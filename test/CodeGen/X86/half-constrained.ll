; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin | FileCheck %s --check-prefix=X32-NOF16C
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=f16c | FileCheck %s --check-prefix=X32-F16C
; RUN: llc < %s -mtriple=x86_64-apple-darwin | FileCheck %s --check-prefix=X64-NOF16C
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=f16c | FileCheck %s --check-prefix=X64-F16C

@a = global half 0xH0000, align 2
@b = global half 0xH0000, align 2
@c = global half 0xH0000, align 2

define float @half_to_float() strictfp {
; X32-NOF16C-LABEL: half_to_float:
; X32-NOF16C:       ## %bb.0:
; X32-NOF16C-NEXT:    subl $12, %esp
; X32-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X32-NOF16C-NEXT:    movzwl _a, %eax
; X32-NOF16C-NEXT:    movl %eax, (%esp)
; X32-NOF16C-NEXT:    calll ___extendhfsf2
; X32-NOF16C-NEXT:    addl $12, %esp
; X32-NOF16C-NEXT:    retl
;
; X32-F16C-LABEL: half_to_float:
; X32-F16C:       ## %bb.0:
; X32-F16C-NEXT:    pushl %eax
; X32-F16C-NEXT:    .cfi_def_cfa_offset 8
; X32-F16C-NEXT:    movzwl _a, %eax
; X32-F16C-NEXT:    vmovd %eax, %xmm0
; X32-F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; X32-F16C-NEXT:    vmovss %xmm0, (%esp)
; X32-F16C-NEXT:    flds (%esp)
; X32-F16C-NEXT:    wait
; X32-F16C-NEXT:    popl %eax
; X32-F16C-NEXT:    retl
;
; X64-NOF16C-LABEL: half_to_float:
; X64-NOF16C:       ## %bb.0:
; X64-NOF16C-NEXT:    pushq %rax
; X64-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X64-NOF16C-NEXT:    pinsrw $0, _a(%rip), %xmm0
; X64-NOF16C-NEXT:    callq ___extendhfsf2
; X64-NOF16C-NEXT:    popq %rax
; X64-NOF16C-NEXT:    retq
;
; X64-F16C-LABEL: half_to_float:
; X64-F16C:       ## %bb.0:
; X64-F16C-NEXT:    movzwl _a(%rip), %eax
; X64-F16C-NEXT:    vmovd %eax, %xmm0
; X64-F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; X64-F16C-NEXT:    retq
  %1 = load half, ptr @a, align 2
  %2 = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %1, metadata !"fpexcept.strict") #0
  ret float %2
}

define double @half_to_double() strictfp {
; X32-NOF16C-LABEL: half_to_double:
; X32-NOF16C:       ## %bb.0:
; X32-NOF16C-NEXT:    subl $12, %esp
; X32-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X32-NOF16C-NEXT:    movzwl _a, %eax
; X32-NOF16C-NEXT:    movl %eax, (%esp)
; X32-NOF16C-NEXT:    calll ___extendhfsf2
; X32-NOF16C-NEXT:    addl $12, %esp
; X32-NOF16C-NEXT:    retl
;
; X32-F16C-LABEL: half_to_double:
; X32-F16C:       ## %bb.0:
; X32-F16C-NEXT:    subl $12, %esp
; X32-F16C-NEXT:    .cfi_def_cfa_offset 16
; X32-F16C-NEXT:    movzwl _a, %eax
; X32-F16C-NEXT:    vmovd %eax, %xmm0
; X32-F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; X32-F16C-NEXT:    vcvtss2sd %xmm0, %xmm0, %xmm0
; X32-F16C-NEXT:    vmovsd %xmm0, (%esp)
; X32-F16C-NEXT:    fldl (%esp)
; X32-F16C-NEXT:    wait
; X32-F16C-NEXT:    addl $12, %esp
; X32-F16C-NEXT:    retl
;
; X64-NOF16C-LABEL: half_to_double:
; X64-NOF16C:       ## %bb.0:
; X64-NOF16C-NEXT:    pushq %rax
; X64-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X64-NOF16C-NEXT:    pinsrw $0, _a(%rip), %xmm0
; X64-NOF16C-NEXT:    callq ___extendhfsf2
; X64-NOF16C-NEXT:    cvtss2sd %xmm0, %xmm0
; X64-NOF16C-NEXT:    popq %rax
; X64-NOF16C-NEXT:    retq
;
; X64-F16C-LABEL: half_to_double:
; X64-F16C:       ## %bb.0:
; X64-F16C-NEXT:    movzwl _a(%rip), %eax
; X64-F16C-NEXT:    vmovd %eax, %xmm0
; X64-F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; X64-F16C-NEXT:    vcvtss2sd %xmm0, %xmm0, %xmm0
; X64-F16C-NEXT:    retq
  %1 = load half, ptr @a, align 2
  %2 = tail call double @llvm.experimental.constrained.fpext.f64.f16(half %1, metadata !"fpexcept.strict") #0
  ret double %2
}

