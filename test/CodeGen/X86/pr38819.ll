; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse,-sse2,-x87 | FileCheck %s

define void @foo(i64 %x, ptr %b) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    .cfi_offset %esi, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK-NEXT:    calll __floatdisf
; CHECK-NEXT:    addl $8, %esp
; CHECK-NEXT:    .cfi_adjust_cfa_offset -8
; CHECK-NEXT:    movl %eax, (%esi)
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
  %conv = sitofp i64 %x to float
  store float %conv, ptr %b
  ret void
}
