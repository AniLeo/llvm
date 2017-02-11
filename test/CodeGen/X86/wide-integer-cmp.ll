; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-linux-gnu %s -o - | FileCheck %s


define i32 @branch_eq(i64 %a, i64 %b) {
; CHECK-LABEL: branch_eq:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB0_2: # %bb2
; CHECK-NEXT:    movl $2, %eax
; CHECK-NEXT:    retl
entry:
  %cmp = icmp eq i64 %a, %b
	br i1 %cmp, label %bb1, label %bb2
bb1:
  ret i32 1
bb2:
  ret i32 2
}

define i32 @branch_slt(i64 %a, i64 %b) {
; CHECK-LABEL: branch_slt:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    sbbl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    jge .LBB1_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB1_2: # %bb2
; CHECK-NEXT:    movl $2, %eax
; CHECK-NEXT:    retl
entry:
  %cmp = icmp slt i64 %a, %b
	br i1 %cmp, label %bb1, label %bb2
bb1:
  ret i32 1
bb2:
  ret i32 2
}

define i32 @branch_ule(i64 %a, i64 %b) {
; CHECK-LABEL: branch_ule:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    sbbl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    jb .LBB2_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB2_2: # %bb2
; CHECK-NEXT:    movl $2, %eax
; CHECK-NEXT:    retl
entry:
  %cmp = icmp ule i64 %a, %b
	br i1 %cmp, label %bb1, label %bb2
bb1:
  ret i32 1
bb2:
  ret i32 2
}

define i32 @set_gt(i64 %a, i64 %b) {
; CHECK-LABEL: set_gt:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    sbbl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    setl %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    retl
entry:
  %cmp = icmp sgt i64 %a, %b
  %res = select i1 %cmp, i32 1, i32 0
  ret i32 %res
}

define i32 @test_wide(i128 %a, i128 %b) {
; CHECK-LABEL: test_wide:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:  .Lcfi0:
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:  .Lcfi1:
; CHECK-NEXT:    .cfi_offset %esi, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    cmpl {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    sbbl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    sbbl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    sbbl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    jge .LBB4_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB4_2: # %bb2
; CHECK-NEXT:    movl $2, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
entry:
  %cmp = icmp slt i128 %a, %b
	br i1 %cmp, label %bb1, label %bb2
bb1:
  ret i32 1
bb2:
  ret i32 2
}

; The comparison of the low bits will be folded to a CARRY_FALSE node. Make
; sure the code can handle that.
define i32 @test_carry_false(i64 %a, i64 %b) {
; CHECK-LABEL: test_carry_false:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    jge .LBB5_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB5_2: # %bb2
; CHECK-NEXT:    movl $2, %eax
; CHECK-NEXT:    retl
entry:
  %x = and i64 %a, -4294967296 ;0xffffffff00000000
  %y = and i64 %b, -4294967296
  %cmp = icmp slt i64 %x, %y
	br i1 %cmp, label %bb1, label %bb2
bb1:
  ret i32 1
bb2:
  ret i32 2
}
