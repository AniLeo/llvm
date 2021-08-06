; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

target triple = "aarch64"

define <vscale x 4 x i32> @uunpkhi_splat(i16 %a) #0 {
; CHECK-LABEL: @uunpkhi_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i16 [[A:%.*]] to i32
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[UNPACK:%.*]] = shufflevector <vscale x 4 x i32> [[DOTSPLATINSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    ret <vscale x 4 x i32> [[UNPACK]]
;
  %splat_insert = insertelement <vscale x 8 x i16> poison, i16 %a, i32 0
  %splat = shufflevector <vscale x 8 x i16> %splat_insert, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %unpack = tail call <vscale x 4 x i32> @llvm.aarch64.sve.uunpkhi.nxv4i32(<vscale x 8 x i16> %splat)
  ret <vscale x 4 x i32> %unpack
}

define <vscale x 4 x i32> @uunpklo_splat(i16 %a) #0 {
; CHECK-LABEL: @uunpklo_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i16 [[A:%.*]] to i32
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[UNPACK:%.*]] = shufflevector <vscale x 4 x i32> [[DOTSPLATINSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    ret <vscale x 4 x i32> [[UNPACK]]
;
  %splat_insert = insertelement <vscale x 8 x i16> poison, i16 %a, i32 0
  %splat = shufflevector <vscale x 8 x i16> %splat_insert, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %unpack = tail call <vscale x 4 x i32> @llvm.aarch64.sve.uunpklo.nxv4i32(<vscale x 8 x i16> %splat)
  ret <vscale x 4 x i32> %unpack
}

define <vscale x 4 x i32> @sunpkhi_splat(i16 %a) #0 {
; CHECK-LABEL: @sunpkhi_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[A:%.*]] to i32
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[UNPACK:%.*]] = shufflevector <vscale x 4 x i32> [[DOTSPLATINSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    ret <vscale x 4 x i32> [[UNPACK]]
;
  %splat_insert = insertelement <vscale x 8 x i16> poison, i16 %a, i32 0
  %splat = shufflevector <vscale x 8 x i16> %splat_insert, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %unpack = tail call <vscale x 4 x i32> @llvm.aarch64.sve.sunpkhi.nxv4i32(<vscale x 8 x i16> %splat)
  ret <vscale x 4 x i32> %unpack
}

define <vscale x 4 x i32> @sunpklo_splat(i16 %a) #0 {
; CHECK-LABEL: @sunpklo_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[A:%.*]] to i32
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x i32> poison, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[UNPACK:%.*]] = shufflevector <vscale x 4 x i32> [[DOTSPLATINSERT]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    ret <vscale x 4 x i32> [[UNPACK]]
;
  %splat_insert = insertelement <vscale x 8 x i16> poison, i16 %a, i32 0
  %splat = shufflevector <vscale x 8 x i16> %splat_insert, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %unpack = tail call <vscale x 4 x i32> @llvm.aarch64.sve.sunpklo.nxv4i32(<vscale x 8 x i16> %splat)
  ret <vscale x 4 x i32> %unpack
}

declare <vscale x 4 x i32> @llvm.aarch64.sve.uunpkhi.nxv4i32(<vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.uunpklo.nxv4i32(<vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.sunpkhi.nxv4i32(<vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.sunpklo.nxv4i32(<vscale x 8 x i16>)

attributes #0 = { "target-features"="+sve" }
