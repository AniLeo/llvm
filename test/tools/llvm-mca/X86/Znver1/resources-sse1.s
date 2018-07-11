# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver1 -instruction-tables < %s | FileCheck %s

addps       %xmm0, %xmm2
addps       (%rax), %xmm2

addss       %xmm0, %xmm2
addss       (%rax), %xmm2

andnps      %xmm0, %xmm2
andnps      (%rax), %xmm2

andps       %xmm0, %xmm2
andps       (%rax), %xmm2

cmpps       $0, %xmm0, %xmm2
cmpps       $0, (%rax), %xmm2

cmpss       $0, %xmm0, %xmm2
cmpss       $0, (%rax), %xmm2

comiss      %xmm0, %xmm1
comiss      (%rax), %xmm1

cvtpi2ps    %mm0, %xmm2
cvtpi2ps    (%rax), %xmm2

cvtps2pi    %xmm0, %mm2
cvtps2pi    (%rax), %mm2

cvtsi2ss    %ecx, %xmm2
cvtsi2ss    %rcx, %xmm2
cvtsi2ss    (%rax), %xmm2
cvtsi2ss    (%rax), %xmm2

cvtss2si    %xmm0, %ecx
cvtss2si    %xmm0, %rcx
cvtss2si    (%rax), %ecx
cvtss2si    (%rax), %rcx

cvttps2pi   %xmm0, %mm2
cvttps2pi   (%rax), %mm2

cvttss2si   %xmm0, %ecx
cvttss2si   %xmm0, %rcx
cvttss2si   (%rax), %ecx
cvttss2si   (%rax), %rcx

divps       %xmm0, %xmm2
divps       (%rax), %xmm2

divss       %xmm0, %xmm2
divss       (%rax), %xmm2

ldmxcsr     (%rax)

maskmovq    %mm0, %mm1

maxps       %xmm0, %xmm2
maxps       (%rax), %xmm2

maxss       %xmm0, %xmm2
maxss       (%rax), %xmm2

minps       %xmm0, %xmm2
minps       (%rax), %xmm2

minss       %xmm0, %xmm2
minss       (%rax), %xmm2

movaps      %xmm0, %xmm2
movaps      %xmm0, (%rax)
movaps      (%rax), %xmm2

movhlps     %xmm0, %xmm2
movlhps     %xmm0, %xmm2

movhps      %xmm0, (%rax)
movhps      (%rax), %xmm2

movlps      %xmm0, (%rax)
movlps      (%rax), %xmm2

movmskps    %xmm0, %rcx

movntps     %xmm0, (%rax)
movntq      %mm0, (%rax)

movss       %xmm0, %xmm2
movss       %xmm0, (%rax)
movss       (%rax), %xmm2

movups      %xmm0, %xmm2
movups      %xmm0, (%rax)
movups      (%rax), %xmm2

mulps       %xmm0, %xmm2
mulps       (%rax), %xmm2

mulss       %xmm0, %xmm2
mulss       (%rax), %xmm2

orps        %xmm0, %xmm2
orps        (%rax), %xmm2

pavgb       %mm0, %mm2
pavgb       (%rax), %mm2

pavgw       %mm0, %mm2
pavgw       (%rax), %mm2

pextrw      $1, %mm0, %rcx

pinsrw      $1, %rax, %mm2
pinsrw      $1, (%rax), %mm2

pmaxsw      %mm0, %mm2
pmaxsw      (%rax), %mm2

pmaxub      %mm0, %mm2
pmaxub      (%rax), %mm2

pminsw      %mm0, %mm2
pminsw      (%rax), %mm2

pminub      %mm0, %mm2
pminub      (%rax), %mm2

pmovmskb    %xmm0, %rcx

pmulhuw     %mm0, %mm2
pmulhuw     (%rax), %mm2

prefetcht0  (%rax)
prefetcht1  (%rax)
prefetcht2  (%rax)
prefetchnta (%rax)

psadbw      %mm0, %mm2
psadbw      (%rax), %mm2

pshufw      $1, %mm0, %mm2
pshufw      $1, (%rax), %mm2

rcpps       %xmm0, %xmm2
rcpps       (%rax), %xmm2

rcpss       %xmm0, %xmm2
rcpss       (%rax), %xmm2

rsqrtps     %xmm0, %xmm2
rsqrtps     (%rax), %xmm2

rsqrtss     %xmm0, %xmm2
rsqrtss     (%rax), %xmm2

sfence

