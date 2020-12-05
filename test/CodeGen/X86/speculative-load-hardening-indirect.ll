; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; Verify the call site info. If the call site info is not
; in the valid state, an assert should be triggered.
; RUN: llc < %s -debug-entry-values -mtriple=x86_64-unknown-linux-gnu -x86-speculative-load-hardening -stop-after=machineverifier

; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -x86-speculative-load-hardening -data-sections | FileCheck %s --check-prefix=X64
; FIXME: Fix machine verifier issues and remove -verify-machineinstrs=0. PR39451.
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -x86-speculative-load-hardening -relocation-model pic -data-sections -verify-machineinstrs=0 | FileCheck %s --check-prefix=X64-PIC
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -x86-speculative-load-hardening -data-sections -mattr=+retpoline | FileCheck %s --check-prefix=X64-RETPOLINE
;
; FIXME: Add support for 32-bit.

@global_fnptr = external global i32 ()*

@global_blockaddrs = constant [4 x i8*] [
  i8* blockaddress(@test_indirectbr_global, %bb0),
  i8* blockaddress(@test_indirectbr_global, %bb1),
  i8* blockaddress(@test_indirectbr_global, %bb2),
  i8* blockaddress(@test_indirectbr_global, %bb3)
]

define i32 @test_indirect_call(i32 ()** %ptr) nounwind {
; X64-LABEL: test_indirect_call:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbx
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %rbx
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    movq (%rdi), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    callq *%rcx
; X64-NEXT:  .Lslh_ret_addr0:
; X64-NEXT:    movq %rsp, %rcx
; X64-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    cmpq $.Lslh_ret_addr0, %rdx
; X64-NEXT:    cmovneq %rbx, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    retq
;
; X64-PIC-LABEL: test_indirect_call:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    pushq %rbx
; X64-PIC-NEXT:    movq %rsp, %rax
; X64-PIC-NEXT:    movq $-1, %rbx
; X64-PIC-NEXT:    sarq $63, %rax
; X64-PIC-NEXT:    movq (%rdi), %rcx
; X64-PIC-NEXT:    orq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rax
; X64-PIC-NEXT:    orq %rax, %rsp
; X64-PIC-NEXT:    callq *%rcx
; X64-PIC-NEXT:  .Lslh_ret_addr0:
; X64-PIC-NEXT:    movq %rsp, %rcx
; X64-PIC-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; X64-PIC-NEXT:    sarq $63, %rcx
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rbx, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    popq %rbx
; X64-PIC-NEXT:    retq
;
; X64-RETPOLINE-LABEL: test_indirect_call:
; X64-RETPOLINE:       # %bb.0: # %entry
; X64-RETPOLINE-NEXT:    pushq %rbx
; X64-RETPOLINE-NEXT:    movq %rsp, %rax
; X64-RETPOLINE-NEXT:    movq $-1, %rbx
; X64-RETPOLINE-NEXT:    sarq $63, %rax
; X64-RETPOLINE-NEXT:    movq (%rdi), %r11
; X64-RETPOLINE-NEXT:    orq %rax, %r11
; X64-RETPOLINE-NEXT:    shlq $47, %rax
; X64-RETPOLINE-NEXT:    orq %rax, %rsp
; X64-RETPOLINE-NEXT:    callq __llvm_retpoline_r11
; X64-RETPOLINE-NEXT:  .Lslh_ret_addr0:
; X64-RETPOLINE-NEXT:    movq %rsp, %rcx
; X64-RETPOLINE-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; X64-RETPOLINE-NEXT:    sarq $63, %rcx
; X64-RETPOLINE-NEXT:    cmpq $.Lslh_ret_addr0, %rdx
; X64-RETPOLINE-NEXT:    cmovneq %rbx, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    popq %rbx
; X64-RETPOLINE-NEXT:    retq
entry:
  %fp = load i32 ()*, i32 ()** %ptr
  %v = call i32 %fp()
  ret i32 %v
}

