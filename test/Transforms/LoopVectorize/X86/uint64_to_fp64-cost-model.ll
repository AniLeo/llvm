; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s  -loop-vectorize -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx -S -debug-only=loop-vectorize 2>&1 | FileCheck %s
; REQUIRES: asserts

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"


; CHECK: cost of 4 for VF 1 For instruction:   %conv = uitofp i64 %tmp to double
; CHECK: cost of 5 for VF 2 For instruction:   %conv = uitofp i64 %tmp to double
; CHECK: cost of 10 for VF 4 For instruction:   %conv = uitofp i64 %tmp to double
define void @uint64_to_double_cost(i64* noalias nocapture %a, double* noalias nocapture readonly %b) nounwind {
; CHECK-LABEL: @uint64_to_double_cost(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 12
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, i64* [[A:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i64, i64* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i64* [[TMP8]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i64>, <4 x i64>* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i64, i64* [[TMP4]], i32 4
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i64* [[TMP10]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <4 x i64>, <4 x i64>* [[TMP11]], align 4
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i64, i64* [[TMP4]], i32 8
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i64* [[TMP12]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD2:%.*]] = load <4 x i64>, <4 x i64>* [[TMP13]], align 4
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds i64, i64* [[TMP4]], i32 12
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast i64* [[TMP14]] to <4 x i64>*
; CHECK-NEXT:    [[WIDE_LOAD3:%.*]] = load <4 x i64>, <4 x i64>* [[TMP15]], align 4
; CHECK-NEXT:    [[TMP16:%.*]] = uitofp <4 x i64> [[WIDE_LOAD]] to <4 x double>
; CHECK-NEXT:    [[TMP17:%.*]] = uitofp <4 x i64> [[WIDE_LOAD1]] to <4 x double>
; CHECK-NEXT:    [[TMP18:%.*]] = uitofp <4 x i64> [[WIDE_LOAD2]] to <4 x double>
; CHECK-NEXT:    [[TMP19:%.*]] = uitofp <4 x i64> [[WIDE_LOAD3]] to <4 x double>
; CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds double, double* [[B:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds double, double* [[TMP20]], i32 0
; CHECK-NEXT:    [[TMP25:%.*]] = bitcast double* [[TMP24]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP16]], <4 x double>* [[TMP25]], align 4
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr inbounds double, double* [[TMP20]], i32 4
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast double* [[TMP26]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP17]], <4 x double>* [[TMP27]], align 4
; CHECK-NEXT:    [[TMP28:%.*]] = getelementptr inbounds double, double* [[TMP20]], i32 8
; CHECK-NEXT:    [[TMP29:%.*]] = bitcast double* [[TMP28]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP18]], <4 x double>* [[TMP29]], align 4
; CHECK-NEXT:    [[TMP30:%.*]] = getelementptr inbounds double, double* [[TMP20]], i32 12
; CHECK-NEXT:    [[TMP31:%.*]] = bitcast double* [[TMP30]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP19]], <4 x double>* [[TMP31]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP32:%.*]] = icmp eq i64 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP32]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 256, 256
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 256, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP:%.*]] = load i64, i64* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[CONV:%.*]] = uitofp i64 [[TMP]] to double
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    store double [[CONV]], double* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 256
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i64, i64* %a, i64 %indvars.iv
  %tmp = load i64, i64* %arrayidx, align 4
  %conv = uitofp i64 %tmp to double
  %arrayidx2 = getelementptr inbounds double, double* %b, i64 %indvars.iv
  store double %conv, double* %arrayidx2, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  ret void
}
