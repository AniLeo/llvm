; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-n8:16:32:64"

declare i32 @llvm.cttz.i32(i32, i1) nounwind readnone
declare i32 @llvm.ctlz.i32(i32, i1) nounwind readnone
declare i32 @llvm.ctpop.i32(i32) nounwind readnone
declare <2 x i8> @llvm.cttz.v2i8(<2 x i8>, i1) nounwind readnone
declare <2 x i8> @llvm.ctlz.v2i8(<2 x i8>, i1) nounwind readnone
declare <2 x i8> @llvm.ctpop.v2i8(<2 x i8>) nounwind readnone

define i32 @lshr_ctlz_zero_is_not_undef(i32 %x) {
; CHECK-LABEL: @lshr_ctlz_zero_is_not_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[SH:%.*]] = zext i1 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SH]]
;
  %ct = call i32 @llvm.ctlz.i32(i32 %x, i1 false)
  %sh = lshr i32 %ct, 5
  ret i32 %sh
}

define i32 @lshr_cttz_zero_is_not_undef(i32 %x) {
; CHECK-LABEL: @lshr_cttz_zero_is_not_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[SH:%.*]] = zext i1 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SH]]
;
  %ct = call i32 @llvm.cttz.i32(i32 %x, i1 false)
  %sh = lshr i32 %ct, 5
  ret i32 %sh
}

define i32 @lshr_ctpop(i32 %x) {
; CHECK-LABEL: @lshr_ctpop(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[X:%.*]], -1
; CHECK-NEXT:    [[SH:%.*]] = zext i1 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[SH]]
;
  %ct = call i32 @llvm.ctpop.i32(i32 %x)
  %sh = lshr i32 %ct, 5
  ret i32 %sh
}

define <2 x i8> @lshr_ctlz_zero_is_not_undef_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_ctlz_zero_is_not_undef_splat_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[SH:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[SH]]
;
  %ct = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> %x, i1 false)
  %sh = lshr <2 x i8> %ct, <i8 3, i8 3>
  ret <2 x i8> %sh
}

define <2 x i8> @lshr_cttz_zero_is_not_undef_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_cttz_zero_is_not_undef_splat_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[SH:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[SH]]
;
  %ct = call <2 x i8> @llvm.cttz.v2i8(<2 x i8> %x, i1 false)
  %sh = lshr <2 x i8> %ct, <i8 3, i8 3>
  ret <2 x i8> %sh
}

define <2 x i8> @lshr_ctpop_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_ctpop_splat_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X:%.*]], <i8 -1, i8 -1>
; CHECK-NEXT:    [[SH:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[SH]]
;
  %ct = call <2 x i8> @llvm.ctpop.v2i8(<2 x i8> %x)
  %sh = lshr <2 x i8> %ct, <i8 3, i8 3>
  ret <2 x i8> %sh
}

define i32 @lshr_ctlz_zero_is_undef(i32 %x) {
; CHECK-LABEL: @lshr_ctlz_zero_is_undef(
; CHECK-NEXT:    ret i32 0
;
  %ct = call i32 @llvm.ctlz.i32(i32 %x, i1 true)
  %sh = lshr i32 %ct, 5
  ret i32 %sh
}

define i32 @lshr_cttz_zero_is_undef(i32 %x) {
; CHECK-LABEL: @lshr_cttz_zero_is_undef(
; CHECK-NEXT:    ret i32 0
;
  %ct = call i32 @llvm.cttz.i32(i32 %x, i1 true)
  %sh = lshr i32 %ct, 5
  ret i32 %sh
}

define <2 x i8> @lshr_ctlz_zero_is_undef_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_ctlz_zero_is_undef_splat_vec(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %ct = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> %x, i1 true)
  %sh = lshr <2 x i8> %ct, <i8 3, i8 3>
  ret <2 x i8> %sh
}

define i8 @lshr_ctlz_zero_is_undef_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_ctlz_zero_is_undef_vec(
; CHECK-NEXT:    ret i8 0
;
  %ct = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> %x, i1 true)
  %sh = lshr <2 x i8> %ct, <i8 3, i8 0>
  %ex = extractelement <2 x i8> %sh, i32 0
  ret i8 %ex
}

define <2 x i8> @lshr_cttz_zero_is_undef_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_cttz_zero_is_undef_splat_vec(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %ct = call <2 x i8> @llvm.cttz.v2i8(<2 x i8> %x, i1 true)
  %sh = lshr <2 x i8> %ct, <i8 3, i8 3>
  ret <2 x i8> %sh
}

define i8 @lshr_cttz_zero_is_undef_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_cttz_zero_is_undef_vec(
; CHECK-NEXT:    ret i8 0
;
  %ct = call <2 x i8> @llvm.cttz.v2i8(<2 x i8> %x, i1 true)
  %sh = lshr <2 x i8> %ct, <i8 3, i8 0>
  %ex = extractelement <2 x i8> %sh, i32 0
  ret i8 %ex
}


define i8 @lshr_exact(i8 %x) {
; CHECK-LABEL: @lshr_exact(
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 [[X:%.*]], 2
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[SHL]], 4
; CHECK-NEXT:    [[LSHR:%.*]] = lshr exact i8 [[ADD]], 2
; CHECK-NEXT:    ret i8 [[LSHR]]
;
  %shl = shl i8 %x, 2
  %add = add i8 %shl, 4
  %lshr = lshr i8 %add, 2
  ret i8 %lshr
}

define <2 x i8> @lshr_exact_splat_vec(<2 x i8> %x) {
; CHECK-LABEL: @lshr_exact_splat_vec(
; CHECK-NEXT:    [[SHL:%.*]] = shl <2 x i8> [[X:%.*]], <i8 2, i8 2>
; CHECK-NEXT:    [[ADD:%.*]] = add <2 x i8> [[SHL]], <i8 4, i8 4>
; CHECK-NEXT:    [[LSHR:%.*]] = lshr exact <2 x i8> [[ADD]], <i8 2, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[LSHR]]
;
  %shl = shl <2 x i8> %x, <i8 2, i8 2>
  %add = add <2 x i8> %shl, <i8 4, i8 4>
  %lshr = lshr <2 x i8> %add, <i8 2, i8 2>
  ret <2 x i8> %lshr
}

