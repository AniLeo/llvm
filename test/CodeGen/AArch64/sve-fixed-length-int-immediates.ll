; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -aarch64-sve-vector-bits-min=512 < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; Although SVE immediate packing should be fully tested using scalable vectors,
; these tests protects against the possibility that scalable nodes, resulting
; from lowering fixed length vector operations, trigger different isel patterns.

;
; ADD
;

define void @add_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: add_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    mov z1.b, #7 // =0x7
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    add z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = add <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @add_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: add_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    mov z1.h, #15 // =0xf
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    add z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = add <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @add_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: add_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    mov z1.s, #31 // =0x1f
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    add z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = add <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @add_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: add_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    mov z1.d, #63 // =0x3f
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    add z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = add <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; AND
;

define void @and_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: and_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    and z0.b, z0.b, #0x7
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = and <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @and_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: and_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    and z0.h, z0.h, #0xf
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = and <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @and_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: and_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    and z0.s, z0.s, #0x1f
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = and <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @and_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: and_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    and z0.d, z0.d, #0x3f
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = and <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; ASHR
;

define void @ashr_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: ashr_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    asr z0.b, p0/m, z0.b, #7
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = ashr <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @ashr_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: ashr_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    asr z0.h, p0/m, z0.h, #15
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = ashr <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @ashr_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: ashr_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    asr z0.s, p0/m, z0.s, #31
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = ashr <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @ashr_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: ashr_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    asr z0.d, p0/m, z0.d, #63
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = ashr <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; ICMP
;

define void @icmp_eq_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: icmp_eq_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    cmpeq p1.b, p0/z, z0.b, #7
; CHECK-NEXT:    mov z0.b, p1/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %cmp = icmp eq <64 x i8> %op1, %op2
  %res = sext <64 x i1> %cmp to <64 x i8>
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @icmp_sge_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: icmp_sge_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    cmpge p1.h, p0/z, z0.h, #15
; CHECK-NEXT:    mov z0.h, p1/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %cmp = icmp sge <32 x i16> %op1, %op2
  %res = sext <32 x i1> %cmp to <32 x i16>
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @icmp_sgt_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: icmp_sgt_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    cmpgt p1.s, p0/z, z0.s, #-16
; CHECK-NEXT:    mov z0.s, p1/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 -16, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %cmp = icmp sgt <16 x i32> %op1, %op2
  %res = sext <16 x i1> %cmp to <16 x i32>
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @icmp_ult_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: icmp_ult_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    cmplo p1.d, p0/z, z0.d, #63
; CHECK-NEXT:    mov z0.d, p1/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %cmp = icmp ult <8 x i64> %op1, %op2
  %res = sext <8 x i1> %cmp to <8 x i64>
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; LSHR
;

define void @lshr_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: lshr_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    lsr z0.b, p0/m, z0.b, #7
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = lshr <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @lshr_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: lshr_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    lsr z0.h, p0/m, z0.h, #15
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = lshr <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @lshr_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: lshr_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    lsr z0.s, p0/m, z0.s, #31
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = lshr <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @lshr_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: lshr_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    lsr z0.d, p0/m, z0.d, #63
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = lshr <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; MUL
;

define void @mul_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: mul_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    mov z1.b, #7 // =0x7
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    mul z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = mul <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @mul_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: mul_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    mov z1.h, #15 // =0xf
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    mul z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = mul <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @mul_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: mul_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    mov z1.s, #31 // =0x1f
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    mul z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = mul <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @mul_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: mul_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    mov z1.d, #63 // =0x3f
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    mul z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = mul <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; OR
;

define void @or_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: or_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    orr z0.b, z0.b, #0x7
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = or <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @or_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: or_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    orr z0.h, z0.h, #0xf
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = or <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @or_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: or_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    orr z0.s, z0.s, #0x1f
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = or <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @or_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: or_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    orr z0.d, z0.d, #0x3f
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = or <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; SHL
;

define void @shl_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: shl_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    lsl z0.b, p0/m, z0.b, #7
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = shl <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @shl_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: shl_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    lsl z0.h, p0/m, z0.h, #15
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = shl <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @shl_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: shl_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    lsl z0.s, p0/m, z0.s, #31
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = shl <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @shl_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: shl_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    lsl z0.d, p0/m, z0.d, #63
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = shl <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; SMAX
;

define void @smax_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: smax_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    mov z1.b, #7 // =0x7
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    smax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = call <64 x i8> @llvm.smax.v64i8(<64 x i8> %op1, <64 x i8> %op2)
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @smax_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: smax_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    mov z1.h, #15 // =0xf
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    smax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = call <32 x i16> @llvm.smax.v32i16(<32 x i16> %op1, <32 x i16> %op2)
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @smax_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: smax_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    mov z1.s, #31 // =0x1f
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = call <16 x i32> @llvm.smax.v16i32(<16 x i32> %op1, <16 x i32> %op2)
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @smax_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: smax_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    mov z1.d, #63 // =0x3f
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    smax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.smax.v8i64(<8 x i64> %op1, <8 x i64> %op2)
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; SMIN
;

define void @smin_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: smin_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    mov z1.b, #7 // =0x7
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    smin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = call <64 x i8> @llvm.smin.v64i8(<64 x i8> %op1, <64 x i8> %op2)
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @smin_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: smin_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    mov z1.h, #15 // =0xf
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    smin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = call <32 x i16> @llvm.smin.v32i16(<32 x i16> %op1, <32 x i16> %op2)
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @smin_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: smin_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    mov z1.s, #31 // =0x1f
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = call <16 x i32> @llvm.smin.v16i32(<16 x i32> %op1, <16 x i32> %op2)
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @smin_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: smin_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    mov z1.d, #63 // =0x3f
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    smin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.smin.v8i64(<8 x i64> %op1, <8 x i64> %op2)
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; SUB
;

