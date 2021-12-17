; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs -tail-predication=enabled -o - %s | FileCheck %s
%struct.SpeexPreprocessState_ = type { i32, i32, half*, half* }

define void @foo(%struct.SpeexPreprocessState_* nocapture readonly %st, i16* %x) {
; CHECK-LABEL: foo:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    ldrd r12, r2, [r0]
; CHECK-NEXT:    ldrd r4, r3, [r0, #8]
; CHECK-NEXT:    rsb r12, r12, r2, lsl #1
; CHECK-NEXT:    dlstp.16 lr, r12
; CHECK-NEXT:  .LBB0_1: @ %do.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r3], #16
; CHECK-NEXT:    vstrh.16 q0, [r4], #16
; CHECK-NEXT:    letp lr, .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %do.end
; CHECK-NEXT:    ldr r2, [r0]
; CHECK-NEXT:    ldr r0, [r0, #8]
; CHECK-NEXT:    add.w r0, r0, r12, lsl #1
; CHECK-NEXT:    mov.w r3, #6144
; CHECK-NEXT:    dlstp.16 lr, r2
; CHECK-NEXT:  .LBB0_3: @ %do.body6
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vcvt.f16.s16 q0, q0
; CHECK-NEXT:    vmul.f16 q0, q0, r3
; CHECK-NEXT:    vstrh.16 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB0_3
; CHECK-NEXT:  @ %bb.4: @ %do.end13
; CHECK-NEXT:    pop {r4, pc}
entry:
  %ps_size = getelementptr inbounds %struct.SpeexPreprocessState_, %struct.SpeexPreprocessState_* %st, i32 0, i32 1
  %0 = load i32, i32* %ps_size, align 4
  %mul = shl nsw i32 %0, 1
  %frame_size = getelementptr inbounds %struct.SpeexPreprocessState_, %struct.SpeexPreprocessState_* %st, i32 0, i32 0
  %1 = load i32, i32* %frame_size, align 4
  %sub = sub nsw i32 %mul, %1
  %inbuf = getelementptr inbounds %struct.SpeexPreprocessState_, %struct.SpeexPreprocessState_* %st, i32 0, i32 3
  %2 = load half*, half** %inbuf, align 4
  %frame = getelementptr inbounds %struct.SpeexPreprocessState_, %struct.SpeexPreprocessState_* %st, i32 0, i32 2
  %3 = load half*, half** %frame, align 4
  br label %do.body

do.body:                                          ; preds = %do.body, %entry
  %pinbuff16.0 = phi half* [ %2, %entry ], [ %add.ptr, %do.body ]
  %blkCnt.0 = phi i32 [ %sub, %entry ], [ %sub2, %do.body ]
  %pframef16.0 = phi half* [ %3, %entry ], [ %add.ptr1, %do.body ]
  %4 = tail call <8 x i1> @llvm.arm.mve.vctp16(i32 %blkCnt.0)
  %5 = bitcast half* %pinbuff16.0 to <8 x half>*
  %6 = tail call fast <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %5, i32 2, <8 x i1> %4, <8 x half> zeroinitializer)
  %7 = bitcast half* %pframef16.0 to <8 x half>*
  tail call void @llvm.masked.store.v8f16.p0v8f16(<8 x half> %6, <8 x half>* %7, i32 2, <8 x i1> %4)
  %add.ptr = getelementptr inbounds half, half* %pinbuff16.0, i32 8
  %add.ptr1 = getelementptr inbounds half, half* %pframef16.0, i32 8
  %sub2 = add nsw i32 %blkCnt.0, -8
  %cmp = icmp sgt i32 %blkCnt.0, 8
  br i1 %cmp, label %do.body, label %do.end

do.end:                                           ; preds = %do.body
  %8 = load half*, half** %frame, align 4
  %add.ptr4 = getelementptr inbounds half, half* %8, i32 %sub
  %9 = load i32, i32* %frame_size, align 4
  br label %do.body6

do.body6:                                         ; preds = %do.body6, %do.end
  %px.0 = phi i16* [ %x, %do.end ], [ %add.ptr8, %do.body6 ]
  %blkCnt.1 = phi i32 [ %9, %do.end ], [ %sub10, %do.body6 ]
  %pframef16.1 = phi half* [ %add.ptr4, %do.end ], [ %add.ptr9, %do.body6 ]
  %10 = tail call <8 x i1> @llvm.arm.mve.vctp16(i32 %blkCnt.1)
  %11 = bitcast i16* %px.0 to <8 x i16>*
  %12 = tail call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %11, i32 2, <8 x i1> %10, <8 x i16> zeroinitializer)
  %13 = tail call fast <8 x half> @llvm.arm.mve.vcvt.fp.int.predicated.v8f16.v8i16.v8i1(<8 x i16> %12, i32 0, <8 x i1> %10, <8 x half> undef)
  %14 = tail call fast <8 x half> @llvm.arm.mve.mul.predicated.v8f16.v8i1(<8 x half> %13, <8 x half> <half 0xH1800, half 0xH1800, half 0xH1800, half 0xH1800, half 0xH1800, half 0xH1800, half 0xH1800, half 0xH1800>, <8 x i1> %10, <8 x half> undef)
  %15 = bitcast half* %pframef16.1 to <8 x half>*
  tail call void @llvm.masked.store.v8f16.p0v8f16(<8 x half> %14, <8 x half>* %15, i32 2, <8 x i1> %10)
  %add.ptr8 = getelementptr inbounds i16, i16* %px.0, i32 8
  %add.ptr9 = getelementptr inbounds half, half* %pframef16.1, i32 8
  %sub10 = add nsw i32 %blkCnt.1, -8
  %cmp12 = icmp sgt i32 %blkCnt.1, 8
  br i1 %cmp12, label %do.body6, label %do.end13

do.end13:                                         ; preds = %do.body6
  ret void
}

declare <8 x i1> @llvm.arm.mve.vctp16(i32)

declare <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>*, i32 immarg, <8 x i1>, <8 x half>)

declare void @llvm.masked.store.v8f16.p0v8f16(<8 x half>, <8 x half>*, i32 immarg, <8 x i1>)

declare <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>*, i32 immarg, <8 x i1>, <8 x i16>)

declare <8 x half> @llvm.arm.mve.vcvt.fp.int.predicated.v8f16.v8i16.v8i1(<8 x i16>, i32, <8 x i1>, <8 x half>)

declare <8 x half> @llvm.arm.mve.mul.predicated.v8f16.v8i1(<8 x half>, <8 x half>, <8 x i1>, <8 x half>)
