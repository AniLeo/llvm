# RUN: not llvm-mc -triple x86_64-windows-msvc %s -filetype=obj -o /dev/null 2>&1 | FileCheck %s --implicit-check-not=error:
	.text

	.seh_pushreg 6
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: .seh_ directive must appear within an active frame

	.seh_stackalloc 32
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: .seh_ directive must appear within an active frame

	.def	 f;
	.scl	2;
	.type	32;
	.endef
	.globl	f                       # -- Begin function f
	.p2align	4, 0x90
f:                                      # @f
.seh_proc f
	pushq	%rsi
	.seh_pushreg 6
	pushq	%rdi
	.seh_pushreg 7
	pushq	%rbx
	.seh_pushreg 3
	subq	$32, %rsp
	.seh_stackalloc 0
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: stack allocation size must be non-zero
	.seh_stackalloc 7
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: stack allocation size is not a multiple of 8
	.seh_stackalloc 32
	.seh_endprologue
	nop
	addq	$32, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	retq
	.seh_handlerdata
	.text
	.seh_endproc


	.seh_pushreg 6
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: .seh_ directive must appear within an active frame

g:
	.seh_proc g
	pushq %rbp
	.seh_pushreg 3
	pushq %rsi
	.seh_pushreg 6
	.seh_endprologue
	.seh_setframe 3 255
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: you must specify a stack pointer offset
	.seh_setframe 3, 255
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: offset is not a multiple of 16
	.seh_setframe 3, 256
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: frame offset must be less than or equal to 240
	.seh_setframe 3, 128
	.seh_setframe 3, 128
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: frame register and offset can be set at most once
	nop
	popq %rsi
	popq %rbp
	retq
	.seh_endproc

        .globl  h                       # -- Begin function h
        .p2align        4, 0x90
h:                                      # @h
.seh_proc h
# %bb.0:                                # %entry
        subq    $72, %rsp
        .seh_stackalloc 72
        movaps  %xmm7, 48(%rsp)         # 16-byte Spill
        .seh_savexmm 7 44
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: you must specify an offset on the stack
        .seh_savexmm 7, 44
	# CHECK: :[[@LINE-1]]:{{[0-9]+}}: error: offset is not a multiple of 16
        .seh_savexmm 7, 48
        movaps  %xmm6, 32(%rsp)         # 16-byte Spill
        .seh_savexmm 6, 32
        .seh_endprologue
        movapd  %xmm0, %xmm6
        callq   getdbl
        movapd  %xmm0, %xmm7
        addsd   %xmm6, %xmm7
        callq   getdbl
        addsd   %xmm7, %xmm0
        movaps  32(%rsp), %xmm6         # 16-byte Reload
        movaps  48(%rsp), %xmm7         # 16-byte Reload
        addq    $72, %rsp
        retq
        .seh_handlerdata
        .text
        .seh_endproc
                                        # -- End function
