; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin | FileCheck %s

@f = external global ptr		; <ptr> [#uses=1]

define i32 @main() nounwind {
; CHECK-LABEL: main:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    subl $12, %esp
; CHECK-NEXT:    movl L_f$non_lazy_ptr, %eax
; CHECK-NEXT:    calll *(%eax)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    addl $12, %esp
; CHECK-NEXT:    retl
entry:
	load ptr, ptr @f, align 8		; <ptr>:0 [#uses=1]
	tail call void %0( ) nounwind
	ret i32 0
}
