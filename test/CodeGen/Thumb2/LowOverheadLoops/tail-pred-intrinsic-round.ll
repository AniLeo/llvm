; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs -tail-predication=enabled -o - %s | FileCheck %s

define arm_aapcs_vfpcc void @round(float* noalias nocapture readonly %pSrcA, float* noalias nocapture %pDst, i32 %n) #0 {
; CHECK-LABEL: round:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB0_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r2
; CHECK-NEXT:  .LBB0_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vrinta.f32 q0, q0
; CHECK-NEXT:    vstrw.32 q0, [r1], #16
; CHECK-NEXT:    letp lr, .LBB0_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp5 = icmp eq i32 %n, 0
  br i1 %cmp5, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %pSrcA, i32 %index
  %next.gep14 = getelementptr float, float* %pDst, i32 %index
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = bitcast float* %next.gep to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %active.lane.mask, <4 x float> undef)
  %1 = call fast <4 x float> @llvm.round.v4f32(<4 x float> %wide.masked.load)
  %2 = bitcast float* %next.gep14 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %1, <4 x float>* %2, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @rint(float* noalias nocapture readonly %pSrcA, float* noalias nocapture %pDst, i32 %n) #0 {
; CHECK-LABEL: rint:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB1_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r2
; CHECK-NEXT:  .LBB1_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vrintx.f32 q0, q0
; CHECK-NEXT:    vstrw.32 q0, [r1], #16
; CHECK-NEXT:    letp lr, .LBB1_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp5 = icmp eq i32 %n, 0
  br i1 %cmp5, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %pSrcA, i32 %index
  %next.gep14 = getelementptr float, float* %pDst, i32 %index
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = bitcast float* %next.gep to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %active.lane.mask, <4 x float> undef)
  %1 = call fast <4 x float> @llvm.rint.v4f32(<4 x float> %wide.masked.load)
  %2 = bitcast float* %next.gep14 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %1, <4 x float>* %2, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @trunc(float* noalias nocapture readonly %pSrcA, float* noalias nocapture %pDst, i32 %n) #0 {
; CHECK-LABEL: trunc:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB2_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r2
; CHECK-NEXT:  .LBB2_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vrintz.f32 q0, q0
; CHECK-NEXT:    vstrw.32 q0, [r1], #16
; CHECK-NEXT:    letp lr, .LBB2_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp5 = icmp eq i32 %n, 0
  br i1 %cmp5, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %pSrcA, i32 %index
  %next.gep14 = getelementptr float, float* %pDst, i32 %index
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = bitcast float* %next.gep to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %active.lane.mask, <4 x float> undef)
  %1 = call fast <4 x float> @llvm.trunc.v4f32(<4 x float> %wide.masked.load)
  %2 = bitcast float* %next.gep14 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %1, <4 x float>* %2, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @ceil(float* noalias nocapture readonly %pSrcA, float* noalias nocapture %pDst, i32 %n) #0 {
; CHECK-LABEL: ceil:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB3_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r2
; CHECK-NEXT:  .LBB3_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vrintp.f32 q0, q0
; CHECK-NEXT:    vstrw.32 q0, [r1], #16
; CHECK-NEXT:    letp lr, .LBB3_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp5 = icmp eq i32 %n, 0
  br i1 %cmp5, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %pSrcA, i32 %index
  %next.gep14 = getelementptr float, float* %pDst, i32 %index
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = bitcast float* %next.gep to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %active.lane.mask, <4 x float> undef)
  %1 = call fast <4 x float> @llvm.ceil.v4f32(<4 x float> %wide.masked.load)
  %2 = bitcast float* %next.gep14 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %1, <4 x float>* %2, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @floor(float* noalias nocapture readonly %pSrcA, float* noalias nocapture %pDst, i32 %n) #0 {
; CHECK-LABEL: floor:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB4_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r2
; CHECK-NEXT:  .LBB4_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vrintm.f32 q0, q0
; CHECK-NEXT:    vstrw.32 q0, [r1], #16
; CHECK-NEXT:    letp lr, .LBB4_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp5 = icmp eq i32 %n, 0
  br i1 %cmp5, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %pSrcA, i32 %index
  %next.gep14 = getelementptr float, float* %pDst, i32 %index
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = bitcast float* %next.gep to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %active.lane.mask, <4 x float> undef)
  %1 = call fast <4 x float> @llvm.floor.v4f32(<4 x float> %wide.masked.load)
  %2 = bitcast float* %next.gep14 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %1, <4 x float>* %2, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

; nearbyint shouldn't be tail predicated because it's lowered into multiple instructions
define arm_aapcs_vfpcc void @nearbyint(float* noalias nocapture readonly %pSrcA, float* noalias nocapture %pDst, i32 %n) #0 {
; CHECK-LABEL: nearbyint:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB5_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r2
; CHECK-NEXT:  .LBB5_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vrintr.f32 s3, s3
; CHECK-NEXT:    vrintr.f32 s2, s2
; CHECK-NEXT:    vrintr.f32 s1, s1
; CHECK-NEXT:    vrintr.f32 s0, s0
; CHECK-NEXT:    vstrw.32 q0, [r1], #16
; CHECK-NEXT:    letp lr, .LBB5_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp5 = icmp eq i32 %n, 0
  br i1 %cmp5, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %n, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %pSrcA, i32 %index
  %next.gep14 = getelementptr float, float* %pDst, i32 %index
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %0 = bitcast float* %next.gep to <4 x float>*
  %wide.masked.load = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %0, i32 4, <4 x i1> %active.lane.mask, <4 x float> undef)
  %1 = call fast <4 x float> @llvm.nearbyint.v4f32(<4 x float> %wide.masked.load)
  %2 = bitcast float* %next.gep14 to <4 x float>*
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %1, <4 x float>* %2, i32 4, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32) #1

declare <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>*, i32 immarg, <4 x i1>, <4 x float>) #2

declare <4 x float> @llvm.trunc.v4f32(<4 x float>) #3

declare <4 x float> @llvm.rint.v4f32(<4 x float>) #3

declare <4 x float> @llvm.round.v4f32(<4 x float>) #3

declare <4 x float> @llvm.ceil.v4f32(<4 x float>) #3

declare <4 x float> @llvm.floor.v4f32(<4 x float>) #3

declare <4 x float> @llvm.nearbyint.v4f32(<4 x float>) #1

declare void @llvm.masked.store.v4f32.p0v4f32(<4 x float>, <4 x float>*, i32 immarg, <4 x i1>) #4