define i16 @bool_zext(i1 %x) {
; CHECK-LABEL: @bool_zext(
; CHECK-NEXT:    [[HIBIT:%.*]] = zext i1 [[X:%.*]] to i16
; CHECK-NEXT:    ret i16 [[HIBIT]]
;
  %sext = sext i1 %x to i16
  %hibit = lshr i16 %sext, 15
  ret i16 %hibit
}

define <2 x i8> @bool_zext_splat(<2 x i1> %x) {
; CHECK-LABEL: @bool_zext_splat(
; CHECK-NEXT:    [[HIBIT:%.*]] = zext <2 x i1> [[X:%.*]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[HIBIT]]
;
  %sext = sext <2 x i1> %x to <2 x i8>
  %hibit = lshr <2 x i8> %sext, <i8 7, i8 7>
  ret <2 x i8> %hibit
}

define i32 @smear_sign_and_widen(i8 %x) {
; CHECK-LABEL: @smear_sign_and_widen(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr i8 [[X:%.*]], 7
; CHECK-NEXT:    [[HIBIT:%.*]] = zext i8 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[HIBIT]]
;
  %sext = sext i8 %x to i32
  %hibit = lshr i32 %sext, 24
  ret i32 %hibit
}

define i16 @smear_sign_and_widen_should_not_change_type(i4 %x) {
; CHECK-LABEL: @smear_sign_and_widen_should_not_change_type(
; CHECK-NEXT:    [[SEXT:%.*]] = sext i4 [[X:%.*]] to i16
; CHECK-NEXT:    [[HIBIT:%.*]] = lshr i16 [[SEXT]], 12
; CHECK-NEXT:    ret i16 [[HIBIT]]
;
  %sext = sext i4 %x to i16
  %hibit = lshr i16 %sext, 12
  ret i16 %hibit
}

define <2 x i8> @smear_sign_and_widen_splat(<2 x i6> %x) {
; CHECK-LABEL: @smear_sign_and_widen_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <2 x i6> [[X:%.*]], <i6 2, i6 2>
; CHECK-NEXT:    [[HIBIT:%.*]] = zext <2 x i6> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[HIBIT]]
;
  %sext = sext <2 x i6> %x to <2 x i8>
  %hibit = lshr <2 x i8> %sext, <i8 2, i8 2>
  ret <2 x i8> %hibit
}

define i18 @fake_sext(i3 %x) {
; CHECK-LABEL: @fake_sext(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i3 [[X:%.*]], 2
; CHECK-NEXT:    [[SH:%.*]] = zext i3 [[TMP1]] to i18
; CHECK-NEXT:    ret i18 [[SH]]
;
  %sext = sext i3 %x to i18
  %sh = lshr i18 %sext, 17
  ret i18 %sh
}

; Avoid the transform if it would change the shift from a legal to illegal type.

define i32 @fake_sext_but_should_not_change_type(i3 %x) {
; CHECK-LABEL: @fake_sext_but_should_not_change_type(
; CHECK-NEXT:    [[SEXT:%.*]] = sext i3 [[X:%.*]] to i32
; CHECK-NEXT:    [[SH:%.*]] = lshr i32 [[SEXT]], 31
; CHECK-NEXT:    ret i32 [[SH]]
;
  %sext = sext i3 %x to i32
  %sh = lshr i32 %sext, 31
  ret i32 %sh
}

define <2 x i8> @fake_sext_splat(<2 x i3> %x) {
; CHECK-LABEL: @fake_sext_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i3> [[X:%.*]], <i3 2, i3 2>
; CHECK-NEXT:    [[SH:%.*]] = zext <2 x i3> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[SH]]
;
  %sext = sext <2 x i3> %x to <2 x i8>
  %sh = lshr <2 x i8> %sext, <i8 7, i8 7>
  ret <2 x i8> %sh
}

; Use a narrow shift: lshr (zext iM X to iN), C --> zext (lshr X, C) to iN

define <2 x i32> @narrow_lshr_constant(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @narrow_lshr_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i8> [[X:%.*]], <i8 3, i8 3>
; CHECK-NEXT:    [[SH:%.*]] = zext <2 x i8> [[TMP1]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[SH]]
;
  %zx = zext <2 x i8> %x to <2 x i32>
  %sh = lshr <2 x i32> %zx, <i32 3, i32 3>
  ret <2 x i32> %sh
}

define i32 @mul_splat_fold(i32 %x) {
; CHECK-LABEL: @mul_splat_fold(
; CHECK-NEXT:    [[T:%.*]] = and i32 [[X:%.*]], 65535
; CHECK-NEXT:    ret i32 [[T]]
;
  %m = mul nuw i32 %x, 65537
  %t = lshr i32 %m, 16
  ret i32 %t
}

; Vector type, extra use, weird types are all ok.

declare void @usevec(<3 x i14>)

define <3 x i14> @mul_splat_fold_vec(<3 x i14> %x) {
; CHECK-LABEL: @mul_splat_fold_vec(
; CHECK-NEXT:    [[M:%.*]] = mul nuw <3 x i14> [[X:%.*]], <i14 129, i14 129, i14 129>
; CHECK-NEXT:    call void @usevec(<3 x i14> [[M]])
; CHECK-NEXT:    [[T:%.*]] = and <3 x i14> [[X]], <i14 127, i14 127, i14 127>
; CHECK-NEXT:    ret <3 x i14> [[T]]
;
  %m = mul nuw <3 x i14> %x, <i14 129, i14 129, i14 129>
  call void @usevec(<3 x i14> %m)
  %t = lshr <3 x i14> %m, <i14 7, i14 7, i14 7>
  ret <3 x i14> %t
}

; Negative test

define i32 @mul_splat_fold_wrong_mul_const(i32 %x) {
; CHECK-LABEL: @mul_splat_fold_wrong_mul_const(
; CHECK-NEXT:    [[M:%.*]] = mul nuw i32 [[X:%.*]], 65538
; CHECK-NEXT:    [[T:%.*]] = lshr i32 [[M]], 16
; CHECK-NEXT:    ret i32 [[T]]
;
  %m = mul nuw i32 %x, 65538
  %t = lshr i32 %m, 16
  ret i32 %t
}

; Negative test

define i32 @mul_splat_fold_wrong_lshr_const(i32 %x) {
; CHECK-LABEL: @mul_splat_fold_wrong_lshr_const(
; CHECK-NEXT:    [[M:%.*]] = mul nuw i32 [[X:%.*]], 65537
; CHECK-NEXT:    [[T:%.*]] = lshr i32 [[M]], 15
; CHECK-NEXT:    ret i32 [[T]]
;
  %m = mul nuw i32 %x, 65537
  %t = lshr i32 %m, 15
  ret i32 %t
}

; Negative test

define i32 @mul_splat_fold_no_nuw(i32 %x) {
; CHECK-LABEL: @mul_splat_fold_no_nuw(
; CHECK-NEXT:    [[M:%.*]] = mul nsw i32 [[X:%.*]], 65537
; CHECK-NEXT:    [[T:%.*]] = lshr i32 [[M]], 16
; CHECK-NEXT:    ret i32 [[T]]
;
  %m = mul nsw i32 %x, 65537
  %t = lshr i32 %m, 16
  ret i32 %t
}
