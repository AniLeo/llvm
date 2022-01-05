; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

; == Scalable ==

define <vscale x 16 x i1> @lane_mask_nxv16i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv16i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.b, w0, w1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i32(i32 %index, i32 %TC)
  ret <vscale x 16 x i1> %active.lane.mask
}

define <vscale x 8 x i1> @lane_mask_nxv8i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv8i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.h, w0, w1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i32(i32 %index, i32 %TC)
  ret <vscale x 8 x i1> %active.lane.mask
}

define <vscale x 4 x i1> @lane_mask_nxv4i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv4i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.s, w0, w1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i32(i32 %index, i32 %TC)
  ret <vscale x 4 x i1> %active.lane.mask
}

define <vscale x 2 x i1> @lane_mask_nxv2i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_nxv2i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.d, w0, w1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i32(i32 %index, i32 %TC)
  ret <vscale x 2 x i1> %active.lane.mask
}

define <vscale x 16 x i1> @lane_mask_nxv16i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv16i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.b, x0, x1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i64(i64 %index, i64 %TC)
  ret <vscale x 16 x i1> %active.lane.mask
}

define <vscale x 8 x i1> @lane_mask_nxv8i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv8i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.h, x0, x1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i64(i64 %index, i64 %TC)
  ret <vscale x 8 x i1> %active.lane.mask
}

define <vscale x 4 x i1> @lane_mask_nxv4i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv4i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.s, x0, x1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 %index, i64 %TC)
  ret <vscale x 4 x i1> %active.lane.mask
}

define <vscale x 2 x i1> @lane_mask_nxv2i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_nxv2i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    whilelo p0.d, x0, x1
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 2 x i1> @llvm.get.active.lane.mask.nxv2i1.i64(i64 %index, i64 %TC)
  ret <vscale x 2 x i1> %active.lane.mask
}

