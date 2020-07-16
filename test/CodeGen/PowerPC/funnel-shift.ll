; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=powerpc64le-- | FileCheck %s

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
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi. 5, 5, 31
; CHECK-NEXT:    subfic 6, 5, 32
; CHECK-NEXT:    slw 5, 3, 5
; CHECK-NEXT:    srw 4, 4, 6
; CHECK-NEXT:    or 4, 5, 4
; CHECK-NEXT:    iseleq 3, 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %f
}

define i64 @fshl_i64(i64 %x, i64 %y, i64 %z) {
; CHECK-LABEL: fshl_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi. 5, 5, 63
; CHECK-NEXT:    subfic 6, 5, 64
; CHECK-NEXT:    sld 5, 3, 5
; CHECK-NEXT:    srd 4, 4, 6
; CHECK-NEXT:    or 4, 5, 4
; CHECK-NEXT:    iseleq 3, 3, 4
; CHECK-NEXT:    blr
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %f
}

; Verify that weird types are minimally supported.
declare i37 @llvm.fshl.i37(i37, i37, i37)
define i37 @fshl_i37(i37 %x, i37 %y, i37 %z) {
; CHECK-LABEL: fshl_i37:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lis 6, -8857
; CHECK-NEXT:    clrldi 5, 5, 27
; CHECK-NEXT:    ori 6, 6, 51366
; CHECK-NEXT:    clrldi 4, 4, 27
; CHECK-NEXT:    sldi 6, 6, 32
; CHECK-NEXT:    oris 6, 6, 3542
; CHECK-NEXT:    ori 6, 6, 31883
; CHECK-NEXT:    mulhdu 6, 5, 6
; CHECK-NEXT:    rldicl 6, 6, 59, 5
; CHECK-NEXT:    mulli 6, 6, 37
; CHECK-NEXT:    sub. 5, 5, 6
; CHECK-NEXT:    subfic 6, 5, 37
; CHECK-NEXT:    sld 5, 3, 5
; CHECK-NEXT:    srd 4, 4, 6
; CHECK-NEXT:    or 4, 5, 4
; CHECK-NEXT:    iseleq 3, 3, 4
; CHECK-NEXT:    blr
  %f = call i37 @llvm.fshl.i37(i37 %x, i37 %y, i37 %z)
  ret i37 %f
}

; extract(concat(0b1110000, 0b1111111) << 2) = 0b1000011

declare i7 @llvm.fshl.i7(i7, i7, i7)
define i7 @fshl_i7_const_fold() {
; CHECK-LABEL: fshl_i7_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 67
; CHECK-NEXT:    blr
  %f = call i7 @llvm.fshl.i7(i7 112, i7 127, i7 2)
  ret i7 %f
}

; With constant shift amount, this is rotate + insert (missing extended mnemonics).

define i32 @fshl_i32_const_shift(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_const_shift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 9
; CHECK-NEXT:    rlwimi 4, 3, 9, 0, 22
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 9)
  ret i32 %f
}

; Check modulo math on shift amount.

define i32 @fshl_i32_const_overshift(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_const_overshift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 9
; CHECK-NEXT:    rlwimi 4, 3, 9, 0, 22
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 41)
  ret i32 %f
}

; 64-bit should also work.

define i64 @fshl_i64_const_overshift(i64 %x, i64 %y) {
; CHECK-LABEL: fshl_i64_const_overshift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotldi 4, 4, 41
; CHECK-NEXT:    rldimi 4, 3, 41, 0
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 105)
  ret i64 %f
}

; This should work without any node-specific logic.

define i8 @fshl_i8_const_fold() {
; CHECK-LABEL: fshl_i8_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 128
; CHECK-NEXT:    blr
  %f = call i8 @llvm.fshl.i8(i8 255, i8 0, i8 7)
  ret i8 %f
}

; Repeat everything for funnel shift right.

; General case - all operands can be variables.

