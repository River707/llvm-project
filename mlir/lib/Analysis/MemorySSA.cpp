//===- MemorySSA.cpp - ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Analysis/MemorySSA.h"
#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Dialect/MemorySSA/IR/MemorySSA.h"
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOps.h"
#include "mlir/IR/Dominance.h"

using namespace mlir;

namespace {

struct UpwardsMemoryQuery {
  // This is the instruction we were querying about.
  Operation *op = nullptr;

  // The MemoryAccess we actually got called with, used to test local domination
  MemoryAccess originalAccess;

  bool skipSelfAccess = false;

  UpwardsMemoryQuery() = default;
  UpwardsMemoryQuery(Operation *op, MemoryAccess access)
      : op(op), originalAccess(access) {}
};

} // end anonymous namespace

namespace {

struct ClobberAlias {
  bool IsClobber;
  Optional<AliasResult> ar;
};

} // end anonymous namespace

// Return a pair of {IsClobber (bool), AR (AliasResult)}. It relies on AR being
// ignored if IsClobber = false.
static ClobberAlias instructionClobbersQuery(MemoryDef md, Value useLoc,
                                             Operation *useInst,
                                             AliasAnalysis &aa) {
  Operation *defOp = md.getMemoryOp();
  assert(defOp && "Defining operation not actually an operation");

  ModRefResult result = aa.getModRef(defOp, useLoc);
  return {result.isMod(), AliasResult(AliasResult::MayAlias)};
}

//===----------------------------------------------------------------------===//
// ClobberWalker
//===----------------------------------------------------------------------===//

namespace {

/// Our algorithm for walking (and trying to optimize) clobbers, all wrapped up
/// in one class.
class ClobberWalker {
  /// Save a few bytes by using unsigned instead of size_t.
  using ListIndex = unsigned;

  /// Represents a span of contiguous MemoryDefs, potentially ending in a
  /// MemoryPhi.
  struct DefPath {
    Value loc;

    // Note that, because we always walk in reverse, last will always dominate
    // first. Also note that first and last are inclusive.
    MemoryAccess first;
    MemoryAccess last;
    Optional<ListIndex> previous;

    DefPath(Value loc, MemoryAccess first, MemoryAccess last,
            Optional<ListIndex> previous)
        : loc(loc), first(first), last(last), previous(previous) {}

    DefPath(Value loc, MemoryAccess init, Optional<ListIndex> previous)
        : DefPath(loc, init, init, previous) {}
  };

  /// Result of calling walkToPhiOrClobber.
  struct UpwardsWalkResult {
    /// The "Result" of the walk. Either a clobber, the last thing we walked, or
    /// both. Include alias info when clobber found.
    MemoryAccess result;
    bool isKnownClobber;
    Optional<AliasResult> ar;
  };

public:
  ClobberWalker(const MemorySSA &mssa, AliasAnalysis &aa, DominanceInfo &dt)
      : mssa(mssa), aa(aa), dt(dt) {}

  /// Finds the nearest clobber for the given query, optimizing phis if
  /// possible.
  MemoryAccess findClobber(MemoryAccess start, UpwardsMemoryQuery &query,
                           unsigned &depthLimit) {
    assert(depthLimit > 0 && "expected non-zero depth limit");
    MemoryAccess current = start;

    // This walker pretends uses don't exist. If we're handed one, silently grab
    // its def. (This has the nice side-effect of ensuring we never cache uses).
    if (MemoryUse mu = start.dyn_cast<MemoryUse>())
      current = mu.getDefiningAccess();

    DefPath firstDesc(/*query.startingLoc=*/nullptr, current, current, None);
    // Fast path for the overly-common case (no crazy phi optimization
    // necessary)
    UpwardsWalkResult walkResult =
        walkToPhiOrClobber(firstDesc, query, depthLimit);
    MemoryAccess result;
    if (walkResult.isKnownClobber) {
      result = walkResult.result;
      // query.AR = WalkResult.AR;
    } else {
      OptznResult optRes =
          tryOptimizePhi(firstDesc.last.cast<MemoryPhi>(), current,
                         /*Q.startingLoc*/ {}, query, depthLimit);
      // verifyOptResult(optRes);
      // resetPhiOptznState();
      result = optRes.primaryClobber.clobber;
    }

    return result;
  }