define <vscale x 16 x i1> @lane_mask_nxv16i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_nxv16i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z0.b, #0, #1
; CHECK-NEXT:    mov z1.b, w0
; CHECK-NEXT:    uqadd z0.b, z1.b, z0.b
; CHECK-NEXT:    mov z1.b, w1
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmphi p0.b, p0/z, z1.b, z0.b
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
; CHECK-NEXT:    mov z1.h, w1
; CHECK-NEXT:    umin z0.h, z0.h, #255
; CHECK-NEXT:    and z1.h, z1.h, #0xff
; CHECK-NEXT:    and z0.h, z0.h, #0xff
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    cmphi p0.h, p0/z, z1.h, z0.h
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
; CHECK-NEXT:    mov z1.s, w1
; CHECK-NEXT:    umin z0.s, z0.s, #255
; CHECK-NEXT:    and z1.s, z1.s, #0xff
; CHECK-NEXT:    and z0.s, z0.s, #0xff
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    cmphi p0.s, p0/z, z1.s, z0.s
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
; CHECK-NEXT:    umin z0.d, z0.d, #255
; CHECK-NEXT:    and z2.d, z2.d, #0xff
; CHECK-NEXT:    and z0.d, z0.d, #0xff
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    cmphi p0.d, p0/z, z2.d, z0.d
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
; CHECK-NEXT:    str p5, [sp, #6, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    mov z3.s, w0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    mov z2.d, z0.d
; CHECK-NEXT:    mov z4.s, w1
; CHECK-NEXT:    incw z1.s
; CHECK-NEXT:    uqadd z5.s, z3.s, z0.s
; CHECK-NEXT:    incw z2.s, all, mul #2
; CHECK-NEXT:    mov z6.d, z1.d
; CHECK-NEXT:    cmphi p1.s, p0/z, z4.s, z5.s
; CHECK-NEXT:    uqadd z5.s, z3.s, z1.s
; CHECK-NEXT:    cmphi p2.s, p0/z, z4.s, z5.s
; CHECK-NEXT:    uqadd z5.s, z3.s, z2.s
; CHECK-NEXT:    incw z6.s, all, mul #2
; CHECK-NEXT:    incw z0.s, all, mul #4
; CHECK-NEXT:    cmphi p3.s, p0/z, z4.s, z5.s
; CHECK-NEXT:    uqadd z5.s, z3.s, z6.s
; CHECK-NEXT:    incw z1.s, all, mul #4
; CHECK-NEXT:    cmphi p4.s, p0/z, z4.s, z5.s
; CHECK-NEXT:    uqadd z0.s, z3.s, z0.s
; CHECK-NEXT:    uqadd z1.s, z3.s, z1.s
; CHECK-NEXT:    incw z2.s, all, mul #4
; CHECK-NEXT:    incw z6.s, all, mul #4
; CHECK-NEXT:    uzp1 p1.h, p1.h, p2.h
; CHECK-NEXT:    uzp1 p2.h, p3.h, p4.h
; CHECK-NEXT:    cmphi p3.s, p0/z, z4.s, z0.s
; CHECK-NEXT:    cmphi p4.s, p0/z, z4.s, z1.s
; CHECK-NEXT:    uqadd z0.s, z3.s, z2.s
; CHECK-NEXT:    uqadd z1.s, z3.s, z6.s
; CHECK-NEXT:    cmphi p5.s, p0/z, z4.s, z0.s
; CHECK-NEXT:    cmphi p0.s, p0/z, z4.s, z1.s
; CHECK-NEXT:    uzp1 p3.h, p3.h, p4.h
; CHECK-NEXT:    uzp1 p4.h, p5.h, p0.h
; CHECK-NEXT:    uzp1 p0.b, p1.b, p2.b
; CHECK-NEXT:    uzp1 p1.b, p3.b, p4.b
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
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p7, [sp, #4, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p6, [sp, #5, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p5, [sp, #6, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 8 * VG
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    index z0.d, #0, #1
; CHECK-NEXT:    mov z3.d, x0
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    mov z2.d, z0.d
; CHECK-NEXT:    mov z4.d, x1
; CHECK-NEXT:    incd z1.d
; CHECK-NEXT:    uqadd z5.d, z3.d, z0.d
; CHECK-NEXT:    uqadd z6.d, z3.d, z1.d
; CHECK-NEXT:    cmphi p1.d, p0/z, z4.d, z5.d
; CHECK-NEXT:    mov z5.d, z1.d
; CHECK-NEXT:    incd z2.d, all, mul #2
; CHECK-NEXT:    cmphi p2.d, p0/z, z4.d, z6.d
; CHECK-NEXT:    uqadd z6.d, z3.d, z2.d
; CHECK-NEXT:    mov z7.d, z0.d
; CHECK-NEXT:    incd z5.d, all, mul #2
; CHECK-NEXT:    uzp1 p1.s, p1.s, p2.s
; CHECK-NEXT:    cmphi p2.d, p0/z, z4.d, z6.d
; CHECK-NEXT:    uqadd z6.d, z3.d, z5.d
; CHECK-NEXT:    mov z24.d, z1.d
; CHECK-NEXT:    incd z7.d, all, mul #4
; CHECK-NEXT:    cmphi p3.d, p0/z, z4.d, z6.d
; CHECK-NEXT:    uqadd z6.d, z3.d, z7.d
; CHECK-NEXT:    mov z25.d, z2.d
; CHECK-NEXT:    incd z24.d, all, mul #4
; CHECK-NEXT:    mov z26.d, z5.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z4.d, z6.d
; CHECK-NEXT:    uqadd z6.d, z3.d, z24.d
; CHECK-NEXT:    incd z25.d, all, mul #4
; CHECK-NEXT:    cmphi p5.d, p0/z, z4.d, z6.d
; CHECK-NEXT:    uqadd z6.d, z3.d, z25.d
; CHECK-NEXT:    incd z26.d, all, mul #4
; CHECK-NEXT:    cmphi p6.d, p0/z, z4.d, z6.d
; CHECK-NEXT:    uqadd z6.d, z3.d, z26.d
; CHECK-NEXT:    uzp1 p2.s, p2.s, p3.s
; CHECK-NEXT:    cmphi p3.d, p0/z, z4.d, z6.d
; CHECK-NEXT:    incd z0.d, all, mul #8
; CHECK-NEXT:    incd z1.d, all, mul #8
; CHECK-NEXT:    uzp1 p4.s, p4.s, p5.s
; CHECK-NEXT:    uzp1 p3.s, p6.s, p3.s
; CHECK-NEXT:    uqadd z0.d, z3.d, z0.d
; CHECK-NEXT:    uqadd z1.d, z3.d, z1.d
; CHECK-NEXT:    incd z2.d, all, mul #8
; CHECK-NEXT:    incd z5.d, all, mul #8
; CHECK-NEXT:    uzp1 p1.h, p1.h, p2.h
; CHECK-NEXT:    uzp1 p2.h, p4.h, p3.h
; CHECK-NEXT:    cmphi p3.d, p0/z, z4.d, z0.d
; CHECK-NEXT:    cmphi p4.d, p0/z, z4.d, z1.d
; CHECK-NEXT:    uqadd z0.d, z3.d, z2.d
; CHECK-NEXT:    uqadd z1.d, z3.d, z5.d
; CHECK-NEXT:    incd z7.d, all, mul #8
; CHECK-NEXT:    incd z24.d, all, mul #8
; CHECK-NEXT:    cmphi p5.d, p0/z, z4.d, z0.d
; CHECK-NEXT:    cmphi p6.d, p0/z, z4.d, z1.d
; CHECK-NEXT:    uqadd z0.d, z3.d, z7.d
; CHECK-NEXT:    uqadd z1.d, z3.d, z24.d
; CHECK-NEXT:    incd z25.d, all, mul #8
; CHECK-NEXT:    incd z26.d, all, mul #8
; CHECK-NEXT:    uzp1 p3.s, p3.s, p4.s
; CHECK-NEXT:    uzp1 p4.s, p5.s, p6.s
; CHECK-NEXT:    cmphi p5.d, p0/z, z4.d, z0.d
; CHECK-NEXT:    cmphi p6.d, p0/z, z4.d, z1.d
; CHECK-NEXT:    uqadd z0.d, z3.d, z25.d
; CHECK-NEXT:    uqadd z1.d, z3.d, z26.d
; CHECK-NEXT:    cmphi p7.d, p0/z, z4.d, z0.d
; CHECK-NEXT:    cmphi p0.d, p0/z, z4.d, z1.d
; CHECK-NEXT:    uzp1 p5.s, p5.s, p6.s
; CHECK-NEXT:    uzp1 p0.s, p7.s, p0.s
; CHECK-NEXT:    uzp1 p3.h, p3.h, p4.h
; CHECK-NEXT:    uzp1 p4.h, p5.h, p0.h
; CHECK-NEXT:    uzp1 p0.b, p1.b, p2.b
; CHECK-NEXT:    uzp1 p1.b, p3.b, p4.b
; CHECK-NEXT:    ldr p7, [sp, #4, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p6, [sp, #5, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p5, [sp, #6, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i64(i64 %index, i64 %TC)
  ret <vscale x 32 x i1> %active.lane.mask
}

define <vscale x 32 x i1> @lane_mask_nxv32i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_nxv32i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    rdvl x8, #1
; CHECK-NEXT:    index z0.b, #0, #1
; CHECK-NEXT:    mov z1.b, w8
; CHECK-NEXT:    mov z2.b, w0
; CHECK-NEXT:    add z1.b, z0.b, z1.b
; CHECK-NEXT:    mov z3.b, w1
; CHECK-NEXT:    uqadd z0.b, z2.b, z0.b
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    uqadd z1.b, z2.b, z1.b
; CHECK-NEXT:    cmphi p0.b, p1/z, z3.b, z0.b
; CHECK-NEXT:    cmphi p1.b, p1/z, z3.b, z1.b
; CHECK-NEXT:    ret
  %active.lane.mask = call <vscale x 32 x i1> @llvm.get.active.lane.mask.nxv32i1.i8(i8 %index, i8 %TC)
  ret <vscale x 32 x i1> %active.lane.mask
}


; == Fixed width ==

define <16 x i1> @lane_mask_v16i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_v16i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI15_0
; CHECK-NEXT:    adrp x9, .LCPI15_3
; CHECK-NEXT:    adrp x10, .LCPI15_2
; CHECK-NEXT:    dup v2.4s, w0
; CHECK-NEXT:    dup v5.4s, w1
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI15_0]
; CHECK-NEXT:    adrp x8, .LCPI15_1
; CHECK-NEXT:    ldr q1, [x9, :lo12:.LCPI15_3]
; CHECK-NEXT:    ldr q3, [x10, :lo12:.LCPI15_2]
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI15_1]
; CHECK-NEXT:    uqadd v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    uqadd v3.4s, v2.4s, v3.4s
; CHECK-NEXT:    uqadd v4.4s, v2.4s, v4.4s
; CHECK-NEXT:    uqadd v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    cmhi v1.4s, v5.4s, v1.4s
; CHECK-NEXT:    cmhi v2.4s, v5.4s, v3.4s
; CHECK-NEXT:    cmhi v3.4s, v5.4s, v4.4s
; CHECK-NEXT:    cmhi v0.4s, v5.4s, v0.4s
; CHECK-NEXT:    uzp1 v1.8h, v2.8h, v1.8h
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v3.8h
; CHECK-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %active.lane.mask = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32 %index, i32 %TC)
  ret <16 x i1> %active.lane.mask
}

