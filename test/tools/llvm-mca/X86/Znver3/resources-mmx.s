# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver3 -instruction-tables < %s | FileCheck %s

emms

movd        %eax, %mm2
movd        (%rax), %mm2

movd        %mm0, %ecx
movd        %mm0, (%rax)

movq        %rax, %mm2
movq        (%rax), %mm2

movq        %mm0, %rcx
movq        %mm0, (%rax)

packsswb    %mm0, %mm2
packsswb    (%rax), %mm2

packssdw    %mm0, %mm2
packssdw    (%rax), %mm2

packuswb    %mm0, %mm2
packuswb    (%rax), %mm2

paddb       %mm0, %mm2
paddb       (%rax), %mm2

paddd       %mm0, %mm2
paddd       (%rax), %mm2

paddsb      %mm0, %mm2
paddsb      (%rax), %mm2

paddsw      %mm0, %mm2
paddsw      (%rax), %mm2

paddusb     %mm0, %mm2
paddusb     (%rax), %mm2

paddusw     %mm0, %mm2
paddusw     (%rax), %mm2

paddw       %mm0, %mm2
paddw       (%rax), %mm2

pand        %mm0, %mm2
pand        (%rax), %mm2

pandn       %mm0, %mm2
pandn       (%rax), %mm2

pcmpeqb     %mm0, %mm2
pcmpeqb     (%rax), %mm2

pcmpeqd     %mm0, %mm2
pcmpeqd     (%rax), %mm2

pcmpeqw     %mm0, %mm2
pcmpeqw     (%rax), %mm2

pcmpgtb     %mm0, %mm2
pcmpgtb     (%rax), %mm2

pcmpgtd     %mm0, %mm2
pcmpgtd     (%rax), %mm2

pcmpgtw     %mm0, %mm2
pcmpgtw     (%rax), %mm2

pmaddwd     %mm0, %mm2
pmaddwd     (%rax), %mm2

pmulhw      %mm0, %mm2
pmulhw      (%rax), %mm2

pmullw      %mm0, %mm2
pmullw      (%rax), %mm2

por         %mm0, %mm2
por         (%rax), %mm2

pslld       $1, %mm2
pslld       %mm0, %mm2
pslld       (%rax), %mm2

psllq       $1, %mm2
psllq       %mm0, %mm2
psllq       (%rax), %mm2

psllw       $1, %mm2
psllw       %mm0, %mm2
psllw       (%rax), %mm2

psrad       $1, %mm2
psrad       %mm0, %mm2
psrad       (%rax), %mm2

psraw       $1, %mm2
psraw       %mm0, %mm2
psraw       (%rax), %mm2

psrld       $1, %mm2
psrld       %mm0, %mm2
psrld       (%rax), %mm2

psrlq       $1, %mm2
psrlq       %mm0, %mm2
psrlq       (%rax), %mm2

psrlw       $1, %mm2
psrlw       %mm0, %mm2
psrlw       (%rax), %mm2

psubb       %mm0, %mm2
psubb       (%rax), %mm2

psubd       %mm0, %mm2
psubd       (%rax), %mm2

psubsb      %mm0, %mm2
psubsb      (%rax), %mm2

psubsw      %mm0, %mm2
psubsw      (%rax), %mm2

psubusb     %mm0, %mm2
psubusb     (%rax), %mm2

psubusw     %mm0, %mm2
psubusw     (%rax), %mm2

psubw       %mm0, %mm2
psubw       (%rax), %mm2

punpckhbw   %mm0, %mm2
punpckhbw   (%rax), %mm2

punpckhdq   %mm0, %mm2
punpckhdq   (%rax), %mm2

punpckhwd   %mm0, %mm2
punpckhwd   (%rax), %mm2

punpcklbw   %mm0, %mm2
punpcklbw   (%rax), %mm2

punpckldq   %mm0, %mm2
punpckldq   (%rax), %mm2

punpcklwd   %mm0, %mm2
punpcklwd   (%rax), %mm2

