; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-unknown-linux-gnu -mcpu=a2q | FileCheck %s
target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-f128:128:128-v128:128:128-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

declare <4 x double> @llvm.sqrt.v4f64(<4 x double>)
declare <4 x float> @llvm.sqrt.v4f32(<4 x float>)

define <4 x double> @foo_fmf(<4 x double> %a, <4 x double> %b) nounwind {
; CHECK-LABEL: foo_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LCPI0_0@toc@ha
; CHECK-NEXT:    qvfrsqrte 3, 2
; CHECK-NEXT:    addi 3, 3, .LCPI0_0@toc@l
; CHECK-NEXT:    qvlfdx 0, 0, 3
; CHECK-NEXT:    qvfmul 4, 3, 3
; CHECK-NEXT:    qvfmsub 2, 2, 0, 2
; CHECK-NEXT:    qvfnmsub 4, 2, 4, 0
; CHECK-NEXT:    qvfmul 3, 3, 4
; CHECK-NEXT:    qvfmul 4, 3, 3
; CHECK-NEXT:    qvfnmsub 0, 2, 4, 0
; CHECK-NEXT:    qvfmul 0, 3, 0
; CHECK-NEXT:    qvfmul 1, 1, 0
; CHECK-NEXT:    blr
entry:
  %x = call fast <4 x double> @llvm.sqrt.v4f64(<4 x double> %b)
  %r = fdiv fast <4 x double> %a, %x
  ret <4 x double> %r
}

define <4 x double> @foo_safe(<4 x double> %a, <4 x double> %b) nounwind {
; CHECK-LABEL: foo_safe:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvesplati 5, 2, 3
; CHECK-NEXT:    qvesplati 3, 2, 1
; CHECK-NEXT:    qvesplati 4, 2, 2
; CHECK-NEXT:    fsqrt 2, 2
; CHECK-NEXT:    fsqrt 5, 5
; CHECK-NEXT:    fsqrt 4, 4
; CHECK-NEXT:    fsqrt 3, 3
; CHECK-NEXT:    qvesplati 6, 1, 3
; CHECK-NEXT:    qvgpci 0, 275
; CHECK-NEXT:    fdiv 2, 1, 2
; CHECK-NEXT:    fdiv 5, 6, 5
; CHECK-NEXT:    qvesplati 6, 1, 2
; CHECK-NEXT:    qvesplati 1, 1, 1
; CHECK-NEXT:    fdiv 4, 6, 4
; CHECK-NEXT:    fdiv 1, 1, 3
; CHECK-NEXT:    qvfperm 3, 4, 5, 0
; CHECK-NEXT:    qvfperm 0, 2, 1, 0
; CHECK-NEXT:    qvgpci 1, 101
; CHECK-NEXT:    qvfperm 1, 0, 3, 1
; CHECK-NEXT:    blr
entry:
  %x = call <4 x double> @llvm.sqrt.v4f64(<4 x double> %b)
  %r = fdiv <4 x double> %a, %x
  ret <4 x double> %r
}

define <4 x double> @foof_fmf(<4 x double> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: foof_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LCPI2_0@toc@ha
; CHECK-NEXT:    qvfrsqrtes 3, 2
; CHECK-NEXT:    addi 3, 3, .LCPI2_0@toc@l
; CHECK-NEXT:    qvlfsx 0, 0, 3
; CHECK-NEXT:    qvfmuls 4, 3, 3
; CHECK-NEXT:    qvfnmsubs 2, 2, 0, 2
; CHECK-NEXT:    qvfmadds 0, 2, 4, 0
; CHECK-NEXT:    qvfmuls 0, 3, 0
; CHECK-NEXT:    qvfmul 1, 1, 0
; CHECK-NEXT:    blr
entry:
  %x = call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> %b)
  %y = fpext <4 x float> %x to <4 x double>
  %r = fdiv fast <4 x double> %a, %y
  ret <4 x double> %r
}

