; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s
target triple = "aarch64-unknown-linux-gnu"

define <vscale x 8 x i1> @masked_load_sext_i8i16(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl32
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 10)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 8 x i1> %extract to <vscale x 8 x i16>
  %p1 = call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 10)
  %cmp1 = call <vscale x 8 x i1> @llvm.aarch64.sve.cmpne.nxv8i16(<vscale x 8 x i1> %p1, <vscale x 8 x i16> %ext1, <vscale x 8 x i16> zeroinitializer)
  ret <vscale x 8 x i1> %cmp1
}

; This negative test ensures the two ptrues have the same vl
define <vscale x 8 x i1> @masked_load_sext_i8i16_ptrue_vl(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i16_ptrue_vl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.h, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    ptrue p0.h, vl32
; CHECK-NEXT:    cmpne p0.h, p0/z, z0.h, #0
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 11)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 8 x i1> %extract to <vscale x 8 x i16>
  %p1 = call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 10)
  %cmp1 = call <vscale x 8 x i1> @llvm.aarch64.sve.cmpne.nxv8i16(<vscale x 8 x i1> %p1, <vscale x 8 x i16> %ext1, <vscale x 8 x i16> zeroinitializer)
  ret <vscale x 8 x i1> %cmp1
}

; This negative test enforces that both predicates are ptrues
define <vscale x 8 x i1> @masked_load_sext_i8i16_parg(i8* %ap, <vscale x 16 x i8> %b, <vscale x 16 x i1> %p0) #0 {
; CHECK-LABEL: masked_load_sext_i8i16_parg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    ptrue p1.h, vl32
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.h, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    cmpne p0.h, p1/z, z0.h, #0
; CHECK-NEXT:    ret
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 8 x i1> %extract to <vscale x 8 x i16>
  %p1 = call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 10)
  %cmp1 = call <vscale x 8 x i1> @llvm.aarch64.sve.cmpne.nxv8i16(<vscale x 8 x i1> %p1, <vscale x 8 x i16> %ext1, <vscale x 8 x i16> zeroinitializer)
  ret <vscale x 8 x i1> %cmp1
}

define <vscale x 4 x i1> @masked_load_sext_i8i32(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl32
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 10)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 4 x i1> %extract to <vscale x 4 x i32>
  %p1 = call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 10)
  %cmp1 = call <vscale x 4 x i1> @llvm.aarch64.sve.cmpne.nxv4i32(<vscale x 4 x i1> %p1, <vscale x 4 x i32> %ext1, <vscale x 4 x i32> zeroinitializer)
  ret <vscale x 4 x i1> %cmp1
}

; This negative test ensures the two ptrues have the same vl
define <vscale x 4 x i1> @masked_load_sext_i8i32_ptrue_vl(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i32_ptrue_vl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.s, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    ptrue p0.s, vl32
; CHECK-NEXT:    cmpne p0.s, p0/z, z0.s, #0
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 11)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 4 x i1> %extract to <vscale x 4 x i32>
  %p1 = call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 10)
  %cmp1 = call <vscale x 4 x i1> @llvm.aarch64.sve.cmpne.nxv4i32(<vscale x 4 x i1> %p1, <vscale x 4 x i32> %ext1, <vscale x 4 x i32> zeroinitializer)
  ret <vscale x 4 x i1> %cmp1
}

; This negative test enforces that both predicates are ptrues
define <vscale x 4 x i1> @masked_load_sext_i8i32_parg(i8* %ap, <vscale x 16 x i8> %b, <vscale x 16 x i1> %p0) #0 {
; CHECK-LABEL: masked_load_sext_i8i32_parg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    ptrue p1.s, vl32
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.s, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    cmpne p0.s, p1/z, z0.s, #0
; CHECK-NEXT:    ret
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 4 x i1> %extract to <vscale x 4 x i32>
  %p1 = call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 10)
  %cmp1 = call <vscale x 4 x i1> @llvm.aarch64.sve.cmpne.nxv4i32(<vscale x 4 x i1> %p1, <vscale x 4 x i32> %ext1, <vscale x 4 x i32> zeroinitializer)
  ret <vscale x 4 x i1> %cmp1
}

define <vscale x 2 x i1> @masked_load_sext_i8i64(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl32
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 10)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 2 x i1> %extract to <vscale x 2 x i64>
  %p1 = call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 10)
  %cmp1 = call <vscale x 2 x i1> @llvm.aarch64.sve.cmpne.nxv2i64(<vscale x 2 x i1> %p1, <vscale x 2 x i64> %ext1, <vscale x 2 x i64> zeroinitializer)
  ret <vscale x 2 x i1> %cmp1
}

