; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --no_x86_scrub_mem_shuffle
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx -disable-peephole | FileCheck %s --check-prefixes=ALL,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 -disable-peephole | FileCheck %s --check-prefixes=ALL,AVX2

define <8 x float> @shuffle_v8f32_45670123(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8f32_45670123:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8f32_45670123:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,0,1]
; AVX2-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_45670123_mem(ptr %pa, ptr %pb) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8f32_45670123_mem:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 $35, (%rdi), %ymm0, %ymm0 # ymm0 = mem[2,3,0,1]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8f32_45670123_mem:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd $78, (%rdi), %ymm0 # ymm0 = mem[2,3,0,1]
; AVX2-NEXT:    retq
entry:
  %a = load <8 x float>, ptr %pa
  %b = load <8 x float>, ptr %pb
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_0123cdef(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_0123cdef:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm1[4,5,6,7]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_01230123(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8f32_01230123:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8f32_01230123:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,1,0,1]
; AVX2-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_01230123_mem(ptr %pa, ptr %pb) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_01230123_mem:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vbroadcastf128 (%rdi), %ymm0 # ymm0 = mem[0,1,0,1]
; ALL-NEXT:    retq
entry:
  %a = load <8 x float>, ptr %pa
  %b = load <8 x float>, ptr %pb
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_45674567(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8f32_45674567:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8f32_45674567:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX2-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_45674567_mem(ptr %pa, ptr %pb) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_45674567_mem:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vbroadcastf128 16(%rdi), %ymm0 # ymm0 = mem[0,1,0,1]
; ALL-NEXT:    retq
entry:
  %a = load <8 x float>, ptr %pa
  %b = load <8 x float>, ptr %pb
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %shuffle
}

define <32 x i8> @shuffle_v32i8_2323(<32 x i8> %a, <32 x i8> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v32i8_2323:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v32i8_2323:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX2-NEXT:    retq
entry:
  %shuffle = shufflevector <32 x i8> %a, <32 x i8> %b, <32 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <32 x i8> %shuffle
}

define <32 x i8> @shuffle_v32i8_2323_domain(<32 x i8> %a, <32 x i8> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v32i8_2323_domain:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v32i8_2323_domain:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpsubb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  ; add forces execution domain
  %a2 = add <32 x i8> %a, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %shuffle = shufflevector <32 x i8> %a2, <32 x i8> %b, <32 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <32 x i8> %shuffle
}

define <4 x i64> @shuffle_v4i64_6701(<4 x i64> %a, <4 x i64> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v4i64_6701:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm1[2,3],ymm0[0,1]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <4 x i64> %a, <4 x i64> %b, <4 x i32> <i32 6, i32 7, i32 0, i32 1>
  ret <4 x i64> %shuffle
}

define <4 x i64> @shuffle_v4i64_6701_domain(<4 x i64> %a, <4 x i64> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v4i64_6701_domain:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm1[2,3],ymm0[0,1]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v4i64_6701_domain:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm2, %ymm2
; AVX2-NEXT:    vpsubq %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm1[2,3],ymm0[0,1]
; AVX2-NEXT:    retq
entry:
  ; add forces execution domain
  %a2 = add <4 x i64> %a, <i64 1, i64 1, i64 1, i64 1>
  %shuffle = shufflevector <4 x i64> %a2, <4 x i64> %b, <4 x i32> <i32 6, i32 7, i32 0, i32 1>
  ret <4 x i64> %shuffle
}

define <8 x i32> @shuffle_v8i32_u5u7cdef(<8 x i32> %a, <8 x i32> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8i32_u5u7cdef:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpsubd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[2,3]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8i32_u5u7cdef:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm2, %ymm2
; AVX2-NEXT:    vpsubd %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[2,3]
; AVX2-NEXT:    retq
entry:
  ; add forces execution domain
  %a2 = add <8 x i32> %a, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %shuffle = shufflevector <8 x i32> %a2, <8 x i32> %b, <8 x i32> <i32 undef, i32 5, i32 undef, i32 7, i32 12, i32 13, i32 14, i32 15>
  ret <8 x i32> %shuffle
}

define <16 x i16> @shuffle_v16i16_4501(<16 x i16> %a, <16 x i16> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v16i16_4501:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpsubw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v16i16_4501:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpcmpeqd %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpsubw %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
entry:
  ; add forces execution domain
  %a2 = add <16 x i16> %a, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %shuffle = shufflevector <16 x i16> %a2, <16 x i16> %b, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <16 x i16> %shuffle
}

define <16 x i16> @shuffle_v16i16_4501_mem(ptr %a, ptr %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v16i16_4501_mem:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovdqa (%rdi), %xmm0
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpsubw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vperm2f128 $2, (%rsi), %ymm0, %ymm0 # ymm0 = mem[0,1],ymm0[0,1]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v16i16_4501_mem:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm1, %ymm1
; AVX2-NEXT:    vpsubw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vperm2i128 $2, (%rsi), %ymm0, %ymm0 # ymm0 = mem[0,1],ymm0[0,1]
; AVX2-NEXT:    retq
entry:
  %c = load <16 x i16>, ptr %a
  %d = load <16 x i16>, ptr %b
  %c2 = add <16 x i16> %c, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %shuffle = shufflevector <16 x i16> %c2, <16 x i16> %d, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <16 x i16> %shuffle
}

;;;; Cases with undef indicies mixed in the mask

define <8 x float> @shuffle_v8f32_uu67u9ub(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_uu67u9ub:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[0,1]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 undef, i32 undef, i32 6, i32 7, i32 undef, i32 9, i32 undef, i32 11>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_uu67uu67(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8f32_uu67uu67:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8f32_uu67uu67:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[3,3,3,3]
; AVX2-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 undef, i32 undef, i32 6, i32 7, i32 undef, i32 undef, i32 6, i32 7>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_uu67uuab(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_uu67uuab:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[0,1]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 undef, i32 undef, i32 6, i32 7, i32 undef, i32 undef, i32 10, i32 11>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_uu67uuef(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_uu67uuef:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[2,3]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 undef, i32 undef, i32 6, i32 7, i32 undef, i32 undef, i32 14, i32 15>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_uu674567(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8f32_uu674567:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8f32_uu674567:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,3,2,3]
; AVX2-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 undef, i32 undef, i32 6, i32 7, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_uu6789ab(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_uu6789ab:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[0,1]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 undef, i32 undef, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_4567uu67(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: shuffle_v8f32_4567uu67:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8f32_4567uu67:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[2,3,2,3]
; AVX2-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 6, i32 7>
  ret <8 x float> %shuffle
}

define <8 x float> @shuffle_v8f32_4567uuef(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_4567uuef:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[2,3]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 14, i32 15>
  ret <8 x float> %shuffle
}

;;;; Cases we must not select vperm2f128

define <8 x float> @shuffle_v8f32_uu67ucuf(<8 x float> %a, <8 x float> %b) nounwind uwtable readnone ssp {
; ALL-LABEL: shuffle_v8f32_uu67ucuf:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[2,3]
; ALL-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,0,2,3,4,4,6,7]
; ALL-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 undef, i32 undef, i32 6, i32 7, i32 undef, i32 12, i32 undef, i32 15>
  ret <8 x float> %shuffle
}

;; Test zero mask generation.
;; PR22984: https://llvm.org/bugs/show_bug.cgi?id=22984
;; Prefer xor+vblendpd over vperm2f128 because that has better performance,
;; unless building for optsize where we should still use vperm2f128.

define <4 x double> @shuffle_v4f64_zz01(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_zz01:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[0,1]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_zz01_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_zz01_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[0,1]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
  ret <4 x double> %s
}

define <4 x double> @shuffle_v4f64_zz23(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_zz23:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 4, i32 5, i32 2, i32 3>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_zz23_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_zz23_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[2,3]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 4, i32 5, i32 2, i32 3>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_zz23_pgso(<4 x double> %a) !prof !14 {
; ALL-LABEL: shuffle_v4f64_zz23_pgso:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[2,3]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 4, i32 5, i32 2, i32 3>
  ret <4 x double> %s
}

define <4 x double> @shuffle_v4f64_zz45(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_zz45:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[0,1]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_zz45_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_zz45_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[0,1]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %s
}

define <4 x double> @shuffle_v4f64_zz67(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_zz67:
; ALL:       # %bb.0:
; ALL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; ALL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_zz67_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_zz67_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[2,3]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_zz67_pgso(<4 x double> %a) !prof !14 {
; ALL-LABEL: shuffle_v4f64_zz67_pgso:
; ALL:       # %bb.0:
; ALL-NEXT:    vperm2f128 {{.*#+}} ymm0 = zero,zero,ymm0[2,3]
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  ret <4 x double> %s
}

define <4 x double> @shuffle_v4f64_01zz(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_01zz:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps %xmm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_01zz_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_01zz_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps %xmm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %s
}

define <4 x double> @shuffle_v4f64_23zz(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_23zz:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_23zz_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_23zz_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> %a, <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %s
}

define <4 x double> @shuffle_v4f64_45zz(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_45zz:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps %xmm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_45zz_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_45zz_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps %xmm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 4, i32 5, i32 0, i32 1>
  ret <4 x double> %s
}

define <4 x double> @shuffle_v4f64_67zz(<4 x double> %a) {
; ALL-LABEL: shuffle_v4f64_67zz:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 6, i32 7, i32 0, i32 1>
  ret <4 x double> %s
}
define <4 x double> @shuffle_v4f64_67zz_optsize(<4 x double> %a) optsize {
; ALL-LABEL: shuffle_v4f64_67zz_optsize:
; ALL:       # %bb.0:
; ALL-NEXT:    vextractf128 $1, %ymm0, %xmm0
; ALL-NEXT:    retq
  %s = shufflevector <4 x double> <double 0.0, double 0.0, double undef, double undef>, <4 x double> %a, <4 x i32> <i32 6, i32 7, i32 0, i32 1>
  ret <4 x double> %s
}

;; With AVX2 select the integer version of the instruction. Use an add to force the domain selection.

define <4 x i64> @shuffle_v4i64_67zz(<4 x i64> %a, <4 x i64> %b) {
; AVX1-LABEL: shuffle_v4i64_67zz:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm1[4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v4i64_67zz:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm0
; AVX2-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
  %s = shufflevector <4 x i64> <i64 0, i64 0, i64 undef, i64 undef>, <4 x i64> %a, <4 x i32> <i32 6, i32 7, i32 0, i32 1>
  %c = add <4 x i64> %b, %s
  ret <4 x i64> %c
}

;;; Memory folding cases

define <4 x double> @ld0_hi0_lo1_4f64(ptr %pa, <4 x double> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld0_hi0_lo1_4f64:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 $3, (%rdi), %ymm0, %ymm0 # ymm0 = mem[2,3],ymm0[0,1]
; AVX1-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld0_hi0_lo1_4f64:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2f128 $3, (%rdi), %ymm0, %ymm0 # ymm0 = mem[2,3],ymm0[0,1]
; AVX2-NEXT:    vbroadcastsd {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX2-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %a = load <4 x double>, ptr %pa
  %shuffle = shufflevector <4 x double> %a, <4 x double> %b, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  %res = fadd <4 x double> %shuffle, <double 1.0, double 1.0, double 1.0, double 1.0>
  ret <4 x double> %res
}

define <4 x double> @ld1_hi0_hi1_4f64(<4 x double> %a, ptr %pb) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld1_hi0_hi1_4f64:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 $49, (%rdi), %ymm0, %ymm0 # ymm0 = ymm0[2,3],mem[2,3]
; AVX1-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld1_hi0_hi1_4f64:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2f128 $49, (%rdi), %ymm0, %ymm0 # ymm0 = ymm0[2,3],mem[2,3]
; AVX2-NEXT:    vbroadcastsd {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX2-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %b = load <4 x double>, ptr %pb
  %shuffle = shufflevector <4 x double> %a, <4 x double> %b, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  %res = fadd <4 x double> %shuffle, <double 1.0, double 1.0, double 1.0, double 1.0>
  ret <4 x double> %res
}

define <8 x float> @ld0_hi0_lo1_8f32(ptr %pa, <8 x float> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld0_hi0_lo1_8f32:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 $3, (%rdi), %ymm0, %ymm0 # ymm0 = mem[2,3],ymm0[0,1]
; AVX1-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld0_hi0_lo1_8f32:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2f128 $3, (%rdi), %ymm0, %ymm0 # ymm0 = mem[2,3],ymm0[0,1]
; AVX2-NEXT:    vbroadcastss {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX2-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %a = load <8 x float>, ptr %pa
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
  %res = fadd <8 x float> %shuffle, <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>
  ret <8 x float> %res
}

define <8 x float> @ld1_hi0_hi1_8f32(<8 x float> %a, ptr %pb) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld1_hi0_hi1_8f32:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vperm2f128 $49, (%rdi), %ymm0, %ymm0 # ymm0 = ymm0[2,3],mem[2,3]
; AVX1-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld1_hi0_hi1_8f32:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2f128 $49, (%rdi), %ymm0, %ymm0 # ymm0 = ymm0[2,3],mem[2,3]
; AVX2-NEXT:    vbroadcastss {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX2-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %b = load <8 x float>, ptr %pb
  %shuffle = shufflevector <8 x float> %a, <8 x float> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  %res = fadd <8 x float> %shuffle, <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>
  ret <8 x float> %res
}

define <4 x i64> @ld0_hi0_lo1_4i64(ptr %pa, <4 x i64> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld0_hi0_lo1_4i64:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld0_hi0_lo1_4i64:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2i128 $3, (%rdi), %ymm0, %ymm0 # ymm0 = mem[2,3],ymm0[0,1]
; AVX2-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %a = load <4 x i64>, ptr %pa
  %shuffle = shufflevector <4 x i64> %a, <4 x i64> %b, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  %res = add <4 x i64> %shuffle, <i64 1, i64 2, i64 3, i64 4>
  ret <4 x i64> %res
}

define <4 x i64> @ld1_hi0_hi1_4i64(<4 x i64> %a, ptr %pb) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld1_hi0_hi1_4i64:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vmovdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld1_hi0_hi1_4i64:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2i128 $49, (%rdi), %ymm0, %ymm0 # ymm0 = ymm0[2,3],mem[2,3]
; AVX2-NEXT:    vpaddq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %b = load <4 x i64>, ptr %pb
  %shuffle = shufflevector <4 x i64> %a, <4 x i64> %b, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  %res = add <4 x i64> %shuffle, <i64 1, i64 2, i64 3, i64 4>
  ret <4 x i64> %res
}

define <8 x i32> @ld0_hi0_lo1_8i32(ptr %pa, <8 x i32> %b) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld0_hi0_lo1_8i32:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [1,2,3,4]
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpaddd 16(%rdi), %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld0_hi0_lo1_8i32:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2i128 $3, (%rdi), %ymm0, %ymm0 # ymm0 = mem[2,3],ymm0[0,1]
; AVX2-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %a = load <8 x i32>, ptr %pa
  %shuffle = shufflevector <8 x i32> %a, <8 x i32> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
  %res = add <8 x i32> %shuffle, <i32 1, i32 2, i32 3, i32 4, i32 1, i32 2, i32 3, i32 4>
  ret <8 x i32> %res
}

define <8 x i32> @ld1_hi0_hi1_8i32(<8 x i32> %a, ptr %pb) nounwind uwtable readnone ssp {
; AVX1-LABEL: ld1_hi0_hi1_8i32:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [1,2,3,4]
; AVX1-NEXT:    vpaddd 16(%rdi), %xmm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ld1_hi0_hi1_8i32:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vperm2i128 $49, (%rdi), %ymm0, %ymm0 # ymm0 = ymm0[2,3],mem[2,3]
; AVX2-NEXT:    vpaddd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; AVX2-NEXT:    retq
entry:
  %b = load <8 x i32>, ptr %pb
  %shuffle = shufflevector <8 x i32> %a, <8 x i32> %b, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  %res = add <8 x i32> %shuffle, <i32 1, i32 2, i32 3, i32 4, i32 1, i32 2, i32 3, i32 4>
  ret <8 x i32> %res
}

define void @PR50053(ptr nocapture %0, ptr nocapture readonly %1) {
; ALL-LABEL: PR50053:
; ALL:       # %bb.0:
; ALL-NEXT:    vmovaps (%rsi), %ymm0
; ALL-NEXT:    vinsertf128 $1, 32(%rsi), %ymm0, %ymm1
; ALL-NEXT:    vinsertf128 $0, 48(%rsi), %ymm0, %ymm0
; ALL-NEXT:    vmovaps %ymm1, (%rdi)
; ALL-NEXT:    vmovaps %ymm0, 32(%rdi)
; ALL-NEXT:    vzeroupper
; ALL-NEXT:    retq
  %3 = load <4 x i64>, ptr %1, align 32
  %4 = getelementptr inbounds <4 x i64>, ptr %1, i64 1
  %5 = load <2 x i64>, ptr %4, align 16
  %6 = getelementptr inbounds <2 x i64>, ptr %4, i64 1
  %7 = load <2 x i64>, ptr %6, align 16
  %8 = shufflevector <2 x i64> %5, <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %9 = shufflevector <4 x i64> %3, <4 x i64> %8, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  store <4 x i64> %9, ptr %0, align 32
  %10 = shufflevector <2 x i64> %7, <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %11 = shufflevector <4 x i64> %10, <4 x i64> %3, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %12 = getelementptr inbounds <4 x i64>, ptr %0, i64 1
  store <4 x i64> %11, ptr %12, align 32
  ret void
}

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"ProfileSummary", !1}
!1 = !{!2, !3, !4, !5, !6, !7, !8, !9}
!2 = !{!"ProfileFormat", !"InstrProf"}
!3 = !{!"TotalCount", i64 10000}
!4 = !{!"MaxCount", i64 10}
!5 = !{!"MaxInternalCount", i64 1}
!6 = !{!"MaxFunctionCount", i64 1000}
!7 = !{!"NumCounts", i64 3}
!8 = !{!"NumFunctions", i64 3}
!9 = !{!"DetailedSummary", !10}
!10 = !{!11, !12, !13}
!11 = !{i32 10000, i64 100, i32 1}
!12 = !{i32 999000, i64 100, i32 1}
!13 = !{i32 999999, i64 1, i32 2}
!14 = !{!"function_entry_count", i64 0}
