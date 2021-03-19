; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine %s -S -o - | FileCheck %s

; This tests that llvm.annotation does not prevent load combining.

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-grtev4-linux-gnu"

declare i32 @llvm.annotation.i32(i32, i8*, i8*, i32) #1

define dso_local i32 @annotated(i32* %c) local_unnamed_addr #0 {
; CHECK-LABEL: @annotated(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[C:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.annotation.i32(i32 [[TMP0]], i8* undef, i8* undef, i32 undef)
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[C]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %0 = load i32, i32* %c, align 4
  %1 = call i32 @llvm.annotation.i32(i32 %0, i8* undef, i8* undef, i32 undef)
  %2 = load i32, i32* %c, align 4
  %add = add nsw i32 %1, %2
  ret i32 %add
}

attributes #0 = { nofree nounwind uwtable willreturn mustprogress }
