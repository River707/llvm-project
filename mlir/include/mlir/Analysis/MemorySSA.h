//===- MemorySSA.h ----------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_ANALYSIS_MEMORYSSA_H_
#define MLIR_ANALYSIS_MEMORYSSA_H_

#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Pass/AnalysisManager.h"

namespace mlir {
class AnalysisManager;
class DominanceInfo;
class OpBuilder;
class memoryaccess_def_iterator;

//===----------------------------------------------------------------------===//
// MemoryAccess
//===----------------------------------------------------------------------===//

class MemoryAccess {
  using ImplType = PointerUnion<Operation *, BlockArgument>;

public:
  MemoryAccess(nullptr_t = nullptr) {}
  MemoryAccess(const MemoryAccess &) = default;
  MemoryAccess &operator=(const MemoryAccess &) = default;

  explicit operator bool() const { return !accessOpOrArg.isNull(); }
  bool operator==(MemoryAccess other) const {
    return accessOpOrArg == other.accessOpOrArg;
  }
  bool operator!=(MemoryAccess other) const { return !(*this == other); }

  template <typename U> bool isa() const {
    assert(accessOpOrArg && "isa<> used on a null attribute.");
    return U::classof(*this);
  }
  template <typename First, typename Second, typename... Rest>
  bool isa() const {
    return isa<First>() || isa<Second, Rest...>();
  }
  template <typename U> U dyn_cast() const {
    return isa<U>() ? U(accessOpOrArg) : U();
  }
  template <typename U> U dyn_cast_or_null() const {
    return (accessOpOrArg && isa<U>()) ? U(accessOpOrArg) : U();
  }
  template <typename U> U cast() const {
    assert(isa<U>());
    return U(accessOpOrArg);
  }

  /// Returns the block this access is defined in.
  Block *getBlock() const;

  /// Returns true if this access is the live-memory on entry access.
  bool isLiveOnEntryDef() const;

  /// Returns true if the access is in the same block as `other` and comes
  /// before it.
  bool isBeforeInBlock(MemoryAccess other) const;

  /// Returns true if the access if a memory use.
  bool isMemoryUse() const;

  /// Returns true if the access if a memory definition.
  bool isMemoryDef() const;

  /// Returns true if the access if a memory use or definition.
  bool isMemoryUseOrDef() const { return accessOpOrArg.is<Operation *>(); }

  /// Returns true if the access if a memory phi.
  bool isMemoryPHI() const { return accessOpOrArg.is<BlockArgument>(); }

  /// This iterator walks over all of the defs in a given
  /// MemoryAccess. For MemoryPhi nodes, this walks arguments. For
  /// MemoryUse/MemoryDef, this walks the defining access.
  memoryaccess_def_iterator defs_begin() const;
  memoryaccess_def_iterator defs_end() const;

  /// Methods for supporting PointerLikeTypeTraits.
  void *getAsOpaquePointer() const { return accessOpOrArg.getOpaqueValue(); }
  static MemoryAccess getFromOpaquePointer(void *pointer) {
    return ImplType::getFromOpaqueValue(pointer);
  }

protected:
  /// Construct a memory access.
  MemoryAccess(ImplType impl) : accessOpOrArg(impl) {}
  MemoryAccess(Value accessValue);

  /// Return the underlying MemorySSA operation, this is the operation in the
  /// mem_ssa dialect representing this access. Asserts that the access is a
  /// use or def.
  Operation *getMemSSAOp() const { return accessOpOrArg.get<Operation *>(); }

  /// Return the underlying MemorySSA block argument, this is an argument in the
  /// mem_ssa dialect representing a MemoryPHI. Asserts that the access is a
  /// block argument.
  BlockArgument getMemSSAArg() const {
    return accessOpOrArg.get<BlockArgument>();
  }

  /// Either the memory access operation or block argument.
  PointerUnion<Operation *, BlockArgument> accessOpOrArg;

  /// Allow access to the constructor.
  friend class MemorySSA;
  friend class MemoryUseOrDef;
};

/// Class that has the common methods + fields of memory uses/defs. It's
/// a little awkward to have, but there are many cases where we want either a
/// use or def, and there are many cases where uses are needed (defs aren't
/// acceptable), and vice-versa.
///
/// This class should never be instantiated directly; make a MemoryUse or
/// MemoryDef instead.
class MemoryUseOrDef : public MemoryAccess {
public:
  using MemoryAccess::MemoryAccess;