define i32 @test_indirect_tail_call(i32 ()** %ptr) nounwind {
; X64-LABEL: test_indirect_tail_call:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %rcx
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    movq (%rdi), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    jmpq *%rcx # TAILCALL
;
; X64-PIC-LABEL: test_indirect_tail_call:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    movq %rsp, %rax
; X64-PIC-NEXT:    movq $-1, %rcx
; X64-PIC-NEXT:    sarq $63, %rax
; X64-PIC-NEXT:    movq (%rdi), %rcx
; X64-PIC-NEXT:    orq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rax
; X64-PIC-NEXT:    orq %rax, %rsp
; X64-PIC-NEXT:    jmpq *%rcx # TAILCALL
;
; X64-RETPOLINE-LABEL: test_indirect_tail_call:
; X64-RETPOLINE:       # %bb.0: # %entry
; X64-RETPOLINE-NEXT:    movq %rsp, %rax
; X64-RETPOLINE-NEXT:    movq $-1, %rcx
; X64-RETPOLINE-NEXT:    sarq $63, %rax
; X64-RETPOLINE-NEXT:    movq (%rdi), %r11
; X64-RETPOLINE-NEXT:    orq %rax, %r11
; X64-RETPOLINE-NEXT:    shlq $47, %rax
; X64-RETPOLINE-NEXT:    orq %rax, %rsp
; X64-RETPOLINE-NEXT:    jmp __llvm_retpoline_r11 # TAILCALL
entry:
  %fp = load i32 ()*, i32 ()** %ptr
  %v = tail call i32 %fp()
  ret i32 %v
}

define i32 @test_indirect_call_global() nounwind {
; X64-LABEL: test_indirect_call_global:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbx
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %rbx
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    movq global_fnptr@{{.*}}(%rip), %rcx
; X64-NEXT:    movq (%rcx), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    callq *%rcx
; X64-NEXT:  .Lslh_ret_addr1:
; X64-NEXT:    movq %rsp, %rcx
; X64-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    cmpq $.Lslh_ret_addr1, %rdx
; X64-NEXT:    cmovneq %rbx, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    popq %rbx
; X64-NEXT:    retq
;
; X64-PIC-LABEL: test_indirect_call_global:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    pushq %rbx
; X64-PIC-NEXT:    movq %rsp, %rax
; X64-PIC-NEXT:    movq $-1, %rbx
; X64-PIC-NEXT:    sarq $63, %rax
; X64-PIC-NEXT:    movq global_fnptr@{{.*}}(%rip), %rcx
; X64-PIC-NEXT:    movq (%rcx), %rcx
; X64-PIC-NEXT:    orq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rax
; X64-PIC-NEXT:    orq %rax, %rsp
; X64-PIC-NEXT:    callq *%rcx
; X64-PIC-NEXT:  .Lslh_ret_addr1:
; X64-PIC-NEXT:    movq %rsp, %rcx
; X64-PIC-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; X64-PIC-NEXT:    sarq $63, %rcx
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rbx, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    popq %rbx
; X64-PIC-NEXT:    retq
;
; X64-RETPOLINE-LABEL: test_indirect_call_global:
; X64-RETPOLINE:       # %bb.0: # %entry
; X64-RETPOLINE-NEXT:    pushq %rbx
; X64-RETPOLINE-NEXT:    movq %rsp, %rax
; X64-RETPOLINE-NEXT:    movq $-1, %rbx
; X64-RETPOLINE-NEXT:    sarq $63, %rax
; X64-RETPOLINE-NEXT:    movq global_fnptr@{{.*}}(%rip), %rcx
; X64-RETPOLINE-NEXT:    movq (%rcx), %r11
; X64-RETPOLINE-NEXT:    orq %rax, %r11
; X64-RETPOLINE-NEXT:    shlq $47, %rax
; X64-RETPOLINE-NEXT:    orq %rax, %rsp
; X64-RETPOLINE-NEXT:    callq __llvm_retpoline_r11
; X64-RETPOLINE-NEXT:  .Lslh_ret_addr1:
; X64-RETPOLINE-NEXT:    movq %rsp, %rcx
; X64-RETPOLINE-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; X64-RETPOLINE-NEXT:    sarq $63, %rcx
; X64-RETPOLINE-NEXT:    cmpq $.Lslh_ret_addr1, %rdx
; X64-RETPOLINE-NEXT:    cmovneq %rbx, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    popq %rbx
; X64-RETPOLINE-NEXT:    retq
entry:
  %fp = load i32 ()*, i32 ()** @global_fnptr
  %v = call i32 %fp()
  ret i32 %v
}

