; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-linux -mattr=+sse2 | FileCheck %s

define <2 x i64> @t1(<2 x i64>* %ptr) nounwind  {
; CHECK-LABEL: t1:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retl
  %tmp45 = bitcast <2 x i64>* %ptr to <2 x i32>*
  %tmp615 = load <2 x i32>, <2 x i32>* %tmp45
  %tmp7 = bitcast <2 x i32> %tmp615 to i64
  %tmp8 = insertelement <2 x i64> zeroinitializer, i64 %tmp7, i32 0
  ret <2 x i64> %tmp8
}

define <2 x i64> @t2(i64 %x) nounwind  {
; CHECK-LABEL: t2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retl
  %tmp717 = bitcast i64 %x to double
  %tmp8 = insertelement <2 x double> undef, double %tmp717, i32 0
  %tmp9 = insertelement <2 x double> %tmp8, double 0.000000e+00, i32 1
  %tmp11 = bitcast <2 x double> %tmp9 to <2 x i64>
  ret <2 x i64> %tmp11
}
