; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

;
; SDIV
;

define <vscale x 16 x i8> @sdiv_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: sdiv_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpkhi z2.h, z1.b
; CHECK-NEXT:    sunpkhi z3.h, z0.b
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sunpklo z1.h, z1.b
; CHECK-NEXT:    sunpklo z0.h, z0.b
; CHECK-NEXT:    sunpkhi z4.s, z2.h
; CHECK-NEXT:    sunpkhi z5.s, z3.h
; CHECK-NEXT:    sunpklo z2.s, z2.h
; CHECK-NEXT:    sunpklo z3.s, z3.h
; CHECK-NEXT:    sdivr z4.s, p0/m, z4.s, z5.s
; CHECK-NEXT:    sunpkhi z5.s, z1.h
; CHECK-NEXT:    sdivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    sunpkhi z3.s, z0.h
; CHECK-NEXT:    sunpklo z1.s, z1.h
; CHECK-NEXT:    sunpklo z0.s, z0.h
; CHECK-NEXT:    sdiv z3.s, p0/m, z3.s, z5.s
; CHECK-NEXT:    sdiv z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    uzp1 z1.h, z2.h, z4.h
; CHECK-NEXT:    uzp1 z0.h, z0.h, z3.h
; CHECK-NEXT:    uzp1 z0.b, z0.b, z1.b
; CHECK-NEXT:    ret
  %div = sdiv <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %div
}

define <vscale x 8 x i16> @sdiv_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: sdiv_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpkhi z2.s, z1.h
; CHECK-NEXT:    sunpkhi z3.s, z0.h
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sunpklo z1.s, z1.h
; CHECK-NEXT:    sunpklo z0.s, z0.h
; CHECK-NEXT:    sdivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    sdiv z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %div = sdiv <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %div
}

define <vscale x 4 x i32> @sdiv_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: sdiv_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sdiv z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %div = sdiv <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %div
}

define <vscale x 2 x i64> @sdiv_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: sdiv_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sdiv z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %div = sdiv <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %div
}

define <vscale x 8 x i32> @sdiv_split_i32(<vscale x 8 x i32> %a, <vscale x 8 x i32> %b) {
; CHECK-LABEL: sdiv_split_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sdiv z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    sdiv z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    ret
  %div = sdiv <vscale x 8 x i32> %a, %b
  ret <vscale x 8 x i32> %div
}

define <vscale x 2 x i32> @sdiv_widen_i32(<vscale x 2 x i32> %a, <vscale x 2 x i32> %b) {
; CHECK-LABEL: sdiv_widen_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sxtw z1.d, p0/m, z1.d
; CHECK-NEXT:    sxtw z0.d, p0/m, z0.d
; CHECK-NEXT:    sdiv z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %div = sdiv <vscale x 2 x i32> %a, %b
  ret <vscale x 2 x i32> %div
}

define <vscale x 4 x i64> @sdiv_split_i64(<vscale x 4 x i64> %a, <vscale x 4 x i64> %b) {
; CHECK-LABEL: sdiv_split_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sdiv z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    sdiv z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    ret
  %div = sdiv <vscale x 4 x i64> %a, %b
  ret <vscale x 4 x i64> %div
}

;
; SREM
;

define <vscale x 16 x i8> @srem_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: srem_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpkhi z2.h, z1.b
; CHECK-NEXT:    sunpkhi z3.h, z0.b
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sunpklo z4.h, z1.b
; CHECK-NEXT:    sunpklo z5.h, z0.b
; CHECK-NEXT:    sunpkhi z6.s, z2.h
; CHECK-NEXT:    sunpkhi z7.s, z3.h
; CHECK-NEXT:    sunpklo z2.s, z2.h
; CHECK-NEXT:    sunpklo z3.s, z3.h
; CHECK-NEXT:    sdivr z6.s, p0/m, z6.s, z7.s
; CHECK-NEXT:    sunpkhi z7.s, z4.h
; CHECK-NEXT:    sdivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    sunpkhi z3.s, z5.h
; CHECK-NEXT:    sunpklo z4.s, z4.h
; CHECK-NEXT:    sunpklo z5.s, z5.h
; CHECK-NEXT:    sdiv z3.s, p0/m, z3.s, z7.s
; CHECK-NEXT:    sdivr z4.s, p0/m, z4.s, z5.s
; CHECK-NEXT:    uzp1 z2.h, z2.h, z6.h
; CHECK-NEXT:    uzp1 z3.h, z4.h, z3.h
; CHECK-NEXT:    uzp1 z2.b, z3.b, z2.b
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    mul z2.b, p0/m, z2.b, z1.b
; CHECK-NEXT:    sub z0.b, z0.b, z2.b
; CHECK-NEXT:    ret
  %div = srem <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %div
}

