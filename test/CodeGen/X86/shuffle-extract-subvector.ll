; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define void @f(<4 x half>* %a, <4 x half>* %b, <8 x half>* %c) {
; CHECK-LABEL: f:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pinsrw $0, (%rdi), %xmm0
; CHECK-NEXT:    pinsrw $0, 2(%rdi), %xmm1
; CHECK-NEXT:    pinsrw $0, 4(%rdi), %xmm2
; CHECK-NEXT:    pinsrw $0, 6(%rdi), %xmm3
; CHECK-NEXT:    pinsrw $0, (%rsi), %xmm4
; CHECK-NEXT:    pinsrw $0, 2(%rsi), %xmm5
; CHECK-NEXT:    pinsrw $0, 4(%rsi), %xmm6
; CHECK-NEXT:    pinsrw $0, 6(%rsi), %xmm7
; CHECK-NEXT:    pextrw $0, %xmm7, %eax
; CHECK-NEXT:    movw %ax, 14(%rdx)
; CHECK-NEXT:    pextrw $0, %xmm3, %eax
; CHECK-NEXT:    movw %ax, 12(%rdx)
; CHECK-NEXT:    pextrw $0, %xmm6, %eax
; CHECK-NEXT:    movw %ax, 10(%rdx)
; CHECK-NEXT:    pextrw $0, %xmm2, %eax
; CHECK-NEXT:    movw %ax, 8(%rdx)
; CHECK-NEXT:    pextrw $0, %xmm5, %eax
; CHECK-NEXT:    movw %ax, 6(%rdx)
; CHECK-NEXT:    pextrw $0, %xmm1, %eax
; CHECK-NEXT:    movw %ax, 4(%rdx)
; CHECK-NEXT:    pextrw $0, %xmm4, %eax
; CHECK-NEXT:    movw %ax, 2(%rdx)
; CHECK-NEXT:    pextrw $0, %xmm0, %eax
; CHECK-NEXT:    movw %ax, (%rdx)
; CHECK-NEXT:    retq
  %tmp4 = load <4 x half>, <4 x half>* %a
  %tmp5 = load <4 x half>, <4 x half>* %b
  %tmp7 = shufflevector <4 x half> %tmp4, <4 x half> %tmp5, <2 x i32> <i32 0, i32 4>
  %tmp8 = shufflevector <4 x half> %tmp4, <4 x half> %tmp5, <2 x i32> <i32 1, i32 5>
  %tmp9 = shufflevector <4 x half> %tmp4, <4 x half> %tmp5, <2 x i32> <i32 2, i32 6>
  %tmp10 = shufflevector <4 x half> %tmp4, <4 x half> %tmp5, <2 x i32> <i32 3, i32 7>
  %tmp11 = extractelement <2 x half> %tmp7, i32 0
  %tmp12 = insertelement <8 x half> undef, half %tmp11, i32 0
  %tmp13 = extractelement <2 x half> %tmp7, i32 1
  %tmp14 = insertelement <8 x half> %tmp12, half %tmp13, i32 1
  %tmp15 = extractelement <2 x half> %tmp8, i32 0
  %tmp16 = insertelement <8 x half> %tmp14, half %tmp15, i32 2
  %tmp17 = extractelement <2 x half> %tmp8, i32 1
  %tmp18 = insertelement <8 x half> %tmp16, half %tmp17, i32 3
  %tmp19 = extractelement <2 x half> %tmp9, i32 0
  %tmp20 = insertelement <8 x half> %tmp18, half %tmp19, i32 4
  %tmp21 = extractelement <2 x half> %tmp9, i32 1
  %tmp22 = insertelement <8 x half> %tmp20, half %tmp21, i32 5
  %tmp23 = extractelement <2 x half> %tmp10, i32 0
  %tmp24 = insertelement <8 x half> %tmp22, half %tmp23, i32 6
  %tmp25 = extractelement <2 x half> %tmp10, i32 1
  %tmp26 = insertelement <8 x half> %tmp24, half %tmp25, i32 7
  store <8 x half> %tmp26, <8 x half>* %c
  ret void
}
