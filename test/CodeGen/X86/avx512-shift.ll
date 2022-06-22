; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=knl | FileCheck %s --check-prefixes=CHECK,KNL
;RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=skx | FileCheck %s --check-prefixes=CHECK,SKX

define <16 x i32> @ashr_16_i32(<16 x i32> %a) {
; CHECK-LABEL: ashr_16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrad $12, %zmm0, %zmm0
; CHECK-NEXT:    retq
   %b = ashr <16 x i32> %a, <i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12>
   ret <16 x i32> %b
}

define <16 x i32> @lshr_16_i32(<16 x i32> %a) {
; CHECK-LABEL: lshr_16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrld $1, %zmm0, %zmm0
; CHECK-NEXT:    retq
   %b = lshr <16 x i32> %a, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
   ret <16 x i32> %b
}

define <16 x i32> @shl_16_i32(<16 x i32> %a) {
; CHECK-LABEL: shl_16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpslld $12, %zmm0, %zmm0
; CHECK-NEXT:    retq
   %b = shl <16 x i32> %a, <i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12, i32 12>
   ret <16 x i32> %b
}

define <8 x i64> @ashr_8_i64(<8 x i64> %a) {
; CHECK-LABEL: ashr_8_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsraq $12, %zmm0, %zmm0
; CHECK-NEXT:    retq
   %b = ashr <8 x i64> %a, <i64 12, i64 12, i64 12, i64 12, i64 12, i64 12, i64 12, i64 12>
   ret <8 x i64> %b
}

define <8 x i64> @lshr_8_i64(<8 x i64> %a) {
; CHECK-LABEL: lshr_8_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlq $1, %zmm0, %zmm0
; CHECK-NEXT:    retq
   %b = lshr <8 x i64> %a, <i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1>
   ret <8 x i64> %b
}

define <8 x i64> @shl_8_i64(<8 x i64> %a) {
; CHECK-LABEL: shl_8_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllq $12, %zmm0, %zmm0
; CHECK-NEXT:    retq
   %b = shl <8 x i64> %a, <i64 12, i64 12, i64 12, i64 12, i64 12, i64 12, i64 12, i64 12>
   ret <8 x i64> %b
}

define <4 x i64> @ashr_4_i64(<4 x i64> %a) {
; KNL-LABEL: ashr_4_i64:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL-NEXT:    vpsraq $12, %zmm0, %zmm0
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: ashr_4_i64:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsraq $12, %ymm0, %ymm0
; SKX-NEXT:    retq
   %b = ashr <4 x i64> %a, <i64 12, i64 12, i64 12, i64 12>
   ret <4 x i64> %b
}

define <4 x i64> @lshr_4_i64(<4 x i64> %a) {
; CHECK-LABEL: lshr_4_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlq $1, %ymm0, %ymm0
; CHECK-NEXT:    retq
   %b = lshr <4 x i64> %a, <i64 1, i64 1, i64 1, i64 1>
   ret <4 x i64> %b
}

define <4 x i64> @shl_4_i64(<4 x i64> %a) {
; CHECK-LABEL: shl_4_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllq $12, %ymm0, %ymm0
; CHECK-NEXT:    retq
   %b = shl <4 x i64> %a,  <i64 12, i64 12, i64 12, i64 12>
   ret <4 x i64> %b
}

define <8 x i64> @variable_shl4(<8 x i64> %x, <8 x i64> %y) {
; CHECK-LABEL: variable_shl4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllvq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %k = shl <8 x i64> %x, %y
  ret <8 x i64> %k
}

define <16 x i32> @variable_shl5(<16 x i32> %x, <16 x i32> %y) {
; CHECK-LABEL: variable_shl5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllvd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %k = shl <16 x i32> %x, %y
  ret <16 x i32> %k
}

define <16 x i32> @variable_srl0(<16 x i32> %x, <16 x i32> %y) {
; CHECK-LABEL: variable_srl0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlvd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %k = lshr <16 x i32> %x, %y
  ret <16 x i32> %k
}

define <8 x i64> @variable_srl2(<8 x i64> %x, <8 x i64> %y) {
; CHECK-LABEL: variable_srl2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlvq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %k = lshr <8 x i64> %x, %y
  ret <8 x i64> %k
}

define <16 x i32> @variable_sra1(<16 x i32> %x, <16 x i32> %y) {
; CHECK-LABEL: variable_sra1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsravd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %k = ashr <16 x i32> %x, %y
  ret <16 x i32> %k
}

define <8 x i64> @variable_sra2(<8 x i64> %x, <8 x i64> %y) {
; CHECK-LABEL: variable_sra2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsravq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %k = ashr <8 x i64> %x, %y
  ret <8 x i64> %k
}

define <4 x i64> @variable_sra3(<4 x i64> %x, <4 x i64> %y) {
; KNL-LABEL: variable_sra3:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL-NEXT:    vpsravq %zmm1, %zmm0, %zmm0
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: variable_sra3:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsravq %ymm1, %ymm0, %ymm0
; SKX-NEXT:    retq
  %k = ashr <4 x i64> %x, %y
  ret <4 x i64> %k
}

define <8 x i16> @variable_sra4(<8 x i16> %x, <8 x i16> %y) {
; KNL-LABEL: variable_sra4:
; KNL:       # %bb.0:
; KNL-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; KNL-NEXT:    vpmovsxwd %xmm0, %ymm0
; KNL-NEXT:    vpsravd %ymm1, %ymm0, %ymm0
; KNL-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; KNL-NEXT:    retq
;
; SKX-LABEL: variable_sra4:
; SKX:       # %bb.0:
; SKX-NEXT:    vpsravw %xmm1, %xmm0, %xmm0
; SKX-NEXT:    retq
  %k = ashr <8 x i16> %x, %y
  ret <8 x i16> %k
}

define <16 x i32> @variable_sra01_load(<16 x i32> %x, ptr %y) {
; CHECK-LABEL: variable_sra01_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsravd (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %y1 = load <16 x i32>, ptr %y
  %k = ashr <16 x i32> %x, %y1
  ret <16 x i32> %k
}

define <16 x i32> @variable_shl1_load(<16 x i32> %x, ptr %y) {
; CHECK-LABEL: variable_shl1_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllvd (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %y1 = load <16 x i32>, ptr %y
  %k = shl <16 x i32> %x, %y1
  ret <16 x i32> %k
}

define <16 x i32> @variable_srl0_load(<16 x i32> %x, ptr %y) {
; CHECK-LABEL: variable_srl0_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlvd (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %y1 = load <16 x i32>, ptr %y
  %k = lshr <16 x i32> %x, %y1
  ret <16 x i32> %k
}

define <8 x i64> @variable_srl3_load(<8 x i64> %x, ptr %y) {
; CHECK-LABEL: variable_srl3_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlvq (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %y1 = load <8 x i64>, ptr %y
  %k = lshr <8 x i64> %x, %y1
  ret <8 x i64> %k
}
