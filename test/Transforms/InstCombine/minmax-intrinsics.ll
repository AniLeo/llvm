; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

declare i8 @llvm.umin.i8(i8, i8)
declare i8 @llvm.umax.i8(i8, i8)
declare i8 @llvm.smin.i8(i8, i8)
declare i8 @llvm.smax.i8(i8, i8)
declare <3 x i8> @llvm.umin.v3i8(<3 x i8>, <3 x i8>)
declare <3 x i8> @llvm.umax.v3i8(<3 x i8>, <3 x i8>)
declare <3 x i8> @llvm.smin.v3i8(<3 x i8>, <3 x i8>)
declare <3 x i8> @llvm.smax.v3i8(<3 x i8>, <3 x i8>)
declare void @use(i8)

define i8 @umin_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_known_bits(
; CHECK-NEXT:    ret i8 0
;
  %x2 = and i8 %x, 127
  %m = call i8 @llvm.umin.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}

define i8 @umax_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @umax_known_bits(
; CHECK-NEXT:    ret i8 -128
;
  %x2 = or i8 %x, -128
  %m = call i8 @llvm.umax.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}

define i8 @smin_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @smin_known_bits(
; CHECK-NEXT:    ret i8 -128
;
  %x2 = or i8 %x, -128
  %m = call i8 @llvm.smin.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}

