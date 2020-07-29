; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse4.1 | FileCheck %s --check-prefixes=SSE41
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512f | FileCheck %s --check-prefixes=AVX,AVX512

define float @roundeven_f32(float %x) {
; SSE2-LABEL: roundeven_f32:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    jmp _roundevenf ## TAILCALL
;
; SSE41-LABEL: roundeven_f32:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundss $8, %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: roundeven_f32:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundss $8, %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = call float @llvm.roundeven.f32(float %x)
  ret float %a
}

define double @roundeven_f64(double %x) {
; SSE2-LABEL: roundeven_f64:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    jmp _roundeven ## TAILCALL
;
; SSE41-LABEL: roundeven_f64:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundsd $8, %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: roundeven_f64:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundsd $8, %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = call double @llvm.roundeven.f64(double %x)
  ret double %a
}

define <4 x float> @roundeven_v4f32(<4 x float> %x) {
; SSE2-LABEL: roundeven_v4f32:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    subq $56, %rsp
; SSE2-NEXT:    .cfi_def_cfa_offset 64
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    unpcklps (%rsp), %xmm0 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2-NEXT:    unpcklpd (%rsp), %xmm1 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm1 = xmm1[0],mem[0]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    addq $56, %rsp
; SSE2-NEXT:    retq
;
; SSE41-LABEL: roundeven_v4f32:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundps $8, %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: roundeven_v4f32:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundps $8, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = call <4 x float> @llvm.roundeven.v4f32(<4 x float> %x)
  ret <4 x float> %a
}

define <2 x double> @roundeven_v2f64(<2 x double> %x) {
; SSE2-LABEL: roundeven_v2f64:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    subq $40, %rsp
; SSE2-NEXT:    .cfi_def_cfa_offset 48
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    addq $40, %rsp
; SSE2-NEXT:    retq
;
; SSE41-LABEL: roundeven_v2f64:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundpd $8, %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: roundeven_v2f64:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundpd $8, %xmm0, %xmm0
; AVX-NEXT:    retq
  %a = call <2 x double> @llvm.roundeven.v2f64(<2 x double> %x)
  ret <2 x double> %a
}

define <8 x float> @roundeven_v8f32(<8 x float> %x) {
; SSE2-LABEL: roundeven_v8f32:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    subq $72, %rsp
; SSE2-NEXT:    .cfi_def_cfa_offset 80
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    unpcklps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2-NEXT:    unpcklpd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm1 = xmm1[0],mem[0]
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    unpcklps (%rsp), %xmm0 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2-NEXT:    unpcklpd (%rsp), %xmm1 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm1 = xmm1[0],mem[0]
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    addq $72, %rsp
; SSE2-NEXT:    retq
;
; SSE41-LABEL: roundeven_v8f32:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundps $8, %xmm0, %xmm0
; SSE41-NEXT:    roundps $8, %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX-LABEL: roundeven_v8f32:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundps $8, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a = call <8 x float> @llvm.roundeven.v8f32(<8 x float> %x)
  ret <8 x float> %a
}

define <4 x double> @roundeven_v4f64(<4 x double> %x) {
; SSE2-LABEL: roundeven_v4f64:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    subq $56, %rsp
; SSE2-NEXT:    .cfi_def_cfa_offset 64
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps (%rsp), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    addq $56, %rsp
; SSE2-NEXT:    retq
;
; SSE41-LABEL: roundeven_v4f64:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundpd $8, %xmm0, %xmm0
; SSE41-NEXT:    roundpd $8, %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX-LABEL: roundeven_v4f64:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundpd $8, %ymm0, %ymm0
; AVX-NEXT:    retq
  %a = call <4 x double> @llvm.roundeven.v4f64(<4 x double> %x)
  ret <4 x double> %a
}

