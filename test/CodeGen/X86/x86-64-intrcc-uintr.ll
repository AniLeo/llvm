; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --no_x86_scrub_sp --no_x86_scrub_rip
; RUN: llc < %s | FileCheck %s -check-prefixes=CHECK-USER
; RUN: llc -O0 < %s | FileCheck %s -check-prefixes=CHECK0-USER
; RUN: llc -code-model=kernel < %s | FileCheck %s -check-prefixes=CHECK-KERNEL
; RUN: llc -O0 -code-model=kernel < %s | FileCheck %s -check-prefixes=CHECK0-KERNEL

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.__uintr_frame = type { i64, i64, i64 }

; #include <x86gprintrin.h>
;
; void
; __attribute__ ((interrupt))
; test_uintr_isr_cc_empty(struct __uintr_frame *frame, unsigned long long uirrv)
; {
; }

define dso_local x86_intrcc void @test_uintr_isr_cc_empty(%struct.__uintr_frame* nocapture byval(%struct.__uintr_frame) %frame, i64 %uirrv) #0 {
; CHECK-USER-LABEL: test_uintr_isr_cc_empty:
; CHECK-USER:       # %bb.0: # %entry
; CHECK-USER-NEXT:    pushq %rax
; CHECK-USER-NEXT:    cld
; CHECK-USER-NEXT:    addq $16, %rsp
; CHECK-USER-NEXT:    uiret
;
; CHECK0-USER-LABEL: test_uintr_isr_cc_empty:
; CHECK0-USER:       # %bb.0: # %entry
; CHECK0-USER-NEXT:    pushq %rax
; CHECK0-USER-NEXT:    cld
; CHECK0-USER-NEXT:    addq $16, %rsp
; CHECK0-USER-NEXT:    uiret
;
; CHECK-KERNEL-LABEL: test_uintr_isr_cc_empty:
; CHECK-KERNEL:       # %bb.0: # %entry
; CHECK-KERNEL-NEXT:    pushq %rax
; CHECK-KERNEL-NEXT:    cld
; CHECK-KERNEL-NEXT:    addq $16, %rsp
; CHECK-KERNEL-NEXT:    iretq
;
; CHECK0-KERNEL-LABEL: test_uintr_isr_cc_empty:
; CHECK0-KERNEL:       # %bb.0: # %entry
; CHECK0-KERNEL-NEXT:    pushq %rax
; CHECK0-KERNEL-NEXT:    cld
; CHECK0-KERNEL-NEXT:    addq $16, %rsp
; CHECK0-KERNEL-NEXT:    iretq
entry:
  ret void
}

; unsigned long long g_rip;
; unsigned long long g_rflags;
; unsigned long long g_rsp;
; unsigned long long g_uirrv;
;
; void
; __attribute__((interrupt))
; test_uintr_isr_cc_args(struct __uintr_frame *frame, unsigned long long uirrv)
; {
;   g_rip = frame->rip;
;   g_rflags = frame->rflags;
;   g_rsp = frame->rsp;
;   g_uirrv = uirrv;
; }
@g_rip = dso_local local_unnamed_addr global i64 0, align 8
@g_rflags = dso_local local_unnamed_addr global i64 0, align 8
@g_rsp = dso_local local_unnamed_addr global i64 0, align 8
@g_uirrv = dso_local local_unnamed_addr global i64 0, align 8

