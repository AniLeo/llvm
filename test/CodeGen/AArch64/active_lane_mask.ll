; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

define <vscale x 16 x i1> @lane_mask_nxv16i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv16i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    mov z2.s, w0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    incw z1.s
; CHECK-NEXT:    add z3.s, z2.s, z0.s
; CHECK-NEXT:    incw z0.s, all, mul #2
; CHECK-NEXT:    add z4.s, z2.s, z1.s
; CHECK-NEXT:    incw z1.s, all, mul #2
; CHECK-NEXT:    cmphi p1.s, p0/z, z2.s, z3.s
; CHECK-NEXT:    add z0.s, z2.s, z0.s
; CHECK-NEXT:    cmphi p2.s, p0/z, z2.s, z4.s
; CHECK-NEXT:    add z1.s, z2.s, z1.s
; CHECK-NEXT:    uzp1 p1.h, p1.h, p2.h
; CHECK-NEXT:    cmphi p2.s, p0/z, z2.s, z0.s
; CHECK-NEXT:    cmphi p3.s, p0/z, z2.s, z1.s
; CHECK-NEXT:    mov z2.s, w1
; CHECK-NEXT:    uzp1 p2.h, p2.h, p3.h
; CHECK-NEXT:    cmphi p3.s, p0/z, z2.s, z4.s
; CHECK-NEXT:    cmphi p4.s, p0/z, z2.s, z3.s
; CHECK-NEXT:    uzp1 p1.b, p1.b, p2.b
; CHECK-NEXT:    uzp1 p2.h, p4.h, p3.h
; CHECK-NEXT:    cmphi p3.s, p0/z, z2.s, z0.s
; CHECK-NEXT:    cmphi p0.s, p0/z, z2.s, z1.s
; CHECK-NEXT:    ptrue p4.b
; CHECK-NEXT:    uzp1 p0.h, p3.h, p0.h
; CHECK-NEXT:    not p1.b, p4/z, p1.b
; CHECK-NEXT:    uzp1 p0.b, p2.b, p0.b
; CHECK-NEXT:    and p0.b, p4/z, p1.b, p0.b
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i32(i32 %index, i32 %TC)
  ret <vscale x 16 x i1> %active.lane.mask
}

define <vscale x 8 x i1> @lane_mask_nxv8i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv8i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    mov z2.s, w0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    add z0.s, z2.s, z0.s
; CHECK-NEXT:    incw z1.s
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    add z1.s, z2.s, z1.s
; CHECK-NEXT:    cmphi p2.s, p0/z, z2.s, z0.s
; CHECK-NEXT:    cmphi p3.s, p0/z, z2.s, z1.s
; CHECK-NEXT:    mov z2.s, w1
; CHECK-NEXT:    ptrue p1.h
; CHECK-NEXT:    uzp1 p2.h, p2.h, p3.h
; CHECK-NEXT:    cmphi p3.s, p0/z, z2.s, z1.s
; CHECK-NEXT:    cmphi p0.s, p0/z, z2.s, z0.s
; CHECK-NEXT:    not p2.b, p1/z, p2.b
; CHECK-NEXT:    uzp1 p0.h, p0.h, p3.h
; CHECK-NEXT:    and p0.b, p1/z, p2.b, p0.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i32(i32 %index, i32 %TC)
  ret <vscale x 8 x i1> %active.lane.mask
}

define <vscale x 4 x i1> @lane_mask_nxv4i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv4i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    index z0.s, w0, #1
; CHECK-NEXT:    mov z1.s, w0
; CHECK-NEXT:    mov z2.s, w1
; CHECK-NEXT:    cmphi p1.s, p0/z, z1.s, z0.s
; CHECK-NEXT:    cmphi p2.s, p0/z, z2.s, z0.s
; CHECK-NEXT:    not p1.b, p0/z, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p1.b, p2.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i32(i32 %index, i32 %TC)
  ret <vscale x 4 x i1> %active.lane.mask
}