  /// Walk to the next Phi or clobber in the def chain starting at Desc.last.
  /// This will update Desc.last as it walks. It will (optionally) also stop at
  /// StopAt.
  ///
  /// This does not test for whether StopAt is a clobber
  UpwardsWalkResult walkToPhiOrClobber(DefPath &desc, UpwardsMemoryQuery &query,
                                       unsigned &depthLimit,
                                       MemoryAccess stopAt = {},
                                       MemoryAccess skipStopAt = {}) const {
    assert(!desc.last.isa<MemoryUse>() && "Uses don't exist in my world");
    bool limitAlreadyReached = false;

    // depthLimit may be 0 here, due to the loop in tryOptimizePhi. Set it to 1.
    // This will not do any alias() calls. It either returns in the first
    // iteration in the loop below, or is set back to 0 if all def chains are
    // free of MemoryDefs.
    if (!depthLimit) {
      depthLimit = 1;
      limitAlreadyReached = true;
    }

    for (MemoryAccess current : def_chain(desc.last)) {
      desc.last = current;
      if (current == stopAt || current == skipStopAt)
        return {current, false, AliasResult(AliasResult::MayAlias)};

      if (auto md = current.dyn_cast<MemoryDef>()) {
        if (md.isLiveOnEntryDef())
          return {md, true, AliasResult(AliasResult::MustAlias)};

        if (--depthLimit == 0)
          return {current, true, AliasResult(AliasResult::MayAlias)};

        ClobberAlias ca = instructionClobbersQuery(md, desc.loc, query.op, aa);
        if (ca.IsClobber)
          return {md, true, ca.ar};
      }
    }

    if (limitAlreadyReached)
      depthLimit = 0;

    assert(desc.last.isa<MemoryPhi>() &&
           "Ended at a non-clobber that's not a phi?");
    return {desc.last, false, AliasResult(AliasResult::MayAlias)};
  }

  /// Find the nearest def or phi that `From` can legally be optimized to.
  const MemoryAccess getWalkTarget(MemoryPhi From) const {
    // assert(From->getNumOperands() && "Phi with no operands?");
    Block *BB = From.getBlock();
    MemoryAccess Result = mssa.getLiveOnEntryDef(BB);
    DominanceInfoNode *node = dt.getNode(BB);
    while ((node = node->getIDom())) {
      // auto *Defs = mssa.getBlockDefs(node->getBlock());
      // if (Defs)
      //   return &*Defs->rbegin();
    }
    return Result;
  }

  void addSearches(MemoryPhi phi, SmallVectorImpl<ListIndex> &pausedSearches,
                   ListIndex priorNode) {
    auto upwardDefsBegin = upward_defs_begin({phi, paths[priorNode].loc}, dt);
    auto upwardDefs = make_range(upwardDefsBegin, upward_defs_end());
    for (const MemoryAccessPair &it : upwardDefs) {
      pausedSearches.push_back(paths.size());
      paths.emplace_back(it.second, it.first, priorNode);
    }
  }

  /// Represents a search that terminated after finding a clobber. This clobber
  /// may or may not be present in the path of defs from LastNode..SearchStart,
  /// since it may have been retrieved from cache.
  struct TerminatedPath {
    MemoryAccess clobber;
    ListIndex LastNode;
  };

