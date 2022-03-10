; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2,+gfni | FileCheck %s --check-prefixes=GFNISSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+gfni | FileCheck %s --check-prefixes=GFNIAVX,GFNIAVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+gfni | FileCheck %s --check-prefixes=GFNIAVX,GFNIAVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+gfni | FileCheck %s --check-prefixes=GFNIAVX,GFNIAVX512,GFNIAVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+gfni | FileCheck %s --check-prefixes=GFNIAVX,GFNIAVX512,GFNIAVX512BW

;
; 128 Bit Vector Shifts
;

define <16 x i8> @splatconstant_shl_v16i8(<16 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_shl_v16i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psllw $3, %xmm0
; GFNISSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; GFNISSE-NEXT:    retq
;
; GFNIAVX-LABEL: splatconstant_shl_v16i8:
; GFNIAVX:       # %bb.0:
; GFNIAVX-NEXT:    vpsllw $3, %xmm0, %xmm0
; GFNIAVX-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; GFNIAVX-NEXT:    retq
  %shift = shl <16 x i8> %a, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  ret <16 x i8> %shift
}

define <16 x i8> @splatconstant_lshr_v16i8(<16 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_lshr_v16i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psrlw $7, %xmm0
; GFNISSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; GFNISSE-NEXT:    retq
;
; GFNIAVX-LABEL: splatconstant_lshr_v16i8:
; GFNIAVX:       # %bb.0:
; GFNIAVX-NEXT:    vpsrlw $7, %xmm0, %xmm0
; GFNIAVX-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; GFNIAVX-NEXT:    retq
  %shift = lshr <16 x i8> %a, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  ret <16 x i8> %shift
}

