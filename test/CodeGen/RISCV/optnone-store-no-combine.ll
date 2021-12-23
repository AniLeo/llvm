; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s | FileCheck %s

; This test verifies that a repeated store is not eliminated with optnone (improves debugging).

define void @foo(i32* %p) noinline optnone {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 8
; CHECK-NEXT:    sw a1, 0(a0)
; CHECK-NEXT:    sw a1, 0(a0)
; CHECK-NEXT:    ret
  store i32 8, i32* %p, align 4
  store i32 8, i32* %p, align 4
  ret void
}
