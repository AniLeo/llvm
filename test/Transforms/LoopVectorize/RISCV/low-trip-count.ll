; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -riscv-v-vector-bits-min=128 -scalable-vectorization=on -force-target-instruction-cost=1 -S < %s | FileCheck %s

target triple = "riscv64"

define void @trip5_i8(i8* noalias nocapture noundef %dst, i8* noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip5_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 8
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i64 -6, [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP2]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP3:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP3]], 8
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 8
; CHECK-NEXT:    [[TMP7:%.*]] = sub i64 [[TMP6]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 5, [[TMP7]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP4]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 8 x i64> poison, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 8 x i64> [[BROADCAST_SPLATINSERT]], <vscale x 8 x i64> poison, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP9:%.*]] = call <vscale x 8 x i64> @llvm.experimental.stepvector.nxv8i64()
; CHECK-NEXT:    [[TMP10:%.*]] = add <vscale x 8 x i64> zeroinitializer, [[TMP9]]
; CHECK-NEXT:    [[VEC_IV:%.*]] = add <vscale x 8 x i64> [[BROADCAST_SPLAT]], [[TMP10]]
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ule <vscale x 8 x i64> [[VEC_IV]], shufflevector (<vscale x 8 x i64> insertelement (<vscale x 8 x i64> poison, i64 4, i32 0), <vscale x 8 x i64> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i8, i8* [[SRC:%.*]], i64 [[TMP8]]
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i8, i8* [[TMP12]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast i8* [[TMP13]] to <vscale x 8 x i8>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8.p0nxv8i8(<vscale x 8 x i8>* [[TMP14]], i32 1, <vscale x 8 x i1> [[TMP11]], <vscale x 8 x i8> poison)
; CHECK-NEXT:    [[TMP15:%.*]] = shl <vscale x 8 x i8> [[WIDE_MASKED_LOAD]], shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 1, i32 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds i8, i8* [[DST:%.*]], i64 [[TMP8]]
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i8, i8* [[TMP16]], i32 0
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i8* [[TMP17]] to <vscale x 8 x i8>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8.p0nxv8i8(<vscale x 8 x i8>* [[TMP18]], i32 1, <vscale x 8 x i1> [[TMP11]], <vscale x 8 x i8> poison)
; CHECK-NEXT:    [[TMP19:%.*]] = add <vscale x 8 x i8> [[TMP15]], [[WIDE_MASKED_LOAD1]]
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast i8* [[TMP17]] to <vscale x 8 x i8>*
; CHECK-NEXT:    call void @llvm.masked.store.nxv8i8.p0nxv8i8(<vscale x 8 x i8> [[TMP19]], <vscale x 8 x i8>* [[TMP20]], i32 1, <vscale x 8 x i1> [[TMP11]])
; CHECK-NEXT:    [[TMP21:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP22:%.*]] = mul i64 [[TMP21]], 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], [[TMP22]]
; CHECK-NEXT:    br i1 true, label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, i8* [[SRC]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP23:%.*]] = load i8, i8* [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP23]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, i8* [[DST]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP24:%.*]] = load i8, i8* [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP24]]
; CHECK-NEXT:    store i8 [[ADD]], i8* [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 5
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, i8* %src, i64 %i.08
  %0 = load i8, i8* %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, i8* %dst, i64 %i.08
  %1 = load i8, i8* %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, i8* %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 5
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

attributes #0 = { "target-features"="+v,+d" }
