; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=rel-lookup-table-converter -relocation-model=pic -S | FileCheck %s
; REQUIRES: x86-registered-target

target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnux32"

@a = internal constant i32 0, align 4
@b = internal constant i32 0, align 4
@c = internal constant i32 0, align 4

@table = private unnamed_addr constant [3 x ptr] [ptr @a, ptr @b, ptr @c]

define ptr @test(i32 %cond) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [3 x ptr], ptr @table, i32 0, i32 [[COND:%.*]]
; CHECK-NEXT:    [[SWITCH_LOAD:%.*]] = load ptr, ptr [[SWITCH_GEP]], align 8
; CHECK-NEXT:    ret ptr [[SWITCH_LOAD]]
;
  %switch.gep = getelementptr inbounds [3 x ptr], ptr @table, i32 0, i32 %cond
  %switch.load = load ptr, ptr %switch.gep, align 8
  ret ptr %switch.load
}
