; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64le-unknown-linux-gnu | FileCheck %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-unknown-linux-gnu | FileCheck %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-ibm-aix-xcoff | FileCheck %s

define i64 @ori_test_1(i64 %a) {
; CHECK-LABEL: ori_test_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 18446744073709551615 ; 0xffffffffffffffff
  ret i64 %or
}

define i64 @ori_test_2(i64 %a) {
; CHECK-LABEL: ori_test_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 4, -1
; CHECK-NEXT:    rldimi 3, 4, 29, 15
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 562949416550400 ; 0x1ffffe0000000
  ret i64 %or
}

define i64 @ori_test_3(i64 %a) {
; CHECK-LABEL: ori_test_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 4, -1
; CHECK-NEXT:    rldimi 3, 4, 3, 28
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 68719476728 ; 0xffffffff8
  ret i64 %or
}

define i64 @ori_test_4(i64 %a) {
; CHECK-LABEL: ori_test_4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 4, -32640
; CHECK-NEXT:    ori 4, 4, 32903
; CHECK-NEXT:    rldicl 4, 4, 13, 19
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 17661175070719 ; 0x10101010ffff
  ret i64 %or
}

; Don't exploit rldimi if operand has multiple uses
define i64 @test_test_5(i64 %a, i64 %b) {
; CHECK-LABEL: test_test_5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 5, 1
; CHECK-NEXT:    rldic 5, 5, 32, 31
; CHECK-NEXT:    or 5, 3, 5
; CHECK-NEXT:    add 4, 5, 4
; CHECK-NEXT:    sub 3, 3, 4
; CHECK-NEXT:    blr
entry:
  %or = or i64 %a, 4294967296
  %add = add i64 %or, %b
  %div = sub i64 %a, %add
  ret i64 %div
}
