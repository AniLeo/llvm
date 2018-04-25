# RUN: llvm-mc -filetype=obj -triple riscv32 < %s \
# RUN:     | llvm-objdump -d - | FileCheck -check-prefix=INSTR %s
# RUN: llvm-mc -filetype=obj -triple riscv32 < %s \
# RUN:     | llvm-readobj -r | FileCheck -check-prefix=RELOC %s
# RUN: llvm-mc -triple riscv32 < %s -show-encoding \
# RUN:     | FileCheck -check-prefix=FIXUP %s

.long foo

call foo
# RELOC: R_RISCV_CALL foo 0x0
# INSTR: auipc ra, 0
# INSTR: jalr  ra
# FIXUP: fixup A - offset: 0, value: foo, kind:
call bar
# RELOC: R_RISCV_CALL bar 0x0
# INSTR: auipc ra, 0
# INSTR: jalr  ra
# FIXUP: fixup A - offset: 0, value: bar, kind:
