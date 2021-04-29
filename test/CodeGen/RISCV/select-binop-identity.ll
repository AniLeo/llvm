; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

; InstCombine canonicalizes (c ? x | y : x) to (x | (c ? y : 0)) similar for
; other binary operations using their identity value as the constant.

; We can reverse this for and/or/xor. Allowing us to pull the binop into
; the basic block we create when we expand select.

define signext i32 @and_select_all_ones_i32(i1 zeroext %c, i32 signext %x, i32 %y) {
; RV32I-LABEL: and_select_all_ones_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beqz a0, .LBB0_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    and a2, a2, a1
; RV32I-NEXT:  .LBB0_2:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: and_select_all_ones_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB0_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    and a2, a2, a1
; RV64I-NEXT:  .LBB0_2:
; RV64I-NEXT:    sext.w a0, a2
; RV64I-NEXT:    ret
  %a = select i1 %c, i32 %x, i32 -1
  %b = and i32 %a, %y
  ret i32 %b
}

define i64 @and_select_all_ones_i64(i1 zeroext %c, i64 %x, i64 %y) {
; RV32I-LABEL: and_select_all_ones_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bnez a0, .LBB1_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    and a3, a3, a1
; RV32I-NEXT:    and a4, a4, a2
; RV32I-NEXT:  .LBB1_2:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:    mv a1, a4
; RV32I-NEXT:    ret
;
; RV64I-LABEL: and_select_all_ones_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bnez a0, .LBB1_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    and a2, a2, a1
; RV64I-NEXT:  .LBB1_2:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    ret
  %a = select i1 %c, i64 -1, i64 %x
  %b = and i64 %y, %a
  ret i64 %b
}

define signext i32 @or_select_all_zeros_i32(i1 zeroext %c, i32 signext %x, i32 signext %y) {
; RV32I-LABEL: or_select_all_zeros_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beqz a0, .LBB2_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    or a2, a2, a1
; RV32I-NEXT:  .LBB2_2:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: or_select_all_zeros_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB2_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    or a2, a2, a1
; RV64I-NEXT:  .LBB2_2:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    ret
  %a = select i1 %c, i32 %x, i32 0
  %b = or i32 %y, %a
  ret i32 %b
}

define i64 @or_select_all_zeros_i64(i1 zeroext %c, i64 %x, i64 %y) {
; RV32I-LABEL: or_select_all_zeros_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bnez a0, .LBB3_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    or a3, a3, a1
; RV32I-NEXT:    or a4, a4, a2
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:    mv a1, a4
; RV32I-NEXT:    ret
;
; RV64I-LABEL: or_select_all_zeros_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bnez a0, .LBB3_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    or a2, a2, a1
; RV64I-NEXT:  .LBB3_2:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    ret
  %a = select i1 %c, i64 0, i64 %x
  %b = or i64 %a, %y
  ret i64 %b
}

define signext i32 @xor_select_all_zeros_i32(i1 zeroext %c, i32 signext %x, i32 signext %y) {
; RV32I-LABEL: xor_select_all_zeros_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bnez a0, .LBB4_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    xor a2, a2, a1
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: xor_select_all_zeros_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bnez a0, .LBB4_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    xor a2, a2, a1
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    ret
  %a = select i1 %c, i32 0, i32 %x
  %b = xor i32 %y, %a
  ret i32 %b
}

define i64 @xor_select_all_zeros_i64(i1 zeroext %c, i64 %x, i64 %y) {
; RV32I-LABEL: xor_select_all_zeros_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beqz a0, .LBB5_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    xor a3, a3, a1
; RV32I-NEXT:    xor a4, a4, a2
; RV32I-NEXT:  .LBB5_2:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:    mv a1, a4
; RV32I-NEXT:    ret
;
; RV64I-LABEL: xor_select_all_zeros_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB5_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    xor a2, a2, a1
; RV64I-NEXT:  .LBB5_2:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    ret
  %a = select i1 %c, i64 %x, i64 0
  %b = xor i64 %a, %y
  ret i64 %b
}
