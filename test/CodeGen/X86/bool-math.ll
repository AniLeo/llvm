; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define i32 @sub_zext_cmp_mask_same_size_result(i32 %x) {
; CHECK-LABEL: sub_zext_cmp_mask_same_size_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    leal -28(%rdi), %eax
; CHECK-NEXT:    retq
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %z = zext i1 %c to i32
  %r = sub i32 -27, %z
  ret i32 %r
}

define i32 @sub_zext_cmp_mask_wider_result(i8 %x) {
; CHECK-LABEL: sub_zext_cmp_mask_wider_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    leal 26(%rdi), %eax
; CHECK-NEXT:    retq
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %z = zext i1 %c to i32
  %r = sub i32 27, %z
  ret i32 %r
}

define i8 @sub_zext_cmp_mask_narrower_result(i32 %x) {
; CHECK-LABEL: sub_zext_cmp_mask_narrower_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    orb $46, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %z = zext i1 %c to i8
  %r = sub i8 47, %z
  ret i8 %r
}

define i8 @add_zext_cmp_mask_same_size_result(i8 %x) {
; CHECK-LABEL: add_zext_cmp_mask_same_size_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    xorb $27, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %z = zext i1 %c to i8
  %r = add i8 %z, 26
  ret i8 %r
}

define i32 @add_zext_cmp_mask_wider_result(i8 %x) {
; CHECK-LABEL: add_zext_cmp_mask_wider_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    xorl $27, %eax
; CHECK-NEXT:    retq
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %z = zext i1 %c to i32
  %r = add i32 %z, 26
  ret i32 %r
}

define i8 @add_zext_cmp_mask_narrower_result(i32 %x) {
; CHECK-LABEL: add_zext_cmp_mask_narrower_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    xorb $43, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %z = zext i1 %c to i8
  %r = add i8 %z, 42
  ret i8 %r
}

define i32 @low_bit_select_constants_bigger_false_same_size_result(i32 %x) {
; CHECK-LABEL: low_bit_select_constants_bigger_false_same_size_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    leal 42(%rdi), %eax
; CHECK-NEXT:    retq
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %r = select i1 %c, i32 42, i32 43
  ret i32 %r
}

define i64 @low_bit_select_constants_bigger_false_wider_result(i32 %x) {
; CHECK-LABEL: low_bit_select_constants_bigger_false_wider_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    leaq 26(%rdi), %rax
; CHECK-NEXT:    retq
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %r = select i1 %c, i64 26, i64 27
  ret i64 %r
}

define i16 @low_bit_select_constants_bigger_false_narrower_result(i32 %x) {
; CHECK-LABEL: low_bit_select_constants_bigger_false_narrower_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %edi
; CHECK-NEXT:    leal 36(%rdi), %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
  %a = and i32 %x, 1
  %c = icmp eq i32 %a, 0
  %r = select i1 %c, i16 36, i16 37
  ret i16 %r
}

define i8 @low_bit_select_constants_bigger_true_same_size_result(i8 %x) {
; CHECK-LABEL: low_bit_select_constants_bigger_true_same_size_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    xorb $-29, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %r = select i1 %c, i8 227, i8 226
  ret i8 %r
}

define i32 @low_bit_select_constants_bigger_true_wider_result(i8 %x) {
; CHECK-LABEL: low_bit_select_constants_bigger_true_wider_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    xorl $227, %eax
; CHECK-NEXT:    retq
  %a = and i8 %x, 1
  %c = icmp eq i8 %a, 0
  %r = select i1 %c, i32 227, i32 226
  ret i32 %r
}

define i8 @low_bit_select_constants_bigger_true_narrower_result(i16 %x) {
; CHECK-LABEL: low_bit_select_constants_bigger_true_narrower_result:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    xorb $41, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %a = and i16 %x, 1
  %c = icmp eq i16 %a, 0
  %r = select i1 %c, i8 41, i8 40
  ret i8 %r
}

