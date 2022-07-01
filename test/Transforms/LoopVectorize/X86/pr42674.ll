; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -loop-vectorize -instcombine -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -mtriple=x86_64-unknown-linux-gnu -mattr=avx512vl,avx512dq,avx512bw -S | FileCheck %s

@bytes = global [128 x i8] zeroinitializer, align 16

; Make sure we end up with vector code for this loop. We used to try to create
; a VF=64,UF=4 loop, but the scalar trip count is only 128 so
; the vector loop was dead code leaving only a scalar remainder.
define zeroext i8 @sum() {
; CHECK-LABEL: @sum(
; CHECK-NEXT:  iter.check:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ITER_CHECK:%.*]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <64 x i8> [ zeroinitializer, [[ITER_CHECK]] ], [ [[TMP4:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI1:%.*]] = phi <64 x i8> [ zeroinitializer, [[ITER_CHECK]] ], [ [[TMP5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [128 x i8], [128 x i8]* @bytes, i64 0, i64 [[INDEX]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[TMP0]] to <64 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <64 x i8>, <64 x i8>* [[TMP1]], align 16
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8* [[TMP0]], i64 64
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i8* [[TMP2]] to <64 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD2:%.*]] = load <64 x i8>, <64 x i8>* [[TMP3]], align 16
; CHECK-NEXT:    [[TMP4]] = add <64 x i8> [[WIDE_LOAD]], [[VEC_PHI]]
; CHECK-NEXT:    [[TMP5]] = add <64 x i8> [[WIDE_LOAD2]], [[VEC_PHI1]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 128
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[INDEX]], 0
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <64 x i8> [[TMP5]], [[TMP4]]
; CHECK-NEXT:    [[TMP7:%.*]] = call i8 @llvm.vector.reduce.add.v64i8(<64 x i8> [[BIN_RDX]])
; CHECK-NEXT:    ret i8 [[TMP7]]
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %r.010 = phi i8 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds [128 x i8], [128 x i8]* @bytes, i64 0, i64 %indvars.iv
  %0 = load i8, i8* %arrayidx, align 1
  %add = add i8 %0, %r.010
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 128
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  %add.lcssa = phi i8 [ %add, %for.body ]
  ret i8 %add.lcssa
}
