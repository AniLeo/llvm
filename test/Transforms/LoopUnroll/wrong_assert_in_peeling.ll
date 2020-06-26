; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -loop-unroll | FileCheck %s
; RUN: opt -S < %s -passes=loop-unroll | FileCheck %s
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:1-p2:32:8:8:32-ni:2"
target triple = "x86_64-unknown-linux-gnu"

define i32 @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP:%.*]] = phi i32 [ -147, [[BB:%.*]] ], [ [[TMP14:%.*]], [[BB13:%.*]] ]
; CHECK-NEXT:    br label [[BB2_PEEL_BEGIN:%.*]]
; CHECK:       bb2.peel.begin:
; CHECK-NEXT:    br label [[BB2_PEEL:%.*]]
; CHECK:       bb2.peel:
; CHECK-NEXT:    [[TMP4_PEEL:%.*]] = add nsw i32 undef, [[TMP]]
; CHECK-NEXT:    br label [[BB5_PEEL:%.*]]
; CHECK:       bb5.peel:
; CHECK-NEXT:    [[TMP6_PEEL:%.*]] = icmp eq i32 undef, 33
; CHECK-NEXT:    br i1 [[TMP6_PEEL]], label [[BB7_PEEL:%.*]], label [[BB15_LOOPEXIT2:%.*]]
; CHECK:       bb7.peel:
; CHECK-NEXT:    [[TMP8_PEEL:%.*]] = sub nsw i32 undef, undef
; CHECK-NEXT:    [[TMP9_PEEL:%.*]] = icmp eq i32 [[TMP8_PEEL]], 0
; CHECK-NEXT:    br i1 [[TMP9_PEEL]], label [[BB10_PEEL:%.*]], label [[BB10_PEEL]]
; CHECK:       bb10.peel:
; CHECK-NEXT:    [[TMP11_PEEL:%.*]] = icmp eq i8 undef, 0
; CHECK-NEXT:    br i1 [[TMP11_PEEL]], label [[BB12_PEEL:%.*]], label [[BB17_LOOPEXIT3:%.*]]
; CHECK:       bb12.peel:
; CHECK-NEXT:    br i1 false, label [[BB13]], label [[BB2_PEEL_NEXT:%.*]]
; CHECK:       bb2.peel.next:
; CHECK-NEXT:    br label [[BB2_PEEL_NEXT1:%.*]]
; CHECK:       bb2.peel.next1:
; CHECK-NEXT:    br label [[BB1_PEEL_NEWPH:%.*]]
; CHECK:       bb1.peel.newph:
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP3:%.*]] = phi i32 [ [[TMP4_PEEL]], [[BB1_PEEL_NEWPH]] ], [ [[TMP4:%.*]], [[BB12:%.*]] ]
; CHECK-NEXT:    [[TMP4]] = add nsw i32 [[TMP3]], [[TMP]]
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    br i1 false, label [[BB7:%.*]], label [[BB15_LOOPEXIT:%.*]]
; CHECK:       bb7:
; CHECK-NEXT:    br i1 undef, label [[BB10:%.*]], label [[BB10]]
; CHECK:       bb10:
; CHECK-NEXT:    br i1 false, label [[BB12]], label [[BB17_LOOPEXIT:%.*]]
; CHECK:       bb12:
; CHECK-NEXT:    br i1 false, label [[BB13_LOOPEXIT:%.*]], label [[BB2]], !llvm.loop !0
; CHECK:       bb13.loopexit:
; CHECK-NEXT:    br label [[BB13]]
; CHECK:       bb13:
; CHECK-NEXT:    [[TMP14]] = add nsw i32 [[TMP]], -1
; CHECK-NEXT:    br label [[BB1]]
; CHECK:       bb15.loopexit:
; CHECK-NEXT:    br label [[BB15:%.*]]
; CHECK:       bb15.loopexit2:
; CHECK-NEXT:    br label [[BB15]]
; CHECK:       bb15:
; CHECK-NEXT:    [[TMP16:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32(i32 17) [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[TMP16]]
; CHECK:       bb17.loopexit:
; CHECK-NEXT:    br label [[BB17:%.*]]
; CHECK:       bb17.loopexit3:
; CHECK-NEXT:    br label [[BB17]]
; CHECK:       bb17:
; CHECK-NEXT:    [[TMP18:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32(i32 6) [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[TMP18]]
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb13, %bb
  %tmp = phi i32 [ -147, %bb ], [ %tmp14, %bb13 ]
  br label %bb2

bb2:                                              ; preds = %bb12, %bb1
  %tmp3 = phi i32 [ undef, %bb1 ], [ %tmp4, %bb12 ]
  %tmp4 = add nsw i32 %tmp3, %tmp
  br label %bb5

bb5:                                              ; preds = %bb2
  %tmp6 = icmp eq i32 undef, 33
  br i1 %tmp6, label %bb7, label %bb15

bb7:                                              ; preds = %bb5
  %tmp8 = sub nsw i32 %tmp3, undef
  %tmp9 = icmp eq i32 %tmp8, 0
  br i1 %tmp9, label %bb10, label %bb10

bb10:                                             ; preds = %bb7, %bb7
  %tmp11 = icmp eq i8 undef, 0
  br i1 %tmp11, label %bb12, label %bb17

bb12:                                             ; preds = %bb10
  br i1 false, label %bb13, label %bb2

bb13:                                             ; preds = %bb12
  %tmp14 = add nsw i32 %tmp, -1
  br label %bb1

bb15:                                             ; preds = %bb5
  %tmp16 = call i32 (...) @llvm.experimental.deoptimize.i32(i32 17) [ "deopt"() ]
  ret i32 %tmp16

bb17:                                             ; preds = %bb10
  %tmp18 = call i32 (...) @llvm.experimental.deoptimize.i32(i32 6) [ "deopt"() ]
  ret i32 %tmp18
}

declare i32 @llvm.experimental.deoptimize.i32(...)
