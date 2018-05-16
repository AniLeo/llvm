# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=slm -instruction-tables < %s | FileCheck %s

blendpd     $11, %xmm0, %xmm2
blendpd     $11, (%rax), %xmm2

blendps     $11, %xmm0, %xmm2
blendps     $11, (%rax), %xmm2

blendvpd    %xmm0, %xmm2
blendvpd    (%rax), %xmm2

blendvps    %xmm0, %xmm2
blendvps    (%rax), %xmm2

dppd        $22, %xmm0, %xmm2
dppd        $22, (%rax), %xmm2

dpps        $22, %xmm0, %xmm2
dpps        $22, (%rax), %xmm2

extractps   $1, %xmm0, %rcx
extractps   $1, %xmm0, (%rax)

insertps    $1, %xmm0, %xmm2
insertps    $1, (%rax), %xmm2

movntdqa    (%rax), %xmm2

mpsadbw     $1, %xmm0, %xmm2
mpsadbw     $1, (%rax), %xmm2

packusdw    %xmm0, %xmm2
packusdw    (%rax), %xmm2

pblendvb    %xmm0, %xmm2
pblendvb    (%rax), %xmm2

pblendw     $11, %xmm0, %xmm2
pblendw     $11, (%rax), %xmm2

pcmpeqq     %xmm0, %xmm2
pcmpeqq     (%rax), %xmm2

pextrb      $1, %xmm0, %ecx
pextrb      $1, %xmm0, (%rax)

pextrd      $1, %xmm0, %ecx
pextrd      $1, %xmm0, (%rax)

pextrq      $1, %xmm0, %rcx
pextrq      $1, %xmm0, (%rax)

pextrw      $1, %xmm0, (%rax)

phminposuw  %xmm0, %xmm2
phminposuw  (%rax), %xmm2

pinsrb      $1, %eax, %xmm1
pinsrb      $1, (%rax), %xmm1

pinsrd      $1, %eax, %xmm1
pinsrd      $1, (%rax), %xmm1

pinsrq      $1, %rax, %xmm1
pinsrq      $1, (%rax), %xmm1

pmaxsb      %xmm0, %xmm2
pmaxsb      (%rax), %xmm2

pmaxsd      %xmm0, %xmm2
pmaxsd      (%rax), %xmm2

pmaxud      %xmm0, %xmm2
pmaxud      (%rax), %xmm2

pmaxuw      %xmm0, %xmm2
pmaxuw      (%rax), %xmm2

pminsb      %xmm0, %xmm2
pminsb      (%rax), %xmm2

pminsd      %xmm0, %xmm2
pminsd      (%rax), %xmm2

pminud      %xmm0, %xmm2
pminud      (%rax), %xmm2

pminuw      %xmm0, %xmm2
pminuw      (%rax), %xmm2

pmovsxbd    %xmm0, %xmm2
pmovsxbd    (%rax), %xmm2

pmovsxbq    %xmm0, %xmm2
pmovsxbq    (%rax), %xmm2

pmovsxbw    %xmm0, %xmm2
pmovsxbw    (%rax), %xmm2

pmovsxdq    %xmm0, %xmm2
pmovsxdq    (%rax), %xmm2

pmovsxwd    %xmm0, %xmm2
pmovsxwd    (%rax), %xmm2

pmovsxwq    %xmm0, %xmm2
pmovsxwq    (%rax), %xmm2

pmovzxbd    %xmm0, %xmm2
pmovzxbd    (%rax), %xmm2

pmovzxbq    %xmm0, %xmm2
pmovzxbq    (%rax), %xmm2

pmovzxbw    %xmm0, %xmm2
pmovzxbw    (%rax), %xmm2

pmovzxdq    %xmm0, %xmm2
pmovzxdq    (%rax), %xmm2

pmovzxwd    %xmm0, %xmm2
pmovzxwd    (%rax), %xmm2

pmovzxwq    %xmm0, %xmm2
pmovzxwq    (%rax), %xmm2

pmuldq      %xmm0, %xmm2
pmuldq      (%rax), %xmm2

pmulld      %xmm0, %xmm2
pmulld      (%rax), %xmm2

