; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -verify-machineinstrs < %s | FileCheck %s

define <vscale x 16 x i8> @test_revd_i8(<vscale x 16 x i8> %a, <vscale x 16 x i1> %pg, <vscale x 16 x i8> %b) {
; CHECK-LABEL: test_revd_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 16 x i8> @llvm.aarch64.sve.revd.nxv16i8(<vscale x 16 x i8> %a, <vscale x 16 x i1> %pg, <vscale x 16 x i8> %b)
  ret <vscale x 16 x i8> %res
}

define <vscale x 8 x i16> @test_revd_i16(<vscale x 8 x i16> %a, <vscale x 8 x i1> %pg, <vscale x 8 x i16> %b) {
; CHECK-LABEL: test_revd_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x  8 x i16> @llvm.aarch64.sve.revd.nxv8i16(<vscale x  8 x i16> %a, <vscale x 8 x i1> %pg, <vscale x 8 x i16> %b)
  ret <vscale x 8 x i16> %res
}

define <vscale x 4 x i32> @test_revd_i32(<vscale x 4 x i32> %a, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %b) {
; CHECK-LABEL: test_revd_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x i32> @llvm.aarch64.sve.revd.nxv4i32(<vscale x 4 x i32> %a, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %b)
  ret <vscale x 4 x i32> %res
}

define <vscale x 2 x i64> @test_revd_i64(<vscale x 2 x i64> %a, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %b) {
; CHECK-LABEL: test_revd_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i64> @llvm.aarch64.sve.revd.nxv2i64(<vscale x 2 x i64> %a, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %b)
  ret <vscale x 2 x i64> %res
}

declare <vscale x 16 x i8> @llvm.aarch64.sve.revd.nxv16i8(<vscale x 16 x i8>, <vscale x 16 x i1>, <vscale x 16 x i8>)
declare <vscale x 8 x i16> @llvm.aarch64.sve.revd.nxv8i16(<vscale x 8 x i16>, <vscale x 8 x i1>, <vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.revd.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i1>, <vscale x 4 x i32>)
declare <vscale x 2 x i64> @llvm.aarch64.sve.revd.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i1>, <vscale x 2 x i64>)
