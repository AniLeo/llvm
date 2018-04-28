# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=broadwell -instruction-tables < %s | FileCheck %s

rclb %dil
rcrb %dil
rclb (%rax)
rcrb (%rax)
rclb $7, %dil
rcrb $7, %dil
rclb $7, (%rax)
rcrb $7, (%rax)
rclb %cl, %dil
rcrb %cl, %dil
rclb %cl, (%rax)
rcrb %cl, (%rax)

rclw %di
rcrw %di
rclw (%rax)
rcrw (%rax)
rclw $7, %di
rcrw $7, %di
rclw $7, (%rax)
rcrw $7, (%rax)
rclw %cl, %di
rcrw %cl, %di
rclw %cl, (%rax)
rcrw %cl, (%rax)

rcll %edi
rcrl %edi
rcll (%rax)
rcrl (%rax)
rcll $7, %edi
rcrl $7, %edi
rcll $7, (%rax)
rcrl $7, (%rax)
rcll %cl, %edi
rcrl %cl, %edi
rcll %cl, (%rax)
rcrl %cl, (%rax)

rclq %rdi
rcrq %rdi
rclq (%rax)
rcrq (%rax)
rclq $7, %rdi
rcrq $7, %rdi
rclq $7, (%rax)
rcrq $7, (%rax)
rclq %cl, %rdi
rcrq %cl, %rdi
rclq %cl, (%rax)
rcrq %cl, (%rax)

rolb %dil
rorb %dil
rolb (%rax)
rorb (%rax)
rolb $7, %dil
rorb $7, %dil
rolb $7, (%rax)
rorb $7, (%rax)
rolb %cl, %dil
rorb %cl, %dil
rolb %cl, (%rax)
rorb %cl, (%rax)

rolw %di
rorw %di
rolw (%rax)
rorw (%rax)
rolw $7, %di
rorw $7, %di
rolw $7, (%rax)
rorw $7, (%rax)
rolw %cl, %di
rorw %cl, %di
rolw %cl, (%rax)
rorw %cl, (%rax)

roll %edi
rorl %edi
roll (%rax)
rorl (%rax)
roll $7, %edi
rorl $7, %edi
roll $7, (%rax)
rorl $7, (%rax)
roll %cl, %edi
rorl %cl, %edi
roll %cl, (%rax)
rorl %cl, (%rax)

rolq %rdi
rorq %rdi
rolq (%rax)
rorq (%rax)
rolq $7, %rdi
rorq $7, %rdi
rolq $7, (%rax)
rorq $7, (%rax)
rolq %cl, %rdi
rorq %cl, %rdi
rolq %cl, (%rax)
rorq %cl, (%rax)

sarb %dil
shlb %dil
shrb %dil
sarb (%rax)
shlb (%rax)
shrb (%rax)
sarb $7, %dil
shlb $7, %dil
shrb $7, %dil
sarb $7, (%rax)
shlb $7, (%rax)
shrb $7, (%rax)
sarb %cl, %dil
shlb %cl, %dil
shrb %cl, %dil
sarb %cl, (%rax)
shlb %cl, (%rax)
shrb %cl, (%rax)

sarw %di
shlw %di
shrw %di
sarw (%rax)
shlw (%rax)
shrw (%rax)
sarw $7, %di
shlw $7, %di
shrw $7, %di
sarw $7, (%rax)
shlw $7, (%rax)
shrw $7, (%rax)
sarw %cl, %di
shlw %cl, %di
shrw %cl, %di
sarw %cl, (%rax)
shlw %cl, (%rax)
shrw %cl, (%rax)

sarl %edi
shll %edi
shrl %edi
sarl (%rax)
shll (%rax)
shrl (%rax)
sarl $7, %edi
shll $7, %edi
shrl $7, %edi
sarl $7, (%rax)
shll $7, (%rax)
shrl $7, (%rax)
sarl %cl, %edi
shll %cl, %edi
shrl %cl, %edi
sarl %cl, (%rax)
shll %cl, (%rax)
shrl %cl, (%rax)

