; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx512bw | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512bw | FileCheck %s --check-prefixes=CHECK,X64

declare <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8>, <64 x i8>, <64 x i8>, i64)

declare <32 x i16> @llvm.x86.avx512.permvar.hi.512(<32 x i16>, <32 x i16>)

declare <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16>, <32 x i16>, <32 x i16>, i32)

declare <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16>, <32 x i16>, <32 x i16>, i32)

define <32 x i16> @combine_vpermt2var_32i16_identity(<32 x i16> %x0, <32 x i16> %x1) {
; CHECK-LABEL: combine_vpermt2var_32i16_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16> <i16 31, i16 30, i16 29, i16 28, i16 27, i16 26, i16 25, i16 24, i16 23, i16 22, i16 21, i16 20, i16 19, i16 18, i16 17, i16 16, i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, <32 x i16> %x0, <32 x i16> %x1, i32 -1)
  %res1 = call <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16> <i16 63, i16 30, i16 61, i16 28, i16 59, i16 26, i16 57, i16 24, i16 55, i16 22, i16 53, i16 20, i16 51, i16 18, i16 49, i16 16, i16 47, i16 46, i16 13, i16 44, i16 11, i16 42, i16 9, i16 40, i16 7, i16 38, i16 5, i16 36, i16 3, i16 34, i16 1, i16 32>, <32 x i16> %res0, <32 x i16> %res0, i32 -1)
  ret <32 x i16> %res1
}
define <32 x i16> @combine_vpermt2var_32i16_identity_mask(<32 x i16> %x0, <32 x i16> %x1, i32 %m) {
; X86-LABEL: combine_vpermt2var_32i16_identity_mask:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpermi2w %zmm0, %zmm0, %zmm1 {%k1} {z}
; X86-NEXT:    vmovdqa64 {{.*#+}} zmm0 = [63,30,61,28,59,26,57,24,55,22,53,20,51,18,49,16,47,46,13,44,11,42,9,40,7,38,5,36,3,34,1,32]
; X86-NEXT:    vpermi2w %zmm1, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: combine_vpermt2var_32i16_identity_mask:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpermi2w %zmm0, %zmm0, %zmm1 {%k1} {z}
; X64-NEXT:    vmovdqa64 {{.*#+}} zmm0 = [63,30,61,28,59,26,57,24,55,22,53,20,51,18,49,16,47,46,13,44,11,42,9,40,7,38,5,36,3,34,1,32]
; X64-NEXT:    vpermi2w %zmm1, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
  %res0 = call <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16> <i16 31, i16 30, i16 29, i16 28, i16 27, i16 26, i16 25, i16 24, i16 23, i16 22, i16 21, i16 20, i16 19, i16 18, i16 17, i16 16, i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, <32 x i16> %x0, <32 x i16> %x1, i32 %m)
  %res1 = call <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16> <i16 63, i16 30, i16 61, i16 28, i16 59, i16 26, i16 57, i16 24, i16 55, i16 22, i16 53, i16 20, i16 51, i16 18, i16 49, i16 16, i16 47, i16 46, i16 13, i16 44, i16 11, i16 42, i16 9, i16 40, i16 7, i16 38, i16 5, i16 36, i16 3, i16 34, i16 1, i16 32>, <32 x i16> %res0, <32 x i16> %res0, i32 %m)
  ret <32 x i16> %res1
}

define <64 x i8> @combine_pshufb_identity(<64 x i8> %x0) {
; CHECK-LABEL: combine_pshufb_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %select = bitcast <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1> to <64 x i8>
  %mask = bitcast <16 x i32> <i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 undef, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051> to <64 x i8>
  %res0 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %x0, <64 x i8> %mask, <64 x i8> %select, i64 -1)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %res0, <64 x i8> %mask, <64 x i8> %select, i64 -1)
  ret <64 x i8> %res1
}
define <64 x i8> @combine_pshufb_identity_mask(<64 x i8> %x0, i64 %m) {
; X86-LABEL: combine_pshufb_identity_mask:
; X86:       # %bb.0:
; X86-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1
; X86-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpternlogd $255, %zmm3, %zmm3, %zmm3
; X86-NEXT:    vpshufb %zmm2, %zmm0, %zmm3 {%k1}
; X86-NEXT:    vpshufb %zmm2, %zmm3, %zmm1 {%k1}
; X86-NEXT:    vmovdqa64 %zmm1, %zmm0
; X86-NEXT:    retl
;
; X64-LABEL: combine_pshufb_identity_mask:
; X64:       # %bb.0:
; X64-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1
; X64-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpternlogd $255, %zmm3, %zmm3, %zmm3
; X64-NEXT:    vpshufb %zmm2, %zmm0, %zmm3 {%k1}
; X64-NEXT:    vpshufb %zmm2, %zmm3, %zmm1 {%k1}
; X64-NEXT:    vmovdqa64 %zmm1, %zmm0
; X64-NEXT:    retq
  %select = bitcast <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1> to <64 x i8>
  %mask = bitcast <16 x i32> <i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051, i32 202182159, i32 134810123, i32 67438087, i32 66051> to <64 x i8>
  %res0 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %x0, <64 x i8> %mask, <64 x i8> %select, i64 %m)
  %res1 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %res0, <64 x i8> %mask, <64 x i8> %select, i64 %m)
  ret <64 x i8> %res1
}

