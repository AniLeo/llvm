; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl | FileCheck %s --check-prefixes=CHECK,X64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl | FileCheck %s --check-prefixes=CHECK,X86

define half @f32tof16(float %b) nounwind {
; X64-LABEL: f32tof16:
; X64:       # %bb.0:
; X64-NEXT:    vcvtss2sh %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: f32tof16:
; X86:       # %bb.0:
; X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    vcvtss2sh %xmm0, %xmm0, %xmm0
; X86-NEXT:    retl
  %a = fptrunc float %b to half
  ret half %a
}

define half @f64tof16(double %b) nounwind {
; X64-LABEL: f64tof16:
; X64:       # %bb.0:
; X64-NEXT:    vcvtsd2sh %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: f64tof16:
; X86:       # %bb.0:
; X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    vcvtsd2sh %xmm0, %xmm0, %xmm0
; X86-NEXT:    retl
  %a = fptrunc double %b to half
  ret half %a
}

define <16 x half> @f32to16f16(<16 x float> %b) nounwind {
; CHECK-LABEL: f32to16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtps2phx %zmm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <16 x float> %b to <16 x half>
  ret <16 x half> %a
}

define <8 x half> @f32to8f16(<8 x float> %b) {
; CHECK-LABEL: f32to8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtps2phx %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <8 x float> %b to <8 x half>
  ret <8 x half> %a
}

define <4 x half> @f32to4f16(<4 x float> %b) {
; CHECK-LABEL: f32to4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtps2phx %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <4 x float> %b to <4 x half>
  ret <4 x half> %a
}

define <2 x half> @f32to2f16(<2 x float> %b) {
; CHECK-LABEL: f32to2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtps2phx %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <2 x float> %b to <2 x half>
  ret <2 x half> %a
}

declare <8 x half> @llvm.x86.avx512fp16.mask.vcvtps2phx.128(<4 x float>, <8 x half>, i8)
declare <8 x half> @llvm.x86.avx512fp16.mask.vcvtps2phx.256(<8 x float>, <8 x half>, i8)

