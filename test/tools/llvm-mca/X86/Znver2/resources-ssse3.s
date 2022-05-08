# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -instruction-tables < %s | FileCheck %s

pabsb       %mm0, %mm2
pabsb       (%rax), %mm2

pabsb       %xmm0, %xmm2
pabsb       (%rax), %xmm2

pabsd       %mm0, %mm2
pabsd       (%rax), %mm2

pabsd       %xmm0, %xmm2
pabsd       (%rax), %xmm2

pabsw       %mm0, %mm2
pabsw       (%rax), %mm2

pabsw       %xmm0, %xmm2
pabsw       (%rax), %xmm2

palignr     $1, %mm0, %mm2
palignr     $1, (%rax), %mm2

palignr     $1, %xmm0, %xmm2
palignr     $1, (%rax), %xmm2

phaddd      %mm0, %mm2
phaddd      (%rax), %mm2

phaddd      %xmm0, %xmm2
phaddd      (%rax), %xmm2

phaddsw     %mm0, %mm2
phaddsw     (%rax), %mm2

phaddsw     %xmm0, %xmm2
phaddsw     (%rax), %xmm2

phaddw      %mm0, %mm2
phaddw      (%rax), %mm2

phaddw      %xmm0, %xmm2
phaddw      (%rax), %xmm2

phsubd      %mm0, %mm2
phsubd      (%rax), %mm2

phsubd      %xmm0, %xmm2
phsubd      (%rax), %xmm2

phsubsw     %mm0, %mm2
phsubsw     (%rax), %mm2

phsubsw     %xmm0, %xmm2
phsubsw     (%rax), %xmm2

phsubw      %mm0, %mm2
phsubw      (%rax), %mm2

phsubw      %xmm0, %xmm2
phsubw      (%rax), %xmm2

pmaddubsw   %mm0, %mm2
pmaddubsw   (%rax), %mm2

pmaddubsw   %xmm0, %xmm2
pmaddubsw   (%rax), %xmm2

pmulhrsw    %mm0, %mm2
pmulhrsw    (%rax), %mm2

pmulhrsw    %xmm0, %xmm2
pmulhrsw    (%rax), %xmm2

pshufb      %mm0, %mm2
pshufb      (%rax), %mm2

pshufb      %xmm0, %xmm2
pshufb      (%rax), %xmm2

psignb      %mm0, %mm2
psignb      (%rax), %mm2

psignb      %xmm0, %xmm2
psignb      (%rax), %xmm2

psignd      %mm0, %mm2
psignd      (%rax), %mm2

psignd      %xmm0, %xmm2
psignd      (%rax), %xmm2

psignw      %mm0, %mm2
psignw      (%rax), %mm2

psignw      %xmm0, %xmm2
psignw      (%rax), %xmm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        pabsb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   pabsb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pabsb	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   pabsb	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        pabsd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   pabsd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pabsd	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   pabsd	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        pabsw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   pabsw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pabsw	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   pabsw	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        palignr	$1, %mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   palignr	$1, (%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        palignr	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   palignr	$1, (%rax), %xmm2
# CHECK-NEXT:  1      3     0.25                        phaddd	%mm0, %mm2
# CHECK-NEXT:  1      10    0.33    *                   phaddd	(%rax), %mm2
# CHECK-NEXT:  1      3     0.25                        phaddd	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.33    *                   phaddd	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.25                        phaddsw	%mm0, %mm2
# CHECK-NEXT:  1      10    0.33    *                   phaddsw	(%rax), %mm2
# CHECK-NEXT:  1      3     0.25                        phaddsw	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.33    *                   phaddsw	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.25                        phaddw	%mm0, %mm2
# CHECK-NEXT:  1      10    0.33    *                   phaddw	(%rax), %mm2
# CHECK-NEXT:  1      3     0.25                        phaddw	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.33    *                   phaddw	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.25                        phsubd	%mm0, %mm2
# CHECK-NEXT:  1      10    0.33    *                   phsubd	(%rax), %mm2
# CHECK-NEXT:  1      3     0.25                        phsubd	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.33    *                   phsubd	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.25                        phsubsw	%mm0, %mm2
# CHECK-NEXT:  1      10    0.33    *                   phsubsw	(%rax), %mm2
# CHECK-NEXT:  1      3     0.25                        phsubsw	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.33    *                   phsubsw	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.25                        phsubw	%mm0, %mm2
# CHECK-NEXT:  1      10    0.33    *                   phsubw	(%rax), %mm2
# CHECK-NEXT:  1      3     0.25                        phsubw	%xmm0, %xmm2
# CHECK-NEXT:  1      10    0.33    *                   phsubw	(%rax), %xmm2
# CHECK-NEXT:  1      4     1.00                        pmaddubsw	%mm0, %mm2
# CHECK-NEXT:  1      11    1.00    *                   pmaddubsw	(%rax), %mm2
# CHECK-NEXT:  1      4     1.00                        pmaddubsw	%xmm0, %xmm2
# CHECK-NEXT:  1      11    1.00    *                   pmaddubsw	(%rax), %xmm2
# CHECK-NEXT:  1      4     1.00                        pmulhrsw	%mm0, %mm2
# CHECK-NEXT:  1      11    1.00    *                   pmulhrsw	(%rax), %mm2
# CHECK-NEXT:  1      4     1.00                        pmulhrsw	%xmm0, %xmm2
# CHECK-NEXT:  1      11    1.00    *                   pmulhrsw	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        pshufb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   pshufb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pshufb	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   pshufb	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        psignb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   psignb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        psignb	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   psignb	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        psignd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   psignd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        psignd	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   psignd	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        psignw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.33    *                   psignw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        psignw	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.33    *                   psignw	(%rax), %xmm2

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
# CHECK-NEXT: 10.67  10.67  10.67   -      -      -      -      -     16.00  8.00   8.00   8.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsb	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsb	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsb	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsd	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsd	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pabsw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     palignr	$1, %mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     palignr	$1, (%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     palignr	$1, %xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     palignr	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phaddd	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phaddd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phaddd	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phaddd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phaddsw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phaddsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phaddsw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phaddsw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phaddw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phaddw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phaddw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phaddw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phsubd	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phsubd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phsubd	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phsubd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phsubsw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phsubsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phsubsw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phsubsw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phsubw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phsubw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -     phsubw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -      -      -      -      -      -     phsubw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     pmaddubsw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     pmaddubsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     pmaddubsw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     pmaddubsw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     pmulhrsw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     pmulhrsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00    -      -      -      -     pmulhrsw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     1.00    -      -      -      -     pmulhrsw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pshufb	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pshufb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pshufb	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pshufb	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignb	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignb	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignb	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignd	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignd	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignw	%mm0, %mm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignw	%xmm0, %xmm2
# CHECK-NEXT: 0.33   0.33   0.33    -      -      -      -      -     0.25   0.25   0.25   0.25    -     psignw	(%rax), %xmm2
