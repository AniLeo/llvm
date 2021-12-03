; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=thumbv8.1m.main -mattr=+mve %s -S -loop-reduce -o - | FileCheck %s
target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv8.1m-arm-none-eabi"

define float @vctp8(float* %0, i32 %1) {
; CHECK-LABEL: @vctp8(
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue { <4 x i32>, i32 } [[TMP3]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw i32 [[TMP1:%.*]], -1
; CHECK-NEXT:    [[TMP6:%.*]] = ptrtoint float* [[TMP0:%.*]] to i32
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x i32> undef, i32 [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = add <4 x i32> [[TMP7]], <i32 -32, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = add <4 x i32> [[TMP4]], [[TMP9]]
; CHECK-NEXT:    br label [[TMP11:%.*]]
; CHECK:       11:
; CHECK-NEXT:    [[TMP12:%.*]] = phi i32 [ [[TMP5]], [[TMP2:%.*]] ], [ [[TMP21:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = phi <4 x float> [ zeroinitializer, [[TMP2]] ], [ [[TMP19:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP14:%.*]] = phi <4 x i32> [ [[TMP10]], [[TMP2]] ], [ [[TMP17:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = tail call <16 x i1> @llvm.arm.mve.vctp8(i32 [[TMP12]])
; CHECK-NEXT:    [[MASK:%.*]] = tail call <4 x i1> @v16i1_to_v4i1(<16 x i1> [[TMP15]])
; CHECK-NEXT:    [[TMP16:%.*]] = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> [[TMP14]], i32 32, <4 x i1> [[MASK]])
; CHECK-NEXT:    [[TMP17]] = extractvalue { <4 x float>, <4 x i32> } [[TMP16]], 1
; CHECK-NEXT:    [[TMP18:%.*]] = extractvalue { <4 x float>, <4 x i32> } [[TMP16]], 0
; CHECK-NEXT:    [[TMP19]] = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> [[TMP13]], <4 x float> [[TMP18]], <4 x i1> [[MASK]], <4 x float> [[TMP13]])
; CHECK-NEXT:    [[TMP20:%.*]] = icmp sgt i32 [[TMP12]], 4
; CHECK-NEXT:    [[TMP21]] = add i32 [[TMP12]], -4
; CHECK-NEXT:    br i1 [[TMP20]], label [[TMP11]], label [[TMP22:%.*]]
; CHECK:       22:
; CHECK-NEXT:    [[TMP23:%.*]] = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> [[TMP19]])
; CHECK-NEXT:    [[TMP24:%.*]] = sitofp i32 [[TMP23]] to float
; CHECK-NEXT:    [[TMP25:%.*]] = tail call float @llvm.fabs.f32(float [[TMP24]])
; CHECK-NEXT:    ret float [[TMP25]]
;
  %3 = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
  %4 = extractvalue { <4 x i32>, i32 } %3, 0
  %5 = add nsw i32 %1, -1
  %6 = ptrtoint float* %0 to i32
  %7 = insertelement <4 x i32> undef, i32 %6, i32 0
  %8 = add <4 x i32> %7, <i32 -32, i32 undef, i32 undef, i32 undef>
  %9 = shufflevector <4 x i32> %8, <4 x i32> undef, <4 x i32> zeroinitializer
  %10 = add <4 x i32> %4, %9
  br label %11

11:                                               ; preds = %11, %2
  %12 = phi i32 [ %5, %2 ], [ %20, %11 ]
  %13 = phi <4 x float> [ zeroinitializer, %2 ], [ %19, %11 ]
  %14 = phi <4 x i32> [ %10, %2 ], [ %17, %11 ]
  %15 = tail call <16 x i1> @llvm.arm.mve.vctp8(i32 %12)
  %mask = tail call <4 x i1> @v16i1_to_v4i1(<16 x i1> %15)
  %16 = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> %14, i32 32, <4 x i1> %mask)
  %17 = extractvalue { <4 x float>, <4 x i32> } %16, 1
  %18 = extractvalue { <4 x float>, <4 x i32> } %16, 0
  %19 = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> %13, <4 x float> %18, <4 x i1> %mask, <4 x float> %13)
  %20 = add nsw i32 %12, -4
  %21 = icmp sgt i32 %12, 4
  br i1 %21, label %11, label %22

22:                                               ; preds = %11
  %23 = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> %19)
  %24 = sitofp i32 %23 to float
  %25 = tail call float @llvm.fabs.f32(float %24)
  ret float %25
}

define float @vctp16(float* %0, i32 %1) {
; CHECK-LABEL: @vctp16(
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue { <4 x i32>, i32 } [[TMP3]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw i32 [[TMP1:%.*]], -1
; CHECK-NEXT:    [[TMP6:%.*]] = ptrtoint float* [[TMP0:%.*]] to i32
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x i32> undef, i32 [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = add <4 x i32> [[TMP7]], <i32 -32, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = add <4 x i32> [[TMP4]], [[TMP9]]
; CHECK-NEXT:    br label [[TMP11:%.*]]
; CHECK:       11:
; CHECK-NEXT:    [[TMP12:%.*]] = phi i32 [ [[TMP5]], [[TMP2:%.*]] ], [ [[TMP21:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = phi <4 x float> [ zeroinitializer, [[TMP2]] ], [ [[TMP19:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP14:%.*]] = phi <4 x i32> [ [[TMP10]], [[TMP2]] ], [ [[TMP17:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = tail call <8 x i1> @llvm.arm.mve.vctp16(i32 [[TMP12]])
; CHECK-NEXT:    [[MASK:%.*]] = tail call <4 x i1> @v8i1_to_v4i1(<8 x i1> [[TMP15]])
; CHECK-NEXT:    [[TMP16:%.*]] = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> [[TMP14]], i32 32, <4 x i1> [[MASK]])
; CHECK-NEXT:    [[TMP17]] = extractvalue { <4 x float>, <4 x i32> } [[TMP16]], 1
; CHECK-NEXT:    [[TMP18:%.*]] = extractvalue { <4 x float>, <4 x i32> } [[TMP16]], 0
; CHECK-NEXT:    [[TMP19]] = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> [[TMP13]], <4 x float> [[TMP18]], <4 x i1> [[MASK]], <4 x float> [[TMP13]])
; CHECK-NEXT:    [[TMP20:%.*]] = icmp sgt i32 [[TMP12]], 4
; CHECK-NEXT:    [[TMP21]] = add i32 [[TMP12]], -4
; CHECK-NEXT:    br i1 [[TMP20]], label [[TMP11]], label [[TMP22:%.*]]
; CHECK:       22:
; CHECK-NEXT:    [[TMP23:%.*]] = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> [[TMP19]])
; CHECK-NEXT:    [[TMP24:%.*]] = sitofp i32 [[TMP23]] to float
; CHECK-NEXT:    [[TMP25:%.*]] = tail call float @llvm.fabs.f32(float [[TMP24]])
; CHECK-NEXT:    ret float [[TMP25]]
;
  %3 = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
  %4 = extractvalue { <4 x i32>, i32 } %3, 0
  %5 = add nsw i32 %1, -1
  %6 = ptrtoint float* %0 to i32
  %7 = insertelement <4 x i32> undef, i32 %6, i32 0
  %8 = add <4 x i32> %7, <i32 -32, i32 undef, i32 undef, i32 undef>
  %9 = shufflevector <4 x i32> %8, <4 x i32> undef, <4 x i32> zeroinitializer
  %10 = add <4 x i32> %4, %9
  br label %11

11:                                               ; preds = %11, %2
  %12 = phi i32 [ %5, %2 ], [ %20, %11 ]
  %13 = phi <4 x float> [ zeroinitializer, %2 ], [ %19, %11 ]
  %14 = phi <4 x i32> [ %10, %2 ], [ %17, %11 ]
  %15 = tail call <8 x i1> @llvm.arm.mve.vctp16(i32 %12)
  %mask = tail call <4 x i1> @v8i1_to_v4i1(<8 x i1> %15)
  %16 = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> %14, i32 32, <4 x i1> %mask)
  %17 = extractvalue { <4 x float>, <4 x i32> } %16, 1
  %18 = extractvalue { <4 x float>, <4 x i32> } %16, 0
  %19 = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> %13, <4 x float> %18, <4 x i1> %mask, <4 x float> %13)
  %20 = add nsw i32 %12, -4
  %21 = icmp sgt i32 %12, 4
  br i1 %21, label %11, label %22

22:                                               ; preds = %11
  %23 = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> %19)
  %24 = sitofp i32 %23 to float
  %25 = tail call float @llvm.fabs.f32(float %24)
  ret float %25
}

define float @vctpi32(float* %0, i32 %1) {
; CHECK-LABEL: @vctpi32(
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue { <4 x i32>, i32 } [[TMP3]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw i32 [[TMP1:%.*]], -1
; CHECK-NEXT:    [[TMP6:%.*]] = ptrtoint float* [[TMP0:%.*]] to i32
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x i32> undef, i32 [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = add <4 x i32> [[TMP7]], <i32 -32, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = add <4 x i32> [[TMP4]], [[TMP9]]
; CHECK-NEXT:    br label [[TMP11:%.*]]
; CHECK:       11:
; CHECK-NEXT:    [[TMP12:%.*]] = phi i32 [ [[TMP5]], [[TMP2:%.*]] ], [ [[TMP21:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = phi <4 x float> [ zeroinitializer, [[TMP2]] ], [ [[TMP19:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP14:%.*]] = phi <4 x i32> [ [[TMP10]], [[TMP2]] ], [ [[TMP17:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = tail call <4 x i1> @llvm.arm.mve.vctp32(i32 [[TMP12]])
; CHECK-NEXT:    [[TMP16:%.*]] = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> [[TMP14]], i32 32, <4 x i1> [[TMP15]])
; CHECK-NEXT:    [[TMP17]] = extractvalue { <4 x float>, <4 x i32> } [[TMP16]], 1
; CHECK-NEXT:    [[TMP18:%.*]] = extractvalue { <4 x float>, <4 x i32> } [[TMP16]], 0
; CHECK-NEXT:    [[TMP19]] = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> [[TMP13]], <4 x float> [[TMP18]], <4 x i1> [[TMP15]], <4 x float> [[TMP13]])
; CHECK-NEXT:    [[TMP20:%.*]] = icmp sgt i32 [[TMP12]], 4
; CHECK-NEXT:    [[TMP21]] = add i32 [[TMP12]], -4
; CHECK-NEXT:    br i1 [[TMP20]], label [[TMP11]], label [[TMP22:%.*]]
; CHECK:       22:
; CHECK-NEXT:    [[TMP23:%.*]] = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> [[TMP19]])
; CHECK-NEXT:    [[TMP24:%.*]] = sitofp i32 [[TMP23]] to float
; CHECK-NEXT:    [[TMP25:%.*]] = tail call float @llvm.fabs.f32(float [[TMP24]])
; CHECK-NEXT:    ret float [[TMP25]]
;
  %3 = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
  %4 = extractvalue { <4 x i32>, i32 } %3, 0
  %5 = add nsw i32 %1, -1
  %6 = ptrtoint float* %0 to i32
  %7 = insertelement <4 x i32> undef, i32 %6, i32 0
  %8 = add <4 x i32> %7, <i32 -32, i32 undef, i32 undef, i32 undef>
  %9 = shufflevector <4 x i32> %8, <4 x i32> undef, <4 x i32> zeroinitializer
  %10 = add <4 x i32> %4, %9
  br label %11

11:                                               ; preds = %11, %2
  %12 = phi i32 [ %5, %2 ], [ %20, %11 ]
  %13 = phi <4 x float> [ zeroinitializer, %2 ], [ %19, %11 ]
  %14 = phi <4 x i32> [ %10, %2 ], [ %17, %11 ]
  %15 = tail call <4 x i1> @llvm.arm.mve.vctp32(i32 %12)
  %16 = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> %14, i32 32, <4 x i1> %15)
  %17 = extractvalue { <4 x float>, <4 x i32> } %16, 1
  %18 = extractvalue { <4 x float>, <4 x i32> } %16, 0
  %19 = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> %13, <4 x float> %18, <4 x i1> %15, <4 x float> %13)
  %20 = add nsw i32 %12, -4
  %21 = icmp sgt i32 %12, 4
  br i1 %21, label %11, label %22

22:                                               ; preds = %11
  %23 = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> %19)
  %24 = sitofp i32 %23 to float
  %25 = tail call float @llvm.fabs.f32(float %24)
  ret float %25
}


define float @vctpi64(float* %0, i32 %1) {
; CHECK-LABEL: @vctpi64(
; CHECK-NEXT:    [[TMP3:%.*]] = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue { <4 x i32>, i32 } [[TMP3]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw i32 [[TMP1:%.*]], -1
; CHECK-NEXT:    [[TMP6:%.*]] = ptrtoint float* [[TMP0:%.*]] to i32
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x i32> undef, i32 [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = add <4 x i32> [[TMP7]], <i32 -32, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x i32> [[TMP8]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = add <4 x i32> [[TMP4]], [[TMP9]]
; CHECK-NEXT:    br label [[TMP11:%.*]]
; CHECK:       11:
; CHECK-NEXT:    [[TMP12:%.*]] = phi i32 [ [[TMP5]], [[TMP2:%.*]] ], [ [[TMP23:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = phi <4 x float> [ zeroinitializer, [[TMP2]] ], [ [[TMP21:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP14:%.*]] = phi <4 x i32> [ [[TMP10]], [[TMP2]] ], [ [[TMP19:%.*]], [[TMP11]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = call <2 x i1> @llvm.arm.mve.vctp64(i32 [[TMP12]])
; CHECK-NEXT:    [[TMP16:%.*]] = call i32 @llvm.arm.mve.pred.v2i.v2i1(<2 x i1> [[TMP15]])
; CHECK-NEXT:    [[TMP17:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP16]])
; CHECK-NEXT:    [[TMP18:%.*]] = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> [[TMP14]], i32 32, <4 x i1> [[TMP17]])
; CHECK-NEXT:    [[TMP19]] = extractvalue { <4 x float>, <4 x i32> } [[TMP18]], 1
; CHECK-NEXT:    [[TMP20:%.*]] = extractvalue { <4 x float>, <4 x i32> } [[TMP18]], 0
; CHECK-NEXT:    [[TMP21]] = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> [[TMP13]], <4 x float> [[TMP20]], <4 x i1> [[TMP17]], <4 x float> [[TMP13]])
; CHECK-NEXT:    [[TMP22:%.*]] = icmp sgt i32 [[TMP12]], 4
; CHECK-NEXT:    [[TMP23]] = add i32 [[TMP12]], -4
; CHECK-NEXT:    br i1 [[TMP22]], label [[TMP11]], label [[TMP24:%.*]]
; CHECK:       24:
; CHECK-NEXT:    [[TMP25:%.*]] = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> [[TMP21]])
; CHECK-NEXT:    [[TMP26:%.*]] = sitofp i32 [[TMP25]] to float
; CHECK-NEXT:    [[TMP27:%.*]] = tail call float @llvm.fabs.f32(float [[TMP26]])
; CHECK-NEXT:    ret float [[TMP27]]
;
  %3 = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 8)
  %4 = extractvalue { <4 x i32>, i32 } %3, 0
  %5 = add nsw i32 %1, -1
  %6 = ptrtoint float* %0 to i32
  %7 = insertelement <4 x i32> undef, i32 %6, i32 0
  %8 = add <4 x i32> %7, <i32 -32, i32 undef, i32 undef, i32 undef>
  %9 = shufflevector <4 x i32> %8, <4 x i32> undef, <4 x i32> zeroinitializer
  %10 = add <4 x i32> %4, %9
  br label %11

11:                                               ; preds = %11, %2
  %12 = phi i32 [ %5, %2 ], [ %20, %11 ]
  %13 = phi <4 x float> [ zeroinitializer, %2 ], [ %19, %11 ]
  %14 = phi <4 x i32> [ %10, %2 ], [ %17, %11 ]
  %15 = tail call <4 x i1> @llvm.arm.mve.vctp64(i32 %12)
  %16 = tail call { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32> %14, i32 32, <4 x i1> %15)
  %17 = extractvalue { <4 x float>, <4 x i32> } %16, 1
  %18 = extractvalue { <4 x float>, <4 x i32> } %16, 0
  %19 = tail call <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float> %13, <4 x float> %18, <4 x i1> %15, <4 x float> %13)
  %20 = add nsw i32 %12, -4
  %21 = icmp sgt i32 %12, 4
  br i1 %21, label %11, label %22

22:                                               ; preds = %11
  %23 = tail call i32 bitcast (i32 (...)* @vecAddAcrossF32Mve to i32 (<4 x float>)*)(<4 x float> %19)
  %24 = sitofp i32 %23 to float
  %25 = tail call float @llvm.fabs.f32(float %24)
  ret float %25
}

declare { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32, i32)
declare <16 x i1> @llvm.arm.mve.vctp8(i32)
declare <8 x i1> @llvm.arm.mve.vctp16(i32)
declare <4 x i1> @llvm.arm.mve.vctp32(i32)
declare <4 x i1> @llvm.arm.mve.vctp64(i32)
declare { <4 x float>, <4 x i32> } @llvm.arm.mve.vldr.gather.base.wb.predicated.v4f32.v4i32.v4i1(<4 x i32>, i32, <4 x i1>)
declare <4 x float> @llvm.arm.mve.add.predicated.v4f32.v4i1(<4 x float>, <4 x float>, <4 x i1>, <4 x float>)
declare i32 @vecAddAcrossF32Mve(...)
declare <4 x i1> @v8i1_to_v4i1(<8 x i1>)
declare <4 x i1> @v16i1_to_v4i1(<16 x i1>)
declare float @llvm.fabs.f32(float)
