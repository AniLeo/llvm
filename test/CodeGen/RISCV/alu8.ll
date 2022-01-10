; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; These tests are identical to those in alu32.ll but operate on i8. They check
; that legalisation of these non-native types doesn't introduce unnecessary
; inefficiencies.

define i8 @addi(i8 %a) nounwind {
; RV32I-LABEL: addi:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: addi:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 1
; RV64I-NEXT:    ret
  %1 = add i8 %a, 1
  ret i8 %1
}

define i8 @slti(i8 %a) nounwind {
; RV32I-LABEL: slti:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    slti a0, a0, 2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: slti:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 56
; RV64I-NEXT:    slti a0, a0, 2
; RV64I-NEXT:    ret
  %1 = icmp slt i8 %a, 2
  %2 = zext i1 %1 to i8
  ret i8 %2
}

define i8 @sltiu(i8 %a) nounwind {
; RV32I-LABEL: sltiu:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    sltiu a0, a0, 3
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sltiu:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, 255
; RV64I-NEXT:    sltiu a0, a0, 3
; RV64I-NEXT:    ret
  %1 = icmp ult i8 %a, 3
  %2 = zext i1 %1 to i8
  ret i8 %2
}

; Make sure we avoid an AND, if the input of an unsigned compare is known
; to be sign extended. This can occur due to InstCombine canonicalizing
; x s>= 0 && x s< 10 to x u< 10.
define i8 @sltiu_signext(i8 signext %a) nounwind {
; RV32I-LABEL: sltiu_signext:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sltiu a0, a0, 10
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sltiu_signext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sltiu a0, a0, 10
; RV64I-NEXT:    ret
  %1 = icmp ult i8 %a, 10
  %2 = zext i1 %1 to i8
  ret i8 %2
}

define i8 @xori(i8 %a) nounwind {
; RV32I-LABEL: xori:
; RV32I:       # %bb.0:
; RV32I-NEXT:    xori a0, a0, 4
; RV32I-NEXT:    ret
;
; RV64I-LABEL: xori:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xori a0, a0, 4
; RV64I-NEXT:    ret
  %1 = xor i8 %a, 4
  ret i8 %1
}

define i8 @ori(i8 %a) nounwind {
; RV32I-LABEL: ori:
; RV32I:       # %bb.0:
; RV32I-NEXT:    ori a0, a0, 5
; RV32I-NEXT:    ret
;
; RV64I-LABEL: ori:
; RV64I:       # %bb.0:
; RV64I-NEXT:    ori a0, a0, 5
; RV64I-NEXT:    ret
  %1 = or i8 %a, 5
  ret i8 %1
}

define i8 @andi(i8 %a) nounwind {
; RV32I-LABEL: andi:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a0, a0, 6
; RV32I-NEXT:    ret
;
; RV64I-LABEL: andi:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, 6
; RV64I-NEXT:    ret
  %1 = and i8 %a, 6
  ret i8 %1
}

define i8 @slli(i8 %a) nounwind {
; RV32I-LABEL: slli:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 7
; RV32I-NEXT:    ret
;
; RV64I-LABEL: slli:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 7
; RV64I-NEXT:    ret
  %1 = shl i8 %a, 7
  ret i8 %1
}

define i8 @srli(i8 %a) nounwind {
; RV32I-LABEL: srli:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srli a0, a0, 30
; RV32I-NEXT:    ret
;
; RV64I-LABEL: srli:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srli a0, a0, 62
; RV64I-NEXT:    ret
  %1 = lshr i8 %a, 6
  ret i8 %1
}

define i8 @srai(i8 %a) nounwind {
; RV32I-LABEL: srai:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 29
; RV32I-NEXT:    ret
;
; RV64I-LABEL: srai:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 61
; RV64I-NEXT:    ret
  %1 = ashr i8 %a, 5
  ret i8 %1
}


define i8 @add(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: add:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
  %1 = add i8 %a, %b
  ret i8 %1
}

define i8 @sub(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: sub:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sub:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
  %1 = sub i8 %a, %b
  ret i8 %1
}

define i8 @sll(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: sll:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sll a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sll:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i8 %a, %b
  ret i8 %1
}

define i8 @slt(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: slt:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a1, 24
; RV32I-NEXT:    srai a1, a1, 24
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    slt a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: slt:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 56
; RV64I-NEXT:    srai a1, a1, 56
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 56
; RV64I-NEXT:    slt a0, a0, a1
; RV64I-NEXT:    ret
  %1 = icmp slt i8 %a, %b
  %2 = zext i1 %1 to i8
  ret i8 %2
}

define i8 @sltu(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: sltu:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a1, a1, 255
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    sltu a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sltu:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a1, a1, 255
; RV64I-NEXT:    andi a0, a0, 255
; RV64I-NEXT:    sltu a0, a0, a1
; RV64I-NEXT:    ret
  %1 = icmp ult i8 %a, %b
  %2 = zext i1 %1 to i8
  ret i8 %2
}

define i8 @xor(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: xor:
; RV32I:       # %bb.0:
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: xor:
; RV64I:       # %bb.0:
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
  %1 = xor i8 %a, %b
  ret i8 %1
}

define i8 @srl(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: srl:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    srl a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: srl:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, 255
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    ret
  %1 = lshr i8 %a, %b
  ret i8 %1
}

define i8 @sra(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: sra:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    sra a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: sra:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 56
; RV64I-NEXT:    sra a0, a0, a1
; RV64I-NEXT:    ret
  %1 = ashr i8 %a, %b
  ret i8 %1
}

define i8 @or(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: or:
; RV32I:       # %bb.0:
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: or:
; RV64I:       # %bb.0:
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
  %1 = or i8 %a, %b
  ret i8 %1
}

define i8 @and(i8 %a, i8 %b) nounwind {
; RV32I-LABEL: and:
; RV32I:       # %bb.0:
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: and:
; RV64I:       # %bb.0:
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
  %1 = and i8 %a, %b
  ret i8 %1
}
