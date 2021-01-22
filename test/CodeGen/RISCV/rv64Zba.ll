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

define i64 @zextw_i64(i64 %a) nounwind {
; RV64I-LABEL: zextw_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: zextw_i64:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    zext.w a0, a0
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: zextw_i64:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    zext.w a0, a0
; RV64IBA-NEXT:    ret
  %and = and i64 %a, 4294967295
  ret i64 %and
}

define signext i16 @sh1add(i64 %0, i16* %1) {
; RV64I-LABEL: sh1add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lh a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1add:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add a0, a0, a1
; RV64IB-NEXT:    lh a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1add:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add a0, a0, a1
; RV64IBA-NEXT:    lh a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = getelementptr inbounds i16, i16* %1, i64 %0
  %4 = load i16, i16* %3
  ret i16 %4
}

define signext i32 @sh2add(i64 %0, i32* %1) {
; RV64I-LABEL: sh2add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2add:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add a0, a0, a1
; RV64IB-NEXT:    lw a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2add:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add a0, a0, a1
; RV64IBA-NEXT:    lw a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = getelementptr inbounds i32, i32* %1, i64 %0
  %4 = load i32, i32* %3
  ret i32 %4
}

define i64 @sh3add(i64 %0, i64* %1) {
; RV64I-LABEL: sh3add:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3add:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add a0, a0, a1
; RV64IB-NEXT:    ld a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3add:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add a0, a0, a1
; RV64IBA-NEXT:    ld a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = getelementptr inbounds i64, i64* %1, i64 %0
  %4 = load i64, i64* %3
  ret i64 %4
}

define signext i16 @sh1adduw(i32 signext %0, i16* %1) {
; RV64I-LABEL: sh1adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lh a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add.uw a0, a0, a1
; RV64IB-NEXT:    lh a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add.uw a0, a0, a1
; RV64IBA-NEXT:    lh a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i16, i16* %1, i64 %3
  %5 = load i16, i16* %4
  ret i16 %5
}

define i64 @sh1adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh1adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 33
; RV64I-NEXT:    addi a2, a2, -2
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh1adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh1add.uw a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh1adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh1add.uw a0, a0, a1
; RV64IBA-NEXT:    ret
  %3 = shl i64 %0, 1
  %4 = and i64 %3, 8589934590
  %5 = add i64 %4, %1
  ret i64 %5
}

define signext i32 @sh2adduw(i32 signext %0, i32* %1) {
; RV64I-LABEL: sh2adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add.uw a0, a0, a1
; RV64IB-NEXT:    lw a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add.uw a0, a0, a1
; RV64IBA-NEXT:    lw a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i32, i32* %1, i64 %3
  %5 = load i32, i32* %4
  ret i32 %5
}

define i64 @sh2adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh2adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 2
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 34
; RV64I-NEXT:    addi a2, a2, -4
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh2adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh2add.uw a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh2adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh2add.uw a0, a0, a1
; RV64IBA-NEXT:    ret
  %3 = shl i64 %0, 2
  %4 = and i64 %3, 17179869180
  %5 = add i64 %4, %1
  ret i64 %5
}

define i64 @sh3adduw(i32 signext %0, i64* %1) {
; RV64I-LABEL: sh3adduw:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3adduw:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add.uw a0, a0, a1
; RV64IB-NEXT:    ld a0, 0(a0)
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3adduw:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add.uw a0, a0, a1
; RV64IBA-NEXT:    ld a0, 0(a0)
; RV64IBA-NEXT:    ret
  %3 = zext i32 %0 to i64
  %4 = getelementptr inbounds i64, i64* %1, i64 %3
  %5 = load i64, i64* %4
  ret i64 %5
}

define i64 @sh3adduw_2(i64 %0, i64 %1) {
; RV64I-LABEL: sh3adduw_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 35
; RV64I-NEXT:    addi a2, a2, -8
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IB-LABEL: sh3adduw_2:
; RV64IB:       # %bb.0:
; RV64IB-NEXT:    sh3add.uw a0, a0, a1
; RV64IB-NEXT:    ret
;
; RV64IBA-LABEL: sh3adduw_2:
; RV64IBA:       # %bb.0:
; RV64IBA-NEXT:    sh3add.uw a0, a0, a1
; RV64IBA-NEXT:    ret
  %3 = shl i64 %0, 3
  %4 = and i64 %3, 34359738360
  %5 = add i64 %4, %1
  ret i64 %5
}
