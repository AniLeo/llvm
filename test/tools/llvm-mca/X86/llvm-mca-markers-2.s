# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -resource-pressure=false < %s | FileCheck %s

  add %edi, %esi
# LLVM-MCA-END
  add %esi, %eax

# CHECK:      [0] Code Region - Default

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      1
# CHECK-NEXT: Total Cycles:      4
# CHECK-NEXT: Total uOps:        1

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.25
# CHECK-NEXT: IPC:               0.25
# CHECK-NEXT: Block RThroughput: 0.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        addl	%edi, %esi
