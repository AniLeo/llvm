; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S -o - %s | FileCheck %s
; Tests that we preserve the inrange attribute on indices where possible.

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.A = type { ptr }

@vt = external global [3 x ptr]

define ptr @f0() {
; CHECK-LABEL: @f0(
; CHECK-NEXT:    ret ptr getelementptr inbounds ([3 x ptr], ptr @vt, inrange i64 0, i64 2)
;
  ret ptr getelementptr (ptr, ptr getelementptr inbounds ([3 x ptr], ptr @vt, inrange i64 0, i64 1), i64 1)
}

define ptr @f1() {
; CHECK-LABEL: @f1(
; CHECK-NEXT:    ret ptr getelementptr inbounds ([3 x ptr], ptr @vt, i64 0, i64 2)
;
  ret ptr getelementptr (ptr, ptr getelementptr inbounds ([3 x ptr], ptr @vt, i64 0, inrange i64 1), i64 1)
}

define ptr @f2() {
; CHECK-LABEL: @f2(
; CHECK-NEXT:    ret ptr getelementptr ([3 x ptr], ptr @vt, i64 1, i64 1)
;
  ret ptr getelementptr (ptr, ptr getelementptr inbounds ([3 x ptr], ptr @vt, i64 0, inrange i64 1), i64 3)
}