shufps      $1, %xmm0, %xmm2
shufps      $1, (%rax), %xmm2

sqrtps      %xmm0, %xmm2
sqrtps      (%rax), %xmm2

sqrtss      %xmm0, %xmm2
sqrtss      (%rax), %xmm2

stmxcsr     (%rax)

subps       %xmm0, %xmm2
subps       (%rax), %xmm2

subss       %xmm0, %xmm2
subss       (%rax), %xmm2

ucomiss     %xmm0, %xmm1
ucomiss     (%rax), %xmm1

unpckhps    %xmm0, %xmm2
unpckhps    (%rax), %xmm2

unpcklps    %xmm0, %xmm2
unpcklps    (%rax), %xmm2

xorps       %xmm0, %xmm2
xorps       (%rax), %xmm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        addps	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   addps	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        addss	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   addss	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        andnps	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   andnps	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        andps	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   andps	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        cmpps	$0, %xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   cmpps	$0, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        cmpss	$0, %xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   cmpss	$0, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        comiss	%xmm0, %xmm1
# CHECK-NEXT:  1      10    1.00    *                   comiss	(%rax), %xmm1
# CHECK-NEXT:  1      5     1.00                        cvtpi2ps	%mm0, %xmm2
# CHECK-NEXT:  1      12    1.00    *                   cvtpi2ps	(%rax), %xmm2
# CHECK-NEXT:  1      4     1.00                        cvtps2pi	%xmm0, %mm2
# CHECK-NEXT:  1      12    1.00    *                   cvtps2pi	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        cvtsi2ssl	%ecx, %xmm2
# CHECK-NEXT:  1      5     1.00                        cvtsi2ssq	%rcx, %xmm2
# CHECK-NEXT:  1      12    1.00    *                   cvtsi2ssl	(%rax), %xmm2
# CHECK-NEXT:  1      12    1.00    *                   cvtsi2ssl	(%rax), %xmm2
# CHECK-NEXT:  1      5     1.00                        cvtss2si	%xmm0, %ecx
# CHECK-NEXT:  1      5     1.00                        cvtss2si	%xmm0, %rcx
# CHECK-NEXT:  2      12    1.00    *                   cvtss2si	(%rax), %ecx
# CHECK-NEXT:  2      12    1.00    *                   cvtss2si	(%rax), %rcx
# CHECK-NEXT:  1      4     1.00                        cvttps2pi	%xmm0, %mm2
# CHECK-NEXT:  1      12    1.00    *                   cvttps2pi	(%rax), %mm2
# CHECK-NEXT:  1      5     1.00                        cvttss2si	%xmm0, %ecx
# CHECK-NEXT:  1      5     1.00                        cvttss2si	%xmm0, %rcx
# CHECK-NEXT:  2      12    1.00    *                   cvttss2si	(%rax), %ecx
# CHECK-NEXT:  2      12    1.00    *                   cvttss2si	(%rax), %rcx
# CHECK-NEXT:  1      15    1.00                        divps	%xmm0, %xmm2
# CHECK-NEXT:  1      22    1.00    *                   divps	(%rax), %xmm2
# CHECK-NEXT:  1      15    1.00                        divss	%xmm0, %xmm2
# CHECK-NEXT:  1      22    1.00    *                   divss	(%rax), %xmm2
# CHECK-NEXT:  1      100   0.25    *      *      U     ldmxcsr	(%rax)
# CHECK-NEXT:  1      100   0.25    *      *      U     maskmovq	%mm0, %mm1
# CHECK-NEXT:  1      3     1.00                        maxps	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   maxps	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        maxss	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   maxss	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        minps	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   minps	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        minss	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   minss	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        movaps	%xmm0, %xmm2
# CHECK-NEXT:  1      1     0.50           *            movaps	%xmm0, (%rax)
# CHECK-NEXT:  1      8     0.50    *                   movaps	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        movhlps	%xmm0, %xmm2
# CHECK-NEXT:  1      1     0.50                        movlhps	%xmm0, %xmm2
# CHECK-NEXT:  1      1     0.50           *            movhps	%xmm0, (%rax)
# CHECK-NEXT:  1      8     0.50    *                   movhps	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50           *            movlps	%xmm0, (%rax)
# CHECK-NEXT:  1      8     0.50    *                   movlps	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        movmskps	%xmm0, %ecx
# CHECK-NEXT:  1      1     0.50           *            movntps	%xmm0, (%rax)
# CHECK-NEXT:  1      1     0.50    *      *      U     movntq	%mm0, (%rax)
# CHECK-NEXT:  1      1     0.50                        movss	%xmm0, %xmm2
# CHECK-NEXT:  1      1     0.50           *            movss	%xmm0, (%rax)
# CHECK-NEXT:  1      8     0.50    *                   movss	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        movups	%xmm0, %xmm2
# CHECK-NEXT:  1      1     0.50           *            movups	%xmm0, (%rax)
# CHECK-NEXT:  1      8     0.50    *                   movups	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.50                        mulps	%xmm0, %xmm2
# CHECK-NEXT:  2      10    0.50    *                   mulps	(%rax), %xmm2
# CHECK-NEXT:  1      3     0.50                        mulss	%xmm0, %xmm2
# CHECK-NEXT:  2      10    0.50    *                   mulss	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        orps	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   orps	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        pavgb	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pavgb	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pavgw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pavgw	(%rax), %mm2
# CHECK-NEXT:  1      2     2.00                        pextrw	$1, %mm0, %ecx
# CHECK-NEXT:  1      1     0.25                        pinsrw	$1, %eax, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pinsrw	$1, (%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pmaxsw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pmaxsw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pmaxub	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pmaxub	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pminsw	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pminsw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pminub	%mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pminub	(%rax), %mm2
# CHECK-NEXT:  1      1     1.00                        pmovmskb	%xmm0, %ecx
# CHECK-NEXT:  1      4     1.00                        pmulhuw	%mm0, %mm2
# CHECK-NEXT:  1      11    1.00    *                   pmulhuw	(%rax), %mm2
# CHECK-NEXT:  1      8     0.50    *      *            prefetcht0	(%rax)
# CHECK-NEXT:  1      8     0.50    *      *            prefetcht1	(%rax)
# CHECK-NEXT:  1      8     0.50    *      *            prefetcht2	(%rax)
# CHECK-NEXT:  1      8     0.50    *      *            prefetchnta	(%rax)
# CHECK-NEXT:  1      3     1.00                        psadbw	%mm0, %mm2
# CHECK-NEXT:  1      10    1.00    *                   psadbw	(%rax), %mm2
# CHECK-NEXT:  1      1     0.25                        pshufw	$1, %mm0, %mm2
# CHECK-NEXT:  1      8     0.50    *                   pshufw	$1, (%rax), %mm2
# CHECK-NEXT:  1      5     0.50                        rcpps	%xmm0, %xmm2
# CHECK-NEXT:  1      12    0.50    *                   rcpps	(%rax), %xmm2
# CHECK-NEXT:  1      5     0.50                        rcpss	%xmm0, %xmm2
# CHECK-NEXT:  1      12    0.50    *                   rcpss	(%rax), %xmm2
# CHECK-NEXT:  1      5     0.50                        rsqrtps	%xmm0, %xmm2
# CHECK-NEXT:  2      12    0.50    *                   rsqrtps	(%rax), %xmm2
# CHECK-NEXT:  1      5     0.50                        rsqrtss	%xmm0, %xmm2
# CHECK-NEXT:  2      12    1.00    *                   rsqrtss	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50    *      *      U     sfence
# CHECK-NEXT:  1      1     0.50                        shufps	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   shufps	$1, (%rax), %xmm2
# CHECK-NEXT:  1      20    20.00                       sqrtps	%xmm0, %xmm2
# CHECK-NEXT:  1      27    20.00   *                   sqrtps	(%rax), %xmm2
# CHECK-NEXT:  1      20    20.00                       sqrtss	%xmm0, %xmm2
# CHECK-NEXT:  1      27    20.00   *                   sqrtss	(%rax), %xmm2
# CHECK-NEXT:  1      100   0.25    *      *      U     stmxcsr	(%rax)
# CHECK-NEXT:  1      3     1.00                        subps	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   subps	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        subss	%xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   subss	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        ucomiss	%xmm0, %xmm1
# CHECK-NEXT:  1      10    1.00    *                   ucomiss	(%rax), %xmm1
# CHECK-NEXT:  1      1     0.50                        unpckhps	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   unpckhps	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        unpcklps	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   unpcklps	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.25                        xorps	%xmm0, %xmm2
# CHECK-NEXT:  1      8     0.50    *                   xorps	(%rax), %xmm2

