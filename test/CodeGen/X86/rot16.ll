; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686--                | FileCheck %s --check-prefixes=X86,X86-BASE
; RUN: llc < %s -mtriple=i686--  -mattr=movbe  | FileCheck %s --check-prefixes=X86,X86-MOVBE
; RUN: llc < %s -mtriple=x86_64--              | FileCheck %s --check-prefixes=X64,X64-BASE
; RUN: llc < %s -mtriple=x86_64-- -mattr=movbe | FileCheck %s --check-prefixes=X64,X64-MOVBE

define i16 @foo(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: foo:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rolw %cl, %ax
; X86-NEXT:    retl
;
; X64-LABEL: foo:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rolw %cl, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = shl i16 %x, %z
	%t1 = sub i16 16, %z
	%t2 = lshr i16 %x, %t1
	%t3 = or i16 %t2, %t0
	ret i16 %t3
}

define i16 @bar(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: bar:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    andb $15, %cl
; X86-NEXT:    shldw %cl, %dx, %ax
; X86-NEXT:    retl
;
; X64-LABEL: bar:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    andb $15, %cl
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shldw %cl, %di, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = shl i16 %y, %z
	%t1 = sub i16 16, %z
	%t2 = lshr i16 %x, %t1
	%t3 = or i16 %t2, %t0
	ret i16 %t3
}

define i16 @un(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: un:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rorw %cl, %ax
; X86-NEXT:    retl
;
; X64-LABEL: un:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rorw %cl, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = lshr i16 %x, %z
	%t1 = sub i16 16, %z
	%t2 = shl i16 %x, %t1
	%t3 = or i16 %t2, %t0
	ret i16 %t3
}

define i16 @bu(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: bu:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    andb $15, %cl
; X86-NEXT:    shrdw %cl, %dx, %ax
; X86-NEXT:    retl
;
; X64-LABEL: bu:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    andb $15, %cl
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrdw %cl, %di, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = lshr i16 %y, %z
	%t1 = sub i16 16, %z
	%t2 = shl i16 %x, %t1
	%t3 = or i16 %t2, %t0
	ret i16 %t3
}

define i16 @xfoo(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: xfoo:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rolw $5, %ax
; X86-NEXT:    retl
;
; X64-LABEL: xfoo:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    rolw $5, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = lshr i16 %x, 11
	%t1 = shl i16 %x, 5
	%t2 = or i16 %t0, %t1
	ret i16 %t2
}

define i16 @xbar(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: xbar:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldw $5, %cx, %ax
; X86-NEXT:    retl
;
; X64-LABEL: xbar:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    shldw $5, %di, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = shl i16 %y, 5
	%t1 = lshr i16 %x, 11
	%t2 = or i16 %t0, %t1
	ret i16 %t2
}

define i16 @xun(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: xun:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rolw $11, %ax
; X86-NEXT:    retl
;
; X64-LABEL: xun:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    rolw $11, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = lshr i16 %x, 5
	%t1 = shl i16 %x, 11
	%t2 = or i16 %t0, %t1
	ret i16 %t2
}

define i16 @xbu(i16 %x, i16 %y, i16 %z) nounwind {
; X86-LABEL: xbu:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldw $11, %cx, %ax
; X86-NEXT:    retl
;
; X64-LABEL: xbu:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shldw $11, %si, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = lshr i16 %y, 5
	%t1 = shl i16 %x, 11
	%t2 = or i16 %t0, %t1
	ret i16 %t2
}

define i32 @rot16_demandedbits(i32 %x, i32 %y) nounwind {
; X86-LABEL: rot16_demandedbits:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    shrl $11, %ecx
; X86-NEXT:    shll $5, %eax
; X86-NEXT:    orl %ecx, %eax
; X86-NEXT:    movzwl %ax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: rot16_demandedbits:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $11, %eax
; X64-NEXT:    shll $5, %edi
; X64-NEXT:    orl %eax, %edi
; X64-NEXT:    movzwl %di, %eax
; X64-NEXT:    retq
	%t0 = lshr i32 %x, 11
	%t1 = shl i32 %x, 5
	%t2 = or i32 %t0, %t1
	%t3 = and i32 %t2, 65535
	ret i32 %t3
}

define i16 @rot16_trunc(i32 %x, i32 %y) nounwind {
; X86-LABEL: rot16_trunc:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    shrl $11, %ecx
; X86-NEXT:    shll $5, %eax
; X86-NEXT:    orl %ecx, %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: rot16_trunc:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    shrl $11, %ecx
; X64-NEXT:    shll $5, %eax
; X64-NEXT:    orl %ecx, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
	%t0 = lshr i32 %x, 11
	%t1 = shl i32 %x, 5
	%t2 = or i32 %t0, %t1
	%t3 = trunc i32 %t2 to i16
	ret i16 %t3
}