define x86_fp80 @half_to_fp80() strictfp {
; X32-NOF16C-LABEL: half_to_fp80:
; X32-NOF16C:       ## %bb.0:
; X32-NOF16C-NEXT:    subl $12, %esp
; X32-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X32-NOF16C-NEXT:    movzwl _a, %eax
; X32-NOF16C-NEXT:    movl %eax, (%esp)
; X32-NOF16C-NEXT:    calll ___extendhfsf2
; X32-NOF16C-NEXT:    addl $12, %esp
; X32-NOF16C-NEXT:    retl
;
; X32-F16C-LABEL: half_to_fp80:
; X32-F16C:       ## %bb.0:
; X32-F16C-NEXT:    subl $12, %esp
; X32-F16C-NEXT:    .cfi_def_cfa_offset 16
; X32-F16C-NEXT:    vpinsrw $0, _a, %xmm0, %xmm0
; X32-F16C-NEXT:    vpextrw $0, %xmm0, (%esp)
; X32-F16C-NEXT:    calll ___extendhfxf2
; X32-F16C-NEXT:    addl $12, %esp
; X32-F16C-NEXT:    retl
;
; X64-NOF16C-LABEL: half_to_fp80:
; X64-NOF16C:       ## %bb.0:
; X64-NOF16C-NEXT:    pushq %rax
; X64-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X64-NOF16C-NEXT:    pinsrw $0, _a(%rip), %xmm0
; X64-NOF16C-NEXT:    callq ___extendhfxf2
; X64-NOF16C-NEXT:    popq %rax
; X64-NOF16C-NEXT:    retq
;
; X64-F16C-LABEL: half_to_fp80:
; X64-F16C:       ## %bb.0:
; X64-F16C-NEXT:    pushq %rax
; X64-F16C-NEXT:    .cfi_def_cfa_offset 16
; X64-F16C-NEXT:    vpinsrw $0, _a(%rip), %xmm0, %xmm0
; X64-F16C-NEXT:    callq ___extendhfxf2
; X64-F16C-NEXT:    popq %rax
; X64-F16C-NEXT:    retq
  %1 = load half, ptr @a, align 2
  %2 = tail call x86_fp80 @llvm.experimental.constrained.fpext.f80.f16(half %1, metadata !"fpexcept.strict") #0
  ret x86_fp80 %2
}

