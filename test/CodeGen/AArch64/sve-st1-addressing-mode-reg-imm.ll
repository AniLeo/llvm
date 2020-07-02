; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

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
; CHECK-NEXT:    rdvl x8, #8
; CHECK-NEXT:    add x8, x0, x8
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
; CHECK-NEXT:    rdvl x8, #-9
; CHECK-NEXT:    add x8, x0, x8
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
