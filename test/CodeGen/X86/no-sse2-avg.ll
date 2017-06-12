; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; REQUIRES: asserts
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=-sse2 | FileCheck %s

define <16 x i8> @PR27973() {
; CHECK-LABEL: PR27973:
; CHECK:       # BB#0:
; CHECK-NEXT:    movb $0, 15(%rdi)
; CHECK-NEXT:    movb $0, 14(%rdi)
; CHECK-NEXT:    movb $0, 13(%rdi)
; CHECK-NEXT:    movb $0, 12(%rdi)
; CHECK-NEXT:    movb $0, 11(%rdi)
; CHECK-NEXT:    movb $0, 10(%rdi)
; CHECK-NEXT:    movb $0, 9(%rdi)
; CHECK-NEXT:    movb $0, 8(%rdi)
; CHECK-NEXT:    movb $0, 7(%rdi)
; CHECK-NEXT:    movb $0, 6(%rdi)
; CHECK-NEXT:    movb $0, 5(%rdi)
; CHECK-NEXT:    movb $0, 4(%rdi)
; CHECK-NEXT:    movb $0, 3(%rdi)
; CHECK-NEXT:    movb $0, 2(%rdi)
; CHECK-NEXT:    movb $0, 1(%rdi)
; CHECK-NEXT:    movb $0, (%rdi)
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = zext <16 x i8> zeroinitializer to <16 x i32>
  %t1 = add nuw nsw <16 x i32> %t0, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %t2 = lshr <16 x i32> %t1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %t3 = trunc <16 x i32> %t2 to <16 x i8>
  ret <16 x i8> %t3
}
