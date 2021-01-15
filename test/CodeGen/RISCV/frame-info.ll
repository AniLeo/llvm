; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 < %s | FileCheck -check-prefix=RV32 %s
; RUN: llc -mtriple=riscv64 < %s | FileCheck -check-prefix=RV64 %s
; RUN: llc -mtriple=riscv32 -frame-pointer=all -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32-WITHFP %s
; RUN: llc -mtriple=riscv64 -frame-pointer=all -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64-WITHFP %s

define void @trivial() {
; RV32-LABEL: trivial:
; RV32:       # %bb.0:
; RV32-NEXT:    ret
;
; RV64-LABEL: trivial:
; RV64:       # %bb.0:
; RV64-NEXT:    ret
;
; RV32-WITHFP-LABEL: trivial:
; RV32-WITHFP:       # %bb.0:
; RV32-WITHFP-NEXT:    addi sp, sp, -16
; RV32-WITHFP-NEXT:    .cfi_def_cfa_offset 16
; RV32-WITHFP-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-WITHFP-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32-WITHFP-NEXT:    .cfi_offset ra, -4
; RV32-WITHFP-NEXT:    .cfi_offset s0, -8
; RV32-WITHFP-NEXT:    addi s0, sp, 16
; RV32-WITHFP-NEXT:    .cfi_def_cfa s0, 0
; RV32-WITHFP-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    addi sp, sp, 16
; RV32-WITHFP-NEXT:    ret
;
; RV64-WITHFP-LABEL: trivial:
; RV64-WITHFP:       # %bb.0:
; RV64-WITHFP-NEXT:    addi sp, sp, -16
; RV64-WITHFP-NEXT:    .cfi_def_cfa_offset 16
; RV64-WITHFP-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-WITHFP-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64-WITHFP-NEXT:    .cfi_offset ra, -8
; RV64-WITHFP-NEXT:    .cfi_offset s0, -16
; RV64-WITHFP-NEXT:    addi s0, sp, 16
; RV64-WITHFP-NEXT:    .cfi_def_cfa s0, 0
; RV64-WITHFP-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    addi sp, sp, 16
; RV64-WITHFP-NEXT:    ret
  ret void
}

define void @stack_alloc(i32 signext %size) {
; RV32-LABEL: stack_alloc:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32-NEXT:    .cfi_offset ra, -4
; RV32-NEXT:    .cfi_offset s0, -8
; RV32-NEXT:    addi s0, sp, 16
; RV32-NEXT:    .cfi_def_cfa s0, 0
; RV32-NEXT:    addi a0, a0, 15
; RV32-NEXT:    andi a0, a0, -16
; RV32-NEXT:    sub a0, sp, a0
; RV32-NEXT:    mv sp, a0
; RV32-NEXT:    call callee_with_args@plt
; RV32-NEXT:    addi sp, s0, -16
; RV32-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: stack_alloc:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    .cfi_def_cfa_offset 16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64-NEXT:    .cfi_offset ra, -8
; RV64-NEXT:    .cfi_offset s0, -16
; RV64-NEXT:    addi s0, sp, 16
; RV64-NEXT:    .cfi_def_cfa s0, 0
; RV64-NEXT:    slli a0, a0, 32
; RV64-NEXT:    srli a0, a0, 32
; RV64-NEXT:    addi a0, a0, 15
; RV64-NEXT:    andi a0, a0, -16
; RV64-NEXT:    sub a0, sp, a0
; RV64-NEXT:    mv sp, a0
; RV64-NEXT:    call callee_with_args@plt
; RV64-NEXT:    addi sp, s0, -16
; RV64-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
;
; RV32-WITHFP-LABEL: stack_alloc:
; RV32-WITHFP:       # %bb.0: # %entry
; RV32-WITHFP-NEXT:    addi sp, sp, -16
; RV32-WITHFP-NEXT:    .cfi_def_cfa_offset 16
; RV32-WITHFP-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-WITHFP-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32-WITHFP-NEXT:    .cfi_offset ra, -4
; RV32-WITHFP-NEXT:    .cfi_offset s0, -8
; RV32-WITHFP-NEXT:    addi s0, sp, 16
; RV32-WITHFP-NEXT:    .cfi_def_cfa s0, 0
; RV32-WITHFP-NEXT:    addi a0, a0, 15
; RV32-WITHFP-NEXT:    andi a0, a0, -16
; RV32-WITHFP-NEXT:    sub a0, sp, a0
; RV32-WITHFP-NEXT:    mv sp, a0
; RV32-WITHFP-NEXT:    call callee_with_args@plt
; RV32-WITHFP-NEXT:    addi sp, s0, -16
; RV32-WITHFP-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    addi sp, sp, 16
; RV32-WITHFP-NEXT:    ret
;
; RV64-WITHFP-LABEL: stack_alloc:
; RV64-WITHFP:       # %bb.0: # %entry
; RV64-WITHFP-NEXT:    addi sp, sp, -16
; RV64-WITHFP-NEXT:    .cfi_def_cfa_offset 16
; RV64-WITHFP-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-WITHFP-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64-WITHFP-NEXT:    .cfi_offset ra, -8
; RV64-WITHFP-NEXT:    .cfi_offset s0, -16
; RV64-WITHFP-NEXT:    addi s0, sp, 16
; RV64-WITHFP-NEXT:    .cfi_def_cfa s0, 0
; RV64-WITHFP-NEXT:    slli a0, a0, 32
; RV64-WITHFP-NEXT:    srli a0, a0, 32
; RV64-WITHFP-NEXT:    addi a0, a0, 15
; RV64-WITHFP-NEXT:    andi a0, a0, -16
; RV64-WITHFP-NEXT:    sub a0, sp, a0
; RV64-WITHFP-NEXT:    mv sp, a0
; RV64-WITHFP-NEXT:    call callee_with_args@plt
; RV64-WITHFP-NEXT:    addi sp, s0, -16
; RV64-WITHFP-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    addi sp, sp, 16
; RV64-WITHFP-NEXT:    ret
entry:
  %0 = alloca i8, i32 %size, align 16
  call void @callee_with_args(i8* nonnull %0)
  ret void
}

