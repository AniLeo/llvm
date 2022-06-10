; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine %s -S -o - | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%test1.struct = type { i32, i32 }
@test1.aligned_glbl = global %test1.struct zeroinitializer, align 4
define void @test1(i64 *%ptr) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    store i64 0, i64* [[PTR:%.*]], align 8
; CHECK-NEXT:    ret void
;
  store i64 and (i64 ptrtoint (i32* getelementptr (%test1.struct, %test1.struct* @test1.aligned_glbl, i32 0, i32 1) to i64), i64 3), i64* %ptr
  ret void
}

; Make sure we do not infinite loop trying to convert a constant expression back-and-forth.

@channel_wg4idx = external dso_local constant [9 x i8], align 1

define i64 @OpenFilter(i64 %x) {
; CHECK-LABEL: @OpenFilter(
; CHECK-NEXT:    [[T:%.*]] = sub i64 [[X:%.*]], zext (i8 ptrtoint ([9 x i8]* @channel_wg4idx to i8) to i64)
; CHECK-NEXT:    [[R:%.*]] = and i64 [[T]], 255
; CHECK-NEXT:    ret i64 [[R]]
;
  %sub = sub i64 %x, ptrtoint ([9 x i8]* @channel_wg4idx to i64)
  %t = trunc i64 %sub to i8
  %r = zext i8 %t to i64
  ret i64 %r
}
