# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m3 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,EM3
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m4 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,EM4

  adds	w0, w1, w2, lsl #0
  sub	x3, x4, x5, lsr #1
  ands	x6, x7, x8, lsl #2
  orr	w9, w10, w11, asr #3
  adds	w12, w13, w14, lsl #4
  sub	x15, x16, x17, lsr #6
  ands	x18, x19, x20, lsl #8
  orr	w21, w22, w23, asr #10

# ALL:      Iterations:        100
# ALL-NEXT: Instructions:      800

# EM3-NEXT: Total Cycles:      354
# EM4-NEXT: Total Cycles:      329

# ALL-NEXT: Total uOps:        800

# EM3:      Dispatch Width:    6
# EM3-NEXT: uOps Per Cycle:    2.26
# EM3-NEXT: IPC:               2.26
# EM3-NEXT: Block RThroughput: 3.5

# EM4:      Dispatch Width:    6
# EM4-NEXT: uOps Per Cycle:    2.43
# EM4-NEXT: IPC:               2.43
# EM4-NEXT: Block RThroughput: 3.3

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:

# EM3-NEXT:  1      1     0.25                        adds	w0, w1, w2
# EM3-NEXT:  1      2     0.50                        sub	x3, x4, x5, lsr #1
# EM3-NEXT:  1      1     0.25                        ands	x6, x7, x8, lsl #2
# EM3-NEXT:  1      2     0.50                        orr	w9, w10, w11, asr #3
# EM3-NEXT:  1      2     0.50                        adds	w12, w13, w14, lsl #4
# EM3-NEXT:  1      2     0.50                        sub	x15, x16, x17, lsr #6
# EM3-NEXT:  1      2     0.50                        ands	x18, x19, x20, lsl #8
# EM3-NEXT:  1      2     0.50                        orr	w21, w22, w23, asr #10

# EM4-NEXT:  1      1     0.25                        adds	w0, w1, w2
# EM4-NEXT:  1      2     0.50                        sub	x3, x4, x5, lsr #1
# EM4-NEXT:  1      1     0.25                        ands	x6, x7, x8, lsl #2
# EM4-NEXT:  1      2     0.50                        orr	w9, w10, w11, asr #3
# EM4-NEXT:  1      2     0.50                        adds	w12, w13, w14, lsl #4
# EM4-NEXT:  1      2     0.50                        sub	x15, x16, x17, lsr #6
# EM4-NEXT:  1      1     0.25                        ands	x18, x19, x20, lsl #8
# EM4-NEXT:  1      2     0.50                        orr	w21, w22, w23, asr #10
