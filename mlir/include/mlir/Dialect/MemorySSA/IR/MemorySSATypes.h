//===- MemorySSATypes.h - Pattern Descriptor Language Types -----------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the types for the Pattern Descriptor Language dialect.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSATYPES_H_
#define MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSATYPES_H_

#include "mlir/IR/Types.h"

//===----------------------------------------------------------------------===//
// MemorySSA Dialect Types
//===----------------------------------------------------------------------===//

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOpsTypes.h.inc"

#endif // MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSATYPES_H_
