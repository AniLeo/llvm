; RUN: llc < %s | FileCheck %s
; RUN: %if ptxas %{ llc < %s | %ptxas-verify %}

target triple = "nvptx64-nvidia-cuda"

declare void @llvm.nvvm.barrier0()

; Load a value, then syncthreads.  Branch, and use the loaded value only on one
; side of the branch.  The load shouldn't be sunk beneath the call, because
; syncthreads is modeled as maystore.
define i32 @f(i32 %x, i32* %ptr, i1 %cond) {
Start:
  ; CHECK: ld.u32
  %ptr_val = load i32, i32* %ptr
  ; CHECK: bar.sync
  call void @llvm.nvvm.barrier0()
  br i1 %cond, label %L1, label %L2
L1:
  %ptr_val2 = add i32 %ptr_val, 100
  br label %L2
L2:
  %v4 = phi i32 [ %x, %Start ], [ %ptr_val2, %L1 ]
  %v5 = add i32 %v4, 1000
  ret i32 %v5
}