ptest       %xmm0, %xmm1
ptest       (%rax), %xmm1

roundpd     $1, %xmm0, %xmm2
roundpd     $1, (%rax), %xmm2

roundps     $1, %xmm0, %xmm2
roundps     $1, (%rax), %xmm2

roundsd     $1, %xmm0, %xmm2
roundsd     $1, (%rax), %xmm2

roundss     $1, %xmm0, %xmm2
roundss     $1, (%rax), %xmm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     1.00                        blendpd	$11, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   blendpd	$11, (%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        blendps	$11, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   blendps	$11, (%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        blendvpd	%xmm0, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   blendvpd	%xmm0, (%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        blendvps	%xmm0, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   blendvps	%xmm0, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        dppd	$22, %xmm0, %xmm2
# CHECK-NEXT:  1      6     1.00    *                   dppd	$22, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        dpps	$22, %xmm0, %xmm2
# CHECK-NEXT:  1      6     1.00    *                   dpps	$22, (%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        extractps	$1, %xmm0, %ecx
# CHECK-NEXT:  2      4     2.00           *            extractps	$1, %xmm0, (%rax)
# CHECK-NEXT:  1      1     1.00                        insertps	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   insertps	$1, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00    *                   movntdqa	(%rax), %xmm2
# CHECK-NEXT:  1      7     1.00                        mpsadbw	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      10    1.00    *                   mpsadbw	$1, (%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        packusdw	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   packusdw	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pblendvb	%xmm0, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pblendvb	%xmm0, (%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pblendw	$11, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pblendw	$11, (%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pcmpeqq	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pcmpeqq	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pextrb	$1, %xmm0, %ecx
# CHECK-NEXT:  2      4     2.00           *            pextrb	$1, %xmm0, (%rax)
# CHECK-NEXT:  1      1     1.00                        pextrd	$1, %xmm0, %ecx
# CHECK-NEXT:  2      4     2.00           *            pextrd	$1, %xmm0, (%rax)
# CHECK-NEXT:  1      1     1.00                        pextrq	$1, %xmm0, %rcx
# CHECK-NEXT:  2      4     2.00           *            pextrq	$1, %xmm0, (%rax)
# CHECK-NEXT:  2      4     2.00           *            pextrw	$1, %xmm0, (%rax)
# CHECK-NEXT:  1      4     1.00                        phminposuw	%xmm0, %xmm2
# CHECK-NEXT:  1      7     1.00    *                   phminposuw	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pinsrb	$1, %eax, %xmm1
# CHECK-NEXT:  1      4     1.00    *                   pinsrb	$1, (%rax), %xmm1
# CHECK-NEXT:  1      1     1.00                        pinsrd	$1, %eax, %xmm1
# CHECK-NEXT:  1      4     1.00    *                   pinsrd	$1, (%rax), %xmm1
# CHECK-NEXT:  1      1     1.00                        pinsrq	$1, %rax, %xmm1
# CHECK-NEXT:  1      4     1.00    *                   pinsrq	$1, (%rax), %xmm1
# CHECK-NEXT:  1      1     0.50                        pmaxsb	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmaxsb	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pmaxsd	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmaxsd	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pmaxud	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmaxud	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pmaxuw	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmaxuw	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pminsb	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pminsb	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pminsd	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pminsd	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pminud	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pminud	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        pminuw	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pminuw	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovsxbd	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovsxbd	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovsxbq	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovsxbq	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovsxbw	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovsxbw	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovsxdq	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovsxdq	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovsxwd	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovsxwd	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovsxwq	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovsxwq	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovzxbd	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovzxbd	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovzxbq	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovzxbq	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovzxbw	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovzxbw	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovzxdq	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovzxdq	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovzxwd	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovzxwd	(%rax), %xmm2
# CHECK-NEXT:  1      1     1.00                        pmovzxwq	%xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00    *                   pmovzxwq	(%rax), %xmm2
# CHECK-NEXT:  1      4     1.00                        pmuldq	%xmm0, %xmm2
# CHECK-NEXT:  1      7     1.00    *                   pmuldq	(%rax), %xmm2
# CHECK-NEXT:  1      4     1.00                        pmulld	%xmm0, %xmm2
# CHECK-NEXT:  1      7     1.00    *                   pmulld	(%rax), %xmm2
# CHECK-NEXT:  1      1     0.50                        ptest	%xmm0, %xmm1
# CHECK-NEXT:  1      4     1.00    *                   ptest	(%rax), %xmm1
# CHECK-NEXT:  1      3     1.00                        roundpd	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      6     1.00    *                   roundpd	$1, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        roundps	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      6     1.00    *                   roundps	$1, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        roundsd	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      6     1.00    *                   roundsd	$1, (%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        roundss	$1, %xmm0, %xmm2
# CHECK-NEXT:  1      6     1.00    *                   roundss	$1, (%rax), %xmm2

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SLMDivider
# CHECK-NEXT: [1]   - SLMFPDivider
# CHECK-NEXT: [2]   - SLMFPMultiplier
# CHECK-NEXT: [3]   - SLM_FPC_RSV0
# CHECK-NEXT: [4]   - SLM_FPC_RSV1
# CHECK-NEXT: [5]   - SLM_IEC_RSV0
# CHECK-NEXT: [6]   - SLM_IEC_RSV1
# CHECK-NEXT: [7]   - SLM_MEC_RSV

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]
# CHECK-NEXT:  -      -      -     73.00  22.00   -      -     54.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     blendpd	$11, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   blendpd	$11, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     blendps	$11, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   blendps	$11, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     blendvpd	%xmm0, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   blendvpd	%xmm0, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     blendvps	%xmm0, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   blendvps	%xmm0, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -     dppd	$22, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   dppd	$22, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -     dpps	$22, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   dpps	$22, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     extractps	$1, %xmm0, %ecx
# CHECK-NEXT:  -      -      -     1.00    -      -      -     2.00   extractps	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     insertps	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   insertps	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00   movntdqa	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     mpsadbw	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   mpsadbw	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     packusdw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   packusdw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pblendvb	%xmm0, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pblendvb	%xmm0, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pblendw	$11, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pblendw	$11, (%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pcmpeqq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pcmpeqq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pextrb	$1, %xmm0, %ecx
# CHECK-NEXT:  -      -      -     1.00    -      -      -     2.00   pextrb	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pextrd	$1, %xmm0, %ecx
# CHECK-NEXT:  -      -      -     1.00    -      -      -     2.00   pextrd	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pextrq	$1, %xmm0, %rcx
# CHECK-NEXT:  -      -      -     1.00    -      -      -     2.00   pextrq	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -     2.00   pextrw	$1, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     phminposuw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   phminposuw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pinsrb	$1, %eax, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pinsrb	$1, (%rax), %xmm1
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pinsrd	$1, %eax, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pinsrd	$1, (%rax), %xmm1
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pinsrq	$1, %rax, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pinsrq	$1, (%rax), %xmm1
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pmaxsb	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pmaxsb	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pmaxsd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pmaxsd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pmaxud	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pmaxud	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pmaxuw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pmaxuw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pminsb	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pminsb	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pminsd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pminsd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pminud	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pminud	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     pminuw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   pminuw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovsxbd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovsxbd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovsxbq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovsxbq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovsxbw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovsxbw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovsxdq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovsxdq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovsxwd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovsxwd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovsxwq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovsxwq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovzxbd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovzxbd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovzxbq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovzxbq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovzxbw	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovzxbw	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovzxdq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovzxdq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovzxwd	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovzxwd	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmovzxwq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmovzxwq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmuldq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmuldq	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pmulld	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -     1.00   pmulld	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -      -     ptest	%xmm0, %xmm1
# CHECK-NEXT:  -      -      -     0.50   0.50    -      -     1.00   ptest	(%rax), %xmm1
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -     roundpd	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   roundpd	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -     roundps	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   roundps	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -     roundsd	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   roundsd	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -      -     roundss	$1, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   roundss	$1, (%rax), %xmm2

