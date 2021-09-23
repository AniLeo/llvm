; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512fp16 --fp-contract=fast --enable-unsafe-fp-math | FileCheck %s

define dso_local <32 x half> @test1(<32 x half> %acc.coerce, <32 x half> %lhs.coerce, <32 x half> %rhs.coerce) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmaddcph %zmm1, %zmm0, %zmm2
; CHECK-NEXT:    vmovaps %zmm2, %zmm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <32 x half> %lhs.coerce to <16 x float>
  %1 = bitcast <32 x half> %rhs.coerce to <16 x float>
  %2 = tail call fast <16 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.512(<16 x float> %0, <16 x float> %1, <16 x float> zeroinitializer, i16 -1, i32 4)
  %3 = bitcast <16 x float> %2 to <32 x half>
  %add.i.i = fadd fast <32 x half> %3, %acc.coerce
  ret <32 x half> %add.i.i
}

define dso_local <16 x half> @test2(<16 x half> %acc.coerce, <16 x half> %lhs.coerce, <16 x half> %rhs.coerce) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmaddcph %ymm1, %ymm0, %ymm2
; CHECK-NEXT:    vmovaps %ymm2, %ymm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <16 x half> %lhs.coerce to <8 x float>
  %1 = bitcast <16 x half> %rhs.coerce to <8 x float>
  %2 = tail call fast <8 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.256(<8 x float> %0, <8 x float> %1, <8 x float> zeroinitializer, i8 -1)
  %3 = bitcast <8 x float> %2 to <16 x half>
  %add.i.i = fadd fast <16 x half> %3, %acc.coerce
  ret <16 x half> %add.i.i
}

define dso_local <8 x half> @test3(<8 x half> %acc.coerce, <8 x half> %lhs.coerce, <8 x half> %rhs.coerce) {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmaddcph %xmm1, %xmm0, %xmm2
; CHECK-NEXT:    vmovaps %xmm2, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <8 x half> %lhs.coerce to <4 x float>
  %1 = bitcast <8 x half> %rhs.coerce to <4 x float>
  %2 = tail call fast <4 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.128(<4 x float> %0, <4 x float> %1, <4 x float> zeroinitializer, i8 -1)
  %3 = bitcast <4 x float> %2 to <8 x half>
  %add.i.i = fadd fast <8 x half> %3, %acc.coerce
  ret <8 x half> %add.i.i
}


define dso_local <8 x half> @test4(<8 x half> %acc.coerce, <8 x half> %lhs.coerce, <8 x half> %rhs.coerce) {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmaddcph %xmm1, %xmm0, %xmm2
; CHECK-NEXT:    vmovaps %xmm2, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <8 x half> %lhs.coerce to <4 x float>
  %1 = bitcast <8 x half> %rhs.coerce to <4 x float>
  %2 = tail call fast <4 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.128(<4 x float> %0, <4 x float> %1, <4 x float> zeroinitializer, i8 -1)
  %3 = bitcast <4 x float> %2 to <8 x half>
  %add.i.i = fadd fast <8 x half> %acc.coerce, %3
  ret <8 x half> %add.i.i
}

declare <16 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.512(<16 x float>, <16 x float>, <16 x float>, i16, i32 immarg)
declare <8 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.256(<8 x float>, <8 x float>, <8 x float>, i8)
declare <4 x float> @llvm.x86.avx512fp16.mask.vfmul.cph.128(<4 x float>, <4 x float>, <4 x float>, i8)
