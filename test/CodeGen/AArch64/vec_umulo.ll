; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s --check-prefix=CHECK

declare {<1 x i32>, <1 x i1>} @llvm.umul.with.overflow.v1i32(<1 x i32>, <1 x i32>)
declare {<2 x i32>, <2 x i1>} @llvm.umul.with.overflow.v2i32(<2 x i32>, <2 x i32>)
declare {<3 x i32>, <3 x i1>} @llvm.umul.with.overflow.v3i32(<3 x i32>, <3 x i32>)
declare {<4 x i32>, <4 x i1>} @llvm.umul.with.overflow.v4i32(<4 x i32>, <4 x i32>)
declare {<6 x i32>, <6 x i1>} @llvm.umul.with.overflow.v6i32(<6 x i32>, <6 x i32>)
declare {<8 x i32>, <8 x i1>} @llvm.umul.with.overflow.v8i32(<8 x i32>, <8 x i32>)

declare {<16 x i8>, <16 x i1>} @llvm.umul.with.overflow.v16i8(<16 x i8>, <16 x i8>)
declare {<8 x i16>, <8 x i1>} @llvm.umul.with.overflow.v8i16(<8 x i16>, <8 x i16>)
declare {<2 x i64>, <2 x i1>} @llvm.umul.with.overflow.v2i64(<2 x i64>, <2 x i64>)

declare {<4 x i24>, <4 x i1>} @llvm.umul.with.overflow.v4i24(<4 x i24>, <4 x i24>)
declare {<4 x i1>, <4 x i1>} @llvm.umul.with.overflow.v4i1(<4 x i1>, <4 x i1>)
declare {<2 x i128>, <2 x i1>} @llvm.umul.with.overflow.v2i128(<2 x i128>, <2 x i128>)

define <1 x i32> @umulo_v1i32(<1 x i32> %a0, <1 x i32> %a1, <1 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v1i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    shrn v0.2s, v1.2d, #32
; CHECK-NEXT:    xtn v1.2s, v1.2d
; CHECK-NEXT:    str s1, [x0]
; CHECK-NEXT:    cmtst v0.2s, v0.2s, v0.2s
; CHECK-NEXT:    ret
  %t = call {<1 x i32>, <1 x i1>} @llvm.umul.with.overflow.v1i32(<1 x i32> %a0, <1 x i32> %a1)
  %val = extractvalue {<1 x i32>, <1 x i1>} %t, 0
  %obit = extractvalue {<1 x i32>, <1 x i1>} %t, 1
  %res = sext <1 x i1> %obit to <1 x i32>
  store <1 x i32> %val, <1 x i32>* %p2
  ret <1 x i32> %res
}

define <2 x i32> @umulo_v2i32(<2 x i32> %a0, <2 x i32> %a1, <2 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    shrn v0.2s, v1.2d, #32
; CHECK-NEXT:    xtn v1.2s, v1.2d
; CHECK-NEXT:    str d1, [x0]
; CHECK-NEXT:    cmtst v0.2s, v0.2s, v0.2s
; CHECK-NEXT:    ret
  %t = call {<2 x i32>, <2 x i1>} @llvm.umul.with.overflow.v2i32(<2 x i32> %a0, <2 x i32> %a1)
  %val = extractvalue {<2 x i32>, <2 x i1>} %t, 0
  %obit = extractvalue {<2 x i32>, <2 x i1>} %t, 1
  %res = sext <2 x i1> %obit to <2 x i32>
  store <2 x i32> %val, <2 x i32>* %p2
  ret <2 x i32> %res
}

