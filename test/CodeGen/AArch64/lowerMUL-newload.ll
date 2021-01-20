; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-eabi | FileCheck %s

define <4 x i16> @mlai16_trunc(<4 x i16> %vec0, <4 x i16> %vec1, <4 x i16> %vec2) {
; CHECK-LABEL: mlai16_trunc:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull v0.4s, v1.4h, v0.4h
; CHECK-NEXT:    saddw v0.4s, v0.4s, v2.4h
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
entry:
  %v0 = sext <4 x i16> %vec0 to <4 x i32>
  %v1 = sext <4 x i16> %vec1 to <4 x i32>
  %v2 = sext <4 x i16> %vec2 to <4 x i32>
  %v3 = mul <4 x i32> %v1, %v0
  %v4 = add <4 x i32> %v3, %v2
  %v5 = trunc <4 x i32> %v4 to <4 x i16>
  ret <4 x i16> %v5
}

define <4 x i32> @mlai16_and(<4 x i16> %vec0, <4 x i16> %vec1, <4 x i16> %vec2) {
; CHECK-LABEL: mlai16_and:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umull v0.4s, v1.4h, v0.4h
; CHECK-NEXT:    uaddw v0.4s, v0.4s, v2.4h
; CHECK-NEXT:    movi v1.2d, #0x00ffff0000ffff
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %v0 = sext <4 x i16> %vec0 to <4 x i32>
  %v1 = sext <4 x i16> %vec1 to <4 x i32>
  %v2 = sext <4 x i16> %vec2 to <4 x i32>
  %v3 = mul <4 x i32> %v1, %v0
  %v4 = add <4 x i32> %v3, %v2
  %v5 = and <4 x i32> %v4, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %v5
}

