; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve.fp -verify-machineinstrs -o - %s | FileCheck %s

%struct.float16x8x2_t = type { [2 x <8 x half>] }
%struct.uint8x16x4_t = type { [4 x <16 x i8>] }
%struct.uint32x4x2_t = type { [2 x <4 x i32>] }
%struct.int8x16x4_t = type { [4 x <16 x i8>] }

define arm_aapcs_vfpcc %struct.float16x8x2_t @test_vld2q_f16(half* %addr) {
; CHECK-LABEL: test_vld2q_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.16 {q0, q1}, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call { <8 x half>, <8 x half> } @llvm.arm.mve.vld2q.v8f16.p0f16(half* %addr)
  %1 = extractvalue { <8 x half>, <8 x half> } %0, 0
  %2 = insertvalue %struct.float16x8x2_t undef, <8 x half> %1, 0, 0
  %3 = extractvalue { <8 x half>, <8 x half> } %0, 1
  %4 = insertvalue %struct.float16x8x2_t %2, <8 x half> %3, 0, 1
  ret %struct.float16x8x2_t %4
}

define arm_aapcs_vfpcc half *@test_vld2q_f16_post(half* %addr, <8 x half>* %dst) {
; CHECK-LABEL: test_vld2q_f16_post:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vld21.16 {q0, q1}, [r0]!
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call { <8 x half>, <8 x half> } @llvm.arm.mve.vld2q.v8f16.p0f16(half* %addr)
  %1 = extractvalue { <8 x half>, <8 x half> } %0, 0
  store <8 x half> %1, <8 x half> *%dst, align 4
  %2 = getelementptr half, half *%addr, i32 16
  ret half *%2
}

declare { <8 x half>, <8 x half> } @llvm.arm.mve.vld2q.v8f16.p0f16(half*)

define arm_aapcs_vfpcc %struct.uint8x16x4_t @test_vld4q_u8(i8* %addr) {
; CHECK-LABEL: test_vld4q_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld40.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld41.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld42.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld43.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.arm.mve.vld4q.v16i8.p0i8(i8* %addr)
  %1 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %0, 0
  %2 = insertvalue %struct.uint8x16x4_t undef, <16 x i8> %1, 0, 0
  %3 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %0, 1
  %4 = insertvalue %struct.uint8x16x4_t %2, <16 x i8> %3, 0, 1
  %5 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %0, 2
  %6 = insertvalue %struct.uint8x16x4_t %4, <16 x i8> %5, 0, 2
  %7 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %0, 3
  %8 = insertvalue %struct.uint8x16x4_t %6, <16 x i8> %7, 0, 3
  ret %struct.uint8x16x4_t %8
}

