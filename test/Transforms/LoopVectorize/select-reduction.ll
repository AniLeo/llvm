; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -force-vector-width=4 -force-vector-interleave=1 -loop-vectorize -S %s | FileCheck %s

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define i32 @test(i64 %N, i32 %x) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXTRA_ITER:%.*]] = and i64 [[N:%.*]], 7
; CHECK-NEXT:    br label [[CHECK:%.*]]
; CHECK:       check:
; CHECK-NEXT:    [[EXTRA_ITER_CHECK:%.*]] = icmp eq i64 [[EXTRA_ITER]], 0
; CHECK-NEXT:    br i1 [[EXTRA_ITER_CHECK]], label [[EXIT:%.*]], label [[LOOP_PREHEADER:%.*]]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[EXTRA_ITER]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = sub i64 [[EXTRA_ITER]], [[N_VEC]]
; CHECK-NEXT:    [[TRIP_COUNT_MINUS_1:%.*]] = sub i64 [[EXTRA_ITER]], 1
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> poison, i64 [[TRIP_COUNT_MINUS_1]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = sub i64 [[EXTRA_ITER]], [[INDEX]]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT3:%.*]] = insertelement <4 x i64> poison, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT4:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT3]], <4 x i64> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC_IV:%.*]] = add <4 x i64> [[BROADCAST_SPLAT4]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule <4 x i64> [[VEC_IV]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt <4 x i32> [[VEC_PHI]], <i32 10, i32 10, i32 10, i32 10>
; CHECK-NEXT:    [[TMP3]] = select <4 x i1> [[TMP2]], <4 x i32> [[VEC_PHI]], <4 x i32> <i32 10, i32 10, i32 10, i32 10>
; CHECK-NEXT:    [[TMP4:%.*]] = select <4 x i1> [[TMP1]], <4 x i32> [[TMP3]], <4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.smax.v4i32(<4 x i32> [[TMP4]])
; CHECK-NEXT:    br i1 true, label [[EXIT_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[EXTRA_ITER]], [[LOOP_PREHEADER]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[LOOP_PREHEADER]] ], [ [[TMP6]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[NEXT:%.*]] = phi i32 [ [[SEL:%.*]], [[LOOP]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[IV_NEXT:%.*]], [[LOOP]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[SEL_COND:%.*]] = icmp sgt i32 [[NEXT]], 10
; CHECK-NEXT:    [[SEL]] = select i1 [[SEL_COND]], i32 [[NEXT]], i32 10
; CHECK-NEXT:    [[IV_NEXT]] = add nsw i64 [[IV]], -1
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i64 [[IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[EC]], label [[EXIT_LOOPEXIT]], label [[LOOP]], [[LOOP2:!llvm.loop !.*]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    [[SEL_LCSSA:%.*]] = phi i32 [ [[SEL]], [[LOOP]] ], [ [[TMP6]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RESULT:%.*]] = phi i32 [ 0, [[CHECK]] ], [ [[SEL_LCSSA]], [[EXIT_LOOPEXIT]] ]
; CHECK-NEXT:    ret i32 [[RESULT]]
;
entry:
  %extra.iter = and i64 %N, 7
  br label %check

check:
  %extra.iter.check = icmp eq i64 %extra.iter, 0
  br i1 %extra.iter.check, label %exit, label %loop

loop:
  %next = phi i32 [ %sel, %loop ], [ 0, %check ]
  %iv = phi i64 [ %iv.next, %loop ], [ %extra.iter, %check ]
  %sel.cond = icmp sgt i32 %next, 10
  %sel = select i1 %sel.cond, i32 %next, i32 10
  %iv.next = add nsw i64 %iv, -1
  %ec = icmp eq i64 %iv.next, 0
  br i1 %ec, label %exit, label %loop

exit:
  %result = phi i32 [ %sel, %loop], [ 0, %check ]
  ret i32 %result
}