define void @branch_and_tail_call(i1 %a) {
; RV32-LABEL: branch_and_tail_call:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    .cfi_offset ra, -4
; RV32-NEXT:    andi a0, a0, 1
; RV32-NEXT:    beqz a0, .LBB2_2
; RV32-NEXT:  # %bb.1: # %blue_pill
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    tail callee1@plt
; RV32-NEXT:  .LBB2_2: # %red_pill
; RV32-NEXT:    call callee2@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: branch_and_tail_call:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    .cfi_def_cfa_offset 16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    .cfi_offset ra, -8
; RV64-NEXT:    andi a0, a0, 1
; RV64-NEXT:    beqz a0, .LBB2_2
; RV64-NEXT:  # %bb.1: # %blue_pill
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    tail callee1@plt
; RV64-NEXT:  .LBB2_2: # %red_pill
; RV64-NEXT:    call callee2@plt
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
;
; RV32-WITHFP-LABEL: branch_and_tail_call:
; RV32-WITHFP:       # %bb.0:
; RV32-WITHFP-NEXT:    addi sp, sp, -16
; RV32-WITHFP-NEXT:    .cfi_def_cfa_offset 16
; RV32-WITHFP-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-WITHFP-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32-WITHFP-NEXT:    .cfi_offset ra, -4
; RV32-WITHFP-NEXT:    .cfi_offset s0, -8
; RV32-WITHFP-NEXT:    addi s0, sp, 16
; RV32-WITHFP-NEXT:    .cfi_def_cfa s0, 0
; RV32-WITHFP-NEXT:    andi a0, a0, 1
; RV32-WITHFP-NEXT:    beqz a0, .LBB2_2
; RV32-WITHFP-NEXT:  # %bb.1: # %blue_pill
; RV32-WITHFP-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    addi sp, sp, 16
; RV32-WITHFP-NEXT:    tail callee1@plt
; RV32-WITHFP-NEXT:  .LBB2_2: # %red_pill
; RV32-WITHFP-NEXT:    call callee2@plt
; RV32-WITHFP-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-WITHFP-NEXT:    addi sp, sp, 16
; RV32-WITHFP-NEXT:    ret
;
; RV64-WITHFP-LABEL: branch_and_tail_call:
; RV64-WITHFP:       # %bb.0:
; RV64-WITHFP-NEXT:    addi sp, sp, -16
; RV64-WITHFP-NEXT:    .cfi_def_cfa_offset 16
; RV64-WITHFP-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-WITHFP-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64-WITHFP-NEXT:    .cfi_offset ra, -8
; RV64-WITHFP-NEXT:    .cfi_offset s0, -16
; RV64-WITHFP-NEXT:    addi s0, sp, 16
; RV64-WITHFP-NEXT:    .cfi_def_cfa s0, 0
; RV64-WITHFP-NEXT:    andi a0, a0, 1
; RV64-WITHFP-NEXT:    beqz a0, .LBB2_2
; RV64-WITHFP-NEXT:  # %bb.1: # %blue_pill
; RV64-WITHFP-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    addi sp, sp, 16
; RV64-WITHFP-NEXT:    tail callee1@plt
; RV64-WITHFP-NEXT:  .LBB2_2: # %red_pill
; RV64-WITHFP-NEXT:    call callee2@plt
; RV64-WITHFP-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-WITHFP-NEXT:    addi sp, sp, 16
; RV64-WITHFP-NEXT:    ret
  br i1 %a, label %blue_pill, label %red_pill
blue_pill:
  tail call void @callee1()
  ret void
red_pill:
  call void @callee2()
  ret void
}

declare void @callee1()
declare void @callee2()
declare void @callee_with_args(i8*)
