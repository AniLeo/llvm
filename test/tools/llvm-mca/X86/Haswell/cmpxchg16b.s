# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=haswell -timeline -timeline-max-iterations=3 -dispatch-stats < %s | FileCheck %s

cmpxchg16b (%rsi)

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      100
# CHECK-NEXT: Total Cycles:      2203
# CHECK-NEXT: Total uOps:        1900

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.86
# CHECK-NEXT: IPC:               0.05
# CHECK-NEXT: Block RThroughput: 4.8

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  19     22    4.00    *      *            cmpxchg16b	(%rsi)

# CHECK:      Dynamic Dispatch Stall Cycles:
# CHECK-NEXT: RAT     - Register unavailable:                      0
# CHECK-NEXT: RCU     - Retire tokens unavailable:                 1487  (67.5%)
# CHECK-NEXT: SCHEDQ  - Scheduler full:                            0
# CHECK-NEXT: LQ      - Load queue full:                           0
# CHECK-NEXT: SQ      - Store queue full:                          0
# CHECK-NEXT: GROUP   - Static restrictions on the dispatch group: 0

# CHECK:      Dispatch Logic - number of cycles where we saw N micro opcodes dispatched:
# CHECK-NEXT: [# dispatched], [# cycles]
# CHECK-NEXT:  0,              1703  (77.3%)
# CHECK-NEXT:  3,              100  (4.5%)
# CHECK-NEXT:  4,              400  (18.2%)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - HWDivider
# CHECK-NEXT: [1]   - HWFPDivider
# CHECK-NEXT: [2]   - HWPort0
# CHECK-NEXT: [3]   - HWPort1
# CHECK-NEXT: [4]   - HWPort2
# CHECK-NEXT: [5]   - HWPort3
# CHECK-NEXT: [6]   - HWPort4
# CHECK-NEXT: [7]   - HWPort5
# CHECK-NEXT: [8]   - HWPort6
# CHECK-NEXT: [9]   - HWPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     2.00   6.00   0.66   0.67   1.00   4.00   4.00   0.67

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -     2.00   6.00   0.66   0.67   1.00   4.00   4.00   0.67   cmpxchg16b	(%rsi)

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789          0123456789
# CHECK-NEXT: Index     0123456789          0123456789          0123456789          012345678

# CHECK:      [0,0]     DeeeeeeeeeeeeeeeeeeeeeeER.    .    .    .    .    .    .    .    .  .   cmpxchg16b	(%rsi)
# CHECK-NEXT: [1,0]     .    D=================eeeeeeeeeeeeeeeeeeeeeeER   .    .    .    .  .   cmpxchg16b	(%rsi)
# CHECK-NEXT: [2,0]     .    .    D==================================eeeeeeeeeeeeeeeeeeeeeeER   cmpxchg16b	(%rsi)

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     18.0   0.3    0.0       cmpxchg16b	(%rsi)