define <4 x double> @foof_safe(<4 x double> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: foof_safe:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvesplati 0, 2, 3
; CHECK-NEXT:    qvesplati 3, 2, 2
; CHECK-NEXT:    fsqrts 4, 2
; CHECK-NEXT:    qvesplati 2, 2, 1
; CHECK-NEXT:    fsqrts 0, 0
; CHECK-NEXT:    fsqrts 3, 3
; CHECK-NEXT:    fsqrts 2, 2
; CHECK-NEXT:    qvgpci 5, 275
; CHECK-NEXT:    qvgpci 6, 101
; CHECK-NEXT:    qvfperm 0, 3, 0, 5
; CHECK-NEXT:    qvesplati 3, 1, 2
; CHECK-NEXT:    qvfperm 2, 4, 2, 5
; CHECK-NEXT:    qvfperm 0, 2, 0, 6
; CHECK-NEXT:    qvesplati 2, 1, 3
; CHECK-NEXT:    qvesplati 4, 0, 3
; CHECK-NEXT:    fdiv 2, 2, 4
; CHECK-NEXT:    qvesplati 4, 0, 2
; CHECK-NEXT:    fdiv 3, 3, 4
; CHECK-NEXT:    qvesplati 4, 1, 1
; CHECK-NEXT:    fdiv 1, 1, 0
; CHECK-NEXT:    qvesplati 0, 0, 1
; CHECK-NEXT:    fdiv 0, 4, 0
; CHECK-NEXT:    qvfperm 2, 3, 2, 5
; CHECK-NEXT:    qvfperm 0, 1, 0, 5
; CHECK-NEXT:    qvfperm 1, 0, 2, 6
; CHECK-NEXT:    blr
entry:
  %x = call <4 x float> @llvm.sqrt.v4f32(<4 x float> %b)
  %y = fpext <4 x float> %x to <4 x double>
  %r = fdiv <4 x double> %a, %y
  ret <4 x double> %r
}

define <4 x float> @food_fmf(<4 x float> %a, <4 x double> %b) nounwind {
; CHECK-LABEL: food_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LCPI4_0@toc@ha
; CHECK-NEXT:    qvfrsqrte 3, 2
; CHECK-NEXT:    addi 3, 3, .LCPI4_0@toc@l
; CHECK-NEXT:    qvlfdx 0, 0, 3
; CHECK-NEXT:    qvfmul 4, 3, 3
; CHECK-NEXT:    qvfmsub 2, 2, 0, 2
; CHECK-NEXT:    qvfnmsub 4, 2, 4, 0
; CHECK-NEXT:    qvfmul 3, 3, 4
; CHECK-NEXT:    qvfmul 4, 3, 3
; CHECK-NEXT:    qvfnmsub 0, 2, 4, 0
; CHECK-NEXT:    qvfmul 0, 3, 0
; CHECK-NEXT:    qvfrsp 0, 0
; CHECK-NEXT:    qvfmuls 1, 1, 0
; CHECK-NEXT:    blr
entry:
  %x = call fast <4 x double> @llvm.sqrt.v4f64(<4 x double> %b)
  %y = fptrunc <4 x double> %x to <4 x float>
  %r = fdiv fast <4 x float> %a, %y
  ret <4 x float> %r
}

