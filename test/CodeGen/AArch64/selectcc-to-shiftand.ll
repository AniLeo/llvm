; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-unknown | FileCheck %s

; Compare if negative and select of constants where one constant is zero.

define i32 @neg_sel_constants(i32 %a) {
; CHECK-LABEL: neg_sel_constants:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #5
; CHECK-NEXT:    and w0, w8, w0, asr #31
; CHECK-NEXT:    ret
  %tmp.1 = icmp slt i32 %a, 0
  %retval = select i1 %tmp.1, i32 5, i32 0
  ret i32 %retval
}

; Compare if negative and select of constants where one constant is zero and the other is a single bit.

define i32 @neg_sel_special_constant(i32 %a) {
; CHECK-LABEL: neg_sel_special_constant:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, #22
; CHECK-NEXT:    and w0, w8, #0x200
; CHECK-NEXT:    ret
  %tmp.1 = icmp slt i32 %a, 0
  %retval = select i1 %tmp.1, i32 512, i32 0
  ret i32 %retval
}

; Compare if negative and select variable or zero.

define i32 @neg_sel_variable_and_zero(i32 %a, i32 %b) {
; CHECK-LABEL: neg_sel_variable_and_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w1, w0, asr #31
; CHECK-NEXT:    ret
  %tmp.1 = icmp slt i32 %a, 0
  %retval = select i1 %tmp.1, i32 %b, i32 0
  ret i32 %retval
}

; Compare if not positive and select the same variable as being compared: smin(a, 0).

define i32 @not_pos_sel_same_variable(i32 %a) {
; CHECK-LABEL: not_pos_sel_same_variable:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w0, w0, asr #31
; CHECK-NEXT:    ret
  %tmp = icmp slt i32 %a, 1
  %min = select i1 %tmp, i32 %a, i32 0
  ret i32 %min
}

; Flipping the comparison condition can be handled by getting the bitwise not of the sign mask.

; Compare if positive and select of constants where one constant is zero.

define i32 @pos_sel_constants(i32 %a) {
; CHECK-LABEL: pos_sel_constants:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #5
; CHECK-NEXT:    bic w0, w8, w0, asr #31
; CHECK-NEXT:    ret
  %tmp.1 = icmp sgt i32 %a, -1
  %retval = select i1 %tmp.1, i32 5, i32 0
  ret i32 %retval
}

; Compare if positive and select of constants where one constant is zero and the other is a single bit.

define i32 @pos_sel_special_constant(i32 %a) {
; CHECK-LABEL: pos_sel_special_constant:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #512
; CHECK-NEXT:    bic w0, w8, w0, lsr #22
; CHECK-NEXT:    ret
  %tmp.1 = icmp sgt i32 %a, -1
  %retval = select i1 %tmp.1, i32 512, i32 0
  ret i32 %retval
}

; Compare if positive and select variable or zero.

define i32 @pos_sel_variable_and_zero(i32 %a, i32 %b) {
; CHECK-LABEL: pos_sel_variable_and_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w0, w1, w0, asr #31
; CHECK-NEXT:    ret
  %tmp.1 = icmp sgt i32 %a, -1
  %retval = select i1 %tmp.1, i32 %b, i32 0
  ret i32 %retval
}

; Compare if not negative or zero and select the same variable as being compared: smax(a, 0).

define i32 @not_neg_sel_same_variable(i32 %a) {
; CHECK-LABEL: not_neg_sel_same_variable:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w0, w0, w0, asr #31
; CHECK-NEXT:    ret
  %tmp = icmp sgt i32 %a, 0
  %min = select i1 %tmp, i32 %a, i32 0
  ret i32 %min
}

; https://llvm.org/bugs/show_bug.cgi?id=31175

; ret = (x-y) > 0 ? x-y : 0
define i32 @PR31175(i32 %x, i32 %y) {
; CHECK-LABEL: PR31175:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w0, w1
; CHECK-NEXT:    bic w0, w8, w8, asr #31
; CHECK-NEXT:    ret
  %sub = sub nsw i32 %x, %y
  %cmp = icmp sgt i32 %sub, 0
  %sel = select i1 %cmp, i32 %sub, i32 0
  ret i32 %sel
}

define i8 @sel_shift_bool_i8(i1 %t) {
; CHECK-LABEL: sel_shift_bool_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-128
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    csel w0, w8, wzr, ne
; CHECK-NEXT:    ret
  %shl = select i1 %t, i8 128, i8 0
  ret i8 %shl
}

define i16 @sel_shift_bool_i16(i1 %t) {
; CHECK-LABEL: sel_shift_bool_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #128
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    csel w0, w8, wzr, ne
; CHECK-NEXT:    ret
  %shl = select i1 %t, i16 128, i16 0
  ret i16 %shl
}

define i32 @sel_shift_bool_i32(i1 %t) {
; CHECK-LABEL: sel_shift_bool_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #64
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    csel w0, w8, wzr, ne
; CHECK-NEXT:    ret
  %shl = select i1 %t, i32 64, i32 0
  ret i32 %shl
}

define i64 @sel_shift_bool_i64(i1 %t) {
; CHECK-LABEL: sel_shift_bool_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #65536
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    csel x0, x8, xzr, ne
; CHECK-NEXT:    ret
  %shl = select i1 %t, i64 65536, i64 0
  ret i64 %shl
}

define <16 x i8> @sel_shift_bool_v16i8(<16 x i1> %t) {
; CHECK-LABEL: sel_shift_bool_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.16b, #128
; CHECK-NEXT:    shl v0.16b, v0.16b, #7
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %shl = select <16 x i1> %t, <16 x i8> <i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128>, <16 x i8> zeroinitializer
  ret <16 x i8> %shl
}

define <8 x i16> @sel_shift_bool_v8i16(<8 x i1> %t) {
; CHECK-LABEL: sel_shift_bool_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-NEXT:    movi v1.8h, #128
; CHECK-NEXT:    shl v0.8h, v0.8h, #15
; CHECK-NEXT:    cmlt v0.8h, v0.8h, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %shl= select <8 x i1> %t, <8 x i16> <i16 128, i16 128, i16 128, i16 128, i16 128, i16 128, i16 128, i16 128>, <8 x i16> zeroinitializer
  ret <8 x i16> %shl
}

define <4 x i32> @sel_shift_bool_v4i32(<4 x i1> %t) {
; CHECK-LABEL: sel_shift_bool_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    movi v1.4s, #64
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %shl = select <4 x i1> %t, <4 x i32> <i32 64, i32 64, i32 64, i32 64>, <4 x i32> zeroinitializer
  ret <4 x i32> %shl
}

define <2 x i64> @sel_shift_bool_v2i64(<2 x i1> %t) {
; CHECK-LABEL: sel_shift_bool_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-NEXT:    mov w8, #65536
; CHECK-NEXT:    shl v0.2d, v0.2d, #63
; CHECK-NEXT:    dup v1.2d, x8
; CHECK-NEXT:    cmlt v0.2d, v0.2d, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %shl = select <2 x i1> %t, <2 x i64> <i64 65536, i64 65536>, <2 x i64> zeroinitializer
  ret <2 x i64> %shl
}
