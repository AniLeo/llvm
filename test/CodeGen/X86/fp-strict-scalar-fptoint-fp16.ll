; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2  -O3 | FileCheck %s --check-prefixes=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+f16c  -O3 | FileCheck %s --check-prefixes=AVX,F16C
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f  -O3 | FileCheck %s --check-prefixes=AVX,AVX512
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl -O3 | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl -O3 | FileCheck %s --check-prefixes=X64

declare i1  @llvm.experimental.constrained.fptosi.i1.f16(half, metadata)
declare i8  @llvm.experimental.constrained.fptosi.i8.f16(half, metadata)
declare i16 @llvm.experimental.constrained.fptosi.i16.f16(half, metadata)
declare i32 @llvm.experimental.constrained.fptosi.i32.f16(half, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.f16(half, metadata)
declare i1  @llvm.experimental.constrained.fptoui.i1.f16(half, metadata)
declare i8  @llvm.experimental.constrained.fptoui.i8.f16(half, metadata)
declare i16 @llvm.experimental.constrained.fptoui.i16.f16(half, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f16(half, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f16(half, metadata)

define i1 @fptosi_f16toi1(half %x) #0 {
; SSE2-LABEL: fptosi_f16toi1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %eax
; SSE2-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptosi_f16toi1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %eax
; AVX-NEXT:    # kill: def $al killed $al killed $eax
; AVX-NEXT:    retq
;
; X86-LABEL: fptosi_f16toi1:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi1:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i1 @llvm.experimental.constrained.fptosi.i1.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i1 %result
}

define i8 @fptosi_f16toi8(half %x) #0 {
; SSE2-LABEL: fptosi_f16toi8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %eax
; SSE2-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptosi_f16toi8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %eax
; AVX-NEXT:    # kill: def $al killed $al killed $eax
; AVX-NEXT:    retq
;
; X86-LABEL: fptosi_f16toi8:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi8:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i8 @llvm.experimental.constrained.fptosi.i8.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i8 %result
}

define i16 @fptosi_f16toi16(half %x) #0 {
; SSE2-LABEL: fptosi_f16toi16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %eax
; SSE2-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptosi_f16toi16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %eax
; AVX-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-NEXT:    retq
;
; X86-LABEL: fptosi_f16toi16:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi16:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %result = call i16 @llvm.experimental.constrained.fptosi.i16.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i16 %result
}

define i32 @fptosi_f16toi32(half %x) #0 {
; SSE2-LABEL: fptosi_f16toi32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %eax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptosi_f16toi32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %eax
; AVX-NEXT:    retq
;
; X86-LABEL: fptosi_f16toi32:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi32:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    retq
  %result = call i32 @llvm.experimental.constrained.fptosi.i32.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i64 @fptosi_f16toi64(half %x) #0 {
; SSE2-LABEL: fptosi_f16toi64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %rax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptosi_f16toi64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %rax
; AVX-NEXT:    retq
;
; X86-LABEL: fptosi_f16toi64:
; X86:       # %bb.0:
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vcvttph2qq %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    vpextrd $1, %xmm0, %edx
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi64:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %rax
; X64-NEXT:    retq
  %result = call i64 @llvm.experimental.constrained.fptosi.i64.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

define i1 @fptoui_f16toi1(half %x) #0 {
; SSE2-LABEL: fptoui_f16toi1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %eax
; SSE2-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptoui_f16toi1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %eax
; AVX-NEXT:    # kill: def $al killed $al killed $eax
; AVX-NEXT:    retq
;
; X86-LABEL: fptoui_f16toi1:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi1:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i1 @llvm.experimental.constrained.fptoui.i1.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i1 %result
}

define i8 @fptoui_f16toi8(half %x) #0 {
; SSE2-LABEL: fptoui_f16toi8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %eax
; SSE2-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptoui_f16toi8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %eax
; AVX-NEXT:    # kill: def $al killed $al killed $eax
; AVX-NEXT:    retq
;
; X86-LABEL: fptoui_f16toi8:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi8:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i8 @llvm.experimental.constrained.fptoui.i8.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i8 %result
}

define i16 @fptoui_f16toi16(half %x) #0 {
; SSE2-LABEL: fptoui_f16toi16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %eax
; SSE2-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; AVX-LABEL: fptoui_f16toi16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $0, %xmm0, %eax
; AVX-NEXT:    movzwl %ax, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX-NEXT:    vcvttss2si %xmm0, %eax
; AVX-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-NEXT:    retq
;
; X86-LABEL: fptoui_f16toi16:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi16:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %result = call i16 @llvm.experimental.constrained.fptoui.i16.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i16 %result
}

