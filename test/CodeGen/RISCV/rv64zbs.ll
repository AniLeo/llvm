; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+experimental-b -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IB
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zbs -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IBS

define signext i32 @sbclr_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbclr_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclr_i32:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    andn a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclr_i32:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    not a1, a1
; RV64IBS-NEXT:    and a0, a1, a0
; RV64IBS-NEXT:    ret
  %and = and i32 %b, 31
  %shl = shl nuw i32 1, %and
  %neg = xor i32 %shl, -1
  %and1 = and i32 %neg, %a
  ret i32 %and1
}

define signext i32 @sbclr_i32_no_mask(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbclr_i32_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclr_i32_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    andn a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclr_i32_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    not a1, a1
; RV64IBS-NEXT:    and a0, a1, a0
; RV64IBS-NEXT:    ret
  %shl = shl i32 1, %b
  %neg = xor i32 %shl, -1
  %and1 = and i32 %neg, %a
  ret i32 %and1
}

define signext i32 @sbclr_i32_load(i32* %p, i32 signext %b) nounwind {
; RV64I-LABEL: sbclr_i32_load:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclr_i32_load:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lw a0, 0(a0)
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    andn a0, a0, a1
; RV64IB-NEXT:    sext.w a0, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclr_i32_load:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lw a0, 0(a0)
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    not a1, a1
; RV64IBS-NEXT:    and a0, a1, a0
; RV64IBS-NEXT:    sext.w a0, a0
; RV64IBS-NEXT:    ret
  %a = load i32, i32* %p
  %shl = shl i32 1, %b
  %neg = xor i32 %shl, -1
  %and1 = and i32 %neg, %a
  ret i32 %and1
}

define i64 @sbclr_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbclr_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sll a1, a2, a1
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclr_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclr a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclr_i64:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclr a0, a0, a1
; RV64IBS-NEXT:    ret
  %and = and i64 %b, 63
  %shl = shl nuw i64 1, %and
  %neg = xor i64 %shl, -1
  %and1 = and i64 %neg, %a
  ret i64 %and1
}

define i64 @sbclr_i64_no_mask(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbclr_i64_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sll a1, a2, a1
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclr_i64_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclr a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclr_i64_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclr a0, a0, a1
; RV64IBS-NEXT:    ret
  %shl = shl i64 1, %b
  %neg = xor i64 %shl, -1
  %and1 = and i64 %neg, %a
  ret i64 %and1
}

define signext i32 @sbset_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbset_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbset_i32:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    or a0, a1, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbset_i32:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    or a0, a1, a0
; RV64IBS-NEXT:    ret
  %and = and i32 %b, 31
  %shl = shl nuw i32 1, %and
  %or = or i32 %shl, %a
  ret i32 %or
}

define signext i32 @sbset_i32_no_mask(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbset_i32_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbset_i32_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    or a0, a1, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbset_i32_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    or a0, a1, a0
; RV64IBS-NEXT:    ret
  %shl = shl i32 1, %b
  %or = or i32 %shl, %a
  ret i32 %or
}

define signext i32 @sbset_i32_load(i32* %p, i32 signext %b) nounwind {
; RV64I-LABEL: sbset_i32_load:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbset_i32_load:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lw a0, 0(a0)
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    or a0, a1, a0
; RV64IB-NEXT:    sext.w a0, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbset_i32_load:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lw a0, 0(a0)
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    or a0, a1, a0
; RV64IBS-NEXT:    sext.w a0, a0
; RV64IBS-NEXT:    ret
  %a = load i32, i32* %p
  %shl = shl i32 1, %b
  %or = or i32 %shl, %a
  ret i32 %or
}

; We can use sbsetw for 1 << x by setting the first source to zero.
define signext i32 @sbset_i32_zero(i32 signext %a) nounwind {
; RV64I-LABEL: sbset_i32_zero:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    sllw a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbset_i32_zero:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a1, zero, 1
; RV64IB-NEXT:    sllw a0, a1, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbset_i32_zero:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    addi a1, zero, 1
; RV64IBS-NEXT:    sllw a0, a1, a0
; RV64IBS-NEXT:    ret
  %shl = shl i32 1, %a
  ret i32 %shl
}

define i64 @sbset_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbset_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sll a1, a2, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbset_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bset a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbset_i64:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bset a0, a0, a1
; RV64IBS-NEXT:    ret
  %conv = and i64 %b, 63
  %shl = shl nuw i64 1, %conv
  %or = or i64 %shl, %a
  ret i64 %or
}