define <vscale x 2 x i1> @lane_mask_nxv2i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv2i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    mov z1.d, x0
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    and z1.d, z1.d, #0xffffffff
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    mov z2.d, x1
; CHECK-NEXT:    adr z0.d, [z1.d, z0.d, uxtw]
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    and z2.d, z2.d, #0xffffffff
; CHECK-NEXT:    and z1.d, z1.d, #0xffffffff
; CHECK-NEXT:    cmpne p1.d, p0/z, z1.d, z0.d
; CHECK-NEXT:    cmphi p2.d, p0/z, z2.d, z1.d
; CHECK-NEXT:    not p1.b, p0/z, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p1.b, p2.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i32(i32 %index, i32 %TC)
  ret <vscale x 2 x i1> %active.lane.mask
}

define <vscale x 16 x i1> @lane_mask_nxv16i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv16i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p6, [sp, #5, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p5, [sp, #6, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    mov z3.d, x0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    mov z2.d, z0.d
; CHECK-NEXT:    incd z1.d
; CHECK-NEXT:    incd z2.d, all, mul #2
; CHECK-NEXT:    mov z5.d, z1.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    incd z5.d, all, mul #2
; CHECK-NEXT:    add z4.d, z3.d, z0.d
; CHECK-NEXT:    add z6.d, z3.d, z1.d
; CHECK-NEXT:    add z7.d, z3.d, z2.d
; CHECK-NEXT:    add z24.d, z3.d, z5.d
; CHECK-NEXT:    incd z0.d, all, mul #4
; CHECK-NEXT:    cmphi p1.d, p0/z, z3.d, z4.d
; CHECK-NEXT:    incd z1.d, all, mul #4
; CHECK-NEXT:    cmphi p2.d, p0/z, z3.d, z6.d
; CHECK-NEXT:    cmphi p3.d, p0/z, z3.d, z7.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z3.d, z24.d
; CHECK-NEXT:    incd z2.d, all, mul #4
; CHECK-NEXT:    incd z5.d, all, mul #4
; CHECK-NEXT:    add z0.d, z3.d, z0.d
; CHECK-NEXT:    uzp1 p1.s, p1.s, p2.s
; CHECK-NEXT:    uzp1 p2.s, p3.s, p4.s
; CHECK-NEXT:    add z1.d, z3.d, z1.d
; CHECK-NEXT:    add z2.d, z3.d, z2.d
; CHECK-NEXT:    add z5.d, z3.d, z5.d
; CHECK-NEXT:    uzp1 p1.h, p1.h, p2.h
; CHECK-NEXT:    cmphi p2.d, p0/z, z3.d, z0.d
; CHECK-NEXT:    cmphi p3.d, p0/z, z3.d, z1.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z3.d, z2.d
; CHECK-NEXT:    cmphi p5.d, p0/z, z3.d, z5.d
; CHECK-NEXT:    uzp1 p2.s, p2.s, p3.s
; CHECK-NEXT:    uzp1 p3.s, p4.s, p5.s
; CHECK-NEXT:    mov z3.d, x1
; CHECK-NEXT:    uzp1 p2.h, p2.h, p3.h
; CHECK-NEXT:    cmphi p3.d, p0/z, z3.d, z6.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z3.d, z4.d
; CHECK-NEXT:    uzp1 p1.b, p1.b, p2.b
; CHECK-NEXT:    uzp1 p2.s, p4.s, p3.s
; CHECK-NEXT:    cmphi p3.d, p0/z, z3.d, z7.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z3.d, z24.d
; CHECK-NEXT:    cmphi p5.d, p0/z, z3.d, z0.d
; CHECK-NEXT:    cmphi p6.d, p0/z, z3.d, z1.d
; CHECK-NEXT:    uzp1 p3.s, p3.s, p4.s
; CHECK-NEXT:    uzp1 p4.s, p5.s, p6.s
; CHECK-NEXT:    cmphi p5.d, p0/z, z3.d, z2.d
; CHECK-NEXT:    cmphi p0.d, p0/z, z3.d, z5.d
; CHECK-NEXT:    uzp1 p0.s, p5.s, p0.s
; CHECK-NEXT:    ptrue p5.b
; CHECK-NEXT:    uzp1 p2.h, p2.h, p3.h
; CHECK-NEXT:    uzp1 p0.h, p4.h, p0.h
; CHECK-NEXT:    not p1.b, p5/z, p1.b
; CHECK-NEXT:    uzp1 p0.b, p2.b, p0.b
; CHECK-NEXT:    and p0.b, p5/z, p1.b, p0.b
; CHECK-NEXT:    ldr p6, [sp, #5, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p5, [sp, #6, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i64(i64 %index, i64 %TC)
  ret <vscale x 16 x i1> %active.lane.mask
}

define <vscale x 8 x i1> @lane_mask_nxv8i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv8i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    mov z2.d, x0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    incd z1.d
; CHECK-NEXT:    add z3.d, z2.d, z0.d
; CHECK-NEXT:    incd z0.d, all, mul #2
; CHECK-NEXT:    add z4.d, z2.d, z1.d
; CHECK-NEXT:    incd z1.d, all, mul #2
; CHECK-NEXT:    cmphi p1.d, p0/z, z2.d, z3.d
; CHECK-NEXT:    add z0.d, z2.d, z0.d
; CHECK-NEXT:    cmphi p2.d, p0/z, z2.d, z4.d
; CHECK-NEXT:    add z1.d, z2.d, z1.d
; CHECK-NEXT:    uzp1 p1.s, p1.s, p2.s
; CHECK-NEXT:    cmphi p2.d, p0/z, z2.d, z0.d
; CHECK-NEXT:    cmphi p3.d, p0/z, z2.d, z1.d
; CHECK-NEXT:    mov z2.d, x1
; CHECK-NEXT:    uzp1 p2.s, p2.s, p3.s
; CHECK-NEXT:    cmphi p3.d, p0/z, z2.d, z4.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z2.d, z3.d
; CHECK-NEXT:    uzp1 p1.h, p1.h, p2.h
; CHECK-NEXT:    uzp1 p2.s, p4.s, p3.s
; CHECK-NEXT:    cmphi p3.d, p0/z, z2.d, z0.d
; CHECK-NEXT:    cmphi p0.d, p0/z, z2.d, z1.d
; CHECK-NEXT:    ptrue p4.h
; CHECK-NEXT:    uzp1 p0.s, p3.s, p0.s
; CHECK-NEXT:    not p1.b, p4/z, p1.b
; CHECK-NEXT:    uzp1 p0.h, p2.h, p0.h
; CHECK-NEXT:    and p0.b, p4/z, p1.b, p0.b
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i64(i64 %index, i64 %TC)
  ret <vscale x 8 x i1> %active.lane.mask
}

