# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -instruction-tables < %s | FileCheck %s

andn        %eax, %ebx, %ecx
andn        (%rax), %ebx, %ecx

andn        %rax, %rbx, %rcx
andn        (%rax), %rbx, %rcx

bextr       %eax, %ebx, %ecx
bextr       %eax, (%rbx), %ecx

bextr       %rax, %rbx, %rcx
bextr       %rax, (%rbx), %rcx

blsi        %eax, %ecx
blsi        (%rax), %ecx

blsi        %rax, %rcx
blsi        (%rax), %rcx

blsmsk      %eax, %ecx
blsmsk      (%rax), %ecx

blsmsk      %rax, %rcx
blsmsk      (%rax), %rcx

blsr        %eax, %ecx
blsr        (%rax), %ecx

blsr        %rax, %rcx
blsr        (%rax), %rcx

tzcnt       %eax, %ecx
tzcnt       (%rax), %ecx

tzcnt       %rax, %rcx
tzcnt       (%rax), %rcx

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        andnl	%eax, %ebx, %ecx
# CHECK-NEXT:  1      4     1.00    *                   andnl	(%rax), %ebx, %ecx
# CHECK-NEXT:  1      1     0.50                        andnq	%rax, %rbx, %rcx
# CHECK-NEXT:  1      4     1.00    *                   andnq	(%rax), %rbx, %rcx
# CHECK-NEXT:  1      1     0.50                        bextrl	%eax, %ebx, %ecx
# CHECK-NEXT:  1      4     1.00    *                   bextrl	%eax, (%rbx), %ecx
# CHECK-NEXT:  1      1     0.50                        bextrq	%rax, %rbx, %rcx
# CHECK-NEXT:  1      4     1.00    *                   bextrq	%rax, (%rbx), %rcx
# CHECK-NEXT:  1      1     0.50                        blsil	%eax, %ecx
# CHECK-NEXT:  1      4     1.00    *                   blsil	(%rax), %ecx
# CHECK-NEXT:  1      1     0.50                        blsiq	%rax, %rcx
# CHECK-NEXT:  1      4     1.00    *                   blsiq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.50                        blsmskl	%eax, %ecx
# CHECK-NEXT:  1      4     1.00    *                   blsmskl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.50                        blsmskq	%rax, %rcx
# CHECK-NEXT:  1      4     1.00    *                   blsmskq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.50                        blsrl	%eax, %ecx
# CHECK-NEXT:  1      4     1.00    *                   blsrl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.50                        blsrq	%rax, %rcx
# CHECK-NEXT:  1      4     1.00    *                   blsrq	(%rax), %rcx
# CHECK-NEXT:  1      2     1.00                        tzcntl	%eax, %ecx
# CHECK-NEXT:  1      5     1.00    *                   tzcntl	(%rax), %ecx
# CHECK-NEXT:  1      2     1.00                        tzcntq	%rax, %rcx
# CHECK-NEXT:  1      5     1.00    *                   tzcntq	(%rax), %rcx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 14.00  14.00   -      -      -      -      -     12.00   -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     andnl	%eax, %ebx, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     andnl	(%rax), %ebx, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     andnq	%rax, %rbx, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     andnq	(%rax), %rbx, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     bextrl	%eax, %ebx, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     bextrl	%eax, (%rbx), %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     bextrq	%rax, %rbx, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     bextrq	%rax, (%rbx), %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     blsil	%eax, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     blsil	(%rax), %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     blsiq	%rax, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     blsiq	(%rax), %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     blsmskl	%eax, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     blsmskl	(%rax), %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     blsmskq	%rax, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     blsmskq	(%rax), %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     blsrl	%eax, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     blsrl	(%rax), %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     blsrq	%rax, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -      -      -     blsrq	(%rax), %rcx
# CHECK-NEXT: 1.00   1.00    -      -      -      -      -      -      -      -      -      -      -      -     tzcntl	%eax, %ecx
# CHECK-NEXT: 1.00   1.00    -      -      -      -      -     1.00    -      -      -      -      -      -     tzcntl	(%rax), %ecx
# CHECK-NEXT: 1.00   1.00    -      -      -      -      -      -      -      -      -      -      -      -     tzcntq	%rax, %rcx
# CHECK-NEXT: 1.00   1.00    -      -      -      -      -     1.00    -      -      -      -      -      -     tzcntq	(%rax), %rcx