define <4 x float> @food_safe(<4 x float> %a, <4 x double> %b) nounwind {
; CHECK-LABEL: food_safe:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvesplati 0, 2, 3
; CHECK-NEXT:    qvesplati 3, 2, 2
; CHECK-NEXT:    fsqrt 4, 2
; CHECK-NEXT:    qvesplati 2, 2, 1
; CHECK-NEXT:    fsqrt 0, 0
; CHECK-NEXT:    fsqrt 3, 3
; CHECK-NEXT:    fsqrt 2, 2
; CHECK-NEXT:    qvgpci 5, 275
; CHECK-NEXT:    qvgpci 6, 101
; CHECK-NEXT:    qvfperm 0, 3, 0, 5
; CHECK-NEXT:    qvesplati 3, 1, 2
; CHECK-NEXT:    qvfperm 2, 4, 2, 5
; CHECK-NEXT:    qvfperm 0, 2, 0, 6
; CHECK-NEXT:    qvesplati 2, 1, 3
; CHECK-NEXT:    qvfrsp 0, 0
; CHECK-NEXT:    qvesplati 4, 0, 3
; CHECK-NEXT:    fdivs 2, 2, 4
; CHECK-NEXT:    qvesplati 4, 0, 2
; CHECK-NEXT:    fdivs 3, 3, 4
; CHECK-NEXT:    qvesplati 4, 1, 1
; CHECK-NEXT:    fdivs 1, 1, 0
; CHECK-NEXT:    qvesplati 0, 0, 1
; CHECK-NEXT:    fdivs 0, 4, 0
; CHECK-NEXT:    qvfperm 2, 3, 2, 5
; CHECK-NEXT:    qvfperm 0, 1, 0, 5
; CHECK-NEXT:    qvfperm 1, 0, 2, 6
; CHECK-NEXT:    blr
entry:
  %x = call <4 x double> @llvm.sqrt.v4f64(<4 x double> %b)
  %y = fptrunc <4 x double> %x to <4 x float>
  %r = fdiv <4 x float> %a, %y
  ret <4 x float> %r
}

define <4 x float> @goo_fmf(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: goo_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LCPI6_0@toc@ha
; CHECK-NEXT:    qvfrsqrtes 3, 2
; CHECK-NEXT:    addi 3, 3, .LCPI6_0@toc@l
; CHECK-NEXT:    qvlfsx 0, 0, 3
; CHECK-NEXT:    qvfmuls 4, 3, 3
; CHECK-NEXT:    qvfnmsubs 2, 2, 0, 2
; CHECK-NEXT:    qvfmadds 0, 2, 4, 0
; CHECK-NEXT:    qvfmuls 0, 3, 0
; CHECK-NEXT:    qvfmuls 1, 1, 0
; CHECK-NEXT:    blr
entry:
  %x = call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> %b)
  %r = fdiv fast <4 x float> %a, %x
  ret <4 x float> %r
}

define <4 x float> @goo_safe(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: goo_safe:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvesplati 5, 2, 3
; CHECK-NEXT:    qvesplati 3, 2, 1
; CHECK-NEXT:    qvesplati 4, 2, 2
; CHECK-NEXT:    fsqrts 2, 2
; CHECK-NEXT:    fsqrts 5, 5
; CHECK-NEXT:    fsqrts 4, 4
; CHECK-NEXT:    fsqrts 3, 3
; CHECK-NEXT:    qvesplati 6, 1, 3
; CHECK-NEXT:    qvgpci 0, 275
; CHECK-NEXT:    fdivs 2, 1, 2
; CHECK-NEXT:    fdivs 5, 6, 5
; CHECK-NEXT:    qvesplati 6, 1, 2
; CHECK-NEXT:    qvesplati 1, 1, 1
; CHECK-NEXT:    fdivs 4, 6, 4
; CHECK-NEXT:    fdivs 1, 1, 3
; CHECK-NEXT:    qvfperm 3, 4, 5, 0
; CHECK-NEXT:    qvfperm 0, 2, 1, 0
; CHECK-NEXT:    qvgpci 1, 101
; CHECK-NEXT:    qvfperm 1, 0, 3, 1
; CHECK-NEXT:    blr
entry:
  %x = call <4 x float> @llvm.sqrt.v4f32(<4 x float> %b)
  %r = fdiv <4 x float> %a, %x
  ret <4 x float> %r
}

define <4 x double> @foo2_fmf(<4 x double> %a, <4 x double> %b) nounwind {
; CHECK-LABEL: foo2_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LCPI8_0@toc@ha
; CHECK-NEXT:    qvfre 3, 2
; CHECK-NEXT:    addi 3, 3, .LCPI8_0@toc@l
; CHECK-NEXT:    qvlfdx 0, 0, 3
; CHECK-NEXT:    qvfnmsub 0, 2, 3, 0
; CHECK-NEXT:    qvfmadd 0, 3, 0, 3
; CHECK-NEXT:    qvfmul 3, 1, 0
; CHECK-NEXT:    qvfnmsub 1, 2, 3, 1
; CHECK-NEXT:    qvfmadd 1, 0, 1, 3
; CHECK-NEXT:    blr
entry:
  %r = fdiv fast <4 x double> %a, %b
  ret <4 x double> %r
}

