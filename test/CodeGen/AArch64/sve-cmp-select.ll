; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-unknown -mattr=+sve -o - < %s | FileCheck %s

define <vscale x 16 x i8> @vselect_cmp_ne(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c) {
; CHECK-LABEL: vselect_cmp_ne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmpne p0.b, p0/z, z0.b, z1.b
; CHECK-NEXT:    sel z0.b, p0, z1.b, z2.b
; CHECK-NEXT:    ret
  %cmp = icmp ne <vscale x 16 x i8> %a, %b
  %d = select <vscale x 16 x i1> %cmp, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c
  ret <vscale x 16 x i8> %d
}

define <vscale x 16 x i8> @vselect_cmp_sgt(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c) {
; CHECK-LABEL: vselect_cmp_sgt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmpgt p0.b, p0/z, z0.b, z1.b
; CHECK-NEXT:    sel z0.b, p0, z1.b, z2.b
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 16 x i8> %a, %b
  %d = select <vscale x 16 x i1> %cmp, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c
  ret <vscale x 16 x i8> %d
}

define <vscale x 16 x i8> @vselect_cmp_ugt(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c) {
; CHECK-LABEL: vselect_cmp_ugt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmphi p0.b, p0/z, z0.b, z1.b
; CHECK-NEXT:    sel z0.b, p0, z1.b, z2.b
; CHECK-NEXT:    ret
  %cmp = icmp ugt <vscale x 16 x i8> %a, %b
  %d = select <vscale x 16 x i1> %cmp, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c
  ret <vscale x 16 x i8> %d
}

; Some folds to remove a redundant icmp if the original input was a predicate vector.

define <vscale x 4 x i1> @fold_away_icmp_ptrue_all(<vscale x 4 x i1> %p) {
; CHECK-LABEL: fold_away_icmp_ptrue_all:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %t0 = sext <vscale x 4 x i1> %p to <vscale x 4 x i32>
  %t1 = icmp ne <vscale x 4 x i32> %t0, zeroinitializer
  ret <vscale x 4 x i1> %t1
}

define <vscale x 4 x i1> @fold_away_icmp_ptrue_vl16(<vscale x 4 x i1> %p) vscale_range(4, 4) {
; CHECK-LABEL: fold_away_icmp_ptrue_vl16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %t0 = call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 9) ;  VL16 is encoded as 9.
  %t1 = sext <vscale x 4 x i1> %p to <vscale x 4 x i32>
  %t2 = call <vscale x 4 x i1> @llvm.aarch64.sve.cmpne.nxv4i32(<vscale x 4 x i1> %t0, <vscale x 4 x i32> %t1, <vscale x 4 x i32> zeroinitializer)
  ret <vscale x 4 x i1> %t2
}


declare <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32)
declare <vscale x 4 x i1> @llvm.aarch64.sve.cmpne.nxv4i32(<vscale x 4 x i1>, <vscale x 4 x i32>, <vscale x 4 x i32>)
