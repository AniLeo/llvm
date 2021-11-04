; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2   | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx    | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2   | FileCheck %s --check-prefixes=AVX,AVX2

; PR28925

define <4 x i32> @test1(<4 x i1> %cond, <4 x i32> %x) {
; SSE-LABEL: test1:
; SSE:       # %bb.0:
; SSE-NEXT:    pslld $31, %xmm0
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    pandn %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpslld $31, %xmm0, %xmm0
; AVX-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX-NEXT:    vpandn %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %r = select <4 x i1> %cond, <4 x i32> zeroinitializer, <4 x i32> %x
  ret <4 x i32> %r
}

define <4 x i32> @test2(<4 x float> %a, <4 x float> %b, <4 x i32> %x) {
; SSE-LABEL: test2:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpneqps %xmm1, %xmm0
; SSE-NEXT:    andps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test2:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpneqps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq <4 x float> %a, %b
  %r = select <4 x i1> %cond, <4 x i32> zeroinitializer, <4 x i32> %x
  ret <4 x i32> %r
}

define float @fsel_zero_false_val(float %a, float %b, float %x) {
; SSE-LABEL: fsel_zero_false_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqss %xmm1, %xmm0
; SSE-NEXT:    andps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_zero_false_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq float %a, %b
  %r = select i1 %cond, float %x, float 0.0
  ret float %r
}

define float @fsel_zero_true_val(float %a, float %b, float %x) {
; SSE-LABEL: fsel_zero_true_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqss %xmm1, %xmm0
; SSE-NEXT:    andnps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_zero_true_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vandnps %xmm2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq float %a, %b
  %r = select i1 %cond, float 0.0, float %x
  ret float %r
}

define double @fsel_nonzero_false_val(double %x, double %y, double %z) {
; SSE-LABEL: fsel_nonzero_false_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqsd %xmm1, %xmm0
; SSE-NEXT:    andpd %xmm0, %xmm2
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    andnpd %xmm1, %xmm0
; SSE-NEXT:    orpd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_nonzero_false_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq double %x, %y
  %r = select i1 %cond, double %z, double 42.0
  ret double %r
}

define double @fsel_nonzero_true_val(double %x, double %y, double %z) {
; SSE-LABEL: fsel_nonzero_true_val:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqsd %xmm1, %xmm0
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    andpd %xmm0, %xmm1
; SSE-NEXT:    andnpd %xmm2, %xmm0
; SSE-NEXT:    orpd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_nonzero_true_val:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq double %x, %y
  %r = select i1 %cond, double 42.0, double %z
  ret double %r
}

define double @fsel_nonzero_constants(double %x, double %y) {
; SSE-LABEL: fsel_nonzero_constants:
; SSE:       # %bb.0:
; SSE-NEXT:    cmpeqsd %xmm1, %xmm0
; SSE-NEXT:    movq %xmm0, %rax
; SSE-NEXT:    andl $1, %eax
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    retq
;
; AVX-LABEL: fsel_nonzero_constants:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmpeqsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; AVX-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oeq double %x, %y
  %r = select i1 %cond, double 12.0, double 42.0
  ret double %r
}

define <2 x double> @vsel_nonzero_constants(<2 x double> %x, <2 x double> %y) {
; SSE2-LABEL: vsel_nonzero_constants:
; SSE2:       # %bb.0:
; SSE2-NEXT:    cmplepd %xmm0, %xmm1
; SSE2-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    andnpd %xmm2, %xmm0
; SSE2-NEXT:    andpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE2-NEXT:    orpd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE42-LABEL: vsel_nonzero_constants:
; SSE42:       # %bb.0:
; SSE42-NEXT:    cmplepd %xmm0, %xmm1
; SSE42-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; SSE42-NEXT:    movapd %xmm1, %xmm0
; SSE42-NEXT:    blendvpd %xmm0, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm2
; SSE42-NEXT:    movapd %xmm2, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: vsel_nonzero_constants:
; AVX:       # %bb.0:
; AVX-NEXT:    vcmplepd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vblendvpd %xmm0, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm0
; AVX-NEXT:    retq
  %cond = fcmp oge <2 x double> %x, %y
  %r = select <2 x i1> %cond, <2 x double> <double 12.0, double -1.0>, <2 x double> <double 42.0, double 0.0>
  ret <2 x double> %r
}

define <16 x i8> @signbit_mask_v16i8(<16 x i8> %a, <16 x i8> %b) {
; SSE-LABEL: signbit_mask_v16i8:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pcmpgtb %xmm0, %xmm2
; SSE-NEXT:    pand %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: signbit_mask_v16i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpcmpgtb %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp slt <16 x i8> %a, zeroinitializer
  %r = select <16 x i1> %cond, <16 x i8> %b, <16 x i8> zeroinitializer
  ret <16 x i8> %r
}

define <8 x i16> @signbit_mask_v8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE-LABEL: signbit_mask_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pcmpgtw %xmm0, %xmm2
; SSE-NEXT:    pand %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: signbit_mask_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpcmpgtw %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp slt <8 x i16> %a, zeroinitializer
  %r = select <8 x i1> %cond, <8 x i16> %b, <8 x i16> zeroinitializer
  ret <8 x i16> %r
}

