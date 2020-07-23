; RUN: llc < %s | FileCheck %s


target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @foo_noprotect() local_unnamed_addr {
; CHECK-LABEL: foo_noprotect:
; CHECK:       # %bb.0:
; CHECK-NEXT:	pushq	%rbp
; CHECK-NEXT:   .cfi_def_cfa_offset 16
; CHECK-NEXT:   .cfi_offset %rbp, -16
; CHECK-NEXT:   movq	%rsp, %rbp
; CHECK-NEXT:   .cfi_def_cfa_register %rbp
; CHECK-NEXT:   andq	$-4096, %rsp                    # imm = 0xF000
; CHECK-NEXT:   subq	$73728, %rsp                    # imm = 0x12000
; CHECK-NEXT:   movl	$1, 392(%rsp)
; CHECK-NEXT:   movl	$1, 28792(%rsp)
; CHECK-NEXT:   movl	(%rsp), %eax
; CHECK-NEXT:   movq	%rbp, %rsp
; CHECK-NEXT:   popq	%rbp
; CHECK-NEXT:   .cfi_def_cfa %rsp, 8
; CHECK-NEXT:   retq


  %a = alloca i32, i64 18000, align 4096
  %b0 = getelementptr inbounds i32, i32* %a, i64 98
  %b1 = getelementptr inbounds i32, i32* %a, i64 7198
  store volatile i32 1, i32* %b0
  store volatile i32 1, i32* %b1
  %c = load volatile i32, i32* %a
  ret i32 %c
}

define i32 @foo_protect() local_unnamed_addr #0 {
; CHECK-LABEL: foo_protect:
; CHECK:       # %bb.0:
; CHECK-NEXT:	pushq	%rbp
; CHECK-NEXT:	.cfi_def_cfa_offset 16
; CHECK-NEXT:	.cfi_offset %rbp, -16
; CHECK-NEXT:	movq	%rsp, %rbp
; CHECK-NEXT:	.cfi_def_cfa_register %rbp
; CHECK-NEXT:	movq	%rsp, %r11
; CHECK-NEXT:	andq	$-4096, %r11                    # imm = 0xF000
; CHECK-NEXT:	cmpq	%rsp, %r11
; CHECK-NEXT:	je	.LBB1_4
; CHECK-NEXT:# %bb.1:
; CHECK-NEXT:	subq	$4096, %rsp                     # imm = 0x1000
; CHECK-NEXT:	cmpq	%rsp, %r11
; CHECK-NEXT:	jb	.LBB1_3
; CHECK-NEXT:.LBB1_2:                                # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:	movq	$0, (%rsp)
; CHECK-NEXT:	subq	$4096, %rsp                     # imm = 0x1000
; CHECK-NEXT:	cmpq	%rsp, %r11
; CHECK-NEXT:	jb	.LBB1_2
; CHECK-NEXT:.LBB1_3:
; CHECK-NEXT:	movq	%r11, %rsp
; CHECK-NEXT:	movq	$0, (%rsp)
; CHECK-NEXT:.LBB1_4:
; CHECK-NEXT:	movq	%rsp, %r11
; CHECK-NEXT:	subq	$73728, %r11                    # imm = 0x12000
; CHECK-NEXT:.LBB1_5:                                # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:	subq	$4096, %rsp                     # imm = 0x1000
; CHECK-NEXT:	movq	$0, (%rsp)
; CHECK-NEXT:	cmpq	%r11, %rsp
; CHECK-NEXT:	jne	.LBB1_5
; CHECK-NEXT:# %bb.6:
; CHECK-NEXT:	movl	$1, 392(%rsp)
; CHECK-NEXT:	movl	$1, 28792(%rsp)
; CHECK-NEXT:	movl	(%rsp), %eax
; CHECK-NEXT:	movq	%rbp, %rsp
; CHECK-NEXT:	popq	%rbp
; CHECK-NEXT:	.cfi_def_cfa %rsp, 8
; CHECK-NEXT:	retq




  %a = alloca i32, i64 18000, align 4096
  %b0 = getelementptr inbounds i32, i32* %a, i64 98
  %b1 = getelementptr inbounds i32, i32* %a, i64 7198
  store volatile i32 1, i32* %b0
  store volatile i32 1, i32* %b1
  %c = load volatile i32, i32* %a
  ret i32 %c
}

attributes #0 =  {"probe-stack"="inline-asm"}
