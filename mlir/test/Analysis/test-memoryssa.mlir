// RUN: mlir-opt %s -pass-pipeline='func(test-memoryssa)' -split-input-file -allow-unregistered-dialect 2>&1 | FileCheck %s

// CHECK-LABEL: Testing : "simple"

func @simple(%cond: i1) {
  %p1 = memref.alloca() : memref<i8>
  %p2 = memref.alloca() : memref<i8>
  %p3 = memref.alloca() : memref<i8>

  %c0 = constant 0 : i8
  %c1 = constant 1 : i8
  %c2 = constant 2 : i8

  memref.store %c0, %p3[] : memref<i8>
  br ^while.cond

^while.cond:
  cond_br %cond, ^bb1, ^bb2

^bb1:
  memref.store %c0, %p1[] : memref<i8>
  br ^bb3

^bb2:
  memref.store %c1, %p2[] : memref<i8>
  br ^bb3

^bb3:
  %1 = memref.load %p1[] : memref<i8>
  memref.store %c2, %p2[] : memref<i8>
  %2 = memref.load %p3[] : memref<i8>
  br ^while.cond
}
