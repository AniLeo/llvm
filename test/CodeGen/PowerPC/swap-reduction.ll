; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64le < %s | FileCheck %s

define i64 @test1(i64* %a, i64* %b) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mr 5, 3
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    ld 4, 0(4)
; CHECK-NEXT:    mtvsrd 34, 3
; CHECK-NEXT:    add 3, 3, 4
; CHECK-NEXT:    mtvsrd 35, 4
; CHECK-NEXT:    vavgsb 2, 2, 3
; CHECK-NEXT:    stxsdx 34, 0, 5
; CHECK-NEXT:    blr
entry:
  %lhs = load i64, i64* %a, align 8
  %rhs = load i64, i64* %b, align 8
  %sum = add i64 %lhs, %rhs
  %lv = insertelement <2 x i64> undef, i64 %lhs, i32 0
  %rv = insertelement <2 x i64> undef, i64 %rhs, i32 0
  %lhc = bitcast <2 x i64> %lv to <16 x i8>
  %rhc = bitcast <2 x i64> %rv to <16 x i8>
  %add = call <16 x i8> @llvm.ppc.altivec.vavgsb(<16 x i8> %lhc, <16 x i8> %rhc)
  %cb = bitcast <16 x i8> %add to <2 x i64>
  %fv = extractelement <2 x i64> %cb, i32 0
  store i64 %fv, i64* %a, align 8
  ret i64 %sum
}

define i64 @test2(i64* %a, i64* %b) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mr 5, 3
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    ld 4, 0(4)
; CHECK-NEXT:    mtvsrd 34, 3
; CHECK-NEXT:    add 3, 3, 4
; CHECK-NEXT:    mtvsrd 35, 4
; CHECK-NEXT:    vadduhm 2, 2, 3
; CHECK-NEXT:    stxsdx 34, 0, 5
; CHECK-NEXT:    blr
entry:
  %lhs = load i64, i64* %a, align 8
  %rhs = load i64, i64* %b, align 8
  %sum = add i64 %lhs, %rhs
  %lv = insertelement <2 x i64> undef, i64 %lhs, i32 0
  %rv = insertelement <2 x i64> undef, i64 %rhs, i32 0
  %lhc = bitcast <2 x i64> %lv to <8 x i16>
  %rhc = bitcast <2 x i64> %rv to <8 x i16>
  %add = add <8 x i16> %lhc, %rhc
  %cb = bitcast <8 x i16> %add to <2 x i64>
  %fv = extractelement <2 x i64> %cb, i32 0
  store i64 %fv, i64* %a, align 8
  ret i64 %sum
}

; Ensure that vec-ops with multiple uses aren't simplified.
define signext i16 @vecop_uses(i16* %addr) {
; CHECK-LABEL: vecop_uses:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 4, 16
; CHECK-NEXT:    lxvd2x 1, 0, 3
; CHECK-NEXT:    lxvd2x 0, 3, 4
; CHECK-NEXT:    xxswapd 35, 1
; CHECK-NEXT:    xxswapd 34, 0
; CHECK-NEXT:    vminsh 2, 3, 2
; CHECK-NEXT:    xxswapd 35, 34
; CHECK-NEXT:    vminsh 2, 2, 3
; CHECK-NEXT:    xxspltw 35, 34, 2
; CHECK-NEXT:    vminsh 2, 2, 3
; CHECK-NEXT:    vsplth 3, 2, 6
; CHECK-NEXT:    vminsh 2, 2, 3
; CHECK-NEXT:    xxswapd 0, 34
; CHECK-NEXT:    mffprd 3, 0
; CHECK-NEXT:    clrldi 3, 3, 48
; CHECK-NEXT:    extsh 3, 3
; CHECK-NEXT:    blr
entry:
  %0 = bitcast i16* %addr to <16 x i16>*
  %1 = load <16 x i16>, <16 x i16>* %0, align 2
  %2 = call i16 @llvm.vector.reduce.smin.v16i16(<16 x i16> %1)
  ret i16 %2
}

declare <16 x i8> @llvm.ppc.altivec.vavgsb(<16 x i8>, <16 x i8>)
declare i16 @llvm.vector.reduce.smin.v16i16(<16 x i16>)
