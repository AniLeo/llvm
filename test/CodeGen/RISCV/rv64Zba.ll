; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+experimental-b -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IB
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zba -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IBA

define i64 @slliuw(i64 %a) nounwind {
; RV64I-LABEL: slliuw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 33
; RV64I-NEXT:    addi a1, a1, -2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: slliuw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli.uw a0, a0, 1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: slliuw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli.uw a0, a0, 1
; RV64IBA-NEXT:    ret
  %conv1 = shl i64 %a, 1
  %shl = and i64 %conv1, 8589934590
  ret i64 %shl
}

define i128 @slliuw_2(i32 signext %0, i128* %1) {
; RV64I-LABEL: slliuw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    slli a0, a0, 4
; RV64I-NEXT:    add a1, a1, a0
; RV64I-NEXT:    ld a0, 0(a1)
; RV64I-NEXT:    ld a1, 8(a1)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: slliuw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    slli.uw a0, a0, 4
; RV64IB-NEXT:    add a1, a1, a0
; RV64IB-NEXT:    ld a0, 0(a1)
; RV64IB-NEXT:    ld a1, 8(a1)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: slliuw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    slli.uw a0, a0, 4
; RV64IBA-NEXT:    add a1, a1, a0
; RV64IBA-NEXT:    ld a0, 0(a1)
; RV64IBA-NEXT:    ld a1, 8(a1)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i128, i128* %1, i64 %3
  %5 = load i128, i128* %4
  ret i128 %5
}

define i64 @adduw(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    add.uw a0, a1, a0
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    add.uw a0, a1, a0
; RV64IBA-NEXT:    ret
  %and = and i64 %b, 4294967295
  %add = add i64 %and, %a
  ret i64 %add
}

define signext i8 @adduw_2(i32 signext %0, i8* %1) {
; RV64I-LABEL: adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lb a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    add.uw a0, a0, a1
; RV64IB-NEXT:    lb a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    add.uw a0, a0, a1
; RV64IBA-NEXT:    lb a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i8, i8* %1, i64 %3
  %5 = load i8, i8* %4
  ret i8 %5
}
