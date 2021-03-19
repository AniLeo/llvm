; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefix=X64

; Verify expansion by using constant values. We just want to cover all the paths layed out by ExpandIntRes_MULFIX.

declare  i4  @llvm.smul.fix.sat.i4   (i4,  i4, i32)
declare  i32 @llvm.smul.fix.sat.i32  (i32, i32, i32)
declare  i64 @llvm.smul.fix.sat.i64  (i64, i64, i32)
declare  <4 x i32> @llvm.smul.fix.sat.v4i32(<4 x i32>, <4 x i32>, i32)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64)

define i64 @func() nounwind {
; X64-LABEL: func:
; X64:       # %bb.0:
; X64-NEXT:    movl $2, %ecx
; X64-NEXT:    movl $3, %eax
; X64-NEXT:    imulq %rcx
; X64-NEXT:    cmpq $1, %rdx
; X64-NEXT:    movabsq $9223372036854775807, %rax # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    movl $1, %ecx
; X64-NEXT:    cmovgq %rax, %rcx
; X64-NEXT:    cmpq $-2, %rdx
; X64-NEXT:    movabsq $-9223372036854775808, %rax # imm = 0x8000000000000000
; X64-NEXT:    cmovgeq %rcx, %rax
; X64-NEXT:    retq
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 3, i64 2, i32 2)
  ret i64 %tmp
}

define i64 @func2() nounwind {
; X64-LABEL: func2:
; X64:       # %bb.0:
; X64-NEXT:    movl $3, %eax
; X64-NEXT:    imulq $2, %rax, %rcx
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    testq %rcx, %rcx
; X64-NEXT:    setns %dl
; X64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    addq %rdx, %rcx
; X64-NEXT:    imulq $2, %rax, %rax
; X64-NEXT:    cmovoq %rcx, %rax
; X64-NEXT:    retq
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 3, i64 2, i32 0)
  ret i64 %tmp
}

define i64 @func3() nounwind {
; X64-LABEL: func3:
; X64:       # %bb.0:
; X64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    movl $2, %edx
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    imulq %rdx
; X64-NEXT:    cmpq $1, %rdx
; X64-NEXT:    movabsq $4611686018427387903, %rsi # imm = 0x3FFFFFFFFFFFFFFF
; X64-NEXT:    cmovgq %rcx, %rsi
; X64-NEXT:    cmpq $-2, %rdx
; X64-NEXT:    movabsq $-9223372036854775808, %rax # imm = 0x8000000000000000
; X64-NEXT:    cmovgeq %rsi, %rax
; X64-NEXT:    retq
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 9223372036854775807, i64 2, i32 2)
  ret i64 %tmp
}

define i64 @func4() nounwind {
; X64-LABEL: func4:
; X64:       # %bb.0:
; X64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    movl $2, %edx
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    imulq %rdx
; X64-NEXT:    cmpq $2147483647, %rdx # imm = 0x7FFFFFFF
; X64-NEXT:    movl $4294967295, %esi # imm = 0xFFFFFFFF
; X64-NEXT:    cmovgq %rcx, %rsi
; X64-NEXT:    cmpq $-2147483648, %rdx # imm = 0x80000000
; X64-NEXT:    movabsq $-9223372036854775808, %rax # imm = 0x8000000000000000
; X64-NEXT:    cmovgeq %rsi, %rax
; X64-NEXT:    retq
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 9223372036854775807, i64 2, i32 32)
  ret i64 %tmp
}

define i64 @func5() nounwind {
; X64-LABEL: func5:
; X64:       # %bb.0:
; X64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; X64-NEXT:    movl $2, %edx
; X64-NEXT:    movq %rcx, %rax
; X64-NEXT:    imulq %rdx
; X64-NEXT:    movabsq $4611686018427387903, %rax # imm = 0x3FFFFFFFFFFFFFFF
; X64-NEXT:    cmpq %rax, %rdx
; X64-NEXT:    movl $1, %esi
; X64-NEXT:    cmovgq %rcx, %rsi
; X64-NEXT:    movabsq $-4611686018427387904, %rax # imm = 0xC000000000000000
; X64-NEXT:    cmpq %rax, %rdx
; X64-NEXT:    movabsq $-9223372036854775808, %rax # imm = 0x8000000000000000
; X64-NEXT:    cmovgeq %rsi, %rax
; X64-NEXT:    retq
  %tmp = call i64 @llvm.smul.fix.sat.i64(i64 9223372036854775807, i64 2, i32 63)
  ret i64 %tmp
}
