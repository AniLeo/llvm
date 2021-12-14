; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define <vscale x 2 x i1> @sge(<vscale x 2 x i8> %x) {
; CHECK-LABEL: @sge(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge <vscale x 2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    ret <vscale x 2 x i1> [[CMP]]
;
  %cmp = icmp sge <vscale x 2 x i8> %x, zeroinitializer
  ret <vscale x 2 x i1> %cmp
}

define <vscale x 2 x i1> @gep_scalevector1(i32* %X) nounwind {
; CHECK-LABEL: @gep_scalevector1(
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 2 x i32*> poison, i32* [[X:%.*]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <vscale x 2 x i32*> [[DOTSPLATINSERT]], zeroinitializer
; CHECK-NEXT:    [[C:%.*]] = shufflevector <vscale x 2 x i1> [[TMP1]], <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:    ret <vscale x 2 x i1> [[C]]
;
  %A = getelementptr inbounds i32, i32* %X, <vscale x 2 x i64> zeroinitializer
  %C = icmp eq <vscale x 2 x i32*> %A, zeroinitializer
  ret <vscale x 2 x i1> %C
}

define <vscale x 2 x i1> @signbit_bitcast_fpext_scalevec(<vscale x 2 x half> %x) {
; CHECK-LABEL: @signbit_bitcast_fpext_scalevec(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <vscale x 2 x half> [[X:%.*]] to <vscale x 2 x i16>
; CHECK-NEXT:    [[R:%.*]] = icmp slt <vscale x 2 x i16> [[TMP1]], zeroinitializer
; CHECK-NEXT:    ret <vscale x 2 x i1> [[R]]
;
  %f = fpext <vscale x 2 x half> %x to <vscale x 2 x float>
  %b = bitcast <vscale x 2 x float> %f to <vscale x 2 x i32>
  %r = icmp slt <vscale x 2 x i32> %b, zeroinitializer
  ret <vscale x 2 x i1> %r
}
