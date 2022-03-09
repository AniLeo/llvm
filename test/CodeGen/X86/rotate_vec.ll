; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=bdver2 | FileCheck %s --check-prefixes=CHECK,XOP,XOPAVX1
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=bdver4 | FileCheck %s --check-prefixes=CHECK,XOP,XOPAVX2
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=skylake-avx512 | FileCheck %s --check-prefixes=CHECK,AVX512

define <4 x i32> @rot_v4i32_splat(<4 x i32> %x) {
; XOP-LABEL: rot_v4i32_splat:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd $31, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: rot_v4i32_splat:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprold $31, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  %2 = shl <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %3 = or <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @rot_v4i32_non_splat(<4 x i32> %x) {
; XOP-LABEL: rot_v4i32_non_splat:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: rot_v4i32_non_splat:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprolvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 2, i32 3, i32 4>
  %2 = shl <4 x i32> %x, <i32 31, i32 30, i32 29, i32 28>
  %3 = or <4 x i32> %1, %2
  ret <4 x i32> %3
}

define <4 x i32> @rot_v4i32_splat_2masks(<4 x i32> %x) {
; XOP-LABEL: rot_v4i32_splat_2masks:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd $31, %xmm0, %xmm0
; XOP-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: rot_v4i32_splat_2masks:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprold $31, %xmm0, %xmm0
; AVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  %2 = and <4 x i32> %1, <i32 4294901760, i32 4294901760, i32 4294901760, i32 4294901760>

  %3 = shl <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %4 = and <4 x i32> %3, <i32 0, i32 4294901760, i32 0, i32 4294901760>
  %5 = or <4 x i32> %2, %4
  ret <4 x i32> %5
}

define <4 x i32> @rot_v4i32_non_splat_2masks(<4 x i32> %x) {
; XOP-LABEL: rot_v4i32_non_splat_2masks:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOP-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: rot_v4i32_non_splat_2masks:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprolvd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 2, i32 3, i32 4>
  %2 = and <4 x i32> %1, <i32 4294901760, i32 4294901760, i32 4294901760, i32 4294901760>

  %3 = shl <4 x i32> %x, <i32 31, i32 30, i32 29, i32 28>
  %4 = and <4 x i32> %3, <i32 0, i32 4294901760, i32 0, i32 4294901760>
  %5 = or <4 x i32> %2, %4
  ret <4 x i32> %5
}

define <4 x i32> @rot_v4i32_zero_non_splat(<4 x i32> %x) {
; XOPAVX1-LABEL: rot_v4i32_zero_non_splat:
; XOPAVX1:       # %bb.0:
; XOPAVX1-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; XOPAVX1-NEXT:    retq
;
; XOPAVX2-LABEL: rot_v4i32_zero_non_splat:
; XOPAVX2:       # %bb.0:
; XOPAVX2-NEXT:    vbroadcastss %xmm0, %xmm0
; XOPAVX2-NEXT:    retq
;
; AVX512-LABEL: rot_v4i32_zero_non_splat:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vbroadcastss %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 2, i32 3>)
  %2 = shufflevector <4 x i32> %1, <4 x i32> undef, <4 x i32> zeroinitializer
  ret <4 x i32> %2
}

define <4 x i32> @rot_v4i32_allsignbits(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: rot_v4i32_allsignbits:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsrad $31, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %1 = ashr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %2 = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %1, <4 x i32> %1, <4 x i32> %y)
  ret <4 x i32> %2
}

define <4 x i32> @rot_v4i32_mask_ashr0(<4 x i32> %a0) {
; XOPAVX1-LABEL: rot_v4i32_mask_ashr0:
; XOPAVX1:       # %bb.0:
; XOPAVX1-NEXT:    vpshad {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOPAVX1-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; XOPAVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOPAVX1-NEXT:    retq
;
; XOPAVX2-LABEL: rot_v4i32_mask_ashr0:
; XOPAVX2:       # %bb.0:
; XOPAVX2-NEXT:    vpsravd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOPAVX2-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; XOPAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOPAVX2-NEXT:    retq
;
; AVX512-LABEL: rot_v4i32_mask_ashr0:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsravd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = ashr <4 x i32> %a0, <i32 25, i32 26, i32 27, i32 28>
  %2 = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %1, <4 x i32> %1, <4 x i32> <i32 1, i32 1, i32 1, i32 1>)
  %3 = ashr <4 x i32> %2, <i32 1, i32 2, i32 3, i32 4>
  %4 = and <4 x i32> %3, <i32 -32768, i32 -65536, i32 -32768, i32 -65536>
  ret <4 x i32> %4
}

