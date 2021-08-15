; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64 -enable-no-nans-fp-math -enable-no-signed-zeros-fp-math -mattr=+avx512fp16 | FileCheck %s --check-prefix=CHECK_UNSAFE
; RUN: llc < %s -mtriple=x86_64 -mattr=+avx512fp16 | FileCheck %s --check-prefix=CHECK

define <32 x half> @test_max_v32f16(<32 x half> * %a_ptr, <32 x half> %b)  {
; CHECK_UNSAFE-LABEL: test_max_v32f16:
; CHECK_UNSAFE:       # %bb.0:
; CHECK_UNSAFE-NEXT:    vmaxph (%rdi), %zmm0, %zmm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_max_v32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %zmm1
; CHECK-NEXT:    vmaxph %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %a = load <32 x half>, <32 x half>* %a_ptr
  %tmp = fcmp fast ogt <32 x half> %a, %b
  %tmp4 = select <32 x i1> %tmp, <32 x half> %a, <32 x half> %b
  ret <32 x half> %tmp4;
}

define <32 x half> @test_min_v32f16(<32 x half>* %a_ptr, <32 x half> %b)  {
; CHECK_UNSAFE-LABEL: test_min_v32f16:
; CHECK_UNSAFE:       # %bb.0:
; CHECK_UNSAFE-NEXT:    vminph (%rdi), %zmm0, %zmm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_min_v32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %zmm1
; CHECK-NEXT:    vminph %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %a = load <32 x half>, <32 x half>* %a_ptr
  %tmp = fcmp fast olt <32 x half> %a, %b
  %tmp4 = select <32 x i1> %tmp, <32 x half> %a, <32 x half> %b
  ret <32 x half> %tmp4;
}

define <16 x half> @test_max_v16f16(<16 x half> * %a_ptr, <16 x half> %b)  {
; CHECK_UNSAFE-LABEL: test_max_v16f16:
; CHECK_UNSAFE:       # %bb.0:
; CHECK_UNSAFE-NEXT:    vmaxph (%rdi), %ymm0, %ymm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_max_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %ymm1
; CHECK-NEXT:    vmaxph %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %a = load <16 x half>, <16 x half>* %a_ptr
  %tmp = fcmp fast ogt <16 x half> %a, %b
  %tmp4 = select <16 x i1> %tmp, <16 x half> %a, <16 x half> %b
  ret <16 x half> %tmp4;
}

define <16 x half> @test_min_v16f16(<16 x half>* %a_ptr, <16 x half> %b)  {
; CHECK_UNSAFE-LABEL: test_min_v16f16:
; CHECK_UNSAFE:       # %bb.0:
; CHECK_UNSAFE-NEXT:    vminph (%rdi), %ymm0, %ymm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_min_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %ymm1
; CHECK-NEXT:    vminph %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %a = load <16 x half>, <16 x half>* %a_ptr
  %tmp = fcmp fast olt <16 x half> %a, %b
  %tmp4 = select <16 x i1> %tmp, <16 x half> %a, <16 x half> %b
  ret <16 x half> %tmp4;
}

define <8 x half> @test_max_v8f16(<8 x half> * %a_ptr, <8 x half> %b)  {
; CHECK_UNSAFE-LABEL: test_max_v8f16:
; CHECK_UNSAFE:       # %bb.0:
; CHECK_UNSAFE-NEXT:    vmaxph (%rdi), %xmm0, %xmm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_max_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm1
; CHECK-NEXT:    vmaxph %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %a = load <8 x half>, <8 x half>* %a_ptr
  %tmp = fcmp fast ogt <8 x half> %a, %b
  %tmp4 = select <8 x i1> %tmp, <8 x half> %a, <8 x half> %b
  ret <8 x half> %tmp4;
}

define <8 x half> @test_min_v8f16(<8 x half>* %a_ptr, <8 x half> %b)  {
; CHECK_UNSAFE-LABEL: test_min_v8f16:
; CHECK_UNSAFE:       # %bb.0:
; CHECK_UNSAFE-NEXT:    vminph (%rdi), %xmm0, %xmm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_min_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps (%rdi), %xmm1
; CHECK-NEXT:    vminph %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %a = load <8 x half>, <8 x half>* %a_ptr
  %tmp = fcmp fast olt <8 x half> %a, %b
  %tmp4 = select <8 x i1> %tmp, <8 x half> %a, <8 x half> %b
  ret <8 x half> %tmp4;
}

define half @test_max_f16(half %a, half* %ptr) {
; CHECK_UNSAFE-LABEL: test_max_f16:
; CHECK_UNSAFE:       # %bb.0: # %entry
; CHECK_UNSAFE-NEXT:    vmaxsh (%rdi), %xmm0, %xmm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_max_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovsh (%rdi), %xmm1
; CHECK-NEXT:    vmaxsh %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = load half, half* %ptr
  %1 = fcmp fast ogt half %0, %a
  %2 = select i1 %1, half %0, half %a
  ret half %2
}

define half @test_min_f16(half %a, half* %ptr) {
; CHECK_UNSAFE-LABEL: test_min_f16:
; CHECK_UNSAFE:       # %bb.0: # %entry
; CHECK_UNSAFE-NEXT:    vminsh (%rdi), %xmm0, %xmm0
; CHECK_UNSAFE-NEXT:    retq
;
; CHECK-LABEL: test_min_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovsh (%rdi), %xmm1
; CHECK-NEXT:    vminsh %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = load half, half* %ptr
  %1 = fcmp fast olt half %0, %a
  %2 = select i1 %1, half %0, half %a
  ret half %2
}
