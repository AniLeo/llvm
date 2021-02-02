; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-LE
; RUN: llc -mtriple=thumbebv8.1m.main-none-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK --check-prefix=CHECK-BE

define void @foo_v4i32_v4i32(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i32> *%src) {
; CHECK-LABEL: foo_v4i32_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %src, i32 4, <4 x i1> %1, <4 x i32> undef)
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %2, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_sext_v4i32_v4i8(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i8> *%src) {
; CHECK-LABEL: foo_sext_v4i32_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrbt.s32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i8> @llvm.masked.load.v4i8.p0v4i8(<4 x i8>* %src, i32 1, <4 x i1> %1, <4 x i8> undef)
  %3 = sext <4 x i8> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_sext_v4i32_v4i16(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i16> *%src) {
; CHECK-LABEL: foo_sext_v4i32_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrht.s32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>* %src, i32 2, <4 x i1> %1, <4 x i16> undef)
  %3 = sext <4 x i16> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_zext_v4i32_v4i8(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i8> *%src) {
; CHECK-LABEL: foo_zext_v4i32_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrbt.u32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i8> @llvm.masked.load.v4i8.p0v4i8(<4 x i8>* %src, i32 1, <4 x i1> %1, <4 x i8> undef)
  %3 = zext <4 x i8> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_zext_v4i32_v4i16(<4 x i32> *%dest, <4 x i32> *%mask, <4 x i16> *%src) {
; CHECK-LABEL: foo_zext_v4i32_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrht.u32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>* %src, i32 2, <4 x i1> %1, <4 x i16> undef)
  %3 = zext <4 x i16> %2 to <4 x i32>
  call void @llvm.masked.store.v4i32.p0v4i32(<4 x i32> %3, <4 x i32>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_sext_v2i64_v2i32(<2 x i64> *%dest, <2 x i32> *%mask, <2 x i32> *%src) {
; CHECK-LE-LABEL: foo_sext_v2i64_v2i32:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-LE-NEXT:    push {r4, r5, r7, lr}
; CHECK-LE-NEXT:    .pad #4
; CHECK-LE-NEXT:    sub sp, #4
; CHECK-LE-NEXT:    ldrd lr, r5, [r1]
; CHECK-LE-NEXT:    movs r3, #0
; CHECK-LE-NEXT:    @ implicit-def: $q0
; CHECK-LE-NEXT:    rsbs.w r1, lr, #0
; CHECK-LE-NEXT:    vmov q1[2], q1[0], lr, r5
; CHECK-LE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r4, r5, #0
; CHECK-LE-NEXT:    sbcs.w r4, r3, r5, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r3, #1
; CHECK-LE-NEXT:    cmp r3, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r3, #1
; CHECK-LE-NEXT:    bfi r3, r1, #0, #1
; CHECK-LE-NEXT:    vmov r4, s4
; CHECK-LE-NEXT:    and r12, r3, #3
; CHECK-LE-NEXT:    lsls r1, r3, #31
; CHECK-LE-NEXT:    itt ne
; CHECK-LE-NEXT:    ldrne r1, [r2]
; CHECK-LE-NEXT:    vmovne.32 q0[0], r1
; CHECK-LE-NEXT:    lsls.w r1, r12, #30
; CHECK-LE-NEXT:    itt mi
; CHECK-LE-NEXT:    ldrmi r1, [r2, #4]
; CHECK-LE-NEXT:    vmovmi.32 q0[2], r1
; CHECK-LE-NEXT:    vmov r3, s0
; CHECK-LE-NEXT:    movs r2, #0
; CHECK-LE-NEXT:    vmov r1, s2
; CHECK-LE-NEXT:    vmov q0[2], q0[0], r3, r1
; CHECK-LE-NEXT:    rsbs r5, r4, #0
; CHECK-LE-NEXT:    asr.w lr, r3, #31
; CHECK-LE-NEXT:    vmov r3, s6
; CHECK-LE-NEXT:    asr.w r12, r1, #31
; CHECK-LE-NEXT:    sbcs.w r1, r2, r4, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    vmov q0[3], q0[1], lr, r12
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r5, r3, #0
; CHECK-LE-NEXT:    sbcs.w r3, r2, r3, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r2, #1
; CHECK-LE-NEXT:    cmp r2, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r2, #1
; CHECK-LE-NEXT:    bfi r2, r1, #0, #1
; CHECK-LE-NEXT:    and r1, r2, #3
; CHECK-LE-NEXT:    lsls r2, r2, #31
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    vstrne d0, [r0]
; CHECK-LE-NEXT:    lsls r1, r1, #30
; CHECK-LE-NEXT:    it mi
; CHECK-LE-NEXT:    vstrmi d1, [r0, #8]
; CHECK-LE-NEXT:    add sp, #4
; CHECK-LE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-BE-LABEL: foo_sext_v2i64_v2i32:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-BE-NEXT:    push {r4, r5, r7, lr}
; CHECK-BE-NEXT:    .pad #4
; CHECK-BE-NEXT:    sub sp, #4
; CHECK-BE-NEXT:    ldrd r12, lr, [r1]
; CHECK-BE-NEXT:    rsbs.w r1, lr, #0
; CHECK-BE-NEXT:    mov.w r3, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-BE-NEXT:    vmov q0[3], q0[1], r12, lr
; CHECK-BE-NEXT:    mov.w lr, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt.w lr, #1
; CHECK-BE-NEXT:    rsbs.w r1, r12, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, r12, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r3, #1
; CHECK-BE-NEXT:    cmp r3, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r3, #1
; CHECK-BE-NEXT:    bfi r3, lr, #0, #1
; CHECK-BE-NEXT:    @ implicit-def: $q2
; CHECK-BE-NEXT:    and r1, r3, #3
; CHECK-BE-NEXT:    lsls r3, r3, #31
; CHECK-BE-NEXT:    beq .LBB5_2
; CHECK-BE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-BE-NEXT:    ldr r3, [r2]
; CHECK-BE-NEXT:    vmov.32 q1[1], r3
; CHECK-BE-NEXT:    vrev64.32 q2, q1
; CHECK-BE-NEXT:  .LBB5_2: @ %else
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    bpl .LBB5_4
; CHECK-BE-NEXT:  @ %bb.3: @ %cond.load1
; CHECK-BE-NEXT:    ldr r1, [r2, #4]
; CHECK-BE-NEXT:    vrev64.32 q0, q2
; CHECK-BE-NEXT:    vmov.32 q0[3], r1
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:  .LBB5_4: @ %else2
; CHECK-BE-NEXT:    vrev64.32 q0, q2
; CHECK-BE-NEXT:    vrev64.32 q2, q1
; CHECK-BE-NEXT:    vmov r2, s11
; CHECK-BE-NEXT:    movs r4, #0
; CHECK-BE-NEXT:    vmov r1, s3
; CHECK-BE-NEXT:    vmov r3, s1
; CHECK-BE-NEXT:    rsbs r5, r2, #0
; CHECK-BE-NEXT:    sbcs.w r2, r4, r2, asr #31
; CHECK-BE-NEXT:    vmov r2, s9
; CHECK-BE-NEXT:    asr.w r12, r1, #31
; CHECK-BE-NEXT:    asr.w lr, r3, #31
; CHECK-BE-NEXT:    vmov q1[2], q1[0], lr, r12
; CHECK-BE-NEXT:    vmov q1[3], q1[1], r3, r1
; CHECK-BE-NEXT:    mov.w r1, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r1, #1
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    rsbs r3, r2, #0
; CHECK-BE-NEXT:    sbcs.w r2, r4, r2, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r4, #1
; CHECK-BE-NEXT:    cmp r4, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r4, #1
; CHECK-BE-NEXT:    bfi r4, r1, #0, #1
; CHECK-BE-NEXT:    and r1, r4, #3
; CHECK-BE-NEXT:    lsls r2, r4, #31
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    vstrne d0, [r0]
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    it mi
; CHECK-BE-NEXT:    vstrmi d1, [r0, #8]
; CHECK-BE-NEXT:    add sp, #4
; CHECK-BE-NEXT:    pop {r4, r5, r7, pc}
entry:
  %0 = load <2 x i32>, <2 x i32>* %mask, align 4
  %1 = icmp sgt <2 x i32> %0, zeroinitializer
  %2 = call <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>* %src, i32 4, <2 x i1> %1, <2 x i32> undef)
  %3 = sext <2 x i32> %2 to <2 x i64>
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %3, <2 x i64>* %dest, i32 8, <2 x i1> %1)
  ret void
}

define void @foo_sext_v2i64_v2i32_unaligned(<2 x i64> *%dest, <2 x i32> *%mask, <2 x i32> *%src) {
; CHECK-LE-LABEL: foo_sext_v2i64_v2i32_unaligned:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-LE-NEXT:    push {r4, r5, r7, lr}
; CHECK-LE-NEXT:    .pad #4
; CHECK-LE-NEXT:    sub sp, #4
; CHECK-LE-NEXT:    ldrd lr, r5, [r1]
; CHECK-LE-NEXT:    movs r3, #0
; CHECK-LE-NEXT:    @ implicit-def: $q0
; CHECK-LE-NEXT:    rsbs.w r1, lr, #0
; CHECK-LE-NEXT:    vmov q1[2], q1[0], lr, r5
; CHECK-LE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r4, r5, #0
; CHECK-LE-NEXT:    sbcs.w r4, r3, r5, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r3, #1
; CHECK-LE-NEXT:    cmp r3, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r3, #1
; CHECK-LE-NEXT:    bfi r3, r1, #0, #1
; CHECK-LE-NEXT:    vmov r4, s4
; CHECK-LE-NEXT:    and r12, r3, #3
; CHECK-LE-NEXT:    lsls r1, r3, #31
; CHECK-LE-NEXT:    itt ne
; CHECK-LE-NEXT:    ldrne r1, [r2]
; CHECK-LE-NEXT:    vmovne.32 q0[0], r1
; CHECK-LE-NEXT:    lsls.w r1, r12, #30
; CHECK-LE-NEXT:    itt mi
; CHECK-LE-NEXT:    ldrmi r1, [r2, #4]
; CHECK-LE-NEXT:    vmovmi.32 q0[2], r1
; CHECK-LE-NEXT:    vmov r3, s0
; CHECK-LE-NEXT:    movs r2, #0
; CHECK-LE-NEXT:    vmov r1, s2
; CHECK-LE-NEXT:    vmov q0[2], q0[0], r3, r1
; CHECK-LE-NEXT:    rsbs r5, r4, #0
; CHECK-LE-NEXT:    asr.w lr, r3, #31
; CHECK-LE-NEXT:    vmov r3, s6
; CHECK-LE-NEXT:    asr.w r12, r1, #31
; CHECK-LE-NEXT:    sbcs.w r1, r2, r4, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    vmov q0[3], q0[1], lr, r12
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r5, r3, #0
; CHECK-LE-NEXT:    sbcs.w r3, r2, r3, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r2, #1
; CHECK-LE-NEXT:    cmp r2, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r2, #1
; CHECK-LE-NEXT:    bfi r2, r1, #0, #1
; CHECK-LE-NEXT:    and r1, r2, #3
; CHECK-LE-NEXT:    lsls r2, r2, #31
; CHECK-LE-NEXT:    itt ne
; CHECK-LE-NEXT:    vmovne r2, r3, d0
; CHECK-LE-NEXT:    strdne r2, r3, [r0]
; CHECK-LE-NEXT:    lsls r1, r1, #30
; CHECK-LE-NEXT:    itt mi
; CHECK-LE-NEXT:    vmovmi r1, r2, d1
; CHECK-LE-NEXT:    strdmi r1, r2, [r0, #8]
; CHECK-LE-NEXT:    add sp, #4
; CHECK-LE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-BE-LABEL: foo_sext_v2i64_v2i32_unaligned:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-BE-NEXT:    push {r4, r5, r7, lr}
; CHECK-BE-NEXT:    .pad #4
; CHECK-BE-NEXT:    sub sp, #4
; CHECK-BE-NEXT:    ldrd r12, lr, [r1]
; CHECK-BE-NEXT:    rsbs.w r1, lr, #0
; CHECK-BE-NEXT:    mov.w r3, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-BE-NEXT:    vmov q0[3], q0[1], r12, lr
; CHECK-BE-NEXT:    mov.w lr, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt.w lr, #1
; CHECK-BE-NEXT:    rsbs.w r1, r12, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, r12, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r3, #1
; CHECK-BE-NEXT:    cmp r3, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r3, #1
; CHECK-BE-NEXT:    bfi r3, lr, #0, #1
; CHECK-BE-NEXT:    @ implicit-def: $q2
; CHECK-BE-NEXT:    and r1, r3, #3
; CHECK-BE-NEXT:    lsls r3, r3, #31
; CHECK-BE-NEXT:    beq .LBB6_2
; CHECK-BE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-BE-NEXT:    ldr r3, [r2]
; CHECK-BE-NEXT:    vmov.32 q1[1], r3
; CHECK-BE-NEXT:    vrev64.32 q2, q1
; CHECK-BE-NEXT:  .LBB6_2: @ %else
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    bpl .LBB6_4
; CHECK-BE-NEXT:  @ %bb.3: @ %cond.load1
; CHECK-BE-NEXT:    ldr r1, [r2, #4]
; CHECK-BE-NEXT:    vrev64.32 q0, q2
; CHECK-BE-NEXT:    vmov.32 q0[3], r1
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:  .LBB6_4: @ %else2
; CHECK-BE-NEXT:    vrev64.32 q0, q2
; CHECK-BE-NEXT:    vrev64.32 q2, q1
; CHECK-BE-NEXT:    vmov r2, s11
; CHECK-BE-NEXT:    movs r4, #0
; CHECK-BE-NEXT:    vmov r1, s3
; CHECK-BE-NEXT:    vmov r3, s1
; CHECK-BE-NEXT:    rsbs r5, r2, #0
; CHECK-BE-NEXT:    sbcs.w r2, r4, r2, asr #31
; CHECK-BE-NEXT:    vmov r2, s9
; CHECK-BE-NEXT:    asr.w r12, r1, #31
; CHECK-BE-NEXT:    asr.w lr, r3, #31
; CHECK-BE-NEXT:    vmov q1[2], q1[0], lr, r12
; CHECK-BE-NEXT:    vmov q1[3], q1[1], r3, r1
; CHECK-BE-NEXT:    mov.w r1, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r1, #1
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    rsbs r3, r2, #0
; CHECK-BE-NEXT:    sbcs.w r2, r4, r2, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r4, #1
; CHECK-BE-NEXT:    cmp r4, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r4, #1
; CHECK-BE-NEXT:    bfi r4, r1, #0, #1
; CHECK-BE-NEXT:    and r1, r4, #3
; CHECK-BE-NEXT:    lsls r2, r4, #31
; CHECK-BE-NEXT:    itt ne
; CHECK-BE-NEXT:    vmovne r2, r3, d0
; CHECK-BE-NEXT:    strdne r3, r2, [r0]
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    itt mi
; CHECK-BE-NEXT:    vmovmi r1, r2, d1
; CHECK-BE-NEXT:    strdmi r2, r1, [r0, #8]
; CHECK-BE-NEXT:    add sp, #4
; CHECK-BE-NEXT:    pop {r4, r5, r7, pc}
entry:
  %0 = load <2 x i32>, <2 x i32>* %mask, align 4
  %1 = icmp sgt <2 x i32> %0, zeroinitializer
  %2 = call <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>* %src, i32 2, <2 x i1> %1, <2 x i32> undef)
  %3 = sext <2 x i32> %2 to <2 x i64>
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %3, <2 x i64>* %dest, i32 4, <2 x i1> %1)
  ret void
}

define void @foo_zext_v2i64_v2i32(<2 x i64> *%dest, <2 x i32> *%mask, <2 x i32> *%src) {
; CHECK-LE-LABEL: foo_zext_v2i64_v2i32:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-LE-NEXT:    push {r4, r5, r7, lr}
; CHECK-LE-NEXT:    .pad #4
; CHECK-LE-NEXT:    sub sp, #4
; CHECK-LE-NEXT:    ldrd lr, r5, [r1]
; CHECK-LE-NEXT:    movs r3, #0
; CHECK-LE-NEXT:    @ implicit-def: $q0
; CHECK-LE-NEXT:    vmov.i64 q2, #0xffffffff
; CHECK-LE-NEXT:    rsbs.w r1, lr, #0
; CHECK-LE-NEXT:    vmov q1[2], q1[0], lr, r5
; CHECK-LE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r4, r5, #0
; CHECK-LE-NEXT:    sbcs.w r4, r3, r5, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r3, #1
; CHECK-LE-NEXT:    cmp r3, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r3, #1
; CHECK-LE-NEXT:    bfi r3, r1, #0, #1
; CHECK-LE-NEXT:    and r12, r3, #3
; CHECK-LE-NEXT:    lsls r1, r3, #31
; CHECK-LE-NEXT:    itt ne
; CHECK-LE-NEXT:    ldrne r1, [r2]
; CHECK-LE-NEXT:    vmovne.32 q0[0], r1
; CHECK-LE-NEXT:    lsls.w r1, r12, #30
; CHECK-LE-NEXT:    itt mi
; CHECK-LE-NEXT:    ldrmi r1, [r2, #4]
; CHECK-LE-NEXT:    vmovmi.32 q0[2], r1
; CHECK-LE-NEXT:    vmov r1, s4
; CHECK-LE-NEXT:    movs r2, #0
; CHECK-LE-NEXT:    vand q0, q0, q2
; CHECK-LE-NEXT:    rsbs r3, r1, #0
; CHECK-LE-NEXT:    vmov r3, s6
; CHECK-LE-NEXT:    sbcs.w r1, r2, r1, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r5, r3, #0
; CHECK-LE-NEXT:    sbcs.w r3, r2, r3, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r2, #1
; CHECK-LE-NEXT:    cmp r2, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r2, #1
; CHECK-LE-NEXT:    bfi r2, r1, #0, #1
; CHECK-LE-NEXT:    and r1, r2, #3
; CHECK-LE-NEXT:    lsls r2, r2, #31
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    vstrne d0, [r0]
; CHECK-LE-NEXT:    lsls r1, r1, #30
; CHECK-LE-NEXT:    it mi
; CHECK-LE-NEXT:    vstrmi d1, [r0, #8]
; CHECK-LE-NEXT:    add sp, #4
; CHECK-LE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-BE-LABEL: foo_zext_v2i64_v2i32:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    .pad #4
; CHECK-BE-NEXT:    sub sp, #4
; CHECK-BE-NEXT:    ldrd r12, lr, [r1]
; CHECK-BE-NEXT:    rsbs.w r1, lr, #0
; CHECK-BE-NEXT:    mov.w r3, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-BE-NEXT:    vmov q0[3], q0[1], r12, lr
; CHECK-BE-NEXT:    mov.w lr, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt.w lr, #1
; CHECK-BE-NEXT:    rsbs.w r1, r12, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, r12, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r3, #1
; CHECK-BE-NEXT:    cmp r3, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r3, #1
; CHECK-BE-NEXT:    bfi r3, lr, #0, #1
; CHECK-BE-NEXT:    @ implicit-def: $q1
; CHECK-BE-NEXT:    and r1, r3, #3
; CHECK-BE-NEXT:    lsls r3, r3, #31
; CHECK-BE-NEXT:    beq .LBB7_2
; CHECK-BE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-BE-NEXT:    ldr r3, [r2]
; CHECK-BE-NEXT:    vmov.32 q2[1], r3
; CHECK-BE-NEXT:    vrev64.32 q1, q2
; CHECK-BE-NEXT:  .LBB7_2: @ %else
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    bpl .LBB7_4
; CHECK-BE-NEXT:  @ %bb.3: @ %cond.load1
; CHECK-BE-NEXT:    ldr r1, [r2, #4]
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    vmov.32 q0[3], r1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:  .LBB7_4: @ %else2
; CHECK-BE-NEXT:    vrev64.32 q3, q2
; CHECK-BE-NEXT:    movs r2, #0
; CHECK-BE-NEXT:    vmov r1, s15
; CHECK-BE-NEXT:    mov.w r12, #0
; CHECK-BE-NEXT:    vmov.i64 q0, #0xffffffff
; CHECK-BE-NEXT:    vand q0, q1, q0
; CHECK-BE-NEXT:    rsbs r3, r1, #0
; CHECK-BE-NEXT:    vmov r3, s13
; CHECK-BE-NEXT:    sbcs.w r1, r2, r1, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt.w r12, #1
; CHECK-BE-NEXT:    rsbs r1, r3, #0
; CHECK-BE-NEXT:    sbcs.w r1, r2, r3, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r2, #1
; CHECK-BE-NEXT:    cmp r2, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r2, #1
; CHECK-BE-NEXT:    bfi r2, r12, #0, #1
; CHECK-BE-NEXT:    and r1, r2, #3
; CHECK-BE-NEXT:    lsls r2, r2, #31
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    vstrne d0, [r0]
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    it mi
; CHECK-BE-NEXT:    vstrmi d1, [r0, #8]
; CHECK-BE-NEXT:    add sp, #4
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %0 = load <2 x i32>, <2 x i32>* %mask, align 4
  %1 = icmp sgt <2 x i32> %0, zeroinitializer
  %2 = call <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>* %src, i32 4, <2 x i1> %1, <2 x i32> undef)
  %3 = zext <2 x i32> %2 to <2 x i64>
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %3, <2 x i64>* %dest, i32 8, <2 x i1> %1)
  ret void
}

define void @foo_zext_v2i64_v2i32_unaligned(<2 x i64> *%dest, <2 x i32> *%mask, <2 x i32> *%src) {
; CHECK-LE-LABEL: foo_zext_v2i64_v2i32_unaligned:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r4, r5, r7, lr}
; CHECK-LE-NEXT:    push {r4, r5, r7, lr}
; CHECK-LE-NEXT:    .pad #4
; CHECK-LE-NEXT:    sub sp, #4
; CHECK-LE-NEXT:    ldrd lr, r5, [r1]
; CHECK-LE-NEXT:    movs r3, #0
; CHECK-LE-NEXT:    @ implicit-def: $q0
; CHECK-LE-NEXT:    vmov.i64 q2, #0xffffffff
; CHECK-LE-NEXT:    rsbs.w r1, lr, #0
; CHECK-LE-NEXT:    vmov q1[2], q1[0], lr, r5
; CHECK-LE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r4, r5, #0
; CHECK-LE-NEXT:    sbcs.w r4, r3, r5, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r3, #1
; CHECK-LE-NEXT:    cmp r3, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r3, #1
; CHECK-LE-NEXT:    bfi r3, r1, #0, #1
; CHECK-LE-NEXT:    and r12, r3, #3
; CHECK-LE-NEXT:    lsls r1, r3, #31
; CHECK-LE-NEXT:    itt ne
; CHECK-LE-NEXT:    ldrne r1, [r2]
; CHECK-LE-NEXT:    vmovne.32 q0[0], r1
; CHECK-LE-NEXT:    lsls.w r1, r12, #30
; CHECK-LE-NEXT:    itt mi
; CHECK-LE-NEXT:    ldrmi r1, [r2, #4]
; CHECK-LE-NEXT:    vmovmi.32 q0[2], r1
; CHECK-LE-NEXT:    vmov r1, s4
; CHECK-LE-NEXT:    movs r2, #0
; CHECK-LE-NEXT:    vand q0, q0, q2
; CHECK-LE-NEXT:    rsbs r3, r1, #0
; CHECK-LE-NEXT:    vmov r3, s6
; CHECK-LE-NEXT:    sbcs.w r1, r2, r1, asr #31
; CHECK-LE-NEXT:    mov.w r1, #0
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r1, #1
; CHECK-LE-NEXT:    rsbs r5, r3, #0
; CHECK-LE-NEXT:    sbcs.w r3, r2, r3, asr #31
; CHECK-LE-NEXT:    it lt
; CHECK-LE-NEXT:    movlt r2, #1
; CHECK-LE-NEXT:    cmp r2, #0
; CHECK-LE-NEXT:    it ne
; CHECK-LE-NEXT:    mvnne r2, #1
; CHECK-LE-NEXT:    bfi r2, r1, #0, #1
; CHECK-LE-NEXT:    and r1, r2, #3
; CHECK-LE-NEXT:    lsls r2, r2, #31
; CHECK-LE-NEXT:    itt ne
; CHECK-LE-NEXT:    vmovne r2, r3, d0
; CHECK-LE-NEXT:    strdne r2, r3, [r0]
; CHECK-LE-NEXT:    lsls r1, r1, #30
; CHECK-LE-NEXT:    itt mi
; CHECK-LE-NEXT:    vmovmi r1, r2, d1
; CHECK-LE-NEXT:    strdmi r1, r2, [r0, #8]
; CHECK-LE-NEXT:    add sp, #4
; CHECK-LE-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-BE-LABEL: foo_zext_v2i64_v2i32_unaligned:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    .pad #4
; CHECK-BE-NEXT:    sub sp, #4
; CHECK-BE-NEXT:    ldrd r12, lr, [r1]
; CHECK-BE-NEXT:    rsbs.w r1, lr, #0
; CHECK-BE-NEXT:    mov.w r3, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, lr, asr #31
; CHECK-BE-NEXT:    vmov q0[3], q0[1], r12, lr
; CHECK-BE-NEXT:    mov.w lr, #0
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt.w lr, #1
; CHECK-BE-NEXT:    rsbs.w r1, r12, #0
; CHECK-BE-NEXT:    sbcs.w r1, r3, r12, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r3, #1
; CHECK-BE-NEXT:    cmp r3, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r3, #1
; CHECK-BE-NEXT:    bfi r3, lr, #0, #1
; CHECK-BE-NEXT:    @ implicit-def: $q1
; CHECK-BE-NEXT:    and r1, r3, #3
; CHECK-BE-NEXT:    lsls r3, r3, #31
; CHECK-BE-NEXT:    beq .LBB8_2
; CHECK-BE-NEXT:  @ %bb.1: @ %cond.load
; CHECK-BE-NEXT:    ldr r3, [r2]
; CHECK-BE-NEXT:    vmov.32 q2[1], r3
; CHECK-BE-NEXT:    vrev64.32 q1, q2
; CHECK-BE-NEXT:  .LBB8_2: @ %else
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    bpl .LBB8_4
; CHECK-BE-NEXT:  @ %bb.3: @ %cond.load1
; CHECK-BE-NEXT:    ldr r1, [r2, #4]
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    vmov.32 q0[3], r1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:  .LBB8_4: @ %else2
; CHECK-BE-NEXT:    vrev64.32 q3, q2
; CHECK-BE-NEXT:    movs r2, #0
; CHECK-BE-NEXT:    vmov r1, s15
; CHECK-BE-NEXT:    mov.w r12, #0
; CHECK-BE-NEXT:    vmov.i64 q0, #0xffffffff
; CHECK-BE-NEXT:    vand q0, q1, q0
; CHECK-BE-NEXT:    rsbs r3, r1, #0
; CHECK-BE-NEXT:    vmov r3, s13
; CHECK-BE-NEXT:    sbcs.w r1, r2, r1, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt.w r12, #1
; CHECK-BE-NEXT:    rsbs r1, r3, #0
; CHECK-BE-NEXT:    sbcs.w r1, r2, r3, asr #31
; CHECK-BE-NEXT:    it lt
; CHECK-BE-NEXT:    movlt r2, #1
; CHECK-BE-NEXT:    cmp r2, #0
; CHECK-BE-NEXT:    it ne
; CHECK-BE-NEXT:    mvnne r2, #1
; CHECK-BE-NEXT:    bfi r2, r12, #0, #1
; CHECK-BE-NEXT:    and r1, r2, #3
; CHECK-BE-NEXT:    lsls r2, r2, #31
; CHECK-BE-NEXT:    itt ne
; CHECK-BE-NEXT:    vmovne r2, r3, d0
; CHECK-BE-NEXT:    strdne r3, r2, [r0]
; CHECK-BE-NEXT:    lsls r1, r1, #30
; CHECK-BE-NEXT:    itt mi
; CHECK-BE-NEXT:    vmovmi r1, r2, d1
; CHECK-BE-NEXT:    strdmi r2, r1, [r0, #8]
; CHECK-BE-NEXT:    add sp, #4
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %0 = load <2 x i32>, <2 x i32>* %mask, align 4
  %1 = icmp sgt <2 x i32> %0, zeroinitializer
  %2 = call <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>* %src, i32 2, <2 x i1> %1, <2 x i32> undef)
  %3 = zext <2 x i32> %2 to <2 x i64>
  call void @llvm.masked.store.v2i64.p0v2i64(<2 x i64> %3, <2 x i64>* %dest, i32 4, <2 x i1> %1)
  ret void
}

define void @foo_v8i16_v8i16(<8 x i16> *%dest, <8 x i16> *%mask, <8 x i16> *%src) {
; CHECK-LABEL: foo_v8i16_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vptt.s16 gt, q0, zr
; CHECK-NEXT:    vldrht.u16 q0, [r2]
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %src, i32 2, <8 x i1> %1, <8 x i16> undef)
  call void @llvm.masked.store.v8i16.p0v8i16(<8 x i16> %2, <8 x i16>* %dest, i32 2, <8 x i1> %1)
  ret void
}

define void @foo_sext_v8i16_v8i8(<8 x i16> *%dest, <8 x i16> *%mask, <8 x i8> *%src) {
; CHECK-LABEL: foo_sext_v8i16_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vptt.s16 gt, q0, zr
; CHECK-NEXT:    vldrbt.s16 q0, [r2]
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i8> @llvm.masked.load.v8i8.p0v8i8(<8 x i8>* %src, i32 1, <8 x i1> %1, <8 x i8> undef)
  %3 = sext <8 x i8> %2 to <8 x i16>
  call void @llvm.masked.store.v8i16.p0v8i16(<8 x i16> %3, <8 x i16>* %dest, i32 2, <8 x i1> %1)
  ret void
}

define void @foo_zext_v8i16_v8i8(<8 x i16> *%dest, <8 x i16> *%mask, <8 x i8> *%src) {
; CHECK-LABEL: foo_zext_v8i16_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vptt.s16 gt, q0, zr
; CHECK-NEXT:    vldrbt.u16 q0, [r2]
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i8> @llvm.masked.load.v8i8.p0v8i8(<8 x i8>* %src, i32 1, <8 x i1> %1, <8 x i8> undef)
  %3 = zext <8 x i8> %2 to <8 x i16>
  call void @llvm.masked.store.v8i16.p0v8i16(<8 x i16> %3, <8 x i16>* %dest, i32 2, <8 x i1> %1)
  ret void
}

define void @foo_v16i8_v16i8(<16 x i8> *%dest, <16 x i8> *%mask, <16 x i8> *%src) {
; CHECK-LABEL: foo_v16i8_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r1]
; CHECK-NEXT:    vptt.s8 gt, q0, zr
; CHECK-NEXT:    vldrbt.u8 q0, [r2]
; CHECK-NEXT:    vstrbt.8 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <16 x i8>, <16 x i8>* %mask, align 1
  %1 = icmp sgt <16 x i8> %0, zeroinitializer
  %2 = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* %src, i32 1, <16 x i1> %1, <16 x i8> undef)
  call void @llvm.masked.store.v16i8.p0v16i8(<16 x i8> %2, <16 x i8>* %dest, i32 1, <16 x i1> %1)
  ret void
}

define void @foo_trunc_v8i8_v8i16(<8 x i8> *%dest, <8 x i16> *%mask, <8 x i16> *%src) {
; CHECK-LABEL: foo_trunc_v8i8_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vptt.s16 gt, q0, zr
; CHECK-NEXT:    vldrht.u16 q0, [r2]
; CHECK-NEXT:    vstrbt.16 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>* %src, i32 2, <8 x i1> %1, <8 x i16> undef)
  %3 = trunc <8 x i16> %2 to <8 x i8>
  call void @llvm.masked.store.v8i8.p0v8i8(<8 x i8> %3, <8 x i8>* %dest, i32 1, <8 x i1> %1)
  ret void
}

define void @foo_trunc_v4i8_v4i32(<4 x i8> *%dest, <4 x i32> *%mask, <4 x i32> *%src) {
; CHECK-LABEL: foo_trunc_v4i8_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    vstrbt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %src, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = trunc <4 x i32> %2 to <4 x i8>
  call void @llvm.masked.store.v4i8.p0v4i8(<4 x i8> %3, <4 x i8>* %dest, i32 1, <4 x i1> %1)
  ret void
}

define void @foo_trunc_v4i16_v4i32(<4 x i16> *%dest, <4 x i32> *%mask, <4 x i32> *%src) {
; CHECK-LABEL: foo_trunc_v4i16_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    vstrht.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %src, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = trunc <4 x i32> %2 to <4 x i16>
  call void @llvm.masked.store.v4i16.p0v4i16(<4 x i16> %3, <4 x i16>* %dest, i32 2, <4 x i1> %1)
  ret void
}

define void @foo_v4f32_v4f32(<4 x float> *%dest, <4 x i32> *%mask, <4 x float> *%src) {
; CHECK-LABEL: foo_v4f32_v4f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vptt.s32 gt, q0, zr
; CHECK-NEXT:    vldrwt.u32 q0, [r2]
; CHECK-NEXT:    vstrwt.32 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <4 x i32>, <4 x i32>* %mask, align 4
  %1 = icmp sgt <4 x i32> %0, zeroinitializer
  %2 = call <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %src, i32 4, <4 x i1> %1, <4 x float> undef)
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %2, <4 x float>* %dest, i32 4, <4 x i1> %1)
  ret void
}

define void @foo_v8f16_v8f16(<8 x half> *%dest, <8 x i16> *%mask, <8 x half> *%src) {
; CHECK-LABEL: foo_v8f16_v8f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vptt.s16 gt, q0, zr
; CHECK-NEXT:    vldrht.u16 q0, [r2]
; CHECK-NEXT:    vstrht.16 q0, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load <8 x i16>, <8 x i16>* %mask, align 2
  %1 = icmp sgt <8 x i16> %0, zeroinitializer
  %2 = call <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>* %src, i32 2, <8 x i1> %1, <8 x half> undef)
  call void @llvm.masked.store.v8f16.p0v8f16(<8 x half> %2, <8 x half>* %dest, i32 2, <8 x i1> %1)
  ret void
}

define void @foo_v4f32_v4f16(<4 x float> *%dest, <4 x i16> *%mask, <4 x half> *%src) {
; CHECK-LABEL: foo_v4f32_v4f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    vldrh.s32 q0, [r1]
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vmrs lr, p0
; CHECK-NEXT:    and r1, lr, #1
; CHECK-NEXT:    ubfx r3, lr, #4, #1
; CHECK-NEXT:    rsb.w r12, r1, #0
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r12, #0, #1
; CHECK-NEXT:    bfi r1, r3, #1, #1
; CHECK-NEXT:    ubfx r3, lr, #8, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #2, #1
; CHECK-NEXT:    ubfx r3, lr, #12, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #3, #1
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    bne .LBB18_6
; CHECK-NEXT:  @ %bb.1: @ %else
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    bmi .LBB18_7
; CHECK-NEXT:  .LBB18_2: @ %else2
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    bmi .LBB18_8
; CHECK-NEXT:  .LBB18_3: @ %else5
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    bpl .LBB18_5
; CHECK-NEXT:  .LBB18_4: @ %cond.load7
; CHECK-NEXT:    vmovx.f16 s4, s0
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vldr.16 s4, [r2, #6]
; CHECK-NEXT:    vins.f16 s1, s4
; CHECK-NEXT:  .LBB18_5: @ %else8
; CHECK-NEXT:    vmrs r2, p0
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vcvtt.f32.f16 s7, s1
; CHECK-NEXT:    vcvtb.f32.f16 s6, s1
; CHECK-NEXT:    vcvtt.f32.f16 s5, s0
; CHECK-NEXT:    vcvtb.f32.f16 s4, s0
; CHECK-NEXT:    and r3, r2, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #0, #1
; CHECK-NEXT:    ubfx r3, r2, #4, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #1, #1
; CHECK-NEXT:    ubfx r3, r2, #8, #1
; CHECK-NEXT:    ubfx r2, r2, #12, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #2, #1
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    bfi r1, r2, #3, #1
; CHECK-NEXT:    lsls r2, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    vmovne r2, s4
; CHECK-NEXT:    strne r2, [r0]
; CHECK-NEXT:    lsls r2, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s5
; CHECK-NEXT:    strmi r2, [r0, #4]
; CHECK-NEXT:    lsls r2, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s6
; CHECK-NEXT:    strmi r2, [r0, #8]
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r1, s7
; CHECK-NEXT:    strmi r1, [r0, #12]
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    pop {r7, pc}
; CHECK-NEXT:  .LBB18_6: @ %cond.load
; CHECK-NEXT:    vldr.16 s0, [r2]
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    bpl .LBB18_2
; CHECK-NEXT:  .LBB18_7: @ %cond.load1
; CHECK-NEXT:    vldr.16 s4, [r2, #2]
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vmovx.f16 s4, s1
; CHECK-NEXT:    vins.f16 s1, s4
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    bpl .LBB18_3
; CHECK-NEXT:  .LBB18_8: @ %cond.load4
; CHECK-NEXT:    vmovx.f16 s4, s0
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vmovx.f16 s4, s1
; CHECK-NEXT:    vldr.16 s1, [r2, #4]
; CHECK-NEXT:    vins.f16 s1, s4
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    bmi .LBB18_4
; CHECK-NEXT:    b .LBB18_5
entry:
  %0 = load <4 x i16>, <4 x i16>* %mask, align 2
  %1 = icmp sgt <4 x i16> %0, zeroinitializer
  %2 = call <4 x half> @llvm.masked.load.v4f16.p0v4f16(<4 x half>* %src, i32 2, <4 x i1> %1, <4 x half> undef)
  %3 = fpext <4 x half> %2 to <4 x float>
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %3, <4 x float>* %dest, i32 2, <4 x i1> %1)
  ret void
}

define void @foo_v4f32_v4f16_unaligned(<4 x float> *%dest, <4 x i16> *%mask, <4 x half> *%src) {
; CHECK-LABEL: foo_v4f32_v4f16_unaligned:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    vldrh.s32 q0, [r1]
; CHECK-NEXT:    vcmp.s32 gt, q0, zr
; CHECK-NEXT:    @ implicit-def: $q0
; CHECK-NEXT:    vmrs lr, p0
; CHECK-NEXT:    and r1, lr, #1
; CHECK-NEXT:    ubfx r3, lr, #4, #1
; CHECK-NEXT:    rsb.w r12, r1, #0
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r12, #0, #1
; CHECK-NEXT:    bfi r1, r3, #1, #1
; CHECK-NEXT:    ubfx r3, lr, #8, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #2, #1
; CHECK-NEXT:    ubfx r3, lr, #12, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #3, #1
; CHECK-NEXT:    lsls r3, r1, #31
; CHECK-NEXT:    bne .LBB19_6
; CHECK-NEXT:  @ %bb.1: @ %else
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    bmi .LBB19_7
; CHECK-NEXT:  .LBB19_2: @ %else2
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    bmi .LBB19_8
; CHECK-NEXT:  .LBB19_3: @ %else5
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    bpl .LBB19_5
; CHECK-NEXT:  .LBB19_4: @ %cond.load7
; CHECK-NEXT:    vmovx.f16 s4, s0
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vldr.16 s4, [r2, #6]
; CHECK-NEXT:    vins.f16 s1, s4
; CHECK-NEXT:  .LBB19_5: @ %else8
; CHECK-NEXT:    vmrs r2, p0
; CHECK-NEXT:    movs r1, #0
; CHECK-NEXT:    vcvtt.f32.f16 s7, s1
; CHECK-NEXT:    vcvtb.f32.f16 s6, s1
; CHECK-NEXT:    vcvtt.f32.f16 s5, s0
; CHECK-NEXT:    vcvtb.f32.f16 s4, s0
; CHECK-NEXT:    and r3, r2, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #0, #1
; CHECK-NEXT:    ubfx r3, r2, #4, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #1, #1
; CHECK-NEXT:    ubfx r3, r2, #8, #1
; CHECK-NEXT:    ubfx r2, r2, #12, #1
; CHECK-NEXT:    rsbs r3, r3, #0
; CHECK-NEXT:    bfi r1, r3, #2, #1
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    bfi r1, r2, #3, #1
; CHECK-NEXT:    lsls r2, r1, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    vmovne r2, s4
; CHECK-NEXT:    strne r2, [r0]
; CHECK-NEXT:    lsls r2, r1, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s5
; CHECK-NEXT:    strmi r2, [r0, #4]
; CHECK-NEXT:    lsls r2, r1, #29
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r2, s6
; CHECK-NEXT:    strmi r2, [r0, #8]
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r1, s7
; CHECK-NEXT:    strmi r1, [r0, #12]
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    pop {r7, pc}
; CHECK-NEXT:  .LBB19_6: @ %cond.load
; CHECK-NEXT:    vldr.16 s0, [r2]
; CHECK-NEXT:    lsls r3, r1, #30
; CHECK-NEXT:    bpl .LBB19_2
; CHECK-NEXT:  .LBB19_7: @ %cond.load1
; CHECK-NEXT:    vldr.16 s4, [r2, #2]
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vmovx.f16 s4, s1
; CHECK-NEXT:    vins.f16 s1, s4
; CHECK-NEXT:    lsls r3, r1, #29
; CHECK-NEXT:    bpl .LBB19_3
; CHECK-NEXT:  .LBB19_8: @ %cond.load4
; CHECK-NEXT:    vmovx.f16 s4, s0
; CHECK-NEXT:    vins.f16 s0, s4
; CHECK-NEXT:    vmovx.f16 s4, s1
; CHECK-NEXT:    vldr.16 s1, [r2, #4]
; CHECK-NEXT:    vins.f16 s1, s4
; CHECK-NEXT:    lsls r1, r1, #28
; CHECK-NEXT:    bmi .LBB19_4
; CHECK-NEXT:    b .LBB19_5
entry:
  %0 = load <4 x i16>, <4 x i16>* %mask, align 2
  %1 = icmp sgt <4 x i16> %0, zeroinitializer
  %2 = call <4 x half> @llvm.masked.load.v4f16.p0v4f16(<4 x half>* %src, i32 2, <4 x i1> %1, <4 x half> undef)
  %3 = fpext <4 x half> %2 to <4 x float>
  call void @llvm.masked.store.v4f32.p0v4f32(<4 x float> %3, <4 x float>* %dest, i32 1, <4 x i1> %1)
  ret void
}

declare void @llvm.masked.store.v4i32.p0v4i32(<4 x i32>, <4 x i32>*, i32, <4 x i1>)
declare void @llvm.masked.store.v8i16.p0v8i16(<8 x i16>, <8 x i16>*, i32, <8 x i1>)
declare void @llvm.masked.store.v16i8.p0v16i8(<16 x i8>, <16 x i8>*, i32, <16 x i1>)
declare void @llvm.masked.store.v8f16.p0v8f16(<8 x half>, <8 x half>*, i32, <8 x i1>)
declare void @llvm.masked.store.v4f32.p0v4f32(<4 x float>, <4 x float>*, i32, <4 x i1>)
declare <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>*, i32, <16 x i1>, <16 x i8>)
declare <8 x i16> @llvm.masked.load.v8i16.p0v8i16(<8 x i16>*, i32, <8 x i1>, <8 x i16>)
declare <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>*, i32, <2 x i1>, <2 x i32>)
declare <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>*, i32, <4 x i1>, <4 x i32>)
declare <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>*, i32, <4 x i1>, <4 x float>)
declare <4 x half> @llvm.masked.load.v4f16.p0v4f16(<4 x half>*, i32, <4 x i1>, <4 x half>)
declare <8 x half> @llvm.masked.load.v8f16.p0v8f16(<8 x half>*, i32, <8 x i1>, <8 x half>)

declare void @llvm.masked.store.v8i8.p0v8i8(<8 x i8>, <8 x i8>*, i32, <8 x i1>)
declare void @llvm.masked.store.v4i8.p0v4i8(<4 x i8>, <4 x i8>*, i32, <4 x i1>)
declare void @llvm.masked.store.v4i16.p0v4i16(<4 x i16>, <4 x i16>*, i32, <4 x i1>)
declare void @llvm.masked.store.v2i64.p0v2i64(<2 x i64>, <2 x i64>*, i32, <2 x i1>)
declare <4 x i16> @llvm.masked.load.v4i16.p0v4i16(<4 x i16>*, i32, <4 x i1>, <4 x i16>)
declare <4 x i8> @llvm.masked.load.v4i8.p0v4i8(<4 x i8>*, i32, <4 x i1>, <4 x i8>)
declare <8 x i8> @llvm.masked.load.v8i8.p0v8i8(<8 x i8>*, i32, <8 x i1>, <8 x i8>)
