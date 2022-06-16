; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -verify-machineinstrs < %s | FileCheck %s

define void @bfmopa(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x bfloat> %zn, <vscale x 8 x bfloat> %zm) {
; CHECK-LABEL: bfmopa:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bfmopa za0.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mopa.wide.nxv8bf16(i64 0, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x bfloat> %zn, <vscale x 8 x bfloat> %zm)
  ret void
}

define void @fmopa(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x half> %zn, <vscale x 8 x half> %zm) {
; CHECK-LABEL: fmopa:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmopa za1.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mopa.wide.nxv8f16(i64 1, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x half> %zn, <vscale x 8 x half> %zm)
  ret void
}

define void @smopa_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: smopa_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    smopa za2.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.smopa.wide.nxv16i8(i64 2, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @smopa_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: smopa_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    smopa za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.smopa.wide.nxv8i16(i64 0, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

define void @umopa_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: umopa_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umopa za3.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.umopa.wide.nxv16i8(i64 3, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @umopa_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: umopa_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umopa za1.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.umopa.wide.nxv8i16(i64 1, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

define void @fmopa_s(<vscale x 4 x i1> %pn, <vscale x 4 x i1> %pm, <vscale x 4 x float> %zn, <vscale x 4 x float> %zm) {
; CHECK-LABEL: fmopa_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmopa za0.s, p0/m, p1/m, z0.s, z1.s
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mopa.nxv4f32(i64 0, <vscale x 4 x i1> %pn, <vscale x 4 x i1> %pm, <vscale x 4 x float> %zn, <vscale x 4 x float> %zm)
  ret void
}

define void @fmopa_d(<vscale x 2 x i1> %pn, <vscale x 2 x i1> %pm, <vscale x 2 x double> %zn, <vscale x 2 x double> %zm) #1 {
; CHECK-LABEL: fmopa_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmopa za2.d, p0/m, p1/m, z0.d, z1.d
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mopa.nxv2f64(i64 2, <vscale x 2 x i1> %pn, <vscale x 2 x i1> %pm, <vscale x 2 x double> %zn, <vscale x 2 x double> %zm)
  ret void
}

define void @sumopa_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: sumopa_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sumopa za1.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.sumopa.wide.nxv16i8(i64 1, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @sumopa_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: sumopa_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sumopa za3.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.sumopa.wide.nxv8i16(i64 3, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

define void @usmopa_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: usmopa_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usmopa za2.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.usmopa.wide.nxv16i8(i64 2, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @usmopa_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: usmopa_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usmopa za7.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.usmopa.wide.nxv8i16(i64 7, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

attributes #0 = { "target-features"="+sme-i64" }
attributes #1 = { "target-features"="+sme-f64" }

declare void @llvm.aarch64.sme.mopa.wide.nxv8bf16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x bfloat>, <vscale x 8 x bfloat>)
declare void @llvm.aarch64.sme.mopa.wide.nxv8f16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x half>, <vscale x 8 x half>)
declare void @llvm.aarch64.sme.mopa.nxv4f32(i64, <vscale x 4 x i1>, <vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
declare void @llvm.aarch64.sme.mopa.nxv2f64(i64, <vscale x 2 x i1>, <vscale x 2 x i1>, <vscale x 2 x double>, <vscale x 2 x double>)
declare void @llvm.aarch64.sme.smopa.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.smopa.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare void @llvm.aarch64.sme.umopa.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.umopa.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare void @llvm.aarch64.sme.sumopa.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.sumopa.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare void @llvm.aarch64.sme.usmopa.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.usmopa.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
