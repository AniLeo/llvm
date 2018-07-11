# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -instruction-tables < %s | FileCheck %s

vfrczpd %xmm0, %xmm3
vfrczpd (%rax), %xmm3

vfrczpd %ymm0, %ymm3
vfrczpd (%rax), %ymm3

vfrczps %xmm0, %xmm3
vfrczps (%rax), %xmm3

vfrczps %ymm0, %ymm3
vfrczps (%rax), %ymm3

vfrczsd %xmm0, %xmm3
vfrczsd (%rax), %xmm3

vfrczss %xmm0, %xmm3
vfrczss (%rax), %xmm3

vpcmov %xmm0, %xmm1, %xmm2, %xmm3
vpcmov (%rax), %xmm0, %xmm1, %xmm3
vpcmov %xmm0, (%rax), %xmm1, %xmm3

vpcmov %ymm0, %ymm1, %ymm2, %ymm3
vpcmov (%rax), %ymm0, %ymm1, %ymm3
vpcmov %ymm0, (%rax), %ymm1, %ymm3

vpcomb $0, %xmm0, %xmm1, %xmm3
vpcomb $0, (%rax), %xmm0, %xmm3

vpcomd $0, %xmm0, %xmm1, %xmm3
vpcomd $0, (%rax), %xmm0, %xmm3

vpcomq $0, %xmm0, %xmm1, %xmm3
vpcomq $0, (%rax), %xmm0, %xmm3

vpcomub $0, %xmm0, %xmm1, %xmm3
vpcomub $0, (%rax), %xmm0, %xmm3

vpcomud $0, %xmm0, %xmm1, %xmm3
vpcomud $0, (%rax), %xmm0, %xmm3

vpcomuq $0, %xmm0, %xmm1, %xmm3
vpcomuq $0, (%rax), %xmm0, %xmm3

vpcomuw $0, %xmm0, %xmm1, %xmm3
vpcomuw $0, (%rax), %xmm0, %xmm3

vpcomw $0, %xmm0, %xmm1, %xmm3
vpcomw $0, (%rax), %xmm0, %xmm3

vpermil2pd $0, %xmm0, %xmm1, %xmm2, %xmm3
vpermil2pd $0, (%rax), %xmm0, %xmm1, %xmm3
vpermil2pd $0, %xmm0, (%rax), %xmm1, %xmm3

vpermil2pd $0, %ymm0, %ymm1, %ymm2, %ymm3
vpermil2pd $0, (%rax), %ymm0, %ymm1, %ymm3
vpermil2pd $0, %ymm0, (%rax), %ymm1, %ymm3

vpermil2ps $0, %xmm0, %xmm1, %xmm2, %xmm3
vpermil2ps $0, (%rax), %xmm0, %xmm1, %xmm3
vpermil2ps $0, %xmm0, (%rax), %xmm1, %xmm3

vpermil2ps $0, %ymm0, %ymm1, %ymm2, %ymm3
vpermil2ps $0, (%rax), %ymm0, %ymm1, %ymm3
vpermil2ps $0, %ymm0, (%rax), %ymm1, %ymm3

vphaddbd %xmm0, %xmm3
vphaddbd (%rax), %xmm3

vphaddbq %xmm0, %xmm3
vphaddbq (%rax), %xmm3

vphaddbw %xmm0, %xmm3
vphaddbw (%rax), %xmm3

vphadddq %xmm0, %xmm3
vphadddq (%rax), %xmm3

vphaddubd %xmm0, %xmm3
vphaddubd (%rax), %xmm3

vphaddubq %xmm0, %xmm3
vphaddubq (%rax), %xmm3

vphaddubw %xmm0, %xmm3
vphaddubw (%rax), %xmm3

vphaddudq %xmm0, %xmm3
vphaddudq (%rax), %xmm3

vphadduwd %xmm0, %xmm3
vphadduwd (%rax), %xmm3

vphadduwq %xmm0, %xmm3
vphadduwq (%rax), %xmm3

vphaddwd %xmm0, %xmm3
vphaddwd (%rax), %xmm3

vphaddwq %xmm0, %xmm3
vphaddwq (%rax), %xmm3

