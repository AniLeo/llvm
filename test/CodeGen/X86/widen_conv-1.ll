; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X64

; truncate v2i64 to v2i32

define void @convert_v2i64_to_v2i32(ptr %dst.addr, <2 x i64> %src) nounwind {
; X86-LABEL: convert_v2i64_to_v2i32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    pcmpeqd %xmm1, %xmm1
; X86-NEXT:    psubd %xmm1, %xmm0
; X86-NEXT:    movq %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: convert_v2i64_to_v2i32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    pcmpeqd %xmm1, %xmm1
; X64-NEXT:    psubd %xmm1, %xmm0
; X64-NEXT:    movq %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
	%val = trunc <2 x i64> %src to <2 x i32>
	%add = add <2 x i32> %val, < i32 1, i32 1 >
	store <2 x i32> %add, ptr %dst.addr
	ret void
}

; truncate v3i32 to v3i8

define void @convert_v3i32_to_v3i8(ptr %dst.addr, ptr %src.addr) nounwind {
; X86-LABEL: convert_v3i32_to_v3i8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movdqa (%ecx), %xmm0
; X86-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; X86-NEXT:    pcmpeqd %xmm1, %xmm1
; X86-NEXT:    psubb %xmm1, %xmm0
; X86-NEXT:    pextrb $2, %xmm0, 2(%eax)
; X86-NEXT:    pextrw $0, %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: convert_v3i32_to_v3i8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movdqa (%rsi), %xmm0
; X64-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; X64-NEXT:    pcmpeqd %xmm1, %xmm1
; X64-NEXT:    psubb %xmm1, %xmm0
; X64-NEXT:    pextrb $2, %xmm0, 2(%rdi)
; X64-NEXT:    pextrw $0, %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
	%load = load <3 x i32>, ptr %src.addr
	%val = trunc <3 x i32> %load to <3 x i8>
	%add = add <3 x i8> %val, < i8 1, i8 1, i8 1 >
	store <3 x i8> %add, ptr %dst.addr
	ret void
}

; truncate v5i16 to v5i8

define void @convert_v5i16_to_v5i8(ptr %dst.addr, ptr %src.addr) nounwind {
; X86-LABEL: convert_v5i16_to_v5i8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movdqa (%ecx), %xmm0
; X86-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; X86-NEXT:    pcmpeqd %xmm1, %xmm1
; X86-NEXT:    psubb %xmm1, %xmm0
; X86-NEXT:    pextrb $4, %xmm0, 4(%eax)
; X86-NEXT:    movd %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: convert_v5i16_to_v5i8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movdqa (%rsi), %xmm0
; X64-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; X64-NEXT:    pcmpeqd %xmm1, %xmm1
; X64-NEXT:    psubb %xmm1, %xmm0
; X64-NEXT:    pextrb $4, %xmm0, 4(%rdi)
; X64-NEXT:    movd %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
	%load = load <5 x i16>, ptr %src.addr
	%val = trunc <5 x i16> %load to <5 x i8>
	%add = add <5 x i8> %val, < i8 1, i8 1, i8 1, i8 1, i8 1 >
	store <5 x i8> %add, ptr %dst.addr
	ret void
}