define i64 @sbset_i64_no_mask(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbset_i64_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sll a1, a2, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbset_i64_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bset a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbset_i64_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bset a0, a0, a1
; RV64IBS-NEXT:    ret
  %shl = shl i64 1, %b
  %or = or i64 %shl, %a
  ret i64 %or
}

; We can use sbsetw for 1 << x by setting the first source to zero.
define signext i64 @sbset_i64_zero(i64 signext %a) nounwind {
; RV64I-LABEL: sbset_i64_zero:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    sll a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbset_i64_zero:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bset a0, zero, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbset_i64_zero:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bset a0, zero, a0
; RV64IBS-NEXT:    ret
  %shl = shl i64 1, %a
  ret i64 %shl
}

define signext i32 @sbinv_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbinv_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    xor a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinv_i32:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    xor a0, a1, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinv_i32:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    xor a0, a1, a0
; RV64IBS-NEXT:    ret
  %and = and i32 %b, 31
  %shl = shl nuw i32 1, %and
  %xor = xor i32 %shl, %a
  ret i32 %xor
}

define signext i32 @sbinv_i32_no_mask(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbinv_i32_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    xor a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinv_i32_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    xor a0, a1, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinv_i32_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    xor a0, a1, a0
; RV64IBS-NEXT:    ret
  %shl = shl i32 1, %b
  %xor = xor i32 %shl, %a
  ret i32 %xor
}

define signext i32 @sbinv_i32_load(i32* %p, i32 signext %b) nounwind {
; RV64I-LABEL: sbinv_i32_load:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    xor a0, a1, a0
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinv_i32_load:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lw a0, 0(a0)
; RV64IB-NEXT:    addi a2, zero, 1
; RV64IB-NEXT:    sllw a1, a2, a1
; RV64IB-NEXT:    xor a0, a1, a0
; RV64IB-NEXT:    sext.w a0, a0
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinv_i32_load:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lw a0, 0(a0)
; RV64IBS-NEXT:    addi a2, zero, 1
; RV64IBS-NEXT:    sllw a1, a2, a1
; RV64IBS-NEXT:    xor a0, a1, a0
; RV64IBS-NEXT:    sext.w a0, a0
; RV64IBS-NEXT:    ret
  %a = load i32, i32* %p
  %shl = shl i32 1, %b
  %xor = xor i32 %shl, %a
  ret i32 %xor
}

define i64 @sbinv_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbinv_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sll a1, a2, a1
; RV64I-NEXT:    xor a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinv_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binv a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinv_i64:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binv a0, a0, a1
; RV64IBS-NEXT:    ret
  %conv = and i64 %b, 63
  %shl = shl nuw i64 1, %conv
  %xor = xor i64 %shl, %a
  ret i64 %xor
}

define i64 @sbinv_i64_no_mask(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbinv_i64_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    sll a1, a2, a1
; RV64I-NEXT:    xor a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinv_i64_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binv a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinv_i64_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binv a0, a0, a1
; RV64IBS-NEXT:    ret
  %shl = shl nuw i64 1, %b
  %xor = xor i64 %shl, %a
  ret i64 %xor
}

define signext i32 @sbext_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbext_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srlw a0, a0, a1
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbext_i32:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    srlw a0, a0, a1
; RV64IB-NEXT:    andi a0, a0, 1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbext_i32:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    srlw a0, a0, a1
; RV64IBS-NEXT:    andi a0, a0, 1
; RV64IBS-NEXT:    ret
  %and = and i32 %b, 31
  %shr = lshr i32 %a, %and
  %and1 = and i32 %shr, 1
  ret i32 %and1
}

define signext i32 @sbext_i32_no_mask(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: sbext_i32_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srlw a0, a0, a1
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbext_i32_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    srlw a0, a0, a1
; RV64IB-NEXT:    andi a0, a0, 1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbext_i32_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    srlw a0, a0, a1
; RV64IBS-NEXT:    andi a0, a0, 1
; RV64IBS-NEXT:    ret
  %shr = lshr i32 %a, %b
  %and1 = and i32 %shr, 1
  ret i32 %and1
}

define i64 @sbext_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbext_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbext_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bext a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbext_i64:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bext a0, a0, a1
; RV64IBS-NEXT:    ret
  %conv = and i64 %b, 63
  %shr = lshr i64 %a, %conv
  %and1 = and i64 %shr, 1
  ret i64 %and1
}

define i64 @sbext_i64_no_mask(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: sbext_i64_no_mask:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbext_i64_no_mask:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bext a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbext_i64_no_mask:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bext a0, a0, a1
; RV64IBS-NEXT:    ret
  %shr = lshr i64 %a, %b
  %and1 = and i64 %shr, 1
  ret i64 %and1
}

define signext i32 @sbexti_i32(i32 signext %a) nounwind {
; RV64I-LABEL: sbexti_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a0, a0, 5
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbexti_i32:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bexti a0, a0, 5
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbexti_i32:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bexti a0, a0, 5
; RV64IBS-NEXT:    ret
  %shr = lshr i32 %a, 5
  %and = and i32 %shr, 1
  ret i32 %and
}

define i64 @sbexti_i64(i64 %a) nounwind {
; RV64I-LABEL: sbexti_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a0, a0, 5
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbexti_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bexti a0, a0, 5
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbexti_i64:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bexti a0, a0, 5
; RV64IBS-NEXT:    ret
  %shr = lshr i64 %a, 5
  %and = and i64 %shr, 1
  ret i64 %and
}

define signext i32 @sbclri_i32_10(i32 signext %a) nounwind {
; RV64I-LABEL: sbclri_i32_10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, -1025
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i32_10:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    andi a0, a0, -1025
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i32_10:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    andi a0, a0, -1025
; RV64IBS-NEXT:    ret
  %and = and i32 %a, -1025
  ret i32 %and
}

define signext i32 @sbclri_i32_11(i32 signext %a) nounwind {
; RV64I-LABEL: sbclri_i32_11:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1048575
; RV64I-NEXT:    addiw a1, a1, 2047
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i32_11:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclri a0, a0, 11
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i32_11:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclri a0, a0, 11
; RV64IBS-NEXT:    ret
  %and = and i32 %a, -2049
  ret i32 %and
}

define signext i32 @sbclri_i32_30(i32 signext %a) nounwind {
; RV64I-LABEL: sbclri_i32_30:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 786432
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i32_30:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclri a0, a0, 30
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i32_30:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclri a0, a0, 30
; RV64IBS-NEXT:    ret
  %and = and i32 %a, -1073741825
  ret i32 %and
}

define signext i32 @sbclri_i32_31(i32 signext %a) nounwind {
; RV64I-LABEL: sbclri_i32_31:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i32_31:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lui a1, 524288
; RV64IB-NEXT:    addiw a1, a1, -1
; RV64IB-NEXT:    and a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i32_31:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lui a1, 524288
; RV64IBS-NEXT:    addiw a1, a1, -1
; RV64IBS-NEXT:    and a0, a0, a1
; RV64IBS-NEXT:    ret
  %and = and i32 %a, -2147483649
  ret i32 %and
}

define i64 @sbclri_i64_10(i64 %a) nounwind {
; RV64I-LABEL: sbclri_i64_10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, -1025
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i64_10:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    andi a0, a0, -1025
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i64_10:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    andi a0, a0, -1025
; RV64IBS-NEXT:    ret
  %and = and i64 %a, -1025
  ret i64 %and
}

define i64 @sbclri_i64_11(i64 %a) nounwind {
; RV64I-LABEL: sbclri_i64_11:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1048575
; RV64I-NEXT:    addiw a1, a1, 2047
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i64_11:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclri a0, a0, 11
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i64_11:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclri a0, a0, 11
; RV64IBS-NEXT:    ret
  %and = and i64 %a, -2049
  ret i64 %and
}

define i64 @sbclri_i64_30(i64 %a) nounwind {
; RV64I-LABEL: sbclri_i64_30:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 786432
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i64_30:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclri a0, a0, 30
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i64_30:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclri a0, a0, 30
; RV64IBS-NEXT:    ret
  %and = and i64 %a, -1073741825
  ret i64 %and
}

define i64 @sbclri_i64_31(i64 %a) nounwind {
; RV64I-LABEL: sbclri_i64_31:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, -1
; RV64I-NEXT:    slli a1, a1, 31
; RV64I-NEXT:    addi a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i64_31:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclri a0, a0, 31
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i64_31:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclri a0, a0, 31
; RV64IBS-NEXT:    ret
  %and = and i64 %a, -2147483649
  ret i64 %and
}

define i64 @sbclri_i64_62(i64 %a) nounwind {
; RV64I-LABEL: sbclri_i64_62:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, -1
; RV64I-NEXT:    slli a1, a1, 62
; RV64I-NEXT:    addi a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i64_62:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclri a0, a0, 62
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i64_62:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclri a0, a0, 62
; RV64IBS-NEXT:    ret
  %and = and i64 %a, -4611686018427387905
  ret i64 %and
}