define i32 @fptoui_f16toi32(half %x) #0 {
; SSE2-LABEL: fptoui_f16toi32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    cvttss2si %xmm0, %rax
; SSE2-NEXT:    # kill: def $eax killed $eax killed $rax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; F16C-LABEL: fptoui_f16toi32:
; F16C:       # %bb.0:
; F16C-NEXT:    vpextrw $0, %xmm0, %eax
; F16C-NEXT:    movzwl %ax, %eax
; F16C-NEXT:    vmovd %eax, %xmm0
; F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; F16C-NEXT:    vcvttss2si %xmm0, %rax
; F16C-NEXT:    # kill: def $eax killed $eax killed $rax
; F16C-NEXT:    retq
;
; AVX512-LABEL: fptoui_f16toi32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpextrw $0, %xmm0, %eax
; AVX512-NEXT:    movzwl %ax, %eax
; AVX512-NEXT:    vmovd %eax, %xmm0
; AVX512-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX512-NEXT:    vcvttss2usi %xmm0, %eax
; AVX512-NEXT:    retq
;
; X86-LABEL: fptoui_f16toi32:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2usi {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi32:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2usi %xmm0, %eax
; X64-NEXT:    retq
  %result = call i32 @llvm.experimental.constrained.fptoui.i32.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i64 @fptoui_f16toi64(half %x) #0 {
; SSE2-LABEL: fptoui_f16toi64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushq %rax
; SSE2-NEXT:    callq __extendhfsf2@PLT
; SSE2-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; SSE2-NEXT:    comiss %xmm2, %xmm0
; SSE2-NEXT:    xorps %xmm1, %xmm1
; SSE2-NEXT:    jb .LBB9_2
; SSE2-NEXT:  # %bb.1:
; SSE2-NEXT:    movaps %xmm2, %xmm1
; SSE2-NEXT:  .LBB9_2:
; SSE2-NEXT:    subss %xmm1, %xmm0
; SSE2-NEXT:    cvttss2si %xmm0, %rcx
; SSE2-NEXT:    setae %al
; SSE2-NEXT:    movzbl %al, %eax
; SSE2-NEXT:    shlq $63, %rax
; SSE2-NEXT:    xorq %rcx, %rax
; SSE2-NEXT:    popq %rcx
; SSE2-NEXT:    retq
;
; F16C-LABEL: fptoui_f16toi64:
; F16C:       # %bb.0:
; F16C-NEXT:    vpextrw $0, %xmm0, %eax
; F16C-NEXT:    movzwl %ax, %eax
; F16C-NEXT:    vmovd %eax, %xmm0
; F16C-NEXT:    vcvtph2ps %xmm0, %xmm0
; F16C-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; F16C-NEXT:    vcomiss %xmm1, %xmm0
; F16C-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; F16C-NEXT:    jb .LBB9_2
; F16C-NEXT:  # %bb.1:
; F16C-NEXT:    vmovaps %xmm1, %xmm2
; F16C-NEXT:  .LBB9_2:
; F16C-NEXT:    vsubss %xmm2, %xmm0, %xmm0
; F16C-NEXT:    vcvttss2si %xmm0, %rcx
; F16C-NEXT:    setae %al
; F16C-NEXT:    movzbl %al, %eax
; F16C-NEXT:    shlq $63, %rax
; F16C-NEXT:    xorq %rcx, %rax
; F16C-NEXT:    retq
;
; AVX512-LABEL: fptoui_f16toi64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpextrw $0, %xmm0, %eax
; AVX512-NEXT:    movzwl %ax, %eax
; AVX512-NEXT:    vmovd %eax, %xmm0
; AVX512-NEXT:    vcvtph2ps %xmm0, %xmm0
; AVX512-NEXT:    vcvttss2usi %xmm0, %rax
; AVX512-NEXT:    retq
;
; X86-LABEL: fptoui_f16toi64:
; X86:       # %bb.0:
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vcvttph2uqq %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    vpextrd $1, %xmm0, %edx
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi64:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2usi %xmm0, %rax
; X64-NEXT:    retq
  %result = call i64 @llvm.experimental.constrained.fptoui.i64.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

attributes #0 = { strictfp nounwind }
