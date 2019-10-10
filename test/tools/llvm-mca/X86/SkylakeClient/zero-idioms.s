# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake -timeline -register-file-stats -iterations=1 < %s | FileCheck %s

# On SKL, renamer-based zeroing does not work for:
#  - 16 and 8-bit GPRs
#  - MMX
#  - ANDN variants

subl  %eax, %eax
subq  %rax, %rax
xorl  %eax, %eax
xorq  %rax, %rax

pcmpgtb   %mm2, %mm2
pcmpgtd   %mm2, %mm2
# pcmpgtq   %mm2, %mm2 # invalid operand for instruction
pcmpgtw   %mm2, %mm2

pcmpgtb   %xmm2, %xmm2
pcmpgtd   %xmm2, %xmm2
pcmpgtq   %xmm2, %xmm2
pcmpgtw   %xmm2, %xmm2

vpcmpgtb  %xmm3, %xmm3, %xmm3
vpcmpgtd  %xmm3, %xmm3, %xmm3
vpcmpgtq  %xmm3, %xmm3, %xmm3
vpcmpgtw  %xmm3, %xmm3, %xmm3

vpcmpgtb  %xmm3, %xmm3, %xmm5
vpcmpgtd  %xmm3, %xmm3, %xmm5
vpcmpgtq  %xmm3, %xmm3, %xmm5
vpcmpgtw  %xmm3, %xmm3, %xmm5

vpcmpgtb  %ymm3, %ymm3, %ymm3
vpcmpgtd  %ymm3, %ymm3, %ymm3
vpcmpgtq  %ymm3, %ymm3, %ymm3
vpcmpgtw  %ymm3, %ymm3, %ymm3

vpcmpgtb  %ymm3, %ymm3, %ymm5
vpcmpgtd  %ymm3, %ymm3, %ymm5
vpcmpgtq  %ymm3, %ymm3, %ymm5
vpcmpgtw  %ymm3, %ymm3, %ymm5

psubb   %mm2, %mm2
psubd   %mm2, %mm2
psubq   %mm2, %mm2
psubw   %mm2, %mm2
psubb   %xmm2, %xmm2
psubd   %xmm2, %xmm2
psubq   %xmm2, %xmm2
psubw   %xmm2, %xmm2
vpsubb  %xmm3, %xmm3, %xmm3
vpsubd  %xmm3, %xmm3, %xmm3
vpsubq  %xmm3, %xmm3, %xmm3
vpsubw  %xmm3, %xmm3, %xmm3
vpsubb  %ymm3, %ymm3, %ymm3
vpsubd  %ymm3, %ymm3, %ymm3
vpsubq  %ymm3, %ymm3, %ymm3
vpsubw  %ymm3, %ymm3, %ymm3

vpsubb  %xmm3, %xmm3, %xmm5
vpsubd  %xmm3, %xmm3, %xmm5
vpsubq  %xmm3, %xmm3, %xmm5
vpsubw  %xmm3, %xmm3, %xmm5
vpsubb  %ymm3, %ymm3, %ymm5
vpsubd  %ymm3, %ymm3, %ymm5
vpsubq  %ymm3, %ymm3, %ymm5
vpsubw  %ymm3, %ymm3, %ymm5

andnps  %xmm0, %xmm0
andnpd  %xmm1, %xmm1
vandnps %xmm2, %xmm2, %xmm2
vandnpd %xmm1, %xmm1, %xmm1
vandnps %ymm2, %ymm2, %ymm2
vandnpd %ymm1, %ymm1, %ymm1
pandn   %mm2, %mm2
pandn   %xmm2, %xmm2
vpandn  %xmm3, %xmm3, %xmm3
vpandn  %ymm3, %ymm3, %ymm3

vandnps %xmm2, %xmm2, %xmm5
vandnpd %xmm1, %xmm1, %xmm5
vpandn  %xmm3, %xmm3, %xmm5
vandnps %ymm2, %ymm2, %ymm5
vandnpd %ymm1, %ymm1, %ymm5
vpandn  %ymm3, %ymm3, %ymm5

xorps  %xmm0, %xmm0
xorpd  %xmm1, %xmm1
vxorps %xmm2, %xmm2, %xmm2
vxorpd %xmm1, %xmm1, %xmm1
vxorps %ymm2, %ymm2, %ymm2
vxorpd %ymm1, %ymm1, %ymm1
pxor   %mm2, %mm2
pxor   %xmm2, %xmm2
vpxor  %xmm3, %xmm3, %xmm3
vpxor  %ymm3, %ymm3, %ymm3

