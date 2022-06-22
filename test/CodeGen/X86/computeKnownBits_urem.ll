; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-linux | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefix=X64

define i32 @main() nounwind {
; X86-LABEL: main:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %eax
; X86-NEXT:    movl $1, (%esp)
; X86-NEXT:    movl $1, %eax
; X86-NEXT:    popl %ecx
; X86-NEXT:    retl
;
; X64-LABEL: main:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl $1, -{{[0-9]+}}(%rsp)
; X64-NEXT:    movl $1, %eax
; X64-NEXT:    retq
entry:
  %a = alloca i32, align 4
  store i32 1, ptr %a, align 4
  %0 = load i32, ptr %a, align 4
  %or = or i32 1, %0
  %and = and i32 1, %or
  %rem = urem i32 %and, 1
  %add = add i32 %rem, 1
  ret i32 %add
}
