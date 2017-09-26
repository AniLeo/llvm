; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+tbm < %s | FileCheck %s

; TODO - Patterns fail to fold with ZF flags and prevents TBM instruction selection.

define i32 @test_x86_tbm_bextri_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextr $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 4
  %t1 = and i32 %t0, 4095
  ret i32 %t1
}

; Make sure we still use AH subreg trick for extracting bits 15:8
define i32 @test_x86_tbm_bextri_u32_subreg(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_subreg:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    movzbl %ah, %eax # NOREX
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 8
  %t1 = and i32 %t0, 255
  ret i32 %t1
}

define i32 @test_x86_tbm_bextri_u32_m(i32* nocapture %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_m:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextr $3076, (%rdi), %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = load i32, i32* %a
  %t1 = lshr i32 %t0, 4
  %t2 = and i32 %t1, 4095
  ret i32 %t2
}

define i32 @test_x86_tbm_bextri_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextr $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 4
  %t1 = and i32 %t0, 4095
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_bextri_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    shrl $4, %edi
; CHECK-NEXT:    testw $4095, %di # imm = 0xFFF
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 4
  %t1 = and i32 %t0, 4095
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_bextri_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextr $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 4
  %t1 = and i64 %t0, 4095
  ret i64 %t1
}

; Make sure we still use AH subreg trick for extracting bits 15:8
define i64 @test_x86_tbm_bextri_u64_subreg(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_subreg:
; CHECK:       # BB#0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    movzbl %ah, %eax # NOREX
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 8
  %t1 = and i64 %t0, 255
  ret i64 %t1
}

define i64 @test_x86_tbm_bextri_u64_m(i64* nocapture %a) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_m:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextr $3076, (%rdi), %eax # imm = 0xC04
; CHECK-NEXT:    retq
  %t0 = load i64, i64* %a
  %t1 = lshr i64 %t0, 4
  %t2 = and i64 %t1, 4095
  ret i64 %t2
}

define i64 @test_x86_tbm_bextri_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextr $3076, %edi, %eax # imm = 0xC04
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 4
  %t1 = and i64 %t0, 4095
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_bextri_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_bextri_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    shrl $4, %edi
; CHECK-NEXT:    testw $4095, %di # imm = 0xFFF
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %a, 4
  %t1 = and i64 %t0, 4095
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blcfill_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcfill %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = and i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blcfill_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcfill %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = and i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blcfill_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    # kill: %EDI<def> %EDI<kill> %RDI<def>
; CHECK-NEXT:    leal 1(%rdi), %eax
; CHECK-NEXT:    testl %edi, %eax
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = and i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blcfill_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcfill %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = and i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blcfill_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcfill %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = and i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blcfill_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcfill_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    leaq 1(%rdi), %rax
; CHECK-NEXT:    testq %rdi, %rax
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = and i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blci_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blci %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 1, %a
  %t1 = xor i32 %t0, -1
  %t2 = or i32 %t1, %a
  ret i32 %t2
}

define i32 @test_x86_tbm_blci_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blci %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 1, %a
  %t1 = xor i32 %t0, -1
  %t2 = or i32 %t1, %a
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_blci_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    # kill: %EDI<def> %EDI<kill> %RDI<def>
; CHECK-NEXT:    leal 1(%rdi), %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    orl %edi, %eax
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 1, %a
  %t1 = xor i32 %t0, -1
  %t2 = or i32 %t1, %a
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_blci_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blci %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 1, %a
  %t1 = xor i64 %t0, -1
  %t2 = or i64 %t1, %a
  ret i64 %t2
}

define i64 @test_x86_tbm_blci_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blci %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 1, %a
  %t1 = xor i64 %t0, -1
  %t2 = or i64 %t1, %a
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_blci_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    leaq 1(%rdi), %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 1, %a
  %t1 = xor i64 %t0, -1
  %t2 = or i64 %t1, %a
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_blci_u32_b(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u32_b:
; CHECK:       # BB#0:
; CHECK-NEXT:    blci %edi, %eax
; CHECK-NEXT:    retq
  %t0 = sub i32 -2, %a
  %t1 = or i32 %t0, %a
  ret i32 %t1
}

define i64 @test_x86_tbm_blci_u64_b(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blci_u64_b:
; CHECK:       # BB#0:
; CHECK-NEXT:    blci %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = sub i64 -2, %a
  %t1 = or i64 %t0, %a
  ret i64 %t1
}

define i32 @test_x86_tbm_blcic_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcic %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = and i32 %t1, %t0
  ret i32 %t2
}

define i32 @test_x86_tbm_blcic_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcic %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = and i32 %t1, %t0
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_blcic_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    incl %edi
; CHECK-NEXT:    testl %eax, %edi
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = and i32 %t1, %t0
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_blcic_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcic %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = and i64 %t1, %t0
  ret i64 %t2
}

