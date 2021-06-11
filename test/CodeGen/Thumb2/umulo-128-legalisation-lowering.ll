; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv7-unknown-none-gnueabi | FileCheck %s --check-prefixes=THUMBV7

define { i128, i8 } @muloti_test(i128 %l, i128 %r) unnamed_addr #0 {
; THUMBV7-LABEL: muloti_test:
; THUMBV7:       @ %bb.0: @ %start
; THUMBV7-NEXT:    .save {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; THUMBV7-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; THUMBV7-NEXT:    .pad #44
; THUMBV7-NEXT:    sub sp, #44
; THUMBV7-NEXT:    ldr.w lr, [sp, #88]
; THUMBV7-NEXT:    mov r11, r0
; THUMBV7-NEXT:    ldr r4, [sp, #96]
; THUMBV7-NEXT:    ldr.w r12, [sp, #80]
; THUMBV7-NEXT:    umull r1, r5, r2, lr
; THUMBV7-NEXT:    umull r7, r6, r3, r4
; THUMBV7-NEXT:    str r1, [sp, #40] @ 4-byte Spill
; THUMBV7-NEXT:    ldr r1, [sp, #100]
; THUMBV7-NEXT:    umull r4, r0, r4, r2
; THUMBV7-NEXT:    str r7, [sp, #32] @ 4-byte Spill
; THUMBV7-NEXT:    umull r7, r1, r1, r2
; THUMBV7-NEXT:    str r4, [sp, #24] @ 4-byte Spill
; THUMBV7-NEXT:    str r0, [sp, #12] @ 4-byte Spill
; THUMBV7-NEXT:    ldr r0, [sp, #84]
; THUMBV7-NEXT:    str r7, [sp, #20] @ 4-byte Spill
; THUMBV7-NEXT:    ldr r7, [sp, #92]
; THUMBV7-NEXT:    umull r10, r8, r0, lr
; THUMBV7-NEXT:    umull r4, r9, r7, r12
; THUMBV7-NEXT:    str r4, [sp, #8] @ 4-byte Spill
; THUMBV7-NEXT:    umull r4, r0, r12, lr
; THUMBV7-NEXT:    mov.w r12, #0
; THUMBV7-NEXT:    umlal r5, r12, r3, lr
; THUMBV7-NEXT:    str r4, [sp, #16] @ 4-byte Spill
; THUMBV7-NEXT:    str r0, [sp, #4] @ 4-byte Spill
; THUMBV7-NEXT:    umull r4, r2, r2, r7
; THUMBV7-NEXT:    ldr r0, [sp, #40] @ 4-byte Reload
; THUMBV7-NEXT:    str r4, [sp, #28] @ 4-byte Spill
; THUMBV7-NEXT:    str r2, [sp, #36] @ 4-byte Spill
; THUMBV7-NEXT:    str.w r0, [r11]
; THUMBV7-NEXT:    ldr r0, [sp, #32] @ 4-byte Reload
; THUMBV7-NEXT:    ldr r2, [sp, #20] @ 4-byte Reload
; THUMBV7-NEXT:    add r2, r0
; THUMBV7-NEXT:    ldr r0, [sp, #12] @ 4-byte Reload
; THUMBV7-NEXT:    adds.w lr, r0, r2
; THUMBV7-NEXT:    mov.w r2, #0
; THUMBV7-NEXT:    adc r0, r2, #0
; THUMBV7-NEXT:    str r0, [sp, #32] @ 4-byte Spill
; THUMBV7-NEXT:    ldr r0, [sp, #8] @ 4-byte Reload
; THUMBV7-NEXT:    add.w r4, r10, r0
; THUMBV7-NEXT:    ldr r0, [sp, #4] @ 4-byte Reload
; THUMBV7-NEXT:    adds r4, r4, r0
; THUMBV7-NEXT:    adc r0, r2, #0
; THUMBV7-NEXT:    str r0, [sp, #40] @ 4-byte Spill
; THUMBV7-NEXT:    ldr r0, [sp, #24] @ 4-byte Reload
; THUMBV7-NEXT:    ldr r2, [sp, #16] @ 4-byte Reload
; THUMBV7-NEXT:    adds.w r10, r2, r0
; THUMBV7-NEXT:    mov r2, r3
; THUMBV7-NEXT:    adc.w r0, r4, lr
; THUMBV7-NEXT:    ldr.w lr, [sp, #100]
; THUMBV7-NEXT:    cmp r1, #0
; THUMBV7-NEXT:    str r0, [sp, #24] @ 4-byte Spill
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r1, #1
; THUMBV7-NEXT:    cmp r3, #0
; THUMBV7-NEXT:    mov r0, lr
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r2, #1
; THUMBV7-NEXT:    cmp.w lr, #0
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r0, #1
; THUMBV7-NEXT:    ldr r4, [sp, #28] @ 4-byte Reload
; THUMBV7-NEXT:    ands r0, r2
; THUMBV7-NEXT:    orrs r1, r0
; THUMBV7-NEXT:    adds r5, r5, r4
; THUMBV7-NEXT:    str.w r5, [r11, #4]
; THUMBV7-NEXT:    ldr r0, [sp, #36] @ 4-byte Reload
; THUMBV7-NEXT:    mov.w r5, #0
; THUMBV7-NEXT:    adcs.w r0, r0, r12
; THUMBV7-NEXT:    adc r2, r5, #0
; THUMBV7-NEXT:    cmp r6, #0
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r6, #1
; THUMBV7-NEXT:    orrs r1, r6
; THUMBV7-NEXT:    ldr r6, [sp, #84]
; THUMBV7-NEXT:    umlal r0, r2, r3, r7
; THUMBV7-NEXT:    ldr r3, [sp, #32] @ 4-byte Reload
; THUMBV7-NEXT:    cmp r7, #0
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r7, #1
; THUMBV7-NEXT:    orrs r1, r3
; THUMBV7-NEXT:    mov r3, r6
; THUMBV7-NEXT:    cmp r6, #0
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r3, #1
; THUMBV7-NEXT:    cmp.w r8, #0
; THUMBV7-NEXT:    and.w r3, r3, r7
; THUMBV7-NEXT:    ldr r7, [sp, #80]
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne.w r8, #1
; THUMBV7-NEXT:    cmp.w r9, #0
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne.w r9, #1
; THUMBV7-NEXT:    orrs r7, r6
; THUMBV7-NEXT:    ldr r6, [sp, #96]
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r7, #1
; THUMBV7-NEXT:    orr.w r3, r3, r8
; THUMBV7-NEXT:    orrs.w r6, r6, lr
; THUMBV7-NEXT:    orr.w r3, r3, r9
; THUMBV7-NEXT:    it ne
; THUMBV7-NEXT:    movne r6, #1
; THUMBV7-NEXT:    adds.w r0, r0, r10
; THUMBV7-NEXT:    str.w r0, [r11, #8]
; THUMBV7-NEXT:    ldr r0, [sp, #24] @ 4-byte Reload
; THUMBV7-NEXT:    adcs r0, r2
; THUMBV7-NEXT:    str.w r0, [r11, #12]
; THUMBV7-NEXT:    ldr r0, [sp, #40] @ 4-byte Reload
; THUMBV7-NEXT:    and.w r2, r7, r6
; THUMBV7-NEXT:    orr.w r0, r0, r3
; THUMBV7-NEXT:    orr.w r0, r0, r2
; THUMBV7-NEXT:    orr.w r0, r0, r1
; THUMBV7-NEXT:    adc r1, r5, #0
; THUMBV7-NEXT:    orrs r0, r1
; THUMBV7-NEXT:    and r0, r0, #1
; THUMBV7-NEXT:    strb.w r0, [r11, #16]
; THUMBV7-NEXT:    add sp, #44
; THUMBV7-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11, pc}
start:
  %0 = tail call { i128, i1 } @llvm.umul.with.overflow.i128(i128 %l, i128 %r) #2
  %1 = extractvalue { i128, i1 } %0, 0
  %2 = extractvalue { i128, i1 } %0, 1
  %3 = zext i1 %2 to i8
  %4 = insertvalue { i128, i8 } undef, i128 %1, 0
  %5 = insertvalue { i128, i8 } %4, i8 %3, 1
  ret { i128, i8 } %5
}

; Function Attrs: nounwind readnone speculatable
declare { i128, i1 } @llvm.umul.with.overflow.i128(i128, i128) #1

attributes #0 = { nounwind readnone uwtable }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind }
