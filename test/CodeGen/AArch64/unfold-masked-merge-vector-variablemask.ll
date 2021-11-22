; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=37104

; All the advanced stuff (negative tests, commutativity) is handled in the
; scalar version of the test only.

; ============================================================================ ;
; 8-bit vector width
; ============================================================================ ;

define <1 x i8> @out_v1i8(<1 x i8> %x, <1 x i8> %y, <1 x i8> %mask) nounwind {
; CHECK-LABEL: out_v1i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <1 x i8> %x, %mask
  %notmask = xor <1 x i8> %mask, <i8 -1>
  %my = and <1 x i8> %y, %notmask
  %r = or <1 x i8> %mx, %my
  ret <1 x i8> %r
}

; ============================================================================ ;
; 16-bit vector width
; ============================================================================ ;

define <2 x i8> @out_v2i8(<2 x i8> %x, <2 x i8> %y, <2 x i8> %mask) nounwind {
; CHECK-LABEL: out_v2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <2 x i8> %x, %mask
  %notmask = xor <2 x i8> %mask, <i8 -1, i8 -1>
  %my = and <2 x i8> %y, %notmask
  %r = or <2 x i8> %mx, %my
  ret <2 x i8> %r
}

define <1 x i16> @out_v1i16(<1 x i16> %x, <1 x i16> %y, <1 x i16> %mask) nounwind {
; CHECK-LABEL: out_v1i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <1 x i16> %x, %mask
  %notmask = xor <1 x i16> %mask, <i16 -1>
  %my = and <1 x i16> %y, %notmask
  %r = or <1 x i16> %mx, %my
  ret <1 x i16> %r
}

; ============================================================================ ;
; 32-bit vector width
; ============================================================================ ;

define <4 x i8> @out_v4i8(<4 x i8> %x, <4 x i8> %y, <4 x i8> %mask) nounwind {
; CHECK-LABEL: out_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <4 x i8> %x, %mask
  %notmask = xor <4 x i8> %mask, <i8 -1, i8 -1, i8 -1, i8 -1>
  %my = and <4 x i8> %y, %notmask
  %r = or <4 x i8> %mx, %my
  ret <4 x i8> %r
}

define <4 x i8> @out_v4i8_undef(<4 x i8> %x, <4 x i8> %y, <4 x i8> %mask) nounwind {
; CHECK-LABEL: out_v4i8_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <4 x i8> %x, %mask
  %notmask = xor <4 x i8> %mask, <i8 -1, i8 -1, i8 undef, i8 -1>
  %my = and <4 x i8> %y, %notmask
  %r = or <4 x i8> %mx, %my
  ret <4 x i8> %r
}

define <2 x i16> @out_v2i16(<2 x i16> %x, <2 x i16> %y, <2 x i16> %mask) nounwind {
; CHECK-LABEL: out_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <2 x i16> %x, %mask
  %notmask = xor <2 x i16> %mask, <i16 -1, i16 -1>
  %my = and <2 x i16> %y, %notmask
  %r = or <2 x i16> %mx, %my
  ret <2 x i16> %r
}

define <1 x i32> @out_v1i32(<1 x i32> %x, <1 x i32> %y, <1 x i32> %mask) nounwind {
; CHECK-LABEL: out_v1i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <1 x i32> %x, %mask
  %notmask = xor <1 x i32> %mask, <i32 -1>
  %my = and <1 x i32> %y, %notmask
  %r = or <1 x i32> %mx, %my
  ret <1 x i32> %r
}

; ============================================================================ ;
; 64-bit vector width
; ============================================================================ ;

define <8 x i8> @out_v8i8(<8 x i8> %x, <8 x i8> %y, <8 x i8> %mask) nounwind {
; CHECK-LABEL: out_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <8 x i8> %x, %mask
  %notmask = xor <8 x i8> %mask, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %my = and <8 x i8> %y, %notmask
  %r = or <8 x i8> %mx, %my
  ret <8 x i8> %r
}

define <4 x i16> @out_v4i16(<4 x i16> %x, <4 x i16> %y, <4 x i16> %mask) nounwind {
; CHECK-LABEL: out_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <4 x i16> %x, %mask
  %notmask = xor <4 x i16> %mask, <i16 -1, i16 -1, i16 -1, i16 -1>
  %my = and <4 x i16> %y, %notmask
  %r = or <4 x i16> %mx, %my
  ret <4 x i16> %r
}

