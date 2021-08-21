; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv7-none-eabi < %s | FileCheck %s

define i1 @test_srem_odd(i29 %X) nounwind {
; CHECK-LABEL: test_srem_odd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r1, #24493
; CHECK-NEXT:    movw r2, #33099
; CHECK-NEXT:    movt r1, #41
; CHECK-NEXT:    movt r2, #8026
; CHECK-NEXT:    mla r0, r0, r2, r1
; CHECK-NEXT:    movw r2, #48987
; CHECK-NEXT:    movt r2, #82
; CHECK-NEXT:    bic r1, r0, #-536870912
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    cmp r1, r2
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r0, #1
; CHECK-NEXT:    bx lr
  %srem = srem i29 %X, 99
  %cmp = icmp eq i29 %srem, 0
  ret i1 %cmp
}

define i1 @test_srem_even(i4 %X) nounwind {
; CHECK-LABEL: test_srem_even:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r2, #43691
; CHECK-NEXT:    sbfx r1, r0, #0, #4
; CHECK-NEXT:    movt r2, #10922
; CHECK-NEXT:    lsls r0, r0, #28
; CHECK-NEXT:    smmul r1, r1, r2
; CHECK-NEXT:    add.w r1, r1, r1, lsr #31
; CHECK-NEXT:    add.w r1, r1, r1, lsl #1
; CHECK-NEXT:    mvn.w r1, r1, lsl #1
; CHECK-NEXT:    add.w r0, r1, r0, asr #28
; CHECK-NEXT:    clz r0, r0
; CHECK-NEXT:    lsrs r0, r0, #5
; CHECK-NEXT:    bx lr
  %srem = srem i4 %X, 6
  %cmp = icmp eq i4 %srem, 1
  ret i1 %cmp
}

define i1 @test_srem_pow2_setne(i6 %X) nounwind {
; CHECK-LABEL: test_srem_pow2_setne:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    sbfx r1, r0, #0, #6
; CHECK-NEXT:    ubfx r1, r1, #9, #2
; CHECK-NEXT:    add r1, r0
; CHECK-NEXT:    and r1, r1, #60
; CHECK-NEXT:    subs r0, r0, r1
; CHECK-NEXT:    ands r0, r0, #63
; CHECK-NEXT:    it ne
; CHECK-NEXT:    movne r0, #1
; CHECK-NEXT:    bx lr
  %srem = srem i6 %X, 4
  %cmp = icmp ne i6 %srem, 0
  ret i1 %cmp
}

define <3 x i1> @test_srem_vec(<3 x i33> %X) nounwind {
; CHECK-LABEL: test_srem_vec:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    .pad #4
; CHECK-NEXT:    sub sp, #4
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    mov r6, r0
; CHECK-NEXT:    and r0, r3, #1
; CHECK-NEXT:    mov r5, r1
; CHECK-NEXT:    rsbs r1, r0, #0
; CHECK-NEXT:    mov r0, r2
; CHECK-NEXT:    movs r2, #9
; CHECK-NEXT:    movs r3, #0
; CHECK-NEXT:    bl __aeabi_ldivmod
; CHECK-NEXT:    and r0, r5, #1
; CHECK-NEXT:    mov r7, r2
; CHECK-NEXT:    rsbs r1, r0, #0
; CHECK-NEXT:    mov r4, r3
; CHECK-NEXT:    mov r0, r6
; CHECK-NEXT:    movs r2, #9
; CHECK-NEXT:    movs r3, #0
; CHECK-NEXT:    bl __aeabi_ldivmod
; CHECK-NEXT:    ldr r1, [sp, #44]
; CHECK-NEXT:    vmov.32 d8[0], r2
; CHECK-NEXT:    ldr r0, [sp, #40]
; CHECK-NEXT:    mov r5, r3
; CHECK-NEXT:    and r1, r1, #1
; CHECK-NEXT:    mvn r2, #8
; CHECK-NEXT:    rsbs r1, r1, #0
; CHECK-NEXT:    mov.w r3, #-1
; CHECK-NEXT:    vmov.32 d9[0], r7
; CHECK-NEXT:    bl __aeabi_ldivmod
; CHECK-NEXT:    vmov.32 d16[0], r2
; CHECK-NEXT:    adr r0, .LCPI3_0
; CHECK-NEXT:    vmov.32 d9[1], r4
; CHECK-NEXT:    vld1.64 {d18, d19}, [r0:128]
; CHECK-NEXT:    adr r0, .LCPI3_1
; CHECK-NEXT:    vmov.32 d16[1], r3
; CHECK-NEXT:    vmov.32 d8[1], r5
; CHECK-NEXT:    vand q8, q8, q9
; CHECK-NEXT:    vld1.64 {d20, d21}, [r0:128]
; CHECK-NEXT:    adr r0, .LCPI3_2
; CHECK-NEXT:    vand q11, q4, q9
; CHECK-NEXT:    vld1.64 {d18, d19}, [r0:128]
; CHECK-NEXT:    vceq.i32 q10, q11, q10
; CHECK-NEXT:    vceq.i32 q8, q8, q9
; CHECK-NEXT:    vrev64.32 q9, q10
; CHECK-NEXT:    vrev64.32 q11, q8
; CHECK-NEXT:    vand q9, q10, q9
; CHECK-NEXT:    vand q8, q8, q11
; CHECK-NEXT:    vmvn q9, q9
; CHECK-NEXT:    vmvn q8, q8
; CHECK-NEXT:    vmovn.i64 d18, q9
; CHECK-NEXT:    vmovn.i64 d16, q8
; CHECK-NEXT:    vmov.32 r0, d18[0]
; CHECK-NEXT:    vmov.32 r1, d18[1]
; CHECK-NEXT:    vmov.32 r2, d16[0]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    add sp, #4
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI3_0:
; CHECK-NEXT:    .long 4294967295 @ 0xffffffff
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 4294967295 @ 0xffffffff
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:  .LCPI3_1:
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 4294967293 @ 0xfffffffd
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:  .LCPI3_2:
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .zero 4
; CHECK-NEXT:    .long 0 @ 0x0
  %srem = srem <3 x i33> %X, <i33 9, i33 9, i33 -9>
  %cmp = icmp ne <3 x i33> %srem, <i33 3, i33 -3, i33 3>
  ret <3 x i1> %cmp
}
