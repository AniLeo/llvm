; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512BW

;
; sdiv by 7
;

define <8 x i64> @test_div7_8i64(<8 x i64> %a) nounwind {
; AVX-LABEL: test_div7_8i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vextracti32x4 $3, %zmm0, %xmm1
; AVX-NEXT:    vpextrq $1, %xmm1, %rax
; AVX-NEXT:    movabsq $5270498306774157605, %rcx # imm = 0x4924924924924925
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm2
; AVX-NEXT:    vmovq %xmm1, %rax
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm1
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX-NEXT:    vextracti32x4 $2, %zmm0, %xmm2
; AVX-NEXT:    vpextrq $1, %xmm2, %rax
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm3
; AVX-NEXT:    vmovq %xmm2, %rax
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm2
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; AVX-NEXT:    vinserti128 $1, %xmm1, %ymm2, %ymm1
; AVX-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX-NEXT:    vpextrq $1, %xmm2, %rax
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm3
; AVX-NEXT:    vmovq %xmm2, %rax
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm2
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; AVX-NEXT:    vpextrq $1, %xmm0, %rax
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm3
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    imulq %rcx
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm0
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm3[0]
; AVX-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX-NEXT:    retq
  %res = sdiv <8 x i64> %a, <i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7>
  ret <8 x i64> %res
}