define <32 x i16> @combine_permvar_as_vpbroadcastw512(<32 x i16> %x0) {
; CHECK-LABEL: combine_permvar_as_vpbroadcastw512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpbroadcastw %xmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <32 x i16> @llvm.x86.avx512.permvar.hi.512(<32 x i16> %x0, <32 x i16> zeroinitializer)
  ret <32 x i16> %1
}

define <64 x i8> @combine_pshufb_as_pslldq(<64 x i8> %a0) {
; CHECK-LABEL: combine_pshufb_as_pslldq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpslldq {{.*#+}} zmm0 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[0,1,2,3,4,5],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[16,17,18,19,20,21],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[32,33,34,35,36,37],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[48,49,50,51,52,53]
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %a0, <64 x i8> <i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5>, <64 x i8> undef, i64 -1)
  ret <64 x i8> %res0
}
define <64 x i8> @combine_pshufb_as_pslldq_mask(<64 x i8> %a0, i64 %m) {
; X86-LABEL: combine_pshufb_as_pslldq_mask:
; X86:       # %bb.0:
; X86-NEXT:    vpslldq {{.*#+}} zmm0 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[0,1,2,3,4,5],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[16,17,18,19,20,21],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[32,33,34,35,36,37],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[48,49,50,51,52,53]
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vmovdqu8 %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: combine_pshufb_as_pslldq_mask:
; X64:       # %bb.0:
; X64-NEXT:    vpslldq {{.*#+}} zmm0 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[0,1,2,3,4,5],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[16,17,18,19,20,21],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[32,33,34,35,36,37],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[48,49,50,51,52,53]
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vmovdqu8 %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
  %res0 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %a0, <64 x i8> <i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 0, i8 1, i8 2, i8 3, i8 4, i8 5>, <64 x i8> zeroinitializer, i64 %m)
  ret <64 x i8> %res0
}

define <64 x i8> @combine_pshufb_as_psrldq(<64 x i8> %a0) {
; CHECK-LABEL: combine_pshufb_as_psrldq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrldq {{.*#+}} zmm0 = zmm0[15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[31],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[47],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[63],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %a0, <64 x i8> <i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128>, <64 x i8> undef, i64 -1)
  ret <64 x i8> %res0
}
define <64 x i8> @combine_pshufb_as_psrldq_mask(<64 x i8> %a0, i64 %m) {
; X86-LABEL: combine_pshufb_as_psrldq_mask:
; X86:       # %bb.0:
; X86-NEXT:    vpsrldq {{.*#+}} zmm0 = zmm0[15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[31],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[47],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[63],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; X86-NEXT:    kmovq {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vmovdqu8 %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: combine_pshufb_as_psrldq_mask:
; X64:       # %bb.0:
; X64-NEXT:    vpsrldq {{.*#+}} zmm0 = zmm0[15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[31],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[47],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zmm0[63],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vmovdqu8 %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
  %res0 = call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %a0, <64 x i8> <i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 15, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128, i8 128>, <64 x i8> zeroinitializer, i64 %m)
  ret <64 x i8> %res0
}

define <32 x i16> @combine_permvar_as_pshuflw(<32 x i16> %a0) {
; CHECK-LABEL: combine_permvar_as_pshuflw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshuflw {{.*#+}} zmm0 = zmm0[1,0,3,2,4,5,6,7,9,8,11,10,12,13,14,15,17,16,19,18,20,21,22,23,25,24,27,26,28,29,30,31]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <32 x i16> @llvm.x86.avx512.permvar.hi.512(<32 x i16> %a0, <32 x i16> <i16 1, i16 0, i16 3, i16 2, i16 4, i16 5, i16 6, i16 7, i16 9, i16 8, i16 11, i16 10, i16 12, i16 13, i16 14, i16 15, i16 17, i16 16, i16 19, i16 18, i16 20, i16 21, i16 22, i16 23, i16 25, i16 24, i16 27, i16 26, i16 28, i16 29, i16 30, i16 31>)
  ret <32 x i16> %1
}

define <32 x i16> @combine_pshufb_as_pshufhw(<32 x i16> %a0) {
; CHECK-LABEL: combine_pshufb_as_pshufhw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshufhw {{.*#+}} zmm0 = zmm0[0,1,2,3,5,4,7,6,8,9,10,11,13,12,15,14,16,17,18,19,21,20,23,22,24,25,26,27,29,28,31,30]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <32 x i16> @llvm.x86.avx512.permvar.hi.512(<32 x i16> %a0, <32 x i16> <i16 0, i16 1, i16 2, i16 3, i16 5, i16 4, i16 7, i16 6, i16 8, i16 9, i16 10, i16 11, i16 13, i16 12, i16 15, i16 14, i16 16, i16 17, i16 18, i16 19, i16 21, i16 20, i16 23, i16 22, i16 24, i16 25, i16 26, i16 27, i16 29, i16 28, i16 31, i16 30>)
  ret <32 x i16> %1
}

define <32 x i16> @combine_vpermi2var_as_packssdw(<16 x i32> %a0, <16 x i32> %a1) nounwind {
; CHECK-LABEL: combine_vpermi2var_as_packssdw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrad $25, %zmm0, %zmm0
; CHECK-NEXT:    vpsrad $25, %zmm1, %zmm1
; CHECK-NEXT:    vpackssdw %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = ashr <16 x i32> %a0, <i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25>
  %2 = ashr <16 x i32> %a1, <i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25>
  %3 = bitcast <16 x i32> %1 to <32 x i16>
  %4 = bitcast <16 x i32> %2 to <32 x i16>
  %5 = call <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16> %3, <32 x i16> <i16 0, i16 2, i16 4, i16 6, i16 32, i16 34, i16 36, i16 38, i16 8, i16 10, i16 12, i16 14, i16 40, i16 42, i16 44, i16 46, i16 16, i16 18, i16 20, i16 22, i16 48, i16 50, i16 52, i16 54, i16 24, i16 26, i16 28, i16 30, i16 56, i16 58, i16 60, i16 62>, <32 x i16> %4, i32 -1)
  ret <32 x i16> %5
}

define <32 x i16> @combine_vpermi2var_as_packusdw(<16 x i32> %a0, <16 x i32> %a1) nounwind {
; CHECK-LABEL: combine_vpermi2var_as_packusdw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrld $25, %zmm0, %zmm0
; CHECK-NEXT:    vpsrld $25, %zmm1, %zmm1
; CHECK-NEXT:    vpackusdw %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = lshr <16 x i32> %a0, <i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25>
  %2 = lshr <16 x i32> %a1, <i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25, i32 25>
  %3 = bitcast <16 x i32> %1 to <32 x i16>
  %4 = bitcast <16 x i32> %2 to <32 x i16>
  %5 = call <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16> %3, <32 x i16> <i16 0, i16 2, i16 4, i16 6, i16 32, i16 34, i16 36, i16 38, i16 8, i16 10, i16 12, i16 14, i16 40, i16 42, i16 44, i16 46, i16 16, i16 18, i16 20, i16 22, i16 48, i16 50, i16 52, i16 54, i16 24, i16 26, i16 28, i16 30, i16 56, i16 58, i16 60, i16 62>, <32 x i16> %4, i32 -1)
  ret <32 x i16> %5
}

define <64 x i8> @combine_pshufb_as_packsswb(<32 x i16> %a0, <32 x i16> %a1) nounwind {
; CHECK-LABEL: combine_pshufb_as_packsswb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsraw $11, %zmm0, %zmm0
; CHECK-NEXT:    vpsraw $11, %zmm1, %zmm1
; CHECK-NEXT:    vpacksswb %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = ashr <32 x i16> %a0, <i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11>
  %2 = ashr <32 x i16> %a1, <i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11>
  %3 = bitcast <32 x i16> %1 to <64 x i8>
  %4 = bitcast <32 x i16> %2 to <64 x i8>
  %5 = tail call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %3, <64 x i8> <i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <64 x i8> undef, i64 -1)
  %6 = tail call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %4, <64 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14>, <64 x i8> undef, i64 -1)
  %7 = or <64 x i8> %5, %6
  ret <64 x i8> %7
}

define <64 x i8> @combine_pshufb_as_packuswb(<32 x i16> %a0, <32 x i16> %a1) nounwind {
; CHECK-LABEL: combine_pshufb_as_packuswb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrlw $11, %zmm0, %zmm0
; CHECK-NEXT:    vpsrlw $11, %zmm1, %zmm1
; CHECK-NEXT:    vpackuswb %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = lshr <32 x i16> %a0, <i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11>
  %2 = lshr <32 x i16> %a1, <i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11>
  %3 = bitcast <32 x i16> %1 to <64 x i8>
  %4 = bitcast <32 x i16> %2 to <64 x i8>
  %5 = tail call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %3, <64 x i8> <i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <64 x i8> undef, i64 -1)
  %6 = tail call <64 x i8> @llvm.x86.avx512.mask.pshuf.b.512(<64 x i8> %4, <64 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 0, i8 2, i8 4, i8 6, i8 8, i8 10, i8 12, i8 14>, <64 x i8> undef, i64 -1)
  %7 = or <64 x i8> %5, %6
  ret <64 x i8> %7
}

define <32 x i16> @combine_vpermi2var_32i16_as_pshufb(<32 x i16> %a0) {
; CHECK-LABEL: combine_vpermi2var_32i16_as_pshufb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpshufb {{.*#+}} zmm0 = zmm0[2,3,0,1,6,7,4,5,10,11,8,9,14,15,12,13,18,19,16,17,22,23,20,21,26,27,24,25,30,31,28,29,34,35,32,33,38,39,36,37,42,43,40,41,46,47,44,45,50,51,48,49,54,55,52,53,58,59,56,57,62,63,60,61]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = call <32 x i16> @llvm.x86.avx512.permvar.hi.512(<32 x i16> %a0, <32 x i16> <i16 1, i16 0, i16 3, i16 2, i16 4, i16 5, i16 6, i16 7, i16 9, i16 8, i16 11, i16 10, i16 12, i16 13, i16 14, i16 15, i16 17, i16 16, i16 19, i16 18, i16 20, i16 21, i16 22, i16 23, i16 25, i16 24, i16 27, i16 26, i16 28, i16 29, i16 30, i16 31>)
  %2 = call <32 x i16> @llvm.x86.avx512.permvar.hi.512(<32 x i16> %1, <32 x i16> <i16 0, i16 1, i16 2, i16 3, i16 5, i16 4, i16 7, i16 6, i16 8, i16 9, i16 10, i16 11, i16 13, i16 12, i16 15, i16 14, i16 16, i16 17, i16 18, i16 19, i16 21, i16 20, i16 23, i16 22, i16 24, i16 25, i16 26, i16 27, i16 29, i16 28, i16 31, i16 30>)
  ret <32 x i16> %2
}

define <32 x i16> @combine_vpermi2var_32i16_identity(<32 x i16> %x0, <32 x i16> %x1) {
; CHECK-LABEL: combine_vpermi2var_32i16_identity:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16> %x0, <32 x i16> <i16 31, i16 30, i16 29, i16 28, i16 27, i16 26, i16 25, i16 24, i16 23, i16 22, i16 21, i16 20, i16 19, i16 18, i16 17, i16 16, i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0>, <32 x i16> %x1, i32 -1)
  %res1 = call <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16> %res0, <32 x i16> <i16 63, i16 30, i16 61, i16 28, i16 59, i16 26, i16 57, i16 24, i16 55, i16 22, i16 53, i16 20, i16 51, i16 18, i16 49, i16 16, i16 47, i16 46, i16 13, i16 44, i16 11, i16 42, i16 9, i16 40, i16 7, i16 38, i16 5, i16 36, i16 3, i16 34, i16 1, i16 32>, <32 x i16> %res0, i32 -1)
  ret <32 x i16> %res1
}

define <32 x i16> @combine_vpermi2var_32i16_as_permw(<32 x i16> %x0, <32 x i16> %x1) {
; CHECK-LABEL: combine_vpermi2var_32i16_as_permw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [15,16,14,17,13,18,12,19,11,20,10,21,9,22,8,23,7,24,6,25,5,26,4,27,3,28,2,29,1,30,0,31]
; CHECK-NEXT:    vpermw %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16> %x0, <32 x i16> <i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0, i16 31, i16 30, i16 29, i16 28, i16 27, i16 26, i16 25, i16 24, i16 23, i16 22, i16 21, i16 20, i16 19, i16 18, i16 17, i16 16>, <32 x i16> %x1, i32 -1)
  %res1 = call <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16> %res0, <32 x i16> <i16 0, i16 31, i16 1, i16 30, i16 2, i16 29, i16 3, i16 28, i16 4, i16 27, i16 5, i16 26, i16 6, i16 25, i16 7, i16 24, i16 8, i16 23, i16 9, i16 22, i16 10, i16 21, i16 11, i16 20, i16 12, i16 19, i16 13, i16 18, i16 14, i16 17, i16 15, i16 16>, <32 x i16> %res0, i32 -1)
  ret <32 x i16> %res1
}

define <32 x i16> @combine_vpermt2var_vpermi2var_32i16_as_permw(<32 x i16> %x0, <32 x i16> %x1) {
; CHECK-LABEL: combine_vpermt2var_vpermi2var_32i16_as_permw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [17,39,19,38,21,37,23,36,25,35,27,34,29,33,31,32,1,47,3,46,5,45,7,44,9,43,11,42,13,41,15,40]
; CHECK-NEXT:    vpermi2w %zmm0, %zmm1, %zmm2
; CHECK-NEXT:    vmovdqa64 %zmm2, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res0 = call <32 x i16> @llvm.x86.avx512.maskz.vpermt2var.hi.512(<32 x i16> <i16 0, i16 63, i16 1, i16 61, i16 2, i16 59, i16 3, i16 57, i16 4, i16 55, i16 5, i16 53, i16 6, i16 51, i16 7, i16 49, i16 8, i16 47, i16 9, i16 45, i16 10, i16 43, i16 11, i16 41, i16 12, i16 39, i16 13, i16 37, i16 14, i16 35, i16 15, i16 33>, <32 x i16> %x0, <32 x i16> %x1, i32 -1)
  %res1 = call <32 x i16> @llvm.x86.avx512.mask.vpermi2var.hi.512(<32 x i16> %res0, <32 x i16> <i16 15, i16 14, i16 13, i16 12, i16 11, i16 10, i16 9, i16 8, i16 7, i16 6, i16 5, i16 4, i16 3, i16 2, i16 1, i16 0, i16 31, i16 30, i16 29, i16 28, i16 27, i16 26, i16 25, i16 24, i16 23, i16 22, i16 21, i16 20, i16 19, i16 18, i16 17, i16 16>, <32 x i16> %res0, i32 -1)
  ret <32 x i16> %res1
}
