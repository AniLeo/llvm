# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -timeline -iterations=2 < %s | FileCheck %s

# PR51494: A read-advance on the implicit read of EDX/RDX was missing.

# LLVM-MCA-BEGIN
mulxl (%rdi), %eax, %edx
# LLVM-MCA-END

# LLVM-MCA-BEGIN
mulxq (%rdi), %rax, %rdx
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      17
# CHECK-NEXT: Total uOps:        2

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.12
# CHECK-NEXT: IPC:               0.12
# CHECK-NEXT: Block RThroughput: 2.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      7     2.00    *                   mulxl	(%rdi), %eax, %edx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn2AGU0
# CHECK-NEXT: [1]   - Zn2AGU1
# CHECK-NEXT: [2]   - Zn2AGU2
# CHECK-NEXT: [3]   - Zn2ALU0
# CHECK-NEXT: [4]   - Zn2ALU1
# CHECK-NEXT: [5]   - Zn2ALU2
# CHECK-NEXT: [6]   - Zn2ALU3
# CHECK-NEXT: [7]   - Zn2Divider
# CHECK-NEXT: [8]   - Zn2FPU0
# CHECK-NEXT: [9]   - Zn2FPU1
# CHECK-NEXT: [10]  - Zn2FPU2
# CHECK-NEXT: [11]  - Zn2FPU3
# CHECK-NEXT: [12]  - Zn2Multiplier

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]
# CHECK-NEXT:  -     0.50   0.50    -     2.00    -      -      -      -      -      -      -     2.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -     0.50   0.50    -     2.00    -      -      -      -      -      -      -     2.00   mulxl	(%rdi), %eax, %edx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeeER.    ..   mulxl	(%rdi), %eax, %edx
# CHECK-NEXT: [1,0]     D=======eeeeeeeER   mulxl	(%rdi), %eax, %edx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     4.5    0.5    0.0       mulxl	(%rdi), %eax, %edx

# CHECK:      [1] Code Region

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      17
# CHECK-NEXT: Total uOps:        2

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.12
# CHECK-NEXT: IPC:               0.12
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      7     1.00    *                   mulxq	(%rdi), %rax, %rdx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn2AGU0
# CHECK-NEXT: [1]   - Zn2AGU1
# CHECK-NEXT: [2]   - Zn2AGU2
# CHECK-NEXT: [3]   - Zn2ALU0
# CHECK-NEXT: [4]   - Zn2ALU1
# CHECK-NEXT: [5]   - Zn2ALU2
# CHECK-NEXT: [6]   - Zn2ALU3
# CHECK-NEXT: [7]   - Zn2Divider
# CHECK-NEXT: [8]   - Zn2FPU0
# CHECK-NEXT: [9]   - Zn2FPU1
# CHECK-NEXT: [10]  - Zn2FPU2
# CHECK-NEXT: [11]  - Zn2FPU3
# CHECK-NEXT: [12]  - Zn2Multiplier

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]
# CHECK-NEXT:  -     0.50   0.50    -     1.00    -      -      -      -      -      -      -     1.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -     0.50   0.50    -     1.00    -      -      -      -      -      -      -     1.00   mulxq	(%rdi), %rax, %rdx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeeER.    ..   mulxq	(%rdi), %rax, %rdx
# CHECK-NEXT: [1,0]     D=======eeeeeeeER   mulxq	(%rdi), %rax, %rdx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     4.5    0.5    0.0       mulxq	(%rdi), %rax, %rdx