define <16 x float> @roundeven_v16f32(<16 x float> %x) {
; SSE2-LABEL: roundeven_v16f32:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    subq $104, %rsp
; SSE2-NEXT:    .cfi_def_cfa_offset 112
; SSE2-NEXT:    movaps %xmm3, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm1, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    unpcklps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2-NEXT:    unpcklpd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm1 = xmm1[0],mem[0]
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    unpcklps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2-NEXT:    unpcklpd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm1 = xmm1[0],mem[0]
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    unpcklps (%rsp), %xmm0 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps (%rsp), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2-NEXT:    unpcklpd {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm1 = xmm1[0],mem[0]
; SSE2-NEXT:    movaps %xmm1, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,3,3,3]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    unpcklps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; SSE2-NEXT:    callq _roundevenf
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm3 ## 16-byte Reload
; SSE2-NEXT:    unpcklps {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1]
; SSE2-NEXT:    unpcklpd {{[-0-9]+}}(%r{{[sb]}}p), %xmm3 ## 16-byte Folded Reload
; SSE2-NEXT:    ## xmm3 = xmm3[0],mem[0]
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movaps (%rsp), %xmm2 ## 16-byte Reload
; SSE2-NEXT:    addq $104, %rsp
; SSE2-NEXT:    retq
;
; SSE41-LABEL: roundeven_v16f32:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundps $8, %xmm0, %xmm0
; SSE41-NEXT:    roundps $8, %xmm1, %xmm1
; SSE41-NEXT:    roundps $8, %xmm2, %xmm2
; SSE41-NEXT:    roundps $8, %xmm3, %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: roundeven_v16f32:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vroundps $8, %ymm0, %ymm0
; AVX1-NEXT:    vroundps $8, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX512-LABEL: roundeven_v16f32:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vrndscaleps $8, %zmm0, %zmm0
; AVX512-NEXT:    retq
  %a = call <16 x float> @llvm.roundeven.v16f32(<16 x float> %x)
  ret <16 x float> %a
}

define <8 x double> @roundeven_v8f64(<8 x double> %x) {
; SSE2-LABEL: roundeven_v8f64:
; SSE2:       ## %bb.0:
; SSE2-NEXT:    subq $88, %rsp
; SSE2-NEXT:    .cfi_def_cfa_offset 96
; SSE2-NEXT:    movaps %xmm3, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm1, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps (%rsp), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps %xmm0, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps (%rsp), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE2-NEXT:    movaps %xmm1, (%rsp) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) ## 16-byte Spill
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; SSE2-NEXT:    callq _roundeven
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm3 ## 16-byte Reload
; SSE2-NEXT:    movlhps {{.*#+}} xmm3 = xmm3[0],xmm0[0]
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 ## 16-byte Reload
; SSE2-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 ## 16-byte Reload
; SSE2-NEXT:    movaps (%rsp), %xmm2 ## 16-byte Reload
; SSE2-NEXT:    addq $88, %rsp
; SSE2-NEXT:    retq
;
; SSE41-LABEL: roundeven_v8f64:
; SSE41:       ## %bb.0:
; SSE41-NEXT:    roundpd $8, %xmm0, %xmm0
; SSE41-NEXT:    roundpd $8, %xmm1, %xmm1
; SSE41-NEXT:    roundpd $8, %xmm2, %xmm2
; SSE41-NEXT:    roundpd $8, %xmm3, %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: roundeven_v8f64:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vroundpd $8, %ymm0, %ymm0
; AVX1-NEXT:    vroundpd $8, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX512-LABEL: roundeven_v8f64:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vrndscalepd $8, %zmm0, %zmm0
; AVX512-NEXT:    retq
  %a = call <8 x double> @llvm.roundeven.v8f64(<8 x double> %x)
  ret <8 x double> %a
}

declare float @llvm.roundeven.f32(float)
declare double @llvm.roundeven.f64(double)
declare <4 x float> @llvm.roundeven.v4f32(<4 x float>)
declare <2 x double> @llvm.roundeven.v2f64(<2 x double>)
declare <8 x float> @llvm.roundeven.v8f32(<8 x float>)
declare <4 x double> @llvm.roundeven.v4f64(<4 x double>)
declare <16 x float> @llvm.roundeven.v16f32(<16 x float>)
declare <8 x double> @llvm.roundeven.v8f64(<8 x double>)
