; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

; First, check the generic pattern for any 2 vector constants. Then, check special cases where
; the constants are all off-by-one. Finally, check the extra special cases where the constants
; include 0 or -1.
; Each minimal select test is repeated with a more typical pattern that includes a compare to
; generate the condition value.

define <4 x i32> @sel_C1_or_C2_vec(<4 x i1> %cond) {
; CHECK-LABEL: sel_C1_or_C2_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI0_0
; CHECK-NEXT:    adrp x9, .LCPI0_1
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI0_0]
; CHECK-NEXT:    ldr q2, [x9, :lo12:.LCPI0_1]
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    bsl v0.16b, v2.16b, v1.16b
; CHECK-NEXT:    ret
  %add = select <4 x i1> %cond, <4 x i32> <i32 3000, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_C1_or_C2_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: cmp_sel_C1_or_C2_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI1_0
; CHECK-NEXT:    adrp x9, .LCPI1_1
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI1_0]
; CHECK-NEXT:    ldr q3, [x9, :lo12:.LCPI1_1]
; CHECK-NEXT:    bsl v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    ret
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 3000, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_Cplus1_or_C_vec(<4 x i1> %cond) {
; CHECK-LABEL: sel_Cplus1_or_C_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI2_0
; CHECK-NEXT:    adrp x9, .LCPI2_1
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI2_0]
; CHECK-NEXT:    ldr q2, [x9, :lo12:.LCPI2_1]
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    bsl v0.16b, v2.16b, v1.16b
; CHECK-NEXT:    ret
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_Cplus1_or_C_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: cmp_sel_Cplus1_or_C_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI3_0
; CHECK-NEXT:    adrp x9, .LCPI3_1
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI3_0]
; CHECK-NEXT:    ldr q3, [x9, :lo12:.LCPI3_1]
; CHECK-NEXT:    bsl v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    ret
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 42, i32 0, i32 -2, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_Cminus1_or_C_vec(<4 x i1> %cond) {
; CHECK-LABEL: sel_Cminus1_or_C_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI4_0
; CHECK-NEXT:    adrp x9, .LCPI4_1
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI4_0]
; CHECK-NEXT:    ldr q2, [x9, :lo12:.LCPI4_1]
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    bsl v0.16b, v2.16b, v1.16b
; CHECK-NEXT:    ret
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 44, i32 2, i32 0, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_Cminus1_or_C_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: cmp_sel_Cminus1_or_C_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI5_0
; CHECK-NEXT:    adrp x9, .LCPI5_1
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI5_0]
; CHECK-NEXT:    ldr q3, [x9, :lo12:.LCPI5_1]
; CHECK-NEXT:    bsl v0.16b, v3.16b, v2.16b
; CHECK-NEXT:    ret
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 43, i32 1, i32 -1, i32 0>, <4 x i32> <i32 44, i32 2, i32 0, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_minus1_or_0_vec(<4 x i1> %cond) {
; CHECK-LABEL: sel_minus1_or_0_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    ret
  %add = select <4 x i1> %cond, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_minus1_or_0_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: cmp_sel_minus1_or_0_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @sel_0_or_minus1_vec(<4 x i1> %cond) {
; CHECK-LABEL: sel_0_or_minus1_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    cmge v0.4s, v0.4s, #0
; CHECK-NEXT:    ret
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_0_or_minus1_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: cmp_sel_0_or_minus1_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    ret
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %add
}

define <4 x i32> @sel_1_or_0_vec(<4 x i1> %cond) {
; CHECK-LABEL: sel_1_or_0_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %add = select <4 x i1> %cond, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_1_or_0_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: cmp_sel_1_or_0_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.4s, #1
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    ret
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 1, i32 1, i32 1, i32 1>, <4 x i32> <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i32> %add
}

define <4 x i32> @sel_0_or_1_vec(<4 x i1> %cond) {
; CHECK-LABEL: sel_0_or_1_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    shl v0.4s, v0.4s, #31
; CHECK-NEXT:    cmge v0.4s, v0.4s, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

define <4 x i32> @cmp_sel_0_or_1_vec(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: cmp_sel_0_or_1_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.4s, #1
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bic v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    ret
  %cond = icmp eq <4 x i32> %x, %y
  %add = select <4 x i1> %cond, <4 x i32> <i32 0, i32 0, i32 0, i32 0>, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %add
}

define <16 x i8> @signbit_mask_v16i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: signbit_mask_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <16 x i8> %a, zeroinitializer
  %r = select <16 x i1> %cond, <16 x i8> %b, <16 x i8> zeroinitializer
  ret <16 x i8> %r
}

; Swap cmp pred and select ops. This is logically equivalent to the above test.

define <16 x i8> @signbit_mask_swap_v16i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: signbit_mask_swap_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp sgt <16 x i8> %a, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %r = select <16 x i1> %cond, <16 x i8> zeroinitializer, <16 x i8> %b
  ret <16 x i8> %r
}

