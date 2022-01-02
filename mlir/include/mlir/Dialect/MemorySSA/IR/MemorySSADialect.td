//===- MemorySSADialect.td - MemorySSA dialect definition --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Defines the MLIR MemorySSA dialect.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSADIALECT
#define MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSADIALECT

include "mlir/IR/OpBase.td"

//===----------------------------------------------------------------------===//
// MemorySSA Dialect
//===----------------------------------------------------------------------===//

def MemorySSA_Dialect : Dialect {
  string summary = "<TODO>";
  string description = [{
    <TODO>
  }];

  let name = "mem_ssa";
  let cppNamespace = "::mlir::mem_ssa";
  let extraClassDeclaration = [{
    void registerTypes();
  }];
}

#endif // MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSADIALECT
