; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=x86_64-pc-linux < %s | FileCheck %s --check-prefix=COMMON --check-prefix=SSE
; RUN: llc -O3 -mtriple=x86_64-pc-linux -mattr=+avx < %s | FileCheck %s --check-prefix=COMMON --check-prefix=AVX --check-prefix=AVX1
; RUN: llc -O3 -mtriple=x86_64-pc-linux -mattr=+avx512f < %s | FileCheck %s --check-prefix=COMMON --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc -O3 -mtriple=x86_64-pc-linux -mattr=+avx512dq < %s | FileCheck %s --check-prefix=COMMON --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512DQ

; Verify that constants aren't folded to inexact results when the rounding mode
; is unknown.
;
; double f1() {
;   // Because 0.1 cannot be represented exactly, this shouldn't be folded.
;   return 1.0/10.0;
; }
;
define double @f1() #0 {
; SSE-LABEL: f1:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    divsd {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f1:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vdivsd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %div = call double @llvm.experimental.constrained.fdiv.f64(
                                               double 1.000000e+00,
                                               double 1.000000e+01,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %div
}

; Verify that 'a - 0' isn't simplified to 'a' when the rounding mode is unknown.
;
; double f2(double a) {
;   // Because the result of '0 - 0' is negative zero if rounding mode is
;   // downward, this shouldn't be simplified.
;   return a - 0;
; }
;
define double @f2(double %a) #0 {
; SSE-LABEL: f2:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    xorpd %xmm1, %xmm1
; SSE-NEXT:    subsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f2:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %sub = call double @llvm.experimental.constrained.fsub.f64(
                                               double %a,
                                               double 0.000000e+00,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %sub
}

; Verify that '-((-a)*b)' isn't simplified to 'a*b' when the rounding mode is
; unknown.
;
; double f3(double a, double b) {
;   // Because the intermediate value involved in this calculation may require
;   // rounding, this shouldn't be simplified.
;   return -((-a)*b);
; }
;
define double @f3(double %a, double %b) #0 {
; SSE-LABEL: f3:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; SSE-NEXT:    movapd %xmm2, %xmm3
; SSE-NEXT:    subsd %xmm0, %xmm3
; SSE-NEXT:    mulsd %xmm1, %xmm3
; SSE-NEXT:    subsd %xmm3, %xmm2
; SSE-NEXT:    movapd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f3:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; AVX-NEXT:    vsubsd %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vmulsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vsubsd %xmm0, %xmm2, %xmm0
; AVX-NEXT:    retq
entry:
  %sub = call double @llvm.experimental.constrained.fsub.f64(
                                               double -0.000000e+00, double %a,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  %mul = call double @llvm.experimental.constrained.fmul.f64(
                                               double %sub, double %b,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  %ret = call double @llvm.experimental.constrained.fsub.f64(
                                               double -0.000000e+00,
                                               double %mul,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %ret
}

; Verify that FP operations are not performed speculatively when FP exceptions
; are not being ignored.
;
; double f4(int n, double a) {
;   // Because a + 1 may overflow, this should not be simplified.
;   if (n > 0)
;     return a + 1.0;
;   return a;
; }
;
;
define double @f4(i32 %n, double %a) #0 {
; SSE-LABEL: f4:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    testl %edi, %edi
; SSE-NEXT:    jle .LBB3_2
; SSE-NEXT:  # %bb.1: # %if.then
; SSE-NEXT:    addsd {{.*}}(%rip), %xmm0
; SSE-NEXT:  .LBB3_2: # %if.end
; SSE-NEXT:    retq
;
; AVX-LABEL: f4:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    testl %edi, %edi
; AVX-NEXT:    jle .LBB3_2
; AVX-NEXT:  # %bb.1: # %if.then
; AVX-NEXT:    vaddsd {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:  .LBB3_2: # %if.end
; AVX-NEXT:    retq
entry:
  %cmp = icmp sgt i32 %n, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:
  %add = call double @llvm.experimental.constrained.fadd.f64(
                                               double 1.000000e+00, double %a,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  br label %if.end

if.end:
  %a.0 = phi double [%add, %if.then], [ %a, %entry ]
  ret double %a.0
}

; Verify that sqrt(42.0) isn't simplified when the rounding mode is unknown.
define double @f5() #0 {
; SSE-LABEL: f5:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f5:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %result = call double @llvm.experimental.constrained.sqrt.f64(double 42.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that pow(42.1, 3.0) isn't simplified when the rounding mode is unknown.
define double @f6() #0 {
; SSE-LABEL: f6:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    jmp pow # TAILCALL
;
; AVX-LABEL: f6:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    jmp pow # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.pow.f64(double 42.1,
                                               double 3.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that powi(42.1, 3) isn't simplified when the rounding mode is unknown.
define double @f7() #0 {
; SSE-LABEL: f7:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movl $3, %edi
; SSE-NEXT:    jmp __powidf2 # TAILCALL
;
; AVX-LABEL: f7:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    movl $3, %edi
; AVX-NEXT:    jmp __powidf2 # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.powi.f64(double 42.1,
                                               i32 3,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that sin(42.0) isn't simplified when the rounding mode is unknown.
define double @f8() #0 {
; SSE-LABEL: f8:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp sin # TAILCALL
;
; AVX-LABEL: f8:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    jmp sin # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.sin.f64(double 42.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that cos(42.0) isn't simplified when the rounding mode is unknown.
define double @f9() #0 {
; SSE-LABEL: f9:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp cos # TAILCALL
;
; AVX-LABEL: f9:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    jmp cos # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.cos.f64(double 42.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that exp(42.0) isn't simplified when the rounding mode is unknown.
define double @f10() #0 {
; SSE-LABEL: f10:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp exp # TAILCALL
;
; AVX-LABEL: f10:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    jmp exp # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.exp.f64(double 42.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that exp2(42.1) isn't simplified when the rounding mode is unknown.
define double @f11() #0 {
; SSE-LABEL: f11:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp exp2 # TAILCALL
;
; AVX-LABEL: f11:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    jmp exp2 # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.exp2.f64(double 42.1,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that log(42.0) isn't simplified when the rounding mode is unknown.
define double @f12() #0 {
; SSE-LABEL: f12:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp log # TAILCALL
;
; AVX-LABEL: f12:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    jmp log # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.log.f64(double 42.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that log10(42.0) isn't simplified when the rounding mode is unknown.
define double @f13() #0 {
; SSE-LABEL: f13:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp log10 # TAILCALL
;
; AVX-LABEL: f13:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    jmp log10 # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.log10.f64(double 42.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that log2(42.0) isn't simplified when the rounding mode is unknown.
define double @f14() #0 {
; SSE-LABEL: f14:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp log2 # TAILCALL
;
; AVX-LABEL: f14:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    jmp log2 # TAILCALL
entry:
  %result = call double @llvm.experimental.constrained.log2.f64(double 42.0,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that rint(42.1) isn't simplified when the rounding mode is unknown.
define double @f15() #0 {
; SSE-LABEL: f15:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp rint # TAILCALL
;
; AVX-LABEL: f15:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vroundsd $4, %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %result = call double @llvm.experimental.constrained.rint.f64(double 42.1,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

; Verify that nearbyint(42.1) isn't simplified when the rounding mode is
; unknown.
define double @f16() #0 {
; SSE-LABEL: f16:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    jmp nearbyint # TAILCALL
;
; AVX-LABEL: f16:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vroundsd $12, %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %result = call double @llvm.experimental.constrained.nearbyint.f64(
                                               double 42.1,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

define double @f19() #0 {
; SSE-LABEL: f19:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    jmp fmod # TAILCALL
;
; AVX-LABEL: f19:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    jmp fmod # TAILCALL
entry:
  %rem = call double @llvm.experimental.constrained.frem.f64(
                                               double 1.000000e+00,
                                               double 1.000000e+01,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret double %rem
}

; Verify that fptoui(%x) isn't simplified when the rounding mode is
; unknown. The expansion should have only one conversion instruction.
; Verify that no gross errors happen.
define i32 @f20u(double %x) #0 {
; SSE-LABEL: f20u:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    movapd %xmm0, %xmm2
; SSE-NEXT:    cmpltsd %xmm1, %xmm2
; SSE-NEXT:    movapd %xmm2, %xmm3
; SSE-NEXT:    andpd %xmm0, %xmm2
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    ucomisd %xmm1, %xmm0
; SSE-NEXT:    subsd %xmm1, %xmm0
; SSE-NEXT:    andnpd %xmm0, %xmm3
; SSE-NEXT:    orpd %xmm3, %xmm2
; SSE-NEXT:    cvttsd2si %xmm2, %ecx
; SSE-NEXT:    setae %al
; SSE-NEXT:    shll $31, %eax
; SSE-NEXT:    xorl %ecx, %eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: f20u:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX1-NEXT:    vcmpltsd %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vsubsd %xmm1, %xmm0, %xmm3
; AVX1-NEXT:    vblendvpd %xmm2, %xmm0, %xmm3, %xmm2
; AVX1-NEXT:    vcvttsd2si %xmm2, %ecx
; AVX1-NEXT:    xorl %eax, %eax
; AVX1-NEXT:    vucomisd %xmm1, %xmm0
; AVX1-NEXT:    setae %al
; AVX1-NEXT:    shll $31, %eax
; AVX1-NEXT:    xorl %ecx, %eax
; AVX1-NEXT:    retq
;
; AVX512-LABEL: f20u:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX512-NEXT:    vcmpltsd %xmm1, %xmm0, %k1
; AVX512-NEXT:    vsubsd %xmm1, %xmm0, %xmm2
; AVX512-NEXT:    vmovsd %xmm0, %xmm2, %xmm2 {%k1}
; AVX512-NEXT:    vcvttsd2si %xmm2, %ecx
; AVX512-NEXT:    xorl %eax, %eax
; AVX512-NEXT:    vucomisd %xmm1, %xmm0
; AVX512-NEXT:    setae %al
; AVX512-NEXT:    shll $31, %eax
; AVX512-NEXT:    xorl %ecx, %eax
; AVX512-NEXT:    retq
entry:
  %result = call i32 @llvm.experimental.constrained.fptoui.i32.f64(double %x,
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

; Verify that round(42.1) isn't simplified when the rounding mode is
; unknown.
; Verify that no gross errors happen.
define float @f21() #0 {
; SSE-LABEL: f21:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    cvtsd2ss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f21:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vcvtsd2ss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %result = call float @llvm.experimental.constrained.fptrunc.f32.f64(
                                               double 42.1,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret float %result
}

define double @f22(float %x) #0 {
; SSE-LABEL: f22:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    cvtss2sd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f22:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vcvtss2sd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %result = call double @llvm.experimental.constrained.fpext.f64.f32(float %x,
                                               metadata !"fpexcept.strict") #0
  ret double %result
}

define i32 @f23(double %x) #0 {
; COMMON-LABEL: f23:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp lrint # TAILCALL
entry:
  %result = call i32 @llvm.experimental.constrained.lrint.i32.f64(double %x,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i32 @f24(float %x) #0 {
; COMMON-LABEL: f24:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp lrintf # TAILCALL
entry:
  %result = call i32 @llvm.experimental.constrained.lrint.i32.f32(float %x,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i64 @f25(double %x) #0 {
; COMMON-LABEL: f25:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp llrint # TAILCALL
entry:
  %result = call i64 @llvm.experimental.constrained.llrint.i64.f64(double %x,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

define i64 @f26(float %x) {
; COMMON-LABEL: f26:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp llrintf # TAILCALL
entry:
  %result = call i64 @llvm.experimental.constrained.llrint.i64.f32(float %x,
                                               metadata !"round.dynamic",
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

define i32 @f27(double %x) #0 {
; COMMON-LABEL: f27:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp lround # TAILCALL
entry:
  %result = call i32 @llvm.experimental.constrained.lround.i32.f64(double %x,
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i32 @f28(float %x) #0 {
; COMMON-LABEL: f28:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp lroundf # TAILCALL
entry:
  %result = call i32 @llvm.experimental.constrained.lround.i32.f32(float %x,
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i64 @f29(double %x) #0 {
; COMMON-LABEL: f29:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp llround # TAILCALL
entry:
  %result = call i64 @llvm.experimental.constrained.llround.i64.f64(double %x,
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

define i64 @f30(float %x) #0 {
; COMMON-LABEL: f30:
; COMMON:       # %bb.0: # %entry
; COMMON-NEXT:    jmp llroundf # TAILCALL
entry:
  %result = call i64 @llvm.experimental.constrained.llround.i64.f32(float %x,
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

attributes #0 = { strictfp }

@llvm.fp.env = thread_local global i8 zeroinitializer, section "llvm.metadata"
declare double @llvm.experimental.constrained.fadd.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.fsub.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.fmul.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.fdiv.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.frem.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.sqrt.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.pow.f64(double, double, metadata, metadata)
declare double @llvm.experimental.constrained.powi.f64(double, i32, metadata, metadata)
declare double @llvm.experimental.constrained.sin.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.cos.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.exp.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.exp2.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.log.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.log10.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.log2.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.rint.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.nearbyint.f64(double, metadata, metadata)
declare i32 @llvm.experimental.constrained.fptosi.i32.f64(double, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f64(double, metadata)
declare float @llvm.experimental.constrained.fptrunc.f32.f64(double, metadata, metadata)
declare double @llvm.experimental.constrained.fpext.f64.f32(float, metadata)
declare i32 @llvm.experimental.constrained.lrint.i32.f64(double, metadata, metadata)
declare i32 @llvm.experimental.constrained.lrint.i32.f32(float, metadata, metadata)
declare i64 @llvm.experimental.constrained.llrint.i64.f64(double, metadata, metadata)
declare i64 @llvm.experimental.constrained.llrint.i64.f32(float, metadata, metadata)
declare i32 @llvm.experimental.constrained.lround.i32.f64(double, metadata)
declare i32 @llvm.experimental.constrained.lround.i32.f32(float, metadata)
declare i64 @llvm.experimental.constrained.llround.i64.f64(double, metadata)
declare i64 @llvm.experimental.constrained.llround.i64.f32(float, metadata)