  /// Get an access that keeps us from optimizing to the given phi.
  ///
  /// pausedSearches is an array of indices into the paths array. Its incoming
  /// value is the indices of searches that stopped at the last phi optimization
  /// target. It's left in an unspecified state.
  ///
  /// If this returns None, newPaused is a vector of searches that terminated
  /// at stopWhere. Otherwise, newPaused is left in an unspecified state.
  Optional<TerminatedPath>
  getBlockingAccess(MemoryAccess stopWhere,
                    SmallVectorImpl<ListIndex> &pausedSearches,
                    SmallVectorImpl<ListIndex> &newPaused,
                    SmallVectorImpl<TerminatedPath> &terminated,
                    UpwardsMemoryQuery &query, unsigned &depthLimit) {
    assert(!pausedSearches.empty() && "No searches to continue?");

    // BFS vs DFS really doesn't make a difference here, so just do a DFS with
    // pausedSearches as our stack.
    while (!pausedSearches.empty()) {
      ListIndex pathIndex = pausedSearches.pop_back_val();
      DefPath &node = paths[pathIndex];

      // If we've already visited this path with this MemoryLocation, we don't
      // need to do so again.
      //
      // NOTE: That we just drop these paths on the ground makes caching
      // behavior sporadic. e.g. given a diamond:
      //  A
      // B C
      //  D
      //
      // ...If we walk D, B, A, C, we'll only cache the result of phi
      // optimization for A, B, and D; C will be skipped because it dies here.
      // This arguably isn't the worst thing ever, since:
      //   - We generally query things in a top-down order, so if we got below D
      //     without needing cache entries for {C, MemLoc}, then chances are
      //     that those cache entries would end up ultimately unused.
      //   - We still cache things for A, so C only needs to walk up a bit.
      // If this behavior becomes problematic, we can fix without a ton of extra
      // work.
      if (!visitedPhis.insert({node.last, node.loc}).second)
        continue;

      MemoryAccess skipStopWhere;
      if (query.skipSelfAccess && node.loc == /*query.startingLoc=*/nullptr) {
        assert(query.originalAccess.isa<MemoryDef>());
        skipStopWhere = query.originalAccess;
      }

      UpwardsWalkResult res = walkToPhiOrClobber(node, query, depthLimit,
                                                 /*StopAt=*/stopWhere,
                                                 /*SkipStopAt=*/skipStopWhere);
      if (res.isKnownClobber) {
        assert(res.result != stopWhere && res.result != skipStopWhere);

        // If this wasn't a cache hit, we hit a clobber when walking. That's a
        // failure.
        TerminatedPath term{res.result, pathIndex};
        if (!mssa.dominates(res.result, stopWhere))
          return term;

        // Otherwise, it's a valid thing to potentially optimize to.
        terminated.push_back(term);
        continue;
      }

      if (res.result == stopWhere || res.result == skipStopWhere) {
        // We've hit our target. Save this path off for if we want to continue
        // walking. If we are in the mode of skipping the originalAccess, and
        // we've reached back to the originalAccess, do not save path, we've
        // just looped back to self.
        if (res.result != skipStopWhere)
          newPaused.push_back(pathIndex);
        continue;
      }

      assert(!res.result.isLiveOnEntryDef() && "liveOnEntry is a clobber");
      addSearches(res.result.cast<MemoryPhi>(), pausedSearches, pathIndex);
    }

    return None;
  }

  template <typename T, typename Walker>
  struct generic_def_path_iterator
      : public llvm::iterator_facade_base<generic_def_path_iterator<T, Walker>,
                                          std::forward_iterator_tag, T *> {
    generic_def_path_iterator() {}
    generic_def_path_iterator(Walker *W, ListIndex N) : W(W), N(N) {}

    T &operator*() const { return curNode(); }

    generic_def_path_iterator &operator++() {
      N = curNode().previous;
      return *this;
    }

    bool operator==(const generic_def_path_iterator &O) const {
      if (N.hasValue() != O.N.hasValue())
        return false;
      return !N.hasValue() || *N == *O.N;
    }

  private:
    T &curNode() const { return W->paths[*N]; }

    Walker *W = nullptr;
    Optional<ListIndex> N = None;
  };

  using def_path_iterator = generic_def_path_iterator<DefPath, ClobberWalker>;
  using const_def_path_iterator =
      generic_def_path_iterator<const DefPath, const ClobberWalker>;

