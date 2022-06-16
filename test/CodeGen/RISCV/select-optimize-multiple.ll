; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -target-abi=ilp32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zbt -target-abi=ilp32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IBT
; RUN: llc -mtriple=riscv64 -mattr=+d -target-abi=lp64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zbt -target-abi=lp64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IBT

; Selects of wide values are split into two selects, which can easily cause
; unnecessary control flow. Here we check some cases where we can currently
; emit a sequence of selects with shared control flow.

define i64 @cmovcc64(i32 signext %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: cmovcc64:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    li a5, 123
; RV32I-NEXT:    beq a0, a5, .LBB0_2
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    mv a1, a3
; RV32I-NEXT:    mv a2, a4
; RV32I-NEXT:  .LBB0_2: # %entry
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    mv a1, a2
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmovcc64:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    addi a5, a0, -123
; RV32IBT-NEXT:    cmov a0, a5, a3, a1
; RV32IBT-NEXT:    cmov a1, a5, a4, a2
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmovcc64:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    li a3, 123
; RV64I-NEXT:    beq a0, a3, .LBB0_2
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    mv a1, a2
; RV64I-NEXT:  .LBB0_2: # %entry
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmovcc64:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    addi a0, a0, -123
; RV64IBT-NEXT:    cmov a0, a0, a2, a1
; RV64IBT-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 123
  %cond = select i1 %cmp, i64 %b, i64 %c
  ret i64 %cond
}

define i128 @cmovcc128(i64 signext %a, i128 %b, i128 %c) nounwind {
; RV32I-LABEL: cmovcc128:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    xori a1, a1, 123
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    mv a2, a3
; RV32I-NEXT:    beqz a1, .LBB1_2
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    mv a2, a4
; RV32I-NEXT:  .LBB1_2: # %entry
; RV32I-NEXT:    beqz a1, .LBB1_5
; RV32I-NEXT:  # %bb.3: # %entry
; RV32I-NEXT:    addi a5, a4, 4
; RV32I-NEXT:    bnez a1, .LBB1_6
; RV32I-NEXT:  .LBB1_4:
; RV32I-NEXT:    addi a6, a3, 8
; RV32I-NEXT:    j .LBB1_7
; RV32I-NEXT:  .LBB1_5:
; RV32I-NEXT:    addi a5, a3, 4
; RV32I-NEXT:    beqz a1, .LBB1_4
; RV32I-NEXT:  .LBB1_6: # %entry
; RV32I-NEXT:    addi a6, a4, 8
; RV32I-NEXT:  .LBB1_7: # %entry
; RV32I-NEXT:    lw a2, 0(a2)
; RV32I-NEXT:    lw a5, 0(a5)
; RV32I-NEXT:    lw a6, 0(a6)
; RV32I-NEXT:    beqz a1, .LBB1_9
; RV32I-NEXT:  # %bb.8: # %entry
; RV32I-NEXT:    addi a1, a4, 12
; RV32I-NEXT:    j .LBB1_10
; RV32I-NEXT:  .LBB1_9:
; RV32I-NEXT:    addi a1, a3, 12
; RV32I-NEXT:  .LBB1_10: # %entry
; RV32I-NEXT:    lw a1, 0(a1)
; RV32I-NEXT:    sw a1, 12(a0)
; RV32I-NEXT:    sw a6, 8(a0)
; RV32I-NEXT:    sw a5, 4(a0)
; RV32I-NEXT:    sw a2, 0(a0)
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmovcc128:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    addi a5, a3, 12
; RV32IBT-NEXT:    addi a6, a4, 12
; RV32IBT-NEXT:    addi a7, a3, 8
; RV32IBT-NEXT:    addi t0, a4, 8
; RV32IBT-NEXT:    addi t1, a3, 4
; RV32IBT-NEXT:    addi t2, a4, 4
; RV32IBT-NEXT:    xori a1, a1, 123
; RV32IBT-NEXT:    or a1, a1, a2
; RV32IBT-NEXT:    cmov a2, a1, a4, a3
; RV32IBT-NEXT:    cmov a3, a1, t2, t1
; RV32IBT-NEXT:    cmov a4, a1, t0, a7
; RV32IBT-NEXT:    cmov a1, a1, a6, a5
; RV32IBT-NEXT:    lw a1, 0(a1)
; RV32IBT-NEXT:    lw a4, 0(a4)
; RV32IBT-NEXT:    lw a3, 0(a3)
; RV32IBT-NEXT:    lw a2, 0(a2)
; RV32IBT-NEXT:    sw a1, 12(a0)
; RV32IBT-NEXT:    sw a4, 8(a0)
; RV32IBT-NEXT:    sw a3, 4(a0)
; RV32IBT-NEXT:    sw a2, 0(a0)
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmovcc128:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    li a5, 123
; RV64I-NEXT:    beq a0, a5, .LBB1_2
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    mv a1, a3
; RV64I-NEXT:    mv a2, a4
; RV64I-NEXT:  .LBB1_2: # %entry
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    mv a1, a2
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmovcc128:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    addi a5, a0, -123
; RV64IBT-NEXT:    cmov a0, a5, a3, a1
; RV64IBT-NEXT:    cmov a1, a5, a4, a2
; RV64IBT-NEXT:    ret
entry:
  %cmp = icmp eq i64 %a, 123
  %cond = select i1 %cmp, i128 %b, i128 %c
  ret i128 %cond
}

