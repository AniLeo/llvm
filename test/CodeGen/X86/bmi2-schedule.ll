; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+bmi2 | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=haswell | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=knl     | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1  | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define i32 @test_bzhi_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_bzhi_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    bzhil %edi, (%rdx), %ecx
; GENERIC-NEXT:    bzhil %edi, %esi, %eax
; GENERIC-NEXT:    addl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_bzhi_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    bzhil %edi, (%rdx), %ecx # sched: [1:0.50]
; HASWELL-NEXT:    bzhil %edi, %esi, %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_bzhi_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    bzhil %edi, (%rdx), %ecx
; ZNVER1-NEXT:    bzhil %edi, %esi, %eax
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %1, i32 %a0)
  %3 = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %a1, i32 %a0)
  %4 = add i32 %2, %3
  ret i32 %4
}
declare i32 @llvm.x86.bmi.bzhi.32(i32, i32)

define i64 @test_bzhi_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_bzhi_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    bzhiq %rdi, (%rdx), %rcx
; GENERIC-NEXT:    bzhiq %rdi, %rsi, %rax
; GENERIC-NEXT:    addq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_bzhi_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    bzhiq %rdi, (%rdx), %rcx # sched: [1:0.50]
; HASWELL-NEXT:    bzhiq %rdi, %rsi, %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_bzhi_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    bzhiq %rdi, (%rdx), %rcx
; ZNVER1-NEXT:    bzhiq %rdi, %rsi, %rax
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = tail call i64 @llvm.x86.bmi.bzhi.64(i64 %1, i64 %a0)
  %3 = tail call i64 @llvm.x86.bmi.bzhi.64(i64 %a1, i64 %a0)
  %4 = add i64 %2, %3
  ret i64 %4
}
declare i64 @llvm.x86.bmi.bzhi.64(i64, i64)

; TODO test_mulx_i32

define i64 @test_mulx_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_mulx_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    movq %rdx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    movq %rdi, %rdx # sched: [1:0.33]
; GENERIC-NEXT:    mulxq %rsi, %rsi, %rcx # sched: [3:1.00]
; GENERIC-NEXT:    mulxq (%rax), %rdx, %rax # sched: [7:1.00]
; GENERIC-NEXT:    orq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_mulx_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    movq %rdx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    movq %rdi, %rdx # sched: [1:0.25]
; HASWELL-NEXT:    mulxq %rsi, %rsi, %rcx # sched: [4:1.00]
; HASWELL-NEXT:    mulxq (%rax), %rdx, %rax # sched: [4:1.00]
; HASWELL-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_mulx_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    movq %rdx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    movq %rdi, %rdx # sched: [1:0.25]
; ZNVER1-NEXT:    mulxq %rsi, %rsi, %rcx # sched: [4:2.00]
; ZNVER1-NEXT:    mulxq (%rax), %rdx, %rax # sched: [8:2.00]
; ZNVER1-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1  = load i64, i64 *%a2
  %2  = zext i64 %a0 to i128
  %3  = zext i64 %a1 to i128
  %4  = zext i64 %1 to i128
  %5  = mul i128 %2, %3
  %6  = mul i128 %2, %4
  %7  = lshr i128 %5, 64
  %8  = lshr i128 %6, 64
  %9  = trunc i128 %7 to i64
  %10 = trunc i128 %8 to i64
  %11 = or i64 %9, %10
  ret i64 %11
}

define i32 @test_pdep_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_pdep_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pdepl (%rdx), %edi, %ecx
; GENERIC-NEXT:    pdepl %esi, %edi, %eax
; GENERIC-NEXT:    addl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pdep_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    pdepl (%rdx), %edi, %ecx # sched: [3:1.00]
; HASWELL-NEXT:    pdepl %esi, %edi, %eax # sched: [3:1.00]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_pdep_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    pdepl (%rdx), %edi, %ecx
; ZNVER1-NEXT:    pdepl %esi, %edi, %eax
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = tail call i32 @llvm.x86.bmi.pdep.32(i32 %a0, i32 %1)
  %3 = tail call i32 @llvm.x86.bmi.pdep.32(i32 %a0, i32 %a1)
  %4 = add i32 %2, %3
  ret i32 %4
}
declare i32 @llvm.x86.bmi.pdep.32(i32, i32)

