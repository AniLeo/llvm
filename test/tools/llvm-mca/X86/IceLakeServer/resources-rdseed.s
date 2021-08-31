# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=icelake-server -instruction-tables < %s | FileCheck %s

rdseed   %ax
rdseed   %eax
rdseed   %rax

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      100   0.25                  U     rdseedw	%ax
# CHECK-NEXT:  1      100   0.25                  U     rdseedl	%eax
# CHECK-NEXT:  1      100   0.25                  U     rdseedq	%rax

# CHECK:      Resources:
# CHECK-NEXT: [0]   - ICXDivider
# CHECK-NEXT: [1]   - ICXFPDivider
# CHECK-NEXT: [2]   - ICXPort0
# CHECK-NEXT: [3]   - ICXPort1
# CHECK-NEXT: [4]   - ICXPort2
# CHECK-NEXT: [5]   - ICXPort3
# CHECK-NEXT: [6]   - ICXPort4
# CHECK-NEXT: [7]   - ICXPort5
# CHECK-NEXT: [8]   - ICXPort6
# CHECK-NEXT: [9]   - ICXPort7
# CHECK-NEXT: [10]  - ICXPort8
# CHECK-NEXT: [11]  - ICXPort9

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]
# CHECK-NEXT:  -      -     0.75   0.75    -      -      -     0.75   0.75    -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   Instructions:
# CHECK-NEXT:  -      -     0.25   0.25    -      -      -     0.25   0.25    -      -      -     rdseedw	%ax
# CHECK-NEXT:  -      -     0.25   0.25    -      -      -     0.25   0.25    -      -      -     rdseedl	%eax
# CHECK-NEXT:  -      -     0.25   0.25    -      -      -     0.25   0.25    -      -      -     rdseedq	%rax
