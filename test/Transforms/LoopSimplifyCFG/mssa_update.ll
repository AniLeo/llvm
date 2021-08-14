; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: asserts
; RUN: opt -S -enable-loop-simplifycfg-term-folding=true -passes='require<domtree>,loop(loop-simplifycfg)' -verify-loop-info -verify-dom-info -verify-loop-lcssa < %s | FileCheck %s
; RUN: opt -S -enable-loop-simplifycfg-term-folding=true -loop-simplifycfg -verify-memoryssa -verify-loop-info -verify-dom-info -verify-loop-lcssa < %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

; Make sure we update MSSA properly.
define void @test(i32* %a, i32* %b) {
; CHECK-LABEL: @test(

entry:
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %i.inc, %latch ]
  br label %switch.bb

switch.bb:
  switch i2 1, label %default [
    i2 1, label %case
  ]

case:
  br label %latch

default:
  unreachable

latch:
  store i32 %i, i32* %a
  store i32 %i, i32* %b
  %i.inc = add nsw i32 %i, 1
  %exitcond = icmp eq i32 %i.inc, 4
  br i1 %exitcond, label %exit, label %for.body

exit:
  ret void
}
