; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-- < %s | FileCheck %s

define <4 x float> @repeated_fp_divisor(float %a, <4 x float> %b) {
; CHECK-LABEL: repeated_fp_divisor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xscvdpspn 0, 1
; CHECK-NEXT:    addis 3, 2, .LCPI0_0@toc@ha
; CHECK-NEXT:    addi 3, 3, .LCPI0_0@toc@l
; CHECK-NEXT:    lvx 3, 0, 3
; CHECK-NEXT:    addis 3, 2, .LCPI0_1@toc@ha
; CHECK-NEXT:    addi 3, 3, .LCPI0_1@toc@l
; CHECK-NEXT:    lvx 4, 0, 3
; CHECK-NEXT:    xxspltw 0, 0, 0
; CHECK-NEXT:    xvresp 1, 0
; CHECK-NEXT:    xvnmsubasp 35, 0, 1
; CHECK-NEXT:    xvmulsp 0, 34, 36
; CHECK-NEXT:    xvmaddasp 1, 1, 35
; CHECK-NEXT:    xvmulsp 34, 0, 1
; CHECK-NEXT:    blr
  %ins = insertelement <4 x float> undef, float %a, i32 0
  %splat = shufflevector <4 x float> %ins, <4 x float> undef, <4 x i32> zeroinitializer
  %t1 = fmul fast <4 x float> %b, <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 0x3FF028F5C0000000>
  %mul = fdiv fast <4 x float> %t1, %splat
  ret <4 x float> %mul
}

