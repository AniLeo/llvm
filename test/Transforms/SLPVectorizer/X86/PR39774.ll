; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=skylake -slp-threshold=-6 | FileCheck %s --check-prefix=CHECK
; RUN: opt -slp-vectorizer -S < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=skylake -slp-threshold=-7 -slp-min-tree-size=6 | FileCheck %s --check-prefix=FORCE_REDUCTION

define void @Test(i32) {
; CHECK-LABEL: @Test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> poison, i32 [[TMP0:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> [[TMP1]], i32 [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[TMP0]], i32 2
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[TMP0]], i32 3
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[TMP0]], i32 4
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[TMP0]], i32 5
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[TMP0]], i32 6
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[TMP0]], i32 7
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <16 x i32> poison, i32 [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <16 x i32> [[TMP9]], i32 [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <16 x i32> [[TMP10]], i32 [[TMP0]], i32 2
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <16 x i32> [[TMP11]], i32 [[TMP0]], i32 3
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <16 x i32> [[TMP12]], i32 [[TMP0]], i32 4
; CHECK-NEXT:    [[TMP14:%.*]] = insertelement <16 x i32> [[TMP13]], i32 [[TMP0]], i32 5
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <16 x i32> [[TMP14]], i32 [[TMP0]], i32 6
; CHECK-NEXT:    [[TMP16:%.*]] = insertelement <16 x i32> [[TMP15]], i32 [[TMP0]], i32 7
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <16 x i32> [[TMP16]], i32 [[TMP0]], i32 8
; CHECK-NEXT:    [[TMP18:%.*]] = insertelement <16 x i32> [[TMP17]], i32 [[TMP0]], i32 9
; CHECK-NEXT:    [[TMP19:%.*]] = insertelement <16 x i32> [[TMP18]], i32 [[TMP0]], i32 10
; CHECK-NEXT:    [[TMP20:%.*]] = insertelement <16 x i32> [[TMP19]], i32 [[TMP0]], i32 11
; CHECK-NEXT:    [[TMP21:%.*]] = insertelement <16 x i32> [[TMP20]], i32 [[TMP0]], i32 12
; CHECK-NEXT:    [[TMP22:%.*]] = insertelement <16 x i32> [[TMP21]], i32 [[TMP0]], i32 13
; CHECK-NEXT:    [[TMP23:%.*]] = insertelement <16 x i32> [[TMP22]], i32 [[TMP0]], i32 14
; CHECK-NEXT:    [[TMP24:%.*]] = insertelement <16 x i32> [[TMP23]], i32 [[TMP0]], i32 15
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[TMP25:%.*]] = phi <2 x i32> [ [[TMP36:%.*]], [[LOOP]] ], [ zeroinitializer, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i32> [[TMP25]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP26:%.*]] = extractelement <8 x i32> [[SHUFFLE]], i32 1
; CHECK-NEXT:    [[TMP27:%.*]] = add <8 x i32> [[SHUFFLE]], <i32 0, i32 55, i32 285, i32 1240, i32 1496, i32 8555, i32 12529, i32 13685>
; CHECK-NEXT:    [[TMP28:%.*]] = call i32 @llvm.vector.reduce.and.v16i32(<16 x i32> [[TMP24]])
; CHECK-NEXT:    [[TMP29:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP8]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = and i32 [[TMP28]], [[TMP29]]
; CHECK-NEXT:    [[TMP30:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP27]])
; CHECK-NEXT:    [[OP_RDX1:%.*]] = and i32 [[OP_RDX]], [[TMP30]]
; CHECK-NEXT:    [[OP_RDX2:%.*]] = and i32 [[OP_RDX1]], [[TMP0]]
; CHECK-NEXT:    [[OP_RDX3:%.*]] = and i32 [[OP_RDX2]], [[TMP0]]
; CHECK-NEXT:    [[OP_RDX4:%.*]] = and i32 [[OP_RDX3]], [[TMP0]]
; CHECK-NEXT:    [[TMP31:%.*]] = insertelement <2 x i32> <i32 poison, i32 14910>, i32 [[OP_RDX4]], i32 0
; CHECK-NEXT:    [[TMP32:%.*]] = insertelement <2 x i32> poison, i32 [[TMP26]], i32 0
; CHECK-NEXT:    [[TMP33:%.*]] = insertelement <2 x i32> [[TMP32]], i32 [[TMP26]], i32 1
; CHECK-NEXT:    [[TMP34:%.*]] = and <2 x i32> [[TMP31]], [[TMP33]]
; CHECK-NEXT:    [[TMP35:%.*]] = add <2 x i32> [[TMP31]], [[TMP33]]
; CHECK-NEXT:    [[TMP36]] = shufflevector <2 x i32> [[TMP34]], <2 x i32> [[TMP35]], <2 x i32> <i32 0, i32 3>
; CHECK-NEXT:    br label [[LOOP]]
;
; FORCE_REDUCTION-LABEL: @Test(
; FORCE_REDUCTION-NEXT:  entry:
; FORCE_REDUCTION-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> poison, i32 [[TMP0:%.*]], i32 0
; FORCE_REDUCTION-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> [[TMP1]], i32 [[TMP0]], i32 1
; FORCE_REDUCTION-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[TMP0]], i32 2
; FORCE_REDUCTION-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[TMP0]], i32 3
; FORCE_REDUCTION-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[TMP0]], i32 4
; FORCE_REDUCTION-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[TMP0]], i32 5
; FORCE_REDUCTION-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[TMP0]], i32 6
; FORCE_REDUCTION-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[TMP0]], i32 7
; FORCE_REDUCTION-NEXT:    [[TMP9:%.*]] = insertelement <16 x i32> poison, i32 [[TMP0]], i32 0
; FORCE_REDUCTION-NEXT:    [[TMP10:%.*]] = insertelement <16 x i32> [[TMP9]], i32 [[TMP0]], i32 1
; FORCE_REDUCTION-NEXT:    [[TMP11:%.*]] = insertelement <16 x i32> [[TMP10]], i32 [[TMP0]], i32 2
; FORCE_REDUCTION-NEXT:    [[TMP12:%.*]] = insertelement <16 x i32> [[TMP11]], i32 [[TMP0]], i32 3
; FORCE_REDUCTION-NEXT:    [[TMP13:%.*]] = insertelement <16 x i32> [[TMP12]], i32 [[TMP0]], i32 4
; FORCE_REDUCTION-NEXT:    [[TMP14:%.*]] = insertelement <16 x i32> [[TMP13]], i32 [[TMP0]], i32 5
; FORCE_REDUCTION-NEXT:    [[TMP15:%.*]] = insertelement <16 x i32> [[TMP14]], i32 [[TMP0]], i32 6
; FORCE_REDUCTION-NEXT:    [[TMP16:%.*]] = insertelement <16 x i32> [[TMP15]], i32 [[TMP0]], i32 7
; FORCE_REDUCTION-NEXT:    [[TMP17:%.*]] = insertelement <16 x i32> [[TMP16]], i32 [[TMP0]], i32 8
; FORCE_REDUCTION-NEXT:    [[TMP18:%.*]] = insertelement <16 x i32> [[TMP17]], i32 [[TMP0]], i32 9
; FORCE_REDUCTION-NEXT:    [[TMP19:%.*]] = insertelement <16 x i32> [[TMP18]], i32 [[TMP0]], i32 10
; FORCE_REDUCTION-NEXT:    [[TMP20:%.*]] = insertelement <16 x i32> [[TMP19]], i32 [[TMP0]], i32 11
; FORCE_REDUCTION-NEXT:    [[TMP21:%.*]] = insertelement <16 x i32> [[TMP20]], i32 [[TMP0]], i32 12
; FORCE_REDUCTION-NEXT:    [[TMP22:%.*]] = insertelement <16 x i32> [[TMP21]], i32 [[TMP0]], i32 13
; FORCE_REDUCTION-NEXT:    [[TMP23:%.*]] = insertelement <16 x i32> [[TMP22]], i32 [[TMP0]], i32 14
; FORCE_REDUCTION-NEXT:    [[TMP24:%.*]] = insertelement <16 x i32> [[TMP23]], i32 [[TMP0]], i32 15
; FORCE_REDUCTION-NEXT:    br label [[LOOP:%.*]]
; FORCE_REDUCTION:       loop:
; FORCE_REDUCTION-NEXT:    [[TMP25:%.*]] = phi <2 x i32> [ [[TMP36:%.*]], [[LOOP]] ], [ zeroinitializer, [[ENTRY:%.*]] ]
; FORCE_REDUCTION-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i32> [[TMP25]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
; FORCE_REDUCTION-NEXT:    [[TMP26:%.*]] = add <8 x i32> [[SHUFFLE]], <i32 0, i32 55, i32 285, i32 1240, i32 1496, i32 8555, i32 12529, i32 13685>
; FORCE_REDUCTION-NEXT:    [[TMP27:%.*]] = call i32 @llvm.vector.reduce.and.v16i32(<16 x i32> [[TMP24]])
; FORCE_REDUCTION-NEXT:    [[TMP28:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP8]])
; FORCE_REDUCTION-NEXT:    [[TMP29:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP26]])
; FORCE_REDUCTION-NEXT:    [[OP_RDX13:%.*]] = and i32 [[TMP29]], [[TMP0]]
; FORCE_REDUCTION-NEXT:    [[OP_RDX14:%.*]] = and i32 [[OP_RDX13]], [[TMP0]]
; FORCE_REDUCTION-NEXT:    [[OP_RDX15:%.*]] = and i32 [[OP_RDX14]], [[TMP0]]
; FORCE_REDUCTION-NEXT:    [[OP_RDX16:%.*]] = and i32 [[OP_RDX15]], [[TMP27]]
; FORCE_REDUCTION-NEXT:    [[OP_RDX17:%.*]] = and i32 [[OP_RDX16]], [[TMP28]]
; FORCE_REDUCTION-NEXT:    [[TMP30:%.*]] = insertelement <2 x i32> <i32 poison, i32 14910>, i32 [[OP_RDX17]], i32 0
; FORCE_REDUCTION-NEXT:    [[TMP31:%.*]] = extractelement <8 x i32> [[SHUFFLE]], i32 1
; FORCE_REDUCTION-NEXT:    [[TMP32:%.*]] = insertelement <2 x i32> poison, i32 [[TMP31]], i32 0
; FORCE_REDUCTION-NEXT:    [[TMP33:%.*]] = insertelement <2 x i32> [[TMP32]], i32 [[TMP31]], i32 1
; FORCE_REDUCTION-NEXT:    [[TMP34:%.*]] = and <2 x i32> [[TMP30]], [[TMP33]]
; FORCE_REDUCTION-NEXT:    [[TMP35:%.*]] = add <2 x i32> [[TMP30]], [[TMP33]]
; FORCE_REDUCTION-NEXT:    [[TMP36]] = shufflevector <2 x i32> [[TMP34]], <2 x i32> [[TMP35]], <2 x i32> <i32 0, i32 3>
; FORCE_REDUCTION-NEXT:    br label [[LOOP]]
;
entry:
  br label %loop