define <4 x i16> @out_v4i16_undef(<4 x i16> %x, <4 x i16> %y, <4 x i16> %mask) nounwind {
; CHECK-LABEL: out_v4i16_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <4 x i16> %x, %mask
  %notmask = xor <4 x i16> %mask, <i16 -1, i16 -1, i16 undef, i16 -1>
  %my = and <4 x i16> %y, %notmask
  %r = or <4 x i16> %mx, %my
  ret <4 x i16> %r
}

define <2 x i32> @out_v2i32(<2 x i32> %x, <2 x i32> %y, <2 x i32> %mask) nounwind {
; CHECK-LABEL: out_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <2 x i32> %x, %mask
  %notmask = xor <2 x i32> %mask, <i32 -1, i32 -1>
  %my = and <2 x i32> %y, %notmask
  %r = or <2 x i32> %mx, %my
  ret <2 x i32> %r
}

define <1 x i64> @out_v1i64(<1 x i64> %x, <1 x i64> %y, <1 x i64> %mask) nounwind {
; CHECK-LABEL: out_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %mx = and <1 x i64> %x, %mask
  %notmask = xor <1 x i64> %mask, <i64 -1>
  %my = and <1 x i64> %y, %notmask
  %r = or <1 x i64> %mx, %my
  ret <1 x i64> %r
}

; ============================================================================ ;
; 128-bit vector width
; ============================================================================ ;

define <16 x i8> @out_v16i8(<16 x i8> %x, <16 x i8> %y, <16 x i8> %mask) nounwind {
; CHECK-LABEL: out_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %mx = and <16 x i8> %x, %mask
  %notmask = xor <16 x i8> %mask, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %my = and <16 x i8> %y, %notmask
  %r = or <16 x i8> %mx, %my
  ret <16 x i8> %r
}

define <8 x i16> @out_v8i16(<8 x i16> %x, <8 x i16> %y, <8 x i16> %mask) nounwind {
; CHECK-LABEL: out_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %mx = and <8 x i16> %x, %mask
  %notmask = xor <8 x i16> %mask, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  %my = and <8 x i16> %y, %notmask
  %r = or <8 x i16> %mx, %my
  ret <8 x i16> %r
}

define <4 x i32> @out_v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> %mask) nounwind {
; CHECK-LABEL: out_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %mx = and <4 x i32> %x, %mask
  %notmask = xor <4 x i32> %mask, <i32 -1, i32 -1, i32 -1, i32 -1>
  %my = and <4 x i32> %y, %notmask
  %r = or <4 x i32> %mx, %my
  ret <4 x i32> %r
}

define <4 x i32> @out_v4i32_undef(<4 x i32> %x, <4 x i32> %y, <4 x i32> %mask) nounwind {
; CHECK-LABEL: out_v4i32_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %mx = and <4 x i32> %x, %mask
  %notmask = xor <4 x i32> %mask, <i32 -1, i32 -1, i32 undef, i32 -1>
  %my = and <4 x i32> %y, %notmask
  %r = or <4 x i32> %mx, %my
  ret <4 x i32> %r
}

