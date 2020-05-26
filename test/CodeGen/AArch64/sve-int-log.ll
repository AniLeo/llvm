; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; WARN-NOT: warning

define <vscale x 2 x i64> @and_d(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: and_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = and <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %res
}

define <vscale x 4 x i32> @and_s(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: and_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = and <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %res
}

define <vscale x 8 x i16> @and_h(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: and_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = and <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %res
}

define <vscale x 16 x i8> @and_b(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: and_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = and <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %res
}

define <vscale x 2 x i1> @and_pred_d(<vscale x 2 x i1> %a, <vscale x 2 x i1> %b) {
; CHECK-LABEL: and_pred_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.d
; CHECK-NEXT:    and p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 2 x i1> %a, %b
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @and_pred_s(<vscale x 4 x i1> %a, <vscale x 4 x i1> %b) {
; CHECK-LABEL: and_pred_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.s
; CHECK-NEXT:    and p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 4 x i1> %a, %b
  ret <vscale x 4 x i1> %res
}

define <vscale x 8 x i1> @and_pred_h(<vscale x 8 x i1> %a, <vscale x 8 x i1> %b) {
; CHECK-LABEL: and_pred_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.h
; CHECK-NEXT:    and p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 8 x i1> %a, %b
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @and_pred_b(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: and_pred_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    and p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 16 x i1> %a, %b
  ret <vscale x 16 x i1> %res
}

define <vscale x 2 x i64> @or_d(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: or_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = or <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %res
}

define <vscale x 4 x i32> @or_s(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: or_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = or <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %res
}

define <vscale x 8 x i16> @or_h(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: or_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = or <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %res
}

define <vscale x 16 x i8> @or_b(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: or_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = or <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %res
}

define <vscale x 2 x i1> @or_pred_d(<vscale x 2 x i1> %a, <vscale x 2 x i1> %b) {
; CHECK-LABEL: or_pred_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.d
; CHECK-NEXT:    orr p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 2 x i1> %a, %b
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @or_pred_s(<vscale x 4 x i1> %a, <vscale x 4 x i1> %b) {
; CHECK-LABEL: or_pred_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.s
; CHECK-NEXT:    orr p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 4 x i1> %a, %b
  ret <vscale x 4 x i1> %res
}

define <vscale x 8 x i1> @or_pred_h(<vscale x 8 x i1> %a, <vscale x 8 x i1> %b) {
; CHECK-LABEL: or_pred_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.h
; CHECK-NEXT:    orr p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 8 x i1> %a, %b
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @or_pred_b(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: or_pred_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    orr p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 16 x i1> %a, %b
  ret <vscale x 16 x i1> %res
}

define <vscale x 2 x i64> @xor_d(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: xor_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = xor <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %res
}

define <vscale x 4 x i32> @xor_s(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: xor_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = xor <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %res
}

define <vscale x 8 x i16> @xor_h(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: xor_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = xor <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %res
}

define <vscale x 16 x i8> @xor_b(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: xor_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %res = xor <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %res
}

define <vscale x 2 x i1> @xor_pred_d(<vscale x 2 x i1> %a, <vscale x 2 x i1> %b) {
; CHECK-LABEL: xor_pred_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.d
; CHECK-NEXT:    eor p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = xor <vscale x 2 x i1> %a, %b
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @xor_pred_s(<vscale x 4 x i1> %a, <vscale x 4 x i1> %b) {
; CHECK-LABEL: xor_pred_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.s
; CHECK-NEXT:    eor p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = xor <vscale x 4 x i1> %a, %b
  ret <vscale x 4 x i1> %res
}

define <vscale x 8 x i1> @xor_pred_h(<vscale x 8 x i1> %a, <vscale x 8 x i1> %b) {
; CHECK-LABEL: xor_pred_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.h
; CHECK-NEXT:    eor p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = xor <vscale x 8 x i1> %a, %b
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @xor_pred_b(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: xor_pred_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    eor p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = xor <vscale x 16 x i1> %a, %b
  ret <vscale x 16 x i1> %res
}
