; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv32 -mattr=+experimental-b -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IB
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zbb -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IBB

define i32 @slo_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: slo_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    sll a0, a0, a1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: slo_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    slo a0, a0, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: slo_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    slo a0, a0, a1
; RV32IBB-NEXT:    ret
  %neg = xor i32 %a, -1
  %shl = shl i32 %neg, %b
  %neg1 = xor i32 %shl, -1
  ret i32 %neg1
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet any matching bit manipulation instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions suitable for this pattern.

define i64 @slo_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: slo_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a3, a2, -32
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    bltz a3, .LBB1_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a2, zero
; RV32I-NEXT:    sll a1, a0, a3
; RV32I-NEXT:    j .LBB1_3
; RV32I-NEXT:  .LBB1_2:
; RV32I-NEXT:    not a1, a1
; RV32I-NEXT:    sll a1, a1, a2
; RV32I-NEXT:    addi a3, zero, 31
; RV32I-NEXT:    sub a3, a3, a2
; RV32I-NEXT:    srli a4, a0, 1
; RV32I-NEXT:    srl a3, a4, a3
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    sll a2, a0, a2
; RV32I-NEXT:  .LBB1_3:
; RV32I-NEXT:    not a1, a1
; RV32I-NEXT:    not a0, a2
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: slo_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    not a0, a0
; RV32IB-NEXT:    not a1, a1
; RV32IB-NEXT:    sll a1, a1, a2
; RV32IB-NEXT:    addi a3, zero, 31
; RV32IB-NEXT:    sub a3, a3, a2
; RV32IB-NEXT:    srli a4, a0, 1
; RV32IB-NEXT:    srl a3, a4, a3
; RV32IB-NEXT:    or a1, a1, a3
; RV32IB-NEXT:    addi a3, a2, -32
; RV32IB-NEXT:    sll a4, a0, a3
; RV32IB-NEXT:    slti a5, a3, 0
; RV32IB-NEXT:    cmov a1, a5, a1, a4
; RV32IB-NEXT:    sll a0, a0, a2
; RV32IB-NEXT:    srai a2, a3, 31
; RV32IB-NEXT:    and a0, a2, a0
; RV32IB-NEXT:    not a1, a1
; RV32IB-NEXT:    not a0, a0
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: slo_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    addi a3, a2, -32
; RV32IBB-NEXT:    not a0, a0
; RV32IBB-NEXT:    bltz a3, .LBB1_2
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    mv a2, zero
; RV32IBB-NEXT:    sll a1, a0, a3
; RV32IBB-NEXT:    j .LBB1_3
; RV32IBB-NEXT:  .LBB1_2:
; RV32IBB-NEXT:    not a1, a1
; RV32IBB-NEXT:    sll a1, a1, a2
; RV32IBB-NEXT:    addi a3, zero, 31
; RV32IBB-NEXT:    sub a3, a3, a2
; RV32IBB-NEXT:    srli a4, a0, 1
; RV32IBB-NEXT:    srl a3, a4, a3
; RV32IBB-NEXT:    or a1, a1, a3
; RV32IBB-NEXT:    sll a2, a0, a2
; RV32IBB-NEXT:  .LBB1_3:
; RV32IBB-NEXT:    not a1, a1
; RV32IBB-NEXT:    not a0, a2
; RV32IBB-NEXT:    ret
  %neg = xor i64 %a, -1
  %shl = shl i64 %neg, %b
  %neg1 = xor i64 %shl, -1
  ret i64 %neg1
}

define i32 @sro_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sro_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    srl a0, a0, a1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sro_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sro a0, a0, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sro_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    sro a0, a0, a1
; RV32IBB-NEXT:    ret
  %neg = xor i32 %a, -1
  %shr = lshr i32 %neg, %b
  %neg1 = xor i32 %shr, -1
  ret i32 %neg1
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet any matching bit manipulation instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions suitable for this pattern.