define i64 @cmov64(i1 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: cmov64:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    andi a5, a0, 1
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    bnez a5, .LBB2_2
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:    mv a2, a4
; RV32I-NEXT:  .LBB2_2: # %entry
; RV32I-NEXT:    mv a1, a2
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmov64:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    andi a5, a0, 1
; RV32IBT-NEXT:    cmov a0, a5, a1, a3
; RV32IBT-NEXT:    cmov a1, a5, a2, a4
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmov64:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    andi a3, a0, 1
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    bnez a3, .LBB2_2
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB2_2: # %entry
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmov64:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    andi a0, a0, 1
; RV64IBT-NEXT:    cmov a0, a0, a1, a2
; RV64IBT-NEXT:    ret
entry:
  %cond = select i1 %a, i64 %b, i64 %c
  ret i64 %cond
}

define i128 @cmov128(i1 %a, i128 %b, i128 %c) nounwind {
; RV32I-LABEL: cmov128:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    andi a1, a1, 1
; RV32I-NEXT:    mv a4, a2
; RV32I-NEXT:    bnez a1, .LBB3_2
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    mv a4, a3
; RV32I-NEXT:  .LBB3_2: # %entry
; RV32I-NEXT:    bnez a1, .LBB3_5
; RV32I-NEXT:  # %bb.3: # %entry
; RV32I-NEXT:    addi a5, a3, 4
; RV32I-NEXT:    beqz a1, .LBB3_6
; RV32I-NEXT:  .LBB3_4:
; RV32I-NEXT:    addi a6, a2, 8
; RV32I-NEXT:    j .LBB3_7
; RV32I-NEXT:  .LBB3_5:
; RV32I-NEXT:    addi a5, a2, 4
; RV32I-NEXT:    bnez a1, .LBB3_4
; RV32I-NEXT:  .LBB3_6: # %entry
; RV32I-NEXT:    addi a6, a3, 8
; RV32I-NEXT:  .LBB3_7: # %entry
; RV32I-NEXT:    lw a4, 0(a4)
; RV32I-NEXT:    lw a5, 0(a5)
; RV32I-NEXT:    lw a6, 0(a6)
; RV32I-NEXT:    bnez a1, .LBB3_9
; RV32I-NEXT:  # %bb.8: # %entry
; RV32I-NEXT:    addi a1, a3, 12
; RV32I-NEXT:    j .LBB3_10
; RV32I-NEXT:  .LBB3_9:
; RV32I-NEXT:    addi a1, a2, 12
; RV32I-NEXT:  .LBB3_10: # %entry
; RV32I-NEXT:    lw a1, 0(a1)
; RV32I-NEXT:    sw a1, 12(a0)
; RV32I-NEXT:    sw a6, 8(a0)
; RV32I-NEXT:    sw a5, 4(a0)
; RV32I-NEXT:    sw a4, 0(a0)
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmov128:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    addi a4, a3, 12
; RV32IBT-NEXT:    addi a5, a2, 12
; RV32IBT-NEXT:    addi a6, a3, 8
; RV32IBT-NEXT:    addi a7, a2, 8
; RV32IBT-NEXT:    addi t0, a3, 4
; RV32IBT-NEXT:    addi t1, a2, 4
; RV32IBT-NEXT:    andi a1, a1, 1
; RV32IBT-NEXT:    cmov a2, a1, a2, a3
; RV32IBT-NEXT:    cmov a3, a1, t1, t0
; RV32IBT-NEXT:    cmov a6, a1, a7, a6
; RV32IBT-NEXT:    cmov a1, a1, a5, a4
; RV32IBT-NEXT:    lw a1, 0(a1)
; RV32IBT-NEXT:    lw a4, 0(a6)
; RV32IBT-NEXT:    lw a3, 0(a3)
; RV32IBT-NEXT:    lw a2, 0(a2)
; RV32IBT-NEXT:    sw a1, 12(a0)
; RV32IBT-NEXT:    sw a4, 8(a0)
; RV32IBT-NEXT:    sw a3, 4(a0)
; RV32IBT-NEXT:    sw a2, 0(a0)
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmov128:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    andi a5, a0, 1
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    bnez a5, .LBB3_2
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:    mv a2, a4
; RV64I-NEXT:  .LBB3_2: # %entry
; RV64I-NEXT:    mv a1, a2
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmov128:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    andi a5, a0, 1
; RV64IBT-NEXT:    cmov a0, a5, a1, a3
; RV64IBT-NEXT:    cmov a1, a5, a2, a4
; RV64IBT-NEXT:    ret
entry:
  %cond = select i1 %a, i128 %b, i128 %c
  ret i128 %cond
}

