; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=CHECK,NOBMI
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+bmi | FileCheck %s --check-prefixes=CHECK,BMI

; InstCombine and DAGCombiner transform an 'add' into an 'or'
; if there are no common bits from the incoming operands.
; LEA instruction selection should be able to see through that
; transform and reduce add/shift/or instruction counts.

define i32 @or_shift1_and1(i32 %x, i32 %y) {
; CHECK-LABEL: or_shift1_and1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %esi
; CHECK-NEXT:    leal (%rsi,%rdi,2), %eax
; CHECK-NEXT:    retq

  %shl = shl i32 %x, 1
  %and = and i32 %y, 1
  %or = or i32 %and, %shl
  ret i32 %or
}

define i32 @or_shift1_and1_swapped(i32 %x, i32 %y) {
; CHECK-LABEL: or_shift1_and1_swapped:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %esi
; CHECK-NEXT:    leal (%rsi,%rdi,2), %eax
; CHECK-NEXT:    retq

  %shl = shl i32 %x, 1
  %and = and i32 %y, 1
  %or = or i32 %shl, %and
  ret i32 %or
}

define i32 @or_shift2_and1(i32 %x, i32 %y) {
; CHECK-LABEL: or_shift2_and1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %esi
; CHECK-NEXT:    leal (%rsi,%rdi,4), %eax
; CHECK-NEXT:    retq

  %shl = shl i32 %x, 2
  %and = and i32 %y, 1
  %or = or i32 %shl, %and
  ret i32 %or
}

define i32 @or_shift3_and1(i32 %x, i32 %y) {
; CHECK-LABEL: or_shift3_and1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $1, %esi
; CHECK-NEXT:    leal (%rsi,%rdi,8), %eax
; CHECK-NEXT:    retq

  %shl = shl i32 %x, 3
  %and = and i32 %y, 1
  %or = or i32 %shl, %and
  ret i32 %or
}

define i32 @or_shift3_and7(i32 %x, i32 %y) {
; CHECK-LABEL: or_shift3_and7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    andl $7, %esi
; CHECK-NEXT:    leal (%rsi,%rdi,8), %eax
; CHECK-NEXT:    retq

  %shl = shl i32 %x, 3
  %and = and i32 %y, 7
  %or = or i32 %shl, %and
  ret i32 %or
}

; The shift is too big for an LEA.

define i32 @or_shift4_and1(i32 %x, i32 %y) {
; CHECK-LABEL: or_shift4_and1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    shll $4, %edi
; CHECK-NEXT:    andl $1, %esi
; CHECK-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-NEXT:    retq

  %shl = shl i32 %x, 4
  %and = and i32 %y, 1
  %or = or i32 %shl, %and
  ret i32 %or
}

; The mask is too big for the shift, so the 'or' isn't equivalent to an 'add'.

define i32 @or_shift3_and8(i32 %x, i32 %y) {
; CHECK-LABEL: or_shift3_and8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    leal (,%rdi,8), %eax
; CHECK-NEXT:    andl $8, %esi
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    retq

  %shl = shl i32 %x, 3
  %and = and i32 %y, 8
  %or = or i32 %shl, %and
  ret i32 %or
}

; 64-bit operands should work too.

define i64 @or_shift1_and1_64(i64 %x, i64 %y) {
; CHECK-LABEL: or_shift1_and1_64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andl $1, %esi
; CHECK-NEXT:    leaq (%rsi,%rdi,2), %rax
; CHECK-NEXT:    retq

  %shl = shl i64 %x, 1
  %and = and i64 %y, 1
  %or = or i64 %and, %shl
  ret i64 %or
}

; In the following patterns, lhs and rhs of the or instruction have no common bits.