define dso_local x86_intrcc void @test_uintr_isr_cc_args(%struct.__uintr_frame* nocapture readonly byval(%struct.__uintr_frame) %frame, i64 %uirrv) #0 {
; CHECK-USER-LABEL: test_uintr_isr_cc_args:
; CHECK-USER:       # %bb.0: # %entry
; CHECK-USER-NEXT:    pushq %rax
; CHECK-USER-NEXT:    pushq %rax
; CHECK-USER-NEXT:    pushq %rdx
; CHECK-USER-NEXT:    pushq %rcx
; CHECK-USER-NEXT:    cld
; CHECK-USER-NEXT:    movq 32(%rsp), %rax
; CHECK-USER-NEXT:    movq 40(%rsp), %rcx
; CHECK-USER-NEXT:    movq 48(%rsp), %rdx
; CHECK-USER-NEXT:    movq %rcx, g_rip(%rip)
; CHECK-USER-NEXT:    movq %rdx, g_rflags(%rip)
; CHECK-USER-NEXT:    movq 56(%rsp), %rcx
; CHECK-USER-NEXT:    movq %rcx, g_rsp(%rip)
; CHECK-USER-NEXT:    movq %rax, g_uirrv(%rip)
; CHECK-USER-NEXT:    popq %rcx
; CHECK-USER-NEXT:    popq %rdx
; CHECK-USER-NEXT:    popq %rax
; CHECK-USER-NEXT:    addq $16, %rsp
; CHECK-USER-NEXT:    uiret
;
; CHECK0-USER-LABEL: test_uintr_isr_cc_args:
; CHECK0-USER:       # %bb.0: # %entry
; CHECK0-USER-NEXT:    pushq %rax
; CHECK0-USER-NEXT:    pushq %rax
; CHECK0-USER-NEXT:    pushq %rdx
; CHECK0-USER-NEXT:    pushq %rcx
; CHECK0-USER-NEXT:    cld
; CHECK0-USER-NEXT:    movq 32(%rsp), %rax
; CHECK0-USER-NEXT:    leaq 40(%rsp), %rcx
; CHECK0-USER-NEXT:    movq (%rcx), %rdx
; CHECK0-USER-NEXT:    movq %rdx, g_rip(%rip)
; CHECK0-USER-NEXT:    movq 8(%rcx), %rdx
; CHECK0-USER-NEXT:    movq %rdx, g_rflags(%rip)
; CHECK0-USER-NEXT:    movq 16(%rcx), %rcx
; CHECK0-USER-NEXT:    movq %rcx, g_rsp(%rip)
; CHECK0-USER-NEXT:    movq %rax, g_uirrv(%rip)
; CHECK0-USER-NEXT:    popq %rcx
; CHECK0-USER-NEXT:    popq %rdx
; CHECK0-USER-NEXT:    popq %rax
; CHECK0-USER-NEXT:    addq $16, %rsp
; CHECK0-USER-NEXT:    uiret
;
; CHECK-KERNEL-LABEL: test_uintr_isr_cc_args:
; CHECK-KERNEL:       # %bb.0: # %entry
; CHECK-KERNEL-NEXT:    pushq %rax
; CHECK-KERNEL-NEXT:    pushq %rax
; CHECK-KERNEL-NEXT:    pushq %rdx
; CHECK-KERNEL-NEXT:    pushq %rcx
; CHECK-KERNEL-NEXT:    cld
; CHECK-KERNEL-NEXT:    movq 32(%rsp), %rax
; CHECK-KERNEL-NEXT:    movq 40(%rsp), %rcx
; CHECK-KERNEL-NEXT:    movq 48(%rsp), %rdx
; CHECK-KERNEL-NEXT:    movq %rcx, g_rip(%rip)
; CHECK-KERNEL-NEXT:    movq %rdx, g_rflags(%rip)
; CHECK-KERNEL-NEXT:    movq 56(%rsp), %rcx
; CHECK-KERNEL-NEXT:    movq %rcx, g_rsp(%rip)
; CHECK-KERNEL-NEXT:    movq %rax, g_uirrv(%rip)
; CHECK-KERNEL-NEXT:    popq %rcx
; CHECK-KERNEL-NEXT:    popq %rdx
; CHECK-KERNEL-NEXT:    popq %rax
; CHECK-KERNEL-NEXT:    addq $16, %rsp
; CHECK-KERNEL-NEXT:    iretq
;
; CHECK0-KERNEL-LABEL: test_uintr_isr_cc_args:
; CHECK0-KERNEL:       # %bb.0: # %entry
; CHECK0-KERNEL-NEXT:    pushq %rax
; CHECK0-KERNEL-NEXT:    pushq %rax
; CHECK0-KERNEL-NEXT:    pushq %rdx
; CHECK0-KERNEL-NEXT:    pushq %rcx
; CHECK0-KERNEL-NEXT:    cld
; CHECK0-KERNEL-NEXT:    movq 32(%rsp), %rax
; CHECK0-KERNEL-NEXT:    leaq 40(%rsp), %rcx
; CHECK0-KERNEL-NEXT:    movq (%rcx), %rdx
; CHECK0-KERNEL-NEXT:    movq %rdx, g_rip(%rip)
; CHECK0-KERNEL-NEXT:    movq 8(%rcx), %rdx
; CHECK0-KERNEL-NEXT:    movq %rdx, g_rflags(%rip)
; CHECK0-KERNEL-NEXT:    movq 16(%rcx), %rcx
; CHECK0-KERNEL-NEXT:    movq %rcx, g_rsp(%rip)
; CHECK0-KERNEL-NEXT:    movq %rax, g_uirrv(%rip)
; CHECK0-KERNEL-NEXT:    popq %rcx
; CHECK0-KERNEL-NEXT:    popq %rdx
; CHECK0-KERNEL-NEXT:    popq %rax
; CHECK0-KERNEL-NEXT:    addq $16, %rsp
; CHECK0-KERNEL-NEXT:    iretq
entry:
  %rip = getelementptr inbounds %struct.__uintr_frame, %struct.__uintr_frame* %frame, i64 0, i32 0
  %0 = load i64, i64* %rip, align 8
  store i64 %0, i64* @g_rip, align 8
  %rflags = getelementptr inbounds %struct.__uintr_frame, %struct.__uintr_frame* %frame, i64 0, i32 1
  %1 = load i64, i64* %rflags, align 8
  store i64 %1, i64* @g_rflags, align 8
  %rsp = getelementptr inbounds %struct.__uintr_frame, %struct.__uintr_frame* %frame, i64 0, i32 2
  %2 = load i64, i64* %rsp, align 8
  store i64 %2, i64* @g_rsp, align 8
  store i64 %uirrv, i64* @g_uirrv, align 8
  ret void
}

attributes #0 = { nofree norecurse nounwind willreturn "disable-tail-calls"="true" "frame-pointer"="none" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+uintr" "tune-cpu"="generic" }
