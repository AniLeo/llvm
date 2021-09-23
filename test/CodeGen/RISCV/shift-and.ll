; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; Test for handling of AND with constant followed by a shift by constant. Often
; we can replace these with a pair of shifts to avoid materializing a constant
; for the and.

define i32 @test1(i32 %x) {
; RV32I-LABEL: test1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a0, a0, 5
; RV32I-NEXT:    andi a0, a0, -8
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test1:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a0, a0, 8
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    ret
  %a = lshr i32 %x, 5
  %b = and i32 %a, 134217720
  ret i32 %b
}

define i64 @test2(i64 %x) {
; RV32I-LABEL: test2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a1, 27
; RV32I-NEXT:    srli a0, a0, 5
; RV32I-NEXT:    or a0, a0, a2
; RV32I-NEXT:    srli a1, a1, 5
; RV32I-NEXT:    andi a0, a0, -8
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a0, a0, 5
; RV64I-NEXT:    andi a0, a0, -8
; RV64I-NEXT:    ret
  %a = lshr i64 %x, 5
  %b = and i64 %a, 576460752303423480
  ret i64 %b
}

define i32 @test3(i32 %x) {
; RV32I-LABEL: test3:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a0, a0, 20
; RV32I-NEXT:    slli a0, a0, 14
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test3:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a0, a0, 20
; RV64I-NEXT:    slli a0, a0, 14
; RV64I-NEXT:    ret
  %a = lshr i32 %x, 6
  %b = and i32 %a, 67092480
  ret i32 %b
}

define i64 @test4(i64 %x) {
; RV32I-LABEL: test4:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a2, a1, 26
; RV32I-NEXT:    srli a0, a0, 6
; RV32I-NEXT:    or a0, a0, a2
; RV32I-NEXT:    srli a1, a1, 6
; RV32I-NEXT:    lui a2, 1048572
; RV32I-NEXT:    and a0, a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test4:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a0, a0, 20
; RV64I-NEXT:    slli a0, a0, 14
; RV64I-NEXT:    ret
  %a = lshr i64 %x, 6
  %b = and i64 %a, 288230376151695360
  ret i64 %b
}
