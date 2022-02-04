; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@hello_world = constant [13 x i8] c"hello world\0A\00"

declare void @sprintf(i8*, i8*, ...)

; Check that a sprintf call, that would otherwise be optimized, but with
; optimized out return type, doesn't crash the optimizer.

define void @test_simplify1(i8* %dst) {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    call void (i8*, i8*, ...) @sprintf(i8* [[DST:%.*]], i8* getelementptr inbounds ([13 x i8], [13 x i8]* @hello_world, i32 0, i32 0))
; CHECK-NEXT:    ret void
;
  %fmt = getelementptr [13 x i8], [13 x i8]* @hello_world, i32 0, i32 0
  call void (i8*, i8*, ...) @sprintf(i8* %dst, i8* %fmt)
  ret void
}