define <4 x i32> @rot_v4i32_mask_ashr1(<4 x i32> %a0) {
; XOPAVX1-LABEL: rot_v4i32_mask_ashr1:
; XOPAVX1:       # %bb.0:
; XOPAVX1-NEXT:    vpsrad $25, %xmm0, %xmm0
; XOPAVX1-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; XOPAVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; XOPAVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOPAVX1-NEXT:    retq
;
; XOPAVX2-LABEL: rot_v4i32_mask_ashr1:
; XOPAVX2:       # %bb.0:
; XOPAVX2-NEXT:    vpsrad $25, %xmm0, %xmm0
; XOPAVX2-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; XOPAVX2-NEXT:    vpbroadcastd %xmm0, %xmm0
; XOPAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; XOPAVX2-NEXT:    retq
;
; AVX512-LABEL: rot_v4i32_mask_ashr1:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsrad $25, %xmm0, %xmm0
; AVX512-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vpbroadcastd %xmm0, %xmm0
; AVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = ashr <4 x i32> %a0, <i32 25, i32 26, i32 27, i32 28>
  %2 = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %1, <4 x i32> %1, <4 x i32> <i32 1, i32 2, i32 3, i32 4>)
  %3 = shufflevector <4 x i32> %2, <4 x i32> undef, <4 x i32> zeroinitializer
  %4 = ashr <4 x i32> %3, <i32 1, i32 2, i32 3, i32 4>
  %5 = and <4 x i32> %4, <i32 -4096, i32 -8192, i32 -4096, i32 -8192>
  ret <4 x i32> %5
}

define <8 x i16> @or_fshl_v8i16(<8 x i16> %x, <8 x i16> %y) {
; XOPAVX1-LABEL: or_fshl_v8i16:
; XOPAVX1:       # %bb.0:
; XOPAVX1-NEXT:    vpor %xmm0, %xmm1, %xmm1
; XOPAVX1-NEXT:    vpsrlw $11, %xmm0, %xmm0
; XOPAVX1-NEXT:    vpsllw $5, %xmm1, %xmm1
; XOPAVX1-NEXT:    vpor %xmm0, %xmm1, %xmm0
; XOPAVX1-NEXT:    retq
;
; XOPAVX2-LABEL: or_fshl_v8i16:
; XOPAVX2:       # %bb.0:
; XOPAVX2-NEXT:    vpor %xmm0, %xmm1, %xmm1
; XOPAVX2-NEXT:    vpsllw $5, %xmm1, %xmm1
; XOPAVX2-NEXT:    vpsrlw $11, %xmm0, %xmm0
; XOPAVX2-NEXT:    vpor %xmm0, %xmm1, %xmm0
; XOPAVX2-NEXT:    retq
;
; AVX512-LABEL: or_fshl_v8i16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpor %xmm0, %xmm1, %xmm1
; AVX512-NEXT:    vpsllw $5, %xmm1, %xmm1
; AVX512-NEXT:    vpsrlw $11, %xmm0, %xmm0
; AVX512-NEXT:    vpor %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %or1 = or <8 x i16> %y, %x
  %sh1 = shl <8 x i16> %or1, <i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5>
  %sh2 = lshr <8 x i16> %x, <i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11, i16 11>
  %r = or <8 x i16> %sh2, %sh1
  ret <8 x i16> %r
}

define <4 x i32> @or_fshl_v4i32(<4 x i32> %x, <4 x i32> %y) {
; XOPAVX1-LABEL: or_fshl_v4i32:
; XOPAVX1:       # %bb.0:
; XOPAVX1-NEXT:    vpor %xmm0, %xmm1, %xmm1
; XOPAVX1-NEXT:    vpsrld $11, %xmm0, %xmm0
; XOPAVX1-NEXT:    vpslld $21, %xmm1, %xmm1
; XOPAVX1-NEXT:    vpor %xmm0, %xmm1, %xmm0
; XOPAVX1-NEXT:    retq
;
; XOPAVX2-LABEL: or_fshl_v4i32:
; XOPAVX2:       # %bb.0:
; XOPAVX2-NEXT:    vpor %xmm0, %xmm1, %xmm1
; XOPAVX2-NEXT:    vpslld $21, %xmm1, %xmm1
; XOPAVX2-NEXT:    vpsrld $11, %xmm0, %xmm0
; XOPAVX2-NEXT:    vpor %xmm0, %xmm1, %xmm0
; XOPAVX2-NEXT:    retq
;
; AVX512-LABEL: or_fshl_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpor %xmm0, %xmm1, %xmm1
; AVX512-NEXT:    vpslld $21, %xmm1, %xmm1
; AVX512-NEXT:    vpsrld $11, %xmm0, %xmm0
; AVX512-NEXT:    vpor %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %or1 = or <4 x i32> %y, %x
  %sh1 = shl <4 x i32> %or1, <i32 21, i32 21, i32 21, i32 21>
  %sh2 = lshr <4 x i32> %x, <i32 11, i32 11, i32 11, i32 11>
  %r = or <4 x i32> %sh2, %sh1
  ret <4 x i32> %r
}

define <2 x i64> @or_fshr_v2i64(<2 x i64> %x, <2 x i64> %y) {
; XOP-LABEL: or_fshr_v2i64:
; XOP:       # %bb.0:
; XOP-NEXT:    vpsrlq $22, %xmm1, %xmm1
; XOP-NEXT:    vprotq $42, %xmm0, %xmm0
; XOP-NEXT:    vpor %xmm1, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: or_fshr_v2i64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpsrlq $22, %xmm1, %xmm1
; AVX512-NEXT:    vprolq $42, %xmm0, %xmm0
; AVX512-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %or1 = or <2 x i64> %x, %y
  %sh1 = shl <2 x i64> %x, <i64 42, i64 42>
  %sh2 = lshr <2 x i64> %or1, <i64 22, i64 22>
  %r = or <2 x i64> %sh1, %sh2
  ret <2 x i64> %r
}

declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)
