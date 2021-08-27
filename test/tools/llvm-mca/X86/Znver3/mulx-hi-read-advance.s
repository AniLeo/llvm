# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver3 -timeline -iterations=1 < %s | FileCheck %s

# PR51495: WriteIMulH reports an incorrect latency for the RM variants of MULX.

# LLVM-MCA-BEGIN
mulxl (%rdi), %eax, %ecx
add %eax, %eax
# LLVM-MCA-END

# LLVM-MCA-BEGIN
mulxq (%rdi), %rax, %rcx
add %rax, %rax
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      11
# CHECK-NEXT: Total uOps:        3

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    0.27
# CHECK-NEXT: IPC:               0.18
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      8     1.00    *                   mulxl	(%rdi), %eax, %ecx
# CHECK-NEXT:  1      1     0.25                        addl	%eax, %eax

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -      -      -      -      -     1.00    -      -     1.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -     1.00    -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     1.00    -      -     1.00    -      -     mulxl	(%rdi), %eax, %ecx
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %eax

# CHECK:      Timeline view:
# CHECK-NEXT:                     0
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeeeER   mulxl	(%rdi), %eax, %ecx
# CHECK-NEXT: [0,1]     D=======eER   addl	%eax, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       mulxl	(%rdi), %eax, %ecx
# CHECK-NEXT: 1.     1     8.0    0.0    0.0       addl	%eax, %eax
# CHECK-NEXT:        1     4.5    0.5    0.0       <total>

# CHECK:      [1] Code Region

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      11
# CHECK-NEXT: Total uOps:        3

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    0.27
# CHECK-NEXT: IPC:               0.18
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      8     1.00    *                   mulxq	(%rdi), %rax, %rcx
# CHECK-NEXT:  1      1     0.25                        addq	%rax, %rax

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -     1.00    -     1.00    -     1.00    -      -      -      -      -      -      -      -      -      -     1.00    -      -     1.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -     1.00    -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     1.00    -      -     1.00    -      -     mulxq	(%rdi), %rax, %rcx
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     addq	%rax, %rax

# CHECK:      Timeline view:
# CHECK-NEXT:                     0
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeeeER   mulxq	(%rdi), %rax, %rcx
# CHECK-NEXT: [0,1]     D=======eER   addq	%rax, %rax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       mulxq	(%rdi), %rax, %rcx
# CHECK-NEXT: 1.     1     8.0    0.0    0.0       addq	%rax, %rax
# CHECK-NEXT:        1     4.5    0.5    0.0       <total>
