# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake-avx512 -instruction-tables < %s | FileCheck %s

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
# CHECK-NEXT:  2      5     1.00                        vcvtph2ps	%xmm0, %xmm2
# CHECK-NEXT:  2      9     0.50    *                   vcvtph2ps	(%rax), %xmm2
# CHECK-NEXT:  2      7     1.00                        vcvtph2ps	%xmm0, %ymm2
# CHECK-NEXT:  2      10    0.50    *                   vcvtph2ps	(%rax), %ymm2
# CHECK-NEXT:  2      5     1.00                        vcvtps2ph	$0, %xmm0, %xmm2
# CHECK-NEXT:  4      6     1.00           *            vcvtps2ph	$0, %xmm0, (%rax)
# CHECK-NEXT:  2      7     1.00                        vcvtps2ph	$0, %ymm0, %xmm2
# CHECK-NEXT:  4      8     1.00           *            vcvtps2ph	$0, %ymm0, (%rax)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SKXDivider
# CHECK-NEXT: [1]   - SKXFPDivider
# CHECK-NEXT: [2]   - SKXPort0
# CHECK-NEXT: [3]   - SKXPort1
# CHECK-NEXT: [4]   - SKXPort2
# CHECK-NEXT: [5]   - SKXPort3
# CHECK-NEXT: [6]   - SKXPort4
# CHECK-NEXT: [7]   - SKXPort5
# CHECK-NEXT: [8]   - SKXPort6
# CHECK-NEXT: [9]   - SKXPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     2.67   2.67   1.67   1.67   2.00   8.67    -     0.67

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     1.33    -      -     vcvtph2ps	%xmm0, %xmm2
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vcvtph2ps	(%rax), %xmm2
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     1.33    -      -     vcvtph2ps	%xmm0, %ymm2
# CHECK-NEXT:  -      -     0.33   0.33   0.50   0.50    -     0.33    -      -     vcvtph2ps	(%rax), %ymm2
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     1.33    -      -     vcvtps2ph	$0, %xmm0, %xmm2
# CHECK-NEXT:  -      -     0.33   0.33   0.33   0.33   1.00   1.33    -     0.33   vcvtps2ph	$0, %xmm0, (%rax)
# CHECK-NEXT:  -      -     0.33   0.33    -      -      -     1.33    -      -     vcvtps2ph	$0, %ymm0, %xmm2
# CHECK-NEXT:  -      -     0.33   0.33   0.33   0.33   1.00   1.33    -     0.33   vcvtps2ph	$0, %ymm0, (%rax)
