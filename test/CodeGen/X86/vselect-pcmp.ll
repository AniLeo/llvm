; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx       | FileCheck %s --check-prefix=AVX --check-prefix=AVX12F --check-prefix=AVX12 --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2      | FileCheck %s --check-prefix=AVX --check-prefix=AVX12F --check-prefix=AVX12 --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512f   | FileCheck %s --check-prefix=AVX --check-prefix=AVX12F --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512vl  | FileCheck %s --check-prefix=AVX                       --check-prefix=AVX512 --check-prefix=AVX512VL

; The condition vector for BLENDV* only cares about the sign bit of each element.
; So in these tests, if we generate BLENDV*, we should be able to remove the redundant cmp op.

; Test 128-bit vectors for all legal element types.

; FIXME: Why didn't AVX-512 optimize too?

define <16 x i8> @signbit_sel_v16i8(<16 x i8> %x, <16 x i8> %y, <16 x i8> %mask) {
; AVX12-LABEL: signbit_sel_v16i8:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vpblendvb %xmm2, %xmm0, %xmm1, %xmm0
; AVX12-NEXT:    retq
;
; AVX512-LABEL: signbit_sel_v16i8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512-NEXT:    vpcmpgtb %xmm2, %xmm3, %xmm2
; AVX512-NEXT:    vpblendvb %xmm2, %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %tr = icmp slt <16 x i8> %mask, zeroinitializer
  %z = select <16 x i1> %tr, <16 x i8> %x, <16 x i8> %y
  ret <16 x i8> %z
}

; Sorry 16-bit, you're not important enough to support?

define <8 x i16> @signbit_sel_v8i16(<8 x i16> %x, <8 x i16> %y, <8 x i16> %mask) {
; AVX-LABEL: signbit_sel_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX-NEXT:    vpcmpgtw %xmm2, %xmm3, %xmm2
; AVX-NEXT:    vpblendvb %xmm2, %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %tr = icmp slt <8 x i16> %mask, zeroinitializer
  %z = select <8 x i1> %tr, <8 x i16> %x, <8 x i16> %y
  ret <8 x i16> %z
}

define <4 x i32> @signbit_sel_v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> %mask) {
; AVX12F-LABEL: signbit_sel_v4i32:
; AVX12F:       # %bb.0:
; AVX12F-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX12F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v4i32:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtd %xmm2, %xmm3, %k1
; AVX512VL-NEXT:    vpblendmd %xmm0, %xmm1, %xmm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <4 x i32> %mask, zeroinitializer
  %z = select <4 x i1> %tr, <4 x i32> %x, <4 x i32> %y
  ret <4 x i32> %z
}

define <2 x i64> @signbit_sel_v2i64(<2 x i64> %x, <2 x i64> %y, <2 x i64> %mask) {
; AVX12F-LABEL: signbit_sel_v2i64:
; AVX12F:       # %bb.0:
; AVX12F-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX12F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v2i64:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtq %xmm2, %xmm3, %k1
; AVX512VL-NEXT:    vpblendmq %xmm0, %xmm1, %xmm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <2 x i64> %mask, zeroinitializer
  %z = select <2 x i1> %tr, <2 x i64> %x, <2 x i64> %y
  ret <2 x i64> %z
}

define <4 x float> @signbit_sel_v4f32(<4 x float> %x, <4 x float> %y, <4 x i32> %mask) {
; AVX12F-LABEL: signbit_sel_v4f32:
; AVX12F:       # %bb.0:
; AVX12F-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX12F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v4f32:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtd %xmm2, %xmm3, %k1
; AVX512VL-NEXT:    vblendmps %xmm0, %xmm1, %xmm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <4 x i32> %mask, zeroinitializer
  %z = select <4 x i1> %tr, <4 x float> %x, <4 x float> %y
  ret <4 x float> %z
}

define <2 x double> @signbit_sel_v2f64(<2 x double> %x, <2 x double> %y, <2 x i64> %mask) {
; AVX12F-LABEL: signbit_sel_v2f64:
; AVX12F:       # %bb.0:
; AVX12F-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm0
; AVX12F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v2f64:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtq %xmm2, %xmm3, %k1
; AVX512VL-NEXT:    vblendmpd %xmm0, %xmm1, %xmm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <2 x i64> %mask, zeroinitializer
  %z = select <2 x i1> %tr, <2 x double> %x, <2 x double> %y
  ret <2 x double> %z
}

; Test 256-bit vectors to see differences between AVX1 and AVX2.

define <32 x i8> @signbit_sel_v32i8(<32 x i8> %x, <32 x i8> %y, <32 x i8> %mask) {
; AVX1-LABEL: signbit_sel_v32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; AVX1-NEXT:    vpcmpgtb %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpgtb %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; AVX1-NEXT:    vandnps %ymm1, %ymm2, %ymm1
; AVX1-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: signbit_sel_v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: signbit_sel_v32i8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512-NEXT:    vpcmpgtb %ymm2, %ymm3, %ymm2
; AVX512-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %tr = icmp slt <32 x i8> %mask, zeroinitializer
  %z = select <32 x i1> %tr, <32 x i8> %x, <32 x i8> %y
  ret <32 x i8> %z
}

; Sorry 16-bit, you'll never be important enough to support?

define <16 x i16> @signbit_sel_v16i16(<16 x i16> %x, <16 x i16> %y, <16 x i16> %mask) {
; AVX1-LABEL: signbit_sel_v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vpxor %xmm4, %xmm4, %xmm4
; AVX1-NEXT:    vpcmpgtw %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpgtw %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; AVX1-NEXT:    vandnps %ymm1, %ymm2, %ymm1
; AVX1-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: signbit_sel_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX2-NEXT:    vpcmpgtw %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: signbit_sel_v16i16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512-NEXT:    vpcmpgtw %ymm2, %ymm3, %ymm2
; AVX512-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %tr = icmp slt <16 x i16> %mask, zeroinitializer
  %z = select <16 x i1> %tr, <16 x i16> %x, <16 x i16> %y
  ret <16 x i16> %z
}