vxorps %xmm4, %xmm4, %xmm5
vxorpd %xmm1, %xmm1, %xmm3
vxorps %ymm4, %ymm4, %ymm5
vxorpd %ymm1, %ymm1, %ymm3
vpxor  %xmm3, %xmm3, %xmm5
vpxor  %ymm3, %ymm3, %ymm5

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      83
# CHECK-NEXT: Total Cycles:      17
# CHECK-NEXT: Total uOps:        83

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    4.88
# CHECK-NEXT: IPC:               4.88
# CHECK-NEXT: Block RThroughput: 13.8

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.17                        subl	%eax, %eax
# CHECK-NEXT:  1      0     0.17                        subq	%rax, %rax
# CHECK-NEXT:  1      0     0.17                        xorl	%eax, %eax
# CHECK-NEXT:  1      0     0.17                        xorq	%rax, %rax
# CHECK-NEXT:  1      1     1.00                        pcmpgtb	%mm2, %mm2
# CHECK-NEXT:  1      1     1.00                        pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  1      1     1.00                        pcmpgtw	%mm2, %mm2
# CHECK-NEXT:  1      0     0.17                        pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpcmpgtb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpcmpgtb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      0     0.17                        vpcmpgtd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      0     0.17                        vpcmpgtq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      0     0.17                        vpcmpgtw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      1     0.50                        psubb	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubd	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubq	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubw	%mm2, %mm2
# CHECK-NEXT:  1      0     0.17                        psubb	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        psubd	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        psubq	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        psubw	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpsubb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpsubd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpsubq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpsubw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpsubb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      0     0.17                        vpsubd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      0     0.17                        vpsubq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      0     0.17                        vpsubw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      1     0.33                        andnps	%xmm0, %xmm0
# CHECK-NEXT:  1      1     0.33                        andnpd	%xmm1, %xmm1
# CHECK-NEXT:  1      1     0.33                        vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  1      1     0.33                        vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  1      1     0.33                        vandnps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT:  1      1     0.33                        vandnpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  1      1     0.50                        pandn	%mm2, %mm2
# CHECK-NEXT:  1      1     0.33                        pandn	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.33                        vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      1     0.33                        vpandn	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      1     0.33                        vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT:  1      1     0.33                        vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT:  1      1     0.33                        vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      1     0.33                        vandnps	%ymm2, %ymm2, %ymm5
# CHECK-NEXT:  1      1     0.33                        vandnpd	%ymm1, %ymm1, %ymm5
# CHECK-NEXT:  1      1     0.33                        vpandn	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  1      0     0.17                        xorps	%xmm0, %xmm0
# CHECK-NEXT:  1      0     0.17                        xorpd	%xmm1, %xmm1
# CHECK-NEXT:  1      0     0.17                        vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  1      0     0.17                        vxorps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT:  1      0     0.17                        vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  1      1     0.50                        pxor	%mm2, %mm2
# CHECK-NEXT:  1      0     0.17                        pxor	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.17                        vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.17                        vpxor	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  1      0     0.17                        vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT:  1      0     0.17                        vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT:  1      0     0.17                        vxorps	%ymm4, %ymm4, %ymm5
# CHECK-NEXT:  1      0     0.17                        vxorpd	%ymm1, %ymm1, %ymm3
# CHECK-NEXT:  1      0     0.17                        vpxor	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.17                        vpxor	%ymm3, %ymm3, %ymm5

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    87
# CHECK-NEXT: Max number of mappings used:         30

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SKLDivider
# CHECK-NEXT: [1]   - SKLFPDivider
# CHECK-NEXT: [2]   - SKLPort0
# CHECK-NEXT: [3]   - SKLPort1
# CHECK-NEXT: [4]   - SKLPort2
# CHECK-NEXT: [5]   - SKLPort3
# CHECK-NEXT: [6]   - SKLPort4
# CHECK-NEXT: [7]   - SKLPort5
# CHECK-NEXT: [8]   - SKLPort6
# CHECK-NEXT: [9]   - SKLPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     10.00  6.00    -      -      -     8.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     subl	%eax, %eax
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     subq	%rax, %rax
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     xorl	%eax, %eax
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     xorq	%rax, %rax
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     pcmpgtb	%mm2, %mm2
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     pcmpgtw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpcmpgtw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     psubb	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     psubd	%mm2, %mm2
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     psubq	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     psubw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     psubb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     psubd	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     psubq	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     psubw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpsubw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -      -      -     andnps	%xmm0, %xmm0
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     andnpd	%xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -      -      -     vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vandnps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -      -      -     vandnpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     pandn	%mm2, %mm2
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     pandn	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -      -      -     vpandn	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -      -      -     vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     vandnps	%ymm2, %ymm2, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -     vandnpd	%ymm1, %ymm1, %ymm5
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -      -      -     vpandn	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     xorps	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     xorpd	%xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -      -      -     pxor	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     pxor	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpxor	%ymm3, %ymm3, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorps	%ymm4, %ymm4, %ymm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vxorpd	%ymm1, %ymm1, %ymm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpxor	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     vpxor	%ymm3, %ymm3, %ymm5

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DR   .    .    ..   subl	%eax, %eax
# CHECK-NEXT: [0,1]     DR   .    .    ..   subq	%rax, %rax
# CHECK-NEXT: [0,2]     DR   .    .    ..   xorl	%eax, %eax
# CHECK-NEXT: [0,3]     DR   .    .    ..   xorq	%rax, %rax
# CHECK-NEXT: [0,4]     DeER .    .    ..   pcmpgtb	%mm2, %mm2
# CHECK-NEXT: [0,5]     D=eER.    .    ..   pcmpgtd	%mm2, %mm2
# CHECK-NEXT: [0,6]     .D=eER    .    ..   pcmpgtw	%mm2, %mm2
# CHECK-NEXT: [0,7]     .D---R    .    ..   pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: [0,8]     .D---R    .    ..   pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: [0,9]     .D---R    .    ..   pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: [0,10]    .D---R    .    ..   pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: [0,11]    .D---R    .    ..   vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,12]    . D--R    .    ..   vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,13]    . D--R    .    ..   vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,14]    . D--R    .    ..   vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,15]    . D--R    .    ..   vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,16]    . D--R    .    ..   vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,17]    . D--R    .    ..   vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,18]    .  D-R    .    ..   vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,19]    .  D-R    .    ..   vpcmpgtb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,20]    .  D-R    .    ..   vpcmpgtd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,21]    .  D-R    .    ..   vpcmpgtq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,22]    .  D-R    .    ..   vpcmpgtw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,23]    .  D-R    .    ..   vpcmpgtb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,24]    .   DR    .    ..   vpcmpgtd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,25]    .   DR    .    ..   vpcmpgtq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,26]    .   DR    .    ..   vpcmpgtw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,27]    .   DeER  .    ..   psubb	%mm2, %mm2
# CHECK-NEXT: [0,28]    .   D=eER .    ..   psubd	%mm2, %mm2
# CHECK-NEXT: [0,29]    .   D==eER.    ..   psubq	%mm2, %mm2
# CHECK-NEXT: [0,30]    .    D==eER    ..   psubw	%mm2, %mm2
# CHECK-NEXT: [0,31]    .    D----R    ..   psubb	%xmm2, %xmm2
# CHECK-NEXT: [0,32]    .    D----R    ..   psubd	%xmm2, %xmm2
# CHECK-NEXT: [0,33]    .    D----R    ..   psubq	%xmm2, %xmm2
# CHECK-NEXT: [0,34]    .    D----R    ..   psubw	%xmm2, %xmm2
# CHECK-NEXT: [0,35]    .    D----R    ..   vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,36]    .    .D---R    ..   vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,37]    .    .D---R    ..   vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,38]    .    .D---R    ..   vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,39]    .    .D---R    ..   vpsubb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,40]    .    .D---R    ..   vpsubd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,41]    .    .D---R    ..   vpsubq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,42]    .    . D--R    ..   vpsubw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,43]    .    . D--R    ..   vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,44]    .    . D--R    ..   vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,45]    .    . D--R    ..   vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,46]    .    . D--R    ..   vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,47]    .    . D--R    ..   vpsubb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,48]    .    .  D-R    ..   vpsubd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,49]    .    .  D-R    ..   vpsubq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,50]    .    .  D-R    ..   vpsubw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,51]    .    .  DeER   ..   andnps	%xmm0, %xmm0
# CHECK-NEXT: [0,52]    .    .  DeER   ..   andnpd	%xmm1, %xmm1
# CHECK-NEXT: [0,53]    .    .  DeER   ..   vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: [0,54]    .    .   DeER  ..   vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: [0,55]    .    .   DeER  ..   vandnps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT: [0,56]    .    .   D=eER ..   vandnpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [0,57]    .    .   DeE-R ..   pandn	%mm2, %mm2
# CHECK-NEXT: [0,58]    .    .   D=eER ..   pandn	%xmm2, %xmm2
# CHECK-NEXT: [0,59]    .    .   D=eER ..   vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,60]    .    .    D=eER..   vpandn	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,61]    .    .    D=eER..   vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT: [0,62]    .    .    D=eER..   vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT: [0,63]    .    .    D==eER.   vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,64]    .    .    D==eER.   vandnps	%ymm2, %ymm2, %ymm5
# CHECK-NEXT: [0,65]    .    .    D==eER.   vandnpd	%ymm1, %ymm1, %ymm5
# CHECK-NEXT: [0,66]    .    .    .D==eER   vpandn	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: [0,67]    .    .    .D----R   xorps	%xmm0, %xmm0
# CHECK-NEXT: [0,68]    .    .    .DE---R   xorpd	%xmm1, %xmm1
# CHECK-NEXT: [0,69]    .    .    .DE---R   vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: [0,70]    .    .    .DE---R   vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: [0,71]    .    .    .DE---R   vxorps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT: [0,72]    .    .    . D---R   vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [0,73]    .    .    . D=eER   pxor	%mm2, %mm2
# CHECK-NEXT: [0,74]    .    .    . D---R   pxor	%xmm2, %xmm2
# CHECK-NEXT: [0,75]    .    .    . DE--R   vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,76]    .    .    . DE--R   vpxor	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: [0,77]    .    .    . D---R   vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT: [0,78]    .    .    .  D--R   vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT: [0,79]    .    .    .  D--R   vxorps	%ymm4, %ymm4, %ymm5
# CHECK-NEXT: [0,80]    .    .    .  D--R   vxorpd	%ymm1, %ymm1, %ymm3
# CHECK-NEXT: [0,81]    .    .    .  D--R   vpxor	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,82]    .    .    .  D--R   vpxor	%ymm3, %ymm3, %ymm5

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     0.0    0.0    0.0       subl	%eax, %eax
# CHECK-NEXT: 1.     1     0.0    0.0    0.0       subq	%rax, %rax
# CHECK-NEXT: 2.     1     0.0    0.0    0.0       xorl	%eax, %eax
# CHECK-NEXT: 3.     1     0.0    0.0    0.0       xorq	%rax, %rax
# CHECK-NEXT: 4.     1     1.0    1.0    0.0       pcmpgtb	%mm2, %mm2
# CHECK-NEXT: 5.     1     2.0    0.0    0.0       pcmpgtd	%mm2, %mm2
# CHECK-NEXT: 6.     1     2.0    0.0    0.0       pcmpgtw	%mm2, %mm2
# CHECK-NEXT: 7.     1     0.0    0.0    3.0       pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: 8.     1     0.0    0.0    3.0       pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: 9.     1     0.0    0.0    3.0       pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: 10.    1     0.0    0.0    3.0       pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: 11.    1     0.0    0.0    3.0       vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 12.    1     0.0    0.0    2.0       vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 13.    1     0.0    0.0    2.0       vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 14.    1     0.0    0.0    2.0       vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 15.    1     0.0    0.0    2.0       vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 16.    1     0.0    0.0    2.0       vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 17.    1     0.0    0.0    2.0       vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 18.    1     0.0    0.0    1.0       vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 19.    1     0.0    0.0    1.0       vpcmpgtb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 20.    1     0.0    0.0    1.0       vpcmpgtd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 21.    1     0.0    0.0    1.0       vpcmpgtq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 22.    1     0.0    0.0    1.0       vpcmpgtw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 23.    1     0.0    0.0    1.0       vpcmpgtb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 24.    1     0.0    0.0    0.0       vpcmpgtd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 25.    1     0.0    0.0    0.0       vpcmpgtq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 26.    1     0.0    0.0    0.0       vpcmpgtw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 27.    1     1.0    1.0    0.0       psubb	%mm2, %mm2
# CHECK-NEXT: 28.    1     2.0    0.0    0.0       psubd	%mm2, %mm2
# CHECK-NEXT: 29.    1     3.0    0.0    0.0       psubq	%mm2, %mm2
# CHECK-NEXT: 30.    1     3.0    0.0    0.0       psubw	%mm2, %mm2
# CHECK-NEXT: 31.    1     0.0    0.0    4.0       psubb	%xmm2, %xmm2
# CHECK-NEXT: 32.    1     0.0    0.0    4.0       psubd	%xmm2, %xmm2
# CHECK-NEXT: 33.    1     0.0    0.0    4.0       psubq	%xmm2, %xmm2
# CHECK-NEXT: 34.    1     0.0    0.0    4.0       psubw	%xmm2, %xmm2
# CHECK-NEXT: 35.    1     0.0    0.0    4.0       vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 36.    1     0.0    0.0    3.0       vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 37.    1     0.0    0.0    3.0       vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 38.    1     0.0    0.0    3.0       vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 39.    1     0.0    0.0    3.0       vpsubb	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 40.    1     0.0    0.0    3.0       vpsubd	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 41.    1     0.0    0.0    3.0       vpsubq	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 42.    1     0.0    0.0    2.0       vpsubw	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 43.    1     0.0    0.0    2.0       vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 44.    1     0.0    0.0    2.0       vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 45.    1     0.0    0.0    2.0       vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 46.    1     0.0    0.0    2.0       vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 47.    1     0.0    0.0    2.0       vpsubb	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 48.    1     0.0    0.0    1.0       vpsubd	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 49.    1     0.0    0.0    1.0       vpsubq	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 50.    1     0.0    0.0    1.0       vpsubw	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 51.    1     1.0    1.0    0.0       andnps	%xmm0, %xmm0
# CHECK-NEXT: 52.    1     1.0    1.0    0.0       andnpd	%xmm1, %xmm1
# CHECK-NEXT: 53.    1     1.0    1.0    0.0       vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: 54.    1     1.0    0.0    0.0       vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: 55.    1     1.0    0.0    0.0       vandnps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT: 56.    1     2.0    0.0    0.0       vandnpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: 57.    1     1.0    1.0    1.0       pandn	%mm2, %mm2
# CHECK-NEXT: 58.    1     2.0    0.0    0.0       pandn	%xmm2, %xmm2
# CHECK-NEXT: 59.    1     2.0    2.0    0.0       vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 60.    1     2.0    0.0    0.0       vpandn	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 61.    1     2.0    0.0    0.0       vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT: 62.    1     2.0    0.0    0.0       vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT: 63.    1     3.0    0.0    0.0       vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 64.    1     3.0    1.0    0.0       vandnps	%ymm2, %ymm2, %ymm5
# CHECK-NEXT: 65.    1     3.0    1.0    0.0       vandnpd	%ymm1, %ymm1, %ymm5
# CHECK-NEXT: 66.    1     3.0    1.0    0.0       vpandn	%ymm3, %ymm3, %ymm5
# CHECK-NEXT: 67.    1     0.0    0.0    4.0       xorps	%xmm0, %xmm0
# CHECK-NEXT: 68.    1     1.0    0.0    3.0       xorpd	%xmm1, %xmm1
# CHECK-NEXT: 69.    1     1.0    0.0    3.0       vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: 70.    1     1.0    0.0    3.0       vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: 71.    1     1.0    0.0    3.0       vxorps	%ymm2, %ymm2, %ymm2
# CHECK-NEXT: 72.    1     0.0    0.0    3.0       vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: 73.    1     2.0    2.0    0.0       pxor	%mm2, %mm2
# CHECK-NEXT: 74.    1     0.0    0.0    3.0       pxor	%xmm2, %xmm2
# CHECK-NEXT: 75.    1     1.0    0.0    2.0       vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 76.    1     1.0    0.0    2.0       vpxor	%ymm3, %ymm3, %ymm3
# CHECK-NEXT: 77.    1     0.0    0.0    3.0       vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT: 78.    1     0.0    0.0    2.0       vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT: 79.    1     0.0    0.0    2.0       vxorps	%ymm4, %ymm4, %ymm5
# CHECK-NEXT: 80.    1     0.0    0.0    2.0       vxorpd	%ymm1, %ymm1, %ymm3
# CHECK-NEXT: 81.    1     0.0    0.0    2.0       vpxor	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 82.    1     0.0    0.0    2.0       vpxor	%ymm3, %ymm3, %ymm5
# CHECK-NEXT:        1     0.6    0.2    1.5       <total>
