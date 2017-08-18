; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -O3 < %s | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

declare void @bar() #0
declare void @baz()

define void @test1(i32 %a) gc "statepoint-example" {
; CHECK-LABEL: test1:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:  Lcfi0:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp0:
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
; We expect the argument to be passed in an extra register to bar
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 1, i32 %a)
  ret void
}

define void @test2(i32 %a, i32 %b) gc "statepoint-example" {
; CHECK-LABEL: test2:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:  Lcfi1:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:  Lcfi2:
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:  Lcfi3:
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:  Lcfi4:
; CHECK-NEXT:    .cfi_offset %rbx, -24
; CHECK-NEXT:  Lcfi5:
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %ebp
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp1:
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp2:
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
entry:
; Because the first call clobbers esi, we have to move the values into
; new registers.  Note that they stay in the registers for both calls.
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 2, i32 %a, i32 %b)
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 2, i32 %b, i32 %a)
  ret void
}

define void @test3(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i) gc "statepoint-example" {
; CHECK-LABEL: test3:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:  Lcfi6:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp3:
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
; We directly reference the argument slot
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 9, i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i)
  ret void
}

; This case just confirms that we don't crash when given more live values
; than registers.  This is a case where we *have* to use a stack slot.  This
; also ends up being a good test of whether we can fold loads from immutable
; stack slots into the statepoint.
define void @test4(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z) gc "statepoint-example" {
; CHECK-LABEL: test4:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:  Lcfi7:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp4:
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %statepoint_token1 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 26, i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, i32 %l, i32 %m, i32 %n, i32 %o, i32 %p, i32 %q, i32 %r, i32 %s, i32 %t, i32 %u, i32 %v, i32 %w, i32 %x, i32 %y, i32 %z)
  ret void
}

; A live-through gc-value must be spilled even if it is also a live-in deopt
; value.  For live-in, we could technically report the register copy, but from
; a code quality perspective it's better to reuse the required stack slot so
; as to put less stress on the register allocator for no benefit.
define  i32 addrspace(1)* @test5(i32 %a, i32 addrspace(1)* %p) gc "statepoint-example" {
; CHECK-LABEL: test5:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:  Lcfi8:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movq %rsi, (%rsp)
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp5:
; CHECK-NEXT:    movq (%rsp), %rax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
entry:
  %token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 1, i32 %a, i32 addrspace(1)* %p, i32 addrspace(1)* %p)
  %p2 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %token,  i32 9, i32 9)
  ret i32 addrspace(1)* %p2
}

; Show the interaction of live-through spilling followed by live-in.
define void @test6(i32 %a) gc "statepoint-example" {
; CHECK-LABEL: test6:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:  Lcfi9:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    subq $16, %rsp
; CHECK-NEXT:  Lcfi10:
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:  Lcfi11:
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movl %edi, %ebx
; CHECK-NEXT:    movl %ebx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    callq _baz
; CHECK-NEXT:  Ltmp6:
; CHECK-NEXT:    callq _bar
; CHECK-NEXT:  Ltmp7:
; CHECK-NEXT:    addq $16, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
entry:
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @baz, i32 0, i32 0, i32 0, i32 1, i32 %a)
  call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @bar, i32 0, i32 2, i32 0, i32 1, i32 %a)
  ret void
}


; CHECK: Ltmp0-_test1
; CHECK:      .byte	1
; CHECK-NEXT:   .byte   0
; CHECK-NEXT: .short 4
; CHECK-NEXT: .short	5
; CHECK-NEXT:   .short  0
; CHECK-NEXT: .long	0

; CHECK: Ltmp1-_test2
; CHECK:      .byte	1
; CHECK-NEXT:   .byte   0
; CHECK-NEXT: .short 4
; CHECK-NEXT: .short	6
; CHECK-NEXT:   .short  0
; CHECK-NEXT: .long	0
; CHECK:      .byte	1
; CHECK-NEXT:   .byte   0
; CHECK-NEXT: .short 4
; CHECK-NEXT: .short	3
; CHECK-NEXT:   .short  0
; CHECK-NEXT: .long	0
; CHECK: Ltmp2-_test2
; CHECK:      .byte	1
; CHECK-NEXT:   .byte   0
; CHECK-NEXT: .short 4
; CHECK-NEXT: .short	3
; CHECK-NEXT:   .short  0
; CHECK-NEXT: .long	0
; CHECK:      .byte	1
; CHECK-NEXT:   .byte   0
; CHECK-NEXT: .short 4
; CHECK-NEXT: .short	6
; CHECK-NEXT:   .short  0
; CHECK-NEXT: .long	0

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
declare i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token, i32, i32)


attributes #0 = { "deopt-lowering"="live-in" }
attributes #1 = { "deopt-lowering"="live-through" }
