; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s

define i1 @combine_setcc_eq_vecreduce_or_v8i1(<8 x i8> %a) {
; CHECK-LABEL: combine_setcc_eq_vecreduce_or_v8i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v0.8b, v0.8b, #0
; CHECK-NEXT:    umaxv b0, v0.8b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    mvn w8, w8
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp eq <8 x i8> %a, zeroinitializer
  %cast = bitcast <8 x i1> %cmp1 to i8
  %cmp2 = icmp eq i8 %cast, zeroinitializer
  ret i1 %cmp2
}

define i1 @combine_setcc_eq_vecreduce_or_v16i1(<16 x i8> %a) {
; CHECK-LABEL: combine_setcc_eq_vecreduce_or_v16i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v0.16b, v0.16b, #0
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    mvn w8, w8
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp eq <16 x i8> %a, zeroinitializer
  %cast = bitcast <16 x i1> %cmp1 to i16
  %cmp2 = icmp eq i16 %cast, zeroinitializer
  ret i1 %cmp2
}

define i1 @combine_setcc_eq_vecreduce_or_v32i1(<32 x i8> %a) {
; CHECK-LABEL: combine_setcc_eq_vecreduce_or_v32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v1.16b, v1.16b, #0
; CHECK-NEXT:    cmeq v0.16b, v0.16b, #0
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    mvn w8, w8
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp eq <32 x i8> %a, zeroinitializer
  %cast = bitcast <32 x i1> %cmp1 to i32
  %cmp2 = icmp eq i32 %cast, zeroinitializer
  ret i1 %cmp2
}

define i1 @combine_setcc_eq_vecreduce_or_v64i1(<64 x i8> %a) {
; CHECK-LABEL: combine_setcc_eq_vecreduce_or_v64i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v2.16b, v2.16b, #0
; CHECK-NEXT:    cmeq v3.16b, v3.16b, #0
; CHECK-NEXT:    cmeq v1.16b, v1.16b, #0
; CHECK-NEXT:    cmeq v0.16b, v0.16b, #0
; CHECK-NEXT:    orr v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    mvn w8, w8
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp eq <64 x i8> %a, zeroinitializer
  %cast = bitcast <64 x i1> %cmp1 to i64
  %cmp2 = icmp eq i64 %cast, zeroinitializer
  ret i1 %cmp2
}

define i1 @combine_setcc_ne_vecreduce_or_v8i1(<8 x i8> %a) {
; CHECK-LABEL: combine_setcc_ne_vecreduce_or_v8i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmtst v0.8b, v0.8b, v0.8b
; CHECK-NEXT:    umaxv b0, v0.8b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp ne <8 x i8> %a, zeroinitializer
  %cast = bitcast <8 x i1> %cmp1 to i8
  %cmp2 = icmp ne i8 %cast, zeroinitializer
  ret i1 %cmp2
}

define i1 @combine_setcc_ne_vecreduce_or_v16i1(<16 x i8> %a) {
; CHECK-LABEL: combine_setcc_ne_vecreduce_or_v16i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmtst v0.16b, v0.16b, v0.16b
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp ne <16 x i8> %a, zeroinitializer
  %cast = bitcast <16 x i1> %cmp1 to i16
  %cmp2 = icmp ne i16 %cast, zeroinitializer
  ret i1 %cmp2
}

define i1 @combine_setcc_ne_vecreduce_or_v32i1(<32 x i8> %a) {
; CHECK-LABEL: combine_setcc_ne_vecreduce_or_v32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmtst v0.16b, v0.16b, v0.16b
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp ne <32 x i8> %a, zeroinitializer
  %cast = bitcast <32 x i1> %cmp1 to i32
  %cmp2 = icmp ne i32 %cast, zeroinitializer
  ret i1 %cmp2
}

define i1 @combine_setcc_ne_vecreduce_or_v64i1(<64 x i8> %a) {
; CHECK-LABEL: combine_setcc_ne_vecreduce_or_v64i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmtst v0.16b, v0.16b, v0.16b
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %cmp1 = icmp ne <64 x i8> %a, zeroinitializer
  %cast = bitcast <64 x i1> %cmp1 to i64
  %cmp2 = icmp ne i64 %cast, zeroinitializer
  ret i1 %cmp2
}