define i64 @test_x86_tbm_blcic_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcic %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = and i64 %t1, %t0
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_blcic_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcic_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    incq %rdi
; CHECK-NEXT:    testq %rax, %rdi
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = and i64 %t1, %t0
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_blcmsk_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcmsk %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = xor i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blcmsk_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcmsk %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = xor i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blcmsk_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    # kill: %EDI<def> %EDI<kill> %RDI<def>
; CHECK-NEXT:    leal 1(%rdi), %eax
; CHECK-NEXT:    xorl %edi, %eax
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = xor i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blcmsk_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcmsk %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = xor i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blcmsk_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcmsk %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = xor i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blcmsk_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcmsk_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    leaq 1(%rdi), %rax
; CHECK-NEXT:    xorq %rdi, %rax
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = xor i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blcs_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcs %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = or i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blcs_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcs %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blcs_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    # kill: %EDI<def> %EDI<kill> %RDI<def>
; CHECK-NEXT:    leal 1(%rdi), %eax
; CHECK-NEXT:    orl %edi, %eax
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, 1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blcs_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcs %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = or i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blcs_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blcs %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blcs_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blcs_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    leaq 1(%rdi), %rax
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, 1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blsfill_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsfill %edi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, -1
  %t1 = or i32 %t0, %a
  ret i32 %t1
}

define i32 @test_x86_tbm_blsfill_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsfill %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, -1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %t1
  ret i32 %t3
}

define i32 @test_x86_tbm_blsfill_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    # kill: %EDI<def> %EDI<kill> %RDI<def>
; CHECK-NEXT:    leal -1(%rdi), %eax
; CHECK-NEXT:    orl %edi, %eax
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = add i32 %a, -1
  %t1 = or i32 %t0, %a
  %t2 = icmp eq i32 %t1, 0
  %t3 = select i1 %t2, i32 %b, i32 %c
  ret i32 %t3
}

define i64 @test_x86_tbm_blsfill_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsfill %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, -1
  %t1 = or i64 %t0, %a
  ret i64 %t1
}

define i64 @test_x86_tbm_blsfill_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsfill %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, -1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %t1
  ret i64 %t3
}

define i64 @test_x86_tbm_blsfill_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsfill_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    leaq -1(%rdi), %rax
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = add i64 %a, -1
  %t1 = or i64 %t0, %a
  %t2 = icmp eq i64 %t1, 0
  %t3 = select i1 %t2, i64 %b, i64 %c
  ret i64 %t3
}

define i32 @test_x86_tbm_blsic_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsic %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

define i32 @test_x86_tbm_blsic_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsic %edi, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_blsic_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    decl %edi
; CHECK-NEXT:    orl %eax, %edi
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_blsic_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsic %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = or i64 %t0, %t1
  ret i64 %t2
}

define i64 @test_x86_tbm_blsic_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsic %rdi, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_blsic_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_blsic_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    decq %rdi
; CHECK-NEXT:    orq %rax, %rdi
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_t1mskc_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    t1mskc %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = or i32 %t0, %t1
  ret i32 %t2
}

define i32 @test_x86_tbm_t1mskc_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    t1mskc %edi, %eax
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_t1mskc_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    incl %edi
; CHECK-NEXT:    orl %eax, %edi
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, 1
  %t2 = or i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_t1mskc_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    t1mskc %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = or i64 %t0, %t1
  ret i64 %t2
}

define i64 @test_x86_tbm_t1mskc_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    t1mskc %rdi, %rax
; CHECK-NEXT:    testq %rax, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_t1mskc_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_t1mskc_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    incq %rdi
; CHECK-NEXT:    orq %rax, %rdi
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, 1
  %t2 = or i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i32 @test_x86_tbm_tzmsk_u32(i32 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u32:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzmsk %edi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = and i32 %t0, %t1
  ret i32 %t2
}

define i32 @test_x86_tbm_tzmsk_u32_z(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u32_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzmsk %edi, %eax
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = and i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %t2
  ret i32 %t4
}

define i32 @test_x86_tbm_tzmsk_u32_z2(i32 %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u32_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    decl %edi
; CHECK-NEXT:    testl %edi, %eax
; CHECK-NEXT:    cmovnel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %t0 = xor i32 %a, -1
  %t1 = add i32 %a, -1
  %t2 = and i32 %t0, %t1
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %b, i32 %c
  ret i32 %t4
}

define i64 @test_x86_tbm_tzmsk_u64(i64 %a) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u64:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzmsk %rdi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = and i64 %t0, %t1
  ret i64 %t2
}

define i64 @test_x86_tbm_tzmsk_u64_z(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u64_z:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzmsk %rdi, %rax
; CHECK-NEXT:    testq %rax, %rax
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = and i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %t2
  ret i64 %t4
}

define i64 @test_x86_tbm_tzmsk_u64_z2(i64 %a, i64 %b, i64 %c) nounwind {
; CHECK-LABEL: test_x86_tbm_tzmsk_u64_z2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    decq %rdi
; CHECK-NEXT:    testq %rdi, %rax
; CHECK-NEXT:    cmovneq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %t0 = xor i64 %a, -1
  %t1 = add i64 %a, -1
  %t2 = and i64 %t0, %t1
  %t3 = icmp eq i64 %t2, 0
  %t4 = select i1 %t3, i64 %b, i64 %c
  ret i64 %t4
}

define i64 @test_and_large_constant_mask(i64 %x) {
; CHECK-LABEL: test_and_large_constant_mask:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    bextr $15872, %rdi, %rax # imm = 0x3E00
; CHECK-NEXT:    retq
entry:
  %and = and i64 %x, 4611686018427387903
  ret i64 %and
}

define i64 @test_and_large_constant_mask_load(i64* %x) {
; CHECK-LABEL: test_and_large_constant_mask_load:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    bextr $15872, (%rdi), %rax # imm = 0x3E00
; CHECK-NEXT:    retq
entry:
  %x1 = load i64, i64* %x
  %and = and i64 %x1, 4611686018427387903
  ret i64 %and
}
