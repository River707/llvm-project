//===- TestAliasAnalysis.cpp - Test alias analysis results ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains test passes for constructing and testing alias analysis
// results.
//
//===----------------------------------------------------------------------===//

#include "mlir/Analysis/MemorySSA.h"
#include "mlir/Pass/Pass.h"

using namespace mlir;

namespace {
struct TestMemorySSAPass
    : public PassWrapper<TestMemorySSAPass, OperationPass<>> {
  void runOnOperation() override {
    llvm::errs() << "Testing : ";
    if (Attribute testName = getOperation()->getAttr("test.name"))
      llvm::errs() << testName << "\n";
    else
      llvm::errs() << getOperation()->getAttr("sym_name") << "\n";

    MemorySSA &mssa = getAnalysis<MemorySSA>();
    mssa.print(llvm::errs());
  }
};
} // end anonymous namespace

namespace mlir {
namespace test {
void registerTestMemorySSAPass() {
  PassRegistration<TestMemorySSAPass> pass("test-memoryssa",
                                           "Test MemorySSA analysis results.");
}
} // namespace test
} // namespace mlir
