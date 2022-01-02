//===- MemorySSATypes.td - MemorySSA Types -----------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the MemorySSA dialect types.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSATYPES
#define MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSATYPES

include "mlir/Dialect/MemorySSA/IR/MemorySSADialect.td"

//===----------------------------------------------------------------------===//
// MemorySSA Types
//===----------------------------------------------------------------------===//

class MemorySSA_Type<string name, string typeMnemonic>
    : TypeDef<MemorySSA_Dialect, name> {
  let mnemonic = typeMnemonic;
}

//===----------------------------------------------------------------------===//
// mem_ssa::MemoryDefType
//===----------------------------------------------------------------------===//

def MemorySSA_MemoryDef : MemorySSA_Type<"MemoryDef", "mem_def"> {
  let summary = "This type represents a new memory definition.";
  let description = [{
  }];
}

#endif // MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSATYPES
