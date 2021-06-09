; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=armv6-unknown-linux-gnu | FileCheck %s --check-prefixes=ARMV6
; RUN: llc < %s -mtriple=armv7-unknown-linux-gnu | FileCheck %s --check-prefixes=ARMV7

define { i128, i8 } @muloti_test(i128 %l, i128 %r) unnamed_addr #0 {
; ARMV6-LABEL: muloti_test:
; ARMV6:       @ %bb.0: @ %start
; ARMV6-NEXT:    push {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; ARMV6-NEXT:    sub sp, sp, #28
; ARMV6-NEXT:    mov r9, #0
; ARMV6-NEXT:    mov r11, r0
; ARMV6-NEXT:    ldr r7, [sp, #76]
; ARMV6-NEXT:    mov r5, r3
; ARMV6-NEXT:    ldr r10, [sp, #72]
; ARMV6-NEXT:    mov r1, r3
; ARMV6-NEXT:    mov r6, r2
; ARMV6-NEXT:    mov r0, r2
; ARMV6-NEXT:    mov r2, #0
; ARMV6-NEXT:    mov r3, #0
; ARMV6-NEXT:    str r9, [sp, #12]
; ARMV6-NEXT:    str r9, [sp, #8]
; ARMV6-NEXT:    str r7, [sp, #4]
; ARMV6-NEXT:    str r10, [sp]
; ARMV6-NEXT:    bl __multi3
; ARMV6-NEXT:    str r3, [sp, #20] @ 4-byte Spill
; ARMV6-NEXT:    str r2, [sp, #16] @ 4-byte Spill
; ARMV6-NEXT:    stm r11, {r0, r1}
; ARMV6-NEXT:    ldr r0, [sp, #84]
; ARMV6-NEXT:    ldr r3, [sp, #80]
; ARMV6-NEXT:    ldr r8, [sp, #64]
; ARMV6-NEXT:    umull r4, r0, r0, r6
; ARMV6-NEXT:    umull r2, r1, r5, r3
; ARMV6-NEXT:    add r2, r4, r2
; ARMV6-NEXT:    umull lr, r4, r3, r6
; ARMV6-NEXT:    umull r3, r6, r7, r8
; ARMV6-NEXT:    adds r12, r4, r2
; ARMV6-NEXT:    adc r2, r9, #0
; ARMV6-NEXT:    str r2, [sp, #24] @ 4-byte Spill
; ARMV6-NEXT:    ldr r2, [sp, #68]
; ARMV6-NEXT:    umull r4, r2, r2, r10
; ARMV6-NEXT:    add r3, r4, r3
; ARMV6-NEXT:    umull r4, r10, r8, r10
; ARMV6-NEXT:    adds r3, r10, r3
; ARMV6-NEXT:    adc r10, r9, #0
; ARMV6-NEXT:    adds r4, r4, lr
; ARMV6-NEXT:    adc r12, r3, r12
; ARMV6-NEXT:    ldr r3, [sp, #16] @ 4-byte Reload
; ARMV6-NEXT:    adds r4, r3, r4
; ARMV6-NEXT:    str r4, [r11, #8]
; ARMV6-NEXT:    ldr r4, [sp, #20] @ 4-byte Reload
; ARMV6-NEXT:    adcs r3, r4, r12
; ARMV6-NEXT:    str r3, [r11, #12]
; ARMV6-NEXT:    ldr r3, [sp, #84]
; ARMV6-NEXT:    adc r12, r9, #0
; ARMV6-NEXT:    cmp r5, #0
; ARMV6-NEXT:    movne r5, #1
; ARMV6-NEXT:    cmp r3, #0
; ARMV6-NEXT:    mov r4, r3
; ARMV6-NEXT:    movne r4, #1
; ARMV6-NEXT:    cmp r0, #0
; ARMV6-NEXT:    movne r0, #1
; ARMV6-NEXT:    cmp r1, #0
; ARMV6-NEXT:    and r5, r4, r5
; ARMV6-NEXT:    movne r1, #1
; ARMV6-NEXT:    orr r0, r5, r0
; ARMV6-NEXT:    ldr r5, [sp, #68]
; ARMV6-NEXT:    orr r0, r0, r1
; ARMV6-NEXT:    ldr r1, [sp, #24] @ 4-byte Reload
; ARMV6-NEXT:    cmp r7, #0
; ARMV6-NEXT:    orr r0, r0, r1
; ARMV6-NEXT:    movne r7, #1
; ARMV6-NEXT:    cmp r5, #0
; ARMV6-NEXT:    mov r1, r5
; ARMV6-NEXT:    movne r1, #1
; ARMV6-NEXT:    cmp r2, #0
; ARMV6-NEXT:    movne r2, #1
; ARMV6-NEXT:    and r1, r1, r7
; ARMV6-NEXT:    orr r1, r1, r2
; ARMV6-NEXT:    ldr r2, [sp, #80]
; ARMV6-NEXT:    cmp r6, #0
; ARMV6-NEXT:    movne r6, #1
; ARMV6-NEXT:    orrs r2, r2, r3
; ARMV6-NEXT:    orr r1, r1, r6
; ARMV6-NEXT:    movne r2, #1
; ARMV6-NEXT:    orrs r7, r8, r5
; ARMV6-NEXT:    orr r1, r1, r10
; ARMV6-NEXT:    movne r7, #1
; ARMV6-NEXT:    and r2, r7, r2
; ARMV6-NEXT:    orr r1, r2, r1
; ARMV6-NEXT:    orr r0, r1, r0
; ARMV6-NEXT:    orr r0, r0, r12
; ARMV6-NEXT:    and r0, r0, #1
; ARMV6-NEXT:    strb r0, [r11, #16]
; ARMV6-NEXT:    add sp, sp, #28
; ARMV6-NEXT:    pop {r4, r5, r6, r7, r8, r9, r10, r11, pc}
;
; ARMV7-LABEL: muloti_test:
; ARMV7:       @ %bb.0: @ %start
; ARMV7-NEXT:    push {r4, r5, r6, r7, r8, r9, r10, r11, lr}
; ARMV7-NEXT:    sub sp, sp, #44
; ARMV7-NEXT:    str r0, [sp, #40] @ 4-byte Spill
; ARMV7-NEXT:    mov r0, #0
; ARMV7-NEXT:    ldr r8, [sp, #88]
; ARMV7-NEXT:    mov r5, r3
; ARMV7-NEXT:    ldr r7, [sp, #92]
; ARMV7-NEXT:    mov r1, r3
; ARMV7-NEXT:    mov r6, r2
; ARMV7-NEXT:    str r0, [sp, #8]
; ARMV7-NEXT:    str r0, [sp, #12]
; ARMV7-NEXT:    mov r0, r2
; ARMV7-NEXT:    mov r2, #0
; ARMV7-NEXT:    mov r3, #0
; ARMV7-NEXT:    str r8, [sp]
; ARMV7-NEXT:    str r7, [sp, #4]
; ARMV7-NEXT:    bl __multi3
; ARMV7-NEXT:    str r1, [sp, #28] @ 4-byte Spill
; ARMV7-NEXT:    ldr r1, [sp, #80]
; ARMV7-NEXT:    str r2, [sp, #24] @ 4-byte Spill
; ARMV7-NEXT:    str r3, [sp, #20] @ 4-byte Spill
; ARMV7-NEXT:    umull r2, r9, r7, r1
; ARMV7-NEXT:    str r0, [sp, #32] @ 4-byte Spill
; ARMV7-NEXT:    ldr r4, [sp, #84]
; ARMV7-NEXT:    ldr r0, [sp, #96]
; ARMV7-NEXT:    umull r1, r3, r1, r8
; ARMV7-NEXT:    umull r12, r10, r4, r8
; ARMV7-NEXT:    str r1, [sp, #16] @ 4-byte Spill
; ARMV7-NEXT:    umull lr, r1, r5, r0
; ARMV7-NEXT:    add r2, r12, r2
; ARMV7-NEXT:    umull r11, r8, r0, r6
; ARMV7-NEXT:    ldr r0, [sp, #100]
; ARMV7-NEXT:    adds r2, r3, r2
; ARMV7-NEXT:    mov r12, #0
; ARMV7-NEXT:    umull r6, r0, r0, r6
; ARMV7-NEXT:    adc r3, r12, #0
; ARMV7-NEXT:    str r3, [sp, #36] @ 4-byte Spill
; ARMV7-NEXT:    add r3, r6, lr
; ARMV7-NEXT:    ldr r6, [sp, #16] @ 4-byte Reload
; ARMV7-NEXT:    adds r3, r8, r3
; ARMV7-NEXT:    adc lr, r12, #0
; ARMV7-NEXT:    adds r6, r6, r11
; ARMV7-NEXT:    adc r2, r2, r3
; ARMV7-NEXT:    ldr r3, [sp, #24] @ 4-byte Reload
; ARMV7-NEXT:    mov r12, #0
; ARMV7-NEXT:    adds r3, r3, r6
; ARMV7-NEXT:    ldr r6, [sp, #20] @ 4-byte Reload
; ARMV7-NEXT:    adcs r8, r6, r2
; ARMV7-NEXT:    ldr r6, [sp, #40] @ 4-byte Reload
; ARMV7-NEXT:    ldr r2, [sp, #32] @ 4-byte Reload
; ARMV7-NEXT:    str r2, [r6]
; ARMV7-NEXT:    ldr r2, [sp, #28] @ 4-byte Reload
; ARMV7-NEXT:    stmib r6, {r2, r3, r8}
; ARMV7-NEXT:    adc r8, r12, #0
; ARMV7-NEXT:    cmp r5, #0
; ARMV7-NEXT:    ldr r2, [sp, #100]
; ARMV7-NEXT:    movwne r5, #1
; ARMV7-NEXT:    cmp r2, #0
; ARMV7-NEXT:    mov r3, r2
; ARMV7-NEXT:    movwne r3, #1
; ARMV7-NEXT:    cmp r0, #0
; ARMV7-NEXT:    movwne r0, #1
; ARMV7-NEXT:    cmp r1, #0
; ARMV7-NEXT:    and r3, r3, r5
; ARMV7-NEXT:    movwne r1, #1
; ARMV7-NEXT:    orr r0, r3, r0
; ARMV7-NEXT:    cmp r7, #0
; ARMV7-NEXT:    orr r0, r0, r1
; ARMV7-NEXT:    ldr r1, [sp, #80]
; ARMV7-NEXT:    movwne r7, #1
; ARMV7-NEXT:    cmp r4, #0
; ARMV7-NEXT:    orr r1, r1, r4
; ARMV7-NEXT:    movwne r4, #1
; ARMV7-NEXT:    cmp r10, #0
; ARMV7-NEXT:    and r3, r4, r7
; ARMV7-NEXT:    movwne r10, #1
; ARMV7-NEXT:    cmp r9, #0
; ARMV7-NEXT:    orr r3, r3, r10
; ARMV7-NEXT:    ldr r7, [sp, #36] @ 4-byte Reload
; ARMV7-NEXT:    movwne r9, #1
; ARMV7-NEXT:    orr r3, r3, r9
; ARMV7-NEXT:    orr r3, r3, r7
; ARMV7-NEXT:    ldr r7, [sp, #96]
; ARMV7-NEXT:    orr r0, r0, lr
; ARMV7-NEXT:    orrs r7, r7, r2
; ARMV7-NEXT:    movwne r7, #1
; ARMV7-NEXT:    cmp r1, #0
; ARMV7-NEXT:    movwne r1, #1
; ARMV7-NEXT:    and r1, r1, r7
; ARMV7-NEXT:    orr r1, r1, r3
; ARMV7-NEXT:    orr r0, r1, r0
; ARMV7-NEXT:    orr r0, r0, r8
; ARMV7-NEXT:    and r0, r0, #1
; ARMV7-NEXT:    strb r0, [r6, #16]
; ARMV7-NEXT:    add sp, sp, #44
; ARMV7-NEXT:    pop {r4, r5, r6, r7, r8, r9, r10, r11, pc}
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
