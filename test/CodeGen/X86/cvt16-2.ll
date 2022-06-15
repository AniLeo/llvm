; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=-avx512fp16 | FileCheck %s -check-prefix=LIBCALL
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512fp16 | FileCheck %s -check-prefix=FP16

define void @test1(float %src, i16* %dest) {
; LIBCALL-LABEL: test1:
; LIBCALL:       # %bb.0:
; LIBCALL-NEXT:    pushq %rbx
; LIBCALL-NEXT:    .cfi_def_cfa_offset 16
; LIBCALL-NEXT:    .cfi_offset %rbx, -16
; LIBCALL-NEXT:    movq %rdi, %rbx
; LIBCALL-NEXT:    callq __gnu_f2h_ieee@PLT
; LIBCALL-NEXT:    movw %ax, (%rbx)
; LIBCALL-NEXT:    popq %rbx
; LIBCALL-NEXT:    .cfi_def_cfa_offset 8
; LIBCALL-NEXT:    retq
;
; FP16-LABEL: test1:
; FP16:       # %bb.0:
; FP16-NEXT:    vcvtss2sh %xmm0, %xmm0, %xmm0
; FP16-NEXT:    vmovsh %xmm0, (%rdi)
; FP16-NEXT:    retq
  %1 = tail call i16 @llvm.convert.to.fp16.f32(float %src)
  store i16 %1, i16* %dest, align 2
  ret void
}

define float @test2(i16* nocapture %src) {
; LIBCALL-LABEL: test2:
; LIBCALL:       # %bb.0:
; LIBCALL-NEXT:    movzwl (%rdi), %edi
; LIBCALL-NEXT:    jmp __gnu_h2f_ieee@PLT # TAILCALL
;
; FP16-LABEL: test2:
; FP16:       # %bb.0:
; FP16-NEXT:    vmovsh (%rdi), %xmm0
; FP16-NEXT:    vcvtsh2ss %xmm0, %xmm0, %xmm0
; FP16-NEXT:    retq
  %1 = load i16, i16* %src, align 2
  %2 = tail call float @llvm.convert.from.fp16.f32(i16 %1)
  ret float %2
}

define float @test3(float %src) nounwind uwtable readnone {
; LIBCALL-LABEL: test3:
; LIBCALL:       # %bb.0:
; LIBCALL-NEXT:    pushq %rax
; LIBCALL-NEXT:    .cfi_def_cfa_offset 16
; LIBCALL-NEXT:    callq __gnu_f2h_ieee@PLT
; LIBCALL-NEXT:    movzwl %ax, %edi
; LIBCALL-NEXT:    popq %rax
; LIBCALL-NEXT:    .cfi_def_cfa_offset 8
; LIBCALL-NEXT:    jmp __gnu_h2f_ieee@PLT # TAILCALL
;
; FP16-LABEL: test3:
; FP16:       # %bb.0:
; FP16-NEXT:    vcvtss2sh %xmm0, %xmm0, %xmm0
; FP16-NEXT:    vcvtsh2ss %xmm0, %xmm0, %xmm0
; FP16-NEXT:    retq
  %1 = tail call i16 @llvm.convert.to.fp16.f32(float %src)
  %2 = tail call float @llvm.convert.from.fp16.f32(i16 %1)
  ret float %2
}

; FIXME: Should it be __extendhfdf2?
define double @test4(i16* nocapture %src) {
; LIBCALL-LABEL: test4:
; LIBCALL:       # %bb.0:
; LIBCALL-NEXT:    pushq %rax
; LIBCALL-NEXT:    .cfi_def_cfa_offset 16
; LIBCALL-NEXT:    movzwl (%rdi), %edi
; LIBCALL-NEXT:    callq __gnu_h2f_ieee@PLT
; LIBCALL-NEXT:    cvtss2sd %xmm0, %xmm0
; LIBCALL-NEXT:    popq %rax
; LIBCALL-NEXT:    .cfi_def_cfa_offset 8
; LIBCALL-NEXT:    retq
;
; FP16-LABEL: test4:
; FP16:       # %bb.0:
; FP16-NEXT:    vmovsh (%rdi), %xmm0
; FP16-NEXT:    vcvtsh2sd %xmm0, %xmm0, %xmm0
; FP16-NEXT:    retq
  %1 = load i16, i16* %src, align 2
  %2 = tail call double @llvm.convert.from.fp16.f64(i16 %1)
  ret double %2
}

