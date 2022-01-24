# With Zk extension:
# RUN: not llvm-mc -triple=riscv32 -mattr=+zk < %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

# With Zkn extension:
# RUN: not llvm-mc -triple=riscv32 -mattr=+zkn < %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

# With Zkne extension:
# RUN: not llvm-mc -triple=riscv32 -mattr=+zkne < %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR

# CHECK-ERROR: immediate must be an integer in the range [0, 3]
aes32esmi a0, a1, a2, 8

# CHECK-ERROR: immediate must be an integer in the range [0, 3]
aes32esi a0, a1, a2, 8
