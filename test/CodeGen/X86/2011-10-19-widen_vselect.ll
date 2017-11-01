; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu -mcpu=corei7   | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=corei7 | FileCheck %s --check-prefix=X64

; Make sure that we don't crash when legalizing vselect and vsetcc and that
; we are able to generate vector blend instructions.

define void @simple_widen(<2 x float> %a, <2 x float> %b) {
; X32-LABEL: simple_widen:
; X32:       # BB#0: # %entry
; X32-NEXT:    extractps $1, %xmm1, (%eax)
; X32-NEXT:    movss %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: simple_widen:
; X64:       # BB#0: # %entry
; X64-NEXT:    movlps %xmm1, (%rax)
; X64-NEXT:    retq
entry:
  %0 = select <2 x i1> undef, <2 x float> %a, <2 x float> %b
  store <2 x float> %0, <2 x float>* undef
  ret void
}

define void @complex_inreg_work(<2 x float> %a, <2 x float> %b) {
; X32-LABEL: complex_inreg_work:
; X32:       # BB#0: # %entry
; X32-NEXT:    movaps %xmm0, %xmm2
; X32-NEXT:    cmpordps %xmm0, %xmm0
; X32-NEXT:    blendvps %xmm0, %xmm2, %xmm1
; X32-NEXT:    extractps $1, %xmm1, (%eax)
; X32-NEXT:    movss %xmm1, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: complex_inreg_work:
; X64:       # BB#0: # %entry
; X64-NEXT:    movaps %xmm0, %xmm2
; X64-NEXT:    cmpordps %xmm0, %xmm0
; X64-NEXT:    blendvps %xmm0, %xmm2, %xmm1
; X64-NEXT:    movlps %xmm1, (%rax)
; X64-NEXT:    retq
entry:
  %0 = fcmp oeq <2 x float> undef, undef
  %1 = select <2 x i1> %0, <2 x float> %a, <2 x float> %b
  store <2 x float> %1, <2 x float>* undef
  ret void
}

define void @zero_test() {
; X32-LABEL: zero_test:
; X32:       # BB#0: # %entry
; X32-NEXT:    xorps %xmm0, %xmm0
; X32-NEXT:    extractps $1, %xmm0, (%eax)
; X32-NEXT:    movss %xmm0, (%eax)
; X32-NEXT:    retl
;
; X64-LABEL: zero_test:
; X64:       # BB#0: # %entry
; X64-NEXT:    xorps %xmm0, %xmm0
; X64-NEXT:    movlps %xmm0, (%rax)
; X64-NEXT:    retq
entry:
  %0 = select <2 x i1> undef, <2 x float> undef, <2 x float> zeroinitializer
  store <2 x float> %0, <2 x float>* undef
  ret void
}

define void @full_test() {
; X32-LABEL: full_test:
; X32:       # BB#0: # %entry
; X32-NEXT:    subl $60, %esp
; X32-NEXT:    .cfi_def_cfa_offset 64
; X32-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; X32-NEXT:    cvttps2dq %xmm2, %xmm0
; X32-NEXT:    cvtdq2ps %xmm0, %xmm1
; X32-NEXT:    xorps %xmm0, %xmm0
; X32-NEXT:    cmpltps %xmm2, %xmm0
; X32-NEXT:    movaps {{.*#+}} xmm3 = <1,1,u,u>
; X32-NEXT:    addps %xmm1, %xmm3
; X32-NEXT:    movaps %xmm1, %xmm4
; X32-NEXT:    blendvps %xmm0, %xmm3, %xmm4
; X32-NEXT:    cmpeqps %xmm2, %xmm1
; X32-NEXT:    movaps %xmm1, %xmm0
; X32-NEXT:    blendvps %xmm0, %xmm2, %xmm4
; X32-NEXT:    movss %xmm4, {{[0-9]+}}(%esp)
; X32-NEXT:    movshdup {{.*#+}} xmm0 = xmm4[1,1,3,3]
; X32-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; X32-NEXT:    movss %xmm4, {{[0-9]+}}(%esp)
; X32-NEXT:    movss %xmm0, {{[0-9]+}}(%esp)
; X32-NEXT:    addl $60, %esp
; X32-NEXT:    .cfi_def_cfa_offset 4
; X32-NEXT:    retl
;
; X64-LABEL: full_test:
; X64:       # BB#0: # %entry
; X64-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; X64-NEXT:    cvttps2dq %xmm2, %xmm0
; X64-NEXT:    cvtdq2ps %xmm0, %xmm1
; X64-NEXT:    xorps %xmm0, %xmm0
; X64-NEXT:    cmpltps %xmm2, %xmm0
; X64-NEXT:    movaps {{.*#+}} xmm3 = <1,1,u,u>
; X64-NEXT:    addps %xmm1, %xmm3
; X64-NEXT:    movaps %xmm1, %xmm4
; X64-NEXT:    blendvps %xmm0, %xmm3, %xmm4
; X64-NEXT:    cmpeqps %xmm2, %xmm1
; X64-NEXT:    movaps %xmm1, %xmm0
; X64-NEXT:    blendvps %xmm0, %xmm2, %xmm4
; X64-NEXT:    movlps %xmm4, -{{[0-9]+}}(%rsp)
; X64-NEXT:    movlps %xmm4, -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
 entry:
   %Cy300 = alloca <4 x float>
   %Cy11a = alloca <2 x float>
   %Cy118 = alloca <2 x float>
   %Cy119 = alloca <2 x float>
   br label %B1

 B1:                                               ; preds = %entry
   %0 = load <2 x float>, <2 x float>* %Cy119
   %1 = fptosi <2 x float> %0 to <2 x i32>
   %2 = sitofp <2 x i32> %1 to <2 x float>
   %3 = fcmp ogt <2 x float> %0, zeroinitializer
   %4 = fadd <2 x float> %2, <float 1.000000e+00, float 1.000000e+00>
   %5 = select <2 x i1> %3, <2 x float> %4, <2 x float> %2
   %6 = fcmp oeq <2 x float> %2, %0
   %7 = select <2 x i1> %6, <2 x float> %0, <2 x float> %5
   store <2 x float> %7, <2 x float>* %Cy118
   %8 = load <2 x float>, <2 x float>* %Cy118
   store <2 x float> %8, <2 x float>* %Cy11a
   ret void
}