define <8 x i16> @signbit_mask_v8i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: signbit_mask_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.8h, v0.8h, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <8 x i16> %a, zeroinitializer
  %r = select <8 x i1> %cond, <8 x i16> %b, <8 x i16> zeroinitializer
  ret <8 x i16> %r
}

define <4 x i32> @signbit_mask_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: signbit_mask_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <4 x i32> %a, zeroinitializer
  %r = select <4 x i1> %cond, <4 x i32> %b, <4 x i32> zeroinitializer
  ret <4 x i32> %r
}

define <2 x i64> @signbit_mask_v2i64(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: signbit_mask_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.2d, v0.2d, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <2 x i64> %a, zeroinitializer
  %r = select <2 x i1> %cond, <2 x i64> %b, <2 x i64> zeroinitializer
  ret <2 x i64> %r
}

define <16 x i8> @signbit_setmask_v16i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: signbit_setmask_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <16 x i8> %a, zeroinitializer
  %r = select <16 x i1> %cond, <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <16 x i8> %b
  ret <16 x i8> %r
}

define <8 x i16> @signbit_setmask_v8i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: signbit_setmask_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.8h, v0.8h, #0
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <8 x i16> %a, zeroinitializer
  %r = select <8 x i1> %cond, <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>, <8 x i16> %b
  ret <8 x i16> %r
}

; Swap cmp pred and select ops. This is logically equivalent to the above test.

define <8 x i16> @signbit_setmask_swap_v8i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: signbit_setmask_swap_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.8h, v0.8h, #0
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp sgt <8 x i16> %a, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  %r = select <8 x i1> %cond, <8 x i16> %b, <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  ret <8 x i16> %r
}

define <4 x i32> @signbit_setmask_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: signbit_setmask_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.4s, v0.4s, #0
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <4 x i32> %a, zeroinitializer
  %r = select <4 x i1> %cond, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %b
  ret <4 x i32> %r
}

define <2 x i64> @signbit_setmask_v2i64(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: signbit_setmask_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.2d, v0.2d, #0
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <2 x i64> %a, zeroinitializer
  %r = select <2 x i1> %cond, <2 x i64> <i64 -1, i64 -1>, <2 x i64> %b
  ret <2 x i64> %r
}

define <16 x i8> @not_signbit_mask_v16i8(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: not_signbit_mask_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmge v0.16b, v0.16b, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp sgt <16 x i8> %a, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %r = select <16 x i1> %cond, <16 x i8> %b, <16 x i8> zeroinitializer
  ret <16 x i8> %r
}

define <8 x i16> @not_signbit_mask_v8i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: not_signbit_mask_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmge v0.8h, v0.8h, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp sgt <8 x i16> %a, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  %r = select <8 x i1> %cond, <8 x i16> %b, <8 x i16> zeroinitializer
  ret <8 x i16> %r
}

define <4 x i32> @not_signbit_mask_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: not_signbit_mask_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmge v0.4s, v0.4s, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp sgt <4 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1>
  %r = select <4 x i1> %cond, <4 x i32> %b, <4 x i32> zeroinitializer
  ret <4 x i32> %r
}

; Swap cmp pred and select ops. This is logically equivalent to the above test.

define <4 x i32> @not_signbit_mask_swap_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: not_signbit_mask_swap_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmge v0.4s, v0.4s, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp slt <4 x i32> %a, zeroinitializer
  %r = select <4 x i1> %cond, <4 x i32> zeroinitializer, <4 x i32> %b
  ret <4 x i32> %r
}

define <2 x i64> @not_signbit_mask_v2i64(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: not_signbit_mask_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmge v0.2d, v0.2d, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %cond = icmp sgt <2 x i64> %a, <i64 -1, i64 -1>
  %r = select <2 x i1> %cond, <2 x i64> %b, <2 x i64> zeroinitializer
  ret <2 x i64> %r
}

; SVE

define <vscale x 16 x i8> @signbit_mask_xor_nxv16i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) #0 {
; CHECK-LABEL: signbit_mask_xor_nxv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    cmplt p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    eor z0.d, z0.d, z1.d
; CHECK-NEXT:    mov z0.b, p0/m, #0 // =0x0
; CHECK-NEXT:    ret
  %cond = icmp slt <vscale x 16 x i8> %a, zeroinitializer
  %xor = xor <vscale x 16 x i8> %a, %b
  %r = select <vscale x 16 x i1> %cond, <vscale x 16 x i8> zeroinitializer, <vscale x 16 x i8> %xor
  ret <vscale x 16 x i8> %r
}

attributes #0 = { "target-features"="+sve" }