define i32 @test_indirect_tail_call_global() nounwind {
; X64-LABEL: test_indirect_tail_call_global:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rsp, %rax
; X64-NEXT:    movq $-1, %rcx
; X64-NEXT:    sarq $63, %rax
; X64-NEXT:    movq global_fnptr@{{.*}}(%rip), %rcx
; X64-NEXT:    movq (%rcx), %rcx
; X64-NEXT:    orq %rax, %rcx
; X64-NEXT:    shlq $47, %rax
; X64-NEXT:    orq %rax, %rsp
; X64-NEXT:    jmpq *%rcx # TAILCALL
;
; X64-PIC-LABEL: test_indirect_tail_call_global:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    movq %rsp, %rax
; X64-PIC-NEXT:    movq $-1, %rcx
; X64-PIC-NEXT:    sarq $63, %rax
; X64-PIC-NEXT:    movq global_fnptr@{{.*}}(%rip), %rcx
; X64-PIC-NEXT:    movq (%rcx), %rcx
; X64-PIC-NEXT:    orq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rax
; X64-PIC-NEXT:    orq %rax, %rsp
; X64-PIC-NEXT:    jmpq *%rcx # TAILCALL
;
; X64-RETPOLINE-LABEL: test_indirect_tail_call_global:
; X64-RETPOLINE:       # %bb.0: # %entry
; X64-RETPOLINE-NEXT:    movq %rsp, %rax
; X64-RETPOLINE-NEXT:    movq $-1, %rcx
; X64-RETPOLINE-NEXT:    sarq $63, %rax
; X64-RETPOLINE-NEXT:    movq global_fnptr@{{.*}}(%rip), %rcx
; X64-RETPOLINE-NEXT:    movq (%rcx), %r11
; X64-RETPOLINE-NEXT:    orq %rax, %r11
; X64-RETPOLINE-NEXT:    shlq $47, %rax
; X64-RETPOLINE-NEXT:    orq %rax, %rsp
; X64-RETPOLINE-NEXT:    jmp __llvm_retpoline_r11 # TAILCALL
entry:
  %fp = load i32 ()*, i32 ()** @global_fnptr
  %v = tail call i32 %fp()
  ret i32 %v
}

define i32 @test_indirectbr(i8** %ptr) nounwind {
; X64-LABEL: test_indirectbr:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rsp, %rcx
; X64-NEXT:    movq $-1, %rax
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    movq (%rdi), %rdx
; X64-NEXT:    orq %rcx, %rdx
; X64-NEXT:    jmpq *%rdx
; X64-NEXT:  .LBB4_1: # Block address taken
; X64-NEXT:    # %bb0
; X64-NEXT:    cmpq $.LBB4_1, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $2, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .LBB4_3: # Block address taken
; X64-NEXT:    # %bb2
; X64-NEXT:    cmpq $.LBB4_3, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $13, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .LBB4_4: # Block address taken
; X64-NEXT:    # %bb3
; X64-NEXT:    cmpq $.LBB4_4, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $42, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .LBB4_2: # Block address taken
; X64-NEXT:    # %bb1
; X64-NEXT:    cmpq $.LBB4_2, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $7, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
;
; X64-PIC-LABEL: test_indirectbr:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    movq %rsp, %rcx
; X64-PIC-NEXT:    movq $-1, %rax
; X64-PIC-NEXT:    sarq $63, %rcx
; X64-PIC-NEXT:    movq (%rdi), %rdx
; X64-PIC-NEXT:    orq %rcx, %rdx
; X64-PIC-NEXT:    jmpq *%rdx
; X64-PIC-NEXT:  .LBB4_1: # Block address taken
; X64-PIC-NEXT:    # %bb0
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $2, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .LBB4_3: # Block address taken
; X64-PIC-NEXT:    # %bb2
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $13, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .LBB4_4: # Block address taken
; X64-PIC-NEXT:    # %bb3
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $42, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .LBB4_2: # Block address taken
; X64-PIC-NEXT:    # %bb1
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $7, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
;
; X64-RETPOLINE-LABEL: test_indirectbr:
; X64-RETPOLINE:       # %bb.0: # %entry
entry:
  %a = load i8*, i8** %ptr
  indirectbr i8* %a, [ label %bb0, label %bb1, label %bb2, label %bb3 ]

bb0:
  ret i32 2

bb1:
  ret i32 7

bb2:
  ret i32 13

bb3:
  ret i32 42
}

