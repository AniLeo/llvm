; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs -disable-mve-tail-predication=false -o - %s | FileCheck %s
define arm_aapcs_vfpcc void @usub_sat(i16* noalias nocapture readonly %pSrcA, i16* noalias nocapture readonly %pSrcB, i16* noalias nocapture %pDst, i32 %blockSize) {
; CHECK-LABEL: usub_sat:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:    dlstp.16 lr, r3
; CHECK-NEXT:  .LBB0_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vldrh.u16 q1, [r0], #16
; CHECK-NEXT:    vqsub.u16 q0, q1, q0
; CHECK-NEXT:    vstrh.16 q0, [r2], #16
; CHECK-NEXT:    letp lr, .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %while.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp7 = icmp eq i32 %blockSize, 0
  br i1 %cmp7, label %while.end, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %blockSize, 7
  %n.vec = and i32 %n.rnd.up, -8
  %trip.count.minus.1 = add i32 %blockSize, -1
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr i16, i16* %pSrcA, i32 %index
  %next.gep20 = getelementptr i16, i16* %pDst, i32 %index
  %next.gep21 = getelementptr i16, i16* %pSrcB, i32 %index
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 %index, i32 %trip.count.minus.1)
  %0 = bitcast i16* %next.gep to <8 x i16>*
  %wide.masked.load = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %0, i32 2, <8 x i1> %active.lane.mask, <8 x i16> undef)
  %1 = bitcast i16* %next.gep21 to <8 x i16>*
  %wide.masked.load24 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %1, i32 2, <8 x i1> %active.lane.mask, <8 x i16> undef)
  %2 = call <8 x i16> @llvm.usub.sat.v8i16(<8 x i16> %wide.masked.load, <8 x i16> %wide.masked.load24)
  %3 = bitcast i16* %next.gep20 to <8 x i16>*
  call void @llvm.masked.store.v8i16.p0v8i16(<8 x i16> %2, <8 x i16>* %3, i32 2, <8 x i1> %active.lane.mask)
  %index.next = add i32 %index, 8
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %while.end, label %vector.body

while.end:                                        ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @ssub_sat(i16* noalias nocapture readonly %pSrcA, i16* noalias nocapture readonly %pSrcB, i16* noalias nocapture %pDst, i32 %blockSize) {
; CHECK-LABEL: ssub_sat:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:    dlstp.16 lr, r3
; CHECK-NEXT:  .LBB1_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vldrh.u16 q1, [r0], #16
; CHECK-NEXT:    vqsub.s16 q0, q1, q0
; CHECK-NEXT:    vstrh.16 q0, [r2], #16
; CHECK-NEXT:    letp lr, .LBB1_1
; CHECK-NEXT:  @ %bb.2: @ %while.end
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp7 = icmp eq i32 %blockSize, 0
  br i1 %cmp7, label %while.end, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %blockSize, 7
  %n.vec = and i32 %n.rnd.up, -8
  %trip.count.minus.1 = add i32 %blockSize, -1
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr i16, i16* %pSrcA, i32 %index
  %next.gep20 = getelementptr i16, i16* %pDst, i32 %index
  %next.gep21 = getelementptr i16, i16* %pSrcB, i32 %index
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 %index, i32 %trip.count.minus.1)
  %0 = bitcast i16* %next.gep to <8 x i16>*
  %wide.masked.load = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %0, i32 2, <8 x i1> %active.lane.mask, <8 x i16> undef)
  %1 = bitcast i16* %next.gep21 to <8 x i16>*
  %wide.masked.load24 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %1, i32 2, <8 x i1> %active.lane.mask, <8 x i16> undef)
  %2 = call <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16> %wide.masked.load, <8 x i16> %wide.masked.load24)
  %3 = bitcast i16* %next.gep20 to <8 x i16>*
  call void @llvm.masked.store.v8i16.p0v8i16(<8 x i16> %2, <8 x i16>* %3, i32 2, <8 x i1> %active.lane.mask)
  %index.next = add i32 %index, 8
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %while.end, label %vector.body

while.end:                                        ; preds = %vector.body, %entry
  ret void
}

declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32, i32)

declare <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>*, i32 immarg, <8 x i1>, <8 x i16>)

declare <8 x i16> @llvm.ssub.sat.v8i16(<8 x i16>, <8 x i16>)

declare <8 x i16> @llvm.usub.sat.v8i16(<8 x i16>, <8 x i16>)

declare void @llvm.masked.store.v8i16.p0v8i16(<8 x i16>, <8 x i16>*, i32 immarg, <8 x i1>)
