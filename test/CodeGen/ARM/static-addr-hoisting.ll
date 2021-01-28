; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv7-none-eabi %s -o -  | FileCheck %s

define void @multiple_store() {
; CHECK-LABEL: multiple_store:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    movw r0, #16960
; CHECK-NEXT:    movs r1, #42
; CHECK-NEXT:    movt r0, #15
; CHECK-NEXT:    str.w r1, [r0, #42]
; CHECK-NEXT:    str r1, [r0, #24]
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    movw r0, #20394
; CHECK-NEXT:    movt r0, #18
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
  store i32 42, i32* inttoptr(i32 1000000 to i32*)
  store i32 42, i32* inttoptr(i32 1000024 to i32*)
  store i32 42, i32* inttoptr(i32 1000042 to i32*)
  store i32 42, i32* inttoptr(i32 1200042 to i32*)
  ret void
}