pxor        %mm0, %mm2
pxor        (%rax), %mm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      2     0.25    *      *      U     emms
# CHECK-NEXT:  2      1     1.00                        movd	%eax, %mm2
# CHECK-NEXT:  1      8     0.50    *                   movd	(%rax), %mm2
# CHECK-NEXT:  1      1     1.00                        movd	%mm0, %ecx
# CHECK-NEXT:  1      1     1.00           *      U     movd	%mm0, (%rax)
# CHECK-NEXT:  2      1     1.00                        movq	%rax, %mm2
# CHECK-NEXT:  1      8     0.50    *                   movq	(%rax), %mm2
# CHECK-NEXT:  1      1     1.00                        movq	%mm0, %rcx
# CHECK-NEXT:  1      1     1.00           *            movq	%mm0, (%rax)
# CHECK-NEXT:  1      1     0.50                        packsswb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   packsswb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        packssdw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   packssdw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        packuswb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   packuswb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        paddb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   paddb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        paddd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   paddd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        paddsb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   paddsb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        paddsw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   paddsw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        paddusb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   paddusb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        paddusw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   paddusw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        paddw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   paddw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pand	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pand	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pandn	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pandn	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pcmpeqb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpeqb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pcmpeqd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpeqd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pcmpeqw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpeqw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pcmpgtb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpgtb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pcmpgtd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpgtd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pcmpgtw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pcmpgtw	(%rax), %mm2
# CHECK-NEXT:  1      3     0.50                        pmaddwd	%mm0, %mm2
# CHECK-NEXT:  1      10    0.50    *                   pmaddwd	(%rax), %mm2
# CHECK-NEXT:  1      3     0.50                        pmulhw	%mm0, %mm2
# CHECK-NEXT:  1      10    0.50    *                   pmulhw	(%rax), %mm2
# CHECK-NEXT:  1      3     0.50                        pmullw	%mm0, %mm2
# CHECK-NEXT:  1      10    0.50    *                   pmullw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        por	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   por	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        pslld	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        pslld	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pslld	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psllq	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        psllq	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psllq	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psllw	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        psllw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psllw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psrad	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        psrad	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psrad	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psraw	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        psraw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psraw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psrld	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        psrld	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psrld	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psrlq	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        psrlq	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psrlq	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psrlw	$1, %mm2
# CHECK-NEXT:  1      1     0.50                        psrlw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psrlw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        psubb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psubb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        psubd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psubd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psubsb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psubsb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psubsw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psubsw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psubusb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psubusb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        psubusw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psubusw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        psubw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   psubw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        punpckhbw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   punpckhbw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        punpckhdq	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   punpckhdq	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        punpckhwd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   punpckhwd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        punpcklbw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   punpcklbw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        punpckldq	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   punpckldq	(%rax), %mm2
# CHECK-NEXT:  1      1     0.50                        punpcklwd	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   punpcklwd	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pxor	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pxor	(%rax), %mm2

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
# CHECK-NEXT:  -      -      -     0.25   0.25   0.25   0.25    -     19.00  37.00  33.00  15.00  27.00  27.00  2.00   16.00  16.00  16.00  15.33  15.33  15.33  1.00   1.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     emms
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00   1.00   1.00   0.50   0.50    -      -      -      -      -      -      -      -      -     movd	%eax, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     movd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -      -      -      -      -      -     movd	%mm0, %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     0.50   0.50   1.00   0.33   0.33   0.33    -      -      -     0.50   0.50   movd	%mm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00   1.00   1.00   0.50   0.50    -      -      -      -      -      -      -      -      -     movq	%rax, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     movq	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -      -      -      -      -      -     movq	%mm0, %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     0.50   0.50   1.00   0.33   0.33   0.33    -      -      -     0.50   0.50   movq	%mm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     packsswb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     packsswb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     packssdw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     packssdw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     packuswb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     packuswb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     paddb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     paddb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     paddd	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     paddd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     paddsb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     paddsb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     paddsw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     paddsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     paddusb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     paddusb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     paddusw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     paddusw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     paddw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     paddw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pand	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pand	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pandn	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pandn	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pcmpeqb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pcmpeqb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pcmpeqd	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pcmpeqd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pcmpeqw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pcmpeqw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pcmpgtb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pcmpgtb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pcmpgtd	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pcmpgtd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pcmpgtw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pcmpgtw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50    -      -     0.50    -      -      -      -      -      -      -      -      -      -      -     pmaddwd	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50    -      -     0.50   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pmaddwd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50    -      -     0.50    -      -      -      -      -      -      -      -      -      -      -     pmulhw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50    -      -     0.50   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pmulhw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50    -      -     0.50    -      -      -      -      -      -      -      -      -      -      -     pmullw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50    -      -     0.50   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pmullw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     por	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     por	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     pslld	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     pslld	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pslld	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psllq	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psllq	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psllq	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psllw	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psllw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psllw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrad	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrad	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psrad	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psraw	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psraw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psraw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrld	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrld	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psrld	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrlq	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrlq	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psrlq	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrlw	$1, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     psrlw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psrlw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     psubb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psubb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     psubd	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psubd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     psubsb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psubsb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     psubsw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psubsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     psubusb	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psubusb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -     psubusw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psubusw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     psubw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     psubw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     punpckhbw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     punpckhbw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     punpckhdq	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     punpckhdq	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     punpckhwd	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     punpckhwd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     punpcklbw	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     punpcklbw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     punpckldq	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     punpckldq	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     punpcklwd	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     0.50   0.50    -     0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     punpcklwd	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -      -      -      -      -      -      -      -      -      -      -     pxor	%mm0, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.25   0.25   0.25   0.25   0.50   0.50    -     0.33   0.33   0.33   0.33   0.33   0.33    -      -     pxor	(%rax), %mm2
