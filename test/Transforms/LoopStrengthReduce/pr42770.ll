; Check that it doesn't crash
; REQUIRES: asserts
; XFAIL: *
; RUN: opt < %s -loop-reduce -S

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"

define void @foo() {
bb:
  br label %bb4

bb1:                                              ; preds = %bb13
  %tmp = shl i64 %tmp14, 32
  %tmp2 = add i64 %tmp, 1
  %tmp3 = ashr i64 %tmp2, 32
  ret void

bb4:                                              ; preds = %bb13, %bb
  %tmp5 = phi i64 [ 2, %bb ], [ %tmp14, %bb13 ]
  %tmp6 = add i64 %tmp5, 4
  %tmp7 = trunc i64 %tmp6 to i16
  %tmp8 = urem i16 %tmp7, 3
  %tmp9 = mul i16 %tmp8, 2
  %tmp10 = icmp eq i16 %tmp9, 1
  br i1 %tmp10, label %bb11, label %bb13

bb11:                                             ; preds = %bb4
  %tmp12 = udiv i16 1, %tmp7
  unreachable

bb13:                                             ; preds = %bb4
  %tmp14 = add nuw nsw i64 %tmp5, 6
  br i1 undef, label %bb1, label %bb4
}