define i32 @test_indirectbr_global(i32 %idx) nounwind {
; X64-LABEL: test_indirectbr_global:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rsp, %rcx
; X64-NEXT:    movq $-1, %rax
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    movslq %edi, %rdx
; X64-NEXT:    movq global_blockaddrs(,%rdx,8), %rdx
; X64-NEXT:    orq %rcx, %rdx
; X64-NEXT:    jmpq *%rdx
; X64-NEXT:  .Ltmp0: # Block address taken
; X64-NEXT:  .LBB5_1: # %bb0
; X64-NEXT:    cmpq $.LBB5_1, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $2, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .Ltmp1: # Block address taken
; X64-NEXT:  .LBB5_3: # %bb2
; X64-NEXT:    cmpq $.LBB5_3, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $13, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .Ltmp2: # Block address taken
; X64-NEXT:  .LBB5_4: # %bb3
; X64-NEXT:    cmpq $.LBB5_4, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $42, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .Ltmp3: # Block address taken
; X64-NEXT:  .LBB5_2: # %bb1
; X64-NEXT:    cmpq $.LBB5_2, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $7, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
;
; X64-PIC-LABEL: test_indirectbr_global:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    movq %rsp, %rcx
; X64-PIC-NEXT:    movq $-1, %rax
; X64-PIC-NEXT:    sarq $63, %rcx
; X64-PIC-NEXT:    movslq %edi, %rdx
; X64-PIC-NEXT:    movq global_blockaddrs@{{.*}}(%rip), %rsi
; X64-PIC-NEXT:    movq (%rsi,%rdx,8), %rdx
; X64-PIC-NEXT:    orq %rcx, %rdx
; X64-PIC-NEXT:    jmpq *%rdx
; X64-PIC-NEXT:  .Ltmp0: # Block address taken
; X64-PIC-NEXT:  .LBB5_1: # %bb0
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $2, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .Ltmp1: # Block address taken
; X64-PIC-NEXT:  .LBB5_3: # %bb2
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $13, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .Ltmp2: # Block address taken
; X64-PIC-NEXT:  .LBB5_4: # %bb3
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $42, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .Ltmp3: # Block address taken
; X64-PIC-NEXT:  .LBB5_2: # %bb1
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $7, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
;
; X64-RETPOLINE-LABEL: test_indirectbr_global:
; X64-RETPOLINE:       # %bb.0: # %entry
; X64-RETPOLINE-NEXT:    movq %rsp, %rcx
; X64-RETPOLINE-NEXT:    movq $-1, %rax
; X64-RETPOLINE-NEXT:    sarq $63, %rcx
; X64-RETPOLINE-NEXT:    movslq %edi, %rdx
; X64-RETPOLINE-NEXT:    movq global_blockaddrs(,%rdx,8), %rdx
; X64-RETPOLINE-NEXT:    orq %rcx, %rdx
; X64-RETPOLINE-NEXT:    cmpq $2, %rdx
; X64-RETPOLINE-NEXT:    je .LBB6_4
; X64-RETPOLINE-NEXT:  # %bb.1: # %entry
; X64-RETPOLINE-NEXT:    cmoveq %rax, %rcx
; X64-RETPOLINE-NEXT:    cmpq $3, %rdx
; X64-RETPOLINE-NEXT:    je .LBB6_5
; X64-RETPOLINE-NEXT:  # %bb.2: # %entry
; X64-RETPOLINE-NEXT:    cmoveq %rax, %rcx
; X64-RETPOLINE-NEXT:    cmpq $4, %rdx
; X64-RETPOLINE-NEXT:    jne .LBB6_3
; X64-RETPOLINE-NEXT:  .Ltmp0: # Block address taken
; X64-RETPOLINE-NEXT:  # %bb.6: # %bb3
; X64-RETPOLINE-NEXT:    cmovneq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $42, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
; X64-RETPOLINE-NEXT:  .Ltmp1: # Block address taken
; X64-RETPOLINE-NEXT:  .LBB6_4: # %bb1
; X64-RETPOLINE-NEXT:    cmovneq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $7, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
; X64-RETPOLINE-NEXT:  .Ltmp2: # Block address taken
; X64-RETPOLINE-NEXT:  .LBB6_5: # %bb2
; X64-RETPOLINE-NEXT:    cmovneq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $13, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
; X64-RETPOLINE-NEXT:  .Ltmp3: # Block address taken
; X64-RETPOLINE-NEXT:  .LBB6_3: # %bb0
; X64-RETPOLINE-NEXT:    cmoveq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $2, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
entry:
  %ptr = getelementptr [4 x i8*], [4 x i8*]* @global_blockaddrs, i32 0, i32 %idx
  %a = load i8*, i8** %ptr
  indirectbr i8* %a, [ label %bb0, label %bb1, label %bb2, label %bb3 ]

bb0:
  ret i32 2

bb1:
  ret i32 7

bb2:
  ret i32 13

bb3:
  ret i32 42
}