; This negative test ensures the two ptrues have the same vl
define <vscale x 2 x i1> @masked_load_sext_i8i64_ptrue_vl(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i64_ptrue_vl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl64
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.d, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    ptrue p0.d, vl32
; CHECK-NEXT:    cmpne p0.d, p0/z, z0.d, #0
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 11)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 2 x i1> %extract to <vscale x 2 x i64>
  %p1 = call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 10)
  %cmp1 = call <vscale x 2 x i1> @llvm.aarch64.sve.cmpne.nxv2i64(<vscale x 2 x i1> %p1, <vscale x 2 x i64> %ext1, <vscale x 2 x i64> zeroinitializer)
  ret <vscale x 2 x i1> %cmp1
}

; This negative test enforces that both predicates are ptrues
define <vscale x 2 x i1> @masked_load_sext_i8i64_parg(i8* %ap, <vscale x 16 x i8> %b, <vscale x 16 x i1> %p0) #0 {
; CHECK-LABEL: masked_load_sext_i8i64_parg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    ptrue p1.d, vl32
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.d, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    cmpne p0.d, p1/z, z0.d, #0
; CHECK-NEXT:    ret
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 2 x i1> %extract to <vscale x 2 x i64>
  %p1 = call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 10)
  %cmp1 = call <vscale x 2 x i1> @llvm.aarch64.sve.cmpne.nxv2i64(<vscale x 2 x i1> %p1, <vscale x 2 x i64> %ext1, <vscale x 2 x i64> zeroinitializer)
  ret <vscale x 2 x i1> %cmp1
}

; This negative test enforces that the ptrues have a specified vl
define <vscale x 8 x i1> @masked_load_sext_i8i16_ptrue_all(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i16_ptrue_all:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.h, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    cmpne p0.h, p0/z, z0.h, #0
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 11)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 8 x i1> %extract to <vscale x 8 x i16>
  %p1 = call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 10)
  %cmp1 = call <vscale x 8 x i1> @llvm.aarch64.sve.cmpne.nxv8i16(<vscale x 8 x i1> %p1, <vscale x 8 x i16> %ext1, <vscale x 8 x i16> zeroinitializer)
  ret <vscale x 8 x i1> %cmp1
}

; This negative test enforces that the ptrues have a specified vl
define <vscale x 4 x i1> @masked_load_sext_i8i32_ptrue_all(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i32_ptrue_all:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.s, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    cmpne p0.s, p0/z, z0.s, #0
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 11)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 4 x i1> %extract to <vscale x 4 x i32>
  %p1 = call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 10)
  %cmp1 = call <vscale x 4 x i1> @llvm.aarch64.sve.cmpne.nxv4i32(<vscale x 4 x i1> %p1, <vscale x 4 x i32> %ext1, <vscale x 4 x i32> zeroinitializer)
  ret <vscale x 4 x i1> %cmp1
}

; This negative test enforces that the ptrues have a specified vl
define <vscale x 2 x i1> @masked_load_sext_i8i64_ptrue_all(i8* %ap, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: masked_load_sext_i8i64_ptrue_all:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmpeq p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    mov z0.d, p0/z, #-1 // =0xffffffffffffffff
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    cmpne p0.d, p0/z, z0.d, #0
; CHECK-NEXT:    ret
  %p0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
  %cmp = call <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1> %p0, <vscale x 16 x i8> %b, <vscale x 16 x i8> zeroinitializer)
  %extract = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %cmp, i64 0)
  %ext1 = sext <vscale x 2 x i1> %extract to <vscale x 2 x i64>
  %p1 = call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 31)
  %cmp1 = call <vscale x 2 x i1> @llvm.aarch64.sve.cmpne.nxv2i64(<vscale x 2 x i1> %p1, <vscale x 2 x i64> %ext1, <vscale x 2 x i64> zeroinitializer)
  ret <vscale x 2 x i1> %cmp1
}

declare <vscale x 16 x i1> @llvm.aarch64.sve.cmpeq.nxv16i8(<vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)

declare <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32)
declare <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32)
declare <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32)
declare <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32)

declare <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1.nxv16i1(<vscale x 16 x i1>, i64)
declare <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1>, i64)
declare <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1>, i64)

declare <vscale x 8 x i1> @llvm.aarch64.sve.cmpne.nxv8i16(<vscale x 8 x i1>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <vscale x 4 x i1> @llvm.aarch64.sve.cmpne.nxv4i32(<vscale x 4 x i1>, <vscale x 4 x i32>, <vscale x 4 x i32>)
declare <vscale x 2 x i1> @llvm.aarch64.sve.cmpne.nxv2i64(<vscale x 2 x i1>, <vscale x 2 x i64>, <vscale x 2 x i64>)

attributes #0 = { "target-features"="+sve" }
