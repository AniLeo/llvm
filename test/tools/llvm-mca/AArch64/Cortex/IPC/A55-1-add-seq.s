# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=aarch64 -mcpu=cortex-a55 --all-views=false --summary-view --iterations=1000 < %s | FileCheck %s

add	w8, w8, #1
add	w9, w9, #1

# CHECK:      Iterations:        1000
# CHECK-NEXT: Instructions:      2000
# CHECK-NEXT: Total Cycles:      1003
# CHECK-NEXT: Total uOps:        2000

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    1.99
# CHECK-NEXT: IPC:               1.99
# CHECK-NEXT: Block RThroughput: 1.0
