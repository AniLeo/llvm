; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx,+slow-unaligned-mem-32 | FileCheck %s --check-prefix=AVXSLOW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx,-slow-unaligned-mem-32 | FileCheck %s --check-prefix=AVXFAST
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 | FileCheck %s --check-prefix=AVX2

; Don't generate an unaligned 32-byte load on this test if that is slower than two 16-byte loads.

define <8 x float> @load32bytes(ptr %Ap) {
; AVXSLOW-LABEL: load32bytes:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vmovaps (%rdi), %xmm0
; AVXSLOW-NEXT:    vinsertf128 $1, 16(%rdi), %ymm0, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: load32bytes:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vmovups (%rdi), %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: load32bytes:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovups (%rdi), %ymm0
; AVX2-NEXT:    retq
  %A = load <8 x float>, ptr %Ap, align 16
  ret <8 x float> %A
}

; Don't generate an unaligned 32-byte store on this test if that is slower than two 16-byte loads.

define void @store32bytes(<8 x float> %A, ptr %P) {
; AVXSLOW-LABEL: store32bytes:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vextractf128 $1, %ymm0, 16(%rdi)
; AVXSLOW-NEXT:    vmovaps %xmm0, (%rdi)
; AVXSLOW-NEXT:    vzeroupper
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: store32bytes:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vmovups %ymm0, (%rdi)
; AVXFAST-NEXT:    vzeroupper
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: store32bytes:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovups %ymm0, (%rdi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  store <8 x float> %A, ptr %P, align 16
  ret void
}

; Merge two consecutive 16-byte subvector loads into a single 32-byte load if it's faster.

define <8 x float> @combine_16_byte_loads_no_intrinsic(ptr %ptr) {
; AVXSLOW-LABEL: combine_16_byte_loads_no_intrinsic:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vmovups 48(%rdi), %xmm0
; AVXSLOW-NEXT:    vinsertf128 $1, 64(%rdi), %ymm0, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_no_intrinsic:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vmovups 48(%rdi), %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_no_intrinsic:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovups 48(%rdi), %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <4 x float>, ptr %ptr, i64 3
  %ptr2 = getelementptr inbounds <4 x float>, ptr %ptr, i64 4
  %v1 = load <4 x float>, ptr %ptr1, align 1
  %v2 = load <4 x float>, ptr %ptr2, align 1
  %v3 = shufflevector <4 x float> %v1, <4 x float> %v2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %v3
}

; If the first load is 32-byte aligned, then the loads should be merged in all cases.

define <8 x float> @combine_16_byte_loads_aligned(ptr %ptr) {
; AVXSLOW-LABEL: combine_16_byte_loads_aligned:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vmovaps 48(%rdi), %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_aligned:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vmovaps 48(%rdi), %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_aligned:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps 48(%rdi), %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <4 x float>, ptr %ptr, i64 3
  %ptr2 = getelementptr inbounds <4 x float>, ptr %ptr, i64 4
  %v1 = load <4 x float>, ptr %ptr1, align 32
  %v2 = load <4 x float>, ptr %ptr2, align 1
  %v3 = shufflevector <4 x float> %v1, <4 x float> %v2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %v3
}

; Swap the order of the shufflevector operands to ensure that the pattern still matches.

define <8 x float> @combine_16_byte_loads_no_intrinsic_swap(ptr %ptr) {
; AVXSLOW-LABEL: combine_16_byte_loads_no_intrinsic_swap:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vmovups 64(%rdi), %xmm0
; AVXSLOW-NEXT:    vinsertf128 $1, 80(%rdi), %ymm0, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_no_intrinsic_swap:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vmovups 64(%rdi), %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_no_intrinsic_swap:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovups 64(%rdi), %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <4 x float>, ptr %ptr, i64 4
  %ptr2 = getelementptr inbounds <4 x float>, ptr %ptr, i64 5
  %v1 = load <4 x float>, ptr %ptr1, align 1
  %v2 = load <4 x float>, ptr %ptr2, align 1
  %v3 = shufflevector <4 x float> %v2, <4 x float> %v1, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3>
  ret <8 x float> %v3
}

; Check each element type other than float to make sure it is handled correctly.
; Use the loaded values with an 'add' to make sure we're using the correct load type.
; Don't generate 32-byte loads for integer ops unless we have AVX2.

define <4 x i64> @combine_16_byte_loads_i64(ptr %ptr, <4 x i64> %x) {
; AVXSLOW-LABEL: combine_16_byte_loads_i64:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXSLOW-NEXT:    vpaddq 96(%rdi), %xmm1, %xmm1
; AVXSLOW-NEXT:    vpaddq 80(%rdi), %xmm0, %xmm0
; AVXSLOW-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_i64:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXFAST-NEXT:    vpaddq 96(%rdi), %xmm1, %xmm1
; AVXFAST-NEXT:    vpaddq 80(%rdi), %xmm0, %xmm0
; AVXFAST-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddq 80(%rdi), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <2 x i64>, ptr %ptr, i64 5
  %ptr2 = getelementptr inbounds <2 x i64>, ptr %ptr, i64 6
  %v1 = load <2 x i64>, ptr %ptr1, align 1
  %v2 = load <2 x i64>, ptr %ptr2, align 1
  %v3 = shufflevector <2 x i64> %v1, <2 x i64> %v2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v4 = add <4 x i64> %v3, %x
  ret <4 x i64> %v4
}

define <8 x i32> @combine_16_byte_loads_i32(ptr %ptr, <8 x i32> %x) {
; AVXSLOW-LABEL: combine_16_byte_loads_i32:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXSLOW-NEXT:    vpaddd 112(%rdi), %xmm1, %xmm1
; AVXSLOW-NEXT:    vpaddd 96(%rdi), %xmm0, %xmm0
; AVXSLOW-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_i32:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXFAST-NEXT:    vpaddd 112(%rdi), %xmm1, %xmm1
; AVXFAST-NEXT:    vpaddd 96(%rdi), %xmm0, %xmm0
; AVXFAST-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddd 96(%rdi), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <4 x i32>, ptr %ptr, i64 6
  %ptr2 = getelementptr inbounds <4 x i32>, ptr %ptr, i64 7
  %v1 = load <4 x i32>, ptr %ptr1, align 1
  %v2 = load <4 x i32>, ptr %ptr2, align 1
  %v3 = shufflevector <4 x i32> %v1, <4 x i32> %v2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %v4 = add <8 x i32> %v3, %x
  ret <8 x i32> %v4
}

define <16 x i16> @combine_16_byte_loads_i16(ptr %ptr, <16 x i16> %x) {
; AVXSLOW-LABEL: combine_16_byte_loads_i16:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXSLOW-NEXT:    vpaddw 128(%rdi), %xmm1, %xmm1
; AVXSLOW-NEXT:    vpaddw 112(%rdi), %xmm0, %xmm0
; AVXSLOW-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_i16:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXFAST-NEXT:    vpaddw 128(%rdi), %xmm1, %xmm1
; AVXFAST-NEXT:    vpaddw 112(%rdi), %xmm0, %xmm0
; AVXFAST-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddw 112(%rdi), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <8 x i16>, ptr %ptr, i64 7
  %ptr2 = getelementptr inbounds <8 x i16>, ptr %ptr, i64 8
  %v1 = load <8 x i16>, ptr %ptr1, align 1
  %v2 = load <8 x i16>, ptr %ptr2, align 1
  %v3 = shufflevector <8 x i16> %v1, <8 x i16> %v2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v4 = add <16 x i16> %v3, %x
  ret <16 x i16> %v4
}

define <32 x i8> @combine_16_byte_loads_i8(ptr %ptr, <32 x i8> %x) {
; AVXSLOW-LABEL: combine_16_byte_loads_i8:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXSLOW-NEXT:    vpaddb 144(%rdi), %xmm1, %xmm1
; AVXSLOW-NEXT:    vpaddb 128(%rdi), %xmm0, %xmm0
; AVXSLOW-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_i8:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVXFAST-NEXT:    vpaddb 144(%rdi), %xmm1, %xmm1
; AVXFAST-NEXT:    vpaddb 128(%rdi), %xmm0, %xmm0
; AVXFAST-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddb 128(%rdi), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <16 x i8>, ptr %ptr, i64 8
  %ptr2 = getelementptr inbounds <16 x i8>, ptr %ptr, i64 9
  %v1 = load <16 x i8>, ptr %ptr1, align 1
  %v2 = load <16 x i8>, ptr %ptr2, align 1
  %v3 = shufflevector <16 x i8> %v1, <16 x i8> %v2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %v4 = add <32 x i8> %v3, %x
  ret <32 x i8> %v4
}

define <4 x double> @combine_16_byte_loads_double(ptr %ptr, <4 x double> %x) {
; AVXSLOW-LABEL: combine_16_byte_loads_double:
; AVXSLOW:       # %bb.0:
; AVXSLOW-NEXT:    vmovups 144(%rdi), %xmm1
; AVXSLOW-NEXT:    vinsertf128 $1, 160(%rdi), %ymm1, %ymm1
; AVXSLOW-NEXT:    vaddpd %ymm0, %ymm1, %ymm0
; AVXSLOW-NEXT:    retq
;
; AVXFAST-LABEL: combine_16_byte_loads_double:
; AVXFAST:       # %bb.0:
; AVXFAST-NEXT:    vaddpd 144(%rdi), %ymm0, %ymm0
; AVXFAST-NEXT:    retq
;
; AVX2-LABEL: combine_16_byte_loads_double:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vaddpd 144(%rdi), %ymm0, %ymm0
; AVX2-NEXT:    retq
  %ptr1 = getelementptr inbounds <2 x double>, ptr %ptr, i64 9
  %ptr2 = getelementptr inbounds <2 x double>, ptr %ptr, i64 10
  %v1 = load <2 x double>, ptr %ptr1, align 1
  %v2 = load <2 x double>, ptr %ptr2, align 1
  %v3 = shufflevector <2 x double> %v1, <2 x double> %v2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %v4 = fadd <4 x double> %v3, %x
  ret <4 x double> %v4
}

