; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -loop-vectorize -force-vector-interleave=3 -force-vector-width=4 -S | FileCheck --check-prefix=UF3 %s
; RUN: opt %s -loop-vectorize -force-vector-interleave=5 -force-vector-width=4 -S | FileCheck --check-prefix=UF5 %s

define i32 @reduction_sum(i64 %n, i32* noalias nocapture %A) {
; UF3-LABEL: @reduction_sum(
; UF3-NEXT:  entry:
; UF3-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], 1
; UF3-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[TMP0]], 12
; UF3-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; UF3:       vector.ph:
; UF3-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[TMP0]], 12
; UF3-NEXT:    [[N_VEC:%.*]] = sub i64 [[TMP0]], [[N_MOD_VF]]
; UF3-NEXT:    br label [[VECTOR_BODY:%.*]]
; UF3:       vector.body:
; UF3-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; UF3-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP13:%.*]], [[VECTOR_BODY]] ]
; UF3-NEXT:    [[VEC_PHI1:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP14:%.*]], [[VECTOR_BODY]] ]
; UF3-NEXT:    [[VEC_PHI2:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP15:%.*]], [[VECTOR_BODY]] ]
; UF3-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 0
; UF3-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 4
; UF3-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 8
; UF3-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[TMP1]]
; UF3-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP2]]
; UF3-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP3]]
; UF3-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 0
; UF3-NEXT:    [[TMP8:%.*]] = bitcast i32* [[TMP7]] to <4 x i32>*
; UF3-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP8]], align 4
; UF3-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 4
; UF3-NEXT:    [[TMP10:%.*]] = bitcast i32* [[TMP9]] to <4 x i32>*
; UF3-NEXT:    [[WIDE_LOAD3:%.*]] = load <4 x i32>, <4 x i32>* [[TMP10]], align 4
; UF3-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i32, i32* [[TMP4]], i32 8
; UF3-NEXT:    [[TMP12:%.*]] = bitcast i32* [[TMP11]] to <4 x i32>*
; UF3-NEXT:    [[WIDE_LOAD4:%.*]] = load <4 x i32>, <4 x i32>* [[TMP12]], align 4
; UF3-NEXT:    [[TMP13]] = add <4 x i32> [[VEC_PHI]], [[WIDE_LOAD]]
; UF3-NEXT:    [[TMP14]] = add <4 x i32> [[VEC_PHI1]], [[WIDE_LOAD3]]
; UF3-NEXT:    [[TMP15]] = add <4 x i32> [[VEC_PHI2]], [[WIDE_LOAD4]]
; UF3-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 12
; UF3-NEXT:    [[TMP16:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; UF3-NEXT:    br i1 [[TMP16]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; UF3:       middle.block:
; UF3-NEXT:    [[BIN_RDX:%.*]] = add <4 x i32> [[TMP14]], [[TMP13]]
; UF3-NEXT:    [[BIN_RDX5:%.*]] = add <4 x i32> [[TMP15]], [[BIN_RDX]]
; UF3-NEXT:    [[TMP17:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[BIN_RDX5]])
; UF3-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP0]], [[N_VEC]]
; UF3-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; UF3:       scalar.ph:
; UF3-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; UF3-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP17]], [[MIDDLE_BLOCK]] ]
; UF3-NEXT:    br label [[LOOP:%.*]]
; UF3:       loop:
; UF3-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; UF3-NEXT:    [[SUM_02:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[SUM_NEXT:%.*]], [[LOOP]] ]
; UF3-NEXT:    [[GEP_A:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[IV]]
; UF3-NEXT:    [[LV_A:%.*]] = load i32, i32* [[GEP_A]], align 4
; UF3-NEXT:    [[SUM_NEXT]] = add i32 [[SUM_02]], [[LV_A]]
; UF3-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; UF3-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV]], [[N]]
; UF3-NEXT:    br i1 [[EXITCOND]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP2:![0-9]+]]
; UF3:       exit:
; UF3-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[LOOP]] ], [ [[TMP17]], [[MIDDLE_BLOCK]] ]
; UF3-NEXT:    ret i32 [[SUM_0_LCSSA]]
;
; UF5-LABEL: @reduction_sum(
; UF5-NEXT:  entry:
; UF5-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], 1
; UF5-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[TMP0]], 20
; UF5-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; UF5:       vector.ph:
; UF5-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[TMP0]], 20
; UF5-NEXT:    [[N_VEC:%.*]] = sub i64 [[TMP0]], [[N_MOD_VF]]
; UF5-NEXT:    br label [[VECTOR_BODY:%.*]]
; UF5:       vector.body:
; UF5-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; UF5-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP21:%.*]], [[VECTOR_BODY]] ]
; UF5-NEXT:    [[VEC_PHI1:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP22:%.*]], [[VECTOR_BODY]] ]
; UF5-NEXT:    [[VEC_PHI2:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP23:%.*]], [[VECTOR_BODY]] ]
; UF5-NEXT:    [[VEC_PHI3:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP24:%.*]], [[VECTOR_BODY]] ]
; UF5-NEXT:    [[VEC_PHI4:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP25:%.*]], [[VECTOR_BODY]] ]
; UF5-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 0
; UF5-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 4
; UF5-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 8
; UF5-NEXT:    [[TMP4:%.*]] = add i64 [[INDEX]], 12
; UF5-NEXT:    [[TMP5:%.*]] = add i64 [[INDEX]], 16
; UF5-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i64 [[TMP1]]
; UF5-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP2]]
; UF5-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP3]]
; UF5-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP4]]
; UF5-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[TMP5]]
; UF5-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i32, i32* [[TMP6]], i32 0
; UF5-NEXT:    [[TMP12:%.*]] = bitcast i32* [[TMP11]] to <4 x i32>*
; UF5-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, <4 x i32>* [[TMP12]], align 4
; UF5-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i32, i32* [[TMP6]], i32 4
; UF5-NEXT:    [[TMP14:%.*]] = bitcast i32* [[TMP13]] to <4 x i32>*
; UF5-NEXT:    [[WIDE_LOAD5:%.*]] = load <4 x i32>, <4 x i32>* [[TMP14]], align 4
; UF5-NEXT:    [[TMP15:%.*]] = getelementptr inbounds i32, i32* [[TMP6]], i32 8
; UF5-NEXT:    [[TMP16:%.*]] = bitcast i32* [[TMP15]] to <4 x i32>*
; UF5-NEXT:    [[WIDE_LOAD6:%.*]] = load <4 x i32>, <4 x i32>* [[TMP16]], align 4
; UF5-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i32, i32* [[TMP6]], i32 12
; UF5-NEXT:    [[TMP18:%.*]] = bitcast i32* [[TMP17]] to <4 x i32>*
; UF5-NEXT:    [[WIDE_LOAD7:%.*]] = load <4 x i32>, <4 x i32>* [[TMP18]], align 4
; UF5-NEXT:    [[TMP19:%.*]] = getelementptr inbounds i32, i32* [[TMP6]], i32 16
; UF5-NEXT:    [[TMP20:%.*]] = bitcast i32* [[TMP19]] to <4 x i32>*
; UF5-NEXT:    [[WIDE_LOAD8:%.*]] = load <4 x i32>, <4 x i32>* [[TMP20]], align 4
; UF5-NEXT:    [[TMP21]] = add <4 x i32> [[VEC_PHI]], [[WIDE_LOAD]]
; UF5-NEXT:    [[TMP22]] = add <4 x i32> [[VEC_PHI1]], [[WIDE_LOAD5]]
; UF5-NEXT:    [[TMP23]] = add <4 x i32> [[VEC_PHI2]], [[WIDE_LOAD6]]
; UF5-NEXT:    [[TMP24]] = add <4 x i32> [[VEC_PHI3]], [[WIDE_LOAD7]]
; UF5-NEXT:    [[TMP25]] = add <4 x i32> [[VEC_PHI4]], [[WIDE_LOAD8]]
; UF5-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 20
; UF5-NEXT:    [[TMP26:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; UF5-NEXT:    br i1 [[TMP26]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; UF5:       middle.block:
; UF5-NEXT:    [[BIN_RDX:%.*]] = add <4 x i32> [[TMP22]], [[TMP21]]
; UF5-NEXT:    [[BIN_RDX9:%.*]] = add <4 x i32> [[TMP23]], [[BIN_RDX]]
; UF5-NEXT:    [[BIN_RDX10:%.*]] = add <4 x i32> [[TMP24]], [[BIN_RDX9]]
; UF5-NEXT:    [[BIN_RDX11:%.*]] = add <4 x i32> [[TMP25]], [[BIN_RDX10]]
; UF5-NEXT:    [[TMP27:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[BIN_RDX11]])
; UF5-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP0]], [[N_VEC]]
; UF5-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; UF5:       scalar.ph:
; UF5-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; UF5-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP27]], [[MIDDLE_BLOCK]] ]
; UF5-NEXT:    br label [[LOOP:%.*]]
; UF5:       loop:
; UF5-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; UF5-NEXT:    [[SUM_02:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[SUM_NEXT:%.*]], [[LOOP]] ]
; UF5-NEXT:    [[GEP_A:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[IV]]
; UF5-NEXT:    [[LV_A:%.*]] = load i32, i32* [[GEP_A]], align 4
; UF5-NEXT:    [[SUM_NEXT]] = add i32 [[SUM_02]], [[LV_A]]
; UF5-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; UF5-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV]], [[N]]
; UF5-NEXT:    br i1 [[EXITCOND]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP2:![0-9]+]]
; UF5:       exit:
; UF5-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ [[SUM_NEXT]], [[LOOP]] ], [ [[TMP27]], [[MIDDLE_BLOCK]] ]
; UF5-NEXT:    ret i32 [[SUM_0_LCSSA]]
;


entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %sum.02 = phi i32 [ 0, %entry ], [ %sum.next, %loop ]
  %gep.A = getelementptr inbounds i32, i32* %A, i64 %iv
  %lv.A = load i32, i32* %gep.A, align 4
  %sum.next = add i32 %sum.02, %lv.A
  %iv.next = add i64 %iv, 1
  %exitcond = icmp eq i64 %iv, %n
  br i1 %exitcond, label %exit, label %loop

exit:
  %sum.0.lcssa = phi i32 [ %sum.next, %loop ]
  ret i32 %sum.0.lcssa
}
