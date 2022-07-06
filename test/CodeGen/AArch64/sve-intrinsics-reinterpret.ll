; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme < %s | FileCheck %s

;
; Converting to svbool_t (<vscale x 16 x i1>)
;

define <vscale x 16 x i1> @reinterpret_bool_from_b(<vscale x 16 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_from_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %out = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv16i1(<vscale x 16 x i1> %pg)
  ret <vscale x 16 x i1> %out
}

define <vscale x 16 x i1> @reinterpret_bool_from_h(<vscale x 8 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_from_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.h
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %out = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1> %pg)
  ret <vscale x 16 x i1> %out
}

define <vscale x 16 x i1> @reinterpret_bool_from_s(<vscale x 4 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_from_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %out = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> %pg)
  ret <vscale x 16 x i1> %out
}

define <vscale x 16 x i1> @reinterpret_bool_from_d(<vscale x 2 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_from_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.d
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %out = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %pg)
  ret <vscale x 16 x i1> %out
}

define <vscale x 16 x i1> @reinterpret_bool_from_q(<vscale x 1 x i1> %arg) {
; CHECK-LABEL: reinterpret_bool_from_q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.d
; CHECK-NEXT:    punpklo p1.h, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv1i1(<vscale x 1 x i1> %arg)
  ret <vscale x 16 x i1> %res
}

;
; Converting from svbool_t
;

define <vscale x 16 x i1> @reinterpret_bool_to_b(<vscale x 16 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_to_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %out = call <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1> %pg)
  ret <vscale x 16 x i1> %out
}

define <vscale x 8 x i1> @reinterpret_bool_to_h(<vscale x 16 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_to_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %out = call <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1> %pg)
  ret <vscale x 8 x i1> %out
}

define <vscale x 4 x i1> @reinterpret_bool_to_s(<vscale x 16 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_to_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %out = call <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1> %pg)
  ret <vscale x 4 x i1> %out
}

define <vscale x 2 x i1> @reinterpret_bool_to_d(<vscale x 16 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_to_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %out = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %pg)
  ret <vscale x 2 x i1> %out
}

define <vscale x 1 x i1> @reinterpret_bool_to_q(<vscale x 16 x i1> %pg) {
; CHECK-LABEL: reinterpret_bool_to_q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %out = call <vscale x 1 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv1i1(<vscale x 16 x i1> %pg)
  ret <vscale x 1 x i1> %out
}

; Reinterpreting a ptrue should not introduce an `and` instruction.
define <vscale x 16 x i1> @reinterpret_ptrue() {
; CHECK-LABEL: reinterpret_ptrue:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ret
  %in = tail call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 31)
  %out = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1> %in)
  ret <vscale x 16 x i1> %out
}

; Reinterpreting a comparison not introduce an `and` instruction.
define <vscale x 16 x i1> @reinterpret_cmpgt(<vscale x 8 x i1> %p, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: reinterpret_cmpgt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmpgt p0.h, p0/z, z0.h, z1.h
; CHECK-NEXT:    ret
  %1 = tail call <vscale x 8 x i1> @llvm.aarch64.sve.cmpgt.nxv8i16(<vscale x 8 x i1> %p, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  %2 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1> %1)
  ret <vscale x 16 x i1> %2
}

; The first reinterpret should prevent the second one from being simplified as a nop
define <vscale x 16 x i1> @chained_reinterpret() {
; CHECK-LABEL: chained_reinterpret:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    ptrue p1.d
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %in = tail call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
  %cast2 = call <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1> %in)
  %out = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %cast2)
  ret <vscale x 16 x i1> %out
}

declare <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 immarg)
declare <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 immarg)
declare <vscale x 8 x i1> @llvm.aarch64.sve.cmpgt.nxv8i16(<vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)

declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv16i1(<vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv1i1(<vscale x 1 x i1>)

declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv16i1(<vscale x 16 x i1>)
declare <vscale x 8 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv8i1(<vscale x 16 x i1>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv4i1(<vscale x 16 x i1>)
declare <vscale x 2 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv2i1(<vscale x 16 x i1>)
declare <vscale x 1 x i1> @llvm.aarch64.sve.convert.from.svbool.nxv1i1(<vscale x 16 x i1>)
