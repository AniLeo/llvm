# RUN: llvm-mc -arch=mips -show-encoding -mcpu=mips1 < %s | FileCheck %s
# RUN: llvm-mc -arch=mips -show-encoding -mcpu=mips64 < %s | FileCheck %s

sle   $4, $5
# CHECK: slt   $4, $5, $4       # encoding: [0x00,0xa4,0x20,0x2a]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
sle   $4, $5, $6
# CHECK: slt   $4, $6, $5       # encoding: [0x00,0xc5,0x20,0x2a]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
sle   $4, $5, 16
# CHECK: addiu $4, $zero, 16    # encoding: [0x24,0x04,0x00,0x10]
# CHECK: slt   $4, $4, $5       # encoding: [0x00,0x85,0x20,0x2a]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
sleu  $4, $5
# CHECK: sltu  $4, $5, $4       # encoding: [0x00,0xa4,0x20,0x2b]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
sleu  $4, $5, $6
# CHECK: sltu  $4, $6, $5       # encoding: [0x00,0xc5,0x20,0x2b]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
sleu  $4, $5, 16
# CHECK: addiu $4, $zero, 16    # encoding: [0x24,0x04,0x00,0x10]
# CHECK: sltu  $4, $4, $5       # encoding: [0x00,0x85,0x20,0x2b]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
sle   $4, 16
# CHECK: addiu $1, $zero, 16    # encoding: [0x24,0x01,0x00,0x10]
# CHECK: slt   $4, $1, $4       # encoding: [0x00,0x24,0x20,0x2a]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
sleu  $4, 16
# CHECK: addiu $1, $zero, 16    # encoding: [0x24,0x01,0x00,0x10]
# CHECK: sltu  $4, $1, $4       # encoding: [0x00,0x24,0x20,0x2b]
# CHECK: xori  $4, $4, 1        # encoding: [0x38,0x84,0x00,0x01]
