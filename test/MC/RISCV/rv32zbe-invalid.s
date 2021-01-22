# RUN: not llvm-mc -triple riscv32 -mattr=+experimental-b,experimental-zbe < %s 2>&1 | FileCheck %s

# Too few operands
bdecompress t0, t1 # CHECK: :[[@LINE]]:1: error: too few operands for instruction
# Too few operands
bcompress t0, t1 # CHECK: :[[@LINE]]:1: error: too few operands for instruction