define <vscale x 8 x i16> @srem_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: srem_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpkhi z2.s, z1.h
; CHECK-NEXT:    sunpkhi z3.s, z0.h
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sdivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    sunpklo z4.s, z1.h
; CHECK-NEXT:    sunpklo z5.s, z0.h
; CHECK-NEXT:    movprfx z3, z5
; CHECK-NEXT:    sdiv z3.s, p0/m, z3.s, z4.s
; CHECK-NEXT:    uzp1 z2.h, z3.h, z2.h
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    mul z2.h, p0/m, z2.h, z1.h
; CHECK-NEXT:    sub z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %div = srem <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %div
}

define <vscale x 4 x i32> @srem_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: srem_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    movprfx z2, z0
; CHECK-NEXT:    sdiv z2.s, p0/m, z2.s, z1.s
; CHECK-NEXT:    mul z2.s, p0/m, z2.s, z1.s
; CHECK-NEXT:    sub z0.s, z0.s, z2.s
; CHECK-NEXT:    ret
  %div = srem <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %div
}

define <vscale x 2 x i64> @srem_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: srem_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    movprfx z2, z0
; CHECK-NEXT:    sdiv z2.d, p0/m, z2.d, z1.d
; CHECK-NEXT:    mul z2.d, p0/m, z2.d, z1.d
; CHECK-NEXT:    sub z0.d, z0.d, z2.d
; CHECK-NEXT:    ret
  %div = srem <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %div
}

;
; UDIV
;

define <vscale x 16 x i8> @udiv_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: udiv_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z2.h, z1.b
; CHECK-NEXT:    uunpkhi z3.h, z0.b
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    uunpklo z1.h, z1.b
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpkhi z4.s, z2.h
; CHECK-NEXT:    uunpkhi z5.s, z3.h
; CHECK-NEXT:    uunpklo z2.s, z2.h
; CHECK-NEXT:    uunpklo z3.s, z3.h
; CHECK-NEXT:    udivr z4.s, p0/m, z4.s, z5.s
; CHECK-NEXT:    uunpkhi z5.s, z1.h
; CHECK-NEXT:    udivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    uunpkhi z3.s, z0.h
; CHECK-NEXT:    uunpklo z1.s, z1.h
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    udiv z3.s, p0/m, z3.s, z5.s
; CHECK-NEXT:    udiv z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    uzp1 z1.h, z2.h, z4.h
; CHECK-NEXT:    uzp1 z0.h, z0.h, z3.h
; CHECK-NEXT:    uzp1 z0.b, z0.b, z1.b
; CHECK-NEXT:    ret
  %div = udiv <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %div
}

define <vscale x 8 x i16> @udiv_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: udiv_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z2.s, z1.h
; CHECK-NEXT:    uunpkhi z3.s, z0.h
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    uunpklo z1.s, z1.h
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    udivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    udiv z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    uzp1 z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %div = udiv <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %div
}

define <vscale x 4 x i32> @udiv_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: udiv_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    udiv z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %div = udiv <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %div
}

define <vscale x 2 x i64> @udiv_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: udiv_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    udiv z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %div = udiv <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %div
}

define <vscale x 8 x i32> @udiv_split_i32(<vscale x 8 x i32> %a, <vscale x 8 x i32> %b) {
; CHECK-LABEL: udiv_split_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    udiv z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    udiv z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    ret
  %div = udiv <vscale x 8 x i32> %a, %b
  ret <vscale x 8 x i32> %div
}

define <vscale x 2 x i32> @udiv_widen_i32(<vscale x 2 x i32> %a, <vscale x 2 x i32> %b) {
; CHECK-LABEL: udiv_widen_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z1.d, z1.d, #0xffffffff
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    udiv z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %div = udiv <vscale x 2 x i32> %a, %b
  ret <vscale x 2 x i32> %div
}