define <16 x i32> @test_div7_16i32(<16 x i32> %a) nounwind {
; AVX-LABEL: test_div7_16i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpbroadcastd {{.*#+}} zmm1 = [2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027]
; AVX-NEXT:    vpmuldq %zmm1, %zmm0, %zmm2
; AVX-NEXT:    vpshufd {{.*#+}} zmm3 = zmm0[1,1,3,3,5,5,7,7,9,9,11,11,13,13,15,15]
; AVX-NEXT:    vpmuldq %zmm1, %zmm3, %zmm1
; AVX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [1,17,3,19,5,21,7,23,9,25,11,27,13,29,15,31]
; AVX-NEXT:    vpermi2d %zmm1, %zmm2, %zmm3
; AVX-NEXT:    vpaddd %zmm0, %zmm3, %zmm0
; AVX-NEXT:    vpsrld $31, %zmm0, %zmm1
; AVX-NEXT:    vpsrad $2, %zmm0, %zmm0
; AVX-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; AVX-NEXT:    retq
  %res = sdiv <16 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
  ret <16 x i32> %res
}

define <32 x i16> @test_div7_32i16(<32 x i16> %a) nounwind {
; AVX512F-LABEL: test_div7_32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725]
; AVX512F-NEXT:    vpmulhw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpsrlw $15, %ymm0, %ymm3
; AVX512F-NEXT:    vpsraw $1, %ymm0, %ymm0
; AVX512F-NEXT:    vpaddw %ymm3, %ymm0, %ymm0
; AVX512F-NEXT:    vpmulhw %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vpsrlw $15, %ymm1, %ymm2
; AVX512F-NEXT:    vpsraw $1, %ymm1, %ymm1
; AVX512F-NEXT:    vpaddw %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_div7_32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmulhw {{.*}}(%rip), %zmm0, %zmm0
; AVX512BW-NEXT:    vpsrlw $15, %zmm0, %zmm1
; AVX512BW-NEXT:    vpsraw $1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpaddw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %res = sdiv <32 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <32 x i16> %res
}

define <64 x i8> @test_div7_64i8(<64 x i8> %a) nounwind {
; AVX512F-LABEL: test_div7_64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX512F-NEXT:    vpmovsxbw %xmm2, %ymm2
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm3 = [65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427]
; AVX512F-NEXT:    vpmullw %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX512F-NEXT:    vpmovsxbw %xmm0, %ymm4
; AVX512F-NEXT:    vpmullw %ymm3, %ymm4, %ymm4
; AVX512F-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpackuswb %ymm2, %ymm4, %ymm2
; AVX512F-NEXT:    vpermq {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm0, %ymm2, %ymm0
; AVX512F-NEXT:    vpsrlw $7, %ymm0, %ymm2
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm4 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; AVX512F-NEXT:    vpand %ymm4, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $2, %ymm0, %ymm0
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm5 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; AVX512F-NEXT:    vpand %ymm5, %ymm0, %ymm0
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm6 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; AVX512F-NEXT:    vpxor %ymm6, %ymm0, %ymm0
; AVX512F-NEXT:    vpsubb %ymm6, %ymm0, %ymm0
; AVX512F-NEXT:    vpaddb %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX512F-NEXT:    vpmovsxbw %xmm2, %ymm2
; AVX512F-NEXT:    vpmullw %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX512F-NEXT:    vpmovsxbw %xmm1, %ymm7
; AVX512F-NEXT:    vpmullw %ymm3, %ymm7, %ymm3
; AVX512F-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512F-NEXT:    vpackuswb %ymm2, %ymm3, %ymm2
; AVX512F-NEXT:    vpermq {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm1, %ymm2, %ymm1
; AVX512F-NEXT:    vpsrlw $7, %ymm1, %ymm2
; AVX512F-NEXT:    vpand %ymm4, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $2, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm5, %ymm1, %ymm1
; AVX512F-NEXT:    vpxor %ymm6, %ymm1, %ymm1
; AVX512F-NEXT:    vpsubb %ymm6, %ymm1, %ymm1
; AVX512F-NEXT:    vpaddb %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_div7_64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovsxbw %ymm0, %zmm1
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427]
; AVX512BW-NEXT:    vpmullw %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpsrlw $8, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovwb %zmm1, %ymm1
; AVX512BW-NEXT:    vextracti64x4 $1, %zmm0, %ymm3
; AVX512BW-NEXT:    vpmovsxbw %ymm3, %zmm3
; AVX512BW-NEXT:    vpmullw %zmm2, %zmm3, %zmm2
; AVX512BW-NEXT:    vpsrlw $8, %zmm2, %zmm2
; AVX512BW-NEXT:    vpmovwb %zmm2, %ymm2
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpaddb %zmm0, %zmm1, %zmm0
; AVX512BW-NEXT:    vpsrlw $2, %zmm0, %zmm1
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; AVX512BW-NEXT:    vpxorq %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpsubb %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpsrlw $7, %zmm0, %zmm0
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm0, %zmm0
; AVX512BW-NEXT:    vpaddb %zmm0, %zmm1, %zmm0
; AVX512BW-NEXT:    retq
  %res = sdiv <64 x i8> %a, <i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7>
  ret <64 x i8> %res
}

;
; sdiv by non-splat constant
;

define <64 x i8> @test_divconstant_64i8(<64 x i8> %a) nounwind {
; AVX512F-LABEL: test_divconstant_64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm2, %ymm3
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX512F-NEXT:    vpand %ymm2, %ymm3, %ymm3
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm4 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpand %ymm2, %ymm4, %ymm4
; AVX512F-NEXT:    vpackuswb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm4
; AVX512F-NEXT:    vpmovsxbw %xmm4, %ymm4
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpmovsxbw %xmm0, %ymm0
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm0, %ymm0
; AVX512F-NEXT:    vpsrlw $8, %ymm0, %ymm0
; AVX512F-NEXT:    vpackuswb %ymm4, %ymm0, %ymm0
; AVX512F-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm3, %ymm0, %ymm0
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm3 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512F-NEXT:    vpsraw $8, %ymm3, %ymm3
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm3, %ymm3
; AVX512F-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm4 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512F-NEXT:    vpsraw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpackuswb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpsrlw $7, %ymm0, %ymm0
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm4 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; AVX512F-NEXT:    vpand %ymm4, %ymm0, %ymm0
; AVX512F-NEXT:    vpaddb %ymm0, %ymm3, %ymm0
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm3 = ymm1[8],ymm0[8],ymm1[9],ymm0[9],ymm1[10],ymm0[10],ymm1[11],ymm0[11],ymm1[12],ymm0[12],ymm1[13],ymm0[13],ymm1[14],ymm0[14],ymm1[15],ymm0[15],ymm1[24],ymm0[24],ymm1[25],ymm0[25],ymm1[26],ymm0[26],ymm1[27],ymm0[27],ymm1[28],ymm0[28],ymm1[29],ymm0[29],ymm1[30],ymm0[30],ymm1[31],ymm0[31]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm3, %ymm3
; AVX512F-NEXT:    vpand %ymm2, %ymm3, %ymm3
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm5 = ymm1[0],ymm0[0],ymm1[1],ymm0[1],ymm1[2],ymm0[2],ymm1[3],ymm0[3],ymm1[4],ymm0[4],ymm1[5],ymm0[5],ymm1[6],ymm0[6],ymm1[7],ymm0[7],ymm1[16],ymm0[16],ymm1[17],ymm0[17],ymm1[18],ymm0[18],ymm1[19],ymm0[19],ymm1[20],ymm0[20],ymm1[21],ymm0[21],ymm1[22],ymm0[22],ymm1[23],ymm0[23]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm5, %ymm5
; AVX512F-NEXT:    vpand %ymm2, %ymm5, %ymm2
; AVX512F-NEXT:    vpackuswb %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vextracti128 $1, %ymm1, %xmm3
; AVX512F-NEXT:    vpmovsxbw %xmm3, %ymm3
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm3, %ymm3
; AVX512F-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512F-NEXT:    vpmovsxbw %xmm1, %ymm1
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm1, %ymm1
; AVX512F-NEXT:    vpsrlw $8, %ymm1, %ymm1
; AVX512F-NEXT:    vpackuswb %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512F-NEXT:    vpsraw $8, %ymm2, %ymm2
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm3 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512F-NEXT:    vpsraw $8, %ymm3, %ymm3
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm3, %ymm3
; AVX512F-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512F-NEXT:    vpackuswb %ymm2, %ymm3, %ymm2
; AVX512F-NEXT:    vpsrlw $7, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm4, %ymm1, %ymm1
; AVX512F-NEXT:    vpaddb %ymm1, %ymm2, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_divconstant_64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm1 = zmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX512BW-NEXT:    vpandq %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm3 = zmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm3, %zmm3
; AVX512BW-NEXT:    vpandq %zmm2, %zmm3, %zmm2
; AVX512BW-NEXT:    vpackuswb %zmm1, %zmm2, %zmm1
; AVX512BW-NEXT:    vpmovsxbw %ymm0, %zmm2
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm2, %zmm2
; AVX512BW-NEXT:    vpsrlw $8, %zmm2, %zmm2
; AVX512BW-NEXT:    vpmovwb %zmm2, %ymm2
; AVX512BW-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; AVX512BW-NEXT:    vpmovsxbw %ymm0, %zmm0
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm0, %zmm0
; AVX512BW-NEXT:    vpsrlw $8, %zmm0, %zmm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm0, %zmm2, %zmm0
; AVX512BW-NEXT:    vpaddb %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm1 = zmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; AVX512BW-NEXT:    vpsraw $8, %zmm1, %zmm1
; AVX512BW-NEXT:    vpsllvw {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vpsrlw $8, %zmm1, %zmm1
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm2 = zmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; AVX512BW-NEXT:    vpsraw $8, %zmm2, %zmm2
; AVX512BW-NEXT:    vpsllvw {{.*}}(%rip), %zmm2, %zmm2
; AVX512BW-NEXT:    vpsrlw $8, %zmm2, %zmm2
; AVX512BW-NEXT:    vpackuswb %zmm1, %zmm2, %zmm1
; AVX512BW-NEXT:    vpsrlw $7, %zmm0, %zmm0
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm0, %zmm0
; AVX512BW-NEXT:    vpaddb %zmm0, %zmm1, %zmm0
; AVX512BW-NEXT:    retq
  %res = sdiv <64 x i8> %a, <i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 16, i8 17, i8 18, i8 19, i8 20, i8 21, i8 22, i8 23, i8 24, i8 25, i8 26, i8 27, i8 28, i8 29, i8 30, i8 31, i8 32, i8 33, i8 34, i8 35, i8 36, i8 37, i8 38, i8 38, i8 37, i8 36, i8 35, i8 34, i8 33, i8 32, i8 31, i8 30, i8 29, i8 28, i8 27, i8 26, i8 25, i8 24, i8 23, i8 22, i8 21, i8 20, i8 19, i8 18, i8 17, i8 16, i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7>
  ret <64 x i8> %res
}

;
; srem by 7
;

define <8 x i64> @test_rem7_8i64(<8 x i64> %a) nounwind {
; AVX-LABEL: test_rem7_8i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vextracti32x4 $3, %zmm0, %xmm1
; AVX-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX-NEXT:    movabsq $5270498306774157605, %rsi # imm = 0x4924924924924925
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm2
; AVX-NEXT:    vmovq %xmm1, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm1
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; AVX-NEXT:    vextracti32x4 $2, %zmm0, %xmm2
; AVX-NEXT:    vpextrq $1, %xmm2, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm3
; AVX-NEXT:    vmovq %xmm2, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm2
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; AVX-NEXT:    vinserti128 $1, %xmm1, %ymm2, %ymm1
; AVX-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX-NEXT:    vpextrq $1, %xmm2, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm3
; AVX-NEXT:    vmovq %xmm2, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm2
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; AVX-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm3
; AVX-NEXT:    vmovq %xmm0, %rcx
; AVX-NEXT:    movq %rcx, %rax
; AVX-NEXT:    imulq %rsi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    shrq $63, %rax
; AVX-NEXT:    sarq %rdx
; AVX-NEXT:    addq %rax, %rdx
; AVX-NEXT:    leaq (,%rdx,8), %rax
; AVX-NEXT:    subq %rax, %rdx
; AVX-NEXT:    addq %rcx, %rdx
; AVX-NEXT:    vmovq %rdx, %xmm0
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm3[0]
; AVX-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; AVX-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX-NEXT:    retq
  %res = srem <8 x i64> %a, <i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7, i64 7>
  ret <8 x i64> %res
}

define <16 x i32> @test_rem7_16i32(<16 x i32> %a) nounwind {
; AVX-LABEL: test_rem7_16i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpbroadcastd {{.*#+}} zmm1 = [2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027,2454267027]
; AVX-NEXT:    vpmuldq %zmm1, %zmm0, %zmm2
; AVX-NEXT:    vpshufd {{.*#+}} zmm3 = zmm0[1,1,3,3,5,5,7,7,9,9,11,11,13,13,15,15]
; AVX-NEXT:    vpmuldq %zmm1, %zmm3, %zmm1
; AVX-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [1,17,3,19,5,21,7,23,9,25,11,27,13,29,15,31]
; AVX-NEXT:    vpermi2d %zmm1, %zmm2, %zmm3
; AVX-NEXT:    vpaddd %zmm0, %zmm3, %zmm1
; AVX-NEXT:    vpsrld $31, %zmm1, %zmm2
; AVX-NEXT:    vpsrad $2, %zmm1, %zmm1
; AVX-NEXT:    vpaddd %zmm2, %zmm1, %zmm1
; AVX-NEXT:    vpmulld {{.*}}(%rip){1to16}, %zmm1, %zmm1
; AVX-NEXT:    vpsubd %zmm1, %zmm0, %zmm0
; AVX-NEXT:    retq
  %res = srem <16 x i32> %a, <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
  ret <16 x i32> %res
}

define <32 x i16> @test_rem7_32i16(<32 x i16> %a) nounwind {
; AVX512F-LABEL: test_rem7_32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725,18725]
; AVX512F-NEXT:    vpmulhw %ymm2, %ymm0, %ymm3
; AVX512F-NEXT:    vpsrlw $15, %ymm3, %ymm4
; AVX512F-NEXT:    vpsraw $1, %ymm3, %ymm3
; AVX512F-NEXT:    vpaddw %ymm4, %ymm3, %ymm3
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm4 = [7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7]
; AVX512F-NEXT:    vpmullw %ymm4, %ymm3, %ymm3
; AVX512F-NEXT:    vpsubw %ymm3, %ymm0, %ymm0
; AVX512F-NEXT:    vpmulhw %ymm2, %ymm1, %ymm2
; AVX512F-NEXT:    vpsrlw $15, %ymm2, %ymm3
; AVX512F-NEXT:    vpsraw $1, %ymm2, %ymm2
; AVX512F-NEXT:    vpaddw %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpmullw %ymm4, %ymm2, %ymm2
; AVX512F-NEXT:    vpsubw %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_rem7_32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmulhw {{.*}}(%rip), %zmm0, %zmm1
; AVX512BW-NEXT:    vpsrlw $15, %zmm1, %zmm2
; AVX512BW-NEXT:    vpsraw $1, %zmm1, %zmm1
; AVX512BW-NEXT:    vpaddw %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vpsubw %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %res = srem <32 x i16> %a, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <32 x i16> %res
}

define <64 x i8> @test_rem7_64i8(<64 x i8> %a) nounwind {
; AVX512F-LABEL: test_rem7_64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX512F-NEXT:    vpmovsxbw %xmm2, %ymm2
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm3 = [65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427]
; AVX512F-NEXT:    vpmullw %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX512F-NEXT:    vpmovsxbw %xmm0, %ymm4
; AVX512F-NEXT:    vpmullw %ymm3, %ymm4, %ymm4
; AVX512F-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpackuswb %ymm2, %ymm4, %ymm2
; AVX512F-NEXT:    vpermq {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm0, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $7, %ymm2, %ymm4
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm5 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; AVX512F-NEXT:    vpand %ymm5, %ymm4, %ymm4
; AVX512F-NEXT:    vpsrlw $2, %ymm2, %ymm2
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm6 = [63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63]
; AVX512F-NEXT:    vpand %ymm6, %ymm2, %ymm2
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm7 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; AVX512F-NEXT:    vpxor %ymm7, %ymm2, %ymm2
; AVX512F-NEXT:    vpsubb %ymm7, %ymm2, %ymm2
; AVX512F-NEXT:    vpaddb %ymm4, %ymm2, %ymm2
; AVX512F-NEXT:    vpsllw $3, %ymm2, %ymm4
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm8 = [248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248]
; AVX512F-NEXT:    vpand %ymm8, %ymm4, %ymm4
; AVX512F-NEXT:    vpsubb %ymm4, %ymm2, %ymm2
; AVX512F-NEXT:    vpaddb %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX512F-NEXT:    vpmovsxbw %xmm2, %ymm2
; AVX512F-NEXT:    vpmullw %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $8, %ymm2, %ymm2
; AVX512F-NEXT:    vpmovsxbw %xmm1, %ymm4
; AVX512F-NEXT:    vpmullw %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpsrlw $8, %ymm3, %ymm3
; AVX512F-NEXT:    vpackuswb %ymm2, %ymm3, %ymm2
; AVX512F-NEXT:    vpermq {{.*#+}} ymm2 = ymm2[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm1, %ymm2, %ymm2
; AVX512F-NEXT:    vpsrlw $7, %ymm2, %ymm3
; AVX512F-NEXT:    vpand %ymm5, %ymm3, %ymm3
; AVX512F-NEXT:    vpsrlw $2, %ymm2, %ymm2
; AVX512F-NEXT:    vpand %ymm6, %ymm2, %ymm2
; AVX512F-NEXT:    vpxor %ymm7, %ymm2, %ymm2
; AVX512F-NEXT:    vpsubb %ymm7, %ymm2, %ymm2
; AVX512F-NEXT:    vpaddb %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpsllw $3, %ymm2, %ymm3
; AVX512F-NEXT:    vpand %ymm8, %ymm3, %ymm3
; AVX512F-NEXT:    vpsubb %ymm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpaddb %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_rem7_64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovsxbw %ymm0, %zmm1
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427,65427]
; AVX512BW-NEXT:    vpmullw %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpsrlw $8, %zmm1, %zmm1
; AVX512BW-NEXT:    vpmovwb %zmm1, %ymm1
; AVX512BW-NEXT:    vextracti64x4 $1, %zmm0, %ymm3
; AVX512BW-NEXT:    vpmovsxbw %ymm3, %zmm3
; AVX512BW-NEXT:    vpmullw %zmm2, %zmm3, %zmm2
; AVX512BW-NEXT:    vpsrlw $8, %zmm2, %zmm2
; AVX512BW-NEXT:    vpmovwb %zmm2, %ymm2
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpaddb %zmm0, %zmm1, %zmm1
; AVX512BW-NEXT:    vpsrlw $2, %zmm1, %zmm2
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm2, %zmm2
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32]
; AVX512BW-NEXT:    vpxorq %zmm3, %zmm2, %zmm2
; AVX512BW-NEXT:    vpsubb %zmm3, %zmm2, %zmm2
; AVX512BW-NEXT:    vpsrlw $7, %zmm1, %zmm1
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vpaddb %zmm1, %zmm2, %zmm1
; AVX512BW-NEXT:    vpsllw $3, %zmm1, %zmm2
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm2, %zmm2
; AVX512BW-NEXT:    vpsubb %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpaddb %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %res = srem <64 x i8> %a, <i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7,i8 7, i8 7, i8 7, i8 7>
  ret <64 x i8> %res
}

;
; srem by non-splat constant
;

define <64 x i8> @test_remconstant_64i8(<64 x i8> %a) nounwind {
; AVX512F-LABEL: test_remconstant_64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm2 = ymm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm2, %ymm3
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX512F-NEXT:    vpand %ymm2, %ymm3, %ymm3
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm4 = ymm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpand %ymm2, %ymm4, %ymm4
; AVX512F-NEXT:    vpackuswb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm4
; AVX512F-NEXT:    vpmovsxbw %xmm4, %ymm4
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpmovsxbw %xmm0, %ymm5
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm5, %ymm5
; AVX512F-NEXT:    vpsrlw $8, %ymm5, %ymm5
; AVX512F-NEXT:    vpackuswb %ymm4, %ymm5, %ymm4
; AVX512F-NEXT:    vpermq {{.*#+}} ymm4 = ymm4[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512F-NEXT:    vpsraw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpsrlw $8, %ymm4, %ymm4
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm5 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512F-NEXT:    vpsraw $8, %ymm5, %ymm5
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm5, %ymm5
; AVX512F-NEXT:    vpsrlw $8, %ymm5, %ymm5
; AVX512F-NEXT:    vpackuswb %ymm4, %ymm5, %ymm4
; AVX512F-NEXT:    vpsrlw $7, %ymm3, %ymm5
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm3 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
; AVX512F-NEXT:    vpand %ymm3, %ymm5, %ymm5
; AVX512F-NEXT:    vpaddb %ymm5, %ymm4, %ymm4
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm5 = ymm4[8],ymm0[8],ymm4[9],ymm0[9],ymm4[10],ymm0[10],ymm4[11],ymm0[11],ymm4[12],ymm0[12],ymm4[13],ymm0[13],ymm4[14],ymm0[14],ymm4[15],ymm0[15],ymm4[24],ymm0[24],ymm4[25],ymm0[25],ymm4[26],ymm0[26],ymm4[27],ymm0[27],ymm4[28],ymm0[28],ymm4[29],ymm0[29],ymm4[30],ymm0[30],ymm4[31],ymm0[31]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm5, %ymm5
; AVX512F-NEXT:    vpand %ymm2, %ymm5, %ymm5
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm4 = ymm4[0],ymm0[0],ymm4[1],ymm0[1],ymm4[2],ymm0[2],ymm4[3],ymm0[3],ymm4[4],ymm0[4],ymm4[5],ymm0[5],ymm4[6],ymm0[6],ymm4[7],ymm0[7],ymm4[16],ymm0[16],ymm4[17],ymm0[17],ymm4[18],ymm0[18],ymm4[19],ymm0[19],ymm4[20],ymm0[20],ymm4[21],ymm0[21],ymm4[22],ymm0[22],ymm4[23],ymm0[23]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpand %ymm2, %ymm4, %ymm4
; AVX512F-NEXT:    vpackuswb %ymm5, %ymm4, %ymm4
; AVX512F-NEXT:    vpsubb %ymm4, %ymm0, %ymm0
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm1[8],ymm0[8],ymm1[9],ymm0[9],ymm1[10],ymm0[10],ymm1[11],ymm0[11],ymm1[12],ymm0[12],ymm1[13],ymm0[13],ymm1[14],ymm0[14],ymm1[15],ymm0[15],ymm1[24],ymm0[24],ymm1[25],ymm0[25],ymm1[26],ymm0[26],ymm1[27],ymm0[27],ymm1[28],ymm0[28],ymm1[29],ymm0[29],ymm1[30],ymm0[30],ymm1[31],ymm0[31]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpand %ymm2, %ymm4, %ymm4
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm5 = ymm1[0],ymm0[0],ymm1[1],ymm0[1],ymm1[2],ymm0[2],ymm1[3],ymm0[3],ymm1[4],ymm0[4],ymm1[5],ymm0[5],ymm1[6],ymm0[6],ymm1[7],ymm0[7],ymm1[16],ymm0[16],ymm1[17],ymm0[17],ymm1[18],ymm0[18],ymm1[19],ymm0[19],ymm1[20],ymm0[20],ymm1[21],ymm0[21],ymm1[22],ymm0[22],ymm1[23],ymm0[23]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm5, %ymm5
; AVX512F-NEXT:    vpand %ymm2, %ymm5, %ymm5
; AVX512F-NEXT:    vpackuswb %ymm4, %ymm5, %ymm4
; AVX512F-NEXT:    vextracti128 $1, %ymm1, %xmm5
; AVX512F-NEXT:    vpmovsxbw %xmm5, %ymm5
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm5, %ymm5
; AVX512F-NEXT:    vpsrlw $8, %ymm5, %ymm5
; AVX512F-NEXT:    vpmovsxbw %xmm1, %ymm6
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm6, %ymm6
; AVX512F-NEXT:    vpsrlw $8, %ymm6, %ymm6
; AVX512F-NEXT:    vpackuswb %ymm5, %ymm6, %ymm5
; AVX512F-NEXT:    vpermq {{.*#+}} ymm5 = ymm5[0,2,1,3]
; AVX512F-NEXT:    vpaddb %ymm4, %ymm5, %ymm4
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm5 = ymm4[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
; AVX512F-NEXT:    vpsraw $8, %ymm5, %ymm5
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm5, %ymm5
; AVX512F-NEXT:    vpsrlw $8, %ymm5, %ymm5
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm6 = ymm4[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
; AVX512F-NEXT:    vpsraw $8, %ymm6, %ymm6
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm6, %ymm6
; AVX512F-NEXT:    vpsrlw $8, %ymm6, %ymm6
; AVX512F-NEXT:    vpackuswb %ymm5, %ymm6, %ymm5
; AVX512F-NEXT:    vpsrlw $7, %ymm4, %ymm4
; AVX512F-NEXT:    vpand %ymm3, %ymm4, %ymm3
; AVX512F-NEXT:    vpaddb %ymm3, %ymm5, %ymm3
; AVX512F-NEXT:    vpunpckhbw {{.*#+}} ymm4 = ymm3[8],ymm0[8],ymm3[9],ymm0[9],ymm3[10],ymm0[10],ymm3[11],ymm0[11],ymm3[12],ymm0[12],ymm3[13],ymm0[13],ymm3[14],ymm0[14],ymm3[15],ymm0[15],ymm3[24],ymm0[24],ymm3[25],ymm0[25],ymm3[26],ymm0[26],ymm3[27],ymm0[27],ymm3[28],ymm0[28],ymm3[29],ymm0[29],ymm3[30],ymm0[30],ymm3[31],ymm0[31]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm4, %ymm4
; AVX512F-NEXT:    vpand %ymm2, %ymm4, %ymm4
; AVX512F-NEXT:    vpunpcklbw {{.*#+}} ymm3 = ymm3[0],ymm0[0],ymm3[1],ymm0[1],ymm3[2],ymm0[2],ymm3[3],ymm0[3],ymm3[4],ymm0[4],ymm3[5],ymm0[5],ymm3[6],ymm0[6],ymm3[7],ymm0[7],ymm3[16],ymm0[16],ymm3[17],ymm0[17],ymm3[18],ymm0[18],ymm3[19],ymm0[19],ymm3[20],ymm0[20],ymm3[21],ymm0[21],ymm3[22],ymm0[22],ymm3[23],ymm0[23]
; AVX512F-NEXT:    vpmullw {{.*}}(%rip), %ymm3, %ymm3
; AVX512F-NEXT:    vpand %ymm2, %ymm3, %ymm2
; AVX512F-NEXT:    vpackuswb %ymm4, %ymm2, %ymm2
; AVX512F-NEXT:    vpsubb %ymm2, %ymm1, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: test_remconstant_64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm1 = zmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX512BW-NEXT:    vpandq %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm3 = zmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm3, %zmm3
; AVX512BW-NEXT:    vpandq %zmm2, %zmm3, %zmm3
; AVX512BW-NEXT:    vpackuswb %zmm1, %zmm3, %zmm1
; AVX512BW-NEXT:    vpmovsxbw %ymm0, %zmm3
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm3, %zmm3
; AVX512BW-NEXT:    vpsrlw $8, %zmm3, %zmm3
; AVX512BW-NEXT:    vpmovwb %zmm3, %ymm3
; AVX512BW-NEXT:    vextracti64x4 $1, %zmm0, %ymm4
; AVX512BW-NEXT:    vpmovsxbw %ymm4, %zmm4
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm4, %zmm4
; AVX512BW-NEXT:    vpsrlw $8, %zmm4, %zmm4
; AVX512BW-NEXT:    vpmovwb %zmm4, %ymm4
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm4, %zmm3, %zmm3
; AVX512BW-NEXT:    vpaddb %zmm1, %zmm3, %zmm1
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm3 = zmm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,40,40,41,41,42,42,43,43,44,44,45,45,46,46,47,47,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63]
; AVX512BW-NEXT:    vpsraw $8, %zmm3, %zmm3
; AVX512BW-NEXT:    vpsllvw {{.*}}(%rip), %zmm3, %zmm3
; AVX512BW-NEXT:    vpsrlw $8, %zmm3, %zmm3
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm4 = zmm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,48,48,49,49,50,50,51,51,52,52,53,53,54,54,55,55]
; AVX512BW-NEXT:    vpsraw $8, %zmm4, %zmm4
; AVX512BW-NEXT:    vpsllvw {{.*}}(%rip), %zmm4, %zmm4
; AVX512BW-NEXT:    vpsrlw $8, %zmm4, %zmm4
; AVX512BW-NEXT:    vpackuswb %zmm3, %zmm4, %zmm3
; AVX512BW-NEXT:    vpsrlw $7, %zmm1, %zmm1
; AVX512BW-NEXT:    vpandq {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vpaddb %zmm1, %zmm3, %zmm1
; AVX512BW-NEXT:    vpunpckhbw {{.*#+}} zmm3 = zmm1[8],zmm0[8],zmm1[9],zmm0[9],zmm1[10],zmm0[10],zmm1[11],zmm0[11],zmm1[12],zmm0[12],zmm1[13],zmm0[13],zmm1[14],zmm0[14],zmm1[15],zmm0[15],zmm1[24],zmm0[24],zmm1[25],zmm0[25],zmm1[26],zmm0[26],zmm1[27],zmm0[27],zmm1[28],zmm0[28],zmm1[29],zmm0[29],zmm1[30],zmm0[30],zmm1[31],zmm0[31],zmm1[40],zmm0[40],zmm1[41],zmm0[41],zmm1[42],zmm0[42],zmm1[43],zmm0[43],zmm1[44],zmm0[44],zmm1[45],zmm0[45],zmm1[46],zmm0[46],zmm1[47],zmm0[47],zmm1[56],zmm0[56],zmm1[57],zmm0[57],zmm1[58],zmm0[58],zmm1[59],zmm0[59],zmm1[60],zmm0[60],zmm1[61],zmm0[61],zmm1[62],zmm0[62],zmm1[63],zmm0[63]
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm3, %zmm3
; AVX512BW-NEXT:    vpandq %zmm2, %zmm3, %zmm3
; AVX512BW-NEXT:    vpunpcklbw {{.*#+}} zmm1 = zmm1[0],zmm0[0],zmm1[1],zmm0[1],zmm1[2],zmm0[2],zmm1[3],zmm0[3],zmm1[4],zmm0[4],zmm1[5],zmm0[5],zmm1[6],zmm0[6],zmm1[7],zmm0[7],zmm1[16],zmm0[16],zmm1[17],zmm0[17],zmm1[18],zmm0[18],zmm1[19],zmm0[19],zmm1[20],zmm0[20],zmm1[21],zmm0[21],zmm1[22],zmm0[22],zmm1[23],zmm0[23],zmm1[32],zmm0[32],zmm1[33],zmm0[33],zmm1[34],zmm0[34],zmm1[35],zmm0[35],zmm1[36],zmm0[36],zmm1[37],zmm0[37],zmm1[38],zmm0[38],zmm1[39],zmm0[39],zmm1[48],zmm0[48],zmm1[49],zmm0[49],zmm1[50],zmm0[50],zmm1[51],zmm0[51],zmm1[52],zmm0[52],zmm1[53],zmm0[53],zmm1[54],zmm0[54],zmm1[55],zmm0[55]
; AVX512BW-NEXT:    vpmullw {{.*}}(%rip), %zmm1, %zmm1
; AVX512BW-NEXT:    vpandq %zmm2, %zmm1, %zmm1
; AVX512BW-NEXT:    vpackuswb %zmm3, %zmm1, %zmm1
; AVX512BW-NEXT:    vpsubb %zmm1, %zmm0, %zmm0
; AVX512BW-NEXT:    retq
  %res = srem <64 x i8> %a, <i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15, i8 16, i8 17, i8 18, i8 19, i8 20, i8 21, i8 22, i8 23, i8 24, i8 25, i8 26, i8 27, i8 28, i8 29, i8 30, i8 31, i8 32, i8 33, i8 34, i8 35, i8 36, i8 37, i8 38, i8 38, i8 37, i8 36, i8 35, i8 34, i8 33, i8 32, i8 31, i8 30, i8 29, i8 28, i8 27, i8 26, i8 25, i8 24, i8 23, i8 22, i8 21, i8 20, i8 19, i8 18, i8 17, i8 16, i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7>
  ret <64 x i8> %res
}