define i64 @test_pdep_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_pdep_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pdepq (%rdx), %rdi, %rcx
; GENERIC-NEXT:    pdepq %rsi, %rdi, %rax
; GENERIC-NEXT:    addq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pdep_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    pdepq (%rdx), %rdi, %rcx # sched: [3:1.00]
; HASWELL-NEXT:    pdepq %rsi, %rdi, %rax # sched: [3:1.00]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_pdep_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    pdepq (%rdx), %rdi, %rcx
; ZNVER1-NEXT:    pdepq %rsi, %rdi, %rax
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = tail call i64 @llvm.x86.bmi.pdep.64(i64 %a0, i64 %1)
  %3 = tail call i64 @llvm.x86.bmi.pdep.64(i64 %a0, i64 %a1)
  %4 = add i64 %2, %3
  ret i64 %4
}
declare i64 @llvm.x86.bmi.pdep.64(i64, i64)

define i32 @test_pext_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_pext_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pextl (%rdx), %edi, %ecx
; GENERIC-NEXT:    pextl %esi, %edi, %eax
; GENERIC-NEXT:    addl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pext_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    pextl (%rdx), %edi, %ecx # sched: [3:1.00]
; HASWELL-NEXT:    pextl %esi, %edi, %eax # sched: [3:1.00]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_pext_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    pextl (%rdx), %edi, %ecx
; ZNVER1-NEXT:    pextl %esi, %edi, %eax
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = tail call i32 @llvm.x86.bmi.pext.32(i32 %a0, i32 %1)
  %3 = tail call i32 @llvm.x86.bmi.pext.32(i32 %a0, i32 %a1)
  %4 = add i32 %2, %3
  ret i32 %4
}
declare i32 @llvm.x86.bmi.pext.32(i32, i32)

define i64 @test_pext_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_pext_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    pextq (%rdx), %rdi, %rcx
; GENERIC-NEXT:    pextq %rsi, %rdi, %rax
; GENERIC-NEXT:    addq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_pext_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    pextq (%rdx), %rdi, %rcx # sched: [3:1.00]
; HASWELL-NEXT:    pextq %rsi, %rdi, %rax # sched: [3:1.00]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_pext_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    pextq (%rdx), %rdi, %rcx
; ZNVER1-NEXT:    pextq %rsi, %rdi, %rax
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = tail call i64 @llvm.x86.bmi.pext.64(i64 %a0, i64 %1)
  %3 = tail call i64 @llvm.x86.bmi.pext.64(i64 %a0, i64 %a1)
  %4 = add i64 %2, %3
  ret i64 %4
}
declare i64 @llvm.x86.bmi.pext.64(i64, i64)

define i32 @test_rorx_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_rorx_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    rorxl $5, %edi, %ecx # sched: [1:0.50]
; GENERIC-NEXT:    rorxl $5, (%rdx), %eax # sched: [5:0.50]
; GENERIC-NEXT:    addl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_rorx_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    rorxl $5, %edi, %ecx # sched: [1:0.50]
; HASWELL-NEXT:    rorxl $5, (%rdx), %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_rorx_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    rorxl $5, (%rdx), %eax # sched: [5:0.50]
; ZNVER1-NEXT:    rorxl $5, %edi, %ecx # sched: [1:0.25]
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = lshr i32 %a0, 5
  %3 = shl i32 %a0, 27
  %4 = or i32 %2, %3
  %5 = lshr i32 %1, 5
  %6 = shl i32 %1, 27
  %7 = or i32 %5, %6
  %8 = add i32 %4, %7
  ret i32 %8
}

define i64 @test_rorx_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_rorx_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    rorxq $5, %rdi, %rcx # sched: [1:0.50]
; GENERIC-NEXT:    rorxq $5, (%rdx), %rax # sched: [5:0.50]
; GENERIC-NEXT:    addq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_rorx_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    rorxq $5, %rdi, %rcx # sched: [1:0.50]
; HASWELL-NEXT:    rorxq $5, (%rdx), %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_rorx_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    rorxq $5, (%rdx), %rax # sched: [5:0.50]
; ZNVER1-NEXT:    rorxq $5, %rdi, %rcx # sched: [1:0.25]
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = lshr i64 %a0, 5
  %3 = shl i64 %a0, 59
  %4 = or i64 %2, %3
  %5 = lshr i64 %1, 5
  %6 = shl i64 %1, 59
  %7 = or i64 %5, %6
  %8 = add i64 %4, %7
  ret i64 %8
}

define i32 @test_sarx_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_sarx_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    sarxl %esi, %edi, %ecx # sched: [1:0.50]
; GENERIC-NEXT:    sarxl %esi, (%rdx), %eax # sched: [5:0.50]
; GENERIC-NEXT:    addl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_sarx_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    sarxl %esi, %edi, %ecx # sched: [1:0.50]
; HASWELL-NEXT:    sarxl %esi, (%rdx), %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_sarx_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    sarxl %esi, (%rdx), %eax # sched: [5:0.50]
; ZNVER1-NEXT:    sarxl %esi, %edi, %ecx # sched: [1:0.25]
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = ashr i32 %a0, %a1
  %3 = ashr i32 %1, %a1
  %4 = add i32 %2, %3
  ret i32 %4
}