define <vscale x 4 x i64> @udiv_split_i64(<vscale x 4 x i64> %a, <vscale x 4 x i64> %b) {
; CHECK-LABEL: udiv_split_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    udiv z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    udiv z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    ret
  %div = udiv <vscale x 4 x i64> %a, %b
  ret <vscale x 4 x i64> %div
}


;
; UREM
;

define <vscale x 16 x i8> @urem_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: urem_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z2.h, z1.b
; CHECK-NEXT:    uunpkhi z3.h, z0.b
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    uunpklo z4.h, z1.b
; CHECK-NEXT:    uunpklo z5.h, z0.b
; CHECK-NEXT:    uunpkhi z6.s, z2.h
; CHECK-NEXT:    uunpkhi z7.s, z3.h
; CHECK-NEXT:    uunpklo z2.s, z2.h
; CHECK-NEXT:    uunpklo z3.s, z3.h
; CHECK-NEXT:    udivr z6.s, p0/m, z6.s, z7.s
; CHECK-NEXT:    uunpkhi z7.s, z4.h
; CHECK-NEXT:    udivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    uunpkhi z3.s, z5.h
; CHECK-NEXT:    uunpklo z4.s, z4.h
; CHECK-NEXT:    uunpklo z5.s, z5.h
; CHECK-NEXT:    udiv z3.s, p0/m, z3.s, z7.s
; CHECK-NEXT:    udivr z4.s, p0/m, z4.s, z5.s
; CHECK-NEXT:    uzp1 z2.h, z2.h, z6.h
; CHECK-NEXT:    uzp1 z3.h, z4.h, z3.h
; CHECK-NEXT:    uzp1 z2.b, z3.b, z2.b
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    mul z2.b, p0/m, z2.b, z1.b
; CHECK-NEXT:    sub z0.b, z0.b, z2.b
; CHECK-NEXT:    ret
  %div = urem <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %div
}

define <vscale x 8 x i16> @urem_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: urem_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z2.s, z1.h
; CHECK-NEXT:    uunpkhi z3.s, z0.h
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    udivr z2.s, p0/m, z2.s, z3.s
; CHECK-NEXT:    uunpklo z4.s, z1.h
; CHECK-NEXT:    uunpklo z5.s, z0.h
; CHECK-NEXT:    movprfx z3, z5
; CHECK-NEXT:    udiv z3.s, p0/m, z3.s, z4.s
; CHECK-NEXT:    uzp1 z2.h, z3.h, z2.h
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    mul z2.h, p0/m, z2.h, z1.h
; CHECK-NEXT:    sub z0.h, z0.h, z2.h
; CHECK-NEXT:    ret
  %div = urem <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %div
}

define <vscale x 4 x i32> @urem_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: urem_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    movprfx z2, z0
; CHECK-NEXT:    udiv z2.s, p0/m, z2.s, z1.s
; CHECK-NEXT:    mul z2.s, p0/m, z2.s, z1.s
; CHECK-NEXT:    sub z0.s, z0.s, z2.s
; CHECK-NEXT:    ret
  %div = urem <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %div
}

define <vscale x 2 x i64> @urem_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: urem_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    movprfx z2, z0
; CHECK-NEXT:    udiv z2.d, p0/m, z2.d, z1.d
; CHECK-NEXT:    mul z2.d, p0/m, z2.d, z1.d
; CHECK-NEXT:    sub z0.d, z0.d, z2.d
; CHECK-NEXT:    ret
  %div = urem <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %div
}

;
; SMIN
;

define <vscale x 16 x i8> @smin_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: smin_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    smin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 16 x i8> %a, %b
  %min = select <vscale x 16 x i1> %cmp, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b
  ret <vscale x 16 x i8> %min
}

define <vscale x 8 x i16> @smin_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: smin_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    smin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 8 x i16> %a, %b
  %min = select <vscale x 8 x i1> %cmp, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b
  ret <vscale x 8 x i16> %min
}

define <vscale x 4 x i32> @smin_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: smin_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 4 x i32> %a, %b
  %min = select <vscale x 4 x i1> %cmp, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b
  ret <vscale x 4 x i32> %min
}

define <vscale x 2 x i64> @smin_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: smin_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    smin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 2 x i64> %a, %b
  %min = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %a, <vscale x 2 x i64> %b
  ret <vscale x 2 x i64> %min
}

