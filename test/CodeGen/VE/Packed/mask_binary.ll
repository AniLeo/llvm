; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ve -mattr=+vpu | FileCheck %s

; Function Attrs: nounwind
define fastcc <512 x i1> @and_mm_v512i1(<512 x i1> %x, <512 x i1> %y) {
; CHECK-LABEL: and_mm_v512i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andm %vm6, %vm2, %vm4
; CHECK-NEXT:    andm %vm7, %vm3, %vm5
; CHECK-NEXT:    andm %vm2, %vm0, %vm6
; CHECK-NEXT:    andm %vm3, %vm0, %vm7
; CHECK-NEXT:    b.l.t (, %s10)
  %z = and <512 x i1> %x, %y
  ret <512 x i1> %z
}

; Function Attrs: nounwind
define fastcc <512 x i1> @or_mm_v512i1(<512 x i1> %x, <512 x i1> %y) {
; CHECK-LABEL: or_mm_v512i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    orm %vm6, %vm2, %vm4
; CHECK-NEXT:    orm %vm7, %vm3, %vm5
; CHECK-NEXT:    andm %vm2, %vm0, %vm6
; CHECK-NEXT:    andm %vm3, %vm0, %vm7
; CHECK-NEXT:    b.l.t (, %s10)
  %z = or <512 x i1> %x, %y
  ret <512 x i1> %z
}

; Function Attrs: nounwind
define fastcc <512 x i1> @xor_mm_v512i1(<512 x i1> %x, <512 x i1> %y) {
; CHECK-LABEL: xor_mm_v512i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorm %vm6, %vm2, %vm4
; CHECK-NEXT:    xorm %vm7, %vm3, %vm5
; CHECK-NEXT:    andm %vm2, %vm0, %vm6
; CHECK-NEXT:    andm %vm3, %vm0, %vm7
; CHECK-NEXT:    b.l.t (, %s10)
  %z = xor <512 x i1> %x, %y
  ret <512 x i1> %z
}

