; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686--   | FileCheck %s --check-prefix=X32

define i32 @sub_zext_cmp_mask_same_size_result(i32 %x) {
; X64-LABEL: sub_zext_cmp_mask_same_size_result:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    andl $1, %edi
; X64-NEXT:    leal -28(%rdi), %eax
; X64-NEXT:    retq
;
; X32-LABEL: sub_zext_cmp_mask_same_size_result:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    orl $-28, %eax
; X32-NEXT:    retl
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %z = zext i1 %c to i32
  %r = sub i32 -27, %z
  ret i32 %r
}

define i32 @sub_zext_cmp_mask_wider_result(i8 %x) {
; X64-LABEL: sub_zext_cmp_mask_wider_result:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    andl $1, %edi
; X64-NEXT:    leal 26(%rdi), %eax
; X64-NEXT:    retq
;
; X32-LABEL: sub_zext_cmp_mask_wider_result:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    orl $26, %eax
; X32-NEXT:    retl
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %z = zext i1 %c to i32
  %r = sub i32 27, %z
  ret i32 %r
}

define i8 @sub_zext_cmp_mask_narrower_result(i32 %x) {
; X64-LABEL: sub_zext_cmp_mask_narrower_result:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    andb $1, %dil
; X64-NEXT:    leal 46(%rdi), %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X32-LABEL: sub_zext_cmp_mask_narrower_result:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    andb $1, %al
; X32-NEXT:    orb $46, %al
; X32-NEXT:    retl
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %z = zext i1 %c to i8
  %r = sub i8 47, %z
  ret i8 %r
}

define i8 @add_zext_cmp_mask_same_size_result(i8 %x) {
; X64-LABEL: add_zext_cmp_mask_same_size_result:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $1, %al
; X64-NEXT:    xorb $27, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X32-LABEL: add_zext_cmp_mask_same_size_result:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    andb $1, %al
; X32-NEXT:    xorb $27, %al
; X32-NEXT:    retl
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %z = zext i1 %c to i8
  %r = add i8 %z, 26
  ret i8 %r
}

define i32 @add_zext_cmp_mask_wider_result(i8 %x) {
; X64-LABEL: add_zext_cmp_mask_wider_result:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $1, %eax
; X64-NEXT:    xorl $27, %eax
; X64-NEXT:    retq
;
; X32-LABEL: add_zext_cmp_mask_wider_result:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    xorl $27, %eax
; X32-NEXT:    retl
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %z = zext i1 %c to i32
  %r = add i32 %z, 26
  ret i32 %r
}

define i8 @add_zext_cmp_mask_narrower_result(i32 %x) {
; X64-LABEL: add_zext_cmp_mask_narrower_result:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $1, %al
; X64-NEXT:    xorb $43, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X32-LABEL: add_zext_cmp_mask_narrower_result:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    andb $1, %al
; X32-NEXT:    xorb $43, %al
; X32-NEXT:    retl
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %z = zext i1 %c to i8
  %r = add i8 %z, 42
  ret i8 %r
}

define i32 @low_bit_select_constants_bigger_false_same_size_result(i32 %x) {
; X64-LABEL: low_bit_select_constants_bigger_false_same_size_result:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    andl $1, %edi
; X64-NEXT:    leal 42(%rdi), %eax
; X64-NEXT:    retq
;
; X32-LABEL: low_bit_select_constants_bigger_false_same_size_result:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    orl $42, %eax
; X32-NEXT:    retl
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %r = select i1 %c, i32 42, i32 43
  ret i32 %r
}

define i64 @low_bit_select_constants_bigger_false_wider_result(i32 %x) {
; X64-LABEL: low_bit_select_constants_bigger_false_wider_result:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    andl $1, %edi
; X64-NEXT:    leaq 26(%rdi), %rax
; X64-NEXT:    retq
;
; X32-LABEL: low_bit_select_constants_bigger_false_wider_result:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    orl $26, %eax
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    retl
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %r = select i1 %c, i64 26, i64 27
  ret i64 %r
}

define i16 @low_bit_select_constants_bigger_false_narrower_result(i32 %x) {
; X64-LABEL: low_bit_select_constants_bigger_false_narrower_result:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    andl $1, %edi
; X64-NEXT:    leal 36(%rdi), %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X32-LABEL: low_bit_select_constants_bigger_false_narrower_result:
; X32:       # %bb.0:
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    orl $36, %eax
; X32-NEXT:    # kill: def $ax killed $ax killed $eax
; X32-NEXT:    retl
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %r = select i1 %c, i16 36, i16 37
  ret i16 %r
}

define i8 @low_bit_select_constants_bigger_true_same_size_result(i8 %x) {
; X64-LABEL: low_bit_select_constants_bigger_true_same_size_result:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $1, %al
; X64-NEXT:    xorb $-29, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X32-LABEL: low_bit_select_constants_bigger_true_same_size_result:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    andb $1, %al
; X32-NEXT:    xorb $-29, %al
; X32-NEXT:    retl
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %r = select i1 %c, i8 227, i8 226
  ret i8 %r
}

define i32 @low_bit_select_constants_bigger_true_wider_result(i8 %x) {
; X64-LABEL: low_bit_select_constants_bigger_true_wider_result:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $1, %eax
; X64-NEXT:    xorl $227, %eax
; X64-NEXT:    retq
;
; X32-LABEL: low_bit_select_constants_bigger_true_wider_result:
; X32:       # %bb.0:
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    xorl $227, %eax
; X32-NEXT:    retl
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %r = select i1 %c, i32 227, i32 226
  ret i32 %r
}

define i8 @low_bit_select_constants_bigger_true_narrower_result(i16 %x) {
; X64-LABEL: low_bit_select_constants_bigger_true_narrower_result:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $1, %al
; X64-NEXT:    xorb $41, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X32-LABEL: low_bit_select_constants_bigger_true_narrower_result:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    andb $1, %al
; X32-NEXT:    xorb $41, %al
; X32-NEXT:    retl
  %a = and i16 %x, 1
  %c = icmp eq i16 %a, 0
  %r = select i1 %c, i8 41, i8 40
  ret i8 %r
}

; Truncation hoisting must not occur with opaque constants
; because that can induce infinite looping.

define i1 @opaque_constant(i48 %x, i48 %y) {
; X64-LABEL: opaque_constant:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rax
; X64-NEXT:    shrq $32, %rdi
; X64-NEXT:    shrq $32, %rax
; X64-NEXT:    xorl %edi, %eax
; X64-NEXT:    andl $1, %eax
; X64-NEXT:    # kill: def $al killed $al killed $rax
; X64-NEXT:    retq
;
; X32-LABEL: opaque_constant:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $1, %eax
; X32-NEXT:    # kill: def $al killed $al killed $eax
; X32-NEXT:    retl
  %andx = and i48 %x, 4294967296
  %andy = and i48 %y, 4294967296
  %cmp1 = icmp ne i48 %andx, 0
  %cmp2 = icmp ne i48 %andy, 0
  %r = xor i1 %cmp1, %cmp2
  ret i1 %r
}

