# REQUIRES: asserts
# RUN: llvm-mc -triple=x86_64-apple-macosx10.9 -filetype=obj -o %t %s
# RUN: llvm-jitlink -debug-only=orc -noexec %t 2>&1 | FileCheck %s
#
# Check that presence of a "__DWARF" section triggers the
# GDBJITDebugInfoRegistrationPlugin.
#
# CHECK: Registering debug object with GDB JIT interface

	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	4, 0x90
_main:
	xorl	%eax, %eax
	retq

	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"test dwarf string"

.subsections_via_symbols
