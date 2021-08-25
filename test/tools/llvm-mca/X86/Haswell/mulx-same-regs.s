# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=haswell -timeline -iterations=2 < %s | FileCheck %s

# PR51495: If the two destination registers are the same, the destination will
# contain teh high half of the multiplication result.

# LLVM-MCA-BEGIN
mulxl %eax, %eax, %eax
# LLVM-MCA-END

# LLVM-MCA-BEGIN
mulxq %rax, %rax, %rax
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      10
# CHECK-NEXT: Total uOps:        8

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.80
# CHECK-NEXT: IPC:               0.20
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  4      4     1.00                        mulxl	%eax, %eax, %eax

# CHECK:      Resources:
# CHECK-NEXT: [0]   - HWDivider
# CHECK-NEXT: [1]   - HWFPDivider
# CHECK-NEXT: [2]   - HWPort0
# CHECK-NEXT: [3]   - HWPort1
# CHECK-NEXT: [4]   - HWPort2
# CHECK-NEXT: [5]   - HWPort3
# CHECK-NEXT: [6]   - HWPort4
# CHECK-NEXT: [7]   - HWPort5
# CHECK-NEXT: [8]   - HWPort6
# CHECK-NEXT: [9]   - HWPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     0.50   1.00    -      -      -     0.50   1.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -     0.50   1.00    -      -      -     0.50   1.00    -     mulxl	%eax, %eax, %eax

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeER  .   mulxl	%eax, %eax, %eax
# CHECK-NEXT: [1,0]     .D==eeeeER   mulxl	%eax, %eax, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     2.0    0.5    0.0       mulxl	%eax, %eax, %eax

# CHECK:      [1] Code Region

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      10
# CHECK-NEXT: Total uOps:        6

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.60
# CHECK-NEXT: IPC:               0.20
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  3      4     1.00                        mulxq	%rax, %rax, %rax

# CHECK:      Resources:
# CHECK-NEXT: [0]   - HWDivider
# CHECK-NEXT: [1]   - HWFPDivider
# CHECK-NEXT: [2]   - HWPort0
# CHECK-NEXT: [3]   - HWPort1
# CHECK-NEXT: [4]   - HWPort2
# CHECK-NEXT: [5]   - HWPort3
# CHECK-NEXT: [6]   - HWPort4
# CHECK-NEXT: [7]   - HWPort5
# CHECK-NEXT: [8]   - HWPort6
# CHECK-NEXT: [9]   - HWPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     1.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     1.00    -     mulxq	%rax, %rax, %rax

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeER  .   mulxq	%rax, %rax, %rax
# CHECK-NEXT: [1,0]     .D==eeeeER   mulxq	%rax, %rax, %rax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     2.0    0.5    0.0       mulxq	%rax, %rax, %rax
