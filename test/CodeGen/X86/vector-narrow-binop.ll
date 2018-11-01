; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512dq | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512DQ

; AVX1 has support for 256-bit bitwise logic because the FP variants were included.
; If using those ops requires extra insert/extract though, it's probably not worth it.

define <8 x i32> @PR32790(<8 x i32> %a, <8 x i32> %b, <8 x i32> %c, <8 x i32> %d) {
; SSE-LABEL: PR32790:
; SSE:       # %bb.0:
; SSE-NEXT:    paddd %xmm2, %xmm0
; SSE-NEXT:    paddd %xmm3, %xmm1
; SSE-NEXT:    pand %xmm5, %xmm1
; SSE-NEXT:    pand %xmm4, %xmm0
; SSE-NEXT:    psubd %xmm6, %xmm0
; SSE-NEXT:    psubd %xmm7, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: PR32790:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm1
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm4, %xmm1
; AVX1-NEXT:    vpsubd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: PR32790:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsubd %ymm3, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: PR32790:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX512-NEXT:    vpsubd %ymm3, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %add = add <8 x i32> %a, %b
  %and = and <8 x i32> %add, %c
  %sub = sub <8 x i32> %and, %d
  ret <8 x i32> %sub
}

; In a more extreme case, even the later AVX targets should avoid extract/insert just
; because 256-bit ops are supported.

define <4 x i32> @do_not_use_256bit_op(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c, <4 x i32> %d) {
; SSE-LABEL: do_not_use_256bit_op:
; SSE:       # %bb.0:
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pand %xmm3, %xmm1
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: do_not_use_256bit_op:
; AVX:       # %bb.0:
; AVX-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vpand %xmm3, %xmm1, %xmm1
; AVX-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %concat1 = shufflevector <4 x i32> %a, <4 x i32> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %concat2 = shufflevector <4 x i32> %c, <4 x i32> %d, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %and = and <8 x i32> %concat1, %concat2
  %extract1 = shufflevector <8 x i32> %and, <8 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %extract2 = shufflevector <8 x i32> %and, <8 x i32> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  %sub = sub <4 x i32> %extract1, %extract2
  ret <4 x i32> %sub
}

; When extracting from a vector binop, the source width should be a multiple of the destination width.
; https://bugs.llvm.org/show_bug.cgi?id=39511

define <3 x float> @PR39511(<4 x float> %t0, <3 x float>* %b) {
; SSE-LABEL: PR39511:
; SSE:       # %bb.0:
; SSE-NEXT:    addps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: PR39511:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %add = fadd <4 x float> %t0, <float 1.0, float 2.0, float 3.0, float 4.0>
  %ext = shufflevector <4 x float> %add, <4 x float> undef, <3 x i32> <i32 0, i32 1, i32 2>
  ret <3 x float> %ext
}