define <8 x i1> @lane_mask_v8i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_v8i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI16_1
; CHECK-NEXT:    adrp x9, .LCPI16_0
; CHECK-NEXT:    dup v2.4s, w0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI16_1]
; CHECK-NEXT:    ldr q1, [x9, :lo12:.LCPI16_0]
; CHECK-NEXT:    uqadd v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    uqadd v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    dup v2.4s, w1
; CHECK-NEXT:    cmhi v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    cmhi v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    uzp1 v0.8h, v1.8h, v0.8h
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    ret
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 %index, i32 %TC)
  ret <8 x i1> %active.lane.mask
}

define <4 x i1> @lane_mask_v4i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_v4i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI17_0
; CHECK-NEXT:    dup v1.4s, w0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI17_0]
; CHECK-NEXT:    uqadd v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    dup v1.4s, w1
; CHECK-NEXT:    cmhi v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %TC)
  ret <4 x i1> %active.lane.mask
}

define <2 x i1> @lane_mask_v2i1_i32(i32 %index, i32 %TC) {
; CHECK-LABEL: lane_mask_v2i1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI18_0
; CHECK-NEXT:    dup v0.2s, w0
; CHECK-NEXT:    ldr d1, [x8, :lo12:.LCPI18_0]
; CHECK-NEXT:    uqadd v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    dup v1.2s, w1
; CHECK-NEXT:    cmhi v0.2s, v1.2s, v0.2s
; CHECK-NEXT:    ret
  %active.lane.mask = call <2 x i1> @llvm.get.active.lane.mask.v2i1.i32(i32 %index, i32 %TC)
  ret <2 x i1> %active.lane.mask
}

