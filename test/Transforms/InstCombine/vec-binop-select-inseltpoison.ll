; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Non-canonical mask

define <4 x i32> @and(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @and(
; CHECK-NEXT:    [[R:%.*]] = and <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 4, i32 1, i32 2, i32 7>
  %r = and <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <vscale x 4 x i32> @vscaleand(<vscale x 4 x i32> %x, <vscale x 4 x i32> %y) {
; CHECK-LABEL: @vscaleand(
; CHECK-NEXT:    [[TMP1:%.*]] = and <vscale x 4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <vscale x 4 x i32> [[TMP1]], <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    ret <vscale x 4 x i32> [[R]]
;
  %sel1 = shufflevector <vscale x 4 x i32> %x, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %sel2 = shufflevector <vscale x 4 x i32> %y, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %r = and <vscale x 4 x i32> %sel1, %sel2
  ret <vscale x 4 x i32> %r
}

define <4 x i32> @or(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @or(
; CHECK-NEXT:    [[R:%.*]] = or <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
  %r = or <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

; Non-canonical masks

define <4 x i32> @xor(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @xor(
; CHECK-NEXT:    [[R:%.*]] = xor <4 x i32> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %r = xor <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

; Flags

define <4 x i32> @add(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @add(
; CHECK-NEXT:    [[R:%.*]] = add nsw <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %r = add nsw <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

; Negative test - wrong operand

define <4 x i32> @add_wrong_op(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z) {
; CHECK-LABEL: @add_wrong_op(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[Z:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[R:%.*]] = add nsw <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %z, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %r = add nsw <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

; Negative test - wrong mask (but we could handle this...)

define <4 x i32> @add_non_select_mask(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @add_non_select_mask(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 1, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 1, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[R:%.*]] = add nsw <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 1, i32 5, i32 2, i32 7>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 1, i32 5, i32 2, i32 7>
  %r = add nsw <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

; Negative test - wrong mask (but we could handle this...)

define <4 x i32> @add_masks_with_undefs(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @add_masks_with_undefs(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 undef, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 undef, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[R:%.*]] = add nsw <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 undef, i32 5, i32 2, i32 7>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 undef, i32 5, i32 2, i32 7>
  %r = add nsw <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

; Non-commutative opcode

define <4 x i32> @sub(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @sub(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[R:%.*]] = sub <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %r = sub <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @mul(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @mul(
; CHECK-NEXT:    [[R:%.*]] = mul nuw <4 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %r = mul nuw <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @sdiv(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @sdiv(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:    [[R:%.*]] = sdiv <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %r = sdiv <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @udiv(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @udiv(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[R:%.*]] = udiv <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %r = udiv <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @srem(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @srem(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:    [[R:%.*]] = srem <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %r = srem <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @urem(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @urem(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 0, i32 1, i32 6, i32 3>
; CHECK-NEXT:    [[R:%.*]] = urem <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  %r = urem <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @shl(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @shl(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 0, i32 1, i32 6, i32 7>
; CHECK-NEXT:    [[R:%.*]] = shl nsw <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  %r = shl nsw <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @lshr(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @lshr(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> [[Y:%.*]], <4 x i32> <i32 0, i32 5, i32 6, i32 3>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[Y]], <4 x i32> [[X]], <4 x i32> <i32 0, i32 5, i32 6, i32 3>
; CHECK-NEXT:    [[R:%.*]] = lshr exact <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
  %r = lshr exact <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x i32> @ashr(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @ashr(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x i32> [[Y:%.*]], <4 x i32> [[X:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x i32> [[X]], <4 x i32> [[Y]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[R:%.*]] = ashr <4 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sel1 = shufflevector <4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x i32> %y, <4 x i32> %x, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %r = ashr <4 x i32> %sel1, %sel2
  ret <4 x i32> %r
}

define <4 x float> @fadd(<4 x float> %x, <4 x float> %y) {
; CHECK-LABEL: @fadd(
; CHECK-NEXT:    [[R:%.*]] = fadd <4 x float> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %sel1 = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x float> %y, <4 x float> %x, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %r = fadd <4 x float> %sel1, %sel2
  ret <4 x float> %r
}

define <4 x float> @fsub(<4 x float> %x, <4 x float> %y) {
; CHECK-LABEL: @fsub(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x float> [[Y:%.*]], <4 x float> [[X:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x float> [[X]], <4 x float> [[Y]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[R:%.*]] = fsub fast <4 x float> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %sel1 = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x float> %y, <4 x float> %x, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %r = fsub fast <4 x float> %sel1, %sel2
  ret <4 x float> %r
}

define <4 x double> @fmul(<4 x double> %x, <4 x double> %y) {
; CHECK-LABEL: @fmul(
; CHECK-NEXT:    [[R:%.*]] = fmul nnan <4 x double> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %sel1 = shufflevector <4 x double> %x, <4 x double> %y, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x double> %y, <4 x double> %x, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %r = fmul nnan <4 x double> %sel1, %sel2
  ret <4 x double> %r
}

define <4 x double> @fdiv(<4 x double> %x, <4 x double> %y) {
; CHECK-LABEL: @fdiv(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x double> [[Y:%.*]], <4 x double> [[X:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x double> [[X]], <4 x double> [[Y]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[R:%.*]] = fdiv nnan arcp <4 x double> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %sel1 = shufflevector <4 x double> %x, <4 x double> %y, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x double> %y, <4 x double> %x, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %r = fdiv arcp nnan <4 x double> %sel1, %sel2
  ret <4 x double> %r
}

define <4 x double> @frem(<4 x double> %x, <4 x double> %y) {
; CHECK-LABEL: @frem(
; CHECK-NEXT:    [[SEL1:%.*]] = shufflevector <4 x double> [[Y:%.*]], <4 x double> [[X:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[SEL2:%.*]] = shufflevector <4 x double> [[X]], <4 x double> [[Y]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    [[R:%.*]] = frem <4 x double> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %sel1 = shufflevector <4 x double> %x, <4 x double> %y, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %sel2 = shufflevector <4 x double> %y, <4 x double> %x, <4 x i32> <i32 4, i32 1, i32 6, i32 3>
  %r = frem <4 x double> %sel1, %sel2
  ret <4 x double> %r
}
