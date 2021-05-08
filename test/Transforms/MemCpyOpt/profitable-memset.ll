; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -memcpyopt -S -verify-memoryssa | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"

define void @foo(i64* nocapture %P) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i64* [[P:%.*]] to i16*
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, i16* [[TMP0]], i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[ARRAYIDX]] to i32*
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i16, i16* [[TMP0]], i64 3
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i16* [[TMP0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 2 [[TMP2]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast i64* %P to i16*
  %arrayidx = getelementptr inbounds i16, i16* %0, i64 1
  %1 = bitcast i16* %arrayidx to i32*
  %arrayidx1 = getelementptr inbounds i16, i16* %0, i64 3
  store i16 0, i16* %0, align 2
  store i32 0, i32* %1, align 4
  store i16 0, i16* %arrayidx1, align 2
  ret void
}

