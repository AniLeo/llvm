# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=armv8 -mcpu=cortex-a57 -instruction-tables < %s | FileCheck %s

  .text
  ldr	r5, [r7]
  ldr	r6, [r3, #63]
  ldr	r2, [r4, #4095]!
  ldr	r1, [r2], #30
  ldr	r3, [r1], #-30
  ldr	r3, [r8, r1]
  ldr	r2, [r5, -r3]
  ldr	r1, [r5, r9]!
  ldr	r6, [r7, -r8]!
  ldr	r1, [r0, r2, lsr #3]!
  ldr	r5, [r9], r2
  ldr	r4, [r3], -r6
  ldr	r3, [r8, -r2, lsl #15]
  ldr	r1, [r5], r3, asr #15
  ldrb	r3, [r8]
  ldrb	r1, [sp, #63]
  ldrb	r9, [r3, #4095]!
  ldrb	r8, [r1], #22
  ldrb	r2, [r7], #-19
  ldrb	r9, [r8, r5]
  ldrb	r1, [r5, -r1]
  ldrb	r3, [r5, r2]!
  ldrb	r6, [r9, -r3]!
  ldrb	r2, [r1], r4
  ldrb	r8, [r4], -r5
  ldrb	r7, [r12, -r1, lsl #15]
  ldrb	r5, [r2], r9, asr #15
  ldrbt	r3, [r1], #4
  ldrbt	r2, [r8], #-8
  ldrbt	r8, [r7], r6
  ldrbt	r1, [r2], -r6, lsl #12
  ldrd	r0, r1, [r5]
  ldrd	r8, r9, [r2, #15]
  ldrd	r2, r3, [r9, #32]!
  ldrd	r6, r7, [r1], #8
  ldrd	r2, r3, [r8], #0
  ldrd	r2, r3, [r8], #0
  ldrd	r2, r3, [r8], #-0
  ldrd	r4, r5, [r1, r3]
  ldrd	r4, r5, [r7, r2]!
  ldrd	r0, r1, [r8], r12
  ldrd	r0, r1, [r8], -r12
  ldrh	r3, [r4]
  ldrh	r2, [r7, #4]
  ldrh	r1, [r8, #64]!
  ldrh	r12, [sp], #4
  ldrh	r6, [r5, r4]
  ldrh	r3, [r8, r11]!
  ldrh	r1, [r2, -r1]!
  ldrh	r9, [r7], r2
  ldrh	r4, [r3], -r2
  ldrht	r9, [r7], #128
  ldrht	r4, [r3], #-75
  ldrht	r9, [r7], r2
  ldrht	r4, [r3], -r2
  ldrsb	r3, [r4]
  ldrsb	r2, [r7, #17]
  ldrsb	r1, [r8, #255]!
  ldrsb	r12, [sp], #9
  ldrsb	r6, [r5, r4]
  ldrsb	r3, [r8, r11]!
  ldrsb	r1, [r2, -r1]!
  ldrsb	r9, [r7], r2
  ldrsb	r4, [r3], -r2
  ldrsbt	r5, [r6], #1
  ldrsbt	r3, [r8], #-12
  ldrsbt	r8, [r9], r5
  ldrsbt	r2, [r1], -r4
  ldrsh	r5, [r9]
  ldrsh	r4, [r5, #7]
  ldrsh	r3, [r6, #55]!
  ldrsh	r2, [r7], #-9
  ldrsh	r3, [r1, r5]
  ldrsh	r4, [r6, r1]!
  ldrsh	r5, [r3, -r6]!
  ldrsh	r6, [r9], r8
  ldrsh	r7, [r8], -r3
  ldrsht	r5, [r6], #1
  ldrsht	r3, [r8], #-12
  ldrsht	r8, [r9], r5
  ldrsht	r2, [r1], -r4
  ldm r2, {r1, r2, r4, r5, r6}
  ldmia r2, {r1, r2, r4, r5, r6}
  ldmia r2, {r1, r3, r4, r5, r6}
  ldmib r2, {r1, r2}
  ldmdb r2, {r1, r2}
  ldmib r2, {r1, r3}
  ldmib r2, {r1, r3, r5}
  ldmib r2, {r1, r2, r5}
  ldmdbeq r2, {r1, r2}
  ldmibeq r2, {r1, r3}
  ldmia r2, {r0, r1, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15}
  ldmia r2, {r0, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15}
  str	r8, [r12]
  str	r7, [r1, #12]
  str	r3, [r5, #40]!
  str	r9, [sp], #4095
  str	r1, [r7], #-128
  str	r9, [r6, r3]
  str	r8, [r0, -r2]
  str	r7, [r1, r6]!
  str	r7, [r1, r6, lsl #2]!
  str	r6, [sp, -r1]!
  str	r5, [r3], r9
  str	r4, [r2], -r5
  str	r3, [r4, -r2, lsl #2]
  str	r2, [r7], r3, asr #24
  strb	r9, [r2]
  strb	r7, [r1, #3]
  strb	r6, [r4, #405]!
  strb	r5, [r7], #72
  strb	r1, [sp], #-1
  strb	r1, [r2, r9]
  strb	r2, [r3, -r8]
  strb	r3, [r4, r7]!
  strb	r4, [r5, -r6]!
  strb	r5, [r6], r5
  strb	r6, [r2], -r4
  strb	r7, [r12, -r3, lsl #5]
  strb	sp, [r7], r2, asr #12
  strbt	r6, [r2], #12
  strbt	r5, [r6], #-13
  strbt	r4, [r9], r5
  strbt	r3, [r8], -r2, lsl #3
  strd	r0, r1, [r4]
  strd	r2, r3, [r6, #1]
  strd	r2, r3, [r7, #22]!
  strd	r4, r5, [r8], #7
  strd	r4, r5, [sp], #0
  strd	r6, r7, [lr], #0
  strd	r6, r7, [r9], #-0
  strd	r8, r9, [r4, r1]
  strd	r6, r7, [r3, r9]!
  strd	r6, r7, [r5], r8
  strd	r4, r5, [r12], -r10
  strh	r3, [r4]
  strh	r2, [r7, #4]
  strh	r1, [r8, #64]!
  strh	r12, [sp], #4
  strh	r6, [r5, r4]
  strh	r3, [r8, r11]!
  strh	r1, [r2, -r1]!
  strh	r9, [r7], r2
  strh	r4, [r3], -r2
  strht	r2, [r5], #76
  strht	r8, [r1], #-25
  strht	r5, [r3], r4
  strht	r6, [r8], -r0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      4     1.00    *                   ldr	r5, [r7]
# CHECK-NEXT:  1      4     1.00    *                   ldr	r6, [r3, #63]
# CHECK-NEXT:  2      4     1.00    *                   ldr	r2, [r4, #4095]!
# CHECK-NEXT:  2      4     1.00    *                   ldr	r1, [r2], #30
# CHECK-NEXT:  2      4     1.00    *                   ldr	r3, [r1], #-30
# CHECK-NEXT:  1      4     1.00    *                   ldr	r3, [r8, r1]
# CHECK-NEXT:  1      4     1.00    *                   ldr	r2, [r5, -r3]
# CHECK-NEXT:  2      4     1.00    *                   ldr	r1, [r5, r9]!
# CHECK-NEXT:  2      4     1.00    *                   ldr	r6, [r7, -r8]!
# CHECK-NEXT:  2      4     1.00    *                   ldr	r1, [r0, r2, lsr #3]!
# CHECK-NEXT:  2      4     1.00    *                   ldr	r5, [r9], r2
# CHECK-NEXT:  2      4     1.00    *                   ldr	r4, [r3], -r6
# CHECK-NEXT:  1      4     1.00    *                   ldr	r3, [r8, -r2, lsl #15]
# CHECK-NEXT:  2      4     1.00    *                   ldr	r1, [r5], r3, asr #15
# CHECK-NEXT:  1      4     1.00    *                   ldrb	r3, [r8]
# CHECK-NEXT:  1      4     1.00    *                   ldrb	r1, [sp, #63]
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r9, [r3, #4095]!
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r8, [r1], #22
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r2, [r7], #-19
# CHECK-NEXT:  1      4     1.00    *                   ldrb	r9, [r8, r5]
# CHECK-NEXT:  1      4     1.00    *                   ldrb	r1, [r5, -r1]
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r3, [r5, r2]!
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r6, [r9, -r3]!
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r2, [r1], r4
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r8, [r4], -r5
# CHECK-NEXT:  1      4     1.00    *                   ldrb	r7, [r12, -r1, lsl #15]
# CHECK-NEXT:  2      4     1.00    *                   ldrb	r5, [r2], r9, asr #15
# CHECK-NEXT:  2      4     1.00    *                   ldrbt	r3, [r1], #4
# CHECK-NEXT:  2      4     1.00    *                   ldrbt	r2, [r8], #-8
# CHECK-NEXT:  2      4     1.00    *                   ldrbt	r8, [r7], r6
# CHECK-NEXT:  2      4     1.00    *                   ldrbt	r1, [r2], -r6, lsl #12
# CHECK-NEXT:  2      4     2.00    *                   ldrd	r0, r1, [r5]
# CHECK-NEXT:  2      4     2.00    *                   ldrd	r8, r9, [r2, #15]
# CHECK-NEXT:  4      5     2.00    *                   ldrd	r2, r3, [r9, #32]!
# CHECK-NEXT:  4      4     2.00    *                   ldrd	r6, r7, [r1], #8
# CHECK-NEXT:  4      4     2.00    *                   ldrd	r2, r3, [r8], #0
# CHECK-NEXT:  4      4     2.00    *                   ldrd	r2, r3, [r8], #0
# CHECK-NEXT:  4      4     2.00    *                   ldrd	r2, r3, [r8], #-0
# CHECK-NEXT:  2      4     2.00    *                   ldrd	r4, r5, [r1, r3]
# CHECK-NEXT:  4      4     2.00    *                   ldrd	r4, r5, [r7, r2]!
# CHECK-NEXT:  4      4     2.00    *                   ldrd	r0, r1, [r8], r12
# CHECK-NEXT:  4      4     2.00    *                   ldrd	r0, r1, [r8], -r12
# CHECK-NEXT:  1      4     1.00    *                   ldrh	r3, [r4]
# CHECK-NEXT:  1      4     1.00    *                   ldrh	r2, [r7, #4]
# CHECK-NEXT:  1      4     1.00    *                   ldrh	r1, [r8, #64]!
# CHECK-NEXT:  2      4     1.00    *                   ldrh	r12, [sp], #4
# CHECK-NEXT:  1      4     1.00    *                   ldrh	r6, [r5, r4]
# CHECK-NEXT:  1      4     1.00    *                   ldrh	r3, [r8, r11]!
# CHECK-NEXT:  1      4     1.00    *                   ldrh	r1, [r2, -r1]!
# CHECK-NEXT:  2      4     1.00    *                   ldrh	r9, [r7], r2
# CHECK-NEXT:  2      4     1.00    *                   ldrh	r4, [r3], -r2
# CHECK-NEXT:  2      4     1.00    *                   ldrht	r9, [r7], #128
# CHECK-NEXT:  2      4     1.00    *                   ldrht	r4, [r3], #-75
# CHECK-NEXT:  2      4     1.00    *                   ldrht	r9, [r7], r2
# CHECK-NEXT:  2      4     1.00    *                   ldrht	r4, [r3], -r2
# CHECK-NEXT:  1      4     1.00    *                   ldrsb	r3, [r4]
# CHECK-NEXT:  1      4     1.00    *                   ldrsb	r2, [r7, #17]
# CHECK-NEXT:  1      4     1.00    *                   ldrsb	r1, [r8, #255]!
# CHECK-NEXT:  2      4     1.00    *                   ldrsb	r12, [sp], #9
# CHECK-NEXT:  1      4     1.00    *                   ldrsb	r6, [r5, r4]
# CHECK-NEXT:  1      4     1.00    *                   ldrsb	r3, [r8, r11]!
# CHECK-NEXT:  1      4     1.00    *                   ldrsb	r1, [r2, -r1]!
# CHECK-NEXT:  2      4     1.00    *                   ldrsb	r9, [r7], r2
# CHECK-NEXT:  2      4     1.00    *                   ldrsb	r4, [r3], -r2
# CHECK-NEXT:  2      4     1.00    *                   ldrsbt	r5, [r6], #1
# CHECK-NEXT:  2      4     1.00    *                   ldrsbt	r3, [r8], #-12
# CHECK-NEXT:  2      4     1.00    *                   ldrsbt	r8, [r9], r5
# CHECK-NEXT:  2      4     1.00    *                   ldrsbt	r2, [r1], -r4
# CHECK-NEXT:  1      4     1.00    *                   ldrsh	r5, [r9]
# CHECK-NEXT:  1      4     1.00    *                   ldrsh	r4, [r5, #7]
# CHECK-NEXT:  1      4     1.00    *                   ldrsh	r3, [r6, #55]!
# CHECK-NEXT:  2      4     1.00    *                   ldrsh	r2, [r7], #-9
# CHECK-NEXT:  1      4     1.00    *                   ldrsh	r3, [r1, r5]
# CHECK-NEXT:  1      4     1.00    *                   ldrsh	r4, [r6, r1]!
# CHECK-NEXT:  1      4     1.00    *                   ldrsh	r5, [r3, -r6]!
# CHECK-NEXT:  2      4     1.00    *                   ldrsh	r6, [r9], r8
# CHECK-NEXT:  2      4     1.00    *                   ldrsh	r7, [r8], -r3
# CHECK-NEXT:  2      4     1.00    *                   ldrsht	r5, [r6], #1
# CHECK-NEXT:  2      4     1.00    *                   ldrsht	r3, [r8], #-12
# CHECK-NEXT:  2      4     1.00    *                   ldrsht	r8, [r9], r5
# CHECK-NEXT:  2      4     1.00    *                   ldrsht	r2, [r1], -r4
# CHECK-NEXT:  12     6     6.00    *                   ldm	r2, {r1, r2, r4, r5, r6}
# CHECK-NEXT:  12     6     6.00    *                   ldm	r2, {r1, r2, r4, r5, r6}
# CHECK-NEXT:  6      5     6.00    *                   ldm	r2, {r1, r3, r4, r5, r6}
# CHECK-NEXT:  4      4     2.00    *                   ldmib	r2, {r1, r2}
# CHECK-NEXT:  4      4     2.00    *                   ldmdb	r2, {r1, r2}
# CHECK-NEXT:  2      3     2.00    *                   ldmib	r2, {r1, r3}
# CHECK-NEXT:  4      4     4.00    *                   ldmib	r2, {r1, r3, r5}
# CHECK-NEXT:  8      5     4.00    *                   ldmib	r2, {r1, r2, r5}
# CHECK-NEXT:  4      4     2.00    *                   ldmdbeq	r2, {r1, r2}
# CHECK-NEXT:  2      3     2.00    *                   ldmibeq	r2, {r1, r3}
# CHECK-NEXT:  16     10    16.00   *                   ldm	r2, {r0, r1, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, sp, lr, pc}
# CHECK-NEXT:  32     11    16.00   *                   ldm	r2, {r0, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, sp, lr, pc}
# CHECK-NEXT:  1      1     1.00           *            str	r8, [r12]
# CHECK-NEXT:  1      1     1.00           *            str	r7, [r1, #12]
# CHECK-NEXT:  2      1     1.00           *            str	r3, [r5, #40]!
# CHECK-NEXT:  2      1     1.00           *            str	r9, [sp], #4095
# CHECK-NEXT:  2      1     1.00           *            str	r1, [r7], #-128
# CHECK-NEXT:  1      1     1.00           *            str	r9, [r6, r3]
# CHECK-NEXT:  1      1     1.00           *            str	r8, [r0, -r2]
# CHECK-NEXT:  2      1     1.00           *            str	r7, [r1, r6]!
# CHECK-NEXT:  2      2     1.00           *            str	r7, [r1, r6, lsl #2]!
# CHECK-NEXT:  2      1     1.00           *            str	r6, [sp, -r1]!
# CHECK-NEXT:  2      2     1.00           *            str	r5, [r3], r9
# CHECK-NEXT:  2      2     1.00           *            str	r4, [r2], -r5
# CHECK-NEXT:  1      1     1.00           *            str	r3, [r4, -r2, lsl #2]
# CHECK-NEXT:  2      2     1.00           *            str	r2, [r7], r3, asr #24
# CHECK-NEXT:  1      1     1.00           *            strb	r9, [r2]
# CHECK-NEXT:  1      1     1.00           *            strb	r7, [r1, #3]
# CHECK-NEXT:  2      1     1.00           *            strb	r6, [r4, #405]!
# CHECK-NEXT:  2      1     1.00           *            strb	r5, [r7], #72
# CHECK-NEXT:  2      1     1.00           *            strb	r1, [sp], #-1
# CHECK-NEXT:  1      1     1.00           *            strb	r1, [r2, r9]
# CHECK-NEXT:  1      1     1.00           *            strb	r2, [r3, -r8]
# CHECK-NEXT:  2      1     1.00           *            strb	r3, [r4, r7]!
# CHECK-NEXT:  2      1     1.00           *            strb	r4, [r5, -r6]!
# CHECK-NEXT:  2      2     1.00           *            strb	r5, [r6], r5
# CHECK-NEXT:  2      2     1.00           *            strb	r6, [r2], -r4
# CHECK-NEXT:  1      1     1.00           *            strb	r7, [r12, -r3, lsl #5]
# CHECK-NEXT:  2      2     1.00           *            strb	sp, [r7], r2, asr #12
# CHECK-NEXT:  2      1     1.00                  U     strbt	r6, [r2], #12
# CHECK-NEXT:  2      1     1.00                  U     strbt	r5, [r6], #-13
# CHECK-NEXT:  2      2     1.00                  U     strbt	r4, [r9], r5
# CHECK-NEXT:  2      2     1.00                  U     strbt	r3, [r8], -r2, lsl #3
# CHECK-NEXT:  1      1     1.00           *            strd	r0, r1, [r4]
# CHECK-NEXT:  1      1     1.00           *            strd	r2, r3, [r6, #1]
# CHECK-NEXT:  2      1     1.00           *            strd	r2, r3, [r7, #22]!
# CHECK-NEXT:  2      1     1.00           *            strd	r4, r5, [r8], #7
# CHECK-NEXT:  2      1     1.00           *            strd	r4, r5, [sp], #0
# CHECK-NEXT:  2      1     1.00           *            strd	r6, r7, [lr], #0
# CHECK-NEXT:  2      1     1.00           *            strd	r6, r7, [r9], #-0
# CHECK-NEXT:  1      1     1.00           *            strd	r8, r9, [r4, r1]
# CHECK-NEXT:  2      1     1.00           *            strd	r6, r7, [r3, r9]!
# CHECK-NEXT:  2      1     1.00           *            strd	r6, r7, [r5], r8
# CHECK-NEXT:  2      1     1.00           *            strd	r4, r5, [r12], -r10
# CHECK-NEXT:  1      1     1.00           *            strh	r3, [r4]
# CHECK-NEXT:  1      1     1.00           *            strh	r2, [r7, #4]
# CHECK-NEXT:  2      1     1.00                  U     strh	r1, [r8, #64]!
# CHECK-NEXT:  2      1     1.00           *            strh	r12, [sp], #4
# CHECK-NEXT:  1      1     1.00           *            strh	r6, [r5, r4]
# CHECK-NEXT:  2      1     1.00                  U     strh	r3, [r8, r11]!
# CHECK-NEXT:  2      1     1.00                  U     strh	r1, [r2, -r1]!
# CHECK-NEXT:  2      1     1.00           *            strh	r9, [r7], r2
# CHECK-NEXT:  2      1     1.00           *            strh	r4, [r3], -r2
# CHECK-NEXT:  2      1     1.00                  U     strht	r2, [r5], #76
# CHECK-NEXT:  2      1     1.00                  U     strht	r8, [r1], #-25
# CHECK-NEXT:  2      1     1.00                  U     strht	r5, [r3], r4
# CHECK-NEXT:  2      1     1.00                  U     strht	r6, [r8], -r0

# CHECK:      Resources:
# CHECK-NEXT: [0]   - A57UnitB
# CHECK-NEXT: [1.0] - A57UnitI
# CHECK-NEXT: [1.1] - A57UnitI
# CHECK-NEXT: [2]   - A57UnitL
# CHECK-NEXT: [3]   - A57UnitM
# CHECK-NEXT: [4]   - A57UnitS
# CHECK-NEXT: [5]   - A57UnitW
# CHECK-NEXT: [6]   - A57UnitX

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1.0]  [1.1]  [2]    [3]    [4]    [5]    [6]
# CHECK-NEXT:  -     63.00  63.00  160.00 9.00   55.00   -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1.0]  [1.1]  [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldr	r5, [r7]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldr	r6, [r3, #63]
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r2, [r4, #4095]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r1, [r2], #30
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r3, [r1], #-30
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldr	r3, [r8, r1]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldr	r2, [r5, -r3]
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r1, [r5, r9]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r6, [r7, -r8]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r1, [r0, r2, lsr #3]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r5, [r9], r2
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r4, [r3], -r6
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldr	r3, [r8, -r2, lsl #15]
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldr	r1, [r5], r3, asr #15
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrb	r3, [r8]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrb	r1, [sp, #63]
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r9, [r3, #4095]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r8, [r1], #22
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r2, [r7], #-19
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrb	r9, [r8, r5]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrb	r1, [r5, -r1]
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r3, [r5, r2]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r6, [r9, -r3]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r2, [r1], r4
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r8, [r4], -r5
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrb	r7, [r12, -r1, lsl #15]
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrb	r5, [r2], r9, asr #15
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrbt	r3, [r1], #4
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrbt	r2, [r8], #-8
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrbt	r8, [r7], r6
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrbt	r1, [r2], -r6, lsl #12
# CHECK-NEXT:  -      -      -     2.00    -      -      -      -     ldrd	r0, r1, [r5]
# CHECK-NEXT:  -      -      -     2.00    -      -      -      -     ldrd	r8, r9, [r2, #15]
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r2, r3, [r9, #32]!
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r6, r7, [r1], #8
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r2, r3, [r8], #0
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r2, r3, [r8], #0
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r2, r3, [r8], #-0
# CHECK-NEXT:  -      -      -     2.00    -      -      -      -     ldrd	r4, r5, [r1, r3]
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r4, r5, [r7, r2]!
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r0, r1, [r8], r12
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldrd	r0, r1, [r8], -r12
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrh	r3, [r4]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrh	r2, [r7, #4]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrh	r1, [r8, #64]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrh	r12, [sp], #4
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrh	r6, [r5, r4]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrh	r3, [r8, r11]!
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrh	r1, [r2, -r1]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrh	r9, [r7], r2
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrh	r4, [r3], -r2
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrht	r9, [r7], #128
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrht	r4, [r3], #-75
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrht	r9, [r7], r2
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrht	r4, [r3], -r2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsb	r3, [r4]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsb	r2, [r7, #17]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsb	r1, [r8, #255]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsb	r12, [sp], #9
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsb	r6, [r5, r4]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsb	r3, [r8, r11]!
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsb	r1, [r2, -r1]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsb	r9, [r7], r2
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsb	r4, [r3], -r2
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsbt	r5, [r6], #1
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsbt	r3, [r8], #-12
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsbt	r8, [r9], r5
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsbt	r2, [r1], -r4
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsh	r5, [r9]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsh	r4, [r5, #7]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsh	r3, [r6, #55]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsh	r2, [r7], #-9
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsh	r3, [r1, r5]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsh	r4, [r6, r1]!
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ldrsh	r5, [r3, -r6]!
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsh	r6, [r9], r8
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsh	r7, [r8], -r3
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsht	r5, [r6], #1
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsht	r3, [r8], #-12
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsht	r8, [r9], r5
# CHECK-NEXT:  -     0.50   0.50   1.00    -      -      -      -     ldrsht	r2, [r1], -r4
# CHECK-NEXT:  -     3.00   3.00   6.00    -      -      -      -     ldm	r2, {r1, r2, r4, r5, r6}
# CHECK-NEXT:  -     3.00   3.00   6.00    -      -      -      -     ldm	r2, {r1, r2, r4, r5, r6}
# CHECK-NEXT:  -      -      -     6.00    -      -      -      -     ldm	r2, {r1, r3, r4, r5, r6}
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldmib	r2, {r1, r2}
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldmdb	r2, {r1, r2}
# CHECK-NEXT:  -      -      -     2.00    -      -      -      -     ldmib	r2, {r1, r3}
# CHECK-NEXT:  -      -      -     4.00    -      -      -      -     ldmib	r2, {r1, r3, r5}
# CHECK-NEXT:  -     2.00   2.00   4.00    -      -      -      -     ldmib	r2, {r1, r2, r5}
# CHECK-NEXT:  -     1.00   1.00   2.00    -      -      -      -     ldmdbeq	r2, {r1, r2}
# CHECK-NEXT:  -      -      -     2.00    -      -      -      -     ldmibeq	r2, {r1, r3}
# CHECK-NEXT:  -      -      -     16.00   -      -      -      -     ldm	r2, {r0, r1, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, sp, lr, pc}
# CHECK-NEXT:  -     8.00   8.00   16.00   -      -      -      -     ldm	r2, {r0, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, sp, lr, pc}
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     str	r8, [r12]
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     str	r7, [r1, #12]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     str	r3, [r5, #40]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     str	r9, [sp], #4095
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     str	r1, [r7], #-128
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     str	r9, [r6, r3]
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     str	r8, [r0, -r2]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     str	r7, [r1, r6]!
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     str	r7, [r1, r6, lsl #2]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     str	r6, [sp, -r1]!
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     str	r5, [r3], r9
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     str	r4, [r2], -r5
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     str	r3, [r4, -r2, lsl #2]
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     str	r2, [r7], r3, asr #24
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strb	r9, [r2]
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strb	r7, [r1, #3]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strb	r6, [r4, #405]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strb	r5, [r7], #72
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strb	r1, [sp], #-1
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strb	r1, [r2, r9]
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strb	r2, [r3, -r8]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strb	r3, [r4, r7]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strb	r4, [r5, -r6]!
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     strb	r5, [r6], r5
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     strb	r6, [r2], -r4
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strb	r7, [r12, -r3, lsl #5]
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     strb	sp, [r7], r2, asr #12
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strbt	r6, [r2], #12
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strbt	r5, [r6], #-13
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     strbt	r4, [r9], r5
# CHECK-NEXT:  -      -      -      -     1.00   1.00    -      -     strbt	r3, [r8], -r2, lsl #3
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strd	r0, r1, [r4]
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strd	r2, r3, [r6, #1]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r2, r3, [r7, #22]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r4, r5, [r8], #7
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r4, r5, [sp], #0
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r6, r7, [lr], #0
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r6, r7, [r9], #-0
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strd	r8, r9, [r4, r1]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r6, r7, [r3, r9]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r6, r7, [r5], r8
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strd	r4, r5, [r12], -r10
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strh	r3, [r4]
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strh	r2, [r7, #4]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strh	r1, [r8, #64]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strh	r12, [sp], #4
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     strh	r6, [r5, r4]
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strh	r3, [r8, r11]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strh	r1, [r2, -r1]!
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strh	r9, [r7], r2
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strh	r4, [r3], -r2
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strht	r2, [r5], #76
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strht	r8, [r1], #-25
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strht	r5, [r3], r4
# CHECK-NEXT:  -     0.50   0.50    -      -     1.00    -      -     strht	r6, [r8], -r0
