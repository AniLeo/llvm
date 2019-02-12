; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s | FileCheck %s
; Test to check that Statepoints with X64 far-immediate targets
; are lowered correctly to an indirect call via a scratch register.

target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-win64"

define void @test_far_call() gc "statepoint-example" {
; CHECK-LABEL: test_far_call:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movabsq $140727162896504, %rax # imm = 0x7FFD988E0078
; CHECK-NEXT:    callq *%rax
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq

entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* inttoptr (i64 140727162896504 to void ()*), i32 0, i32 0, i32 0, i32 0)
  ret void
}

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)

