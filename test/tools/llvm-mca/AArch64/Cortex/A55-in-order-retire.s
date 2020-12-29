# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64 -mcpu=cortex-a55 --all-stats --all-views --iterations=2 < %s | FileCheck %s

sdiv	w12, w21, w0
add	w8, w8, #1
add	w1, w2, w0
add	w3, w4, #1
add	w5, w6, w0
add	w7, w9, w0

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      12
# CHECK-NEXT: Total Cycles:      18
# CHECK-NEXT: Total uOps:        12

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.67
# CHECK-NEXT: IPC:               0.67
# CHECK-NEXT: Block RThroughput: 8.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      8     8.00                        sdiv	w12, w21, w0
# CHECK-NEXT:  1      3     0.50                        add	w8, w8, #1
# CHECK-NEXT:  1      3     0.50                        add	w1, w2, w0
# CHECK-NEXT:  1      3     0.50                        add	w3, w4, #1
# CHECK-NEXT:  1      3     0.50                        add	w5, w6, w0
# CHECK-NEXT:  1      3     0.50                        add	w7, w9, w0

# CHECK:      Dynamic Dispatch Stall Cycles:
# CHECK-NEXT: RAT     - Register unavailable:                      0
# CHECK-NEXT: RCU     - Retire tokens unavailable:                 0
# CHECK-NEXT: SCHEDQ  - Scheduler full:                            0
# CHECK-NEXT: LQ      - Load queue full:                           0
# CHECK-NEXT: SQ      - Store queue full:                          0
# CHECK-NEXT: GROUP   - Static restrictions on the dispatch group: 5  (27.8%)

# CHECK:      Dispatch Logic - number of cycles where we saw N micro opcodes dispatched:
# CHECK-NEXT: [# dispatched], [# cycles]
# CHECK-NEXT:  0,              12  (66.7%)
# CHECK-NEXT:  2,              6  (33.3%)

# CHECK:      Schedulers - number of cycles where we saw N micro opcodes issued:
# CHECK-NEXT: [# issued], [# cycles]
# CHECK-NEXT:  0,          12  (66.7%)
# CHECK-NEXT:  2,          6  (33.3%)

# CHECK:      Scheduler's queue usage:
# CHECK-NEXT: No scheduler resources used.

# CHECK:      Retire Control Unit - number of cycles where we saw N instructions retired:
# CHECK-NEXT: [# retired], [# cycles]
# CHECK-NEXT:  0,           16  (88.9%)
# CHECK-NEXT:  6,           2  (11.1%)

# CHECK:      Total ROB Entries:                64
# CHECK-NEXT: Max Used ROB Entries:             8  ( 12.5% )
# CHECK-NEXT: Average Used ROB Entries per cy:  5  ( 7.8% )

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    12
# CHECK-NEXT: Max number of mappings used:         8

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
# CHECK-NEXT: 2.50   2.50    -     8.00    -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3.0]  [3.1]  [4]    [5.0]  [5.1]  [6]    [7]    [8]    Instructions:
# CHECK-NEXT:  -      -      -     8.00    -      -      -      -      -      -      -      -     sdiv	w12, w21, w0
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     add	w8, w8, #1
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     add	w1, w2, w0
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     add	w3, w4, #1
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     add	w5, w6, w0
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     add	w7, w9, w0

# CHECK:      Timeline view:
# CHECK-NEXT:                     01234567
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeeER.    . .   sdiv	w12, w21, w0
# CHECK-NEXT: [0,1]     DeeE-----R.    . .   add	w8, w8, #1
# CHECK-NEXT: [0,2]     .DeeE----R.    . .   add	w1, w2, w0
# CHECK-NEXT: [0,3]     .DeeE----R.    . .   add	w3, w4, #1
# CHECK-NEXT: [0,4]     . DeeE---R.    . .   add	w5, w6, w0
# CHECK-NEXT: [0,5]     . DeeE---R.    . .   add	w7, w9, w0
# CHECK-NEXT: [1,0]     .    .  DeeeeeeeER   sdiv	w12, w21, w0
# CHECK-NEXT: [1,1]     .    .  DeeE-----R   add	w8, w8, #1
# CHECK-NEXT: [1,2]     .    .   DeeE----R   add	w1, w2, w0
# CHECK-NEXT: [1,3]     .    .   DeeE----R   add	w3, w4, #1
# CHECK-NEXT: [1,4]     .    .    DeeE---R   add	w5, w6, w0
# CHECK-NEXT: [1,5]     .    .    DeeE---R   add	w7, w9, w0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     0.0    0.0    0.0       sdiv	w12, w21, w0
# CHECK-NEXT: 1.     2     0.0    0.0    5.0       add	w8, w8, #1
# CHECK-NEXT: 2.     2     0.0    0.0    4.0       add	w1, w2, w0
# CHECK-NEXT: 3.     2     0.0    0.0    4.0       add	w3, w4, #1
# CHECK-NEXT: 4.     2     0.0    0.0    3.0       add	w5, w6, w0
# CHECK-NEXT: 5.     2     0.0    0.0    3.0       add	w7, w9, w0
# CHECK-NEXT:        2     0.0    0.0    3.2       <total>
