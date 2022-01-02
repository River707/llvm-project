//===- MemorySSAOps.h - MemorySSA Operations --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the operations for the MemorySSA dialect.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSAOPS_H_
#define MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSAOPS_H_

#include "mlir/Dialect/MemorySSA/IR/MemorySSATypes.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

//===----------------------------------------------------------------------===//
// MemorySSA Dialect Operations
//===----------------------------------------------------------------------===//

#define GET_OP_CLASSES
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOps.h.inc"

#endif // MLIR_DIALECT_MEMORYSSA_IR_MEMORYSSAOPS_H_
