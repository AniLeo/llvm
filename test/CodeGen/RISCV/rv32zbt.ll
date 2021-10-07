; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zbt -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32ZBT

define i32 @cmix_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmix_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    not a1, a1
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    or a0, a1, a0
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmix_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmix a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %and = and i32 %b, %a
  %neg = xor i32 %b, -1
  %and1 = and i32 %neg, %c
  %or = or i32 %and1, %and
  ret i32 %or
}

define i64 @cmix_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: cmix_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    and a1, a3, a1
; RV32I-NEXT:    and a0, a2, a0
; RV32I-NEXT:    not a2, a2
; RV32I-NEXT:    not a3, a3
; RV32I-NEXT:    and a3, a3, a5
; RV32I-NEXT:    and a2, a2, a4
; RV32I-NEXT:    or a0, a2, a0
; RV32I-NEXT:    or a1, a3, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmix_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmix a0, a2, a0, a4
; RV32ZBT-NEXT:    cmix a1, a3, a1, a5
; RV32ZBT-NEXT:    ret
  %and = and i64 %b, %a
  %neg = xor i64 %b, -1
  %and1 = and i64 %neg, %c
  %or = or i64 %and1, %and
  ret i64 %or
}

define i32 @cmov_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beqz a1, .LBB2_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a2, a0
; RV32I-NEXT:  .LBB2_2:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp eq i32 %b, 0
  %cond = select i1 %tobool.not, i32 %c, i32 %a
  ret i32 %cond
}

define i32 @cmov_sle_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_sle_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bge a2, a1, .LBB3_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sle_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slt a1, a2, a1
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp sle i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_sge_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_sge_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bge a1, a2, .LBB4_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sge_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slt a1, a1, a2
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp sge i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_ule_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_ule_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bgeu a2, a1, .LBB5_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB5_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ule_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltu a1, a2, a1
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp ule i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_uge_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_uge_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bgeu a1, a2, .LBB6_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB6_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_uge_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltu a1, a1, a2
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp uge i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i64 @cmov_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: cmov_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    or a2, a2, a3
; RV32I-NEXT:    beqz a2, .LBB7_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a4, a0
; RV32I-NEXT:    mv a5, a1
; RV32I-NEXT:  .LBB7_2:
; RV32I-NEXT:    mv a0, a4
; RV32I-NEXT:    mv a1, a5
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    or a2, a2, a3
; RV32ZBT-NEXT:    cmov a0, a2, a0, a4
; RV32ZBT-NEXT:    cmov a1, a2, a1, a5
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp eq i64 %b, 0
  %cond = select i1 %tobool.not, i64 %c, i64 %a
  ret i64 %cond
}

define i64 @cmov_sle_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_sle_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB8_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    slt a2, a5, a3
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB8_3
; RV32I-NEXT:    j .LBB8_4
; RV32I-NEXT:  .LBB8_2:
; RV32I-NEXT:    sltu a2, a4, a2
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB8_4
; RV32I-NEXT:  .LBB8_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB8_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sle_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a4, a2
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    slt a3, a5, a3
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp sle i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_sge_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_sge_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB9_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    slt a2, a3, a5
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB9_3
; RV32I-NEXT:    j .LBB9_4
; RV32I-NEXT:  .LBB9_2:
; RV32I-NEXT:    sltu a2, a2, a4
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB9_4
; RV32I-NEXT:  .LBB9_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB9_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sge_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a2, a4
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    slt a3, a3, a5
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp sge i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_ule_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_ule_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB10_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a2, a5, a3
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB10_3
; RV32I-NEXT:    j .LBB10_4
; RV32I-NEXT:  .LBB10_2:
; RV32I-NEXT:    sltu a2, a4, a2
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB10_4
; RV32I-NEXT:  .LBB10_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB10_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ule_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a4, a2
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    sltu a3, a5, a3
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp ule i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_uge_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_uge_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB11_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a2, a3, a5
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB11_3
; RV32I-NEXT:    j .LBB11_4
; RV32I-NEXT:  .LBB11_2:
; RV32I-NEXT:    sltu a2, a2, a4
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB11_4
; RV32I-NEXT:  .LBB11_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB11_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_uge_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a2, a4
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    sltu a3, a3, a5
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp uge i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

declare i32 @llvm.fshl.i32(i32, i32, i32)

define i32 @fshl_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: fshl_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sll a0, a0, a2
; RV32I-NEXT:    not a2, a2
; RV32I-NEXT:    srli a1, a1, 1
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshl_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    andi a2, a2, 31
; RV32ZBT-NEXT:    fsl a0, a0, a1, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet an efficient pattern-matching with bit manipulation
; instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions that can match more efficiently this pattern.

declare i64 @llvm.fshl.i64(i64, i64, i64)

