; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs \
; RUN:   -mtriple=aarch64-unknown-unknown < %s | FileCheck %s

declare i64 @llvm.abs.i64(i64, i1 immarg)

define i64 @neg_abs64(i64 %x) {
; CHECK-LABEL: neg_abs64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp x0, #0 // =0
; CHECK-NEXT:    cneg x8, x0, mi
; CHECK-NEXT:    neg x0, x8
; CHECK-NEXT:    ret
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 true)
  %neg = sub nsw i64 0, %abs
  ret i64 %neg
}

declare i32 @llvm.abs.i32(i32, i1 immarg)

define i32 @neg_abs32(i32 %x) {
; CHECK-LABEL: neg_abs32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0 // =0
; CHECK-NEXT:    cneg w8, w0, mi
; CHECK-NEXT:    neg w0, w8
; CHECK-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  %neg = sub nsw i32 0, %abs
  ret i32 %neg
}

declare i16 @llvm.abs.i16(i16, i1 immarg)

define i16 @neg_abs16(i16 %x) {
; CHECK-LABEL: neg_abs16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #15, #1
; CHECK-NEXT:    eor w9, w0, w8
; CHECK-NEXT:    sub w0, w8, w9
; CHECK-NEXT:    ret
  %abs = tail call i16 @llvm.abs.i16(i16 %x, i1 true)
  %neg = sub nsw i16 0, %abs
  ret i16 %neg
}


declare i128 @llvm.abs.i128(i128, i1 immarg)

define i128 @neg_abs128(i128 %x) {
; CHECK-LABEL: neg_abs128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr x8, x1, #63
; CHECK-NEXT:    eor x10, x0, x8
; CHECK-NEXT:    eor x9, x1, x8
; CHECK-NEXT:    subs x0, x8, x10
; CHECK-NEXT:    sbcs x1, x8, x9
; CHECK-NEXT:    ret
  %abs = tail call i128 @llvm.abs.i128(i128 %x, i1 true)
  %neg = sub nsw i128 0, %abs
  ret i128 %neg
}



define i64 @abs64(i64 %x) {
; CHECK-LABEL: abs64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp x0, #0 // =0
; CHECK-NEXT:    cneg x0, x0, mi
; CHECK-NEXT:    ret
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 true)
  ret i64 %abs
}

define i32 @abs32(i32 %x) {
; CHECK-LABEL: abs32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0 // =0
; CHECK-NEXT:    cneg w0, w0, mi
; CHECK-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %abs
}

define i16 @abs16(i16 %x) {
; CHECK-LABEL: abs16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxth w8, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cneg w0, w8, mi
; CHECK-NEXT:    ret
  %abs = tail call i16 @llvm.abs.i16(i16 %x, i1 true)
  ret i16 %abs
}

define i128 @abs128(i128 %x) {
; CHECK-LABEL: abs128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    negs x8, x0
; CHECK-NEXT:    ngcs x9, x1
; CHECK-NEXT:    cmp x1, #0 // =0
; CHECK-NEXT:    csel x0, x8, x0, lt
; CHECK-NEXT:    csel x1, x9, x1, lt
; CHECK-NEXT:    ret
  %abs = tail call i128 @llvm.abs.i128(i128 %x, i1 true)
  ret i128 %abs
}

