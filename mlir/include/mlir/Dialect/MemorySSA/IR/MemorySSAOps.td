//===- MemorySSAOps.td - MemorySSA Operations --------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the MemorySSA dialect operations.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSAOPS
#define MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSAOPS

include "mlir/Dialect/MemorySSA/IR/MemorySSATypes.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

//===----------------------------------------------------------------------===//
// MemorySSA Ops
//===----------------------------------------------------------------------===//

class MemorySSA_Op<string mnemonic, list<OpTrait> traits = []>
    : Op<MemorySSA_Dialect, mnemonic, traits> {
  let printer = [{ ::print(p, *this); }];
  let parser = [{ return ::parse$cppClass(parser, result); }];
  let verifier = [{ return ::verify(*this); }];
}

//===----------------------------------------------------------------------===//
// mem_ssa::BranchOp
//===----------------------------------------------------------------------===//

def MemorySSA_BranchOp : MemorySSA_Op<"branch", [
    DeclareOpInterfaceMethods<BranchOpInterface>,
    NoSideEffect, Terminator
  ]> {
  let arguments = (ins Variadic<MemorySSA_MemoryDef>:$successorOperands);
  let successors = (successor VariadicSuccessor<AnySuccessor>:$successors);
  let assemblyFormat = [{
    custom<BranchSuccessors>($successorOperands, $successors) attr-dict
  }];
}

//===----------------------------------------------------------------------===//
// mem_ssa::DefOp
//===----------------------------------------------------------------------===//

def MemorySSA_DefOp : MemorySSA_Op<"def", [IsolatedFromAbove]> {
  let arguments = (ins MemorySSA_MemoryDef:$parentDef,
                       Optional<MemorySSA_MemoryDef>:$clobber);
  let results = (outs MemorySSA_MemoryDef:$result);
  let regions = (region VariadicRegion<AnyRegion>:$regions);
  let assemblyFormat = [{
    `parent` `(` $parentDef `)` (`clobber` `(` $clobber^ `)`)? $regions
    attr-dict
  }];
}

//===----------------------------------------------------------------------===//
// mem_ssa::ModuleOp
//===----------------------------------------------------------------------===//

def MemorySSA_ModuleOp : MemorySSA_Op<"module", [IsolatedFromAbove]> {
  let regions = (region VariadicRegion<AnyRegion>:$regions);
  let assemblyFormat = [{
    attr-dict-with-keyword $regions
  }];
}

//===----------------------------------------------------------------------===//
// mem_ssa::UseOp
//===----------------------------------------------------------------------===//

def MemorySSA_UseOp : MemorySSA_Op<"use", [IsolatedFromAbove]> {
  let arguments = (ins MemorySSA_MemoryDef:$definingAccess);
  let regions = (region VariadicRegion<AnyRegion>:$regions);
  let assemblyFormat = "`of` $definingAccess $regions attr-dict";
}

//===----------------------------------------------------------------------===//
// mem_ssa::YieldOp
//===----------------------------------------------------------------------===//

def MemorySSA_YieldOp
    : MemorySSA_Op<"yield", [ParentOneOf<["DefOp", "UseOp"]>, Terminator]> {
  let assemblyFormat = "attr-dict";
  let verifier = ?;
}

#endif // MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSAOPS
