; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=sse2    | FileCheck %s --check-prefixes=SSE2
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx     | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx512f | FileCheck %s --check-prefixes=AVX,AVX512

define i1 @olt_ole_and_f32(float %w, float %x, float %y, float %z) {
; SSE2-LABEL: olt_ole_and_f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomiss %xmm0, %xmm1
; SSE2-NEXT:    seta %cl
; SSE2-NEXT:    ucomiss %xmm2, %xmm3
; SSE2-NEXT:    setae %al
; SSE2-NEXT:    andb %cl, %al
; SSE2-NEXT:    retq
;
; AVX1-LABEL: olt_ole_and_f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpleps %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vcmpltps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    retq
;
; AVX512-LABEL: olt_ole_and_f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm3 killed $xmm3 def $zmm3
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $zmm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512-NEXT:    vcmpltps %zmm1, %zmm0, %k1
; AVX512-NEXT:    vcmpleps %zmm3, %zmm2, %k0 {%k1}
; AVX512-NEXT:    kmovw %k0, %eax
; AVX512-NEXT:    # kill: def $al killed $al killed $eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %f1 = fcmp olt float %w, %x
  %f2 = fcmp ole float %y, %z
  %r = and i1 %f1, %f2
  ret i1 %r
}

define i1 @oge_oeq_or_f32(float %w, float %x, float %y, float %z) {
; SSE2-LABEL: oge_oeq_or_f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomiss %xmm1, %xmm0
; SSE2-NEXT:    setae %cl
; SSE2-NEXT:    ucomiss %xmm3, %xmm2
; SSE2-NEXT:    setnp %dl
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    andb %dl, %al
; SSE2-NEXT:    orb %cl, %al
; SSE2-NEXT:    retq
;
; AVX1-LABEL: oge_oeq_or_f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpeqps %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vcmpleps %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vorps %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    retq
;
; AVX512-LABEL: oge_oeq_or_f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm3 killed $xmm3 def $zmm3
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $zmm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512-NEXT:    vcmpeqps %zmm3, %zmm2, %k0
; AVX512-NEXT:    vcmpleps %zmm0, %zmm1, %k1
; AVX512-NEXT:    korw %k0, %k1, %k0
; AVX512-NEXT:    kmovw %k0, %eax
; AVX512-NEXT:    # kill: def $al killed $al killed $eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %f1 = fcmp oge float %w, %x
  %f2 = fcmp oeq float %y, %z
  %r = or i1 %f1, %f2
  ret i1 %r
}

define i1 @ord_one_xor_f32(float %w, float %x, float %y, float %z) {
; SSE2-LABEL: ord_one_xor_f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomiss %xmm1, %xmm0
; SSE2-NEXT:    setnp %cl
; SSE2-NEXT:    ucomiss %xmm3, %xmm2
; SSE2-NEXT:    setne %al
; SSE2-NEXT:    xorb %cl, %al
; SSE2-NEXT:    retq
;
; AVX1-LABEL: ord_one_xor_f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpneq_oqps %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vcmpordps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vxorps %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    retq
;
; AVX512-LABEL: ord_one_xor_f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm3 killed $xmm3 def $zmm3
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $zmm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512-NEXT:    vcmpneq_oqps %zmm3, %zmm2, %k0
; AVX512-NEXT:    vcmpordps %zmm1, %zmm0, %k1
; AVX512-NEXT:    kxorw %k0, %k1, %k0
; AVX512-NEXT:    kmovw %k0, %eax
; AVX512-NEXT:    # kill: def $al killed $al killed $eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %f1 = fcmp ord float %w, %x
  %f2 = fcmp one float %y, %z
  %r = xor i1 %f1, %f2
  ret i1 %r
}

define i1 @une_ugt_and_f64(double %w, double %x, double %y, double %z) {
; SSE2-LABEL: une_ugt_and_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomisd %xmm1, %xmm0
; SSE2-NEXT:    setp %al
; SSE2-NEXT:    setne %cl
; SSE2-NEXT:    orb %al, %cl
; SSE2-NEXT:    ucomisd %xmm2, %xmm3
; SSE2-NEXT:    setb %al
; SSE2-NEXT:    andb %cl, %al
; SSE2-NEXT:    retq
;
; AVX1-LABEL: une_ugt_and_f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpnlepd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vcmpneqpd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vandpd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    retq
;
; AVX512-LABEL: une_ugt_and_f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm3 killed $xmm3 def $zmm3
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $zmm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512-NEXT:    vcmpneqpd %zmm1, %zmm0, %k1
; AVX512-NEXT:    vcmpnlepd %zmm3, %zmm2, %k0 {%k1}
; AVX512-NEXT:    kmovw %k0, %eax
; AVX512-NEXT:    # kill: def $al killed $al killed $eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %f1 = fcmp une double %w, %x
  %f2 = fcmp ugt double %y, %z
  %r = and i1 %f1, %f2
  ret i1 %r
}

define i1 @ult_uge_or_f64(double %w, double %x, double %y, double %z) {
; SSE2-LABEL: ult_uge_or_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomisd %xmm1, %xmm0
; SSE2-NEXT:    setb %cl
; SSE2-NEXT:    ucomisd %xmm2, %xmm3
; SSE2-NEXT:    setbe %al
; SSE2-NEXT:    orb %cl, %al
; SSE2-NEXT:    retq
;
; AVX1-LABEL: ult_uge_or_f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpnltpd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vcmpnlepd %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vorpd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    retq
;
; AVX512-LABEL: ult_uge_or_f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm3 killed $xmm3 def $zmm3
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $zmm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512-NEXT:    vcmpnltpd %zmm3, %zmm2, %k0
; AVX512-NEXT:    vcmpnlepd %zmm0, %zmm1, %k1
; AVX512-NEXT:    korw %k0, %k1, %k0
; AVX512-NEXT:    kmovw %k0, %eax
; AVX512-NEXT:    # kill: def $al killed $al killed $eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %f1 = fcmp ult double %w, %x
  %f2 = fcmp uge double %y, %z
  %r = or i1 %f1, %f2
  ret i1 %r
}

define i1 @une_uno_xor_f64(double %w, double %x, double %y, double %z) {
; SSE2-LABEL: une_uno_xor_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomisd %xmm1, %xmm0
; SSE2-NEXT:    setp %al
; SSE2-NEXT:    setne %cl
; SSE2-NEXT:    orb %al, %cl
; SSE2-NEXT:    ucomisd %xmm3, %xmm2
; SSE2-NEXT:    setp %al
; SSE2-NEXT:    xorb %cl, %al
; SSE2-NEXT:    retq
;
; AVX1-LABEL: une_uno_xor_f64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vcmpunordpd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vcmpneqpd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vxorpd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    retq
;
; AVX512-LABEL: une_uno_xor_f64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    # kill: def $xmm3 killed $xmm3 def $zmm3
; AVX512-NEXT:    # kill: def $xmm2 killed $xmm2 def $zmm2
; AVX512-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512-NEXT:    vcmpunordpd %zmm3, %zmm2, %k0
; AVX512-NEXT:    vcmpneqpd %zmm1, %zmm0, %k1
; AVX512-NEXT:    kxorw %k0, %k1, %k0
; AVX512-NEXT:    kmovw %k0, %eax
; AVX512-NEXT:    # kill: def $al killed $al killed $eax
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %f1 = fcmp une double %w, %x
  %f2 = fcmp uno double %y, %z
  %r = xor i1 %f1, %f2
  ret i1 %r
}

; This uses ucomis because the types do not match.
; TODO: Merge down to narrow type?

define i1 @olt_olt_and_f32_f64(float %w, float %x, double %y, double %z) {
; SSE2-LABEL: olt_olt_and_f32_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomiss %xmm0, %xmm1
; SSE2-NEXT:    seta %cl
; SSE2-NEXT:    ucomisd %xmm2, %xmm3
; SSE2-NEXT:    seta %al
; SSE2-NEXT:    andb %cl, %al
; SSE2-NEXT:    retq
;
; AVX-LABEL: olt_olt_and_f32_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vucomiss %xmm0, %xmm1
; AVX-NEXT:    seta %cl
; AVX-NEXT:    vucomisd %xmm2, %xmm3
; AVX-NEXT:    seta %al
; AVX-NEXT:    andb %cl, %al
; AVX-NEXT:    retq
  %f1 = fcmp olt float %w, %x
  %f2 = fcmp olt double %y, %z
  %r = and i1 %f1, %f2
  ret i1 %r
}

; This uses ucomis because of extra uses.

define i1 @une_uno_xor_f64_use1(double %w, double %x, double %y, double %z, i1* %p) {
; SSE2-LABEL: une_uno_xor_f64_use1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomisd %xmm1, %xmm0
; SSE2-NEXT:    setp %al
; SSE2-NEXT:    setne %cl
; SSE2-NEXT:    orb %al, %cl
; SSE2-NEXT:    movb %cl, (%rdi)
; SSE2-NEXT:    ucomisd %xmm3, %xmm2
; SSE2-NEXT:    setp %al
; SSE2-NEXT:    xorb %cl, %al
; SSE2-NEXT:    retq
;
; AVX-LABEL: une_uno_xor_f64_use1:
; AVX:       # %bb.0:
; AVX-NEXT:    vucomisd %xmm1, %xmm0
; AVX-NEXT:    setp %al
; AVX-NEXT:    setne %cl
; AVX-NEXT:    orb %al, %cl
; AVX-NEXT:    movb %cl, (%rdi)
; AVX-NEXT:    vucomisd %xmm3, %xmm2
; AVX-NEXT:    setp %al
; AVX-NEXT:    xorb %cl, %al
; AVX-NEXT:    retq
  %f1 = fcmp une double %w, %x
  store i1 %f1, i1* %p
  %f2 = fcmp uno double %y, %z
  %r = xor i1 %f1, %f2
  ret i1 %r
}

; This uses ucomis because of extra uses.

define i1 @une_uno_xor_f64_use2(double %w, double %x, double %y, double %z, i1* %p) {
; SSE2-LABEL: une_uno_xor_f64_use2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    ucomisd %xmm1, %xmm0
; SSE2-NEXT:    setp %al
; SSE2-NEXT:    setne %cl
; SSE2-NEXT:    orb %al, %cl
; SSE2-NEXT:    ucomisd %xmm3, %xmm2
; SSE2-NEXT:    setp %al
; SSE2-NEXT:    setp (%rdi)
; SSE2-NEXT:    xorb %cl, %al
; SSE2-NEXT:    retq
;
; AVX-LABEL: une_uno_xor_f64_use2:
; AVX:       # %bb.0:
; AVX-NEXT:    vucomisd %xmm1, %xmm0
; AVX-NEXT:    setp %al
; AVX-NEXT:    setne %cl
; AVX-NEXT:    orb %al, %cl
; AVX-NEXT:    vucomisd %xmm3, %xmm2
; AVX-NEXT:    setp %al
; AVX-NEXT:    setp (%rdi)
; AVX-NEXT:    xorb %cl, %al
; AVX-NEXT:    retq
  %f1 = fcmp une double %w, %x
  %f2 = fcmp uno double %y, %z
  store i1 %f2, i1* %p
  %r = xor i1 %f1, %f2
  ret i1 %r
}
