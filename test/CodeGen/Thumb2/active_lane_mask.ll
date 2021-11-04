; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve %s -o - | FileCheck %s

define <4 x i32> @v4i32(i32 %index, i32 %TC, <4 x i32> %V1, <4 x i32> %V2) {
; CHECK-LABEL: v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    adr.w r12, .LCPI0_0
; CHECK-NEXT:    vdup.32 q1, r0
; CHECK-NEXT:    vldrw.u32 q0, [r12]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    add r0, sp, #8
; CHECK-NEXT:    vcmp.u32 hi, q1, q0
; CHECK-NEXT:    vdup.32 q1, r1
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmpt.u32 hi, q1, q0
; CHECK-NEXT:    vldr d1, [sp]
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vmov d0, r2, r3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI0_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %TC)
  %select = select <4 x i1> %active.lane.mask, <4 x i32> %V1, <4 x i32> %V2
  ret <4 x i32> %select
}

define <7 x i32> @v7i32(i32 %index, i32 %TC, <7 x i32> %V1, <7 x i32> %V2) {
; CHECK-LABEL: v7i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    adr r3, .LCPI1_0
; CHECK-NEXT:    vdup.32 q1, r1
; CHECK-NEXT:    vldrw.u32 q0, [r3]
; CHECK-NEXT:    ldr r3, [sp, #32]
; CHECK-NEXT:    vadd.i32 q2, q0, r1
; CHECK-NEXT:    vdup.32 q0, r2
; CHECK-NEXT:    vcmp.u32 hi, q1, q2
; CHECK-NEXT:    ldr r2, [sp, #40]
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmpt.u32 hi, q0, q2
; CHECK-NEXT:    vmov q2[2], q2[0], r3, r2
; CHECK-NEXT:    ldr r2, [sp, #44]
; CHECK-NEXT:    ldr r3, [sp, #36]
; CHECK-NEXT:    vmov q2[3], q2[1], r3, r2
; CHECK-NEXT:    ldr r2, [sp, #8]
; CHECK-NEXT:    ldr r3, [sp]
; CHECK-NEXT:    vmov q3[2], q3[0], r3, r2
; CHECK-NEXT:    ldr r2, [sp, #12]
; CHECK-NEXT:    ldr r3, [sp, #4]
; CHECK-NEXT:    vmov q3[3], q3[1], r3, r2
; CHECK-NEXT:    adr r2, .LCPI1_1
; CHECK-NEXT:    vpsel q2, q3, q2
; CHECK-NEXT:    vstrw.32 q2, [r0]
; CHECK-NEXT:    vldrw.u32 q2, [r2]
; CHECK-NEXT:    movw r2, #4095
; CHECK-NEXT:    vadd.i32 q2, q2, r1
; CHECK-NEXT:    vcmp.u32 hi, q1, q2
; CHECK-NEXT:    vmrs r1, p0
; CHECK-NEXT:    eors r1, r2
; CHECK-NEXT:    ldr r2, [sp, #48]
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    ldr r1, [sp, #52]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmpt.u32 hi, q0, q2
; CHECK-NEXT:    vmov.32 q0[1], r1
; CHECK-NEXT:    ldr r1, [sp, #56]
; CHECK-NEXT:    vmov q0[2], q0[0], r2, r1
; CHECK-NEXT:    ldr r1, [sp, #20]
; CHECK-NEXT:    ldr r2, [sp, #16]
; CHECK-NEXT:    vmov.32 q1[1], r1
; CHECK-NEXT:    ldr r1, [sp, #24]
; CHECK-NEXT:    vmov q1[2], q1[0], r2, r1
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov.f32 s2, s1
; CHECK-NEXT:    vmov r3, s0
; CHECK-NEXT:    vmov r2, s2
; CHECK-NEXT:    strd r3, r2, [r0, #16]
; CHECK-NEXT:    str r1, [r0, #24]
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI1_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:  .LCPI1_1:
; CHECK-NEXT:    .long 4 @ 0x4
; CHECK-NEXT:    .long 5 @ 0x5
; CHECK-NEXT:    .long 6 @ 0x6
; CHECK-NEXT:    .zero 4
  %active.lane.mask = call <7 x i1> @llvm.get.active.lane.mask.v7i1.i32(i32 %index, i32 %TC)
  %select = select <7 x i1> %active.lane.mask, <7 x i32> %V1, <7 x i32> %V2
  ret <7 x i32> %select
}

define <8 x i16> @v8i16(i32 %index, i32 %TC, <8 x i16> %V1, <8 x i16> %V2) {
; CHECK-LABEL: v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vpush {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    adr.w r12, .LCPI2_0
; CHECK-NEXT:    vdup.32 q5, r1
; CHECK-NEXT:    vldrw.u32 q0, [r12]
; CHECK-NEXT:    vmov.i8 q1, #0x0
; CHECK-NEXT:    vmov.i8 q2, #0xff
; CHECK-NEXT:    vadd.i32 q3, q0, r0
; CHECK-NEXT:    vcmp.u32 hi, q5, q3
; CHECK-NEXT:    vpsel q4, q2, q1
; CHECK-NEXT:    vmov r1, r12, d8
; CHECK-NEXT:    vmov.16 q0[0], r1
; CHECK-NEXT:    vmov.16 q0[1], r12
; CHECK-NEXT:    vmov r1, r12, d9
; CHECK-NEXT:    vmov.16 q0[2], r1
; CHECK-NEXT:    adr r1, .LCPI2_1
; CHECK-NEXT:    vldrw.u32 q4, [r1]
; CHECK-NEXT:    vmov.16 q0[3], r12
; CHECK-NEXT:    vadd.i32 q4, q4, r0
; CHECK-NEXT:    vcmp.u32 hi, q5, q4
; CHECK-NEXT:    vpsel q5, q2, q1
; CHECK-NEXT:    vmov r1, r12, d10
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r12
; CHECK-NEXT:    vmov r1, r12, d11
; CHECK-NEXT:    vdup.32 q5, r0
; CHECK-NEXT:    vmov.16 q0[6], r1
; CHECK-NEXT:    vcmp.u32 hi, q5, q3
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    vpsel q6, q2, q1
; CHECK-NEXT:    vcmp.u32 hi, q5, q4
; CHECK-NEXT:    vmov r0, r1, d12
; CHECK-NEXT:    vpsel q1, q2, q1
; CHECK-NEXT:    vmov.16 q3[0], r0
; CHECK-NEXT:    vmov.16 q3[1], r1
; CHECK-NEXT:    vmov r0, r1, d13
; CHECK-NEXT:    vmov.16 q3[2], r0
; CHECK-NEXT:    vmov.16 q3[3], r1
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov.16 q3[4], r0
; CHECK-NEXT:    vmov.16 q3[5], r1
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov.16 q3[6], r0
; CHECK-NEXT:    add r0, sp, #56
; CHECK-NEXT:    vmov.16 q3[7], r1
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vcmp.i16 ne, q3, zr
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmpt.i16 ne, q0, zr
; CHECK-NEXT:    vldr d1, [sp, #48]
; CHECK-NEXT:    vmov d0, r2, r3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    vpop {d8, d9, d10, d11, d12, d13}
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI2_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:  .LCPI2_1:
; CHECK-NEXT:    .long 4 @ 0x4
; CHECK-NEXT:    .long 5 @ 0x5
; CHECK-NEXT:    .long 6 @ 0x6
; CHECK-NEXT:    .long 7 @ 0x7
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 %index, i32 %TC)
  %select = select <8 x i1> %active.lane.mask, <8 x i16> %V1, <8 x i16> %V2
  ret <8 x i16> %select
}

define <16 x i8> @v16i8(i32 %index, i32 %TC, <16 x i8> %V1, <16 x i8> %V2) {
; CHECK-LABEL: v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vpush {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    sub sp, #16
; CHECK-NEXT:    adr.w r12, .LCPI3_0
; CHECK-NEXT:    vdup.32 q7, r1
; CHECK-NEXT:    vldrw.u32 q0, [r12]
; CHECK-NEXT:    vmov.i8 q5, #0x0
; CHECK-NEXT:    vmov.i8 q4, #0xff
; CHECK-NEXT:    vadd.i32 q1, q0, r0
; CHECK-NEXT:    vcmp.u32 hi, q7, q1
; CHECK-NEXT:    vpsel q0, q4, q5
; CHECK-NEXT:    vmov r1, r12, d0
; CHECK-NEXT:    vmov.16 q2[0], r1
; CHECK-NEXT:    vmov.16 q2[1], r12
; CHECK-NEXT:    vmov r1, r12, d1
; CHECK-NEXT:    vmov.16 q2[2], r1
; CHECK-NEXT:    adr r1, .LCPI3_1
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vmov.16 q2[3], r12
; CHECK-NEXT:    vadd.i32 q3, q0, r0
; CHECK-NEXT:    vcmp.u32 hi, q7, q3
; CHECK-NEXT:    vpsel q0, q4, q5
; CHECK-NEXT:    vmov r1, r12, d0
; CHECK-NEXT:    vmov.16 q2[4], r1
; CHECK-NEXT:    vmov.16 q2[5], r12
; CHECK-NEXT:    vmov r1, r12, d1
; CHECK-NEXT:    vmov.16 q2[6], r1
; CHECK-NEXT:    vmov.16 q2[7], r12
; CHECK-NEXT:    vcmp.i16 ne, q2, zr
; CHECK-NEXT:    vpsel q0, q4, q5
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vmov.8 q2[0], r1
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    vmov.8 q2[1], r1
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    vmov.8 q2[2], r1
; CHECK-NEXT:    vmov.u16 r1, q0[3]
; CHECK-NEXT:    vmov.8 q2[3], r1
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    vmov.8 q2[4], r1
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    vmov.8 q2[5], r1
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    vmov.8 q2[6], r1
; CHECK-NEXT:    vmov.u16 r1, q0[7]
; CHECK-NEXT:    vmov.8 q2[7], r1
; CHECK-NEXT:    adr r1, .LCPI3_2
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vadd.i32 q0, q0, r0
; CHECK-NEXT:    vcmp.u32 hi, q7, q0
; CHECK-NEXT:    vstrw.32 q0, [sp] @ 16-byte Spill
; CHECK-NEXT:    vpsel q6, q4, q5
; CHECK-NEXT:    vmov r1, r12, d12
; CHECK-NEXT:    vmov.16 q0[0], r1
; CHECK-NEXT:    vmov.16 q0[1], r12
; CHECK-NEXT:    vmov r1, r12, d13
; CHECK-NEXT:    vmov.16 q0[2], r1
; CHECK-NEXT:    adr r1, .LCPI3_3
; CHECK-NEXT:    vldrw.u32 q6, [r1]
; CHECK-NEXT:    vmov.16 q0[3], r12
; CHECK-NEXT:    vadd.i32 q6, q6, r0
; CHECK-NEXT:    vcmp.u32 hi, q7, q6
; CHECK-NEXT:    vpsel q7, q4, q5
; CHECK-NEXT:    vmov r1, r12, d14
; CHECK-NEXT:    vmov.16 q0[4], r1
; CHECK-NEXT:    vmov.16 q0[5], r12
; CHECK-NEXT:    vmov r1, r12, d15
; CHECK-NEXT:    vmov.16 q0[6], r1
; CHECK-NEXT:    vdup.32 q7, r0
; CHECK-NEXT:    vmov.16 q0[7], r12
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q4, q5
; CHECK-NEXT:    vcmp.u32 hi, q7, q1
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vpsel q1, q4, q5
; CHECK-NEXT:    vmov.8 q2[8], r1
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    vmov.8 q2[9], r1
; CHECK-NEXT:    vmov.u16 r1, q0[2]
; CHECK-NEXT:    vmov.8 q2[10], r1
; CHECK-NEXT:    vmov.u16 r1, q0[3]
; CHECK-NEXT:    vmov.8 q2[11], r1
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    vmov.8 q2[12], r1
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    vmov.8 q2[13], r1
; CHECK-NEXT:    vmov.u16 r1, q0[6]
; CHECK-NEXT:    vmov.8 q2[14], r1
; CHECK-NEXT:    vmov.u16 r1, q0[7]
; CHECK-NEXT:    vmov.8 q2[15], r1
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vcmp.u32 hi, q7, q3
; CHECK-NEXT:    vmov.16 q0[1], r1
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vpsel q1, q4, q5
; CHECK-NEXT:    vmov.16 q0[3], r1
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov.16 q0[5], r1
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov.16 q0[7], r1
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q4, q5
; CHECK-NEXT:    vmov.u16 r0, q0[0]
; CHECK-NEXT:    vmov.8 q3[0], r0
; CHECK-NEXT:    vmov.u16 r0, q0[1]
; CHECK-NEXT:    vmov.8 q3[1], r0
; CHECK-NEXT:    vmov.u16 r0, q0[2]
; CHECK-NEXT:    vmov.8 q3[2], r0
; CHECK-NEXT:    vmov.u16 r0, q0[3]
; CHECK-NEXT:    vmov.8 q3[3], r0
; CHECK-NEXT:    vmov.u16 r0, q0[4]
; CHECK-NEXT:    vmov.8 q3[4], r0
; CHECK-NEXT:    vmov.u16 r0, q0[5]
; CHECK-NEXT:    vmov.8 q3[5], r0
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.8 q3[6], r0
; CHECK-NEXT:    vmov.u16 r0, q0[7]
; CHECK-NEXT:    vldrw.u32 q0, [sp] @ 16-byte Reload
; CHECK-NEXT:    vmov.8 q3[7], r0
; CHECK-NEXT:    vcmp.u32 hi, q7, q0
; CHECK-NEXT:    vpsel q1, q4, q5
; CHECK-NEXT:    vcmp.u32 hi, q7, q6
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vmov.16 q0[1], r1
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vpsel q1, q4, q5
; CHECK-NEXT:    vmov.16 q0[3], r1
; CHECK-NEXT:    vmov r0, r1, d2
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov.16 q0[5], r1
; CHECK-NEXT:    vmov r0, r1, d3
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov.16 q0[7], r1
; CHECK-NEXT:    vcmp.i16 ne, q0, zr
; CHECK-NEXT:    vpsel q0, q4, q5
; CHECK-NEXT:    vmov.u16 r0, q0[0]
; CHECK-NEXT:    vmov.8 q3[8], r0
; CHECK-NEXT:    vmov.u16 r0, q0[1]
; CHECK-NEXT:    vmov.8 q3[9], r0
; CHECK-NEXT:    vmov.u16 r0, q0[2]
; CHECK-NEXT:    vmov.8 q3[10], r0
; CHECK-NEXT:    vmov.u16 r0, q0[3]
; CHECK-NEXT:    vmov.8 q3[11], r0
; CHECK-NEXT:    vmov.u16 r0, q0[4]
; CHECK-NEXT:    vmov.8 q3[12], r0
; CHECK-NEXT:    vmov.u16 r0, q0[5]
; CHECK-NEXT:    vmov.8 q3[13], r0
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.8 q3[14], r0
; CHECK-NEXT:    vmov.u16 r0, q0[7]
; CHECK-NEXT:    vmov.8 q3[15], r0
; CHECK-NEXT:    add r0, sp, #88
; CHECK-NEXT:    vcmp.i8 ne, q3, zr
; CHECK-NEXT:    vldr d1, [sp, #80]
; CHECK-NEXT:    vpnot
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vcmpt.i8 ne, q2, zr
; CHECK-NEXT:    vmov d0, r2, r3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    add sp, #16
; CHECK-NEXT:    vpop {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI3_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:  .LCPI3_1:
; CHECK-NEXT:    .long 4 @ 0x4
; CHECK-NEXT:    .long 5 @ 0x5
; CHECK-NEXT:    .long 6 @ 0x6
; CHECK-NEXT:    .long 7 @ 0x7
; CHECK-NEXT:  .LCPI3_2:
; CHECK-NEXT:    .long 8 @ 0x8
; CHECK-NEXT:    .long 9 @ 0x9
; CHECK-NEXT:    .long 10 @ 0xa
; CHECK-NEXT:    .long 11 @ 0xb
; CHECK-NEXT:  .LCPI3_3:
; CHECK-NEXT:    .long 12 @ 0xc
; CHECK-NEXT:    .long 13 @ 0xd
; CHECK-NEXT:    .long 14 @ 0xe
; CHECK-NEXT:    .long 15 @ 0xf
  %active.lane.mask = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32 %index, i32 %TC)
  %select = select <16 x i1> %active.lane.mask, <16 x i8> %V1, <16 x i8> %V2
  ret <16 x i8> %select
}

define void @test_width2(i32* nocapture readnone %x, i32* nocapture %y, i8 zeroext %m) {
; CHECK-LABEL: test_width2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, r9, lr}
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    beq.w .LBB4_3
; CHECK-NEXT:  @ %bb.1: @ %for.body.preheader
; CHECK-NEXT:    adds r0, r2, #1
; CHECK-NEXT:    vmov q1[2], q1[0], r2, r2
; CHECK-NEXT:    bic r0, r0, #1
; CHECK-NEXT:    adr r2, .LCPI4_0
; CHECK-NEXT:    subs r0, #2
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    vmov.i64 q0, #0xffffffff
; CHECK-NEXT:    vldrw.u32 q2, [r2]
; CHECK-NEXT:    add.w lr, r3, r0, lsr #1
; CHECK-NEXT:    mov.w r12, #0
; CHECK-NEXT:    vand q1, q1, q0
; CHECK-NEXT:  .LBB4_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmov q3[2], q3[0], r12, r12
; CHECK-NEXT:    vmov r6, r7, d3
; CHECK-NEXT:    vand q3, q3, q0
; CHECK-NEXT:    add.w r12, r12, #2
; CHECK-NEXT:    vmov r2, r3, d7
; CHECK-NEXT:    vmov r9, s12
; CHECK-NEXT:    adds r0, r2, #1
; CHECK-NEXT:    vmov q3[2], q3[0], r9, r0
; CHECK-NEXT:    adc r8, r3, #0
; CHECK-NEXT:    vand q3, q3, q0
; CHECK-NEXT:    vmov r3, r2, d2
; CHECK-NEXT:    vmov r4, r5, d7
; CHECK-NEXT:    subs r6, r4, r6
; CHECK-NEXT:    eor.w r0, r0, r4
; CHECK-NEXT:    sbcs r5, r7
; CHECK-NEXT:    vmov r6, r7, d6
; CHECK-NEXT:    mov.w r5, #0
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r5, #1
; CHECK-NEXT:    cmp r5, #0
; CHECK-NEXT:    csetm r5, ne
; CHECK-NEXT:    subs r3, r6, r3
; CHECK-NEXT:    sbcs.w r2, r7, r2
; CHECK-NEXT:    mov.w r2, #0
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r2, #1
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    csetm r2, ne
; CHECK-NEXT:    orrs.w r0, r0, r8
; CHECK-NEXT:    cset r0, ne
; CHECK-NEXT:    vmov q3[2], q3[0], r2, r5
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    vmov q3[3], q3[1], r2, r5
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    teq.w r6, r9
; CHECK-NEXT:    cset r2, ne
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    csetm r2, ne
; CHECK-NEXT:    vmov q4[2], q4[0], r2, r0
; CHECK-NEXT:    vmov q4[3], q4[1], r2, r0
; CHECK-NEXT:    veor q4, q4, q2
; CHECK-NEXT:    vand q4, q4, q3
; CHECK-NEXT:    @ implicit-def: $q3
; CHECK-NEXT:    vmov r2, s16
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    and r2, r2, #1
; CHECK-NEXT:    orr.w r3, r2, r0, lsl #1
; CHECK-NEXT:    sub.w r2, r1, #8
; CHECK-NEXT:    lsls r0, r3, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    ldrne r0, [r2]
; CHECK-NEXT:    vmovne.32 q3[0], r0
; CHECK-NEXT:    and r0, r3, #3
; CHECK-NEXT:    lsls r0, r0, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    ldrmi r0, [r2, #4]
; CHECK-NEXT:    vmovmi.32 q3[2], r0
; CHECK-NEXT:    vmov r2, s16
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    and r2, r2, #1
; CHECK-NEXT:    orr.w r2, r2, r0, lsl #1
; CHECK-NEXT:    lsls r0, r2, #31
; CHECK-NEXT:    itt ne
; CHECK-NEXT:    vmovne r0, s12
; CHECK-NEXT:    strne r0, [r1]
; CHECK-NEXT:    and r0, r2, #3
; CHECK-NEXT:    lsls r0, r0, #30
; CHECK-NEXT:    itt mi
; CHECK-NEXT:    vmovmi r0, s14
; CHECK-NEXT:    strmi r0, [r1, #4]
; CHECK-NEXT:    adds r1, #8
; CHECK-NEXT:    le lr, .LBB4_2
; CHECK-NEXT:  .LBB4_3: @ %for.cond.cleanup
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.4:
; CHECK-NEXT:  .LCPI4_0:
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 0 @ 0x0
entry:
  %cmp9.not = icmp eq i8 %m, 0
  br i1 %cmp9.not, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  %wide.trip.count = zext i8 %m to i32
  %n.rnd.up = add nuw nsw i32 %wide.trip.count, 1
  %n.vec = and i32 %n.rnd.up, 510
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %for.body.preheader
  %index = phi i32 [ 0, %for.body.preheader ], [ %index.next, %vector.body ]
  %active.lane.mask = call <2 x i1> @llvm.get.active.lane.mask.v2i1.i32(i32 %index, i32 %wide.trip.count)
  %0 = add nsw i32 %index, -2
  %1 = getelementptr inbounds i32, i32* %y, i32 %0
  %2 = bitcast i32* %1 to <2 x i32>*
  %wide.masked.load = call <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>* %2, i32 4, <2 x i1> %active.lane.mask, <2 x i32> undef)
  %3 = getelementptr inbounds i32, i32* %y, i32 %index
  %4 = bitcast i32* %3 to <2 x i32>*
  call void @llvm.masked.store.v2i32.p0v2i32(<2 x i32> %wide.masked.load, <2 x i32>* %4, i32 4, <2 x i1> %active.lane.mask)
  %index.next = add i32 %index, 2
  %5 = icmp eq i32 %index.next, %n.vec
  br i1 %5, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

declare <2 x i1> @llvm.get.active.lane.mask.v2i1.i32(i32, i32)
declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <7 x i1> @llvm.get.active.lane.mask.v7i1.i32(i32, i32)
declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32, i32)
declare <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32, i32)
declare <2 x i32> @llvm.masked.load.v2i32.p0v2i32(<2 x i32>*, i32, <2 x i1>, <2 x i32>)
declare void @llvm.masked.store.v2i32.p0v2i32(<2 x i32>, <2 x i32>*, i32, <2 x i1>)