  iterator_range<def_path_iterator> def_path(ListIndex From) {
    return make_range(def_path_iterator(this, From), def_path_iterator());
  }

  iterator_range<const_def_path_iterator> const_def_path(ListIndex From) const {
    return make_range(const_def_path_iterator(this, From),
                      const_def_path_iterator());
  }

  struct OptznResult {
    /// The path that contains our result.
    TerminatedPath primaryClobber;
    /// The paths that we can legally cache back from, but that aren't
    /// necessarily the result of the Phi optimization.
    SmallVector<TerminatedPath, 4> OtherClobbers;
  };

  ListIndex defPathIndex(const DefPath &N) const {
    // The assert looks nicer if we don't need to do &N
    const DefPath *NP = &N;
    assert(!paths.empty() && NP >= &paths.front() && NP <= &paths.back() &&
           "Out of bounds DefPath!");
    return NP - &paths.front();
  }

  /// Try to optimize a phi as best as we can. Returns a SmallVector of paths
  /// that act as legal clobbers. Note that this won't return *all* clobbers.
  ///
  /// Phi optimization algorithm tl;dr:
  ///   - Find the earliest def/phi, A, we can optimize to
  ///   - Find if all paths from the starting memory access ultimately reach A
  ///     - If not, optimization isn't possible.
  ///     - Otherwise, walk from A to another clobber or phi, A'.
  ///       - If A' is a def, we're done.
  ///       - If A' is a phi, try to optimize it.
  ///
  /// A path is a series of {MemoryAccess, MemoryLocation} pairs. A path
  /// terminates when a MemoryAccess that clobbers said MemoryLocation is found.
  OptznResult tryOptimizePhi(MemoryPhi phi, MemoryAccess start, Value loc,
                             UpwardsMemoryQuery &query, unsigned &depthLimit) {
    assert(paths.empty() && visitedPhis.empty() &&
           "Reset the optimization state.");
    paths.emplace_back(loc, start, phi, llvm::None);

    // Stores how many "valid" optimization nodes we had prior to calling
    // addSearches/getBlockingAccess. Necessary for caching if we had a blocker.
    auto priorPathsSize = paths.size();
    SmallVector<ListIndex, 16> pausedSearches;
    SmallVector<ListIndex, 8> newPaused;
    SmallVector<TerminatedPath, 4> terminatedPaths;

    addSearches(phi, pausedSearches, 0);

    // Moves the TerminatedPath with the "most dominated" clobber to the end of
    // paths.
    auto moveDominatedPathToEnd = [&](SmallVectorImpl<TerminatedPath> &paths) {
      assert(!paths.empty() && "Need a path to move");
      auto Dom = paths.begin();
      for (auto I = std::next(Dom), E = paths.end(); I != E; ++I)
        if (!mssa.dominates(I->clobber, Dom->clobber))
          Dom = I;
      auto last = paths.end() - 1;
      if (last != Dom)
        std::iter_swap(last, Dom);
    };

    MemoryPhi current = phi;
    while (true) {
      assert(!current.isLiveOnEntryDef() &&
             "liveOnEntry wasn't treated as a clobber?");

      MemoryAccess target = getWalkTarget(current);
      // If a TerminatedPath doesn't dominate Target, then it wasn't a legal
      // optimization for the prior phi.
      assert(all_of(terminatedPaths, [&](const TerminatedPath &path) {
        return mssa.dominates(path.clobber, target);
      }));

      // FIXME: This is broken, because the Blocker may be reported to be
      // liveOnEntry, and we'll happily wait for that to disappear (read: never)
      // For the moment, this is fine, since we do nothing with blocker info.
      if (Optional<TerminatedPath> Blocker =
              getBlockingAccess(target, pausedSearches, newPaused,
                                terminatedPaths, query, depthLimit)) {
        // Find the node we started at. We can't search based on N->last, since
        // we may have gone around a loop with a different MemoryLocation.
        auto iter = find_if(def_path(Blocker->LastNode), [&](const DefPath &N) {
          return defPathIndex(N) < priorPathsSize;
        });
        assert(iter != def_path_iterator());

        DefPath &curNode = *iter;
        assert(curNode.last == current);

        // Two things:
        // A. We can't reliably cache all of newPaused back. Consider a case
        //    where we have two paths in newPaused; one of which can't optimize
        //    above this phi, whereas the other can. If we cache the second path
        //    back, we'll end up with suboptimal cache entries. We can handle
        //    cases like this a bit better when we either try to find all
        //    clobbers that block phi optimization, or when our cache starts
        //    supporting unfinished searches.
        // B. We can't reliably cache terminatedPaths back here without doing
        //    extra checks; consider a case like:
        //       T
        //      / \
        //     D   C
        //      \ /
        //       S
        //    Where T is our target, C is a node with a clobber on it, D is a
        //    diamond (with a clobber *only* on the left or right node, N), and
        //    S is our start. Say we walk to D, through the node opposite N
        //    (read: ignoring the clobber), and see a cache entry in the top
        //    node of D. That cache entry gets put into terminatedPaths. We then
        //    walk up to C (N is later in our worklist), find the clobber, and
        //    quit. If we append terminatedPaths to OtherClobbers, we'll cache
        //    the bottom part of D to the cached clobber, ignoring the clobber
        //    in N. Again, this problem goes away if we start tracking all
        //    blockers for a given phi optimization.
        TerminatedPath path{curNode.last, defPathIndex(curNode)};
        return {path, {}};
      }

      // If there's nothing left to search, then all paths led to valid clobbers
      // that we got from our cache; pick the nearest to the start, and allow
      // the rest to be cached back.
      if (newPaused.empty()) {
        moveDominatedPathToEnd(terminatedPaths);
        return {terminatedPaths.pop_back_val(), std::move(terminatedPaths)};
      }

      MemoryAccess defChainEnd;
      SmallVector<TerminatedPath, 4> clobbers;
      for (ListIndex paused : newPaused) {
        UpwardsWalkResult result =
            walkToPhiOrClobber(paths[paused], query, depthLimit);
        if (result.isKnownClobber)
          clobbers.push_back({result.result, paused});
        else
          // Micro-opt: If we hit the end of the chain, save it.
          defChainEnd = result.result;
      }

      if (!terminatedPaths.empty()) {
        // If we couldn't find the dominating phi/liveOnEntry in the above loop,
        // do it now.
        if (!defChainEnd)
          for (MemoryAccess ma : def_chain(target))
            defChainEnd = ma;
        assert(defChainEnd && "Failed to find dominating phi/liveOnEntry");

        // If any of the terminated paths don't dominate the phi we'll try to
        // optimize, we need to figure out what they are and quit.
        Block *ChainBB = defChainEnd.getBlock();
        for (const TerminatedPath &path : terminatedPaths) {
          // Because we know that defChainEnd is as "high" as we can go, we
          // don't need local dominance checks; BB dominance is sufficient.
          if (dt.dominates(ChainBB, path.clobber.getBlock()))
            clobbers.push_back(path);
        }
      }

      // If we have clobbers in the def chain, find the one closest to current
      // and quit.
      if (!clobbers.empty()) {
        moveDominatedPathToEnd(clobbers);
        TerminatedPath Result = clobbers.pop_back_val();
        return {Result, std::move(clobbers)};
      }

      assert(all_of(newPaused,
                    [&](ListIndex I) { return paths[I].last == defChainEnd; }));

      // Because liveOnEntry is a clobber, this must be a phi.
      MemoryPhi defChainPhi = defChainEnd.cast<MemoryPhi>();

      priorPathsSize = paths.size();
      pausedSearches.clear();
      for (ListIndex I : newPaused)
        addSearches(defChainPhi, pausedSearches, I);
      newPaused.clear();

      current = defChainPhi;
    }
  }

