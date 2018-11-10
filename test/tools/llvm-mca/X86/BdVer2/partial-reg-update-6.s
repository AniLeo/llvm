# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -iterations=1500 -timeline -timeline-max-iterations=3 < %s | FileCheck %s

# perf stat reports a throughput of 0.60 IPC for this code snippet.
# Each lzcnt has a false dependency on %ecx; the first lzcnt has to wait on the
# imul. However, the folded load can start immediately.
# The last lzcnt has a false dependency on %cx. However, even in this case, the
# folded load can start immediately.

imul %edx, %ecx
lzcnt (%rsp), %cx
lzcnt 2(%rsp), %cx

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      4500
# CHECK-NEXT: Total Cycles:      10503
# CHECK-NEXT: Total uOps:        7500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.71
# CHECK-NEXT: IPC:               0.43
# CHECK-NEXT: Block RThroughput: 1.3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      4     1.00                        imull	%edx, %ecx
# CHECK-NEXT:  2      6     0.50    *                   lzcntw	(%rsp), %cx
# CHECK-NEXT:  2      6     0.50    *                   lzcntw	2(%rsp), %cx

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
# CHECK-NEXT:  -     2.00    -      -      -     1.50   1.50    -      -      -      -      -      -      -      -      -      -      -      -      -     2.00   1.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -     1.00    -     imull	%edx, %ecx
# CHECK-NEXT:  -     1.00    -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -     1.00    -      -     lzcntw	(%rsp), %cx
# CHECK-NEXT:  -     1.00    -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     1.00    -      -     lzcntw	2(%rsp), %cx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          0123

# CHECK:      [0,0]     DeeeeER   .    .    .  .   imull	%edx, %ecx
# CHECK-NEXT: [0,1]     DeeeeeeER .    .    .  .   lzcntw	(%rsp), %cx
# CHECK-NEXT: [0,2]     .DeeeeeeER.    .    .  .   lzcntw	2(%rsp), %cx
# CHECK-NEXT: [1,0]     .D======eeeeER .    .  .   imull	%edx, %ecx
# CHECK-NEXT: [1,1]     . D=====eeeeeeER    .  .   lzcntw	(%rsp), %cx
# CHECK-NEXT: [1,2]     . D======eeeeeeER   .  .   lzcntw	2(%rsp), %cx
# CHECK-NEXT: [2,0]     .  D===========eeeeER  .   imull	%edx, %ecx
# CHECK-NEXT: [2,1]     .  D===========eeeeeeER.   lzcntw	(%rsp), %cx
# CHECK-NEXT: [2,2]     .   D===========eeeeeeER   lzcntw	2(%rsp), %cx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     6.7    0.3    0.0       imull	%edx, %ecx
# CHECK-NEXT: 1.     3     6.3    0.0    0.0       lzcntw	(%rsp), %cx
# CHECK-NEXT: 2.     3     6.7    0.0    0.0       lzcntw	2(%rsp), %cx
