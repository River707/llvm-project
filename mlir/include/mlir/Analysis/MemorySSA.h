//===- MemorySSA.h ----------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_ANALYSIS_MEMORYSSA_H_
#define MLIR_ANALYSIS_MEMORYSSA_H_

#include "mlir/Interfaces/SideEffectInterfaces.h"

namespace mlir {
class OpBuilder;

//===----------------------------------------------------------------------===//
// MemorySSA
//===----------------------------------------------------------------------===//

class MemorySSA {
public:
  MemorySSA(Operation *op);

  /// Print the current state of the MemorySSA analysis.
  void print(raw_ostream &os);

private:
  void buildMemSSAForRegions(OpBuilder &builder,
                             MutableArrayRef<Region> memSSARegions,
                             MutableArrayRef<Region> regions);
  void buildMemSSAForOp(
      OpBuilder &builder, Value &lastMemDef, Operation *op,
      SmallVectorImpl<MemoryEffects::EffectInstance> &memoryEffects);

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

} // end namespace mlir

#endif // MLIR_ANALYSIS_MEMORYSSA_H_
