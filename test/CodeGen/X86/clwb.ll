; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=clwb | FileCheck %s

define void @clwb(i8* %p) nounwind {
; CHECK-LABEL: clwb:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    clwb (%eax)
; CHECK-NEXT:    retl
  tail call void @llvm.x86.clwb(i8* %p)
  ret void
}
declare void @llvm.x86.clwb(i8*) nounwind
