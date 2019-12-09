; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

define i8 @test(i32 *%P) nounwind {
; CHECK-LABEL: test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmpb $0, 4(%eax)
; CHECK-NEXT:    je .LBB0_1
; CHECK-NEXT:  # %bb.2: # %F
; CHECK-NEXT:    movb 7(%eax), %al
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB0_1: # %TB
; CHECK-NEXT:    movb $4, %al
; CHECK-NEXT:    retl
  %Q = getelementptr i32, i32* %P, i32 1
  %R = bitcast i32* %Q to i8*
  %S = load i8, i8* %R
  %T = icmp eq i8 %S, 0
  br i1 %T, label %TB, label %F
TB:
  ret i8 4
F:
  %U = getelementptr i8, i8* %R, i32 3
  %V = load i8, i8* %U
  ret i8 %V
}