  /// Returns the operation that this MemoryUseOrDef represents.
  Operation *getMemoryOp() const {
    // The parent operation is stored as part of the location on the mem_ssa
    // operation.
    return getMemSSAOp()
        ->getLoc()
        .cast<OpaqueLoc>()
        .getUnderlyingLocation<Operation *>();
  }

  /// Get the access that produces the memory state used by this Use.
  MemoryAccess getDefiningAccess() const {
    return MemoryAccess(getMemSSAOp()->getOperand(0));
  }

  static bool classof(MemoryAccess ma) { return ma.isMemoryUseOrDef(); }
};

/// Represents read-only accesses to memory
///
/// In particular, the set of Instructions that will be represented by
/// MemoryUse's is exactly the set of Instructions for which
/// AliasAnalysis::getModRefInfo returns "Ref".
class MemoryUse final : public MemoryUseOrDef {
public:
  using MemoryUseOrDef::MemoryUseOrDef;

  static bool classof(MemoryAccess ma) { return ma.isMemoryUse(); }

private:
  friend class MemorySSA;
};

/// Represents a read-write access to memory, whether it is a must-alias,
/// or a may-alias.
///
/// In particular, the set of Instructions that will be represented by
/// MemoryDef's is exactly the set of Instructions for which
/// AliasAnalysis::getModRefInfo returns "Mod" or "ModRef".
/// Note that, in order to provide def-def chains, all defs also have a use
/// associated with them. This use points to the nearest reaching
/// MemoryDef/MemoryPhi.
class MemoryDef final : public MemoryUseOrDef {
public:
  using MemoryUseOrDef::MemoryUseOrDef;

  static bool classof(MemoryAccess ma) { return ma.isMemoryDef(); }

private:
  friend class MemorySSA;
};

/// Represents phi nodes for memory accesses.
///
/// These have the same semantic as regular phi nodes, with the exception that
/// only one phi will ever exist in a given basic block.
/// Guaranteeing one phi per block means guaranteeing there is only ever one
/// valid reaching MemoryDef/MemoryPHI along each path to the phi node.
/// This is ensured by not allowing disambiguation of the RHS of a MemoryDef or
/// a MemoryPhi's operands.
/// That is, given
/// if (a) {
///   store %a
///   store %b
/// }
/// it *must* be transformed into
/// if (a) {
///    1 = MemoryDef(liveOnEntry)
///    store %a
///    2 = MemoryDef(1)
///    store %b
/// }
/// and *not*
/// if (a) {
///    1 = MemoryDef(liveOnEntry)
///    store %a
///    2 = MemoryDef(liveOnEntry)
///    store %b
/// }
/// even if the two stores do not conflict. Otherwise, both 1 and 2 reach the
/// end of the branch, and if there are not two phi nodes, one will be
/// disconnected completely from the SSA graph below that point.
/// Because MemoryUse's do not generate new definitions, they do not have this
/// issue.
class MemoryPhi final : public MemoryAccess {
public:
  using MemoryAccess::MemoryAccess;

  static bool classof(MemoryAccess ma) { return ma.isMemoryPHI(); }

  unsigned getNumIncomingValues() const { return 0; }

protected:
  friend class MemorySSA;
};

//===----------------------------------------------------------------------===//
// MemorySSA
//===----------------------------------------------------------------------===//

class MemorySSA {
public:
  MemorySSA(Operation *op, AnalysisManager &am);

  /// Returns true if this analysis was truly invalidated or not.
  bool isInvalidated(const AnalysisManager::PreservedAnalyses &pa);

  /// Given two memory accesses in potentially different blocks, determine
  /// whether `dominator` dominates `dominatee`.
  bool dominates(MemoryAccess dominator, MemoryAccess dominatee) const;

  /// Return the memory-live on entry access for the given block.
  MemoryAccess getLiveOnEntryDef(Block *block) const {
    auto it = blockToMSSABlock.find(block);
    assert(it != blockToMSSABlock.end() && "expected a valid block mapping");
    return it->second->getArgument(0);
  }

  /// Print the current state of the MemorySSA analysis.
  void print(raw_ostream &os) const;

private:
  void buildMemSSAForRegions(OpBuilder &builder,
                             MutableArrayRef<Region> memSSARegions,
                             MutableArrayRef<Region> regions);
  void buildMemSSAForOp(
      OpBuilder &builder, Value &lastMemDef, Operation *op,
      SmallVectorImpl<MemoryEffects::EffectInstance> &memoryEffects);

  /// Dominance information for the input IR.
  DominanceInfo &dinfo;

