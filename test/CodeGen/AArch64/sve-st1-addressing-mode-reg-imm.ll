; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; ST1B

define void @st1b_lower_bound(<vscale x 16 x i8> %data, <vscale x 16 x i8>* %a) {
; CHECK-LABEL: st1b_lower_bound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0, #-8, mul vl]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8>* %a, i64 -8
  store <vscale x 16 x i8> %data, <vscale x 16 x i8>* %base
  ret void
}

define void @st1b_inbound(<vscale x 16 x i8> %data, <vscale x 16 x i8>* %a) {
; CHECK-LABEL: st1b_inbound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0, #1, mul vl]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8>* %a, i64 1
  store <vscale x 16 x i8> %data, <vscale x 16 x i8>* %base
  ret void
}

define void @st1b_upper_bound(<vscale x 16 x i8> %data, <vscale x 16 x i8>* %a) {
; CHECK-LABEL: st1b_upper_bound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0, #7, mul vl]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8>* %a, i64 7
  store <vscale x 16 x i8> %data, <vscale x 16 x i8>* %base
  ret void
}

define void @st1b_out_of_upper_bound(<vscale x 16 x i8> %data, <vscale x 16 x i8>* %a) {
; CHECK-LABEL: st1b_out_of_upper_bound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    addvl x8, x0, #8
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x8]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8>* %a, i64 8
  store <vscale x 16 x i8> %data, <vscale x 16 x i8>* %base
  ret void
}

define void @st1b_out_of_lower_bound(<vscale x 16 x i8> %data, <vscale x 16 x i8>* %a) {
; CHECK-LABEL: st1b_out_of_lower_bound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    addvl x8, x0, #-9
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x8]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8>* %a, i64 -9
  store <vscale x 16 x i8> %data, <vscale x 16 x i8>* %base
  ret void
}

; ST1H

define void @st1h_inbound(<vscale x 8 x i16> %data, <vscale x 8 x i16>* %a) {
; CHECK-LABEL: st1h_inbound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0, #-6, mul vl]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 8 x i16>, <vscale x 8 x i16>* %a, i64 -6
  store <vscale x 8 x i16> %data, <vscale x 8 x i16>* %base
  ret void
}

; ST1W

define void @st1w_inbound(<vscale x 4 x i32> %data, <vscale x 4 x i32>* %a) {
; CHECK-LABEL: st1w_inbound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, #2, mul vl]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %a, i64 2
  store <vscale x 4 x i32> %data, <vscale x 4 x i32>* %base
  ret void
}

; ST1D

define void @st1d_inbound(<vscale x 2 x i64> %data, <vscale x 2 x i64>* %a) {
; CHECK-LABEL: st1d_inbound:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, #5, mul vl]
; CHECK-NEXT:    ret
  %base = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64>* %a, i64 5
  store <vscale x 2 x i64> %data, <vscale x 2 x i64>* %base
  ret void
}


; Splat stores of unpacked FP scalable vectors

define void @store_nxv2f32(<vscale x 2 x float>* %out) {
; CHECK-LABEL: store_nxv2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov z0.s, #1.00000000
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    st1w { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 2 x float> undef, float 1.0, i32 0
  %splat = shufflevector <vscale x 2 x float> %ins, <vscale x 2 x float> undef, <vscale x 2 x i32> zeroinitializer
  store <vscale x 2 x float> %splat, <vscale x 2 x float>* %out
  ret void
}

define void @store_nxv4f16(<vscale x 4 x half>* %out) {
; CHECK-LABEL: store_nxv4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov z0.h, #1.00000000
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1h { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 4 x half> undef, half 1.0, i32 0
  %splat = shufflevector <vscale x 4 x half> %ins, <vscale x 4 x half> undef, <vscale x 4 x i32> zeroinitializer
  store <vscale x 4 x half> %splat, <vscale x 4 x half>* %out
  ret void
}

; Splat stores of unusual FP scalable vector types

define void @store_nxv6f32(<vscale x 6 x float>* %out) {
; CHECK-LABEL: store_nxv6f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov z0.s, #1.00000000
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, #2, mul vl]
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 6 x float> undef, float 1.0, i32 0
  %splat = shufflevector <vscale x 6 x float> %ins, <vscale x 6 x float> undef, <vscale x 6 x i32> zeroinitializer
  store <vscale x 6 x float> %splat, <vscale x 6 x float>* %out
  ret void
}

define void @store_nxv12f16(<vscale x 12 x half>* %out) {
; CHECK-LABEL: store_nxv12f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov z0.h, #1.00000000
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, #2, mul vl]
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 12 x half> undef, half 1.0, i32 0
  %splat = shufflevector <vscale x 12 x half> %ins, <vscale x 12 x half> undef, <vscale x 12 x i32> zeroinitializer
  store <vscale x 12 x half> %splat, <vscale x 12 x half>* %out
  ret void
}
