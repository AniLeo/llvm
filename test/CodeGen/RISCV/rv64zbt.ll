; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zbt -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBT

define signext i32 @cmix_i32(i32 signext %a, i32 signext %b, i32 signext %c) nounwind {
; RV64I-LABEL: cmix_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmix_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    cmix a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %and = and i32 %b, %a
  %neg = xor i32 %b, -1
  %and1 = and i32 %neg, %c
  %or = or i32 %and1, %and
  ret i32 %or
}

define signext i32 @cmix_i32_2(i32 signext %a, i32 signext %b, i32 signext %c) nounwind {
; RV64I-LABEL: cmix_i32_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xor a0, a0, a2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    xor a0, a0, a2
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmix_i32_2:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    cmix a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %xor = xor i32 %a, %c
  %and = and i32 %xor, %b
  %xor1 = xor i32 %and, %c
  ret i32 %xor1
}

define i64 @cmix_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmix_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmix_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    cmix a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %and = and i64 %b, %a
  %neg = xor i64 %b, -1
  %and1 = and i64 %neg, %c
  %or = or i64 %and1, %and
  ret i64 %or
}

define i64 @cmix_i64_2(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmix_i64_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xor a0, a1, a2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    xor a0, a0, a2
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmix_i64_2:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    cmix a0, a1, a1, a2
; RV64ZBT-NEXT:    ret
  %xor = xor i64 %b, %c
  %and = and i64 %xor, %b
  %xor1 = xor i64 %and, %c
  ret i64 %xor1
}

define signext i32 @cmov_i32(i32 signext %a, i32 signext %b, i32 signext %c) nounwind {
; RV64I-LABEL: cmov_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a1, .LBB4_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a2, a0
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp eq i32 %b, 0
  %cond = select i1 %tobool.not, i32 %c, i32 %a
  ret i32 %cond
}

