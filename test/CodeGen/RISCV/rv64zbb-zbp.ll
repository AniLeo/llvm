; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zbb -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBB
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zbp -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBP

define signext i32 @andn_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: andn_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: andn_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    andn a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: andn_i32:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    andn a0, a0, a1
; RV64ZBP-NEXT:    ret
  %neg = xor i32 %b, -1
  %and = and i32 %neg, %a
  ret i32 %and
}

define i64 @andn_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: andn_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: andn_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    andn a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: andn_i64:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    andn a0, a0, a1
; RV64ZBP-NEXT:    ret
  %neg = xor i64 %b, -1
  %and = and i64 %neg, %a
  ret i64 %and
}

define signext i32 @orn_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: orn_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: orn_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    orn a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: orn_i32:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    orn a0, a0, a1
; RV64ZBP-NEXT:    ret
  %neg = xor i32 %b, -1
  %or = or i32 %neg, %a
  ret i32 %or
}

define i64 @orn_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: orn_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: orn_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    orn a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: orn_i64:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    orn a0, a0, a1
; RV64ZBP-NEXT:    ret
  %neg = xor i64 %b, -1
  %or = or i64 %neg, %a
  ret i64 %or
}

define signext i32 @xnor_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: xnor_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: xnor_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    xnor a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: xnor_i32:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    xnor a0, a0, a1
; RV64ZBP-NEXT:    ret
  %neg = xor i32 %a, -1
  %xor = xor i32 %neg, %b
  ret i32 %xor
}

define i64 @xnor_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: xnor_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: xnor_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    xnor a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: xnor_i64:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    xnor a0, a0, a1
; RV64ZBP-NEXT:    ret
  %neg = xor i64 %a, -1
  %xor = xor i64 %neg, %b
  ret i64 %xor
}

declare i32 @llvm.fshl.i32(i32, i32, i32)

define signext i32 @rol_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: rol_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sllw a2, a0, a1
; RV64I-NEXT:    negw a1, a1
; RV64I-NEXT:    srlw a0, a0, a1
; RV64I-NEXT:    or a0, a2, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rol_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rolw a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rol_i32:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    rolw a0, a0, a1
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %a, i32 %b)
  ret i32 %1
}

; Similar to rol_i32, but doesn't sign extend the result.
define void @rol_i32_nosext(i32 signext %a, i32 signext %b, i32* %x) nounwind {
; RV64I-LABEL: rol_i32_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sllw a3, a0, a1
; RV64I-NEXT:    negw a1, a1
; RV64I-NEXT:    srlw a0, a0, a1
; RV64I-NEXT:    or a0, a3, a0
; RV64I-NEXT:    sw a0, 0(a2)
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rol_i32_nosext:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rolw a0, a0, a1
; RV64ZBB-NEXT:    sw a0, 0(a2)
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rol_i32_nosext:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    rolw a0, a0, a1
; RV64ZBP-NEXT:    sw a0, 0(a2)
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %a, i32 %b)
  store i32 %1, i32* %x
  ret void
}

define signext i32 @rol_i32_neg_constant_rhs(i32 signext %a) nounwind {
; RV64I-LABEL: rol_i32_neg_constant_rhs:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a1, -2
; RV64I-NEXT:    sllw a2, a1, a0
; RV64I-NEXT:    negw a0, a0
; RV64I-NEXT:    srlw a0, a1, a0
; RV64I-NEXT:    or a0, a2, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rol_i32_neg_constant_rhs:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    li a1, -2
; RV64ZBB-NEXT:    rolw a0, a1, a0
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rol_i32_neg_constant_rhs:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    li a1, -2
; RV64ZBP-NEXT:    rolw a0, a1, a0
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 -2, i32 -2, i32 %a)
  ret i32 %1
}

declare i64 @llvm.fshl.i64(i64, i64, i64)

define i64 @rol_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: rol_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sll a2, a0, a1
; RV64I-NEXT:    neg a1, a1
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    or a0, a2, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rol_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rol a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rol_i64:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    rol a0, a0, a1
; RV64ZBP-NEXT:    ret
  %or = tail call i64 @llvm.fshl.i64(i64 %a, i64 %a, i64 %b)
  ret i64 %or
}

declare i32 @llvm.fshr.i32(i32, i32, i32)

define signext i32 @ror_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: ror_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srlw a2, a0, a1
; RV64I-NEXT:    negw a1, a1
; RV64I-NEXT:    sllw a0, a0, a1
; RV64I-NEXT:    or a0, a2, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ror_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rorw a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: ror_i32:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    rorw a0, a0, a1
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %a, i32 %b)
  ret i32 %1
}

