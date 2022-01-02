//===- MemorySSATypes.cpp - MemorySSA Types -------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/MemorySSA/IR/MemorySSATypes.h"
#include "mlir/Dialect/MemorySSA/IR/MemorySSA.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::mem_ssa;

//===----------------------------------------------------------------------===//
// TableGen'd type method definitions
//===----------------------------------------------------------------------===//

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOpsTypes.cpp.inc"

//===----------------------------------------------------------------------===//
// MemorySSADialect
//===----------------------------------------------------------------------===//

void MemorySSADialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/MemorySSA/IR/MemorySSAOpsTypes.cpp.inc"
      >();
}

static Type parseMemorySSAType(DialectAsmParser &parser) {
  StringRef typeTag;
  if (parser.parseKeyword(&typeTag))
    return Type();
  {
    Type genType;
    auto parseResult = generatedTypeParser(parser.getBuilder().getContext(),
                                           parser, typeTag, genType);
    if (parseResult.hasValue())
      return genType;
  }

  parser.emitError(parser.getNameLoc(), "invalid 'mem_ssa' type: `")
      << typeTag << "'";
  return Type();
}

Type MemorySSADialect::parseType(DialectAsmParser &parser) const {
  return parseMemorySSAType(parser);
}

void MemorySSADialect::printType(Type type, DialectAsmPrinter &printer) const {
  if (failed(generatedTypePrinter(type, printer)))
    llvm_unreachable("unknown 'mem_ssa' type");
}