sarq %rdi
shlq %rdi
shrq %rdi
sarq (%rax)
shlq (%rax)
shrq (%rax)
sarq $7, %rdi
shlq $7, %rdi
shrq $7, %rdi
sarq $7, (%rax)
shlq $7, (%rax)
shrq $7, (%rax)
sarq %cl, %rdi
shlq %cl, %rdi
shrq %cl, %rdi
sarq %cl, (%rax)
shlq %cl, (%rax)
shrq %cl, (%rax)

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]	Instructions:
# CHECK-NEXT:  3      3     0.75                    	rclb	%dil
# CHECK-NEXT:  3      3     0.75                    	rcrb	%dil
# CHECK-NEXT:  5      8     0.75           *        	rclb	(%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrb	(%rax)
# CHECK-NEXT:  3      3     0.75                    	rclb	$7, %dil
# CHECK-NEXT:  3      3     0.75                    	rcrb	$7, %dil
# CHECK-NEXT:  5      8     0.75           *        	rclb	$7, (%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrb	$7, (%rax)
# CHECK-NEXT:  9      11    2.25                    	rclb	%cl, %dil
# CHECK-NEXT:  10     14    2.50                    	rcrb	%cl, %dil
# CHECK-NEXT:  10     15    2.00           *        	rclb	%cl, (%rax)
# CHECK-NEXT:  11     18    2.25           *        	rcrb	%cl, (%rax)
# CHECK-NEXT:  3      3     0.75                    	rclw	%di
# CHECK-NEXT:  3      3     0.75                    	rcrw	%di
# CHECK-NEXT:  5      8     0.75           *        	rclw	(%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrw	(%rax)
# CHECK-NEXT:  3      3     0.75                    	rclw	$7, %di
# CHECK-NEXT:  3      3     0.75                    	rcrw	$7, %di
# CHECK-NEXT:  5      8     0.75           *        	rclw	$7, (%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrw	$7, (%rax)
# CHECK-NEXT:  7      11    2.00                    	rclw	%cl, %di
# CHECK-NEXT:  7      11    2.00                    	rcrw	%cl, %di
# CHECK-NEXT:  10     15    2.00           *        	rclw	%cl, (%rax)
# CHECK-NEXT:  11     18    2.25           *        	rcrw	%cl, (%rax)
# CHECK-NEXT:  3      3     0.75                    	rcll	%edi
# CHECK-NEXT:  3      3     0.75                    	rcrl	%edi
# CHECK-NEXT:  5      8     0.75           *        	rcll	(%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrl	(%rax)
# CHECK-NEXT:  3      3     0.75                    	rcll	$7, %edi
# CHECK-NEXT:  3      3     0.75                    	rcrl	$7, %edi
# CHECK-NEXT:  5      8     0.75           *        	rcll	$7, (%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrl	$7, (%rax)
# CHECK-NEXT:  7      11    2.00                    	rcll	%cl, %edi
# CHECK-NEXT:  7      11    2.00                    	rcrl	%cl, %edi
# CHECK-NEXT:  10     15    2.00           *        	rcll	%cl, (%rax)
# CHECK-NEXT:  11     18    2.25           *        	rcrl	%cl, (%rax)
# CHECK-NEXT:  3      3     0.75                    	rclq	%rdi
# CHECK-NEXT:  3      3     0.75                    	rcrq	%rdi
# CHECK-NEXT:  5      8     0.75           *        	rclq	(%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrq	(%rax)
# CHECK-NEXT:  3      3     0.75                    	rclq	$7, %rdi
# CHECK-NEXT:  3      3     0.75                    	rcrq	$7, %rdi
# CHECK-NEXT:  5      8     0.75           *        	rclq	$7, (%rax)
# CHECK-NEXT:  5      8     0.75           *        	rcrq	$7, (%rax)
# CHECK-NEXT:  7      11    2.00                    	rclq	%cl, %rdi
# CHECK-NEXT:  7      11    2.00                    	rcrq	%cl, %rdi
# CHECK-NEXT:  10     15    2.00           *        	rclq	%cl, (%rax)
# CHECK-NEXT:  11     18    2.25           *        	rcrq	%cl, (%rax)
# CHECK-NEXT:  2      2     1.00                    	rolb	%dil
# CHECK-NEXT:  2      2     1.00                    	rorb	%dil
# CHECK-NEXT:  5      7     1.00    *      *        	rolb	(%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorb	(%rax)
# CHECK-NEXT:  2      2     1.00                    	rolb	$7, %dil
# CHECK-NEXT:  2      2     1.00                    	rorb	$7, %dil
# CHECK-NEXT:  5      7     1.00    *      *        	rolb	$7, (%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorb	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	rolb	%cl, %dil
# CHECK-NEXT:  3      3     1.00                    	rorb	%cl, %dil
# CHECK-NEXT:  6      8     1.00    *      *        	rolb	%cl, (%rax)
# CHECK-NEXT:  5      8     1.00    *      *        	rorb	%cl, (%rax)
# CHECK-NEXT:  2      2     1.00                    	rolw	%di
# CHECK-NEXT:  2      2     1.00                    	rorw	%di
# CHECK-NEXT:  5      7     1.00    *      *        	rolw	(%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorw	(%rax)
# CHECK-NEXT:  2      2     1.00                    	rolw	$7, %di
# CHECK-NEXT:  2      2     1.00                    	rorw	$7, %di
# CHECK-NEXT:  5      7     1.00    *      *        	rolw	$7, (%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorw	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	rolw	%cl, %di
# CHECK-NEXT:  3      3     1.00                    	rorw	%cl, %di
# CHECK-NEXT:  6      8     1.00    *      *        	rolw	%cl, (%rax)
# CHECK-NEXT:  5      8     1.00    *      *        	rorw	%cl, (%rax)
# CHECK-NEXT:  2      2     1.00                    	roll	%edi
# CHECK-NEXT:  2      2     1.00                    	rorl	%edi
# CHECK-NEXT:  5      7     1.00    *      *        	roll	(%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorl	(%rax)
# CHECK-NEXT:  2      2     1.00                    	roll	$7, %edi
# CHECK-NEXT:  2      2     1.00                    	rorl	$7, %edi
# CHECK-NEXT:  5      7     1.00    *      *        	roll	$7, (%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorl	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	roll	%cl, %edi
# CHECK-NEXT:  3      3     1.00                    	rorl	%cl, %edi
# CHECK-NEXT:  6      8     1.00    *      *        	roll	%cl, (%rax)
# CHECK-NEXT:  5      8     1.00    *      *        	rorl	%cl, (%rax)
# CHECK-NEXT:  2      2     1.00                    	rolq	%rdi
# CHECK-NEXT:  2      2     1.00                    	rorq	%rdi
# CHECK-NEXT:  5      7     1.00    *      *        	rolq	(%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorq	(%rax)
# CHECK-NEXT:  2      2     1.00                    	rolq	$7, %rdi
# CHECK-NEXT:  2      2     1.00                    	rorq	$7, %rdi
# CHECK-NEXT:  5      7     1.00    *      *        	rolq	$7, (%rax)
# CHECK-NEXT:  5      7     1.00    *      *        	rorq	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	rolq	%cl, %rdi
# CHECK-NEXT:  3      3     1.00                    	rorq	%cl, %rdi
# CHECK-NEXT:  6      8     1.00    *      *        	rolq	%cl, (%rax)
# CHECK-NEXT:  5      8     1.00    *      *        	rorq	%cl, (%rax)
# CHECK-NEXT:  1      1     0.50                    	sarb	%dil
# CHECK-NEXT:  1      1     0.50                    	shlb	%dil
# CHECK-NEXT:  1      1     0.50                    	shrb	%dil
# CHECK-NEXT:  4      6     1.00    *      *        	sarb	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shlb	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrb	(%rax)
# CHECK-NEXT:  1      1     0.50                    	sarb	$7, %dil
# CHECK-NEXT:  1      1     0.50                    	shlb	$7, %dil
# CHECK-NEXT:  1      1     0.50                    	shrb	$7, %dil
# CHECK-NEXT:  4      6     1.00    *      *        	sarb	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shlb	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrb	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	sarb	%cl, %dil
# CHECK-NEXT:  3      3     1.00                    	shlb	%cl, %dil
# CHECK-NEXT:  3      3     1.00                    	shrb	%cl, %dil
# CHECK-NEXT:  6      8     1.00    *      *        	sarb	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shlb	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shrb	%cl, (%rax)
# CHECK-NEXT:  1      1     0.50                    	sarw	%di
# CHECK-NEXT:  1      1     0.50                    	shlw	%di
# CHECK-NEXT:  1      1     0.50                    	shrw	%di
# CHECK-NEXT:  4      6     1.00    *      *        	sarw	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shlw	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrw	(%rax)
# CHECK-NEXT:  1      1     0.50                    	sarw	$7, %di
# CHECK-NEXT:  1      1     0.50                    	shlw	$7, %di
# CHECK-NEXT:  1      1     0.50                    	shrw	$7, %di
# CHECK-NEXT:  4      6     1.00    *      *        	sarw	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shlw	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrw	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	sarw	%cl, %di
# CHECK-NEXT:  3      3     1.00                    	shlw	%cl, %di
# CHECK-NEXT:  3      3     1.00                    	shrw	%cl, %di
# CHECK-NEXT:  6      8     1.00    *      *        	sarw	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shlw	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shrw	%cl, (%rax)
# CHECK-NEXT:  1      1     0.50                    	sarl	%edi
# CHECK-NEXT:  1      1     0.50                    	shll	%edi
# CHECK-NEXT:  1      1     0.50                    	shrl	%edi
# CHECK-NEXT:  4      6     1.00    *      *        	sarl	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shll	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrl	(%rax)
# CHECK-NEXT:  1      1     0.50                    	sarl	$7, %edi
# CHECK-NEXT:  1      1     0.50                    	shll	$7, %edi
# CHECK-NEXT:  1      1     0.50                    	shrl	$7, %edi
# CHECK-NEXT:  4      6     1.00    *      *        	sarl	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shll	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrl	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	sarl	%cl, %edi
# CHECK-NEXT:  3      3     1.00                    	shll	%cl, %edi
# CHECK-NEXT:  3      3     1.00                    	shrl	%cl, %edi
# CHECK-NEXT:  6      8     1.00    *      *        	sarl	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shll	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shrl	%cl, (%rax)
# CHECK-NEXT:  1      1     0.50                    	sarq	%rdi
# CHECK-NEXT:  1      1     0.50                    	shlq	%rdi
# CHECK-NEXT:  1      1     0.50                    	shrq	%rdi
# CHECK-NEXT:  4      6     1.00    *      *        	sarq	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shlq	(%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrq	(%rax)
# CHECK-NEXT:  1      1     0.50                    	sarq	$7, %rdi
# CHECK-NEXT:  1      1     0.50                    	shlq	$7, %rdi
# CHECK-NEXT:  1      1     0.50                    	shrq	$7, %rdi
# CHECK-NEXT:  4      6     1.00    *      *        	sarq	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shlq	$7, (%rax)
# CHECK-NEXT:  4      6     1.00    *      *        	shrq	$7, (%rax)
# CHECK-NEXT:  3      3     1.00                    	sarq	%cl, %rdi
# CHECK-NEXT:  3      3     1.00                    	shlq	%cl, %rdi
# CHECK-NEXT:  3      3     1.00                    	shrq	%cl, %rdi
# CHECK-NEXT:  6      8     1.00    *      *        	sarq	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shlq	%cl, (%rax)
# CHECK-NEXT:  6      8     1.00    *      *        	shrq	%cl, (%rax)

