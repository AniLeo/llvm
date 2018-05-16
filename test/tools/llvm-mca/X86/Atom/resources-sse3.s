# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=atom -instruction-tables < %s | FileCheck %s

addsubpd  %xmm0, %xmm2
addsubpd  (%rax),  %xmm2

addsubps  %xmm0, %xmm2
addsubps  (%rax), %xmm2

haddpd    %xmm0, %xmm2
haddpd    (%rax), %xmm2

haddps    %xmm0, %xmm2
haddps    (%rax), %xmm2

hsubpd    %xmm0, %xmm2
hsubpd    (%rax), %xmm2

hsubps    %xmm0, %xmm2
hsubps    (%rax), %xmm2

lddqu     (%rax), %xmm2

movddup   %xmm0, %xmm2
movddup   (%rax), %xmm2

movshdup  %xmm0, %xmm2
movshdup  (%rax), %xmm2

movsldup  %xmm0, %xmm2
movsldup  (%rax), %xmm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      6     3.00                        addsubpd	%xmm0, %xmm2
# CHECK-NEXT:  1      7     3.50    *                   addsubpd	(%rax), %xmm2
# CHECK-NEXT:  1      5     5.00                        addsubps	%xmm0, %xmm2
# CHECK-NEXT:  1      5     5.00    *                   addsubps	(%rax), %xmm2
# CHECK-NEXT:  1      8     4.00                        haddpd	%xmm0, %xmm2
# CHECK-NEXT:  1      9     4.50    *                   haddpd	(%rax), %xmm2
# CHECK-NEXT:  1      8     4.00                        haddps	%xmm0, %xmm2
# CHECK-NEXT:  1      9     4.50    *                   haddps	(%rax), %xmm2
# CHECK-NEXT:  1      8     4.00                        hsubpd	%xmm0, %xmm2
# CHECK-NEXT:  1      9     4.50    *                   hsubpd	(%rax), %xmm2
# CHECK-NEXT:  1      8     4.00                        hsubps	%xmm0, %xmm2
# CHECK-NEXT:  1      9     4.50    *                   hsubps	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.50    *                   lddqu	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        movddup	%xmm0, %xmm2
# CHECK-NEXT:  1      1     1.00    *                   movddup	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        movshdup	%xmm0, %xmm2
# CHECK-NEXT:  1      1     1.00    *                   movshdup	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        movsldup	%xmm0, %xmm2
# CHECK-NEXT:  1      1     1.00    *                   movsldup	(%rax), %xmm2

# CHECK:      Resources:
# CHECK-NEXT: [0]   - AtomPort0
# CHECK-NEXT: [1]   - AtomPort1

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]
# CHECK-NEXT: 58.00  42.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    Instructions:
# CHECK-NEXT: 3.00   3.00   addsubpd	%xmm0, %xmm2
# CHECK-NEXT: 3.50   3.50   addsubpd	(%rax), %xmm2
# CHECK-NEXT: 5.00    -     addsubps	%xmm0, %xmm2
# CHECK-NEXT: 5.00    -     addsubps	(%rax), %xmm2
# CHECK-NEXT: 4.00   4.00   haddpd	%xmm0, %xmm2
# CHECK-NEXT: 4.50   4.50   haddpd	(%rax), %xmm2
# CHECK-NEXT: 4.00   4.00   haddps	%xmm0, %xmm2
# CHECK-NEXT: 4.50   4.50   haddps	(%rax), %xmm2
# CHECK-NEXT: 4.00   4.00   hsubpd	%xmm0, %xmm2
# CHECK-NEXT: 4.50   4.50   hsubpd	(%rax), %xmm2
# CHECK-NEXT: 4.00   4.00   hsubps	%xmm0, %xmm2
# CHECK-NEXT: 4.50   4.50   hsubps	(%rax), %xmm2
# CHECK-NEXT: 1.50   1.50   lddqu	(%rax), %xmm2
# CHECK-NEXT: 1.00    -     movddup	%xmm0, %xmm2
# CHECK-NEXT: 1.00    -     movddup	(%rax), %xmm2
# CHECK-NEXT: 1.00    -     movshdup	%xmm0, %xmm2
# CHECK-NEXT: 1.00    -     movshdup	(%rax), %xmm2
# CHECK-NEXT: 1.00    -     movsldup	%xmm0, %xmm2
# CHECK-NEXT: 1.00    -     movsldup	(%rax), %xmm2