  void verifyOptResult(const OptznResult &R) const {
    assert(all_of(R.OtherClobbers, [&](const TerminatedPath &P) {
      return mssa.dominates(P.clobber, R.primaryClobber.clobber);
    }));
  }

  void resetPhiOptznState() {
    paths.clear();
    visitedPhis.clear();
  }

  const MemorySSA &mssa;
  AliasAnalysis &aa;
  DominanceInfo &dt;

  // Phi optimization bookkeeping:
  // List of DefPath to process during the current phi optimization walk.
  SmallVector<DefPath, 32> paths;
  // List of visited <Access, Location> pairs; we can skip paths already
  // visited with the same memory location.
  DenseSet<MemoryAccessPair> visitedPhis;
};
} // namespace

//===----------------------------------------------------------------------===//
// ClobberWalkerBase
//===----------------------------------------------------------------------===//

namespace {
class ClobberWalkerBase {
public:
  ClobberWalkerBase(MemorySSA &mssa, AliasAnalysis &aa, DominanceInfo &dt)
      : walker(mssa, aa, dt), mssa(mssa) {}

  /// Walk the use-def chains starting at \p startingAccess and find
  /// the MemoryAccess that actually clobbers loc.
  ///
  /// \returns our clobbering memory access
  MemoryAccess getClobberingMemoryAccessBase(MemoryAccess startingAccess,
                                             Operation *op,
                                             unsigned &depthLimit) {
    assert(!startingAccess.isa<MemoryUse>() && "Use cannot be defining access");

    if (startingAccess.isLiveOnEntryDef())
      return startingAccess;

    // Unlike the other function, do not walk to the def of a def, because we
    // are handed something we already believe is the clobbering access. We
    // never set UpwardsMemoryQuery::skipSelf to true in this method.
    UpwardsMemoryQuery query(op, startingAccess);
    return walker.findClobber(startingAccess, query, depthLimit);
  }

