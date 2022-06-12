; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sroa -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-n8:16:32:64"

define <4 x i1> @vector_bitcast() {
; CHECK-LABEL: @vector_bitcast(
; CHECK-NEXT:    [[A:%.*]] = alloca <3 x i1>, align 1
; CHECK-NEXT:    store <3 x i1> <i1 true, i1 false, i1 true>, <3 x i1>* [[A]], align 1
; CHECK-NEXT:    [[A_0_CAST_SROA_CAST:%.*]] = bitcast <3 x i1>* [[A]] to <4 x i1>*
; CHECK-NEXT:    [[A_0_VEC:%.*]] = load <4 x i1>, <4 x i1>* [[A_0_CAST_SROA_CAST]], align 1
; CHECK-NEXT:    ret <4 x i1> [[A_0_VEC]]
;

  %a = alloca <3 x i1>
  store <3 x i1> <i1 1,i1 0,i1 1>, <3 x i1>* %a
  %cast = bitcast <3 x i1>* %a to <4 x i1>*
  %vec = load <4 x i1>, <4 x i1>* %cast
  ret <4 x i1> %vec
}

define void @vector_bitcast_2(<32 x i16> %v) {
; CHECK-LABEL: @vector_bitcast_2(
; CHECK-NEXT:    %"sum$1.host2" = alloca <32 x i16>, align 64
; CHECK-NEXT:    store <32 x i16> [[V:%.*]], <32 x i16>* %"sum$1.host2", align 64
; CHECK-NEXT:    %"sum$1.host2.0.bc.sroa_cast" = bitcast <32 x i16>* %"sum$1.host2" to <64 x i16>*
; CHECK-NEXT:    %"sum$1.host2.0.bcl" = load <64 x i16>, <64 x i16>* %"sum$1.host2.0.bc.sroa_cast", align 64
; CHECK-NEXT:    ret void
;

  %"sum$1.host2" = alloca <32 x i16>
  store <32 x i16> %v, <32 x i16>* %"sum$1.host2"
  %bc = bitcast <32 x i16>* %"sum$1.host2" to <64 x i16>*
  %bcl = load <64 x i16>, <64 x i16>* %bc
  ret void
}