define i32 @fshr_i32(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: fshr_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi. 5, 5, 31
; CHECK-NEXT:    subfic 6, 5, 32
; CHECK-NEXT:    srw 5, 4, 5
; CHECK-NEXT:    slw 3, 3, 6
; CHECK-NEXT:    or 3, 3, 5
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %f
}

define i64 @fshr_i64(i64 %x, i64 %y, i64 %z) {
; CHECK-LABEL: fshr_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi. 5, 5, 63
; CHECK-NEXT:    subfic 6, 5, 64
; CHECK-NEXT:    srd 5, 4, 5
; CHECK-NEXT:    sld 3, 3, 6
; CHECK-NEXT:    or 3, 3, 5
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %f
}

; Verify that weird types are minimally supported.
declare i37 @llvm.fshr.i37(i37, i37, i37)
define i37 @fshr_i37(i37 %x, i37 %y, i37 %z) {
; CHECK-LABEL: fshr_i37:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lis 6, -8857
; CHECK-NEXT:    clrldi 5, 5, 27
; CHECK-NEXT:    ori 6, 6, 51366
; CHECK-NEXT:    sldi 6, 6, 32
; CHECK-NEXT:    oris 6, 6, 3542
; CHECK-NEXT:    ori 6, 6, 31883
; CHECK-NEXT:    mulhdu 6, 5, 6
; CHECK-NEXT:    rldicl 6, 6, 59, 5
; CHECK-NEXT:    mulli 6, 6, 37
; CHECK-NEXT:    sub. 5, 5, 6
; CHECK-NEXT:    clrldi 6, 4, 27
; CHECK-NEXT:    subfic 7, 5, 37
; CHECK-NEXT:    srd 5, 6, 5
; CHECK-NEXT:    sld 3, 3, 7
; CHECK-NEXT:    or 3, 3, 5
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
  %f = call i37 @llvm.fshr.i37(i37 %x, i37 %y, i37 %z)
  ret i37 %f
}

; extract(concat(0b1110000, 0b1111111) >> 2) = 0b0011111

declare i7 @llvm.fshr.i7(i7, i7, i7)
define i7 @fshr_i7_const_fold() {
; CHECK-LABEL: fshr_i7_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 31
; CHECK-NEXT:    blr
  %f = call i7 @llvm.fshr.i7(i7 112, i7 127, i7 2)
  ret i7 %f
}

; With constant shift amount, this is rotate + insert (missing extended mnemonics).

define i32 @fshr_i32_const_shift(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_const_shift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 23
; CHECK-NEXT:    rlwimi 4, 3, 23, 0, 8
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 9)
  ret i32 %f
}

; Check modulo math on shift amount. 41-32=9.

define i32 @fshr_i32_const_overshift(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_const_overshift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 23
; CHECK-NEXT:    rlwimi 4, 3, 23, 0, 8
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 41)
  ret i32 %f
}

; 64-bit should also work. 105-64 = 41.

define i64 @fshr_i64_const_overshift(i64 %x, i64 %y) {
; CHECK-LABEL: fshr_i64_const_overshift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotldi 4, 4, 23
; CHECK-NEXT:    rldimi 4, 3, 23, 0
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 105)
  ret i64 %f
}

; This should work without any node-specific logic.

define i8 @fshr_i8_const_fold() {
; CHECK-LABEL: fshr_i8_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 254
; CHECK-NEXT:    blr
  %f = call i8 @llvm.fshr.i8(i8 255, i8 0, i8 7)
  ret i8 %f
}

define i32 @fshl_i32_shift_by_bitwidth(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 32)
  ret i32 %f
}

define i32 @fshr_i32_shift_by_bitwidth(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 32)
  ret i32 %f
}

define <4 x i32> @fshl_v4i32_shift_by_bitwidth(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: fshl_v4i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blr
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

define <4 x i32> @fshr_v4i32_shift_by_bitwidth(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: fshr_v4i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmr 2, 3
; CHECK-NEXT:    blr
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

