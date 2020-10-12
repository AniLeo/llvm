; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

declare i8 @llvm.fshl.i8(i8, i8, i8)
declare i16 @llvm.fshl.i16(i16, i16, i16)
declare i32 @llvm.fshl.i32(i32, i32, i32)
declare i64 @llvm.fshl.i64(i64, i64, i64)
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

declare i8 @llvm.fshr.i8(i8, i8, i8)
declare i16 @llvm.fshr.i16(i16, i16, i16)
declare i32 @llvm.fshr.i32(i32, i32, i32)
declare i64 @llvm.fshr.i64(i64, i64, i64)
declare <4 x i32> @llvm.fshr.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

; General case - all operands can be variables.

define i32 @fshl_i32(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: fshl_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    mvn w9, w2
; CHECK-NEXT:    lsr w10, w1, #1
; CHECK-NEXT:    lsl w8, w0, w2
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %f
}

define i64 @fshl_i64(i64 %x, i64 %y, i64 %z) {
; CHECK-LABEL: fshl_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w9, w2
; CHECK-NEXT:    lsr x10, x1, #1
; CHECK-NEXT:    lsl x8, x0, x2
; CHECK-NEXT:    lsr x9, x10, x9
; CHECK-NEXT:    orr x0, x8, x9
; CHECK-NEXT:    ret
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %f
}

; Verify that weird types are minimally supported.
declare i37 @llvm.fshl.i37(i37, i37, i37)
define i37 @fshl_i37(i37 %x, i37 %y, i37 %z) {
; CHECK-LABEL: fshl_i37:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #31883
; CHECK-NEXT:    movk x8, #3542, lsl #16
; CHECK-NEXT:    movk x8, #51366, lsl #32
; CHECK-NEXT:    movk x8, #56679, lsl #48
; CHECK-NEXT:    umulh x8, x2, x8
; CHECK-NEXT:    mov w9, #37
; CHECK-NEXT:    ubfx x8, x8, #5, #27
; CHECK-NEXT:    msub w8, w8, w9, w2
; CHECK-NEXT:    lsl x9, x0, x8
; CHECK-NEXT:    mvn w8, w8
; CHECK-NEXT:    ubfiz x10, x1, #26, #37
; CHECK-NEXT:    lsr x8, x10, x8
; CHECK-NEXT:    orr x0, x9, x8
; CHECK-NEXT:    ret
  %f = call i37 @llvm.fshl.i37(i37 %x, i37 %y, i37 %z)
  ret i37 %f
}

; extract(concat(0b1110000, 0b1111111) << 2) = 0b1000011

declare i7 @llvm.fshl.i7(i7, i7, i7)
define i7 @fshl_i7_const_fold() {
; CHECK-LABEL: fshl_i7_const_fold:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #67
; CHECK-NEXT:    ret
  %f = call i7 @llvm.fshl.i7(i7 112, i7 127, i7 2)
  ret i7 %f
}

define i8 @fshl_i8_const_fold_overshift_1() {
; CHECK-LABEL: fshl_i8_const_fold_overshift_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #128
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshl.i8(i8 255, i8 0, i8 15)
  ret i8 %f
}

define i8 @fshl_i8_const_fold_overshift_2() {
; CHECK-LABEL: fshl_i8_const_fold_overshift_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #120
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshl.i8(i8 15, i8 15, i8 11)
  ret i8 %f
}

define i8 @fshl_i8_const_fold_overshift_3() {
; CHECK-LABEL: fshl_i8_const_fold_overshift_3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshl.i8(i8 0, i8 225, i8 8)
  ret i8 %f
}

; With constant shift amount, this is 'extr'.

define i32 @fshl_i32_const_shift(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_const_shift:
; CHECK:       // %bb.0:
; CHECK-NEXT:    extr w0, w0, w1, #23
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 9)
  ret i32 %f
}

; Check modulo math on shift amount.

define i32 @fshl_i32_const_overshift(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_const_overshift:
; CHECK:       // %bb.0:
; CHECK-NEXT:    extr w0, w0, w1, #23
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 41)
  ret i32 %f
}

; 64-bit should also work.

define i64 @fshl_i64_const_overshift(i64 %x, i64 %y) {
; CHECK-LABEL: fshl_i64_const_overshift:
; CHECK:       // %bb.0:
; CHECK-NEXT:    extr x0, x0, x1, #23
; CHECK-NEXT:    ret
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 105)
  ret i64 %f
}

; This should work without any node-specific logic.

define i8 @fshl_i8_const_fold() {
; CHECK-LABEL: fshl_i8_const_fold:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #128
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshl.i8(i8 255, i8 0, i8 7)
  ret i8 %f
}

; Repeat everything for funnel shift right.

; General case - all operands can be variables.