define <8 x half> @f32to4f16_mask(<4 x float> %a, <8 x half> %b, i8 %mask) {
; X64-LABEL: f32to4f16_mask:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vcvtps2phx %xmm0, %xmm1 {%k1}
; X64-NEXT:    vmovaps %xmm1, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: f32to4f16_mask:
; X86:       # %bb.0:
; X86-NEXT:    kmovb {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vcvtps2phx %xmm0, %xmm1 {%k1}
; X86-NEXT:    vmovaps %xmm1, %xmm0
; X86-NEXT:    retl
  %res = call <8 x half> @llvm.x86.avx512fp16.mask.vcvtps2phx.128(<4 x float> %a, <8 x half> %b, i8 %mask)
  ret <8 x half> %res
}

define <8 x half> @f32to8f16_mask(<8 x float> %a, <8 x half> %b, i8 %mask) {
; X64-LABEL: f32to8f16_mask:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vcvtps2phx %ymm0, %xmm1 {%k1}
; X64-NEXT:    vmovaps %xmm1, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: f32to8f16_mask:
; X86:       # %bb.0:
; X86-NEXT:    kmovb {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vcvtps2phx %ymm0, %xmm1 {%k1}
; X86-NEXT:    vmovaps %xmm1, %xmm0
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %res = call <8 x half> @llvm.x86.avx512fp16.mask.vcvtps2phx.256(<8 x float> %a, <8 x half> %b, i8 %mask)
  ret <8 x half> %res
}

define <8 x half> @f32to8f16_mask2(<8 x float> %b, <8 x i1> %mask) {
; CHECK-LABEL: f32to8f16_mask2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllw $15, %xmm1, %xmm1
; CHECK-NEXT:    vpmovw2m %xmm1, %k1
; CHECK-NEXT:    vcvtps2phx %ymm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <8 x float> %b to <8 x half>
  %c = select <8 x i1>%mask, <8 x half>%a, <8 x half> zeroinitializer
  ret <8 x half> %c
}

define <16 x half> @f32to16f16_mask(<16 x float> %b, <16 x i1> %mask) {
; CHECK-LABEL: f32to16f16_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllw $7, %xmm1, %xmm1
; CHECK-NEXT:    vpmovb2m %xmm1, %k1
; CHECK-NEXT:    vcvtps2phx %zmm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <16 x float> %b to <16 x half>
  %c = select <16 x i1>%mask, <16 x half>%a, <16 x half> zeroinitializer
  ret <16 x half> %c
}

define float @f16tof32(half %b) nounwind {
; X64-LABEL: f16tof32:
; X64:       # %bb.0:
; X64-NEXT:    vcvtsh2ss %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: f16tof32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vcvtsh2ss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %a = fpext half %b to float
  ret float %a
}

define double @f16tof64(half %b) nounwind {
; X64-LABEL: f16tof64:
; X64:       # %bb.0:
; X64-NEXT:    vcvtsh2sd %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: f16tof64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vmovsh 8(%ebp), %xmm0
; X86-NEXT:    vcvtsh2sd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %a = fpext half %b to double
  ret double %a
}

define <16 x float> @f16to16f32(<16 x half> %b) nounwind {
; CHECK-LABEL: f16to16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2psx %ymm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <16 x half> %b to <16 x float>
  ret <16 x float> %a
}

define <8 x float> @f16to8f32(<8 x half> %b) nounwind {
; CHECK-LABEL: f16to8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2psx %xmm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <8 x half> %b to <8 x float>
  ret <8 x float> %a
}

define <4 x float> @f16to4f32(<4 x half> %b) nounwind {
; CHECK-LABEL: f16to4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2psx %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <4 x half> %b to <4 x float>
  ret <4 x float> %a
}

define <2 x float> @f16to2f32(<2 x half> %b) nounwind {
; CHECK-LABEL: f16to2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2psx %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <2 x half> %b to <2 x float>
  ret <2 x float> %a
}

define <16 x float> @f16to16f32_mask(<16 x half> %b, <16 x float> %b1, <16 x float> %a1) {
; CHECK-LABEL: f16to16f32_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcmpltps %zmm2, %zmm1, %k1
; CHECK-NEXT:    vcvtph2psx %ymm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <16 x half> %b to <16 x float>
  %mask = fcmp ogt <16 x float> %a1, %b1
  %c = select <16 x i1> %mask, <16 x float> %a, <16 x float> zeroinitializer
  ret <16 x float> %c
}

define <8 x float> @f16to8f32_mask(<8 x half> %b, <8 x float> %b1, <8 x float> %a1) {
; CHECK-LABEL: f16to8f32_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcmpltps %ymm2, %ymm1, %k1
; CHECK-NEXT:    vcvtph2psx %xmm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <8 x half> %b to <8 x float>
  %mask = fcmp ogt <8 x float> %a1, %b1
  %c = select <8 x i1> %mask, <8 x float> %a, <8 x float> zeroinitializer
  ret <8 x float> %c
}

define <4 x float> @f16to4f32_mask(<4 x half> %b, <4 x float> %b1, <4 x float> %a1) {
; CHECK-LABEL: f16to4f32_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcmpltps %xmm2, %xmm1, %k1
; CHECK-NEXT:    vcvtph2psx %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <4 x half> %b to <4 x float>
  %mask = fcmp ogt <4 x float> %a1, %b1
  %c = select <4 x i1> %mask, <4 x float> %a, <4 x float> zeroinitializer
  ret <4 x float> %c
}

define <2 x float> @f16to2f32_mask(<2 x half> %b, <2 x float> %b1, <2 x float> %a1) {
; CHECK-LABEL: f16to2f32_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcmpltps %xmm2, %xmm1, %k1
; CHECK-NEXT:    vcvtph2psx %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <2 x half> %b to <2 x float>
  %mask = fcmp ogt <2 x float> %a1, %b1
  %c = select <2 x i1> %mask, <2 x float> %a, <2 x float> zeroinitializer
  ret <2 x float> %c
}

define <2 x double> @f16to2f64(<2 x half> %b) nounwind {
; CHECK-LABEL: f16to2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2pd %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <2 x half> %b to <2 x double>
  ret <2 x double> %a
}

define <2 x double> @f16to2f64_mask(<2 x half> %b, <2 x double> %b1, <2 x double> %a1) {
; CHECK-LABEL: f16to2f64_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcmpltpd %xmm2, %xmm1, %k1
; CHECK-NEXT:    vcvtph2pd %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <2 x half> %b to <2 x double>
  %mask = fcmp ogt <2 x double> %a1, %b1
  %c = select <2 x i1> %mask, <2 x double> %a, <2 x double> zeroinitializer
  ret <2 x double> %c
}

define <4 x double> @f16to4f64(<4 x half> %b) nounwind {
; CHECK-LABEL: f16to4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2pd %xmm0, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <4 x half> %b to <4 x double>
  ret <4 x double> %a
}

define <4 x double> @f16to4f64_mask(<4 x half> %b, <4 x double> %b1, <4 x double> %a1) {
; CHECK-LABEL: f16to4f64_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcmpltpd %ymm2, %ymm1, %k1
; CHECK-NEXT:    vcvtph2pd %xmm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <4 x half> %b to <4 x double>
  %mask = fcmp ogt <4 x double> %a1, %b1
  %c = select <4 x i1> %mask, <4 x double> %a, <4 x double> zeroinitializer
  ret <4 x double> %c
}

define <8 x double> @f16to8f64(<8 x half> %b) nounwind {
; CHECK-LABEL: f16to8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2pd %xmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <8 x half> %b to <8 x double>
  ret <8 x double> %a
}

define <8 x double> @f16to8f64_mask(<8 x half> %b, <8 x double> %b1, <8 x double> %a1) {
; CHECK-LABEL: f16to8f64_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcmpltpd %zmm2, %zmm1, %k1
; CHECK-NEXT:    vcvtph2pd %xmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fpext <8 x half> %b to <8 x double>
  %mask = fcmp ogt <8 x double> %a1, %b1
  %c = select <8 x i1> %mask, <8 x double> %a, <8 x double> zeroinitializer
  ret <8 x double> %c
}

define <2 x half> @f64to2f16(<2 x double> %b) {
; CHECK-LABEL: f64to2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtpd2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <2 x double> %b to <2 x half>
  ret <2 x half> %a
}

define <4 x half> @f64to4f16(<4 x double> %b) {
; CHECK-LABEL: f64to4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtpd2ph %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <4 x double> %b to <4 x half>
  ret <4 x half> %a
}

define <8 x half> @f64to8f16(<8 x double> %b) {
; CHECK-LABEL: f64to8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtpd2ph %zmm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %a = fptrunc <8 x double> %b to <8 x half>
  ret <8 x half> %a
}

define float @extload_f16_f32(half* %x) {
; X64-LABEL: extload_f16_f32:
; X64:       # %bb.0:
; X64-NEXT:    vmovsh (%rdi), %xmm0
; X64-NEXT:    vcvtsh2ss %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_f16_f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovsh (%eax), %xmm0
; X86-NEXT:    vcvtsh2ss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
  %a = load half, half* %x
  %b = fpext half %a to float
  ret float %b
}

define double @extload_f16_f64(half* %x) {
; X64-LABEL: extload_f16_f64:
; X64:       # %bb.0:
; X64-NEXT:    vmovsh (%rdi), %xmm0
; X64-NEXT:    vcvtsh2sd %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_f16_f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    movl 8(%ebp), %eax
; X86-NEXT:    vmovsh (%eax), %xmm0
; X86-NEXT:    vcvtsh2sd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
  %a = load half, half* %x
  %b = fpext half %a to double
  ret double %b
}

define float @extload_f16_f32_optsize(half* %x) optsize {
; X64-LABEL: extload_f16_f32_optsize:
; X64:       # %bb.0:
; X64-NEXT:    vcvtsh2ss (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_f16_f32_optsize:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtsh2ss (%eax), %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
  %a = load half, half* %x
  %b = fpext half %a to float
  ret float %b
}

define double @extload_f16_f64_optsize(half* %x) optsize {
; X64-LABEL: extload_f16_f64_optsize:
; X64:       # %bb.0:
; X64-NEXT:    vcvtsh2sd (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_f16_f64_optsize:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    movl 8(%ebp), %eax
; X86-NEXT:    vcvtsh2sd (%eax), %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
  %a = load half, half* %x
  %b = fpext half %a to double
  ret double %b
}

define <16 x float> @extload_v16f16_v16f32(<16 x half>* %x) {
; X64-LABEL: extload_v16f16_v16f32:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2psx (%rdi), %zmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_v16f16_v16f32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtph2psx (%eax), %zmm0
; X86-NEXT:    retl
  %a = load <16 x half>, <16 x half>* %x
  %b = fpext <16 x half> %a to <16 x float>
  ret <16 x float> %b
}

define <8 x float> @extload_v8f16_v8f32(<8 x half>* %x) {
; X64-LABEL: extload_v8f16_v8f32:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2psx (%rdi), %ymm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_v8f16_v8f32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtph2psx (%eax), %ymm0
; X86-NEXT:    retl
  %a = load <8 x half>, <8 x half>* %x
  %b = fpext <8 x half> %a to <8 x float>
  ret <8 x float> %b
}

define <4 x float> @extload_v4f16_v4f32(<4 x half>* %x) {
; X64-LABEL: extload_v4f16_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2psx (%rdi), %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_v4f16_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtph2psx (%eax), %xmm0
; X86-NEXT:    retl
  %a = load <4 x half>, <4 x half>* %x
  %b = fpext <4 x half> %a to <4 x float>
  ret <4 x float> %b
}

define <8 x double> @extload_v8f16_v8f64(<8 x half>* %x) {
; X64-LABEL: extload_v8f16_v8f64:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2pd (%rdi), %zmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_v8f16_v8f64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtph2pd (%eax), %zmm0
; X86-NEXT:    retl
  %a = load <8 x half>, <8 x half>* %x
  %b = fpext <8 x half> %a to <8 x double>
  ret <8 x double> %b
}

define <4 x double> @extload_v4f16_v4f64(<4 x half>* %x) {
; X64-LABEL: extload_v4f16_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2pd (%rdi), %ymm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_v4f16_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtph2pd (%eax), %ymm0
; X86-NEXT:    retl
  %a = load <4 x half>, <4 x half>* %x
  %b = fpext <4 x half> %a to <4 x double>
  ret <4 x double> %b
}

define <2 x double> @extload_v2f16_v2f64(<2 x half>* %x) {
; X64-LABEL: extload_v2f16_v2f64:
; X64:       # %bb.0:
; X64-NEXT:    vcvtph2pd (%rdi), %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: extload_v2f16_v2f64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtph2pd (%eax), %xmm0
; X86-NEXT:    retl
  %a = load <2 x half>, <2 x half>* %x
  %b = fpext <2 x half> %a to <2 x double>
  ret <2 x double> %b
}

define half @s8_to_half(i8 %x) {
; X64-LABEL: s8_to_half:
; X64:       # %bb.0:
; X64-NEXT:    movsbl %dil, %eax
; X64-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: s8_to_half:
; X86:       # %bb.0:
; X86-NEXT:    movsbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X86-NEXT:    retl
  %a = sitofp i8 %x to half
  ret half %a
}

define half @s16_to_half(i16 %x) {
; X64-LABEL: s16_to_half:
; X64:       # %bb.0:
; X64-NEXT:    movswl %di, %eax
; X64-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: s16_to_half:
; X86:       # %bb.0:
; X86-NEXT:    movswl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X86-NEXT:    retl
  %a = sitofp i16 %x to half
  ret half %a
}

define half @s32_to_half(i32 %x) {
; X64-LABEL: s32_to_half:
; X64:       # %bb.0:
; X64-NEXT:    vcvtsi2sh %edi, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: s32_to_half:
; X86:       # %bb.0:
; X86-NEXT:    vcvtsi2shl {{[0-9]+}}(%esp), %xmm0, %xmm0
; X86-NEXT:    retl
  %a = sitofp i32 %x to half
  ret half %a
}

define half @s64_to_half(i64 %x) {
; X64-LABEL: s64_to_half:
; X64:       # %bb.0:
; X64-NEXT:    vcvtsi2sh %rdi, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: s64_to_half:
; X86:       # %bb.0:
; X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    vcvtqq2ph %xmm0, %xmm0
; X86-NEXT:    retl
  %a = sitofp i64 %x to half
  ret half %a
}

define half @s128_to_half(i128 %x) {
; X64-LABEL: s128_to_half:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    .cfi_def_cfa_offset 16
; X64-NEXT:    callq __floattihf@PLT
; X64-NEXT:    popq %rax
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
;
; X86-LABEL: s128_to_half:
; X86:       # %bb.0:
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    .cfi_def_cfa_offset 20
; X86-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vmovups %xmm0, (%esp)
; X86-NEXT:    calll __floattihf
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
  %a = sitofp i128 %x to half
  ret half %a
}

define half @u8_to_half(i8 %x) {
; X64-LABEL: u8_to_half:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: u8_to_half:
; X86:       # %bb.0:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X86-NEXT:    retl
  %a = uitofp i8 %x to half
  ret half %a
}

define half @u16_to_half(i16 %x) {
; X64-LABEL: u16_to_half:
; X64:       # %bb.0:
; X64-NEXT:    movzwl %di, %eax
; X64-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: u16_to_half:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vcvtsi2sh %eax, %xmm0, %xmm0
; X86-NEXT:    retl
  %a = uitofp i16 %x to half
  ret half %a
}

define half @u32_to_half(i32 %x) {
; X64-LABEL: u32_to_half:
; X64:       # %bb.0:
; X64-NEXT:    vcvtusi2sh %edi, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: u32_to_half:
; X86:       # %bb.0:
; X86-NEXT:    vcvtusi2shl {{[0-9]+}}(%esp), %xmm0, %xmm0
; X86-NEXT:    retl
  %a = uitofp i32 %x to half
  ret half %a
}

define half @u64_to_half(i64 %x) {
; X64-LABEL: u64_to_half:
; X64:       # %bb.0:
; X64-NEXT:    vcvtusi2sh %rdi, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: u64_to_half:
; X86:       # %bb.0:
; X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    vcvtuqq2ph %xmm0, %xmm0
; X86-NEXT:    retl
  %a = uitofp i64 %x to half
  ret half %a
}

define half @u128_to_half(i128 %x) {
; X64-LABEL: u128_to_half:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    .cfi_def_cfa_offset 16
; X64-NEXT:    callq __floatuntihf@PLT
; X64-NEXT:    popq %rax
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
;
; X86-LABEL: u128_to_half:
; X86:       # %bb.0:
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    .cfi_def_cfa_offset 20
; X86-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vmovups %xmm0, (%esp)
; X86-NEXT:    calll __floatuntihf
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
  %a = uitofp i128 %x to half
  ret half %a
}

define i8 @half_to_s8(half %x) {
; X64-LABEL: half_to_s8:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_s8:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
  %a = fptosi half %x to i8
  ret i8 %a
}

define i16 @half_to_s16(half %x) {
; X64-LABEL: half_to_s16:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_s16:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
  %a = fptosi half %x to i16
  ret i16 %a
}

define i32 @half_to_s32(half %x) {
; X64-LABEL: half_to_s32:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_s32:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
  %a = fptosi half %x to i32
  ret i32 %a
}

define i64 @half_to_s64(half %x) {
; X64-LABEL: half_to_s64:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %rax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_s64:
; X86:       # %bb.0:
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vcvttph2qq %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    vpextrd $1, %xmm0, %edx
; X86-NEXT:    retl
  %a = fptosi half %x to i64
  ret i64 %a
}

define i128 @half_to_s128(half %x) {
; X64-LABEL: half_to_s128:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    .cfi_def_cfa_offset 16
; X64-NEXT:    callq __fixhfti@PLT
; X64-NEXT:    popq %rcx
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
;
; X86-LABEL: half_to_s128:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $32, %esp
; X86-NEXT:    .cfi_offset %esi, -12
; X86-NEXT:    movl 8(%ebp), %esi
; X86-NEXT:    vmovsh 12(%ebp), %xmm0
; X86-NEXT:    vmovsh %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    calll __fixhfti
; X86-NEXT:    subl $4, %esp
; X86-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vmovups %xmm0, (%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    leal -4(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl $4
  %a = fptosi half %x to i128
  ret i128 %a
}

define i8 @half_to_u8(half %x) {
; X64-LABEL: half_to_u8:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_u8:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
  %a = fptoui half %x to i8
  ret i8 %a
}

define i16 @half_to_u16(half %x) {
; X64-LABEL: half_to_u16:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_u16:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
  %a = fptoui half %x to i16
  ret i16 %a
}

define i32 @half_to_u32(half %x) {
; X64-LABEL: half_to_u32:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2usi %xmm0, %eax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_u32:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2usi {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
  %a = fptoui half %x to i32
  ret i32 %a
}

define i64 @half_to_u64(half %x) {
; X64-LABEL: half_to_u64:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2usi %xmm0, %rax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_u64:
; X86:       # %bb.0:
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vcvttph2uqq %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    vpextrd $1, %xmm0, %edx
; X86-NEXT:    retl
  %a = fptoui half %x to i64
  ret i64 %a
}

define i128 @half_to_u128(half %x) {
; X64-LABEL: half_to_u128:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    .cfi_def_cfa_offset 16
; X64-NEXT:    callq __fixunshfti@PLT
; X64-NEXT:    popq %rcx
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
;
; X86-LABEL: half_to_u128:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $32, %esp
; X86-NEXT:    .cfi_offset %esi, -12
; X86-NEXT:    movl 8(%ebp), %esi
; X86-NEXT:    vmovsh 12(%ebp), %xmm0
; X86-NEXT:    vmovsh %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    calll __fixunshfti
; X86-NEXT:    subl $4, %esp
; X86-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vmovups %xmm0, (%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    leal -4(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl $4
  %a = fptoui half %x to i128
  ret i128 %a
}

define x86_fp80 @half_to_f80(half %x) nounwind {
; X64-LABEL: half_to_f80:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    callq __extendhfxf2@PLT
; X64-NEXT:    popq %rax
; X64-NEXT:    retq
;
; X86-LABEL: half_to_f80:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vmovsh %xmm0, (%esp)
; X86-NEXT:    calll __extendhfxf2
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %a = fpext half %x to x86_fp80
  ret x86_fp80 %a
}

define half @f80_to_half(x86_fp80 %x) nounwind {
; X64-LABEL: f80_to_half:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-NEXT:    fstpt (%rsp)
; X64-NEXT:    callq __truncxfhf2@PLT
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    retq
;
; X86-LABEL: f80_to_half:
; X86:       # %bb.0:
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-NEXT:    fstpt (%esp)
; X86-NEXT:    calll __truncxfhf2
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %a = fptrunc x86_fp80 %x to half
  ret half %a
}

; FIXME: We're doing a two step conversion here on 32-bit.
; First from f16->f32 then f32->f128. This is occuring
; due to common code in LegalizeFloatTypes that thinks
; there are no libcalls for f16 to any type but f32.
; Changing this may break other non-x86 targets. The code
; generated here should be functional.
define fp128 @half_to_f128(half %x) nounwind {
; X64-LABEL: half_to_f128:
; X64:       # %bb.0:
; X64-NEXT:    jmp __extendhftf2@PLT # TAILCALL
;
; X86-LABEL: half_to_f128:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $32, %esp
; X86-NEXT:    movl 8(%ebp), %esi
; X86-NEXT:    vmovsh 12(%ebp), %xmm0
; X86-NEXT:    vcvtsh2ss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, (%esp)
; X86-NEXT:    calll __extendsftf2
; X86-NEXT:    subl $4, %esp
; X86-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vmovaps %xmm0, (%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    leal -4(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
  %a = fpext half %x to fp128
  ret fp128 %a
}

define half @f128_to_half(fp128 %x) nounwind {
; X64-LABEL: f128_to_half:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    callq __trunctfhf2@PLT
; X64-NEXT:    popq %rax
; X64-NEXT:    retq
;
; X86-LABEL: f128_to_half:
; X86:       # %bb.0:
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vmovups %xmm0, (%esp)
; X86-NEXT:    calll __trunctfhf2
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
  %a = fptrunc fp128 %x to half
  ret half %a
}
