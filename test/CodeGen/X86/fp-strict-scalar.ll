; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 -O3 | FileCheck %s --check-prefixes=CHECK,SSE,SSE-X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 -O3 | FileCheck %s --check-prefixes=CHECK,SSE,SSE-X64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx -O3 | FileCheck %s --check-prefixes=CHECK,AVX,AVX-X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx -O3 | FileCheck %s --check-prefixes=CHECK,AVX,AVX-X64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 | FileCheck %s --check-prefixes=CHECK,AVX,AVX-X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f -mattr=+avx512vl -O3 | FileCheck %s --check-prefixes=CHECK,AVX,AVX-X64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=-sse -O3 | FileCheck %s --check-prefixes=CHECK,X87

declare double @llvm.experimental.constrained.fadd.f64(double, double, metadata, metadata)
declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fsub.f64(double, double, metadata, metadata)
declare float @llvm.experimental.constrained.fsub.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fmul.f64(double, double, metadata, metadata)
declare float @llvm.experimental.constrained.fmul.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fdiv.f64(double, double, metadata, metadata)
declare float @llvm.experimental.constrained.fdiv.f32(float, float, metadata, metadata)
declare double @llvm.experimental.constrained.fpext.f64.f32(float, metadata)
declare float @llvm.experimental.constrained.fptrunc.f64.f32(double, metadata, metadata)
declare float @llvm.experimental.constrained.sqrt.f32(float, metadata, metadata)
declare double @llvm.experimental.constrained.sqrt.f64(double, metadata, metadata)

define double @fadd_f64(double %a, double %b) nounwind strictfp {
; SSE-X86-LABEL: fadd_f64:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %ebp
; SSE-X86-NEXT:    movl %esp, %ebp
; SSE-X86-NEXT:    andl $-8, %esp
; SSE-X86-NEXT:    subl $8, %esp
; SSE-X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X86-NEXT:    addsd 16(%ebp), %xmm0
; SSE-X86-NEXT:    movsd %xmm0, (%esp)
; SSE-X86-NEXT:    fldl (%esp)
; SSE-X86-NEXT:    movl %ebp, %esp
; SSE-X86-NEXT:    popl %ebp
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fadd_f64:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    addsd %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fadd_f64:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %ebp
; AVX-X86-NEXT:    movl %esp, %ebp
; AVX-X86-NEXT:    andl $-8, %esp
; AVX-X86-NEXT:    subl $8, %esp
; AVX-X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X86-NEXT:    vaddsd 16(%ebp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovsd %xmm0, (%esp)
; AVX-X86-NEXT:    fldl (%esp)
; AVX-X86-NEXT:    movl %ebp, %esp
; AVX-X86-NEXT:    popl %ebp
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fadd_f64:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fadd_f64:
; X87:       # %bb.0:
; X87-NEXT:    fldl {{[0-9]+}}(%esp)
; X87-NEXT:    faddl {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call double @llvm.experimental.constrained.fadd.f64(double %a, double %b,
                                                             metadata !"round.dynamic",
                                                             metadata !"fpexcept.strict") #0
  ret double %ret
}

define float @fadd_fsub_f32(float %a, float %b) nounwind strictfp {
; SSE-X86-LABEL: fadd_fsub_f32:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %eax
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    addss {{[0-9]+}}(%esp), %xmm0
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    flds (%esp)
; SSE-X86-NEXT:    popl %eax
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fadd_fsub_f32:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    addss %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fadd_fsub_f32:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %eax
; AVX-X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X86-NEXT:    vaddss {{[0-9]+}}(%esp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovss %xmm0, (%esp)
; AVX-X86-NEXT:    flds (%esp)
; AVX-X86-NEXT:    popl %eax
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fadd_fsub_f32:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fadd_fsub_f32:
; X87:       # %bb.0:
; X87-NEXT:    flds {{[0-9]+}}(%esp)
; X87-NEXT:    fadds {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call float @llvm.experimental.constrained.fadd.f32(float %a, float %b,
                                                            metadata !"round.dynamic",
                                                            metadata !"fpexcept.strict") #0
  ret float %ret
}

define double @fsub_f64(double %a, double %b) nounwind strictfp {
; SSE-X86-LABEL: fsub_f64:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %ebp
; SSE-X86-NEXT:    movl %esp, %ebp
; SSE-X86-NEXT:    andl $-8, %esp
; SSE-X86-NEXT:    subl $8, %esp
; SSE-X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X86-NEXT:    subsd 16(%ebp), %xmm0
; SSE-X86-NEXT:    movsd %xmm0, (%esp)
; SSE-X86-NEXT:    fldl (%esp)
; SSE-X86-NEXT:    movl %ebp, %esp
; SSE-X86-NEXT:    popl %ebp
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fsub_f64:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    subsd %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fsub_f64:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %ebp
; AVX-X86-NEXT:    movl %esp, %ebp
; AVX-X86-NEXT:    andl $-8, %esp
; AVX-X86-NEXT:    subl $8, %esp
; AVX-X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X86-NEXT:    vsubsd 16(%ebp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovsd %xmm0, (%esp)
; AVX-X86-NEXT:    fldl (%esp)
; AVX-X86-NEXT:    movl %ebp, %esp
; AVX-X86-NEXT:    popl %ebp
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fsub_f64:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fsub_f64:
; X87:       # %bb.0:
; X87-NEXT:    fldl {{[0-9]+}}(%esp)
; X87-NEXT:    fsubl {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call double @llvm.experimental.constrained.fsub.f64(double %a, double %b,
                                                             metadata !"round.dynamic",
                                                             metadata !"fpexcept.strict") #0
  ret double %ret
}

define float @fsub_f32(float %a, float %b) nounwind strictfp {
; SSE-X86-LABEL: fsub_f32:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %eax
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    subss {{[0-9]+}}(%esp), %xmm0
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    flds (%esp)
; SSE-X86-NEXT:    popl %eax
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fsub_f32:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    subss %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fsub_f32:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %eax
; AVX-X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X86-NEXT:    vsubss {{[0-9]+}}(%esp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovss %xmm0, (%esp)
; AVX-X86-NEXT:    flds (%esp)
; AVX-X86-NEXT:    popl %eax
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fsub_f32:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fsub_f32:
; X87:       # %bb.0:
; X87-NEXT:    flds {{[0-9]+}}(%esp)
; X87-NEXT:    fsubs {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call float @llvm.experimental.constrained.fsub.f32(float %a, float %b,
                                                            metadata !"round.dynamic",
                                                            metadata !"fpexcept.strict") #0
  ret float %ret
}

define double @fmul_f64(double %a, double %b) nounwind strictfp {
; SSE-X86-LABEL: fmul_f64:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %ebp
; SSE-X86-NEXT:    movl %esp, %ebp
; SSE-X86-NEXT:    andl $-8, %esp
; SSE-X86-NEXT:    subl $8, %esp
; SSE-X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X86-NEXT:    mulsd 16(%ebp), %xmm0
; SSE-X86-NEXT:    movsd %xmm0, (%esp)
; SSE-X86-NEXT:    fldl (%esp)
; SSE-X86-NEXT:    movl %ebp, %esp
; SSE-X86-NEXT:    popl %ebp
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fmul_f64:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    mulsd %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fmul_f64:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %ebp
; AVX-X86-NEXT:    movl %esp, %ebp
; AVX-X86-NEXT:    andl $-8, %esp
; AVX-X86-NEXT:    subl $8, %esp
; AVX-X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X86-NEXT:    vmulsd 16(%ebp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovsd %xmm0, (%esp)
; AVX-X86-NEXT:    fldl (%esp)
; AVX-X86-NEXT:    movl %ebp, %esp
; AVX-X86-NEXT:    popl %ebp
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fmul_f64:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vmulsd %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fmul_f64:
; X87:       # %bb.0:
; X87-NEXT:    fldl {{[0-9]+}}(%esp)
; X87-NEXT:    fmull {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call double @llvm.experimental.constrained.fmul.f64(double %a, double %b,
                                                             metadata !"round.dynamic",
                                                             metadata !"fpexcept.strict") #0
  ret double %ret
}

define float @fmul_f32(float %a, float %b) nounwind strictfp {
; SSE-X86-LABEL: fmul_f32:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %eax
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    mulss {{[0-9]+}}(%esp), %xmm0
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    flds (%esp)
; SSE-X86-NEXT:    popl %eax
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fmul_f32:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    mulss %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fmul_f32:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %eax
; AVX-X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X86-NEXT:    vmulss {{[0-9]+}}(%esp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovss %xmm0, (%esp)
; AVX-X86-NEXT:    flds (%esp)
; AVX-X86-NEXT:    popl %eax
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fmul_f32:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fmul_f32:
; X87:       # %bb.0:
; X87-NEXT:    flds {{[0-9]+}}(%esp)
; X87-NEXT:    fmuls {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call float @llvm.experimental.constrained.fmul.f32(float %a, float %b,
                                                            metadata !"round.dynamic",
                                                            metadata !"fpexcept.strict") #0
  ret float %ret
}

define double @fdiv_f64(double %a, double %b) nounwind strictfp {
; SSE-X86-LABEL: fdiv_f64:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %ebp
; SSE-X86-NEXT:    movl %esp, %ebp
; SSE-X86-NEXT:    andl $-8, %esp
; SSE-X86-NEXT:    subl $8, %esp
; SSE-X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X86-NEXT:    divsd 16(%ebp), %xmm0
; SSE-X86-NEXT:    movsd %xmm0, (%esp)
; SSE-X86-NEXT:    fldl (%esp)
; SSE-X86-NEXT:    movl %ebp, %esp
; SSE-X86-NEXT:    popl %ebp
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fdiv_f64:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    divsd %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fdiv_f64:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %ebp
; AVX-X86-NEXT:    movl %esp, %ebp
; AVX-X86-NEXT:    andl $-8, %esp
; AVX-X86-NEXT:    subl $8, %esp
; AVX-X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X86-NEXT:    vdivsd 16(%ebp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovsd %xmm0, (%esp)
; AVX-X86-NEXT:    fldl (%esp)
; AVX-X86-NEXT:    movl %ebp, %esp
; AVX-X86-NEXT:    popl %ebp
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fdiv_f64:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vdivsd %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fdiv_f64:
; X87:       # %bb.0:
; X87-NEXT:    fldl {{[0-9]+}}(%esp)
; X87-NEXT:    fdivl {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call double @llvm.experimental.constrained.fdiv.f64(double %a, double %b,
                                                             metadata !"round.dynamic",
                                                             metadata !"fpexcept.strict") #0
  ret double %ret
}

define float @fdiv_f32(float %a, float %b) nounwind strictfp {
; SSE-X86-LABEL: fdiv_f32:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    pushl %eax
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    divss {{[0-9]+}}(%esp), %xmm0
; SSE-X86-NEXT:    movss %xmm0, (%esp)
; SSE-X86-NEXT:    flds (%esp)
; SSE-X86-NEXT:    popl %eax
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fdiv_f32:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    divss %xmm1, %xmm0
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fdiv_f32:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    pushl %eax
; AVX-X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X86-NEXT:    vdivss {{[0-9]+}}(%esp), %xmm0, %xmm0
; AVX-X86-NEXT:    vmovss %xmm0, (%esp)
; AVX-X86-NEXT:    flds (%esp)
; AVX-X86-NEXT:    popl %eax
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fdiv_f32:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vdivss %xmm1, %xmm0, %xmm0
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fdiv_f32:
; X87:       # %bb.0:
; X87-NEXT:    flds {{[0-9]+}}(%esp)
; X87-NEXT:    fdivs {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %ret = call float @llvm.experimental.constrained.fdiv.f32(float %a, float %b,
                                                            metadata !"round.dynamic",
                                                            metadata !"fpexcept.strict") #0
  ret float %ret
}

define void @fpext_f32_to_f64(float* %val, double* %ret) nounwind strictfp {
; SSE-X86-LABEL: fpext_f32_to_f64:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    cvtss2sd %xmm0, %xmm0
; SSE-X86-NEXT:    movsd %xmm0, (%eax)
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fpext_f32_to_f64:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X64-NEXT:    cvtss2sd %xmm0, %xmm0
; SSE-X64-NEXT:    movsd %xmm0, (%rsi)
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fpext_f32_to_f64:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; AVX-X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X86-NEXT:    vcvtss2sd %xmm0, %xmm0, %xmm0
; AVX-X86-NEXT:    vmovsd %xmm0, (%eax)
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fpext_f32_to_f64:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X64-NEXT:    vcvtss2sd %xmm0, %xmm0, %xmm0
; AVX-X64-NEXT:    vmovsd %xmm0, (%rsi)
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fpext_f32_to_f64:
; X87:       # %bb.0:
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X87-NEXT:    flds (%ecx)
; X87-NEXT:    fstpl (%eax)
; X87-NEXT:    retl
  %1 = load float, float* %val, align 4
  %res = call double @llvm.experimental.constrained.fpext.f64.f32(float %1,
                                                                  metadata !"fpexcept.strict") #0
  store double %res, double* %ret, align 8
  ret void
}

define void @fptrunc_double_to_f32(double* %val, float *%ret) nounwind strictfp {
; SSE-X86-LABEL: fptrunc_double_to_f32:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; SSE-X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X86-NEXT:    cvtsd2ss %xmm0, %xmm0
; SSE-X86-NEXT:    movss %xmm0, (%eax)
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fptrunc_double_to_f32:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X64-NEXT:    cvtsd2ss %xmm0, %xmm0
; SSE-X64-NEXT:    movss %xmm0, (%rsi)
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fptrunc_double_to_f32:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; AVX-X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X86-NEXT:    vcvtsd2ss %xmm0, %xmm0, %xmm0
; AVX-X86-NEXT:    vmovss %xmm0, (%eax)
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fptrunc_double_to_f32:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X64-NEXT:    vcvtsd2ss %xmm0, %xmm0, %xmm0
; AVX-X64-NEXT:    vmovss %xmm0, (%rsi)
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fptrunc_double_to_f32:
; X87:       # %bb.0:
; X87-NEXT:    pushl %eax
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X87-NEXT:    fldl (%ecx)
; X87-NEXT:    fstps (%esp)
; X87-NEXT:    flds (%esp)
; X87-NEXT:    fstps (%eax)
; X87-NEXT:    popl %eax
; X87-NEXT:    retl
  %1 = load double, double* %val, align 8
  %res = call float @llvm.experimental.constrained.fptrunc.f64.f32(double %1,
                                                                   metadata !"round.dynamic",
                                                                   metadata !"fpexcept.strict") #0
  store float %res, float* %ret, align 4
  ret void
}

define void @fsqrt_f64(double* %a) nounwind strictfp {
; SSE-X86-LABEL: fsqrt_f64:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X86-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-X86-NEXT:    movsd %xmm0, (%eax)
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fsqrt_f64:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-X64-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-X64-NEXT:    movsd %xmm0, (%rdi)
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fsqrt_f64:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X86-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-X86-NEXT:    vmovsd %xmm0, (%eax)
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fsqrt_f64:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-X64-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-X64-NEXT:    vmovsd %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fsqrt_f64:
; X87:       # %bb.0:
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    fldl (%eax)
; X87-NEXT:    fsqrt
; X87-NEXT:    fstpl (%eax)
; X87-NEXT:    retl
  %1 = load double, double* %a, align 8
  %res = call double @llvm.experimental.constrained.sqrt.f64(double %1,
                                                             metadata !"round.dynamic",
                                                             metadata !"fpexcept.strict") #0
  store double %res, double* %a, align 8
  ret void
}

define void @fsqrt_f32(float* %a) nounwind strictfp {
; SSE-X86-LABEL: fsqrt_f32:
; SSE-X86:       # %bb.0:
; SSE-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X86-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X86-NEXT:    sqrtss %xmm0, %xmm0
; SSE-X86-NEXT:    movss %xmm0, (%eax)
; SSE-X86-NEXT:    retl
;
; SSE-X64-LABEL: fsqrt_f32:
; SSE-X64:       # %bb.0:
; SSE-X64-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-X64-NEXT:    sqrtss %xmm0, %xmm0
; SSE-X64-NEXT:    movss %xmm0, (%rdi)
; SSE-X64-NEXT:    retq
;
; AVX-X86-LABEL: fsqrt_f32:
; AVX-X86:       # %bb.0:
; AVX-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X86-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-X86-NEXT:    vmovss %xmm0, (%eax)
; AVX-X86-NEXT:    retl
;
; AVX-X64-LABEL: fsqrt_f32:
; AVX-X64:       # %bb.0:
; AVX-X64-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-X64-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-X64-NEXT:    vmovss %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; X87-LABEL: fsqrt_f32:
; X87:       # %bb.0:
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    flds (%eax)
; X87-NEXT:    fsqrt
; X87-NEXT:    fstps (%eax)
; X87-NEXT:    retl
  %1 = load float, float* %a, align 4
  %res = call float @llvm.experimental.constrained.sqrt.f32(float %1,
                                                            metadata !"round.dynamic",
                                                            metadata !"fpexcept.strict") #0
  store float %res, float* %a, align 4
  ret void
}

attributes #0 = { strictfp }