define float @cmovfloat(i1 %a, float %b, float %c, float %d, float %e) nounwind {
; RV32I-LABEL: cmovfloat:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    andi a0, a0, 1
; RV32I-NEXT:    bnez a0, .LBB4_2
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    fmv.w.x ft0, a4
; RV32I-NEXT:    fmv.w.x ft1, a2
; RV32I-NEXT:    j .LBB4_3
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    fmv.w.x ft0, a3
; RV32I-NEXT:    fmv.w.x ft1, a1
; RV32I-NEXT:  .LBB4_3: # %entry
; RV32I-NEXT:    fadd.s ft0, ft1, ft0
; RV32I-NEXT:    fmv.x.w a0, ft0
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmovfloat:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    andi a0, a0, 1
; RV32IBT-NEXT:    bnez a0, .LBB4_2
; RV32IBT-NEXT:  # %bb.1: # %entry
; RV32IBT-NEXT:    fmv.w.x ft0, a4
; RV32IBT-NEXT:    fmv.w.x ft1, a2
; RV32IBT-NEXT:    j .LBB4_3
; RV32IBT-NEXT:  .LBB4_2:
; RV32IBT-NEXT:    fmv.w.x ft0, a3
; RV32IBT-NEXT:    fmv.w.x ft1, a1
; RV32IBT-NEXT:  .LBB4_3: # %entry
; RV32IBT-NEXT:    fadd.s ft0, ft1, ft0
; RV32IBT-NEXT:    fmv.x.w a0, ft0
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmovfloat:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    bnez a0, .LBB4_2
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    fmv.w.x ft0, a4
; RV64I-NEXT:    fmv.w.x ft1, a2
; RV64I-NEXT:    j .LBB4_3
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    fmv.w.x ft0, a3
; RV64I-NEXT:    fmv.w.x ft1, a1
; RV64I-NEXT:  .LBB4_3: # %entry
; RV64I-NEXT:    fadd.s ft0, ft1, ft0
; RV64I-NEXT:    fmv.x.w a0, ft0
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmovfloat:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    andi a0, a0, 1
; RV64IBT-NEXT:    bnez a0, .LBB4_2
; RV64IBT-NEXT:  # %bb.1: # %entry
; RV64IBT-NEXT:    fmv.w.x ft0, a4
; RV64IBT-NEXT:    fmv.w.x ft1, a2
; RV64IBT-NEXT:    j .LBB4_3
; RV64IBT-NEXT:  .LBB4_2:
; RV64IBT-NEXT:    fmv.w.x ft0, a3
; RV64IBT-NEXT:    fmv.w.x ft1, a1
; RV64IBT-NEXT:  .LBB4_3: # %entry
; RV64IBT-NEXT:    fadd.s ft0, ft1, ft0
; RV64IBT-NEXT:    fmv.x.w a0, ft0
; RV64IBT-NEXT:    ret
entry:
  %cond1 = select i1 %a, float %b, float %c
  %cond2 = select i1 %a, float %d, float %e
  %ret = fadd float %cond1, %cond2
  ret float %ret
}

