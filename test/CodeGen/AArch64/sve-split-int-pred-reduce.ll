; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

; ANDV

define i1 @andv_nxv32i1(<vscale x 32 x i1> %a) {
; CHECK-LABEL: andv_nxv32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    and p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    not p0.b, p2/z, p0.b
; CHECK-NEXT:    ptest p2, p0.b
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.and.nxv32i1(<vscale x 32 x i1> %a)
  ret i1 %res
}

define i1 @andv_nxv64i1(<vscale x 64 x i1> %a) {
; CHECK-LABEL: andv_nxv64i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    ptrue p4.b
; CHECK-NEXT:    and p1.b, p4/z, p1.b, p3.b
; CHECK-NEXT:    and p0.b, p4/z, p0.b, p2.b
; CHECK-NEXT:    and p0.b, p4/z, p0.b, p1.b
; CHECK-NEXT:    not p0.b, p4/z, p0.b
; CHECK-NEXT:    ptest p4, p0.b
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.and.nxv64i1(<vscale x 64 x i1> %a)
  ret i1 %res
}

; ORV

define i1 @orv_nxv32i1(<vscale x 32 x i1> %a) {
; CHECK-LABEL: orv_nxv32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    orr p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ptest p0, p0.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.or.nxv32i1(<vscale x 32 x i1> %a)
  ret i1 %res
}

; XORV

define i1 @xorv_nxv32i1(<vscale x 32 x i1> %a) {
; CHECK-LABEL: xorv_nxv32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    eor p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    cntp x8, p2, p0.b
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.xor.nxv32i1(<vscale x 32 x i1> %a)
  ret i1 %res
}

; SMAXV

define i1 @smaxv_nxv32i1(<vscale x 32 x i1> %a) {
; CHECK-LABEL: smaxv_nxv32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    and p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    not p0.b, p2/z, p0.b
; CHECK-NEXT:    ptest p2, p0.b
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.smax.nxv32i1(<vscale x 32 x i1> %a)
  ret i1 %res
}

; SMINV

define i1 @sminv_nxv32i1(<vscale x 32 x i1> %a) {
; CHECK-LABEL: sminv_nxv32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    orr p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ptest p0, p0.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.smin.nxv32i1(<vscale x 32 x i1> %a)
  ret i1 %res
}

; UMAXV

define i1 @umaxv_nxv32i1(<vscale x 32 x i1> %a) {
; CHECK-LABEL: umaxv_nxv32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    orr p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    ptest p0, p0.b
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.umax.nxv32i1(<vscale x 32 x i1> %a)
  ret i1 %res
}

; UMINV

define i1 @uminv_nxv32i1(<vscale x 32 x i1> %a) {
; CHECK-LABEL: uminv_nxv32i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p2.b
; CHECK-NEXT:    and p0.b, p2/z, p0.b, p1.b
; CHECK-NEXT:    not p0.b, p2/z, p0.b
; CHECK-NEXT:    ptest p2, p0.b
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %res = call i1 @llvm.vector.reduce.umin.nxv32i1(<vscale x 32 x i1> %a)
  ret i1 %res
}

declare i1 @llvm.vector.reduce.and.nxv32i1(<vscale x 32 x i1>)
declare i1 @llvm.vector.reduce.and.nxv64i1(<vscale x 64 x i1>)

declare i1 @llvm.vector.reduce.or.nxv32i1(<vscale x 32 x i1>)

declare i1 @llvm.vector.reduce.xor.nxv32i1(<vscale x 32 x i1>)

declare i1 @llvm.vector.reduce.smax.nxv32i1(<vscale x 32 x i1>)

declare i1 @llvm.vector.reduce.smin.nxv32i1(<vscale x 32 x i1>)

declare i1 @llvm.vector.reduce.umax.nxv32i1(<vscale x 32 x i1>)

declare i1 @llvm.vector.reduce.umin.nxv32i1(<vscale x 32 x i1>)