define i32 @or_and_and_rhs_neg_i32(i32 %x, i32 %y, i32 %z) {
; NOBMI-LABEL: or_and_and_rhs_neg_i32:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    # kill: def $esi killed $esi def $rsi
; NOBMI-NEXT:    andl %esi, %edx
; NOBMI-NEXT:    notl %esi
; NOBMI-NEXT:    andl %edi, %esi
; NOBMI-NEXT:    orl %edx, %esi
; NOBMI-NEXT:    leal 1(%rsi), %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_and_rhs_neg_i32:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andl %esi, %edx
; BMI-NEXT:    andnl %edi, %esi, %eax
; BMI-NEXT:    orl %edx, %eax
; BMI-NEXT:    incl %eax
; BMI-NEXT:    retq
entry:
  %and1 = and i32 %z, %y
  %xor = xor i32 %y, -1
  %and2 = and i32 %x, %xor
  %or = or i32 %and1, %and2
  %inc = add i32 %or, 1
  ret i32 %inc
}

define i32 @or_and_and_lhs_neg_i32(i32 %x, i32 %y, i32 %z) {
; NOBMI-LABEL: or_and_and_lhs_neg_i32:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    # kill: def $esi killed $esi def $rsi
; NOBMI-NEXT:    andl %esi, %edx
; NOBMI-NEXT:    notl %esi
; NOBMI-NEXT:    andl %edi, %esi
; NOBMI-NEXT:    orl %edx, %esi
; NOBMI-NEXT:    leal 1(%rsi), %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_and_lhs_neg_i32:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andl %esi, %edx
; BMI-NEXT:    andnl %edi, %esi, %eax
; BMI-NEXT:    orl %edx, %eax
; BMI-NEXT:    incl %eax
; BMI-NEXT:    retq
entry:
  %and1 = and i32 %z, %y
  %xor = xor i32 %y, -1
  %and2 = and i32 %xor, %x
  %or = or i32 %and1, %and2
  %inc = add i32 %or, 1
  ret i32 %inc
}

define i32 @or_and_rhs_neg_and_i32(i32 %x, i32 %y, i32 %z) {
; NOBMI-LABEL: or_and_rhs_neg_and_i32:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    # kill: def $esi killed $esi def $rsi
; NOBMI-NEXT:    andl %esi, %edi
; NOBMI-NEXT:    notl %esi
; NOBMI-NEXT:    andl %edx, %esi
; NOBMI-NEXT:    orl %edi, %esi
; NOBMI-NEXT:    leal 1(%rsi), %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_rhs_neg_and_i32:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andnl %edx, %esi, %eax
; BMI-NEXT:    andl %esi, %edi
; BMI-NEXT:    orl %edi, %eax
; BMI-NEXT:    incl %eax
; BMI-NEXT:    retq
entry:
  %xor = xor i32 %y, -1
  %and1 = and i32 %z, %xor
  %and2 = and i32 %x, %y
  %or = or i32 %and1, %and2
  %inc = add i32 %or, 1
  ret i32 %inc
}

define i32 @or_and_lhs_neg_and_i32(i32 %x, i32 %y, i32 %z) {
; NOBMI-LABEL: or_and_lhs_neg_and_i32:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    # kill: def $esi killed $esi def $rsi
; NOBMI-NEXT:    andl %esi, %edi
; NOBMI-NEXT:    notl %esi
; NOBMI-NEXT:    andl %edx, %esi
; NOBMI-NEXT:    orl %edi, %esi
; NOBMI-NEXT:    leal 1(%rsi), %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_lhs_neg_and_i32:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andnl %edx, %esi, %eax
; BMI-NEXT:    andl %esi, %edi
; BMI-NEXT:    orl %edi, %eax
; BMI-NEXT:    incl %eax
; BMI-NEXT:    retq
entry:
  %xor = xor i32 %y, -1
  %and1 = and i32 %xor, %z
  %and2 = and i32 %x, %y
  %or = or i32 %and1, %and2
  %inc = add i32 %or, 1
  ret i32 %inc
}

