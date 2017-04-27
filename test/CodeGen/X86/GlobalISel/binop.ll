; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-linux-gnu                                  -global-isel < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=SSE
; RUN: llc -mtriple=x86_64-linux-gnu -mattr=+avx                      -global-isel < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=ALL_AVX --check-prefix=AVX
; RUN: llc -mtriple=x86_64-linux-gnu -mattr=+avx512f                  -global-isel < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=ALL_AVX --check-prefix=AVX512F
; RUN: llc -mtriple=x86_64-linux-gnu -mattr=+avx512f -mattr=+avx512vl -global-isel < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=ALL_AVX --check-prefix=AVX512VL

define i64 @test_add_i64(i64 %arg1, i64 %arg2) {
; ALL-LABEL: test_add_i64:
; ALL:       # BB#0:
; ALL-NEXT:    leaq (%rsi,%rdi), %rax
; ALL-NEXT:    retq
  %ret = add i64 %arg1, %arg2
  ret i64 %ret
}

define i32 @test_add_i32(i32 %arg1, i32 %arg2) {
; ALL-LABEL: test_add_i32:
; ALL:       # BB#0:
; ALL-NEXT:    # kill: %EDI<def> %EDI<kill> %RDI<def>
; ALL-NEXT:    # kill: %ESI<def> %ESI<kill> %RSI<def>
; ALL-NEXT:    leal (%rsi,%rdi), %eax
; ALL-NEXT:    retq
  %ret = add i32 %arg1, %arg2
  ret i32 %ret
}

define i16 @test_add_i16(i16 %arg1, i16 %arg2) {
; ALL-LABEL: test_add_i16:
; ALL:       # BB#0:
; ALL-NEXT:    # kill: %DI<def> %DI<kill> %RDI<def>
; ALL-NEXT:    # kill: %SI<def> %SI<kill> %RSI<def>
; ALL-NEXT:    leal (%rsi,%rdi), %eax
; ALL-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; ALL-NEXT:    retq
  %ret = add i16 %arg1, %arg2
  ret i16 %ret
}

define i8 @test_add_i8(i8 %arg1, i8 %arg2) {
; ALL-LABEL: test_add_i8:
; ALL:       # BB#0:
; ALL-NEXT:    addb %dil, %sil
; ALL-NEXT:    movl %esi, %eax
; ALL-NEXT:    retq
  %ret = add i8 %arg1, %arg2
  ret i8 %ret
}

define i64 @test_sub_i64(i64 %arg1, i64 %arg2) {
; ALL-LABEL: test_sub_i64:
; ALL:       # BB#0:
; ALL-NEXT:    subq %rsi, %rdi
; ALL-NEXT:    movq %rdi, %rax
; ALL-NEXT:    retq
  %ret = sub i64 %arg1, %arg2
  ret i64 %ret
}

define i32 @test_sub_i32(i32 %arg1, i32 %arg2) {
; ALL-LABEL: test_sub_i32:
; ALL:       # BB#0:
; ALL-NEXT:    subl %esi, %edi
; ALL-NEXT:    movl %edi, %eax
; ALL-NEXT:    retq
  %ret = sub i32 %arg1, %arg2
  ret i32 %ret
}

define float @test_add_float(float %arg1, float %arg2) {
; SSE-LABEL: test_add_float:
; SSE:       # BB#0:
; SSE-NEXT:    addss %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_add_float:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = fadd float %arg1, %arg2
  ret float %ret
}

define double @test_add_double(double %arg1, double %arg2) {
; SSE-LABEL: test_add_double:
; SSE:       # BB#0:
; SSE-NEXT:    addsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_add_double:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = fadd double %arg1, %arg2
  ret double %ret
}

define float @test_sub_float(float %arg1, float %arg2) {
; SSE-LABEL: test_sub_float:
; SSE:       # BB#0:
; SSE-NEXT:    subss %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_sub_float:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = fsub float %arg1, %arg2
  ret float %ret
}

define double @test_sub_double(double %arg1, double %arg2) {
; SSE-LABEL: test_sub_double:
; SSE:       # BB#0:
; SSE-NEXT:    subsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_sub_double:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = fsub double %arg1, %arg2
  ret double %ret
}

define <4 x i32>  @test_add_v4i32(<4 x i32> %arg1, <4 x i32>  %arg2) {
; SSE-LABEL: test_add_v4i32:
; SSE:       # BB#0:
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_add_v4i32:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = add <4 x i32>  %arg1, %arg2
  ret <4 x i32>  %ret
}

define <4 x i32>  @test_sub_v4i32(<4 x i32> %arg1, <4 x i32>  %arg2) {
; SSE-LABEL: test_sub_v4i32:
; SSE:       # BB#0:
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_sub_v4i32:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = sub <4 x i32>  %arg1, %arg2
  ret <4 x i32>  %ret
}

define <4 x float>  @test_add_v4f32(<4 x float> %arg1, <4 x float>  %arg2) {
; SSE-LABEL: test_add_v4f32:
; SSE:       # BB#0:
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_add_v4f32:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = fadd <4 x float>  %arg1, %arg2
  ret <4 x float>  %ret
}

define <4 x float>  @test_sub_v4f32(<4 x float> %arg1, <4 x float>  %arg2) {
; SSE-LABEL: test_sub_v4f32:
; SSE:       # BB#0:
; SSE-NEXT:    subps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_sub_v4f32:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vsubps %xmm1, %xmm0, %xmm0
; ALL_AVX-NEXT:    retq
  %ret = fsub <4 x float>  %arg1, %arg2
  ret <4 x float>  %ret
}

define i32  @test_copy_float(float %val) {
; SSE-LABEL: test_copy_float:
; SSE:       # BB#0:
; SSE-NEXT:    movd %xmm0, %eax
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_copy_float:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vmovd %xmm0, %eax
; ALL_AVX-NEXT:    retq
  %r = bitcast float %val to i32
  ret i32 %r
}

define float  @test_copy_i32(i32 %val) {
; SSE-LABEL: test_copy_i32:
; SSE:       # BB#0:
; SSE-NEXT:    movd %edi, %xmm0
; SSE-NEXT:    retq
;
; ALL_AVX-LABEL: test_copy_i32:
; ALL_AVX:       # BB#0:
; ALL_AVX-NEXT:    vmovd %edi, %xmm0
; ALL_AVX-NEXT:    retq
  %r = bitcast i32 %val to float
  ret float %r
}

