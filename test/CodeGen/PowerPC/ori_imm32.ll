; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64le-unknown-linux-gnu | FileCheck %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-unknown-linux-gnu | FileCheck %s

define i64 @ori_test_a(i64 %a) {
; CHECK-LABEL: ori_test_a:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ori 3, 3, 65535
; CHECK-NEXT:    oris 3, 3, 65535
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 4294967295
  ret i64 %or
}

define i64 @ori_test_b(i64 %a) {
; CHECK-LABEL: ori_test_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    sldi 4, 4, 32
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 4294967296
  ret i64 %or
}

define i64 @ori_test_c(i64 %a) {
; CHECK-LABEL: ori_test_c:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ori 3, 3, 65535
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 65535
  ret i64 %or
}

define i64 @ori_test_d(i64 %a) {
; CHECK-LABEL: ori_test_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    oris 3, 3, 1
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 65536
  ret i64 %or
}

define zeroext i32 @ori_test_e(i32 zeroext %a) {
; CHECK-LABEL: ori_test_e:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ori 3, 3, 65535
; CHECK-NEXT:    oris 3, 3, 255
; CHECK-NEXT:    blr
entry:
  %or = or i32 %a, 16777215
  ret i32 %or
}

define i64 @xori_test_a(i64 %a) {
; CHECK-LABEL: xori_test_a:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xori 3, 3, 65535
; CHECK-NEXT:    xoris 3, 3, 65535
; CHECK-NEXT:    blr
entry:
  %xor = xor i64 %a, 4294967295
  ret i64 %xor
}

define i64 @xori_test_b(i64 %a) {
; CHECK-LABEL: xori_test_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    sldi 4, 4, 32
; CHECK-NEXT:    xor 3, 3, 4
; CHECK-NEXT:    blr
entry:
  %xor = xor i64 %a, 4294967296
  ret i64 %xor
}

define i64 @xori_test_c(i64 %a) {
; CHECK-LABEL: xori_test_c:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xori 3, 3, 65535
; CHECK-NEXT:    blr
entry:
  %xor = xor i64 %a, 65535
  ret i64 %xor
}

define i64 @xori_test_d(i64 %a) {
; CHECK-LABEL: xori_test_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xoris 3, 3, 1
; CHECK-NEXT:    blr
entry:
  %xor = xor i64 %a, 65536
  ret i64 %xor
}

define zeroext i32 @xori_test_e(i32 zeroext %a) {
; CHECK-LABEL: xori_test_e:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xori 3, 3, 65535
; CHECK-NEXT:    xoris 3, 3, 255
; CHECK-NEXT:    blr
entry:
  %xor = xor i32 %a, 16777215
  ret i32 %xor
}
