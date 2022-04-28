; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=CHECK,NOZBS,RV32,RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=CHECK,NOZBS,RV64,RV64I
; RUN: llc -mtriple=riscv32 -mattr=+zbs -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=CHECK,ZBS,RV32,RV32ZBS
; RUN: llc -mtriple=riscv64 -mattr=+zbs -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=CHECK,ZBS,RV64,RV64ZBS

define signext i32 @bittest_7_i32(i32 signext %a) nounwind {
; CHECK-LABEL: bittest_7_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a0, a0, 128
; CHECK-NEXT:    seqz a0, a0
; CHECK-NEXT:    ret
  %shr = lshr i32 %a, 7
  %not = xor i32 %shr, -1
  %and = and i32 %not, 1
  ret i32 %and
}

define signext i32 @bittest_10_i32(i32 signext %a) nounwind {
; CHECK-LABEL: bittest_10_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a0, a0, 1024
; CHECK-NEXT:    seqz a0, a0
; CHECK-NEXT:    ret
  %shr = lshr i32 %a, 10
  %not = xor i32 %shr, -1
  %and = and i32 %not, 1
  ret i32 %and
}

define signext i32 @bittest_11_i32(i32 signext %a) nounwind {
; NOZBS-LABEL: bittest_11_i32:
; NOZBS:       # %bb.0:
; NOZBS-NEXT:    srli a0, a0, 11
; NOZBS-NEXT:    not a0, a0
; NOZBS-NEXT:    andi a0, a0, 1
; NOZBS-NEXT:    ret
;
; ZBS-LABEL: bittest_11_i32:
; ZBS:       # %bb.0:
; ZBS-NEXT:    bexti a0, a0, 11
; ZBS-NEXT:    xori a0, a0, 1
; ZBS-NEXT:    ret
  %shr = lshr i32 %a, 11
  %not = xor i32 %shr, -1
  %and = and i32 %not, 1
  ret i32 %and
}

define signext i32 @bittest_31_i32(i32 signext %a) nounwind {
; RV32-LABEL: bittest_31_i32:
; RV32:       # %bb.0:
; RV32-NEXT:    not a0, a0
; RV32-NEXT:    srli a0, a0, 31
; RV32-NEXT:    ret
;
; RV64-LABEL: bittest_31_i32:
; RV64:       # %bb.0:
; RV64-NEXT:    not a0, a0
; RV64-NEXT:    srliw a0, a0, 31
; RV64-NEXT:    ret
  %shr = lshr i32 %a, 31
  %not = xor i32 %shr, -1
  %and = and i32 %not, 1
  ret i32 %and
}

define i64 @bittest_7_i64(i64 %a) nounwind {
; RV32-LABEL: bittest_7_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    andi a0, a0, 128
; RV32-NEXT:    seqz a0, a0
; RV32-NEXT:    li a1, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: bittest_7_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    andi a0, a0, 128
; RV64-NEXT:    seqz a0, a0
; RV64-NEXT:    ret
  %shr = lshr i64 %a, 7
  %not = xor i64 %shr, -1
  %and = and i64 %not, 1
  ret i64 %and
}

define i64 @bittest_10_i64(i64 %a) nounwind {
; RV32-LABEL: bittest_10_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    andi a0, a0, 1024
; RV32-NEXT:    seqz a0, a0
; RV32-NEXT:    li a1, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: bittest_10_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    andi a0, a0, 1024
; RV64-NEXT:    seqz a0, a0
; RV64-NEXT:    ret
  %shr = lshr i64 %a, 10
  %not = xor i64 %shr, -1
  %and = and i64 %not, 1
  ret i64 %and
}

define i64 @bittest_11_i64(i64 %a) nounwind {
; RV32I-LABEL: bittest_11_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a0, a0, 11
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    andi a0, a0, 1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    ret
;
; RV64I-LABEL: bittest_11_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a0, a0, 11
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV32ZBS-LABEL: bittest_11_i64:
; RV32ZBS:       # %bb.0:
; RV32ZBS-NEXT:    bexti a0, a0, 11
; RV32ZBS-NEXT:    xori a0, a0, 1
; RV32ZBS-NEXT:    li a1, 0
; RV32ZBS-NEXT:    ret
;
; RV64ZBS-LABEL: bittest_11_i64:
; RV64ZBS:       # %bb.0:
; RV64ZBS-NEXT:    bexti a0, a0, 11
; RV64ZBS-NEXT:    xori a0, a0, 1
; RV64ZBS-NEXT:    ret
  %shr = lshr i64 %a, 11
  %not = xor i64 %shr, -1
  %and = and i64 %not, 1
  ret i64 %and
}

define i64 @bittest_31_i64(i64 %a) nounwind {
; RV32-LABEL: bittest_31_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    not a0, a0
; RV32-NEXT:    srli a0, a0, 31
; RV32-NEXT:    li a1, 0
; RV32-NEXT:    ret
;
; RV64I-LABEL: bittest_31_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a0, a0, 31
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64ZBS-LABEL: bittest_31_i64:
; RV64ZBS:       # %bb.0:
; RV64ZBS-NEXT:    bexti a0, a0, 31
; RV64ZBS-NEXT:    xori a0, a0, 1
; RV64ZBS-NEXT:    ret
  %shr = lshr i64 %a, 31
  %not = xor i64 %shr, -1
  %and = and i64 %not, 1
  ret i64 %and
}

define i64 @bittest_32_i64(i64 %a) nounwind {
; RV32-LABEL: bittest_32_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    not a0, a1
; RV32-NEXT:    andi a0, a0, 1
; RV32-NEXT:    li a1, 0
; RV32-NEXT:    ret
;
; RV64I-LABEL: bittest_32_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    andi a0, a0, 1
; RV64I-NEXT:    ret
;
; RV64ZBS-LABEL: bittest_32_i64:
; RV64ZBS:       # %bb.0:
; RV64ZBS-NEXT:    bexti a0, a0, 32
; RV64ZBS-NEXT:    xori a0, a0, 1
; RV64ZBS-NEXT:    ret
  %shr = lshr i64 %a, 32
  %not = xor i64 %shr, -1
  %and = and i64 %not, 1
  ret i64 %and
}

define i64 @bittest_63_i64(i64 %a) nounwind {
; RV32-LABEL: bittest_63_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    not a0, a1
; RV32-NEXT:    srli a0, a0, 31
; RV32-NEXT:    li a1, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: bittest_63_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    not a0, a0
; RV64-NEXT:    srli a0, a0, 63
; RV64-NEXT:    ret
  %shr = lshr i64 %a, 63
  %not = xor i64 %shr, -1
  %and = and i64 %not, 1
  ret i64 %and
}
