; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -O3 -S                                        | FileCheck %s
; RUN: opt < %s -passes='default<O3>' -S | FileCheck %s

; Test that IR is optimal after vectorization/unrolling/CSE/canonicalization.
; In particular, there should be no fdivs inside loops because that is expensive.

; TODO: There is a CSE opportunity to reduce the hoisted fdivs after vectorization/unrolling.
; PR46115 - https://bugs.llvm.org/PR46115

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.15.0"

define void @vdiv(double* %x, double* %y, double %a, i32 %N) #0 {
; CHECK-LABEL: @vdiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[FOR_BODY_LR_PH:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[FOR_BODY_PREHEADER:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr double, double* [[X:%.*]], i64 [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[SCEVGEP6:%.*]] = getelementptr double, double* [[Y:%.*]], i64 [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ugt double* [[SCEVGEP6]], [[X]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ugt double* [[SCEVGEP]], [[Y]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[FOR_BODY_PREHEADER]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 4294967292
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x double> poison, double [[A:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x double> [[BROADCAST_SPLATINSERT]], <4 x double> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[N_VEC]], -4
; CHECK-NEXT:    [[TMP1:%.*]] = lshr exact i64 [[TMP0]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[XTRAITER:%.*]] = and i64 [[TMP2]], 3
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ult i64 [[TMP0]], 12
; CHECK-NEXT:    br i1 [[TMP3]], label [[MIDDLE_BLOCK_UNR_LCSSA:%.*]], label [[VECTOR_PH_NEW:%.*]]
; CHECK:       vector.ph.new:
; CHECK-NEXT:    [[UNROLL_ITER:%.*]] = and i64 [[TMP2]], 9223372036854775804
; CHECK-NEXT:    [[TMP4:%.*]] = fdiv fast <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = fdiv fast <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP6:%.*]] = fdiv fast <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP7:%.*]] = fdiv fast <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, [[BROADCAST_SPLAT]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH_NEW]] ], [ [[INDEX_NEXT_3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[NITER:%.*]] = phi i64 [ [[UNROLL_ITER]], [[VECTOR_PH_NEW]] ], [ [[NITER_NSUB_3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast double* [[TMP8]] to <4 x double>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x double>, <4 x double>* [[TMP9]], align 8, [[TBAA3:!tbaa !.*]], !alias.scope !7
; CHECK-NEXT:    [[TMP10:%.*]] = fmul fast <4 x double> [[WIDE_LOAD]], [[TMP4]]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast double* [[TMP11]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP10]], <4 x double>* [[TMP12]], align 8, [[TBAA3]], !alias.scope !10, !noalias !7
; CHECK-NEXT:    [[INDEX_NEXT:%.*]] = or i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDEX_NEXT]]
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast double* [[TMP13]] to <4 x double>*
; CHECK-NEXT:    [[WIDE_LOAD_1:%.*]] = load <4 x double>, <4 x double>* [[TMP14]], align 8, [[TBAA3]], !alias.scope !7
; CHECK-NEXT:    [[TMP15:%.*]] = fmul fast <4 x double> [[WIDE_LOAD_1]], [[TMP5]]
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDEX_NEXT]]
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast double* [[TMP16]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP15]], <4 x double>* [[TMP17]], align 8, [[TBAA3]], !alias.scope !10, !noalias !7
; CHECK-NEXT:    [[INDEX_NEXT_1:%.*]] = or i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP18:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDEX_NEXT_1]]
; CHECK-NEXT:    [[TMP19:%.*]] = bitcast double* [[TMP18]] to <4 x double>*
; CHECK-NEXT:    [[WIDE_LOAD_2:%.*]] = load <4 x double>, <4 x double>* [[TMP19]], align 8, [[TBAA3]], !alias.scope !7
; CHECK-NEXT:    [[TMP20:%.*]] = fmul fast <4 x double> [[WIDE_LOAD_2]], [[TMP6]]
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDEX_NEXT_1]]
; CHECK-NEXT:    [[TMP22:%.*]] = bitcast double* [[TMP21]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP20]], <4 x double>* [[TMP22]], align 8, [[TBAA3]], !alias.scope !10, !noalias !7
; CHECK-NEXT:    [[INDEX_NEXT_2:%.*]] = or i64 [[INDEX]], 12
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDEX_NEXT_2]]
; CHECK-NEXT:    [[TMP24:%.*]] = bitcast double* [[TMP23]] to <4 x double>*
; CHECK-NEXT:    [[WIDE_LOAD_3:%.*]] = load <4 x double>, <4 x double>* [[TMP24]], align 8, [[TBAA3]], !alias.scope !7
; CHECK-NEXT:    [[TMP25:%.*]] = fmul fast <4 x double> [[WIDE_LOAD_3]], [[TMP7]]
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDEX_NEXT_2]]
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast double* [[TMP26]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP25]], <4 x double>* [[TMP27]], align 8, [[TBAA3]], !alias.scope !10, !noalias !7
; CHECK-NEXT:    [[INDEX_NEXT_3]] = add i64 [[INDEX]], 16
; CHECK-NEXT:    [[NITER_NSUB_3]] = add i64 [[NITER]], -4
; CHECK-NEXT:    [[NITER_NCMP_3:%.*]] = icmp eq i64 [[NITER_NSUB_3]], 0
; CHECK-NEXT:    br i1 [[NITER_NCMP_3]], label [[MIDDLE_BLOCK_UNR_LCSSA]], label [[VECTOR_BODY]], [[LOOP12:!llvm.loop !.*]]
; CHECK:       middle.block.unr-lcssa:
; CHECK-NEXT:    [[INDEX_UNR:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT_3]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[LCMP_MOD_NOT:%.*]] = icmp eq i64 [[XTRAITER]], 0
; CHECK-NEXT:    br i1 [[LCMP_MOD_NOT]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY_EPIL_PREHEADER:%.*]]
; CHECK:       vector.body.epil.preheader:
; CHECK-NEXT:    [[TMP28:%.*]] = fdiv fast <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, [[BROADCAST_SPLAT]]
; CHECK-NEXT:    br label [[VECTOR_BODY_EPIL:%.*]]
; CHECK:       vector.body.epil:
; CHECK-NEXT:    [[INDEX_EPIL:%.*]] = phi i64 [ [[INDEX_UNR]], [[VECTOR_BODY_EPIL_PREHEADER]] ], [ [[INDEX_NEXT_EPIL:%.*]], [[VECTOR_BODY_EPIL]] ]
; CHECK-NEXT:    [[EPIL_ITER:%.*]] = phi i64 [ [[XTRAITER]], [[VECTOR_BODY_EPIL_PREHEADER]] ], [ [[EPIL_ITER_SUB:%.*]], [[VECTOR_BODY_EPIL]] ]
; CHECK-NEXT:    [[TMP29:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDEX_EPIL]]
; CHECK-NEXT:    [[TMP30:%.*]] = bitcast double* [[TMP29]] to <4 x double>*
; CHECK-NEXT:    [[WIDE_LOAD_EPIL:%.*]] = load <4 x double>, <4 x double>* [[TMP30]], align 8, [[TBAA3]], !alias.scope !7
; CHECK-NEXT:    [[TMP31:%.*]] = fmul fast <4 x double> [[WIDE_LOAD_EPIL]], [[TMP28]]
; CHECK-NEXT:    [[TMP32:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDEX_EPIL]]
; CHECK-NEXT:    [[TMP33:%.*]] = bitcast double* [[TMP32]] to <4 x double>*
; CHECK-NEXT:    store <4 x double> [[TMP31]], <4 x double>* [[TMP33]], align 8, [[TBAA3]], !alias.scope !10, !noalias !7
; CHECK-NEXT:    [[INDEX_NEXT_EPIL]] = add i64 [[INDEX_EPIL]], 4
; CHECK-NEXT:    [[EPIL_ITER_SUB]] = add i64 [[EPIL_ITER]], -1
; CHECK-NEXT:    [[EPIL_ITER_CMP_NOT:%.*]] = icmp eq i64 [[EPIL_ITER_SUB]], 0
; CHECK-NEXT:    br i1 [[EPIL_ITER_CMP_NOT]], label [[MIDDLE_BLOCK]], label [[VECTOR_BODY_EPIL]], [[LOOP14:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N_VEC]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END]], label [[FOR_BODY_PREHEADER]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    [[INDVARS_IV_PH:%.*]] = phi i64 [ 0, [[VECTOR_MEMCHECK]] ], [ 0, [[FOR_BODY_LR_PH]] ], [ [[N_VEC]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[TMP34:%.*]] = xor i64 [[INDVARS_IV_PH]], -1
; CHECK-NEXT:    [[TMP35:%.*]] = add nsw i64 [[TMP34]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    [[XTRAITER8:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 3
; CHECK-NEXT:    [[LCMP_MOD9_NOT:%.*]] = icmp eq i64 [[XTRAITER8]], 0
; CHECK-NEXT:    br i1 [[LCMP_MOD9_NOT]], label [[FOR_BODY_PROL_LOOPEXIT:%.*]], label [[FOR_BODY_PROL_PREHEADER:%.*]]
; CHECK:       for.body.prol.preheader:
; CHECK-NEXT:    [[TMP36:%.*]] = fdiv fast double 1.000000e+00, [[A]]
; CHECK-NEXT:    br label [[FOR_BODY_PROL:%.*]]
; CHECK:       for.body.prol:
; CHECK-NEXT:    [[INDVARS_IV_PROL:%.*]] = phi i64 [ [[INDVARS_IV_NEXT_PROL:%.*]], [[FOR_BODY_PROL]] ], [ [[INDVARS_IV_PH]], [[FOR_BODY_PROL_PREHEADER]] ]
; CHECK-NEXT:    [[PROL_ITER:%.*]] = phi i64 [ [[PROL_ITER_SUB:%.*]], [[FOR_BODY_PROL]] ], [ [[XTRAITER8]], [[FOR_BODY_PROL_PREHEADER]] ]
; CHECK-NEXT:    [[ARRAYIDX_PROL:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDVARS_IV_PROL]]
; CHECK-NEXT:    [[T0_PROL:%.*]] = load double, double* [[ARRAYIDX_PROL]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[TMP37:%.*]] = fmul fast double [[T0_PROL]], [[TMP36]]
; CHECK-NEXT:    [[ARRAYIDX2_PROL:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDVARS_IV_PROL]]
; CHECK-NEXT:    store double [[TMP37]], double* [[ARRAYIDX2_PROL]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_PROL]] = add nuw nsw i64 [[INDVARS_IV_PROL]], 1
; CHECK-NEXT:    [[PROL_ITER_SUB]] = add i64 [[PROL_ITER]], -1
; CHECK-NEXT:    [[PROL_ITER_CMP_NOT:%.*]] = icmp eq i64 [[PROL_ITER_SUB]], 0
; CHECK-NEXT:    br i1 [[PROL_ITER_CMP_NOT]], label [[FOR_BODY_PROL_LOOPEXIT]], label [[FOR_BODY_PROL]], [[LOOP16:!llvm.loop !.*]]
; CHECK:       for.body.prol.loopexit:
; CHECK-NEXT:    [[INDVARS_IV_UNR:%.*]] = phi i64 [ [[INDVARS_IV_PH]], [[FOR_BODY_PREHEADER]] ], [ [[INDVARS_IV_NEXT_PROL]], [[FOR_BODY_PROL]] ]
; CHECK-NEXT:    [[TMP38:%.*]] = icmp ult i64 [[TMP35]], 3
; CHECK-NEXT:    br i1 [[TMP38]], label [[FOR_END]], label [[FOR_BODY_PREHEADER_NEW:%.*]]
; CHECK:       for.body.preheader.new:
; CHECK-NEXT:    [[TMP39:%.*]] = fdiv fast double 1.000000e+00, [[A]]
; CHECK-NEXT:    [[TMP40:%.*]] = fdiv fast double 1.000000e+00, [[A]]
; CHECK-NEXT:    [[TMP41:%.*]] = fdiv fast double 1.000000e+00, [[A]]
; CHECK-NEXT:    [[TMP42:%.*]] = fdiv fast double 1.000000e+00, [[A]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_UNR]], [[FOR_BODY_PREHEADER_NEW]] ], [ [[INDVARS_IV_NEXT_3:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[T0:%.*]] = load double, double* [[ARRAYIDX]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[TMP43:%.*]] = fmul fast double [[T0]], [[TMP39]]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    store double [[TMP43]], double* [[ARRAYIDX2]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[T0_1:%.*]] = load double, double* [[ARRAYIDX_1]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[TMP44:%.*]] = fmul fast double [[T0_1]], [[TMP40]]
; CHECK-NEXT:    [[ARRAYIDX2_1:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    store double [[TMP44]], double* [[ARRAYIDX2_1]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_1:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDVARS_IV_NEXT_1]]
; CHECK-NEXT:    [[T0_2:%.*]] = load double, double* [[ARRAYIDX_2]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[TMP45:%.*]] = fmul fast double [[T0_2]], [[TMP41]]
; CHECK-NEXT:    [[ARRAYIDX2_2:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDVARS_IV_NEXT_1]]
; CHECK-NEXT:    store double [[TMP45]], double* [[ARRAYIDX2_2]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_2:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds double, double* [[Y]], i64 [[INDVARS_IV_NEXT_2]]
; CHECK-NEXT:    [[T0_3:%.*]] = load double, double* [[ARRAYIDX_3]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[TMP46:%.*]] = fmul fast double [[T0_3]], [[TMP42]]
; CHECK-NEXT:    [[ARRAYIDX2_3:%.*]] = getelementptr inbounds double, double* [[X]], i64 [[INDVARS_IV_NEXT_2]]
; CHECK-NEXT:    store double [[TMP46]], double* [[ARRAYIDX2_3]], align 8, [[TBAA3]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT_3]] = add nuw nsw i64 [[INDVARS_IV]], 4
; CHECK-NEXT:    [[EXITCOND_NOT_3:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT_3]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT_3]], label [[FOR_END]], label [[FOR_BODY]], [[LOOP17:!llvm.loop !.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %div = fdiv fast double 1.0, %a
  br label %for.cond

for.cond:
  %n.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %n.0, %N
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  br label %for.end

for.body:
  %idxprom = sext i32 %n.0 to i64
  %arrayidx = getelementptr inbounds double, double* %y, i64 %idxprom
  %t0 = load double, double* %arrayidx, align 8, !tbaa !3
  %mul = fmul fast double %t0, %div
  %idxprom1 = sext i32 %n.0 to i64
  %arrayidx2 = getelementptr inbounds double, double* %x, i64 %idxprom1
  store double %mul, double* %arrayidx2, align 8, !tbaa !3
  br label %for.inc

for.inc:
  %inc = add nsw i32 %n.0, 1
  br label %for.cond

for.end:
  ret void
}

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="true" "no-jump-tables"="false" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="skylake-avx512" "target-features"="+adx,+aes,+avx,+avx2,+avx512bw,+avx512cd,+avx512dq,+avx512f,+avx512vl,+bmi,+bmi2,+clflushopt,+clwb,+cx16,+cx8,+f16c,+fma,+fsgsbase,+fxsr,+invpcid,+lzcnt,+mmx,+movbe,+pclmul,+pku,+popcnt,+prfchw,+rdrnd,+rdseed,+sahf,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsavec,+xsaveopt,+xsaves" "unsafe-fp-math"="true" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{!"clang version 11.0.0 (https://github.com/llvm/llvm-project.git 45ebe38ffc40bb7221fc587bfb4481cf7f53ebbc)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"double", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}

