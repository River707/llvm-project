add_mlir_pdll_library(MLIRArithmeticCanonicalizationIncGen
  ArithmeticCanonicalization.pdll
  ArithmeticCanonicalization.inc
)

add_mlir_dialect_library(MLIRArithmetic
  ArithmeticOps.cpp
  ArithmeticDialect.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Arithmetic

  DEPENDS
  MLIRArithmeticOpsIncGen

  LINK_LIBS PUBLIC
  MLIRDialect
  MLIRInferTypeOpInterface
  MLIRIR
  MLIRParser
  MLIRPDL
  MLIRPDLInterp
  )
