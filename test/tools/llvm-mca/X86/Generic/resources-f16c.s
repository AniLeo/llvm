# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -instruction-tables < %s | FileCheck %s

vcvtph2ps   %xmm0, %xmm2
vcvtph2ps   (%rax), %xmm2

vcvtph2ps   %xmm0, %ymm2
vcvtph2ps   (%rax), %ymm2

vcvtps2ph   $0, %xmm0, %xmm2
vcvtps2ph   $0, %xmm0, (%rax)

vcvtps2ph   $0, %ymm0, %xmm2
vcvtps2ph   $0, %ymm0, (%rax)

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        vcvtph2ps	%xmm0, %xmm2
# CHECK-NEXT:  2      8     1.00    *                   vcvtph2ps	(%rax), %xmm2
# CHECK-NEXT:  1      3     1.00                        vcvtph2ps	%xmm0, %ymm2
# CHECK-NEXT:  2      8     1.00    *                   vcvtph2ps	(%rax), %ymm2
# CHECK-NEXT:  1      3     1.00                        vcvtps2ph	$0, %xmm0, %xmm2
# CHECK-NEXT:  1      4     1.00           *            vcvtps2ph	$0, %xmm0, (%rax)
# CHECK-NEXT:  1      3     1.00                        vcvtps2ph	$0, %ymm0, %xmm2
# CHECK-NEXT:  1      4     1.00           *            vcvtps2ph	$0, %ymm0, (%rax)

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
# CHECK-NEXT:  -      -      -     8.00   2.00    -     2.00   2.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vcvtph2ps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vcvtph2ps	(%rax), %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vcvtph2ps	%xmm0, %ymm2
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   vcvtph2ps	(%rax), %ymm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vcvtps2ph	$0, %xmm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00    -     0.50   0.50   vcvtps2ph	$0, %xmm0, (%rax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     vcvtps2ph	$0, %ymm0, %xmm2
# CHECK-NEXT:  -      -      -     1.00   1.00    -     0.50   0.50   vcvtps2ph	$0, %ymm0, (%rax)
