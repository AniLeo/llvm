; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -dse < %s | FileCheck %s

declare void @llvm.memcpy.p0i8.p0i8.i8(i8* nocapture, i8* nocapture, i8, i1) nounwind
declare void @llvm.memmove.p0i8.p0i8.i8(i8* nocapture, i8* nocapture, i8, i1) nounwind
declare void @llvm.memset.p0i8.i8(i8* nocapture, i8, i8, i1) nounwind

define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret void
;
  %A = alloca i8
  %B = alloca i8

  store i8 0, i8* %A  ;; Written to by memcpy

  call void @llvm.memcpy.p0i8.p0i8.i8(i8* %A, i8* %B, i8 -1, i1 false)

  ret void
}

define void @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret void
;
  %A = alloca i8
  %B = alloca i8

  store i8 0, i8* %A  ;; Written to by memmove

  call void @llvm.memmove.p0i8.p0i8.i8(i8* %A, i8* %B, i8 -1, i1 false)

  ret void
}

define void @test3() {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret void
;
  %A = alloca i8
  %B = alloca i8

  store i8 0, i8* %A  ;; Written to by memset

  call void @llvm.memset.p0i8.i8(i8* %A, i8 0, i8 -1, i1 false)

  ret void
}