define i64 @fshl_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: fshl_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a5, a4, 63
; RV32I-NEXT:    addi a7, a5, -32
; RV32I-NEXT:    addi a6, zero, 31
; RV32I-NEXT:    bltz a7, .LBB13_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sll a1, a0, a7
; RV32I-NEXT:    j .LBB13_3
; RV32I-NEXT:  .LBB13_2:
; RV32I-NEXT:    sll t0, a1, a4
; RV32I-NEXT:    sub a5, a6, a5
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    srl a1, a1, a5
; RV32I-NEXT:    or a1, t0, a1
; RV32I-NEXT:  .LBB13_3:
; RV32I-NEXT:    not t2, a4
; RV32I-NEXT:    andi t1, t2, 63
; RV32I-NEXT:    addi a5, t1, -32
; RV32I-NEXT:    srli t0, a3, 1
; RV32I-NEXT:    bltz a5, .LBB13_5
; RV32I-NEXT:  # %bb.4:
; RV32I-NEXT:    srl a2, t0, a5
; RV32I-NEXT:    bltz a7, .LBB13_6
; RV32I-NEXT:    j .LBB13_7
; RV32I-NEXT:  .LBB13_5:
; RV32I-NEXT:    srl a5, t0, t2
; RV32I-NEXT:    or a1, a1, a5
; RV32I-NEXT:    slli a3, a3, 31
; RV32I-NEXT:    srli a2, a2, 1
; RV32I-NEXT:    or a2, a2, a3
; RV32I-NEXT:    srl a2, a2, t2
; RV32I-NEXT:    sub a3, a6, t1
; RV32I-NEXT:    slli a5, t0, 1
; RV32I-NEXT:    sll a3, a5, a3
; RV32I-NEXT:    or a2, a2, a3
; RV32I-NEXT:    bgez a7, .LBB13_7
; RV32I-NEXT:  .LBB13_6:
; RV32I-NEXT:    sll a0, a0, a4
; RV32I-NEXT:    or a2, a2, a0
; RV32I-NEXT:  .LBB13_7:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshl_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sll a7, a1, a4
; RV32ZBT-NEXT:    andi a5, a4, 63
; RV32ZBT-NEXT:    addi a6, zero, 31
; RV32ZBT-NEXT:    sub t0, a6, a5
; RV32ZBT-NEXT:    srli a1, a0, 1
; RV32ZBT-NEXT:    srl a1, a1, t0
; RV32ZBT-NEXT:    or a7, a7, a1
; RV32ZBT-NEXT:    addi t1, a5, -32
; RV32ZBT-NEXT:    sll t0, a0, t1
; RV32ZBT-NEXT:    slti a1, t1, 0
; RV32ZBT-NEXT:    cmov t0, a1, a7, t0
; RV32ZBT-NEXT:    not a5, a4
; RV32ZBT-NEXT:    srli a7, a3, 1
; RV32ZBT-NEXT:    srl t4, a7, a5
; RV32ZBT-NEXT:    andi t2, a5, 63
; RV32ZBT-NEXT:    addi t3, t2, -32
; RV32ZBT-NEXT:    srai a1, t3, 31
; RV32ZBT-NEXT:    and a1, a1, t4
; RV32ZBT-NEXT:    or a1, t0, a1
; RV32ZBT-NEXT:    fsri a2, a2, a3, 1
; RV32ZBT-NEXT:    srl a2, a2, a5
; RV32ZBT-NEXT:    sub a3, a6, t2
; RV32ZBT-NEXT:    slli a5, a7, 1
; RV32ZBT-NEXT:    sll a3, a5, a3
; RV32ZBT-NEXT:    or a2, a2, a3
; RV32ZBT-NEXT:    srl a3, a7, t3
; RV32ZBT-NEXT:    slti a5, t3, 0
; RV32ZBT-NEXT:    cmov a2, a5, a2, a3
; RV32ZBT-NEXT:    sll a0, a0, a4
; RV32ZBT-NEXT:    srai a3, t1, 31
; RV32ZBT-NEXT:    and a0, a3, a0
; RV32ZBT-NEXT:    or a0, a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshl.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

declare i32 @llvm.fshr.i32(i32, i32, i32)

define i32 @fshr_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: fshr_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    not a2, a2
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    sll a0, a0, a2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshr_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    andi a2, a2, 31
; RV32ZBT-NEXT:    fsr a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet an efficient pattern-matching with bit manipulation
; instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions that can match more efficiently this pattern.

declare i64 @llvm.fshr.i64(i64, i64, i64)

