; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -verify-machineinstrs < %s | FileCheck %s

define void @bfmops(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x bfloat> %zn, <vscale x 8 x bfloat> %zm) {
; CHECK-LABEL: bfmops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bfmops za0.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mops.wide.nxv8bf16(i64 0, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x bfloat> %zn, <vscale x 8 x bfloat> %zm)
  ret void
}

define void @fmops(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x half> %zn, <vscale x 8 x half> %zm) {
; CHECK-LABEL: fmops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmops za1.s, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mops.wide.nxv8f16(i64 1, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x half> %zn, <vscale x 8 x half> %zm)
  ret void
}

define void @smops_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: smops_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    smops za2.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.smops.wide.nxv16i8(i64 2, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @smops_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: smops_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    smops za0.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.smops.wide.nxv8i16(i64 0, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

define void @umops_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: umops_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umops za3.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.umops.wide.nxv16i8(i64 3, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @umops_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: umops_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umops za1.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.umops.wide.nxv8i16(i64 1, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

define void @fmops_s(<vscale x 4 x i1> %pn, <vscale x 4 x i1> %pm, <vscale x 4 x float> %zn, <vscale x 4 x float> %zm) {
; CHECK-LABEL: fmops_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmops za0.s, p0/m, p1/m, z0.s, z1.s
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mops.nxv4f32(i64 0, <vscale x 4 x i1> %pn, <vscale x 4 x i1> %pm, <vscale x 4 x float> %zn, <vscale x 4 x float> %zm)
  ret void
}

define void @fmops_d(<vscale x 2 x i1> %pn, <vscale x 2 x i1> %pm, <vscale x 2 x double> %zn, <vscale x 2 x double> %zm) #1 {
; CHECK-LABEL: fmops_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmops za2.d, p0/m, p1/m, z0.d, z1.d
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.mops.nxv2f64(i64 2, <vscale x 2 x i1> %pn, <vscale x 2 x i1> %pm, <vscale x 2 x double> %zn, <vscale x 2 x double> %zm)
  ret void
}

define void @sumops_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: sumops_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sumops za1.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.sumops.wide.nxv16i8(i64 1, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @sumops_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: sumops_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sumops za3.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.sumops.wide.nxv8i16(i64 3, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

define void @usmops_s(<vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm) {
; CHECK-LABEL: usmops_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usmops za2.s, p0/m, p1/m, z0.b, z1.b
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.usmops.wide.nxv16i8(i64 2, <vscale x 16 x i1> %pn, <vscale x 16 x i1> %pm, <vscale x 16 x i8> %zn, <vscale x 16 x i8> %zm)
  ret void
}

define void @usmops_d(<vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm) #0 {
; CHECK-LABEL: usmops_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usmops za7.d, p0/m, p1/m, z0.h, z1.h
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.usmops.wide.nxv8i16(i64 7, <vscale x 8 x i1> %pn, <vscale x 8 x i1> %pm, <vscale x 8 x i16> %zn, <vscale x 8 x i16> %zm)
  ret void
}

attributes #0 = { "target-features"="+sme-i64" }
attributes #1 = { "target-features"="+sme-f64" }

declare void @llvm.aarch64.sme.mops.wide.nxv8bf16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x bfloat>, <vscale x 8 x bfloat>)
declare void @llvm.aarch64.sme.mops.wide.nxv8f16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x half>, <vscale x 8 x half>)
declare void @llvm.aarch64.sme.mops.nxv4f32(i64, <vscale x 4 x i1>, <vscale x 4 x i1>, <vscale x 4 x float>, <vscale x 4 x float>)
declare void @llvm.aarch64.sme.mops.nxv2f64(i64, <vscale x 2 x i1>, <vscale x 2 x i1>, <vscale x 2 x double>, <vscale x 2 x double>)
declare void @llvm.aarch64.sme.smops.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.smops.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare void @llvm.aarch64.sme.umops.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.umops.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare void @llvm.aarch64.sme.sumops.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.sumops.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare void @llvm.aarch64.sme.usmops.wide.nxv16i8(i64, <vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare void @llvm.aarch64.sme.usmops.wide.nxv8i16(i64, <vscale x 8 x i1>, <vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
