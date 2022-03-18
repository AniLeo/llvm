; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2,+gfni | FileCheck %s --check-prefixes=GFNISSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+gfni | FileCheck %s --check-prefixes=GFNIAVX1OR2,GFNIAVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+gfni | FileCheck %s --check-prefixes=GFNIAVX1OR2,GFNIAVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+avx512vl,+gfni | FileCheck %s --check-prefixes=GFNIAVX512

;
; 128 Bit Vector Rotates
;

define <16 x i8> @splatconstant_rotl_v16i8(<16 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_rotl_v16i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    movdqa %xmm0, %xmm1
; GFNISSE-NEXT:    psrlw $5, %xmm1
; GFNISSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; GFNISSE-NEXT:    psllw $3, %xmm0
; GFNISSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; GFNISSE-NEXT:    por %xmm1, %xmm0
; GFNISSE-NEXT:    retq
;
; GFNIAVX1OR2-LABEL: splatconstant_rotl_v16i8:
; GFNIAVX1OR2:       # %bb.0:
; GFNIAVX1OR2-NEXT:    vpsrlw $5, %xmm0, %xmm1
; GFNIAVX1OR2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; GFNIAVX1OR2-NEXT:    vpsllw $3, %xmm0, %xmm0
; GFNIAVX1OR2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; GFNIAVX1OR2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; GFNIAVX1OR2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_rotl_v16i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsllw $3, %xmm0, %xmm1
; GFNIAVX512-NEXT:    vpsrlw $5, %xmm0, %xmm0
; GFNIAVX512-NEXT:    vpternlogq $216, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm0
; GFNIAVX512-NEXT:    retq
  %res = call <16 x i8> @llvm.fshl.v16i8(<16 x i8> %a, <16 x i8> %a, <16 x i8> <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.fshl.v16i8(<16 x i8>, <16 x i8>, <16 x i8>)

define <16 x i8> @splatconstant_rotr_v16i8(<16 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_rotr_v16i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    movdqa %xmm0, %xmm1
; GFNISSE-NEXT:    psrlw $7, %xmm1
; GFNISSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; GFNISSE-NEXT:    paddb %xmm0, %xmm0
; GFNISSE-NEXT:    por %xmm1, %xmm0
; GFNISSE-NEXT:    retq
;
; GFNIAVX1OR2-LABEL: splatconstant_rotr_v16i8:
; GFNIAVX1OR2:       # %bb.0:
; GFNIAVX1OR2-NEXT:    vpsrlw $7, %xmm0, %xmm1
; GFNIAVX1OR2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; GFNIAVX1OR2-NEXT:    vpaddb %xmm0, %xmm0, %xmm0
; GFNIAVX1OR2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; GFNIAVX1OR2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_rotr_v16i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsrlw $7, %xmm0, %xmm1
; GFNIAVX512-NEXT:    vpaddb %xmm0, %xmm0, %xmm0
; GFNIAVX512-NEXT:    vpternlogq $248, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm0
; GFNIAVX512-NEXT:    retq
  %res = call <16 x i8> @llvm.fshr.v16i8(<16 x i8> %a, <16 x i8> %a, <16 x i8> <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>)
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.fshr.v16i8(<16 x i8>, <16 x i8>, <16 x i8>)

;
; 256 Bit Vector Rotates
;

define <32 x i8> @splatconstant_rotl_v32i8(<32 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_rotl_v32i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    movdqa %xmm0, %xmm2
; GFNISSE-NEXT:    psrlw $4, %xmm2
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm3 = [240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240]
; GFNISSE-NEXT:    movdqa %xmm3, %xmm4
; GFNISSE-NEXT:    pandn %xmm2, %xmm4
; GFNISSE-NEXT:    psllw $4, %xmm0
; GFNISSE-NEXT:    pand %xmm3, %xmm0
; GFNISSE-NEXT:    por %xmm4, %xmm0
; GFNISSE-NEXT:    movdqa %xmm1, %xmm2
; GFNISSE-NEXT:    psrlw $4, %xmm2
; GFNISSE-NEXT:    psllw $4, %xmm1
; GFNISSE-NEXT:    pand %xmm3, %xmm1
; GFNISSE-NEXT:    pandn %xmm2, %xmm3
; GFNISSE-NEXT:    por %xmm3, %xmm1
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_rotl_v32i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $4, %xmm1, %xmm2
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240]
; GFNIAVX1-NEXT:    vpandn %xmm2, %xmm3, %xmm2
; GFNIAVX1-NEXT:    vpsllw $4, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpor %xmm2, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $4, %xmm0, %xmm2
; GFNIAVX1-NEXT:    vpandn %xmm2, %xmm3, %xmm2
; GFNIAVX1-NEXT:    vpsllw $4, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpor %xmm2, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_rotl_v32i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $4, %ymm0, %ymm1
; GFNIAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpsllw $4, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpor %ymm1, %ymm0, %ymm0
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_rotl_v32i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsllw $4, %ymm0, %ymm1
; GFNIAVX512-NEXT:    vpsrlw $4, %ymm0, %ymm0
; GFNIAVX512-NEXT:    vpternlogq $216, {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %ymm1, %ymm0
; GFNIAVX512-NEXT:    retq
  %res = call <32 x i8> @llvm.fshl.v32i8(<32 x i8> %a, <32 x i8> %a, <32 x i8> <i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4, i8 4>)
  ret <32 x i8> %res
}
declare <32 x i8> @llvm.fshl.v32i8(<32 x i8>, <32 x i8>, <32 x i8>)

define <32 x i8> @splatconstant_rotr_v32i8(<32 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_rotr_v32i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    movdqa %xmm0, %xmm2
; GFNISSE-NEXT:    psrlw $6, %xmm2
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm3 = [252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252]
; GFNISSE-NEXT:    movdqa %xmm3, %xmm4
; GFNISSE-NEXT:    pandn %xmm2, %xmm4
; GFNISSE-NEXT:    psllw $2, %xmm0
; GFNISSE-NEXT:    pand %xmm3, %xmm0
; GFNISSE-NEXT:    por %xmm4, %xmm0
; GFNISSE-NEXT:    movdqa %xmm1, %xmm2
; GFNISSE-NEXT:    psrlw $6, %xmm2
; GFNISSE-NEXT:    psllw $2, %xmm1
; GFNISSE-NEXT:    pand %xmm3, %xmm1
; GFNISSE-NEXT:    pandn %xmm2, %xmm3
; GFNISSE-NEXT:    por %xmm3, %xmm1
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_rotr_v32i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $6, %xmm1, %xmm2
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252]
; GFNIAVX1-NEXT:    vpandn %xmm2, %xmm3, %xmm2
; GFNIAVX1-NEXT:    vpsllw $2, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpor %xmm2, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpsrlw $6, %xmm0, %xmm2
; GFNIAVX1-NEXT:    vpandn %xmm2, %xmm3, %xmm2
; GFNIAVX1-NEXT:    vpsllw $2, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpor %xmm2, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_rotr_v32i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $6, %ymm0, %ymm1
; GFNIAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpsllw $2, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpor %ymm1, %ymm0, %ymm0
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_rotr_v32i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsllw $2, %ymm0, %ymm1
; GFNIAVX512-NEXT:    vpsrlw $6, %ymm0, %ymm0
; GFNIAVX512-NEXT:    vpternlogq $216, {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %ymm1, %ymm0
; GFNIAVX512-NEXT:    retq
  %res = call <32 x i8> @llvm.fshr.v32i8(<32 x i8> %a, <32 x i8> %a, <32 x i8> <i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6, i8 6>)
  ret <32 x i8> %res
}
declare <32 x i8> @llvm.fshr.v32i8(<32 x i8>, <32 x i8>, <32 x i8>)

;
; 512 Bit Vector Rotates
;

define <64 x i8> @splatconstant_rotl_v64i8(<64 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_rotl_v64i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    movdqa %xmm0, %xmm4
; GFNISSE-NEXT:    psrlw $7, %xmm4
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm5 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; GFNISSE-NEXT:    pand %xmm5, %xmm4
; GFNISSE-NEXT:    paddb %xmm0, %xmm0
; GFNISSE-NEXT:    por %xmm4, %xmm0
; GFNISSE-NEXT:    movdqa %xmm1, %xmm4
; GFNISSE-NEXT:    psrlw $7, %xmm4
; GFNISSE-NEXT:    pand %xmm5, %xmm4
; GFNISSE-NEXT:    paddb %xmm1, %xmm1
; GFNISSE-NEXT:    por %xmm4, %xmm1
; GFNISSE-NEXT:    movdqa %xmm2, %xmm4
; GFNISSE-NEXT:    psrlw $7, %xmm4
; GFNISSE-NEXT:    pand %xmm5, %xmm4
; GFNISSE-NEXT:    paddb %xmm2, %xmm2
; GFNISSE-NEXT:    por %xmm4, %xmm2
; GFNISSE-NEXT:    movdqa %xmm3, %xmm4
; GFNISSE-NEXT:    psrlw $7, %xmm4
; GFNISSE-NEXT:    pand %xmm5, %xmm4
; GFNISSE-NEXT:    paddb %xmm3, %xmm3
; GFNISSE-NEXT:    por %xmm4, %xmm3
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_rotl_v64i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm2, %xmm3
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm3, %xmm3
; GFNIAVX1-NEXT:    vpaddb %xmm2, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm0, %xmm3
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm3, %xmm3
; GFNIAVX1-NEXT:    vpaddb %xmm0, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm2, %xmm3
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm3, %xmm3
; GFNIAVX1-NEXT:    vpaddb %xmm2, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $7, %xmm1, %xmm3
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm3, %xmm3
; GFNIAVX1-NEXT:    vpaddb %xmm1, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_rotl_v64i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $7, %ymm0, %ymm2
; GFNIAVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; GFNIAVX2-NEXT:    vpand %ymm3, %ymm2, %ymm2
; GFNIAVX2-NEXT:    vpaddb %ymm0, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpor %ymm2, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpsrlw $7, %ymm1, %ymm2
; GFNIAVX2-NEXT:    vpand %ymm3, %ymm2, %ymm2
; GFNIAVX2-NEXT:    vpaddb %ymm1, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpor %ymm2, %ymm1, %ymm1
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_rotl_v64i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsrlw $7, %zmm0, %zmm1
; GFNIAVX512-NEXT:    vpaddb %zmm0, %zmm0, %zmm0
; GFNIAVX512-NEXT:    vpternlogq $248, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %zmm1, %zmm0
; GFNIAVX512-NEXT:    retq
  %res = call <64 x i8> @llvm.fshl.v64i8(<64 x i8> %a, <64 x i8> %a, <64 x i8> <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>)
  ret <64 x i8> %res
}
declare <64 x i8> @llvm.fshl.v64i8(<64 x i8>, <64 x i8>, <64 x i8>)

define <64 x i8> @splatconstant_rotr_v64i8(<64 x i8> %a) nounwind {
; GFNISSE-LABEL: splatconstant_rotr_v64i8:
; GFNISSE:       # %bb.0:
; GFNISSE-NEXT:    movdqa %xmm0, %xmm5
; GFNISSE-NEXT:    psrlw $2, %xmm5
; GFNISSE-NEXT:    movdqa {{.*#+}} xmm4 = [192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192]
; GFNISSE-NEXT:    movdqa %xmm4, %xmm6
; GFNISSE-NEXT:    pandn %xmm5, %xmm6
; GFNISSE-NEXT:    psllw $6, %xmm0
; GFNISSE-NEXT:    pand %xmm4, %xmm0
; GFNISSE-NEXT:    por %xmm6, %xmm0
; GFNISSE-NEXT:    movdqa %xmm1, %xmm5
; GFNISSE-NEXT:    psrlw $2, %xmm5
; GFNISSE-NEXT:    movdqa %xmm4, %xmm6
; GFNISSE-NEXT:    pandn %xmm5, %xmm6
; GFNISSE-NEXT:    psllw $6, %xmm1
; GFNISSE-NEXT:    pand %xmm4, %xmm1
; GFNISSE-NEXT:    por %xmm6, %xmm1
; GFNISSE-NEXT:    movdqa %xmm2, %xmm5
; GFNISSE-NEXT:    psrlw $2, %xmm5
; GFNISSE-NEXT:    movdqa %xmm4, %xmm6
; GFNISSE-NEXT:    pandn %xmm5, %xmm6
; GFNISSE-NEXT:    psllw $6, %xmm2
; GFNISSE-NEXT:    pand %xmm4, %xmm2
; GFNISSE-NEXT:    por %xmm6, %xmm2
; GFNISSE-NEXT:    movdqa %xmm3, %xmm5
; GFNISSE-NEXT:    psrlw $2, %xmm5
; GFNISSE-NEXT:    psllw $6, %xmm3
; GFNISSE-NEXT:    pand %xmm4, %xmm3
; GFNISSE-NEXT:    pandn %xmm5, %xmm4
; GFNISSE-NEXT:    por %xmm4, %xmm3
; GFNISSE-NEXT:    retq
;
; GFNIAVX1-LABEL: splatconstant_rotr_v64i8:
; GFNIAVX1:       # %bb.0:
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $2, %xmm2, %xmm3
; GFNIAVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192]
; GFNIAVX1-NEXT:    vpandn %xmm3, %xmm4, %xmm3
; GFNIAVX1-NEXT:    vpsllw $6, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $2, %xmm0, %xmm3
; GFNIAVX1-NEXT:    vpandn %xmm3, %xmm4, %xmm3
; GFNIAVX1-NEXT:    vpsllw $6, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm0, %xmm0
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; GFNIAVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $2, %xmm2, %xmm3
; GFNIAVX1-NEXT:    vpandn %xmm3, %xmm4, %xmm3
; GFNIAVX1-NEXT:    vpsllw $6, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm2, %xmm2
; GFNIAVX1-NEXT:    vpsrlw $2, %xmm1, %xmm3
; GFNIAVX1-NEXT:    vpandn %xmm3, %xmm4, %xmm3
; GFNIAVX1-NEXT:    vpsllw $6, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpand %xmm4, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vpor %xmm3, %xmm1, %xmm1
; GFNIAVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; GFNIAVX1-NEXT:    retq
;
; GFNIAVX2-LABEL: splatconstant_rotr_v64i8:
; GFNIAVX2:       # %bb.0:
; GFNIAVX2-NEXT:    vpsrlw $2, %ymm0, %ymm2
; GFNIAVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = [192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192]
; GFNIAVX2-NEXT:    vpandn %ymm2, %ymm3, %ymm2
; GFNIAVX2-NEXT:    vpsllw $6, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpand %ymm3, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpor %ymm2, %ymm0, %ymm0
; GFNIAVX2-NEXT:    vpsrlw $2, %ymm1, %ymm2
; GFNIAVX2-NEXT:    vpandn %ymm2, %ymm3, %ymm2
; GFNIAVX2-NEXT:    vpsllw $6, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpand %ymm3, %ymm1, %ymm1
; GFNIAVX2-NEXT:    vpor %ymm2, %ymm1, %ymm1
; GFNIAVX2-NEXT:    retq
;
; GFNIAVX512-LABEL: splatconstant_rotr_v64i8:
; GFNIAVX512:       # %bb.0:
; GFNIAVX512-NEXT:    vpsllw $6, %zmm0, %zmm1
; GFNIAVX512-NEXT:    vpsrlw $2, %zmm0, %zmm0
; GFNIAVX512-NEXT:    vpternlogq $216, {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm1, %zmm0
; GFNIAVX512-NEXT:    retq
  %res = call <64 x i8> @llvm.fshr.v64i8(<64 x i8> %a, <64 x i8> %a, <64 x i8> <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>)
  ret <64 x i8> %res
}
declare <64 x i8> @llvm.fshr.v64i8(<64 x i8>, <64 x i8>, <64 x i8>)