define <vscale x 4 x i1> @lane_mask_nxv4i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv4i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    mov z2.d, x0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    add z0.d, z2.d, z0.d
; CHECK-NEXT:    incd z1.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    add z1.d, z2.d, z1.d
; CHECK-NEXT:    cmphi p2.d, p0/z, z2.d, z0.d
; CHECK-NEXT:    cmphi p3.d, p0/z, z2.d, z1.d
; CHECK-NEXT:    mov z2.d, x1
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    uzp1 p2.s, p2.s, p3.s
; CHECK-NEXT:    cmphi p3.d, p0/z, z2.d, z1.d
; CHECK-NEXT:    cmphi p0.d, p0/z, z2.d, z0.d
; CHECK-NEXT:    not p2.b, p1/z, p2.b
; CHECK-NEXT:    uzp1 p0.s, p0.s, p3.s
; CHECK-NEXT:    and p0.b, p1/z, p2.b, p0.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 %index, i64 %TC)
  ret <vscale x 4 x i1> %active.lane.mask
}

define <vscale x 2 x i1> @lane_mask_nxv2i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv2i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    index z0.d, x0, #1
; CHECK-NEXT:    mov z1.d, x0
; CHECK-NEXT:    mov z2.d, x1
; CHECK-NEXT:    cmphi p1.d, p0/z, z1.d, z0.d
; CHECK-NEXT:    cmphi p2.d, p0/z, z2.d, z0.d
; CHECK-NEXT:    not p1.b, p0/z, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p1.b, p2.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i64(i64 %index, i64 %TC)
  ret <vscale x 2 x i1> %active.lane.mask
}

