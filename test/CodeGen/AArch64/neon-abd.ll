; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

;
; SABD
;

define <8 x i8> @sabd_8b(<8 x i8> %a, <8 x i8> %b) #0 {
; CHECK-LABEL: sabd_8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabd v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %a.sext = sext <8 x i8> %a to <8 x i16>
  %b.sext = sext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.sext, %b.sext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  %trunc = trunc <8 x i16> %abs to <8 x i8>
  ret <8 x i8> %trunc
}

define <16 x i8> @sabd_16b(<16 x i8> %a, <16 x i8> %b) #0 {
; CHECK-LABEL: sabd_16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabd v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a.sext = sext <16 x i8> %a to <16 x i16>
  %b.sext = sext <16 x i8> %b to <16 x i16>
  %sub = sub <16 x i16> %a.sext, %b.sext
  %abs = call <16 x i16> @llvm.abs.v16i16(<16 x i16> %sub, i1 true)
  %trunc = trunc <16 x i16> %abs to <16 x i8>
  ret <16 x i8> %trunc
}

define <4 x i16> @sabd_4h(<4 x i16> %a, <4 x i16> %b) #0 {
; CHECK-LABEL: sabd_4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabd v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    ret
  %a.sext = sext <4 x i16> %a to <4 x i32>
  %b.sext = sext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.sext, %b.sext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  %trunc = trunc <4 x i32> %abs to <4 x i16>
  ret <4 x i16> %trunc
}

define <4 x i16> @sabd_4h_promoted_ops(<4 x i8> %a, <4 x i8> %b) #0 {
; CHECK-LABEL: sabd_4h_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.4h, v0.4h, #8
; CHECK-NEXT:    shl v1.4h, v1.4h, #8
; CHECK-NEXT:    sshr v0.4h, v0.4h, #8
; CHECK-NEXT:    sshr v1.4h, v1.4h, #8
; CHECK-NEXT:    sabd v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    ret
  %a.sext = sext <4 x i8> %a to <4 x i16>
  %b.sext = sext <4 x i8> %b to <4 x i16>
  %sub = sub <4 x i16> %a.sext, %b.sext
  %abs = call <4 x i16> @llvm.abs.v4i16(<4 x i16> %sub, i1 true)
  ret <4 x i16> %abs
}

define <8 x i16> @sabd_8h(<8 x i16> %a, <8 x i16> %b) #0 {
; CHECK-LABEL: sabd_8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabd v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    ret
  %a.sext = sext <8 x i16> %a to <8 x i32>
  %b.sext = sext <8 x i16> %b to <8 x i32>
  %sub = sub <8 x i32> %a.sext, %b.sext
  %abs = call <8 x i32> @llvm.abs.v8i32(<8 x i32> %sub, i1 true)
  %trunc = trunc <8 x i32> %abs to <8 x i16>
  ret <8 x i16> %trunc
}

define <8 x i16> @sabd_8h_promoted_ops(<8 x i8> %a, <8 x i8> %b) #0 {
; CHECK-LABEL: sabd_8h_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabdl v0.8h, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %a.sext = sext <8 x i8> %a to <8 x i16>
  %b.sext = sext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.sext, %b.sext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  ret <8 x i16> %abs
}

define <2 x i32> @sabd_2s(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: sabd_2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    ret
  %a.sext = sext <2 x i32> %a to <2 x i64>
  %b.sext = sext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.sext, %b.sext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  %trunc = trunc <2 x i64> %abs to <2 x i32>
  ret <2 x i32> %trunc
}

define <2 x i32> @sabd_2s_promoted_ops(<2 x i16> %a, <2 x i16> %b) #0 {
; CHECK-LABEL: sabd_2s_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.2s, v0.2s, #16
; CHECK-NEXT:    shl v1.2s, v1.2s, #16
; CHECK-NEXT:    sshr v0.2s, v0.2s, #16
; CHECK-NEXT:    sshr v1.2s, v1.2s, #16
; CHECK-NEXT:    sabd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    ret
  %a.sext = sext <2 x i16> %a to <2 x i32>
  %b.sext = sext <2 x i16> %b to <2 x i32>
  %sub = sub <2 x i32> %a.sext, %b.sext
  %abs = call <2 x i32> @llvm.abs.v2i32(<2 x i32> %sub, i1 true)
  ret <2 x i32> %abs
}

define <4 x i32> @sabd_4s(<4 x i32> %a, <4 x i32> %b) #0 {
; CHECK-LABEL: sabd_4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabd v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %a.sext = sext <4 x i32> %a to <4 x i64>
  %b.sext = sext <4 x i32> %b to <4 x i64>
  %sub = sub <4 x i64> %a.sext, %b.sext
  %abs = call <4 x i64> @llvm.abs.v4i64(<4 x i64> %sub, i1 true)
  %trunc = trunc <4 x i64> %abs to <4 x i32>
  ret <4 x i32> %trunc
}

define <4 x i32> @sabd_4s_promoted_ops(<4 x i16> %a, <4 x i16> %b) #0 {
; CHECK-LABEL: sabd_4s_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabdl v0.4s, v0.4h, v1.4h
; CHECK-NEXT:    ret
  %a.sext = sext <4 x i16> %a to <4 x i32>
  %b.sext = sext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.sext, %b.sext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  ret <4 x i32> %abs
}

