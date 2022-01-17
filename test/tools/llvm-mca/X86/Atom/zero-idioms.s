# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=atom -timeline -register-file-stats -iterations=1 < %s | FileCheck %s

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

psubb   %mm2, %mm2
psubd   %mm2, %mm2
psubq   %mm2, %mm2
psubw   %mm2, %mm2
psubb   %xmm2, %xmm2
psubd   %xmm2, %xmm2
psubq   %xmm2, %xmm2
psubw   %xmm2, %xmm2

psubsb   %mm2, %mm2
psubsw   %mm2, %mm2
psubsb   %xmm2, %xmm2
psubsw   %xmm2, %xmm2

psubusb   %mm2, %mm2
psubusw   %mm2, %mm2
psubusb   %xmm2, %xmm2
psubusw   %xmm2, %xmm2

andnps  %xmm0, %xmm0
andnpd  %xmm1, %xmm1
pandn   %mm2, %mm2
pandn   %xmm2, %xmm2
vpandn  %xmm3, %xmm3, %xmm3

xorps  %xmm0, %xmm0
xorpd  %xmm1, %xmm1
pxor   %mm2, %mm2
pxor   %xmm2, %xmm2

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      36
# CHECK-NEXT: Total Cycles:      26
# CHECK-NEXT: Total uOps:        36

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    1.38
# CHECK-NEXT: IPC:               1.38
# CHECK-NEXT: Block RThroughput: 19.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        subl	%eax, %eax
# CHECK-NEXT:  1      1     0.50                        subq	%rax, %rax
# CHECK-NEXT:  1      1     0.50                        xorl	%eax, %eax
# CHECK-NEXT:  1      1     0.50                        xorq	%rax, %rax
# CHECK-NEXT:  1      1     0.50                        pcmpgtb	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtw	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubb	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubd	%mm2, %mm2
# CHECK-NEXT:  1      2     1.00                        psubq	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubw	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubb	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubd	%xmm2, %xmm2
# CHECK-NEXT:  1      2     1.00                        psubq	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubw	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubsb	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubsw	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubsb	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubsw	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubusb	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubusw	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubusb	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubusw	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        andnps	%xmm0, %xmm0
# CHECK-NEXT:  1      1     0.50                        andnpd	%xmm1, %xmm1
# CHECK-NEXT:  1      1     0.50                        pandn	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        pandn	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      1     0.50                        xorps	%xmm0, %xmm0
# CHECK-NEXT:  1      1     0.50                        xorpd	%xmm1, %xmm1
# CHECK-NEXT:  1      1     0.50                        pxor	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        pxor	%xmm2, %xmm2

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    40
# CHECK-NEXT: Max number of mappings used:         3

# CHECK:      Resources:
# CHECK-NEXT: [0]   - AtomPort0
# CHECK-NEXT: [1]   - AtomPort1

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]
# CHECK-NEXT: 20.00  18.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    Instructions:
# CHECK-NEXT:  -     1.00   subl	%eax, %eax
# CHECK-NEXT: 1.00    -     subq	%rax, %rax
# CHECK-NEXT:  -     1.00   xorl	%eax, %eax
# CHECK-NEXT: 1.00    -     xorq	%rax, %rax
# CHECK-NEXT:  -     1.00   pcmpgtb	%mm2, %mm2
# CHECK-NEXT: 1.00    -     pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  -     1.00   pcmpgtw	%mm2, %mm2
# CHECK-NEXT: 1.00    -     pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  -     1.00   pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: 1.00    -     pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  -     1.00   pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: 1.00    -     psubb	%mm2, %mm2
# CHECK-NEXT:  -     1.00   psubd	%mm2, %mm2
# CHECK-NEXT: 2.00    -     psubq	%mm2, %mm2
# CHECK-NEXT:  -     1.00   psubw	%mm2, %mm2
# CHECK-NEXT: 1.00    -     psubb	%xmm2, %xmm2
# CHECK-NEXT:  -     1.00   psubd	%xmm2, %xmm2
# CHECK-NEXT: 2.00    -     psubq	%xmm2, %xmm2
# CHECK-NEXT:  -     1.00   psubw	%xmm2, %xmm2
# CHECK-NEXT: 1.00    -     psubsb	%mm2, %mm2
# CHECK-NEXT:  -     1.00   psubsw	%mm2, %mm2
# CHECK-NEXT: 1.00    -     psubsb	%xmm2, %xmm2
# CHECK-NEXT:  -     1.00   psubsw	%xmm2, %xmm2
# CHECK-NEXT: 1.00    -     psubusb	%mm2, %mm2
# CHECK-NEXT:  -     1.00   psubusw	%mm2, %mm2
# CHECK-NEXT: 1.00    -     psubusb	%xmm2, %xmm2
# CHECK-NEXT:  -     1.00   psubusw	%xmm2, %xmm2
# CHECK-NEXT: 1.00    -     andnps	%xmm0, %xmm0
# CHECK-NEXT:  -     1.00   andnpd	%xmm1, %xmm1
# CHECK-NEXT: 1.00    -     pandn	%mm2, %mm2
# CHECK-NEXT:  -     1.00   pandn	%xmm2, %xmm2
# CHECK-NEXT: 1.00    -     vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -     1.00   xorps	%xmm0, %xmm0
# CHECK-NEXT: 1.00    -     xorpd	%xmm1, %xmm1
# CHECK-NEXT:  -     1.00   pxor	%mm2, %mm2
# CHECK-NEXT: 1.00    -     pxor	%xmm2, %xmm2

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012345