  MemoryAccess getClobberingMemoryAccessBase(MemoryAccess ma,
                                             unsigned &depthLimit,
                                             bool skipSelf) {
    MemoryUseOrDef startingAccess = ma.dyn_cast<MemoryUseOrDef>();

    // If this is a MemoryPhi, we can't do anything.
    if (!startingAccess)
      return ma;

    // If this is an already optimized use or def, return the optimized result.
    // Note: Currently, we store the optimized def result in a separate field,
    // since we can't use the defining access.
    bool isOptimized = false;
    // if (startingAccess->isOptimized()) {
    //   if (!skipSelf || !isa<MemoryDef>(startingAccess))
    //     return startingAccess->getOptimized();
    //   isOptimized = true;
    // }

    UpwardsMemoryQuery query(startingAccess.getMemoryOp(), startingAccess);

    MemoryAccess optimizedAccess;
    if (!isOptimized) {
      // Start with the thing we already think clobbers this location
      MemoryAccess definingAccess = startingAccess.getDefiningAccess();

      // At this point, DefiningAccess may be the live on entry def.
      // If it is, we will not get a better result.
      if (definingAccess.isLiveOnEntryDef()) {
        // startingAccess->setOptimized(definingAccess);
        // startingAccess->setOptimizedAccessType(None);
        return definingAccess;
      }

      optimizedAccess = walker.findClobber(definingAccess, query, depthLimit);
      // startingAccess->setOptimized(optimizedAccess);
      // if (mssa->isLiveOnEntryDef(optimizedAccess))
      //   startingAccess->setOptimizedAccessType(None);
      // else if (query.AR && *query.AR == AliasResult::MustAlias)
      //   startingAccess->setOptimizedAccessType(
      //       AliasResult(AliasResult::MustAlias));
    } else {
      // optimizedAccess = startingAccess.getOptimized();
    }

    // LLVM_DEBUG(dbgs() << "Starting Memory SSA clobber for " << *I << " is ");
    // LLVM_DEBUG(dbgs() << *startingAccess << "\n");
    // LLVM_DEBUG(dbgs() << "Optimized Memory SSA clobber for " << *I << " is
    // "); LLVM_DEBUG(dbgs() << *optimizedAccess << "\n");

    MemoryAccess result;
    if (skipSelf && optimizedAccess.isa<MemoryPhi>() &&
        startingAccess.isa<MemoryDef>() && depthLimit) {
      assert(query.originalAccess.isa<MemoryDef>());
      query.skipSelfAccess = true;
      result = walker.findClobber(optimizedAccess, query, depthLimit);
    } else {
      result = optimizedAccess;
    }

    // LLVM_DEBUG(dbgs() << "Result Memory SSA clobber [SkipSelf = " <<
    // SkipSelf);

    // LLVM_DEBUG(dbgs() << "] for " << *I << " is " << result << "\n");

    return result;
  }

private:
  ClobberWalker walker;
  MemorySSA &mssa;
};
} // namespace