define i64 @test_sarx_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_sarx_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    sarxq %rsi, %rdi, %rcx # sched: [1:0.50]
; GENERIC-NEXT:    sarxq %rsi, (%rdx), %rax # sched: [5:0.50]
; GENERIC-NEXT:    addq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_sarx_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    sarxq %rsi, %rdi, %rcx # sched: [1:0.50]
; HASWELL-NEXT:    sarxq %rsi, (%rdx), %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_sarx_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    sarxq %rsi, (%rdx), %rax # sched: [5:0.50]
; ZNVER1-NEXT:    sarxq %rsi, %rdi, %rcx # sched: [1:0.25]
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = ashr i64 %a0, %a1
  %3 = ashr i64 %1, %a1
  %4 = add i64 %2, %3
  ret i64 %4
}

define i32 @test_shlx_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_shlx_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    shlxl %esi, %edi, %ecx # sched: [1:0.50]
; GENERIC-NEXT:    shlxl %esi, (%rdx), %eax # sched: [5:0.50]
; GENERIC-NEXT:    addl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_shlx_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    shlxl %esi, %edi, %ecx # sched: [1:0.50]
; HASWELL-NEXT:    shlxl %esi, (%rdx), %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_shlx_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    shlxl %esi, (%rdx), %eax # sched: [5:0.50]
; ZNVER1-NEXT:    shlxl %esi, %edi, %ecx # sched: [1:0.25]
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = shl i32 %a0, %a1
  %3 = shl i32 %1, %a1
  %4 = add i32 %2, %3
  ret i32 %4
}

define i64 @test_shlx_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_shlx_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    shlxq %rsi, %rdi, %rcx # sched: [1:0.50]
; GENERIC-NEXT:    shlxq %rsi, (%rdx), %rax # sched: [5:0.50]
; GENERIC-NEXT:    addq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_shlx_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    shlxq %rsi, %rdi, %rcx # sched: [1:0.50]
; HASWELL-NEXT:    shlxq %rsi, (%rdx), %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_shlx_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    shlxq %rsi, (%rdx), %rax # sched: [5:0.50]
; ZNVER1-NEXT:    shlxq %rsi, %rdi, %rcx # sched: [1:0.25]
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = shl i64 %a0, %a1
  %3 = shl i64 %1, %a1
  %4 = add i64 %2, %3
  ret i64 %4
}

define i32 @test_shrx_i32(i32 %a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_shrx_i32:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    shrxl %esi, %edi, %ecx # sched: [1:0.50]
; GENERIC-NEXT:    shrxl %esi, (%rdx), %eax # sched: [5:0.50]
; GENERIC-NEXT:    addl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_shrx_i32:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    shrxl %esi, %edi, %ecx # sched: [1:0.50]
; HASWELL-NEXT:    shrxl %esi, (%rdx), %eax # sched: [1:0.50]
; HASWELL-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_shrx_i32:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    shrxl %esi, (%rdx), %eax # sched: [5:0.50]
; ZNVER1-NEXT:    shrxl %esi, %edi, %ecx # sched: [1:0.25]
; ZNVER1-NEXT:    addl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i32, i32 *%a2
  %2 = lshr i32 %a0, %a1
  %3 = lshr i32 %1, %a1
  %4 = add i32 %2, %3
  ret i32 %4
}

define i64 @test_shrx_i64(i64 %a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_shrx_i64:
; GENERIC:       # BB#0:
; GENERIC-NEXT:    shrxq %rsi, %rdi, %rcx # sched: [1:0.50]
; GENERIC-NEXT:    shrxq %rsi, (%rdx), %rax # sched: [5:0.50]
; GENERIC-NEXT:    addq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_shrx_i64:
; HASWELL:       # BB#0:
; HASWELL-NEXT:    shrxq %rsi, %rdi, %rcx # sched: [1:0.50]
; HASWELL-NEXT:    shrxq %rsi, (%rdx), %rax # sched: [1:0.50]
; HASWELL-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [2:1.00]
;
; ZNVER1-LABEL: test_shrx_i64:
; ZNVER1:       # BB#0:
; ZNVER1-NEXT:    shrxq %rsi, (%rdx), %rax # sched: [5:0.50]
; ZNVER1-NEXT:    shrxq %rsi, %rdi, %rcx # sched: [1:0.25]
; ZNVER1-NEXT:    addq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [5:0.50]
  %1 = load i64, i64 *%a2
  %2 = lshr i64 %a0, %a1
  %3 = lshr i64 %1, %a1
  %4 = add i64 %2, %3
  ret i64 %4
}
