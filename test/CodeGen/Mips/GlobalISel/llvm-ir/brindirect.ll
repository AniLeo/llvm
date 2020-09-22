; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel  -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32

define i32 @indirectbr(i8 *%addr) {
; MIPS32-LABEL: indirectbr:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -8
; MIPS32-NEXT:    .cfi_def_cfa_offset 8
; MIPS32-NEXT:    ori $2, $zero, 1
; MIPS32-NEXT:    ori $1, $zero, 0
; MIPS32-NEXT:    sw $2, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $1, 0($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    jr $4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_1: # %L1
; MIPS32-NEXT:    lw $2, 0($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 8
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_2: # %L2
; MIPS32-NEXT:    lw $2, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 8
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  indirectbr i8* %addr, [label %L1, label %L2]

L1:
  ret i32 0

L2:
  ret i32 1
}