vphsubbw %xmm0, %xmm3
vphsubbw (%rax), %xmm3

vphsubdq %xmm0, %xmm3
vphsubdq (%rax), %xmm3

vphsubwd %xmm0, %xmm3
vphsubwd (%rax), %xmm3

vpmacsdd %xmm0, %xmm1, %xmm2, %xmm3
vpmacsdd %xmm0, (%rax), %xmm1, %xmm3

vpmacsdqh %xmm0, %xmm1, %xmm2, %xmm3
vpmacsdqh %xmm0, (%rax), %xmm1, %xmm3

vpmacsdql %xmm0, %xmm1, %xmm2, %xmm3
vpmacsdql %xmm0, (%rax), %xmm1, %xmm3

vpmacssdd %xmm0, %xmm1, %xmm2, %xmm3
vpmacssdd %xmm0, (%rax), %xmm1, %xmm3

vpmacssdqh %xmm0, %xmm1, %xmm2, %xmm3
vpmacssdqh %xmm0, (%rax), %xmm1, %xmm3

vpmacssdql %xmm0, %xmm1, %xmm2, %xmm3
vpmacssdql %xmm0, (%rax), %xmm1, %xmm3

vpmacsswd %xmm0, %xmm1, %xmm2, %xmm3
vpmacsswd %xmm0, (%rax), %xmm1, %xmm3

vpmacssww %xmm0, %xmm1, %xmm2, %xmm3
vpmacssww %xmm0, (%rax), %xmm1, %xmm3

vpmacswd %xmm0, %xmm1, %xmm2, %xmm3
vpmacswd %xmm0, (%rax), %xmm1, %xmm3

vpmacsww %xmm0, %xmm1, %xmm2, %xmm3
vpmacsww %xmm0, (%rax), %xmm1, %xmm3

vpmadcsswd %xmm0, %xmm1, %xmm2, %xmm3
vpmadcsswd %xmm0, (%rax), %xmm1, %xmm3

vpmadcswd %xmm0, %xmm1, %xmm2, %xmm3
vpmadcswd %xmm0, (%rax), %xmm1, %xmm3

vpperm %xmm0, %xmm1, %xmm2, %xmm3
vpperm (%rax), %xmm0, %xmm1, %xmm3
vpperm %xmm0, (%rax), %xmm1, %xmm3

vprotb %xmm0, %xmm1, %xmm3
vprotb (%rax), %xmm0, %xmm3
vprotb %xmm0, (%rax), %xmm3

vprotb $0, %xmm0, %xmm3
vprotb $0, (%rax), %xmm3

vprotd %xmm0, %xmm1, %xmm3
vprotd (%rax), %xmm0, %xmm3
vprotd %xmm0, (%rax), %xmm3

vprotd $0, %xmm0, %xmm3
vprotd $0, (%rax), %xmm3

vprotq %xmm0, %xmm1, %xmm3
vprotq (%rax), %xmm0, %xmm3
vprotq %xmm0, (%rax), %xmm3

vprotq $0, %xmm0, %xmm3
vprotq $0, (%rax), %xmm3

vprotw %xmm0, %xmm1, %xmm3
vprotw (%rax), %xmm0, %xmm3
vprotw %xmm0, (%rax), %xmm3

vprotw $0, %xmm0, %xmm3
vprotw $0, (%rax), %xmm3

vpshab %xmm0, %xmm1, %xmm3
vpshab (%rax), %xmm0, %xmm3
vpshab %xmm0, (%rax), %xmm3

vpshad %xmm0, %xmm1, %xmm3
vpshad (%rax), %xmm0, %xmm3
vpshad %xmm0, (%rax), %xmm3

vpshaq %xmm0, %xmm1, %xmm3
vpshaq (%rax), %xmm0, %xmm3
vpshaq %xmm0, (%rax), %xmm3

vpshaw %xmm0, %xmm1, %xmm3
vpshaw (%rax), %xmm0, %xmm3
vpshaw %xmm0, (%rax), %xmm3

vpshlb %xmm0, %xmm1, %xmm3
vpshlb (%rax), %xmm0, %xmm3
vpshlb %xmm0, (%rax), %xmm3