define i64 @or_and_and_rhs_neg_i64(i64 %x, i64 %y, i64 %z) {
; NOBMI-LABEL: or_and_and_rhs_neg_i64:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    andq %rsi, %rdx
; NOBMI-NEXT:    notq %rsi
; NOBMI-NEXT:    andq %rdi, %rsi
; NOBMI-NEXT:    orq %rdx, %rsi
; NOBMI-NEXT:    leaq 1(%rsi), %rax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_and_rhs_neg_i64:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andq %rsi, %rdx
; BMI-NEXT:    andnq %rdi, %rsi, %rax
; BMI-NEXT:    orq %rdx, %rax
; BMI-NEXT:    incq %rax
; BMI-NEXT:    retq
entry:
  %and1 = and i64 %z, %y
  %xor = xor i64 %y, -1
  %and2 = and i64 %x, %xor
  %or = or i64 %and1, %and2
  %inc = add i64 %or, 1
  ret i64 %inc
}

define i64 @or_and_and_lhs_neg_i64(i64 %x, i64 %y, i64 %z) {
; NOBMI-LABEL: or_and_and_lhs_neg_i64:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    andq %rsi, %rdx
; NOBMI-NEXT:    notq %rsi
; NOBMI-NEXT:    andq %rdi, %rsi
; NOBMI-NEXT:    orq %rdx, %rsi
; NOBMI-NEXT:    leaq 1(%rsi), %rax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_and_lhs_neg_i64:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andq %rsi, %rdx
; BMI-NEXT:    andnq %rdi, %rsi, %rax
; BMI-NEXT:    orq %rdx, %rax
; BMI-NEXT:    incq %rax
; BMI-NEXT:    retq
entry:
  %and1 = and i64 %z, %y
  %xor = xor i64 %y, -1
  %and2 = and i64 %xor, %x
  %or = or i64 %and1, %and2
  %inc = add i64 %or, 1
  ret i64 %inc
}

define i64 @or_and_rhs_neg_and_i64(i64 %x, i64 %y, i64 %z) {
; NOBMI-LABEL: or_and_rhs_neg_and_i64:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    andq %rsi, %rdi
; NOBMI-NEXT:    notq %rsi
; NOBMI-NEXT:    andq %rdx, %rsi
; NOBMI-NEXT:    orq %rdi, %rsi
; NOBMI-NEXT:    leaq 1(%rsi), %rax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_rhs_neg_and_i64:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andnq %rdx, %rsi, %rax
; BMI-NEXT:    andq %rsi, %rdi
; BMI-NEXT:    orq %rdi, %rax
; BMI-NEXT:    incq %rax
; BMI-NEXT:    retq
entry:
  %xor = xor i64 %y, -1
  %and1 = and i64 %z, %xor
  %and2 = and i64 %x, %y
  %or = or i64 %and1, %and2
  %inc = add i64 %or, 1
  ret i64 %inc
}

define i64 @or_and_lhs_neg_and_i64(i64 %x, i64 %y, i64 %z) {
; NOBMI-LABEL: or_and_lhs_neg_and_i64:
; NOBMI:       # %bb.0: # %entry
; NOBMI-NEXT:    andq %rsi, %rdi
; NOBMI-NEXT:    notq %rsi
; NOBMI-NEXT:    andq %rdx, %rsi
; NOBMI-NEXT:    orq %rdi, %rsi
; NOBMI-NEXT:    leaq 1(%rsi), %rax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: or_and_lhs_neg_and_i64:
; BMI:       # %bb.0: # %entry
; BMI-NEXT:    andnq %rdx, %rsi, %rax
; BMI-NEXT:    andq %rsi, %rdi
; BMI-NEXT:    orq %rdi, %rax
; BMI-NEXT:    incq %rax
; BMI-NEXT:    retq
entry:
  %xor = xor i64 %y, -1
  %and1 = and i64 %xor, %z
  %and2 = and i64 %x, %y
  %or = or i64 %and1, %and2
  %inc = add i64 %or, 1
  ret i64 %inc
}
