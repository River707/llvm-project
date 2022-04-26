module {
  pdl_interp.func @matcher(%arg0: !pdl.operation) {
    %0 = pdl_interp.get_operand 0 of %arg0
    %1 = pdl_interp.get_defining_op of %0 : !pdl.value
    pdl_interp.is_not_null %1 : !pdl.operation -> ^bb28, ^bb1
  ^bb1:  // 183 preds: ^bb0, ^bb28, ^bb29, ^bb30, ^bb31, ^bb32, ^bb33, ^bb34, ^bb35, ^bb36, ^bb37, ^bb38, ^bb39, ^bb40, ^bb41, ^bb42, ^bb43, ^bb44, ^bb45, ^bb46, ^bb47, ^bb48, ^bb49, ^bb50, ^bb51, ^bb52, ^bb53, ^bb54, ^bb55, ^bb56, ^bb57, ^bb58, ^bb59, ^bb60, ^bb61, ^bb62, ^bb63, ^bb64, ^bb65, ^bb66, ^bb67, ^bb68, ^bb69, ^bb70, ^bb71, ^bb72, ^bb73, ^bb74, ^bb75, ^bb76, ^bb77, ^bb78, ^bb79, ^bb80, ^bb82, ^bb83, ^bb84, ^bb85, ^bb86, ^bb87, ^bb88, ^bb89, ^bb90, ^bb99, ^bb100, ^bb101, ^bb102, ^bb103, ^bb105, ^bb106, ^bb107, ^bb108, ^bb109, ^bb110, ^bb111, ^bb112, ^bb113, ^bb122, ^bb123, ^bb124, ^bb125, ^bb126, ^bb127, ^bb128, ^bb129, ^bb130, ^bb131, ^bb132, ^bb133, ^bb134, ^bb135, ^bb136, ^bb137, ^bb138, ^bb139, ^bb140, ^bb141, ^bb142, ^bb143, ^bb144, ^bb145, ^bb146, ^bb147, ^bb148, ^bb149, ^bb150, ^bb151, ^bb152, ^bb153, ^bb154, ^bb155, ^bb156, ^bb157, ^bb158, ^bb159, ^bb160, ^bb161, ^bb162, ^bb163, ^bb164, ^bb165, ^bb166, ^bb167, ^bb168, ^bb169, ^bb170, ^bb171, ^bb172, ^bb173, ^bb174, ^bb175, ^bb176, ^bb177, ^bb178, ^bb179, ^bb180, ^bb181, ^bb182, ^bb183, ^bb184, ^bb185, ^bb186, ^bb187, ^bb188, ^bb189, ^bb190, ^bb191, ^bb192, ^bb193, ^bb194, ^bb195, ^bb196, ^bb197, ^bb198, ^bb199, ^bb200, ^bb201, ^bb202, ^bb203, ^bb204, ^bb205, ^bb206, ^bb207, ^bb208, ^bb209, ^bb210, ^bb211, ^bb212, ^bb213, ^bb214, ^bb215, ^bb216, ^bb217, ^bb218, ^bb220, ^bb221, ^bb222, ^bb223, ^bb224, ^bb225, ^bb226, ^bb227, ^bb228
    pdl_interp.switch_operation_name of %arg0 to ["arith.index_cast", "arith.extsi", "arith.bitcast"](^bb3, ^bb16, ^bb22) -> ^bb2
  ^bb2:  // 26 preds: ^bb1, ^bb3, ^bb4, ^bb5, ^bb6, ^bb7, ^bb8, ^bb9, ^bb10, ^bb11, ^bb12, ^bb13, ^bb14, ^bb15, ^bb16, ^bb17, ^bb18, ^bb19, ^bb20, ^bb21, ^bb22, ^bb23, ^bb24, ^bb25, ^bb26, ^bb27
    pdl_interp.finalize
  ^bb3:  // pred: ^bb1
    %2 = pdl_interp.get_operands of %arg0 : !pdl.range<value>
    %3 = pdl_interp.get_defining_op of %2 : !pdl.range<value>
    pdl_interp.is_not_null %3 : !pdl.operation -> ^bb4, ^bb2
  ^bb4:  // pred: ^bb3
    pdl_interp.switch_operation_name of %3 to ["arith.index_cast", "arith.extsi"](^bb5, ^bb12) -> ^bb2
  ^bb5:  // pred: ^bb4
    pdl_interp.check_operand_count of %3 is 1 -> ^bb6, ^bb2
  ^bb6:  // pred: ^bb5
    %4 = pdl_interp.get_operand 0 of %3
    pdl_interp.is_not_null %4 : !pdl.value -> ^bb7, ^bb2
  ^bb7:  // pred: ^bb6
    %5 = pdl_interp.get_results of %3 : !pdl.range<value>
    pdl_interp.are_equal %5, %2 : !pdl.range<value> -> ^bb8, ^bb2
  ^bb8:  // pred: ^bb7
    pdl_interp.check_result_count of %arg0 is 1 -> ^bb9, ^bb2
  ^bb9:  // pred: ^bb8
    %6 = pdl_interp.get_result 0 of %arg0
    pdl_interp.is_not_null %6 : !pdl.value -> ^bb10, ^bb2
  ^bb10:  // pred: ^bb9
    %7 = pdl_interp.get_value_type of %4 : !pdl.type
    %8 = pdl_interp.get_value_type of %6 : !pdl.type
    pdl_interp.are_equal %7, %8 : !pdl.type -> ^bb11, ^bb2
  ^bb11:  // pred: ^bb10
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter(%4, %arg0 : !pdl.value, !pdl.operation) : benefit(0), loc([%arg0, %3]), root("arith.index_cast") -> ^bb2
  ^bb12:  // pred: ^bb4
    pdl_interp.check_operand_count of %3 is 1 -> ^bb13, ^bb2
  ^bb13:  // pred: ^bb12
    %9 = pdl_interp.get_operand 0 of %3
    pdl_interp.is_not_null %9 : !pdl.value -> ^bb14, ^bb2
  ^bb14:  // pred: ^bb13
    %10 = pdl_interp.get_results of %3 : !pdl.range<value>
    pdl_interp.are_equal %10, %2 : !pdl.range<value> -> ^bb15, ^bb2
  ^bb15:  // pred: ^bb14
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_0(%9, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.index_cast"]), loc([%3]), root("arith.index_cast") -> ^bb2
  ^bb16:  // pred: ^bb1
    %11 = pdl_interp.get_operands of %arg0 : !pdl.range<value>
    %12 = pdl_interp.get_defining_op of %11 : !pdl.range<value>
    pdl_interp.is_not_null %12 : !pdl.operation -> ^bb17, ^bb2
  ^bb17:  // pred: ^bb16
    pdl_interp.check_operation_name of %12 is "arith.extui" -> ^bb18, ^bb2
  ^bb18:  // pred: ^bb17
    pdl_interp.check_operand_count of %12 is 1 -> ^bb19, ^bb2
  ^bb19:  // pred: ^bb18
    %13 = pdl_interp.get_operand 0 of %12
    pdl_interp.is_not_null %13 : !pdl.value -> ^bb20, ^bb2
  ^bb20:  // pred: ^bb19
    %14 = pdl_interp.get_results of %12 : !pdl.range<value>
    pdl_interp.are_equal %14, %11 : !pdl.range<value> -> ^bb21, ^bb2
  ^bb21:  // pred: ^bb20
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_1(%13, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.extui"]), loc([%12]), root("arith.extsi") -> ^bb2
  ^bb22:  // pred: ^bb1
    %15 = pdl_interp.get_operands of %arg0 : !pdl.range<value>
    %16 = pdl_interp.get_defining_op of %15 : !pdl.range<value>
    pdl_interp.is_not_null %16 : !pdl.operation -> ^bb23, ^bb2
  ^bb23:  // pred: ^bb22
    pdl_interp.check_operation_name of %16 is "arith.bitcast" -> ^bb24, ^bb2
  ^bb24:  // pred: ^bb23
    pdl_interp.check_operand_count of %16 is 1 -> ^bb25, ^bb2
  ^bb25:  // pred: ^bb24
    %17 = pdl_interp.get_operand 0 of %16
    pdl_interp.is_not_null %17 : !pdl.value -> ^bb26, ^bb2
  ^bb26:  // pred: ^bb25
    %18 = pdl_interp.get_results of %16 : !pdl.range<value>
    pdl_interp.are_equal %18, %15 : !pdl.range<value> -> ^bb27, ^bb2
  ^bb27:  // pred: ^bb26
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_2(%17, %arg0 : !pdl.value, !pdl.operation) : benefit(0), loc([%16]), root("arith.bitcast") -> ^bb2
  ^bb28:  // pred: ^bb0
    %19 = pdl_interp.get_operand 1 of %arg0
    %20 = pdl_interp.get_defining_op of %19 : !pdl.value
    pdl_interp.is_not_null %20 : !pdl.operation -> ^bb29, ^bb1
  ^bb29:  // pred: ^bb28
    pdl_interp.switch_operation_name of %arg0 to ["arith.xori", "arith.subi", "arith.ori", "arith.cmpi", "arith.andi", "arith.addi"](^bb30, ^bb45, ^bb122, ^bb144, ^bb174, ^bb196) -> ^bb1
  ^bb30:  // pred: ^bb29
    pdl_interp.check_operand_count of %arg0 is 2 -> ^bb31, ^bb1
  ^bb31:  // pred: ^bb30
    pdl_interp.is_not_null %0 : !pdl.value -> ^bb32, ^bb1
  ^bb32:  // pred: ^bb31
    pdl_interp.is_not_null %19 : !pdl.value -> ^bb33, ^bb1
  ^bb33:  // pred: ^bb32
    pdl_interp.check_operation_name of %1 is "arith.cmpi" -> ^bb34, ^bb1
  ^bb34:  // pred: ^bb33
    pdl_interp.check_operation_name of %20 is "arith.constant" -> ^bb35, ^bb1
  ^bb35:  // pred: ^bb34
    %21 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %21, %0 : !pdl.value -> ^bb36, ^bb1
  ^bb36:  // pred: ^bb35
    %22 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %22, %19 : !pdl.value -> ^bb37, ^bb1
  ^bb37:  // pred: ^bb36
    pdl_interp.check_operand_count of %1 is 2 -> ^bb38, ^bb1
  ^bb38:  // pred: ^bb37
    %23 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %23 : !pdl.value -> ^bb39, ^bb1
  ^bb39:  // pred: ^bb38
    %24 = pdl_interp.get_operand 1 of %1
    pdl_interp.is_not_null %24 : !pdl.value -> ^bb40, ^bb1
  ^bb40:  // pred: ^bb39
    %25 = pdl_interp.get_attribute "value" of %20
    pdl_interp.is_not_null %25 : !pdl.attribute -> ^bb41, ^bb1
  ^bb41:  // pred: ^bb40
    pdl_interp.check_attribute %25 is true -> ^bb42, ^bb1
  ^bb42:  // pred: ^bb41
    %26 = pdl_interp.get_attribute "predicate" of %1
    pdl_interp.is_not_null %26 : !pdl.attribute -> ^bb43, ^bb1
  ^bb43:  // pred: ^bb42
    pdl_interp.check_attribute %26 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":135:53) -> ^bb44, ^bb1
  ^bb44:  // pred: ^bb43
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_3(%23, %24, %arg0 : !pdl.value, !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.cmpi"]), loc([%1, %20, %arg0]), root("arith.xori") -> ^bb1
  ^bb45:  // pred: ^bb29
    pdl_interp.check_operand_count of %arg0 is 2 -> ^bb46, ^bb1
  ^bb46:  // pred: ^bb45
    pdl_interp.is_not_null %0 : !pdl.value -> ^bb47, ^bb1
  ^bb47:  // pred: ^bb46
    pdl_interp.is_not_null %19 : !pdl.value -> ^bb48, ^bb1
  ^bb48:  // pred: ^bb47
    pdl_interp.switch_operation_name of %1 to ["arith.addi", "arith.constant", "arith.subi"](^bb49, ^bb63, ^bb99) -> ^bb1
  ^bb49:  // pred: ^bb48
    pdl_interp.check_operation_name of %20 is "arith.constant" -> ^bb50, ^bb1
  ^bb50:  // pred: ^bb49
    %27 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %27, %0 : !pdl.value -> ^bb51, ^bb1
  ^bb51:  // pred: ^bb50
    %28 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %28, %19 : !pdl.value -> ^bb52, ^bb1
  ^bb52:  // pred: ^bb51
    pdl_interp.check_operand_count of %1 is 2 -> ^bb53, ^bb1
  ^bb53:  // pred: ^bb52
    %29 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %29 : !pdl.value -> ^bb54, ^bb1
  ^bb54:  // pred: ^bb53
    %30 = pdl_interp.get_operand 1 of %1
    %31 = pdl_interp.get_defining_op of %30 : !pdl.value
    pdl_interp.is_not_null %31 : !pdl.operation -> ^bb55, ^bb1
  ^bb55:  // pred: ^bb54
    pdl_interp.is_not_null %30 : !pdl.value -> ^bb56, ^bb1
  ^bb56:  // pred: ^bb55
    %32 = pdl_interp.get_attribute "value" of %20
    pdl_interp.is_not_null %32 : !pdl.attribute -> ^bb57, ^bb1
  ^bb57:  // pred: ^bb56
    pdl_interp.check_attribute %32 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":75:33) -> ^bb58, ^bb1
  ^bb58:  // pred: ^bb57
    pdl_interp.check_operation_name of %31 is "arith.constant" -> ^bb59, ^bb1
  ^bb59:  // pred: ^bb58
    %33 = pdl_interp.get_attribute "value" of %31
    pdl_interp.is_not_null %33 : !pdl.attribute -> ^bb60, ^bb1
  ^bb60:  // pred: ^bb59
    pdl_interp.check_attribute %33 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":74:58) -> ^bb61, ^bb1
  ^bb61:  // pred: ^bb60
    %34 = pdl_interp.get_result 0 of %31
    pdl_interp.are_equal %34, %30 : !pdl.value -> ^bb62, ^bb1
  ^bb62:  // pred: ^bb61
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_4(%29, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.addi"]), loc([%arg0, %1, %20, %31]), root("arith.subi") -> ^bb1
  ^bb63:  // pred: ^bb48
    pdl_interp.switch_operation_name of %20 to ["arith.addi", "arith.subi"](^bb64, ^bb77) -> ^bb1
  ^bb64:  // pred: ^bb63
    %35 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %35, %0 : !pdl.value -> ^bb65, ^bb1
  ^bb65:  // pred: ^bb64
    %36 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %36, %19 : !pdl.value -> ^bb66, ^bb1
  ^bb66:  // pred: ^bb65
    pdl_interp.check_operand_count of %20 is 2 -> ^bb67, ^bb1
  ^bb67:  // pred: ^bb66
    %37 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %37 : !pdl.value -> ^bb68, ^bb1
  ^bb68:  // pred: ^bb67
    %38 = pdl_interp.get_operand 1 of %20
    %39 = pdl_interp.get_defining_op of %38 : !pdl.value
    pdl_interp.is_not_null %39 : !pdl.operation -> ^bb69, ^bb1
  ^bb69:  // pred: ^bb68
    pdl_interp.is_not_null %38 : !pdl.value -> ^bb70, ^bb1
  ^bb70:  // pred: ^bb69
    %40 = pdl_interp.get_attribute "value" of %1
    pdl_interp.is_not_null %40 : !pdl.attribute -> ^bb71, ^bb1
  ^bb71:  // pred: ^bb70
    pdl_interp.check_attribute %40 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":82:33) -> ^bb72, ^bb1
  ^bb72:  // pred: ^bb71
    pdl_interp.check_operation_name of %39 is "arith.constant" -> ^bb73, ^bb1
  ^bb73:  // pred: ^bb72
    %41 = pdl_interp.get_attribute "value" of %39
    pdl_interp.is_not_null %41 : !pdl.attribute -> ^bb74, ^bb1
  ^bb74:  // pred: ^bb73
    pdl_interp.check_attribute %41 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":83:58) -> ^bb75, ^bb1
  ^bb75:  // pred: ^bb74
    %42 = pdl_interp.get_result 0 of %39
    pdl_interp.are_equal %42, %38 : !pdl.value -> ^bb76, ^bb1
  ^bb76:  // pred: ^bb75
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_5(%37, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.subi"]), loc([%arg0, %20, %39]), root("arith.subi") -> ^bb1
  ^bb77:  // pred: ^bb63
    %43 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %43, %0 : !pdl.value -> ^bb78, ^bb1
  ^bb78:  // pred: ^bb77
    %44 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %44, %19 : !pdl.value -> ^bb79, ^bb1
  ^bb79:  // pred: ^bb78
    pdl_interp.check_operand_count of %20 is 2 -> ^bb80, ^bb1
  ^bb80:  // pred: ^bb79
    %45 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %45 : !pdl.value -> ^bb81, ^bb1
  ^bb81:  // pred: ^bb80
    %46 = pdl_interp.get_operand 1 of %20
    %47 = pdl_interp.get_defining_op of %46 : !pdl.value
    pdl_interp.is_not_null %47 : !pdl.operation -> ^bb91, ^bb82
  ^bb82:  // 9 preds: ^bb81, ^bb91, ^bb92, ^bb93, ^bb94, ^bb95, ^bb96, ^bb97, ^bb98
    %48 = pdl_interp.get_operand 1 of %20
    pdl_interp.is_not_null %48 : !pdl.value -> ^bb83, ^bb1
  ^bb83:  // pred: ^bb82
    %49 = pdl_interp.get_attribute "value" of %1
    pdl_interp.is_not_null %49 : !pdl.attribute -> ^bb84, ^bb1
  ^bb84:  // pred: ^bb83
    pdl_interp.check_attribute %49 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":114:33) -> ^bb85, ^bb1
  ^bb85:  // pred: ^bb84
    %50 = pdl_interp.get_defining_op of %45 : !pdl.value
    pdl_interp.is_not_null %50 : !pdl.operation -> ^bb86, ^bb1
  ^bb86:  // pred: ^bb85
    pdl_interp.check_operation_name of %50 is "arith.constant" -> ^bb87, ^bb1
  ^bb87:  // pred: ^bb86
    %51 = pdl_interp.get_attribute "value" of %50
    pdl_interp.is_not_null %51 : !pdl.attribute -> ^bb88, ^bb1
  ^bb88:  // pred: ^bb87
    pdl_interp.check_attribute %51 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":115:48) -> ^bb89, ^bb1
  ^bb89:  // pred: ^bb88
    %52 = pdl_interp.get_result 0 of %50
    pdl_interp.are_equal %52, %45 : !pdl.value -> ^bb90, ^bb1
  ^bb90:  // pred: ^bb89
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_6(%48, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.addi"]), loc([%arg0, %20, %50]), root("arith.subi") -> ^bb1
  ^bb91:  // pred: ^bb81
    pdl_interp.is_not_null %46 : !pdl.value -> ^bb92, ^bb82
  ^bb92:  // pred: ^bb91
    %53 = pdl_interp.get_attribute "value" of %1
    pdl_interp.is_not_null %53 : !pdl.attribute -> ^bb93, ^bb82
  ^bb93:  // pred: ^bb92
    pdl_interp.check_attribute %53 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":106:33) -> ^bb94, ^bb82
  ^bb94:  // pred: ^bb93
    pdl_interp.check_operation_name of %47 is "arith.constant" -> ^bb95, ^bb82
  ^bb95:  // pred: ^bb94
    %54 = pdl_interp.get_attribute "value" of %47
    pdl_interp.is_not_null %54 : !pdl.attribute -> ^bb96, ^bb82
  ^bb96:  // pred: ^bb95
    pdl_interp.check_attribute %54 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":107:58) -> ^bb97, ^bb82
  ^bb97:  // pred: ^bb96
    %55 = pdl_interp.get_result 0 of %47
    pdl_interp.are_equal %55, %46 : !pdl.value -> ^bb98, ^bb82
  ^bb98:  // pred: ^bb97
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_7(%45, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.subi"]), loc([%arg0, %20, %47]), root("arith.subi") -> ^bb82
  ^bb99:  // pred: ^bb48
    pdl_interp.check_operation_name of %20 is "arith.constant" -> ^bb100, ^bb1
  ^bb100:  // pred: ^bb99
    %56 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %56, %0 : !pdl.value -> ^bb101, ^bb1
  ^bb101:  // pred: ^bb100
    %57 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %57, %19 : !pdl.value -> ^bb102, ^bb1
  ^bb102:  // pred: ^bb101
    pdl_interp.check_operand_count of %1 is 2 -> ^bb103, ^bb1
  ^bb103:  // pred: ^bb102
    %58 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %58 : !pdl.value -> ^bb104, ^bb1
  ^bb104:  // pred: ^bb103
    %59 = pdl_interp.get_operand 1 of %1
    %60 = pdl_interp.get_defining_op of %59 : !pdl.value
    pdl_interp.is_not_null %60 : !pdl.operation -> ^bb114, ^bb105
  ^bb105:  // 9 preds: ^bb104, ^bb114, ^bb115, ^bb116, ^bb117, ^bb118, ^bb119, ^bb120, ^bb121
    %61 = pdl_interp.get_operand 1 of %1
    pdl_interp.is_not_null %61 : !pdl.value -> ^bb106, ^bb1
  ^bb106:  // pred: ^bb105
    %62 = pdl_interp.get_attribute "value" of %20
    pdl_interp.is_not_null %62 : !pdl.attribute -> ^bb107, ^bb1
  ^bb107:  // pred: ^bb106
    pdl_interp.check_attribute %62 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":99:33) -> ^bb108, ^bb1
  ^bb108:  // pred: ^bb107
    %63 = pdl_interp.get_defining_op of %58 : !pdl.value
    pdl_interp.is_not_null %63 : !pdl.operation -> ^bb109, ^bb1
  ^bb109:  // pred: ^bb108
    pdl_interp.check_operation_name of %63 is "arith.constant" -> ^bb110, ^bb1
  ^bb110:  // pred: ^bb109
    %64 = pdl_interp.get_attribute "value" of %63
    pdl_interp.is_not_null %64 : !pdl.attribute -> ^bb111, ^bb1
  ^bb111:  // pred: ^bb110
    pdl_interp.check_attribute %64 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":98:48) -> ^bb112, ^bb1
  ^bb112:  // pred: ^bb111
    %65 = pdl_interp.get_result 0 of %63
    pdl_interp.are_equal %65, %58 : !pdl.value -> ^bb113, ^bb1
  ^bb113:  // pred: ^bb112
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_8(%61, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.subi"]), loc([%arg0, %20, %1, %63]), root("arith.subi") -> ^bb1
  ^bb114:  // pred: ^bb104
    pdl_interp.is_not_null %59 : !pdl.value -> ^bb115, ^bb105
  ^bb115:  // pred: ^bb114
    %66 = pdl_interp.get_attribute "value" of %20
    pdl_interp.is_not_null %66 : !pdl.attribute -> ^bb116, ^bb105
  ^bb116:  // pred: ^bb115
    pdl_interp.check_attribute %66 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":91:33) -> ^bb117, ^bb105
  ^bb117:  // pred: ^bb116
    pdl_interp.check_operation_name of %60 is "arith.constant" -> ^bb118, ^bb105
  ^bb118:  // pred: ^bb117
    %67 = pdl_interp.get_attribute "value" of %60
    pdl_interp.is_not_null %67 : !pdl.attribute -> ^bb119, ^bb105
  ^bb119:  // pred: ^bb118
    pdl_interp.check_attribute %67 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":90:58) -> ^bb120, ^bb105
  ^bb120:  // pred: ^bb119
    %68 = pdl_interp.get_result 0 of %60
    pdl_interp.are_equal %68, %59 : !pdl.value -> ^bb121, ^bb105
  ^bb121:  // pred: ^bb120
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_9(%58, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.subi"]), loc([%arg0, %20, %1, %60]), root("arith.subi") -> ^bb105
  ^bb122:  // pred: ^bb29
    pdl_interp.check_operand_count of %arg0 is 2 -> ^bb123, ^bb1
  ^bb123:  // pred: ^bb122
    pdl_interp.is_not_null %0 : !pdl.value -> ^bb124, ^bb1
  ^bb124:  // pred: ^bb123
    pdl_interp.is_not_null %19 : !pdl.value -> ^bb125, ^bb1
  ^bb125:  // pred: ^bb124
    pdl_interp.switch_operation_name of %1 to ["arith.extui", "arith.extsi"](^bb126, ^bb135) -> ^bb1
  ^bb126:  // pred: ^bb125
    pdl_interp.check_operation_name of %20 is "arith.extui" -> ^bb127, ^bb1
  ^bb127:  // pred: ^bb126
    %69 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %69, %0 : !pdl.value -> ^bb128, ^bb1
  ^bb128:  // pred: ^bb127
    %70 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %70, %19 : !pdl.value -> ^bb129, ^bb1
  ^bb129:  // pred: ^bb128
    pdl_interp.check_operand_count of %1 is 1 -> ^bb130, ^bb1
  ^bb130:  // pred: ^bb129
    %71 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %71 : !pdl.value -> ^bb131, ^bb1
  ^bb131:  // pred: ^bb130
    pdl_interp.check_operand_count of %20 is 1 -> ^bb132, ^bb1
  ^bb132:  // pred: ^bb131
    %72 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %72 : !pdl.value -> ^bb133, ^bb1
  ^bb133:  // pred: ^bb132
    %73 = pdl_interp.get_value_type of %71 : !pdl.type
    %74 = pdl_interp.get_value_type of %72 : !pdl.type
    pdl_interp.are_equal %73, %74 : !pdl.type -> ^bb134, ^bb1
  ^bb134:  // pred: ^bb133
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_10(%71, %72, %arg0 : !pdl.value, !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.ori", "arith.extui"]), loc([%arg0, %1, %20]), root("arith.ori") -> ^bb1
  ^bb135:  // pred: ^bb125
    pdl_interp.check_operation_name of %20 is "arith.extsi" -> ^bb136, ^bb1
  ^bb136:  // pred: ^bb135
    %75 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %75, %0 : !pdl.value -> ^bb137, ^bb1
  ^bb137:  // pred: ^bb136
    %76 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %76, %19 : !pdl.value -> ^bb138, ^bb1
  ^bb138:  // pred: ^bb137
    pdl_interp.check_operand_count of %1 is 1 -> ^bb139, ^bb1
  ^bb139:  // pred: ^bb138
    %77 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %77 : !pdl.value -> ^bb140, ^bb1
  ^bb140:  // pred: ^bb139
    pdl_interp.check_operand_count of %20 is 1 -> ^bb141, ^bb1
  ^bb141:  // pred: ^bb140
    %78 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %78 : !pdl.value -> ^bb142, ^bb1
  ^bb142:  // pred: ^bb141
    %79 = pdl_interp.get_value_type of %77 : !pdl.type
    %80 = pdl_interp.get_value_type of %78 : !pdl.type
    pdl_interp.are_equal %79, %80 : !pdl.type -> ^bb143, ^bb1
  ^bb143:  // pred: ^bb142
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_11(%77, %78, %arg0 : !pdl.value, !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.ori", "arith.extsi"]), loc([%arg0, %20, %1]), root("arith.ori") -> ^bb1
  ^bb144:  // pred: ^bb29
    pdl_interp.check_operand_count of %arg0 is 2 -> ^bb145, ^bb1
  ^bb145:  // pred: ^bb144
    pdl_interp.is_not_null %0 : !pdl.value -> ^bb146, ^bb1
  ^bb146:  // pred: ^bb145
    pdl_interp.is_not_null %19 : !pdl.value -> ^bb147, ^bb1
  ^bb147:  // pred: ^bb146
    pdl_interp.switch_operation_name of %1 to ["arith.extsi", "arith.extui"](^bb148, ^bb161) -> ^bb1
  ^bb148:  // pred: ^bb147
    pdl_interp.check_operation_name of %20 is "arith.extsi" -> ^bb149, ^bb1
  ^bb149:  // pred: ^bb148
    %81 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %81, %0 : !pdl.value -> ^bb150, ^bb1
  ^bb150:  // pred: ^bb149
    %82 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %82, %19 : !pdl.value -> ^bb151, ^bb1
  ^bb151:  // pred: ^bb150
    pdl_interp.check_operand_count of %1 is 1 -> ^bb152, ^bb1
  ^bb152:  // pred: ^bb151
    %83 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %83 : !pdl.value -> ^bb153, ^bb1
  ^bb153:  // pred: ^bb152
    pdl_interp.check_operand_count of %20 is 1 -> ^bb154, ^bb1
  ^bb154:  // pred: ^bb153
    %84 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %84 : !pdl.value -> ^bb155, ^bb1
  ^bb155:  // pred: ^bb154
    %85 = pdl_interp.get_value_type of %83 : !pdl.type
    %86 = pdl_interp.get_value_type of %84 : !pdl.type
    pdl_interp.are_equal %85, %86 : !pdl.type -> ^bb156, ^bb1
  ^bb156:  // pred: ^bb155
    %87 = pdl_interp.get_attribute "predicate" of %arg0
    pdl_interp.is_not_null %87 : !pdl.attribute -> ^bb157, ^bb1
  ^bb157:  // pred: ^bb156
    pdl_interp.check_attribute %87 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":155:18) -> ^bb158, ^bb1
  ^bb158:  // pred: ^bb157
    pdl_interp.apply_constraint "Arith_CmpIPredicateAttr"(%87 : !pdl.attribute) -> ^bb159, ^bb1
  ^bb159:  // pred: ^bb158
    pdl_interp.apply_constraint "IsEqOrNeCmp"(%87 : !pdl.attribute) -> ^bb160, ^bb1
  ^bb160:  // pred: ^bb159
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_12(%83, %84, %arg0 : !pdl.value, !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.cmpi"]), loc([%arg0, %1, %20]), root("arith.cmpi") -> ^bb1
  ^bb161:  // pred: ^bb147
    pdl_interp.check_operation_name of %20 is "arith.extui" -> ^bb162, ^bb1
  ^bb162:  // pred: ^bb161
    %88 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %88, %0 : !pdl.value -> ^bb163, ^bb1
  ^bb163:  // pred: ^bb162
    %89 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %89, %19 : !pdl.value -> ^bb164, ^bb1
  ^bb164:  // pred: ^bb163
    pdl_interp.check_operand_count of %1 is 1 -> ^bb165, ^bb1
  ^bb165:  // pred: ^bb164
    %90 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %90 : !pdl.value -> ^bb166, ^bb1
  ^bb166:  // pred: ^bb165
    pdl_interp.check_operand_count of %20 is 1 -> ^bb167, ^bb1
  ^bb167:  // pred: ^bb166
    %91 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %91 : !pdl.value -> ^bb168, ^bb1
  ^bb168:  // pred: ^bb167
    %92 = pdl_interp.get_value_type of %90 : !pdl.type
    %93 = pdl_interp.get_value_type of %91 : !pdl.type
    pdl_interp.are_equal %92, %93 : !pdl.type -> ^bb169, ^bb1
  ^bb169:  // pred: ^bb168
    %94 = pdl_interp.get_attribute "predicate" of %arg0
    pdl_interp.is_not_null %94 : !pdl.attribute -> ^bb170, ^bb1
  ^bb170:  // pred: ^bb169
    pdl_interp.check_attribute %94 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":164:18) -> ^bb171, ^bb1
  ^bb171:  // pred: ^bb170
    pdl_interp.apply_constraint "Arith_CmpIPredicateAttr"(%94 : !pdl.attribute) -> ^bb172, ^bb1
  ^bb172:  // pred: ^bb171
    pdl_interp.apply_constraint "IsEqOrNeCmp"(%94 : !pdl.attribute) -> ^bb173, ^bb1
  ^bb173:  // pred: ^bb172
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_13(%90, %91, %arg0 : !pdl.value, !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.cmpi"]), loc([%arg0, %20, %1]), root("arith.cmpi") -> ^bb1
  ^bb174:  // pred: ^bb29
    pdl_interp.check_operand_count of %arg0 is 2 -> ^bb175, ^bb1
  ^bb175:  // pred: ^bb174
    pdl_interp.is_not_null %0 : !pdl.value -> ^bb176, ^bb1
  ^bb176:  // pred: ^bb175
    pdl_interp.is_not_null %19 : !pdl.value -> ^bb177, ^bb1
  ^bb177:  // pred: ^bb176
    pdl_interp.switch_operation_name of %1 to ["arith.extui", "arith.extsi"](^bb178, ^bb187) -> ^bb1
  ^bb178:  // pred: ^bb177
    pdl_interp.check_operation_name of %20 is "arith.extui" -> ^bb179, ^bb1
  ^bb179:  // pred: ^bb178
    %95 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %95, %0 : !pdl.value -> ^bb180, ^bb1
  ^bb180:  // pred: ^bb179
    %96 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %96, %19 : !pdl.value -> ^bb181, ^bb1
  ^bb181:  // pred: ^bb180
    pdl_interp.check_operand_count of %1 is 1 -> ^bb182, ^bb1
  ^bb182:  // pred: ^bb181
    %97 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %97 : !pdl.value -> ^bb183, ^bb1
  ^bb183:  // pred: ^bb182
    pdl_interp.check_operand_count of %20 is 1 -> ^bb184, ^bb1
  ^bb184:  // pred: ^bb183
    %98 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %98 : !pdl.value -> ^bb185, ^bb1
  ^bb185:  // pred: ^bb184
    %99 = pdl_interp.get_value_type of %97 : !pdl.type
    %100 = pdl_interp.get_value_type of %98 : !pdl.type
    pdl_interp.are_equal %99, %100 : !pdl.type -> ^bb186, ^bb1
  ^bb186:  // pred: ^bb185
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_14(%97, %98, %arg0 : !pdl.value, !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.andi", "arith.extui"]), loc([%arg0, %1, %20]), root("arith.andi") -> ^bb1
  ^bb187:  // pred: ^bb177
    pdl_interp.check_operation_name of %20 is "arith.extsi" -> ^bb188, ^bb1
  ^bb188:  // pred: ^bb187
    %101 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %101, %0 : !pdl.value -> ^bb189, ^bb1
  ^bb189:  // pred: ^bb188
    %102 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %102, %19 : !pdl.value -> ^bb190, ^bb1
  ^bb190:  // pred: ^bb189
    pdl_interp.check_operand_count of %1 is 1 -> ^bb191, ^bb1
  ^bb191:  // pred: ^bb190
    %103 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %103 : !pdl.value -> ^bb192, ^bb1
  ^bb192:  // pred: ^bb191
    pdl_interp.check_operand_count of %20 is 1 -> ^bb193, ^bb1
  ^bb193:  // pred: ^bb192
    %104 = pdl_interp.get_operand 0 of %20
    pdl_interp.is_not_null %104 : !pdl.value -> ^bb194, ^bb1
  ^bb194:  // pred: ^bb193
    %105 = pdl_interp.get_value_type of %103 : !pdl.type
    %106 = pdl_interp.get_value_type of %104 : !pdl.type
    pdl_interp.are_equal %105, %106 : !pdl.type -> ^bb195, ^bb1
  ^bb195:  // pred: ^bb194
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_15(%103, %104, %arg0 : !pdl.value, !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.andi", "arith.extsi"]), loc([%arg0, %20, %1]), root("arith.andi") -> ^bb1
  ^bb196:  // pred: ^bb29
    pdl_interp.check_operand_count of %arg0 is 2 -> ^bb197, ^bb1
  ^bb197:  // pred: ^bb196
    pdl_interp.is_not_null %0 : !pdl.value -> ^bb198, ^bb1
  ^bb198:  // pred: ^bb197
    pdl_interp.is_not_null %19 : !pdl.value -> ^bb199, ^bb1
  ^bb199:  // pred: ^bb198
    pdl_interp.switch_operation_name of %1 to ["arith.addi", "arith.subi"](^bb200, ^bb214) -> ^bb1
  ^bb200:  // pred: ^bb199
    pdl_interp.check_operation_name of %20 is "arith.constant" -> ^bb201, ^bb1
  ^bb201:  // pred: ^bb200
    %107 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %107, %0 : !pdl.value -> ^bb202, ^bb1
  ^bb202:  // pred: ^bb201
    %108 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %108, %19 : !pdl.value -> ^bb203, ^bb1
  ^bb203:  // pred: ^bb202
    pdl_interp.check_operand_count of %1 is 2 -> ^bb204, ^bb1
  ^bb204:  // pred: ^bb203
    %109 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %109 : !pdl.value -> ^bb205, ^bb1
  ^bb205:  // pred: ^bb204
    %110 = pdl_interp.get_operand 1 of %1
    %111 = pdl_interp.get_defining_op of %110 : !pdl.value
    pdl_interp.is_not_null %111 : !pdl.operation -> ^bb206, ^bb1
  ^bb206:  // pred: ^bb205
    pdl_interp.is_not_null %110 : !pdl.value -> ^bb207, ^bb1
  ^bb207:  // pred: ^bb206
    %112 = pdl_interp.get_attribute "value" of %20
    pdl_interp.is_not_null %112 : !pdl.attribute -> ^bb208, ^bb1
  ^bb208:  // pred: ^bb207
    pdl_interp.check_attribute %112 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":47:33) -> ^bb209, ^bb1
  ^bb209:  // pred: ^bb208
    pdl_interp.check_operation_name of %111 is "arith.constant" -> ^bb210, ^bb1
  ^bb210:  // pred: ^bb209
    %113 = pdl_interp.get_attribute "value" of %111
    pdl_interp.is_not_null %113 : !pdl.attribute -> ^bb211, ^bb1
  ^bb211:  // pred: ^bb210
    pdl_interp.check_attribute %113 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":46:59) -> ^bb212, ^bb1
  ^bb212:  // pred: ^bb211
    %114 = pdl_interp.get_result 0 of %111
    pdl_interp.are_equal %114, %110 : !pdl.value -> ^bb213, ^bb1
  ^bb213:  // pred: ^bb212
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_16(%109, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.addi"]), loc([%arg0, %1, %20, %111]), root("arith.addi") -> ^bb1
  ^bb214:  // pred: ^bb199
    pdl_interp.check_operation_name of %20 is "arith.constant" -> ^bb215, ^bb1
  ^bb215:  // pred: ^bb214
    %115 = pdl_interp.get_result 0 of %1
    pdl_interp.are_equal %115, %0 : !pdl.value -> ^bb216, ^bb1
  ^bb216:  // pred: ^bb215
    %116 = pdl_interp.get_result 0 of %20
    pdl_interp.are_equal %116, %19 : !pdl.value -> ^bb217, ^bb1
  ^bb217:  // pred: ^bb216
    pdl_interp.check_operand_count of %1 is 2 -> ^bb218, ^bb1
  ^bb218:  // pred: ^bb217
    %117 = pdl_interp.get_operand 0 of %1
    pdl_interp.is_not_null %117 : !pdl.value -> ^bb219, ^bb1
  ^bb219:  // pred: ^bb218
    %118 = pdl_interp.get_operand 1 of %1
    %119 = pdl_interp.get_defining_op of %118 : !pdl.value
    pdl_interp.is_not_null %119 : !pdl.operation -> ^bb229, ^bb220
  ^bb220:  // 10 preds: ^bb219, ^bb229, ^bb230, ^bb231, ^bb232, ^bb233, ^bb234, ^bb235, ^bb236, ^bb237
    %120 = pdl_interp.get_operand 1 of %1
    pdl_interp.is_not_null %120 : !pdl.value -> ^bb221, ^bb1
  ^bb221:  // pred: ^bb220
    %121 = pdl_interp.get_attribute "value" of %20
    pdl_interp.is_not_null %121 : !pdl.attribute -> ^bb222, ^bb1
  ^bb222:  // pred: ^bb221
    pdl_interp.check_attribute %121 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":63:33) -> ^bb223, ^bb1
  ^bb223:  // pred: ^bb222
    %122 = pdl_interp.get_defining_op of %117 : !pdl.value
    pdl_interp.is_not_null %122 : !pdl.operation -> ^bb224, ^bb1
  ^bb224:  // pred: ^bb223
    pdl_interp.check_operation_name of %122 is "arith.constant" -> ^bb225, ^bb1
  ^bb225:  // pred: ^bb224
    %123 = pdl_interp.get_attribute "value" of %122
    pdl_interp.is_not_null %123 : !pdl.attribute -> ^bb226, ^bb1
  ^bb226:  // pred: ^bb225
    pdl_interp.check_attribute %123 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":62:48) -> ^bb227, ^bb1
  ^bb227:  // pred: ^bb226
    %124 = pdl_interp.get_result 0 of %122
    pdl_interp.are_equal %124, %117 : !pdl.value -> ^bb228, ^bb1
  ^bb228:  // pred: ^bb227
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_17(%120, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.subi"]), loc([%arg0, %20, %1, %122]), root("arith.addi") -> ^bb1
  ^bb229:  // pred: ^bb219
    pdl_interp.is_not_null %118 : !pdl.value -> ^bb230, ^bb220
  ^bb230:  // pred: ^bb229
    %125 = pdl_interp.get_attribute "value" of %20
    pdl_interp.is_not_null %125 : !pdl.attribute -> ^bb231, ^bb220
  ^bb231:  // pred: ^bb230
    pdl_interp.check_attribute %125 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":55:33) -> ^bb232, ^bb220
  ^bb232:  // pred: ^bb231
    pdl_interp.check_operation_name of %119 is "arith.constant" -> ^bb233, ^bb220
  ^bb233:  // pred: ^bb232
    %126 = pdl_interp.get_attribute "value" of %119
    pdl_interp.is_not_null %126 : !pdl.attribute -> ^bb234, ^bb220
  ^bb234:  // pred: ^bb233
    pdl_interp.check_attribute %126 is loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":54:59) -> ^bb235, ^bb220
  ^bb235:  // pred: ^bb234
    %127 = pdl_interp.get_result 0 of %119
    pdl_interp.are_equal %127, %118 : !pdl.value -> ^bb236, ^bb220
  ^bb236:  // pred: ^bb235
    pdl_interp.apply_constraint "APIntAttr"(%126 : !pdl.attribute) -> ^bb237, ^bb220
  ^bb237:  // pred: ^bb236
    pdl_interp.record_match @rewriters::@pdl_generated_rewriter_18(%117, %arg0 : !pdl.value, !pdl.operation) : benefit(0), generatedOps(["arith.constant", "arith.addi"]), loc([%arg0, %20, %1, %119]), root("arith.addi") -> ^bb220
  }
  module @rewriters {
    pdl_interp.func @pdl_generated_rewriter(%arg0: !pdl.value, %arg1: !pdl.operation) {
      pdl_interp.replace %arg1 with (%arg0 : !pdl.value)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_0(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %1 = pdl_interp.get_value_type of %0 : !pdl.range<type>
      %2 = pdl_interp.create_operation "arith.index_cast"(%arg0 : !pdl.value)  -> (%1 : !pdl.range<type>)
      %3 = pdl_interp.get_results of %2 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%3 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_1(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %1 = pdl_interp.get_value_type of %0 : !pdl.range<type>
      %2 = pdl_interp.create_operation "arith.extui"(%arg0 : !pdl.value)  -> (%1 : !pdl.range<type>)
      %3 = pdl_interp.get_results of %2 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%3 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_2(%arg0: !pdl.value, %arg1: !pdl.operation) {
      pdl_interp.replace %arg1 with (%arg0 : !pdl.value)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_3(%arg0: !pdl.value, %arg1: !pdl.value, %arg2: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":135:53)
      %1 = pdl_interp.apply_rewrite "InvertPredicate"(%0 : !pdl.attribute) : !pdl.attribute
      %2 = pdl_interp.get_results of %arg2 : !pdl.range<value>
      %3 = pdl_interp.get_value_type of %2 : !pdl.range<type>
      %4 = pdl_interp.create_operation "arith.cmpi"(%arg0, %arg1 : !pdl.value, !pdl.value)  {"predicate" = %1} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_results of %4 : !pdl.range<value>
      pdl_interp.replace %arg2 with (%5 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_4(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":74:58)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":75:33)
      %2 = pdl_interp.apply_rewrite "SubIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.addi"(%arg0, %5 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_5(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":82:33)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":83:58)
      %2 = pdl_interp.apply_rewrite "SubIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.subi"(%5, %arg0 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_6(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":114:33)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":115:48)
      %2 = pdl_interp.apply_rewrite "SubIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.addi"(%5, %arg0 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_7(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":107:58)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":106:33)
      %2 = pdl_interp.apply_rewrite "AddIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.subi"(%5, %arg0 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_8(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":98:48)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":99:33)
      %2 = pdl_interp.apply_rewrite "SubIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.subi"(%5, %arg0 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_9(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":90:58)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":91:33)
      %2 = pdl_interp.apply_rewrite "AddIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.subi"(%arg0, %5 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_10(%arg0: !pdl.value, %arg1: !pdl.value, %arg2: !pdl.operation) {
      %0 = pdl_interp.inferred_types
      %1 = pdl_interp.create_operation "arith.ori"(%arg0, %arg1 : !pdl.value, !pdl.value)  -> (%0 : !pdl.range<type>)
      %2 = pdl_interp.get_results of %1 : !pdl.range<value>
      %3 = pdl_interp.get_results of %arg2 : !pdl.range<value>
      %4 = pdl_interp.get_value_type of %3 : !pdl.range<type>
      %5 = pdl_interp.create_operation "arith.extui"(%2 : !pdl.range<value>)  -> (%4 : !pdl.range<type>)
      %6 = pdl_interp.get_results of %5 : !pdl.range<value>
      pdl_interp.replace %arg2 with (%6 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_11(%arg0: !pdl.value, %arg1: !pdl.value, %arg2: !pdl.operation) {
      %0 = pdl_interp.inferred_types
      %1 = pdl_interp.create_operation "arith.ori"(%arg0, %arg1 : !pdl.value, !pdl.value)  -> (%0 : !pdl.range<type>)
      %2 = pdl_interp.get_results of %1 : !pdl.range<value>
      %3 = pdl_interp.get_results of %arg2 : !pdl.range<value>
      %4 = pdl_interp.get_value_type of %3 : !pdl.range<type>
      %5 = pdl_interp.create_operation "arith.extsi"(%2 : !pdl.range<value>)  -> (%4 : !pdl.range<type>)
      %6 = pdl_interp.get_results of %5 : !pdl.range<value>
      pdl_interp.replace %arg2 with (%6 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_12(%arg0: !pdl.value, %arg1: !pdl.value, %arg2: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":155:18)
      %1 = pdl_interp.get_results of %arg2 : !pdl.range<value>
      %2 = pdl_interp.get_value_type of %1 : !pdl.range<type>
      %3 = pdl_interp.create_operation "arith.cmpi"(%arg0, %arg1 : !pdl.value, !pdl.value)  {"predicate" = %0} -> (%2 : !pdl.range<type>)
      %4 = pdl_interp.get_results of %3 : !pdl.range<value>
      pdl_interp.replace %arg2 with (%4 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_13(%arg0: !pdl.value, %arg1: !pdl.value, %arg2: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":164:18)
      %1 = pdl_interp.get_results of %arg2 : !pdl.range<value>
      %2 = pdl_interp.get_value_type of %1 : !pdl.range<type>
      %3 = pdl_interp.create_operation "arith.cmpi"(%arg0, %arg1 : !pdl.value, !pdl.value)  {"predicate" = %0} -> (%2 : !pdl.range<type>)
      %4 = pdl_interp.get_results of %3 : !pdl.range<value>
      pdl_interp.replace %arg2 with (%4 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_14(%arg0: !pdl.value, %arg1: !pdl.value, %arg2: !pdl.operation) {
      %0 = pdl_interp.inferred_types
      %1 = pdl_interp.create_operation "arith.andi"(%arg0, %arg1 : !pdl.value, !pdl.value)  -> (%0 : !pdl.range<type>)
      %2 = pdl_interp.get_results of %1 : !pdl.range<value>
      %3 = pdl_interp.get_results of %arg2 : !pdl.range<value>
      %4 = pdl_interp.get_value_type of %3 : !pdl.range<type>
      %5 = pdl_interp.create_operation "arith.extui"(%2 : !pdl.range<value>)  -> (%4 : !pdl.range<type>)
      %6 = pdl_interp.get_results of %5 : !pdl.range<value>
      pdl_interp.replace %arg2 with (%6 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_15(%arg0: !pdl.value, %arg1: !pdl.value, %arg2: !pdl.operation) {
      %0 = pdl_interp.inferred_types
      %1 = pdl_interp.create_operation "arith.andi"(%arg0, %arg1 : !pdl.value, !pdl.value)  -> (%0 : !pdl.range<type>)
      %2 = pdl_interp.get_results of %1 : !pdl.range<value>
      %3 = pdl_interp.get_results of %arg2 : !pdl.range<value>
      %4 = pdl_interp.get_value_type of %3 : !pdl.range<type>
      %5 = pdl_interp.create_operation "arith.extsi"(%2 : !pdl.range<value>)  -> (%4 : !pdl.range<type>)
      %6 = pdl_interp.get_results of %5 : !pdl.range<value>
      pdl_interp.replace %arg2 with (%6 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_16(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":46:59)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":47:33)
      %2 = pdl_interp.apply_rewrite "AddIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.addi"(%arg0, %5 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_17(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":62:48)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":63:33)
      %2 = pdl_interp.apply_rewrite "AddIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.subi"(%5, %arg0 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
    pdl_interp.func @pdl_generated_rewriter_18(%arg0: !pdl.value, %arg1: !pdl.operation) {
      %0 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":54:59)
      %1 = pdl_interp.create_attribute loc("/home/river/llvm-project/mlir/lib/Dialect/Arithmetic/IR/ArithmeticCanonicalization.pdll":55:33)
      %2 = pdl_interp.apply_rewrite "SubIntAttrs"(%0, %1 : !pdl.attribute, !pdl.attribute) : !pdl.attribute
      %3 = pdl_interp.inferred_types
      %4 = pdl_interp.create_operation "arith.constant"  {"value" = %2} -> (%3 : !pdl.range<type>)
      %5 = pdl_interp.get_result 0 of %4
      %6 = pdl_interp.get_results of %arg1 : !pdl.range<value>
      %7 = pdl_interp.get_value_type of %6 : !pdl.range<type>
      %8 = pdl_interp.create_operation "arith.addi"(%arg0, %5 : !pdl.value, !pdl.value)  -> (%7 : !pdl.range<type>)
      %9 = pdl_interp.get_results of %8 : !pdl.range<value>
      pdl_interp.replace %arg1 with (%9 : !pdl.range<value>)
      pdl_interp.finalize
    }
  }
}

module {
  func @select_same_val(%arg0: i1, %arg1: i64) -> i64 {
    return %arg1 : i64
  }
  func @select_cmp_eq_select(%arg0: i64, %arg1: i64) -> i64 {
    return %arg1 : i64
  }
  func @select_cmp_ne_select(%arg0: i64, %arg1: i64) -> i64 {
    return %arg0 : i64
  }
  func @select_extui(%arg0: i1) -> i64 {
    %0 = arith.extui %arg0 : i1 to i64
    return %0 : i64
  }
  func @select_extui2(%arg0: i1) -> i64 {
    %true = arith.constant true
    %0 = arith.xori %arg0, %true : i1
    %1 = arith.extui %0 : i1 to i64
    return %1 : i64
  }
  func @select_extui_i1(%arg0: i1) -> i1 {
    return %arg0 : i1
  }
  func @selToNot(%arg0: i1) -> i1 {
    %true = arith.constant true
    %0 = arith.xori %arg0, %true : i1
    return %0 : i1
  }
  func @selToArith(%arg0: i1, %arg1: i1, %arg2: i1) -> i1 {
    %true = arith.constant true
    %0 = arith.xori %arg0, %true : i1
    %1 = arith.andi %arg0, %arg1 : i1
    %2 = arith.andi %0, %arg2 : i1
    %3 = arith.ori %1, %2 : i1
    return %3 : i1
  }
  func @cmpi_equal_operands(%arg0: i64) -> (i1, i1, i1, i1, i1, i1, i1, i1, i1, i1) {
    %false = arith.constant false
    %true = arith.constant true
    return %true, %true, %true, %true, %true, %false, %false, %false, %false, %false : i1, i1, i1, i1, i1, i1, i1, i1, i1, i1
  }
  func @cmpi_equal_vector_operands(%arg0: vector<1x8xi64>) -> (vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>) {
    %cst = arith.constant dense<false> : vector<1x8xi1>
    %cst_0 = arith.constant dense<true> : vector<1x8xi1>
    return %cst_0, %cst_0, %cst_0, %cst_0, %cst_0, %cst, %cst, %cst, %cst, %cst : vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>, vector<1x8xi1>
  }
  func @cmpOfExtSI(%arg0: i1) -> i1 {
    return %arg0 : i1
  }
  func @cmpOfExtUI(%arg0: i1) -> i1 {
    return %arg0 : i1
  }
  func @extSIOfExtUI(%arg0: i1) -> i64 {
    %0 = arith.extui %arg0 : i1 to i64
    return %0 : i64
  }
  func @extUIOfExtUI(%arg0: i1) -> i64 {
    %0 = arith.extui %arg0 : i1 to i64
    return %0 : i64
  }
  func @extSIOfExtSI(%arg0: i1) -> i64 {
    %0 = arith.extsi %arg0 : i1 to i64
    return %0 : i64
  }
  func @cmpIExtSINE(%arg0: i8, %arg1: i8) -> i1 {
    %0 = arith.extsi %arg0 : i8 to i64
    %1 = arith.extsi %arg1 : i8 to i64
    %2 = arith.cmpi ne, %0, %1 : i64
    return %2 : i1
  }
  func @cmpIExtSIEQ(%arg0: i8, %arg1: i8) -> i1 {
    %0 = arith.extsi %arg0 : i8 to i64
    %1 = arith.extsi %arg1 : i8 to i64
    %2 = arith.cmpi eq, %0, %1 : i64
    return %2 : i1
  }
  func @cmpIExtUINE(%arg0: i8, %arg1: i8) -> i1 {
    %0 = arith.extui %arg0 : i8 to i64
    %1 = arith.extui %arg1 : i8 to i64
    %2 = arith.cmpi ne, %0, %1 : i64
    return %2 : i1
  }
  func @cmpIExtUIEQ(%arg0: i8, %arg1: i8) -> i1 {
    %0 = arith.extui %arg0 : i8 to i64
    %1 = arith.extui %arg1 : i8 to i64
    %2 = arith.cmpi eq, %0, %1 : i64
    return %2 : i1
  }
  func @andOfExtSI(%arg0: i8, %arg1: i8) -> i64 {
    %0 = arith.andi %arg0, %arg1 : i8
    %1 = arith.extsi %0 : i8 to i64
    return %1 : i64
  }
  func @andOfExtUI(%arg0: i8, %arg1: i8) -> i64 {
    %0 = arith.andi %arg0, %arg1 : i8
    %1 = arith.extui %0 : i8 to i64
    return %1 : i64
  }
  func @orOfExtSI(%arg0: i8, %arg1: i8) -> i64 {
    %0 = arith.ori %arg0, %arg1 : i8
    %1 = arith.extsi %0 : i8 to i64
    return %1 : i64
  }
  func @orOfExtUI(%arg0: i8, %arg1: i8) -> i64 {
    %0 = arith.ori %arg0, %arg1 : i8
    %1 = arith.extui %0 : i8 to i64
    return %1 : i64
  }
  func @indexCastOfSignExtend(%arg0: i8) -> index {
    %0 = arith.index_cast %arg0 : i8 to index
    return %0 : index
  }
  func @signExtendConstant() -> i16 {
    %c-2_i16 = arith.constant -2 : i16
    return %c-2_i16 : i16
  }
  func @signExtendConstantSplat() -> vector<4xi16> {
    %cst = arith.constant dense<-2> : vector<4xi16>
    return %cst : vector<4xi16>
  }
  func @signExtendConstantVector() -> vector<4xi16> {
    %cst = arith.constant dense<[1, 3, 5, 7]> : vector<4xi16>
    return %cst : vector<4xi16>
  }
  func @unsignedExtendConstant() -> i16 {
    %c2_i16 = arith.constant 2 : i16
    return %c2_i16 : i16
  }
  func @unsignedExtendConstantSplat() -> vector<4xi16> {
    %cst = arith.constant dense<2> : vector<4xi16>
    return %cst : vector<4xi16>
  }
  func @unsignedExtendConstantVector() -> vector<4xi16> {
    %cst = arith.constant dense<[1, 3, 5, 7]> : vector<4xi16>
    return %cst : vector<4xi16>
  }
  func @truncConstant(%arg0: i8) -> i16 {
    %c-2_i16 = arith.constant -2 : i16
    return %c-2_i16 : i16
  }
  func @truncConstantSplat() -> vector<4xi8> {
    %cst = arith.constant dense<-2> : vector<4xi8>
    return %cst : vector<4xi8>
  }
  func @truncConstantVector() -> vector<4xi8> {
    %cst = arith.constant dense<[1, 3, 5, 7]> : vector<4xi8>
    return %cst : vector<4xi8>
  }
  func @truncTrunc(%arg0: i64) -> i8 {
    %0 = arith.trunci %arg0 : i64 to i8
    return %0 : i8
  }
  func @truncFPConstant() -> bf16 {
    %cst = arith.constant 1.000000e+00 : bf16
    return %cst : bf16
  }
  func @truncFPConstantRounding() -> bf16 {
    %cst = arith.constant 1.444000e+25 : f32
    %0 = arith.truncf %cst : f32 to bf16
    return %0 : bf16
  }
  func @tripleAddAdd(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.addi %arg0, %c17 : index
    %1 = arith.addi %0, %c42 : index
    return %1 : index
  }
  func @tripleAddSub0(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.subi %c17, %arg0 : index
    %1 = arith.addi %0, %c42 : index
    return %1 : index
  }
  func @tripleAddSub1(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.subi %arg0, %c17 : index
    %1 = arith.addi %0, %c42 : index
    return %1 : index
  }
  func @tripleSubAdd0(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.addi %arg0, %c17 : index
    %1 = arith.subi %c42, %0 : index
    return %1 : index
  }
  func @tripleSubAdd1(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.addi %arg0, %c17 : index
    %1 = arith.subi %0, %c42 : index
    return %1 : index
  }
  func @tripleSubSub0(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.subi %c17, %arg0 : index
    %1 = arith.subi %c42, %0 : index
    return %1 : index
  }
  func @tripleSubSub1(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.subi %c17, %arg0 : index
    %1 = arith.subi %0, %c42 : index
    return %1 : index
  }
  func @tripleSubSub2(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.subi %arg0, %c17 : index
    %1 = arith.subi %c42, %0 : index
    return %1 : index
  }
  func @tripleSubSub3(%arg0: index) -> index {
    %c42 = arith.constant 42 : index
    %c17 = arith.constant 17 : index
    %0 = arith.subi %arg0, %c17 : index
    %1 = arith.subi %0, %c42 : index
    return %1 : index
  }
  func @doubleAddSub1(%arg0: index, %arg1: index) -> index {
    return %arg0 : index
  }
  func @doubleAddSub2(%arg0: index, %arg1: index) -> index {
    return %arg0 : index
  }
  func @notCmpEQ(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi eq, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpEQ2(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi eq, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpNE(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi ne, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpSLT(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi slt, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpSLE(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi sle, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpSGT(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi sgt, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpSGE(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi sge, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpULT(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi ult, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpULE(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi ule, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpUGT(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi ugt, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @notCmpUGE(%arg0: i8, %arg1: i8) -> i1 {
    %true = arith.constant true
    %0 = arith.cmpi uge, %arg0, %arg1 : i8
    %1 = arith.xori %0, %true : i1
    return %1 : i1
  }
  func @xorxor(%arg0: i1) -> i1 {
    return %arg0 : i1
  }
  func @bitcastSameType(%arg0: f32) -> f32 {
    return %arg0 : f32
  }
  func @bitcastConstantFPtoI() -> i32 {
    %c0_i32 = arith.constant 0 : i32
    return %c0_i32 : i32
  }
  func @bitcastConstantItoFP() -> f32 {
    %cst = arith.constant 0.000000e+00 : f32
    return %cst : f32
  }
  func @bitcastConstantFPtoFP() -> f16 {
    %cst = arith.constant 0.000000e+00 : f16
    return %cst : f16
  }
  func @bitcastConstantVecFPtoI() -> vector<3xf32> {
    %cst = arith.constant dense<0.000000e+00> : vector<3xf32>
    return %cst : vector<3xf32>
  }
  func @bitcastConstantVecItoFP() -> vector<3xi32> {
    %cst = arith.constant dense<0> : vector<3xi32>
    return %cst : vector<3xi32>
  }
  func @bitcastConstantVecFPtoFP() -> vector<3xbf16> {
    %cst = arith.constant dense<0.000000e+00> : vector<3xbf16>
    return %cst : vector<3xbf16>
  }
  func @bitcastBackAndForth(%arg0: i32) -> i32 {
    return %arg0 : i32
  }
  func @bitcastOfBitcast(%arg0: i16) -> i16 {
    return %arg0 : i16
  }
  func @test_maxsi(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c127_i8 = arith.constant 127 : i8
    %0 = arith.maxsi %arg0, %c42_i8 : i8
    return %arg0, %c127_i8, %arg0, %0 : i8, i8, i8, i8
  }
  func @test_maxsi2(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c127_i8 = arith.constant 127 : i8
    %0 = arith.maxsi %arg0, %c42_i8 : i8
    return %arg0, %c127_i8, %arg0, %0 : i8, i8, i8, i8
  }
  func @test_maxui(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c-1_i8 = arith.constant -1 : i8
    %0 = arith.maxui %arg0, %c42_i8 : i8
    return %arg0, %c-1_i8, %arg0, %0 : i8, i8, i8, i8
  }
  func @test_maxui2(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c-1_i8 = arith.constant -1 : i8
    %0 = arith.maxui %arg0, %c42_i8 : i8
    return %arg0, %c-1_i8, %arg0, %0 : i8, i8, i8, i8
  }
  func @test_minsi(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c-128_i8 = arith.constant -128 : i8
    %0 = arith.minsi %arg0, %c42_i8 : i8
    return %arg0, %arg0, %c-128_i8, %0 : i8, i8, i8, i8
  }
  func @test_minsi2(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c-128_i8 = arith.constant -128 : i8
    %0 = arith.minsi %arg0, %c42_i8 : i8
    return %arg0, %arg0, %c-128_i8, %0 : i8, i8, i8, i8
  }
  func @test_minui(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c0_i8 = arith.constant 0 : i8
    %0 = arith.minui %arg0, %c42_i8 : i8
    return %arg0, %arg0, %c0_i8, %0 : i8, i8, i8, i8
  }
  func @test_minui2(%arg0: i8) -> (i8, i8, i8, i8) {
    %c42_i8 = arith.constant 42 : i8
    %c0_i8 = arith.constant 0 : i8
    %0 = arith.minui %arg0, %c42_i8 : i8
    return %arg0, %arg0, %c0_i8, %0 : i8, i8, i8, i8
  }
  func @test_minf(%arg0: f32) -> (f32, f32, f32) {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = arith.minf %arg0, %cst : f32
    return %0, %arg0, %arg0 : f32, f32, f32
  }
  func @test_maxf(%arg0: f32) -> (f32, f32, f32) {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = arith.maxf %arg0, %cst : f32
    return %0, %arg0, %arg0 : f32, f32, f32
  }
  func @test_addf(%arg0: f32) -> (f32, f32, f32, f32) {
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %0 = arith.addf %arg0, %cst_0 : f32
    return %0, %arg0, %arg0, %cst : f32, f32, f32, f32
  }
  func @test_subf(%arg0: f16) -> (f16, f16, f16) {
    %cst = arith.constant -1.000000e+00 : f16
    %cst_0 = arith.constant -0.000000e+00 : f16
    %0 = arith.subf %arg0, %cst_0 : f16
    return %arg0, %0, %cst : f16, f16, f16
  }
  func @test_mulf(%arg0: f32) -> (f32, f32, f32, f32) {
    %cst = arith.constant 4.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %0 = arith.mulf %arg0, %cst_0 : f32
    return %0, %arg0, %arg0, %cst : f32, f32, f32, f32
  }
  func @test_divf(%arg0: f64) -> (f64, f64) {
    %cst = arith.constant 5.000000e-01 : f64
    return %arg0, %cst : f64, f64
  }
  func @test_cmpf(%arg0: f32) -> (i1, i1, i1, i1) {
    %true = arith.constant true
    %false = arith.constant false
    return %false, %false, %true, %true : i1, i1, i1, i1
  }
  func @constant_FPtoUI() -> i32 {
    %c2_i32 = arith.constant 2 : i32
    return %c2_i32 : i32
  }
  func @constant_FPtoUI_splat() -> vector<4xi32> {
    %cst = arith.constant dense<2> : vector<4xi32>
    return %cst : vector<4xi32>
  }
  func @constant_FPtoUI_vector() -> vector<4xi32> {
    %cst = arith.constant dense<[1, 3, 5, 7]> : vector<4xi32>
    return %cst : vector<4xi32>
  }
  func @invalid_constant_FPtoUI() -> i32 {
    %cst = arith.constant -2.000000e+00 : f32
    %0 = arith.fptoui %cst : f32 to i32
    return %0 : i32
  }
  func @constant_FPtoSI() -> i32 {
    %c-2_i32 = arith.constant -2 : i32
    return %c-2_i32 : i32
  }
  func @constant_FPtoSI_splat() -> vector<4xi32> {
    %cst = arith.constant dense<-2> : vector<4xi32>
    return %cst : vector<4xi32>
  }
  func @constant_FPtoSI_vector() -> vector<4xi32> {
    %cst = arith.constant dense<[-1, -3, -5, -7]> : vector<4xi32>
    return %cst : vector<4xi32>
  }
  func @invalid_constant_FPtoSI() -> i8 {
    %cst = arith.constant 2.000000e+10 : f32
    %0 = arith.fptosi %cst : f32 to i8
    return %0 : i8
  }
  func @constant_SItoFP() -> f32 {
    %cst = arith.constant -2.000000e+00 : f32
    return %cst : f32
  }
  func @constant_SItoFP_splat() -> vector<4xf32> {
    %cst = arith.constant dense<2.000000e+00> : vector<4xf32>
    return %cst : vector<4xf32>
  }
  func @constant_SItoFP_vector() -> vector<4xf32> {
    %cst = arith.constant dense<[1.000000e+00, 3.000000e+00, 5.000000e+00, 7.000000e+00]> : vector<4xf32>
    return %cst : vector<4xf32>
  }
  func @constant_UItoFP() -> f32 {
    %cst = arith.constant 2.000000e+00 : f32
    return %cst : f32
  }
  func @constant_UItoFP_splat() -> vector<4xf32> {
    %cst = arith.constant dense<2.000000e+00> : vector<4xf32>
    return %cst : vector<4xf32>
  }
  func @constant_UItoFP_vector() -> vector<4xf32> {
    %cst = arith.constant dense<[1.000000e+00, 3.000000e+00, 5.000000e+00, 7.000000e+00]> : vector<4xf32>
    return %cst : vector<4xf32>
  }
  func @test1(%arg0: i32) -> i1 {
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.cmpi ule, %arg0, %c0_i32 : i32
    return %0 : i1
  }
  func @test2(%arg0: i32) -> i1 {
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.cmpi ult, %arg0, %c0_i32 : i32
    return %0 : i1
  }
  func @test3(%arg0: i32) -> i1 {
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.cmpi uge, %arg0, %c0_i32 : i32
    return %0 : i1
  }
  func @test4(%arg0: i32) -> i1 {
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.cmpi ugt, %arg0, %c0_i32 : i32
    return %0 : i1
  }
  func @test5(%arg0: i32) -> i1 {
    %true = arith.constant true
    return %true : i1
  }
  func @test6(%arg0: i32) -> i1 {
    %false = arith.constant false
    return %false : i1
  }
  func @test7(%arg0: i32) -> i1 {
    %c3_i32 = arith.constant 3 : i32
    %0 = arith.cmpi ugt, %arg0, %c3_i32 : i32
    return %0 : i1
  }
  func @foldShl() -> i64 {
    %c4294967296_i64 = arith.constant 4294967296 : i64
    return %c4294967296_i64 : i64
  }
  func @nofoldShl() -> i64 {
    %c132_i64 = arith.constant 132 : i64
    %c1_i64 = arith.constant 1 : i64
    %0 = arith.shli %c1_i64, %c132_i64 : i64
    return %0 : i64
  }
  func @nofoldShl2() -> i64 {
    %c-32_i64 = arith.constant -32 : i64
    %c1_i64 = arith.constant 1 : i64
    %0 = arith.shli %c1_i64, %c-32_i64 : i64
    return %0 : i64
  }
  func @foldShru() -> i64 {
    %c2_i64 = arith.constant 2 : i64
    return %c2_i64 : i64
  }
  func @foldShru2() -> i64 {
    %c9223372036854775807_i64 = arith.constant 9223372036854775807 : i64
    return %c9223372036854775807_i64 : i64
  }
  func @nofoldShru() -> i64 {
    %c132_i64 = arith.constant 132 : i64
    %c8_i64 = arith.constant 8 : i64
    %0 = arith.shrui %c8_i64, %c132_i64 : i64
    return %0 : i64
  }
  func @nofoldShru2() -> i64 {
    %c-32_i64 = arith.constant -32 : i64
    %c8_i64 = arith.constant 8 : i64
    %0 = arith.shrui %c8_i64, %c-32_i64 : i64
    return %0 : i64
  }
  func @foldShrs() -> i64 {
    %c2_i64 = arith.constant 2 : i64
    return %c2_i64 : i64
  }
  func @foldShrs2() -> i64 {
    %c-1_i64 = arith.constant -1 : i64
    return %c-1_i64 : i64
  }
  func @nofoldShrs() -> i64 {
    %c132_i64 = arith.constant 132 : i64
    %c8_i64 = arith.constant 8 : i64
    %0 = arith.shrsi %c8_i64, %c132_i64 : i64
    return %0 : i64
  }
  func @nofoldShrs2() -> i64 {
    %c-32_i64 = arith.constant -32 : i64
    %c8_i64 = arith.constant 8 : i64
    %0 = arith.shrsi %c8_i64, %c-32_i64 : i64
    return %0 : i64
  }
  func @test_negf() -> f32 {
    %cst = arith.constant -2.000000e+00 : f32
    return %cst : f32
  }
  func @test_remui() -> vector<4xi32> {
    %cst = arith.constant dense<[0, 0, 4, 2]> : vector<4xi32>
    return %cst : vector<4xi32>
  }
  func @test_remui_1(%arg0: vector<4xi32>) -> vector<4xi32> {
    %cst = arith.constant dense<0> : vector<4xi32>
    return %cst : vector<4xi32>
  }
  func @test_remsi() -> vector<4xi32> {
    %cst = arith.constant dense<[0, 0, 4, 2]> : vector<4xi32>
    return %cst : vector<4xi32>
  }
  func @test_remsi_1(%arg0: vector<4xi32>) -> vector<4xi32> {
    %cst = arith.constant dense<0> : vector<4xi32>
    return %cst : vector<4xi32>
  }
}