define <vscale x 16 x i1> @lane_mask_nxv16i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_nxv16i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    index z0.b, w0, #1
; CHECK-NEXT:    mov z1.b, w0
; CHECK-NEXT:    mov z2.b, w1
; CHECK-NEXT:    cmphi p1.b, p0/z, z1.b, z0.b
; CHECK-NEXT:    cmphi p2.b, p0/z, z2.b, z0.b
; CHECK-NEXT:    not p1.b, p0/z, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p1.b, p2.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i8(i8 %index, i8 %TC)
  ret <vscale x 16 x i1> %active.lane.mask
}

define <vscale x 8 x i1> @lane_mask_nxv8i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_nxv8i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z0.h, #0, #1
; CHECK-NEXT:    mov z1.h, w0
; CHECK-NEXT:    and z0.h, z0.h, #0xff
; CHECK-NEXT:    and z1.h, z1.h, #0xff
; CHECK-NEXT:    add z0.h, z1.h, z0.h
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    mov z2.h, w1
; CHECK-NEXT:    and z1.h, z1.h, #0xff
; CHECK-NEXT:    and z2.h, z2.h, #0xff
; CHECK-NEXT:    cmpne p1.h, p0/z, z1.h, z0.h
; CHECK-NEXT:    cmphi p2.h, p0/z, z2.h, z1.h
; CHECK-NEXT:    not p1.b, p0/z, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p1.b, p2.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i8(i8 %index, i8 %TC)
  ret <vscale x 8 x i1> %active.lane.mask
}

define <vscale x 4 x i1> @lane_mask_nxv4i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_nxv4i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    mov z1.s, w0
; CHECK-NEXT:    and z0.s, z0.s, #0xff
; CHECK-NEXT:    and z1.s, z1.s, #0xff
; CHECK-NEXT:    add z0.s, z1.s, z0.s
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    mov z2.s, w1
; CHECK-NEXT:    and z1.s, z1.s, #0xff
; CHECK-NEXT:    and z2.s, z2.s, #0xff
; CHECK-NEXT:    cmpne p1.s, p0/z, z1.s, z0.s
; CHECK-NEXT:    cmphi p2.s, p0/z, z2.s, z1.s
; CHECK-NEXT:    not p1.b, p0/z, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p1.b, p2.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i8(i8 %index, i8 %TC)
  ret <vscale x 4 x i1> %active.lane.mask
}

define <vscale x 2 x i1> @lane_mask_nxv2i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_nxv2i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    mov z1.d, x0
; CHECK-NEXT:    and z0.d, z0.d, #0xff
; CHECK-NEXT:    and z1.d, z1.d, #0xff
; CHECK-NEXT:    add z0.d, z1.d, z0.d
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    mov z2.d, x1
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z1.d, z1.d, #0xff
; CHECK-NEXT:    and z2.d, z2.d, #0xff
; CHECK-NEXT:    cmpne p1.d, p0/z, z1.d, z0.d
; CHECK-NEXT:    cmphi p2.d, p0/z, z2.d, z1.d
; CHECK-NEXT:    not p1.b, p0/z, p1.b
; CHECK-NEXT:    and p0.b, p0/z, p1.b, p2.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i8(i8 %index, i8 %TC)
  ret <vscale x 2 x i1> %active.lane.mask
}


