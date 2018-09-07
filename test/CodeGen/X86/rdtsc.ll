; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=generic | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=generic | FileCheck %s --check-prefix=X64

; Verify that we correctly lower ISD::READCYCLECOUNTER.


define i64 @test_builtin_readcyclecounter() {
; X86-LABEL: test_builtin_readcyclecounter:
; X86:       # %bb.0:
; X86-NEXT:    rdtsc
; X86-NEXT:    retl
;
; X64-LABEL: test_builtin_readcyclecounter:
; X64:       # %bb.0:
; X64-NEXT:    rdtsc
; X64-NEXT:    shlq $32, %rdx
; X64-NEXT:    orq %rdx, %rax
; X64-NEXT:    retq
  %1 = tail call i64 @llvm.readcyclecounter()
  ret i64 %1
}

; Verify that we correctly lower the Read Cycle Counter GCC x86 builtins
; (i.e. RDTSC and RDTSCP).

define i64 @test_builtin_rdtsc() {
; X86-LABEL: test_builtin_rdtsc:
; X86:       # %bb.0:
; X86-NEXT:    rdtsc
; X86-NEXT:    retl
;
; X64-LABEL: test_builtin_rdtsc:
; X64:       # %bb.0:
; X64-NEXT:    rdtsc
; X64-NEXT:    shlq $32, %rdx
; X64-NEXT:    orq %rdx, %rax
; X64-NEXT:    retq
  %1 = tail call i64 @llvm.x86.rdtsc()
  ret i64 %1
}

define i64 @test_builtin_rdtscp(i8* %A) {
; X86-LABEL: test_builtin_rdtscp:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %esi, -8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    rdtscp
; X86-NEXT:    movl %ecx, (%esi)
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: test_builtin_rdtscp:
; X64:       # %bb.0:
; X64-NEXT:    rdtscp
; X64-NEXT:    shlq $32, %rdx
; X64-NEXT:    orq %rdx, %rax
; X64-NEXT:    movl %ecx, (%rdi)
; X64-NEXT:    retq
  %1 = call { i64, i32 } @llvm.x86.rdtscp()
  %2 = extractvalue { i64, i32 } %1, 1
  %3 = bitcast i8* %A to i32*
  store i32 %2, i32* %3, align 1
  %4 = extractvalue { i64, i32 } %1, 0
  ret i64 %4
}

declare i64 @llvm.readcyclecounter()
declare { i64, i32 } @llvm.x86.rdtscp()
declare i64 @llvm.x86.rdtsc()