define double @cmovdouble(i1 %a, double %b, double %c) nounwind {
; RV32I-LABEL: cmovdouble:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw a3, 8(sp)
; RV32I-NEXT:    sw a4, 12(sp)
; RV32I-NEXT:    fld ft0, 8(sp)
; RV32I-NEXT:    sw a1, 8(sp)
; RV32I-NEXT:    andi a0, a0, 1
; RV32I-NEXT:    sw a2, 12(sp)
; RV32I-NEXT:    beqz a0, .LBB5_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    fld ft0, 8(sp)
; RV32I-NEXT:  .LBB5_2: # %entry
; RV32I-NEXT:    fsd ft0, 8(sp)
; RV32I-NEXT:    lw a0, 8(sp)
; RV32I-NEXT:    lw a1, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmovdouble:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    addi sp, sp, -16
; RV32IBT-NEXT:    sw a3, 8(sp)
; RV32IBT-NEXT:    sw a4, 12(sp)
; RV32IBT-NEXT:    fld ft0, 8(sp)
; RV32IBT-NEXT:    sw a1, 8(sp)
; RV32IBT-NEXT:    andi a0, a0, 1
; RV32IBT-NEXT:    sw a2, 12(sp)
; RV32IBT-NEXT:    beqz a0, .LBB5_2
; RV32IBT-NEXT:  # %bb.1:
; RV32IBT-NEXT:    fld ft0, 8(sp)
; RV32IBT-NEXT:  .LBB5_2: # %entry
; RV32IBT-NEXT:    fsd ft0, 8(sp)
; RV32IBT-NEXT:    lw a0, 8(sp)
; RV32IBT-NEXT:    lw a1, 12(sp)
; RV32IBT-NEXT:    addi sp, sp, 16
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmovdouble:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    bnez a0, .LBB5_2
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    fmv.d.x ft0, a2
; RV64I-NEXT:    fmv.x.d a0, ft0
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB5_2:
; RV64I-NEXT:    fmv.d.x ft0, a1
; RV64I-NEXT:    fmv.x.d a0, ft0
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmovdouble:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    andi a0, a0, 1
; RV64IBT-NEXT:    bnez a0, .LBB5_2
; RV64IBT-NEXT:  # %bb.1: # %entry
; RV64IBT-NEXT:    fmv.d.x ft0, a2
; RV64IBT-NEXT:    fmv.x.d a0, ft0
; RV64IBT-NEXT:    ret
; RV64IBT-NEXT:  .LBB5_2:
; RV64IBT-NEXT:    fmv.d.x ft0, a1
; RV64IBT-NEXT:    fmv.x.d a0, ft0
; RV64IBT-NEXT:    ret
entry:
  %cond = select i1 %a, double %b, double %c
  ret double %cond
}

; Check that selects with dependencies on previous ones aren't incorrectly
; optimized.

