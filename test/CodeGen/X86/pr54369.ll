; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-- -O0 < %s | FileCheck %s

define i64 @adder(i64 %lhs, i64 %rhs) {
; CHECK-LABEL: adder:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rsi, %rdi
; CHECK-NEXT:    seto %dl
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    # kill: def $rax killed $eax
; CHECK-NEXT:    movl $148, %ecx
; CHECK-NEXT:    testb $1, %dl
; CHECK-NEXT:    cmovneq %rcx, %rax
; CHECK-NEXT:    retq
	%res = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %lhs, i64 %rhs)
	%errorbit = extractvalue { i64, i1 } %res, 1
	%errorval = select i1 %errorbit, i64 148, i64 0
	ret i64 %errorval
}

@a = global i32 0, align 4

define i64 @adder_constexpr(i64 %lhs, i64 %rhs) {
; CHECK-LABEL: adder_constexpr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addq %rsi, %rdi
; CHECK-NEXT:    seto %dl
; CHECK-NEXT:    movq a@GOTPCREL(%rip), %rax
; CHECK-NEXT:    addq $5, %rax
; CHECK-NEXT:    movl $148, %ecx
; CHECK-NEXT:    testb $1, %dl
; CHECK-NEXT:    cmovneq %rcx, %rax
; CHECK-NEXT:    retq
  %res = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %lhs, i64 %rhs)
  %errorbit = extractvalue { i64, i1 } %res, 1
  %errorval = select i1 %errorbit, i64 148, i64 add (i64 ptrtoint (ptr @a to i64), i64 5)
  ret i64 %errorval
}

declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %a, i64 %b)