define <vscale x 32 x i8> @smin_split_i8(<vscale x 32 x i8> %a, <vscale x 32 x i8> %b) {
; CHECK-LABEL: smin_split_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    smin z0.b, p0/m, z0.b, z2.b
; CHECK-NEXT:    smin z1.b, p0/m, z1.b, z3.b
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 32 x i8> %a, %b
  %min = select <vscale x 32 x i1> %cmp, <vscale x 32 x i8> %a, <vscale x 32 x i8> %b
  ret <vscale x 32 x i8> %min
}

define <vscale x 32 x i16> @smin_split_i16(<vscale x 32 x i16> %a, <vscale x 32 x i16> %b) {
; CHECK-LABEL: smin_split_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    smin z0.h, p0/m, z0.h, z4.h
; CHECK-NEXT:    smin z1.h, p0/m, z1.h, z5.h
; CHECK-NEXT:    smin z2.h, p0/m, z2.h, z6.h
; CHECK-NEXT:    smin z3.h, p0/m, z3.h, z7.h
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 32 x i16> %a, %b
  %min = select <vscale x 32 x i1> %cmp, <vscale x 32 x i16> %a, <vscale x 32 x i16> %b
  ret <vscale x 32 x i16> %min
}

define <vscale x 8 x i32> @smin_split_i32(<vscale x 8 x i32> %a, <vscale x 8 x i32> %b) {
; CHECK-LABEL: smin_split_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    smin z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 8 x i32> %a, %b
  %min = select <vscale x 8 x i1> %cmp, <vscale x 8 x i32> %a, <vscale x 8 x i32> %b
  ret <vscale x 8 x i32> %min
}

define <vscale x 4 x i64> @smin_split_i64(<vscale x 4 x i64> %a, <vscale x 4 x i64> %b) {
; CHECK-LABEL: smin_split_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    smin z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    smin z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 4 x i64> %a, %b
  %min = select <vscale x 4 x i1> %cmp, <vscale x 4 x i64> %a, <vscale x 4 x i64> %b
  ret <vscale x 4 x i64> %min
}

define <vscale x 8 x i8> @smin_promote_i8(<vscale x 8 x i8> %a, <vscale x 8 x i8> %b) {
; CHECK-LABEL: smin_promote_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    sxtb z1.h, p0/m, z1.h
; CHECK-NEXT:    sxtb z0.h, p0/m, z0.h
; CHECK-NEXT:    smin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 8 x i8> %a, %b
  %min = select <vscale x 8 x i1> %cmp, <vscale x 8 x i8> %a, <vscale x 8 x i8> %b
  ret <vscale x 8 x i8> %min
}

define <vscale x 4 x i16> @smin_promote_i16(<vscale x 4 x i16> %a, <vscale x 4 x i16> %b) {
; CHECK-LABEL: smin_promote_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sxth z1.s, p0/m, z1.s
; CHECK-NEXT:    sxth z0.s, p0/m, z0.s
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 4 x i16> %a, %b
  %min = select <vscale x 4 x i1> %cmp, <vscale x 4 x i16> %a, <vscale x 4 x i16> %b
  ret <vscale x 4 x i16> %min
}

define <vscale x 2 x i32> @smin_promote_i32(<vscale x 2 x i32> %a, <vscale x 2 x i32> %b) {
; CHECK-LABEL: smin_promote_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sxtw z1.d, p0/m, z1.d
; CHECK-NEXT:    sxtw z0.d, p0/m, z0.d
; CHECK-NEXT:    smin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 2 x i32> %a, %b
  %min = select <vscale x 2 x i1> %cmp, <vscale x 2 x i32> %a, <vscale x 2 x i32> %b
  ret <vscale x 2 x i32> %min
}

;
; UMIN
;

define <vscale x 16 x i8> @umin_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: umin_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    umin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %cmp = icmp ult <vscale x 16 x i8> %a, %b
  %min = select <vscale x 16 x i1> %cmp, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b
  ret <vscale x 16 x i8> %min
}

define <vscale x 8 x i16> @umin_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: umin_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    umin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %cmp = icmp ult <vscale x 8 x i16> %a, %b
  %min = select <vscale x 8 x i1> %cmp, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b
  ret <vscale x 8 x i16> %min
}

define <vscale x 4 x i32> @umin_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: umin_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    umin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %cmp = icmp ult <vscale x 4 x i32> %a, %b
  %min = select <vscale x 4 x i1> %cmp, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b
  ret <vscale x 4 x i32> %min
}

