; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

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

define <vscale x 16 x i8> @and_b_zero(<vscale x 16 x i8> %a) {
; CHECK-LABEL: and_b_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.b, #0 // =0x0
; CHECK-NEXT:    ret
  %res = and <vscale x 16 x i8> %a, zeroinitializer
  ret <vscale x 16 x i8> %res
}

define <vscale x 1 x i1> @and_pred_q(<vscale x 1 x i1> %a, <vscale x 1 x i1> %b) {
; CHECK-LABEL: and_pred_q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 1 x i1> %a, %b
  ret <vscale x 1 x i1> %res
}

define <vscale x 2 x i1> @and_pred_d(<vscale x 2 x i1> %a, <vscale x 2 x i1> %b) {
; CHECK-LABEL: and_pred_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 2 x i1> %a, %b
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @and_pred_s(<vscale x 4 x i1> %a, <vscale x 4 x i1> %b) {
; CHECK-LABEL: and_pred_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 4 x i1> %a, %b
  ret <vscale x 4 x i1> %res
}

define <vscale x 8 x i1> @and_pred_h(<vscale x 8 x i1> %a, <vscale x 8 x i1> %b) {
; CHECK-LABEL: and_pred_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 8 x i1> %a, %b
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @and_pred_b(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: and_pred_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = and <vscale x 16 x i1> %a, %b
  ret <vscale x 16 x i1> %res
}

define <vscale x 2 x i64> @bic_d(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: bic_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 2 x i64> insertelement(<vscale x 2 x i64> undef, i64 -1, i32 0), <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %not_b = xor <vscale x 2 x i64> %b, %allones
  %res = and <vscale x 2 x i64> %a, %not_b
  ret <vscale x 2 x i64> %res
}

define <vscale x 4 x i32> @bic_s(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: bic_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 4 x i32> insertelement(<vscale x 4 x i32> undef, i32 -1, i32 0), <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %not_b = xor <vscale x 4 x i32> %b, %allones
  %res = and <vscale x 4 x i32> %a, %not_b
  ret <vscale x 4 x i32> %res
}

define <vscale x 8 x i16> @bic_h(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: bic_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 8 x i16> insertelement(<vscale x 8 x i16> undef, i16 -1, i32 0), <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %not_b = xor <vscale x 8 x i16> %b, %allones
  %res = and <vscale x 8 x i16> %a, %not_b
  ret <vscale x 8 x i16> %res
}

define <vscale x 16 x i8> @bic_b(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: bic_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic z0.d, z0.d, z1.d
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 16 x i8> insertelement(<vscale x 16 x i8> undef, i8 -1, i32 0), <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %not_b = xor <vscale x 16 x i8> %b, %allones
  %res = and <vscale x 16 x i8> %a, %not_b
  ret <vscale x 16 x i8> %res
}

define <vscale x 1 x i1> @bic_pred_q(<vscale x 1 x i1> %a, <vscale x 1 x i1> %b) {
; CHECK-LABEL: bic_pred_q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 1 x i1> insertelement(<vscale x 1 x i1> undef, i1 true, i32 0), <vscale x 1 x i1> undef, <vscale x 1 x i32> zeroinitializer
  %not_b = xor <vscale x 1 x i1> %b, %allones
  %res = and <vscale x 1 x i1> %a, %not_b
  ret <vscale x 1 x i1> %res
}

define <vscale x 2 x i1> @bic_pred_d(<vscale x 2 x i1> %a, <vscale x 2 x i1> %b) {
; CHECK-LABEL: bic_pred_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 2 x i1> insertelement(<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer
  %not_b = xor <vscale x 2 x i1> %b, %allones
  %res = and <vscale x 2 x i1> %a, %not_b
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @bic_pred_s(<vscale x 4 x i1> %a, <vscale x 4 x i1> %b) {
; CHECK-LABEL: bic_pred_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 4 x i1> insertelement(<vscale x 4 x i1> undef, i1 true, i32 0), <vscale x 4 x i1> undef, <vscale x 4 x i32> zeroinitializer
  %not_b = xor <vscale x 4 x i1> %b, %allones
  %res = and <vscale x 4 x i1> %a, %not_b
  ret <vscale x 4 x i1> %res
}

define <vscale x 8 x i1> @bic_pred_h(<vscale x 8 x i1> %a, <vscale x 8 x i1> %b) {
; CHECK-LABEL: bic_pred_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 8 x i1> insertelement(<vscale x 8 x i1> undef, i1 true, i32 0), <vscale x 8 x i1> undef, <vscale x 8 x i32> zeroinitializer
  %not_b = xor <vscale x 8 x i1> %b, %allones
  %res = and <vscale x 8 x i1> %a, %not_b
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @bic_pred_b(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: bic_pred_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic p0.b, p0/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %allones = shufflevector <vscale x 16 x i1> insertelement(<vscale x 16 x i1> undef, i1 true, i32 0), <vscale x 16 x i1> undef, <vscale x 16 x i32> zeroinitializer
  %not_b = xor <vscale x 16 x i1> %b, %allones
  %res = and <vscale x 16 x i1> %a, %not_b
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

define <vscale x 16 x i8> @or_b_zero(<vscale x 16 x i8> %a) {
; CHECK-LABEL: or_b_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %res = or <vscale x 16 x i8> %a, zeroinitializer
  ret <vscale x 16 x i8> %res
}

define <vscale x 1 x i1> @or_pred_q(<vscale x 1 x i1> %a, <vscale x 1 x i1> %b) {
; CHECK-LABEL: or_pred_q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sel p0.b, p0, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 1 x i1> %a, %b
  ret <vscale x 1 x i1> %res
}

define <vscale x 2 x i1> @or_pred_d(<vscale x 2 x i1> %a, <vscale x 2 x i1> %b) {
; CHECK-LABEL: or_pred_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sel p0.b, p0, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 2 x i1> %a, %b
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @or_pred_s(<vscale x 4 x i1> %a, <vscale x 4 x i1> %b) {
; CHECK-LABEL: or_pred_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sel p0.b, p0, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 4 x i1> %a, %b
  ret <vscale x 4 x i1> %res
}

define <vscale x 8 x i1> @or_pred_h(<vscale x 8 x i1> %a, <vscale x 8 x i1> %b) {
; CHECK-LABEL: or_pred_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sel p0.b, p0, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = or <vscale x 8 x i1> %a, %b
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @or_pred_b(<vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: or_pred_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sel p0.b, p0, p0.b, p1.b
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

define <vscale x 16 x i8> @xor_b_zero(<vscale x 16 x i8> %a) {
; CHECK-LABEL: xor_b_zero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %res = xor <vscale x 16 x i8> %a, zeroinitializer
  ret <vscale x 16 x i8> %res
}

define <vscale x 1 x i1> @xor_pred_q(<vscale x 1 x i1> %a, <vscale x 1 x i1> %b) {
; CHECK-LABEL: xor_pred_q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.d
; CHECK-NEXT:    eor p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ret
  %res = xor <vscale x 1 x i1> %a, %b
  ret <vscale x 1 x i1> %res
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
