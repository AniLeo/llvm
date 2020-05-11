; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s
; RUN: llc -mtriple=riscv64 -mattr=+f,+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IFD %s

;; This tests how good we are at materialising constants using `select`. The aim
;; is that we do so without a branch if possible (at the moment our lowering of
;; select always introduces a branch).
;;
;; Currently the hook `convertSelectOfConstantsToMath` only is useful when the
;; constants are either 1 away from each other, or one is a power of two and
;; the other is zero.

define signext i32 @select_const_int_easy(i1 zeroext %a) nounwind {
; RV32I-LABEL: select_const_int_easy:
; RV32I:       # %bb.0:
; RV32I-NEXT:    ret
;
; RV32IF-LABEL: select_const_int_easy:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    ret
;
; RV64I-LABEL: select_const_int_easy:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ret
;
; RV64IFD-LABEL: select_const_int_easy:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    ret
  %1 = select i1 %a, i32 1, i32 0
  ret i32 %1
}

define signext i32 @select_const_int_one_away(i1 zeroext %a) nounwind {
; RV32I-LABEL: select_const_int_one_away:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a1, zero, 4
; RV32I-NEXT:    sub a0, a1, a0
; RV32I-NEXT:    ret
;
; RV32IF-LABEL: select_const_int_one_away:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi a1, zero, 4
; RV32IF-NEXT:    sub a0, a1, a0
; RV32IF-NEXT:    ret
;
; RV64I-LABEL: select_const_int_one_away:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 4
; RV64I-NEXT:    sub a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IFD-LABEL: select_const_int_one_away:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi a1, zero, 4
; RV64IFD-NEXT:    sub a0, a1, a0
; RV64IFD-NEXT:    ret
  %1 = select i1 %a, i32 3, i32 4
  ret i32 %1
}

define signext i32 @select_const_int_pow2_zero(i1 zeroext %a) nounwind {
; RV32I-LABEL: select_const_int_pow2_zero:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 2
; RV32I-NEXT:    ret
;
; RV32IF-LABEL: select_const_int_pow2_zero:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    slli a0, a0, 2
; RV32IF-NEXT:    ret
;
; RV64I-LABEL: select_const_int_pow2_zero:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    ret
;
; RV64IFD-LABEL: select_const_int_pow2_zero:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    slli a0, a0, 2
; RV64IFD-NEXT:    ret
  %1 = select i1 %a, i32 4, i32 0
  ret i32 %1
}

define signext i32 @select_const_int_harder(i1 zeroext %a) nounwind {
; RV32I-LABEL: select_const_int_harder:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    addi a0, zero, 6
; RV32I-NEXT:    bnez a1, .LBB3_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    addi a0, zero, 38
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    ret
;
; RV32IF-LABEL: select_const_int_harder:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    mv a1, a0
; RV32IF-NEXT:    addi a0, zero, 6
; RV32IF-NEXT:    bnez a1, .LBB3_2
; RV32IF-NEXT:  # %bb.1:
; RV32IF-NEXT:    addi a0, zero, 38
; RV32IF-NEXT:  .LBB3_2:
; RV32IF-NEXT:    ret
;
; RV64I-LABEL: select_const_int_harder:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    addi a0, zero, 6
; RV64I-NEXT:    bnez a1, .LBB3_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    addi a0, zero, 38
; RV64I-NEXT:  .LBB3_2:
; RV64I-NEXT:    ret
;
; RV64IFD-LABEL: select_const_int_harder:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    mv a1, a0
; RV64IFD-NEXT:    addi a0, zero, 6
; RV64IFD-NEXT:    bnez a1, .LBB3_2
; RV64IFD-NEXT:  # %bb.1:
; RV64IFD-NEXT:    addi a0, zero, 38
; RV64IFD-NEXT:  .LBB3_2:
; RV64IFD-NEXT:    ret
  %1 = select i1 %a, i32 6, i32 38
  ret i32 %1
}

define float @select_const_fp(i1 zeroext %a) nounwind {
; RV32I-LABEL: select_const_fp:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    lui a0, 263168
; RV32I-NEXT:    bnez a1, .LBB4_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    lui a0, 264192
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    ret
;
; RV32IF-LABEL: select_const_fp:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    bnez a0, .LBB4_2
; RV32IF-NEXT:  # %bb.1:
; RV32IF-NEXT:    lui a0, %hi(.LCPI4_0)
; RV32IF-NEXT:    flw ft0, %lo(.LCPI4_0)(a0)
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
; RV32IF-NEXT:  .LBB4_2:
; RV32IF-NEXT:    lui a0, %hi(.LCPI4_1)
; RV32IF-NEXT:    flw ft0, %lo(.LCPI4_1)(a0)
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64I-LABEL: select_const_fp:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    lui a0, 263168
; RV64I-NEXT:    bnez a1, .LBB4_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    lui a0, 264192
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    ret
;
; RV64IFD-LABEL: select_const_fp:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    bnez a0, .LBB4_2
; RV64IFD-NEXT:  # %bb.1:
; RV64IFD-NEXT:    lui a0, %hi(.LCPI4_0)
; RV64IFD-NEXT:    flw ft0, %lo(.LCPI4_0)(a0)
; RV64IFD-NEXT:    fmv.x.w a0, ft0
; RV64IFD-NEXT:    ret
; RV64IFD-NEXT:  .LBB4_2:
; RV64IFD-NEXT:    lui a0, %hi(.LCPI4_1)
; RV64IFD-NEXT:    flw ft0, %lo(.LCPI4_1)(a0)
; RV64IFD-NEXT:    fmv.x.w a0, ft0
; RV64IFD-NEXT:    ret
  %1 = select i1 %a, float 3.0, float 4.0
  ret float %1
}