define void @float_to_half(float %0) strictfp {
; X32-NOF16C-LABEL: float_to_half:
; X32-NOF16C:       ## %bb.0:
; X32-NOF16C-NEXT:    subl $12, %esp
; X32-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X32-NOF16C-NEXT:    flds {{[0-9]+}}(%esp)
; X32-NOF16C-NEXT:    fstps (%esp)
; X32-NOF16C-NEXT:    wait
; X32-NOF16C-NEXT:    calll ___truncsfhf2
; X32-NOF16C-NEXT:    movw %ax, _a
; X32-NOF16C-NEXT:    addl $12, %esp
; X32-NOF16C-NEXT:    retl
;
; X32-F16C-LABEL: float_to_half:
; X32-F16C:       ## %bb.0:
; X32-F16C-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-F16C-NEXT:    vcvtps2ph $4, %xmm0, %xmm0
; X32-F16C-NEXT:    vmovd %xmm0, %eax
; X32-F16C-NEXT:    movw %ax, _a
; X32-F16C-NEXT:    retl
;
; X64-NOF16C-LABEL: float_to_half:
; X64-NOF16C:       ## %bb.0:
; X64-NOF16C-NEXT:    pushq %rax
; X64-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X64-NOF16C-NEXT:    callq ___truncsfhf2
; X64-NOF16C-NEXT:    pextrw $0, %xmm0, %eax
; X64-NOF16C-NEXT:    movw %ax, _a(%rip)
; X64-NOF16C-NEXT:    popq %rax
; X64-NOF16C-NEXT:    retq
;
; X64-F16C-LABEL: float_to_half:
; X64-F16C:       ## %bb.0:
; X64-F16C-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-F16C-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; X64-F16C-NEXT:    vcvtps2ph $4, %xmm0, %xmm0
; X64-F16C-NEXT:    vmovd %xmm0, %eax
; X64-F16C-NEXT:    movw %ax, _a(%rip)
; X64-F16C-NEXT:    retq
  %2 = tail call half @llvm.experimental.constrained.fptrunc.f16.f32(float %0, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  store half %2, ptr @a, align 2
  ret void
}

define void @double_to_half(double %0) strictfp {
; X32-NOF16C-LABEL: double_to_half:
; X32-NOF16C:       ## %bb.0:
; X32-NOF16C-NEXT:    subl $12, %esp
; X32-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X32-NOF16C-NEXT:    fldl {{[0-9]+}}(%esp)
; X32-NOF16C-NEXT:    fstpl (%esp)
; X32-NOF16C-NEXT:    wait
; X32-NOF16C-NEXT:    calll ___truncdfhf2
; X32-NOF16C-NEXT:    movw %ax, _a
; X32-NOF16C-NEXT:    addl $12, %esp
; X32-NOF16C-NEXT:    retl
;
; X32-F16C-LABEL: double_to_half:
; X32-F16C:       ## %bb.0:
; X32-F16C-NEXT:    subl $12, %esp
; X32-F16C-NEXT:    .cfi_def_cfa_offset 16
; X32-F16C-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; X32-F16C-NEXT:    vmovq %xmm0, (%esp)
; X32-F16C-NEXT:    calll ___truncdfhf2
; X32-F16C-NEXT:    vpextrw $0, %xmm0, _a
; X32-F16C-NEXT:    addl $12, %esp
; X32-F16C-NEXT:    retl
;
; X64-NOF16C-LABEL: double_to_half:
; X64-NOF16C:       ## %bb.0:
; X64-NOF16C-NEXT:    pushq %rax
; X64-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X64-NOF16C-NEXT:    callq ___truncdfhf2
; X64-NOF16C-NEXT:    pextrw $0, %xmm0, %eax
; X64-NOF16C-NEXT:    movw %ax, _a(%rip)
; X64-NOF16C-NEXT:    popq %rax
; X64-NOF16C-NEXT:    retq
;
; X64-F16C-LABEL: double_to_half:
; X64-F16C:       ## %bb.0:
; X64-F16C-NEXT:    pushq %rax
; X64-F16C-NEXT:    .cfi_def_cfa_offset 16
; X64-F16C-NEXT:    callq ___truncdfhf2
; X64-F16C-NEXT:    vpextrw $0, %xmm0, _a(%rip)
; X64-F16C-NEXT:    popq %rax
; X64-F16C-NEXT:    retq
  %2 = tail call half @llvm.experimental.constrained.fptrunc.f16.f64(double %0, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  store half %2, ptr @a, align 2
  ret void
}

define void @fp80_to_half(x86_fp80 %0) strictfp {
; X32-NOF16C-LABEL: fp80_to_half:
; X32-NOF16C:       ## %bb.0:
; X32-NOF16C-NEXT:    subl $28, %esp
; X32-NOF16C-NEXT:    .cfi_def_cfa_offset 32
; X32-NOF16C-NEXT:    fldt {{[0-9]+}}(%esp)
; X32-NOF16C-NEXT:    fstpt (%esp)
; X32-NOF16C-NEXT:    wait
; X32-NOF16C-NEXT:    calll ___truncxfhf2
; X32-NOF16C-NEXT:    movw %ax, _a
; X32-NOF16C-NEXT:    addl $28, %esp
; X32-NOF16C-NEXT:    retl
;
; X32-F16C-LABEL: fp80_to_half:
; X32-F16C:       ## %bb.0:
; X32-F16C-NEXT:    subl $28, %esp
; X32-F16C-NEXT:    .cfi_def_cfa_offset 32
; X32-F16C-NEXT:    fldt {{[0-9]+}}(%esp)
; X32-F16C-NEXT:    fstpt (%esp)
; X32-F16C-NEXT:    wait
; X32-F16C-NEXT:    calll ___truncxfhf2
; X32-F16C-NEXT:    vpextrw $0, %xmm0, _a
; X32-F16C-NEXT:    addl $28, %esp
; X32-F16C-NEXT:    retl
;
; X64-NOF16C-LABEL: fp80_to_half:
; X64-NOF16C:       ## %bb.0:
; X64-NOF16C-NEXT:    subq $24, %rsp
; X64-NOF16C-NEXT:    .cfi_def_cfa_offset 32
; X64-NOF16C-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NOF16C-NEXT:    fstpt (%rsp)
; X64-NOF16C-NEXT:    wait
; X64-NOF16C-NEXT:    callq ___truncxfhf2
; X64-NOF16C-NEXT:    pextrw $0, %xmm0, %eax
; X64-NOF16C-NEXT:    movw %ax, _a(%rip)
; X64-NOF16C-NEXT:    addq $24, %rsp
; X64-NOF16C-NEXT:    retq
;
; X64-F16C-LABEL: fp80_to_half:
; X64-F16C:       ## %bb.0:
; X64-F16C-NEXT:    subq $24, %rsp
; X64-F16C-NEXT:    .cfi_def_cfa_offset 32
; X64-F16C-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-F16C-NEXT:    fstpt (%rsp)
; X64-F16C-NEXT:    wait
; X64-F16C-NEXT:    callq ___truncxfhf2
; X64-F16C-NEXT:    vpextrw $0, %xmm0, _a(%rip)
; X64-F16C-NEXT:    addq $24, %rsp
; X64-F16C-NEXT:    retq
  %2 = tail call half @llvm.experimental.constrained.fptrunc.f16.f80(x86_fp80 %0, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  store half %2, ptr @a, align 2
  ret void
}

define void @add() strictfp {
; X32-NOF16C-LABEL: add:
; X32-NOF16C:       ## %bb.0:
; X32-NOF16C-NEXT:    subl $12, %esp
; X32-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X32-NOF16C-NEXT:    movzwl _a, %eax
; X32-NOF16C-NEXT:    movl %eax, (%esp)
; X32-NOF16C-NEXT:    calll ___extendhfsf2
; X32-NOF16C-NEXT:    fstps {{[-0-9]+}}(%e{{[sb]}}p) ## 4-byte Folded Spill
; X32-NOF16C-NEXT:    wait
; X32-NOF16C-NEXT:    movzwl _b, %eax
; X32-NOF16C-NEXT:    movl %eax, (%esp)
; X32-NOF16C-NEXT:    calll ___extendhfsf2
; X32-NOF16C-NEXT:    flds {{[-0-9]+}}(%e{{[sb]}}p) ## 4-byte Folded Reload
; X32-NOF16C-NEXT:    faddp %st, %st(1)
; X32-NOF16C-NEXT:    fstps (%esp)
; X32-NOF16C-NEXT:    wait
; X32-NOF16C-NEXT:    calll ___truncsfhf2
; X32-NOF16C-NEXT:    movw %ax, _c
; X32-NOF16C-NEXT:    addl $12, %esp
; X32-NOF16C-NEXT:    retl
;
; X32-F16C-LABEL: add:
; X32-F16C:       ## %bb.0:
; X32-F16C-NEXT:    movzwl _a, %eax
; X32-F16C-NEXT:    vmovd %eax, %xmm0
; X32-F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; X32-F16C-NEXT:    movzwl _b, %eax
; X32-F16C-NEXT:    vmovd %eax, %xmm1
; X32-F16C-NEXT:    vcvtph2ps %xmm1, %xmm1
; X32-F16C-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; X32-F16C-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-F16C-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; X32-F16C-NEXT:    vcvtps2ph $4, %xmm0, %xmm0
; X32-F16C-NEXT:    vmovd %xmm0, %eax
; X32-F16C-NEXT:    movw %ax, _c
; X32-F16C-NEXT:    retl
;
; X64-NOF16C-LABEL: add:
; X64-NOF16C:       ## %bb.0:
; X64-NOF16C-NEXT:    pushq %rax
; X64-NOF16C-NEXT:    .cfi_def_cfa_offset 16
; X64-NOF16C-NEXT:    pinsrw $0, _a(%rip), %xmm0
; X64-NOF16C-NEXT:    callq ___extendhfsf2
; X64-NOF16C-NEXT:    movd %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 4-byte Folded Spill
; X64-NOF16C-NEXT:    pinsrw $0, _b(%rip), %xmm0
; X64-NOF16C-NEXT:    callq ___extendhfsf2
; X64-NOF16C-NEXT:    addss {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 4-byte Folded Reload
; X64-NOF16C-NEXT:    callq ___truncsfhf2
; X64-NOF16C-NEXT:    pextrw $0, %xmm0, %eax
; X64-NOF16C-NEXT:    movw %ax, _c(%rip)
; X64-NOF16C-NEXT:    popq %rax
; X64-NOF16C-NEXT:    retq
;
; X64-F16C-LABEL: add:
; X64-F16C:       ## %bb.0:
; X64-F16C-NEXT:    movzwl _a(%rip), %eax
; X64-F16C-NEXT:    vmovd %eax, %xmm0
; X64-F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; X64-F16C-NEXT:    movzwl _b(%rip), %eax
; X64-F16C-NEXT:    vmovd %eax, %xmm1
; X64-F16C-NEXT:    vcvtph2ps %xmm1, %xmm1
; X64-F16C-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; X64-F16C-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-F16C-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; X64-F16C-NEXT:    vcvtps2ph $4, %xmm0, %xmm0
; X64-F16C-NEXT:    vmovd %xmm0, %eax
; X64-F16C-NEXT:    movw %ax, _c(%rip)
; X64-F16C-NEXT:    retq
  %1 = load half, ptr @a, align 2
  %2 = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %1, metadata !"fpexcept.strict") #0
  %3 = load half, ptr @b, align 2
  %4 = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %3, metadata !"fpexcept.strict") #0
  %5 = tail call float @llvm.experimental.constrained.fadd.f32(float %2, float %4, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  %6 = tail call half @llvm.experimental.constrained.fptrunc.f16.f32(float %5, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  store half %6, ptr @c, align 2
  ret void
}

declare float @llvm.experimental.constrained.fpext.f32.f16(half, metadata)
declare double @llvm.experimental.constrained.fpext.f64.f16(half, metadata)
declare x86_fp80 @llvm.experimental.constrained.fpext.f80.f16(half, metadata)
declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata)
declare half @llvm.experimental.constrained.fptrunc.f16.f32(float, metadata, metadata)
declare half @llvm.experimental.constrained.fptrunc.f16.f64(double, metadata, metadata)
declare half @llvm.experimental.constrained.fptrunc.f16.f80(x86_fp80, metadata, metadata)

attributes #0 = { strictfp }

