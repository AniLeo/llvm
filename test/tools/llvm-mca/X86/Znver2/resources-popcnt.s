# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -instruction-tables < %s | FileCheck %s

popcntw     %cx, %cx
popcntw     (%rax), %cx

popcntl     %eax, %ecx
popcntl     (%rax), %ecx

popcntq     %rax, %rcx
popcntq     (%rax), %rcx

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        popcntw	%cx, %cx
# CHECK-NEXT:  2      5     0.33    *                   popcntw	(%rax), %cx
# CHECK-NEXT:  1      1     0.25                        popcntl	%eax, %ecx
# CHECK-NEXT:  2      5     0.33    *                   popcntl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.25                        popcntq	%rax, %rcx
# CHECK-NEXT:  2      5     0.33    *                   popcntq	(%rax), %rcx

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
# CHECK-NEXT: 1.00   1.00   1.00   1.50   1.50   1.50   1.50    -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -     -      0.25   0.25   0.25   0.25    -      -      -      -      -      -     popcntw	%cx, %cx
# CHECK-NEXT: 0.33   0.33   0.33    0.25   0.25   0.25   0.25    -      -      -      -      -      -     popcntw	(%rax), %cx
# CHECK-NEXT:  -      -     -      0.25   0.25   0.25   0.25    -      -      -      -      -      -     popcntl	%eax, %ecx
# CHECK-NEXT: 0.33   0.33   0.33    0.25   0.25   0.25   0.25    -      -      -      -      -      -     popcntl	(%rax), %ecx
# CHECK-NEXT:  -      -     -      0.25   0.25   0.25   0.25    -      -      -      -      -      -     popcntq	%rax, %rcx
# CHECK-NEXT: 0.33   0.33   0.33    0.25   0.25   0.25   0.25    -      -      -      -      -      -     popcntq	(%rax), %rcx