define i8 @smax_known_bits(i8 %x, i8 %y) {
; CHECK-LABEL: @smax_known_bits(
; CHECK-NEXT:    ret i8 0
;
  %x2 = and i8 %x, 127
  %m = call i8 @llvm.smax.i8(i8 %x2, i8 %y)
  %r = and i8 %m, -128
  ret i8 %r
}

define i8 @smax_sext(i5 %x, i5 %y) {
; CHECK-LABEL: @smax_sext(
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.smax.i5(i5 [[X:%.*]], i5 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = sext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %sx = sext i5 %x to i8
  %sy = sext i5 %y to i8
  %m = call i8 @llvm.smax.i8(i8 %sx, i8 %sy)
  ret i8 %m
}

; Extra use is ok.

define i8 @smin_sext(i5 %x, i5 %y) {
; CHECK-LABEL: @smin_sext(
; CHECK-NEXT:    [[SY:%.*]] = sext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[SY]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.smin.i5(i5 [[X:%.*]], i5 [[Y]])
; CHECK-NEXT:    [[M:%.*]] = sext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %sx = sext i5 %x to i8
  %sy = sext i5 %y to i8
  call void @use(i8 %sy)
  %m = call i8 @llvm.smin.i8(i8 %sx, i8 %sy)
  ret i8 %m
}

; Sext doesn't change unsigned min/max comparison of narrow values.

define i8 @umax_sext(i5 %x, i5 %y) {
; CHECK-LABEL: @umax_sext(
; CHECK-NEXT:    [[SX:%.*]] = sext i5 [[X:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[SX]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.umax.i5(i5 [[X]], i5 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = sext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %sx = sext i5 %x to i8
  call void @use(i8 %sx)
  %sy = sext i5 %y to i8
  %m = call i8 @llvm.umax.i8(i8 %sx, i8 %sy)
  ret i8 %m
}

define <3 x i8> @umin_sext(<3 x i5> %x, <3 x i5> %y) {
; CHECK-LABEL: @umin_sext(
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x i5> @llvm.umin.v3i5(<3 x i5> [[X:%.*]], <3 x i5> [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = sext <3 x i5> [[TMP1]] to <3 x i8>
; CHECK-NEXT:    ret <3 x i8> [[M]]
;
  %sx = sext <3 x i5> %x to <3 x i8>
  %sy = sext <3 x i5> %y to <3 x i8>
  %m = call <3 x i8> @llvm.umin.v3i8(<3 x i8> %sx, <3 x i8> %sy)
  ret <3 x i8> %m
}

; Negative test - zext may change sign of inputs

define i8 @smax_zext(i5 %x, i5 %y) {
; CHECK-LABEL: @smax_zext(
; CHECK-NEXT:    [[ZX:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[ZY:%.*]] = zext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smax.i8(i8 [[ZX]], i8 [[ZY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i5 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.smax.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

; Negative test - zext may change sign of inputs

define i8 @smin_zext(i5 %x, i5 %y) {
; CHECK-LABEL: @smin_zext(
; CHECK-NEXT:    [[ZX:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[ZY:%.*]] = zext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[ZX]], i8 [[ZY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i5 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.smin.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

define i8 @umax_zext(i5 %x, i5 %y) {
; CHECK-LABEL: @umax_zext(
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.umax.i5(i5 [[X:%.*]], i5 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = zext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i5 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.umax.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

define i8 @umin_zext(i5 %x, i5 %y) {
; CHECK-LABEL: @umin_zext(
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.umin.i5(i5 [[X:%.*]], i5 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = zext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i5 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.umin.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

; Negative test - mismatched types

define i8 @umin_zext_types(i6 %x, i5 %y) {
; CHECK-LABEL: @umin_zext_types(
; CHECK-NEXT:    [[ZX:%.*]] = zext i6 [[X:%.*]] to i8
; CHECK-NEXT:    [[ZY:%.*]] = zext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[ZX]], i8 [[ZY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i6 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.umin.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

; Negative test - mismatched extends

define i8 @umin_ext(i5 %x, i5 %y) {
; CHECK-LABEL: @umin_ext(
; CHECK-NEXT:    [[SX:%.*]] = sext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[ZY:%.*]] = zext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[SX]], i8 [[ZY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %sx = sext i5 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.umin.i8(i8 %sx, i8 %zy)
  ret i8 %m
}

; Negative test - too many uses.

define i8 @umin_zext_uses(i5 %x, i5 %y) {
; CHECK-LABEL: @umin_zext_uses(
; CHECK-NEXT:    [[ZX:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[ZX]])
; CHECK-NEXT:    [[ZY:%.*]] = zext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[ZY]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[ZX]], i8 [[ZY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i5 %x to i8
  call void @use(i8 %zx)
  %zy = zext i5 %y to i8
  call void @use(i8 %zy)
  %m = call i8 @llvm.umin.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

define i8 @smax_sext_constant(i5 %x) {
; CHECK-LABEL: @smax_sext_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.smax.i5(i5 [[X:%.*]], i5 7)
; CHECK-NEXT:    [[M:%.*]] = zext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = sext i5 %x to i8
  %m = call i8 @llvm.smax.i8(i8 %e, i8 7)
  ret i8 %m
}

; simplifies

define i8 @smax_sext_constant_big(i5 %x) {
; CHECK-LABEL: @smax_sext_constant_big(
; CHECK-NEXT:    ret i8 16
;
  %e = sext i5 %x to i8
  %m = call i8 @llvm.smax.i8(i8 %e, i8 16)
  ret i8 %m
}

; negative test

define i8 @smax_zext_constant(i5 %x) {
; CHECK-LABEL: @smax_zext_constant(
; CHECK-NEXT:    [[E:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smax.i8(i8 [[E]], i8 7)
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = zext i5 %x to i8
  %m = call i8 @llvm.smax.i8(i8 %e, i8 7)
  ret i8 %m
}

define <3 x i8> @smin_sext_constant(<3 x i5> %x) {
; CHECK-LABEL: @smin_sext_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x i5> @llvm.smin.v3i5(<3 x i5> [[X:%.*]], <3 x i5> <i5 7, i5 15, i5 -16>)
; CHECK-NEXT:    [[M:%.*]] = sext <3 x i5> [[TMP1]] to <3 x i8>
; CHECK-NEXT:    ret <3 x i8> [[M]]
;
  %e = sext <3 x i5> %x to <3 x i8>
  %m = call <3 x i8> @llvm.smin.v3i8(<3 x i8> %e, <3 x i8> <i8 7, i8 15, i8 -16>)
  ret <3 x i8> %m
}

; negative test

define i8 @smin_zext_constant(i5 %x) {
; CHECK-LABEL: @smin_zext_constant(
; CHECK-NEXT:    [[E:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[E]], i8 7)
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = zext i5 %x to i8
  %m = call i8 @llvm.smin.i8(i8 %e, i8 7)
  ret i8 %m
}

define i8 @umax_sext_constant(i5 %x) {
; CHECK-LABEL: @umax_sext_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.umax.i5(i5 [[X:%.*]], i5 7)
; CHECK-NEXT:    [[M:%.*]] = sext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = sext i5 %x to i8
  %m = call i8 @llvm.umax.i8(i8 %e, i8 7)
  ret i8 %m
}

; negative test

define i8 @umax_sext_constant_big(i5 %x) {
; CHECK-LABEL: @umax_sext_constant_big(
; CHECK-NEXT:    [[E:%.*]] = sext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umax.i8(i8 [[E]], i8 126)
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = sext i5 %x to i8
  %m = call i8 @llvm.umax.i8(i8 %e, i8 126)
  ret i8 %m
}

define <3 x i8> @umax_zext_constant(<3 x i5> %x) {
; CHECK-LABEL: @umax_zext_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x i5> @llvm.umax.v3i5(<3 x i5> [[X:%.*]], <3 x i5> <i5 7, i5 15, i5 -1>)
; CHECK-NEXT:    [[M:%.*]] = zext <3 x i5> [[TMP1]] to <3 x i8>
; CHECK-NEXT:    ret <3 x i8> [[M]]
;
  %e = zext <3 x i5> %x to <3 x i8>
  %m = call <3 x i8> @llvm.umax.v3i8(<3 x i8> %e, <3 x i8> <i8 7, i8 15, i8 31>)
  ret <3 x i8> %m
}

; simplifies

define i8 @umax_zext_constant_big(i5 %x) {
; CHECK-LABEL: @umax_zext_constant_big(
; CHECK-NEXT:    ret i8 126
;
  %e = zext i5 %x to i8
  %m = call i8 @llvm.umax.i8(i8 %e, i8 126)
  ret i8 %m
}

define i8 @umin_sext_constant(i5 %x) {
; CHECK-LABEL: @umin_sext_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.umin.i5(i5 [[X:%.*]], i5 7)
; CHECK-NEXT:    [[M:%.*]] = zext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = sext i5 %x to i8
  %m = call i8 @llvm.umin.i8(i8 %e, i8 7)
  ret i8 %m
}

; negative test

define i8 @umin_sext_constant_big(i5 %x) {
; CHECK-LABEL: @umin_sext_constant_big(
; CHECK-NEXT:    [[E:%.*]] = sext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[E]], i8 126)
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = sext i5 %x to i8
  %m = call i8 @llvm.umin.i8(i8 %e, i8 126)
  ret i8 %m
}

define i8 @umin_zext_constant(i5 %x) {
; CHECK-LABEL: @umin_zext_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = call i5 @llvm.umin.i5(i5 [[X:%.*]], i5 7)
; CHECK-NEXT:    [[M:%.*]] = zext i5 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = zext i5 %x to i8
  %m = call i8 @llvm.umin.i8(i8 %e, i8 7)
  ret i8 %m
}

; simplifies

define i8 @umin_zext_constant_big(i5 %x) {
; CHECK-LABEL: @umin_zext_constant_big(
; CHECK-NEXT:    [[E:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    ret i8 [[E]]
;
  %e = zext i5 %x to i8
  %m = call i8 @llvm.umin.i8(i8 %e, i8 126)
  ret i8 %m
}

; negative test

define i8 @umin_zext_constant_uses(i5 %x) {
; CHECK-LABEL: @umin_zext_constant_uses(
; CHECK-NEXT:    [[E:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[E]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[E]], i8 7)
; CHECK-NEXT:    ret i8 [[M]]
;
  %e = zext i5 %x to i8
  call void @use(i8 %e)
  %m = call i8 @llvm.umin.i8(i8 %e, i8 7)
  ret i8 %m
}

define i8 @smax_of_nots(i8 %x, i8 %y) {
; CHECK-LABEL: @smax_of_nots(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smin.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = xor i8 [[TMP1]], -1
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  %noty = xor i8 %y, -1
  %m = call i8 @llvm.smax.i8(i8 %notx, i8 %noty)
  ret i8 %m
}

; Vectors are ok (including undef lanes of not ops)

define <3 x i8> @smin_of_nots(<3 x i8> %x, <3 x i8> %y) {
; CHECK-LABEL: @smin_of_nots(
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x i8> @llvm.smax.v3i8(<3 x i8> [[X:%.*]], <3 x i8> [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = xor <3 x i8> [[TMP1]], <i8 -1, i8 -1, i8 -1>
; CHECK-NEXT:    ret <3 x i8> [[M]]
;
  %notx = xor <3 x i8> %x, <i8 -1, i8 undef, i8 -1>
  %noty = xor <3 x i8> %y, <i8 -1, i8 -1, i8 undef>
  %m = call <3 x i8> @llvm.smin.v3i8(<3 x i8> %notx, <3 x i8> %noty)
  ret <3 x i8> %m
}

; An extra use is ok.

define i8 @umax_of_nots(i8 %x, i8 %y) {
; CHECK-LABEL: @umax_of_nots(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umin.i8(i8 [[X]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = xor i8 [[TMP1]], -1
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %noty = xor i8 %y, -1
  %m = call i8 @llvm.umax.i8(i8 %notx, i8 %noty)
  ret i8 %m
}

; An extra use is ok.

define i8 @umin_of_nots(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_of_nots(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTY]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umax.i8(i8 [[X:%.*]], i8 [[Y]])
; CHECK-NEXT:    [[M:%.*]] = xor i8 [[TMP1]], -1
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  %noty = xor i8 %y, -1
  call void @use(i8 %noty)
  %m = call i8 @llvm.umin.i8(i8 %notx, i8 %noty)
  ret i8 %m
}

; Negative test - too many uses

define i8 @umin_of_nots_uses(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_of_nots_uses(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[NOTY:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTY]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[NOTX]], i8 [[NOTY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %noty = xor i8 %y, -1
  call void @use(i8 %noty)
  %m = call i8 @llvm.umin.i8(i8 %notx, i8 %noty)
  ret i8 %m
}

; Canonicalize 'not' after min/max.

define i8 @smax_of_not_and_const(i8 %x) {
; CHECK-LABEL: @smax_of_not_and_const(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smin.i8(i8 [[X:%.*]], i8 -43)
; CHECK-NEXT:    [[M:%.*]] = xor i8 [[TMP1]], -1
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  %m = call i8 @llvm.smax.i8(i8 %notx, i8 42)
  ret i8 %m
}

; Vectors are ok (including undef lanes of not ops and min/max constant operand)

define <3 x i8> @smin_of_not_and_const(<3 x i8> %x) {
; CHECK-LABEL: @smin_of_not_and_const(
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x i8> @llvm.smax.v3i8(<3 x i8> [[X:%.*]], <3 x i8> <i8 -43, i8 undef, i8 -44>)
; CHECK-NEXT:    [[M:%.*]] = xor <3 x i8> [[TMP1]], <i8 -1, i8 -1, i8 -1>
; CHECK-NEXT:    ret <3 x i8> [[M]]
;
  %notx = xor <3 x i8> %x, <i8 -1, i8 -1, i8 undef>
  %m = call <3 x i8> @llvm.smin.v3i8(<3 x i8> <i8 42, i8 undef, i8 43>, <3 x i8> %notx)
  ret <3 x i8> %m
}

define i8 @umax_of_not_and_const(i8 %x) {
; CHECK-LABEL: @umax_of_not_and_const(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umin.i8(i8 [[X:%.*]], i8 -45)
; CHECK-NEXT:    [[M:%.*]] = xor i8 [[TMP1]], -1
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  %m = call i8 @llvm.umax.i8(i8 %notx, i8 44)
  ret i8 %m
}

define i8 @umin_of_not_and_const(i8 %x) {
; CHECK-LABEL: @umin_of_not_and_const(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umax.i8(i8 [[X:%.*]], i8 44)
; CHECK-NEXT:    [[M:%.*]] = xor i8 [[TMP1]], -1
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  %m = call i8 @llvm.umin.i8(i8 -45, i8 %notx)
  ret i8 %m
}

; Negative test - too many uses

define i8 @umin_of_not_and_const_uses(i8 %x) {
; CHECK-LABEL: @umin_of_not_and_const_uses(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[NOTX]], i8 -45)
; CHECK-NEXT:    ret i8 [[M]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %m = call i8 @llvm.umin.i8(i8 -45, i8 %notx)
  ret i8 %m
}

define i8 @not_smax_of_nots(i8 %x, i8 %y) {
; CHECK-LABEL: @not_smax_of_nots(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[NOTY:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTY]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smin.i8(i8 [[X]], i8 [[Y]])
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %noty = xor i8 %y, -1
  call void @use(i8 %noty)
  %m = call i8 @llvm.smax.i8(i8 %notx, i8 %noty)
  %notm = xor i8 %m, -1
  ret i8 %notm
}

define i8 @not_smin_of_nots(i8 %x, i8 %y) {
; CHECK-LABEL: @not_smin_of_nots(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[NOTY:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTY]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[NOTX]], i8 [[NOTY]])
; CHECK-NEXT:    call void @use(i8 [[M]])
; CHECK-NEXT:    [[NOTM:%.*]] = xor i8 [[M]], -1
; CHECK-NEXT:    ret i8 [[NOTM]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %noty = xor i8 %y, -1
  call void @use(i8 %noty)
  %m = call i8 @llvm.smin.i8(i8 %notx, i8 %noty)
  call void @use(i8 %m)
  %notm = xor i8 %m, -1
  ret i8 %notm
}

define i8 @not_umax_of_not(i8 %x, i8 %y) {
; CHECK-LABEL: @not_umax_of_not(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.umin.i8(i8 [[X]], i8 [[TMP1]])
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %m = call i8 @llvm.umax.i8(i8 %notx, i8 %y)
  %notm = xor i8 %m, -1
  ret i8 %notm
}

; Negative test - this would require an extra instruction.

define i8 @not_umin_of_not(i8 %x, i8 %y) {
; CHECK-LABEL: @not_umin_of_not(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[NOTX]], i8 [[Y:%.*]])
; CHECK-NEXT:    call void @use(i8 [[M]])
; CHECK-NEXT:    [[NOTM:%.*]] = xor i8 [[M]], -1
; CHECK-NEXT:    ret i8 [[NOTM]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %m = call i8 @llvm.umin.i8(i8 %notx, i8 %y)
  call void @use(i8 %m)
  %notm = xor i8 %m, -1
  ret i8 %notm
}

define i8 @not_umin_of_not_constant_op(i8 %x) {
; CHECK-LABEL: @not_umin_of_not_constant_op(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @use(i8 [[NOTX]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umax.i8(i8 [[X]], i8 -43)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %notx = xor i8 %x, -1
  call void @use(i8 %notx)
  %m = call i8 @llvm.umin.i8(i8 %notx, i8 42)
  %notm = xor i8 %m, -1
  ret i8 %notm
}

define i8 @smax_negation(i8 %x, i8 %y) {
; CHECK-LABEL: @smax_negation(
; CHECK-NEXT:    [[S1:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[S1]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %s1 = sub i8 %x, %y
  %s2 = sub i8 %y, %x
  %r = call i8 @llvm.smax.i8(i8 %s1, i8 %s2)
  ret i8 %r
}

define i8 @smax_negation_nsw(i8 %x, i8 %y) {
; CHECK-LABEL: @smax_negation_nsw(
; CHECK-NEXT:    [[S1:%.*]] = sub nsw i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[S1]], i1 true)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %s1 = sub nsw i8 %x, %y
  %s2 = sub nsw i8 %y, %x
  %r = call i8 @llvm.smax.i8(i8 %s1, i8 %s2)
  ret i8 %r
}

define i8 @smax_negation_not_nsw(i8 %x, i8 %y) {
; CHECK-LABEL: @smax_negation_not_nsw(
; CHECK-NEXT:    [[S1:%.*]] = sub nsw i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[S1]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %s1 = sub nsw i8 %x, %y
  %s2 = sub nuw i8 %y, %x
  %r = call i8 @llvm.smax.i8(i8 %s1, i8 %s2)
  ret i8 %r
}

define <3 x i8> @smax_negation_vec(<3 x i8> %x) {
; CHECK-LABEL: @smax_negation_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x i8> @llvm.abs.v3i8(<3 x i8> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <3 x i8> [[TMP1]]
;
  %s = sub <3 x i8> <i8 0, i8 undef, i8 0>, %x
  %r = call <3 x i8> @llvm.smax.v3i8(<3 x i8> %x, <3 x i8> %s)
  ret <3 x i8> %r
}

define i8 @smin_negation(i8 %x, i8 %y) {
; CHECK-LABEL: @smin_negation(
; CHECK-NEXT:    [[S1:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[S1]], i1 false)
; CHECK-NEXT:    [[NABS:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[NABS]]
;
  %s1 = sub i8 %x, %y
  %s2 = sub i8 %y, %x
  %r = call i8 @llvm.smin.i8(i8 %s1, i8 %s2)
  ret i8 %r
}

define i8 @umax_negation(i8 %x, i8 %y) {
; CHECK-LABEL: @umax_negation(
; CHECK-NEXT:    [[S1:%.*]] = sub nsw i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[S1]], i1 true)
; CHECK-NEXT:    [[NABS:%.*]] = sub nsw i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[NABS]]
;
  %s1 = sub nsw i8 %x, %y
  %s2 = sub nsw i8 %y, %x
  %r = call i8 @llvm.umax.i8(i8 %s1, i8 %s2)
  ret i8 %r
}

define i8 @umin_negation(i8 %x) {
; CHECK-LABEL: @umin_negation(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %s = sub nsw i8 0, %x
  %r = call i8 @llvm.umin.i8(i8 %s, i8 %x)
  ret i8 %r
}

define i8 @smax_negation_uses(i8 %x, i8 %y) {
; CHECK-LABEL: @smax_negation_uses(
; CHECK-NEXT:    [[S2:%.*]] = sub i8 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    call void @use(i8 [[S2]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[S2]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %s1 = sub i8 %x, %y
  %s2 = sub i8 %y, %x
  call void @use(i8 %s2)
  %r = call i8 @llvm.smax.i8(i8 %s1, i8 %s2)
  ret i8 %r
}

define i8 @clamp_two_vals_smax_smin(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_smax_smin(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i8 [[X:%.*]], 43
; CHECK-NEXT:    [[R:%.*]] = select i1 [[TMP1]], i8 42, i8 43
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.smax.i8(i8 %x, i8 42)
  %r = call i8 @llvm.smin.i8(i8 %m, i8 43)
  ret i8 %r
}

define <3 x i8> @clamp_two_vals_smin_smax(<3 x i8> %x) {
; CHECK-LABEL: @clamp_two_vals_smin_smax(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <3 x i8> [[X:%.*]], <i8 41, i8 41, i8 41>
; CHECK-NEXT:    [[R:%.*]] = select <3 x i1> [[TMP1]], <3 x i8> <i8 42, i8 42, i8 42>, <3 x i8> <i8 41, i8 41, i8 41>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %m = call <3 x i8> @llvm.smin.v3i8(<3 x i8> %x, <3 x i8> <i8 42, i8 42, i8 42>)
  %r = call <3 x i8> @llvm.smax.v3i8(<3 x i8> %m, <3 x i8> <i8 41, i8 41, i8 41>)
  ret <3 x i8> %r
}

define i8 @clamp_two_vals_umax_umin(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_umax_umin(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i8 [[X:%.*]], 43
; CHECK-NEXT:    [[R:%.*]] = select i1 [[TMP1]], i8 42, i8 43
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.umax.i8(i8 %x, i8 42)
  %r = call i8 @llvm.umin.i8(i8 %m, i8 43)
  ret i8 %r
}

define i8 @clamp_two_vals_umin_umax(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_umin_umax(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[X:%.*]], 41
; CHECK-NEXT:    [[R:%.*]] = select i1 [[TMP1]], i8 42, i8 41
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.umin.i8(i8 %x, i8 42)
  %r = call i8 @llvm.umax.i8(i8 %m, i8 41)
  ret i8 %r
}

; Negative test - mismatched signs

define i8 @clamp_two_vals_smax_umin(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_smax_umin(
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smax.i8(i8 [[X:%.*]], i8 42)
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.umin.i8(i8 [[M]], i8 43)
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.smax.i8(i8 %x, i8 42)
  %r = call i8 @llvm.umin.i8(i8 %m, i8 43)
  ret i8 %r
}

; Negative test - wrong range

define i8 @clamp_three_vals_smax_smin(i8 %x) {
; CHECK-LABEL: @clamp_three_vals_smax_smin(
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smax.i8(i8 [[X:%.*]], i8 42)
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.smin.i8(i8 [[M]], i8 44)
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.smax.i8(i8 %x, i8 42)
  %r = call i8 @llvm.smin.i8(i8 %m, i8 44)
  ret i8 %r
}

; Edge cases are simplified

define i8 @clamp_two_vals_umax_umin_edge(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_umax_umin_edge(
; CHECK-NEXT:    ret i8 0
;
  %m = call i8 @llvm.umax.i8(i8 %x, i8 255)
  %r = call i8 @llvm.umin.i8(i8 %m, i8 0)
  ret i8 %r
}

; Edge cases are simplified

define i8 @clamp_two_vals_umin_umax_edge(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_umin_umax_edge(
; CHECK-NEXT:    ret i8 -1
;
  %m = call i8 @llvm.umin.i8(i8 %x, i8 0)
  %r = call i8 @llvm.umax.i8(i8 %m, i8 255)
  ret i8 %r
}

; Edge cases are simplified

define i8 @clamp_two_vals_smax_smin_edge(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_smax_smin_edge(
; CHECK-NEXT:    ret i8 -128
;
  %m = call i8 @llvm.smax.i8(i8 %x, i8 127)
  %r = call i8 @llvm.smin.i8(i8 %m, i8 128)
  ret i8 %r
}

; Edge cases are simplified

define i8 @clamp_two_vals_smin_smax_edge(i8 %x) {
; CHECK-LABEL: @clamp_two_vals_smin_smax_edge(
; CHECK-NEXT:    ret i8 127
;
  %m = call i8 @llvm.smin.i8(i8 %x, i8 128)
  %r = call i8 @llvm.smax.i8(i8 %m, i8 127)
  ret i8 %r
}


define i8 @umin_non_zero_idiom1(i8 %a) {
; CHECK-LABEL: @umin_non_zero_idiom1(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8 [[A:%.*]], 0
; CHECK-NEXT:    [[RES:%.*]] = zext i1 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[RES]]
;
  %res = call i8 @llvm.umin.i8(i8 %a, i8 1)
  ret i8 %res
}

define i8 @umin_non_zero_idiom2(i8 %a) {
; CHECK-LABEL: @umin_non_zero_idiom2(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8 [[A:%.*]], 0
; CHECK-NEXT:    [[RES:%.*]] = zext i1 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[RES]]
;
  %res = call i8 @llvm.umin.i8(i8 1, i8 %a)
  ret i8 %res
}

define <3 x i8> @umin_non_zero_idiom3(<3 x i8> %a) {
; CHECK-LABEL: @umin_non_zero_idiom3(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne <3 x i8> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    [[RES:%.*]] = zext <3 x i1> [[TMP1]] to <3 x i8>
; CHECK-NEXT:    ret <3 x i8> [[RES]]
;
  %res = call <3 x i8> @llvm.umin.v3i8(<3 x i8> %a, <3 x i8> <i8 1, i8 1, i8 1>)
  ret <3 x i8> %res
}

define <3 x i8> @umin_non_zero_idiom4(<3 x i8> %a) {
; CHECK-LABEL: @umin_non_zero_idiom4(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne <3 x i8> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    [[RES:%.*]] = zext <3 x i1> [[TMP1]] to <3 x i8>
; CHECK-NEXT:    ret <3 x i8> [[RES]]
;
  %res = call <3 x i8> @llvm.umin.v3i8(<3 x i8> %a, <3 x i8> <i8 1, i8 undef, i8 undef>)
  ret <3 x i8> %res
}

define i1 @umin_eq_zero(i8 %a, i8 %b) {
; CHECK-LABEL: @umin_eq_zero(
; CHECK-NEXT:    [[UMIN:%.*]] = call i8 @llvm.umin.i8(i8 [[A:%.*]], i8 [[B:%.*]])
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i8 [[UMIN]], 0
; CHECK-NEXT:    ret i1 [[RES]]
;
  %umin = call i8 @llvm.umin.i8(i8 %a, i8 %b)
  %res = icmp eq i8 %umin, 0
  ret i1 %res
}

define <3 x i1> @umin_eq_zero2(<3 x i8> %a, <3 x i8> %b) {
; CHECK-LABEL: @umin_eq_zero2(
; CHECK-NEXT:    [[UMIN:%.*]] = call <3 x i8> @llvm.umin.v3i8(<3 x i8> [[A:%.*]], <3 x i8> [[B:%.*]])
; CHECK-NEXT:    [[RES:%.*]] = icmp eq <3 x i8> [[UMIN]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[RES]]
;

  %umin = call <3 x i8> @llvm.umin.v3i8(<3 x i8> %a, <3 x i8> %b)
  %res = icmp eq <3 x i8> %umin, zeroinitializer
  ret <3 x i1> %res
}

define i1 @umin_ne_zero(i8 %a, i8 %b) {
; CHECK-LABEL: @umin_ne_zero(
; CHECK-NEXT:    [[UMIN:%.*]] = call i8 @llvm.umin.i8(i8 [[A:%.*]], i8 [[B:%.*]])
; CHECK-NEXT:    [[RES:%.*]] = icmp ne i8 [[UMIN]], 0
; CHECK-NEXT:    ret i1 [[RES]]
;
  %umin = call i8 @llvm.umin.i8(i8 %a, i8 %b)
  %res = icmp ne i8 %umin, 0
  ret i1 %res
}

define <3 x i1> @umin_ne_zero2(<3 x i8> %a, <3 x i8> %b) {
; CHECK-LABEL: @umin_ne_zero2(
; CHECK-NEXT:    [[UMIN:%.*]] = call <3 x i8> @llvm.umin.v3i8(<3 x i8> [[A:%.*]], <3 x i8> [[B:%.*]])
; CHECK-NEXT:    [[RES:%.*]] = icmp ne <3 x i8> [[UMIN]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[RES]]
;

  %umin = call <3 x i8> @llvm.umin.v3i8(<3 x i8> %a, <3 x i8> %b)
  %res = icmp ne <3 x i8> %umin, zeroinitializer
  ret <3 x i1> %res
}

define i8 @smax(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @smax(
; CHECK-NEXT:    [[M2:%.*]] = call i8 @llvm.smax.i8(i8 [[X:%.*]], i8 [[Z:%.*]])
; CHECK-NEXT:    [[M3:%.*]] = call i8 @llvm.smax.i8(i8 [[M2]], i8 [[Y:%.*]])
; CHECK-NEXT:    ret i8 [[M3]]
;
  %m1 = call i8 @llvm.smax.i8(i8 %x, i8 %y)
  %m2 = call i8 @llvm.smax.i8(i8 %x, i8 %z)
  %m3 = call i8 @llvm.smax.i8(i8 %m1, i8 %m2)
  ret i8 %m3
}

define <3 x i8> @smin(<3 x i8> %x, <3 x i8> %y, <3 x i8> %z) {
; CHECK-LABEL: @smin(
; CHECK-NEXT:    [[M2:%.*]] = call <3 x i8> @llvm.smin.v3i8(<3 x i8> [[X:%.*]], <3 x i8> [[Z:%.*]])
; CHECK-NEXT:    [[M3:%.*]] = call <3 x i8> @llvm.smin.v3i8(<3 x i8> [[M2]], <3 x i8> [[Y:%.*]])
; CHECK-NEXT:    ret <3 x i8> [[M3]]
;
  %m1 = call <3 x i8> @llvm.smin.v3i8(<3 x i8> %y, <3 x i8> %x)
  %m2 = call <3 x i8> @llvm.smin.v3i8(<3 x i8> %x, <3 x i8> %z)
  %m3 = call <3 x i8> @llvm.smin.v3i8(<3 x i8> %m1, <3 x i8> %m2)
  ret <3 x i8> %m3
}

define i8 @umax(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @umax(
; CHECK-NEXT:    [[M1:%.*]] = call i8 @llvm.umax.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    call void @use(i8 [[M1]])
; CHECK-NEXT:    [[M3:%.*]] = call i8 @llvm.umax.i8(i8 [[M1]], i8 [[Z:%.*]])
; CHECK-NEXT:    ret i8 [[M3]]
;
  %m1 = call i8 @llvm.umax.i8(i8 %x, i8 %y)
  call void @use(i8 %m1)
  %m2 = call i8 @llvm.umax.i8(i8 %z, i8 %x)
  %m3 = call i8 @llvm.umax.i8(i8 %m1, i8 %m2)
  ret i8 %m3
}

define i8 @umin(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @umin(
; CHECK-NEXT:    [[M2:%.*]] = call i8 @llvm.umin.i8(i8 [[Z:%.*]], i8 [[X:%.*]])
; CHECK-NEXT:    call void @use(i8 [[M2]])
; CHECK-NEXT:    [[M3:%.*]] = call i8 @llvm.umin.i8(i8 [[M2]], i8 [[Y:%.*]])
; CHECK-NEXT:    ret i8 [[M3]]
;
  %m1 = call i8 @llvm.umin.i8(i8 %y, i8 %x)
  %m2 = call i8 @llvm.umin.i8(i8 %z, i8 %x)
  call void @use(i8 %m2)
  %m3 = call i8 @llvm.umin.i8(i8 %m1, i8 %m2)
  ret i8 %m3
}

; negative test - too many uses

define i8 @smax_uses(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @smax_uses(
; CHECK-NEXT:    [[M1:%.*]] = call i8 @llvm.smax.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    call void @use(i8 [[M1]])
; CHECK-NEXT:    [[M2:%.*]] = call i8 @llvm.smax.i8(i8 [[X]], i8 [[Z:%.*]])
; CHECK-NEXT:    call void @use(i8 [[M2]])
; CHECK-NEXT:    [[M3:%.*]] = call i8 @llvm.smax.i8(i8 [[M1]], i8 [[M2]])
; CHECK-NEXT:    ret i8 [[M3]]
;
  %m1 = call i8 @llvm.smax.i8(i8 %x, i8 %y)
  call void @use(i8 %m1)
  %m2 = call i8 @llvm.smax.i8(i8 %x, i8 %z)
  call void @use(i8 %m2)
  %m3 = call i8 @llvm.smax.i8(i8 %m1, i8 %m2)
  ret i8 %m3
}

; negative test - must have common operand

define i8 @smax_no_common_op(i8 %x, i8 %y, i8 %z, i8 %w) {
; CHECK-LABEL: @smax_no_common_op(
; CHECK-NEXT:    [[M1:%.*]] = call i8 @llvm.smax.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[M2:%.*]] = call i8 @llvm.smax.i8(i8 [[W:%.*]], i8 [[Z:%.*]])
; CHECK-NEXT:    [[M3:%.*]] = call i8 @llvm.smax.i8(i8 [[M1]], i8 [[M2]])
; CHECK-NEXT:    ret i8 [[M3]]
;
  %m1 = call i8 @llvm.smax.i8(i8 %x, i8 %y)
  %m2 = call i8 @llvm.smax.i8(i8 %w, i8 %z)
  %m3 = call i8 @llvm.smax.i8(i8 %m1, i8 %m2)
  ret i8 %m3
}

define i8 @umax_demand_lshr(i8 %x) {
; CHECK-LABEL: @umax_demand_lshr(
; CHECK-NEXT:    [[R:%.*]] = lshr i8 [[X:%.*]], 4
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.umax.i8(i8 %x, i8 15)
  %r = lshr i8 %m, 4
  ret i8 %r
}

define i8 @umax_demand_and(i8 %x) {
; CHECK-LABEL: @umax_demand_and(
; CHECK-NEXT:    [[R:%.*]] = and i8 [[X:%.*]], 10
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.umax.i8(i8 1, i8 %x)
  %r = and i8 %m, 10
  ret i8 %r
}

define i8 @umin_demand_or_31_30(i8 %x) {
; CHECK-LABEL: @umin_demand_or_31_30(
; CHECK-NEXT:    [[R:%.*]] = or i8 [[X:%.*]], 31
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.umin.i8(i8 -30, i8 %x)
  %r = or i8 %m, 31
  ret i8 %r
}

define i8 @umin_demand_and_7_8(i8 %x) {
; CHECK-LABEL: @umin_demand_and_7_8(
; CHECK-NEXT:    [[R:%.*]] = and i8 [[X:%.*]], -8
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = call i8 @llvm.umin.i8(i8 %x, i8 -7)
  %r = and i8 %m, -8
  ret i8 %r
}

define i8 @neg_neg_nsw_smax(i8 %x, i8 %y) {
; CHECK-LABEL: @neg_neg_nsw_smax(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smin.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = sub nsw i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[M]]
;
  %nx = sub nsw i8 0, %x
  %ny = sub nsw i8 0, %y
  %m = call i8 @llvm.smax.i8(i8 %nx, i8 %ny)
  ret i8 %m
}

define <3 x i8> @neg_neg_nsw_smin(<3 x i8> %x, <3 x i8> %y) {
; CHECK-LABEL: @neg_neg_nsw_smin(
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x i8> @llvm.smax.v3i8(<3 x i8> [[X:%.*]], <3 x i8> [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = sub nsw <3 x i8> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <3 x i8> [[M]]
;
  %nx = sub nsw <3 x i8> zeroinitializer, %x
  %ny = sub nsw <3 x i8> zeroinitializer, %y
  %m = call <3 x i8> @llvm.smin.v3i8(<3 x i8> %nx, <3 x i8> %ny)
  ret <3 x i8> %m
}

define i8 @neg_neg_nsw_smax_use0(i8 %x, i8 %y) {
; CHECK-LABEL: @neg_neg_nsw_smax_use0(
; CHECK-NEXT:    [[NX:%.*]] = sub nsw i8 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i8 [[NX]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smin.i8(i8 [[X]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[M:%.*]] = sub nsw i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[M]]
;
  %nx = sub nsw i8 0, %x
  call void @use(i8 %nx)
  %ny = sub nsw i8 0, %y
  %m = call i8 @llvm.smax.i8(i8 %nx, i8 %ny)
  ret i8 %m
}

define i8 @neg_neg_nsw_smin_use1(i8 %x, i8 %y) {
; CHECK-LABEL: @neg_neg_nsw_smin_use1(
; CHECK-NEXT:    [[NY:%.*]] = sub nsw i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use(i8 [[NY]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smax.i8(i8 [[X:%.*]], i8 [[Y]])
; CHECK-NEXT:    [[M:%.*]] = sub nsw i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[M]]
;
  %nx = sub nsw i8 0, %x
  %ny = sub nsw i8 0, %y
  call void @use(i8 %ny)
  %m = call i8 @llvm.smin.i8(i8 %nx, i8 %ny)
  ret i8 %m
}

; negative test - too many uses

define i8 @neg_neg_nsw_smin_use2(i8 %x, i8 %y) {
; CHECK-LABEL: @neg_neg_nsw_smin_use2(
; CHECK-NEXT:    [[NX:%.*]] = sub nsw i8 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i8 [[NX]])
; CHECK-NEXT:    [[NY:%.*]] = sub nsw i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use(i8 [[NY]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[NX]], i8 [[NY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %nx = sub nsw i8 0, %x
  call void @use(i8 %nx)
  %ny = sub nsw i8 0, %y
  call void @use(i8 %ny)
  %m = call i8 @llvm.smin.i8(i8 %nx, i8 %ny)
  ret i8 %m
}

; negative test - need nsw on both ops

define i8 @neg_neg_smax(i8 %x, i8 %y) {
; CHECK-LABEL: @neg_neg_smax(
; CHECK-NEXT:    [[NX:%.*]] = sub i8 0, [[X:%.*]]
; CHECK-NEXT:    [[NY:%.*]] = sub nsw i8 0, [[Y:%.*]]
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smax.i8(i8 [[NX]], i8 [[NY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %nx = sub i8 0, %x
  %ny = sub nsw i8 0, %y
  %m = call i8 @llvm.smax.i8(i8 %nx, i8 %ny)
  ret i8 %m
}

; negative test - need nsw on both ops

define i8 @neg_neg_smin(i8 %x, i8 %y) {
; CHECK-LABEL: @neg_neg_smin(
; CHECK-NEXT:    [[NX:%.*]] = sub i8 0, [[X:%.*]]
; CHECK-NEXT:    [[NY:%.*]] = sub nsw i8 0, [[Y:%.*]]
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[NX]], i8 [[NY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %nx = sub i8 0, %x
  %ny = sub nsw i8 0, %y
  %m = call i8 @llvm.smin.i8(i8 %nx, i8 %ny)
  ret i8 %m
}

; negative test - need signed min/max

define i8 @neg_neg_nsw_umin(i8 %x, i8 %y) {
; CHECK-LABEL: @neg_neg_nsw_umin(
; CHECK-NEXT:    [[NX:%.*]] = sub nsw i8 0, [[X:%.*]]
; CHECK-NEXT:    [[NY:%.*]] = sub nsw i8 0, [[Y:%.*]]
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[NX]], i8 [[NY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %nx = sub nsw i8 0, %x
  %ny = sub nsw i8 0, %y
  %m = call i8 @llvm.umin.i8(i8 %nx, i8 %ny)
  ret i8 %m
}

declare void @use4(i8, i8, i8, i8)

define void @cmyk(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk(
; CHECK-NEXT:    [[NOTR:%.*]] = xor i8 [[R:%.*]], -1
; CHECK-NEXT:    [[NOTG:%.*]] = xor i8 [[G:%.*]], -1
; CHECK-NEXT:    [[NOTB:%.*]] = xor i8 [[B:%.*]], -1
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[NOTR]], i8 [[NOTG]])
; CHECK-NEXT:    [[K:%.*]] = call i8 @llvm.smin.i8(i8 [[M]], i8 [[NOTB]])
; CHECK-NEXT:    [[CK:%.*]] = sub i8 [[NOTR]], [[K]]
; CHECK-NEXT:    [[MK:%.*]] = sub i8 [[NOTG]], [[K]]
; CHECK-NEXT:    [[YK:%.*]] = sub i8 [[NOTB]], [[K]]
; CHECK-NEXT:    call void @use4(i8 [[CK]], i8 [[MK]], i8 [[YK]], i8 [[K]])
; CHECK-NEXT:    ret void
;
  %notr = xor i8 %r, -1
  %notg = xor i8 %g, -1
  %notb = xor i8 %b, -1
  %m = call i8 @llvm.smin.i8(i8 %notr, i8 %notg)
  %k = call i8 @llvm.smin.i8(i8 %m, i8 %notb)
  %ck = sub i8 %notr, %k
  %mk = sub i8 %notg, %k
  %yk = sub i8 %notb, %k
  call void @use4(i8 %ck, i8 %mk, i8 %yk, i8 %k)
  ret void
}
