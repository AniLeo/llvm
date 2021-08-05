; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: asserts
; RUN: opt -loop-vectorize -scalable-vectorization=on -S -mtriple=aarch64 -mattr=+sve -debug-only=loop-vectorize < %s 2>&1 | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; CHECK-LABEL:  LV: Checking a loop in "pointer_induction_used_as_vector"
; CHECK-NOT:    LV: Found {{.*}} scalar instruction:   %ptr.iv.2.next = getelementptr inbounds i8, i8* %ptr.iv.2, i64 1
;
; CHECK:        VPlan 'Initial VPlan for VF={vscale x 2},UF>=1' {
; CHECK-NEXT:   loop.body:
; CHECK-NEXT:     WIDEN-INDUCTION %iv = phi 0, %iv.next
; CHECK-NEXT:     WIDEN-PHI %ptr.iv.1 = phi %start.1, %ptr.iv.1.next
; CHECK-NEXT:     WIDEN-PHI %ptr.iv.2 = phi %start.2, %ptr.iv.2.next
; CHECK-NEXT:     WIDEN-GEP Var[Inv] ir<%ptr.iv.2.next> = getelementptr ir<%ptr.iv.2>, ir<1>
; CHECK-NEXT:     WIDEN store ir<%ptr.iv.1>, ir<%ptr.iv.2.next>
; CHECK-NEXT:     WIDEN ir<%lv> = load ir<%ptr.iv.2>
; CHECK-NEXT:     WIDEN ir<%add> = add ir<%lv>, ir<1>
; CHECK-NEXT:     WIDEN store ir<%ptr.iv.2>, ir<%add>
; CHECK-NEXT:   No successors
; CHECK-NEXT:   }

; In the test below the pointer phi %ptr.iv.2 is used as
;  1. As a uniform address for the load, and
;  2. Non-uniform use by the getelementptr which is stored. This requires the
;     vector value.
define void @pointer_induction_used_as_vector(i8** noalias %start.1, i8* noalias %start.2, i64 %N) {
; CHECK-LABEL: @pointer_induction_used_as_vector(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 2
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], [[TMP1]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 2
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = getelementptr i8*, i8** [[START_1:%.*]], i64 [[N_VEC]]
; CHECK-NEXT:    [[IND_END3:%.*]] = getelementptr i8, i8* [[START_2:%.*]], i64 [[N_VEC]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i8*, i8** [[START_1]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP6:%.*]] = call <vscale x 2 x i64> @llvm.experimental.stepvector.nxv2i64()
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 2 x i64> poison, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 2 x i64> [[DOTSPLATINSERT]], <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP7:%.*]] = add <vscale x 2 x i64> shufflevector (<vscale x 2 x i64> insertelement (<vscale x 2 x i64> poison, i64 0, i32 0), <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer), [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = add <vscale x 2 x i64> [[DOTSPLAT]], [[TMP7]]
; CHECK-NEXT:    [[NEXT_GEP4:%.*]] = getelementptr i8, i8* [[START_2]], <vscale x 2 x i64> [[TMP8]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i8, <vscale x 2 x i8*> [[NEXT_GEP4]], i64 1
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr i8*, i8** [[NEXT_GEP]], i32 0
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i8** [[TMP10]] to <vscale x 2 x i8*>*
; CHECK-NEXT:    store <vscale x 2 x i8*> [[TMP9]], <vscale x 2 x i8*>* [[TMP11]], align 8
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <vscale x 2 x i8*> [[NEXT_GEP4]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr i8, i8* [[TMP12]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast i8* [[TMP13]] to <vscale x 2 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x i8>, <vscale x 2 x i8>* [[TMP14]], align 1
; CHECK-NEXT:    [[TMP15:%.*]] = add <vscale x 2 x i8> [[WIDE_LOAD]], shufflevector (<vscale x 2 x i8> insertelement (<vscale x 2 x i8> poison, i8 1, i32 0), <vscale x 2 x i8> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast i8* [[TMP13]] to <vscale x 2 x i8>*
; CHECK-NEXT:    store <vscale x 2 x i8> [[TMP15]], <vscale x 2 x i8>* [[TMP16]], align 1
; CHECK-NEXT:    [[TMP17:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP18:%.*]] = mul i64 [[TMP17]], 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP18]]
; CHECK-NEXT:    [[TMP19:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP19]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i8** [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[START_1]], [[ENTRY]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL2:%.*]] = phi i8* [ [[IND_END3]], [[MIDDLE_BLOCK]] ], [ [[START_2]], [[ENTRY]] ]
; CHECK-NEXT:    br label [[LOOP_BODY:%.*]]
; CHECK:       loop.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_BODY]] ]
; CHECK-NEXT:    [[PTR_IV_1:%.*]] = phi i8** [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ], [ [[PTR_IV_1_NEXT:%.*]], [[LOOP_BODY]] ]
; CHECK-NEXT:    [[PTR_IV_2:%.*]] = phi i8* [ [[BC_RESUME_VAL2]], [[SCALAR_PH]] ], [ [[PTR_IV_2_NEXT:%.*]], [[LOOP_BODY]] ]
; CHECK-NEXT:    [[PTR_IV_1_NEXT]] = getelementptr inbounds i8*, i8** [[PTR_IV_1]], i64 1
; CHECK-NEXT:    [[PTR_IV_2_NEXT]] = getelementptr inbounds i8, i8* [[PTR_IV_2]], i64 1
; CHECK-NEXT:    store i8* [[PTR_IV_2_NEXT]], i8** [[PTR_IV_1]], align 8
; CHECK-NEXT:    [[LV:%.*]] = load i8, i8* [[PTR_IV_2]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[LV]], 1
; CHECK-NEXT:    store i8 [[ADD]], i8* [[PTR_IV_2]], align 1
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i64 [[IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[C]], label [[LOOP_BODY]], label [[EXIT]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;


entry:
  br label %loop.body

loop.body:                                    ; preds = %loop.body, %entry
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.body ]
  %ptr.iv.1 = phi i8** [ %start.1, %entry ], [ %ptr.iv.1.next, %loop.body ]
  %ptr.iv.2 = phi i8* [ %start.2, %entry ], [ %ptr.iv.2.next, %loop.body ]
  %ptr.iv.1.next = getelementptr inbounds i8*, i8** %ptr.iv.1, i64 1
  %ptr.iv.2.next = getelementptr inbounds i8, i8* %ptr.iv.2, i64 1
  store i8* %ptr.iv.2.next, i8** %ptr.iv.1, align 8
  %lv = load i8, i8* %ptr.iv.2, align 1
  %add = add i8 %lv, 1
  store i8 %add, i8* %ptr.iv.2, align 1
  %iv.next = add nuw i64 %iv, 1
  %c = icmp ne i64 %iv.next, %N
  br i1 %c, label %loop.body, label %exit, !llvm.loop !0

exit:                            ; preds = %loop.body
  ret void
}


attributes #0 = {"target-features"="+sve"}

!0 = distinct !{!0, !1, !2, !3}
!1 = !{!"llvm.loop.interleave.count", i32 1}
!2 = !{!"llvm.loop.vectorize.width", i32 2}
!3 = !{!"llvm.loop.vectorize.scalable.enable", i1 true}
!4 = !{ !5 }
!5 = distinct !{ !5, !6 }
!6 = distinct !{ !7 }
!7 = distinct !{ !7, !6 }
