# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -iterations=5 -instruction-info=false -dispatch-stats -register-file-stats -timeline < %s | FileCheck %s

vaddps %xmm0, %xmm0, %xmm0
vmulps %xmm0, %xmm0, %xmm0

# CHECK:      Iterations:        5
# CHECK-NEXT: Instructions:      10
# CHECK-NEXT: Total Cycles:      53
# CHECK-NEXT: Total uOps:        10

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.19
# CHECK-NEXT: IPC:               0.19
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Dynamic Dispatch Stall Cycles:
# CHECK-NEXT: RAT     - Register unavailable:                      0
# CHECK-NEXT: RCU     - Retire tokens unavailable:                 0
# CHECK-NEXT: SCHEDQ  - Scheduler full:                            0
# CHECK-NEXT: LQ      - Load queue full:                           0
# CHECK-NEXT: SQ      - Store queue full:                          0
# CHECK-NEXT: GROUP   - Static restrictions on the dispatch group: 0

# CHECK:      Dispatch Logic - number of cycles where we saw N micro opcodes dispatched:
# CHECK-NEXT: [# dispatched], [# cycles]
# CHECK-NEXT:  0,              50  (94.3%)
# CHECK-NEXT:  2,              1  (1.9%)
# CHECK-NEXT:  4,              2  (3.8%)

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    10
# CHECK-NEXT: Max number of mappings used:         10

# CHECK:      *  Register File #1 -- PdFpuPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 10
# CHECK-NEXT:    Max number of mappings used:      10

# CHECK:      *  Register File #2 -- PdIntegerPRF:
# CHECK-NEXT:    Number of physical registers:     96
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -     1.00   1.00    -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -      -      -     1.00    -      -      -      -      -      -      -     vmulps	%xmm0, %xmm0, %xmm0

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789          012
# CHECK-NEXT: Index     0123456789          0123456789          0123456789

# CHECK:      [0,0]     DeeeeeER  .    .    .    .    .    .    .    .    . .   vaddps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [0,1]     D=====eeeeeER  .    .    .    .    .    .    .    . .   vmulps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [1,0]     D==========eeeeeER  .    .    .    .    .    .    . .   vaddps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [1,1]     D===============eeeeeER  .    .    .    .    .    . .   vmulps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [2,0]     .D===================eeeeeER  .    .    .    .    . .   vaddps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [2,1]     .D========================eeeeeER  .    .    .    . .   vmulps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [3,0]     .D=============================eeeeeER  .    .    . .   vaddps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [3,1]     .D==================================eeeeeER  .    . .   vmulps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [4,0]     . D======================================eeeeeER  . .   vaddps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: [4,1]     . D===========================================eeeeeER   vmulps	%xmm0, %xmm0, %xmm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     5     20.2   0.2    0.0       vaddps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT: 1.     5     25.2   0.0    0.0       vmulps	%xmm0, %xmm0, %xmm0
# CHECK-NEXT:        5     22.7   0.1    0.0       <total>
