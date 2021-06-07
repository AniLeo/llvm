; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-vectorize -dce -instcombine < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"
target triple = "x86_64-unknown-linux-gnu"

; Ensure that the 'inbounds' is preserved on the GEPs that feed the load and store in the loop.
define void @foo(i8 addrspace(1)* align 8 dereferenceable_or_null(16), i8 addrspace(1)* align 8 dereferenceable_or_null(8), i64) #0 {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[DOT10:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[TMP0:%.*]], i64 16
; CHECK-NEXT:    [[DOT11:%.*]] = bitcast i8 addrspace(1)* [[DOT10]] to i8 addrspace(1)* addrspace(1)*
; CHECK-NEXT:    [[DOT12:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[TMP1:%.*]], i64 16
; CHECK-NEXT:    [[DOT13:%.*]] = bitcast i8 addrspace(1)* [[DOT12]] to i8 addrspace(1)* addrspace(1)*
; CHECK-NEXT:    [[UMAX2:%.*]] = call i64 @llvm.umax.i64(i64 [[TMP2:%.*]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[UMAX2]], 16
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[TMP2]], i64 1)
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[UMAX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = add i64 [[TMP3]], 16
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i8, i8 addrspace(1)* [[TMP0]], i64 [[TMP4]]
; CHECK-NEXT:    [[SCEVGEP1:%.*]] = getelementptr i8, i8 addrspace(1)* [[TMP1]], i64 [[TMP4]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8 addrspace(1)* [[DOT10]], [[SCEVGEP1]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8 addrspace(1)* [[DOT12]], [[SCEVGEP]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[UMAX2]], -16
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[DOT13]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP5]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8 addrspace(1)*>, <4 x i8 addrspace(1)*> addrspace(1)* [[TMP6]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[TMP5]], i64 4
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP7]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    [[WIDE_LOAD3:%.*]] = load <4 x i8 addrspace(1)*>, <4 x i8 addrspace(1)*> addrspace(1)* [[TMP8]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[TMP5]], i64 8
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP9]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    [[WIDE_LOAD4:%.*]] = load <4 x i8 addrspace(1)*>, <4 x i8 addrspace(1)*> addrspace(1)* [[TMP10]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[TMP5]], i64 12
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP11]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    [[WIDE_LOAD5:%.*]] = load <4 x i8 addrspace(1)*>, <4 x i8 addrspace(1)*> addrspace(1)* [[TMP12]], align 8, !alias.scope !0
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[DOT11]], i64 [[INDEX]]
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP13]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    store <4 x i8 addrspace(1)*> [[WIDE_LOAD]], <4 x i8 addrspace(1)*> addrspace(1)* [[TMP14]], align 8, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[TMP13]], i64 4
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP15]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    store <4 x i8 addrspace(1)*> [[WIDE_LOAD3]], <4 x i8 addrspace(1)*> addrspace(1)* [[TMP16]], align 8, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[TMP13]], i64 8
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP17]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    store <4 x i8 addrspace(1)*> [[WIDE_LOAD4]], <4 x i8 addrspace(1)*> addrspace(1)* [[TMP18]], align 8, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[TMP13]], i64 12
; CHECK-NEXT:    [[TMP20:%.*]] = bitcast i8 addrspace(1)* addrspace(1)* [[TMP19]] to <4 x i8 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    store <4 x i8 addrspace(1)*> [[WIDE_LOAD5]], <4 x i8 addrspace(1)*> addrspace(1)* [[TMP20]], align 8, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP21:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP21]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP5:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[UMAX2]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[PREHEADER]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDVARS_IV3:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT4:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[DOT18:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[DOT13]], i64 [[INDVARS_IV3]]
; CHECK-NEXT:    [[V:%.*]] = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[DOT18]], align 8
; CHECK-NEXT:    [[DOT20:%.*]] = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[DOT11]], i64 [[INDVARS_IV3]]
; CHECK-NEXT:    store i8 addrspace(1)* [[V]], i8 addrspace(1)* addrspace(1)* [[DOT20]], align 8
; CHECK-NEXT:    [[INDVARS_IV_NEXT4]] = add nuw nsw i64 [[INDVARS_IV3]], 1
; CHECK-NEXT:    [[DOT21:%.*]] = icmp ult i64 [[INDVARS_IV_NEXT4]], [[TMP2]]
; CHECK-NEXT:    br i1 [[DOT21]], label [[LOOP]], label [[LOOPEXIT]], [[LOOP7:!llvm.loop !.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    ret void
;
entry:
  br label %preheader

preheader:                                       ; preds = %4
  %.10 = getelementptr inbounds i8, i8 addrspace(1)* %0, i64 16
  %.11 = bitcast i8 addrspace(1)* %.10 to i8 addrspace(1)* addrspace(1)*
  %.12 = getelementptr inbounds i8, i8 addrspace(1)* %1, i64 16
  %.13 = bitcast i8 addrspace(1)* %.12 to i8 addrspace(1)* addrspace(1)*
  br label %loop

loop:
  %indvars.iv3 = phi i64 [ 0, %preheader ], [ %indvars.iv.next4, %loop ]
  %.18 = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %.13, i64 %indvars.iv3
  %v = load i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %.18, align 8
  %.20 = getelementptr inbounds i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %.11, i64 %indvars.iv3
  store i8 addrspace(1)* %v, i8 addrspace(1)* addrspace(1)* %.20, align 8
  %indvars.iv.next4 = add nuw nsw i64 %indvars.iv3, 1
  %.21 = icmp ult i64 %indvars.iv.next4, %2
  br i1 %.21, label %loop, label %loopexit

loopexit:
  ret void
}

attributes #0 = { uwtable "target-cpu"="skylake" "target-features"="+sse2,+cx16,+sahf,-tbm,-avx512ifma,-sha,-gfni,-fma4,-vpclmulqdq,+prfchw,+bmi2,-cldemote,+fsgsbase,+xsavec,+popcnt,+aes,-avx512bitalg,+xsaves,-avx512er,-avx512vnni,-avx512vpopcntdq,-clwb,-avx512f,-clzero,-pku,+mmx,-lwp,-rdpid,-xop,+rdseed,-waitpkg,-sse4a,-avx512bw,+clflushopt,+xsave,-avx512vbmi2,-avx512vl,-avx512cd,+avx,-vaes,+rtm,+fma,+bmi,+rdrnd,-mwaitx,+sse4.1,+sse4.2,+avx2,-wbnoinvd,+sse,+lzcnt,+pclmul,-prefetchwt1,+f16c,+ssse3,+sgx,-shstk,+cmov,-avx512vbmi,+movbe,+xsaveopt,-avx512dq,+adx,-avx512pf,+sse3" }

!0 = !{i32 0, i32 2147483646}
!1 = !{}
