# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m3 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,EM3
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m4 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,EM4
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m5 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,EM5

scvtf	h0, w0
scvtf	s1, w1
scvtf	d2, x2

fcvtzs	w3, h3
fcvtzs	w4, s4
fcvtzs	x5, d5

fmov	h6, #2.0
fmov	s7, #4.0
fmov	d8, #8.0

fmov	h9, w9
fmov	s10, w10
fmov	d11, x11
fmov	v12.d[1], x12

fmov	w13, h13
fmov	w14, s14
fmov	x15, d15
fmov	x16, v16.d[1]

# ALL:      Iterations:        100

# EM3-NEXT: Instructions:      1200
# EM3-NEXT: Total Cycles:      405
# EM3-NEXT: Total uOps:        1400

# EM4-NEXT: Instructions:      1700
# EM4-NEXT: Total Cycles:      1108
# EM4-NEXT: Total uOps:        1900

# EM5-NEXT: Instructions:      1700
# EM5-NEXT: Total Cycles:      1407
# EM5-NEXT: Total uOps:        1900

# ALL:      Dispatch Width:    6

# EM3-NEXT: uOps Per Cycle:    3.46
# EM3-NEXT: IPC:               2.96
# EM3-NEXT: Block RThroughput: 4.0

# EM4-NEXT: uOps Per Cycle:    1.71
# EM4-NEXT: IPC:               1.53
# EM4-NEXT: Block RThroughput: 11.0

# EM5-NEXT: uOps Per Cycle:    1.35
# EM5-NEXT: IPC:               1.21
# EM5-NEXT: Block RThroughput: 14.0

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# EM3:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# EM3-NEXT:  1      4     1.00                        scvtf	s1, w1
# EM3-NEXT:  1      4     1.00                        scvtf	d2, x2
# EM3-NEXT:  1      3     1.00                        fcvtzs	w4, s4
# EM3-NEXT:  1      3     1.00                        fcvtzs	x5, d5
# EM3-NEXT:  1      1     0.33                        fmov	s7, #4.00000000
# EM3-NEXT:  1      1     0.33                        fmov	d8, #8.00000000
# EM3-NEXT:  1      1     0.33                        fmov	s10, w10
# EM3-NEXT:  1      1     0.33                        fmov	d11, x11
# EM3-NEXT:  2      5     1.00                        fmov	v12.d[1], x12
# EM3-NEXT:  1      1     0.33                        fmov	w14, s14
# EM3-NEXT:  1      1     0.33                        fmov	x15, d15
# EM3-NEXT:  2      5     1.00                        fmov	x16, v16.d[1]

# EM4:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# EM4-NEXT:  1      6     1.00                        scvtf	h0, w0
# EM4-NEXT:  1      6     1.00                        scvtf	s1, w1
# EM4-NEXT:  1      6     1.00                        scvtf	d2, x2
# EM4-NEXT:  1      4     1.00                        fcvtzs	w3, h3
# EM4-NEXT:  1      4     1.00                        fcvtzs	w4, s4
# EM4-NEXT:  1      4     1.00                        fcvtzs	x5, d5
# EM4-NEXT:  1      1     0.33                        fmov	h6, #2.00000000
# EM4-NEXT:  1      1     0.33                        fmov	s7, #4.00000000
# EM4-NEXT:  1      1     0.33                        fmov	d8, #8.00000000
# EM4-NEXT:  1      3     1.00                        fmov	h9, w9
# EM4-NEXT:  1      3     1.00                        fmov	s10, w10
# EM4-NEXT:  1      3     1.00                        fmov	d11, x11
# EM4-NEXT:  2      2     1.00                        fmov	v12.d[1], x12
# EM4-NEXT:  1      4     1.00                        fmov	w13, h13
# EM4-NEXT:  1      4     1.00                        fmov	w14, s14
# EM4-NEXT:  1      4     1.00                        fmov	x15, d15
# EM4-NEXT:  2      5     1.00                        fmov	x16, v16.d[1]

# EM5:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# EM5-NEXT:  1      6     1.00                        scvtf	h0, w0
# EM5-NEXT:  1      6     1.00                        scvtf	s1, w1
# EM5-NEXT:  1      6     1.00                        scvtf	d2, x2
# EM5-NEXT:  1      4     1.00                        fcvtzs	w3, h3
# EM5-NEXT:  1      4     1.00                        fcvtzs	w4, s4
# EM5-NEXT:  1      4     1.00                        fcvtzs	x5, d5
# EM5-NEXT:  1      1     0.33                        fmov	h6, #2.00000000
# EM5-NEXT:  1      1     0.33                        fmov	s7, #4.00000000
# EM5-NEXT:  1      1     0.33                        fmov	d8, #8.00000000
# EM5-NEXT:  1      4     1.00                        fmov	h9, w9
# EM5-NEXT:  1      4     1.00                        fmov	s10, w10
# EM5-NEXT:  1      4     1.00                        fmov	d11, x11
# EM5-NEXT:  2      6     1.00                        fmov	v12.d[1], x12
# EM5-NEXT:  1      3     1.00                        fmov	w13, h13
# EM5-NEXT:  1      3     1.00                        fmov	w14, s14
# EM5-NEXT:  1      3     1.00                        fmov	x15, d15
# EM5-NEXT:  2      5     1.00                        fmov	x16, v16.d[1]
