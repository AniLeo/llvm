; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=+sse2 | FileCheck %s
define i32 @t() nounwind  {
; CHECK-LABEL: t:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    andl $-16, %esp
; CHECK-NEXT:    subl $48, %esp
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [10,11,12,13]
; CHECK-NEXT:    movaps %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $1, (%esp)
; CHECK-NEXT:    calll foo
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movl %ebp, %esp
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
entry:
	tail call void (i32, ...) @foo( i32 1, <4 x i32> < i32 10, i32 11, i32 12, i32 13 > ) nounwind
	ret i32 0
}

declare void @foo(i32, ...)