define arm_aapcs_vfpcc i8* @test_vld4q_u8_post(i8* %addr, <16 x i8>* %dst) {
; CHECK-LABEL: test_vld4q_u8_post:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld40.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld41.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld42.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vld43.8 {q0, q1, q2, q3}, [r0]!
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %0 = tail call { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.arm.mve.vld4q.v16i8.p0i8(i8* %addr)
  %1 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %0, 0
  store <16 x i8> %1, <16 x i8> *%dst, align 4
  %2 = getelementptr i8, i8 *%addr, i32 64
  ret i8* %2
}

declare { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.arm.mve.vld4q.v16i8.p0i8(i8*)

define arm_aapcs_vfpcc void @test_vst2q_u32(i32* %addr, %struct.uint32x4x2_t %value.coerce) {
; CHECK-LABEL: test_vst2q_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    vst20.32 {q0, q1}, [r0]
; CHECK-NEXT:    vst21.32 {q0, q1}, [r0]
; CHECK-NEXT:    bx lr
entry:
  %value.coerce.fca.0.0.extract = extractvalue %struct.uint32x4x2_t %value.coerce, 0, 0
  %value.coerce.fca.0.1.extract = extractvalue %struct.uint32x4x2_t %value.coerce, 0, 1
  tail call void @llvm.arm.mve.vst2q.p0i32.v4i32(i32* %addr, <4 x i32> %value.coerce.fca.0.0.extract, <4 x i32> %value.coerce.fca.0.1.extract, i32 0)
  tail call void @llvm.arm.mve.vst2q.p0i32.v4i32(i32* %addr, <4 x i32> %value.coerce.fca.0.0.extract, <4 x i32> %value.coerce.fca.0.1.extract, i32 1)
  ret void
}

define arm_aapcs_vfpcc i32* @test_vst2q_u32_post(i32* %addr, %struct.uint32x4x2_t %value.coerce) {
; CHECK-LABEL: test_vst2q_u32_post:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    vst20.32 {q0, q1}, [r0]
; CHECK-NEXT:    vst21.32 {q0, q1}, [r0]!
; CHECK-NEXT:    bx lr
entry:
  %value.coerce.fca.0.0.extract = extractvalue %struct.uint32x4x2_t %value.coerce, 0, 0
  %value.coerce.fca.0.1.extract = extractvalue %struct.uint32x4x2_t %value.coerce, 0, 1
  tail call void @llvm.arm.mve.vst2q.p0i32.v4i32(i32* %addr, <4 x i32> %value.coerce.fca.0.0.extract, <4 x i32> %value.coerce.fca.0.1.extract, i32 0)
  tail call void @llvm.arm.mve.vst2q.p0i32.v4i32(i32* %addr, <4 x i32> %value.coerce.fca.0.0.extract, <4 x i32> %value.coerce.fca.0.1.extract, i32 1)
  %g = getelementptr i32, i32 *%addr, i32 8
  ret i32* %g
}

declare void @llvm.arm.mve.vst2q.p0i32.v4i32(i32*, <4 x i32>, <4 x i32>, i32)

define arm_aapcs_vfpcc void @test_vst2q_f16(half* %addr, %struct.float16x8x2_t %value.coerce) {
; CHECK-LABEL: test_vst2q_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    vst20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vst21.16 {q0, q1}, [r0]
; CHECK-NEXT:    bx lr
entry:
  %value.coerce.fca.0.0.extract = extractvalue %struct.float16x8x2_t %value.coerce, 0, 0
  %value.coerce.fca.0.1.extract = extractvalue %struct.float16x8x2_t %value.coerce, 0, 1
  call void @llvm.arm.mve.vst2q.p0f16.v8f16(half* %addr, <8 x half> %value.coerce.fca.0.0.extract, <8 x half> %value.coerce.fca.0.1.extract, i32 0)
  call void @llvm.arm.mve.vst2q.p0f16.v8f16(half* %addr, <8 x half> %value.coerce.fca.0.0.extract, <8 x half> %value.coerce.fca.0.1.extract, i32 1)
  ret void
}

define arm_aapcs_vfpcc half* @test_vst2q_f16_post(half* %addr, %struct.float16x8x2_t %value.coerce) {
; CHECK-LABEL: test_vst2q_f16_post:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1 def $q0_q1
; CHECK-NEXT:    vst20.16 {q0, q1}, [r0]
; CHECK-NEXT:    vst21.16 {q0, q1}, [r0]!
; CHECK-NEXT:    bx lr
entry:
  %value.coerce.fca.0.0.extract = extractvalue %struct.float16x8x2_t %value.coerce, 0, 0
  %value.coerce.fca.0.1.extract = extractvalue %struct.float16x8x2_t %value.coerce, 0, 1
  call void @llvm.arm.mve.vst2q.p0f16.v8f16(half* %addr, <8 x half> %value.coerce.fca.0.0.extract, <8 x half> %value.coerce.fca.0.1.extract, i32 0)
  call void @llvm.arm.mve.vst2q.p0f16.v8f16(half* %addr, <8 x half> %value.coerce.fca.0.0.extract, <8 x half> %value.coerce.fca.0.1.extract, i32 1)
  %g = getelementptr half, half *%addr, i32 16
  ret half* %g
}

declare void @llvm.arm.mve.vst2q.p0f16.v8f16(half*, <8 x half>, <8 x half>, i32)

define arm_aapcs_vfpcc void @test_vst4q_s8(i8* %addr, %struct.int8x16x4_t %value.coerce) {
; CHECK-LABEL: test_vst4q_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $q3 killed $q3 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    @ kill: def $q2 killed $q2 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    vst40.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vst41.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vst42.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vst43.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    bx lr
entry:
  %value.coerce.fca.0.0.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 0
  %value.coerce.fca.0.1.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 1
  %value.coerce.fca.0.2.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 2
  %value.coerce.fca.0.3.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 3
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 0)
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 1)
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 2)
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 3)
  ret void
}

define arm_aapcs_vfpcc i8* @test_vst4q_s8_post(i8* %addr, %struct.int8x16x4_t %value.coerce) {
; CHECK-LABEL: test_vst4q_s8_post:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $q3 killed $q3 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    @ kill: def $q2 killed $q2 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    @ kill: def $q1 killed $q1 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    @ kill: def $q0 killed $q0 killed $q0_q1_q2_q3 def $q0_q1_q2_q3
; CHECK-NEXT:    vst40.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vst41.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vst42.8 {q0, q1, q2, q3}, [r0]
; CHECK-NEXT:    vst43.8 {q0, q1, q2, q3}, [r0]!
; CHECK-NEXT:    bx lr
entry:
  %value.coerce.fca.0.0.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 0
  %value.coerce.fca.0.1.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 1
  %value.coerce.fca.0.2.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 2
  %value.coerce.fca.0.3.extract = extractvalue %struct.int8x16x4_t %value.coerce, 0, 3
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 0)
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 1)
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 2)
  tail call void @llvm.arm.mve.vst4q.p0i8.v16i8(i8* %addr, <16 x i8> %value.coerce.fca.0.0.extract, <16 x i8> %value.coerce.fca.0.1.extract, <16 x i8> %value.coerce.fca.0.2.extract, <16 x i8> %value.coerce.fca.0.3.extract, i32 3)
  %g = getelementptr i8, i8 *%addr, i32 64
  ret i8* %g
}

declare void @llvm.arm.mve.vst4q.p0i8.v16i8(i8*, <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8>, i32)
