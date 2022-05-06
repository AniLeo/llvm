; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple powerpc64-ibm-aix-xcoff -mcpu=pwr7 \
; RUN:   -verify-machineinstrs -O2 -mattr=vsx < %s | \
; RUN:    FileCheck %s --check-prefix=CHECK-AIX
; RUN: llc -mtriple powerpc64le-unknown-linux-gnu -mcpu=pwr8 \
; RUN:   -verify-machineinstrs -O2 -mattr=vsx < %s | \
; RUN:    FileCheck %s

define void @test_aix_splatimm(i32 %arg, i32 %arg1, i32 %arg2) {
; CHECK-AIX-LABEL: test_aix_splatimm:
; CHECK-AIX:       # %bb.0: # %bb
; CHECK-AIX-NEXT:    bclr 12, 20, 0
; CHECK-AIX-NEXT:  # %bb.1: # %bb3
; CHECK-AIX-NEXT:    srwi 4, 4, 16
; CHECK-AIX-NEXT:    srwi 5, 5, 16
; CHECK-AIX-NEXT:    slwi 3, 3, 8
; CHECK-AIX-NEXT:    mullw 4, 5, 4
; CHECK-AIX-NEXT:    neg 3, 3
; CHECK-AIX-NEXT:    lwz 5, 0(3)
; CHECK-AIX-NEXT:    sth 3, -16(1)
; CHECK-AIX-NEXT:    addi 3, 1, -16
; CHECK-AIX-NEXT:    lxvw4x 34, 0, 3
; CHECK-AIX-NEXT:    srwi 5, 5, 1
; CHECK-AIX-NEXT:    mullw 3, 4, 5
; CHECK-AIX-NEXT:    li 4, 0
; CHECK-AIX-NEXT:    vsplth 2, 2, 0
; CHECK-AIX-NEXT:    neg 3, 3
; CHECK-AIX-NEXT:    stxvw4x 34, 0, 4
; CHECK-AIX-NEXT:    sth 3, -32(1)
; CHECK-AIX-NEXT:    addi 3, 1, -32
; CHECK-AIX-NEXT:    lxvw4x 34, 0, 3
; CHECK-AIX-NEXT:    vsplth 2, 2, 0
; CHECK-AIX-NEXT:    stxvw4x 34, 0, 3
;
; CHECK-LABEL: test_aix_splatimm:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    bclr 12, 20, 0
; CHECK-NEXT:  # %bb.1: # %bb3
; CHECK-NEXT:    srwi 4, 4, 16
; CHECK-NEXT:    srwi 5, 5, 16
; CHECK-NEXT:    mullw 4, 5, 4
; CHECK-NEXT:    lwz 5, 0(3)
; CHECK-NEXT:    slwi 3, 3, 8
; CHECK-NEXT:    neg 3, 3
; CHECK-NEXT:    srwi 5, 5, 1
; CHECK-NEXT:    mtvsrd 34, 3
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    mullw 4, 4, 5
; CHECK-NEXT:    vsplth 2, 2, 3
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    neg 4, 4
; CHECK-NEXT:    mtvsrd 35, 4
; CHECK-NEXT:    vsplth 3, 3, 3
; CHECK-NEXT:    stvx 3, 0, 3
bb:
  br i1 undef, label %bb22, label %bb3

bb3:                                              ; preds = %bb
  %i = insertelement <8 x i16> undef, i16 0, i32 0
  %i4 = trunc i32 %arg to i16
  %i5 = mul i16 %i4, -256
  %i6 = insertelement <8 x i16> %i, i16 %i5, i32 1
  %i7 = ashr i32 %arg1, 16
  %i8 = ashr i32 %arg2, 16
  %i9 = mul nsw i32 %i8, %i7
  %i10 = insertelement <8 x i16> %i6, i16 0, i32 2
  %i11 = insertelement <8 x i16> %i10, i16 0, i32 3
  %i12 = load i32, i32* undef, align 4
  %i13 = ashr i32 %i12, 1
  %i14 = mul i32 %i9, %i13
  %i15 = trunc i32 %i14 to i16
  %i16 = sub i16 0, %i15
  %i17 = insertelement <8 x i16> %i11, i16 %i16, i32 4
  %i18 = insertelement <8 x i16> %i17, i16 0, i32 5
  %i19 = bitcast <8 x i16> %i18 to <16 x i8>
  %i20 = shufflevector <16 x i8> %i19, <16 x i8> undef, <16 x i32> <i32 2, i32 3, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  store <16 x i8> %i20, <16 x i8>* null, align 16
  %i21 = shufflevector <16 x i8> %i19, <16 x i8> undef, <16 x i32> <i32 8, i32 9, i32 8, i32 9, i32 8, i32 9, i32 8, i32 9, i32 8, i32 9, i32 8, i32 9, i32 8, i32 9, i32 8, i32 9>
  store <16 x i8> %i21, <16 x i8>* undef, align 16
  unreachable

bb22:                                             ; preds = %bb
  ret void
}
