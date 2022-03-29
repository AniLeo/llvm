; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -csky-no-aliases -mattr=+e2 -mattr=+2e3 < %s -mtriple=csky | FileCheck %s
; RUN: llc -verify-machineinstrs -csky-no-aliases < %s -mtriple=csky  | FileCheck %s --check-prefix=GENERIC

; i32/i16/i8/i1 --> i64
define i64 @zextR_i64_0(i32 %x) {
; CHECK-LABEL: zextR_i64_0:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movi16 a1, 0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i64_0:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i32 %x to i64
  ret i64 %zext
}

define i64 @zextR_i64_1(i16 %x) {
; CHECK-LABEL: zextR_i64_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    zexth16 a0, a0
; CHECK-NEXT:    movi16 a1, 0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i64_1:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 0
; GENERIC-NEXT:    lsli16 a2, a1, 24
; GENERIC-NEXT:    lsli16 a1, a1, 16
; GENERIC-NEXT:    or16 a1, a2
; GENERIC-NEXT:    movi16 a2, 255
; GENERIC-NEXT:    lsli16 a3, a2, 8
; GENERIC-NEXT:    or16 a3, a1
; GENERIC-NEXT:    or16 a3, a2
; GENERIC-NEXT:    and16 a0, a3
; GENERIC-NEXT:    movi16 a1, 0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i16 %x to i64
  ret i64 %zext
}

define i64 @zextR_i64_2(i8 %x) {
; CHECK-LABEL: zextR_i64_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    zextb16 a0, a0
; CHECK-NEXT:    movi16 a1, 0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i64_2:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 255
; GENERIC-NEXT:    and16 a0, a1
; GENERIC-NEXT:    movi16 a1, 0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i8 %x to i64
  ret i64 %zext
}

define i64 @zextR_i64_3(i1 %x) {
; CHECK-LABEL: zextR_i64_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a0, a0, 1
; CHECK-NEXT:    movi16 a1, 0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i64_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 1
; GENERIC-NEXT:    and16 a0, a1
; GENERIC-NEXT:    movi16 a1, 0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i1 %x to i64
  ret i64 %zext
}

; i16/i8/i1 --> i32
define i32 @zextR_i32_1(i16 %x) {
; CHECK-LABEL: zextR_i32_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    zexth16 a0, a0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i32_1:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 0
; GENERIC-NEXT:    lsli16 a2, a1, 24
; GENERIC-NEXT:    lsli16 a1, a1, 16
; GENERIC-NEXT:    or16 a1, a2
; GENERIC-NEXT:    movi16 a2, 255
; GENERIC-NEXT:    lsli16 a3, a2, 8
; GENERIC-NEXT:    or16 a3, a1
; GENERIC-NEXT:    or16 a3, a2
; GENERIC-NEXT:    and16 a0, a3
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i16 %x to i32
  ret i32 %zext
}

define i32 @zextR_i32_2(i8 %x) {
; CHECK-LABEL: zextR_i32_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    zextb16 a0, a0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i32_2:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 255
; GENERIC-NEXT:    and16 a0, a1
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i8 %x to i32
  ret i32 %zext
}

define i32 @zextR_i32_3(i1 %x) {
; CHECK-LABEL: zextR_i32_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a0, a0, 1
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i32_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 1
; GENERIC-NEXT:    and16 a0, a1
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i1 %x to i32
  ret i32 %zext
}

; i8/i1 --> i16
define i16 @zextR_i16_2(i8 %x) {
; CHECK-LABEL: zextR_i16_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    zextb16 a0, a0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i16_2:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 255
; GENERIC-NEXT:    and16 a0, a1
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i8 %x to i16
  ret i16 %zext
}

define i16 @zextR_i16_3(i1 %x) {
; CHECK-LABEL: zextR_i16_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a0, a0, 1
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i16_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 1
; GENERIC-NEXT:    and16 a0, a1
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i1 %x to i16
  ret i16 %zext
}