define <4 x double> @foo2_safe(<4 x double> %a, <4 x double> %b) nounwind {
; CHECK-LABEL: foo2_safe:
; CHECK:       # %bb.0:
; CHECK-NEXT:    qvesplati 3, 2, 3
; CHECK-NEXT:    qvesplati 4, 1, 3
; CHECK-NEXT:    qvesplati 5, 2, 2
; CHECK-NEXT:    qvgpci 0, 275
; CHECK-NEXT:    fdiv 3, 4, 3
; CHECK-NEXT:    qvesplati 4, 1, 2
; CHECK-NEXT:    fdiv 4, 4, 5
; CHECK-NEXT:    fdiv 5, 1, 2
; CHECK-NEXT:    qvesplati 2, 2, 1
; CHECK-NEXT:    qvesplati 1, 1, 1
; CHECK-NEXT:    fdiv 1, 1, 2
; CHECK-NEXT:    qvfperm 2, 4, 3, 0
; CHECK-NEXT:    qvfperm 0, 5, 1, 0
; CHECK-NEXT:    qvgpci 1, 101
; CHECK-NEXT:    qvfperm 1, 0, 2, 1
; CHECK-NEXT:    blr
  %r = fdiv <4 x double> %a, %b
  ret <4 x double> %r
}

define <4 x float> @goo2_fmf(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: goo2_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvfres 0, 2
; CHECK-NEXT:    qvfmuls 3, 1, 0
; CHECK-NEXT:    qvfnmsubs 1, 2, 3, 1
; CHECK-NEXT:    qvfmadds 1, 0, 1, 3
; CHECK-NEXT:    blr
entry:
  %r = fdiv fast <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x float> @goo2_safe(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: goo2_safe:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvesplati 3, 2, 3
; CHECK-NEXT:    qvesplati 4, 1, 3
; CHECK-NEXT:    qvesplati 5, 2, 2
; CHECK-NEXT:    qvgpci 0, 275
; CHECK-NEXT:    fdivs 3, 4, 3
; CHECK-NEXT:    qvesplati 4, 1, 2
; CHECK-NEXT:    fdivs 4, 4, 5
; CHECK-NEXT:    fdivs 5, 1, 2
; CHECK-NEXT:    qvesplati 2, 2, 1
; CHECK-NEXT:    qvesplati 1, 1, 1
; CHECK-NEXT:    fdivs 1, 1, 2
; CHECK-NEXT:    qvfperm 2, 4, 3, 0
; CHECK-NEXT:    qvfperm 0, 5, 1, 0
; CHECK-NEXT:    qvgpci 1, 101
; CHECK-NEXT:    qvfperm 1, 0, 2, 1
; CHECK-NEXT:    blr
entry:
  %r = fdiv <4 x float> %a, %b
  ret <4 x float> %r
}

define <4 x double> @foo3_fmf(<4 x double> %a) nounwind {
; CHECK-LABEL: foo3_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LCPI12_0@toc@ha
; CHECK-NEXT:    qvfrsqrte 0, 1
; CHECK-NEXT:    addi 3, 3, .LCPI12_0@toc@l
; CHECK-NEXT:    qvlfdx 2, 0, 3
; CHECK-NEXT:    addis 3, 2, .LCPI12_1@toc@ha
; CHECK-NEXT:    addi 3, 3, .LCPI12_1@toc@l
; CHECK-NEXT:    qvfmul 3, 0, 0
; CHECK-NEXT:    qvfmsub 4, 1, 2, 1
; CHECK-NEXT:    qvfnmsub 3, 4, 3, 2
; CHECK-NEXT:    qvfmul 0, 0, 3
; CHECK-NEXT:    qvfmul 3, 0, 0
; CHECK-NEXT:    qvfnmsub 2, 4, 3, 2
; CHECK-NEXT:    qvfmul 0, 0, 2
; CHECK-NEXT:    qvlfdx 2, 0, 3
; CHECK-NEXT:    qvfmul 0, 0, 1
; CHECK-NEXT:    qvfcmpeq 1, 1, 2
; CHECK-NEXT:    qvfsel 1, 1, 2, 0
; CHECK-NEXT:    blr
entry:
  %r = call fast <4 x double> @llvm.sqrt.v4f64(<4 x double> %a)
  ret <4 x double> %r
}

define <4 x double> @foo3_safe(<4 x double> %a) nounwind {
; CHECK-LABEL: foo3_safe:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvesplati 2, 1, 3
; CHECK-NEXT:    qvesplati 3, 1, 2
; CHECK-NEXT:    fsqrt 4, 1
; CHECK-NEXT:    qvesplati 1, 1, 1
; CHECK-NEXT:    fsqrt 2, 2
; CHECK-NEXT:    fsqrt 3, 3
; CHECK-NEXT:    fsqrt 1, 1
; CHECK-NEXT:    qvgpci 0, 275
; CHECK-NEXT:    qvfperm 2, 3, 2, 0
; CHECK-NEXT:    qvfperm 0, 4, 1, 0
; CHECK-NEXT:    qvgpci 1, 101
; CHECK-NEXT:    qvfperm 1, 0, 2, 1
; CHECK-NEXT:    blr
entry:
  %r = call <4 x double> @llvm.sqrt.v4f64(<4 x double> %a)
  ret <4 x double> %r
}

define <4 x float> @goo3_fmf(<4 x float> %a) nounwind {
; CHECK-LABEL: goo3_fmf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LCPI14_1@toc@ha
; CHECK-NEXT:    qvfrsqrtes 2, 1
; CHECK-NEXT:    addi 3, 3, .LCPI14_1@toc@l
; CHECK-NEXT:    qvlfsx 0, 0, 3
; CHECK-NEXT:    addis 3, 2, .LCPI14_0@toc@ha
; CHECK-NEXT:    addi 3, 3, .LCPI14_0@toc@l
; CHECK-NEXT:    qvfmuls 4, 2, 2
; CHECK-NEXT:    qvfnmsubs 3, 1, 0, 1
; CHECK-NEXT:    qvfmadds 0, 3, 4, 0
; CHECK-NEXT:    qvlfsx 3, 0, 3
; CHECK-NEXT:    qvfmuls 0, 2, 0
; CHECK-NEXT:    qvfmuls 0, 0, 1
; CHECK-NEXT:    qvfcmpeq 1, 1, 3
; CHECK-NEXT:    qvfsel 1, 1, 3, 0
; CHECK-NEXT:    blr
entry:
  %r = call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> %a)
  ret <4 x float> %r
}

define <4 x float> @goo3_safe(<4 x float> %a) nounwind {
; CHECK-LABEL: goo3_safe:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    qvesplati 2, 1, 3
; CHECK-NEXT:    qvesplati 3, 1, 2
; CHECK-NEXT:    fsqrts 4, 1
; CHECK-NEXT:    qvesplati 1, 1, 1
; CHECK-NEXT:    fsqrts 2, 2
; CHECK-NEXT:    fsqrts 3, 3
; CHECK-NEXT:    fsqrts 1, 1
; CHECK-NEXT:    qvgpci 0, 275
; CHECK-NEXT:    qvfperm 2, 3, 2, 0
; CHECK-NEXT:    qvfperm 0, 4, 1, 0
; CHECK-NEXT:    qvgpci 1, 101
; CHECK-NEXT:    qvfperm 1, 0, 2, 1
; CHECK-NEXT:    blr
entry:
  %r = call <4 x float> @llvm.sqrt.v4f32(<4 x float> %a)
  ret <4 x float> %r
}