# CHECK:      [0,0]     DE   .    .    .    .    .   subl	%eax, %eax
# CHECK-NEXT: [0,1]     .DE  .    .    .    .    .   subq	%rax, %rax
# CHECK-NEXT: [0,2]     . DE .    .    .    .    .   xorl	%eax, %eax
# CHECK-NEXT: [0,3]     .  DE.    .    .    .    .   xorq	%rax, %rax
# CHECK-NEXT: [0,4]     .  DE.    .    .    .    .   pcmpgtb	%mm2, %mm2
# CHECK-NEXT: [0,5]     .   DE    .    .    .    .   pcmpgtd	%mm2, %mm2
# CHECK-NEXT: [0,6]     .    DE   .    .    .    .   pcmpgtw	%mm2, %mm2
# CHECK-NEXT: [0,7]     .    DE   .    .    .    .   pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: [0,8]     .    .DE  .    .    .    .   pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: [0,9]     .    . DE .    .    .    .   pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: [0,10]    .    .  DE.    .    .    .   pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: [0,11]    .    .  DE.    .    .    .   psubb	%mm2, %mm2
# CHECK-NEXT: [0,12]    .    .   DE    .    .    .   psubd	%mm2, %mm2
# CHECK-NEXT: [0,13]    .    .    DeE  .    .    .   psubq	%mm2, %mm2
# CHECK-NEXT: [0,14]    .    .    . DE .    .    .   psubw	%mm2, %mm2
# CHECK-NEXT: [0,15]    .    .    . DE .    .    .   psubb	%xmm2, %xmm2
# CHECK-NEXT: [0,16]    .    .    .  DE.    .    .   psubd	%xmm2, %xmm2
# CHECK-NEXT: [0,17]    .    .    .   DeE   .    .   psubq	%xmm2, %xmm2
# CHECK-NEXT: [0,18]    .    .    .    .DE  .    .   psubw	%xmm2, %xmm2
# CHECK-NEXT: [0,19]    .    .    .    .DE  .    .   psubsb	%mm2, %mm2
# CHECK-NEXT: [0,20]    .    .    .    . DE .    .   psubsw	%mm2, %mm2
# CHECK-NEXT: [0,21]    .    .    .    . DE .    .   psubsb	%xmm2, %xmm2
# CHECK-NEXT: [0,22]    .    .    .    .  DE.    .   psubsw	%xmm2, %xmm2
# CHECK-NEXT: [0,23]    .    .    .    .  DE.    .   psubusb	%mm2, %mm2
# CHECK-NEXT: [0,24]    .    .    .    .   DE    .   psubusw	%mm2, %mm2
# CHECK-NEXT: [0,25]    .    .    .    .   DE    .   psubusb	%xmm2, %xmm2
# CHECK-NEXT: [0,26]    .    .    .    .    DE   .   psubusw	%xmm2, %xmm2
# CHECK-NEXT: [0,27]    .    .    .    .    DE   .   andnps	%xmm0, %xmm0
# CHECK-NEXT: [0,28]    .    .    .    .    .DE  .   andnpd	%xmm1, %xmm1
# CHECK-NEXT: [0,29]    .    .    .    .    .DE  .   pandn	%mm2, %mm2
# CHECK-NEXT: [0,30]    .    .    .    .    . DE .   pandn	%xmm2, %xmm2
# CHECK-NEXT: [0,31]    .    .    .    .    . DE .   vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,32]    .    .    .    .    .  DE.   xorps	%xmm0, %xmm0
# CHECK-NEXT: [0,33]    .    .    .    .    .  DE.   xorpd	%xmm1, %xmm1
# CHECK-NEXT: [0,34]    .    .    .    .    .   DE   pxor	%mm2, %mm2
# CHECK-NEXT: [0,35]    .    .    .    .    .   DE   pxor	%xmm2, %xmm2

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
# CHECK-NEXT: 4.     1     0.0    0.0    0.0       pcmpgtb	%mm2, %mm2
# CHECK-NEXT: 5.     1     0.0    0.0    0.0       pcmpgtd	%mm2, %mm2
# CHECK-NEXT: 6.     1     0.0    0.0    0.0       pcmpgtw	%mm2, %mm2
# CHECK-NEXT: 7.     1     0.0    0.0    0.0       pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: 8.     1     0.0    0.0    0.0       pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: 9.     1     0.0    0.0    0.0       pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: 10.    1     0.0    0.0    0.0       pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: 11.    1     0.0    0.0    0.0       psubb	%mm2, %mm2
# CHECK-NEXT: 12.    1     0.0    0.0    0.0       psubd	%mm2, %mm2
# CHECK-NEXT: 13.    1     0.0    0.0    0.0       psubq	%mm2, %mm2
# CHECK-NEXT: 14.    1     0.0    0.0    0.0       psubw	%mm2, %mm2
# CHECK-NEXT: 15.    1     0.0    0.0    0.0       psubb	%xmm2, %xmm2
# CHECK-NEXT: 16.    1     0.0    0.0    0.0       psubd	%xmm2, %xmm2
# CHECK-NEXT: 17.    1     0.0    0.0    0.0       psubq	%xmm2, %xmm2
# CHECK-NEXT: 18.    1     0.0    0.0    0.0       psubw	%xmm2, %xmm2
# CHECK-NEXT: 19.    1     0.0    0.0    0.0       psubsb	%mm2, %mm2
# CHECK-NEXT: 20.    1     0.0    0.0    0.0       psubsw	%mm2, %mm2
# CHECK-NEXT: 21.    1     0.0    0.0    0.0       psubsb	%xmm2, %xmm2
# CHECK-NEXT: 22.    1     0.0    0.0    0.0       psubsw	%xmm2, %xmm2
# CHECK-NEXT: 23.    1     0.0    0.0    0.0       psubusb	%mm2, %mm2
# CHECK-NEXT: 24.    1     0.0    0.0    0.0       psubusw	%mm2, %mm2
# CHECK-NEXT: 25.    1     0.0    0.0    0.0       psubusb	%xmm2, %xmm2
# CHECK-NEXT: 26.    1     0.0    0.0    0.0       psubusw	%xmm2, %xmm2
# CHECK-NEXT: 27.    1     0.0    0.0    0.0       andnps	%xmm0, %xmm0
# CHECK-NEXT: 28.    1     0.0    0.0    0.0       andnpd	%xmm1, %xmm1
# CHECK-NEXT: 29.    1     0.0    0.0    0.0       pandn	%mm2, %mm2
# CHECK-NEXT: 30.    1     0.0    0.0    0.0       pandn	%xmm2, %xmm2
# CHECK-NEXT: 31.    1     0.0    0.0    0.0       vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 32.    1     0.0    0.0    0.0       xorps	%xmm0, %xmm0
# CHECK-NEXT: 33.    1     0.0    0.0    0.0       xorpd	%xmm1, %xmm1
# CHECK-NEXT: 34.    1     0.0    0.0    0.0       pxor	%mm2, %mm2
# CHECK-NEXT: 35.    1     0.0    0.0    0.0       pxor	%xmm2, %xmm2
# CHECK-NEXT:        1     0.0    0.0    0.0       <total>