# CHECK:      Resources:
# CHECK-NEXT: [0] - BWDivider
# CHECK-NEXT: [1] - BWFPDivider
# CHECK-NEXT: [2] - BWPort0
# CHECK-NEXT: [3] - BWPort1
# CHECK-NEXT: [4] - BWPort2
# CHECK-NEXT: [5] - BWPort3
# CHECK-NEXT: [6] - BWPort4
# CHECK-NEXT: [7] - BWPort5
# CHECK-NEXT: [8] - BWPort6
# CHECK-NEXT: [9] - BWPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     172.75 69.25  70.00  70.00  56.00  42.25  172.75 28.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    	Instructions:
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rclb	%dil
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrb	%dil
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rclb	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrb	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rclb	$7, %dil
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrb	$7, %dil
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rclb	$7, (%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrb	$7, (%rax)
# CHECK-NEXT:  -      -     2.75   2.25    -      -      -     1.25   2.75    -     	rclb	%cl, %dil
# CHECK-NEXT:  -      -     2.50   3.50    -      -      -     1.50   2.50    -     	rcrb	%cl, %dil
# CHECK-NEXT:  -      -     2.50   2.00   0.83   0.83    -     1.00   2.50   0.33   	rclb	%cl, (%rax)
# CHECK-NEXT:  -      -     2.25   3.25   0.83   0.83    -     1.25   2.25   0.33   	rcrb	%cl, (%rax)
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rclw	%di
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrw	%di
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rclw	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrw	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rclw	$7, %di
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrw	$7, %di
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rclw	$7, (%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrw	$7, (%rax)
# CHECK-NEXT:  -      -     1.75   2.75    -      -      -     0.75   1.75    -     	rclw	%cl, %di
# CHECK-NEXT:  -      -     1.75   2.75    -      -      -     0.75   1.75    -     	rcrw	%cl, %di
# CHECK-NEXT:  -      -     2.50   2.00   0.83   0.83    -     1.00   2.50   0.33   	rclw	%cl, (%rax)
# CHECK-NEXT:  -      -     2.25   3.25   0.83   0.83    -     1.25   2.25   0.33   	rcrw	%cl, (%rax)
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcll	%edi
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrl	%edi
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcll	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrl	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcll	$7, %edi
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrl	$7, %edi
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcll	$7, (%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrl	$7, (%rax)
# CHECK-NEXT:  -      -     1.75   2.75    -      -      -     0.75   1.75    -     	rcll	%cl, %edi
# CHECK-NEXT:  -      -     1.75   2.75    -      -      -     0.75   1.75    -     	rcrl	%cl, %edi
# CHECK-NEXT:  -      -     2.50   2.00   0.83   0.83    -     1.00   2.50   0.33   	rcll	%cl, (%rax)
# CHECK-NEXT:  -      -     2.25   3.25   0.83   0.83    -     1.25   2.25   0.33   	rcrl	%cl, (%rax)
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rclq	%rdi
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrq	%rdi
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rclq	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrq	(%rax)
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rclq	$7, %rdi
# CHECK-NEXT:  -      -     1.00   0.50    -      -      -     0.50   1.00    -     	rcrq	$7, %rdi
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rclq	$7, (%rax)
# CHECK-NEXT:  -      -     1.00   0.50   0.83   0.83    -     0.50   1.00   0.33   	rcrq	$7, (%rax)
# CHECK-NEXT:  -      -     1.75   2.75    -      -      -     0.75   1.75    -     	rclq	%cl, %rdi
# CHECK-NEXT:  -      -     1.75   2.75    -      -      -     0.75   1.75    -     	rcrq	%cl, %rdi
# CHECK-NEXT:  -      -     2.50   2.00   0.83   0.83    -     1.00   2.50   0.33   	rclq	%cl, (%rax)
# CHECK-NEXT:  -      -     2.25   3.25   0.83   0.83    -     1.25   2.25   0.33   	rcrq	%cl, (%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rolb	%dil
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorb	%dil
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rolb	(%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorb	(%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rolb	$7, %dil
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorb	$7, %dil
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rolb	$7, (%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorb	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	rolb	%cl, %dil
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	rorb	%cl, %dil
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	rolb	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83    -     0.25   1.25   0.33   	rorb	%cl, (%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rolw	%di
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorw	%di
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rolw	(%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorw	(%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rolw	$7, %di
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorw	$7, %di
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rolw	$7, (%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorw	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	rolw	%cl, %di
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	rorw	%cl, %di
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	rolw	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83    -     0.25   1.25   0.33   	rorw	%cl, (%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	roll	%edi
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorl	%edi
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	roll	(%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorl	(%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	roll	$7, %edi
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorl	$7, %edi
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	roll	$7, (%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorl	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	roll	%cl, %edi
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	rorl	%cl, %edi
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	roll	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83    -     0.25   1.25   0.33   	rorl	%cl, (%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rolq	%rdi
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorq	%rdi
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rolq	(%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorq	(%rax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rolq	$7, %rdi
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     1.00    -     	rorq	$7, %rdi
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rolq	$7, (%rax)
# CHECK-NEXT:  -      -     1.00    -     0.83   0.83   1.00    -     1.00   0.33   	rorq	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	rolq	%cl, %rdi
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	rorq	%cl, %rdi
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	rolq	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83    -     0.25   1.25   0.33   	rorq	%cl, (%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarb	%dil
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shlb	%dil
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrb	%dil
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarb	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shlb	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrb	(%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarb	$7, %dil
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shlb	$7, %dil
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrb	$7, %dil
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarb	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shlb	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrb	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	sarb	%cl, %dil
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shlb	%cl, %dil
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shrb	%cl, %dil
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	sarb	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shlb	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shrb	%cl, (%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarw	%di
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shlw	%di
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrw	%di
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarw	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shlw	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrw	(%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarw	$7, %di
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shlw	$7, %di
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrw	$7, %di
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarw	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shlw	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrw	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	sarw	%cl, %di
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shlw	%cl, %di
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shrw	%cl, %di
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	sarw	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shlw	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shrw	%cl, (%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarl	%edi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shll	%edi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrl	%edi
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarl	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shll	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrl	(%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarl	$7, %edi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shll	$7, %edi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrl	$7, %edi
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarl	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shll	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrl	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	sarl	%cl, %edi
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shll	%cl, %edi
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shrl	%cl, %edi
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	sarl	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shll	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shrl	%cl, (%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarq	%rdi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shlq	%rdi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrq	%rdi
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarq	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shlq	(%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrq	(%rax)
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	sarq	$7, %rdi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shlq	$7, %rdi
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     	shrq	$7, %rdi
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	sarq	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shlq	$7, (%rax)
# CHECK-NEXT:  -      -     0.50    -     0.83   0.83   1.00    -     0.50   0.33   	shrq	$7, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	sarq	%cl, %rdi
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shlq	%cl, %rdi
# CHECK-NEXT:  -      -     1.25   0.25    -      -      -     0.25   1.25    -     	shrq	%cl, %rdi
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	sarq	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shlq	%cl, (%rax)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   	shrq	%cl, (%rax)