define <2 x i64> @sabd_2d(<2 x i64> %a, <2 x i64> %b) #0 {
; CHECK-LABEL: sabd_2d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, v0.d[1]
; CHECK-NEXT:    fmov x10, d0
; CHECK-NEXT:    mov x9, v1.d[1]
; CHECK-NEXT:    asr x11, x10, #63
; CHECK-NEXT:    asr x12, x8, #63
; CHECK-NEXT:    asr x13, x9, #63
; CHECK-NEXT:    subs x8, x8, x9
; CHECK-NEXT:    fmov x9, d1
; CHECK-NEXT:    sbcs x12, x12, x13
; CHECK-NEXT:    asr x13, x9, #63
; CHECK-NEXT:    subs x9, x10, x9
; CHECK-NEXT:    sbcs x10, x11, x13
; CHECK-NEXT:    cmp x10, #0
; CHECK-NEXT:    cneg x9, x9, lt
; CHECK-NEXT:    cmp x12, #0
; CHECK-NEXT:    cneg x8, x8, lt
; CHECK-NEXT:    fmov d0, x9
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-NEXT:    ret
  %a.sext = sext <2 x i64> %a to <2 x i128>
  %b.sext = sext <2 x i64> %b to <2 x i128>
  %sub = sub <2 x i128> %a.sext, %b.sext
  %abs = call <2 x i128> @llvm.abs.v2i128(<2 x i128> %sub, i1 true)
  %trunc = trunc <2 x i128> %abs to <2 x i64>
  ret <2 x i64> %trunc
}

define <2 x i64> @sabd_2d_promoted_ops(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: sabd_2d_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sabdl v0.2d, v0.2s, v1.2s
; CHECK-NEXT:    ret
  %a.sext = sext <2 x i32> %a to <2 x i64>
  %b.sext = sext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.sext, %b.sext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  ret <2 x i64> %abs
}

;
; UABD
;

define <8 x i8> @uabd_8b(<8 x i8> %a, <8 x i8> %b) #0 {
; CHECK-LABEL: uabd_8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabd v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %a.zext = zext <8 x i8> %a to <8 x i16>
  %b.zext = zext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.zext, %b.zext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  %trunc = trunc <8 x i16> %abs to <8 x i8>
  ret <8 x i8> %trunc
}

define <16 x i8> @uabd_16b(<16 x i8> %a, <16 x i8> %b) #0 {
; CHECK-LABEL: uabd_16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabd v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %a.zext = zext <16 x i8> %a to <16 x i16>
  %b.zext = zext <16 x i8> %b to <16 x i16>
  %sub = sub <16 x i16> %a.zext, %b.zext
  %abs = call <16 x i16> @llvm.abs.v16i16(<16 x i16> %sub, i1 true)
  %trunc = trunc <16 x i16> %abs to <16 x i8>
  ret <16 x i8> %trunc
}

define <4 x i16> @uabd_4h(<4 x i16> %a, <4 x i16> %b) #0 {
; CHECK-LABEL: uabd_4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabd v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    ret
  %a.zext = zext <4 x i16> %a to <4 x i32>
  %b.zext = zext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.zext, %b.zext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  %trunc = trunc <4 x i32> %abs to <4 x i16>
  ret <4 x i16> %trunc
}

define <4 x i16> @uabd_4h_promoted_ops(<4 x i8> %a, <4 x i8> %b) #0 {
; CHECK-LABEL: uabd_4h_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic v0.4h, #255, lsl #8
; CHECK-NEXT:    bic v1.4h, #255, lsl #8
; CHECK-NEXT:    uabd v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    ret
  %a.zext = zext <4 x i8> %a to <4 x i16>
  %b.zext = zext <4 x i8> %b to <4 x i16>
  %sub = sub <4 x i16> %a.zext, %b.zext
  %abs = call <4 x i16> @llvm.abs.v4i16(<4 x i16> %sub, i1 true)
  ret <4 x i16> %abs
}

define <8 x i16> @uabd_8h(<8 x i16> %a, <8 x i16> %b) #0 {
; CHECK-LABEL: uabd_8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabd v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    ret
  %a.zext = zext <8 x i16> %a to <8 x i32>
  %b.zext = zext <8 x i16> %b to <8 x i32>
  %sub = sub <8 x i32> %a.zext, %b.zext
  %abs = call <8 x i32> @llvm.abs.v8i32(<8 x i32> %sub, i1 true)
  %trunc = trunc <8 x i32> %abs to <8 x i16>
  ret <8 x i16> %trunc
}

define <8 x i16> @uabd_8h_promoted_ops(<8 x i8> %a, <8 x i8> %b) #0 {
; CHECK-LABEL: uabd_8h_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabdl v0.8h, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %a.zext = zext <8 x i8> %a to <8 x i16>
  %b.zext = zext <8 x i8> %b to <8 x i16>
  %sub = sub <8 x i16> %a.zext, %b.zext
  %abs = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %sub, i1 true)
  ret <8 x i16> %abs
}

