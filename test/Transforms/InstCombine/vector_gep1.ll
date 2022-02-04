; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@G1 = global i8 zeroinitializer

define <2 x i1> @test(<2 x i8*> %a, <2 x i8*> %b) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i8*> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %c = icmp eq <2 x i8*> %a, %b
  ret <2 x i1> %c
}

define <2 x i1> @test2(<2 x i8*> %a) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %c = inttoptr <2 x i32> <i32 1, i32 2> to <2 x i8*>
  %d = icmp ult <2 x i8*> %c, zeroinitializer
  ret <2 x i1> %d
}

define <2 x i1> @test3(<2 x i8*> %a) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %g = getelementptr i8, <2 x i8*> %a, <2 x i32> <i32 1, i32 0>
  %B = icmp ult <2 x i8*> %g, zeroinitializer
  ret <2 x i1> %B
}

define <1 x i1> @test4(<1 x i8*> %a) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret <1 x i1> zeroinitializer
;
  %g = getelementptr i8, <1 x i8*> %a, <1 x i32> <i32 1>
  %B = icmp ult <1 x i8*> %g, zeroinitializer
  ret <1 x i1> %B
}

define <2 x i1> @test5(<2 x i8*> %a) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %w = getelementptr i8, <2 x i8*> %a, <2 x i32> zeroinitializer
  %e = getelementptr i8, <2 x i8*> %w, <2 x i32> <i32 5, i32 9>
  %g = getelementptr i8, <2 x i8*> %e, <2 x i32> <i32 1, i32 0>
  %B = icmp ult <2 x i8*> %g, zeroinitializer
  ret <2 x i1> %B
}

define <2 x i32*> @test7(<2 x {i32, i32}*> %a) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[W:%.*]] = getelementptr { i32, i32 }, <2 x { i32, i32 }*> [[A:%.*]], <2 x i64> <i64 5, i64 9>, <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x i32*> [[W]]
;
  %w = getelementptr {i32, i32}, <2 x {i32, i32}*> %a, <2 x i32> <i32 5, i32 9>, <2 x i32> zeroinitializer
  ret <2 x i32*> %w
}

define <vscale x 2 x i1> @test8() {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret <vscale x 2 x i1> zeroinitializer
;
  %ins = insertelement <vscale x 2 x i32> undef, i32 1, i32 0
  %b = shufflevector <vscale x 2 x i32> %ins, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %c = inttoptr <vscale x 2 x i32> %b to <vscale x 2 x i8*>
  %d = icmp ult <vscale x 2 x i8*> %c, zeroinitializer
  ret <vscale x 2 x i1> %d
}
