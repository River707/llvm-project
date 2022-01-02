//===- MemorySSA.cpp - ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Analysis/MemorySSA.h"
#include "mlir/Dialect/MemorySSA/IR/MemorySSA.h"
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOps.h"

using namespace mlir;

//===----------------------------------------------------------------------===//
// MemorySSA
//===----------------------------------------------------------------------===//

MemorySSA::MemorySSA(Operation *op) {
  context.getOrLoadDialect<mem_ssa::MemorySSADialect>();

  /// Build the top-level MemorySSA module for `op`. We don't really care to
  /// model the semantics of the top-level operation, because it is external.
  OpBuilder builder(&context);
  memSSAModule = builder.create<mem_ssa::ModuleOp>(OpaqueLoc::get(op, &context),
                                                   op->getNumRegions());
  buildMemSSAForRegions(builder, memSSAModule->getRegions(), op->getRegions());
}

/// Print the current state of the MemorySSA analysis.
void MemorySSA::print(raw_ostream &os) { memSSAModule->print(os); }

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
      if (block.empty()) {
        builder.create<mem_ssa::YieldOp>(builder.getUnknownLoc());
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
        builder.create<mem_ssa::YieldOp>(builder.getUnknownLoc());
        continue;
      }

      builder.create<mem_ssa::BranchOp>(
          builder.getUnknownLoc(),
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
