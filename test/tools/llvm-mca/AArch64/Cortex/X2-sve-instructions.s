# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64 -mcpu=cortex-x2 -instruction-tables < %s | FileCheck %s

# Check the Neoverse N2 model is used.

addhnb	z0.b, z1.h, z31.h

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      2     0.50                        addhnb	z0.b, z1.h, z31.h

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - N2UnitB
# CHECK-NEXT: [0.1] - N2UnitB
# CHECK-NEXT: [1.0] - N2UnitD
# CHECK-NEXT: [1.1] - N2UnitD
# CHECK-NEXT: [2]   - N2UnitL2
# CHECK-NEXT: [3.0] - N2UnitL01
# CHECK-NEXT: [3.1] - N2UnitL01
# CHECK-NEXT: [4]   - N2UnitM0
# CHECK-NEXT: [5]   - N2UnitM1
# CHECK-NEXT: [6.0] - N2UnitS
# CHECK-NEXT: [6.1] - N2UnitS
# CHECK-NEXT: [7]   - N2UnitV0
# CHECK-NEXT: [8]   - N2UnitV1

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1.0]  [1.1]  [2]    [3.0]  [3.1]  [4]    [5]    [6.0]  [6.1]  [7]    [8]
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -     0.50   0.50

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1.0]  [1.1]  [2]    [3.0]  [3.1]  [4]    [5]    [6.0]  [6.1]  [7]    [8]    Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -     0.50   0.50   addhnb	z0.b, z1.h, z31.h
