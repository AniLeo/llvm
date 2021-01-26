; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=avr | FileCheck %s

define i8 @neg8(i8 %x) {
; CHECK-LABEL: neg8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    neg r24
; CHECK-NEXT:    ret
  %sub = sub i8 0, %x
  ret i8 %sub
}

define i16 @neg16(i16 %x) {
; CHECK-LABEL: neg16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    neg r25
; CHECK-NEXT:    neg r24
; CHECK-NEXT:    sbci r25, 0
; CHECK-NEXT:    ret
  %sub = sub i16 0, %x
  ret i16 %sub
}