define <vscale x 2 x i64> @umin_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: umin_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    umin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %cmp = icmp ult <vscale x 2 x i64> %a, %b
  %min = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %a, <vscale x 2 x i64> %b
  ret <vscale x 2 x i64> %min
}

define <vscale x 4 x i64> @umin_split_i64(<vscale x 4 x i64> %a, <vscale x 4 x i64> %b) {
; CHECK-LABEL: umin_split_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    umin z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    umin z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    ret
  %cmp = icmp ult <vscale x 4 x i64> %a, %b
  %min = select <vscale x 4 x i1> %cmp, <vscale x 4 x i64> %a, <vscale x 4 x i64> %b
  ret <vscale x 4 x i64> %min
}

define <vscale x 8 x i8> @umin_promote_i8(<vscale x 8 x i8> %a, <vscale x 8 x i8> %b) {
; CHECK-LABEL: umin_promote_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    and z1.h, z1.h, #0xff
; CHECK-NEXT:    and z0.h, z0.h, #0xff
; CHECK-NEXT:    umin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %cmp = icmp ult <vscale x 8 x i8> %a, %b
  %min = select <vscale x 8 x i1> %cmp, <vscale x 8 x i8> %a, <vscale x 8 x i8> %b
  ret <vscale x 8 x i8> %min
}

;
; SMAX
;

define <vscale x 16 x i8> @smax_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: smax_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    smax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 16 x i8> %a, %b
  %max = select <vscale x 16 x i1> %cmp, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b
  ret <vscale x 16 x i8> %max
}

define <vscale x 8 x i16> @smax_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: smax_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    smax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 8 x i16> %a, %b
  %max = select <vscale x 8 x i1> %cmp, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b
  ret <vscale x 8 x i16> %max
}

define <vscale x 4 x i32> @smax_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: smax_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 4 x i32> %a, %b
  %max = select <vscale x 4 x i1> %cmp, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b
  ret <vscale x 4 x i32> %max
}

define <vscale x 2 x i64> @smax_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: smax_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    smax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 2 x i64> %a, %b
  %max = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %a, <vscale x 2 x i64> %b
  ret <vscale x 2 x i64> %max
}

define <vscale x 8 x i32> @smax_split_i32(<vscale x 8 x i32> %a, <vscale x 8 x i32> %b) {
; CHECK-LABEL: smax_split_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    smax z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 8 x i32> %a, %b
  %max = select <vscale x 8 x i1> %cmp, <vscale x 8 x i32> %a, <vscale x 8 x i32> %b
  ret <vscale x 8 x i32> %max
}

define <vscale x 4 x i16> @smax_promote_i16(<vscale x 4 x i16> %a, <vscale x 4 x i16> %b) {
; CHECK-LABEL: smax_promote_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    sxth z1.s, p0/m, z1.s
; CHECK-NEXT:    sxth z0.s, p0/m, z0.s
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 4 x i16> %a, %b
  %max = select <vscale x 4 x i1> %cmp, <vscale x 4 x i16> %a, <vscale x 4 x i16> %b
  ret <vscale x 4 x i16> %max
}

;
; UMAX
;

define <vscale x 16 x i8> @umax_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: umax_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    umax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %cmp = icmp ugt <vscale x 16 x i8> %a, %b
  %max = select <vscale x 16 x i1> %cmp, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b
  ret <vscale x 16 x i8> %max
}

define <vscale x 8 x i16> @umax_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: umax_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    umax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %cmp = icmp ugt <vscale x 8 x i16> %a, %b
  %max = select <vscale x 8 x i1> %cmp, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b
  ret <vscale x 8 x i16> %max
}

define <vscale x 4 x i32> @umax_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: umax_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    umax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %cmp = icmp ugt <vscale x 4 x i32> %a, %b
  %max = select <vscale x 4 x i1> %cmp, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b
  ret <vscale x 4 x i32> %max
}

define <vscale x 2 x i64> @umax_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: umax_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    umax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %cmp = icmp ugt <vscale x 2 x i64> %a, %b
  %max = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %a, <vscale x 2 x i64> %b
  ret <vscale x 2 x i64> %max
}