; Similar to ror_i32, but doesn't sign extend the result.
define void @ror_i32_nosext(i32 signext %a, i32 signext %b, i32* %x) nounwind {
; RV64I-LABEL: ror_i32_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srlw a3, a0, a1
; RV64I-NEXT:    negw a1, a1
; RV64I-NEXT:    sllw a0, a0, a1
; RV64I-NEXT:    or a0, a3, a0
; RV64I-NEXT:    sw a0, 0(a2)
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ror_i32_nosext:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rorw a0, a0, a1
; RV64ZBB-NEXT:    sw a0, 0(a2)
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: ror_i32_nosext:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    rorw a0, a0, a1
; RV64ZBP-NEXT:    sw a0, 0(a2)
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %a, i32 %b)
  store i32 %1, i32* %x
  ret void
}

define signext i32 @ror_i32_neg_constant_rhs(i32 signext %a) nounwind {
; RV64I-LABEL: ror_i32_neg_constant_rhs:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a1, -2
; RV64I-NEXT:    srlw a2, a1, a0
; RV64I-NEXT:    negw a0, a0
; RV64I-NEXT:    sllw a0, a1, a0
; RV64I-NEXT:    or a0, a2, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ror_i32_neg_constant_rhs:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    li a1, -2
; RV64ZBB-NEXT:    rorw a0, a1, a0
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: ror_i32_neg_constant_rhs:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    li a1, -2
; RV64ZBP-NEXT:    rorw a0, a1, a0
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 -2, i32 -2, i32 %a)
  ret i32 %1
}

declare i64 @llvm.fshr.i64(i64, i64, i64)

define i64 @ror_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: ror_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srl a2, a0, a1
; RV64I-NEXT:    neg a1, a1
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    or a0, a2, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ror_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    ror a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: ror_i64:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    ror a0, a0, a1
; RV64ZBP-NEXT:    ret
  %or = tail call i64 @llvm.fshr.i64(i64 %a, i64 %a, i64 %b)
  ret i64 %or
}

define signext i32 @rori_i32_fshl(i32 signext %a) nounwind {
; RV64I-LABEL: rori_i32_fshl:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a0, 1
; RV64I-NEXT:    slliw a0, a0, 31
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rori_i32_fshl:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    roriw a0, a0, 1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rori_i32_fshl:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    roriw a0, a0, 1
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %a, i32 31)
  ret i32 %1
}

; Similar to rori_i32_fshl, but doesn't sign extend the result.
define void @rori_i32_fshl_nosext(i32 signext %a, i32* %x) nounwind {
; RV64I-LABEL: rori_i32_fshl_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a2, a0, 1
; RV64I-NEXT:    slli a0, a0, 31
; RV64I-NEXT:    or a0, a0, a2
; RV64I-NEXT:    sw a0, 0(a1)
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rori_i32_fshl_nosext:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    roriw a0, a0, 1
; RV64ZBB-NEXT:    sw a0, 0(a1)
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rori_i32_fshl_nosext:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    roriw a0, a0, 1
; RV64ZBP-NEXT:    sw a0, 0(a1)
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %a, i32 31)
  store i32 %1, i32* %x
  ret void
}

define signext i32 @rori_i32_fshr(i32 signext %a) nounwind {
; RV64I-LABEL: rori_i32_fshr:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slliw a1, a0, 1
; RV64I-NEXT:    srliw a0, a0, 31
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rori_i32_fshr:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    roriw a0, a0, 31
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rori_i32_fshr:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    roriw a0, a0, 31
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %a, i32 31)
  ret i32 %1
}

; Similar to rori_i32_fshr, but doesn't sign extend the result.
define void @rori_i32_fshr_nosext(i32 signext %a, i32* %x) nounwind {
; RV64I-LABEL: rori_i32_fshr_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a2, a0, 1
; RV64I-NEXT:    srliw a0, a0, 31
; RV64I-NEXT:    or a0, a0, a2
; RV64I-NEXT:    sw a0, 0(a1)
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rori_i32_fshr_nosext:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    roriw a0, a0, 31
; RV64ZBB-NEXT:    sw a0, 0(a1)
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rori_i32_fshr_nosext:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    roriw a0, a0, 31
; RV64ZBP-NEXT:    sw a0, 0(a1)
; RV64ZBP-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %a, i32 31)
  store i32 %1, i32* %x
  ret void
}

; This test is similar to the type legalized version of the fshl/fshr tests, but
; instead of having the same input to both shifts it has different inputs. Make
; sure we don't match it as a roriw.
define signext i32 @not_rori_i32(i32 signext %x, i32 signext %y) nounwind {
; RV64I-LABEL: not_rori_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slliw a0, a0, 31
; RV64I-NEXT:    srliw a1, a1, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: not_rori_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    slliw a0, a0, 31
; RV64ZBB-NEXT:    srliw a1, a1, 1
; RV64ZBB-NEXT:    or a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: not_rori_i32:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    slliw a0, a0, 31
; RV64ZBP-NEXT:    srliw a1, a1, 1
; RV64ZBP-NEXT:    or a0, a0, a1
; RV64ZBP-NEXT:    ret
  %a = shl i32 %x, 31
  %b = lshr i32 %y, 1
  %c = or i32 %a, %b
  ret i32 %c
}

