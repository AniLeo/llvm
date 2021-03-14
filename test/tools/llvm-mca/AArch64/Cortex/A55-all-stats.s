# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64 -mcpu=cortex-a55 --all-stats --iterations=2 < %s | FileCheck %s

ldr	w4, [x2], #4
ldr	w5, [x3]
madd	w0, w5, w4, w0
add	x3, x3, x13
subs	x1, x1, #1
str	w0, [x21, x18, lsl #2]

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      12
# CHECK-NEXT: Total Cycles:      20
# CHECK-NEXT: Total uOps:        14

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.70
# CHECK-NEXT: IPC:               0.60
# CHECK-NEXT: Block RThroughput: 3.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      3     1.00    *                   ldr	w4, [x2], #4
# CHECK-NEXT:  1      3     1.00    *                   ldr	w5, [x3]
# CHECK-NEXT:  1      4     1.00                        madd	w0, w5, w4, w0
# CHECK-NEXT:  1      3     0.50                        add	x3, x3, x13
# CHECK-NEXT:  1      3     0.50                        subs	x1, x1, #1
# CHECK-NEXT:  1      4     1.00           *            str	w0, [x21, x18, lsl #2]

# CHECK:      Dynamic Dispatch Stall Cycles:
# CHECK-NEXT: RAT     - Register unavailable:                      8  (40.0%)
# CHECK-NEXT: RCU     - Retire tokens unavailable:                 0
# CHECK-NEXT: SCHEDQ  - Scheduler full:                            0
# CHECK-NEXT: LQ      - Load queue full:                           0
# CHECK-NEXT: SQ      - Store queue full:                          0
# CHECK-NEXT: GROUP   - Static restrictions on the dispatch group: 0

# CHECK:      Dispatch Logic - number of cycles where we saw N micro opcodes dispatched:
# CHECK-NEXT: [# dispatched], [# cycles]
# CHECK-NEXT:  0,              10  (50.0%)
# CHECK-NEXT:  1,              6  (30.0%)
# CHECK-NEXT:  2,              4  (20.0%)

# CHECK:      Schedulers - number of cycles where we saw N micro opcodes issued:
# CHECK-NEXT: [# issued], [# cycles]
# CHECK-NEXT:  0,          10  (50.0%)
# CHECK-NEXT:  1,          6  (30.0%)
# CHECK-NEXT:  2,          4  (20.0%)

# CHECK:      Scheduler's queue usage:
# CHECK-NEXT: No scheduler resources used.

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    14
# CHECK-NEXT: Max number of mappings used:         4

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
# CHECK-NEXT: 1.00   1.00    -      -      -      -      -      -      -     2.00   1.00   1.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3.0]  [3.1]  [4]    [5.0]  [5.1]  [6]    [7]    [8]    Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -     ldr	w4, [x2], #4
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -     ldr	w5, [x3]
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     madd	w0, w5, w4, w0
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -      -      -      -      -     add	x3, x3, x13
# CHECK-NEXT: 1.00    -      -      -      -      -      -      -      -      -      -      -     subs	x1, x1, #1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -     1.00   str	w0, [x21, x18, lsl #2]
