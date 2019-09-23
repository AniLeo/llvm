# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64-linux-gnu -mcpu=exynos-m3 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M3
# RUN: llvm-mca -mtriple=aarch64-linux-gnu -mcpu=exynos-m4 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M4
# RUN: llvm-mca -mtriple=aarch64-linux-gnu -mcpu=exynos-m5 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M5

ld2	{v0.s, v1.s}[0], [sp]
ld2r	{v0.2s, v1.2s}, [sp]
ld2	{v0.2s, v1.2s}, [sp]

ld2	{v0.d, v1.d}[0], [sp]
ld2r	{v0.2d, v1.2d}, [sp]
ld2	{v0.2d, v1.2d}, [sp]

ld2	{v0.s, v1.s}[0], [sp], #8
ld2r	{v0.2s, v1.2s}, [sp], #8
ld2	{v0.2s, v1.2s}, [sp], #16

ld2	{v0.d, v1.d}[0], [sp], #16
ld2r	{v0.2d, v1.2d}, [sp], #16
ld2	{v0.2d, v1.2d}, [sp], #32

ld2	{v0.s, v1.s}[0], [sp], x0
ld2r	{v0.2s, v1.2s}, [sp], x0
ld2	{v0.2s, v1.2s}, [sp], x0

ld2	{v0.d, v1.d}[0], [sp], x0
ld2r	{v0.2d, v1.2d}, [sp], x0
ld2	{v0.2d, v1.2d}, [sp], x0

# ALL:      Iterations:        100
# ALL-NEXT: Instructions:      1800

# M3-NEXT:  Total Cycles:      10003
# M4-NEXT:  Total Cycles:      9803
# M5-NEXT:  Total Cycles:      11103

# ALL-NEXT: Total uOps:        5400

# ALL:      Dispatch Width:    6

# M3-NEXT:  uOps Per Cycle:    0.54
# M3-NEXT:  IPC:               0.18
# M3-NEXT:  Block RThroughput: 42.0

# M4-NEXT:  uOps Per Cycle:    0.55
# M4-NEXT:  IPC:               0.18
# M4-NEXT:  Block RThroughput: 30.0

# M5-NEXT:  uOps Per Cycle:    0.49
# M5-NEXT:  IPC:               0.16
# M5-NEXT:  Block RThroughput: 45.0

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:

# M3-NEXT:   3      7     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp]
# M3-NEXT:   2      5     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp]
# M3-NEXT:   2      10    5.00    *                   ld2	{ v0.2s, v1.2s }, [sp]
# M3-NEXT:   3      6     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp]
# M3-NEXT:   2      5     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp]
# M3-NEXT:   2      10    5.00    *                   ld2	{ v0.2d, v1.2d }, [sp]
# M3-NEXT:   4      7     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp], #8
# M3-NEXT:   3      5     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp], #8
# M3-NEXT:   3      10    5.00    *                   ld2	{ v0.2s, v1.2s }, [sp], #16
# M3-NEXT:   4      6     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp], #16
# M3-NEXT:   3      5     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp], #16
# M3-NEXT:   3      10    5.00    *                   ld2	{ v0.2d, v1.2d }, [sp], #32
# M3-NEXT:   4      7     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp], x0
# M3-NEXT:   3      5     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp], x0
# M3-NEXT:   3      10    5.00    *                   ld2	{ v0.2s, v1.2s }, [sp], x0
# M3-NEXT:   4      6     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp], x0
# M3-NEXT:   3      5     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp], x0
# M3-NEXT:   3      10    5.00    *                   ld2	{ v0.2d, v1.2d }, [sp], x0

# M4-NEXT:   3      6     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp]
# M4-NEXT:   2      5     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp]
# M4-NEXT:   2      10    3.00    *                   ld2	{ v0.2s, v1.2s }, [sp]
# M4-NEXT:   3      6     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp]
# M4-NEXT:   2      5     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp]
# M4-NEXT:   2      10    3.00    *                   ld2	{ v0.2d, v1.2d }, [sp]
# M4-NEXT:   4      6     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp], #8
# M4-NEXT:   3      5     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp], #8
# M4-NEXT:   3      10    3.00    *                   ld2	{ v0.2s, v1.2s }, [sp], #16
# M4-NEXT:   4      6     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp], #16
# M4-NEXT:   3      5     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp], #16
# M4-NEXT:   3      10    3.00    *                   ld2	{ v0.2d, v1.2d }, [sp], #32
# M4-NEXT:   4      6     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp], x0
# M4-NEXT:   3      5     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp], x0
# M4-NEXT:   3      10    3.00    *                   ld2	{ v0.2s, v1.2s }, [sp], x0
# M4-NEXT:   4      6     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp], x0
# M4-NEXT:   3      5     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp], x0
# M4-NEXT:   3      10    3.00    *                   ld2	{ v0.2d, v1.2d }, [sp], x0

# M5-NEXT:   3      7     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp]
# M5-NEXT:   2      6     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp]
# M5-NEXT:   2      11    5.50    *                   ld2	{ v0.2s, v1.2s }, [sp]
# M5-NEXT:   3      7     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp]
# M5-NEXT:   2      6     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp]
# M5-NEXT:   2      11    5.50    *                   ld2	{ v0.2d, v1.2d }, [sp]
# M5-NEXT:   4      7     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp], #8
# M5-NEXT:   3      6     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp], #8
# M5-NEXT:   3      11    5.50    *                   ld2	{ v0.2s, v1.2s }, [sp], #16
# M5-NEXT:   4      7     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp], #16
# M5-NEXT:   3      6     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp], #16
# M5-NEXT:   3      11    5.50    *                   ld2	{ v0.2d, v1.2d }, [sp], #32
# M5-NEXT:   4      7     1.00    *                   ld2	{ v0.s, v1.s }[0], [sp], x0
# M5-NEXT:   3      6     1.00    *                   ld2r	{ v0.2s, v1.2s }, [sp], x0
# M5-NEXT:   3      11    5.50    *                   ld2	{ v0.2s, v1.2s }, [sp], x0
# M5-NEXT:   4      7     1.00    *                   ld2	{ v0.d, v1.d }[0], [sp], x0
# M5-NEXT:   3      6     1.00    *                   ld2r	{ v0.2d, v1.2d }, [sp], x0
# M5-NEXT:   3      11    5.50    *                   ld2	{ v0.2d, v1.2d }, [sp], x0
