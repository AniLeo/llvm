; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefix=SSE --check-prefix=SSE4A
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=VLX

; Make sure that we generate non-temporal stores for the test cases below.
; We use xorps for zeroing, so domain information isn't available anymore.

; Scalar versions (zeroing means we can this even for fp types).

define void @test_zero_f32(ptr %dst) {
; SSE-LABEL: test_zero_f32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    movntil %eax, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    movntil %eax, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_f32:
; VLX:       # %bb.0:
; VLX-NEXT:    xorl %eax, %eax
; VLX-NEXT:    movntil %eax, (%rdi)
; VLX-NEXT:    retq
  store float zeroinitializer, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_i32(ptr %dst) {
; SSE-LABEL: test_zero_i32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    movntil %eax, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_i32:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    movntil %eax, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_i32:
; VLX:       # %bb.0:
; VLX-NEXT:    xorl %eax, %eax
; VLX-NEXT:    movntil %eax, (%rdi)
; VLX-NEXT:    retq
  store i32 zeroinitializer, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_f64(ptr %dst) {
; SSE-LABEL: test_zero_f64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    movntiq %rax, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    movntiq %rax, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_f64:
; VLX:       # %bb.0:
; VLX-NEXT:    xorl %eax, %eax
; VLX-NEXT:    movntiq %rax, (%rdi)
; VLX-NEXT:    retq
  store double zeroinitializer, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_zero_i64(ptr %dst) {
; SSE-LABEL: test_zero_i64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    movntiq %rax, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_i64:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    movntiq %rax, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_i64:
; VLX:       # %bb.0:
; VLX-NEXT:    xorl %eax, %eax
; VLX-NEXT:    movntiq %rax, (%rdi)
; VLX-NEXT:    retq
  store i64 zeroinitializer, ptr %dst, align 1, !nontemporal !1
  ret void
}

; And now XMM versions.

define void @test_zero_v4f32(ptr %dst) {
; SSE-LABEL: test_zero_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v4f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <4 x float> zeroinitializer, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v4i32(ptr %dst) {
; SSE-LABEL: test_zero_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v4i32:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <4 x i32> zeroinitializer, ptr %dst, align 16, !nontemporal !1
  store <4 x i32> zeroinitializer, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v2f64(ptr %dst) {
; SSE-LABEL: test_zero_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v2f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <2 x double> zeroinitializer, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v2i64(ptr %dst) {
; SSE-LABEL: test_zero_v2i64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v2i64:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <2 x i64> zeroinitializer, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v8i16(ptr %dst) {
; SSE-LABEL: test_zero_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v8i16:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <8 x i16> zeroinitializer, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_zero_v16i8(ptr %dst) {
; SSE-LABEL: test_zero_v16i8:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v16i8:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <16 x i8> zeroinitializer, ptr %dst, align 16, !nontemporal !1
  ret void
}

; And now YMM versions.

define void @test_zero_v8f32(ptr %dst) {
; SSE-LABEL: test_zero_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v8f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <8 x float> zeroinitializer, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v8i32(ptr %dst) {
; SSE-LABEL: test_zero_v8i32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v8i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v8i32:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <8 x i32> zeroinitializer, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v4f64(ptr %dst) {
; SSE-LABEL: test_zero_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v4f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <4 x double> zeroinitializer, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v4i64(ptr %dst) {
; SSE-LABEL: test_zero_v4i64:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v4i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v4i64:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <4 x i64> zeroinitializer, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v16i16(ptr %dst) {
; SSE-LABEL: test_zero_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v16i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v16i16:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <16 x i16> zeroinitializer, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_zero_v32i8(ptr %dst) {
; SSE-LABEL: test_zero_v32i8:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    movntps %xmm0, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_zero_v32i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_zero_v32i8:
; VLX:       # %bb.0:
; VLX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <32 x i8> zeroinitializer, ptr %dst, align 32, !nontemporal !1
  ret void
}


; Check that we also handle arguments.  Here the type survives longer.

; Scalar versions.

define void @test_arg_f32(float %arg, ptr %dst) {
; SSE2-LABEL: test_arg_f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss %xmm0, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_arg_f32:
; SSE4A:       # %bb.0:
; SSE4A-NEXT:    movntss %xmm0, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_arg_f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movss %xmm0, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_arg_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovss %xmm0, (%rdi)
; VLX-NEXT:    retq
  store float %arg, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_arg_i32(i32 %arg, ptr %dst) {
; SSE-LABEL: test_arg_i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movntil %edi, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_i32:
; AVX:       # %bb.0:
; AVX-NEXT:    movntil %edi, (%rsi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_i32:
; VLX:       # %bb.0:
; VLX-NEXT:    movntil %edi, (%rsi)
; VLX-NEXT:    retq
  store i32 %arg, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_arg_f64(double %arg, ptr %dst) {
; SSE2-LABEL: test_arg_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd %xmm0, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_arg_f64:
; SSE4A:       # %bb.0:
; SSE4A-NEXT:    movntsd %xmm0, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_arg_f64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movsd %xmm0, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_arg_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovsd %xmm0, (%rdi)
; VLX-NEXT:    retq
  store double %arg, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_arg_i64(i64 %arg, ptr %dst) {
; SSE-LABEL: test_arg_i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movntiq %rdi, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_i64:
; AVX:       # %bb.0:
; AVX-NEXT:    movntiq %rdi, (%rsi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_i64:
; VLX:       # %bb.0:
; VLX-NEXT:    movntiq %rdi, (%rsi)
; VLX-NEXT:    retq
  store i64 %arg, ptr %dst, align 1, !nontemporal !1
  ret void
}

; Extract versions

define void @test_extract_f32(<4 x float> %arg, ptr %dst) {
; SSE2-LABEL: test_extract_f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    movss %xmm0, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_extract_f32:
; SSE4A:       # %bb.0:
; SSE4A-NEXT:    movshdup {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE4A-NEXT:    movntss %xmm0, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_extract_f32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    extractps $1, %xmm0, %eax
; SSE41-NEXT:    movntil %eax, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_extract_f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractps $1, %xmm0, %eax
; AVX-NEXT:    movntil %eax, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_extract_f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vextractps $1, %xmm0, %eax
; VLX-NEXT:    movntil %eax, (%rdi)
; VLX-NEXT:    retq
  %1 = extractelement <4 x float> %arg, i32 1
  store float %1, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_extract_i32(<4 x i32> %arg, ptr %dst) {
; SSE2-LABEL: test_extract_i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    movntil %eax, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_extract_i32:
; SSE4A:       # %bb.0:
; SSE4A-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE4A-NEXT:    movd %xmm0, %eax
; SSE4A-NEXT:    movntil %eax, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_extract_i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    extractps $1, %xmm0, %eax
; SSE41-NEXT:    movntil %eax, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_extract_i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractps $1, %xmm0, %eax
; AVX-NEXT:    movntil %eax, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_extract_i32:
; VLX:       # %bb.0:
; VLX-NEXT:    vextractps $1, %xmm0, %eax
; VLX-NEXT:    movntil %eax, (%rdi)
; VLX-NEXT:    retq
  %1 = extractelement <4 x i32> %arg, i32 1
  store i32 %1, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_extract_f64(<2 x double> %arg, ptr %dst) {
; SSE2-LABEL: test_extract_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movhps %xmm0, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_extract_f64:
; SSE4A:       # %bb.0:
; SSE4A-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE4A-NEXT:    movntsd %xmm0, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_extract_f64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movhps %xmm0, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_extract_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovhps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_extract_f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovhps %xmm0, (%rdi)
; VLX-NEXT:    retq
  %1 = extractelement <2 x double> %arg, i32 1
  store double %1, ptr %dst, align 1, !nontemporal !1
  ret void
}

define void @test_extract_i64(<2 x i64> %arg, ptr %dst) {
; SSE2-LABEL: test_extract_i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; SSE2-NEXT:    movq %xmm0, %rax
; SSE2-NEXT:    movntiq %rax, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_extract_i64:
; SSE4A:       # %bb.0:
; SSE4A-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; SSE4A-NEXT:    movq %xmm0, %rax
; SSE4A-NEXT:    movntiq %rax, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_extract_i64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pextrq $1, %xmm0, %rax
; SSE41-NEXT:    movntiq %rax, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_extract_i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrq $1, %xmm0, %rax
; AVX-NEXT:    movntiq %rax, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_extract_i64:
; VLX:       # %bb.0:
; VLX-NEXT:    vpextrq $1, %xmm0, %rax
; VLX-NEXT:    movntiq %rax, (%rdi)
; VLX-NEXT:    retq
  %1 = extractelement <2 x i64> %arg, i32 1
  store i64 %1, ptr %dst, align 1, !nontemporal !1
  ret void
}

; And now XMM versions.

define void @test_arg_v4f32(<4 x float> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v4f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <4 x float> %arg, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_arg_v4i32(<4 x i32> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v4i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v4i32:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <4 x i32> %arg, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_arg_v2f64(<2 x double> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v2f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <2 x double> %arg, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_arg_v2i64(<2 x i64> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v2i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v2i64:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <2 x i64> %arg, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_arg_v8i16(<8 x i16> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v8i16:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <8 x i16> %arg, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_arg_v16i8(<16 x i8> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v16i8:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v16i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v16i8:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  store <16 x i8> %arg, ptr %dst, align 16, !nontemporal !1
  ret void
}

; And now YMM versions.

define void @test_arg_v8f32(<8 x float> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v8f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <8 x float> %arg, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_arg_v8i32(<8 x i32> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v8i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v8i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v8i32:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <8 x i32> %arg, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_arg_v4f64(<4 x double> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v4f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <4 x double> %arg, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_arg_v4i64(<4 x i64> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v4i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v4i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v4i64:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <4 x i64> %arg, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_arg_v16i16(<16 x i16> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v16i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v16i16:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <16 x i16> %arg, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_arg_v32i8(<32 x i8> %arg, ptr %dst) {
; SSE-LABEL: test_arg_v32i8:
; SSE:       # %bb.0:
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_arg_v32i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_arg_v32i8:
; VLX:       # %bb.0:
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  store <32 x i8> %arg, ptr %dst, align 32, !nontemporal !1
  ret void
}


; Now check that if the execution domain is trivially visible, we use it.
; We use an add to make the type survive all the way to the MOVNT.

define void @test_op_v4f32(<4 x float> %a, <4 x float> %b, ptr %dst) {
; SSE-LABEL: test_op_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v4f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    retq
  %r = fadd <4 x float> %a, %b
  store <4 x float> %r, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_op_v4i32(<4 x i32> %a, <4 x i32> %b, ptr %dst) {
; SSE-LABEL: test_op_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v4i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v4i32:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; VLX-NEXT:    vmovntdq %xmm0, (%rdi)
; VLX-NEXT:    retq
  %r = add <4 x i32> %a, %b
  store <4 x i32> %r, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_op_v2f64(<2 x double> %a, <2 x double> %b, ptr %dst) {
; SSE-LABEL: test_op_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    movntpd %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovntpd %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v2f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; VLX-NEXT:    vmovntpd %xmm0, (%rdi)
; VLX-NEXT:    retq
  %r = fadd <2 x double> %a, %b
  store <2 x double> %r, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_op_v2i64(<2 x i64> %a, <2 x i64> %b, ptr %dst) {
; SSE-LABEL: test_op_v2i64:
; SSE:       # %bb.0:
; SSE-NEXT:    paddq %xmm1, %xmm0
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v2i64:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; VLX-NEXT:    vmovntdq %xmm0, (%rdi)
; VLX-NEXT:    retq
  %r = add <2 x i64> %a, %b
  store <2 x i64> %r, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_op_v8i16(<8 x i16> %a, <8 x i16> %b, ptr %dst) {
; SSE-LABEL: test_op_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    paddw %xmm1, %xmm0
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v8i16:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; VLX-NEXT:    vmovntdq %xmm0, (%rdi)
; VLX-NEXT:    retq
  %r = add <8 x i16> %a, %b
  store <8 x i16> %r, ptr %dst, align 16, !nontemporal !1
  ret void
}

define void @test_op_v16i8(<16 x i8> %a, <16 x i8> %b, ptr %dst) {
; SSE-LABEL: test_op_v16i8:
; SSE:       # %bb.0:
; SSE-NEXT:    paddb %xmm1, %xmm0
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v16i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v16i8:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; VLX-NEXT:    vmovntdq %xmm0, (%rdi)
; VLX-NEXT:    retq
  %r = add <16 x i8> %a, %b
  store <16 x i8> %r, ptr %dst, align 16, !nontemporal !1
  ret void
}

; And now YMM versions.

define void @test_op_v8f32(<8 x float> %a, <8 x float> %b, ptr %dst) {
; SSE-LABEL: test_op_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    addps %xmm2, %xmm0
; SSE-NEXT:    addps %xmm3, %xmm1
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v8f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; VLX-NEXT:    vmovntps %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  %r = fadd <8 x float> %a, %b
  store <8 x float> %r, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_op_v8i32(<8 x i32> %a, <8 x i32> %b, ptr %dst) {
; SSE-LABEL: test_op_v8i32:
; SSE:       # %bb.0:
; SSE-NEXT:    paddd %xmm2, %xmm0
; SSE-NEXT:    paddd %xmm3, %xmm1
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_op_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmovntdq %xmm0, 16(%rdi)
; AVX1-NEXT:    vmovntdq %xmm2, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_op_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; VLX-LABEL: test_op_v8i32:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; VLX-NEXT:    vmovntdq %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  %r = add <8 x i32> %a, %b
  store <8 x i32> %r, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_op_v4f64(<4 x double> %a, <4 x double> %b, ptr %dst) {
; SSE-LABEL: test_op_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addpd %xmm2, %xmm0
; SSE-NEXT:    addpd %xmm3, %xmm1
; SSE-NEXT:    movntpd %xmm1, 16(%rdi)
; SSE-NEXT:    movntpd %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_op_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vmovntpd %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_op_v4f64:
; VLX:       # %bb.0:
; VLX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; VLX-NEXT:    vmovntpd %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  %r = fadd <4 x double> %a, %b
  store <4 x double> %r, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_op_v4i64(<4 x i64> %a, <4 x i64> %b, ptr %dst) {
; SSE-LABEL: test_op_v4i64:
; SSE:       # %bb.0:
; SSE-NEXT:    paddq %xmm2, %xmm0
; SSE-NEXT:    paddq %xmm3, %xmm1
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_op_v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpaddq %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmovntdq %xmm0, 16(%rdi)
; AVX1-NEXT:    vmovntdq %xmm2, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_op_v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; VLX-LABEL: test_op_v4i64:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; VLX-NEXT:    vmovntdq %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  %r = add <4 x i64> %a, %b
  store <4 x i64> %r, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_op_v16i16(<16 x i16> %a, <16 x i16> %b, ptr %dst) {
; SSE-LABEL: test_op_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    paddw %xmm2, %xmm0
; SSE-NEXT:    paddw %xmm3, %xmm1
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_op_v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpaddw %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmovntdq %xmm0, 16(%rdi)
; AVX1-NEXT:    vmovntdq %xmm2, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_op_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; VLX-LABEL: test_op_v16i16:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddw %ymm1, %ymm0, %ymm0
; VLX-NEXT:    vmovntdq %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  %r = add <16 x i16> %a, %b
  store <16 x i16> %r, ptr %dst, align 32, !nontemporal !1
  ret void
}

define void @test_op_v32i8(<32 x i8> %a, <32 x i8> %b, ptr %dst) {
; SSE-LABEL: test_op_v32i8:
; SSE:       # %bb.0:
; SSE-NEXT:    paddb %xmm2, %xmm0
; SSE-NEXT:    paddb %xmm3, %xmm1
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_op_v32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpaddb %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmovntdq %xmm0, 16(%rdi)
; AVX1-NEXT:    vmovntdq %xmm2, (%rdi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_op_v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; VLX-LABEL: test_op_v32i8:
; VLX:       # %bb.0:
; VLX-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; VLX-NEXT:    vmovntdq %ymm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  %r = add <32 x i8> %a, %b
  store <32 x i8> %r, ptr %dst, align 32, !nontemporal !1
  ret void
}

; 256-bit NT stores require 256-bit alignment.
; For AVX, we lower 128-bit alignment as 2x movntps %xmm.
define void @test_unaligned_v8f32(<8 x float> %a, <8 x float> %b, ptr %dst) {
; SSE-LABEL: test_unaligned_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    addps %xmm3, %xmm1
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    addps %xmm2, %xmm0
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_unaligned_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovntps %xmm1, 16(%rdi)
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; VLX-LABEL: test_unaligned_v8f32:
; VLX:       # %bb.0:
; VLX-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; VLX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; VLX-NEXT:    vmovntps %xmm1, 16(%rdi)
; VLX-NEXT:    vmovntps %xmm0, (%rdi)
; VLX-NEXT:    vzeroupper
; VLX-NEXT:    retq
  %r = fadd <8 x float> %a, %b
  store <8 x float> %r, ptr %dst, align 16, !nontemporal !1
  ret void
}

!1 = !{i32 1}
