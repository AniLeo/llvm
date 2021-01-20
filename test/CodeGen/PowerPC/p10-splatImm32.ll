; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s

; Function Attrs: norecurse nounwind readnone
define  <4 x i32> @test_xxsplti32dx_1(<4 x i32> %a) {
; CHECK-LABEL: test_xxsplti32dx_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 0, 566
; CHECK-NEXT:    blr
entry:
  %vecins1 = shufflevector <4 x i32> %a, <4 x i32> <i32 undef, i32 566, i32 undef, i32 566>, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x i32> %vecins1
}

; Function Attrs: norecurse nounwind readnone
define  <4 x i32> @test_xxsplti32dx_2(<4 x i32> %a) {
; CHECK-LABEL: test_xxsplti32dx_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 1, 33
; CHECK-NEXT:    blr
entry:
  %vecins1 = shufflevector <4 x i32> <i32 33, i32 undef, i32 33, i32 undef>, <4 x i32> %a, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x i32> %vecins1
}

; Function Attrs: norecurse nounwind readnone
define  <4 x i32> @test_xxsplti32dx_3(<4 x i32> %a) {
; CHECK-LABEL: test_xxsplti32dx_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 0, 12
; CHECK-NEXT:    blr
entry:
  %vecins1 = shufflevector <4 x i32> %a, <4 x i32> <i32 undef, i32 12, i32 undef, i32 12>, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x i32> %vecins1
}

; Function Attrs: norecurse nounwind readnone
define  <4 x i32> @test_xxsplti32dx_4(<4 x i32> %a) {
; CHECK-LABEL: test_xxsplti32dx_4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 1, -683
; CHECK-NEXT:    blr
entry:
  %vecins1 = shufflevector <4 x i32> <i32 -683, i32 undef, i32 -683, i32 undef>, <4 x i32> %a, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x i32> %vecins1
}

; Function Attrs: nounwind
define  <4 x float> @test_xxsplti32dx_5(<4 x float> %vfa) {
; CHECK-LABEL: test_xxsplti32dx_5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 0, 1065353216
; CHECK-NEXT:    blr
entry:
  %vecins3.i = shufflevector <4 x float> %vfa, <4 x float> <float undef, float 1.000000e+00, float undef, float 1.000000e+00>, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x float> %vecins3.i
}

; Function Attrs: nounwind
define  <4 x float> @test_xxsplti32dx_6(<4 x float> %vfa) {
; CHECK-LABEL: test_xxsplti32dx_6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 1, 1073741824
; CHECK-NEXT:    blr
entry:
  %vecins3.i = shufflevector <4 x float> <float 2.000000e+00, float undef, float 2.000000e+00, float undef>, <4 x float> %vfa, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x float> %vecins3.i
}

; Function Attrs: norecurse nounwind readnone
; Test to illustrate when the splat is narrower than 32-bits.
define dso_local <4 x i32> @test_xxsplti32dx_7(<4 x i32> %a) local_unnamed_addr #0 {
; CHECK-LABEL: test_xxsplti32dx_7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 1, -1414812757
; CHECK-NEXT:    blr
entry:
  %vecins1 = shufflevector <4 x i32> <i32 -1414812757, i32 undef, i32 -1414812757, i32 undef>, <4 x i32> %a, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x i32> %vecins1
}

define dso_local <2 x double> @test_xxsplti32dx_8() {
; CHECK-LABEL: test_xxsplti32dx_8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 0, 1082660167
; CHECK-NEXT:    xxsplti32dx vs34, 1, -1374389535
; CHECK-NEXT:    blr
entry:
  ret <2 x double> <double 0x40881547AE147AE1, double 0x40881547AE147AE1>
}

define dso_local <8 x i16> @test_xxsplti32dx_9() {
; CHECK-LABEL: test_xxsplti32dx_9:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xxsplti32dx vs34, 0, 23855277
; CHECK-NEXT:    xxsplti32dx vs34, 1, 65827
; CHECK-NEXT:    blr
entry:
  ret <8 x i16> <i16 291, i16 undef, i16 undef, i16 364, i16 undef, i16 1, i16 173, i16 undef>
}