define i64 @sro_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: sro_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a3, a2, -32
; RV32I-NEXT:    not a1, a1
; RV32I-NEXT:    bltz a3, .LBB3_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a2, zero
; RV32I-NEXT:    srl a0, a1, a3
; RV32I-NEXT:    j .LBB3_3
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    srl a0, a0, a2
; RV32I-NEXT:    addi a3, zero, 31
; RV32I-NEXT:    sub a3, a3, a2
; RV32I-NEXT:    slli a4, a1, 1
; RV32I-NEXT:    sll a3, a4, a3
; RV32I-NEXT:    or a0, a0, a3
; RV32I-NEXT:    srl a2, a1, a2
; RV32I-NEXT:  .LBB3_3:
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    not a1, a2
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sro_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    not a1, a1
; RV32IB-NEXT:    not a0, a0
; RV32IB-NEXT:    srl a0, a0, a2
; RV32IB-NEXT:    addi a3, zero, 31
; RV32IB-NEXT:    sub a3, a3, a2
; RV32IB-NEXT:    slli a4, a1, 1
; RV32IB-NEXT:    sll a3, a4, a3
; RV32IB-NEXT:    or a0, a0, a3
; RV32IB-NEXT:    addi a3, a2, -32
; RV32IB-NEXT:    srl a4, a1, a3
; RV32IB-NEXT:    slti a5, a3, 0
; RV32IB-NEXT:    cmov a0, a5, a0, a4
; RV32IB-NEXT:    srl a1, a1, a2
; RV32IB-NEXT:    srai a2, a3, 31
; RV32IB-NEXT:    and a1, a2, a1
; RV32IB-NEXT:    not a0, a0
; RV32IB-NEXT:    not a1, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sro_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    addi a3, a2, -32
; RV32IBB-NEXT:    not a1, a1
; RV32IBB-NEXT:    bltz a3, .LBB3_2
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    mv a2, zero
; RV32IBB-NEXT:    srl a0, a1, a3
; RV32IBB-NEXT:    j .LBB3_3
; RV32IBB-NEXT:  .LBB3_2:
; RV32IBB-NEXT:    not a0, a0
; RV32IBB-NEXT:    srl a0, a0, a2
; RV32IBB-NEXT:    addi a3, zero, 31
; RV32IBB-NEXT:    sub a3, a3, a2
; RV32IBB-NEXT:    slli a4, a1, 1
; RV32IBB-NEXT:    sll a3, a4, a3
; RV32IBB-NEXT:    or a0, a0, a3
; RV32IBB-NEXT:    srl a2, a1, a2
; RV32IBB-NEXT:  .LBB3_3:
; RV32IBB-NEXT:    not a0, a0
; RV32IBB-NEXT:    not a1, a2
; RV32IBB-NEXT:    ret
  %neg = xor i64 %a, -1
  %shr = lshr i64 %neg, %b
  %neg1 = xor i64 %shr, -1
  ret i64 %neg1
}

define i32 @sloi_i32(i32 %a) nounwind {
; RV32I-LABEL: sloi_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    ori a0, a0, 1
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sloi_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sloi a0, a0, 1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sloi_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    sloi a0, a0, 1
; RV32IBB-NEXT:    ret
  %neg = shl i32 %a, 1
  %neg12 = or i32 %neg, 1
  ret i32 %neg12
}

define i64 @sloi_i64(i64 %a) nounwind {
; RV32I-LABEL: sloi_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a2, a0, 31
; RV32I-NEXT:    slli a1, a1, 1
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    ori a0, a0, 1
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sloi_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    fsri a1, a0, a1, 31
; RV32IB-NEXT:    sloi a0, a0, 1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sloi_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    srli a2, a0, 31
; RV32IBB-NEXT:    slli a1, a1, 1
; RV32IBB-NEXT:    or a1, a1, a2
; RV32IBB-NEXT:    sloi a0, a0, 1
; RV32IBB-NEXT:    ret
  %neg = shl i64 %a, 1
  %neg12 = or i64 %neg, 1
  ret i64 %neg12
}

define i32 @sroi_i32(i32 %a) nounwind {
; RV32I-LABEL: sroi_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a0, a0, 1
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sroi_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sroi a0, a0, 1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sroi_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    sroi a0, a0, 1
; RV32IBB-NEXT:    ret
  %neg = lshr i32 %a, 1
  %neg12 = or i32 %neg, -2147483648
  ret i32 %neg12
}

