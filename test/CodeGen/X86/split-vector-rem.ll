; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define <8 x i32> @foo(<8 x i32> %t, <8 x i32> %u) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movdqa %xmm0, %xmm4
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,3,3,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[3,3,3,3]
; CHECK-NEXT:    movd %xmm0, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[2,3,2,3]
; CHECK-NEXT:    movd %xmm5, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm5 = xmm2[2,3,2,3]
; CHECK-NEXT:    movd %xmm5, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm5
; CHECK-NEXT:    punpckldq {{.*#+}} xmm5 = xmm5[0],xmm0[0],xmm5[1],xmm0[1]
; CHECK-NEXT:    movd %xmm4, %eax
; CHECK-NEXT:    movd %xmm2, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,1,1]
; CHECK-NEXT:    movd %xmm4, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,1,1]
; CHECK-NEXT:    movd %xmm2, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm5[0]
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[3,3,3,3]
; CHECK-NEXT:    movd %xmm2, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[3,3,3,3]
; CHECK-NEXT:    movd %xmm2, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[2,3,2,3]
; CHECK-NEXT:    movd %xmm4, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm4 = xmm3[2,3,2,3]
; CHECK-NEXT:    movd %xmm4, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm4
; CHECK-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
; CHECK-NEXT:    movd %xmm1, %eax
; CHECK-NEXT:    movd %xmm3, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,1,1]
; CHECK-NEXT:    movd %xmm1, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,1,1,1]
; CHECK-NEXT:    movd %xmm1, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movd %edx, %xmm1
; CHECK-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm4[0]
; CHECK-NEXT:    movdqa %xmm2, %xmm1
; CHECK-NEXT:    retq
	%m = srem <8 x i32> %t, %u
	ret <8 x i32> %m
}
define <8 x i32> @bar(<8 x i32> %t, <8 x i32> %u) {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movdqa %xmm0, %xmm4
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,3,3,3]
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[3,3,3,3]
; CHECK-NEXT:    movd %xmm0, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm5 = xmm4[2,3,2,3]
; CHECK-NEXT:    movd %xmm5, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm5 = xmm2[2,3,2,3]
; CHECK-NEXT:    movd %xmm5, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm5
; CHECK-NEXT:    punpckldq {{.*#+}} xmm5 = xmm5[0],xmm0[0],xmm5[1],xmm0[1]
; CHECK-NEXT:    movd %xmm4, %eax
; CHECK-NEXT:    movd %xmm2, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm0
; CHECK-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,1,1]
; CHECK-NEXT:    movd %xmm4, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,1,1]
; CHECK-NEXT:    movd %xmm2, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm5[0]
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[3,3,3,3]
; CHECK-NEXT:    movd %xmm2, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[3,3,3,3]
; CHECK-NEXT:    movd %xmm2, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[2,3,2,3]
; CHECK-NEXT:    movd %xmm4, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm4 = xmm3[2,3,2,3]
; CHECK-NEXT:    movd %xmm4, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm4
; CHECK-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm2[0],xmm4[1],xmm2[1]
; CHECK-NEXT:    movd %xmm1, %eax
; CHECK-NEXT:    movd %xmm3, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,1,1]
; CHECK-NEXT:    movd %xmm1, %eax
; CHECK-NEXT:    pshufd {{.*#+}} xmm1 = xmm3[1,1,1,1]
; CHECK-NEXT:    movd %xmm1, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movd %edx, %xmm1
; CHECK-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm4[0]
; CHECK-NEXT:    movdqa %xmm2, %xmm1
; CHECK-NEXT:    retq
	%m = urem <8 x i32> %t, %u
	ret <8 x i32> %m
}
define <8 x float> @qux(<8 x float> %t, <8 x float> %u) {
; CHECK-LABEL: qux:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $104, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    movaps %xmm3, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps %xmm2, (%rsp) # 16-byte Spill
; CHECK-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; CHECK-NEXT:    movaps %xmm2, %xmm1
; CHECK-NEXT:    shufps {{.*#+}} xmm1 = xmm1[3,3],xmm2[3,3]
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; CHECK-NEXT:    movaps (%rsp), %xmm1 # 16-byte Reload
; CHECK-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    unpcklps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    # xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movaps (%rsp), %xmm1 # 16-byte Reload
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; CHECK-NEXT:    movaps (%rsp), %xmm1 # 16-byte Reload
; CHECK-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1,1,1]
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; CHECK-NEXT:    unpcklpd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Folded Reload
; CHECK-NEXT:    # xmm1 = xmm1[0],mem[0]
; CHECK-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    shufps {{.*#+}} xmm1 = xmm1[3,3,3,3]
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    unpcklps (%rsp), %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    # xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1,1,1]
; CHECK-NEXT:    callq fmodf
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; CHECK-NEXT:    unpcklpd (%rsp), %xmm1 # 16-byte Folded Reload
; CHECK-NEXT:    # xmm1 = xmm1[0],mem[0]
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    addq $104, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
	%m = frem <8 x float> %t, %u
	ret <8 x float> %m
}