  /// An MLIRContext used for creating the MemorySSA IR. Using a separate has
  /// several benefits:
  ///   * Can disable multi-threading during construction
  ///   * Avoid leaking memory of MemorySSA constructs
  ///   * Users don't need to configure MemorySSA in their dialect registry, as
  ///     we only need to load it in the new dialect.
  /// It also has downsides:
  ///   * Need to reconfigure the context every time we construct the analysis.
  /// The exact trade off here is something that can/should be tracked, but
  /// switching from one to the other is somewhat "trivial" and mostly non-user
  /// facing.
  MLIRContext context;

  /// The top-level MemorySSA operation.
  Operation *memSSAModule;

  /// A mapping from input block to the corresponding block in the MemorySSA
  /// module.
  DenseMap<Block *, Block *> blockToMSSABlock;

  /// A mapping from an input memory operation to its corresponding MemorySSA
  /// operation.
  DenseMap<Operation *, Operation *> opToMSSOp;
};

//===----------------------------------------------------------------------===//
// Def Chain Iteration
//===----------------------------------------------------------------------===//

using MemoryAccessPair = std::pair<MemoryAccess, Value>;

/// Iterator base class used to implement const and non-const iterators
/// over the defining accesses of a MemoryAccess.
class memoryaccess_def_iterator
    : public llvm::iterator_facade_base<memoryaccess_def_iterator,
                                        std::forward_iterator_tag, MemoryAccess,
                                        ptrdiff_t, MemoryAccess, MemoryAccess> {
  using BaseT = typename memoryaccess_def_iterator::iterator_facade_base;

public:
  memoryaccess_def_iterator(MemoryAccess start) : access(start) {}
  memoryaccess_def_iterator() = default;

  bool operator==(const memoryaccess_def_iterator &other) const {
    return access == other.access && (!access || argNo == other.argNo);
  }

  typename std::iterator_traits<BaseT>::pointer operator*() const {
    assert(access && "Tried to access past the end of our iterator");
    // Go to the first argument for phis, and the defining access for everything
    // else.
    // if (const MemoryPhi *MP = dyn_cast<MemoryPhi>(access))
    //  return MP->getIncomingValue(argNo);
    return access.cast<MemoryUseOrDef>().getDefiningAccess();
  }

  using BaseT::operator++;
  memoryaccess_def_iterator &operator++() {
    assert(access && "Hit end of iterator");
    if (const MemoryPhi MP = access.dyn_cast<MemoryPhi>()) {
      if (++argNo >= MP.getNumIncomingValues()) {
        argNo = 0;
        access = {};
      }
    } else {
      access = {};
    }
    return *this;
  }

  Block *getPhiArgBlock() const { return nullptr; }

private:
  MemoryAccess access;
  unsigned argNo = 0;
};

// inline memoryaccess_def_iterator MemoryAccess::defs_begin() {
//   return memoryaccess_def_iterator(this);
// }

// inline memoryaccess_def_iterator MemoryAccess::defs_end() {
//   return memoryaccess_def_iterator();
// }

/// Provide an iterator that walks defs, giving both the memory access,
/// and the current pointer location, updating the pointer location as it
/// changes due to phi node translation.
///
/// This iterator, while somewhat specialized, is what most clients actually
/// want when walking upwards through MemorySSA def chains. It takes a pair of
/// <MemoryAccess,MemoryLocation>, and walks defs, properly translating the
/// memory location through phi nodes for the user.
class upward_defs_iterator
    : public llvm::iterator_facade_base<
          upward_defs_iterator, std::forward_iterator_tag, MemoryAccessPair> {
  using BaseT = upward_defs_iterator::iterator_facade_base;

public:
  upward_defs_iterator(const MemoryAccessPair &Info, DominanceInfo *DT)
      : DefIterator(Info.first), Location(Info.second),
        OriginalAccess(Info.first), DT(DT) {
    CurrentPair.first = nullptr;

    WalkingPhi = Info.first && Info.first.isa<MemoryPhi>();
    fillInCurrentPair();
  }

  upward_defs_iterator() { CurrentPair.first = nullptr; }

  bool operator==(const upward_defs_iterator &Other) const {
    return DefIterator == Other.DefIterator;
  }

  typename std::iterator_traits<BaseT>::reference operator*() const {
    assert(DefIterator != OriginalAccess.defs_end() &&
           "Tried to access past the end of our iterator");
    return CurrentPair;
  }

  using BaseT::operator++;
  upward_defs_iterator &operator++() {
    assert(DefIterator != OriginalAccess.defs_end() &&
           "Tried to access past the end of the iterator");
    ++DefIterator;
    if (DefIterator != OriginalAccess.defs_end())
      fillInCurrentPair();
    return *this;
  }

  Block *getPhiArgBlock() const { return DefIterator.getPhiArgBlock(); }

private:
  /// Returns true if \p Ptr is guaranteed to be loop invariant for any possible
  /// loop. In particular, this guarantees that it only references a single
  /// MemoryLocation during execution of the containing function.
  bool IsGuaranteedLoopInvariant(Value *Ptr) const;

  void fillInCurrentPair() {
    CurrentPair.first = *DefIterator;
    CurrentPair.second = Location;
  }

  mutable MemoryAccessPair CurrentPair;
  memoryaccess_def_iterator DefIterator;
  Value Location;
  MemoryAccess OriginalAccess;
  DominanceInfo *DT = nullptr;
  bool WalkingPhi = false;
};

inline upward_defs_iterator upward_defs_begin(const MemoryAccessPair &pair,
                                              DominanceInfo &dt) {
  return upward_defs_iterator(pair, &dt);
}

inline upward_defs_iterator upward_defs_end() { return upward_defs_iterator(); }

inline iterator_range<upward_defs_iterator>
upward_defs(const MemoryAccessPair &pair, DominanceInfo &dt) {
  return make_range(upward_defs_begin(pair, dt), upward_defs_end());
}

//===----------------------------------------------------------------------===//
// Def Chain Iteration
//===----------------------------------------------------------------------===//

/// Walks the defining accesses of MemoryDefs. Stops after we hit something that
/// has no defining use (e.g. a MemoryPhi or liveOnEntry). Note that, when
/// comparing against a null def_chain_iterator, this will compare equal only
/// after walking said Phi/liveOnEntry.
///
/// The UseOptimizedChain flag specifies whether to walk the clobbering
/// access chain, or all the accesses.
///
/// Normally, MemoryDef are all just def/use linked together, so a def_chain on
/// a MemoryDef will walk all MemoryDefs above it in the program until it hits
/// a phi node.  The optimized chain walks the clobbering access of a store.
/// So if you are just trying to find, given a store, what the next
/// thing that would clobber the same memory is, you want the optimized chain.
template <class T, bool UseOptimizedChain = false>
struct def_chain_iterator : public llvm::iterator_facade_base<
                                def_chain_iterator<T, UseOptimizedChain>,
                                std::forward_iterator_tag, MemoryAccess> {
  def_chain_iterator() : ma(nullptr) {}
  def_chain_iterator(T ma) : ma(ma) {}

  T operator*() const { return ma; }

  def_chain_iterator &operator++() {
    // N.B. liveOnEntry has a null defining access.
    if (MemoryUseOrDef mud = ma.template dyn_cast<MemoryUseOrDef>()) {
      // if (UseOptimizedChain && mud->isOptimized())
      //   ma = mud->getOptimized();
      // else
      ma = mud.getDefiningAccess();
    } else {
      ma = nullptr;
    }

    return *this;
  }

  bool operator==(const def_chain_iterator &rhs) const { return ma == rhs.ma; }

private:
  T ma;
};

template <class T>
inline iterator_range<def_chain_iterator<T>>
def_chain(T ma, MemoryAccess upTo = nullptr) {
#ifdef EXPENSIVE_CHECKS
  assert((!UpTo || find(def_chain(MA), UpTo) != def_chain_iterator<T>()) &&
         "UpTo isn't in the def chain!");
#endif
  return make_range(def_chain_iterator<T>(ma), def_chain_iterator<T>(upTo));
}

template <class T>
inline iterator_range<def_chain_iterator<T, true>> optimized_def_chain(T ma) {
  return make_range(def_chain_iterator<T, true>(ma),
                    def_chain_iterator<T, true>(nullptr));
}

} // end namespace mlir

namespace llvm {
template <> struct DenseMapInfo<mlir::MemoryAccess> {
  static mlir::MemoryAccess getEmptyKey() {
    void *pointer = llvm::DenseMapInfo<void *>::getEmptyKey();
    return mlir::MemoryAccess::getFromOpaquePointer(pointer);
  }
  static mlir::MemoryAccess getTombstoneKey() {
    void *pointer = llvm::DenseMapInfo<void *>::getTombstoneKey();
    return mlir::MemoryAccess::getFromOpaquePointer(pointer);
  }
  static unsigned getHashValue(mlir::MemoryAccess val) {
    return llvm::DenseMapInfo<void *>::getHashValue(val.getAsOpaquePointer());
  }
  static bool isEqual(mlir::MemoryAccess lhs, mlir::MemoryAccess rhs) {
    return lhs == rhs;
  }
};
} // namespace llvm

#endif // MLIR_ANALYSIS_MEMORYSSA_H_