define i16 @rotate16(i16 %x) {
; X86-BASE-LABEL: rotate16:
; X86-BASE:       # %bb.0:
; X86-BASE-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-BASE-NEXT:    rolw $8, %ax
; X86-BASE-NEXT:    retl
;
; X86-MOVBE-LABEL: rotate16:
; X86-MOVBE:       # %bb.0:
; X86-MOVBE-NEXT:    movbew {{[0-9]+}}(%esp), %ax
; X86-MOVBE-NEXT:    retl
;
; X64-LABEL: rotate16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    rolw $8, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %r = call i16 @llvm.fshl.i16(i16 %x, i16 %x, i16 8)
  ret i16 %r
}

; TODO: Should this always be rolw with memory operand?

define void @rotate16_in_place_memory(i8* %p) {
; X86-BASE-LABEL: rotate16_in_place_memory:
; X86-BASE:       # %bb.0:
; X86-BASE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-BASE-NEXT:    rolw $8, (%eax)
; X86-BASE-NEXT:    retl
;
; X86-MOVBE-LABEL: rotate16_in_place_memory:
; X86-MOVBE:       # %bb.0:
; X86-MOVBE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MOVBE-NEXT:    movzwl (%eax), %ecx
; X86-MOVBE-NEXT:    movbew %cx, (%eax)
; X86-MOVBE-NEXT:    retl
;
; X64-BASE-LABEL: rotate16_in_place_memory:
; X64-BASE:       # %bb.0:
; X64-BASE-NEXT:    rolw $8, (%rdi)
; X64-BASE-NEXT:    retq
;
; X64-MOVBE-LABEL: rotate16_in_place_memory:
; X64-MOVBE:       # %bb.0:
; X64-MOVBE-NEXT:    movzwl (%rdi), %eax
; X64-MOVBE-NEXT:    movbew %ax, (%rdi)
; X64-MOVBE-NEXT:    retq
  %p0 = getelementptr i8, i8* %p, i64 0
  %p1 = getelementptr i8, i8* %p, i64 1
  %i0 = load i8, i8* %p0, align 1
  %i1 = load i8, i8* %p1, align 1
  store i8 %i1, i8* %p0, align 1
  store i8 %i0, i8* %p1, align 1
  ret void
}

define void @rotate16_memory(i8* %p, i8* %q) {
; X86-BASE-LABEL: rotate16_memory:
; X86-BASE:       # %bb.0:
; X86-BASE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-BASE-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-BASE-NEXT:    movzwl (%ecx), %ecx
; X86-BASE-NEXT:    rolw $8, %cx
; X86-BASE-NEXT:    movw %cx, (%eax)
; X86-BASE-NEXT:    retl
;
; X86-MOVBE-LABEL: rotate16_memory:
; X86-MOVBE:       # %bb.0:
; X86-MOVBE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MOVBE-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-MOVBE-NEXT:    movzwl (%ecx), %ecx
; X86-MOVBE-NEXT:    movbew %cx, (%eax)
; X86-MOVBE-NEXT:    retl
;
; X64-BASE-LABEL: rotate16_memory:
; X64-BASE:       # %bb.0:
; X64-BASE-NEXT:    movzwl (%rdi), %eax
; X64-BASE-NEXT:    rolw $8, %ax
; X64-BASE-NEXT:    movw %ax, (%rsi)
; X64-BASE-NEXT:    retq
;
; X64-MOVBE-LABEL: rotate16_memory:
; X64-MOVBE:       # %bb.0:
; X64-MOVBE-NEXT:    movzwl (%rdi), %eax
; X64-MOVBE-NEXT:    movbew %ax, (%rsi)
; X64-MOVBE-NEXT:    retq
  %p0 = getelementptr i8, i8* %p, i64 0
  %p1 = getelementptr i8, i8* %p, i64 1
  %q0 = getelementptr i8, i8* %q, i64 0
  %q1 = getelementptr i8, i8* %q, i64 1
  %i0 = load i8, i8* %p0, align 1
  %i1 = load i8, i8* %p1, align 1
  store i8 %i1, i8* %q0, align 1
  store i8 %i0, i8* %q1, align 1
  ret void
}

declare i16 @llvm.fshl.i16(i16, i16, i16)
