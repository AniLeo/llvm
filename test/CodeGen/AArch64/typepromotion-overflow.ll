; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 %s -o - | FileCheck %s

define zeroext i16 @overflow_add(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: overflow_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w1, w0
; CHECK-NEXT:    mov w9, #2
; CHECK-NEXT:    orr w8, w8, #0x1
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #1024
; CHECK-NEXT:    mov w8, #5
; CHECK-NEXT:    csel w0, w9, w8, hi
; CHECK-NEXT:    ret
  %add = add i16 %b, %a
  %or = or i16 %add, 1
  %cmp = icmp ugt i16 %or, 1024
  %res = select i1 %cmp, i16 2, i16 5
  ret i16 %res
}

define zeroext i16 @overflow_sub(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: overflow_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w0, w1
; CHECK-NEXT:    mov w9, #2
; CHECK-NEXT:    orr w8, w8, #0x1
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    cmp w8, #1024
; CHECK-NEXT:    mov w8, #5
; CHECK-NEXT:    csel w0, w9, w8, hi
; CHECK-NEXT:    ret
  %add = sub i16 %a, %b
  %or = or i16 %add, 1
  %cmp = icmp ugt i16 %or, 1024
  %res = select i1 %cmp, i16 2, i16 5
  ret i16 %res
}

define zeroext i16 @overflow_mul(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: overflow_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mul w9, w1, w0
; CHECK-NEXT:    mov w8, #5
; CHECK-NEXT:    orr w9, w9, #0x1
; CHECK-NEXT:    and w9, w9, #0xffff
; CHECK-NEXT:    cmp w9, #1024
; CHECK-NEXT:    mov w9, #2
; CHECK-NEXT:    csel w0, w9, w8, hi
; CHECK-NEXT:    ret
  %add = mul i16 %b, %a
  %or = or i16 %add, 1
  %cmp = icmp ugt i16 %or, 1024
  %res = select i1 %cmp, i16 2, i16 5
  ret i16 %res
}

define zeroext i16 @overflow_shl(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: overflow_shl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl w9, w0, w1
; CHECK-NEXT:    mov w8, #5
; CHECK-NEXT:    orr w9, w9, #0x1
; CHECK-NEXT:    and w9, w9, #0xffff
; CHECK-NEXT:    cmp w9, #1024
; CHECK-NEXT:    mov w9, #2
; CHECK-NEXT:    csel w0, w9, w8, hi
; CHECK-NEXT:    ret
  %add = shl i16 %a, %b
  %or = or i16 %add, 1
  %cmp = icmp ugt i16 %or, 1024
  %res = select i1 %cmp, i16 2, i16 5
  ret i16 %res
}