define <16 x i1> @lane_mask_v16i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_v16i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI19_0
; CHECK-NEXT:    adrp x9, .LCPI19_1
; CHECK-NEXT:    adrp x10, .LCPI19_2
; CHECK-NEXT:    dup v1.2d, x0
; CHECK-NEXT:    dup v17.2d, x1
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI19_0]
; CHECK-NEXT:    adrp x8, .LCPI19_3
; CHECK-NEXT:    ldr q2, [x9, :lo12:.LCPI19_1]
; CHECK-NEXT:    adrp x9, .LCPI19_4
; CHECK-NEXT:    ldr q3, [x10, :lo12:.LCPI19_2]
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI19_3]
; CHECK-NEXT:    adrp x8, .LCPI19_5
; CHECK-NEXT:    ldr q5, [x9, :lo12:.LCPI19_4]
; CHECK-NEXT:    adrp x9, .LCPI19_7
; CHECK-NEXT:    uqadd v0.2d, v1.2d, v0.2d
; CHECK-NEXT:    ldr q6, [x8, :lo12:.LCPI19_5]
; CHECK-NEXT:    adrp x8, .LCPI19_6
; CHECK-NEXT:    ldr q7, [x9, :lo12:.LCPI19_7]
; CHECK-NEXT:    uqadd v2.2d, v1.2d, v2.2d
; CHECK-NEXT:    ldr q16, [x8, :lo12:.LCPI19_6]
; CHECK-NEXT:    uqadd v3.2d, v1.2d, v3.2d
; CHECK-NEXT:    uqadd v4.2d, v1.2d, v4.2d
; CHECK-NEXT:    uqadd v6.2d, v1.2d, v6.2d
; CHECK-NEXT:    uqadd v7.2d, v1.2d, v7.2d
; CHECK-NEXT:    uqadd v16.2d, v1.2d, v16.2d
; CHECK-NEXT:    uqadd v1.2d, v1.2d, v5.2d
; CHECK-NEXT:    cmhi v6.2d, v17.2d, v6.2d
; CHECK-NEXT:    cmhi v5.2d, v17.2d, v7.2d
; CHECK-NEXT:    cmhi v7.2d, v17.2d, v16.2d
; CHECK-NEXT:    cmhi v1.2d, v17.2d, v1.2d
; CHECK-NEXT:    cmhi v4.2d, v17.2d, v4.2d
; CHECK-NEXT:    cmhi v3.2d, v17.2d, v3.2d
; CHECK-NEXT:    cmhi v2.2d, v17.2d, v2.2d
; CHECK-NEXT:    cmhi v0.2d, v17.2d, v0.2d
; CHECK-NEXT:    uzp1 v5.4s, v7.4s, v5.4s
; CHECK-NEXT:    uzp1 v1.4s, v1.4s, v6.4s
; CHECK-NEXT:    uzp1 v3.4s, v3.4s, v4.4s
; CHECK-NEXT:    uzp1 v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    uzp1 v1.8h, v1.8h, v5.8h
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v3.8h
; CHECK-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %active.lane.mask = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i64(i64 %index, i64 %TC)
  ret <16 x i1> %active.lane.mask
}