vpshld %xmm0, %xmm1, %xmm3
vpshld (%rax), %xmm0, %xmm3
vpshld %xmm0, (%rax), %xmm3

vpshlq %xmm0, %xmm1, %xmm3
vpshlq (%rax), %xmm0, %xmm3
vpshlq %xmm0, (%rax), %xmm3

vpshlw %xmm0, %xmm1, %xmm3
vpshlw (%rax), %xmm0, %xmm3
vpshlw %xmm0, (%rax), %xmm3

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        vfrczpd	%xmm0, %xmm3
# CHECK-NEXT:  2      9     1.00    *                   vfrczpd	(%rax), %xmm3
# CHECK-NEXT:  1      3     1.00                        vfrczpd	%ymm0, %ymm3
# CHECK-NEXT:  2      10    1.00    *                   vfrczpd	(%rax), %ymm3
# CHECK-NEXT:  1      3     1.00                        vfrczps	%xmm0, %xmm3
# CHECK-NEXT:  2      9     1.00    *                   vfrczps	(%rax), %xmm3
# CHECK-NEXT:  1      3     1.00                        vfrczps	%ymm0, %ymm3
# CHECK-NEXT:  2      10    1.00    *                   vfrczps	(%rax), %ymm3
# CHECK-NEXT:  1      3     1.00                        vfrczsd	%xmm0, %xmm3
# CHECK-NEXT:  2      9     1.00    *                   vfrczsd	(%rax), %xmm3
# CHECK-NEXT:  1      3     1.00                        vfrczss	%xmm0, %xmm3
# CHECK-NEXT:  2      9     1.00    *                   vfrczss	(%rax), %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcmov	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcmov	(%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcmov	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      1     1.00                        vpcmov	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      8     1.00    *                   vpcmov	(%rax), %ymm0, %ymm1, %ymm3
# CHECK-NEXT:  2      8     1.00    *                   vpcmov	%ymm0, (%rax), %ymm1, %ymm3
# CHECK-NEXT:  1      1     0.50                        vpcomb	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomb	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcomd	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomd	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcomq	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomq	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcomub	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomub	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcomud	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomud	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcomuq	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomuq	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcomuw	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomuw	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpcomw	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpcomw	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  1      1     1.00                        vpermil2pd	$0, %xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpermil2pd	$0, (%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpermil2pd	$0, %xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      1     1.00                        vpermil2pd	$0, %ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      8     1.00    *                   vpermil2pd	$0, (%rax), %ymm0, %ymm1, %ymm3
# CHECK-NEXT:  2      8     1.00    *                   vpermil2pd	$0, %ymm0, (%rax), %ymm1, %ymm3
# CHECK-NEXT:  1      1     1.00                        vpermil2ps	$0, %xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpermil2ps	$0, (%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpermil2ps	$0, %xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      1     1.00                        vpermil2ps	$0, %ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  2      8     1.00    *                   vpermil2ps	$0, (%rax), %ymm0, %ymm1, %ymm3
# CHECK-NEXT:  2      8     1.00    *                   vpermil2ps	$0, %ymm0, (%rax), %ymm1, %ymm3
# CHECK-NEXT:  3      3     1.50                        vphaddbd	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddbd	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddbq	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddbq	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddbw	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddbw	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphadddq	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphadddq	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddubd	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddubd	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddubq	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddubq	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddubw	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddubw	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddudq	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddudq	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphadduwd	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphadduwd	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphadduwq	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphadduwq	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddwd	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddwd	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphaddwq	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphaddwq	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphsubbw	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphsubbw	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphsubdq	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphsubdq	(%rax), %xmm3
# CHECK-NEXT:  3      3     1.50                        vphsubwd	%xmm0, %xmm3
# CHECK-NEXT:  4      9     1.50    *                   vphsubwd	(%rax), %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacsdd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacsdd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacsdqh	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacsdqh	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacsdql	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacsdql	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacssdd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacssdd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacssdqh	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacssdqh	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacssdql	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacssdql	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacsswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacsswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacssww	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacssww	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmacsww	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmacsww	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmadcsswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmadcsswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      5     1.00                        vpmadcswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      11    1.00    *                   vpmadcswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      1     0.50                        vpperm	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpperm	(%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     0.50    *                   vpperm	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotb	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotb	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotb	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotb	$0, %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotb	$0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotd	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotd	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotd	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotd	$0, %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotd	$0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotq	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotq	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotq	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotq	$0, %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotq	$0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotw	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotw	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotw	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vprotw	$0, %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vprotw	$0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshab	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshab	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshab	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshad	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshad	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshad	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshaq	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshaq	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshaq	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshaw	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshaw	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshaw	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshlb	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshlb	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshlb	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshld	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshld	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshld	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshlq	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshlq	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshlq	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  1      1     1.00                        vpshlw	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshlw	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  2      7     1.00    *                   vpshlw	%xmm0, (%rax), %xmm3

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -     68.00  68.00   -     71.00  41.50  41.50

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vfrczpd	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vfrczpd	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vfrczpd	%ymm0, %ymm3
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vfrczpd	(%rax), %ymm3
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vfrczps	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vfrczps	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vfrczps	%ymm0, %ymm3
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vfrczps	(%rax), %ymm3
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vfrczsd	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vfrczsd	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vfrczss	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vfrczss	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcmov	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcmov	(%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcmov	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     vpcmov	%ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpcmov	(%rax), %ymm0, %ymm1, %ymm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpcmov	%ymm0, (%rax), %ymm1, %ymm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomb	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomb	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomd	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomd	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomq	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomq	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomub	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomub	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomud	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomud	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomuq	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomuq	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomuw	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomuw	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpcomw	$0, %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpcomw	$0, (%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     vpermil2pd	$0, %xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2pd	$0, (%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2pd	$0, %xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     vpermil2pd	$0, %ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2pd	$0, (%rax), %ymm0, %ymm1, %ymm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2pd	$0, %ymm0, (%rax), %ymm1, %ymm3
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     vpermil2ps	$0, %xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2ps	$0, (%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2ps	$0, %xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     vpermil2ps	$0, %ymm0, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2ps	$0, (%rax), %ymm0, %ymm1, %ymm3
# CHECK-NEXT:  -      -      -      -      -     1.00   0.50   0.50   vpermil2ps	$0, %ymm0, (%rax), %ymm1, %ymm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddbd	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddbd	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddbq	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddbq	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddbw	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddbw	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphadddq	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphadddq	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddubd	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddubd	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddubq	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddubq	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddubw	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddubw	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddudq	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddudq	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphadduwd	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphadduwd	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphadduwq	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphadduwq	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddwd	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddwd	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphaddwq	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphaddwq	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphsubbw	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphsubbw	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphsubdq	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphsubdq	(%rax), %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50    -      -     vphsubwd	%xmm0, %xmm3
# CHECK-NEXT:  -      -      -     1.50    -     1.50   0.50   0.50   vphsubwd	(%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacsdd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacsdd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacsdqh	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacsdqh	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacsdql	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacsdql	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacssdd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacssdd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacssdqh	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacssdqh	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacssdql	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacssdql	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacsswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacsswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacssww	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacssww	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmacsww	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmacsww	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmadcsswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmadcsswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpmadcswd	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpmadcswd	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -     vpperm	%xmm0, %xmm1, %xmm2, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpperm	(%rax), %xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -     0.50    -     0.50   0.50   0.50   vpperm	%xmm0, (%rax), %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotb	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotb	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotb	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotb	$0, %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotb	$0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotd	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotd	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotd	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotd	$0, %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotd	$0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotq	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotq	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotq	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotq	$0, %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotq	$0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotw	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotw	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotw	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vprotw	$0, %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vprotw	$0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshab	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshab	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshab	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshad	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshad	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshad	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshaq	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshaq	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshaq	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshaw	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshaw	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshaw	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshlb	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshlb	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshlb	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshld	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshld	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshld	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshlq	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshlq	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshlq	%xmm0, (%rax), %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     vpshlw	%xmm0, %xmm1, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshlw	(%rax), %xmm0, %xmm3
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   vpshlw	%xmm0, (%rax), %xmm3
