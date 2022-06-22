; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -O0 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux-muslx32 -O0 | FileCheck %s

define void @foo(ptr %p) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    leal -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    addl $16, %eax
; CHECK-NEXT:    movl %eax, (%edi)
; CHECK-NEXT:    retq
  %a = alloca i32, i32 10
  %addr = getelementptr i32, ptr %a, i32 4
  store ptr %addr, ptr %p
  ret void
}