define i32 @overflow_add_no_consts(i8 zeroext %a, i8 zeroext %b, i8 zeroext %limit) {
; CHECK-LABEL: overflow_add_no_consts:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w9, w1, w0
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    cmp w2, w9, uxtb
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    csel w0, w9, w8, lo
; CHECK-NEXT:    ret
  %add = add i8 %b, %a
  %cmp = icmp ugt i8 %add, %limit
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @overflow_add_const_limit(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: overflow_add_const_limit:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w1, w0
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    and w8, w8, #0xff
; CHECK-NEXT:    cmp w8, #128
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    csel w0, w9, w8, hi
; CHECK-NEXT:    ret
  %add = add i8 %b, %a
  %cmp = icmp ugt i8 %add, -128
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @overflow_add_positive_const_limit(i8 zeroext %a) {
; CHECK-LABEL: overflow_add_positive_const_limit:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-1
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    cmp w8, w0, sxtb
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    csel w0, w9, w8, gt
; CHECK-NEXT:    ret
  %cmp = icmp slt i8 %a, -1
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @unsafe_add_underflow(i8 zeroext %a) {
; CHECK-LABEL: unsafe_add_underflow:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    cmp w0, #1
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    csel w0, w9, w8, eq
; CHECK-NEXT:    ret
  %cmp = icmp eq i8 %a, 1
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @safe_add_underflow(i8 zeroext %a) {
; CHECK-LABEL: safe_add_underflow:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    csel w0, w9, w8, eq
; CHECK-NEXT:    ret
  %cmp = icmp eq i8 %a, 0
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @safe_add_underflow_neg(i8 zeroext %a) {
; CHECK-LABEL: safe_add_underflow_neg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w9, w0, #2
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    cmp w9, #251
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    csel w0, w9, w8, lo
; CHECK-NEXT:    ret
  %add = add i8 %a, -2
  %cmp = icmp ult i8 %add, -5
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @overflow_sub_negative_const_limit(i8 zeroext %a) {
; CHECK-LABEL: overflow_sub_negative_const_limit:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-1
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    cmp w8, w0, sxtb
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    csel w0, w9, w8, gt
; CHECK-NEXT:    ret
  %cmp = icmp slt i8 %a, -1
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @unsafe_sub_underflow(i8 zeroext %a) {
; CHECK-LABEL: unsafe_sub_underflow:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w9, w0, #6
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    and w9, w9, #0xff
; CHECK-NEXT:    cmp w9, #250
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    csel w0, w9, w8, hi
; CHECK-NEXT:    ret
  %sub = add i8 %a, -6
  %cmp = icmp ugt i8 %sub, -6
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @safe_sub_underflow(i8 zeroext %a) {
; CHECK-LABEL: safe_sub_underflow:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #8
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w9, #16
; CHECK-NEXT:    csel w0, w9, w8, eq
; CHECK-NEXT:    ret
  %cmp.not = icmp eq i8 %a, 0
  %res = select i1 %cmp.not, i32 16, i32 8
  ret i32 %res
}

define i32 @safe_sub_underflow_neg(i8 zeroext %a) {
; CHECK-LABEL: safe_sub_underflow_neg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w9, w0, #4
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    cmp w9, #250
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    csel w0, w9, w8, hi
; CHECK-NEXT:    ret
  %sub = add i8 %a, -4
  %cmp = icmp ugt i8 %sub, -6
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @unsafe_sub_underflow_neg(i8 zeroext %a) {
; CHECK-LABEL: unsafe_sub_underflow_neg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w9, w0, #4
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    and w9, w9, #0xff
; CHECK-NEXT:    cmp w9, #253
; CHECK-NEXT:    mov w9, #8
; CHECK-NEXT:    csel w0, w9, w8, lo
; CHECK-NEXT:    ret
  %sub = add i8 %a, -4
  %cmp = icmp ult i8 %sub, -3
  %res = select i1 %cmp, i32 8, i32 16
  ret i32 %res
}

define i32 @safe_sub_imm_var(i8* nocapture readonly %b) local_unnamed_addr #1 {
; CHECK-LABEL: safe_sub_imm_var:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ret
entry:
  ret i32 0
}

define i32 @safe_sub_var_imm(i8* nocapture readonly %b) local_unnamed_addr #1 {
; CHECK-LABEL: safe_sub_var_imm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    add w8, w8, #8
; CHECK-NEXT:    and w8, w8, #0xff
; CHECK-NEXT:    cmp w8, #252
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
entry:
  %0 = load i8, i8* %b, align 1
  %sub = add nsw i8 %0, 8
  %cmp = icmp ugt i8 %sub, -4
  %conv4 = zext i1 %cmp to i32
  ret i32 %conv4
}

define i32 @safe_add_imm_var(i8* nocapture readnone %b) {
; CHECK-LABEL: safe_add_imm_var:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w0, #1
; CHECK-NEXT:    ret
entry:
  ret i32 1
}

define i32 @safe_add_var_imm(i8* nocapture readnone %b) {
; CHECK-LABEL: safe_add_var_imm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w0, #1
; CHECK-NEXT:    ret
entry:
  ret i32 1
}

define i8 @convert_add_order(i8 zeroext %arg) {
; CHECK-LABEL: convert_add_order:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, w0, #0x1
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    sub w10, w9, #40
; CHECK-NEXT:    cmp w10, #20
; CHECK-NEXT:    cinc w8, w8, hs
; CHECK-NEXT:    cmp w9, #50
; CHECK-NEXT:    mov w9, #255
; CHECK-NEXT:    csel w8, w8, w9, lo
; CHECK-NEXT:    and w0, w8, w0
; CHECK-NEXT:    ret
  %shl = or i8 %arg, 1
  %cmp.0 = icmp ult i8 %shl, 50
  %sub = add nsw i8 %shl, -40
  %cmp.1 = icmp ult i8 %sub, 20
  %mask.sel.v = select i1 %cmp.1, i8 1, i8 2
  %mask.sel = select i1 %cmp.0, i8 %mask.sel.v, i8 -1
  %res = and i8 %mask.sel, %arg
  ret i8 %res
}

define i8 @underflow_if_sub(i32 %arg, i8 zeroext %arg1) {
; CHECK-LABEL: underflow_if_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w9, #100
; CHECK-NEXT:    cset w8, gt
; CHECK-NEXT:    and w8, w8, w0
; CHECK-NEXT:    add w8, w8, #245
; CHECK-NEXT:    cmp w8, w1
; CHECK-NEXT:    csel w0, w8, w9, lo
; CHECK-NEXT:    ret
  %cmp = icmp sgt i32 %arg, 0
  %conv = zext i1 %cmp to i32
  %and = and i32 %conv, %arg
  %trunc = trunc i32 %and to i8
  %conv1 = add nuw nsw i8 %trunc, -11
  %cmp.1 = icmp ult i8 %conv1, %arg1
  %res = select i1 %cmp.1, i8 %conv1, i8 100
  ret i8 %res
}

define i8 @underflow_if_sub_signext(i32 %arg, i8 signext %arg1) {
; CHECK-LABEL: underflow_if_sub_signext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w9, #100
; CHECK-NEXT:    cset w8, gt
; CHECK-NEXT:    and w8, w8, w0
; CHECK-NEXT:    add w8, w8, #245
; CHECK-NEXT:    cmp w8, w1, uxtb
; CHECK-NEXT:    csel w0, w8, w9, lo
; CHECK-NEXT:    ret
  %cmp = icmp sgt i32 %arg, 0
  %conv = zext i1 %cmp to i32
  %and = and i32 %conv, %arg
  %trunc = trunc i32 %and to i8
  %conv1 = add nuw nsw i8 %trunc, -11
  %cmp.1 = icmp ult i8 %conv1, %arg1
  %res = select i1 %cmp.1, i8 %conv1, i8 100
  ret i8 %res
}