define i64 @sroi_i64(i64 %a) nounwind {
; RV32I-LABEL: sroi_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a1, 31
; RV32I-NEXT:    srli a0, a0, 1
; RV32I-NEXT:    or a0, a0, a2
; RV32I-NEXT:    srli a1, a1, 1
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sroi_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    fsri a0, a0, a1, 1
; RV32IB-NEXT:    sroi a1, a1, 1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sroi_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    slli a2, a1, 31
; RV32IBB-NEXT:    srli a0, a0, 1
; RV32IBB-NEXT:    or a0, a0, a2
; RV32IBB-NEXT:    sroi a1, a1, 1
; RV32IBB-NEXT:    ret
  %neg = lshr i64 %a, 1
  %neg12 = or i64 %neg, -9223372036854775808
  ret i64 %neg12
}

declare i32 @llvm.ctlz.i32(i32, i1)

define i32 @ctlz_i32(i32 %a) nounwind {
; RV32I-LABEL: ctlz_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    beqz a0, .LBB8_2
; RV32I-NEXT:  # %bb.1: # %cond.false
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 8
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 16
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    j .LBB8_3
; RV32I-NEXT:  .LBB8_2:
; RV32I-NEXT:    addi a0, zero, 32
; RV32I-NEXT:  .LBB8_3: # %cond.end
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: ctlz_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    clz a0, a0
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: ctlz_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    clz a0, a0
; RV32IBB-NEXT:    ret
  %1 = call i32 @llvm.ctlz.i32(i32 %a, i1 false)
  ret i32 %1
}

declare i64 @llvm.ctlz.i64(i64, i1)