define <16 x i8> @splatconstant_ashr_v16i8(<16 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_ashr_v16i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psrlw $4, %xmm0
; GFNISSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm1 = [8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]
; GFNISSE-NEXT:    pxor %xmm1, %xmm0
; GFNISSE-NEXT:    psubb %xmm1, %xmm0
; GFNISSE-NEXT:    retq
;
; GFNIAVX-LABEL: splatconstant_ashr_v16i8:
; GFNIAVX:       # %bb.0:
; GFNIAVX-NEXT:    vpsrlw $4, %xmm0, %xmm0
; GFNIAVX-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; GFNIAVX-NEXT:    vmovdqa {{.*#+}} xmm1 = [8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]
; GFNIAVX-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; GFNIAVX-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; GFNIAVX-NEXT:    retq
  %shift = ashr <16 x i8> %a, <i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4>
  ret <16 x i8> %shift
}

;
; 256 Bit Vector Shifts
;

define <32 x i8> @splatconstant_shl_v32i8(<32 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_shl_v32i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psllw $6, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm2 = [192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192]
; GFNISSE-NEXT:    pand %xmm2, %xmm0
; GFNISSE-NEXT:    psllw $6, %xmm1
; GFNISSE-NEXT:    pand %xmm2, %xmm1
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_shl_v32i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; GFNIAVX1-NEXT:    vpsllw $6, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192]
; GFNIAVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpsllw $6, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_shl_v32i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsllw $6, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_shl_v32i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsllw $6, %ymm0, %ymm0
; GFNIAVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX512-NEXT:    retq
  %shift = shl <32 x i8> %a, <i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6>
  ret <32 x i8> %shift
}

define <32 x i8> @splatconstant_lshr_v32i8(<32 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_lshr_v32i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psrlw $1, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm2 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; GFNISSE-NEXT:    pand %xmm2, %xmm0
; GFNISSE-NEXT:    psrlw $1, %xmm1
; GFNISSE-NEXT:    pand %xmm2, %xmm1
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_lshr_v32i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $1, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; GFNIAVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $1, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_lshr_v32i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $1, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_lshr_v32i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsrlw $1, %ymm0, %ymm0
; GFNIAVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX512-NEXT:    retq
  %shift = lshr <32 x i8> %a, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <32 x i8> %shift
}

define <32 x i8> @splatconstant_ashr_v32i8(<32 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_ashr_v32i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psrlw $2, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm2 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; GFNISSE-NEXT:    pand %xmm2, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm3 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; GFNISSE-NEXT:    pxor %xmm3, %xmm0
; GFNISSE-NEXT:    psubb %xmm3, %xmm0
; GFNISSE-NEXT:    psrlw $2, %xmm1
; GFNISSE-NEXT:    pand %xmm2, %xmm1
; GFNISSE-NEXT:    pxor %xmm3, %xmm1
; GFNISSE-NEXT:    psubb %xmm3, %xmm1
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_ashr_v32i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $2, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; GFNIAVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; GFNIAVX1-NEXT:    vpxor %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpsubb %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $2, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpxor %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpsubb %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_ashr_v32i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $2, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; GFNIAVX2-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpsubb %ymm1, %ymm0, %ymm0
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_ashr_v32i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsrlw $2, %ymm0, %ymm0
; GFNIAVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX512-NEXT:    vmovdqa {{.*#+}} ymm1 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; GFNIAVX512-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; GFNIAVX512-NEXT:    vpsubb %ymm1, %ymm0, %ymm0
; GFNIAVX512-NEXT:    retq
  %shift = ashr <32 x i8> %a, <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <32 x i8> %shift
}

;
; 512 Bit Vector Shifts
;

define <64 x i8> @splatconstant_shl_v64i8(<64 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_shl_v64i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psllw $5, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm4 = [224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224]
; GFNISSE-NEXT:    pand %xmm4, %xmm0
; GFNISSE-NEXT:    psllw $5, %xmm1
; GFNISSE-NEXT:    pand %xmm4, %xmm1
; GFNISSE-NEXT:    psllw $5, %xmm2
; GFNISSE-NEXT:    pand %xmm4, %xmm2
; GFNISSE-NEXT:    psllw $5, %xmm3
; GFNISSE-NEXT:    pand %xmm4, %xmm3
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_shl_v64i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; GFNIAVX1-NEXT:    vpsllw $5, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224]
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsllw $5, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; GFNIAVX1-NEXT:    vpsllw $5, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsllw $5, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_shl_v64i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsllw $5, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224,224]
; GFNIAVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpsllw $5, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpand %ymm2, %ymm1, %ymm1
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512F-LABEL: splatconstant_shl_v64i8:
; GFNIAVX512F:       # %bb.0:
; GFNIAVX512F-NEXT:    vpsllw $5, %ymm0, %ymm1
; GFNIAVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; GFNIAVX512F-NEXT:    vpsllw $5, %ymm0, %ymm0
; GFNIAVX512F-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; GFNIAVX512F-NEXT:    vpandq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; GFNIAVX512F-NEXT:    retq
;
; GFNIAVX512BW-LABEL: splatconstant_shl_v64i8:
; GFNIAVX512BW:       # %bb.0:
; GFNIAVX512BW-NEXT:    vpsllw $5, %zmm0, %zmm0
; GFNIAVX512BW-NEXT:    vpandq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; GFNIAVX512BW-NEXT:    retq
  %shift = shl <64 x i8> %a, <i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5>
  ret <64 x i8> %shift
}

define <64 x i8> @splatconstant_lshr_v64i8(<64 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_lshr_v64i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psrlw $7, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm4 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; GFNISSE-NEXT:    pand %xmm4, %xmm0
; GFNISSE-NEXT:    psrlw $7, %xmm1
; GFNISSE-NEXT:    pand %xmm4, %xmm1
; GFNISSE-NEXT:    psrlw $7, %xmm2
; GFNISSE-NEXT:    pand %xmm4, %xmm2
; GFNISSE-NEXT:    psrlw $7, %xmm3
; GFNISSE-NEXT:    pand %xmm4, %xmm3
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_lshr_v64i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_lshr_v64i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $7, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; GFNIAVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpsrlw $7, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpand %ymm2, %ymm1, %ymm1
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512F-LABEL: splatconstant_lshr_v64i8:
; GFNIAVX512F:       # %bb.0:
; GFNIAVX512F-NEXT:    vpsrlw $7, %ymm0, %ymm1
; GFNIAVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; GFNIAVX512F-NEXT:    vpsrlw $7, %ymm0, %ymm0
; GFNIAVX512F-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; GFNIAVX512F-NEXT:    vpandq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; GFNIAVX512F-NEXT:    retq
;
; GFNIAVX512BW-LABEL: splatconstant_lshr_v64i8:
; GFNIAVX512BW:       # %bb.0:
; GFNIAVX512BW-NEXT:    vpsrlw $7, %zmm0, %zmm0
; GFNIAVX512BW-NEXT:    vpandq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm0, %zmm0
; GFNIAVX512BW-NEXT:    retq
  %shift = lshr <64 x i8> %a, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  ret <64 x i8> %shift
}

define <64 x i8> @splatconstant_ashr_v64i8(<64 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_ashr_v64i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    psrlw $1, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm4 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; GFNISSE-NEXT:    pand %xmm4, %xmm0
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm5 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
; GFNISSE-NEXT:    pxor %xmm5, %xmm0
; GFNISSE-NEXT:    psubb %xmm5, %xmm0
; GFNISSE-NEXT:    psrlw $1, %xmm1
; GFNISSE-NEXT:    pand %xmm4, %xmm1
; GFNISSE-NEXT:    pxor %xmm5, %xmm1
; GFNISSE-NEXT:    psubb %xmm5, %xmm1
; GFNISSE-NEXT:    psrlw $1, %xmm2
; GFNISSE-NEXT:    pand %xmm4, %xmm2
; GFNISSE-NEXT:    pxor %xmm5, %xmm2
; GFNISSE-NEXT:    psubb %xmm5, %xmm2
; GFNISSE-NEXT:    psrlw $1, %xmm3
; GFNISSE-NEXT:    pand %xmm4, %xmm3
; GFNISSE-NEXT:    pxor %xmm5, %xmm3
; GFNISSE-NEXT:    psubb %xmm5, %xmm3
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_ashr_v64i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $1, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
; GFNIAVX1-NEXT:    vpxor %xmm4, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsubb %xmm4, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $1, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpxor %xmm4, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpsubb %xmm4, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $1, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpxor %xmm4, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsubb %xmm4, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $1, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpxor %xmm4, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpsubb %xmm4, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_ashr_v64i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $1, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; GFNIAVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
; GFNIAVX2-NEXT:    vpxor %ymm3, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpsubb %ymm3, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpsrlw $1, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpand %ymm2, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpxor %ymm3, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpsubb %ymm3, %ymm1, %ymm1
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512F-LABEL: splatconstant_ashr_v64i8:
; GFNIAVX512F:       # %bb.0:
; GFNIAVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm1
; GFNIAVX512F-NEXT:    vpsrlw $1, %ymm1, %ymm1
; GFNIAVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127]
; GFNIAVX512F-NEXT:    vpand %ymm2, %ymm1, %ymm1
; GFNIAVX512F-NEXT:    vmovdqa {{.*#+}} ymm3 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
; GFNIAVX512F-NEXT:    vpxor %ymm3, %ymm1, %ymm1
; GFNIAVX512F-NEXT:    vpsubb %ymm3, %ymm1, %ymm1
; GFNIAVX512F-NEXT:    vpsrlw $1, %ymm0, %ymm0
; GFNIAVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm0
; GFNIAVX512F-NEXT:    vpxor %ymm3, %ymm0, %ymm0
; GFNIAVX512F-NEXT:    vpsubb %ymm3, %ymm0, %ymm0
; GFNIAVX512F-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; GFNIAVX512F-NEXT:    retq
;
; GFNIAVX512BW-LABEL: splatconstant_ashr_v64i8:
; GFNIAVX512BW:       # %bb.0:
; GFNIAVX512BW-NEXT:    vpsrlw $1, %zmm0, %zmm0
; GFNIAVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm1 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
; GFNIAVX512BW-NEXT:    vpternlogq $108, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm1, %zmm0
; GFNIAVX512BW-NEXT:    vpsubb %zmm1, %zmm0, %zmm0
; GFNIAVX512BW-NEXT:    retq
  %shift = ashr <64 x i8> %a, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <64 x i8> %shift
}