define i64 @sbclri_i64_63(i64 %a) nounwind {
; RV64I-LABEL: sbclri_i64_63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, -1
; RV64I-NEXT:    srli a1, a1, 1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbclri_i64_63:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bclri a0, a0, 63
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbclri_i64_63:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bclri a0, a0, 63
; RV64IBS-NEXT:    ret
  %and = and i64 %a, -9223372036854775809
  ret i64 %and
}

define signext i32 @sbseti_i32_10(i32 signext %a) nounwind {
; RV64I-LABEL: sbseti_i32_10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ori a0, a0, 1024
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i32_10:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    ori a0, a0, 1024
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i32_10:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    ori a0, a0, 1024
; RV64IBS-NEXT:    ret
  %or = or i32 %a, 1024
  ret i32 %or
}

define signext i32 @sbseti_i32_11(i32 signext %a) nounwind {
; RV64I-LABEL: sbseti_i32_11:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, -2048
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i32_11:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 11
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i32_11:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 11
; RV64IBS-NEXT:    ret
  %or = or i32 %a, 2048
  ret i32 %or
}

define signext i32 @sbseti_i32_30(i32 signext %a) nounwind {
; RV64I-LABEL: sbseti_i32_30:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 262144
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i32_30:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 30
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i32_30:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 30
; RV64IBS-NEXT:    ret
  %or = or i32 %a, 1073741824
  ret i32 %or
}

define signext i32 @sbseti_i32_31(i32 signext %a) nounwind {
; RV64I-LABEL: sbseti_i32_31:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i32_31:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lui a1, 524288
; RV64IB-NEXT:    or a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i32_31:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lui a1, 524288
; RV64IBS-NEXT:    or a0, a0, a1
; RV64IBS-NEXT:    ret
  %or = or i32 %a, 2147483648
  ret i32 %or
}

define i64 @sbseti_i64_10(i64 %a) nounwind {
; RV64I-LABEL: sbseti_i64_10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ori a0, a0, 1024
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i64_10:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    ori a0, a0, 1024
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i64_10:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    ori a0, a0, 1024
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 1024
  ret i64 %or
}

define i64 @sbseti_i64_11(i64 %a) nounwind {
; RV64I-LABEL: sbseti_i64_11:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, -2048
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i64_11:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 11
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i64_11:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 11
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 2048
  ret i64 %or
}

define i64 @sbseti_i64_30(i64 %a) nounwind {
; RV64I-LABEL: sbseti_i64_30:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 262144
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i64_30:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 30
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i64_30:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 30
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 1073741824
  ret i64 %or
}

define i64 @sbseti_i64_31(i64 %a) nounwind {
; RV64I-LABEL: sbseti_i64_31:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 31
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i64_31:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 31
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i64_31:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 31
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 2147483648
  ret i64 %or
}

define i64 @sbseti_i64_62(i64 %a) nounwind {
; RV64I-LABEL: sbseti_i64_62:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 62
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i64_62:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 62
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i64_62:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 62
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 4611686018427387904
  ret i64 %or
}

define i64 @sbseti_i64_63(i64 %a) nounwind {
; RV64I-LABEL: sbseti_i64_63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, -1
; RV64I-NEXT:    slli a1, a1, 63
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbseti_i64_63:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 63
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbseti_i64_63:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 63
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 9223372036854775808
  ret i64 %or
}

define signext i32 @sbinvi_i32_10(i32 signext %a) nounwind {
; RV64I-LABEL: sbinvi_i32_10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xori a0, a0, 1024
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i32_10:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    xori a0, a0, 1024
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i32_10:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    xori a0, a0, 1024
; RV64IBS-NEXT:    ret
  %xor = xor i32 %a, 1024
  ret i32 %xor
}

define signext i32 @sbinvi_i32_11(i32 signext %a) nounwind {
; RV64I-LABEL: sbinvi_i32_11:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, -2048
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i32_11:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 11
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i32_11:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 11
; RV64IBS-NEXT:    ret
  %xor = xor i32 %a, 2048
  ret i32 %xor
}

define signext i32 @sbinvi_i32_30(i32 signext %a) nounwind {
; RV64I-LABEL: sbinvi_i32_30:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 262144
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i32_30:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 30
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i32_30:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 30
; RV64IBS-NEXT:    ret
  %xor = xor i32 %a, 1073741824
  ret i32 %xor
}

