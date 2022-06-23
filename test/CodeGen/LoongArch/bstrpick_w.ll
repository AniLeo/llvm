; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s

define i32 @lshr40_and255(i32 %a) {
; CHECK-LABEL: lshr40_and255:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.w $a0, $a0, 17, 10
; CHECK-NEXT:    jirl $zero, $ra, 0
  %shr = lshr i32 %a, 10
  %and = and i32 %shr, 255
  ret i32 %and
}

define i32 @ashr50_and511(i32 %a) {
; CHECK-LABEL: ashr50_and511:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.w $a0, $a0, 28, 20
; CHECK-NEXT:    jirl $zero, $ra, 0
  %shr = ashr i32 %a, 20
  %and = and i32 %shr, 511
  ret i32 %and
}

define i32 @zext_i16_to_i32(i16 %a) {
; CHECK-LABEL: zext_i16_to_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.w $a0, $a0, 15, 0
; CHECK-NEXT:    jirl $zero, $ra, 0
  %res = zext i16 %a to i32
  ret i32 %res
}

define i32 @and8191(i32 %a) {
; CHECK-LABEL: and8191:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.w $a0, $a0, 12, 0
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i32 %a, 8191
  ret i32 %and
}

;; Check that andi but not bstrpick.d is generated.
define i32 @and4095(i32 %a) {
; CHECK-LABEL: and4095:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi $a0, $a0, 4095
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i32 %a, 4095
  ret i32 %and
}

;; (srl (and a, 0xff0), 4) => (BSTRPICK a, 11, 4)
define i32 @and0xff0_lshr4(i32 %a) {
; CHECK-LABEL: and0xff0_lshr4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.w $a0, $a0, 11, 4
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i32 %a, 4080
  %shr = lshr i32 %and, 4
  ret i32 %shr
}

;; (sra (and a, 0xff0), 5) can also be combined to (BSTRPICK a, 11, 5).
;; This is because (sra (and a, 0xff0)) would be combined to (srl (and a, 0xff0), 5)
;; firstly by DAGCombiner::SimplifyDemandedBits.
define i32 @and4080_ashr5(i32 %a) {
; CHECK-LABEL: and4080_ashr5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.w $a0, $a0, 11, 5
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i32 %a, 4080
  %shr = ashr i32 %and, 5
  ret i32 %shr
}

;; Negative test: the second operand of AND is not a shifted mask
define i32 @and0xf30_lshr4(i32 %a) {
; CHECK-LABEL: and0xf30_lshr4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi $a0, $a0, 3888
; CHECK-NEXT:    srli.w $a0, $a0, 4
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i32 %a, 3888
  %shr = lshr i32 %and, 4
  ret i32 %shr
}

;; Negative test: Shamt < MaskIdx
define i32 @and0xff0_lshr3(i32 %a) {
; CHECK-LABEL: and0xff0_lshr3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi $a0, $a0, 4080
; CHECK-NEXT:    srli.w $a0, $a0, 3
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i32 %a, 4080
  %shr = lshr i32 %and, 3
  ret i32 %shr
}