define i32 @fshr_i32(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: fshr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    mvn w9, w2
; CHECK-NEXT:    lsl w10, w0, #1
; CHECK-NEXT:    lsr w8, w1, w2
; CHECK-NEXT:    lsl w9, w10, w9
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %f
}

define i64 @fshr_i64(i64 %x, i64 %y, i64 %z) {
; CHECK-LABEL: fshr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w9, w2
; CHECK-NEXT:    lsl x10, x0, #1
; CHECK-NEXT:    lsr x8, x1, x2
; CHECK-NEXT:    lsl x9, x10, x9
; CHECK-NEXT:    orr x0, x9, x8
; CHECK-NEXT:    ret
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %f
}

; Verify that weird types are minimally supported.
declare i37 @llvm.fshr.i37(i37, i37, i37)
define i37 @fshr_i37(i37 %x, i37 %y, i37 %z) {
; CHECK-LABEL: fshr_i37:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #31883
; CHECK-NEXT:    movk x8, #3542, lsl #16
; CHECK-NEXT:    movk x8, #51366, lsl #32
; CHECK-NEXT:    movk x8, #56679, lsl #48
; CHECK-NEXT:    umulh x8, x2, x8
; CHECK-NEXT:    mov w9, #37
; CHECK-NEXT:    lsr x8, x8, #5
; CHECK-NEXT:    msub w8, w8, w9, w2
; CHECK-NEXT:    lsl x10, x1, #27
; CHECK-NEXT:    add w8, w8, #27 // =27
; CHECK-NEXT:    lsr x9, x10, x8
; CHECK-NEXT:    mvn w8, w8
; CHECK-NEXT:    lsl x10, x0, #1
; CHECK-NEXT:    lsl x8, x10, x8
; CHECK-NEXT:    orr x0, x8, x9
; CHECK-NEXT:    ret
  %f = call i37 @llvm.fshr.i37(i37 %x, i37 %y, i37 %z)
  ret i37 %f
}

; extract(concat(0b1110000, 0b1111111) >> 2) = 0b0011111

declare i7 @llvm.fshr.i7(i7, i7, i7)
define i7 @fshr_i7_const_fold() {
; CHECK-LABEL: fshr_i7_const_fold:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #31
; CHECK-NEXT:    ret
  %f = call i7 @llvm.fshr.i7(i7 112, i7 127, i7 2)
  ret i7 %f
}

define i8 @fshr_i8_const_fold_overshift_1() {
; CHECK-LABEL: fshr_i8_const_fold_overshift_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #254
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshr.i8(i8 255, i8 0, i8 15)
  ret i8 %f
}

define i8 @fshr_i8_const_fold_overshift_2() {
; CHECK-LABEL: fshr_i8_const_fold_overshift_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #225
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshr.i8(i8 15, i8 15, i8 11)
  ret i8 %f
}

define i8 @fshr_i8_const_fold_overshift_3() {
; CHECK-LABEL: fshr_i8_const_fold_overshift_3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #255
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshr.i8(i8 0, i8 255, i8 8)
  ret i8 %f
}

; With constant shift amount, this is 'extr'.

define i32 @fshr_i32_const_shift(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_const_shift:
; CHECK:       // %bb.0:
; CHECK-NEXT:    extr w0, w0, w1, #9
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 9)
  ret i32 %f
}

; Check modulo math on shift amount. 41-32=9.

define i32 @fshr_i32_const_overshift(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_const_overshift:
; CHECK:       // %bb.0:
; CHECK-NEXT:    extr w0, w0, w1, #9
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 41)
  ret i32 %f
}

; 64-bit should also work. 105-64 = 41.

define i64 @fshr_i64_const_overshift(i64 %x, i64 %y) {
; CHECK-LABEL: fshr_i64_const_overshift:
; CHECK:       // %bb.0:
; CHECK-NEXT:    extr x0, x0, x1, #41
; CHECK-NEXT:    ret
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 105)
  ret i64 %f
}

; This should work without any node-specific logic.

define i8 @fshr_i8_const_fold() {
; CHECK-LABEL: fshr_i8_const_fold:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #254
; CHECK-NEXT:    ret
  %f = call i8 @llvm.fshr.i8(i8 255, i8 0, i8 7)
  ret i8 %f
}

define i32 @fshl_i32_shift_by_bitwidth(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_shift_by_bitwidth:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 32)
  ret i32 %f
}

define i32 @fshr_i32_shift_by_bitwidth(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_shift_by_bitwidth:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, w1
; CHECK-NEXT:    ret
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 32)
  ret i32 %f
}

define <4 x i32> @fshl_v4i32_shift_by_bitwidth(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: fshl_v4i32_shift_by_bitwidth:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

define <4 x i32> @fshr_v4i32_shift_by_bitwidth(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: fshr_v4i32_shift_by_bitwidth:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

