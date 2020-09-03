; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

define i35 @smax(i35 %x) {
; CHECK-LABEL: @smax(
; CHECK-NEXT:    [[R:%.*]] = call i35 @llvm.smax.i35(i35 [[X:%.*]], i35 42)
; CHECK-NEXT:    ret i35 [[R]]
;
  %r = call i35 @llvm.smax.i35(i35 42, i35 %x)
  ret i35 %r
}

define i5 @smin(i5 %x) {
; CHECK-LABEL: @smin(
; CHECK-NEXT:    [[R:%.*]] = call i5 @llvm.smin.i5(i5 [[X:%.*]], i5 10)
; CHECK-NEXT:    ret i5 [[R]]
;
  %r = call i5 @llvm.smin.i5(i5 42, i5 %x)
  ret i5 %r
}

define <2 x i35> @umax(<2 x i35> %x) {
; CHECK-LABEL: @umax(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i35> @llvm.umax.v2i35(<2 x i35> [[X:%.*]], <2 x i35> <i35 42, i35 43>)
; CHECK-NEXT:    ret <2 x i35> [[R]]
;
  %r = call <2 x i35> @llvm.umax.v2i35(<2 x i35> <i35 42, i35 43>, <2 x i35> %x)
  ret <2 x i35> %r
}

define <3 x i35> @umin(<3 x i35> %x) {
; CHECK-LABEL: @umin(
; CHECK-NEXT:    [[R:%.*]] = call <3 x i35> @llvm.umin.v3i35(<3 x i35> [[X:%.*]], <3 x i35> <i35 undef, i35 42, i35 43>)
; CHECK-NEXT:    ret <3 x i35> [[R]]
;
  %r = call <3 x i35> @llvm.umin.v3i35(<3 x i35> <i35 undef, i35 42, i35 43>, <3 x i35> %x)
  ret <3 x i35> %r
}

define i35 @smul_fix(i35 %x) {
; CHECK-LABEL: @smul_fix(
; CHECK-NEXT:    [[R:%.*]] = call i35 @llvm.smul.fix.i35(i35 [[X:%.*]], i35 42, i32 2)
; CHECK-NEXT:    ret i35 [[R]]
;
  %r = call i35 @llvm.smul.fix.i35(i35 42, i35 %x, i32 2)
  ret i35 %r
}

define i5 @umul_fix(i5 %x) {
; CHECK-LABEL: @umul_fix(
; CHECK-NEXT:    [[R:%.*]] = call i5 @llvm.umul.fix.i5(i5 [[X:%.*]], i5 10, i32 3)
; CHECK-NEXT:    ret i5 [[R]]
;
  %r = call i5 @llvm.umul.fix.i5(i5 42, i5 %x, i32 3)
  ret i5 %r
}

define <2 x i35> @smul_fix_sat(<2 x i35> %x) {
; CHECK-LABEL: @smul_fix_sat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i35> @llvm.smul.fix.sat.v2i35(<2 x i35> [[X:%.*]], <2 x i35> <i35 42, i35 43>, i32 4)
; CHECK-NEXT:    ret <2 x i35> [[R]]
;
  %r = call <2 x i35> @llvm.smul.fix.sat.v2i35(<2 x i35> <i35 42, i35 43>, <2 x i35> %x, i32 4)
  ret <2 x i35> %r
}

define <3 x i35> @umul_fix_sat(<3 x i35> %x) {
; CHECK-LABEL: @umul_fix_sat(
; CHECK-NEXT:    [[R:%.*]] = call <3 x i35> @llvm.umul.fix.sat.v3i35(<3 x i35> [[X:%.*]], <3 x i35> <i35 undef, i35 42, i35 43>, i32 5)
; CHECK-NEXT:    ret <3 x i35> [[R]]
;
  %r = call <3 x i35> @llvm.umul.fix.sat.v3i35(<3 x i35> <i35 undef, i35 42, i35 43>, <3 x i35> %x, i32 5)
  ret <3 x i35> %r
}

declare i35 @llvm.smax.i35(i35, i35)
declare i5 @llvm.smin.i5(i5, i5)
declare <2 x i35> @llvm.umax.v2i35(<2 x i35>, <2 x i35>)
declare <3 x i35> @llvm.umin.v3i35(<3 x i35>, <3 x i35>)
declare i35 @llvm.smul.fix.i35(i35, i35, i32)
declare i5 @llvm.umul.fix.i5(i5, i5, i32)
declare <2 x i35> @llvm.smul.fix.sat.v2i35(<2 x i35>, <2 x i35>, i32)
declare <3 x i35> @llvm.umul.fix.sat.v3i35(<3 x i35>, <3 x i35>, i32)
