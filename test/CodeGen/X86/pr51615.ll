; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefixes=ALL,AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=ALL,AVX2

; https://bugs.llvm.org/show_bug.cgi?id=51615
; We can not replace a wide volatile load with a broadcast-from-memory,
; because that would narrow the load, which isn't legal for volatiles.

@g0 = external dso_local global <2 x double>, align 16
define void @volatile_load_2_elts() {
; AVX-LABEL: volatile_load_2_elts:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps g0(%rip), %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm1
; AVX-NEXT:    vpermilpd {{.*#+}} ymm1 = ymm1[0,0,3,2]
; AVX-NEXT:    vxorpd %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vblendpd {{.*#+}} ymm1 = ymm2[0,1],ymm1[2],ymm2[3]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vblendpd {{.*#+}} ymm0 = ymm2[0],ymm0[1],ymm2[2],ymm0[3]
; AVX-NEXT:    vmovapd %ymm0, (%rax)
; AVX-NEXT:    vmovapd %ymm1, (%rax)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX2-LABEL: volatile_load_2_elts:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps g0(%rip), %xmm0
; AVX2-NEXT:    vbroadcastsd %xmm0, %ymm0
; AVX2-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vblendps {{.*#+}} ymm2 = ymm1[0,1,2,3],ymm0[4,5],ymm1[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1],ymm0[2,3],ymm1[4,5],ymm0[6,7]
; AVX2-NEXT:    vmovaps %ymm0, (%rax)
; AVX2-NEXT:    vmovaps %ymm2, (%rax)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %i = load volatile <2 x double>, <2 x double>* @g0, align 16
  %i1 = shufflevector <2 x double> %i, <2 x double> poison, <4 x i32> <i32 undef, i32 0, i32 undef, i32 0>
  %shuffle1 = shufflevector <4 x double> %i1, <4 x double> zeroinitializer, <8 x i32> <i32 6, i32 7, i32 3, i32 6, i32 7, i32 1, i32 7, i32 1>
  store volatile <8 x double> %shuffle1, <8 x double>* undef, align 64
  ret void
}

@g1 = external dso_local global <1 x double>, align 16
define void @volatile_load_1_elt() {
; ALL-LABEL: volatile_load_1_elt:
; ALL:       # %bb.0:
; ALL-NEXT:    vbroadcastsd g1(%rip), %ymm0
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vblendps {{.*#+}} ymm2 = ymm1[0,1,2,3],ymm0[4,5],ymm1[6,7]
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1],ymm0[2,3],ymm1[4,5],ymm0[6,7]
; ALL-NEXT:    vmovaps %ymm0, (%rax)
; ALL-NEXT:    vmovaps %ymm2, (%rax)
; ALL-NEXT:    vzeroupper
; ALL-NEXT:    retq
  %i = load volatile <1 x double>, <1 x double>* @g1, align 16
  %i1 = shufflevector <1 x double> %i, <1 x double> poison, <4 x i32> <i32 undef, i32 0, i32 undef, i32 0>
  %shuffle1 = shufflevector <4 x double> %i1, <4 x double> zeroinitializer, <8 x i32> <i32 6, i32 7, i32 3, i32 6, i32 7, i32 1, i32 7, i32 1>
  store volatile <8 x double> %shuffle1, <8 x double>* undef, align 64
  ret void
}

@g2 = external dso_local global <2 x float>, align 16
define void @volatile_load_2_elts_bitcast() {
; ALL-LABEL: volatile_load_2_elts_bitcast:
; ALL:       # %bb.0:
; ALL-NEXT:    vbroadcastsd g2(%rip), %ymm0
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vblendps {{.*#+}} ymm2 = ymm1[0,1,2,3],ymm0[4,5],ymm1[6,7]
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1],ymm0[2,3],ymm1[4,5],ymm0[6,7]
; ALL-NEXT:    vmovaps %ymm0, (%rax)
; ALL-NEXT:    vmovaps %ymm2, (%rax)
; ALL-NEXT:    vzeroupper
; ALL-NEXT:    retq
  %i0 = load volatile <2 x float>, <2 x float>* @g2, align 16
  %i = bitcast <2 x float> %i0 to <1 x double>
  %i1 = shufflevector <1 x double> %i, <1 x double> poison, <4 x i32> <i32 undef, i32 0, i32 undef, i32 0>
  %shuffle1 = shufflevector <4 x double> %i1, <4 x double> zeroinitializer, <8 x i32> <i32 6, i32 7, i32 3, i32 6, i32 7, i32 1, i32 7, i32 1>
  store volatile <8 x double> %shuffle1, <8 x double>* undef, align 64
  ret void
}

define void @elts_from_consecutive_loads(<2 x i64>* %arg, i32* %arg12, <8 x i32>* %arg13, float %arg14, i1 %arg15) {
; AVX-LABEL: elts_from_consecutive_loads:
; AVX:       # %bb.0: # %bb
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    .p2align 4, 0x90
; AVX-NEXT:  .LBB3_1: # %bb16
; AVX-NEXT:    # =>This Loop Header: Depth=1
; AVX-NEXT:    # Child Loop BB3_2 Depth 2
; AVX-NEXT:    testb $1, %cl
; AVX-NEXT:    je .LBB3_1
; AVX-NEXT:    .p2align 4, 0x90
; AVX-NEXT:  .LBB3_2: # %bb17
; AVX-NEXT:    # Parent Loop BB3_1 Depth=1
; AVX-NEXT:    # => This Inner Loop Header: Depth=2
; AVX-NEXT:    movl (%rdi), %eax
; AVX-NEXT:    vbroadcastss (%rdi), %ymm2
; AVX-NEXT:    movl %eax, (%rsi)
; AVX-NEXT:    vmovaps %ymm2, (%rdx)
; AVX-NEXT:    vucomiss %xmm1, %xmm0
; AVX-NEXT:    jne .LBB3_2
; AVX-NEXT:    jp .LBB3_2
; AVX-NEXT:    jmp .LBB3_1
;
; AVX2-LABEL: elts_from_consecutive_loads:
; AVX2:       # %bb.0: # %bb
; AVX2-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB3_1: # %bb16
; AVX2-NEXT:    # =>This Loop Header: Depth=1
; AVX2-NEXT:    # Child Loop BB3_2 Depth 2
; AVX2-NEXT:    testb $1, %cl
; AVX2-NEXT:    je .LBB3_1
; AVX2-NEXT:    .p2align 4, 0x90
; AVX2-NEXT:  .LBB3_2: # %bb17
; AVX2-NEXT:    # Parent Loop BB3_1 Depth=1
; AVX2-NEXT:    # => This Inner Loop Header: Depth=2
; AVX2-NEXT:    vmovaps (%rdi), %xmm2
; AVX2-NEXT:    vmovss %xmm2, (%rsi)
; AVX2-NEXT:    vbroadcastss %xmm2, %ymm2
; AVX2-NEXT:    vmovaps %ymm2, (%rdx)
; AVX2-NEXT:    vucomiss %xmm1, %xmm0
; AVX2-NEXT:    jne .LBB3_2
; AVX2-NEXT:    jp .LBB3_2
; AVX2-NEXT:    jmp .LBB3_1
bb:
  br label %bb16

bb16:                                             ; preds = %bb17, %bb16, %bb
  br i1 %arg15, label %bb17, label %bb16

bb17:                                             ; preds = %bb17, %bb16
  %tmp = load <2 x i64>, <2 x i64>* %arg, align 16
  %tmp18 = extractelement <2 x i64> %tmp, i32 0
  %tmp19 = trunc i64 %tmp18 to i32
  store i32 %tmp19, i32* %arg12, align 4
  %tmp20 = insertelement <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, i32 %tmp19, i32 0
  %tmp21 = shufflevector <8 x i32> %tmp20, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, <8 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 0, i32 undef, i32 undef, i32 undef>
  store <8 x i32> %tmp21, <8 x i32>* %arg13, align 32
  %tmp22 = fcmp une float %arg14, 0.000000e+00
  br i1 %tmp22, label %bb17, label %bb16
}
