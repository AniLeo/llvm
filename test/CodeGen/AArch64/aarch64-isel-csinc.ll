; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-- -o - < %s | FileCheck %s

; Verify that we can fold csneg/csel into csinc instruction.

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

; int csinc1 (int a, int b) { return !a ? b+3 : b+1; }
define dso_local i32 @csinc1(i32 %a, i32 %b) {
; CHECK-LABEL: csinc1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    add w8, w1, #3
; CHECK-NEXT:    csinc w0, w8, w1, eq
; CHECK-NEXT:    ret
entry:
  %tobool.not = icmp eq i32 %a, 0
  %cond.v = select i1 %tobool.not, i32 3, i32 1
  %cond = add nsw i32 %cond.v, %b
  ret i32 %cond
}

; int csinc2 (int a, int b) { return a ? b+3 : b+1; }
define dso_local i32 @csinc2(i32 %a, i32 %b) {
; CHECK-LABEL: csinc2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    add w8, w1, #3
; CHECK-NEXT:    csinc w0, w8, w1, ne
; CHECK-NEXT:    ret
entry:
  %tobool.not = icmp eq i32 %a, 0
  %cond.v = select i1 %tobool.not, i32 1, i32 3
  %cond = add nsw i32 %cond.v, %b
  ret i32 %cond
}

; int csinc3 (int a, int b) { return !a ? b+1 : b-3; }
define dso_local i32 @csinc3(i32 %a, i32 %b) {
; CHECK-LABEL: csinc3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub w8, w1, #3
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csinc w0, w8, w1, ne
; CHECK-NEXT:    ret
entry:
  %tobool.not = icmp eq i32 %a, 0
  %cond.v = select i1 %tobool.not, i32 1, i32 -3
  %cond = add nsw i32 %cond.v, %b
  ret i32 %cond
}

; int csinc4 (int a, int b) { return a ? b+1 : b-3; }
define dso_local i32 @csinc4(i32 %a, i32 %b) {
; CHECK-LABEL: csinc4:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub w8, w1, #3
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csinc w0, w8, w1, eq
; CHECK-NEXT:    ret
entry:
  %tobool.not = icmp eq i32 %a, 0
  %cond.v = select i1 %tobool.not, i32 -3, i32 1
  %cond = add nsw i32 %cond.v, %b
  ret i32 %cond
}

; int csinc5 (int a, int b) { return a ? b+1 : b-4095; }
define dso_local i32 @csinc5(i32 %a, i32 %b) {
; CHECK-LABEL: csinc5:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub w8, w1, #4095
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csinc w0, w8, w1, eq
; CHECK-NEXT:    ret
entry:
  %tobool.not = icmp eq i32 %a, 0
  %cond.v = select i1 %tobool.not, i32 -4095, i32 1
  %cond = add nsw i32 %cond.v, %b
  ret i32 %cond
}

; int csinc6 (int a, int b) { return a ? b+1 : b-4096; }
define dso_local i32 @csinc6(i32 %a, i32 %b) {
; CHECK-LABEL: csinc6:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub w8, w1, #1, lsl #12 // =4096
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csinc w0, w8, w1, eq
; CHECK-NEXT:    ret
entry:
  %tobool.not = icmp eq i32 %a, 0
  %cond.v = select i1 %tobool.not, i32 -4096, i32 1
  %cond = add nsw i32 %cond.v, %b
  ret i32 %cond
}

; prevent larger constants (the add laid after csinc)
; int csinc7 (int a, int b) { return a ? b+1 : b-4097; }
define dso_local i32 @csinc7(i32 %a, i32 %b) {
; CHECK-LABEL: csinc7:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #-4097
; CHECK-NEXT:    csinc w8, w8, wzr, eq
; CHECK-NEXT:    add w0, w8, w1
; CHECK-NEXT:    ret
entry:
  %tobool.not = icmp eq i32 %a, 0
  %cond.v = select i1 %tobool.not, i32 -4097, i32 1
  %cond = add nsw i32 %cond.v, %b
  ret i32 %cond
}