; This is similar to the type legalized roriw pattern, but the and mask is more
; than 32 bits so the lshr doesn't shift zeroes into the lower 32 bits. Make
; sure we don't match it to roriw.
define i64 @roriw_bug(i64 %x) nounwind {
; RV64I-LABEL: roriw_bug:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 31
; RV64I-NEXT:    andi a0, a0, -2
; RV64I-NEXT:    srli a2, a0, 1
; RV64I-NEXT:    or a1, a1, a2
; RV64I-NEXT:    sext.w a1, a1
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: roriw_bug:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    slli a1, a0, 31
; RV64ZBB-NEXT:    andi a0, a0, -2
; RV64ZBB-NEXT:    srli a2, a0, 1
; RV64ZBB-NEXT:    or a1, a1, a2
; RV64ZBB-NEXT:    sext.w a1, a1
; RV64ZBB-NEXT:    xor a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: roriw_bug:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    slli a1, a0, 31
; RV64ZBP-NEXT:    andi a0, a0, -2
; RV64ZBP-NEXT:    srli a2, a0, 1
; RV64ZBP-NEXT:    or a1, a1, a2
; RV64ZBP-NEXT:    sext.w a1, a1
; RV64ZBP-NEXT:    xor a0, a0, a1
; RV64ZBP-NEXT:    ret
  %a = shl i64 %x, 31
  %b = and i64 %x, 18446744073709551614
  %c = lshr i64 %b, 1
  %d = or i64 %a, %c
  %e = shl i64 %d, 32
  %f = ashr i64 %e, 32
  %g = xor i64 %b, %f ; to increase the use count on %b to disable SimplifyDemandedBits.
  ret i64 %g
}

define i64 @rori_i64_fshl(i64 %a) nounwind {
; RV64I-LABEL: rori_i64_fshl:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    slli a0, a0, 63
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rori_i64_fshl:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rori a0, a0, 1
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rori_i64_fshl:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    rori a0, a0, 1
; RV64ZBP-NEXT:    ret
  %1 = tail call i64 @llvm.fshl.i64(i64 %a, i64 %a, i64 63)
  ret i64 %1
}

define i64 @rori_i64_fshr(i64 %a) nounwind {
; RV64I-LABEL: rori_i64_fshr:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 1
; RV64I-NEXT:    srli a0, a0, 63
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: rori_i64_fshr:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rori a0, a0, 63
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: rori_i64_fshr:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    rori a0, a0, 63
; RV64ZBP-NEXT:    ret
  %1 = tail call i64 @llvm.fshr.i64(i64 %a, i64 %a, i64 63)
  ret i64 %1
}

define i8 @srli_i8(i8 %a) nounwind {
; RV64I-LABEL: srli_i8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, 192
; RV64I-NEXT:    srli a0, a0, 6
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: srli_i8:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    andi a0, a0, 192
; RV64ZBB-NEXT:    srli a0, a0, 6
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: srli_i8:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    andi a0, a0, 192
; RV64ZBP-NEXT:    srli a0, a0, 6
; RV64ZBP-NEXT:    ret
  %1 = lshr i8 %a, 6
  ret i8 %1
}

define i8 @srai_i8(i8 %a) nounwind {
; RV64I-LABEL: srai_i8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 61
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: srai_i8:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.b a0, a0
; RV64ZBB-NEXT:    srai a0, a0, 5
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: srai_i8:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    slli a0, a0, 56
; RV64ZBP-NEXT:    srai a0, a0, 61
; RV64ZBP-NEXT:    ret
  %1 = ashr i8 %a, 5
  ret i8 %1
}

define i16 @srli_i16(i16 %a) nounwind {
; RV64I-LABEL: srli_i16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srli a0, a0, 54
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: srli_i16:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    zext.h a0, a0
; RV64ZBB-NEXT:    srli a0, a0, 6
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: srli_i16:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    zext.h a0, a0
; RV64ZBP-NEXT:    srli a0, a0, 6
; RV64ZBP-NEXT:    ret
  %1 = lshr i16 %a, 6
  ret i16 %1
}

define i16 @srai_i16(i16 %a) nounwind {
; RV64I-LABEL: srai_i16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srai a0, a0, 57
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: srai_i16:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.h a0, a0
; RV64ZBB-NEXT:    srai a0, a0, 9
; RV64ZBB-NEXT:    ret
;
; RV64ZBP-LABEL: srai_i16:
; RV64ZBP:       # %bb.0:
; RV64ZBP-NEXT:    slli a0, a0, 48
; RV64ZBP-NEXT:    srai a0, a0, 57
; RV64ZBP-NEXT:    ret
  %1 = ashr i16 %a, 9
  ret i16 %1
}