; This function's switch is crafted to trigger jump-table lowering in the x86
; backend so that we can test how the exact jump table lowering behaves.
define i32 @test_switch_jumptable(i32 %idx) nounwind {
; X64-LABEL: test_switch_jumptable:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rsp, %rcx
; X64-NEXT:    movq $-1, %rax
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    cmpl $3, %edi
; X64-NEXT:    ja .LBB6_2
; X64-NEXT:  # %bb.1: # %entry
; X64-NEXT:    cmovaq %rax, %rcx
; X64-NEXT:    movl %edi, %edx
; X64-NEXT:    movq .LJTI6_0(,%rdx,8), %rdx
; X64-NEXT:    orq %rcx, %rdx
; X64-NEXT:    jmpq *%rdx
; X64-NEXT:  .LBB6_3: # Block address taken
; X64-NEXT:    # %bb1
; X64-NEXT:    cmpq $.LBB6_3, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $7, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .LBB6_2: # %bb0
; X64-NEXT:    cmovbeq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $2, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .LBB6_4: # Block address taken
; X64-NEXT:    # %bb2
; X64-NEXT:    cmpq $.LBB6_4, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $13, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .LBB6_5: # Block address taken
; X64-NEXT:    # %bb3
; X64-NEXT:    cmpq $.LBB6_5, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $42, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
; X64-NEXT:  .LBB6_6: # Block address taken
; X64-NEXT:    # %bb5
; X64-NEXT:    cmpq $.LBB6_6, %rdx
; X64-NEXT:    cmovneq %rax, %rcx
; X64-NEXT:    shlq $47, %rcx
; X64-NEXT:    movl $11, %eax
; X64-NEXT:    orq %rcx, %rsp
; X64-NEXT:    retq
;
; X64-PIC-LABEL: test_switch_jumptable:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    movq %rsp, %rcx
; X64-PIC-NEXT:    movq $-1, %rax
; X64-PIC-NEXT:    sarq $63, %rcx
; X64-PIC-NEXT:    cmpl $3, %edi
; X64-PIC-NEXT:    ja .LBB6_2
; X64-PIC-NEXT:  # %bb.1: # %entry
; X64-PIC-NEXT:    cmovaq %rax, %rcx
; X64-PIC-NEXT:    movl %edi, %edx
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    movslq (%rsi,%rdx,4), %rdx
; X64-PIC-NEXT:    addq %rsi, %rdx
; X64-PIC-NEXT:    orq %rcx, %rdx
; X64-PIC-NEXT:    jmpq *%rdx
; X64-PIC-NEXT:  .LBB6_3: # Block address taken
; X64-PIC-NEXT:    # %bb1
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $7, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .LBB6_2: # %bb0
; X64-PIC-NEXT:    cmovbeq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $2, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .LBB6_4: # Block address taken
; X64-PIC-NEXT:    # %bb2
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $13, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .LBB6_5: # Block address taken
; X64-PIC-NEXT:    # %bb3
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $42, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
; X64-PIC-NEXT:  .LBB6_6: # Block address taken
; X64-PIC-NEXT:    # %bb5
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:    cmpq %rsi, %rdx
; X64-PIC-NEXT:    cmovneq %rax, %rcx
; X64-PIC-NEXT:    shlq $47, %rcx
; X64-PIC-NEXT:    movl $11, %eax
; X64-PIC-NEXT:    orq %rcx, %rsp
; X64-PIC-NEXT:    retq
;
; X64-RETPOLINE-LABEL: test_switch_jumptable:
; X64-RETPOLINE:       # %bb.0: # %entry
; X64-RETPOLINE-NEXT:    movq %rsp, %rcx
; X64-RETPOLINE-NEXT:    movq $-1, %rax
; X64-RETPOLINE-NEXT:    sarq $63, %rcx
; X64-RETPOLINE-NEXT:    cmpl $1, %edi
; X64-RETPOLINE-NEXT:    jg .LBB7_4
; X64-RETPOLINE-NEXT:  # %bb.1: # %entry
; X64-RETPOLINE-NEXT:    cmovgq %rax, %rcx
; X64-RETPOLINE-NEXT:    testl %edi, %edi
; X64-RETPOLINE-NEXT:    je .LBB7_7
; X64-RETPOLINE-NEXT:  # %bb.2: # %entry
; X64-RETPOLINE-NEXT:    cmoveq %rax, %rcx
; X64-RETPOLINE-NEXT:    cmpl $1, %edi
; X64-RETPOLINE-NEXT:    jne .LBB7_6
; X64-RETPOLINE-NEXT:  # %bb.3: # %bb2
; X64-RETPOLINE-NEXT:    cmovneq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $13, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
; X64-RETPOLINE-NEXT:  .LBB7_4: # %entry
; X64-RETPOLINE-NEXT:    cmovleq %rax, %rcx
; X64-RETPOLINE-NEXT:    cmpl $2, %edi
; X64-RETPOLINE-NEXT:    je .LBB7_8
; X64-RETPOLINE-NEXT:  # %bb.5: # %entry
; X64-RETPOLINE-NEXT:    cmoveq %rax, %rcx
; X64-RETPOLINE-NEXT:    cmpl $3, %edi
; X64-RETPOLINE-NEXT:    jne .LBB7_6
; X64-RETPOLINE-NEXT:  # %bb.9: # %bb5
; X64-RETPOLINE-NEXT:    cmovneq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $11, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
; X64-RETPOLINE-NEXT:  .LBB7_6:
; X64-RETPOLINE-NEXT:    cmoveq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $2, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
; X64-RETPOLINE-NEXT:  .LBB7_7: # %bb1
; X64-RETPOLINE-NEXT:    cmovneq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $7, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
; X64-RETPOLINE-NEXT:  .LBB7_8: # %bb3
; X64-RETPOLINE-NEXT:    cmovneq %rax, %rcx
; X64-RETPOLINE-NEXT:    shlq $47, %rcx
; X64-RETPOLINE-NEXT:    movl $42, %eax
; X64-RETPOLINE-NEXT:    orq %rcx, %rsp
; X64-RETPOLINE-NEXT:    retq
entry:
  switch i32 %idx, label %bb0 [
    i32 0, label %bb1
    i32 1, label %bb2
    i32 2, label %bb3
    i32 3, label %bb5
  ]

bb0:
  ret i32 2

bb1:
  ret i32 7

bb2:
  ret i32 13

bb3:
  ret i32 42

bb5:
  ret i32 11
}

