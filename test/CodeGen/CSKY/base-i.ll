; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -csky-no-aliases -mattr=+e2 < %s -mtriple=csky | FileCheck %s

define i32 @addRR(i32 %x, i32 %y) {
; CHECK-LABEL: addRR:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addu32 a0, a1, a0
; CHECK-NEXT:    rts32
entry:
  %add = add nsw i32 %y, %x
  ret i32 %add
}

define i32 @addRI(i32 %x) {
; CHECK-LABEL: addRI:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi32 a0, a0, 10
; CHECK-NEXT:    rts32
entry:
  %add = add nsw i32 %x, 10
  ret i32 %add
}

define i32 @addRI_X(i32 %x) {
; CHECK-LABEL: addRI_X:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movi32 a1, 4097
; CHECK-NEXT:    addu32 a0, a0, a1
; CHECK-NEXT:    rts32
entry:
  %add = add nsw i32 %x, 4097
  ret i32 %add
}
