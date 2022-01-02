//===- MemorySSA.cpp - MemorySSA Dialect ----------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/MemorySSA/IR/MemorySSA.h"
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOps.h"
#include "mlir/Dialect/MemorySSA/IR/MemorySSATypes.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"
#include "llvm/ADT/StringSwitch.h"
#include <numeric>

using namespace mlir;

//===----------------------------------------------------------------------===//
// MemorySSADialect
//===----------------------------------------------------------------------===//

void mem_ssa::MemorySSADialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOps.cpp.inc"
      >();
  registerTypes();
}

//===----------------------------------------------------------------------===//
// MemorySSA Operations
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// mem_ssa::BranchOp
//===----------------------------------------------------------------------===//

static LogicalResult verify(mem_ssa::BranchOp op) { return success(); }

static ParseResult parseBranchSuccessors(
    OpAsmParser &parser,
    SmallVectorImpl<OpAsmParser::OperandType> &successorOperands,
    SmallVectorImpl<Block *> &successors) {
  do {
    Block *successor;
    OptionalParseResult result = parser.parseOptionalSuccessor(successor);
    if (!result.hasValue()) {
      if (successors.empty())
        return success();
      return parser.emitError(parser.getCurrentLocation(),
                              "expected successor block");
    }
    if (failed(result.getValue()))
      return failure();
    successors.push_back(successor);

    if (succeeded(parser.parseOptionalLParen())) {
      OpAsmParser::OperandType operand;
      if (parser.parseOperand(operand) || parser.parseRParen())
        return failure();
      successorOperands.push_back(operand);
    }
  } while (succeeded(parser.parseOptionalComma()));
  return success();
}

static void printBranchSuccessors(OpAsmPrinter &printer, mem_ssa::BranchOp op,
                                  OperandRange successorOperands,
                                  SuccessorRange successors) {
  auto operandIt = successorOperands.begin();
  llvm::interleaveComma(successors, printer, [&](Block *successor) {
    printer.printSuccessor(successor);
    if (!successor->args_empty())
      printer << "(" << *(operandIt++) << ")";
  });
}

Optional<MutableOperandRange>
mem_ssa::BranchOp::getMutableSuccessorOperands(unsigned index) {
  assert(index < getNumSuccessors() && "invalid successor index");
  SuccessorRange succs = successors();
  unsigned operandStart = std::accumulate(
      succs.begin(), std::next(succs.begin(), index), 0,
      [](unsigned it, Block *succ) { return it + succ->getNumArguments(); });
  return successorOperandsMutable().slice(operandStart,
                                          succs[index]->getNumArguments());
}

//===----------------------------------------------------------------------===//
// mem_ssa::DefOp
//===----------------------------------------------------------------------===//

static LogicalResult verify(mem_ssa::DefOp op) { return success(); }

//===----------------------------------------------------------------------===//
// mem_ssa::ModuleOp
//===----------------------------------------------------------------------===//

static LogicalResult verify(mem_ssa::ModuleOp op) { return success(); }

//===----------------------------------------------------------------------===//
// mem_ssa::UseOp
//===----------------------------------------------------------------------===//

static LogicalResult verify(mem_ssa::UseOp op) { return success(); }

//===----------------------------------------------------------------------===//
// TableGen'd op method definitions
//===----------------------------------------------------------------------===//

#define GET_OP_CLASSES
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOps.cpp.inc"
