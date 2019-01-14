; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512vbmi --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vbmi --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64

declare <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_mask_permvar_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_permvar_qi_512:
; X86:       # %bb.0:
; X86-NEXT:    vpermb %zmm0, %zmm1, %zmm3 # encoding: [0x62,0xf2,0x75,0x48,0x8d,0xd8]
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1 # encoding: [0xc4,0xe1,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vpermb %zmm0, %zmm1, %zmm2 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x8d,0xd0]
; X86-NEXT:    vpermb %zmm0, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x8d,0xc0]
; X86-NEXT:    vpaddb %zmm3, %zmm0, %zmm0 # encoding: [0x62,0xf1,0x7d,0x48,0xfc,0xc3]
; X86-NEXT:    vpaddb %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0x6d,0x48,0xfc,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_permvar_qi_512:
; X64:       # %bb.0:
; X64-NEXT:    vpermb %zmm0, %zmm1, %zmm3 # encoding: [0x62,0xf2,0x75,0x48,0x8d,0xd8]
; X64-NEXT:    kmovq %rdi, %k1 # encoding: [0xc4,0xe1,0xfb,0x92,0xcf]
; X64-NEXT:    vpermb %zmm0, %zmm1, %zmm2 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x8d,0xd0]
; X64-NEXT:    vpermb %zmm0, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x8d,0xc0]
; X64-NEXT:    vpaddb %zmm3, %zmm0, %zmm0 # encoding: [0x62,0xf1,0x7d,0x48,0xfc,0xc3]
; X64-NEXT:    vpaddb %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0x6d,0x48,0xfc,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
 %res = call <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
 %res1 = call <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> zeroinitializer, i64 %x3)
 %res2 = call <64 x i8> @llvm.x86.avx512.mask.permvar.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 -1)
 %res3 = add <64 x i8> %res, %res1
 %res4 = add <64 x i8> %res3, %res2
 ret <64 x i8> %res4
}

declare <64 x i8> @llvm.x86.avx512.mask.pmultishift.qb.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_mask_pmultishift_qb_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_pmultishift_qb_512:
; X86:       # %bb.0:
; X86-NEXT:    vpmultishiftqb %zmm1, %zmm0, %zmm3 # encoding: [0x62,0xf2,0xfd,0x48,0x83,0xd9]
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1 # encoding: [0xc4,0xe1,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vpmultishiftqb %zmm1, %zmm0, %zmm2 {%k1} # encoding: [0x62,0xf2,0xfd,0x49,0x83,0xd1]
; X86-NEXT:    vpmultishiftqb %zmm1, %zmm0, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xfd,0xc9,0x83,0xc1]
; X86-NEXT:    vpaddb %zmm3, %zmm0, %zmm0 # encoding: [0x62,0xf1,0x7d,0x48,0xfc,0xc3]
; X86-NEXT:    vpaddb %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0x6d,0x48,0xfc,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_pmultishift_qb_512:
; X64:       # %bb.0:
; X64-NEXT:    vpmultishiftqb %zmm1, %zmm0, %zmm3 # encoding: [0x62,0xf2,0xfd,0x48,0x83,0xd9]
; X64-NEXT:    kmovq %rdi, %k1 # encoding: [0xc4,0xe1,0xfb,0x92,0xcf]
; X64-NEXT:    vpmultishiftqb %zmm1, %zmm0, %zmm2 {%k1} # encoding: [0x62,0xf2,0xfd,0x49,0x83,0xd1]
; X64-NEXT:    vpmultishiftqb %zmm1, %zmm0, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0xfd,0xc9,0x83,0xc1]
; X64-NEXT:    vpaddb %zmm3, %zmm0, %zmm0 # encoding: [0x62,0xf1,0x7d,0x48,0xfc,0xc3]
; X64-NEXT:    vpaddb %zmm0, %zmm2, %zmm0 # encoding: [0x62,0xf1,0x6d,0x48,0xfc,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %res = call <64 x i8> @llvm.x86.avx512.mask.pmultishift.qb.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.pmultishift.qb.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> zeroinitializer, i64 %x3)
  %res2 = call <64 x i8> @llvm.x86.avx512.mask.pmultishift.qb.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 -1)
  %res3 = add <64 x i8> %res, %res1
  %res4 = add <64 x i8> %res3, %res2
  ret <64 x i8> %res4
}

