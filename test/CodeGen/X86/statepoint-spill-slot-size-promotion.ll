; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK
;
; Test different type sizes of deop bundle operands.
;
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-win64"

define i1 @test_spill_slot_size(i1 %a1, i2 %a2, i7 %a7, i8 %a8, i9 %a9, i15 %a15, i16 %a16, i32 %a32, i64 %a64, i128 %a128, i32 addrspace(1)* %obj1) gc "statepoint-example" {
; CHECK-LABEL: test_spill_slot_size:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    subq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %r10
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %r11
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movzwl {{[0-9]+}}(%rsp), %edi
; CHECK-NEXT:    movw %di, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %r11, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %r10, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb %cl, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    andb $3, %sil
; CHECK-NEXT:    movb %sil, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    andb $127, %dl
; CHECK-NEXT:    movb %dl, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    andl $511, %r8d # imm = 0x1FF
; CHECK-NEXT:    movw %r8w, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    andl $32767, %r9d # imm = 0x7FFF
; CHECK-NEXT:    movw %r9w, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movabsq $140727162896504, %rax # imm = 0x7FFD988E0078
; CHECK-NEXT:    callq *%rax
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    addq $32, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq

entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* elementtype(void ()) inttoptr (i64 140727162896504 to void ()*), i32 0, i32 0, i32 0, i32 0)
      [ "deopt"(i1 %a1, i2 %a2, i7 %a7, i8 %a8, i9 %a9, i15 %a15, i16 %a16, i32 %a32, i64 %a64, i128 %a128, i32 addrspace(1)* %obj1) ]
  ret i1 %a1
}

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
