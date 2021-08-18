; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm-eabi | FileCheck %s -check-prefix=LE
; RUN: llc < %s -mtriple=armeb-eabi | FileCheck %s -check-prefix=BE

define void @i24_or(i24* %a) {
; LE-LABEL: i24_or:
; LE:       @ %bb.0:
; LE-NEXT:    ldrh r1, [r0]
; LE-NEXT:    orr r1, r1, #384
; LE-NEXT:    strh r1, [r0]
; LE-NEXT:    mov pc, lr
;
; BE-LABEL: i24_or:
; BE:       @ %bb.0:
; BE-NEXT:    ldrh r1, [r0]
; BE-NEXT:    ldrb r2, [r0, #2]
; BE-NEXT:    orr r1, r2, r1, lsl #8
; BE-NEXT:    orr r1, r1, #384
; BE-NEXT:    strb r1, [r0, #2]
; BE-NEXT:    lsr r1, r1, #8
; BE-NEXT:    strh r1, [r0]
; BE-NEXT:    mov pc, lr
  %aa = load i24, i24* %a, align 1
  %b = or i24 %aa, 384
  store i24 %b, i24* %a, align 1
  ret void
}

define void @i24_and_or(i24* %a) {
; LE-LABEL: i24_and_or:
; LE:       @ %bb.0:
; LE-NEXT:    ldrh r1, [r0]
; LE-NEXT:    orr r1, r1, #384
; LE-NEXT:    bic r1, r1, #127
; LE-NEXT:    strh r1, [r0]
; LE-NEXT:    mov pc, lr
;
; BE-LABEL: i24_and_or:
; BE:       @ %bb.0:
; BE-NEXT:    mov r1, #128
; BE-NEXT:    strb r1, [r0, #2]
; BE-NEXT:    ldrh r1, [r0]
; BE-NEXT:    orr r1, r1, #1
; BE-NEXT:    strh r1, [r0]
; BE-NEXT:    mov pc, lr
  %b = load i24, i24* %a, align 1
  %c = and i24 %b, -128
  %d = or i24 %c, 384
  store i24 %d, i24* %a, align 1
  ret void
}

define void @i24_insert_bit(i24* %a, i1 zeroext %bit) {
; LE-LABEL: i24_insert_bit:
; LE:       @ %bb.0:
; LE-NEXT:    mov r3, #255
; LE-NEXT:    ldrh r2, [r0]
; LE-NEXT:    orr r3, r3, #57088
; LE-NEXT:    and r2, r2, r3
; LE-NEXT:    orr r1, r2, r1, lsl #13
; LE-NEXT:    strh r1, [r0]
; LE-NEXT:    mov pc, lr
;
; BE-LABEL: i24_insert_bit:
; BE:       @ %bb.0:
; BE-NEXT:    ldrh r2, [r0]
; BE-NEXT:    mov r3, #57088
; BE-NEXT:    orr r3, r3, #16711680
; BE-NEXT:    and r2, r3, r2, lsl #8
; BE-NEXT:    orr r1, r2, r1, lsl #13
; BE-NEXT:    lsr r1, r1, #8
; BE-NEXT:    strh r1, [r0]
; BE-NEXT:    mov pc, lr
  %extbit = zext i1 %bit to i24
  %b = load i24, i24* %a, align 1
  %extbit.shl = shl nuw nsw i24 %extbit, 13
  %c = and i24 %b, -8193
  %d = or i24 %c, %extbit.shl
  store i24 %d, i24* %a, align 1
  ret void
}

define void @i56_or(i56* %a) {
; LE-LABEL: i56_or:
; LE:       @ %bb.0:
; LE-NEXT:    ldr r1, [r0]
; LE-NEXT:    orr r1, r1, #384
; LE-NEXT:    str r1, [r0]
; LE-NEXT:    mov pc, lr
;
; BE-LABEL: i56_or:
; BE:       @ %bb.0:
; BE-NEXT:    mov r1, r0
; BE-NEXT:    ldr r12, [r0]
; BE-NEXT:    ldrh r2, [r1, #4]!
; BE-NEXT:    ldrb r3, [r1, #2]
; BE-NEXT:    orr r2, r3, r2, lsl #8
; BE-NEXT:    orr r2, r2, r12, lsl #24
; BE-NEXT:    orr r2, r2, #384
; BE-NEXT:    strb r2, [r1, #2]
; BE-NEXT:    lsr r3, r2, #8
; BE-NEXT:    strh r3, [r1]
; BE-NEXT:    bic r1, r12, #255
; BE-NEXT:    orr r1, r1, r2, lsr #24
; BE-NEXT:    str r1, [r0]
; BE-NEXT:    mov pc, lr
  %aa = load i56, i56* %a
  %b = or i56 %aa, 384
  store i56 %b, i56* %a
  ret void
}

define void @i56_and_or(i56* %a) {
; LE-LABEL: i56_and_or:
; LE:       @ %bb.0:
; LE-NEXT:    ldr r1, [r0]
; LE-NEXT:    orr r1, r1, #384
; LE-NEXT:    bic r1, r1, #127
; LE-NEXT:    str r1, [r0]
; LE-NEXT:    mov pc, lr
;
; BE-LABEL: i56_and_or:
; BE:       @ %bb.0:
; BE-NEXT:    mov r1, r0
; BE-NEXT:    mov r2, #128
; BE-NEXT:    ldrh r12, [r1, #4]!
; BE-NEXT:    ldrb r3, [r1, #2]
; BE-NEXT:    strb r2, [r1, #2]
; BE-NEXT:    orr r2, r3, r12, lsl #8
; BE-NEXT:    ldr r12, [r0]
; BE-NEXT:    orr r2, r2, r12, lsl #24
; BE-NEXT:    orr r2, r2, #384
; BE-NEXT:    lsr r3, r2, #8
; BE-NEXT:    strh r3, [r1]
; BE-NEXT:    bic r1, r12, #255
; BE-NEXT:    orr r1, r1, r2, lsr #24
; BE-NEXT:    str r1, [r0]
; BE-NEXT:    mov pc, lr

  %b = load i56, i56* %a, align 1
  %c = and i56 %b, -128
  %d = or i56 %c, 384
  store i56 %d, i56* %a, align 1
  ret void
}

define void @i56_insert_bit(i56* %a, i1 zeroext %bit) {
; LE-LABEL: i56_insert_bit:
; LE:       @ %bb.0:
; LE-NEXT:    ldr r2, [r0]
; LE-NEXT:    bic r2, r2, #8192
; LE-NEXT:    orr r1, r2, r1, lsl #13
; LE-NEXT:    str r1, [r0]
; LE-NEXT:    mov pc, lr
;
; BE-LABEL: i56_insert_bit:
; BE:       @ %bb.0:
; BE-NEXT:    .save {r11, lr}
; BE-NEXT:    push {r11, lr}
; BE-NEXT:    mov r2, r0
; BE-NEXT:    ldr lr, [r0]
; BE-NEXT:    ldrh r12, [r2, #4]!
; BE-NEXT:    ldrb r3, [r2, #2]
; BE-NEXT:    orr r12, r3, r12, lsl #8
; BE-NEXT:    orr r3, r12, lr, lsl #24
; BE-NEXT:    bic r3, r3, #8192
; BE-NEXT:    orr r1, r3, r1, lsl #13
; BE-NEXT:    lsr r3, r1, #8
; BE-NEXT:    strh r3, [r2]
; BE-NEXT:    bic r2, lr, #255
; BE-NEXT:    orr r1, r2, r1, lsr #24
; BE-NEXT:    str r1, [r0]
; BE-NEXT:    pop {r11, lr}
; BE-NEXT:    mov pc, lr
  %extbit = zext i1 %bit to i56
  %b = load i56, i56* %a, align 1
  %extbit.shl = shl nuw nsw i56 %extbit, 13
  %c = and i56 %b, -8193
  %d = or i56 %c, %extbit.shl
  store i56 %d, i56* %a, align 1
  ret void
}