define void @mlai16_loadstore(i16* %a, i16* %b, i16* %c) {
; CHECK-LABEL: mlai16_loadstore:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr d0, [x0, #16]
; CHECK-NEXT:    ldr d1, [x1, #16]
; CHECK-NEXT:    ldr d2, [x2, #16]
; CHECK-NEXT:    smull v0.4s, v1.4h, v0.4h
; CHECK-NEXT:    saddw v0.4s, v0.4s, v2.4h
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    str d0, [x0, #16]
; CHECK-NEXT:    ret
entry:
  %scevgep0 = getelementptr i16, i16* %a, i32 8
  %vector_ptr0 = bitcast i16* %scevgep0 to <4 x i16>*
  %vec0 = load <4 x i16>, <4 x i16>* %vector_ptr0, align 8
  %v0 = sext <4 x i16> %vec0 to <4 x i32>
  %scevgep1 = getelementptr i16, i16* %b, i32 8
  %vector_ptr1 = bitcast i16* %scevgep1 to <4 x i16>*
  %vec1 = load <4 x i16>, <4 x i16>* %vector_ptr1, align 8
  %v1 = sext <4 x i16> %vec1 to <4 x i32>
  %scevgep2 = getelementptr i16, i16* %c, i32 8
  %vector_ptr2 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec2 = load <4 x i16>, <4 x i16>* %vector_ptr2, align 8
  %v2 = sext <4 x i16> %vec2 to <4 x i32>
  %v3 = mul <4 x i32> %v1, %v0
  %v4 = add <4 x i32> %v3, %v2
  %v5 = trunc <4 x i32> %v4 to <4 x i16>
  %scevgep3 = getelementptr i16, i16* %a, i32 8
  %vector_ptr3 = bitcast i16* %scevgep3 to <4 x i16>*
  store <4 x i16> %v5, <4 x i16>* %vector_ptr3, align 8
  ret void
}

define <4 x i16> @addmuli16_trunc(<4 x i16> %vec0, <4 x i16> %vec1, <4 x i16> %vec2) {
; CHECK-LABEL: addmuli16_trunc:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull v1.4s, v1.4h, v2.4h
; CHECK-NEXT:    smlal v1.4s, v0.4h, v2.4h
; CHECK-NEXT:    xtn v0.4h, v1.4s
; CHECK-NEXT:    ret
entry:
  %v0 = sext <4 x i16> %vec0 to <4 x i32>
  %v1 = sext <4 x i16> %vec1 to <4 x i32>
  %v2 = sext <4 x i16> %vec2 to <4 x i32>
  %v3 = add <4 x i32> %v1, %v0
  %v4 = mul <4 x i32> %v3, %v2
  %v5 = trunc <4 x i32> %v4 to <4 x i16>
  ret <4 x i16> %v5
}

define <4 x i32> @addmuli16_and(<4 x i16> %vec0, <4 x i16> %vec1, <4 x i16> %vec2) {
; CHECK-LABEL: addmuli16_and:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umull v1.4s, v1.4h, v2.4h
; CHECK-NEXT:    umlal v1.4s, v0.4h, v2.4h
; CHECK-NEXT:    movi v0.2d, #0x00ffff0000ffff
; CHECK-NEXT:    and v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
entry:
  %v0 = sext <4 x i16> %vec0 to <4 x i32>
  %v1 = sext <4 x i16> %vec1 to <4 x i32>
  %v2 = sext <4 x i16> %vec2 to <4 x i32>
  %v3 = add <4 x i32> %v1, %v0
  %v4 = mul <4 x i32> %v3, %v2
  %v5 = and <4 x i32> %v4, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %v5
}

define void @addmuli16_loadstore(i16* %a, i16* %b, i16* %c) {
; CHECK-LABEL: addmuli16_loadstore:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr d0, [x1, #16]
; CHECK-NEXT:    ldr d1, [x2, #16]
; CHECK-NEXT:    ldr d2, [x0, #16]
; CHECK-NEXT:    smull v0.4s, v0.4h, v1.4h
; CHECK-NEXT:    smlal v0.4s, v2.4h, v1.4h
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    str d0, [x0, #16]
; CHECK-NEXT:    ret
entry:
  %scevgep0 = getelementptr i16, i16* %a, i32 8
  %vector_ptr0 = bitcast i16* %scevgep0 to <4 x i16>*
  %vec0 = load <4 x i16>, <4 x i16>* %vector_ptr0, align 8
  %v0 = sext <4 x i16> %vec0 to <4 x i32>
  %scevgep1 = getelementptr i16, i16* %b, i32 8
  %vector_ptr1 = bitcast i16* %scevgep1 to <4 x i16>*
  %vec1 = load <4 x i16>, <4 x i16>* %vector_ptr1, align 8
  %v1 = sext <4 x i16> %vec1 to <4 x i32>
  %scevgep2 = getelementptr i16, i16* %c, i32 8
  %vector_ptr2 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec2 = load <4 x i16>, <4 x i16>* %vector_ptr2, align 8
  %v2 = sext <4 x i16> %vec2 to <4 x i32>
  %v3 = add <4 x i32> %v1, %v0
  %v4 = mul <4 x i32> %v3, %v2
  %v5 = trunc <4 x i32> %v4 to <4 x i16>
  %scevgep3 = getelementptr i16, i16* %a, i32 8
  %vector_ptr3 = bitcast i16* %scevgep3 to <4 x i16>*
  store <4 x i16> %v5, <4 x i16>* %vector_ptr3, align 8
  ret void
}

define <2 x i32> @mlai32_trunc(<2 x i32> %vec0, <2 x i32> %vec1, <2 x i32> %vec2) {
; CHECK-LABEL: mlai32_trunc:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull v0.2d, v1.2s, v0.2s
; CHECK-NEXT:    saddw v0.2d, v0.2d, v2.2s
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    ret
entry:
  %v0 = sext <2 x i32> %vec0 to <2 x i64>
  %v1 = sext <2 x i32> %vec1 to <2 x i64>
  %v2 = sext <2 x i32> %vec2 to <2 x i64>
  %v3 = mul <2 x i64> %v1, %v0
  %v4 = add <2 x i64> %v3, %v2
  %v5 = trunc <2 x i64> %v4 to <2 x i32>
  ret <2 x i32> %v5
}

define <2 x i64> @mlai32_and(<2 x i32> %vec0, <2 x i32> %vec1, <2 x i32> %vec2) {
; CHECK-LABEL: mlai32_and:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umull v0.2d, v1.2s, v0.2s
; CHECK-NEXT:    uaddw v0.2d, v0.2d, v2.2s
; CHECK-NEXT:    movi v1.2d, #0x000000ffffffff
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %v0 = sext <2 x i32> %vec0 to <2 x i64>
  %v1 = sext <2 x i32> %vec1 to <2 x i64>
  %v2 = sext <2 x i32> %vec2 to <2 x i64>
  %v3 = mul <2 x i64> %v1, %v0
  %v4 = add <2 x i64> %v3, %v2
  %v5 = and <2 x i64> %v4, <i64 4294967295, i64 4294967295>
  ret <2 x i64> %v5
}

define void @mlai32_loadstore(i32* %a, i32* %b, i32* %c) {
; CHECK-LABEL: mlai32_loadstore:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr d0, [x0, #32]
; CHECK-NEXT:    ldr d1, [x1, #32]
; CHECK-NEXT:    ldr d2, [x2, #32]
; CHECK-NEXT:    smull v0.2d, v1.2s, v0.2s
; CHECK-NEXT:    saddw v0.2d, v0.2d, v2.2s
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    str d0, [x0, #32]
; CHECK-NEXT:    ret
entry:
  %scevgep0 = getelementptr i32, i32* %a, i32 8
  %vector_ptr0 = bitcast i32* %scevgep0 to <2 x i32>*
  %vec0 = load <2 x i32>, <2 x i32>* %vector_ptr0, align 8
  %v0 = sext <2 x i32> %vec0 to <2 x i64>
  %scevgep1 = getelementptr i32, i32* %b, i32 8
  %vector_ptr1 = bitcast i32* %scevgep1 to <2 x i32>*
  %vec1 = load <2 x i32>, <2 x i32>* %vector_ptr1, align 8
  %v1 = sext <2 x i32> %vec1 to <2 x i64>
  %scevgep2 = getelementptr i32, i32* %c, i32 8
  %vector_ptr2 = bitcast i32* %scevgep2 to <2 x i32>*
  %vec2 = load <2 x i32>, <2 x i32>* %vector_ptr2, align 8
  %v2 = sext <2 x i32> %vec2 to <2 x i64>
  %v3 = mul <2 x i64> %v1, %v0
  %v4 = add <2 x i64> %v3, %v2
  %v5 = trunc <2 x i64> %v4 to <2 x i32>
  %scevgep3 = getelementptr i32, i32* %a, i32 8
  %vector_ptr3 = bitcast i32* %scevgep3 to <2 x i32>*
  store <2 x i32> %v5, <2 x i32>* %vector_ptr3, align 8
  ret void
}

define <2 x i32> @addmuli32_trunc(<2 x i32> %vec0, <2 x i32> %vec1, <2 x i32> %vec2) {
; CHECK-LABEL: addmuli32_trunc:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull v1.2d, v1.2s, v2.2s
; CHECK-NEXT:    smlal v1.2d, v0.2s, v2.2s
; CHECK-NEXT:    xtn v0.2s, v1.2d
; CHECK-NEXT:    ret
entry:
  %v0 = sext <2 x i32> %vec0 to <2 x i64>
  %v1 = sext <2 x i32> %vec1 to <2 x i64>
  %v2 = sext <2 x i32> %vec2 to <2 x i64>
  %v3 = add <2 x i64> %v1, %v0
  %v4 = mul <2 x i64> %v3, %v2
  %v5 = trunc <2 x i64> %v4 to <2 x i32>
  ret <2 x i32> %v5
}

define <2 x i64> @addmuli32_and(<2 x i32> %vec0, <2 x i32> %vec1, <2 x i32> %vec2) {
; CHECK-LABEL: addmuli32_and:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umull v1.2d, v1.2s, v2.2s
; CHECK-NEXT:    umlal v1.2d, v0.2s, v2.2s
; CHECK-NEXT:    movi v0.2d, #0x000000ffffffff
; CHECK-NEXT:    and v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
entry:
  %v0 = sext <2 x i32> %vec0 to <2 x i64>
  %v1 = sext <2 x i32> %vec1 to <2 x i64>
  %v2 = sext <2 x i32> %vec2 to <2 x i64>
  %v3 = add <2 x i64> %v1, %v0
  %v4 = mul <2 x i64> %v3, %v2
  %v5 = and <2 x i64> %v4, <i64 4294967295, i64 4294967295>
  ret <2 x i64> %v5
}

define void @addmuli32_loadstore(i32* %a, i32* %b, i32* %c) {
; CHECK-LABEL: addmuli32_loadstore:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr d0, [x1, #32]
; CHECK-NEXT:    ldr d1, [x2, #32]
; CHECK-NEXT:    ldr d2, [x0, #32]
; CHECK-NEXT:    smull v0.2d, v0.2s, v1.2s
; CHECK-NEXT:    smlal v0.2d, v2.2s, v1.2s
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    str d0, [x0, #32]
; CHECK-NEXT:    ret
entry:
  %scevgep0 = getelementptr i32, i32* %a, i32 8
  %vector_ptr0 = bitcast i32* %scevgep0 to <2 x i32>*
  %vec0 = load <2 x i32>, <2 x i32>* %vector_ptr0, align 8
  %v0 = sext <2 x i32> %vec0 to <2 x i64>
  %scevgep1 = getelementptr i32, i32* %b, i32 8
  %vector_ptr1 = bitcast i32* %scevgep1 to <2 x i32>*
  %vec1 = load <2 x i32>, <2 x i32>* %vector_ptr1, align 8
  %v1 = sext <2 x i32> %vec1 to <2 x i64>
  %scevgep2 = getelementptr i32, i32* %c, i32 8
  %vector_ptr2 = bitcast i32* %scevgep2 to <2 x i32>*
  %vec2 = load <2 x i32>, <2 x i32>* %vector_ptr2, align 8
  %v2 = sext <2 x i32> %vec2 to <2 x i64>
  %v3 = add <2 x i64> %v1, %v0
  %v4 = mul <2 x i64> %v3, %v2
  %v5 = trunc <2 x i64> %v4 to <2 x i32>
  %scevgep3 = getelementptr i32, i32* %a, i32 8
  %vector_ptr3 = bitcast i32* %scevgep3 to <2 x i32>*
  store <2 x i32> %v5, <2 x i32>* %vector_ptr3, align 8
  ret void
}

define void @func1(i16* %a, i16* %b, i16* %c) {
; CHECK-LABEL: func1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr d0, [x2, #16]
; CHECK-NEXT:    ldr d1, [x1, #16]
; CHECK-NEXT:    ldr d2, [x0, #16]
; CHECK-NEXT:    sshll v0.4s, v0.4h, #0
; CHECK-NEXT:    uaddw v0.4s, v0.4s, v1.4h
; CHECK-NEXT:    xtn v1.4h, v0.4s
; CHECK-NEXT:    str d1, [x0, #16]
; CHECK-NEXT:    ldr d1, [x2, #16]
; CHECK-NEXT:    sshll v1.4s, v1.4h, #0
; CHECK-NEXT:    mul v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    xtn v1.4h, v0.4s
; CHECK-NEXT:    str d1, [x1, #16]
; CHECK-NEXT:    ldr d1, [x2, #16]
; CHECK-NEXT:    smlal v0.4s, v1.4h, v2.4h
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    str d0, [x0, #16]
; CHECK-NEXT:    ret
entry:
; The test case trying to vectorize the pseudo code below.
; a[i] = b[i] + c[i];
; b[i] = a[i] * c[i];
; a[i] = b[i] + a[i] * c[i];
; Checking that vector load a[i] for "a[i] = b[i] + a[i] * c[i]" is
; scheduled before the first vector store to "a[i] = b[i] + c[i]".
; Checking that there is no vector load a[i] scheduled between the vector
; stores to a[i], otherwise the load of a[i] will be polluted by the first
; vector store to a[i].
; This test case check that the chain information is updated during
; lowerMUL for the new created Load SDNode.


  %scevgep0 = getelementptr i16, i16* %a, i32 8
  %vector_ptr0 = bitcast i16* %scevgep0 to <4 x i16>*
  %vec0 = load <4 x i16>, <4 x i16>* %vector_ptr0, align 8
  %scevgep1 = getelementptr i16, i16* %b, i32 8
  %vector_ptr1 = bitcast i16* %scevgep1 to <4 x i16>*
  %vec1 = load <4 x i16>, <4 x i16>* %vector_ptr1, align 8
  %0 = zext <4 x i16> %vec1 to <4 x i32>
  %scevgep2 = getelementptr i16, i16* %c, i32 8
  %vector_ptr2 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec2 = load <4 x i16>, <4 x i16>* %vector_ptr2, align 8
  %1 = sext <4 x i16> %vec2 to <4 x i32>
  %vec3 = add <4 x i32> %1, %0
  %2 = trunc <4 x i32> %vec3 to <4 x i16>
  %scevgep3 = getelementptr i16, i16* %a, i32 8
  %vector_ptr3 = bitcast i16* %scevgep3 to <4 x i16>*
  store <4 x i16> %2, <4 x i16>* %vector_ptr3, align 8
  %vector_ptr4 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec4 = load <4 x i16>, <4 x i16>* %vector_ptr4, align 8
  %3 = sext <4 x i16> %vec4 to <4 x i32>
  %vec5 = mul <4 x i32> %3, %vec3
  %4 = trunc <4 x i32> %vec5 to <4 x i16>
  %vector_ptr5 = bitcast i16* %scevgep1 to <4 x i16>*
  store <4 x i16> %4, <4 x i16>* %vector_ptr5, align 8
  %5 = sext <4 x i16> %vec0 to <4 x i32>
  %vector_ptr6 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec6 = load <4 x i16>, <4 x i16>* %vector_ptr6, align 8
  %6 = sext <4 x i16> %vec6 to <4 x i32>
  %vec7 = mul <4 x i32> %6, %5
  %vec8 = add <4 x i32> %vec7, %vec5
  %7 = trunc <4 x i32> %vec8 to <4 x i16>
  %vector_ptr7 = bitcast i16* %scevgep3 to <4 x i16>*
  store <4 x i16> %7, <4 x i16>* %vector_ptr7, align 8
  ret void
}

define void @func2(i16* %a, i16* %b, i16* %c) {
; CHECK-LABEL: func2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr d0, [x2, #16]
; CHECK-NEXT:    ldr d1, [x1, #16]
; CHECK-NEXT:    ldr d2, [x0, #16]
; CHECK-NEXT:    sshll v0.4s, v0.4h, #0
; CHECK-NEXT:    uaddw v0.4s, v0.4s, v1.4h
; CHECK-NEXT:    xtn v1.4h, v0.4s
; CHECK-NEXT:    str d1, [x0, #16]
; CHECK-NEXT:    ldr d1, [x2, #16]
; CHECK-NEXT:    sshll v1.4s, v1.4h, #0
; CHECK-NEXT:    mul v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    xtn v1.4h, v0.4s
; CHECK-NEXT:    str d1, [x1, #16]
; CHECK-NEXT:    ldr d1, [x2, #16]
; CHECK-NEXT:    smlal v0.4s, v1.4h, v2.4h
; CHECK-NEXT:    saddw v0.4s, v0.4s, v2.4h
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    str d0, [x0, #16]
; CHECK-NEXT:    ret
entry:
; The test case trying to vectorize the pseudo code below.
; a[i] = b[i] + c[i];
; b[i] = a[i] * c[i];
; a[i] = b[i] + a[i] * c[i] + a[i];
; Checking that vector load a[i] for "a[i] = b[i] + a[i] * c[i] + a[i]"
; is scheduled before the first vector store to "a[i] = b[i] + c[i]".
; Checking that there is no vector load a[i] scheduled between the first
; vector store to a[i] and the vector add of a[i], otherwise the load of
; a[i] will be polluted by the first vector store to a[i].
; This test case check that both the chain and value of the new created
; Load SDNode are updated during lowerMUL.


  %scevgep0 = getelementptr i16, i16* %a, i32 8
  %vector_ptr0 = bitcast i16* %scevgep0 to <4 x i16>*
  %vec0 = load <4 x i16>, <4 x i16>* %vector_ptr0, align 8
  %scevgep1 = getelementptr i16, i16* %b, i32 8
  %vector_ptr1 = bitcast i16* %scevgep1 to <4 x i16>*
  %vec1 = load <4 x i16>, <4 x i16>* %vector_ptr1, align 8
  %0 = zext <4 x i16> %vec1 to <4 x i32>
  %scevgep2 = getelementptr i16, i16* %c, i32 8
  %vector_ptr2 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec2 = load <4 x i16>, <4 x i16>* %vector_ptr2, align 8
  %1 = sext <4 x i16> %vec2 to <4 x i32>
  %vec3 = add <4 x i32> %1, %0
  %2 = trunc <4 x i32> %vec3 to <4 x i16>
  %scevgep3 = getelementptr i16, i16* %a, i32 8
  %vector_ptr3 = bitcast i16* %scevgep3 to <4 x i16>*
  store <4 x i16> %2, <4 x i16>* %vector_ptr3, align 8
  %vector_ptr4 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec4 = load <4 x i16>, <4 x i16>* %vector_ptr4, align 8
  %3 = sext <4 x i16> %vec4 to <4 x i32>
  %vec5 = mul <4 x i32> %3, %vec3
  %4 = trunc <4 x i32> %vec5 to <4 x i16>
  %vector_ptr5 = bitcast i16* %scevgep1 to <4 x i16>*
  store <4 x i16> %4, <4 x i16>* %vector_ptr5, align 8
  %5 = sext <4 x i16> %vec0 to <4 x i32>
  %vector_ptr6 = bitcast i16* %scevgep2 to <4 x i16>*
  %vec6 = load <4 x i16>, <4 x i16>* %vector_ptr6, align 8
  %6 = sext <4 x i16> %vec6 to <4 x i32>
  %vec7 = mul <4 x i32> %6, %5
  %vec8 = add <4 x i32> %vec7, %vec5
  %vec9 = add <4 x i32> %vec8, %5
  %7 = trunc <4 x i32> %vec9 to <4 x i16>
  %vector_ptr7 = bitcast i16* %scevgep3 to <4 x i16>*
  store <4 x i16> %7, <4 x i16>* %vector_ptr7, align 8
  ret void
}
