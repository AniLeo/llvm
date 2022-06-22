; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s
;
; Check that the isel does not fold the shld, which already folds a load
; and has two uses, into a store.

target triple = "i686-unknown-unknown"

@A = external dso_local global i32

define i32 @test5(i32 %B, i8 %C) {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movb {{[0-9]+}}(%esp), %cl
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    movl A, %eax
; CHECK-NEXT:    shldl %cl, %edx, %eax
; CHECK-NEXT:    movl %eax, A
; CHECK-NEXT:    retl
entry:
  %tmp.1 = load i32, ptr @A
  %shift.upgrd.1 = zext i8 %C to i32
  %tmp.2 = shl i32 %tmp.1, %shift.upgrd.1
  %tmp.3 = sub i8 32, %C
  %shift.upgrd.2 = zext i8 %tmp.3 to i32
  %tmp.4 = lshr i32 %B, %shift.upgrd.2
  %tmp.5 = or i32 %tmp.4, %tmp.2
  store i32 %tmp.5, ptr @A
  ret i32 %tmp.5
}