//===----------------------------------------------------------------------===//
// MemoryAccess
//===----------------------------------------------------------------------===//

Block *MemoryAccess::getBlock() const {
  // The MLIR block is stored in an opaque location within the terminator
  // operation of the memory ssa block.
  Block *memSSABlock;
  if (BlockArgument memssaArg = accessOpOrArg.dyn_cast<BlockArgument>())
    memSSABlock = memssaArg.getOwner();
  else
    memSSABlock = getMemSSAOp()->getBlock();
  Operation *termOp = memSSABlock->getTerminator();
  return termOp->getLoc().cast<OpaqueLoc>().getUnderlyingLocation<Block *>();
}

bool MemoryAccess::isLiveOnEntryDef() const {
  BlockArgument memssaArg = accessOpOrArg.dyn_cast<BlockArgument>();
  return memssaArg && memssaArg.getOwner()->isEntryBlock();
}

bool MemoryAccess::isBeforeInBlock(MemoryAccess other) const {
  assert(*this && other && getBlock() == other.getBlock());
  if (isa<MemoryPhi>())
    return true;
  if (other.isa<MemoryPhi>())
    return false;
  return getMemSSAOp()->isBeforeInBlock(other.getMemSSAOp());
}

bool MemoryAccess::isMemoryUse() const {
  return isa_and_nonnull<mem_ssa::UseOp>(accessOpOrArg.dyn_cast<Operation *>());
}

bool MemoryAccess::isMemoryDef() const {
  return isa_and_nonnull<mem_ssa::DefOp>(accessOpOrArg.dyn_cast<Operation *>());
}

//===----------------------------------------------------------------------===//
// MemorySSA
//===----------------------------------------------------------------------===//

MemorySSA::MemorySSA(Operation *op, AnalysisManager &am)
    : dinfo(am.getAnalysis<DominanceInfo>()) {
  context.getOrLoadDialect<mem_ssa::MemorySSADialect>();

  /// Build the top-level MemorySSA module for `op`. We don't really care to
  /// model the semantics of the top-level operation, because it is external.
  OpBuilder builder(&context);
  memSSAModule = builder.create<mem_ssa::ModuleOp>(OpaqueLoc::get(op, &context),
                                                   op->getNumRegions());
  buildMemSSAForRegions(builder, memSSAModule->getRegions(), op->getRegions());
}

bool MemorySSA::isInvalidated(const AnalysisManager::PreservedAnalyses &pa) {
  return !pa.isPreserved<MemorySSA>() || !pa.isPreserved<DominanceInfo>();
}

void MemorySSA::print(raw_ostream &os) const { memSSAModule->print(os); }

bool MemorySSA::dominates(MemoryAccess dominator,
                          MemoryAccess dominatee) const {
  if (dominator == dominatee)
    return true;
  if (dominatee.isLiveOnEntryDef())
    return false;

  if (dominator.getBlock() != dominatee.getBlock())
    return dinfo.dominates(dominator.getBlock(), dominatee.getBlock());
  return dominator.isBeforeInBlock(dominatee);
}

