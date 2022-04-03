; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -disable-loop-unrolling -debug-only=loop-vectorize -passes='default<O3>' -S 2>&1 | FileCheck %s
; RUN: opt < %s -disable-loop-unrolling -debug-only=loop-vectorize -O3 -S 2>&1 | FileCheck %s
; REQUIRES: asserts
; We want to make sure that we don't even try to vectorize loops again
; The vectorizer used to mark the un-vectorized loop only as already vectorized
; thus, trying to vectorize the vectorized loop again

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@a = external global [255 x i32]

; Function Attrs: nounwind readonly uwtable
define i32 @vect() {
; CHECK-LABEL: @vect(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, [[ENTRY]] ], [ [[TMP4:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI1:%.*]] = phi <4 x i32> [ zeroinitializer, [[ENTRY]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [255 x i32], [255 x i32]* @a, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[TMP0]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 4
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <4 x i32>*
; CHECK-NEXT:    [[WIDE_LOAD2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP4]] = add <4 x i32> [[WIDE_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP5]] = add <4 x i32> [[WIDE_LOAD2]], [[VEC_PHI1]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[INDEX_NEXT]], 248
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <4 x i32> [[TMP5]], [[TMP4]]
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[BIN_RDX]])
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 248, [[MIDDLE_BLOCK]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[RED_05:%.*]] = phi i32 [ [[TMP7]], [[MIDDLE_BLOCK]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [255 x i32], [255 x i32]* @a, i64 0, i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[TMP8]], [[RED_05]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 255
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
; We need to make sure we did vectorize the loop
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %red.05 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds [255 x i32], [255 x i32]* @a, i64 0, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %red.05
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 255
  br i1 %exitcond, label %for.end, label %for.body

; If it did, we have two loops:

for.end:                                          ; preds = %for.body
  ret i32 %add
}

; Now, we check for the Hint metadata

