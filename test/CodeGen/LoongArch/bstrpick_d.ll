; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s

define i64 @lshr40_and255(i64 %a) {
; CHECK-LABEL: lshr40_and255:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a0, $a0, 47, 40
; CHECK-NEXT:    jirl $zero, $ra, 0
  %shr = lshr i64 %a, 40
  %and = and i64 %shr, 255
  ret i64 %and
}

define i64 @ashr50_and511(i64 %a) {
; CHECK-LABEL: ashr50_and511:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a0, $a0, 58, 50
; CHECK-NEXT:    jirl $zero, $ra, 0
  %shr = ashr i64 %a, 50
  %and = and i64 %shr, 511
  ret i64 %and
}

define i64 @zext_i32_to_i64(i32 %a) {
; CHECK-LABEL: zext_i32_to_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a0, $a0, 31, 0
; CHECK-NEXT:    jirl $zero, $ra, 0
  %res = zext i32 %a to i64
  ret i64 %res
}

define i64 @and8191(i64 %a) {
; CHECK-LABEL: and8191:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a0, $a0, 12, 0
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i64 %a, 8191
  ret i64 %and
}

;; Check that andi but not bstrpick.d is generated.
define i64 @and4095(i64 %a) {
; CHECK-LABEL: and4095:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi $a0, $a0, 4095
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i64 %a, 4095
  ret i64 %and
}

;; (srl (and a, 0xff0), 4) => (BSTRPICK a, 11, 4)
define i64 @and0xff0_lshr4(i64 %a) {
; CHECK-LABEL: and0xff0_lshr4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a0, $a0, 11, 4
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i64 %a, 4080
  %shr = lshr i64 %and, 4
  ret i64 %shr
}

;; (sra (and a, 0xff0), 5) can also be combined to (BSTRPICK a, 11, 5).
;; This is because (sra (and a, 0xff0)) would be combined to (srl (and a, 0xff0), 5)
;; firstly by DAGCombiner::SimplifyDemandedBits.
define i64 @and4080_ashr5(i64 %a) {
; CHECK-LABEL: and4080_ashr5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bstrpick.d $a0, $a0, 11, 5
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i64 %a, 4080
  %shr = ashr i64 %and, 5
  ret i64 %shr
}

;; Negative test: the second operand of AND is not a shifted mask
define i64 @and0xf30_lshr4(i64 %a) {
; CHECK-LABEL: and0xf30_lshr4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi $a0, $a0, 3888
; CHECK-NEXT:    srli.d $a0, $a0, 4
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i64 %a, 3888
  %shr = lshr i64 %and, 4
  ret i64 %shr
}

;; Negative test: Shamt < MaskIdx
define i64 @and0xff0_lshr3(i64 %a) {
; CHECK-LABEL: and0xff0_lshr3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi $a0, $a0, 4080
; CHECK-NEXT:    srli.d $a0, $a0, 3
; CHECK-NEXT:    jirl $zero, $ra, 0
  %and = and i64 %a, 4080
  %shr = lshr i64 %and, 3
  ret i64 %shr
}