define i64 @ctlz_i64(i64 %a) nounwind {
; RV32I-LABEL: ctlz_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 20(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 16(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s3, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s4, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s5, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s6, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s3, a1
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    srli a0, a1, 1
; RV32I-NEXT:    or a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 8
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 16
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi s5, a2, 1365
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi s1, a1, 819
; RV32I-NEXT:    and a1, a0, s1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s1
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi s6, a1, -241
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi s0, a1, 257
; RV32I-NEXT:    mv a1, s0
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    srli a0, s4, 1
; RV32I-NEXT:    or a0, s4, a0
; RV32I-NEXT:    srli a1, a0, 2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 8
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 16
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    and a1, a0, s1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s1
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    mv a1, s0
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    bnez s3, .LBB9_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    addi a0, a0, 32
; RV32I-NEXT:    j .LBB9_3
; RV32I-NEXT:  .LBB9_2:
; RV32I-NEXT:    srli a0, s2, 24
; RV32I-NEXT:  .LBB9_3:
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    lw s6, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s5, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s4, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s3, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 16(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 20(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: ctlz_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    clz a2, a1
; RV32IB-NEXT:    clz a0, a0
; RV32IB-NEXT:    addi a0, a0, 32
; RV32IB-NEXT:    cmov a0, a1, a2, a0
; RV32IB-NEXT:    mv a1, zero
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: ctlz_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    bnez a1, .LBB9_2
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    clz a0, a0
; RV32IBB-NEXT:    addi a0, a0, 32
; RV32IBB-NEXT:    mv a1, zero
; RV32IBB-NEXT:    ret
; RV32IBB-NEXT:  .LBB9_2:
; RV32IBB-NEXT:    clz a0, a1
; RV32IBB-NEXT:    mv a1, zero
; RV32IBB-NEXT:    ret
  %1 = call i64 @llvm.ctlz.i64(i64 %a, i1 false)
  ret i64 %1
}

declare i32 @llvm.cttz.i32(i32, i1)

define i32 @cttz_i32(i32 %a) nounwind {
; RV32I-LABEL: cttz_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    beqz a0, .LBB10_2
; RV32I-NEXT:  # %bb.1: # %cond.false
; RV32I-NEXT:    addi a1, a0, -1
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    j .LBB10_3
; RV32I-NEXT:  .LBB10_2:
; RV32I-NEXT:    addi a0, zero, 32
; RV32I-NEXT:  .LBB10_3: # %cond.end
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: cttz_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    ctz a0, a0
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: cttz_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    ctz a0, a0
; RV32IBB-NEXT:    ret
  %1 = call i32 @llvm.cttz.i32(i32 %a, i1 false)
  ret i32 %1
}

declare i64 @llvm.cttz.i64(i64, i1)

define i64 @cttz_i64(i64 %a) nounwind {
; RV32I-LABEL: cttz_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 20(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 16(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s3, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s4, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s5, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s6, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s3, a1
; RV32I-NEXT:    mv s4, a0
; RV32I-NEXT:    addi a0, a0, -1
; RV32I-NEXT:    not a1, s4
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi s5, a2, 1365
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi s0, a1, 819
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi s6, a1, -241
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi s1, a1, 257
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    addi a0, s3, -1
; RV32I-NEXT:    not a1, s3
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    and a1, a1, s5
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    and a0, a0, s6
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    bnez s4, .LBB11_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    addi a0, a0, 32
; RV32I-NEXT:    j .LBB11_3
; RV32I-NEXT:  .LBB11_2:
; RV32I-NEXT:    srli a0, s2, 24
; RV32I-NEXT:  .LBB11_3:
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    lw s6, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s5, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s4, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s3, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 16(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 20(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: cttz_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    ctz a2, a0
; RV32IB-NEXT:    ctz a1, a1
; RV32IB-NEXT:    addi a1, a1, 32
; RV32IB-NEXT:    cmov a0, a0, a2, a1
; RV32IB-NEXT:    mv a1, zero
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: cttz_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    bnez a0, .LBB11_2
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    ctz a0, a1
; RV32IBB-NEXT:    addi a0, a0, 32
; RV32IBB-NEXT:    mv a1, zero
; RV32IBB-NEXT:    ret
; RV32IBB-NEXT:  .LBB11_2:
; RV32IBB-NEXT:    ctz a0, a0
; RV32IBB-NEXT:    mv a1, zero
; RV32IBB-NEXT:    ret
  %1 = call i64 @llvm.cttz.i64(i64 %a, i1 false)
  ret i64 %1
}

declare i32 @llvm.ctpop.i32(i32)

define i32 @ctpop_i32(i32 %a) nounwind {
; RV32I-LABEL: ctpop_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    srli a1, a0, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi a2, a2, 1365
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi a1, a1, 819
; RV32I-NEXT:    and a2, a0, a1
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi a1, a1, -241
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi a1, a1, 257
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: ctpop_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    pcnt a0, a0
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: ctpop_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    pcnt a0, a0
; RV32IBB-NEXT:    ret
  %1 = call i32 @llvm.ctpop.i32(i32 %a)
  ret i32 %1
}

declare i64 @llvm.ctpop.i64(i64)

define i64 @ctpop_i64(i64 %a) nounwind {
; RV32I-LABEL: ctpop_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 20(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 16(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s3, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s4, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s5, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    srli a0, a1, 1
; RV32I-NEXT:    lui a2, 349525
; RV32I-NEXT:    addi s3, a2, 1365
; RV32I-NEXT:    and a0, a0, s3
; RV32I-NEXT:    sub a0, a1, a0
; RV32I-NEXT:    lui a1, 209715
; RV32I-NEXT:    addi s0, a1, 819
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 61681
; RV32I-NEXT:    addi s4, a1, -241
; RV32I-NEXT:    and a0, a0, s4
; RV32I-NEXT:    lui a1, 4112
; RV32I-NEXT:    addi s1, a1, 257
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli s5, a0, 24
; RV32I-NEXT:    srli a0, s2, 1
; RV32I-NEXT:    and a0, a0, s3
; RV32I-NEXT:    sub a0, s2, a0
; RV32I-NEXT:    and a1, a0, s0
; RV32I-NEXT:    srli a0, a0, 2
; RV32I-NEXT:    and a0, a0, s0
; RV32I-NEXT:    add a0, a1, a0
; RV32I-NEXT:    srli a1, a0, 4
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    and a0, a0, s4
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsi3@plt
; RV32I-NEXT:    srli a0, a0, 24
; RV32I-NEXT:    add a0, a0, s5
; RV32I-NEXT:    mv a1, zero
; RV32I-NEXT:    lw s5, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s4, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s3, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 16(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 20(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: ctpop_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    pcnt a1, a1
; RV32IB-NEXT:    pcnt a0, a0
; RV32IB-NEXT:    add a0, a0, a1
; RV32IB-NEXT:    mv a1, zero
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: ctpop_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    pcnt a1, a1
; RV32IBB-NEXT:    pcnt a0, a0
; RV32IBB-NEXT:    add a0, a0, a1
; RV32IBB-NEXT:    mv a1, zero
; RV32IBB-NEXT:    ret
  %1 = call i64 @llvm.ctpop.i64(i64 %a)
  ret i64 %1
}

define i32 @sextb_i32(i32 %a) nounwind {
; RV32I-LABEL: sextb_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sextb_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sext.b a0, a0
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sextb_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    sext.b a0, a0
; RV32IBB-NEXT:    ret
  %shl = shl i32 %a, 24
  %shr = ashr exact i32 %shl, 24
  ret i32 %shr
}

define i64 @sextb_i64(i64 %a) nounwind {
; RV32I-LABEL: sextb_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 24
; RV32I-NEXT:    srai a0, a1, 24
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sextb_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sext.b a0, a0
; RV32IB-NEXT:    srai a1, a0, 31
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sextb_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    sext.b a0, a0
; RV32IBB-NEXT:    srai a1, a0, 31
; RV32IBB-NEXT:    ret
  %shl = shl i64 %a, 56
  %shr = ashr exact i64 %shl, 56
  ret i64 %shr
}

define i32 @sexth_i32(i32 %a) nounwind {
; RV32I-LABEL: sexth_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 16
; RV32I-NEXT:    srai a0, a0, 16
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sexth_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sext.h a0, a0
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sexth_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    sext.h a0, a0
; RV32IBB-NEXT:    ret
  %shl = shl i32 %a, 16
  %shr = ashr exact i32 %shl, 16
  ret i32 %shr
}

define i64 @sexth_i64(i64 %a) nounwind {
; RV32I-LABEL: sexth_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 16
; RV32I-NEXT:    srai a0, a1, 16
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: sexth_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sext.h a0, a0
; RV32IB-NEXT:    srai a1, a0, 31
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: sexth_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    sext.h a0, a0
; RV32IBB-NEXT:    srai a1, a0, 31
; RV32IBB-NEXT:    ret
  %shl = shl i64 %a, 48
  %shr = ashr exact i64 %shl, 48
  ret i64 %shr
}

define i32 @min_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: min_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    blt a0, a1, .LBB18_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB18_2:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: min_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    min a0, a0, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: min_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    min a0, a0, a1
; RV32IBB-NEXT:    ret
  %cmp = icmp slt i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet any matching bit manipulation instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions suitable for this pattern.

define i64 @min_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: min_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a1, a3, .LBB19_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    slt a4, a1, a3
; RV32I-NEXT:    beqz a4, .LBB19_3
; RV32I-NEXT:    j .LBB19_4
; RV32I-NEXT:  .LBB19_2:
; RV32I-NEXT:    sltu a4, a0, a2
; RV32I-NEXT:    bnez a4, .LBB19_4
; RV32I-NEXT:  .LBB19_3:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    mv a1, a3
; RV32I-NEXT:  .LBB19_4:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: min_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    slt a4, a1, a3
; RV32IB-NEXT:    cmov a4, a4, a0, a2
; RV32IB-NEXT:    minu a0, a0, a2
; RV32IB-NEXT:    xor a2, a1, a3
; RV32IB-NEXT:    cmov a0, a2, a4, a0
; RV32IB-NEXT:    min a1, a1, a3
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: min_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    mv a4, a0
; RV32IBB-NEXT:    bge a1, a3, .LBB19_3
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    beq a1, a3, .LBB19_4
; RV32IBB-NEXT:  .LBB19_2:
; RV32IBB-NEXT:    min a1, a1, a3
; RV32IBB-NEXT:    ret
; RV32IBB-NEXT:  .LBB19_3:
; RV32IBB-NEXT:    mv a0, a2
; RV32IBB-NEXT:    bne a1, a3, .LBB19_2
; RV32IBB-NEXT:  .LBB19_4:
; RV32IBB-NEXT:    minu a0, a4, a2
; RV32IBB-NEXT:    min a1, a1, a3
; RV32IBB-NEXT:    ret
  %cmp = icmp slt i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

define i32 @max_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: max_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    blt a1, a0, .LBB20_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB20_2:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: max_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    max a0, a0, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: max_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    max a0, a0, a1
; RV32IBB-NEXT:    ret
  %cmp = icmp sgt i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet any matching bit manipulation instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions suitable for this pattern.

define i64 @max_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: max_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a1, a3, .LBB21_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    slt a4, a3, a1
; RV32I-NEXT:    beqz a4, .LBB21_3
; RV32I-NEXT:    j .LBB21_4
; RV32I-NEXT:  .LBB21_2:
; RV32I-NEXT:    sltu a4, a2, a0
; RV32I-NEXT:    bnez a4, .LBB21_4
; RV32I-NEXT:  .LBB21_3:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    mv a1, a3
; RV32I-NEXT:  .LBB21_4:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: max_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    slt a4, a3, a1
; RV32IB-NEXT:    cmov a4, a4, a0, a2
; RV32IB-NEXT:    maxu a0, a0, a2
; RV32IB-NEXT:    xor a2, a1, a3
; RV32IB-NEXT:    cmov a0, a2, a4, a0
; RV32IB-NEXT:    max a1, a1, a3
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: max_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    mv a4, a0
; RV32IBB-NEXT:    bge a3, a1, .LBB21_3
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    beq a1, a3, .LBB21_4
; RV32IBB-NEXT:  .LBB21_2:
; RV32IBB-NEXT:    max a1, a1, a3
; RV32IBB-NEXT:    ret
; RV32IBB-NEXT:  .LBB21_3:
; RV32IBB-NEXT:    mv a0, a2
; RV32IBB-NEXT:    bne a1, a3, .LBB21_2
; RV32IBB-NEXT:  .LBB21_4:
; RV32IBB-NEXT:    maxu a0, a4, a2
; RV32IBB-NEXT:    max a1, a1, a3
; RV32IBB-NEXT:    ret
  %cmp = icmp sgt i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

define i32 @minu_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: minu_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bltu a0, a1, .LBB22_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB22_2:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: minu_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    minu a0, a0, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: minu_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    minu a0, a0, a1
; RV32IBB-NEXT:    ret
  %cmp = icmp ult i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet any matching bit manipulation instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions suitable for this pattern.

define i64 @minu_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: minu_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a1, a3, .LBB23_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a4, a1, a3
; RV32I-NEXT:    beqz a4, .LBB23_3
; RV32I-NEXT:    j .LBB23_4
; RV32I-NEXT:  .LBB23_2:
; RV32I-NEXT:    sltu a4, a0, a2
; RV32I-NEXT:    bnez a4, .LBB23_4
; RV32I-NEXT:  .LBB23_3:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    mv a1, a3
; RV32I-NEXT:  .LBB23_4:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: minu_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sltu a4, a1, a3
; RV32IB-NEXT:    cmov a4, a4, a0, a2
; RV32IB-NEXT:    minu a0, a0, a2
; RV32IB-NEXT:    xor a2, a1, a3
; RV32IB-NEXT:    cmov a0, a2, a4, a0
; RV32IB-NEXT:    minu a1, a1, a3
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: minu_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    mv a4, a0
; RV32IBB-NEXT:    bgeu a1, a3, .LBB23_3
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    beq a1, a3, .LBB23_4
; RV32IBB-NEXT:  .LBB23_2:
; RV32IBB-NEXT:    minu a1, a1, a3
; RV32IBB-NEXT:    ret
; RV32IBB-NEXT:  .LBB23_3:
; RV32IBB-NEXT:    mv a0, a2
; RV32IBB-NEXT:    bne a1, a3, .LBB23_2
; RV32IBB-NEXT:  .LBB23_4:
; RV32IBB-NEXT:    minu a0, a4, a2
; RV32IBB-NEXT:    minu a1, a1, a3
; RV32IBB-NEXT:    ret
  %cmp = icmp ult i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

define i32 @maxu_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: maxu_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bltu a1, a0, .LBB24_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB24_2:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: maxu_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    maxu a0, a0, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: maxu_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    maxu a0, a0, a1
; RV32IBB-NEXT:    ret
  %cmp = icmp ugt i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet any matching bit manipulation instructions on RV32.
; This test is presented here in case future expansions of the experimental-b
; extension introduce instructions suitable for this pattern.

define i64 @maxu_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: maxu_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a1, a3, .LBB25_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a4, a3, a1
; RV32I-NEXT:    beqz a4, .LBB25_3
; RV32I-NEXT:    j .LBB25_4
; RV32I-NEXT:  .LBB25_2:
; RV32I-NEXT:    sltu a4, a2, a0
; RV32I-NEXT:    bnez a4, .LBB25_4
; RV32I-NEXT:  .LBB25_3:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    mv a1, a3
; RV32I-NEXT:  .LBB25_4:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: maxu_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    sltu a4, a3, a1
; RV32IB-NEXT:    cmov a4, a4, a0, a2
; RV32IB-NEXT:    maxu a0, a0, a2
; RV32IB-NEXT:    xor a2, a1, a3
; RV32IB-NEXT:    cmov a0, a2, a4, a0
; RV32IB-NEXT:    maxu a1, a1, a3
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: maxu_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    mv a4, a0
; RV32IBB-NEXT:    bgeu a3, a1, .LBB25_3
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    beq a1, a3, .LBB25_4
; RV32IBB-NEXT:  .LBB25_2:
; RV32IBB-NEXT:    maxu a1, a1, a3
; RV32IBB-NEXT:    ret
; RV32IBB-NEXT:  .LBB25_3:
; RV32IBB-NEXT:    mv a0, a2
; RV32IBB-NEXT:    bne a1, a3, .LBB25_2
; RV32IBB-NEXT:  .LBB25_4:
; RV32IBB-NEXT:    maxu a0, a4, a2
; RV32IBB-NEXT:    maxu a1, a1, a3
; RV32IBB-NEXT:    ret
  %cmp = icmp ugt i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

declare i32 @llvm.abs.i32(i32, i1 immarg)

define i32 @abs_i32(i32 %x) {
; RV32I-LABEL: abs_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: abs_i32:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    neg a1, a0
; RV32IB-NEXT:    max a0, a0, a1
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: abs_i32:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    neg a1, a0
; RV32IBB-NEXT:    max a0, a0, a1
; RV32IBB-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %abs
}

declare i64 @llvm.abs.i64(i64, i1 immarg)

define i64 @abs_i64(i64 %x) {
; RV32I-LABEL: abs_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bgez a1, .LBB27_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    snez a2, a0
; RV32I-NEXT:    neg a0, a0
; RV32I-NEXT:    add a1, a1, a2
; RV32I-NEXT:    neg a1, a1
; RV32I-NEXT:  .LBB27_2:
; RV32I-NEXT:    ret
;
; RV32IB-LABEL: abs_i64:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    neg a2, a0
; RV32IB-NEXT:    slti a3, a1, 0
; RV32IB-NEXT:    cmov a2, a3, a2, a0
; RV32IB-NEXT:    snez a0, a0
; RV32IB-NEXT:    add a0, a1, a0
; RV32IB-NEXT:    neg a0, a0
; RV32IB-NEXT:    cmov a1, a3, a0, a1
; RV32IB-NEXT:    mv a0, a2
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: abs_i64:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    bgez a1, .LBB27_2
; RV32IBB-NEXT:  # %bb.1:
; RV32IBB-NEXT:    snez a2, a0
; RV32IBB-NEXT:    neg a0, a0
; RV32IBB-NEXT:    add a1, a1, a2
; RV32IBB-NEXT:    neg a1, a1
; RV32IBB-NEXT:  .LBB27_2:
; RV32IBB-NEXT:    ret
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 true)
  ret i64 %abs
}