define <2 x i32> @uabd_2s(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: uabd_2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    ret
  %a.zext = zext <2 x i32> %a to <2 x i64>
  %b.zext = zext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.zext, %b.zext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  %trunc = trunc <2 x i64> %abs to <2 x i32>
  ret <2 x i32> %trunc
}

define <2 x i32> @uabd_2s_promoted_ops(<2 x i16> %a, <2 x i16> %b) #0 {
; CHECK-LABEL: uabd_2s_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi d2, #0x00ffff0000ffff
; CHECK-NEXT:    and v0.8b, v0.8b, v2.8b
; CHECK-NEXT:    and v1.8b, v1.8b, v2.8b
; CHECK-NEXT:    uabd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    ret
  %a.zext = zext <2 x i16> %a to <2 x i32>
  %b.zext = zext <2 x i16> %b to <2 x i32>
  %sub = sub <2 x i32> %a.zext, %b.zext
  %abs = call <2 x i32> @llvm.abs.v2i32(<2 x i32> %sub, i1 true)
  ret <2 x i32> %abs
}

define <4 x i32> @uabd_4s(<4 x i32> %a, <4 x i32> %b) #0 {
; CHECK-LABEL: uabd_4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabd v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %a.zext = zext <4 x i32> %a to <4 x i64>
  %b.zext = zext <4 x i32> %b to <4 x i64>
  %sub = sub <4 x i64> %a.zext, %b.zext
  %abs = call <4 x i64> @llvm.abs.v4i64(<4 x i64> %sub, i1 true)
  %trunc = trunc <4 x i64> %abs to <4 x i32>
  ret <4 x i32> %trunc
}

define <4 x i32> @uabd_4s_promoted_ops(<4 x i16> %a, <4 x i16> %b) #0 {
; CHECK-LABEL: uabd_4s_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabdl v0.4s, v0.4h, v1.4h
; CHECK-NEXT:    ret
  %a.zext = zext <4 x i16> %a to <4 x i32>
  %b.zext = zext <4 x i16> %b to <4 x i32>
  %sub = sub <4 x i32> %a.zext, %b.zext
  %abs = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %sub, i1 true)
  ret <4 x i32> %abs
}

define <2 x i64> @uabd_2d(<2 x i64> %a, <2 x i64> %b) #0 {
; CHECK-LABEL: uabd_2d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, v0.d[1]
; CHECK-NEXT:    fmov x10, d0
; CHECK-NEXT:    mov x9, v1.d[1]
; CHECK-NEXT:    subs x8, x8, x9
; CHECK-NEXT:    fmov x9, d1
; CHECK-NEXT:    ngcs x11, xzr
; CHECK-NEXT:    subs x9, x10, x9
; CHECK-NEXT:    ngcs x10, xzr
; CHECK-NEXT:    cmp x10, #0
; CHECK-NEXT:    cneg x9, x9, lt
; CHECK-NEXT:    cmp x11, #0
; CHECK-NEXT:    cneg x8, x8, lt
; CHECK-NEXT:    fmov d0, x9
; CHECK-NEXT:    fmov d1, x8
; CHECK-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-NEXT:    ret
  %a.zext = zext <2 x i64> %a to <2 x i128>
  %b.zext = zext <2 x i64> %b to <2 x i128>
  %sub = sub <2 x i128> %a.zext, %b.zext
  %abs = call <2 x i128> @llvm.abs.v2i128(<2 x i128> %sub, i1 true)
  %trunc = trunc <2 x i128> %abs to <2 x i64>
  ret <2 x i64> %trunc
}

define <2 x i64> @uabd_2d_promoted_ops(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: uabd_2d_promoted_ops:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uabdl v0.2d, v0.2s, v1.2s
; CHECK-NEXT:    ret
  %a.zext = zext <2 x i32> %a to <2 x i64>
  %b.zext = zext <2 x i32> %b to <2 x i64>
  %sub = sub <2 x i64> %a.zext, %b.zext
  %abs = call <2 x i64> @llvm.abs.v2i64(<2 x i64> %sub, i1 true)
  ret <2 x i64> %abs
}

declare <8 x i8> @llvm.abs.v8i8(<8 x i8>, i1)
declare <16 x i8> @llvm.abs.v16i8(<16 x i8>, i1)

declare <4 x i16> @llvm.abs.v4i16(<4 x i16>, i1)
declare <8 x i16> @llvm.abs.v8i16(<8 x i16>, i1)
declare <16 x i16> @llvm.abs.v16i16(<16 x i16>, i1)

declare <2 x i32> @llvm.abs.v2i32(<2 x i32>, i1)
declare <4 x i32> @llvm.abs.v4i32(<4 x i32>, i1)
declare <8 x i32> @llvm.abs.v8i32(<8 x i32>, i1)

declare <2 x i64> @llvm.abs.v2i64(<2 x i64>, i1)
declare <4 x i64> @llvm.abs.v4i64(<4 x i64>, i1)

declare <2 x i128> @llvm.abs.v2i128(<2 x i128>, i1)

attributes #0 = { "target-features"="+neon" }
