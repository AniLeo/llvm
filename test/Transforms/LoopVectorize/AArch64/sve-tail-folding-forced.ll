; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: asserts
; RUN: opt -S -loop-vectorize -debug-only=loop-vectorize < %s 2>%t | FileCheck %s
; RUN: cat %t | FileCheck %s --check-prefix=VPLANS

; These tests ensure that tail-folding is enabled when the predicate.enable
; loop attribute is set to true.

target triple = "aarch64-unknown-linux-gnu"

; VPLANS-LABEL: Checking a loop in 'simple_memset'
; VPLANS:      VPlan 'Initial VPlan for VF={vscale x 1,vscale x 2,vscale x 4},UF>=1' {
; VPLANS-NEXT: vector.ph:
; VPLANS-NEXT:     EMIT vp<%2> = VF * Part +  ir<0>
; VPLANS-NEXT:     EMIT vp<%3> = active lane mask vp<%2> <badref>
; VPLANS-NEXT: Successor(s): vector loop
; VPLANS-EMPTY:
; VPLANS-NEXT: <x1> vector loop: {
; VPLANS-NEXT:   vector.body:
; VPLANS-NEXT:     EMIT vp<%4> = CANONICAL-INDUCTION
; VPLANS-NEXT:     ACTIVE-LANE-MASK-PHI vp<%5> = phi vp<%3>, vp<%10>
; VPLANS-NEXT:     vp<%6>    = SCALAR-STEPS vp<%4>, ir<0>, ir<1>
; VPLANS-NEXT:     CLONE ir<%gep> = getelementptr ir<%ptr>, vp<%6>
; VPLANS-NEXT:     WIDEN store ir<%gep>, ir<%val>, vp<%5>
; VPLANS-NEXT:     EMIT vp<%8> = VF * UF +  vp<%4>
; VPLANS-NEXT:     EMIT vp<%9> = VF * Part +  vp<%8>
; VPLANS-NEXT:     EMIT vp<%10> = active lane mask vp<%9> <badref>
; VPLANS-NEXT:     EMIT vp<%11> = not vp<%10>
; VPLANS-NEXT:     EMIT branch-on-cond vp<%11>
; VPLANS-NEXT:   No successors
; VPLANS-NEXT: }

define void @simple_memset(i32 %val, i32* %ptr, i64 %n) #0 {
; CHECK-LABEL: @simple_memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 -1, [[UMAX]]
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ult i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP3]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP4:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP5:%.*]] = mul i64 [[TMP4]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP7:%.*]] = mul i64 [[TMP6]], 4
; CHECK-NEXT:    [[TMP8:%.*]] = sub i64 [[TMP7]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[UMAX]], [[TMP8]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP5]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 0, i64 [[UMAX]])
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[VAL:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 4 x i32> [[BROADCAST_SPLATINSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX1:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK2:%.*]] = phi <vscale x 4 x i1> [ [[ACTIVE_LANE_MASK]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK4:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = add i64 [[INDEX1]], 0
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i64 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr i32, i32* [[TMP10]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast i32* [[TMP11]] to <vscale x 4 x i32>*
; CHECK-NEXT:    call void @llvm.masked.store.nxv4i32.p0nxv4i32(<vscale x 4 x i32> [[BROADCAST_SPLAT]], <vscale x 4 x i32>* [[TMP12]], i32 4, <vscale x 4 x i1> [[ACTIVE_LANE_MASK2]])
; CHECK-NEXT:    [[TMP13:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP14:%.*]] = mul i64 [[TMP13]], 4
; CHECK-NEXT:    [[INDEX_NEXT3]] = add i64 [[INDEX1]], [[TMP14]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK4]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 [[INDEX_NEXT3]], i64 [[UMAX]])
; CHECK-NEXT:    [[TMP15:%.*]] = xor <vscale x 4 x i1> [[ACTIVE_LANE_MASK4]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i32 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <vscale x 4 x i1> [[TMP15]], i32 0
; CHECK-NEXT:    br i1 [[TMP16]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
;
entry:
  br label %while.body

while.body:                                       ; preds = %while.body, %entry
  %index = phi i64 [ %index.next, %while.body ], [ 0, %entry ]
  %gep = getelementptr i32, i32* %ptr, i64 %index
  store i32 %val, i32* %gep
  %index.next = add nsw i64 %index, 1
  %cmp10 = icmp ult i64 %index.next, %n
  br i1 %cmp10, label %while.body, label %while.end.loopexit, !llvm.loop !0

while.end.loopexit:                               ; preds = %while.body
  ret void
}


attributes #0 = { "target-features"="+sve" }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.vectorize.predicate.enable", i1 true}
