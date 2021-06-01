; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu -mcpu=bdver2 < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @hoge() {
; CHECK-LABEL: @hoge(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 undef, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    [[T:%.*]] = select i1 undef, i16 undef, i16 15
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i16> poison, i16 [[T]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = sext <2 x i16> [[TMP0]] to <2 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = sub nsw <2 x i32> <i32 poison, i32 63>, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = sub <2 x i32> [[TMP2]], poison
; CHECK-NEXT:    [[SHUFFLE10:%.*]] = shufflevector <2 x i32> [[TMP3]], <2 x i32> poison, <4 x i32> <i32 0, i32 0, i32 0, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = add <4 x i32> [[SHUFFLE10]], <i32 15, i32 31, i32 47, i32 poison>
; CHECK-NEXT:    [[TMP5:%.*]] = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> [[TMP4]])
; CHECK-NEXT:    [[T19:%.*]] = select i1 undef, i32 [[TMP5]], i32 undef
; CHECK-NEXT:    [[T20:%.*]] = icmp sgt i32 [[T19]], 63
; CHECK-NEXT:    [[TMP6:%.*]] = sub nsw <2 x i32> poison, [[TMP1]]
; CHECK-NEXT:    [[TMP7:%.*]] = sub <2 x i32> [[TMP6]], poison
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i32> [[TMP7]], <2 x i32> poison, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
; CHECK-NEXT:    [[TMP8:%.*]] = add nsw <4 x i32> [[SHUFFLE]], <i32 -49, i32 -33, i32 -33, i32 -17>
; CHECK-NEXT:    [[TMP9:%.*]] = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> [[TMP8]])
; CHECK-NEXT:    [[OP_EXTRA:%.*]] = icmp slt i32 [[TMP9]], undef
; CHECK-NEXT:    [[OP_EXTRA1:%.*]] = select i1 [[OP_EXTRA]], i32 [[TMP9]], i32 undef
; CHECK-NEXT:    [[OP_EXTRA2:%.*]] = icmp slt i32 [[OP_EXTRA1]], undef
; CHECK-NEXT:    [[OP_EXTRA3:%.*]] = select i1 [[OP_EXTRA2]], i32 [[OP_EXTRA1]], i32 undef
; CHECK-NEXT:    [[OP_EXTRA4:%.*]] = icmp slt i32 [[OP_EXTRA3]], undef
; CHECK-NEXT:    [[OP_EXTRA5:%.*]] = select i1 [[OP_EXTRA4]], i32 [[OP_EXTRA3]], i32 undef
; CHECK-NEXT:    [[OP_EXTRA6:%.*]] = icmp slt i32 [[OP_EXTRA5]], undef
; CHECK-NEXT:    [[OP_EXTRA7:%.*]] = select i1 [[OP_EXTRA6]], i32 [[OP_EXTRA5]], i32 undef
; CHECK-NEXT:    [[OP_EXTRA8:%.*]] = icmp slt i32 [[OP_EXTRA7]], undef
; CHECK-NEXT:    [[OP_EXTRA9:%.*]] = select i1 [[OP_EXTRA8]], i32 [[OP_EXTRA7]], i32 undef
; CHECK-NEXT:    [[T45:%.*]] = icmp sgt i32 undef, [[OP_EXTRA9]]
; CHECK-NEXT:    unreachable
;
bb:
  br i1 undef, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  ret void

bb2:                                              ; preds = %bb
  %t = select i1 undef, i16 undef, i16 15
  %t3 = sext i16 undef to i32
  %t4 = sext i16 %t to i32
  %t5 = sub nsw i32 undef, %t4
  %t6 = sub i32 %t5, undef
  %t7 = sub nsw i32 63, %t3
  %t8 = sub i32 %t7, undef
  %t9 = add i32 %t8, undef
  %t10 = add nsw i32 %t6, 15
  %t11 = icmp sgt i32 %t9, %t10
  %t12 = select i1 %t11, i32 %t9, i32 %t10
  %t13 = add nsw i32 %t6, 31
  %t14 = icmp sgt i32 %t12, %t13
  %t15 = select i1 %t14, i32 %t12, i32 %t13
  %t16 = add nsw i32 %t6, 47
  %t17 = icmp sgt i32 %t15, %t16
  %t18 = select i1 %t17, i32 %t15, i32 %t16
  %t19 = select i1 undef, i32 %t18, i32 undef
  %t20 = icmp sgt i32 %t19, 63
  %t21 = sub nsw i32 undef, %t3
  %t22 = sub i32 %t21, undef
  %t23 = sub nsw i32 undef, %t4
  %t24 = sub i32 %t23, undef
  %t25 = add nsw i32 %t24, -49
  %t26 = icmp sgt i32 %t25, undef
  %t27 = select i1 %t26, i32 undef, i32 %t25
  %t28 = icmp sgt i32 %t27, undef
  %t29 = select i1 %t28, i32 undef, i32 %t27
  %t30 = add nsw i32 %t22, -33
  %t31 = icmp sgt i32 %t30, undef
  %t32 = select i1 %t31, i32 undef, i32 %t30
  %t33 = icmp sgt i32 %t32, %t29
  %t34 = select i1 %t33, i32 %t29, i32 %t32
  %t35 = add nsw i32 %t24, -33
  %t36 = icmp sgt i32 %t35, undef
  %t37 = select i1 %t36, i32 undef, i32 %t35
  %t38 = icmp sgt i32 %t37, %t34
  %t39 = select i1 %t38, i32 %t34, i32 %t37
  %t40 = add nsw i32 %t22, -17
  %t41 = icmp sgt i32 %t40, undef
  %t42 = select i1 %t41, i32 undef, i32 %t40
  %t43 = icmp sgt i32 %t42, %t39
  %t44 = select i1 %t43, i32 %t39, i32 %t42
  %t45 = icmp sgt i32 undef, %t44
  unreachable
}