# CHECK:      Resources:
# CHECK-NEXT: [0]   - ZnAGU0
# CHECK-NEXT: [1]   - ZnAGU1
# CHECK-NEXT: [2]   - ZnALU0
# CHECK-NEXT: [3]   - ZnALU1
# CHECK-NEXT: [4]   - ZnALU2
# CHECK-NEXT: [5]   - ZnALU3
# CHECK-NEXT: [6]   - ZnDivider
# CHECK-NEXT: [7]   - ZnFPU0
# CHECK-NEXT: [8]   - ZnFPU1
# CHECK-NEXT: [9]   - ZnFPU2
# CHECK-NEXT: [10]  - ZnFPU3
# CHECK-NEXT: [11]  - ZnMultiplier

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]
# CHECK-NEXT: 32.50  32.50   -      -      -      -      -     41.00  21.50  22.00  108.50  -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     addps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     addps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     addss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     addss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     andnps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     andnps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     andps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     andps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     cmpps	$0, %xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     cmpps	$0, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     cmpss	$0, %xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     cmpss	$0, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     comiss	%xmm0, %xmm1
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     comiss	(%rax), %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     cvtpi2ps	%mm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     1.00    -     cvtpi2ps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     cvtps2pi	%xmm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     1.00    -     cvtps2pi	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     cvtsi2ssl	%ecx, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     cvtsi2ssq	%rcx, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     1.00    -     cvtsi2ssl	(%rax), %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     1.00    -     cvtsi2ssl	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50   1.00    -     cvtss2si	%xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50   1.00    -     cvtss2si	%xmm0, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50   1.00    -     cvtss2si	(%rax), %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50   1.00    -     cvtss2si	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     cvttps2pi	%xmm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     1.00    -     cvttps2pi	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50   1.00    -     cvttss2si	%xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50   1.00    -     cvttss2si	%xmm0, %rcx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50   1.00    -     cvttss2si	(%rax), %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50   1.00    -     cvttss2si	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     divps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     1.00    -     divps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00    -     divss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     1.00    -     divss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     ldmxcsr	(%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     maskmovq	%mm0, %mm1
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     maxps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     maxps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     maxss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     maxss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     minps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     minps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     minss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     minss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     movaps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movaps	%xmm0, (%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movaps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -     movhlps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -     movlhps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movhps	%xmm0, (%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50    -      -     movhps	(%rax), %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movlps	%xmm0, (%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50    -      -     movlps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -     movmskps	%xmm0, %ecx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movntps	%xmm0, (%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movntq	%mm0, (%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -     movss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movss	%xmm0, (%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     movups	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movups	%xmm0, (%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     movups	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.50   0.50    -      -      -     mulps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.50   0.50    -      -      -     mulps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.50   0.50    -      -      -     mulss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.50   0.50    -      -      -     mulss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     orps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     orps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pavgb	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pavgb	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pavgw	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pavgw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   2.50    -      -     pextrw	$1, %mm0, %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pinsrw	$1, %eax, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pinsrw	$1, (%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pmaxsw	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pmaxsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pmaxub	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pmaxub	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pminsw	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pminsw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pminub	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pminub	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     1.00    -      -     pmovmskb	%xmm0, %ecx
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     pmulhuw	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     pmulhuw	(%rax), %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     prefetcht0	(%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     prefetcht1	(%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     prefetcht2	(%rax)
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     prefetchnta	(%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     psadbw	%mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     psadbw	(%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     pshufw	$1, %mm0, %mm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     pshufw	$1, (%rax), %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.50   0.50    -      -      -     rcpps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.50   0.50    -      -      -     rcpps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.50   0.50    -      -      -     rcpss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.50   0.50    -      -      -     rcpss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.50   0.50    -      -      -     rsqrtps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.50   0.50    -      -      -     rsqrtps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.50    -     0.50    -      -     rsqrtss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -     1.00    -      -     rsqrtss	(%rax), %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -     sfence
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -     shufps	$1, %xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50    -      -     shufps	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     20.00   -     sqrtps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     20.00   -     sqrtps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     20.00   -     sqrtss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -     20.00   -     sqrtss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     stmxcsr	(%rax)
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     subps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     subps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     subss	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     subss	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -     ucomiss	%xmm0, %xmm1
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     1.00    -      -      -      -     ucomiss	(%rax), %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -     unpckhps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50    -      -     unpckhps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.50   0.50    -      -     unpcklps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -     0.50   0.50    -      -     unpcklps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     0.25   0.25   0.25   0.25    -     xorps	%xmm0, %xmm2
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -     0.25   0.25   0.25   0.25    -     xorps	(%rax), %xmm2
