; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -basic-aa -gvn 2>&1 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128"
target triple = "x86_64-apple-darwin10.0"

declare noalias i8* @malloc(i64) nounwind
declare noalias i8* @calloc(i64, i64)
declare noalias i8* @_Znwm(i64)
declare void @escape(i8*)

define i8 @test_malloc(i8* %p) {
; CHECK-LABEL: @test_malloc(
; CHECK-NEXT:    [[OBJ:%.*]] = call i8* @malloc(i64 16)
; CHECK-NEXT:    call void @escape(i8* [[OBJ]])
; CHECK-NEXT:    ret i8 0
;
  %v1 = load i8, i8* %p
  %obj = call i8* @malloc(i64 16)
  %v2 = load i8, i8* %p
  %sub = sub i8 %v1, %v2
  call void @escape(i8* %obj)
  ret i8 %sub
}

define i8 @test_calloc(i8* %p) {
; CHECK-LABEL: @test_calloc(
; CHECK-NEXT:    [[OBJ:%.*]] = call i8* @calloc(i64 1, i64 16)
; CHECK-NEXT:    call void @escape(i8* [[OBJ]])
; CHECK-NEXT:    ret i8 0
;
  %v1 = load i8, i8* %p
  %obj = call i8* @calloc(i64 1, i64 16)
  %v2 = load i8, i8* %p
  %sub = sub i8 %v1, %v2
  call void @escape(i8* %obj)
  ret i8 %sub
}

define i8 @test_opnew(i8* %p) {
; CHECK-LABEL: @test_opnew(
; CHECK-NEXT:    [[OBJ:%.*]] = call i8* @_Znwm(i64 16)
; CHECK-NEXT:    call void @escape(i8* [[OBJ]])
; CHECK-NEXT:    ret i8 0
;
  %v1 = load i8, i8* %p
  %obj = call i8* @_Znwm(i64 16)
  %v2 = load i8, i8* %p
  %sub = sub i8 %v1, %v2
  call void @escape(i8* %obj)
  ret i8 %sub
}


