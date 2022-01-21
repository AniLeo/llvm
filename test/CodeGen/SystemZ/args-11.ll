; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Test outgoing promoted arguments that are split (and passed by reference).
;
; RUN: llc < %s -mtriple=s390x-linux-gnu | FileCheck %s

; The i96 arg is promoted to i128 and should get the full stack space.
declare void @fn1(i96)
define i32 @fn2() {
; CHECK-LABEL: fn2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stmg %r14, %r15, 112(%r15)
; CHECK-NEXT:    .cfi_offset %r14, -48
; CHECK-NEXT:    .cfi_offset %r15, -40
; CHECK-NEXT:    aghi %r15, -184
; CHECK-NEXT:    .cfi_def_cfa_offset 344
; CHECK-NEXT:    mvhi 164(%r15), -1
; CHECK-NEXT:    mvghi 176(%r15), 0
; CHECK-NEXT:    la %r2, 168(%r15)
; CHECK-NEXT:    mvghi 168(%r15), 0
; CHECK-NEXT:    brasl %r14, fn1@PLT
; CHECK-NEXT:    l %r2, 164(%r15)
; CHECK-NEXT:    lmg %r14, %r15, 296(%r15)
; CHECK-NEXT:    br %r14
  %1 = alloca i32
  store i32 -1, i32* %1
  call void @fn1(i96 0)
  %2 = load i32, i32* %1
  ret i32 %2
}

declare void @fn3(i136)
define i32 @fn4() {
; CHECK-LABEL: fn4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    stmg %r14, %r15, 112(%r15)
; CHECK-NEXT:    .cfi_offset %r14, -48
; CHECK-NEXT:    .cfi_offset %r15, -40
; CHECK-NEXT:    aghi %r15, -192
; CHECK-NEXT:    .cfi_def_cfa_offset 352
; CHECK-NEXT:    mvhi 164(%r15), -1
; CHECK-NEXT:    mvghi 184(%r15), 0
; CHECK-NEXT:    mvghi 176(%r15), 0
; CHECK-NEXT:    la %r2, 168(%r15)
; CHECK-NEXT:    mvghi 168(%r15), 0
; CHECK-NEXT:    brasl %r14, fn3@PLT
; CHECK-NEXT:    l %r2, 164(%r15)
; CHECK-NEXT:    lmg %r14, %r15, 304(%r15)
; CHECK-NEXT:    br %r14
  %1 = alloca i32
  store i32 -1, i32* %1
  call void @fn3(i136 0)
  %2 = load i32, i32* %1
  ret i32 %2
}