define <2 x i64> @out_v2i64(<2 x i64> %x, <2 x i64> %y, <2 x i64> %mask) nounwind {
; CHECK-LABEL: out_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %mx = and <2 x i64> %x, %mask
  %notmask = xor <2 x i64> %mask, <i64 -1, i64 -1>
  %my = and <2 x i64> %y, %notmask
  %r = or <2 x i64> %mx, %my
  ret <2 x i64> %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Should be the same as the previous one.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ============================================================================ ;
; 8-bit vector width
; ============================================================================ ;

define <1 x i8> @in_v1i8(<1 x i8> %x, <1 x i8> %y, <1 x i8> %mask) nounwind {
; CHECK-LABEL: in_v1i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <1 x i8> %x, %y
  %n1 = and <1 x i8> %n0, %mask
  %r = xor <1 x i8> %n1, %y
  ret <1 x i8> %r
}

; ============================================================================ ;
; 16-bit vector width
; ============================================================================ ;

define <2 x i8> @in_v2i8(<2 x i8> %x, <2 x i8> %y, <2 x i8> %mask) nounwind {
; CHECK-LABEL: in_v2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <2 x i8> %x, %y
  %n1 = and <2 x i8> %n0, %mask
  %r = xor <2 x i8> %n1, %y
  ret <2 x i8> %r
}

define <1 x i16> @in_v1i16(<1 x i16> %x, <1 x i16> %y, <1 x i16> %mask) nounwind {
; CHECK-LABEL: in_v1i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <1 x i16> %x, %y
  %n1 = and <1 x i16> %n0, %mask
  %r = xor <1 x i16> %n1, %y
  ret <1 x i16> %r
}

; ============================================================================ ;
; 32-bit vector width
; ============================================================================ ;

define <4 x i8> @in_v4i8(<4 x i8> %x, <4 x i8> %y, <4 x i8> %mask) nounwind {
; CHECK-LABEL: in_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <4 x i8> %x, %y
  %n1 = and <4 x i8> %n0, %mask
  %r = xor <4 x i8> %n1, %y
  ret <4 x i8> %r
}

define <2 x i16> @in_v2i16(<2 x i16> %x, <2 x i16> %y, <2 x i16> %mask) nounwind {
; CHECK-LABEL: in_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <2 x i16> %x, %y
  %n1 = and <2 x i16> %n0, %mask
  %r = xor <2 x i16> %n1, %y
  ret <2 x i16> %r
}

define <1 x i32> @in_v1i32(<1 x i32> %x, <1 x i32> %y, <1 x i32> %mask) nounwind {
; CHECK-LABEL: in_v1i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <1 x i32> %x, %y
  %n1 = and <1 x i32> %n0, %mask
  %r = xor <1 x i32> %n1, %y
  ret <1 x i32> %r
}

; ============================================================================ ;
; 64-bit vector width
; ============================================================================ ;

define <8 x i8> @in_v8i8(<8 x i8> %x, <8 x i8> %y, <8 x i8> %mask) nounwind {
; CHECK-LABEL: in_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <8 x i8> %x, %y
  %n1 = and <8 x i8> %n0, %mask
  %r = xor <8 x i8> %n1, %y
  ret <8 x i8> %r
}

define <4 x i16> @in_v4i16(<4 x i16> %x, <4 x i16> %y, <4 x i16> %mask) nounwind {
; CHECK-LABEL: in_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <4 x i16> %x, %y
  %n1 = and <4 x i16> %n0, %mask
  %r = xor <4 x i16> %n1, %y
  ret <4 x i16> %r
}

define <2 x i32> @in_v2i32(<2 x i32> %x, <2 x i32> %y, <2 x i32> %mask) nounwind {
; CHECK-LABEL: in_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <2 x i32> %x, %y
  %n1 = and <2 x i32> %n0, %mask
  %r = xor <2 x i32> %n1, %y
  ret <2 x i32> %r
}

define <1 x i64> @in_v1i64(<1 x i64> %x, <1 x i64> %y, <1 x i64> %mask) nounwind {
; CHECK-LABEL: in_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %n0 = xor <1 x i64> %x, %y
  %n1 = and <1 x i64> %n0, %mask
  %r = xor <1 x i64> %n1, %y
  ret <1 x i64> %r
}

; ============================================================================ ;
; 128-bit vector width
; ============================================================================ ;

define <16 x i8> @in_v16i8(<16 x i8> %x, <16 x i8> %y, <16 x i8> %mask) nounwind {
; CHECK-LABEL: in_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %n0 = xor <16 x i8> %x, %y
  %n1 = and <16 x i8> %n0, %mask
  %r = xor <16 x i8> %n1, %y
  ret <16 x i8> %r
}

define <8 x i16> @in_v8i16(<8 x i16> %x, <8 x i16> %y, <8 x i16> %mask) nounwind {
; CHECK-LABEL: in_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %n0 = xor <8 x i16> %x, %y
  %n1 = and <8 x i16> %n0, %mask
  %r = xor <8 x i16> %n1, %y
  ret <8 x i16> %r
}

define <4 x i32> @in_v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> %mask) nounwind {
; CHECK-LABEL: in_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %n0 = xor <4 x i32> %x, %y
  %n1 = and <4 x i32> %n0, %mask
  %r = xor <4 x i32> %n1, %y
  ret <4 x i32> %r
}

define <2 x i64> @in_v2i64(<2 x i64> %x, <2 x i64> %y, <2 x i64> %mask) nounwind {
; CHECK-LABEL: in_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %n0 = xor <2 x i64> %x, %y
  %n1 = and <2 x i64> %n0, %mask
  %r = xor <2 x i64> %n1, %y
  ret <2 x i64> %r
}
