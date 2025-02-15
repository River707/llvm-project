; RUN: opt -S -dxil-op-lower -mtriple=dxil-pc-shadermodel6.3-library %s | FileCheck %s

; Make sure dxil operation function calls for log2 are generated for float and half.

define noundef float @log2_float(float noundef %a) #0 {
entry:
; CHECK:call float @dx.op.unary.f32(i32 23, float %{{.*}}) #[[#ATTR:]]
  %elt.log2 = call float @llvm.log2.f32(float %a)
  ret float %elt.log2
}

define noundef half @log2_half(half noundef %a) #0 {
entry:
; CHECK:call half @dx.op.unary.f16(i32 23, half %{{.*}}) #[[#ATTR]]
  %elt.log2 = call half @llvm.log2.f16(half %a)
  ret half %elt.log2
}

; CHECK: attributes #[[#ATTR]] = {{{.*}} memory(none) {{.*}}}

declare half @llvm.log2.f16(half)
declare float @llvm.log2.f32(float)
