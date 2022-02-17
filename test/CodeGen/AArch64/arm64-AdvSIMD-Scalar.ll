; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=arm64-eabi -aarch64-neon-syntax=apple -aarch64-enable-simd-scalar=true | FileCheck %s -check-prefix=CHECK
; RUN: llc < %s -verify-machineinstrs -mtriple=arm64-eabi -aarch64-neon-syntax=generic -aarch64-enable-simd-scalar=true | FileCheck %s -check-prefix=GENERIC

define <2 x i64> @bar(<2 x i64> %a, <2 x i64> %b) nounwind readnone {
; CHECK-LABEL: bar:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add.2d v0, v0, v1
; CHECK-NEXT:    sub d2, d0, d1
; CHECK-NEXT:    add d0, d0, d1
; CHECK-NEXT:    fmov x8, d2
; CHECK-NEXT:    mov.d v0[1], x8
; CHECK-NEXT:    ret
;
; GENERIC-LABEL: bar:
; GENERIC:       // %bb.0:
; GENERIC-NEXT:    add v0.2d, v0.2d, v1.2d
; GENERIC-NEXT:    sub d2, d0, d1
; GENERIC-NEXT:    add d0, d0, d1
; GENERIC-NEXT:    fmov x8, d2
; GENERIC-NEXT:    mov v0.d[1], x8
; GENERIC-NEXT:    ret
  %add = add <2 x i64> %a, %b
  %vgetq_lane = extractelement <2 x i64> %add, i32 0
  %vgetq_lane2 = extractelement <2 x i64> %b, i32 0
  %add3 = add i64 %vgetq_lane, %vgetq_lane2
  %sub = sub i64 %vgetq_lane, %vgetq_lane2
  %vecinit = insertelement <2 x i64> undef, i64 %add3, i32 0
  %vecinit8 = insertelement <2 x i64> %vecinit, i64 %sub, i32 1
  ret <2 x i64> %vecinit8
}

define double @subdd_su64(<2 x i64> %a, <2 x i64> %b) nounwind readnone {
; CHECK-LABEL: subdd_su64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub d0, d1, d0
; CHECK-NEXT:    ret
;
; GENERIC-LABEL: subdd_su64:
; GENERIC:       // %bb.0:
; GENERIC-NEXT:    sub d0, d1, d0
; GENERIC-NEXT:    ret
  %vecext = extractelement <2 x i64> %a, i32 0
  %vecext1 = extractelement <2 x i64> %b, i32 0
  %sub.i = sub nsw i64 %vecext1, %vecext
  %retval = bitcast i64 %sub.i to double
  ret double %retval
}

define double @vaddd_su64(<2 x i64> %a, <2 x i64> %b) nounwind readnone {
; CHECK-LABEL: vaddd_su64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add d0, d1, d0
; CHECK-NEXT:    ret
;
; GENERIC-LABEL: vaddd_su64:
; GENERIC:       // %bb.0:
; GENERIC-NEXT:    add d0, d1, d0
; GENERIC-NEXT:    ret
  %vecext = extractelement <2 x i64> %a, i32 0
  %vecext1 = extractelement <2 x i64> %b, i32 0
  %add.i = add nsw i64 %vecext1, %vecext
  %retval = bitcast i64 %add.i to double
  ret double %retval
}

; sub MI doesn't access dsub register.
define double @add_sub_su64(<2 x i64> %a, <2 x i64> %b) nounwind readnone {
; CHECK-LABEL: add_sub_su64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov d2, xzr
; CHECK-NEXT:    add d0, d1, d0
; CHECK-NEXT:    sub d0, d2, d0
; CHECK-NEXT:    ret
;
; GENERIC-LABEL: add_sub_su64:
; GENERIC:       // %bb.0:
; GENERIC-NEXT:    fmov d2, xzr
; GENERIC-NEXT:    add d0, d1, d0
; GENERIC-NEXT:    sub d0, d2, d0
; GENERIC-NEXT:    ret
  %vecext = extractelement <2 x i64> %a, i32 0
  %vecext1 = extractelement <2 x i64> %b, i32 0
  %add.i = add i64 %vecext1, %vecext
  %sub.i = sub i64 0, %add.i
  %retval = bitcast i64 %sub.i to double
  ret double %retval
}
define double @and_su64(<2 x i64> %a, <2 x i64> %b) nounwind readnone {
; CHECK-LABEL: and_su64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and.8b v0, v1, v0
; CHECK-NEXT:    ret
;
; GENERIC-LABEL: and_su64:
; GENERIC:       // %bb.0:
; GENERIC-NEXT:    and v0.8b, v1.8b, v0.8b
; GENERIC-NEXT:    ret
  %vecext = extractelement <2 x i64> %a, i32 0
  %vecext1 = extractelement <2 x i64> %b, i32 0
  %or.i = and i64 %vecext1, %vecext
  %retval = bitcast i64 %or.i to double
  ret double %retval
}

define double @orr_su64(<2 x i64> %a, <2 x i64> %b) nounwind readnone {
; CHECK-LABEL: orr_su64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr.8b v0, v1, v0
; CHECK-NEXT:    ret
;
; GENERIC-LABEL: orr_su64:
; GENERIC:       // %bb.0:
; GENERIC-NEXT:    orr v0.8b, v1.8b, v0.8b
; GENERIC-NEXT:    ret
  %vecext = extractelement <2 x i64> %a, i32 0
  %vecext1 = extractelement <2 x i64> %b, i32 0
  %or.i = or i64 %vecext1, %vecext
  %retval = bitcast i64 %or.i to double
  ret double %retval
}

define double @xorr_su64(<2 x i64> %a, <2 x i64> %b) nounwind readnone {
; CHECK-LABEL: xorr_su64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor.8b v0, v1, v0
; CHECK-NEXT:    ret
;
; GENERIC-LABEL: xorr_su64:
; GENERIC:       // %bb.0:
; GENERIC-NEXT:    eor v0.8b, v1.8b, v0.8b
; GENERIC-NEXT:    ret
  %vecext = extractelement <2 x i64> %a, i32 0
  %vecext1 = extractelement <2 x i64> %b, i32 0
  %xor.i = xor i64 %vecext1, %vecext
  %retval = bitcast i64 %xor.i to double
  ret double %retval
}