define <8 x i32> @signbit_sel_v8i32(<8 x i32> %x, <8 x i32> %y, <8 x i32> %mask) {
; AVX12-LABEL: signbit_sel_v8i32:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vblendvps %ymm2, %ymm0, %ymm1, %ymm0
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: signbit_sel_v8i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    # kill: %ymm2<def> %ymm2<kill> %zmm2<def>
; AVX512F-NEXT:    # kill: %ymm1<def> %ymm1<kill> %zmm1<def>
; AVX512F-NEXT:    # kill: %ymm0<def> %ymm0<kill> %zmm0<def>
; AVX512F-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512F-NEXT:    vpcmpgtd %zmm2, %zmm3, %k1
; AVX512F-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    # kill: %ymm0<def> %ymm0<kill> %zmm0<kill>
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v8i32:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtd %ymm2, %ymm3, %k1
; AVX512VL-NEXT:    vpblendmd %ymm0, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <8 x i32> %mask, zeroinitializer
  %z = select <8 x i1> %tr, <8 x i32> %x, <8 x i32> %y
  ret <8 x i32> %z
}

define <4 x i64> @signbit_sel_v4i64(<4 x i64> %x, <4 x i64> %y, <4 x i64> %mask) {
; AVX12F-LABEL: signbit_sel_v4i64:
; AVX12F:       # %bb.0:
; AVX12F-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX12F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v4i64:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtq %ymm2, %ymm3, %k1
; AVX512VL-NEXT:    vpblendmq %ymm0, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <4 x i64> %mask, zeroinitializer
  %z = select <4 x i1> %tr, <4 x i64> %x, <4 x i64> %y
  ret <4 x i64> %z
}

define <4 x double> @signbit_sel_v4f64(<4 x double> %x, <4 x double> %y, <4 x i64> %mask) {
; AVX12F-LABEL: signbit_sel_v4f64:
; AVX12F:       # %bb.0:
; AVX12F-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX12F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v4f64:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtq %ymm2, %ymm3, %k1
; AVX512VL-NEXT:    vblendmpd %ymm0, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <4 x i64> %mask, zeroinitializer
  %z = select <4 x i1> %tr, <4 x double> %x, <4 x double> %y
  ret <4 x double> %z
}

; Try a condition with a different type than the select operands.

define <4 x double> @signbit_sel_v4f64_small_mask(<4 x double> %x, <4 x double> %y, <4 x i32> %mask) {
; AVX1-LABEL: signbit_sel_v4f64_small_mask:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm3
; AVX1-NEXT:    vpshufd {{.*#+}} xmm2 = xmm2[2,3,0,1]
; AVX1-NEXT:    vpmovsxdq %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: signbit_sel_v4f64_small_mask:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovsxdq %xmm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: signbit_sel_v4f64_small_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmovsxdq %xmm2, %ymm2
; AVX512F-NEXT:    vblendvpd %ymm2, %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v4f64_small_mask:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512VL-NEXT:    vpcmpgtd %xmm2, %xmm3, %k1
; AVX512VL-NEXT:    vblendmpd %ymm0, %ymm1, %ymm0 {%k1}
; AVX512VL-NEXT:    retq
  %tr = icmp slt <4 x i32> %mask, zeroinitializer
  %z = select <4 x i1> %tr, <4 x double> %x, <4 x double> %y
  ret <4 x double> %z
}

; Try a 512-bit vector to make sure AVX-512 is handled as expected.

define <8 x double> @signbit_sel_v8f64(<8 x double> %x, <8 x double> %y, <8 x i64> %mask) {
; AVX12-LABEL: signbit_sel_v8f64:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vblendvpd %ymm4, %ymm0, %ymm2, %ymm0
; AVX12-NEXT:    vblendvpd %ymm5, %ymm1, %ymm3, %ymm1
; AVX12-NEXT:    retq
;
; AVX512-LABEL: signbit_sel_v8f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX512-NEXT:    vpcmpgtq %zmm2, %zmm3, %k1
; AVX512-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
  %tr = icmp slt <8 x i64> %mask, zeroinitializer
  %z = select <8 x i1> %tr, <8 x double> %x, <8 x double> %y
  ret <8 x double> %z
}

; If we have a floating-point compare:
; (1) Don't die.
; (2) FIXME: If we don't care about signed-zero (and NaN?), the compare should still get folded.

define <4 x float> @signbit_sel_v4f32_fcmp(<4 x float> %x, <4 x float> %y, <4 x float> %mask) #0 {
; AVX12F-LABEL: signbit_sel_v4f32_fcmp:
; AVX12F:       # %bb.0:
; AVX12F-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX12F-NEXT:    vcmpltps %xmm2, %xmm0, %xmm2
; AVX12F-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; AVX12F-NEXT:    retq
;
; AVX512VL-LABEL: signbit_sel_v4f32_fcmp:
; AVX512VL:       # %bb.0:
; AVX512VL-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512VL-NEXT:    vcmpltps %xmm2, %xmm0, %k1
; AVX512VL-NEXT:    vblendmps %xmm0, %xmm1, %xmm0 {%k1}
; AVX512VL-NEXT:    retq
  %cmp = fcmp olt <4 x float> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x float> %x, <4 x float> %y
  ret <4 x float> %sel
}

attributes #0 = { "no-nans-fp-math"="true" }