define <vscale x 16 x i16> @umax_split_i16(<vscale x 16 x i16> %a, <vscale x 16 x i16> %b) {
; CHECK-LABEL: umax_split_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    umax z0.h, p0/m, z0.h, z2.h
; CHECK-NEXT:    umax z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    ret
  %cmp = icmp ugt <vscale x 16 x i16> %a, %b
  %max = select <vscale x 16 x i1> %cmp, <vscale x 16 x i16> %a, <vscale x 16 x i16> %b
  ret <vscale x 16 x i16> %max
}

define <vscale x 2 x i32> @umax_promote_i32(<vscale x 2 x i32> %a, <vscale x 2 x i32> %b) {
; CHECK-LABEL: umax_promote_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z1.d, z1.d, #0xffffffff
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    umax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %cmp = icmp ugt <vscale x 2 x i32> %a, %b
  %max = select <vscale x 2 x i1> %cmp, <vscale x 2 x i32> %a, <vscale x 2 x i32> %b
  ret <vscale x 2 x i32> %max
}

;
; ASR
;

define <vscale x 16 x i8> @asr_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b){
; CHECK-LABEL: asr_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    asr z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %shr
}

define <vscale x 8 x i16> @asr_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b){
; CHECK-LABEL: asr_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    asr z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %shr
}

define <vscale x 4 x i32> @asr_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b){
; CHECK-LABEL: asr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    asr z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %shr
}

define <vscale x 2 x i64> @asr_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b){
; CHECK-LABEL: asr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    asr z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %shr
}

define <vscale x 16 x i16> @asr_split_i16(<vscale x 16 x i16> %a, <vscale x 16 x i16> %b){
; CHECK-LABEL: asr_split_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    asr z0.h, p0/m, z0.h, z2.h
; CHECK-NEXT:    asr z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 16 x i16> %a, %b
  ret <vscale x 16 x i16> %shr
}

define <vscale x 2 x i32> @asr_promote_i32(<vscale x 2 x i32> %a, <vscale x 2 x i32> %b){
; CHECK-LABEL: asr_promote_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sxtw z0.d, p0/m, z0.d
; CHECK-NEXT:    and z1.d, z1.d, #0xffffffff
; CHECK-NEXT:    asr z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 2 x i32> %a, %b
  ret <vscale x 2 x i32> %shr
}

;
; ASRR
;

define <vscale x 16 x i8> @asrr_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b){
; CHECK-LABEL: asrr_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    asrr z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 16 x i8> %b, %a
  ret <vscale x 16 x i8> %shr
}

define <vscale x 8 x i16> @asrr_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b){
; CHECK-LABEL: asrr_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    asrr z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 8 x i16> %b, %a
  ret <vscale x 8 x i16> %shr
}

define <vscale x 4 x i32> @asrr_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b){
; CHECK-LABEL: asrr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    asrr z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 4 x i32> %b, %a
  ret <vscale x 4 x i32> %shr
}

define <vscale x 2 x i64> @asrr_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b){
; CHECK-LABEL: asrr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    asrr z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %shr = ashr <vscale x 2 x i64> %b, %a
  ret <vscale x 2 x i64> %shr
}

;
; LSL
;

define <vscale x 16 x i8> @lsl_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b){
; CHECK-LABEL: lsl_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    lsl z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %shl = shl <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %shl
}

define <vscale x 8 x i16> @lsl_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b){
; CHECK-LABEL: lsl_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    lsl z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %shl = shl <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %shl
}

define <vscale x 4 x i32> @lsl_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b){
; CHECK-LABEL: lsl_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    lsl z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %shl = shl <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %shl
}

define <vscale x 2 x i64> @lsl_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b){
; CHECK-LABEL: lsl_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    lsl z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %shl = shl <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %shl
}

define <vscale x 4 x i64> @lsl_split_i64(<vscale x 4 x i64> %a, <vscale x 4 x i64> %b){
; CHECK-LABEL: lsl_split_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    lsl z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    lsl z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    ret
  %shl = shl <vscale x 4 x i64> %a, %b
  ret <vscale x 4 x i64> %shl
}

define <vscale x 4 x i16> @lsl_promote_i16(<vscale x 4 x i16> %a, <vscale x 4 x i16> %b){
; CHECK-LABEL: lsl_promote_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    and z1.s, z1.s, #0xffff
; CHECK-NEXT:    lsl z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %shl = shl <vscale x 4 x i16> %a, %b
  ret <vscale x 4 x i16> %shl
}

;
; LSLR
;

define <vscale x 16 x i8> @lslr_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b){
; CHECK-LABEL: lslr_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    lslr z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %shl = shl <vscale x 16 x i8> %b, %a
  ret <vscale x 16 x i8> %shl
}