define i16 @test5(double %src) {
; LIBCALL-LABEL: test5:
; LIBCALL:       # %bb.0:
; LIBCALL-NEXT:    jmp __truncdfhf2@PLT # TAILCALL
;
; FP16-LABEL: test5:
; FP16:       # %bb.0:
; FP16-NEXT:    vcvtsd2sh %xmm0, %xmm0, %xmm0
; FP16-NEXT:    vmovw %xmm0, %eax
; FP16-NEXT:    # kill: def $ax killed $ax killed $eax
; FP16-NEXT:    retq
  %val = tail call i16 @llvm.convert.to.fp16.f64(double %src)
  ret i16 %val
}

; FIXME: Should it be __extendhfxf2?
define x86_fp80 @test6(i16* nocapture %src) {
; LIBCALL-LABEL: test6:
; LIBCALL:       # %bb.0:
; LIBCALL-NEXT:    pushq %rax
; LIBCALL-NEXT:    .cfi_def_cfa_offset 16
; LIBCALL-NEXT:    movzwl (%rdi), %edi
; LIBCALL-NEXT:    callq __gnu_h2f_ieee@PLT
; LIBCALL-NEXT:    movss %xmm0, {{[0-9]+}}(%rsp)
; LIBCALL-NEXT:    flds {{[0-9]+}}(%rsp)
; LIBCALL-NEXT:    popq %rax
; LIBCALL-NEXT:    .cfi_def_cfa_offset 8
; LIBCALL-NEXT:    retq
;
; FP16-LABEL: test6:
; FP16:       # %bb.0:
; FP16-NEXT:    pushq %rax
; FP16-NEXT:    .cfi_def_cfa_offset 16
; FP16-NEXT:    vmovsh (%rdi), %xmm0
; FP16-NEXT:    callq __extendhfxf2@PLT
; FP16-NEXT:    popq %rax
; FP16-NEXT:    .cfi_def_cfa_offset 8
; FP16-NEXT:    retq
  %1 = load i16, i16* %src, align 2
  %2 = tail call x86_fp80 @llvm.convert.from.fp16.f80(i16 %1)
  ret x86_fp80 %2
}

define i16 @test7(x86_fp80 %src) {
; LIBCALL-LABEL: test7:
; LIBCALL:       # %bb.0:
; LIBCALL-NEXT:    jmp __truncxfhf2@PLT # TAILCALL
;
; FP16-LABEL: test7:
; FP16:       # %bb.0:
; FP16-NEXT:    subq $24, %rsp
; FP16-NEXT:    .cfi_def_cfa_offset 32
; FP16-NEXT:    fldt {{[0-9]+}}(%rsp)
; FP16-NEXT:    fstpt (%rsp)
; FP16-NEXT:    callq __truncxfhf2@PLT
; FP16-NEXT:    vmovw %xmm0, %eax
; FP16-NEXT:    # kill: def $ax killed $ax killed $eax
; FP16-NEXT:    addq $24, %rsp
; FP16-NEXT:    .cfi_def_cfa_offset 8
; FP16-NEXT:    retq
  %val = tail call i16 @llvm.convert.to.fp16.f80(x86_fp80 %src)
  ret i16 %val
}

declare float @llvm.convert.from.fp16.f32(i16) nounwind readnone
declare i16 @llvm.convert.to.fp16.f32(float) nounwind readnone
declare double @llvm.convert.from.fp16.f64(i16) nounwind readnone
declare i16 @llvm.convert.to.fp16.f64(double) nounwind readnone
declare x86_fp80 @llvm.convert.from.fp16.f80(i16) nounwind readnone
declare i16 @llvm.convert.to.fp16.f80(x86_fp80) nounwind readnone
