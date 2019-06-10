# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views=false -summary-view -bottleneck-analysis -iterations 1 < %s | FileCheck %s -implicit-check-not 'Cycles with backend pressure increase'

add %eax, %ebx

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      1
# CHECK-NEXT: Total Cycles:      4
# CHECK-NEXT: Total uOps:        1

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.25
# CHECK-NEXT: IPC:               0.25
# CHECK-NEXT: Block RThroughput: 0.5

# CHECK:      No resource or data dependency bottlenecks discovered.
