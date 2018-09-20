; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
target datalayout = "p:16:16"

@offsets = external dso_local global [4 x i16], align 1

define void @PR38984() {
; CHECK-LABEL: @PR38984(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i16, i16* getelementptr ([4 x i16], [4 x i16]* @offsets, i16 0, i16 undef), align 1
  %1 = insertelement <4 x i16> undef, i16 %0, i32 3
  %2 = sub <4 x i16> zeroinitializer, %1
  %3 = sext <4 x i16> %2 to <4 x i32>
  %4 = getelementptr inbounds i64, i64* null, <4 x i32> %3
  %5 = ptrtoint <4 x i64*> %4 to <4 x i32>
  %6 = getelementptr inbounds i64, i64* null, <4 x i16> %2
  %7 = ptrtoint <4 x i64*> %6 to <4 x i32>
  %8 = icmp eq <4 x i32> %5, %7
  %9 = select <4 x i1> %8, <4 x i16> zeroinitializer, <4 x i16> <i16 1, i16 1, i16 1, i16 1>
  %10 = sext <4 x i16> %9 to <4 x i32>
  ret void
}