declare <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_mask_vpermi2var_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpermi2var_qi_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    vpermt2b %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0x75,0x48,0x7d,0xda]
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1 # encoding: [0xc4,0xe1,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vpermi2b %zmm2, %zmm0, %zmm1 {%k1} # encoding: [0x62,0xf2,0x7d,0x49,0x75,0xca]
; X86-NEXT:    vmovdqa64 %zmm1, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe1]
; X86-NEXT:    vpermi2b %zmm2, %zmm0, %zmm4 {%k1} # encoding: [0x62,0xf2,0x7d,0x49,0x75,0xe2]
; X86-NEXT:    vpaddb %zmm3, %zmm4, %zmm0 # encoding: [0x62,0xf1,0x5d,0x48,0xfc,0xc3]
; X86-NEXT:    vpaddb %zmm0, %zmm1, %zmm0 # encoding: [0x62,0xf1,0x75,0x48,0xfc,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpermi2var_qi_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    vpermt2b %zmm2, %zmm1, %zmm3 # encoding: [0x62,0xf2,0x75,0x48,0x7d,0xda]
; X64-NEXT:    kmovq %rdi, %k1 # encoding: [0xc4,0xe1,0xfb,0x92,0xcf]
; X64-NEXT:    vpermi2b %zmm2, %zmm0, %zmm1 {%k1} # encoding: [0x62,0xf2,0x7d,0x49,0x75,0xca]
; X64-NEXT:    vmovdqa64 %zmm1, %zmm4 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xe1]
; X64-NEXT:    vpermi2b %zmm2, %zmm0, %zmm4 {%k1} # encoding: [0x62,0xf2,0x7d,0x49,0x75,0xe2]
; X64-NEXT:    vpaddb %zmm3, %zmm4, %zmm0 # encoding: [0x62,0xf1,0x5d,0x48,0xfc,0xc3]
; X64-NEXT:    vpaddb %zmm0, %zmm1, %zmm0 # encoding: [0x62,0xf1,0x75,0x48,0xfc,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %res = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %x0, <64 x i8> %res, <64 x i8> %x2, i64 %x3)
  %res2 = call <64 x i8> @llvm.x86.avx512.mask.vpermi2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 -1)
  %res3 = add <64 x i8> %res, %res1
  %res4 = add <64 x i8> %res3, %res2
  ret <64 x i8> %res4
}

declare <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_mask_vpermt2var_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpermt2var_qi_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm1, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd9]
; X86-NEXT:    vpermt2b %zmm2, %zmm0, %zmm3 # encoding: [0x62,0xf2,0x7d,0x48,0x7d,0xda]
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1 # encoding: [0xc4,0xe1,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vpermt2b %zmm2, %zmm0, %zmm1 {%k1} # encoding: [0x62,0xf2,0x7d,0x49,0x7d,0xca]
; X86-NEXT:    vpxor %xmm4, %xmm4, %xmm4 # encoding: [0xc5,0xd9,0xef,0xe4]
; X86-NEXT:    vpermt2b %zmm2, %zmm0, %zmm4 {%k1} {z} # encoding: [0x62,0xf2,0x7d,0xc9,0x7d,0xe2]
; X86-NEXT:    vpaddb %zmm3, %zmm4, %zmm0 # encoding: [0x62,0xf1,0x5d,0x48,0xfc,0xc3]
; X86-NEXT:    vpaddb %zmm0, %zmm1, %zmm0 # encoding: [0x62,0xf1,0x75,0x48,0xfc,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpermt2var_qi_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm1, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd9]
; X64-NEXT:    vpermt2b %zmm2, %zmm0, %zmm3 # encoding: [0x62,0xf2,0x7d,0x48,0x7d,0xda]
; X64-NEXT:    kmovq %rdi, %k1 # encoding: [0xc4,0xe1,0xfb,0x92,0xcf]
; X64-NEXT:    vpermt2b %zmm2, %zmm0, %zmm1 {%k1} # encoding: [0x62,0xf2,0x7d,0x49,0x7d,0xca]
; X64-NEXT:    vpxor %xmm4, %xmm4, %xmm4 # encoding: [0xc5,0xd9,0xef,0xe4]
; X64-NEXT:    vpermt2b %zmm2, %zmm0, %zmm4 {%k1} {z} # encoding: [0x62,0xf2,0x7d,0xc9,0x7d,0xe2]
; X64-NEXT:    vpaddb %zmm3, %zmm4, %zmm0 # encoding: [0x62,0xf1,0x5d,0x48,0xfc,0xc3]
; X64-NEXT:    vpaddb %zmm0, %zmm1, %zmm0 # encoding: [0x62,0xf1,0x75,0x48,0xfc,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %res = call <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> zeroinitializer, <64 x i8> %x2, i64 %x3)
  %res2 = call <64 x i8> @llvm.x86.avx512.mask.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 -1)
  %res3 = add <64 x i8> %res, %res1
  %res4 = add <64 x i8> %res3, %res2
  ret <64 x i8> %res4
}

declare <64 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

define <64 x i8>@test_int_x86_avx512_maskz_vpermt2var_qi_512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3) {
; X86-LABEL: test_int_x86_avx512_maskz_vpermt2var_qi_512:
; X86:       # %bb.0:
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1 # encoding: [0xc4,0xe1,0xf8,0x90,0x4c,0x24,0x04]
; X86-NEXT:    vpermi2b %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x75,0xc2]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_maskz_vpermt2var_qi_512:
; X64:       # %bb.0:
; X64-NEXT:    kmovq %rdi, %k1 # encoding: [0xc4,0xe1,0xfb,0x92,0xcf]
; X64-NEXT:    vpermi2b %zmm2, %zmm1, %zmm0 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x75,0xc2]
; X64-NEXT:    retq # encoding: [0xc3]
  %res = call <64 x i8> @llvm.x86.avx512.maskz.vpermt2var.qi.512(<64 x i8> %x0, <64 x i8> %x1, <64 x i8> %x2, i64 %x3)
  ret <64 x i8> %res
}
