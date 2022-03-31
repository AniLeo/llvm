; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+sse2 < %s | FileCheck %s --check-prefixes=CHECK,SSE2
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 < %s | FileCheck %s --check-prefixes=CHECK,SSE41

define i32 @test_eq_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_eq_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_eq_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp eq <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ne_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_ne_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_ne_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp ne <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_le_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_le_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sle <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ge_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_ge_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_ge_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sge <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_lt_1(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_lt_1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_lt_1:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm0, %xmm1
; SSE41-NEXT:    pextrd $1, %xmm1, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp slt <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_gt_1(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_gt_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %A, %B
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sgt <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_eq_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_eq_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_eq_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp eq <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ne_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_ne_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_ne_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp ne <4 x i32> %sext, zeroinitializer
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_le_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_le_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    notl %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_le_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    notl %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sle <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_ge_2(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: test_ge_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sge <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_lt_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_lt_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_lt_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp slt <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

define i32 @test_gt_2(<4 x i32> %A, <4 x i32> %B) {
; SSE2-LABEL: test_gt_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    movd %xmm0, %eax
; SSE2-NEXT:    retq
;
; SSE41-LABEL: test_gt_2:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pcmpgtd %xmm1, %xmm0
; SSE41-NEXT:    pextrd $1, %xmm0, %eax
; SSE41-NEXT:    retq
  %cmp = icmp slt <4 x i32> %B, %A
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %cmp1 = icmp sgt <4 x i32> zeroinitializer, %sext
  %t0 = extractelement <4 x i1> %cmp1, i32 1
  %t1 = sext i1 %t0 to i32
  ret i32 %t1
}

; (and (setne X, 0), (setne X, -1)) --> (setuge (add X, 1), 2)
; Don't combine with i1 - out of range constant
define void @test_i1_uge(i1 *%A2) {
; CHECK-LABEL: test_i1_uge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movb (%rdi), %al
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    xorb $1, %cl
; CHECK-NEXT:    andb %cl, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    negq %rax
; CHECK-NEXT:    andb $1, %cl
; CHECK-NEXT:    movb %cl, (%rdi,%rax)
; CHECK-NEXT:    retq
  %L5 = load i1, i1* %A2
  %C3 = icmp ne i1 %L5, true
  %C8 = icmp eq i1 %L5, false
  %C9 = icmp ugt i1 %C3, %C8
  %G3 = getelementptr i1, i1* %A2, i1 %C9
  store i1 %C3, i1* %G3
  ret void
}

; This should not get folded to 0.

define i64 @PR40657(i8 %var2, i8 %var9) {
; CHECK-LABEL: PR40657:
; CHECK:       # %bb.0:
; CHECK-NEXT:    notb %sil
; CHECK-NEXT:    addb %dil, %sil
; CHECK-NEXT:    movzbl %sil, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    retq
  %var6 = trunc i8 %var9 to i1
  %var7 = trunc i8 175 to i1
  %var3 = sub nsw i1 %var6, %var7
  %var4 = icmp eq i64 1114591064, 1114591064
  %var1 = udiv i1 %var3, %var4
  %var0 = trunc i8 %var2 to i1
  %res = sub nsw nuw i1 %var0, %var1
  %res.cast = zext i1 %res to i64
  ret i64 %res.cast
}

; This should not get folded to 0.

define i64 @PR40657_commute(i8 %var7, i8 %var8, i8 %var9) {
; CHECK-LABEL: PR40657_commute:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subb %dil, %sil
; CHECK-NEXT:    subb %sil, %dl
; CHECK-NEXT:    subb %dl, %sil
; CHECK-NEXT:    xorb %dl, %sil
; CHECK-NEXT:    subb %sil, %dl
; CHECK-NEXT:    movzbl %dl, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    retq
  %var4 = trunc i8 %var9 to i1
  %var5 = trunc i8 %var8 to i1
  %var6 = trunc i8 %var7 to i1
  %var3 = sub nsw nuw i1 %var5, %var6
  %var0 = sub nuw i1 %var4, %var3
  %var2 = sub i1 %var3, %var0
  %var1 = icmp ne i1 %var0, %var2
  %res = sub nsw nuw i1 %var0, %var1
  %res.cast = zext i1 %res to i64
  ret i64 %res.cast
}

define i64 @sub_to_shift_to_add(i32 %x, i32 %y, i64 %s1, i64 %s2) {
; CHECK-LABEL: sub_to_shift_to_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    addl %esi, %esi
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    cmovneq %rcx, %rax
; CHECK-NEXT:    retq
  %sub = sub i32 %x, %y
  %cmp = icmp eq i32 %sub, %y
  %r = select i1 %cmp, i64 %s1, i64 %s2
  ret i64 %r
}

define <4 x float> @sub_to_shift_to_add_vec(<4 x i32> %x, <4 x i32> %y, <4 x float> %s1, <4 x float> %s2) {
; SSE2-LABEL: sub_to_shift_to_add_vec:
; SSE2:       # %bb.0:
; SSE2-NEXT:    paddd %xmm1, %xmm1
; SSE2-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm0, %xmm2
; SSE2-NEXT:    pandn %xmm3, %xmm0
; SSE2-NEXT:    por %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: sub_to_shift_to_add_vec:
; SSE41:       # %bb.0:
; SSE41-NEXT:    paddd %xmm1, %xmm1
; SSE41-NEXT:    pcmpeqd %xmm1, %xmm0
; SSE41-NEXT:    blendvps %xmm0, %xmm2, %xmm3
; SSE41-NEXT:    movaps %xmm3, %xmm0
; SSE41-NEXT:    retq
  %sub = sub <4 x i32> %x, %y
  %cmp = icmp eq <4 x i32> %sub, %y
  %r = select <4 x i1> %cmp, <4 x float> %s1, <4 x float> %s2
  ret <4 x float> %r
}

define i64 @sub_constant_to_shift_to_add(i32 %x, i64 %s1, i64 %s2) {
; CHECK-LABEL: sub_constant_to_shift_to_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    addl %edi, %edi
; CHECK-NEXT:    cmpl $42, %edi
; CHECK-NEXT:    cmovneq %rdx, %rax
; CHECK-NEXT:    retq
  %sub = sub i32 42, %x
  %cmp = icmp eq i32 %sub, %x
  %r = select i1 %cmp, i64 %s1, i64 %s2
  ret i64 %r
}

define float @olt(float %x) {
; CHECK-LABEL: olt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    xorps %xmm0, %xmm1
; CHECK-NEXT:    minss %xmm1, %xmm0
; CHECK-NEXT:    retq
  %cmp = fcmp olt float %x, 0.0
  %neg = fneg float %x
  %r = select i1 %cmp, float %x, float %neg
  ret float %r
}

define double @ogt(double %x) {
; CHECK-LABEL: ogt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movapd {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0]
; CHECK-NEXT:    xorpd %xmm0, %xmm1
; CHECK-NEXT:    maxsd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %neg = fneg double %x
  %cmp = fcmp ogt double %x, 0.0
  %r = select i1 %cmp, double %x, double %neg
  ret double %r
}

define <4 x float> @olt_swap(<4 x float> %x) {
; CHECK-LABEL: olt_swap:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    xorps %xmm0, %xmm1
; CHECK-NEXT:    maxps %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %cmp = fcmp olt <4 x float> %x, zeroinitializer
  %neg = fneg <4 x float> %x
  %r = select <4 x i1> %cmp, <4 x float> %neg, <4 x float> %x
  ret <4 x float> %r
}

define <2 x double> @ogt_swap(<2 x double> %x) {
; CHECK-LABEL: ogt_swap:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movapd {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0]
; CHECK-NEXT:    xorpd %xmm0, %xmm1
; CHECK-NEXT:    minpd %xmm0, %xmm1
; CHECK-NEXT:    movapd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %neg = fneg <2 x double> %x
  %cmp = fcmp ogt <2 x double> %x, zeroinitializer
  %r = select <2 x i1> %cmp, <2 x double> %neg, <2 x double> %x
  ret <2 x double> %r
}

define <4 x float> @ole(<4 x float> %x) {
; SSE2-LABEL: ole:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; SSE2-NEXT:    xorps %xmm0, %xmm2
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    cmpleps %xmm2, %xmm1
; SSE2-NEXT:    andps %xmm1, %xmm2
; SSE2-NEXT:    andnps %xmm0, %xmm1
; SSE2-NEXT:    orps %xmm2, %xmm1
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: ole:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movaps %xmm0, %xmm1
; SSE41-NEXT:    movaps {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; SSE41-NEXT:    xorps %xmm0, %xmm2
; SSE41-NEXT:    cmpleps %xmm2, %xmm0
; SSE41-NEXT:    blendvps %xmm0, %xmm2, %xmm1
; SSE41-NEXT:    movaps %xmm1, %xmm0
; SSE41-NEXT:    retq
  %cmp = fcmp ole <4 x float> %x, zeroinitializer
  %neg = fneg <4 x float> %x
  %r = select <4 x i1> %cmp, <4 x float> %neg, <4 x float> %x
  ret <4 x float> %r
}

define <2 x double> @oge(<2 x double> %x) {
; SSE2-LABEL: oge:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movapd {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0]
; SSE2-NEXT:    xorpd %xmm0, %xmm2
; SSE2-NEXT:    movapd %xmm2, %xmm1
; SSE2-NEXT:    cmplepd %xmm0, %xmm1
; SSE2-NEXT:    andpd %xmm1, %xmm2
; SSE2-NEXT:    andnpd %xmm0, %xmm1
; SSE2-NEXT:    orpd %xmm2, %xmm1
; SSE2-NEXT:    movapd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: oge:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movapd %xmm0, %xmm1
; SSE41-NEXT:    movapd {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0]
; SSE41-NEXT:    xorpd %xmm0, %xmm2
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    cmplepd %xmm1, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    retq
  %neg = fneg <2 x double> %x
  %cmp = fcmp oge <2 x double> %x, zeroinitializer
  %r = select <2 x i1> %cmp, <2 x double> %neg, <2 x double> %x
  ret <2 x double> %r
}

; negative test - don't create an fneg to replace 0.0 operand

define double @ogt_no_fneg(double %x, double %y) {
; CHECK-LABEL: ogt_no_fneg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorpd %xmm2, %xmm2
; CHECK-NEXT:    cmpltsd %xmm0, %xmm2
; CHECK-NEXT:    andpd %xmm2, %xmm0
; CHECK-NEXT:    andnpd %xmm1, %xmm2
; CHECK-NEXT:    orpd %xmm2, %xmm0
; CHECK-NEXT:    retq
  %cmp = fcmp ogt double %x, 0.0
  %r = select i1 %cmp, double %x, double %y
  ret double %r
}

; negative test - can't change the setcc for non-zero constant

define double @ogt_no_zero(double %x) {
; CHECK-LABEL: ogt_no_zero:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movapd {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0]
; CHECK-NEXT:    xorpd %xmm0, %xmm1
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    cmpltsd %xmm0, %xmm2
; CHECK-NEXT:    andpd %xmm2, %xmm0
; CHECK-NEXT:    andnpd %xmm1, %xmm2
; CHECK-NEXT:    orpd %xmm2, %xmm0
; CHECK-NEXT:    retq
  %neg = fneg double %x
  %cmp = fcmp ogt double %x, 1.0
  %r = select i1 %cmp, double %x, double %neg
  ret double %r
}