define signext i32 @sbinvi_i32_31(i32 signext %a) nounwind {
; RV64I-LABEL: sbinvi_i32_31:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i32_31:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lui a1, 524288
; RV64IB-NEXT:    xor a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i32_31:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lui a1, 524288
; RV64IBS-NEXT:    xor a0, a0, a1
; RV64IBS-NEXT:    ret
  %xor = xor i32 %a, 2147483648
  ret i32 %xor
}

define i64 @sbinvi_i64_10(i64 %a) nounwind {
; RV64I-LABEL: sbinvi_i64_10:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xori a0, a0, 1024
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i64_10:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    xori a0, a0, 1024
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i64_10:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    xori a0, a0, 1024
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 1024
  ret i64 %xor
}

define i64 @sbinvi_i64_11(i64 %a) nounwind {
; RV64I-LABEL: sbinvi_i64_11:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, -2048
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i64_11:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 11
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i64_11:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 11
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 2048
  ret i64 %xor
}

define i64 @sbinvi_i64_30(i64 %a) nounwind {
; RV64I-LABEL: sbinvi_i64_30:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 262144
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i64_30:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 30
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i64_30:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 30
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 1073741824
  ret i64 %xor
}

define i64 @sbinvi_i64_31(i64 %a) nounwind {
; RV64I-LABEL: sbinvi_i64_31:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 31
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i64_31:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 31
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i64_31:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 31
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 2147483648
  ret i64 %xor
}

define i64 @sbinvi_i64_62(i64 %a) nounwind {
; RV64I-LABEL: sbinvi_i64_62:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 62
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i64_62:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 62
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i64_62:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 62
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 4611686018427387904
  ret i64 %xor
}

define i64 @sbinvi_i64_63(i64 %a) nounwind {
; RV64I-LABEL: sbinvi_i64_63:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, -1
; RV64I-NEXT:    slli a1, a1, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sbinvi_i64_63:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 63
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: sbinvi_i64_63:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 63
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 9223372036854775808
  ret i64 %xor
}

define i64 @xor_i64_large(i64 %a) nounwind {
; RV64I-LABEL: xor_i64_large:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    addi a1, a1, 1
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: xor_i64_large:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    binvi a0, a0, 0
; RV64IB-NEXT:    binvi a0, a0, 32
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: xor_i64_large:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    binvi a0, a0, 0
; RV64IBS-NEXT:    binvi a0, a0, 32
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 4294967297
  ret i64 %xor
}

define i64 @xor_i64_4099(i64 %a) nounwind {
; RV64I-LABEL: xor_i64_4099:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, 3
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: xor_i64_4099:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lui a1, 1
; RV64IB-NEXT:    addiw a1, a1, 3
; RV64IB-NEXT:    xor a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: xor_i64_4099:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lui a1, 1
; RV64IBS-NEXT:    addiw a1, a1, 3
; RV64IBS-NEXT:    xor a0, a0, a1
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 4099
  ret i64 %xor
}

define i64 @xor_i64_96(i64 %a) nounwind {
; RV64I-LABEL: xor_i64_96:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xori a0, a0, 96
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: xor_i64_96:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    xori a0, a0, 96
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: xor_i64_96:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    xori a0, a0, 96
; RV64IBS-NEXT:    ret
  %xor = xor i64 %a, 96
  ret i64 %xor
}

define i64 @or_i64_large(i64 %a) nounwind {
; RV64I-LABEL: or_i64_large:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    addi a1, a1, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: or_i64_large:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    bseti a0, a0, 0
; RV64IB-NEXT:    bseti a0, a0, 32
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: or_i64_large:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    bseti a0, a0, 0
; RV64IBS-NEXT:    bseti a0, a0, 32
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 4294967297
  ret i64 %or
}

define i64 @or_i64_4099(i64 %a) nounwind {
; RV64I-LABEL: or_i64_4099:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, 3
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: or_i64_4099:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    lui a1, 1
; RV64IB-NEXT:    addiw a1, a1, 3
; RV64IB-NEXT:    or a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: or_i64_4099:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    lui a1, 1
; RV64IBS-NEXT:    addiw a1, a1, 3
; RV64IBS-NEXT:    or a0, a0, a1
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 4099
  ret i64 %or
}

define i64 @or_i64_96(i64 %a) nounwind {
; RV64I-LABEL: or_i64_96:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ori a0, a0, 96
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: or_i64_96:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    ori a0, a0, 96
; RV64IB-NEXT:    ret
;
; RV64IBS-LABEL: or_i64_96:
; RV64IBS:       # %bb.0:
; RV64IBS-NEXT:    ori a0, a0, 96
; RV64IBS-NEXT:    ret
  %or = or i64 %a, 96
  ret i64 %or
}
