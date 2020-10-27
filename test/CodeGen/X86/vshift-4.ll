; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,X64

; test vector shifts converted to proper SSE2 vector shifts when the shift
; amounts are the same when using a shuffle splat.

define void @shift1a(<2 x i64> %val, <2 x i64>* %dst, <2 x i64> %sh) nounwind {
; X86-LABEL: shift1a:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    psllq %xmm1, %xmm0
; X86-NEXT:    movdqa %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: shift1a:
; X64:       # %bb.0: # %entry
; X64-NEXT:    psllq %xmm1, %xmm0
; X64-NEXT:    movdqa %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
  %shamt = shufflevector <2 x i64> %sh, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %shl = shl <2 x i64> %val, %shamt
  store <2 x i64> %shl, <2 x i64>* %dst
  ret void
}

; shift1b can't use a packed shift but can shift lanes separately and shuffle back together
define void @shift1b(<2 x i64> %val, <2 x i64>* %dst, <2 x i64> %sh) nounwind {
; X86-LABEL: shift1b:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movdqa %xmm0, %xmm2
; X86-NEXT:    psllq %xmm1, %xmm2
; X86-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[2,3,2,3]
; X86-NEXT:    psllq %xmm1, %xmm0
; X86-NEXT:    movsd {{.*#+}} xmm0 = xmm2[0],xmm0[1]
; X86-NEXT:    movapd %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: shift1b:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movdqa %xmm0, %xmm2
; X64-NEXT:    psllq %xmm1, %xmm2
; X64-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[2,3,2,3]
; X64-NEXT:    psllq %xmm1, %xmm0
; X64-NEXT:    movsd {{.*#+}} xmm0 = xmm2[0],xmm0[1]
; X64-NEXT:    movapd %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
  %shamt = shufflevector <2 x i64> %sh, <2 x i64> undef, <2 x i32> <i32 0, i32 1>
  %shl = shl <2 x i64> %val, %shamt
  store <2 x i64> %shl, <2 x i64>* %dst
  ret void
}

define void @shift2a(<4 x i32> %val, <4 x i32>* %dst, <2 x i32> %amt) nounwind {
; X86-LABEL: shift2a:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    psrlq $32, %xmm1
; X86-NEXT:    pslld %xmm1, %xmm0
; X86-NEXT:    movdqa %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: shift2a:
; X64:       # %bb.0: # %entry
; X64-NEXT:    psrlq $32, %xmm1
; X64-NEXT:    pslld %xmm1, %xmm0
; X64-NEXT:    movdqa %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
  %shamt = shufflevector <2 x i32> %amt, <2 x i32> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  %shl = shl <4 x i32> %val, %shamt
  store <4 x i32> %shl, <4 x i32>* %dst
  ret void
}

define void @shift2b(<4 x i32> %val, <4 x i32>* %dst, <2 x i32> %amt) nounwind {
; X86-LABEL: shift2b:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    psrlq $32, %xmm1
; X86-NEXT:    pslld %xmm1, %xmm0
; X86-NEXT:    movdqa %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: shift2b:
; X64:       # %bb.0: # %entry
; X64-NEXT:    psrlq $32, %xmm1
; X64-NEXT:    pslld %xmm1, %xmm0
; X64-NEXT:    movdqa %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
  %shamt = shufflevector <2 x i32> %amt, <2 x i32> undef, <4 x i32> <i32 1, i32 undef, i32 1, i32 1>
  %shl = shl <4 x i32> %val, %shamt
  store <4 x i32> %shl, <4 x i32>* %dst
  ret void
}

define void @shift2c(<4 x i32> %val, <4 x i32>* %dst, <2 x i32> %amt) nounwind {
; X86-LABEL: shift2c:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    psrlq $32, %xmm1
; X86-NEXT:    pslld %xmm1, %xmm0
; X86-NEXT:    movdqa %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: shift2c:
; X64:       # %bb.0: # %entry
; X64-NEXT:    psrlq $32, %xmm1
; X64-NEXT:    pslld %xmm1, %xmm0
; X64-NEXT:    movdqa %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
  %shamt = shufflevector <2 x i32> %amt, <2 x i32> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  %shl = shl <4 x i32> %val, %shamt
  store <4 x i32> %shl, <4 x i32>* %dst
  ret void
}

define void @shift3a(<8 x i16> %val, <8 x i16>* %dst, <8 x i16> %amt) nounwind {
; X86-LABEL: shift3a:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pshufhw {{.*#+}} xmm1 = xmm1[0,1,2,3,6,6,6,6]
; X86-NEXT:    psrldq {{.*#+}} xmm1 = xmm1[14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; X86-NEXT:    psllw %xmm1, %xmm0
; X86-NEXT:    movdqa %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: shift3a:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pshufhw {{.*#+}} xmm1 = xmm1[0,1,2,3,6,6,6,6]
; X64-NEXT:    psrldq {{.*#+}} xmm1 = xmm1[14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; X64-NEXT:    psllw %xmm1, %xmm0
; X64-NEXT:    movdqa %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
  %shamt = shufflevector <8 x i16> %amt, <8 x i16> undef, <8 x i32> <i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6, i32 6>
  %shl = shl <8 x i16> %val, %shamt
  store <8 x i16> %shl, <8 x i16>* %dst
  ret void
}

define void @shift3b(<8 x i16> %val, <8 x i16>* %dst, i16 %amt) nounwind {
; X86-LABEL: shift3b:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movd %ecx, %xmm1
; X86-NEXT:    psllw %xmm1, %xmm0
; X86-NEXT:    movdqa %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: shift3b:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movzwl %si, %eax
; X64-NEXT:    movd %eax, %xmm1
; X64-NEXT:    psllw %xmm1, %xmm0
; X64-NEXT:    movdqa %xmm0, (%rdi)
; X64-NEXT:    retq
entry:
  %0 = insertelement <8 x i16> undef, i16 %amt, i32 0
  %1 = insertelement <8 x i16> %0, i16 %amt, i32 1
  %2 = insertelement <8 x i16> %1, i16 %amt, i32 2
  %3 = insertelement <8 x i16> %2, i16 %amt, i32 3
  %4 = insertelement <8 x i16> %3, i16 %amt, i32 4
  %5 = insertelement <8 x i16> %4, i16 %amt, i32 5
  %6 = insertelement <8 x i16> %5, i16 %amt, i32 6
  %7 = insertelement <8 x i16> %6, i16 %amt, i32 7
  %shl = shl <8 x i16> %val, %7
  store <8 x i16> %shl, <8 x i16>* %dst
  ret void
}

