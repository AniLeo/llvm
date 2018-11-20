; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86 --check-prefix=X86-SSE2
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X86 --check-prefix=X86-SSE42
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64 --check-prefix=X64-SSE2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X64 --check-prefix=X64-SSE42

; sign to float v2i16 to v2f32

define void @convert_v2i16_to_v2f32(<2 x float>* %dst.addr, <2 x i16> %src) nounwind {
; X86-LABEL: convert_v2i16_to_v2f32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    psllq $48, %xmm0
; X86-NEXT:    psrad $16, %xmm0
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; X86-NEXT:    cvtdq2ps %xmm0, %xmm0
; X86-NEXT:    movlps %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: convert_v2i16_to_v2f32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    psllq $48, %xmm0
; X64-NEXT:    psrad $16, %xmm0
; X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; X64-NEXT:    cvtdq2ps %xmm0, %xmm0
; X64-NEXT:    movlps %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
	%val = sitofp <2 x i16> %src to <2 x float>
	store <2 x float> %val, <2 x float>* %dst.addr, align 4
	ret void
}

; sign to float v3i8 to v3f32

define void @convert_v3i8_to_v3f32(<3 x float>* %dst.addr, <3 x i8>* %src.addr) nounwind {
; X86-SSE2-LABEL: convert_v3i8_to_v3f32:
; X86-SSE2:       # %bb.0: # %entry
; X86-SSE2-NEXT:    pushl %ebp
; X86-SSE2-NEXT:    movl %esp, %ebp
; X86-SSE2-NEXT:    pushl %esi
; X86-SSE2-NEXT:    andl $-16, %esp
; X86-SSE2-NEXT:    subl $32, %esp
; X86-SSE2-NEXT:    movl 8(%ebp), %eax
; X86-SSE2-NEXT:    movl 12(%ebp), %ecx
; X86-SSE2-NEXT:    movzwl (%ecx), %edx
; X86-SSE2-NEXT:    movd %edx, %xmm0
; X86-SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; X86-SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3]
; X86-SSE2-NEXT:    movdqa %xmm0, (%esp)
; X86-SSE2-NEXT:    movl (%esp), %edx
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-SSE2-NEXT:    shll $8, %edx
; X86-SSE2-NEXT:    pinsrw $1, %edx, %xmm0
; X86-SSE2-NEXT:    shll $8, %esi
; X86-SSE2-NEXT:    pinsrw $3, %esi, %xmm0
; X86-SSE2-NEXT:    movzbl 2(%ecx), %ecx
; X86-SSE2-NEXT:    shll $8, %ecx
; X86-SSE2-NEXT:    pinsrw $5, %ecx, %xmm0
; X86-SSE2-NEXT:    psrad $24, %xmm0
; X86-SSE2-NEXT:    cvtdq2ps %xmm0, %xmm0
; X86-SSE2-NEXT:    movss %xmm0, (%eax)
; X86-SSE2-NEXT:    movaps %xmm0, %xmm1
; X86-SSE2-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; X86-SSE2-NEXT:    movss %xmm1, 8(%eax)
; X86-SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; X86-SSE2-NEXT:    movss %xmm0, 4(%eax)
; X86-SSE2-NEXT:    leal -4(%ebp), %esp
; X86-SSE2-NEXT:    popl %esi
; X86-SSE2-NEXT:    popl %ebp
; X86-SSE2-NEXT:    retl
;
; X86-SSE42-LABEL: convert_v3i8_to_v3f32:
; X86-SSE42:       # %bb.0: # %entry
; X86-SSE42-NEXT:    pushl %eax
; X86-SSE42-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE42-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE42-NEXT:    movzbl 2(%ecx), %edx
; X86-SSE42-NEXT:    movzwl (%ecx), %ecx
; X86-SSE42-NEXT:    movd %ecx, %xmm0
; X86-SSE42-NEXT:    pmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; X86-SSE42-NEXT:    pinsrd $2, %edx, %xmm0
; X86-SSE42-NEXT:    pslld $24, %xmm0
; X86-SSE42-NEXT:    psrad $24, %xmm0
; X86-SSE42-NEXT:    cvtdq2ps %xmm0, %xmm0
; X86-SSE42-NEXT:    extractps $2, %xmm0, 8(%eax)
; X86-SSE42-NEXT:    extractps $1, %xmm0, 4(%eax)
; X86-SSE42-NEXT:    movss %xmm0, (%eax)
; X86-SSE42-NEXT:    popl %eax
; X86-SSE42-NEXT:    retl
;
; X64-SSE2-LABEL: convert_v3i8_to_v3f32:
; X64-SSE2:       # %bb.0: # %entry
; X64-SSE2-NEXT:    movzwl (%rsi), %eax
; X64-SSE2-NEXT:    movq %rax, %xmm0
; X64-SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; X64-SSE2-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3]
; X64-SSE2-NEXT:    movdqa %xmm0, -{{[0-9]+}}(%rsp)
; X64-SSE2-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-SSE2-NEXT:    movl -{{[0-9]+}}(%rsp), %ecx
; X64-SSE2-NEXT:    shll $8, %eax
; X64-SSE2-NEXT:    pinsrw $1, %eax, %xmm0
; X64-SSE2-NEXT:    shll $8, %ecx
; X64-SSE2-NEXT:    pinsrw $3, %ecx, %xmm0
; X64-SSE2-NEXT:    movzbl 2(%rsi), %eax
; X64-SSE2-NEXT:    shll $8, %eax
; X64-SSE2-NEXT:    pinsrw $5, %eax, %xmm0
; X64-SSE2-NEXT:    psrad $24, %xmm0
; X64-SSE2-NEXT:    cvtdq2ps %xmm0, %xmm0
; X64-SSE2-NEXT:    movlps %xmm0, (%rdi)
; X64-SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; X64-SSE2-NEXT:    movss %xmm0, 8(%rdi)
; X64-SSE2-NEXT:    retq
;
; X64-SSE42-LABEL: convert_v3i8_to_v3f32:
; X64-SSE42:       # %bb.0: # %entry
; X64-SSE42-NEXT:    movzbl 2(%rsi), %eax
; X64-SSE42-NEXT:    movzwl (%rsi), %ecx
; X64-SSE42-NEXT:    movq %rcx, %xmm0
; X64-SSE42-NEXT:    pmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; X64-SSE42-NEXT:    pinsrd $2, %eax, %xmm0
; X64-SSE42-NEXT:    pslld $24, %xmm0
; X64-SSE42-NEXT:    psrad $24, %xmm0
; X64-SSE42-NEXT:    cvtdq2ps %xmm0, %xmm0
; X64-SSE42-NEXT:    extractps $2, %xmm0, 8(%rdi)
; X64-SSE42-NEXT:    movlps %xmm0, (%rdi)
; X64-SSE42-NEXT:    retq
entry:
	%load = load <3 x i8>, <3 x i8>* %src.addr, align 1
	%cvt = sitofp <3 x i8> %load to <3 x float>
	store <3 x float> %cvt, <3 x float>* %dst.addr, align 4
	ret void
}