define void @sub_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: sub_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    mov z1.b, #7 // =0x7
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    sub z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = sub <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @sub_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: sub_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    mov z1.h, #15 // =0xf
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    sub z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = sub <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @sub_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: sub_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    mov z1.s, #31 // =0x1f
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    sub z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = sub <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @sub_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: sub_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    mov z1.d, #63 // =0x3f
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    sub z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = sub <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; UMAX
;

define void @umax_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: umax_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    mov z1.b, #7 // =0x7
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    umax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = call <64 x i8> @llvm.umax.v64i8(<64 x i8> %op1, <64 x i8> %op2)
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @umax_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: umax_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    mov z1.h, #15 // =0xf
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    umax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = call <32 x i16> @llvm.umax.v32i16(<32 x i16> %op1, <32 x i16> %op2)
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @umax_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: umax_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    mov z1.s, #31 // =0x1f
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    umax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = call <16 x i32> @llvm.umax.v16i32(<16 x i32> %op1, <16 x i32> %op2)
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @umax_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: umax_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    mov z1.d, #63 // =0x3f
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    umax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.umax.v8i64(<8 x i64> %op1, <8 x i64> %op2)
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; UMIN
;

define void @umin_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: umin_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    mov z1.b, #7 // =0x7
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    umin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = call <64 x i8> @llvm.umin.v64i8(<64 x i8> %op1, <64 x i8> %op2)
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @umin_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: umin_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    mov z1.h, #15 // =0xf
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    umin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = call <32 x i16> @llvm.umin.v32i16(<32 x i16> %op1, <32 x i16> %op2)
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @umin_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: umin_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    mov z1.s, #31 // =0x1f
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    umin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = call <16 x i32> @llvm.umin.v16i32(<16 x i32> %op1, <16 x i32> %op2)
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @umin_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: umin_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    mov z1.d, #63 // =0x3f
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    umin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = call <8 x i64> @llvm.umin.v8i64(<8 x i64> %op1, <8 x i64> %op2)
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

;
; XOR
;

define void @xor_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: xor_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0]
; CHECK-NEXT:    eor z0.b, z0.b, #0x7
; CHECK-NEXT:    st1b { z0.b }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <64 x i8>, <64 x i8>* %a
  %ins = insertelement <64 x i8> undef, i8 7, i64 0
  %op2 = shufflevector <64 x i8> %ins, <64 x i8> undef, <64 x i32> zeroinitializer
  %res = xor <64 x i8> %op1, %op2
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @xor_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: xor_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0]
; CHECK-NEXT:    eor z0.h, z0.h, #0xf
; CHECK-NEXT:    st1h { z0.h }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i16>, <32 x i16>* %a
  %ins = insertelement <32 x i16> undef, i16 15, i64 0
  %op2 = shufflevector <32 x i16> %ins, <32 x i16> undef, <32 x i32> zeroinitializer
  %res = xor <32 x i16> %op1, %op2
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @xor_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: xor_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl16
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0]
; CHECK-NEXT:    eor z0.s, z0.s, #0x1f
; CHECK-NEXT:    st1w { z0.s }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i32>, <16 x i32>* %a
  %ins = insertelement <16 x i32> undef, i32 31, i64 0
  %op2 = shufflevector <16 x i32> %ins, <16 x i32> undef, <16 x i32> zeroinitializer
  %res = xor <16 x i32> %op1, %op2
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @xor_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: xor_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0]
; CHECK-NEXT:    eor z0.d, z0.d, #0x3f
; CHECK-NEXT:    st1d { z0.d }, p0, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i64>, <8 x i64>* %a
  %ins = insertelement <8 x i64> undef, i64 63, i64 0
  %op2 = shufflevector <8 x i64> %ins, <8 x i64> undef, <8 x i32> zeroinitializer
  %res = xor <8 x i64> %op1, %op2
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

declare <64 x i8> @llvm.smax.v64i8(<64 x i8>, <64 x i8>)
declare <32 x i16> @llvm.smax.v32i16(<32 x i16>, <32 x i16>)
declare <16 x i32> @llvm.smax.v16i32(<16 x i32>, <16 x i32>)
declare <8 x i64> @llvm.smax.v8i64(<8 x i64>, <8 x i64>)

declare <64 x i8> @llvm.smin.v64i8(<64 x i8>, <64 x i8>)
declare <32 x i16> @llvm.smin.v32i16(<32 x i16>, <32 x i16>)
declare <16 x i32> @llvm.smin.v16i32(<16 x i32>, <16 x i32>)
declare <8 x i64> @llvm.smin.v8i64(<8 x i64>, <8 x i64>)

declare <64 x i8> @llvm.umax.v64i8(<64 x i8>, <64 x i8>)
declare <32 x i16> @llvm.umax.v32i16(<32 x i16>, <32 x i16>)
declare <16 x i32> @llvm.umax.v16i32(<16 x i32>, <16 x i32>)
declare <8 x i64> @llvm.umax.v8i64(<8 x i64>, <8 x i64>)

declare <64 x i8> @llvm.umin.v64i8(<64 x i8>, <64 x i8>)
declare <32 x i16> @llvm.umin.v32i16(<32 x i16>, <32 x i16>)
declare <16 x i32> @llvm.umin.v16i32(<16 x i32>, <16 x i32>)
declare <8 x i64> @llvm.umin.v8i64(<8 x i64>, <8 x i64>)

attributes #0 = { "target-features"="+sve" }
