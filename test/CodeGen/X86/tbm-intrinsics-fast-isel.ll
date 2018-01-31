; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i686-unknown-unknown -mattr=+tbm | FileCheck %s --check-prefix=X32
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+tbm | FileCheck %s --check-prefix=X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/tbm-builtins.c

define i32 @test__bextri_u32(i32 %a0) {
; X32-LABEL: test__bextri_u32:
; X32:       # %bb.0:
; X32-NEXT:    bextrl $1, {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__bextri_u32:
; X64:       # %bb.0:
; X64-NEXT:    bextrl $1, %edi, %eax
; X64-NEXT:    retq
  %1 = call i32 @llvm.x86.tbm.bextri.u32(i32 %a0, i32 1)
  ret i32 %1
}

define i32 @test__blcfill_u32(i32 %a0) {
; X32-LABEL: test__blcfill_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    leal 1(%ecx), %eax
; X32-NEXT:    andl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blcfill_u32:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 1(%rdi), %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    retq
  %1 = add i32 %a0, 1
  %2 = and i32 %a0, %1
  ret i32 %2
}

define i32 @test__blci_u32(i32 %a0) {
; X32-LABEL: test__blci_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    leal 1(%ecx), %eax
; X32-NEXT:    xorl $-1, %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blci_u32:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 1(%rdi), %eax
; X64-NEXT:    xorl $-1, %eax
; X64-NEXT:    orl %edi, %eax
; X64-NEXT:    retq
  %1 = add i32 %a0, 1
  %2 = xor i32 %1, -1
  %3 = or i32 %a0, %2
  ret i32 %3
}

define i32 @test__blcic_u32(i32 %a0) {
; X32-LABEL: test__blcic_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    xorl $-1, %ecx
; X32-NEXT:    addl $1, %eax
; X32-NEXT:    andl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blcic_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $-1, %eax
; X64-NEXT:    addl $1, %edi
; X64-NEXT:    andl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %1 = xor i32 %a0, -1
  %2 = add i32 %a0, 1
  %3 = and i32 %1, %2
  ret i32 %3
}

define i32 @test__blcmsk_u32(i32 %a0) {
; X32-LABEL: test__blcmsk_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    leal 1(%ecx), %eax
; X32-NEXT:    xorl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blcmsk_u32:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 1(%rdi), %eax
; X64-NEXT:    xorl %edi, %eax
; X64-NEXT:    retq
  %1 = add i32 %a0, 1
  %2 = xor i32 %a0, %1
  ret i32 %2
}

define i32 @test__blcs_u32(i32 %a0) {
; X32-LABEL: test__blcs_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    leal 1(%ecx), %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blcs_u32:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 1(%rdi), %eax
; X64-NEXT:    orl %edi, %eax
; X64-NEXT:    retq
  %1 = add i32 %a0, 1
  %2 = or i32 %a0, %1
  ret i32 %2
}

define i32 @test__blsfill_u32(i32 %a0) {
; X32-LABEL: test__blsfill_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    subl $1, %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blsfill_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    subl $1, %eax
; X64-NEXT:    orl %edi, %eax
; X64-NEXT:    retq
  %1 = sub i32 %a0, 1
  %2 = or i32 %a0, %1
  ret i32 %2
}

define i32 @test__blsic_u32(i32 %a0) {
; X32-LABEL: test__blsic_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    xorl $-1, %ecx
; X32-NEXT:    subl $1, %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__blsic_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $-1, %eax
; X64-NEXT:    subl $1, %edi
; X64-NEXT:    orl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %1 = xor i32 %a0, -1
  %2 = sub i32 %a0, 1
  %3 = or i32 %1, %2
  ret i32 %3
}

define i32 @test__t1mskc_u32(i32 %a0) {
; X32-LABEL: test__t1mskc_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    xorl $-1, %ecx
; X32-NEXT:    addl $1, %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__t1mskc_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $-1, %eax
; X64-NEXT:    addl $1, %edi
; X64-NEXT:    orl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %1 = xor i32 %a0, -1
  %2 = add i32 %a0, 1
  %3 = or i32 %1, %2
  ret i32 %3
}

define i32 @test__tzmsk_u32(i32 %a0) {
; X32-LABEL: test__tzmsk_u32:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, %ecx
; X32-NEXT:    xorl $-1, %ecx
; X32-NEXT:    subl $1, %eax
; X32-NEXT:    andl %ecx, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test__tzmsk_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $-1, %eax
; X64-NEXT:    subl $1, %edi
; X64-NEXT:    andl %eax, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %1 = xor i32 %a0, -1
  %2 = sub i32 %a0, 1
  %3 = and i32 %1, %2
  ret i32 %3
}

declare i32 @llvm.x86.tbm.bextri.u32(i32, i32)
