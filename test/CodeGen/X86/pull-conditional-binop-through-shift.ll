; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X32

; shift left

define i32 @and_signbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: and_signbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: and_signbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB0_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:  .LBB0_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @and_nosignbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: and_nosignbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: and_nosignbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB1_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:  .LBB1_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @or_signbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: or_signbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    orl $16711680, %eax # imm = 0xFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: or_signbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB2_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    orl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:  .LBB2_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @or_nosignbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: or_nosignbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    orl $16711680, %eax # imm = 0xFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: or_nosignbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB3_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    orl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:  .LBB3_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @xor_signbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: xor_signbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $16711680, %eax # imm = 0xFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: xor_signbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB4_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    xorl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:  .LBB4_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @xor_nosignbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: xor_nosignbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $16711680, %eax # imm = 0xFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: xor_nosignbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB5_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    xorl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:  .LBB5_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @add_signbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: add_signbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal -65536(%rdi), %eax
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: add_signbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB6_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    addl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB6_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @add_nosignbit_select_shl(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: add_nosignbit_select_shl:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 2147418112(%rdi), %eax
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: add_nosignbit_select_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB7_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    addl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB7_2:
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = shl i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

; logical shift right

define i32 @and_signbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: and_signbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: and_signbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB8_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    andl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB8_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @and_nosignbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: and_nosignbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: and_nosignbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB9_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    andl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB9_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @or_signbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: or_signbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    orl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: or_signbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB10_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    orl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB10_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @or_nosignbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: or_nosignbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    orl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: or_nosignbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB11_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    orl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB11_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @xor_signbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: xor_signbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: xor_signbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB12_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    xorl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB12_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @xor_nosignbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: xor_nosignbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: xor_nosignbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB13_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    xorl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB13_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @add_signbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: add_signbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal -65536(%rdi), %eax
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: add_signbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB14_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    addl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB14_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @add_nosignbit_select_lshr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: add_nosignbit_select_lshr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 2147418112(%rdi), %eax
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: add_nosignbit_select_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB15_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    addl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB15_2:
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = lshr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

; arithmetic shift right

define i32 @and_signbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: and_signbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: and_signbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB16_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    andl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB16_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @and_nosignbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: and_nosignbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: and_nosignbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB17_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    andl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB17_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @or_signbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: or_signbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    orl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: or_signbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB18_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    orl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB18_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @or_nosignbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: or_nosignbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    orl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: or_nosignbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB19_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    orl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB19_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @xor_signbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: xor_signbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: xor_signbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB20_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    xorl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB20_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @xor_nosignbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: xor_nosignbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: xor_nosignbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB21_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    xorl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB21_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @add_signbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: add_signbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal -65536(%rdi), %eax
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: add_signbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB22_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    addl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:  .LBB22_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @add_nosignbit_select_ashr(i32 %x, i1 %cond, ptr %dst) {
; X64-LABEL: add_nosignbit_select_ashr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 2147418112(%rdi), %eax
; X64-NEXT:    testb $1, %sil
; X64-NEXT:    cmovel %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rdx)
; X64-NEXT:    retq
;
; X32-LABEL: add_nosignbit_select_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X32-NEXT:    je .LBB23_2
; X32-NEXT:  # %bb.1:
; X32-NEXT:    addl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:  .LBB23_2:
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %t1 = select i1 %cond, i32 %t0, i32 %x
  %r = ashr i32 %t1, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