loop:
  %local_4_39.us = phi i32 [ %val_42, %loop ], [ 0, %entry ]
  %local_8_43.us = phi i32 [ %val_43, %loop ], [ 0, %entry ]
  %val_0 = add i32 %local_4_39.us, 0
  %val_1 = and i32 %local_8_43.us, %val_0
  %val_2 = and i32 %val_1, %0
  %val_3 = and i32 %val_2, %0
  %val_4 = and i32 %val_3, %0
  %val_5 = and i32 %val_4, %0
  %val_6 = add i32 %local_8_43.us, 55
  %val_7 = and i32 %val_5, %val_6
  %val_8 = and i32 %val_7, %0
  %val_9 = and i32 %val_8, %0
  %val_10 = and i32 %val_9, %0
  %val_11 = add i32 %local_8_43.us, 285
  %val_12 = and i32 %val_10, %val_11
  %val_13 = and i32 %val_12, %0
  %val_14 = and i32 %val_13, %0
  %val_15 = and i32 %val_14, %0
  %val_16 = and i32 %val_15, %0
  %val_17 = and i32 %val_16, %0
  %val_18 = add i32 %local_8_43.us, 1240
  %val_19 = and i32 %val_17, %val_18
  %val_20 = add i32 %local_8_43.us, 1496
  %val_21 = and i32 %val_19, %val_20
  %val_22 = and i32 %val_21, %0
  %val_23 = and i32 %val_22, %0
  %val_24 = and i32 %val_23, %0
  %val_25 = and i32 %val_24, %0
  %val_26 = and i32 %val_25, %0
  %val_27 = and i32 %val_26, %0
  %val_28 = and i32 %val_27, %0
  %val_29 = and i32 %val_28, %0
  %val_30 = and i32 %val_29, %0
  %val_31 = and i32 %val_30, %0
  %val_32 = and i32 %val_31, %0
  %val_33 = and i32 %val_32, %0
  %val_34 = add i32 %local_8_43.us, 8555
  %val_35 = and i32 %val_33, %val_34
  %val_36 = and i32 %val_35, %0
  %val_37 = and i32 %val_36, %0
  %val_38 = and i32 %val_37, %0
  %val_39 = add i32 %local_8_43.us, 12529
  %val_40 = and i32 %val_38, %val_39
  %val_41 = add i32 %local_8_43.us, 13685
  %val_42 = and i32 %val_40, %val_41
  %val_43 = add i32 %local_8_43.us, 14910
  br label %loop
}
