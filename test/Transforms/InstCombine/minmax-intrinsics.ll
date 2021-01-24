; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

declare i8 @llvm.umin.i8(i8, i8)
declare i8 @llvm.umax.i8(i8, i8)
declare i8 @llvm.smin.i8(i8, i8)
declare i8 @llvm.smax.i8(i8, i8)
declare <3 x i8> @llvm.umin.v3i8(<3 x i8>, <3 x i8>)
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
; CHECK-NEXT:    [[SX:%.*]] = sext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[SY:%.*]] = sext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smax.i8(i8 [[SX]], i8 [[SY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %sx = sext i5 %x to i8
  %sy = sext i5 %y to i8
  %m = call i8 @llvm.smax.i8(i8 %sx, i8 %sy)
  ret i8 %m
}

define i8 @smin_sext(i5 %x, i5 %y) {
; CHECK-LABEL: @smin_sext(
; CHECK-NEXT:    [[SX:%.*]] = sext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[SY:%.*]] = sext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[SY]])
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.smin.i8(i8 [[SX]], i8 [[SY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %sx = sext i5 %x to i8
  %sy = sext i5 %y to i8
  call void @use(i8 %sy)
  %m = call i8 @llvm.smin.i8(i8 %sx, i8 %sy)
  ret i8 %m
}

define i8 @umax_sext(i5 %x, i5 %y) {
; CHECK-LABEL: @umax_sext(
; CHECK-NEXT:    [[SX:%.*]] = sext i5 [[X:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[SX]])
; CHECK-NEXT:    [[SY:%.*]] = sext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umax.i8(i8 [[SX]], i8 [[SY]])
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
; CHECK-NEXT:    [[SX:%.*]] = sext <3 x i5> [[X:%.*]] to <3 x i8>
; CHECK-NEXT:    [[SY:%.*]] = sext <3 x i5> [[Y:%.*]] to <3 x i8>
; CHECK-NEXT:    [[M:%.*]] = call <3 x i8> @llvm.umin.v3i8(<3 x i8> [[SX]], <3 x i8> [[SY]])
; CHECK-NEXT:    ret <3 x i8> [[M]]
;
  %sx = sext <3 x i5> %x to <3 x i8>
  %sy = sext <3 x i5> %y to <3 x i8>
  %m = call <3 x i8> @llvm.umin.v3i8(<3 x i8> %sx, <3 x i8> %sy)
  ret <3 x i8> %m
}

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
; CHECK-NEXT:    [[ZX:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[ZY:%.*]] = zext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umax.i8(i8 [[ZX]], i8 [[ZY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i5 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.umax.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

define i8 @umin_zext(i5 %x, i5 %y) {
; CHECK-LABEL: @umin_zext(
; CHECK-NEXT:    [[ZX:%.*]] = zext i5 [[X:%.*]] to i8
; CHECK-NEXT:    [[ZY:%.*]] = zext i5 [[Y:%.*]] to i8
; CHECK-NEXT:    [[M:%.*]] = call i8 @llvm.umin.i8(i8 [[ZX]], i8 [[ZY]])
; CHECK-NEXT:    ret i8 [[M]]
;
  %zx = zext i5 %x to i8
  %zy = zext i5 %y to i8
  %m = call i8 @llvm.umin.i8(i8 %zx, i8 %zy)
  ret i8 %m
}

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
