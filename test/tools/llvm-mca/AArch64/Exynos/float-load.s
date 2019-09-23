# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m3 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M3
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m4 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M4
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m5 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M5

ldr	s0, 1f
ldr	q0, 1f

ldur	d0, [sp, #2]
ldur	q0, [sp, #16]

ldr	b0, [sp], #1
ldr	q0, [sp], #16

ldr	h0, [sp, #2]!
ldr	q0, [sp, #16]!

ldr	s0, [sp, #4]
ldr	q0, [sp, #16]

ldr	d0, [sp, x0, lsl #3]
ldr	q0, [sp, x0, lsl #4]

ldr	b0, [sp, x0]
ldr	q0, [sp, x0]

ldr	h0, [sp, w0, sxtw #1]
ldr	q0, [sp, w0, uxtw #4]

ldr	s0, [sp, w0, sxtw]
ldr	q0, [sp, w0, uxtw]

ldp	d0, d1, [sp], #16
ldp	q0, q1, [sp], #32

ldp	s0, s1, [sp, #8]!
ldp	q0, q1, [sp, #32]!

ldp	d0, d1, [sp, #16]
ldp	q0, q1, [sp, #32]

1:

# ALL:      Iterations:        100
# ALL-NEXT: Instructions:      2400

# M3-NEXT:  Total Cycles:      4708
# M3-NEXT:  Total uOps:        3200

# M4-NEXT:  Total Cycles:      4708
# M4-NEXT:  Total uOps:        3200

# M5-NEXT:  Total Cycles:      5509
# M5-NEXT:  Total uOps:        3300

# ALL:      Dispatch Width:    6

# M3-NEXT:  uOps Per Cycle:    0.68
# M3-NEXT:  IPC:               0.51
# M3-NEXT:  Block RThroughput: 13.5

# M4-NEXT:  uOps Per Cycle:    0.68
# M4-NEXT:  IPC:               0.51
# M4-NEXT:  Block RThroughput: 13.0

# M5-NEXT:  uOps Per Cycle:    0.60
# M5-NEXT:  IPC:               0.44
# M5-NEXT:  Block RThroughput: 13.5

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:

# M3-NEXT:   1      5     0.50    *                   ldr	s0, {{\.?}}Ltmp0
# M3-NEXT:   1      5     0.50    *                   ldr	q0, {{\.?}}Ltmp0
# M3-NEXT:   1      5     0.50    *                   ldur	d0, [sp, #2]
# M3-NEXT:   1      5     0.50    *                   ldur	q0, [sp, #16]
# M3-NEXT:   1      5     0.50    *                   ldr	b0, [sp], #1
# M3-NEXT:   1      5     0.50    *                   ldr	q0, [sp], #16
# M3-NEXT:   1      5     0.50    *                   ldr	h0, [sp, #2]!
# M3-NEXT:   1      5     0.50    *                   ldr	q0, [sp, #16]!
# M3-NEXT:   1      5     0.50    *                   ldr	s0, [sp, #4]
# M3-NEXT:   1      5     0.50    *                   ldr	q0, [sp, #16]
# M3-NEXT:   1      5     0.50    *                   ldr	d0, [sp, x0, lsl #3]
# M3-NEXT:   2      6     0.50    *                   ldr	q0, [sp, x0, lsl #4]
# M3-NEXT:   1      5     0.50    *                   ldr	b0, [sp, x0]
# M3-NEXT:   1      5     0.50    *                   ldr	q0, [sp, x0]
# M3-NEXT:   2      6     0.50    *                   ldr	h0, [sp, w0, sxtw #1]
# M3-NEXT:   2      6     0.50    *                   ldr	q0, [sp, w0, uxtw #4]
# M3-NEXT:   2      6     0.50    *                   ldr	s0, [sp, w0, sxtw]
# M3-NEXT:   1      5     0.50    *                   ldr	q0, [sp, w0, uxtw]
# M3-NEXT:   2      5     0.50    *                   ldp	d0, d1, [sp], #16
# M3-NEXT:   2      5     1.00    *                   ldp	q0, q1, [sp], #32
# M3-NEXT:   2      5     0.50    *                   ldp	s0, s1, [sp, #8]!
# M3-NEXT:   2      5     1.00    *                   ldp	q0, q1, [sp, #32]!
# M3-NEXT:   1      5     0.50    *                   ldp	d0, d1, [sp, #16]
# M3-NEXT:   1      5     1.00    *                   ldp	q0, q1, [sp, #32]

# M4-NEXT:   1      5     0.50    *                   ldr	s0, {{\.?}}Ltmp0
# M4-NEXT:   1      5     0.50    *                   ldr	q0, {{\.?}}Ltmp0
# M4-NEXT:   1      5     0.50    *                   ldur	d0, [sp, #2]
# M4-NEXT:   1      5     0.50    *                   ldur	q0, [sp, #16]
# M4-NEXT:   1      5     0.50    *                   ldr	b0, [sp], #1
# M4-NEXT:   1      5     0.50    *                   ldr	q0, [sp], #16
# M4-NEXT:   1      5     0.50    *                   ldr	h0, [sp, #2]!
# M4-NEXT:   1      5     0.50    *                   ldr	q0, [sp, #16]!
# M4-NEXT:   1      5     0.50    *                   ldr	s0, [sp, #4]
# M4-NEXT:   1      5     0.50    *                   ldr	q0, [sp, #16]
# M4-NEXT:   1      5     0.50    *                   ldr	d0, [sp, x0, lsl #3]
# M4-NEXT:   2      6     0.50    *                   ldr	q0, [sp, x0, lsl #4]
# M4-NEXT:   1      5     0.50    *                   ldr	b0, [sp, x0]
# M4-NEXT:   1      5     0.50    *                   ldr	q0, [sp, x0]
# M4-NEXT:   2      6     0.50    *                   ldr	h0, [sp, w0, sxtw #1]
# M4-NEXT:   2      6     0.50    *                   ldr	q0, [sp, w0, uxtw #4]
# M4-NEXT:   2      6     0.50    *                   ldr	s0, [sp, w0, sxtw]
# M4-NEXT:   2      6     0.50    *                   ldr	q0, [sp, w0, uxtw]
# M4-NEXT:   1      5     0.50    *                   ldp	d0, d1, [sp], #16
# M4-NEXT:   2      5     0.50    *                   ldp	q0, q1, [sp], #32
# M4-NEXT:   2      5     0.50    *                   ldp	s0, s1, [sp, #8]!
# M4-NEXT:   2      5     1.00    *                   ldp	q0, q1, [sp, #32]!
# M4-NEXT:   1      5     0.50    *                   ldp	d0, d1, [sp, #16]
# M4-NEXT:   1      5     1.00    *                   ldp	q0, q1, [sp, #32]

# M5-NEXT:   1      6     0.50    *                   ldr	s0, {{\.?}}Ltmp0
# M5-NEXT:   1      6     0.50    *                   ldr	q0, {{\.?}}Ltmp0
# M5-NEXT:   1      6     0.50    *                   ldur	d0, [sp, #2]
# M5-NEXT:   1      6     0.50    *                   ldur	q0, [sp, #16]
# M5-NEXT:   1      6     0.50    *                   ldr	b0, [sp], #1
# M5-NEXT:   1      6     0.50    *                   ldr	q0, [sp], #16
# M5-NEXT:   1      6     0.50    *                   ldr	h0, [sp, #2]!
# M5-NEXT:   1      6     0.50    *                   ldr	q0, [sp, #16]!
# M5-NEXT:   1      6     0.50    *                   ldr	s0, [sp, #4]
# M5-NEXT:   1      6     0.50    *                   ldr	q0, [sp, #16]
# M5-NEXT:   1      6     0.50    *                   ldr	d0, [sp, x0, lsl #3]
# M5-NEXT:   2      7     0.50    *                   ldr	q0, [sp, x0, lsl #4]
# M5-NEXT:   1      6     0.50    *                   ldr	b0, [sp, x0]
# M5-NEXT:   1      6     0.50    *                   ldr	q0, [sp, x0]
# M5-NEXT:   2      7     0.50    *                   ldr	h0, [sp, w0, sxtw #1]
# M5-NEXT:   2      7     0.50    *                   ldr	q0, [sp, w0, uxtw #4]
# M5-NEXT:   2      7     0.50    *                   ldr	s0, [sp, w0, sxtw]
# M5-NEXT:   2      7     0.50    *                   ldr	q0, [sp, w0, uxtw]
# M5-NEXT:   2      6     0.50    *                   ldp	d0, d1, [sp], #16
# M5-NEXT:   2      6     1.00    *                   ldp	q0, q1, [sp], #32
# M5-NEXT:   2      6     0.50    *                   ldp	s0, s1, [sp, #8]!
# M5-NEXT:   2      6     1.00    *                   ldp	q0, q1, [sp, #32]!
# M5-NEXT:   1      6     0.50    *                   ldp	d0, d1, [sp, #16]
# M5-NEXT:   1      6     1.00    *                   ldp	q0, q1, [sp, #32]
