# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64 -mcpu=cortex-a55 -timeline --iterations=5 -noalias=false < %s | FileCheck %s

# PR50483: Execution of loads and stores should not overlap if flag -noalias is set to false.

str x1, [x4]
ldr x2, [x4]

# CHECK:      Iterations:        5
# CHECK-NEXT: Instructions:      10
# CHECK-NEXT: Total Cycles:      9
# CHECK-NEXT: Total uOps:        10

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    1.11
# CHECK-NEXT: IPC:               1.11
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      4     1.00           *            str	x1, [x4]
# CHECK-NEXT:  1      3     1.00    *                   ldr	x2, [x4]

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - CortexA55UnitALU
# CHECK-NEXT: [0.1] - CortexA55UnitALU
# CHECK-NEXT: [1]   - CortexA55UnitB
# CHECK-NEXT: [2]   - CortexA55UnitDiv
# CHECK-NEXT: [3.0] - CortexA55UnitFPALU
# CHECK-NEXT: [3.1] - CortexA55UnitFPALU
# CHECK-NEXT: [4]   - CortexA55UnitFPDIV
# CHECK-NEXT: [5.0] - CortexA55UnitFPMAC
# CHECK-NEXT: [5.1] - CortexA55UnitFPMAC
# CHECK-NEXT: [6]   - CortexA55UnitLd
# CHECK-NEXT: [7]   - CortexA55UnitMAC
# CHECK-NEXT: [8]   - CortexA55UnitSt

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3.0]  [3.1]  [4]    [5.0]  [5.1]  [6]    [7]    [8]
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -     1.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3.0]  [3.1]  [4]    [5.0]  [5.1]  [6]    [7]    [8]    Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -     1.00   str	x1, [x4]
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -     ldr	x2, [x4]

# CHECK:      Timeline view:
# CHECK-NEXT: Index     012345678

# CHECK:      [0,0]     DeeeE.  .   str	x1, [x4]
# CHECK-NEXT: [0,1]     .DeeE.  .   ldr	x2, [x4]
# CHECK-NEXT: [1,0]     .DeeeE  .   str	x1, [x4]
# CHECK-NEXT: [1,1]     . DeeE  .   ldr	x2, [x4]
# CHECK-NEXT: [2,0]     . DeeeE .   str	x1, [x4]
# CHECK-NEXT: [2,1]     .  DeeE .   ldr	x2, [x4]
# CHECK-NEXT: [3,0]     .  DeeeE.   str	x1, [x4]
# CHECK-NEXT: [3,1]     .   DeeE.   ldr	x2, [x4]
# CHECK-NEXT: [4,0]     .   DeeeE   str	x1, [x4]
# CHECK-NEXT: [4,1]     .    DeeE   ldr	x2, [x4]

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     5     0.0    0.0    0.0       str	x1, [x4]
# CHECK-NEXT: 1.     5     0.0    0.0    0.0       ldr	x2, [x4]
# CHECK-NEXT:        5     0.0    0.0    0.0       <total>
