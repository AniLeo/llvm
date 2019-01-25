; XFAIL: *
; REQUIRES: asserts
; RUN: opt -S -enable-loop-simplifycfg-term-folding=true -loop-simplifycfg -debug-only=loop-simplifycfg -verify-loop-info -verify-dom-info -verify-loop-lcssa 2>&1 < %s | FileCheck %s
; RUN: opt -S -enable-loop-simplifycfg-term-folding=true -passes='require<domtree>,loop(simplify-cfg)' -debug-only=loop-simplifycfg -verify-loop-info -verify-dom-info -verify-loop-lcssa 2>&1 < %s | FileCheck %s
; RUN: opt -S -enable-loop-simplifycfg-term-folding=true -loop-simplifycfg -enable-mssa-loop-dependency=true -verify-memoryssa -debug-only=loop-simplifycfg -verify-loop-info -verify-dom-info -verify-loop-lcssa 2>&1 < %s | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"

define void @test() {

; CHECK-LABEL: @test(

  br label %bb1

bb1:                                              ; preds = %bb4, %0
  br label %bb2

bb2:                                              ; preds = %bb6, %bb1
  br label %bb3

bb3:                                              ; preds = %bb8, %bb3, %bb2
  br i1 false, label %bb4, label %bb3

bb4:                                              ; preds = %bb8, %bb3
  br i1 undef, label %bb1, label %bb6

bb6:                                              ; preds = %bb4
  br i1 undef, label %bb2, label %bb8

bb8:                                              ; preds = %bb6
  br i1 true, label %bb4, label %bb3
}

define void @test_many_subloops(i1 %c) {

; CHECK-LABEL: @test_many_subloops(

  br label %bb1

bb1:
  br label %bb2

bb2:
  br label %bb3

bb3:
  br i1 false, label %bb4, label %bb3

bb4:
  br i1 undef, label %bb1, label %subloop1

subloop1:
  br i1 %c, label %subloop2, label %subloop11

subloop11:
  br i1 %c, label %subloop11, label %subloop12

subloop12:
  br i1 %c, label %subloop12, label %subloop13

subloop13:
  br i1 %c, label %subloop13, label %subloop1_latch

subloop1_latch:
  br label %subloop1

subloop2:
  br i1 %c, label %bb6, label %subloop21

subloop21:
  br i1 %c, label %subloop21, label %subloop22

subloop22:
  br i1 %c, label %subloop22, label %subloop23

subloop23:
  br i1 %c, label %subloop23, label %subloop2_latch

subloop2_latch:
  br label %subloop2

bb6:
  br i1 undef, label %bb2, label %bb8

bb8:
  br i1 true, label %bb4, label %bb3
}
