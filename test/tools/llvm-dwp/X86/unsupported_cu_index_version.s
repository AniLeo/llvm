# RUN: llvm-mc -triple x86_64-unknown-linux %s -filetype=obj -o %t.dwp
# RUN: not llvm-dwp %t.dwp -o %t 2>&1 | FileCheck %s

# CHECK: error: unsupported cu_index version: 5 (only version 2 is supported)
    .section .debug_info.dwo, "e", @progbits
    .long	.Ldebug_info_dwo_end0-.Ldebug_info_dwo_start0 # Length of Unit
.Ldebug_info_dwo_start0:
    .short 5                       # DWARF version number
    .byte 5                        # DWARF Unit type
    .byte 8                        # Address Size (in bytes)
    .long 0                        # Offset Into Abbrev. Section
    .quad	-346972125991005518
.Ldebug_info_dwo_end0:
    .section .debug_cu_index, "", @progbits
## Header:
    .short 5                        # Version
    .space 2                        # Padding
    .long 2                         # Section count
    .long 1                         # Unit count
    .long 2                         # Slot count
## Hash Table of Signatures:
    .quad 0x1100001122222222
    .quad 0
## Parallel Table of Indexes:
    .long 1
    .long 0
## Table of Section Offsets:
## Row 0:
    .long 1                         # DW_SECT_INFO
    .long 3                         # DW_SECT_ABBREV
## Row 1:
    .long 0
    .long 0
## Table of Section Sizes:
    .long 1
    .long 1