define <3 x i32> @umulo_v3i32(<3 x i32> %a0, <3 x i32> %a1, <3 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v3i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.2d, v0.4s, v1.4s
; CHECK-NEXT:    add x8, x0, #8
; CHECK-NEXT:    umull v3.2d, v0.2s, v1.2s
; CHECK-NEXT:    mul v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    uzp2 v2.4s, v3.4s, v2.4s
; CHECK-NEXT:    st1 { v1.s }[2], [x8]
; CHECK-NEXT:    str d1, [x0]
; CHECK-NEXT:    cmtst v2.4s, v2.4s, v2.4s
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
  %t = call {<3 x i32>, <3 x i1>} @llvm.umul.with.overflow.v3i32(<3 x i32> %a0, <3 x i32> %a1)
  %val = extractvalue {<3 x i32>, <3 x i1>} %t, 0
  %obit = extractvalue {<3 x i32>, <3 x i1>} %t, 1
  %res = sext <3 x i1> %obit to <3 x i32>
  store <3 x i32> %val, <3 x i32>* %p2
  ret <3 x i32> %res
}

define <4 x i32> @umulo_v4i32(<4 x i32> %a0, <4 x i32> %a1, <4 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.2d, v0.4s, v1.4s
; CHECK-NEXT:    umull v3.2d, v0.2s, v1.2s
; CHECK-NEXT:    mul v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    uzp2 v2.4s, v3.4s, v2.4s
; CHECK-NEXT:    str q1, [x0]
; CHECK-NEXT:    cmtst v2.4s, v2.4s, v2.4s
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
  %t = call {<4 x i32>, <4 x i1>} @llvm.umul.with.overflow.v4i32(<4 x i32> %a0, <4 x i32> %a1)
  %val = extractvalue {<4 x i32>, <4 x i1>} %t, 0
  %obit = extractvalue {<4 x i32>, <4 x i1>} %t, 1
  %res = sext <4 x i1> %obit to <4 x i32>
  store <4 x i32> %val, <4 x i32>* %p2
  ret <4 x i32> %res
}

