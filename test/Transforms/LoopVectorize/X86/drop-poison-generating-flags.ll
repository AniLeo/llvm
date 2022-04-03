; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -loop-vectorize -force-vector-width=4 -force-vector-interleave=1 -S | FileCheck %s

; Make sure that integer poison-generating flags (i.e., nuw/nsw, exact and inbounds)
; are dropped from instructions in blocks that need predication and are linearized
; and masked after vectorization. We only drop flags from scalar instructions that
; contribute to the address computation of a masked vector load/store. After
; linearizing the control flow and removing their guarding condition, these
; instructions could generate a poison value which would be used as base address of
; the masked vector load/store (see PR52111). For gather/scatter cases,
; posiong-generating flags can be preserved since poison addresses in the vector GEP
; reaching the gather/scatter instruction will be masked-out by the gather/scatter
; instruction itself and won't be used.
; We need AVX512 target features for the loop to be vectorized with masks instead of
; predicates.

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Drop poison-generating flags from 'sub' and 'getelementptr' feeding a masked load.
; Test for PR52111.
define void @drop_scalar_nuw_nsw(float* noalias nocapture readonly %input,
; CHECK-LABEL: @drop_scalar_nuw_nsw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr float, float* [[INPUT:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor <4 x i1> [[TMP1]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr float, float* [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[TMP5]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* [[TMP6]], i32 4, <4 x i1> [[TMP4]], <4 x float> poison), !invariant.load !0
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP4]], <4 x float> [[WIDE_MASKED_LOAD]], <4 x float> zeroinitializer
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds float, float* [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[TMP8]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[PREDPHI]], <4 x float>* [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP1:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I23:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    br i1 [[I23]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I27:%.*]] = sub nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[I29:%.*]] = getelementptr inbounds float, float* [[INPUT]], i64 [[I27]]
; CHECK-NEXT:    [[I30:%.*]] = load float, float* [[I29]], align 4, !invariant.load !0
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi float [ 0.000000e+00, [[LOOP_HEADER]] ], [ [[I30]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds float, float* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store float [[I34]], float* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
  float* %output) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i23 = icmp eq i64 %iv, 0
  br i1 %i23, label %if.end, label %if.then

if.then:
  %i27 = sub nuw nsw i64 %iv, 1
  %i29 = getelementptr inbounds float, float* %input, i64 %i27
  %i30 = load float, float* %i29, align 4, !invariant.load !0
  br label %if.end

if.end:
  %i34 = phi float [ 0.000000e+00, %loop.header ], [ %i30, %if.then ]
  %i35 = getelementptr inbounds float, float* %output, i64 %iv
  store float %i34, float* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Drop poison-generating flags from 'sub' and 'getelementptr' feeding a masked load.
; In this case, 'sub' and 'getelementptr' are not guarded by the predicate.
define void @drop_nonpred_scalar_nuw_nsw(float* noalias nocapture readonly %input,
; CHECK-LABEL: @drop_nonpred_scalar_nuw_nsw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = sub i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr float, float* [[INPUT:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = xor <4 x i1> [[TMP3]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr float, float* [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[TMP5]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* [[TMP6]], i32 4, <4 x i1> [[TMP4]], <4 x float> poison), !invariant.load !0
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP4]], <4 x float> [[WIDE_MASKED_LOAD]], <4 x float> zeroinitializer
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds float, float* [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[TMP8]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[PREDPHI]], <4 x float>* [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I27:%.*]] = sub i64 [[IV]], 1
; CHECK-NEXT:    [[I29:%.*]] = getelementptr float, float* [[INPUT]], i64 [[I27]]
; CHECK-NEXT:    [[I23:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    br i1 [[I23]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I30:%.*]] = load float, float* [[I29]], align 4, !invariant.load !0
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi float [ 0.000000e+00, [[LOOP_HEADER]] ], [ [[I30]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds float, float* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store float [[I34]], float* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
  float* %output) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i27 = sub i64 %iv, 1
  %i29 = getelementptr float, float* %input, i64 %i27
  %i23 = icmp eq i64 %iv, 0
  br i1 %i23, label %if.end, label %if.then

if.then:
  %i30 = load float, float* %i29, align 4, !invariant.load !0
  br label %if.end

if.end:
  %i34 = phi float [ 0.000000e+00, %loop.header ], [ %i30, %if.then ]
  %i35 = getelementptr inbounds float, float* %output, i64 %iv
  store float %i34, float* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Preserve poison-generating flags from vector 'sub', 'mul' and 'getelementptr' feeding a masked gather.
define void @preserve_vector_nuw_nsw(float* noalias nocapture readonly %input,
; CHECK-LABEL: @preserve_vector_nuw_nsw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = sub nuw nsw <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; CHECK-NEXT:    [[TMP3:%.*]] = mul nuw nsw <4 x i64> [[TMP2]], <i64 2, i64 2, i64 2, i64 2>
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds float, float* [[INPUT:%.*]], <4 x i64> [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor <4 x i1> [[TMP1]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> [[TMP4]], i32 4, <4 x i1> [[TMP5]], <4 x float> undef), !invariant.load !0
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP5]], <4 x float> [[WIDE_MASKED_GATHER]], <4 x float> zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP7]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[PREDPHI]], <4 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I23:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    br i1 [[I23]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I27:%.*]] = sub nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[I28:%.*]] = mul nuw nsw i64 [[I27]], 2
; CHECK-NEXT:    [[I29:%.*]] = getelementptr inbounds float, float* [[INPUT]], i64 [[I28]]
; CHECK-NEXT:    [[I30:%.*]] = load float, float* [[I29]], align 4, !invariant.load !0
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi float [ 0.000000e+00, [[LOOP_HEADER]] ], [ [[I30]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds float, float* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store float [[I34]], float* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
  float* %output) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i23 = icmp eq i64 %iv, 0
  br i1 %i23, label %if.end, label %if.then

if.then:
  %i27 = sub nuw nsw i64 %iv, 1
  %i28 = mul nuw nsw i64 %i27, 2
  %i29 = getelementptr inbounds float, float* %input, i64 %i28
  %i30 = load float, float* %i29, align 4, !invariant.load !0
  br label %if.end

if.end:
  %i34 = phi float [ 0.000000e+00, %loop.header ], [ %i30, %if.then ]
  %i35 = getelementptr inbounds float, float* %output, i64 %iv
  store float %i34, float* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Drop poison-generating flags from vector 'sub' and 'gep' feeding a masked load.
define void @drop_vector_nuw_nsw(float* noalias nocapture readonly %input,
; CHECK-LABEL: @drop_vector_nuw_nsw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds float*, float** [[PTRS:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = sub <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr float, float* [[INPUT:%.*]], <4 x i64> [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds float*, float** [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float** [[TMP5]] to <4 x float*>*
; CHECK-NEXT:    store <4 x float*> [[TMP4]], <4 x float*>* [[TMP6]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = xor <4 x i1> [[TMP1]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x float*> [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr float, float* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast float* [[TMP9]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* [[TMP10]], i32 4, <4 x i1> [[TMP7]], <4 x float> poison), !invariant.load !0
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP7]], <4 x float> [[WIDE_MASKED_LOAD]], <4 x float> zeroinitializer
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds float, float* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds float, float* [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast float* [[TMP12]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[PREDPHI]], <4 x float>* [[TMP13]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP14:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP14]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I23:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds float*, float** [[PTRS]], i64 [[IV]]
; CHECK-NEXT:    [[I27:%.*]] = sub nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[I29:%.*]] = getelementptr inbounds float, float* [[INPUT]], i64 [[I27]]
; CHECK-NEXT:    store float* [[I29]], float** [[GEP]], align 8
; CHECK-NEXT:    br i1 [[I23]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I30:%.*]] = load float, float* [[I29]], align 4, !invariant.load !0
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi float [ 0.000000e+00, [[LOOP_HEADER]] ], [ [[I30]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds float, float* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store float [[I34]], float* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
  float* %output, float** noalias %ptrs) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i23 = icmp eq i64 %iv, 0
  %gep = getelementptr inbounds float*, float** %ptrs, i64 %iv
  %i27 = sub nuw nsw i64 %iv, 1
  %i29 = getelementptr inbounds float, float* %input, i64 %i27
  store float* %i29, float** %gep
  br i1 %i23, label %if.end, label %if.then

if.then:
  %i30 = load float, float* %i29, align 4, !invariant.load !0
  br label %if.end

if.end:
  %i34 = phi float [ 0.000000e+00, %loop.header ], [ %i30, %if.then ]
  %i35 = getelementptr inbounds float, float* %output, i64 %iv
  store float %i34, float* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Preserve poison-generating flags from 'sub', which is not contributing to any address computation
; of any masked load/store/gather/scatter.
define void @preserve_nuw_nsw_no_addr(i64* %output) local_unnamed_addr #0 {
; CHECK-LABEL: @preserve_nuw_nsw_no_addr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = sub nuw nsw <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; CHECK-NEXT:    [[TMP3:%.*]] = xor <4 x i1> [[TMP1]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP3]], <4 x i64> [[TMP2]], <4 x i64> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, i64* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i64, i64* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i64* [[TMP5]] to <4 x i64>*
; CHECK-NEXT:    store <4 x i64> [[PREDPHI]], <4 x i64>* [[TMP6]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I23:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    br i1 [[I23]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I27:%.*]] = sub nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi i64 [ 0, [[LOOP_HEADER]] ], [ [[I27]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds i64, i64* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[I34]], i64* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i23 = icmp eq i64 %iv, 0
  br i1 %i23, label %if.end, label %if.then

if.then:
  %i27 = sub nuw nsw i64 %iv, 1
  br label %if.end

if.end:
  %i34 = phi i64 [ 0, %loop.header ], [ %i27, %if.then ]
  %i35 = getelementptr inbounds i64, i64* %output, i64 %iv
  store i64 %i34, i64* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Drop poison-generating flags from 'sdiv' and 'getelementptr' feeding a masked load.
define void @drop_scalar_exact(float* noalias nocapture readonly %input,
; CHECK-LABEL: @drop_scalar_exact(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq <4 x i64> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = and <4 x i1> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = sdiv i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr float, float* [[INPUT:%.*]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = xor <4 x i1> [[TMP4]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr float, float* [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[TMP8]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* [[TMP9]], i32 4, <4 x i1> [[TMP7]], <4 x float> poison), !invariant.load !0
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP7]], <4 x float> [[WIDE_MASKED_LOAD]], <4 x float> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds float, float* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds float, float* [[TMP10]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast float* [[TMP11]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[PREDPHI]], <4 x float>* [[TMP12]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP13]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I7:%.*]] = icmp ne i64 [[IV]], 0
; CHECK-NEXT:    [[I8:%.*]] = and i64 [[IV]], 1
; CHECK-NEXT:    [[I9:%.*]] = icmp eq i64 [[I8]], 0
; CHECK-NEXT:    [[I10:%.*]] = and i1 [[I7]], [[I9]]
; CHECK-NEXT:    br i1 [[I10]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I26:%.*]] = sdiv exact i64 [[IV]], 1
; CHECK-NEXT:    [[I29:%.*]] = getelementptr inbounds float, float* [[INPUT]], i64 [[I26]]
; CHECK-NEXT:    [[I30:%.*]] = load float, float* [[I29]], align 4, !invariant.load !0
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi float [ 0.000000e+00, [[LOOP_HEADER]] ], [ [[I30]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds float, float* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store float [[I34]], float* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP14:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
  float* %output) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i7 = icmp ne i64 %iv, 0
  %i8 = and i64 %iv, 1
  %i9 = icmp eq i64 %i8, 0
  %i10 = and i1 %i7, %i9
  br i1 %i10, label %if.end, label %if.then

if.then:
  %i26 = sdiv exact i64 %iv, 1
  %i29 = getelementptr inbounds float, float* %input, i64 %i26
  %i30 = load float, float* %i29, align 4, !invariant.load !0
  br label %if.end

if.end:
  %i34 = phi float [ 0.000000e+00, %loop.header ], [ %i30, %if.then ]
  %i35 = getelementptr inbounds float, float* %output, i64 %iv
  store float %i34, float* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Preserve poison-generating flags from 'sdiv' and 'getelementptr' feeding a masked gather.
define void @preserve_vector_exact_no_addr(float* noalias nocapture readonly %input,
; CHECK-LABEL: @preserve_vector_exact_no_addr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq <4 x i64> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = and <4 x i1> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = sdiv exact <4 x i64> [[VEC_IND]], <i64 2, i64 2, i64 2, i64 2>
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[INPUT:%.*]], <4 x i64> [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = xor <4 x i1> [[TMP4]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x float> @llvm.masked.gather.v4f32.v4p0f32(<4 x float*> [[TMP6]], i32 4, <4 x i1> [[TMP7]], <4 x float> undef), !invariant.load !0
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP7]], <4 x float> [[WIDE_MASKED_GATHER]], <4 x float> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds float, float* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds float, float* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast float* [[TMP9]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[PREDPHI]], <4 x float>* [[TMP10]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP15:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I7:%.*]] = icmp ne i64 [[IV]], 0
; CHECK-NEXT:    [[I8:%.*]] = and i64 [[IV]], 1
; CHECK-NEXT:    [[I9:%.*]] = icmp eq i64 [[I8]], 0
; CHECK-NEXT:    [[I10:%.*]] = and i1 [[I7]], [[I9]]
; CHECK-NEXT:    br i1 [[I10]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I26:%.*]] = sdiv exact i64 [[IV]], 2
; CHECK-NEXT:    [[I29:%.*]] = getelementptr inbounds float, float* [[INPUT]], i64 [[I26]]
; CHECK-NEXT:    [[I30:%.*]] = load float, float* [[I29]], align 4, !invariant.load !0
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi float [ 0.000000e+00, [[LOOP_HEADER]] ], [ [[I30]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds float, float* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store float [[I34]], float* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP16:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
  float* %output) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i7 = icmp ne i64 %iv, 0
  %i8 = and i64 %iv, 1
  %i9 = icmp eq i64 %i8, 0
  %i10 = and i1 %i7, %i9
  br i1 %i10, label %if.end, label %if.then

if.then:
  %i26 = sdiv exact i64 %iv, 2
  %i29 = getelementptr inbounds float, float* %input, i64 %i26
  %i30 = load float, float* %i29, align 4, !invariant.load !0
  br label %if.end

if.end:
  %i34 = phi float [ 0.000000e+00, %loop.header ], [ %i30, %if.then ]
  %i35 = getelementptr inbounds float, float* %output, i64 %iv
  store float %i34, float* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Preserve poison-generating flags from 'sdiv', which is not contributing to any address computation
; of any masked load/store/gather/scatter.
define void @preserve_exact_no_addr(i64* %output) local_unnamed_addr #0 {
; CHECK-LABEL: @preserve_exact_no_addr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <4 x i64> [[VEC_IND]], zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = sdiv exact <4 x i64> [[VEC_IND]], <i64 2, i64 2, i64 2, i64 2>
; CHECK-NEXT:    [[TMP3:%.*]] = xor <4 x i1> [[TMP1]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <4 x i1> [[TMP3]], <4 x i64> [[TMP2]], <4 x i64> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, i64* [[OUTPUT:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i64, i64* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i64* [[TMP5]] to <4 x i64>*
; CHECK-NEXT:    store <4 x i64> [[PREDPHI]], <4 x i64>* [[TMP6]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP17:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 4, 4
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[I23:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    br i1 [[I23]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I27:%.*]] = sdiv exact i64 [[IV]], 2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi i64 [ 0, [[LOOP_HEADER]] ], [ [[I27]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds i64, i64* [[OUTPUT]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[I34]], i64* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP18:![0-9]+]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i23 = icmp eq i64 %iv, 0
  br i1 %i23, label %if.end, label %if.then

if.then:
  %i27 = sdiv exact i64 %iv, 2
  br label %if.end

if.end:
  %i34 = phi i64 [ 0, %loop.header ], [ %i27, %if.then ]
  %i35 = getelementptr inbounds i64, i64* %output, i64 %iv
  store i64 %i34, i64* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

; Make sure we don't vectorize a loop with a phi feeding a poison value to
; a masked load/gather.
define void @dont_vectorize_poison_phi(float* noalias nocapture readonly %input,
; CHECK-LABEL: @dont_vectorize_poison_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[POISON:%.*]] = phi i64 [ poison, [[ENTRY:%.*]] ], [ [[IV_INC:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[IV_INC]], [[IF_END]] ]
; CHECK-NEXT:    [[I23:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    br i1 [[I23]], label [[IF_END]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[I29:%.*]] = getelementptr inbounds float, float* [[INPUT:%.*]], i64 [[POISON]]
; CHECK-NEXT:    [[I30:%.*]] = load float, float* [[I29]], align 4, !invariant.load !0
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I34:%.*]] = phi float [ 0.000000e+00, [[LOOP_HEADER]] ], [ [[I30]], [[IF_THEN]] ]
; CHECK-NEXT:    [[I35:%.*]] = getelementptr inbounds float, float* [[OUTPUT:%.*]], i64 [[IV]]
; CHECK-NEXT:    store float [[I34]], float* [[I35]], align 4
; CHECK-NEXT:    [[IV_INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV_INC]], 4
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_EXIT:%.*]], label [[LOOP_HEADER]]
; CHECK:       loop.exit:
; CHECK-NEXT:    ret void
;
  float* %output) local_unnamed_addr #0 {
entry:
  br label %loop.header

loop.header:
  %poison = phi i64 [ poison, %entry ], [ %iv.inc, %if.end ]
  %iv = phi i64 [ 0, %entry ], [ %iv.inc, %if.end ]
  %i23 = icmp eq i64 %iv, 0
  br i1 %i23, label %if.end, label %if.then

if.then:
  %i29 = getelementptr inbounds float, float* %input, i64 %poison
  %i30 = load float, float* %i29, align 4, !invariant.load !0
  br label %if.end

if.end:
  %i34 = phi float [ 0.000000e+00, %loop.header ], [ %i30, %if.then ]
  %i35 = getelementptr inbounds float, float* %output, i64 %iv
  store float %i34, float* %i35, align 4
  %iv.inc = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.inc, 4
  br i1 %exitcond, label %loop.exit, label %loop.header

loop.exit:
  ret void
}

attributes #0 = { noinline nounwind uwtable "target-features"="+avx512bw,+avx512cd,+avx512dq,+avx512f,+avx512vl" }

!0 = !{}
