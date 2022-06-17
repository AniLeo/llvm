; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; USRA

define <vscale x 16 x i8> @usra_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: usra_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.b, z1.b, #1
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 16 x i8> poison, i8 1, i32 0
  %splat = shufflevector <vscale x 16 x i8> %ins, <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer
  %shift = lshr <vscale x 16 x i8> %b, %splat
  %add = add <vscale x 16 x i8> %a, %shift
  ret <vscale x 16 x i8> %add
}

define <vscale x 8 x i16> @usra_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) #0 {
; CHECK-LABEL: usra_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.h, z1.h, #2
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 8 x i16> poison, i16 2, i32 0
  %splat = shufflevector <vscale x 8 x i16> %ins, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %shift = lshr <vscale x 8 x i16> %b, %splat
  %add = add <vscale x 8 x i16> %a, %shift
  ret <vscale x 8 x i16> %add
}

define <vscale x 4 x i32> @usra_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) #0 {
; CHECK-LABEL: usra_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.s, z1.s, #3
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 4 x i32> poison, i32 3, i32 0
  %splat = shufflevector <vscale x 4 x i32> %ins, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %shift = lshr <vscale x 4 x i32> %b, %splat
  %add = add <vscale x 4 x i32> %a, %shift
  ret <vscale x 4 x i32> %add
}

define <vscale x 2 x i64> @usra_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) #0 {
; CHECK-LABEL: usra_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.d, z1.d, #4
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 2 x i64> poison, i64 4, i32 0
  %splat = shufflevector <vscale x 2 x i64> %ins, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %shift = lshr <vscale x 2 x i64> %b, %splat
  %add = add <vscale x 2 x i64> %a, %shift
  ret <vscale x 2 x i64> %add
}

define <vscale x 16 x i8> @usra_intr_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: usra_intr_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.b, z1.b, #1
; CHECK-NEXT:    ret
  %pg = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
  %ins = insertelement <vscale x 16 x i8> poison, i8 1, i32 0
  %splat = shufflevector <vscale x 16 x i8> %ins, <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer
  %shift = call <vscale x 16 x i8> @llvm.aarch64.sve.lsr.nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %b, <vscale x 16 x i8> %splat)
  %add = add <vscale x 16 x i8> %a, %shift
  ret <vscale x 16 x i8> %add
}

define <vscale x 8 x i16> @usra_intr_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) #0 {
; CHECK-LABEL: usra_intr_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.h, z1.h, #2
; CHECK-NEXT:    ret
  %pg = call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 31)
  %ins = insertelement <vscale x 8 x i16> poison, i16 2, i32 0
  %splat = shufflevector <vscale x 8 x i16> %ins, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %shift = call <vscale x 8 x i16> @llvm.aarch64.sve.lsr.nxv8i16(<vscale x 8 x i1> %pg, <vscale x 8 x i16> %b, <vscale x 8 x i16> %splat)
  %add = add <vscale x 8 x i16> %a, %shift
  ret <vscale x 8 x i16> %add
}

define <vscale x 4 x i32> @usra_intr_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) #0 {
; CHECK-LABEL: usra_intr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.s, z1.s, #3
; CHECK-NEXT:    ret
  %pg = call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 31)
  %ins = insertelement <vscale x 4 x i32> poison, i32 3, i32 0
  %splat = shufflevector <vscale x 4 x i32> %ins, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %shift = call <vscale x 4 x i32> @llvm.aarch64.sve.lsr.nxv4i32(<vscale x 4 x i1> %pg, <vscale x 4 x i32> %b, <vscale x 4 x i32> %splat)
  %add = add <vscale x 4 x i32> %a, %shift
  ret <vscale x 4 x i32> %add
}

define <vscale x 2 x i64> @usra_intr_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) #0 {
; CHECK-LABEL: usra_intr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    usra z0.d, z1.d, #4
; CHECK-NEXT:    ret
  %pg = call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 31)
  %ins = insertelement <vscale x 2 x i64> poison, i64 4, i32 0
  %splat = shufflevector <vscale x 2 x i64> %ins, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %shift = call <vscale x 2 x i64> @llvm.aarch64.sve.lsr.nxv2i64(<vscale x 2 x i1> %pg, <vscale x 2 x i64> %b, <vscale x 2 x i64> %splat)
  %add = add <vscale x 2 x i64> %a, %shift
  ret <vscale x 2 x i64> %add
}

; SSRA

define <vscale x 16 x i8> @ssra_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: ssra_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.b, z1.b, #1
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 16 x i8> poison, i8 1, i32 0
  %splat = shufflevector <vscale x 16 x i8> %ins, <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer
  %shift = ashr <vscale x 16 x i8> %b, %splat
  %add = add <vscale x 16 x i8> %a, %shift
  ret <vscale x 16 x i8> %add
}

define <vscale x 8 x i16> @ssra_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) #0 {
; CHECK-LABEL: ssra_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.h, z1.h, #2
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 8 x i16> poison, i16 2, i32 0
  %splat = shufflevector <vscale x 8 x i16> %ins, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %shift = ashr <vscale x 8 x i16> %b, %splat
  %add = add <vscale x 8 x i16> %a, %shift
  ret <vscale x 8 x i16> %add
}