define i32 @cmovccdep(i32 signext %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmovccdep:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    li a4, 123
; RV32I-NEXT:    bne a0, a4, .LBB6_3
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    mv a2, a1
; RV32I-NEXT:    bne a0, a4, .LBB6_4
; RV32I-NEXT:  .LBB6_2: # %entry
; RV32I-NEXT:    add a0, a1, a2
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB6_3: # %entry
; RV32I-NEXT:    mv a1, a2
; RV32I-NEXT:    mv a2, a1
; RV32I-NEXT:    beq a0, a4, .LBB6_2
; RV32I-NEXT:  .LBB6_4: # %entry
; RV32I-NEXT:    mv a2, a3
; RV32I-NEXT:    add a0, a1, a2
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmovccdep:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    addi a0, a0, -123
; RV32IBT-NEXT:    cmov a1, a0, a2, a1
; RV32IBT-NEXT:    cmov a0, a0, a3, a1
; RV32IBT-NEXT:    add a0, a1, a0
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmovccdep:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    li a4, 123
; RV64I-NEXT:    bne a0, a4, .LBB6_3
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    mv a2, a1
; RV64I-NEXT:    bne a0, a4, .LBB6_4
; RV64I-NEXT:  .LBB6_2: # %entry
; RV64I-NEXT:    addw a0, a1, a2
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB6_3: # %entry
; RV64I-NEXT:    mv a1, a2
; RV64I-NEXT:    mv a2, a1
; RV64I-NEXT:    beq a0, a4, .LBB6_2
; RV64I-NEXT:  .LBB6_4: # %entry
; RV64I-NEXT:    mv a2, a3
; RV64I-NEXT:    addw a0, a1, a2
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmovccdep:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    addi a0, a0, -123
; RV64IBT-NEXT:    cmov a1, a0, a2, a1
; RV64IBT-NEXT:    cmov a0, a0, a3, a1
; RV64IBT-NEXT:    addw a0, a1, a0
; RV64IBT-NEXT:    ret
entry:
  %cmp = icmp eq i32 %a, 123
  %cond1 = select i1 %cmp, i32 %b, i32 %c
  %cond2 = select i1 %cmp, i32 %cond1, i32 %d
  %ret = add i32 %cond1, %cond2
  ret i32 %ret
}

; Check that selects with different conditions aren't incorrectly optimized.

define i32 @cmovdiffcc(i1 %a, i1 %b, i32 %c, i32 %d, i32 %e, i32 %f) nounwind {
; RV32I-LABEL: cmovdiffcc:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    andi a6, a0, 1
; RV32I-NEXT:    andi a0, a1, 1
; RV32I-NEXT:    beqz a6, .LBB7_3
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    beqz a0, .LBB7_4
; RV32I-NEXT:  .LBB7_2: # %entry
; RV32I-NEXT:    add a0, a2, a4
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB7_3: # %entry
; RV32I-NEXT:    mv a2, a3
; RV32I-NEXT:    bnez a0, .LBB7_2
; RV32I-NEXT:  .LBB7_4: # %entry
; RV32I-NEXT:    mv a4, a5
; RV32I-NEXT:    add a0, a2, a4
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: cmovdiffcc:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    andi a1, a1, 1
; RV32IBT-NEXT:    andi a0, a0, 1
; RV32IBT-NEXT:    cmov a0, a0, a2, a3
; RV32IBT-NEXT:    cmov a1, a1, a4, a5
; RV32IBT-NEXT:    add a0, a0, a1
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: cmovdiffcc:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    andi a6, a0, 1
; RV64I-NEXT:    andi a0, a1, 1
; RV64I-NEXT:    beqz a6, .LBB7_3
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    beqz a0, .LBB7_4
; RV64I-NEXT:  .LBB7_2: # %entry
; RV64I-NEXT:    addw a0, a2, a4
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB7_3: # %entry
; RV64I-NEXT:    mv a2, a3
; RV64I-NEXT:    bnez a0, .LBB7_2
; RV64I-NEXT:  .LBB7_4: # %entry
; RV64I-NEXT:    mv a4, a5
; RV64I-NEXT:    addw a0, a2, a4
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: cmovdiffcc:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    andi a1, a1, 1
; RV64IBT-NEXT:    andi a0, a0, 1
; RV64IBT-NEXT:    cmov a0, a0, a2, a3
; RV64IBT-NEXT:    cmov a1, a1, a4, a5
; RV64IBT-NEXT:    addw a0, a0, a1
; RV64IBT-NEXT:    ret
entry:
  %cond1 = select i1 %a, i32 %c, i32 %d
  %cond2 = select i1 %b, i32 %e, i32 %f
  %ret = add i32 %cond1, %cond2
  ret i32 %ret
}