;i1 --> i8
define i8 @zextR_i8_3(i1 %x) {
; CHECK-LABEL: zextR_i8_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi32 a0, a0, 1
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: zextR_i8_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    movi16 a1, 1
; GENERIC-NEXT:    and16 a0, a1
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %zext = zext i1 %x to i8
  ret i8 %zext
}

; i32/i16/i8/i1 --> i64
define i64 @sextR_i64_0(i32 %x) {
; CHECK-LABEL: sextR_i64_0:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    asri16 a1, a0, 31
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i64_0:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    asri16 a1, a0, 31
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i32 %x to i64
  ret i64 %sext
}

define i64 @sextR_i64_1(i16 %x) {
; CHECK-LABEL: sextR_i64_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sexth16 a0, a0
; CHECK-NEXT:    asri16 a1, a0, 31
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i64_1:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    sexth16 a0, a0
; GENERIC-NEXT:    asri16 a1, a0, 31
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i16 %x to i64
  ret i64 %sext
}

define i64 @sextR_i64_2(i8 %x) {
; CHECK-LABEL: sextR_i64_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sextb16 a0, a0
; CHECK-NEXT:    asri16 a1, a0, 31
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i64_2:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    sextb16 a0, a0
; GENERIC-NEXT:    asri16 a1, a0, 31
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i8 %x to i64
  ret i64 %sext
}

define i64 @sextR_i64_3(i1 %x) {
; CHECK-LABEL: sextR_i64_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sext32 a0, a0, 0, 0
; CHECK-NEXT:    mov16 a1, a0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i64_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    lsli16 a0, a0, 7
; GENERIC-NEXT:    asri16 a0, a0, 7
; GENERIC-NEXT:    mov16 a1, a0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i1 %x to i64
  ret i64 %sext
}

; i16/i8/i1 --> i32
define i32 @sextR_i32_1(i16 %x) {
; CHECK-LABEL: sextR_i32_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sexth16 a0, a0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i32_1:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    sexth16 a0, a0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i16 %x to i32
  ret i32 %sext
}

define i32 @sextR_i32_2(i8 %x) {
; CHECK-LABEL: sextR_i32_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sextb16 a0, a0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i32_2:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    sextb16 a0, a0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i8 %x to i32
  ret i32 %sext
}

define i32 @sextR_i32_3(i1 %x) {
; CHECK-LABEL: sextR_i32_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sext32 a0, a0, 0, 0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i32_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    lsli16 a0, a0, 7
; GENERIC-NEXT:    asri16 a0, a0, 7
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i1 %x to i32
  ret i32 %sext
}

; i8/i1 --> i16
define i16 @sextR_i16_2(i8 %x) {
; CHECK-LABEL: sextR_i16_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sextb16 a0, a0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i16_2:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    sextb16 a0, a0
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i8 %x to i16
  ret i16 %sext
}

define i16 @sextR_i16_3(i1 %x) {
; CHECK-LABEL: sextR_i16_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sext32 a0, a0, 0, 0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i16_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    lsli16 a0, a0, 7
; GENERIC-NEXT:    asri16 a0, a0, 7
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i1 %x to i16
  ret i16 %sext
}

;i1 --> i8
define i8 @sextR_i8_3(i1 %x) {
; CHECK-LABEL: sextR_i8_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sext32 a0, a0, 0, 0
; CHECK-NEXT:    rts16
;
; GENERIC-LABEL: sextR_i8_3:
; GENERIC:       # %bb.0: # %entry
; GENERIC-NEXT:    .cfi_def_cfa_offset 0
; GENERIC-NEXT:    subi16 sp, sp, 4
; GENERIC-NEXT:    .cfi_def_cfa_offset 4
; GENERIC-NEXT:    lsli16 a0, a0, 7
; GENERIC-NEXT:    asri16 a0, a0, 7
; GENERIC-NEXT:    addi16 sp, sp, 4
; GENERIC-NEXT:    rts16
entry:
  %sext = sext i1 %x to i8
  ret i8 %sext
}