define <8 x i1> @lane_mask_v8i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_v8i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI20_0
; CHECK-NEXT:    adrp x9, .LCPI20_3
; CHECK-NEXT:    adrp x10, .LCPI20_2
; CHECK-NEXT:    dup v2.2d, x0
; CHECK-NEXT:    dup v5.2d, x1
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI20_0]
; CHECK-NEXT:    adrp x8, .LCPI20_1
; CHECK-NEXT:    ldr q1, [x9, :lo12:.LCPI20_3]
; CHECK-NEXT:    ldr q3, [x10, :lo12:.LCPI20_2]
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI20_1]
; CHECK-NEXT:    uqadd v1.2d, v2.2d, v1.2d
; CHECK-NEXT:    uqadd v3.2d, v2.2d, v3.2d
; CHECK-NEXT:    uqadd v4.2d, v2.2d, v4.2d
; CHECK-NEXT:    uqadd v0.2d, v2.2d, v0.2d
; CHECK-NEXT:    cmhi v1.2d, v5.2d, v1.2d
; CHECK-NEXT:    cmhi v2.2d, v5.2d, v3.2d
; CHECK-NEXT:    cmhi v3.2d, v5.2d, v4.2d
; CHECK-NEXT:    cmhi v0.2d, v5.2d, v0.2d
; CHECK-NEXT:    uzp1 v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    uzp1 v0.4s, v0.4s, v3.4s
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    ret
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i64(i64 %index, i64 %TC)
  ret <8 x i1> %active.lane.mask
}

define <4 x i1> @lane_mask_v4i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_v4i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI21_1
; CHECK-NEXT:    adrp x9, .LCPI21_0
; CHECK-NEXT:    dup v2.2d, x0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI21_1]
; CHECK-NEXT:    ldr q1, [x9, :lo12:.LCPI21_0]
; CHECK-NEXT:    uqadd v0.2d, v2.2d, v0.2d
; CHECK-NEXT:    uqadd v1.2d, v2.2d, v1.2d
; CHECK-NEXT:    dup v2.2d, x1
; CHECK-NEXT:    cmhi v0.2d, v2.2d, v0.2d
; CHECK-NEXT:    cmhi v1.2d, v2.2d, v1.2d
; CHECK-NEXT:    uzp1 v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i64(i64 %index, i64 %TC)
  ret <4 x i1> %active.lane.mask
}