define float @CascadedSelect(float noundef %a) {
; RV32I-LABEL: CascadedSelect:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    fmv.w.x ft0, a0
; RV32I-NEXT:    fmv.w.x ft1, zero
; RV32I-NEXT:    flt.s a0, ft0, ft1
; RV32I-NEXT:    bnez a0, .LBB8_3
; RV32I-NEXT:  # %bb.1: # %entry
; RV32I-NEXT:    lui a0, %hi(.LCPI8_0)
; RV32I-NEXT:    flw ft1, %lo(.LCPI8_0)(a0)
; RV32I-NEXT:    flt.s a0, ft1, ft0
; RV32I-NEXT:    bnez a0, .LBB8_3
; RV32I-NEXT:  # %bb.2: # %entry
; RV32I-NEXT:    fmv.s ft1, ft0
; RV32I-NEXT:  .LBB8_3: # %entry
; RV32I-NEXT:    fmv.x.w a0, ft1
; RV32I-NEXT:    ret
;
; RV32IBT-LABEL: CascadedSelect:
; RV32IBT:       # %bb.0: # %entry
; RV32IBT-NEXT:    fmv.w.x ft0, a0
; RV32IBT-NEXT:    fmv.w.x ft1, zero
; RV32IBT-NEXT:    flt.s a0, ft0, ft1
; RV32IBT-NEXT:    bnez a0, .LBB8_3
; RV32IBT-NEXT:  # %bb.1: # %entry
; RV32IBT-NEXT:    lui a0, %hi(.LCPI8_0)
; RV32IBT-NEXT:    flw ft1, %lo(.LCPI8_0)(a0)
; RV32IBT-NEXT:    flt.s a0, ft1, ft0
; RV32IBT-NEXT:    bnez a0, .LBB8_3
; RV32IBT-NEXT:  # %bb.2: # %entry
; RV32IBT-NEXT:    fmv.s ft1, ft0
; RV32IBT-NEXT:  .LBB8_3: # %entry
; RV32IBT-NEXT:    fmv.x.w a0, ft1
; RV32IBT-NEXT:    ret
;
; RV64I-LABEL: CascadedSelect:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    fmv.w.x ft0, a0
; RV64I-NEXT:    fmv.w.x ft1, zero
; RV64I-NEXT:    flt.s a0, ft0, ft1
; RV64I-NEXT:    bnez a0, .LBB8_3
; RV64I-NEXT:  # %bb.1: # %entry
; RV64I-NEXT:    lui a0, %hi(.LCPI8_0)
; RV64I-NEXT:    flw ft1, %lo(.LCPI8_0)(a0)
; RV64I-NEXT:    flt.s a0, ft1, ft0
; RV64I-NEXT:    bnez a0, .LBB8_3
; RV64I-NEXT:  # %bb.2: # %entry
; RV64I-NEXT:    fmv.s ft1, ft0
; RV64I-NEXT:  .LBB8_3: # %entry
; RV64I-NEXT:    fmv.x.w a0, ft1
; RV64I-NEXT:    ret
;
; RV64IBT-LABEL: CascadedSelect:
; RV64IBT:       # %bb.0: # %entry
; RV64IBT-NEXT:    fmv.w.x ft0, a0
; RV64IBT-NEXT:    fmv.w.x ft1, zero
; RV64IBT-NEXT:    flt.s a0, ft0, ft1
; RV64IBT-NEXT:    bnez a0, .LBB8_3
; RV64IBT-NEXT:  # %bb.1: # %entry
; RV64IBT-NEXT:    lui a0, %hi(.LCPI8_0)
; RV64IBT-NEXT:    flw ft1, %lo(.LCPI8_0)(a0)
; RV64IBT-NEXT:    flt.s a0, ft1, ft0
; RV64IBT-NEXT:    bnez a0, .LBB8_3
; RV64IBT-NEXT:  # %bb.2: # %entry
; RV64IBT-NEXT:    fmv.s ft1, ft0
; RV64IBT-NEXT:  .LBB8_3: # %entry
; RV64IBT-NEXT:    fmv.x.w a0, ft1
; RV64IBT-NEXT:    ret
entry:
  %cmp = fcmp ogt float %a, 1.000000e+00
  %cmp1 = fcmp olt float %a, 0.000000e+00
  %.a = select i1 %cmp1, float 0.000000e+00, float %a
  %retval.0 = select i1 %cmp, float 1.000000e+00, float %.a
  ret float %retval.0
}
