; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs -disable-mve-tail-predication=false %s -o - | FileCheck %s

define arm_aapcs_vfpcc void @fmas1(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fmas1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB0_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmov q3, q0
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vldrw.u32 q2, [r0], #16
; CHECK-NEXT:    vfma.f32 q3, q2, q1
; CHECK-NEXT:    vstrw.32 q3, [r2], #16
; CHECK-NEXT:    letp lr, .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = call fast <4 x float> @llvm.fma.v4f32(<4 x float> %wide.masked.load, <4 x float> %wide.masked.load12, <4 x float> %broadcast.splat14)
  %6 = getelementptr inbounds float, float* %z, i32 %index
  %7 = bitcast float* %6 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %5, <4 x float>* %7, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %8 = icmp eq i32 %index.next, %n.vec
  br i1 %8, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fmas2(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fmas2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB1_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vfmas.f32 q1, q0, r12
; CHECK-NEXT:    vstrw.32 q1, [r2], #16
; CHECK-NEXT:    letp lr, .LBB1_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = fmul fast <4 x float> %wide.masked.load12, %wide.masked.load
  %6 = fadd fast <4 x float> %5, %broadcast.splat14
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fma1(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fma1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB2_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vldrw.u32 q2, [r1], #16
; CHECK-NEXT:    vfma.f32 q2, q1, q0
; CHECK-NEXT:    vstrw.32 q2, [r2], #16
; CHECK-NEXT:    letp lr, .LBB2_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = call fast <4 x float> @llvm.fma.v4f32(<4 x float> %wide.masked.load, <4 x float> %broadcast.splat14, <4 x float> %wide.masked.load12)
  %6 = getelementptr inbounds float, float* %z, i32 %index
  %7 = bitcast float* %6 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %5, <4 x float>* %7, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %8 = icmp eq i32 %index.next, %n.vec
  br i1 %8, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fma2(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fma2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB3_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vfma.f32 q1, q0, r12
; CHECK-NEXT:    vstrw.32 q1, [r2], #16
; CHECK-NEXT:    letp lr, .LBB3_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert12 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat13 = shufflevector <4 x float> %broadcast.splatinsert12, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = fmul fast <4 x float> %wide.masked.load, %broadcast.splat13
  %4 = getelementptr inbounds float, float* %y, i32 %index
  %5 = bitcast float* %4 to <4 x float>*
  %wide.masked.load14 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %5, i32 4, <4 x i1> %1, <4 x float> undef)
  %6 = fadd fast <4 x float> %3, %wide.masked.load14
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fmss1(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fmss1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:    eor r12, r12, #-2147483648
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:  .LBB4_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmov q3, q0
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vldrw.u32 q2, [r0], #16
; CHECK-NEXT:    vfma.f32 q3, q2, q1
; CHECK-NEXT:    vstrw.32 q3, [r2], #16
; CHECK-NEXT:    letp lr, .LBB4_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %fneg = fneg fast float %a
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %fneg, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = call fast <4 x float> @llvm.fma.v4f32(<4 x float> %wide.masked.load, <4 x float> %wide.masked.load12, <4 x float> %broadcast.splat14)
  %6 = getelementptr inbounds float, float* %z, i32 %index
  %7 = bitcast float* %6 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %5, <4 x float>* %7, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %8 = icmp eq i32 %index.next, %n.vec
  br i1 %8, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fmss2(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fmss2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:    vneg.f32 q0, q0
; CHECK-NEXT:  .LBB5_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmov q3, q0
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vldrw.u32 q2, [r1], #16
; CHECK-NEXT:    vfma.f32 q3, q2, q1
; CHECK-NEXT:    vstrw.32 q3, [r2], #16
; CHECK-NEXT:    letp lr, .LBB5_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = fmul fast <4 x float> %wide.masked.load12, %wide.masked.load
  %6 = fsub fast <4 x float> %5, %broadcast.splat14
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fmss3(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fmss3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB6_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmov q3, q0
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vldrw.u32 q2, [r0], #16
; CHECK-NEXT:    vfms.f32 q3, q2, q1
; CHECK-NEXT:    vstrw.32 q3, [r2], #16
; CHECK-NEXT:    letp lr, .LBB6_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = fneg fast <4 x float> %wide.masked.load12
  %6 = call fast <4 x float> @llvm.fma.v4f32(<4 x float> %wide.masked.load, <4 x float> %5, <4 x float> %broadcast.splat14)
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fmss4(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fmss4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB7_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmov q3, q0
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vldrw.u32 q2, [r1], #16
; CHECK-NEXT:    vfms.f32 q3, q2, q1
; CHECK-NEXT:    vstrw.32 q3, [r2], #16
; CHECK-NEXT:    letp lr, .LBB7_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = fmul fast <4 x float> %wide.masked.load12, %wide.masked.load
  %6 = fsub fast <4 x float> %broadcast.splat14, %5
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fms1(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fms1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:    eor r12, r12, #-2147483648
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:  .LBB8_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vldrw.u32 q2, [r1], #16
; CHECK-NEXT:    vfma.f32 q2, q1, q0
; CHECK-NEXT:    vstrw.32 q2, [r2], #16
; CHECK-NEXT:    letp lr, .LBB8_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %fneg = fneg fast float %a
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %fneg, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = call fast <4 x float> @llvm.fma.v4f32(<4 x float> %wide.masked.load, <4 x float> %broadcast.splat14, <4 x float> %wide.masked.load12)
  %6 = getelementptr inbounds float, float* %z, i32 %index
  %7 = bitcast float* %6 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %5, <4 x float>* %7, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %8 = icmp eq i32 %index.next, %n.vec
  br i1 %8, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fms2(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fms2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB9_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vldrw.u32 q2, [r1], #16
; CHECK-NEXT:    vfms.f32 q2, q1, q0
; CHECK-NEXT:    vstrw.32 q2, [r2], #16
; CHECK-NEXT:    letp lr, .LBB9_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = fmul fast <4 x float> %wide.masked.load, %broadcast.splat14
  %6 = fsub fast <4 x float> %wide.masked.load12, %5
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fms3(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fms3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    vdup.32 q0, r12
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB10_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    vldrw.u32 q2, [r0], #16
; CHECK-NEXT:    vneg.f32 q1, q1
; CHECK-NEXT:    vfma.f32 q1, q2, q0
; CHECK-NEXT:    vstrw.32 q1, [r2], #16
; CHECK-NEXT:    letp lr, .LBB10_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert13 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat14 = shufflevector <4 x float> %broadcast.splatinsert13, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = getelementptr inbounds float, float* %y, i32 %index
  %4 = bitcast float* %3 to <4 x float>*
  %wide.masked.load12 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %1, <4 x float> undef)
  %5 = fneg fast <4 x float> %wide.masked.load12
  %6 = call fast <4 x float> @llvm.fma.v4f32(<4 x float> %wide.masked.load, <4 x float> %broadcast.splat14, <4 x float> %5)
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @fms4(float* nocapture readonly %x, float* nocapture readonly %y, float* noalias nocapture %z, float %a, i32 %n) {
; CHECK-LABEL: fms4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    poplt {r7, pc}
; CHECK-NEXT:    vmov r12, s0
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB11_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vldrw.u32 q1, [r0], #16
; CHECK-NEXT:    vneg.f32 q0, q0
; CHECK-NEXT:    vfma.f32 q0, q1, r12
; CHECK-NEXT:    vstrw.32 q0, [r2], #16
; CHECK-NEXT:    letp lr, .LBB11_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %vector.ph, label %for.cond.cleanup

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  %trip.count.minus.1 = add i32 %n, -1
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %trip.count.minus.1, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  %broadcast.splatinsert12 = insertelement <4 x float> undef, float %a, i32 0
  %broadcast.splat13 = shufflevector <4 x float> %broadcast.splatinsert12, <4 x float> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = or <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %0 = getelementptr inbounds float, float* %x, i32 %index
  %1 = icmp ule <4 x i32> %induction, %broadcast.splat11
  %2 = bitcast float* %0 to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %2, i32 4, <4 x i1> %1, <4 x float> undef)
  %3 = fmul fast <4 x float> %wide.masked.load, %broadcast.splat13
  %4 = getelementptr inbounds float, float* %y, i32 %index
  %5 = bitcast float* %4 to <4 x float>*
  %wide.masked.load14 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %5, i32 4, <4 x i1> %1, <4 x float> undef)
  %6 = fsub fast <4 x float> %3, %wide.masked.load14
  %7 = getelementptr inbounds float, float* %z, i32 %index
  %8 = bitcast float* %7 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %6, <4 x float>* %8, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

declare <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>*, i32 immarg, <4 x i1>, <4 x float>)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>)
declare void @llvm.masked.store.v4f32.p0v4f32(<4 x float>, <4 x float>*, i32 immarg, <4 x i1>)