define <2 x i1> @lane_mask_v2i1_i64(i64 %index, i64 %TC) {
; CHECK-LABEL: lane_mask_v2i1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI22_0
; CHECK-NEXT:    dup v1.2d, x0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI22_0]
; CHECK-NEXT:    uqadd v0.2d, v1.2d, v0.2d
; CHECK-NEXT:    dup v1.2d, x1
; CHECK-NEXT:    cmhi v0.2d, v1.2d, v0.2d
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    ret
  %active.lane.mask = call <2 x i1> @llvm.get.active.lane.mask.v2i1.i64(i64 %index, i64 %TC)
  ret <2 x i1> %active.lane.mask
}

define <16 x i1> @lane_mask_v16i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_v16i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI23_0
; CHECK-NEXT:    dup v1.16b, w0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI23_0]
; CHECK-NEXT:    uqadd v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    dup v1.16b, w1
; CHECK-NEXT:    cmhi v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    ret
  %active.lane.mask = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i8(i8 %index, i8 %TC)
  ret <16 x i1> %active.lane.mask
}

define <8 x i1> @lane_mask_v8i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_v8i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI24_0
; CHECK-NEXT:    dup v0.8b, w0
; CHECK-NEXT:    ldr d1, [x8, :lo12:.LCPI24_0]
; CHECK-NEXT:    uqadd v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    dup v1.8b, w1
; CHECK-NEXT:    cmhi v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    ret
  %active.lane.mask = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i8(i8 %index, i8 %TC)
  ret <8 x i1> %active.lane.mask
}

define <4 x i1> @lane_mask_v4i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_v4i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    dup v0.4h, w0
; CHECK-NEXT:    adrp x8, .LCPI25_0
; CHECK-NEXT:    dup v2.4h, w1
; CHECK-NEXT:    ldr d1, [x8, :lo12:.LCPI25_0]
; CHECK-NEXT:    bic v0.4h, #255, lsl #8
; CHECK-NEXT:    bic v2.4h, #255, lsl #8
; CHECK-NEXT:    add v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    movi d1, #0xff00ff00ff00ff
; CHECK-NEXT:    umin v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    cmhi v0.4h, v2.4h, v0.4h
; CHECK-NEXT:    ret
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i8(i8 %index, i8 %TC)
  ret <4 x i1> %active.lane.mask
}

define <2 x i1> @lane_mask_v2i1_i8(i8 %index, i8 %TC) {
; CHECK-LABEL: lane_mask_v2i1_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi d0, #0x0000ff000000ff
; CHECK-NEXT:    dup v1.2s, w0
; CHECK-NEXT:    adrp x8, .LCPI26_0
; CHECK-NEXT:    dup v3.2s, w1
; CHECK-NEXT:    and v1.8b, v1.8b, v0.8b
; CHECK-NEXT:    ldr d2, [x8, :lo12:.LCPI26_0]
; CHECK-NEXT:    add v1.2s, v1.2s, v2.2s
; CHECK-NEXT:    and v2.8b, v3.8b, v0.8b
; CHECK-NEXT:    umin v0.2s, v1.2s, v0.2s
; CHECK-NEXT:    cmhi v0.2s, v2.2s, v0.2s
; CHECK-NEXT:    ret
  %active.lane.mask = call <2 x i1> @llvm.get.active.lane.mask.v2i1.i8(i8 %index, i8 %TC)
  ret <2 x i1> %active.lane.mask
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


declare <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32, i32)
declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32, i32)
declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <2 x i1> @llvm.get.active.lane.mask.v2i1.i32(i32, i32)

declare <16 x i1> @llvm.get.active.lane.mask.v16i1.i64(i64, i64)
declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i64(i64, i64)
declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i64(i64, i64)
declare <2 x i1> @llvm.get.active.lane.mask.v2i1.i64(i64, i64)

declare <16 x i1> @llvm.get.active.lane.mask.v16i1.i8(i8, i8)
declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i8(i8, i8)
declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i8(i8, i8)
declare <2 x i1> @llvm.get.active.lane.mask.v2i1.i8(i8, i8)