void MemorySSA::buildMemSSAForRegions(OpBuilder &builder,
                                      MutableArrayRef<Region> memSSARegions,
                                      MutableArrayRef<Region> regions) {
  SmallVector<MemoryEffects::EffectInstance> memoryEffects;
  for (auto it : llvm::zip(memSSARegions, regions)) {
    Region &memSSARegion = std::get<0>(it), &region = std::get<1>(it);
    if (region.empty())
      continue;

    // As a first pass, create a matching MemorySSA block for each block in the
    // region.
    for (Block &block : region)
      blockToMSSABlock.try_emplace(&block, builder.createBlock(&memSSARegion));

    // In a second pass, create the actual MemorySSA operations.
    for (auto blockIt : llvm::zip(memSSARegion, region)) {
      Block &memSSABlock = std::get<0>(blockIt), &block = std::get<1>(blockIt);
      builder.setInsertionPointToStart(&memSSABlock);

      Location termLoc = OpaqueLoc::get(&block, builder.getContext());
      if (block.empty()) {
        builder.create<mem_ssa::YieldOp>(termLoc);
        continue;
      }

      // Each block has an argument for the last memory definition.
      Value lastMemDef =
          memSSABlock.addArgument(builder.getType<mem_ssa::MemoryDefType>());
      for (Operation &op : block)
        buildMemSSAForOp(builder, lastMemDef, &op, memoryEffects);

      // Create a branch to the successors of this block.
      Operation *terminator = &block.back();
      if (terminator->getNumSuccessors() == 0) {
        builder.create<mem_ssa::YieldOp>(termLoc);
        continue;
      }

      builder.create<mem_ssa::BranchOp>(
          termLoc,
          SmallVector<Value>(terminator->getNumSuccessors(), lastMemDef),
          llvm::to_vector<8>(llvm::map_range(
              terminator->getSuccessors(),
              [&](Block *successor) { return blockToMSSABlock[successor]; })));
    }
  }
}

void MemorySSA::buildMemSSAForOp(
    OpBuilder &builder, Value &lastMemDef, Operation *op,
    SmallVectorImpl<MemoryEffects::EffectInstance> &memoryEffects) {
  Operation *memSSAOp = nullptr;
  if (auto effectOp = dyn_cast<MemoryEffectOpInterface>(op)) {
    memoryEffects.clear();
    effectOp.getEffects(memoryEffects);
    bool isRead = false, isWrite = false;
    for (const MemoryEffects::EffectInstance &effect : memoryEffects) {
      if (isa<MemoryEffects::Read>(effect.getEffect()))
        isRead = true;
      else if (isa<MemoryEffects::Write>(effect.getEffect()))
        isWrite = true;
    }
    if (!isWrite && !isRead)
      return;
    if (isWrite) {
      mem_ssa::DefOp def = builder.create<mem_ssa::DefOp>(
          OpaqueLoc::get(op, builder.getContext()),
          builder.getType<mem_ssa::MemoryDefType>(), lastMemDef, Value(),
          op->getNumRegions());
      lastMemDef = def;
      memSSAOp = def;
    } else {
      memSSAOp = builder.create<mem_ssa::UseOp>(
          OpaqueLoc::get(op, builder.getContext()), lastMemDef,
          op->getNumRegions());
    }
  } else {
    mem_ssa::DefOp def = builder.create<mem_ssa::DefOp>(
        OpaqueLoc::get(op, builder.getContext()),
        builder.getType<mem_ssa::MemoryDefType>(), lastMemDef, Value(),
        op->getNumRegions());
    lastMemDef = def;
    memSSAOp = def;
  }

  // Build Memory SSA operations for any nested memory operations.
  if (op->getNumRegions()) {
    OpBuilder::InsertionGuard insertGuard(builder);
    buildMemSSAForRegions(builder, memSSAOp->getRegions(), op->getRegions());
  }
  opToMSSOp.try_emplace(op, memSSAOp);
}
