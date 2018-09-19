; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; REQUIRES: asserts
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=-sse2 | FileCheck %s

define <16 x i8> @PR27973() {
; CHECK-LABEL: PR27973:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movq $0, 8(%rdi)
; CHECK-NEXT:    movq $0, (%rdi)
; CHECK-NEXT:    retq
  %t0 = zext <16 x i8> zeroinitializer to <16 x i32>
  %t1 = add nuw nsw <16 x i32> %t0, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %t2 = lshr <16 x i32> %t1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %t3 = trunc <16 x i32> %t2 to <16 x i8>
  ret <16 x i8> %t3
}
