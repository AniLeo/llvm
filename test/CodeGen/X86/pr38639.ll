; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=btver2 | FileCheck %s

define <8 x double> @test(<4 x double> %a, <4 x double> %b) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovaps {{.*#+}} ymm1 = <u,0.82071743224100002,0.82071743224100002,0.82071743224100002>
; CHECK-NEXT:    vblendps {{.*#+}} ymm2 = ymm0[0,1,2,3],ymm1[4,5,6,7]
; CHECK-NEXT:    vblendps {{.*#+}} ymm1 = ymm0[0,1],ymm1[2,3],ymm0[4,5,6,7]
; CHECK-NEXT:    vunpckhpd {{.*#+}} ymm1 = ymm1[1],ymm2[1],ymm1[3],ymm2[3]
; CHECK-NEXT:    vmovaps {{.*#+}} xmm2 = [8.207174e-01,8.207174e-01]
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm2[0,1,2,3],ymm0[4,5,6,7]
; CHECK-NEXT:    retq
  %1 = shufflevector <4 x double> %a, <4 x double> <double undef, double 0x3FEA435134576E1C, double 0x3FEA435134576E1C, double 0x3FEA435134576E1C>, <8 x i32> <i32 6, i32 5, i32 2, i32 3, i32 5, i32 1, i32 3, i32 7>
  ret <8 x double> %1
}

