# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -instruction-tables < %s | FileCheck %s

crc32b      %al, %ecx
crc32b      (%rax), %ecx

crc32l      %eax, %ecx
crc32l      (%rax), %ecx

crc32w      %ax, %ecx
crc32w      (%rax), %ecx

crc32b      %al, %rcx
crc32b      (%rax), %rcx

crc32q      %rax, %rcx
crc32q      (%rax), %rcx

pcmpestri   $1, %xmm0, %xmm2
pcmpestri   $1, (%rax), %xmm2

pcmpestrm   $1, %xmm0, %xmm2
pcmpestrm   $1, (%rax), %xmm2

pcmpistri   $1, %xmm0, %xmm2
pcmpistri   $1, (%rax), %xmm2

pcmpistrm   $1, %xmm0, %xmm2
pcmpistrm   $1, (%rax), %xmm2

pcmpgtq     %xmm0, %xmm2
pcmpgtq     (%rax), %xmm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        crc32b	%al, %ecx
# CHECK-NEXT:  1      10    1.00    *                   crc32b	(%rax), %ecx
# CHECK-NEXT:  1      3     1.00                        crc32l	%eax, %ecx
# CHECK-NEXT:  1      10    1.00    *                   crc32l	(%rax), %ecx
# CHECK-NEXT:  1      3     1.00                        crc32w	%ax, %ecx
# CHECK-NEXT:  1      10    1.00    *                   crc32w	(%rax), %ecx
# CHECK-NEXT:  1      3     1.00                        crc32b	%al, %rcx
# CHECK-NEXT:  1      10    1.00    *                   crc32b	(%rax), %rcx
# CHECK-NEXT:  1      3     1.00                        crc32q	%rax, %rcx
# CHECK-NEXT:  1      10    1.00    *                   crc32q	(%rax), %rcx
# CHECK-NEXT:  1      100   0.25                        pcmpestri	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100   0.25    *                   pcmpestri	$1, (%rax), %xmm2
# CHECK-NEXT:  1      100   0.25                        pcmpestrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100   0.25    *                   pcmpestrm	$1, (%rax), %xmm2
# CHECK-NEXT:  1      100   0.25                        pcmpistri	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100   0.25    *                   pcmpistri	$1, (%rax), %xmm2
# CHECK-NEXT:  1      100   0.25                        pcmpistrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      100   0.25    *                   pcmpistrm	$1, (%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtq	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpgtq	(%rax), %xmm2

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
# CHECK-NEXT: 2.00  2.00   2.00    -      -      -      -      -     11.00   -      -     1.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     crc32b	%al, %ecx
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     crc32b	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     crc32l	%eax, %ecx
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     crc32l	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     crc32w	%ax, %ecx
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     crc32w	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     crc32b	%al, %rcx
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     crc32b	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     crc32q	%rax, %rcx
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     crc32q	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpestri	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpestri	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpestrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpestrm	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpistri	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpistri	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpistrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpistrm	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50    -      -     0.50    -     pcmpgtq	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.50    -      -     0.50    -     pcmpgtq	(%rax), %xmm2
