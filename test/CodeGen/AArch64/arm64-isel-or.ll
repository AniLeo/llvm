; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-linux-gnu  -o - | FileCheck %s
; ModuleID = '<stdin>'
source_filename = "<stdin>"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

define i32 @Orlshr(i32 %e) {
; CHECK-LABEL: Orlshr:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    orr w8, w0, w0, lsr #15
; CHECK-NEXT:    orr w8, w8, w8, lsr #15
; CHECK-NEXT:    orr w8, w8, w8, lsr #15
; CHECK-NEXT:    orr w0, w8, w8, lsr #15
; CHECK-NEXT:    ret
entry:
  %shr = lshr i32 %e, 15
  %or = or i32 %shr, %e
  %shr.1 = lshr i32 %or, 15
  %or.1 = or i32 %shr.1, %or
  %shr.2 = lshr i32 %or.1, 15
  %or.2 = or i32 %shr.2, %or.1
  %shr.3 = lshr i32 %or.2, 15
  %or.3 = or i32 %shr.3, %or.2
  ret i32 %or.3
}

define i32 @Orshl(i32 %e) {
; CHECK-LABEL: Orshl:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    orr w8, w0, w0, lsl #15
; CHECK-NEXT:    orr w8, w8, w8, lsl #15
; CHECK-NEXT:    orr w8, w8, w8, lsl #15
; CHECK-NEXT:    orr w0, w8, w8, lsl #15
; CHECK-NEXT:    ret
entry:
  %shl = shl i32 %e, 15
  %or = or i32 %shl, %e
  %shl.1 = shl i32 %or, 15
  %or.1 = or i32 %shl.1, %or
  %shl.2 = shl i32 %or.1, 15
  %or.2 = or i32 %shl.2, %or.1
  %shl.3 = shl i32 %or.2, 15
  %or.3 = or i32 %shl.3, %or.2
  ret i32 %or.3
}
