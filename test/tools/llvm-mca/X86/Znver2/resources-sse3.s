# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -instruction-tables < %s | FileCheck %s

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

monitor

movddup   %xmm0, %xmm2
movddup   (%rax), %xmm2

movshdup  %xmm0, %xmm2
movshdup  (%rax), %xmm2

movsldup  %xmm0, %xmm2
movsldup  (%rax), %xmm2

mwait

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     0.50                        addsubpd	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.50    *                   addsubpd	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.50                        addsubps	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.50    *                   addsubps	(%rax), %xmm2
# CHECK-NEXT:  1      7     0.25                        haddpd	%xmm0, %xmm2
# CHECK-NEXT:  1      14    0.33    *                   haddpd	(%rax), %xmm2
# CHECK-NEXT:  1      7     0.25                        haddps	%xmm0, %xmm2
# CHECK-NEXT:  1      14    0.33    *                   haddps	(%rax), %xmm2
# CHECK-NEXT:  1      7     0.25                        hsubpd	%xmm0, %xmm2
# CHECK-NEXT:  1      14    0.33    *                   hsubpd	(%rax), %xmm2
# CHECK-NEXT:  1      7     0.25                        hsubps	%xmm0, %xmm2
# CHECK-NEXT:  1      14    0.33    *                   hsubps	(%rax), %xmm2
# CHECK-NEXT:  1      8     0.33    *                   lddqu	(%rax), %xmm2
# CHECK-NEXT:  1      100   0.25                  U     monitor
# CHECK-NEXT:  1      1     0.50                        movddup	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   movddup	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        movshdup	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   movshdup	(%rax), %xmm2
# CHECK-NEXT:  1      100   0.25                        movsldup	%xmm0, %xmm2
# CHECK-NEXT:  1      100   0.25    *                   movsldup	(%rax), %xmm2
# CHECK-NEXT:  1      100   0.25    *      *      U     mwait

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
# CHECK-NEXT: 3.00   3.00   3.00    -      -      -      -      -      -     2.00   4.00   2.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     0.50   0.50    -     addsubpd	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -     0.50   0.50    -     addsubpd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     0.50   0.50    -     addsubps	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -     0.50   0.50    -     addsubps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     haddpd	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     haddpd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     haddps	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     haddps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     hsubpd	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     hsubpd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     hsubps	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     hsubps	(%rax), %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     lddqu	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     monitor
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -     movddup	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -     0.50   0.50    -      -     movddup	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -     movshdup	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -     0.50   0.50    -      -     movshdup	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     movsldup	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     movsldup	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     mwait