; This function's switch is crafted to trigger jump-table lowering in the x86
; backend so that we can test how the exact jump table lowering behaves, but
; also arranges for fallthroughs from case to case to ensure that this pattern
; too can be handled.
define i32 @test_switch_jumptable_fallthrough(i32 %idx, i32* %a.ptr, i32* %b.ptr, i32* %c.ptr, i32* %d.ptr) nounwind {
; X64-LABEL: test_switch_jumptable_fallthrough:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rsp, %r9
; X64-NEXT:    movq $-1, %r10
; X64-NEXT:    sarq $63, %r9
; X64-NEXT:    cmpl $3, %edi
; X64-NEXT:    ja .LBB7_2
; X64-NEXT:  # %bb.1: # %entry
; X64-NEXT:    cmovaq %r10, %r9
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    movl %edi, %esi
; X64-NEXT:    movq .LJTI7_0(,%rsi,8), %rsi
; X64-NEXT:    orq %r9, %rsi
; X64-NEXT:    jmpq *%rsi
; X64-NEXT:  .LBB7_2: # %bb0
; X64-NEXT:    cmovbeq %r10, %r9
; X64-NEXT:    movl (%rsi), %eax
; X64-NEXT:    orl %r9d, %eax
; X64-NEXT:    movq $.LBB7_3, %rsi
; X64-NEXT:  .LBB7_3: # Block address taken
; X64-NEXT:    # %bb1
; X64-NEXT:    cmpq $.LBB7_3, %rsi
; X64-NEXT:    cmovneq %r10, %r9
; X64-NEXT:    addl (%rdx), %eax
; X64-NEXT:    orl %r9d, %eax
; X64-NEXT:    movq $.LBB7_4, %rsi
; X64-NEXT:  .LBB7_4: # Block address taken
; X64-NEXT:    # %bb2
; X64-NEXT:    cmpq $.LBB7_4, %rsi
; X64-NEXT:    cmovneq %r10, %r9
; X64-NEXT:    addl (%rcx), %eax
; X64-NEXT:    orl %r9d, %eax
; X64-NEXT:    movq $.LBB7_5, %rsi
; X64-NEXT:  .LBB7_5: # Block address taken
; X64-NEXT:    # %bb3
; X64-NEXT:    cmpq $.LBB7_5, %rsi
; X64-NEXT:    cmovneq %r10, %r9
; X64-NEXT:    addl (%r8), %eax
; X64-NEXT:    orl %r9d, %eax
; X64-NEXT:    movq $.LBB7_6, %rsi
; X64-NEXT:  .LBB7_6: # Block address taken
; X64-NEXT:    # %bb4
; X64-NEXT:    cmpq $.LBB7_6, %rsi
; X64-NEXT:    cmovneq %r10, %r9
; X64-NEXT:    shlq $47, %r9
; X64-NEXT:    orq %r9, %rsp
; X64-NEXT:    retq
;
; X64-PIC-LABEL: test_switch_jumptable_fallthrough:
; X64-PIC:       # %bb.0: # %entry
; X64-PIC-NEXT:    movq %rsp, %r9
; X64-PIC-NEXT:    movq $-1, %r10
; X64-PIC-NEXT:    sarq $63, %r9
; X64-PIC-NEXT:    cmpl $3, %edi
; X64-PIC-NEXT:    ja .LBB7_2
; X64-PIC-NEXT:  # %bb.1: # %entry
; X64-PIC-NEXT:    cmovaq %r10, %r9
; X64-PIC-NEXT:    xorl %eax, %eax
; X64-PIC-NEXT:    movl %edi, %esi
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rdi
; X64-PIC-NEXT:    movslq (%rdi,%rsi,4), %rsi
; X64-PIC-NEXT:    addq %rdi, %rsi
; X64-PIC-NEXT:    orq %r9, %rsi
; X64-PIC-NEXT:    jmpq *%rsi
; X64-PIC-NEXT:  .LBB7_2: # %bb0
; X64-PIC-NEXT:    cmovbeq %r10, %r9
; X64-PIC-NEXT:    movl (%rsi), %eax
; X64-PIC-NEXT:    orl %r9d, %eax
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:  .LBB7_3: # Block address taken
; X64-PIC-NEXT:    # %bb1
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rdi
; X64-PIC-NEXT:    cmpq %rdi, %rsi
; X64-PIC-NEXT:    cmovneq %r10, %r9
; X64-PIC-NEXT:    addl (%rdx), %eax
; X64-PIC-NEXT:    orl %r9d, %eax
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:  .LBB7_4: # Block address taken
; X64-PIC-NEXT:    # %bb2
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rdx
; X64-PIC-NEXT:    cmpq %rdx, %rsi
; X64-PIC-NEXT:    cmovneq %r10, %r9
; X64-PIC-NEXT:    addl (%rcx), %eax
; X64-PIC-NEXT:    orl %r9d, %eax
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:  .LBB7_5: # Block address taken
; X64-PIC-NEXT:    # %bb3
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rcx
; X64-PIC-NEXT:    cmpq %rcx, %rsi
; X64-PIC-NEXT:    cmovneq %r10, %r9
; X64-PIC-NEXT:    addl (%r8), %eax
; X64-PIC-NEXT:    orl %r9d, %eax
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rsi
; X64-PIC-NEXT:  .LBB7_6: # Block address taken
; X64-PIC-NEXT:    # %bb4
; X64-PIC-NEXT:    leaq {{.*}}(%rip), %rcx
; X64-PIC-NEXT:    cmpq %rcx, %rsi
; X64-PIC-NEXT:    cmovneq %r10, %r9
; X64-PIC-NEXT:    shlq $47, %r9
; X64-PIC-NEXT:    orq %r9, %rsp
; X64-PIC-NEXT:    retq
;
; X64-RETPOLINE-LABEL: test_switch_jumptable_fallthrough:
; X64-RETPOLINE:       # %bb.0: # %entry
; X64-RETPOLINE-NEXT:    movq %rsp, %r9
; X64-RETPOLINE-NEXT:    movq $-1, %r10
; X64-RETPOLINE-NEXT:    sarq $63, %r9
; X64-RETPOLINE-NEXT:    xorl %eax, %eax
; X64-RETPOLINE-NEXT:    cmpl $1, %edi
; X64-RETPOLINE-NEXT:    jg .LBB8_5
; X64-RETPOLINE-NEXT:  # %bb.1: # %entry
; X64-RETPOLINE-NEXT:    cmovgq %r10, %r9
; X64-RETPOLINE-NEXT:    testl %edi, %edi
; X64-RETPOLINE-NEXT:    je .LBB8_2
; X64-RETPOLINE-NEXT:  # %bb.3: # %entry
; X64-RETPOLINE-NEXT:    cmoveq %r10, %r9
; X64-RETPOLINE-NEXT:    cmpl $1, %edi
; X64-RETPOLINE-NEXT:    jne .LBB8_8
; X64-RETPOLINE-NEXT:  # %bb.4:
; X64-RETPOLINE-NEXT:    cmovneq %r10, %r9
; X64-RETPOLINE-NEXT:    jmp .LBB8_10
; X64-RETPOLINE-NEXT:  .LBB8_5: # %entry
; X64-RETPOLINE-NEXT:    cmovleq %r10, %r9
; X64-RETPOLINE-NEXT:    cmpl $2, %edi
; X64-RETPOLINE-NEXT:    je .LBB8_6
; X64-RETPOLINE-NEXT:  # %bb.7: # %entry
; X64-RETPOLINE-NEXT:    cmoveq %r10, %r9
; X64-RETPOLINE-NEXT:    cmpl $3, %edi
; X64-RETPOLINE-NEXT:    jne .LBB8_8
; X64-RETPOLINE-NEXT:  # %bb.13:
; X64-RETPOLINE-NEXT:    cmovneq %r10, %r9
; X64-RETPOLINE-NEXT:    jmp .LBB8_12
; X64-RETPOLINE-NEXT:  .LBB8_8:
; X64-RETPOLINE-NEXT:    cmoveq %r10, %r9
; X64-RETPOLINE-NEXT:    movl (%rsi), %eax
; X64-RETPOLINE-NEXT:    orl %r9d, %eax
; X64-RETPOLINE-NEXT:    jmp .LBB8_9
; X64-RETPOLINE-NEXT:  .LBB8_2:
; X64-RETPOLINE-NEXT:    cmovneq %r10, %r9
; X64-RETPOLINE-NEXT:  .LBB8_9: # %bb1
; X64-RETPOLINE-NEXT:    addl (%rdx), %eax
; X64-RETPOLINE-NEXT:    orl %r9d, %eax
; X64-RETPOLINE-NEXT:  .LBB8_10: # %bb2
; X64-RETPOLINE-NEXT:    addl (%rcx), %eax
; X64-RETPOLINE-NEXT:    orl %r9d, %eax
; X64-RETPOLINE-NEXT:    jmp .LBB8_11
; X64-RETPOLINE-NEXT:  .LBB8_6:
; X64-RETPOLINE-NEXT:    cmovneq %r10, %r9
; X64-RETPOLINE-NEXT:  .LBB8_11: # %bb3
; X64-RETPOLINE-NEXT:    addl (%r8), %eax
; X64-RETPOLINE-NEXT:    orl %r9d, %eax
; X64-RETPOLINE-NEXT:  .LBB8_12: # %bb4
; X64-RETPOLINE-NEXT:    shlq $47, %r9
; X64-RETPOLINE-NEXT:    orq %r9, %rsp
; X64-RETPOLINE-NEXT:    retq
entry:
  switch i32 %idx, label %bb0 [
    i32 0, label %bb1
    i32 1, label %bb2
    i32 2, label %bb3
    i32 3, label %bb4
  ]

bb0:
  %a = load i32, i32* %a.ptr
  br label %bb1

bb1:
  %b.phi = phi i32 [ 0, %entry ], [ %a, %bb0 ]
  %b = load i32, i32* %b.ptr
  %b.sum = add i32 %b.phi, %b
  br label %bb2

bb2:
  %c.phi = phi i32 [ 0, %entry ], [ %b.sum, %bb1 ]
  %c = load i32, i32* %c.ptr
  %c.sum = add i32 %c.phi, %c
  br label %bb3

bb3:
  %d.phi = phi i32 [ 0, %entry ], [ %c.sum, %bb2 ]
  %d = load i32, i32* %d.ptr
  %d.sum = add i32 %d.phi, %d
  br label %bb4

bb4:
  %e.phi = phi i32 [ 0, %entry ], [ %d.sum, %bb3 ]
  ret i32 %e.phi
}