; Illegal types

define <vscale x 32 x i1> @lane_mask_nxv32i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv32i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p7, [sp, #4, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p6, [sp, #5, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p5, [sp, #6, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    mov z3.s, w0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    mov z2.d, z0.d
; CHECK-NEXT:    incw z1.s
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    mov z6.d, z1.d
; CHECK-NEXT:    add z4.s, z3.s, z0.s
; CHECK-NEXT:    incw z2.s, all, mul #2
; CHECK-NEXT:    add z5.s, z3.s, z1.s
; CHECK-NEXT:    incw z6.s, all, mul #2
; CHECK-NEXT:    cmphi p1.s, p0/z, z3.s, z4.s
; CHECK-NEXT:    cmphi p2.s, p0/z, z3.s, z5.s
; CHECK-NEXT:    add z7.s, z3.s, z2.s
; CHECK-NEXT:    add z25.s, z3.s, z6.s
; CHECK-NEXT:    uzp1 p1.h, p1.h, p2.h
; CHECK-NEXT:    cmphi p2.s, p0/z, z3.s, z7.s
; CHECK-NEXT:    cmphi p4.s, p0/z, z3.s, z25.s
; CHECK-NEXT:    mov z24.s, w1
; CHECK-NEXT:    uzp1 p2.h, p2.h, p4.h
; CHECK-NEXT:    incw z0.s, all, mul #4
; CHECK-NEXT:    incw z1.s, all, mul #4
; CHECK-NEXT:    incw z2.s, all, mul #4
; CHECK-NEXT:    incw z6.s, all, mul #4
; CHECK-NEXT:    cmphi p3.s, p0/z, z24.s, z5.s
; CHECK-NEXT:    cmphi p5.s, p0/z, z24.s, z4.s
; CHECK-NEXT:    cmphi p4.s, p0/z, z24.s, z7.s
; CHECK-NEXT:    uzp1 p1.b, p1.b, p2.b
; CHECK-NEXT:    cmphi p2.s, p0/z, z24.s, z25.s
; CHECK-NEXT:    add z0.s, z3.s, z0.s
; CHECK-NEXT:    add z1.s, z3.s, z1.s
; CHECK-NEXT:    add z2.s, z3.s, z2.s
; CHECK-NEXT:    add z4.s, z3.s, z6.s
; CHECK-NEXT:    uzp1 p3.h, p5.h, p3.h
; CHECK-NEXT:    uzp1 p2.h, p4.h, p2.h
; CHECK-NEXT:    cmphi p4.s, p0/z, z3.s, z0.s
; CHECK-NEXT:    cmphi p5.s, p0/z, z3.s, z1.s
; CHECK-NEXT:    cmphi p6.s, p0/z, z3.s, z2.s
; CHECK-NEXT:    cmphi p7.s, p0/z, z3.s, z4.s
; CHECK-NEXT:    uzp1 p4.h, p4.h, p5.h
; CHECK-NEXT:    uzp1 p5.h, p6.h, p7.h
; CHECK-NEXT:    uzp1 p2.b, p3.b, p2.b
; CHECK-NEXT:    uzp1 p3.b, p4.b, p5.b
; CHECK-NEXT:    cmphi p4.s, p0/z, z24.s, z0.s
; CHECK-NEXT:    cmphi p5.s, p0/z, z24.s, z1.s
; CHECK-NEXT:    ptrue p6.b
; CHECK-NEXT:    uzp1 p4.h, p4.h, p5.h
; CHECK-NEXT:    cmphi p5.s, p0/z, z24.s, z2.s
; CHECK-NEXT:    cmphi p0.s, p0/z, z24.s, z4.s
; CHECK-NEXT:    not p1.b, p6/z, p1.b
; CHECK-NEXT:    uzp1 p0.h, p5.h, p0.h
; CHECK-NEXT:    not p3.b, p6/z, p3.b
; CHECK-NEXT:    uzp1 p4.b, p4.b, p0.b
; CHECK-NEXT:    and p0.b, p6/z, p1.b, p2.b
; CHECK-NEXT:    and p1.b, p6/z, p3.b, p4.b
; CHECK-NEXT:    ldr p7, [sp, #4, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p6, [sp, #5, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p5, [sp, #6, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i32(i32 %index, i32 %TC)
  ret <vscale x 32 x i1> %active.lane.mask
}

define <vscale x 32 x i1> @lane_mask_nxv32i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv32i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-3
; CHECK-NEXT:    str p9, [sp, #2, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p8, [sp, #3, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p7, [sp, #4, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p6, [sp, #5, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p5, [sp, #6, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str z9, [sp, #1, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    str z8, [sp, #2, mul vl] // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x18, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 24 * VG
; CHECK-NEXT:    .cfi_escape 0x10, 0x48, 0x0a, 0x11, 0x70, 0x22, 0x11, 0x78, 0x92, 0x2e, 0x00, 0x1e, 0x22 // $d8 @ cfa - 16 - 8 * VG
; CHECK-NEXT:    .cfi_escape 0x10, 0x49, 0x0a, 0x11, 0x70, 0x22, 0x11, 0x70, 0x92, 0x2e, 0x00, 0x1e, 0x22 // $d9 @ cfa - 16 - 16 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    index z2.d, #0, #1
; CHECK-NEXT:    mov z0.d, x0
; CHECK-NEXT:    mov z3.d, z2.d
; CHECK-NEXT:    mov z4.d, z2.d
; CHECK-NEXT:    incd z3.d
; CHECK-NEXT:    incd z4.d, all, mul #2
; CHECK-NEXT:    mov z7.d, z3.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    incd z7.d, all, mul #2
; CHECK-NEXT:    add z5.d, z0.d, z2.d
; CHECK-NEXT:    add z6.d, z0.d, z3.d
; CHECK-NEXT:    mov z25.d, z2.d
; CHECK-NEXT:    mov z26.d, z3.d
; CHECK-NEXT:    mov z28.d, z4.d
; CHECK-NEXT:    mov z29.d, z7.d
; CHECK-NEXT:    cmphi p1.d, p0/z, z0.d, z5.d
; CHECK-NEXT:    cmphi p2.d, p0/z, z0.d, z6.d
; CHECK-NEXT:    add z24.d, z0.d, z4.d
; CHECK-NEXT:    add z27.d, z0.d, z7.d
; CHECK-NEXT:    incd z25.d, all, mul #4
; CHECK-NEXT:    incd z26.d, all, mul #4
; CHECK-NEXT:    incd z28.d, all, mul #4
; CHECK-NEXT:    incd z29.d, all, mul #4
; CHECK-NEXT:    cmphi p3.d, p0/z, z0.d, z24.d
; CHECK-NEXT:    uzp1 p1.s, p1.s, p2.s
; CHECK-NEXT:    cmphi p2.d, p0/z, z0.d, z27.d
; CHECK-NEXT:    add z30.d, z0.d, z25.d
; CHECK-NEXT:    add z31.d, z0.d, z26.d
; CHECK-NEXT:    add z8.d, z0.d, z28.d
; CHECK-NEXT:    add z9.d, z0.d, z29.d
; CHECK-NEXT:    uzp1 p2.s, p3.s, p2.s
; CHECK-NEXT:    cmphi p3.d, p0/z, z0.d, z30.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z0.d, z31.d
; CHECK-NEXT:    cmphi p5.d, p0/z, z0.d, z8.d
; CHECK-NEXT:    cmphi p6.d, p0/z, z0.d, z9.d
; CHECK-NEXT:    uzp1 p3.s, p3.s, p4.s
; CHECK-NEXT:    uzp1 p4.s, p5.s, p6.s
; CHECK-NEXT:    uzp1 p1.h, p1.h, p2.h
; CHECK-NEXT:    uzp1 p2.h, p3.h, p4.h
; CHECK-NEXT:    mov z1.d, x1
; CHECK-NEXT:    uzp1 p1.b, p1.b, p2.b
; CHECK-NEXT:    cmphi p2.d, p0/z, z1.d, z6.d
; CHECK-NEXT:    cmphi p3.d, p0/z, z1.d, z5.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z1.d, z24.d
; CHECK-NEXT:    cmphi p5.d, p0/z, z1.d, z27.d
; CHECK-NEXT:    uzp1 p2.s, p3.s, p2.s
; CHECK-NEXT:    uzp1 p3.s, p4.s, p5.s
; CHECK-NEXT:    cmphi p4.d, p0/z, z1.d, z30.d
; CHECK-NEXT:    cmphi p5.d, p0/z, z1.d, z31.d
; CHECK-NEXT:    cmphi p6.d, p0/z, z1.d, z8.d
; CHECK-NEXT:    cmphi p7.d, p0/z, z1.d, z9.d
; CHECK-NEXT:    incd z2.d, all, mul #8
; CHECK-NEXT:    incd z3.d, all, mul #8
; CHECK-NEXT:    incd z4.d, all, mul #8
; CHECK-NEXT:    incd z7.d, all, mul #8
; CHECK-NEXT:    uzp1 p4.s, p4.s, p5.s
; CHECK-NEXT:    uzp1 p5.s, p6.s, p7.s
; CHECK-NEXT:    add z2.d, z0.d, z2.d
; CHECK-NEXT:    add z3.d, z0.d, z3.d
; CHECK-NEXT:    add z4.d, z0.d, z4.d
; CHECK-NEXT:    add z5.d, z0.d, z7.d
; CHECK-NEXT:    incd z25.d, all, mul #8
; CHECK-NEXT:    incd z26.d, all, mul #8
; CHECK-NEXT:    incd z28.d, all, mul #8
; CHECK-NEXT:    incd z29.d, all, mul #8
; CHECK-NEXT:    uzp1 p2.h, p2.h, p3.h
; CHECK-NEXT:    uzp1 p3.h, p4.h, p5.h
; CHECK-NEXT:    cmphi p4.d, p0/z, z0.d, z2.d
; CHECK-NEXT:    cmphi p5.d, p0/z, z0.d, z3.d
; CHECK-NEXT:    cmphi p6.d, p0/z, z0.d, z4.d
; CHECK-NEXT:    cmphi p7.d, p0/z, z0.d, z5.d
; CHECK-NEXT:    add z6.d, z0.d, z25.d
; CHECK-NEXT:    add z7.d, z0.d, z26.d
; CHECK-NEXT:    add z24.d, z0.d, z28.d
; CHECK-NEXT:    add z25.d, z0.d, z29.d
; CHECK-NEXT:    uzp1 p4.s, p4.s, p5.s
; CHECK-NEXT:    uzp1 p5.s, p6.s, p7.s
; CHECK-NEXT:    cmphi p6.d, p0/z, z0.d, z6.d
; CHECK-NEXT:    cmphi p7.d, p0/z, z0.d, z7.d
; CHECK-NEXT:    cmphi p8.d, p0/z, z0.d, z24.d
; CHECK-NEXT:    cmphi p9.d, p0/z, z0.d, z25.d
; CHECK-NEXT:    uzp1 p6.s, p6.s, p7.s
; CHECK-NEXT:    uzp1 p7.s, p8.s, p9.s
; CHECK-NEXT:    uzp1 p4.h, p4.h, p5.h
; CHECK-NEXT:    uzp1 p5.h, p6.h, p7.h
; CHECK-NEXT:    uzp1 p2.b, p2.b, p3.b
; CHECK-NEXT:    uzp1 p3.b, p4.b, p5.b
; CHECK-NEXT:    cmphi p4.d, p0/z, z1.d, z2.d
; CHECK-NEXT:    cmphi p5.d, p0/z, z1.d, z3.d
; CHECK-NEXT:    cmphi p6.d, p0/z, z1.d, z4.d
; CHECK-NEXT:    cmphi p7.d, p0/z, z1.d, z5.d
; CHECK-NEXT:    uzp1 p4.s, p4.s, p5.s
; CHECK-NEXT:    uzp1 p5.s, p6.s, p7.s
; CHECK-NEXT:    cmphi p6.d, p0/z, z1.d, z6.d
; CHECK-NEXT:    cmphi p7.d, p0/z, z1.d, z7.d
; CHECK-NEXT:    uzp1 p4.h, p4.h, p5.h
; CHECK-NEXT:    uzp1 p5.s, p6.s, p7.s
; CHECK-NEXT:    cmphi p6.d, p0/z, z1.d, z24.d
; CHECK-NEXT:    cmphi p0.d, p0/z, z1.d, z25.d
; CHECK-NEXT:    ldr p9, [sp, #2, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    uzp1 p0.s, p6.s, p0.s
; CHECK-NEXT:    ptrue p6.b
; CHECK-NEXT:    uzp1 p0.h, p5.h, p0.h
; CHECK-NEXT:    not p1.b, p6/z, p1.b
; CHECK-NEXT:    not p3.b, p6/z, p3.b
; CHECK-NEXT:    uzp1 p4.b, p4.b, p0.b
; CHECK-NEXT:    and p0.b, p6/z, p1.b, p2.b
; CHECK-NEXT:    and p1.b, p6/z, p3.b, p4.b
; CHECK-NEXT:    ldr p8, [sp, #3, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p7, [sp, #4, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p6, [sp, #5, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p5, [sp, #6, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr z9, [sp, #1, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    ldr z8, [sp, #2, mul vl] // 16-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #3
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i64(i64 %index, i64 %TC)
  ret <vscale x 32 x i1> %active.lane.mask
}

define <vscale x 32 x i1> @lane_mask_nxv32i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_nxv32i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    rdvl x8, #1
; CHECK-NEXT:    index z1.b, #0, #1
; CHECK-NEXT:    mov z0.b, w8
; CHECK-NEXT:    mov z2.b, w0
; CHECK-NEXT:    add z0.b, z1.b, z0.b
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    add z4.b, z2.b, z1.b
; CHECK-NEXT:    add z0.b, z2.b, z0.b
; CHECK-NEXT:    mov z3.b, w1
; CHECK-NEXT:    cmphi p2.b, p1/z, z2.b, z4.b
; CHECK-NEXT:    cmphi p3.b, p1/z, z2.b, z0.b
; CHECK-NEXT:    cmphi p0.b, p1/z, z3.b, z4.b
; CHECK-NEXT:    not p2.b, p1/z, p2.b
; CHECK-NEXT:    cmphi p4.b, p1/z, z3.b, z0.b
; CHECK-NEXT:    not p3.b, p1/z, p3.b
; CHECK-NEXT:    and p0.b, p1/z, p2.b, p0.b
; CHECK-NEXT:    and p1.b, p1/z, p3.b, p4.b
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i8(i8 %index, i8 %TC)
  ret <vscale x 32 x i1> %active.lane.mask
}


declare <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i32(i32, i32)
declare <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i32(i32, i32)
declare <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i32(i32, i32)
declare <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i32(i32, i32)
declare <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i32(i32, i32)

declare <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i64(i64, i64)
declare <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i64(i64, i64)
declare <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i64(i64, i64)
declare <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64, i64)
declare <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i64(i64, i64)

declare <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i8(i8, i8)
declare <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i8(i8, i8)
declare <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i8(i8, i8)
declare <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i8(i8, i8)
declare <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i8(i8, i8)
