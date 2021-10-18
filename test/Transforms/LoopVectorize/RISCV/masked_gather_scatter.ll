; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-vectorize -mtriple=riscv32 -mattr=+experimental-v,+d -riscv-v-vector-bits-min=256 -S | FileCheck %s -check-prefixes=RV32
; RUN: opt < %s -loop-vectorize -mtriple=riscv64 -mattr=+experimental-v,+d -riscv-v-vector-bits-min=256 -S | FileCheck %s -check-prefixes=RV64

; The source code:
;
;void foo4(double *A, double *B, int *trigger) {
;
;  for (int i=0; i<10000; i += 16) {
;    if (trigger[i] < 100) {
;          A[i] = B[i*2] + trigger[i]; << non-consecutive access
;    }
;  }
;}

define void @foo4(double* nocapture %A, double* nocapture readonly %B, i32* nocapture readonly %trigger) local_unnamed_addr #0 {
; RV32-LABEL: @foo4(
; RV32-NEXT:  entry:
; RV32-NEXT:    [[A1:%.*]] = bitcast double* [[A:%.*]] to i8*
; RV32-NEXT:    [[TRIGGER3:%.*]] = bitcast i32* [[TRIGGER:%.*]] to i8*
; RV32-NEXT:    [[B6:%.*]] = bitcast double* [[B:%.*]] to i8*
; RV32-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; RV32:       vector.memcheck:
; RV32-NEXT:    [[SCEVGEP:%.*]] = getelementptr double, double* [[A]], i64 9985
; RV32-NEXT:    [[SCEVGEP2:%.*]] = bitcast double* [[SCEVGEP]] to i8*
; RV32-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i32, i32* [[TRIGGER]], i64 9985
; RV32-NEXT:    [[SCEVGEP45:%.*]] = bitcast i32* [[SCEVGEP4]] to i8*
; RV32-NEXT:    [[SCEVGEP7:%.*]] = getelementptr double, double* [[B]], i64 19969
; RV32-NEXT:    [[SCEVGEP78:%.*]] = bitcast double* [[SCEVGEP7]] to i8*
; RV32-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[A1]], [[SCEVGEP45]]
; RV32-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[TRIGGER3]], [[SCEVGEP2]]
; RV32-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; RV32-NEXT:    [[BOUND09:%.*]] = icmp ult i8* [[A1]], [[SCEVGEP78]]
; RV32-NEXT:    [[BOUND110:%.*]] = icmp ult i8* [[B6]], [[SCEVGEP2]]
; RV32-NEXT:    [[FOUND_CONFLICT11:%.*]] = and i1 [[BOUND09]], [[BOUND110]]
; RV32-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[FOUND_CONFLICT]], [[FOUND_CONFLICT11]]
; RV32-NEXT:    br i1 [[CONFLICT_RDX]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; RV32:       vector.ph:
; RV32-NEXT:    br label [[VECTOR_BODY:%.*]]
; RV32:       vector.body:
; RV32-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; RV32-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 16, i64 32, i64 48>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; RV32-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[TRIGGER]], <4 x i64> [[VEC_IND]]
; RV32-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> [[TMP0]], i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef), !alias.scope !0
; RV32-NEXT:    [[TMP1:%.*]] = icmp slt <4 x i32> [[WIDE_MASKED_GATHER]], <i32 100, i32 100, i32 100, i32 100>
; RV32-NEXT:    [[TMP2:%.*]] = shl nuw nsw <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; RV32-NEXT:    [[TMP3:%.*]] = getelementptr inbounds double, double* [[B]], <4 x i64> [[TMP2]]
; RV32-NEXT:    [[WIDE_MASKED_GATHER12:%.*]] = call <4 x double> @llvm.masked.gather.v4f64.v4p0f64(<4 x double*> [[TMP3]], i32 8, <4 x i1> [[TMP1]], <4 x double> undef), !alias.scope !3
; RV32-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[WIDE_MASKED_GATHER]] to <4 x double>
; RV32-NEXT:    [[TMP5:%.*]] = fadd <4 x double> [[WIDE_MASKED_GATHER12]], [[TMP4]]
; RV32-NEXT:    [[TMP6:%.*]] = getelementptr inbounds double, double* [[A]], <4 x i64> [[VEC_IND]]
; RV32-NEXT:    call void @llvm.masked.scatter.v4f64.v4p0f64(<4 x double> [[TMP5]], <4 x double*> [[TMP6]], i32 8, <4 x i1> [[TMP1]]), !alias.scope !5, !noalias !7
; RV32-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; RV32-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 64, i64 64, i64 64, i64 64>
; RV32-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 624
; RV32-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; RV32:       middle.block:
; RV32-NEXT:    [[CMP_N:%.*]] = icmp eq i64 625, 624
; RV32-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; RV32:       scalar.ph:
; RV32-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 9984, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; RV32-NEXT:    br label [[FOR_BODY:%.*]]
; RV32:       for.body:
; RV32-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ]
; RV32-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TRIGGER]], i64 [[INDVARS_IV]]
; RV32-NEXT:    [[TMP8:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; RV32-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[TMP8]], 100
; RV32-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; RV32:       if.then:
; RV32-NEXT:    [[TMP9:%.*]] = shl nuw nsw i64 [[INDVARS_IV]], 1
; RV32-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[TMP9]]
; RV32-NEXT:    [[TMP10:%.*]] = load double, double* [[ARRAYIDX3]], align 8
; RV32-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP8]] to double
; RV32-NEXT:    [[ADD:%.*]] = fadd double [[TMP10]], [[CONV]]
; RV32-NEXT:    [[ARRAYIDX7:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[INDVARS_IV]]
; RV32-NEXT:    store double [[ADD]], double* [[ARRAYIDX7]], align 8
; RV32-NEXT:    br label [[FOR_INC]]
; RV32:       for.inc:
; RV32-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 16
; RV32-NEXT:    [[CMP:%.*]] = icmp ult i64 [[INDVARS_IV_NEXT]], 10000
; RV32-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop [[LOOP10:![0-9]+]]
; RV32:       for.end:
; RV32-NEXT:    ret void
;
; RV64-LABEL: @foo4(
; RV64-NEXT:  entry:
; RV64-NEXT:    [[A1:%.*]] = bitcast double* [[A:%.*]] to i8*
; RV64-NEXT:    [[TRIGGER3:%.*]] = bitcast i32* [[TRIGGER:%.*]] to i8*
; RV64-NEXT:    [[B6:%.*]] = bitcast double* [[B:%.*]] to i8*
; RV64-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; RV64:       vector.memcheck:
; RV64-NEXT:    [[SCEVGEP:%.*]] = getelementptr double, double* [[A]], i64 9985
; RV64-NEXT:    [[SCEVGEP2:%.*]] = bitcast double* [[SCEVGEP]] to i8*
; RV64-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i32, i32* [[TRIGGER]], i64 9985
; RV64-NEXT:    [[SCEVGEP45:%.*]] = bitcast i32* [[SCEVGEP4]] to i8*
; RV64-NEXT:    [[SCEVGEP7:%.*]] = getelementptr double, double* [[B]], i64 19969
; RV64-NEXT:    [[SCEVGEP78:%.*]] = bitcast double* [[SCEVGEP7]] to i8*
; RV64-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[A1]], [[SCEVGEP45]]
; RV64-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[TRIGGER3]], [[SCEVGEP2]]
; RV64-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; RV64-NEXT:    [[BOUND09:%.*]] = icmp ult i8* [[A1]], [[SCEVGEP78]]
; RV64-NEXT:    [[BOUND110:%.*]] = icmp ult i8* [[B6]], [[SCEVGEP2]]
; RV64-NEXT:    [[FOUND_CONFLICT11:%.*]] = and i1 [[BOUND09]], [[BOUND110]]
; RV64-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[FOUND_CONFLICT]], [[FOUND_CONFLICT11]]
; RV64-NEXT:    br i1 [[CONFLICT_RDX]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; RV64:       vector.ph:
; RV64-NEXT:    br label [[VECTOR_BODY:%.*]]
; RV64:       vector.body:
; RV64-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; RV64-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 16, i64 32, i64 48>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; RV64-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, i32* [[TRIGGER]], <4 x i64> [[VEC_IND]]
; RV64-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> [[TMP0]], i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef), !alias.scope !0
; RV64-NEXT:    [[TMP1:%.*]] = icmp slt <4 x i32> [[WIDE_MASKED_GATHER]], <i32 100, i32 100, i32 100, i32 100>
; RV64-NEXT:    [[TMP2:%.*]] = shl nuw nsw <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; RV64-NEXT:    [[TMP3:%.*]] = getelementptr inbounds double, double* [[B]], <4 x i64> [[TMP2]]
; RV64-NEXT:    [[WIDE_MASKED_GATHER12:%.*]] = call <4 x double> @llvm.masked.gather.v4f64.v4p0f64(<4 x double*> [[TMP3]], i32 8, <4 x i1> [[TMP1]], <4 x double> undef), !alias.scope !3
; RV64-NEXT:    [[TMP4:%.*]] = sitofp <4 x i32> [[WIDE_MASKED_GATHER]] to <4 x double>
; RV64-NEXT:    [[TMP5:%.*]] = fadd <4 x double> [[WIDE_MASKED_GATHER12]], [[TMP4]]
; RV64-NEXT:    [[TMP6:%.*]] = getelementptr inbounds double, double* [[A]], <4 x i64> [[VEC_IND]]
; RV64-NEXT:    call void @llvm.masked.scatter.v4f64.v4p0f64(<4 x double> [[TMP5]], <4 x double*> [[TMP6]], i32 8, <4 x i1> [[TMP1]]), !alias.scope !5, !noalias !7
; RV64-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; RV64-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 64, i64 64, i64 64, i64 64>
; RV64-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 624
; RV64-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; RV64:       middle.block:
; RV64-NEXT:    [[CMP_N:%.*]] = icmp eq i64 625, 624
; RV64-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; RV64:       scalar.ph:
; RV64-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 9984, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; RV64-NEXT:    br label [[FOR_BODY:%.*]]
; RV64:       for.body:
; RV64-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ]
; RV64-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[TRIGGER]], i64 [[INDVARS_IV]]
; RV64-NEXT:    [[TMP8:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; RV64-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[TMP8]], 100
; RV64-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; RV64:       if.then:
; RV64-NEXT:    [[TMP9:%.*]] = shl nuw nsw i64 [[INDVARS_IV]], 1
; RV64-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[TMP9]]
; RV64-NEXT:    [[TMP10:%.*]] = load double, double* [[ARRAYIDX3]], align 8
; RV64-NEXT:    [[CONV:%.*]] = sitofp i32 [[TMP8]] to double
; RV64-NEXT:    [[ADD:%.*]] = fadd double [[TMP10]], [[CONV]]
; RV64-NEXT:    [[ARRAYIDX7:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[INDVARS_IV]]
; RV64-NEXT:    store double [[ADD]], double* [[ARRAYIDX7]], align 8
; RV64-NEXT:    br label [[FOR_INC]]
; RV64:       for.inc:
; RV64-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 16
; RV64-NEXT:    [[CMP:%.*]] = icmp ult i64 [[INDVARS_IV_NEXT]], 10000
; RV64-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop [[LOOP10:![0-9]+]]
; RV64:       for.end:
; RV64-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.inc
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.inc ]
  %arrayidx = getelementptr inbounds i32, i32* %trigger, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp slt i32 %0, 100
  br i1 %cmp1, label %if.then, label %for.inc

if.then:                                          ; preds = %for.body
  %1 = shl nuw nsw i64 %indvars.iv, 1
  %arrayidx3 = getelementptr inbounds double, double* %B, i64 %1
  %2 = load double, double* %arrayidx3, align 8
  %conv = sitofp i32 %0 to double
  %add = fadd double %2, %conv
  %arrayidx7 = getelementptr inbounds double, double* %A, i64 %indvars.iv
  store double %add, double* %arrayidx7, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 16
  %cmp = icmp ult i64 %indvars.iv.next, 10000
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.inc
  ret void
}
