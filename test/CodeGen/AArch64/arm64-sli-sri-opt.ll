; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-eabi -aarch64-neon-syntax=apple | FileCheck %s

define void @testLeftGood8x8(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testLeftGood8x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sli.8b v0, v1, #3
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i8> %src1, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %vshl_n = shl <8 x i8> %src2, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  %result = or <8 x i8> %and.i, %vshl_n
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testLeftBad8x8(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testLeftBad8x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi.8b v2, #165
; CHECK-NEXT:    shl.8b v1, v1, #1
; CHECK-NEXT:    and.8b v0, v0, v2
; CHECK-NEXT:    orr.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i8> %src1, <i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165>
  %vshl_n = shl <8 x i8> %src2, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %result = or <8 x i8> %and.i, %vshl_n
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testRightGood8x8(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testRightGood8x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sri.8b v0, v1, #3
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i8> %src1, <i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224>
  %vshl_n = lshr <8 x i8> %src2, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  %result = or <8 x i8> %and.i, %vshl_n
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testRightBad8x8(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testRightBad8x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi.8b v2, #165
; CHECK-NEXT:    ushr.8b v1, v1, #1
; CHECK-NEXT:    and.8b v0, v0, v2
; CHECK-NEXT:    orr.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i8> %src1, <i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165>
  %vshl_n = lshr <8 x i8> %src2, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %result = or <8 x i8> %and.i, %vshl_n
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testLeftGood16x8(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testLeftGood16x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sli.16b v0, v1, #3
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <16 x i8> %src1, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %vshl_n = shl <16 x i8> %src2, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  %result = or <16 x i8> %and.i, %vshl_n
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testLeftBad16x8(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testLeftBad16x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi.16b v2, #165
; CHECK-NEXT:    shl.16b v1, v1, #1
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    orr.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <16 x i8> %src1, <i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165>
  %vshl_n = shl <16 x i8> %src2, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %result = or <16 x i8> %and.i, %vshl_n
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testRightGood16x8(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testRightGood16x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sri.16b v0, v1, #3
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <16 x i8> %src1, <i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224, i8 224>
  %vshl_n = lshr <16 x i8> %src2, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  %result = or <16 x i8> %and.i, %vshl_n
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testRightBad16x8(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testRightBad16x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi.16b v2, #165
; CHECK-NEXT:    ushr.16b v1, v1, #1
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    orr.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <16 x i8> %src1, <i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165, i8 165>
  %vshl_n = lshr <16 x i8> %src2, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %result = or <16 x i8> %and.i, %vshl_n
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testLeftGood4x16(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testLeftGood4x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sli.4h v0, v1, #14
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i16> %src1, <i16 16383, i16 16383, i16 16383, i16 16383>
  %vshl_n = shl <4 x i16> %src2, <i16 14, i16 14, i16 14, i16 14>
  %result = or <4 x i16> %and.i, %vshl_n
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testLeftBad4x16(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testLeftBad4x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16500
; CHECK-NEXT:    shl.4h v1, v1, #14
; CHECK-NEXT:    dup.4h v2, w8
; CHECK-NEXT:    and.8b v0, v0, v2
; CHECK-NEXT:    orr.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i16> %src1, <i16 16500, i16 16500, i16 16500, i16 16500>
  %vshl_n = shl <4 x i16> %src2, <i16 14, i16 14, i16 14, i16 14>
  %result = or <4 x i16> %and.i, %vshl_n
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testRightGood4x16(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testRightGood4x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sri.4h v0, v1, #14
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i16> %src1, <i16 65532, i16 65532, i16 65532, i16 65532>
  %vshl_n = lshr <4 x i16> %src2, <i16 14, i16 14, i16 14, i16 14>
  %result = or <4 x i16> %and.i, %vshl_n
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testRightBad4x16(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testRightBad4x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16500
; CHECK-NEXT:    dup.4h v2, w8
; CHECK-NEXT:    and.8b v0, v0, v2
; CHECK-NEXT:    usra.4h v0, v1, #14
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i16> %src1, <i16 16500, i16 16500, i16 16500, i16 16500>
  %vshl_n = lshr <4 x i16> %src2, <i16 14, i16 14, i16 14, i16 14>
  %result = or <4 x i16> %and.i, %vshl_n
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testLeftGood8x16(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testLeftGood8x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sli.8h v0, v1, #14
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i16> %src1, <i16 16383, i16 16383, i16 16383, i16 16383, i16 16383, i16 16383, i16 16383, i16 16383>
  %vshl_n = shl <8 x i16> %src2, <i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14>
  %result = or <8 x i16> %and.i, %vshl_n
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testLeftBad8x16(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testLeftBad8x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16500
; CHECK-NEXT:    shl.8h v1, v1, #14
; CHECK-NEXT:    dup.8h v2, w8
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    orr.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i16> %src1, <i16 16500, i16 16500, i16 16500, i16 16500, i16 16500, i16 16500, i16 16500, i16 16500>
  %vshl_n = shl <8 x i16> %src2, <i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14>
  %result = or <8 x i16> %and.i, %vshl_n
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testRightGood8x16(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testRightGood8x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sri.8h v0, v1, #14
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i16> %src1, <i16 65532, i16 65532, i16 65532, i16 65532, i16 65532, i16 65532, i16 65532, i16 65532>
  %vshl_n = lshr <8 x i16> %src2, <i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14>
  %result = or <8 x i16> %and.i, %vshl_n
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testRightBad8x16(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testRightBad8x16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16500
; CHECK-NEXT:    dup.8h v2, w8
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    usra.8h v0, v1, #14
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i16> %src1, <i16 16500, i16 16500, i16 16500, i16 16500, i16 16500, i16 16500, i16 16500, i16 16500>
  %vshl_n = lshr <8 x i16> %src2, <i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14, i16 14>
  %result = or <8 x i16> %and.i, %vshl_n
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testLeftGood2x32(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testLeftGood2x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sli.2s v0, v1, #22
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i32> %src1, <i32 4194303, i32 4194303>
  %vshl_n = shl <2 x i32> %src2, <i32 22, i32 22>
  %result = or <2 x i32> %and.i, %vshl_n
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testLeftBad2x32(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testLeftBad2x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #4194300
; CHECK-NEXT:    shl.2s v1, v1, #22
; CHECK-NEXT:    dup.2s v2, w8
; CHECK-NEXT:    and.8b v0, v0, v2
; CHECK-NEXT:    orr.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i32> %src1, <i32 4194300, i32 4194300>
  %vshl_n = shl <2 x i32> %src2, <i32 22, i32 22>
  %result = or <2 x i32> %and.i, %vshl_n
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testRightGood2x32(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testRightGood2x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sri.2s v0, v1, #22
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i32> %src1, <i32 4294966272, i32 4294966272>
  %vshl_n = lshr <2 x i32> %src2, <i32 22, i32 22>
  %result = or <2 x i32> %and.i, %vshl_n
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testRightBad2x32(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testRightBad2x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #4194300
; CHECK-NEXT:    ushr.2s v1, v1, #22
; CHECK-NEXT:    dup.2s v2, w8
; CHECK-NEXT:    and.8b v0, v0, v2
; CHECK-NEXT:    orr.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i32> %src1, <i32 4194300, i32 4194300>
  %vshl_n = lshr <2 x i32> %src2, <i32 22, i32 22>
  %result = or <2 x i32> %and.i, %vshl_n
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testLeftGood4x32(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testLeftGood4x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sli.4s v0, v1, #22
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i32> %src1, <i32 4194303, i32 4194303, i32 4194303, i32 4194303>
  %vshl_n = shl <4 x i32> %src2, <i32 22, i32 22, i32 22, i32 22>
  %result = or <4 x i32> %and.i, %vshl_n
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}

define void @testLeftBad4x32(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testLeftBad4x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #4194300
; CHECK-NEXT:    shl.4s v1, v1, #22
; CHECK-NEXT:    dup.4s v2, w8
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    orr.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i32> %src1, <i32 4194300, i32 4194300, i32 4194300, i32 4194300>
  %vshl_n = shl <4 x i32> %src2, <i32 22, i32 22, i32 22, i32 22>
  %result = or <4 x i32> %and.i, %vshl_n
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}

define void @testRightGood4x32(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testRightGood4x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sri.4s v0, v1, #22
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i32> %src1, <i32 4294966272, i32 4294966272, i32 4294966272, i32 4294966272>
  %vshl_n = lshr <4 x i32> %src2, <i32 22, i32 22, i32 22, i32 22>
  %result = or <4 x i32> %and.i, %vshl_n
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}

define void @testRightBad4x32(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testRightBad4x32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #4194300
; CHECK-NEXT:    ushr.4s v1, v1, #22
; CHECK-NEXT:    dup.4s v2, w8
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    orr.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <4 x i32> %src1, <i32 4194300, i32 4194300, i32 4194300, i32 4194300>
  %vshl_n = lshr <4 x i32> %src2, <i32 22, i32 22, i32 22, i32 22>
  %result = or <4 x i32> %and.i, %vshl_n
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}

define void @testLeftGood2x64(<2 x i64> %src1, <2 x i64> %src2, <2 x i64>* %dest) nounwind {
; CHECK-LABEL: testLeftGood2x64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sli.2d v0, v1, #48
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i64> %src1, <i64 281474976710655, i64 281474976710655>
  %vshl_n = shl <2 x i64> %src2, <i64 48, i64 48>
  %result = or <2 x i64> %and.i, %vshl_n
  store <2 x i64> %result, <2 x i64>* %dest, align 16
  ret void
}

define void @testLeftBad2x64(<2 x i64> %src1, <2 x i64> %src2, <2 x i64>* %dest) nounwind {
; CHECK-LABEL: testLeftBad2x64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #10
; CHECK-NEXT:    shl.2d v1, v1, #48
; CHECK-NEXT:    movk x8, #1, lsl #48
; CHECK-NEXT:    dup.2d v2, x8
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    orr.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i64> %src1, <i64 281474976710666, i64 281474976710666>
  %vshl_n = shl <2 x i64> %src2, <i64 48, i64 48>
  %result = or <2 x i64> %and.i, %vshl_n
  store <2 x i64> %result, <2 x i64>* %dest, align 16
  ret void
}

define void @testRightGood2x64(<2 x i64> %src1, <2 x i64> %src2, <2 x i64>* %dest) nounwind {
; CHECK-LABEL: testRightGood2x64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sri.2d v0, v1, #48
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i64> %src1, <i64 18446744073709486080, i64 18446744073709486080>
  %vshl_n = lshr <2 x i64> %src2, <i64 48, i64 48>
  %result = or <2 x i64> %and.i, %vshl_n
  store <2 x i64> %result, <2 x i64>* %dest, align 16
  ret void
}

define void @testRightBad2x64(<2 x i64> %src1, <2 x i64> %src2, <2 x i64>* %dest) nounwind {
; CHECK-LABEL: testRightBad2x64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #10
; CHECK-NEXT:    ushr.2d v1, v1, #48
; CHECK-NEXT:    movk x8, #1, lsl #48
; CHECK-NEXT:    dup.2d v2, x8
; CHECK-NEXT:    and.16b v0, v0, v2
; CHECK-NEXT:    orr.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <2 x i64> %src1, <i64 281474976710666, i64 281474976710666>
  %vshl_n = lshr <2 x i64> %src2, <i64 48, i64 48>
  %result = or <2 x i64> %and.i, %vshl_n
  store <2 x i64> %result, <2 x i64>* %dest, align 16
  ret void
}

define void @testLeftShouldNotCreateSLI1x128(<1 x i128> %src1, <1 x i128> %src2, <1 x i128>* %dest) nounwind {
; CHECK-LABEL: testLeftShouldNotCreateSLI1x128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bfi x1, x2, #6, #58
; CHECK-NEXT:    stp x0, x1, [x4]
; CHECK-NEXT:    ret
  %and.i = and <1 x i128> %src1, <i128 1180591620717411303423>
  %vshl_n = shl <1 x i128> %src2, <i128 70>
  %result = or <1 x i128> %and.i, %vshl_n
  store <1 x i128> %result, <1 x i128>* %dest, align 16
  ret void
}

define void @testLeftNotAllConstantBuildVec8x8(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testLeftNotAllConstantBuildVec8x8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI29_0
; CHECK-NEXT:    shl.8b v1, v1, #3
; CHECK-NEXT:    ldr d2, [x8, :lo12:.LCPI29_0]
; CHECK-NEXT:    and.8b v0, v0, v2
; CHECK-NEXT:    orr.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %and.i = and <8 x i8> %src1, <i8 7, i8 7, i8 255, i8 7, i8 7, i8 7, i8 255, i8 7>
  %vshl_n = shl <8 x i8> %src2, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  %result = or <8 x i8> %and.i, %vshl_n
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}
