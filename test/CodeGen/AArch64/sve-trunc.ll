; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

; For all the functions below should the operation is a nop
define <vscale x 8 x i8> @trunc_i16toi8(<vscale x 8 x i16> %in) {
; CHECK-LABEL: trunc_i16toi8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 8 x i16> %in to <vscale x 8 x i8>
  ret <vscale x 8 x i8> %out
}

define <vscale x 4 x i8> @trunc_i32toi8(<vscale x 4 x i32> %in) {
; CHECK-LABEL: trunc_i32toi8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 4 x i32> %in to <vscale x 4 x i8>
  ret <vscale x 4 x i8> %out
}

define <vscale x 2 x i8> @trunc_i64toi8(<vscale x 2 x i64> %in) {
; CHECK-LABEL: trunc_i64toi8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 2 x i64> %in to <vscale x 2 x i8>
  ret <vscale x 2 x i8> %out
}

define <vscale x 4 x i16> @trunc_i32toi16(<vscale x 4 x i32> %in) {
; CHECK-LABEL: trunc_i32toi16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 4 x i32> %in to <vscale x 4 x i16>
  ret <vscale x 4 x i16> %out
}

define <vscale x 2 x i16> @trunc_i64toi16(<vscale x 2 x i64> %in) {
; CHECK-LABEL: trunc_i64toi16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 2 x i64> %in to <vscale x 2 x i16>
  ret <vscale x 2 x i16> %out
}

define <vscale x 2 x i32> @trunc_i64toi32(<vscale x 2 x i64> %in) {
; CHECK-LABEL: trunc_i64toi32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 2 x i64> %in to <vscale x 2 x i32>
  ret <vscale x 2 x i32> %out
}

; Truncating to i1 requires convert it to a cmp

define <vscale x 2 x i1> @trunc_i64toi1(<vscale x 2 x i64> %in) {
; CHECK-LABEL: trunc_i64toi1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z0.d, z0.d, #0x1
; CHECK-NEXT:    cmpne p0.d, p0/z, z0.d, #0
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 2 x i64> %in to <vscale x 2 x i1>
  ret <vscale x 2 x i1> %out
}

define <vscale x 4 x i1> @trunc_i64toi1_split(<vscale x 4 x i64> %in) {
; CHECK-LABEL: trunc_i64toi1_split:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z1.d, z1.d, #0x1
; CHECK-NEXT:    and z0.d, z0.d, #0x1
; CHECK-NEXT:    cmpne p1.d, p0/z, z1.d, #0
; CHECK-NEXT:    cmpne p0.d, p0/z, z0.d, #0
; CHECK-NEXT:    uzp1 p0.s, p0.s, p1.s
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 4 x i64> %in to <vscale x 4 x i1>
  ret <vscale x 4 x i1> %out
}

define <vscale x 8 x i1> @trunc_i64toi1_split2(<vscale x 8 x i64> %in) {
; CHECK-LABEL: trunc_i64toi1_split2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z3.d, z3.d, #0x1
; CHECK-NEXT:    and z2.d, z2.d, #0x1
; CHECK-NEXT:    and z1.d, z1.d, #0x1
; CHECK-NEXT:    and z0.d, z0.d, #0x1
; CHECK-NEXT:    cmpne p1.d, p0/z, z3.d, #0
; CHECK-NEXT:    cmpne p2.d, p0/z, z2.d, #0
; CHECK-NEXT:    uzp1 p1.s, p2.s, p1.s
; CHECK-NEXT:    cmpne p2.d, p0/z, z1.d, #0
; CHECK-NEXT:    cmpne p0.d, p0/z, z0.d, #0
; CHECK-NEXT:    uzp1 p0.s, p0.s, p2.s
; CHECK-NEXT:    uzp1 p0.h, p0.h, p1.h
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 8 x i64> %in to <vscale x 8 x i1>
  ret <vscale x 8 x i1> %out
}

define <vscale x 16 x i1> @trunc_i64toi1_split3(<vscale x 16 x i64> %in) {
; CHECK-LABEL: trunc_i64toi1_split3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    str p4, [sp, #7, mul vl] // 2-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset p4, -2
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z7.d, z7.d, #0x1
; CHECK-NEXT:    and z6.d, z6.d, #0x1
; CHECK-NEXT:    and z5.d, z5.d, #0x1
; CHECK-NEXT:    and z4.d, z4.d, #0x1
; CHECK-NEXT:    and z3.d, z3.d, #0x1
; CHECK-NEXT:    and z2.d, z2.d, #0x1
; CHECK-NEXT:    cmpne p1.d, p0/z, z7.d, #0
; CHECK-NEXT:    cmpne p2.d, p0/z, z6.d, #0
; CHECK-NEXT:    cmpne p3.d, p0/z, z5.d, #0
; CHECK-NEXT:    cmpne p4.d, p0/z, z4.d, #0
; CHECK-NEXT:    and z1.d, z1.d, #0x1
; CHECK-NEXT:    and z0.d, z0.d, #0x1
; CHECK-NEXT:    uzp1 p1.s, p2.s, p1.s
; CHECK-NEXT:    cmpne p2.d, p0/z, z3.d, #0
; CHECK-NEXT:    uzp1 p3.s, p4.s, p3.s
; CHECK-NEXT:    cmpne p4.d, p0/z, z2.d, #0
; CHECK-NEXT:    uzp1 p2.s, p4.s, p2.s
; CHECK-NEXT:    cmpne p4.d, p0/z, z1.d, #0
; CHECK-NEXT:    cmpne p0.d, p0/z, z0.d, #0
; CHECK-NEXT:    uzp1 p0.s, p0.s, p4.s
; CHECK-NEXT:    ldr p4, [sp, #7, mul vl] // 2-byte Folded Reload
; CHECK-NEXT:    uzp1 p1.h, p3.h, p1.h
; CHECK-NEXT:    uzp1 p0.h, p0.h, p2.h
; CHECK-NEXT:    uzp1 p0.b, p0.b, p1.b
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 16 x i64> %in to <vscale x 16 x i1>
  ret <vscale x 16 x i1> %out
}


define <vscale x 4 x i1> @trunc_i32toi1(<vscale x 4 x i32> %in) {
; CHECK-LABEL: trunc_i32toi1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    and z0.s, z0.s, #0x1
; CHECK-NEXT:    cmpne p0.s, p0/z, z0.s, #0
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 4 x i32> %in to <vscale x 4 x i1>
  ret <vscale x 4 x i1> %out
}

define <vscale x 8 x i1> @trunc_i16toi1(<vscale x 8 x i16> %in) {
; CHECK-LABEL: trunc_i16toi1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    and z0.h, z0.h, #0x1
; CHECK-NEXT:    cmpne p0.h, p0/z, z0.h, #0
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 8 x i16> %in to <vscale x 8 x i1>
  ret <vscale x 8 x i1> %out
}

define <vscale x 16 x i1> @trunc_i8toi1(<vscale x 16 x i8> %in) {
; CHECK-LABEL: trunc_i8toi1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    and z0.b, z0.b, #0x1
; CHECK-NEXT:    cmpne p0.b, p0/z, z0.b, #0
; CHECK-NEXT:    ret
entry:
  %out = trunc <vscale x 16 x i8> %in to <vscale x 16 x i1>
  ret <vscale x 16 x i1> %out
}