define signext i32 @cmov_sle_i32(i32 signext %a, i32 signext %b, i32 signext %c, i32 signext %d) nounwind {
; RV64I-LABEL: cmov_sle_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bge a2, a1, .LBB5_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB5_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sle_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slt a1, a2, a1
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sle i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define signext i32 @cmov_sge_i32(i32 signext %a, i32 signext %b, i32 signext %c, i32 signext %d) nounwind {
; RV64I-LABEL: cmov_sge_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bge a1, a2, .LBB6_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB6_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sge_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slt a1, a1, a2
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sge i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define signext i32 @cmov_ule_i32(i32 signext %a, i32 signext %b, i32 signext %c, i32 signext %d) nounwind {
; RV64I-LABEL: cmov_ule_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bgeu a2, a1, .LBB7_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB7_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ule_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltu a1, a2, a1
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp ule i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define signext i32 @cmov_uge_i32(i32 signext %a, i32 signext %b, i32 signext %c, i32 signext %d) nounwind {
; RV64I-LABEL: cmov_uge_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bgeu a1, a2, .LBB8_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB8_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_uge_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltu a1, a1, a2
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp uge i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i64 @cmov_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a1, .LBB9_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a2, a0
; RV64I-NEXT:  .LBB9_2:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp eq i64 %b, 0
  %cond = select i1 %tobool.not, i64 %c, i64 %a
  ret i64 %cond
}

define i64 @cmov_eq_i64_constant_2048(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_eq_i64_constant_2048:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a3, 1
; RV64I-NEXT:    addiw a3, a3, -2048
; RV64I-NEXT:    beq a1, a3, .LBB10_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB10_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_eq_i64_constant_2048:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    addi a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp eq i64 %b, 2048
  %cond = select i1 %tobool.not, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_eq_i64_constant_neg_2047(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_eq_i64_constant_neg_2047:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, -2047
; RV64I-NEXT:    beq a1, a3, .LBB11_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB11_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_eq_i64_constant_neg_2047:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    addi a1, a1, 2047
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp eq i64 %b, -2047
  %cond = select i1 %tobool.not, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_ne_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV64I-LABEL: cmov_ne_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bne a1, a2, .LBB12_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB12_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ne_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    xor a1, a1, a2
; RV64ZBT-NEXT:    cmov a0, a1, a0, a3
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp ne i64 %b, %c
  %cond = select i1 %tobool.not, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_ne_i64_constant_zero(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_ne_i64_constant_zero:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bnez a1, .LBB13_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB13_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ne_i64_constant_zero:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp ne i64 %b, 0
  %cond = select i1 %tobool.not, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_ne_i64_constant_2048(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_ne_i64_constant_2048:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a3, 1
; RV64I-NEXT:    addiw a3, a3, -2048
; RV64I-NEXT:    bne a1, a3, .LBB14_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB14_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ne_i64_constant_2048:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    addi a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp ne i64 %b, 2048
  %cond = select i1 %tobool.not, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_ne_i64_constant_neg_2047(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_ne_i64_constant_neg_2047:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, -2047
; RV64I-NEXT:    bne a1, a3, .LBB15_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB15_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ne_i64_constant_neg_2047:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    addi a1, a1, 2047
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool.not = icmp ne i64 %b, -2047
  %cond = select i1 %tobool.not, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_sle_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV64I-LABEL: cmov_sle_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bge a2, a1, .LBB16_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB16_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sle_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slt a1, a2, a1
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sle i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_sle_i64_constant_2046(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_sle_i64_constant_2046:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, 2047
; RV64I-NEXT:    blt a1, a3, .LBB17_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB17_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sle_i64_constant_2046:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slti a1, a1, 2047
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool = icmp sle i64 %b, 2046
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_sle_i64_constant_neg_2049(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_sle_i64_constant_neg_2049:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, -2048
; RV64I-NEXT:    blt a1, a3, .LBB18_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB18_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sle_i64_constant_neg_2049:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slti a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool = icmp sle i64 %b, -2049
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_sgt_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV64I-LABEL: cmov_sgt_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    blt a2, a1, .LBB19_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB19_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sgt_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slt a1, a2, a1
; RV64ZBT-NEXT:    cmov a0, a1, a0, a3
; RV64ZBT-NEXT:    ret
  %tobool = icmp sgt i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_sgt_i64_constant_2046(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_sgt_i64_constant_2046:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, 2046
; RV64I-NEXT:    blt a3, a1, .LBB20_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB20_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sgt_i64_constant_2046:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slti a1, a1, 2047
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sgt i64 %b, 2046
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_sgt_i64_constant_neg_2049(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_sgt_i64_constant_neg_2049:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a3, 1048575
; RV64I-NEXT:    addiw a3, a3, 2047
; RV64I-NEXT:    blt a3, a1, .LBB21_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB21_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sgt_i64_constant_neg_2049:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slti a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sgt i64 %b, -2049
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_sge_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV64I-LABEL: cmov_sge_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bge a1, a2, .LBB22_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB22_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sge_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slt a1, a1, a2
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sge i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_sge_i64_constant_2047(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_sge_i64_constant_2047:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, 2046
; RV64I-NEXT:    blt a3, a1, .LBB23_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB23_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sge_i64_constant_2047:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slti a1, a1, 2047
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sge i64 %b, 2047
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_sge_i64_constant_neg_2048(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_sge_i64_constant_neg_2048:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a3, 1048575
; RV64I-NEXT:    addiw a3, a3, 2047
; RV64I-NEXT:    blt a3, a1, .LBB24_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB24_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_sge_i64_constant_neg_2048:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    slti a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp sge i64 %b, -2048
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_ule_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV64I-LABEL: cmov_ule_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bgeu a2, a1, .LBB25_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB25_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ule_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltu a1, a2, a1
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp ule i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_ule_i64_constant_2047(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_ule_i64_constant_2047:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a1, a1, 11
; RV64I-NEXT:    beqz a1, .LBB26_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB26_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ule_i64_constant_2047:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    srli a1, a1, 11
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp ule i64 %b, 2047
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_ule_i64_constant_neg_2049(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_ule_i64_constant_neg_2049:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, -2048
; RV64I-NEXT:    bltu a1, a3, .LBB27_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB27_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ule_i64_constant_neg_2049:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltiu a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %tobool = icmp ule i64 %b, 18446744073709549567
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_ugt_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV64I-LABEL: cmov_ugt_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bltu a2, a1, .LBB28_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB28_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ugt_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltu a1, a2, a1
; RV64ZBT-NEXT:    cmov a0, a1, a0, a3
; RV64ZBT-NEXT:    ret
  %tobool = icmp ugt i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_ugt_i64_constant_2046(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_ugt_i64_constant_2046:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, 2046
; RV64I-NEXT:    bltu a3, a1, .LBB29_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB29_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ugt_i64_constant_2046:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltiu a1, a1, 2047
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp ugt i64 %b, 2046
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_ugt_i64_constant_neg_2049(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_ugt_i64_constant_neg_2049:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a3, 1048575
; RV64I-NEXT:    addiw a3, a3, 2047
; RV64I-NEXT:    bltu a3, a1, .LBB30_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB30_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_ugt_i64_constant_neg_2049:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltiu a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp ugt i64 %b, 18446744073709549567
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_uge_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV64I-LABEL: cmov_uge_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bgeu a1, a2, .LBB31_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB31_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_uge_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltu a1, a1, a2
; RV64ZBT-NEXT:    cmov a0, a1, a3, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp uge i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_uge_i64_constant_2047(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_uge_i64_constant_2047:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a3, 2046
; RV64I-NEXT:    bltu a3, a1, .LBB32_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB32_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_uge_i64_constant_2047:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltiu a1, a1, 2047
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp uge i64 %b, 2047
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

define i64 @cmov_uge_i64_constant_neg_2048(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: cmov_uge_i64_constant_neg_2048:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a3, 1048575
; RV64I-NEXT:    addiw a3, a3, 2047
; RV64I-NEXT:    bltu a3, a1, .LBB33_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB33_2:
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: cmov_uge_i64_constant_neg_2048:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    sltiu a1, a1, -2048
; RV64ZBT-NEXT:    cmov a0, a1, a2, a0
; RV64ZBT-NEXT:    ret
  %tobool = icmp uge i64 %b, 18446744073709549568
  %cond = select i1 %tobool, i64 %a, i64 %c
  ret i64 %cond
}

declare i32 @llvm.fshl.i32(i32, i32, i32)

define signext i32 @fshl_i32(i32 signext %a, i32 signext %b, i32 signext %c) nounwind {
; RV64I-LABEL: fshl_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    andi a1, a2, 31
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    srai a0, a0, 32
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshl_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a2, a2, 31
; RV64ZBT-NEXT:    fslw a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

; Similar to fshl_i32 but result is not sign extended.
define void @fshl_i32_nosext(i32 signext %a, i32 signext %b, i32 signext %c, i32* %x) nounwind {
; RV64I-LABEL: fshl_i32_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    andi a1, a2, 31
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    sw a0, 0(a3)
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshl_i32_nosext:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a2, a2, 31
; RV64ZBT-NEXT:    fslw a0, a0, a1, a2
; RV64ZBT-NEXT:    sw a0, 0(a3)
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 %c)
  store i32 %1, i32* %x
  ret void
}

declare i64 @llvm.fshl.i64(i64, i64, i64)

define i64 @fshl_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: fshl_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sll a0, a0, a2
; RV64I-NEXT:    not a2, a2
; RV64I-NEXT:    srli a1, a1, 1
; RV64I-NEXT:    srl a1, a1, a2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshl_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a2, a2, 63
; RV64ZBT-NEXT:    fsl a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshl.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

declare i32 @llvm.fshr.i32(i32, i32, i32)

define signext i32 @fshr_i32(i32 signext %a, i32 signext %b, i32 signext %c) nounwind {
; RV64I-LABEL: fshr_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    andi a1, a2, 31
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshr_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a2, a2, 31
; RV64ZBT-NEXT:    fsrw a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

; Similar to fshr_i32 but result is not sign extended.
define void @fshr_i32_nosext(i32 signext %a, i32 signext %b, i32 signext %c, i32* %x) nounwind {
; RV64I-LABEL: fshr_i32_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    andi a1, a2, 31
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    sw a0, 0(a3)
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshr_i32_nosext:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a2, a2, 31
; RV64ZBT-NEXT:    fsrw a0, a1, a0, a2
; RV64ZBT-NEXT:    sw a0, 0(a3)
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 %c)
  store i32 %1, i32* %x
  ret void
}

declare i64 @llvm.fshr.i64(i64, i64, i64)

define i64 @fshr_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV64I-LABEL: fshr_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srl a1, a1, a2
; RV64I-NEXT:    not a2, a2
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    sll a0, a0, a2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshr_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a2, a2, 63
; RV64ZBT-NEXT:    fsr a0, a1, a0, a2
; RV64ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshr.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

define signext i32 @fshri_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: fshri_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a1, 5
; RV64I-NEXT:    slli a0, a0, 27
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshri_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsriw a0, a1, a0, 5
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 5)
  ret i32 %1
}

; Similar to fshr_i32 but result is not sign extended.
define void @fshri_i32_nosext(i32 signext %a, i32 signext %b, i32* %x) nounwind {
; RV64I-LABEL: fshri_i32_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a1, 5
; RV64I-NEXT:    slli a0, a0, 27
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    sw a0, 0(a2)
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshri_i32_nosext:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsriw a0, a1, a0, 5
; RV64ZBT-NEXT:    sw a0, 0(a2)
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 5)
  store i32 %1, i32* %x
  ret void
}

define i64 @fshri_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: fshri_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a1, a1, 5
; RV64I-NEXT:    slli a0, a0, 59
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshri_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsri a0, a1, a0, 5
; RV64ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshr.i64(i64 %a, i64 %b, i64 5)
  ret i64 %1
}

define signext i32 @fshli_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: fshli_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a1, 27
; RV64I-NEXT:    slli a0, a0, 5
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshli_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsriw a0, a1, a0, 27
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 5)
  ret i32 %1
}

; Similar to fshl_i32 but result is not sign extended.
define void @fshli_i32_nosext(i32 signext %a, i32 signext %b, i32* %x) nounwind {
; RV64I-LABEL: fshli_i32_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a1, 27
; RV64I-NEXT:    slli a0, a0, 5
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    sw a0, 0(a2)
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshli_i32_nosext:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsriw a0, a1, a0, 27
; RV64ZBT-NEXT:    sw a0, 0(a2)
; RV64ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 5)
  store i32 %1, i32* %x
  ret void
}

define i64 @fshli_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: fshli_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a1, a1, 59
; RV64I-NEXT:    slli a0, a0, 5
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBT-LABEL: fshli_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsri a0, a1, a0, 59
; RV64ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshl.i64(i64 %a, i64 %b, i64 5)
  ret i64 %1
}