define <vscale x 8 x i16> @lslr_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b){
; CHECK-LABEL: lslr_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    lslr z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %shl = shl <vscale x 8 x i16> %b, %a
  ret <vscale x 8 x i16> %shl
}

define <vscale x 4 x i32> @lslr_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b){
; CHECK-LABEL: lslr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    lslr z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %shl = shl <vscale x 4 x i32> %b, %a
  ret <vscale x 4 x i32> %shl
}

define <vscale x 2 x i64> @lslr_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b){
; CHECK-LABEL: lslr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    lslr z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %shl = shl <vscale x 2 x i64> %b, %a
  ret <vscale x 2 x i64> %shl
}

;
; LSR
;

define <vscale x 16 x i8> @lsr_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b){
; CHECK-LABEL: lsr_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    lsr z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 16 x i8> %a, %b
  ret <vscale x 16 x i8> %shr
}

define <vscale x 8 x i16> @lsr_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b){
; CHECK-LABEL: lsr_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    lsr z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 8 x i16> %a, %b
  ret <vscale x 8 x i16> %shr
}

define <vscale x 4 x i32> @lsr_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b){
; CHECK-LABEL: lsr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    lsr z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 4 x i32> %a, %b
  ret <vscale x 4 x i32> %shr
}

define <vscale x 2 x i64> @lsr_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b){
; CHECK-LABEL: lsr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    lsr z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 2 x i64> %a, %b
  ret <vscale x 2 x i64> %shr
}

define <vscale x 8 x i8> @lsr_promote_i8(<vscale x 8 x i8> %a, <vscale x 8 x i8> %b){
; CHECK-LABEL: lsr_promote_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    and z1.h, z1.h, #0xff
; CHECK-NEXT:    and z0.h, z0.h, #0xff
; CHECK-NEXT:    lsr z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 8 x i8> %a, %b
  ret <vscale x 8 x i8> %shr
}

define <vscale x 8 x i32> @lsr_split_i32(<vscale x 8 x i32> %a, <vscale x 8 x i32> %b){
; CHECK-LABEL: lsr_split_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    lsr z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    lsr z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 8 x i32> %a, %b
  ret <vscale x 8 x i32> %shr
}

;
; LSRR
;

define <vscale x 16 x i8> @lsrr_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b){
; CHECK-LABEL: lsrr_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    lsrr z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 16 x i8> %b, %a
  ret <vscale x 16 x i8> %shr
}

define <vscale x 8 x i16> @lsrr_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b){
; CHECK-LABEL: lsrr_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    lsrr z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 8 x i16> %b, %a
  ret <vscale x 8 x i16> %shr
}

define <vscale x 4 x i32> @lsrr_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b){
; CHECK-LABEL: lsrr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    lsrr z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 4 x i32> %b, %a
  ret <vscale x 4 x i32> %shr
}

define <vscale x 2 x i64> @lsrr_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b){
; CHECK-LABEL: lsrr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    lsrr z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    ret
  %shr = lshr <vscale x 2 x i64> %b, %a
  ret <vscale x 2 x i64> %shr
}

;
; CMP
;

define <vscale x 32 x i1> @cmp_split_32(<vscale x 32 x i8> %a, <vscale x 32 x i8> %b) {
; CHECK-LABEL: cmp_split_32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    cmpgt p0.b, p1/z, z2.b, z0.b
; CHECK-NEXT:    cmpgt p1.b, p1/z, z3.b, z1.b
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 32 x i8> %a, %b
  ret <vscale x 32 x i1> %cmp
}

define <vscale x 64 x i1> @cmp_split_64(<vscale x 64 x i8> %a, <vscale x 64 x i8> %b) {
; CHECK-LABEL: cmp_split_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p3.b
; CHECK-NEXT:    cmpgt p0.b, p3/z, z0.b, z4.b
; CHECK-NEXT:    cmpgt p1.b, p3/z, z1.b, z5.b
; CHECK-NEXT:    cmpgt p2.b, p3/z, z2.b, z6.b
; CHECK-NEXT:    cmpgt p3.b, p3/z, z3.b, z7.b
; CHECK-NEXT:    ret
  %cmp = icmp sgt <vscale x 64 x i8> %a, %b
  ret <vscale x 64 x i1> %cmp
}
