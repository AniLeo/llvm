; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx2,+fma | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2,+fma | FileCheck %s --check-prefix=X64

declare <8 x float> @llvm.fma.v8f32(<8 x float>, <8 x float>, <8 x float>)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>)
declare float @llvm.fma.f32(float, float, float)
declare <2 x double> @llvm.fma.v2f64(<2 x double>, <2 x double>, <2 x double>)

; This test checks combinations of FNEG and FMA intrinsics

define <8 x float> @test1(<8 x float> %a, <8 x float> %b, <8 x float> %c)  {
; X32-LABEL: test1:
; X32:       # %bb.0:
; X32-NEXT:    vfmsub213ps {{.*#+}} ymm0 = (ymm1 * ymm0) - ymm2
; X32-NEXT:    retl
;
; X64-LABEL: test1:
; X64:       # %bb.0:
; X64-NEXT:    vfmsub213ps {{.*#+}} ymm0 = (ymm1 * ymm0) - ymm2
; X64-NEXT:    retq
  %sub.i = fsub <8 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %r = tail call <8 x float> @llvm.fma.v8f32(<8 x float> %a, <8 x float> %b, <8 x float> %sub.i) #2
  ret <8 x float> %r
}

define <4 x float> @test2(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; X32-LABEL: test2:
; X32:       # %bb.0:
; X32-NEXT:    vfnmsub213ps {{.*#+}} xmm0 = -(xmm1 * xmm0) - xmm2
; X32-NEXT:    retl
;
; X64-LABEL: test2:
; X64:       # %bb.0:
; X64-NEXT:    vfnmsub213ps {{.*#+}} xmm0 = -(xmm1 * xmm0) - xmm2
; X64-NEXT:    retq
  %t0 = tail call <4 x float> @llvm.fma.v4f32(<4 x float> %a, <4 x float> %b, <4 x float> %c) #2
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %t0
  ret <4 x float> %sub.i
}

define <4 x float> @test3(<4 x float> %a, <4 x float> %b, <4 x float> %c)  {
; X32-LABEL: test3:
; X32:       # %bb.0:
; X32-NEXT:    vfnmadd213ss {{.*#+}} xmm0 = -(xmm1 * xmm0) + xmm2
; X32-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X32-NEXT:    vxorps %xmm1, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test3:
; X64:       # %bb.0:
; X64-NEXT:    vfnmadd213ss {{.*#+}} xmm0 = -(xmm1 * xmm0) + xmm2
; X64-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X64-NEXT:    vxorps %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
  %a0 = extractelement <4 x float> %a, i64 0
  %b0 = extractelement <4 x float> %b, i64 0
  %c0 = extractelement <4 x float> %c, i64 0
  %negb0 = fneg float %b0
  %t0 = tail call float @llvm.fma.f32(float %a0, float %negb0, float %c0) #2
  %i = insertelement <4 x float> %a, float %t0, i64 0
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %i
  ret <4 x float> %sub.i
}

define <8 x float> @test4(<8 x float> %a, <8 x float> %b, <8 x float> %c) {
; X32-LABEL: test4:
; X32:       # %bb.0:
; X32-NEXT:    vfnmadd213ps {{.*#+}} ymm0 = -(ymm1 * ymm0) + ymm2
; X32-NEXT:    retl
;
; X64-LABEL: test4:
; X64:       # %bb.0:
; X64-NEXT:    vfnmadd213ps {{.*#+}} ymm0 = -(ymm1 * ymm0) + ymm2
; X64-NEXT:    retq
  %negc = fneg <8 x float> %c
  %t0 = tail call <8 x float> @llvm.fma.v8f32(<8 x float> %a, <8 x float> %b, <8 x float> %negc) #2
  %sub.i = fsub <8 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %t0
  ret <8 x float> %sub.i
}

define <8 x float> @test5(<8 x float> %a, <8 x float> %b, <8 x float> %c) {
; X32-LABEL: test5:
; X32:       # %bb.0:
; X32-NEXT:    vfmadd213ps {{.*#+}} ymm0 = (ymm1 * ymm0) + ymm2
; X32-NEXT:    retl
;
; X64-LABEL: test5:
; X64:       # %bb.0:
; X64-NEXT:    vfmadd213ps {{.*#+}} ymm0 = (ymm1 * ymm0) + ymm2
; X64-NEXT:    retq
  %sub.c = fsub <8 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %negsubc = fneg <8 x float> %sub.c
  %t0 = tail call <8 x float> @llvm.fma.v8f32(<8 x float> %a, <8 x float> %b, <8 x float> %negsubc) #2
  ret <8 x float> %t0
}

define <2 x double> @test6(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; X32-LABEL: test6:
; X32:       # %bb.0:
; X32-NEXT:    vfnmsub213pd {{.*#+}} xmm0 = -(xmm1 * xmm0) - xmm2
; X32-NEXT:    retl
;
; X64-LABEL: test6:
; X64:       # %bb.0:
; X64-NEXT:    vfnmsub213pd {{.*#+}} xmm0 = -(xmm1 * xmm0) - xmm2
; X64-NEXT:    retq
  %t0 = tail call <2 x double> @llvm.fma.v2f64(<2 x double> %a, <2 x double> %b, <2 x double> %c) #2
  %sub.i = fsub <2 x double> <double -0.0, double -0.0>, %t0
  ret <2 x double> %sub.i
}

define <8 x float> @test7(float %a, <8 x float> %b, <8 x float> %c)  {
; X32-LABEL: test7:
; X32:       # %bb.0:
; X32-NEXT:    vbroadcastss {{[0-9]+}}(%esp), %ymm2
; X32-NEXT:    vfnmadd213ps {{.*#+}} ymm0 = -(ymm2 * ymm0) + ymm1
; X32-NEXT:    retl
;
; X64-LABEL: test7:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastss %xmm0, %ymm0
; X64-NEXT:    vfnmadd213ps {{.*#+}} ymm0 = -(ymm1 * ymm0) + ymm2
; X64-NEXT:    retq
  %t0 = insertelement <8 x float> undef, float %a, i32 0
  %t1 = fsub <8 x float> <float -0.0, float undef, float undef, float undef, float undef, float undef, float undef, float undef>, %t0
  %t2 = shufflevector <8 x float> %t1, <8 x float> undef, <8 x i32> zeroinitializer
  %t3 = tail call <8 x float> @llvm.fma.v8f32(<8 x float> %t2, <8 x float> %b, <8 x float> %c)
  ret <8 x float> %t3

}

define <8 x float> @test8(float %a, <8 x float> %b, <8 x float> %c)  {
; X32-LABEL: test8:
; X32:       # %bb.0:
; X32-NEXT:    vbroadcastss {{[0-9]+}}(%esp), %ymm2
; X32-NEXT:    vfnmadd213ps {{.*#+}} ymm0 = -(ymm2 * ymm0) + ymm1
; X32-NEXT:    retl
;
; X64-LABEL: test8:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastss %xmm0, %ymm0
; X64-NEXT:    vfnmadd213ps {{.*#+}} ymm0 = -(ymm1 * ymm0) + ymm2
; X64-NEXT:    retq
  %t0 = fsub float -0.0, %a
  %t1 = insertelement <8 x float> undef, float %t0, i32 0
  %t2 = shufflevector <8 x float> %t1, <8 x float> undef, <8 x i32> zeroinitializer
  %t3 = tail call <8 x float> @llvm.fma.v8f32(<8 x float> %t2, <8 x float> %b, <8 x float> %c)
  ret <8 x float> %t3
}
