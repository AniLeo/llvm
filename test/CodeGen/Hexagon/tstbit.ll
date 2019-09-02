; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=hexagon < %s | FileCheck %s

; Function Attrs: nounwind readnone
define i32 @f0(i32 %a0, i32 %a1) #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = tstbit(r0,r1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = mux(p0,#1,#0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = shl i32 1, %a1
  %v1 = and i32 %v0, %a0
  %v2 = icmp ne i32 %v1, 0
  %v3 = zext i1 %v2 to i32
  ret i32 %v3
}

; TODO: Match to tstbit?

define i64 @is_upper_bit_clear_i64(i64 %x) #0 {
; CHECK-LABEL: is_upper_bit_clear_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r4 = #0
; CHECK-NEXT:     r2 = #32
; CHECK-NEXT:     r7:6 = combine(#0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r5 = and(r1,r2)
; CHECK-NEXT:     r1 = r4
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r5:4,r7:6)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = mux(p0,#1,#0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %sh = lshr i64 %x, 37
  %m = and i64 %sh, 1
  %r = xor i64 %m, 1
  ret i64 %r
}

; TODO: Match to tstbit?

define i64 @is_lower_bit_clear_i64(i64 %x) #0 {
; CHECK-LABEL: is_lower_bit_clear_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r5:4 = combine(#0,#0)
; CHECK-NEXT:     r2 = ##134217728
; CHECK-NEXT:     r1 = #0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = and(r0,r2)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r1:0,r5:4)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = mux(p0,#1,#0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %sh = lshr i64 %x, 27
  %m = and i64 %sh, 1
  %r = xor i64 %m, 1
  ret i64 %r
}

; TODO: Match to tstbit?

define i32 @is_bit_clear_i32(i32 %x) #0 {
; CHECK-LABEL: is_bit_clear_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = and(r0,##134217728)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = cmp.eq(r0,#0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %sh = lshr i32 %x, 27
  %n = xor i32 %sh, -1
  %r = and i32 %n, 1
  ret i32 %r
}

; TODO: Match to tstbit?

define i16 @is_bit_clear_i16(i16 %x) #0 {
; CHECK-LABEL: is_bit_clear_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = and(r0,#128)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = cmp.eq(r0,#0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %sh = lshr i16 %x, 7
  %m = and i16 %sh, 1
  %r = xor i16 %m, 1
  ret i16 %r
}

; TODO: Match to tstbit?

define i8 @is_bit_clear_i8(i8 %x) #0 {
; CHECK-LABEL: is_bit_clear_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = and(r0,#8)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = cmp.eq(r0,#0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %sh = lshr i8 %x, 3
  %m = and i8 %sh, 1
  %r = xor i8 %m, 1
  ret i8 %r
}


attributes #0 = { nounwind readnone }