define <vscale x 4 x i32> @ssra_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) #0 {
; CHECK-LABEL: ssra_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.s, z1.s, #3
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 4 x i32> poison, i32 3, i32 0
  %splat = shufflevector <vscale x 4 x i32> %ins, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %shift = ashr <vscale x 4 x i32> %b, %splat
  %add = add <vscale x 4 x i32> %a, %shift
  ret <vscale x 4 x i32> %add
}

define <vscale x 2 x i64> @ssra_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) #0 {
; CHECK-LABEL: ssra_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.d, z1.d, #4
; CHECK-NEXT:    ret
  %ins = insertelement <vscale x 2 x i64> poison, i64 4, i32 0
  %splat = shufflevector <vscale x 2 x i64> %ins, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %shift = ashr <vscale x 2 x i64> %b, %splat
  %add = add <vscale x 2 x i64> %a, %shift
  ret <vscale x 2 x i64> %add
}

define <vscale x 16 x i8> @ssra_intr_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: ssra_intr_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.b, z1.b, #1
; CHECK-NEXT:    ret
  %pg = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
  %ins = insertelement <vscale x 16 x i8> poison, i8 1, i32 0
  %splat = shufflevector <vscale x 16 x i8> %ins, <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer
  %shift = call <vscale x 16 x i8> @llvm.aarch64.sve.asr.nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %b, <vscale x 16 x i8> %splat)
  %add = add <vscale x 16 x i8> %a, %shift
  ret <vscale x 16 x i8> %add
}

define <vscale x 8 x i16> @ssra_intr_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b) #0 {
; CHECK-LABEL: ssra_intr_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.h, z1.h, #2
; CHECK-NEXT:    ret
  %pg = call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 31)
  %ins = insertelement <vscale x 8 x i16> poison, i16 2, i32 0
  %splat = shufflevector <vscale x 8 x i16> %ins, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  %shift = call <vscale x 8 x i16> @llvm.aarch64.sve.asr.nxv8i16(<vscale x 8 x i1> %pg, <vscale x 8 x i16> %b, <vscale x 8 x i16> %splat)
  %add = add <vscale x 8 x i16> %a, %shift
  ret <vscale x 8 x i16> %add
}

define <vscale x 4 x i32> @ssra_intr_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b) #0 {
; CHECK-LABEL: ssra_intr_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.s, z1.s, #3
; CHECK-NEXT:    ret
  %pg = call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 31)
  %ins = insertelement <vscale x 4 x i32> poison, i32 3, i32 0
  %splat = shufflevector <vscale x 4 x i32> %ins, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %shift = call <vscale x 4 x i32> @llvm.aarch64.sve.asr.nxv4i32(<vscale x 4 x i1> %pg, <vscale x 4 x i32> %b, <vscale x 4 x i32> %splat)
  %add = add <vscale x 4 x i32> %a, %shift
  ret <vscale x 4 x i32> %add
}

define <vscale x 2 x i64> @ssra_intr_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b) #0 {
; CHECK-LABEL: ssra_intr_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ssra z0.d, z1.d, #4
; CHECK-NEXT:    ret
  %pg = call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 31)
  %ins = insertelement <vscale x 2 x i64> poison, i64 4, i32 0
  %splat = shufflevector <vscale x 2 x i64> %ins, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %shift = call <vscale x 2 x i64> @llvm.aarch64.sve.asr.nxv2i64(<vscale x 2 x i1> %pg, <vscale x 2 x i64> %b, <vscale x 2 x i64> %splat)
  %add = add <vscale x 2 x i64> %a, %shift
  ret <vscale x 2 x i64> %add
}


declare <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 immarg)
declare <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 immarg)
declare <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 immarg)
declare <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 immarg)

declare <vscale x 16 x i8> @llvm.aarch64.sve.lsr.nxv16i8(<vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <vscale x 8 x i16> @llvm.aarch64.sve.lsr.nxv8i16(<vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.lsr.nxv4i32(<vscale x 4 x i1>, <vscale x 4 x i32>, <vscale x 4 x i32>)
declare <vscale x 2 x i64> @llvm.aarch64.sve.lsr.nxv2i64(<vscale x 2 x i1>, <vscale x 2 x i64>, <vscale x 2 x i64>)

declare <vscale x 16 x i8> @llvm.aarch64.sve.asr.nxv16i8(<vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <vscale x 8 x i16> @llvm.aarch64.sve.asr.nxv8i16(<vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.asr.nxv4i32(<vscale x 4 x i1>, <vscale x 4 x i32>, <vscale x 4 x i32>)
declare <vscale x 2 x i64> @llvm.aarch64.sve.asr.nxv2i64(<vscale x 2 x i1>, <vscale x 2 x i64>, <vscale x 2 x i64>)

attributes #0 = { "target-features"="+sve,+sve2" }
