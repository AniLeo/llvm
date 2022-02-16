; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O1 -S -enable-new-pm=0 < %s | FileCheck --check-prefixes=OLDPM_O1 %s
; RUN: opt -O2 -S -enable-new-pm=0 < %s | FileCheck --check-prefixes=OLDPM_O2 %s
; RUN: opt -O3 -S -enable-new-pm=0 < %s | FileCheck --check-prefixes=OLDPM_O3 %s
; RUN: opt -passes='default<O1>' -S < %s | FileCheck --check-prefixes=NEWPM_O1 %s
; RUN: opt -passes='default<O2>' -S < %s | FileCheck --check-prefixes=NEWPM_O2 %s
; RUN: opt -passes='default<O3>' -S < %s | FileCheck --check-prefixes=NEWPM_O3 %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; We should retain the TBAA on the load here, not lose it.

define void @licm(double** align 8 dereferenceable(8) %_M_start.i, i64 %numElem) {
; OLDPM_O1-LABEL: @licm(
; OLDPM_O1-NEXT:  entry:
; OLDPM_O1-NEXT:    [[TMP0:%.*]] = load double*, double** [[_M_START_I:%.*]], align 8
; OLDPM_O1-NEXT:    [[CMP1_NOT:%.*]] = icmp eq i64 [[NUMELEM:%.*]], 0
; OLDPM_O1-NEXT:    br i1 [[CMP1_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY:%.*]]
; OLDPM_O1:       for.body:
; OLDPM_O1-NEXT:    [[K_02:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; OLDPM_O1-NEXT:    [[ADD_PTR_I:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[K_02]]
; OLDPM_O1-NEXT:    store double 2.000000e+00, double* [[ADD_PTR_I]], align 8, !tbaa [[TBAA3:![0-9]+]]
; OLDPM_O1-NEXT:    [[INC]] = add nuw i64 [[K_02]], 1
; OLDPM_O1-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[NUMELEM]]
; OLDPM_O1-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]]
; OLDPM_O1:       for.cond.cleanup:
; OLDPM_O1-NEXT:    ret void
;
; OLDPM_O2-LABEL: @licm(
; OLDPM_O2-NEXT:  entry:
; OLDPM_O2-NEXT:    [[TMP0:%.*]] = load double*, double** [[_M_START_I:%.*]], align 8
; OLDPM_O2-NEXT:    [[CMP1_NOT:%.*]] = icmp eq i64 [[NUMELEM:%.*]], 0
; OLDPM_O2-NEXT:    br i1 [[CMP1_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; OLDPM_O2:       for.body.preheader:
; OLDPM_O2-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[NUMELEM]], 4
; OLDPM_O2-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[FOR_BODY_PREHEADER3:%.*]], label [[VECTOR_PH:%.*]]
; OLDPM_O2:       vector.ph:
; OLDPM_O2-NEXT:    [[N_VEC:%.*]] = and i64 [[NUMELEM]], -4
; OLDPM_O2-NEXT:    br label [[VECTOR_BODY:%.*]]
; OLDPM_O2:       vector.body:
; OLDPM_O2-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; OLDPM_O2-NEXT:    [[TMP1:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[INDEX]]
; OLDPM_O2-NEXT:    [[TMP2:%.*]] = bitcast double* [[TMP1]] to <2 x double>*
; OLDPM_O2-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP2]], align 8, !tbaa [[TBAA3:![0-9]+]]
; OLDPM_O2-NEXT:    [[TMP3:%.*]] = getelementptr inbounds double, double* [[TMP1]], i64 2
; OLDPM_O2-NEXT:    [[TMP4:%.*]] = bitcast double* [[TMP3]] to <2 x double>*
; OLDPM_O2-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP4]], align 8, !tbaa [[TBAA3]]
; OLDPM_O2-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; OLDPM_O2-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; OLDPM_O2-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; OLDPM_O2:       middle.block:
; OLDPM_O2-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_VEC]], [[NUMELEM]]
; OLDPM_O2-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_PREHEADER3]]
; OLDPM_O2:       for.body.preheader3:
; OLDPM_O2-NEXT:    [[K_02_PH:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[N_VEC]], [[MIDDLE_BLOCK]] ]
; OLDPM_O2-NEXT:    br label [[FOR_BODY:%.*]]
; OLDPM_O2:       for.body:
; OLDPM_O2-NEXT:    [[K_02:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[K_02_PH]], [[FOR_BODY_PREHEADER3]] ]
; OLDPM_O2-NEXT:    [[ADD_PTR_I:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[K_02]]
; OLDPM_O2-NEXT:    store double 2.000000e+00, double* [[ADD_PTR_I]], align 8, !tbaa [[TBAA3]]
; OLDPM_O2-NEXT:    [[INC]] = add nuw i64 [[K_02]], 1
; OLDPM_O2-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[NUMELEM]]
; OLDPM_O2-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; OLDPM_O2:       for.cond.cleanup:
; OLDPM_O2-NEXT:    ret void
;
; OLDPM_O3-LABEL: @licm(
; OLDPM_O3-NEXT:  entry:
; OLDPM_O3-NEXT:    [[TMP0:%.*]] = load double*, double** [[_M_START_I:%.*]], align 8
; OLDPM_O3-NEXT:    [[CMP1_NOT:%.*]] = icmp eq i64 [[NUMELEM:%.*]], 0
; OLDPM_O3-NEXT:    br i1 [[CMP1_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; OLDPM_O3:       for.body.preheader:
; OLDPM_O3-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[NUMELEM]], 4
; OLDPM_O3-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[FOR_BODY_PREHEADER3:%.*]], label [[VECTOR_PH:%.*]]
; OLDPM_O3:       vector.ph:
; OLDPM_O3-NEXT:    [[N_VEC:%.*]] = and i64 [[NUMELEM]], -4
; OLDPM_O3-NEXT:    br label [[VECTOR_BODY:%.*]]
; OLDPM_O3:       vector.body:
; OLDPM_O3-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; OLDPM_O3-NEXT:    [[TMP1:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[INDEX]]
; OLDPM_O3-NEXT:    [[TMP2:%.*]] = bitcast double* [[TMP1]] to <2 x double>*
; OLDPM_O3-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP2]], align 8, !tbaa [[TBAA3:![0-9]+]]
; OLDPM_O3-NEXT:    [[TMP3:%.*]] = getelementptr inbounds double, double* [[TMP1]], i64 2
; OLDPM_O3-NEXT:    [[TMP4:%.*]] = bitcast double* [[TMP3]] to <2 x double>*
; OLDPM_O3-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP4]], align 8, !tbaa [[TBAA3]]
; OLDPM_O3-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; OLDPM_O3-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; OLDPM_O3-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; OLDPM_O3:       middle.block:
; OLDPM_O3-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_VEC]], [[NUMELEM]]
; OLDPM_O3-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_PREHEADER3]]
; OLDPM_O3:       for.body.preheader3:
; OLDPM_O3-NEXT:    [[K_02_PH:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[N_VEC]], [[MIDDLE_BLOCK]] ]
; OLDPM_O3-NEXT:    br label [[FOR_BODY:%.*]]
; OLDPM_O3:       for.body:
; OLDPM_O3-NEXT:    [[K_02:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[K_02_PH]], [[FOR_BODY_PREHEADER3]] ]
; OLDPM_O3-NEXT:    [[ADD_PTR_I:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[K_02]]
; OLDPM_O3-NEXT:    store double 2.000000e+00, double* [[ADD_PTR_I]], align 8, !tbaa [[TBAA3]]
; OLDPM_O3-NEXT:    [[INC]] = add nuw i64 [[K_02]], 1
; OLDPM_O3-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[NUMELEM]]
; OLDPM_O3-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; OLDPM_O3:       for.cond.cleanup:
; OLDPM_O3-NEXT:    ret void
;
; NEWPM_O1-LABEL: @licm(
; NEWPM_O1-NEXT:  entry:
; NEWPM_O1-NEXT:    [[TMP0:%.*]] = load double*, double** [[_M_START_I:%.*]], align 8
; NEWPM_O1-NEXT:    [[CMP1_NOT:%.*]] = icmp eq i64 [[NUMELEM:%.*]], 0
; NEWPM_O1-NEXT:    br i1 [[CMP1_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY:%.*]]
; NEWPM_O1:       for.body:
; NEWPM_O1-NEXT:    [[K_02:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; NEWPM_O1-NEXT:    [[ADD_PTR_I:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[K_02]]
; NEWPM_O1-NEXT:    store double 2.000000e+00, double* [[ADD_PTR_I]], align 8, !tbaa [[TBAA3:![0-9]+]]
; NEWPM_O1-NEXT:    [[INC]] = add nuw i64 [[K_02]], 1
; NEWPM_O1-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[NUMELEM]]
; NEWPM_O1-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]]
; NEWPM_O1:       for.cond.cleanup:
; NEWPM_O1-NEXT:    ret void
;
; NEWPM_O2-LABEL: @licm(
; NEWPM_O2-NEXT:  entry:
; NEWPM_O2-NEXT:    [[TMP0:%.*]] = load double*, double** [[_M_START_I:%.*]], align 8
; NEWPM_O2-NEXT:    [[CMP1_NOT:%.*]] = icmp eq i64 [[NUMELEM:%.*]], 0
; NEWPM_O2-NEXT:    br i1 [[CMP1_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; NEWPM_O2:       for.body.preheader:
; NEWPM_O2-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[NUMELEM]], 4
; NEWPM_O2-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[FOR_BODY_PREHEADER3:%.*]], label [[VECTOR_PH:%.*]]
; NEWPM_O2:       vector.ph:
; NEWPM_O2-NEXT:    [[N_VEC:%.*]] = and i64 [[NUMELEM]], -4
; NEWPM_O2-NEXT:    br label [[VECTOR_BODY:%.*]]
; NEWPM_O2:       vector.body:
; NEWPM_O2-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; NEWPM_O2-NEXT:    [[TMP1:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[INDEX]]
; NEWPM_O2-NEXT:    [[TMP2:%.*]] = bitcast double* [[TMP1]] to <2 x double>*
; NEWPM_O2-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP2]], align 8, !tbaa [[TBAA3:![0-9]+]]
; NEWPM_O2-NEXT:    [[TMP3:%.*]] = getelementptr inbounds double, double* [[TMP1]], i64 2
; NEWPM_O2-NEXT:    [[TMP4:%.*]] = bitcast double* [[TMP3]] to <2 x double>*
; NEWPM_O2-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP4]], align 8, !tbaa [[TBAA3]]
; NEWPM_O2-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; NEWPM_O2-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; NEWPM_O2-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; NEWPM_O2:       middle.block:
; NEWPM_O2-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_VEC]], [[NUMELEM]]
; NEWPM_O2-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_PREHEADER3]]
; NEWPM_O2:       for.body.preheader3:
; NEWPM_O2-NEXT:    [[K_02_PH:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[N_VEC]], [[MIDDLE_BLOCK]] ]
; NEWPM_O2-NEXT:    br label [[FOR_BODY:%.*]]
; NEWPM_O2:       for.body:
; NEWPM_O2-NEXT:    [[K_02:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[K_02_PH]], [[FOR_BODY_PREHEADER3]] ]
; NEWPM_O2-NEXT:    [[ADD_PTR_I:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[K_02]]
; NEWPM_O2-NEXT:    store double 2.000000e+00, double* [[ADD_PTR_I]], align 8, !tbaa [[TBAA3]]
; NEWPM_O2-NEXT:    [[INC]] = add nuw i64 [[K_02]], 1
; NEWPM_O2-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[NUMELEM]]
; NEWPM_O2-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; NEWPM_O2:       for.cond.cleanup:
; NEWPM_O2-NEXT:    ret void
;
; NEWPM_O3-LABEL: @licm(
; NEWPM_O3-NEXT:  entry:
; NEWPM_O3-NEXT:    [[TMP0:%.*]] = load double*, double** [[_M_START_I:%.*]], align 8
; NEWPM_O3-NEXT:    [[CMP1_NOT:%.*]] = icmp eq i64 [[NUMELEM:%.*]], 0
; NEWPM_O3-NEXT:    br i1 [[CMP1_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; NEWPM_O3:       for.body.preheader:
; NEWPM_O3-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[NUMELEM]], 4
; NEWPM_O3-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[FOR_BODY_PREHEADER3:%.*]], label [[VECTOR_PH:%.*]]
; NEWPM_O3:       vector.ph:
; NEWPM_O3-NEXT:    [[N_VEC:%.*]] = and i64 [[NUMELEM]], -4
; NEWPM_O3-NEXT:    br label [[VECTOR_BODY:%.*]]
; NEWPM_O3:       vector.body:
; NEWPM_O3-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; NEWPM_O3-NEXT:    [[TMP1:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[INDEX]]
; NEWPM_O3-NEXT:    [[TMP2:%.*]] = bitcast double* [[TMP1]] to <2 x double>*
; NEWPM_O3-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP2]], align 8, !tbaa [[TBAA3:![0-9]+]]
; NEWPM_O3-NEXT:    [[TMP3:%.*]] = getelementptr inbounds double, double* [[TMP1]], i64 2
; NEWPM_O3-NEXT:    [[TMP4:%.*]] = bitcast double* [[TMP3]] to <2 x double>*
; NEWPM_O3-NEXT:    store <2 x double> <double 2.000000e+00, double 2.000000e+00>, <2 x double>* [[TMP4]], align 8, !tbaa [[TBAA3]]
; NEWPM_O3-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; NEWPM_O3-NEXT:    [[TMP5:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; NEWPM_O3-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; NEWPM_O3:       middle.block:
; NEWPM_O3-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_VEC]], [[NUMELEM]]
; NEWPM_O3-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_PREHEADER3]]
; NEWPM_O3:       for.body.preheader3:
; NEWPM_O3-NEXT:    [[K_02_PH:%.*]] = phi i64 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[N_VEC]], [[MIDDLE_BLOCK]] ]
; NEWPM_O3-NEXT:    br label [[FOR_BODY:%.*]]
; NEWPM_O3:       for.body:
; NEWPM_O3-NEXT:    [[K_02:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[K_02_PH]], [[FOR_BODY_PREHEADER3]] ]
; NEWPM_O3-NEXT:    [[ADD_PTR_I:%.*]] = getelementptr inbounds double, double* [[TMP0]], i64 [[K_02]]
; NEWPM_O3-NEXT:    store double 2.000000e+00, double* [[ADD_PTR_I]], align 8, !tbaa [[TBAA3]]
; NEWPM_O3-NEXT:    [[INC]] = add nuw i64 [[K_02]], 1
; NEWPM_O3-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[NUMELEM]]
; NEWPM_O3-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; NEWPM_O3:       for.cond.cleanup:
; NEWPM_O3-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %k.0 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ult i64 %k.0, %numElem
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.body:                                         ; preds = %for.cond
  %0 = load double*, double** %_M_start.i, align 8, !tbaa !3
  %add.ptr.i = getelementptr inbounds double, double* %0, i64 %k.0
  store double 2.000000e+00, double* %add.ptr.i, align 8, !tbaa !8
  %inc = add nuw i64 %k.0, 1
  br label %for.cond

for.cond.cleanup:                                 ; preds = %for.cond
  ret void
}

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{!"clang version 15.0.0 (https://github.com/llvm/llvm-project.git fc510998f7c287df2bc1304673e0cd8452d50b31)"}
!3 = !{!4, !5, i64 0}
!4 = !{!"_ZTSNSt12_Vector_baseIdSaIdEE17_Vector_impl_dataE", !5, i64 0, !5, i64 8, !5, i64 16}
!5 = !{!"any pointer", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"double", !6, i64 0}