define i64 @fshr_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: fshr_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv t0, a0
; RV32I-NEXT:    andi a0, a4, 63
; RV32I-NEXT:    addi a6, a0, -32
; RV32I-NEXT:    addi a7, zero, 31
; RV32I-NEXT:    bltz a6, .LBB15_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    srl a0, a3, a6
; RV32I-NEXT:    j .LBB15_3
; RV32I-NEXT:  .LBB15_2:
; RV32I-NEXT:    srl a2, a2, a4
; RV32I-NEXT:    sub a0, a7, a0
; RV32I-NEXT:    slli a5, a3, 1
; RV32I-NEXT:    sll a0, a5, a0
; RV32I-NEXT:    or a0, a2, a0
; RV32I-NEXT:  .LBB15_3:
; RV32I-NEXT:    not t2, a4
; RV32I-NEXT:    andi a5, t2, 63
; RV32I-NEXT:    addi a2, a5, -32
; RV32I-NEXT:    slli t1, t0, 1
; RV32I-NEXT:    bltz a2, .LBB15_5
; RV32I-NEXT:  # %bb.4:
; RV32I-NEXT:    sll a1, t1, a2
; RV32I-NEXT:    bltz a6, .LBB15_6
; RV32I-NEXT:    j .LBB15_7
; RV32I-NEXT:  .LBB15_5:
; RV32I-NEXT:    sll a2, t1, t2
; RV32I-NEXT:    or a0, a0, a2
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    addi a2, a2, -1
; RV32I-NEXT:    and a2, t0, a2
; RV32I-NEXT:    sub a5, a7, a5
; RV32I-NEXT:    srl a2, a2, a5
; RV32I-NEXT:    srli a5, t0, 31
; RV32I-NEXT:    slli a1, a1, 1
; RV32I-NEXT:    or a1, a1, a5
; RV32I-NEXT:    sll a1, a1, t2
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    bgez a6, .LBB15_7
; RV32I-NEXT:  .LBB15_6:
; RV32I-NEXT:    srl a2, a3, a4
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:  .LBB15_7:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshr_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    srl a7, a2, a4
; RV32ZBT-NEXT:    andi a5, a4, 63
; RV32ZBT-NEXT:    addi a6, zero, 31
; RV32ZBT-NEXT:    sub t0, a6, a5
; RV32ZBT-NEXT:    slli a2, a3, 1
; RV32ZBT-NEXT:    sll a2, a2, t0
; RV32ZBT-NEXT:    or a7, a7, a2
; RV32ZBT-NEXT:    addi t2, a5, -32
; RV32ZBT-NEXT:    srl t0, a3, t2
; RV32ZBT-NEXT:    slti a2, t2, 0
; RV32ZBT-NEXT:    cmov a7, a2, a7, t0
; RV32ZBT-NEXT:    not t4, a4
; RV32ZBT-NEXT:    slli t0, a0, 1
; RV32ZBT-NEXT:    sll t1, t0, t4
; RV32ZBT-NEXT:    andi t3, t4, 63
; RV32ZBT-NEXT:    addi a5, t3, -32
; RV32ZBT-NEXT:    srai a2, a5, 31
; RV32ZBT-NEXT:    and a2, a2, t1
; RV32ZBT-NEXT:    or a7, a2, a7
; RV32ZBT-NEXT:    lui a2, 524288
; RV32ZBT-NEXT:    addi a2, a2, -1
; RV32ZBT-NEXT:    and t1, a0, a2
; RV32ZBT-NEXT:    sub a2, a6, t3
; RV32ZBT-NEXT:    srl a2, t1, a2
; RV32ZBT-NEXT:    fsri a0, a0, a1, 31
; RV32ZBT-NEXT:    sll a0, a0, t4
; RV32ZBT-NEXT:    or a0, a0, a2
; RV32ZBT-NEXT:    sll a1, t0, a5
; RV32ZBT-NEXT:    slti a2, a5, 0
; RV32ZBT-NEXT:    cmov a0, a2, a0, a1
; RV32ZBT-NEXT:    srl a1, a3, a4
; RV32ZBT-NEXT:    srai a2, t2, 31
; RV32ZBT-NEXT:    and a1, a2, a1
; RV32ZBT-NEXT:    or a1, a0, a1
; RV32ZBT-NEXT:    mv a0, a7
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshr.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

define i32 @fshri_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: fshri_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a1, a1, 5
; RV32I-NEXT:    slli a0, a0, 27
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshri_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a0, a1, a0, 5
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 5)
  ret i32 %1
}

define i64 @fshri_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: fshri_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a3, 27
; RV32I-NEXT:    srli a2, a2, 5
; RV32I-NEXT:    or a2, a2, a1
; RV32I-NEXT:    srli a1, a3, 5
; RV32I-NEXT:    slli a0, a0, 27
; RV32I-NEXT:    or a1, a0, a1
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshri_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a2, a2, a3, 5
; RV32ZBT-NEXT:    fsri a1, a3, a0, 5
; RV32ZBT-NEXT:    mv a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshr.i64(i64 %a, i64 %b, i64 5)
  ret i64 %1
}

define i32 @fshli_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: fshli_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a1, a1, 27
; RV32I-NEXT:    slli a0, a0, 5
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshli_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a0, a1, a0, 27
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 5)
  ret i32 %1
}

define i64 @fshli_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: fshli_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a2, a3, 27
; RV32I-NEXT:    slli a3, a0, 5
; RV32I-NEXT:    or a2, a3, a2
; RV32I-NEXT:    srli a0, a0, 27
; RV32I-NEXT:    slli a1, a1, 5
; RV32I-NEXT:    or a1, a1, a0
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshli_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a2, a3, a0, 27
; RV32ZBT-NEXT:    fsri a1, a0, a1, 27
; RV32ZBT-NEXT:    mv a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshl.i64(i64 %a, i64 %b, i64 5)
  ret i64 %1
}
