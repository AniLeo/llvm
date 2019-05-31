; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel -relocation-model=pic -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32_PIC

declare i32 @f(i32 %a, i32 %b);

define i32 @call_global(i32 %a0, i32 %a1, i32 %x, i32 %y) {
; MIPS32-LABEL: call_global:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    move $4, $6
; MIPS32-NEXT:    move $5, $7
; MIPS32-NEXT:    jal f
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    addu $2, $2, $2
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
;
; MIPS32_PIC-LABEL: call_global:
; MIPS32_PIC:       # %bb.0: # %entry
; MIPS32_PIC-NEXT:    lui $2, %hi(_gp_disp)
; MIPS32_PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; MIPS32_PIC-NEXT:    addiu $sp, $sp, -24
; MIPS32_PIC-NEXT:    .cfi_def_cfa_offset 24
; MIPS32_PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    .cfi_offset 31, -4
; MIPS32_PIC-NEXT:    addu $1, $2, $25
; MIPS32_PIC-NEXT:    lw $25, %call16(f)($1)
; MIPS32_PIC-NEXT:    move $4, $6
; MIPS32_PIC-NEXT:    move $5, $7
; MIPS32_PIC-NEXT:    move $gp, $1
; MIPS32_PIC-NEXT:    jalr $25
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:    addu $2, $2, $2
; MIPS32_PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 24
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
entry:
  %z = call i32 @f(i32 %x, i32 %y)
  %doublez = add i32 %z, %z
  ret i32 %doublez
}

define internal i32 @f_with_local_linkage(i32 %x, i32 %y) {
; MIPS32-LABEL: f_with_local_linkage:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addu $2, $5, $4
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
;
; MIPS32_PIC-LABEL: f_with_local_linkage:
; MIPS32_PIC:       # %bb.0: # %entry
; MIPS32_PIC-NEXT:    addu $2, $5, $4
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
entry:
  %add = add i32 %y, %x
  ret i32 %add
}

define i32 @call_global_with_local_linkage(i32 %a0, i32 %a1, i32 %x, i32 %y) {
; MIPS32-LABEL: call_global_with_local_linkage:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    move $4, $6
; MIPS32-NEXT:    move $5, $7
; MIPS32-NEXT:    jal f_with_local_linkage
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    addu $2, $2, $2
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
;
; MIPS32_PIC-LABEL: call_global_with_local_linkage:
; MIPS32_PIC:       # %bb.0: # %entry
; MIPS32_PIC-NEXT:    lui $2, %hi(_gp_disp)
; MIPS32_PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; MIPS32_PIC-NEXT:    addiu $sp, $sp, -24
; MIPS32_PIC-NEXT:    .cfi_def_cfa_offset 24
; MIPS32_PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    .cfi_offset 31, -4
; MIPS32_PIC-NEXT:    addu $1, $2, $25
; MIPS32_PIC-NEXT:    lw $2, %got(f_with_local_linkage)($1)
; MIPS32_PIC-NEXT:    addiu $25, $2, %lo(f_with_local_linkage)
; MIPS32_PIC-NEXT:    move $4, $6
; MIPS32_PIC-NEXT:    move $5, $7
; MIPS32_PIC-NEXT:    move $gp, $1
; MIPS32_PIC-NEXT:    jalr $25
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:    addu $2, $2, $2
; MIPS32_PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 24
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
entry:
  %z = call i32 @f_with_local_linkage(i32 %x, i32 %y)
  %doublez = add i32 %z, %z
  ret i32 %doublez
}

define i32 @call_reg(i32 (i32, i32)* %f_ptr, i32 %x, i32 %y) {
; MIPS32-LABEL: call_reg:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    sw $4, 16($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    move $4, $5
; MIPS32-NEXT:    move $5, $6
; MIPS32-NEXT:    lw $25, 16($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    jalr $25
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
;
; MIPS32_PIC-LABEL: call_reg:
; MIPS32_PIC:       # %bb.0: # %entry
; MIPS32_PIC-NEXT:    addiu $sp, $sp, -24
; MIPS32_PIC-NEXT:    .cfi_def_cfa_offset 24
; MIPS32_PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    .cfi_offset 31, -4
; MIPS32_PIC-NEXT:    sw $4, 16($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    move $4, $5
; MIPS32_PIC-NEXT:    move $5, $6
; MIPS32_PIC-NEXT:    lw $25, 16($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    jalr $25
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 24
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
entry:
  %call = call i32 %f_ptr(i32 %x, i32 %y)
  ret i32 %call
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1 immarg)

define void @call_symbol(i8* nocapture readonly %src, i8* nocapture %dest, i32 signext %length) {
; MIPS32-LABEL: call_symbol:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    sw $4, 16($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    move $4, $5
; MIPS32-NEXT:    lw $5, 16($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    jal memcpy
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
;
; MIPS32_PIC-LABEL: call_symbol:
; MIPS32_PIC:       # %bb.0: # %entry
; MIPS32_PIC-NEXT:    addiu $sp, $sp, -24
; MIPS32_PIC-NEXT:    .cfi_def_cfa_offset 24
; MIPS32_PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    .cfi_offset 31, -4
; MIPS32_PIC-NEXT:    sw $4, 16($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    move $4, $5
; MIPS32_PIC-NEXT:    lw $5, 16($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    jal memcpy
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 24
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %dest, i8* align 1 %src, i32 %length, i1 false)
  ret void
}
