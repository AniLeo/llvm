; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=skylake < %s | FileCheck %s

target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Shows a case where we spill a 32 byte value onto a stack which is only
; 16 byte aligned.  With stack realignment, we can use an aligned spill slot
; (if we think it's profitable), but without realignment, using a stack
; slot which is 32 byte aligned or a store which expects 32 byte alignment
; is incorrect.

declare void @foo()
define void @can_realign(<8 x i32>* %p) {
; CHECK-LABEL: can_realign:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    andq $-32, %rsp
; CHECK-NEXT:    subq $64, %rsp
; CHECK-NEXT:    vmovaps (%rdi), %ymm0
; CHECK-NEXT:    vmovaps %ymm0, (%rsp)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq foo
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    movq %rbp, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    retq
  %val = load <8 x i32>, <8 x i32>* %p, align 32
  call void @foo() ["deopt" (<8 x i32> %val)]
  ret void
}

define void @no_realign(<8 x i32>* %p) "no-realign-stack" {
; CHECK-LABEL: no_realign:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    vmovaps (%rdi), %ymm0
; CHECK-NEXT:    vmovups %ymm0, (%rsp)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq foo
; CHECK-NEXT:  .Ltmp1:
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  %val = load <8 x i32>, <8 x i32>* %p, align 32
  call void @foo() ["deopt" (<8 x i32> %val)]
  ret void
}

;; Next batch are similiar to the above, but require a reload of the
;; spilled value as well.

define <4 x i8 addrspace(1)*> @spillfill_can_realign(<4 x i8 addrspace(1)*> %obj) gc "statepoint-example" {
; CHECK-LABEL: spillfill_can_realign:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    andq $-32, %rsp
; CHECK-NEXT:    subq $64, %rsp
; CHECK-NEXT:    vmovaps %ymm0, (%rsp)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq do_safepoint
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    vmovaps (%rsp), %ymm0
; CHECK-NEXT:    movq %rbp, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) ["gc-live" (<4 x i8 addrspace(1)*> %obj)]
  %obj.relocated = call coldcc <4 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v4p1i8(token %safepoint_token, i32 0, i32 0) ; (%obj, %obj)
  ret <4 x i8 addrspace(1)*> %obj.relocated
}

define <4 x i8 addrspace(1)*> @spillfill_no_realign(<4 x i8 addrspace(1)*> %obj) "no-realign-stack" gc "statepoint-example" {
; CHECK-LABEL: spillfill_no_realign:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    vmovups %ymm0, (%rsp)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    callq do_safepoint
; CHECK-NEXT:  .Ltmp3:
; CHECK-NEXT:    vmovups (%rsp), %ymm0
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) ["gc-live" (<4 x i8 addrspace(1)*> %obj)]
  %obj.relocated = call coldcc <4 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v4p1i8(token %safepoint_token, i32 0, i32 0) ; (%obj, %obj)
  ret <4 x i8 addrspace(1)*> %obj.relocated
}

declare void @do_safepoint()

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
declare i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token, i32, i32)
declare <4 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v4p1i8(token, i32, i32)
