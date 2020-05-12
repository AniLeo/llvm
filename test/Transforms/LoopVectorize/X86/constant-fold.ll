; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -S -mtriple=x86_64-- -o - %s | FileCheck %s

; Testcase that verify that we don't get a faulty bitcast that cast between
; different sizes.

%rec8 = type { i16 }

@a = global [1 x %rec8] zeroinitializer
@b = global [2 x i16*] zeroinitializer


define void @f1() {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i32 [[INDEX]] to i16
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i16> undef, i16 [[OFFSET_IDX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i16> [[BROADCAST_SPLATINSERT]], <2 x i16> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <2 x i16> [[BROADCAST_SPLAT]], <i16 0, i16 1>
; CHECK-NEXT:    [[TMP0:%.*]] = add i16 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr [2 x i16*], [2 x i16*]* @b, i16 0, i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i16*, i16** [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i16** [[TMP3]] to <2 x i16*>*
; CHECK-NEXT:    store <2 x i16*> <i16* getelementptr inbounds ([1 x %rec8], [1 x %rec8]* @a, i32 0, i32 0, i32 0), i16* getelementptr inbounds ([1 x %rec8], [1 x %rec8]* @a, i32 0, i32 0, i32 0)>, <2 x i16*>* [[TMP4]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i32 [[INDEX_NEXT]], 2
; CHECK-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 2, 2
; CHECK-NEXT:    br i1 [[CMP_N]], label [[BB3:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i16 [ 2, [[MIDDLE_BLOCK]] ], [ 0, [[BB1:%.*]] ]
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[C_1_0:%.*]] = phi i16 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[_TMP9:%.*]], [[BB2]] ]
; CHECK-NEXT:    [[_TMP1:%.*]] = zext i16 0 to i64
; CHECK-NEXT:    [[_TMP2:%.*]] = getelementptr [1 x %rec8], [1 x %rec8]* @a, i16 0, i64 [[_TMP1]]
; CHECK-NEXT:    [[_TMP4:%.*]] = bitcast %rec8* [[_TMP2]] to i16*
; CHECK-NEXT:    [[_TMP6:%.*]] = sext i16 [[C_1_0]] to i64
; CHECK-NEXT:    [[_TMP7:%.*]] = getelementptr [2 x i16*], [2 x i16*]* @b, i16 0, i64 [[_TMP6]]
; CHECK-NEXT:    store i16* [[_TMP4]], i16** [[_TMP7]]
; CHECK-NEXT:    [[_TMP9]] = add nsw i16 [[C_1_0]], 1
; CHECK-NEXT:    [[_TMP11:%.*]] = icmp slt i16 [[_TMP9]], 2
; CHECK-NEXT:    br i1 [[_TMP11]], label [[BB2]], label [[BB3]], !llvm.loop !2
; CHECK:       bb3:
; CHECK-NEXT:    ret void
;

bb1:
  br label %bb2

bb2:
  %c.1.0 = phi i16 [ 0, %bb1 ], [ %_tmp9, %bb2 ]
  %_tmp1 = zext i16 0 to i64
  %_tmp2 = getelementptr [1 x %rec8], [1 x %rec8]* @a, i16 0, i64 %_tmp1
  %_tmp4 = bitcast %rec8* %_tmp2 to i16*
  %_tmp6 = sext i16 %c.1.0 to i64
  %_tmp7 = getelementptr [2 x i16*], [2 x i16*]* @b, i16 0, i64 %_tmp6
  store i16* %_tmp4, i16** %_tmp7
  %_tmp9 = add nsw i16 %c.1.0, 1
  %_tmp11 = icmp slt i16 %_tmp9, 2
  br i1 %_tmp11, label %bb2, label %bb3

bb3:
  ret void
}
