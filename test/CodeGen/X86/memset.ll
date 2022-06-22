; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=pentium2 -mtriple=i686-apple-darwin8.8.0 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mcpu=pentium3 -mtriple=i686-apple-darwin8.8.0 | FileCheck %s --check-prefix=XMM
; RUN: llc < %s -mcpu=bdver1   -mtriple=i686-apple-darwin8.8.0 | FileCheck %s --check-prefix=YMM

%struct.x = type { i16, i16 }

define void @t() nounwind  {
; X86-LABEL: t:
; X86:       ## %bb.0: ## %entry
; X86-NEXT:    subl $44, %esp
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    calll _foo
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    retl
;
; XMM-LABEL: t:
; XMM:       ## %bb.0: ## %entry
; XMM-NEXT:    subl $60, %esp
; XMM-NEXT:    xorps %xmm0, %xmm0
; XMM-NEXT:    movaps %xmm0, {{[0-9]+}}(%esp)
; XMM-NEXT:    movaps %xmm0, {{[0-9]+}}(%esp)
; XMM-NEXT:    leal {{[0-9]+}}(%esp), %eax
; XMM-NEXT:    movl %eax, (%esp)
; XMM-NEXT:    calll _foo
; XMM-NEXT:    addl $60, %esp
; XMM-NEXT:    retl
;
; YMM-LABEL: t:
; YMM:       ## %bb.0: ## %entry
; YMM-NEXT:    pushl %ebp
; YMM-NEXT:    movl %esp, %ebp
; YMM-NEXT:    andl $-32, %esp
; YMM-NEXT:    subl $96, %esp
; YMM-NEXT:    leal {{[0-9]+}}(%esp), %eax
; YMM-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; YMM-NEXT:    vmovaps %ymm0, {{[0-9]+}}(%esp)
; YMM-NEXT:    movl %eax, (%esp)
; YMM-NEXT:    vzeroupper
; YMM-NEXT:    calll _foo
; YMM-NEXT:    movl %ebp, %esp
; YMM-NEXT:    popl %ebp
; YMM-NEXT:    retl
entry:
	%up_mvd = alloca [8 x %struct.x]		; <ptr> [#uses=2]
	%up_mvd116 = getelementptr [8 x %struct.x], ptr %up_mvd, i32 0, i32 0		; <ptr> [#uses=1]

	call void @llvm.memset.p0.i64(ptr align 8 %up_mvd, i8 0, i64 32, i1 false)
	call void @foo( ptr %up_mvd116 ) nounwind
	ret void
}

declare void @foo(ptr)

declare void @llvm.memset.p0.i64(ptr nocapture, i8, i64, i1) nounwind

; Ensure that alignment of '0' in an @llvm.memset intrinsic results in
; unaligned loads and stores.
define void @PR15348(ptr %a) {
; X86-LABEL: PR15348:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb $0, 16(%eax)
; X86-NEXT:    movl $0, 12(%eax)
; X86-NEXT:    movl $0, 8(%eax)
; X86-NEXT:    movl $0, 4(%eax)
; X86-NEXT:    movl $0, (%eax)
; X86-NEXT:    retl
;
; XMM-LABEL: PR15348:
; XMM:       ## %bb.0:
; XMM-NEXT:    movl {{[0-9]+}}(%esp), %eax
; XMM-NEXT:    movb $0, 16(%eax)
; XMM-NEXT:    movl $0, 12(%eax)
; XMM-NEXT:    movl $0, 8(%eax)
; XMM-NEXT:    movl $0, 4(%eax)
; XMM-NEXT:    movl $0, (%eax)
; XMM-NEXT:    retl
;
; YMM-LABEL: PR15348:
; YMM:       ## %bb.0:
; YMM-NEXT:    movl {{[0-9]+}}(%esp), %eax
; YMM-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; YMM-NEXT:    vmovups %xmm0, (%eax)
; YMM-NEXT:    movb $0, 16(%eax)
; YMM-NEXT:    retl
  call void @llvm.memset.p0.i64(ptr %a, i8 0, i64 17, i1 false)
  ret void
}
