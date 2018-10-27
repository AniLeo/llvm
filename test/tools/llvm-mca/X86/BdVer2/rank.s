# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -timeline -timeline-max-iterations=3 < %s | FileCheck %s

add %eax, %ecx
add %eax, %edx
add %eax, %ebx
add %edx, %esi
add %ebx, %eax
add %edx, %esi
add %ebx, %eax
add %ebx, %eax

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      800
# CHECK-NEXT: Total Cycles:      503
# CHECK-NEXT: Total uOps:        800

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    1.59
# CHECK-NEXT: IPC:               1.59
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        addl	%eax, %ecx
# CHECK-NEXT:  1      1     0.50                        addl	%eax, %edx
# CHECK-NEXT:  1      1     0.50                        addl	%eax, %ebx
# CHECK-NEXT:  1      1     0.50                        addl	%edx, %esi
# CHECK-NEXT:  1      1     0.50                        addl	%ebx, %eax
# CHECK-NEXT:  1      1     0.50                        addl	%edx, %esi
# CHECK-NEXT:  1      1     0.50                        addl	%ebx, %eax
# CHECK-NEXT:  1      1     0.50                        addl	%ebx, %eax

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
# CHECK-NEXT: [16]  - PdMul

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16]
# CHECK-NEXT:  -      -      -      -      -     4.00   4.00    -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %ecx
# CHECK-NEXT:  -      -      -      -      -     0.01   0.99    -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %edx
# CHECK-NEXT:  -      -      -      -      -     0.99   0.01    -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %ebx
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%edx, %esi
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%ebx, %eax
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%edx, %esi
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%ebx, %eax
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%ebx, %eax

# CHECK:      Timeline view:
# CHECK-NEXT:                     01234567
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeER .    .    . .   addl	%eax, %ecx
# CHECK-NEXT: [0,1]     DeER .    .    . .   addl	%eax, %edx
# CHECK-NEXT: [0,2]     D=eER.    .    . .   addl	%eax, %ebx
# CHECK-NEXT: [0,3]     D=eER.    .    . .   addl	%edx, %esi
# CHECK-NEXT: [0,4]     .D=eER    .    . .   addl	%ebx, %eax
# CHECK-NEXT: [0,5]     .D=eER    .    . .   addl	%edx, %esi
# CHECK-NEXT: [0,6]     .D==eER   .    . .   addl	%ebx, %eax
# CHECK-NEXT: [0,7]     .D===eER  .    . .   addl	%ebx, %eax
# CHECK-NEXT: [1,0]     . D====eER.    . .   addl	%eax, %ecx
# CHECK-NEXT: [1,1]     . D===eE-R.    . .   addl	%eax, %edx
# CHECK-NEXT: [1,2]     . D===eE-R.    . .   addl	%eax, %ebx
# CHECK-NEXT: [1,3]     . D====eER.    . .   addl	%edx, %esi
# CHECK-NEXT: [1,4]     .  D====eER    . .   addl	%ebx, %eax
# CHECK-NEXT: [1,5]     .  D====eER    . .   addl	%edx, %esi
# CHECK-NEXT: [1,6]     .  D=====eER   . .   addl	%ebx, %eax
# CHECK-NEXT: [1,7]     .  D======eER  . .   addl	%ebx, %eax
# CHECK-NEXT: [2,0]     .   D=======eER. .   addl	%eax, %ecx
# CHECK-NEXT: [2,1]     .   D======eE-R. .   addl	%eax, %edx
# CHECK-NEXT: [2,2]     .   D======eE-R. .   addl	%eax, %ebx
# CHECK-NEXT: [2,3]     .   D=======eER. .   addl	%edx, %esi
# CHECK-NEXT: [2,4]     .    D=======eER .   addl	%ebx, %eax
# CHECK-NEXT: [2,5]     .    D=======eER .   addl	%edx, %esi
# CHECK-NEXT: [2,6]     .    D========eER.   addl	%ebx, %eax
# CHECK-NEXT: [2,7]     .    D=========eER   addl	%ebx, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     4.7    1.0    0.0       addl	%eax, %ecx
# CHECK-NEXT: 1.     3     4.0    0.3    0.7       addl	%eax, %edx
# CHECK-NEXT: 2.     3     4.3    0.7    0.7       addl	%eax, %ebx
# CHECK-NEXT: 3.     3     5.0    0.0    0.0       addl	%edx, %esi
# CHECK-NEXT: 4.     3     5.0    0.7    0.0       addl	%ebx, %eax
# CHECK-NEXT: 5.     3     5.0    0.0    0.0       addl	%edx, %esi
# CHECK-NEXT: 6.     3     6.0    0.0    0.0       addl	%ebx, %eax
# CHECK-NEXT: 7.     3     7.0    0.0    0.0       addl	%ebx, %eax
