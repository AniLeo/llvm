; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -verify-machineinstrs < %s | FileCheck %s

; Check that we can export values of "duplicated" gc.relocates without a crash
; "duplicate" here means maps to same SDValue.  We previously had an
; optimization which tried to reduce number of spills/stackmap entries in such
; cases, but it incorrectly handled exports across basis block boundaries
; leading to a crash in this case.

target triple = "x86_64-pc-linux-gnu"

declare void @func()

define i1 @test() gc "statepoint-example" {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq func@PLT
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    callq func@PLT
; CHECK-NEXT:  .Ltmp1:
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 0, i32 0, ptr elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (ptr addrspace(1) null, ptr addrspace(1) null)]
  %base = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token,  i32 0, i32 0)
  %derived = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token,  i32 0, i32 1)
  %safepoint_token2 = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 0, i32 0, ptr elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (ptr addrspace(1) %base, ptr addrspace(1) %derived)]
  br label %next

next:
  %base_reloc = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token2,  i32 0, i32 0)
  %derived_reloc = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token2,  i32 0, i32 1)
  %cmp1 = icmp eq ptr addrspace(1) %base_reloc, null
  %cmp2 = icmp eq ptr addrspace(1) %derived_reloc, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}

; Showing redundant fill on first statepoint and spill/fill on second one
define i1 @test2(ptr addrspace(1) %arg) gc "statepoint-example" {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movq %rdi, (%rsp)
; CHECK-NEXT:    callq func@PLT
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    callq func@PLT
; CHECK-NEXT:  .Ltmp3:
; CHECK-NEXT:    cmpq $0, (%rsp)
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %safepoint_token = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 0, i32 0, ptr elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (ptr addrspace(1) %arg, ptr addrspace(1) %arg)]
  %base = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token,  i32 0, i32 0)
  %derived = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token,  i32 0, i32 1)
  %safepoint_token2 = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 0, i32 0, ptr elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (ptr addrspace(1) %base, ptr addrspace(1) %derived)]
  br label %next

next:
  %base_reloc = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token2,  i32 0, i32 0)
  %derived_reloc = call ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token %safepoint_token2,  i32 0, i32 1)
  %cmp1 = icmp eq ptr addrspace(1) %base_reloc, null
  %cmp2 = icmp eq ptr addrspace(1) %derived_reloc, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}


declare token @llvm.experimental.gc.statepoint.p0(i64, i32, ptr, i32, i32, ...)
declare ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token, i32, i32)