define <6 x i32> @umulo_v6i32(<6 x i32> %a0, <6 x i32> %a1, <6 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v6i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov s0, w6
; CHECK-NEXT:    fmov s1, w0
; CHECK-NEXT:    mov x8, sp
; CHECK-NEXT:    add x9, sp, #8
; CHECK-NEXT:    ldr s2, [sp, #16]
; CHECK-NEXT:    fmov s3, w4
; CHECK-NEXT:    mov v0.s[1], w7
; CHECK-NEXT:    mov v1.s[1], w1
; CHECK-NEXT:    mov v3.s[1], w5
; CHECK-NEXT:    ld1 { v0.s }[2], [x8]
; CHECK-NEXT:    add x8, sp, #24
; CHECK-NEXT:    mov v1.s[2], w2
; CHECK-NEXT:    ld1 { v2.s }[1], [x8]
; CHECK-NEXT:    ld1 { v0.s }[3], [x9]
; CHECK-NEXT:    mov v1.s[3], w3
; CHECK-NEXT:    ldr x8, [sp, #32]
; CHECK-NEXT:    umull2 v6.2d, v3.4s, v2.4s
; CHECK-NEXT:    umull v7.2d, v3.2s, v2.2s
; CHECK-NEXT:    umull2 v4.2d, v1.4s, v0.4s
; CHECK-NEXT:    umull v5.2d, v1.2s, v0.2s
; CHECK-NEXT:    mul v2.4s, v3.4s, v2.4s
; CHECK-NEXT:    mul v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    uzp2 v4.4s, v5.4s, v4.4s
; CHECK-NEXT:    uzp2 v5.4s, v7.4s, v6.4s
; CHECK-NEXT:    str d2, [x8, #16]
; CHECK-NEXT:    str q0, [x8]
; CHECK-NEXT:    cmtst v4.4s, v4.4s, v4.4s
; CHECK-NEXT:    cmtst v3.4s, v5.4s, v5.4s
; CHECK-NEXT:    mov w1, v4.s[1]
; CHECK-NEXT:    mov w2, v4.s[2]
; CHECK-NEXT:    mov w3, v4.s[3]
; CHECK-NEXT:    mov w5, v3.s[1]
; CHECK-NEXT:    fmov w0, s4
; CHECK-NEXT:    fmov w4, s3
; CHECK-NEXT:    ret
  %t = call {<6 x i32>, <6 x i1>} @llvm.umul.with.overflow.v6i32(<6 x i32> %a0, <6 x i32> %a1)
  %val = extractvalue {<6 x i32>, <6 x i1>} %t, 0
  %obit = extractvalue {<6 x i32>, <6 x i1>} %t, 1
  %res = sext <6 x i1> %obit to <6 x i32>
  store <6 x i32> %val, <6 x i32>* %p2
  ret <6 x i32> %res
}

define <8 x i32> @umulo_v8i32(<8 x i32> %a0, <8 x i32> %a1, <8 x i32>* %p2) nounwind {
; CHECK-LABEL: umulo_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v4.2d, v1.4s, v3.4s
; CHECK-NEXT:    umull2 v5.2d, v0.4s, v2.4s
; CHECK-NEXT:    umull v6.2d, v0.2s, v2.2s
; CHECK-NEXT:    umull v7.2d, v1.2s, v3.2s
; CHECK-NEXT:    mul v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    mul v2.4s, v0.4s, v2.4s
; CHECK-NEXT:    uzp2 v5.4s, v6.4s, v5.4s
; CHECK-NEXT:    uzp2 v6.4s, v7.4s, v4.4s
; CHECK-NEXT:    stp q2, q3, [x0]
; CHECK-NEXT:    cmtst v4.4s, v5.4s, v5.4s
; CHECK-NEXT:    cmtst v5.4s, v6.4s, v6.4s
; CHECK-NEXT:    mov v0.16b, v4.16b
; CHECK-NEXT:    mov v1.16b, v5.16b
; CHECK-NEXT:    ret
  %t = call {<8 x i32>, <8 x i1>} @llvm.umul.with.overflow.v8i32(<8 x i32> %a0, <8 x i32> %a1)
  %val = extractvalue {<8 x i32>, <8 x i1>} %t, 0
  %obit = extractvalue {<8 x i32>, <8 x i1>} %t, 1
  %res = sext <8 x i1> %obit to <8 x i32>
  store <8 x i32> %val, <8 x i32>* %p2
  ret <8 x i32> %res
}

define <16 x i32> @umulo_v16i8(<16 x i8> %a0, <16 x i8> %a1, <16 x i8>* %p2) nounwind {
; CHECK-LABEL: umulo_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.8h, v0.16b, v1.16b
; CHECK-NEXT:    umull v3.8h, v0.8b, v1.8b
; CHECK-NEXT:    uzp2 v2.16b, v3.16b, v2.16b
; CHECK-NEXT:    cmtst v2.16b, v2.16b, v2.16b
; CHECK-NEXT:    ext v3.16b, v2.16b, v2.16b, #8
; CHECK-NEXT:    zip1 v4.8b, v2.8b, v0.8b
; CHECK-NEXT:    zip2 v2.8b, v2.8b, v0.8b
; CHECK-NEXT:    zip1 v5.8b, v3.8b, v0.8b
; CHECK-NEXT:    zip2 v3.8b, v3.8b, v0.8b
; CHECK-NEXT:    ushll v4.4s, v4.4h, #0
; CHECK-NEXT:    ushll v2.4s, v2.4h, #0
; CHECK-NEXT:    ushll v5.4s, v5.4h, #0
; CHECK-NEXT:    ushll v3.4s, v3.4h, #0
; CHECK-NEXT:    shl v4.4s, v4.4s, #31
; CHECK-NEXT:    shl v2.4s, v2.4s, #31
; CHECK-NEXT:    shl v6.4s, v5.4s, #31
; CHECK-NEXT:    shl v3.4s, v3.4s, #31
; CHECK-NEXT:    cmlt v4.4s, v4.4s, #0
; CHECK-NEXT:    cmlt v5.4s, v2.4s, #0
; CHECK-NEXT:    cmlt v2.4s, v6.4s, #0
; CHECK-NEXT:    cmlt v3.4s, v3.4s, #0
; CHECK-NEXT:    mul v6.16b, v0.16b, v1.16b
; CHECK-NEXT:    mov v0.16b, v4.16b
; CHECK-NEXT:    mov v1.16b, v5.16b
; CHECK-NEXT:    str q6, [x0]
; CHECK-NEXT:    ret
  %t = call {<16 x i8>, <16 x i1>} @llvm.umul.with.overflow.v16i8(<16 x i8> %a0, <16 x i8> %a1)
  %val = extractvalue {<16 x i8>, <16 x i1>} %t, 0
  %obit = extractvalue {<16 x i8>, <16 x i1>} %t, 1
  %res = sext <16 x i1> %obit to <16 x i32>
  store <16 x i8> %val, <16 x i8>* %p2
  ret <16 x i32> %res
}

define <8 x i32> @umulo_v8i16(<8 x i16> %a0, <8 x i16> %a1, <8 x i16>* %p2) nounwind {
; CHECK-LABEL: umulo_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umull2 v2.4s, v0.8h, v1.8h
; CHECK-NEXT:    umull v3.4s, v0.4h, v1.4h
; CHECK-NEXT:    uzp2 v2.8h, v3.8h, v2.8h
; CHECK-NEXT:    cmtst v2.8h, v2.8h, v2.8h
; CHECK-NEXT:    xtn v2.8b, v2.8h
; CHECK-NEXT:    zip1 v3.8b, v2.8b, v0.8b
; CHECK-NEXT:    zip2 v2.8b, v2.8b, v0.8b
; CHECK-NEXT:    ushll v3.4s, v3.4h, #0
; CHECK-NEXT:    ushll v2.4s, v2.4h, #0
; CHECK-NEXT:    shl v3.4s, v3.4s, #31
; CHECK-NEXT:    shl v4.4s, v2.4s, #31
; CHECK-NEXT:    cmlt v2.4s, v3.4s, #0
; CHECK-NEXT:    cmlt v3.4s, v4.4s, #0
; CHECK-NEXT:    mul v4.8h, v0.8h, v1.8h
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    mov v1.16b, v3.16b
; CHECK-NEXT:    str q4, [x0]
; CHECK-NEXT:    ret
  %t = call {<8 x i16>, <8 x i1>} @llvm.umul.with.overflow.v8i16(<8 x i16> %a0, <8 x i16> %a1)
  %val = extractvalue {<8 x i16>, <8 x i1>} %t, 0
  %obit = extractvalue {<8 x i16>, <8 x i1>} %t, 1
  %res = sext <8 x i1> %obit to <8 x i32>
  store <8 x i16> %val, <8 x i16>* %p2
  ret <8 x i32> %res
}

define <2 x i32> @umulo_v2i64(<2 x i64> %a0, <2 x i64> %a1, <2 x i64>* %p2) nounwind {
; CHECK-LABEL: umulo_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, v1.d[1]
; CHECK-NEXT:    fmov x10, d1
; CHECK-NEXT:    mov x9, v0.d[1]
; CHECK-NEXT:    fmov x11, d0
; CHECK-NEXT:    umulh x12, x9, x8
; CHECK-NEXT:    umulh x13, x11, x10
; CHECK-NEXT:    cmp xzr, x12
; CHECK-NEXT:    mul x10, x11, x10
; CHECK-NEXT:    csetm x12, ne
; CHECK-NEXT:    cmp xzr, x13
; CHECK-NEXT:    csetm x13, ne
; CHECK-NEXT:    mul x8, x9, x8
; CHECK-NEXT:    fmov d1, x10
; CHECK-NEXT:    fmov d0, x13
; CHECK-NEXT:    mov v1.d[1], x8
; CHECK-NEXT:    mov v0.d[1], x12
; CHECK-NEXT:    str q1, [x0]
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    ret
  %t = call {<2 x i64>, <2 x i1>} @llvm.umul.with.overflow.v2i64(<2 x i64> %a0, <2 x i64> %a1)
  %val = extractvalue {<2 x i64>, <2 x i1>} %t, 0
  %obit = extractvalue {<2 x i64>, <2 x i1>} %t, 1
  %res = sext <2 x i1> %obit to <2 x i32>
  store <2 x i64> %val, <2 x i64>* %p2
  ret <2 x i32> %res
}

define <4 x i32> @umulo_v4i24(<4 x i24> %a0, <4 x i24> %a1, <4 x i24>* %p2) nounwind {
; CHECK-LABEL: umulo_v4i24:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic v1.4s, #255, lsl #24
; CHECK-NEXT:    bic v0.4s, #255, lsl #24
; CHECK-NEXT:    umull2 v2.2d, v0.4s, v1.4s
; CHECK-NEXT:    umull v3.2d, v0.2s, v1.2s
; CHECK-NEXT:    mul v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    uzp2 v1.4s, v3.4s, v2.4s
; CHECK-NEXT:    ushr v2.4s, v0.4s, #24
; CHECK-NEXT:    mov w8, v0.s[3]
; CHECK-NEXT:    mov w9, v0.s[2]
; CHECK-NEXT:    mov w10, v0.s[1]
; CHECK-NEXT:    cmeq v1.4s, v1.4s, #0
; CHECK-NEXT:    fmov w11, s0
; CHECK-NEXT:    cmtst v2.4s, v2.4s, v2.4s
; CHECK-NEXT:    sturh w8, [x0, #9]
; CHECK-NEXT:    lsr w8, w8, #16
; CHECK-NEXT:    strh w9, [x0, #6]
; CHECK-NEXT:    lsr w9, w9, #16
; CHECK-NEXT:    sturh w10, [x0, #3]
; CHECK-NEXT:    orn v0.16b, v2.16b, v1.16b
; CHECK-NEXT:    strb w8, [x0, #11]
; CHECK-NEXT:    lsr w8, w10, #16
; CHECK-NEXT:    lsr w10, w11, #16
; CHECK-NEXT:    strh w11, [x0]
; CHECK-NEXT:    strb w9, [x0, #8]
; CHECK-NEXT:    strb w8, [x0, #5]
; CHECK-NEXT:    strb w10, [x0, #2]
; CHECK-NEXT:    ret
  %t = call {<4 x i24>, <4 x i1>} @llvm.umul.with.overflow.v4i24(<4 x i24> %a0, <4 x i24> %a1)
  %val = extractvalue {<4 x i24>, <4 x i1>} %t, 0
  %obit = extractvalue {<4 x i24>, <4 x i1>} %t, 1
  %res = sext <4 x i1> %obit to <4 x i32>
  store <4 x i24> %val, <4 x i24>* %p2
  ret <4 x i32> %res
}

define <4 x i32> @umulo_v4i1(<4 x i1> %a0, <4 x i1> %a1, <4 x i1>* %p2) nounwind {
; CHECK-LABEL: umulo_v4i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov d2, d0
; CHECK-NEXT:    movi v0.2d, #0000000000000000
; CHECK-NEXT:    and v1.8b, v2.8b, v1.8b
; CHECK-NEXT:    umov w8, v1.h[1]
; CHECK-NEXT:    umov w9, v1.h[2]
; CHECK-NEXT:    umov w10, v1.h[0]
; CHECK-NEXT:    umov w11, v1.h[3]
; CHECK-NEXT:    and w8, w8, #0x1
; CHECK-NEXT:    and w9, w9, #0x1
; CHECK-NEXT:    bfi w10, w8, #1, #1
; CHECK-NEXT:    bfi w10, w9, #2, #1
; CHECK-NEXT:    bfi w10, w11, #3, #29
; CHECK-NEXT:    and w8, w10, #0xf
; CHECK-NEXT:    strb w8, [x0]
; CHECK-NEXT:    ret
  %t = call {<4 x i1>, <4 x i1>} @llvm.umul.with.overflow.v4i1(<4 x i1> %a0, <4 x i1> %a1)
  %val = extractvalue {<4 x i1>, <4 x i1>} %t, 0
  %obit = extractvalue {<4 x i1>, <4 x i1>} %t, 1
  %res = sext <4 x i1> %obit to <4 x i32>
  store <4 x i1> %val, <4 x i1>* %p2
  ret <4 x i32> %res
}

define <2 x i32> @umulo_v2i128(<2 x i128> %a0, <2 x i128> %a1, <2 x i128>* %p2) nounwind {
; CHECK-LABEL: umulo_v2i128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umulh x8, x3, x6
; CHECK-NEXT:    mul x10, x7, x2
; CHECK-NEXT:    cmp xzr, x8
; CHECK-NEXT:    umulh x8, x7, x2
; CHECK-NEXT:    cset w9, ne
; CHECK-NEXT:    cmp x3, #0
; CHECK-NEXT:    ccmp x7, #0, #4, ne
; CHECK-NEXT:    umulh x11, x2, x6
; CHECK-NEXT:    madd x10, x3, x6, x10
; CHECK-NEXT:    umulh x12, x1, x4
; CHECK-NEXT:    cset w13, ne
; CHECK-NEXT:    cmp xzr, x8
; CHECK-NEXT:    cset w8, ne
; CHECK-NEXT:    adds x10, x11, x10
; CHECK-NEXT:    cset w11, hs
; CHECK-NEXT:    cmp xzr, x12
; CHECK-NEXT:    cset w12, ne
; CHECK-NEXT:    cmp x1, #0
; CHECK-NEXT:    ccmp x5, #0, #4, ne
; CHECK-NEXT:    mul x15, x5, x0
; CHECK-NEXT:    umulh x14, x5, x0
; CHECK-NEXT:    orr w9, w13, w9
; CHECK-NEXT:    umulh x16, x0, x4
; CHECK-NEXT:    orr w8, w9, w8
; CHECK-NEXT:    madd x15, x1, x4, x15
; CHECK-NEXT:    cset w17, ne
; CHECK-NEXT:    cmp xzr, x14
; CHECK-NEXT:    orr w12, w17, w12
; CHECK-NEXT:    cset w14, ne
; CHECK-NEXT:    adds x15, x16, x15
; CHECK-NEXT:    orr w12, w12, w14
; CHECK-NEXT:    cset w14, hs
; CHECK-NEXT:    orr w12, w12, w14
; CHECK-NEXT:    orr w8, w8, w11
; CHECK-NEXT:    mul x11, x0, x4
; CHECK-NEXT:    ldr x9, [sp]
; CHECK-NEXT:    fmov s0, w12
; CHECK-NEXT:    stp x11, x15, [x9]
; CHECK-NEXT:    mov v0.s[1], w8
; CHECK-NEXT:    mul x8, x2, x6
; CHECK-NEXT:    shl v0.2s, v0.2s, #31
; CHECK-NEXT:    stp x8, x10, [x9, #16]
; CHECK-NEXT:    cmlt v0.2s, v0.2s, #0
; CHECK-NEXT:    ret
  %t = call {<2 x i128>, <2 x i1>} @llvm.umul.with.overflow.v2i128(<2 x i128> %a0, <2 x i128> %a1)
  %val = extractvalue {<2 x i128>, <2 x i1>} %t, 0
  %obit = extractvalue {<2 x i128>, <2 x i1>} %t, 1
  %res = sext <2 x i1> %obit to <2 x i32>
  store <2 x i128> %val, <2 x i128>* %p2
  ret <2 x i32> %res
}
