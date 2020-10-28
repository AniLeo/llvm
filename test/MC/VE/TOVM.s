# RUN: llvm-mc -triple=ve --show-encoding < %s \
# RUN:     | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: llvm-mc -triple=ve -filetype=obj < %s | llvm-objdump -d - \
# RUN:     | FileCheck %s --check-prefixes=CHECK-INST

# CHECK-INST: tovm %s11, %vm0
# CHECK-ENCODING: encoding: [0x00,0x00,0x00,0x00,0x00,0x00,0x0b,0xa6]
tovm %s11, %vm0

# CHECK-INST: tovm %s11, %vm1
# CHECK-ENCODING: encoding: [0x00,0x00,0x01,0x00,0x00,0x00,0x0b,0xa6]
tovm %s11, %vm1

# CHECK-INST: tovm %s11, %vm15
# CHECK-ENCODING: encoding: [0x00,0x00,0x0f,0x00,0x00,0x00,0x0b,0xa6]
tovm %s11, %vm15
