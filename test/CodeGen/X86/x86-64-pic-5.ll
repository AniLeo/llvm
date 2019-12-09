; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -relocation-model=pic | FileCheck %s

@a = hidden global i32 0

define i32 @get_a() {
; CHECK-LABEL: get_a:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{.*}}(%rip), %eax
; CHECK-NEXT:    retq
entry:
	%tmp1 = load i32, i32* @a, align 4
	ret i32 %tmp1
}
