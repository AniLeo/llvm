# RUN: llvm-mca -mtriple=arm-eabi -mcpu=cortex-a9 -iterations=100 < %s | FileCheck %s

vadd.f32 s0, s2, s2

# CHECK: Iterations:     100
# CHECK-NEXT: Instructions:   100
# CHECK-NEXT: Total Cycles:   105
# CHECK-NEXT: Dispatch Width: 2
# CHECK-NEXT: IPC:            0.95

# CHECK: Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK: [1]    [2]    [3]    [4]    [5]    [6]	Instructions:
# CHECK-NEXT:  1      4     1.00                    	vadd.f32	s0, s2, s2


# CHECK: Resources:
# CHECK-NEXT: [0] - A9UnitAGU
# CHECK-NEXT: [1.0] - A9UnitALU
# CHECK-NEXT: [1.1] - A9UnitALU
# CHECK-NEXT: [2] - A9UnitB
# CHECK-NEXT: [3] - A9UnitFP
# CHECK-NEXT: [4] - A9UnitLS
# CHECK-NEXT: [5] - A9UnitMul

# CHECK: Resource pressure per iteration:
# CHECK-NEXT: [0]    [1.0]  [1.1]  [2]    [3]    [4]    [5]
# CHECK-NEXT: 1.00    -      -      -     1.00    -      -

# CHECK: Resource pressure by instruction:
# CHECK-NEXT: [0]    [1.0]  [1.1]  [2]    [3]    [4]    [5]    	Instructions:
# CHECK-NEXT: 1.00    -      -      -     1.00    -      -     	vadd.f32	s0, s2, s2