define <4 x i32> @signbit_mask_v4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: signbit_mask_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pcmpgtd %xmm0, %xmm2
; SSE-NEXT:    pand %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: signbit_mask_v4i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpcmpgtd %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp slt <4 x i32> %a, zeroinitializer
  %r = select <4 x i1> %cond, <4 x i32> %b, <4 x i32> zeroinitializer
  ret <4 x i32> %r
}

define <2 x i64> @signbit_mask_v2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: signbit_mask_v2i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pxor %xmm0, %xmm0
; SSE2-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-NEXT:    pand %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE42-LABEL: signbit_mask_v2i64:
; SSE42:       # %bb.0:
; SSE42-NEXT:    pxor %xmm2, %xmm2
; SSE42-NEXT:    pcmpgtq %xmm0, %xmm2
; SSE42-NEXT:    pand %xmm1, %xmm2
; SSE42-NEXT:    movdqa %xmm2, %xmm0
; SSE42-NEXT:    retq
;
; AVX-LABEL: signbit_mask_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpcmpgtq %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %cond = icmp slt <2 x i64> %a, zeroinitializer
  %r = select <2 x i1> %cond, <2 x i64> %b, <2 x i64> zeroinitializer
  ret <2 x i64> %r
}

define <32 x i8> @signbit_mask_v32i8(<32 x i8> %a, <32 x i8> %b) {
; SSE-LABEL: signbit_mask_v32i8:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm4, %xmm4
; SSE-NEXT:    pxor %xmm5, %xmm5
; SSE-NEXT:    pcmpgtb %xmm1, %xmm5
; SSE-NEXT:    pcmpgtb %xmm0, %xmm4
; SSE-NEXT:    pand %xmm2, %xmm4
; SSE-NEXT:    pand %xmm3, %xmm5
; SSE-NEXT:    movdqa %xmm4, %xmm0
; SSE-NEXT:    movdqa %xmm5, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: signbit_mask_v32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpgtb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtb %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: signbit_mask_v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpcmpgtb %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cond = icmp slt <32 x i8> %a, zeroinitializer
  %r = select <32 x i1> %cond, <32 x i8> %b, <32 x i8> zeroinitializer
  ret <32 x i8> %r
}

define <16 x i16> @signbit_mask_v16i16(<16 x i16> %a, <16 x i16> %b) {
; SSE-LABEL: signbit_mask_v16i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm4, %xmm4
; SSE-NEXT:    pxor %xmm5, %xmm5
; SSE-NEXT:    pcmpgtw %xmm1, %xmm5
; SSE-NEXT:    pcmpgtw %xmm0, %xmm4
; SSE-NEXT:    pand %xmm2, %xmm4
; SSE-NEXT:    pand %xmm3, %xmm5
; SSE-NEXT:    movdqa %xmm4, %xmm0
; SSE-NEXT:    movdqa %xmm5, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: signbit_mask_v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpgtw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtw %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: signbit_mask_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpcmpgtw %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cond = icmp slt <16 x i16> %a, zeroinitializer
  %r = select <16 x i1> %cond, <16 x i16> %b, <16 x i16> zeroinitializer
  ret <16 x i16> %r
}

define <8 x i32> @signbit_mask_v8i32(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: signbit_mask_v8i32:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm4, %xmm4
; SSE-NEXT:    pxor %xmm5, %xmm5
; SSE-NEXT:    pcmpgtd %xmm1, %xmm5
; SSE-NEXT:    pcmpgtd %xmm0, %xmm4
; SSE-NEXT:    pand %xmm2, %xmm4
; SSE-NEXT:    pand %xmm3, %xmm5
; SSE-NEXT:    movdqa %xmm4, %xmm0
; SSE-NEXT:    movdqa %xmm5, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: signbit_mask_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtd %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: signbit_mask_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpcmpgtd %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cond = icmp slt <8 x i32> %a, zeroinitializer
  %r = select <8 x i1> %cond, <8 x i32> %b, <8 x i32> zeroinitializer
  ret <8 x i32> %r
}

define <4 x i64> @signbit_mask_v4i64(<4 x i64> %a, <4 x i64> %b) {
; SSE2-LABEL: signbit_mask_v4i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm5 = xmm1[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm4
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    pcmpgtd %xmm5, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm4
; SSE2-NEXT:    pand %xmm2, %xmm4
; SSE2-NEXT:    pand %xmm3, %xmm1
; SSE2-NEXT:    movdqa %xmm4, %xmm0
; SSE2-NEXT:    retq
;
; SSE42-LABEL: signbit_mask_v4i64:
; SSE42:       # %bb.0:
; SSE42-NEXT:    pxor %xmm4, %xmm4
; SSE42-NEXT:    pxor %xmm5, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm1, %xmm5
; SSE42-NEXT:    pcmpgtq %xmm0, %xmm4
; SSE42-NEXT:    pand %xmm2, %xmm4
; SSE42-NEXT:    pand %xmm3, %xmm5
; SSE42-NEXT:    movdqa %xmm4, %xmm0
; SSE42-NEXT:    movdqa %xmm5, %xmm1
; SSE42-NEXT:    retq
;
; AVX1-LABEL: signbit_mask_v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vandps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: signbit_mask_v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpcmpgtq %ymm0, %ymm2, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %cond = icmp slt <4 x i64> %a, zeroinitializer
  %r = select <4 x i1> %cond, <4 x i64> %b, <4 x i64> zeroinitializer
  ret <4 x i64> %r
}
