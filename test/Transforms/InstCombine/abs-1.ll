; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

declare i32 @abs(i32)
declare i64 @labs(i64)
declare i64 @llabs(i64)

; Test that the abs library call simplifier works correctly.
; abs(x) -> x <s 0 ? -x : x.

define i32 @test_abs(i32 %x) {
; CHECK-LABEL: @test_abs(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %ret = call i32 @abs(i32 %x)
  ret i32 %ret
}

define i64 @test_labs(i64 %x) {
; CHECK-LABEL: @test_labs(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.abs.i64(i64 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %ret = call i64 @labs(i64 %x)
  ret i64 %ret
}

define i64 @test_llabs(i64 %x) {
; CHECK-LABEL: @test_llabs(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.abs.i64(i64 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %ret = call i64 @llabs(i64 %x)
  ret i64 %ret
}

; We have a canonical form of abs to make CSE easier.

define i8 @abs_canonical_1(i8 %x) {
; CHECK-LABEL: @abs_canonical_1(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %cmp = icmp sgt i8 %x, 0
  %neg = sub i8 0, %x
  %abs = select i1 %cmp, i8 %x, i8 %neg
  ret i8 %abs
}

; Vectors should work too.

define <2 x i8> @abs_canonical_2(<2 x i8> %x) {
; CHECK-LABEL: @abs_canonical_2(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %cmp = icmp sgt <2 x i8> %x, <i8 -1, i8 -1>
  %neg = sub <2 x i8> zeroinitializer, %x
  %abs = select <2 x i1> %cmp, <2 x i8> %x, <2 x i8> %neg
  ret <2 x i8> %abs
}

; Even if a constant has undef elements.

define <2 x i8> @abs_canonical_2_vec_undef_elts(<2 x i8> %x) {
; CHECK-LABEL: @abs_canonical_2_vec_undef_elts(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %cmp = icmp sgt <2 x i8> %x, <i8 undef, i8 -1>
  %neg = sub <2 x i8> zeroinitializer, %x
  %abs = select <2 x i1> %cmp, <2 x i8> %x, <2 x i8> %neg
  ret <2 x i8> %abs
}

; NSW should not change.

define i8 @abs_canonical_3(i8 %x) {
; CHECK-LABEL: @abs_canonical_3(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %cmp = icmp slt i8 %x, 0
  %neg = sub nsw i8 0, %x
  %abs = select i1 %cmp, i8 %neg, i8 %x
  ret i8 %abs
}

define i8 @abs_canonical_4(i8 %x) {
; CHECK-LABEL: @abs_canonical_4(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %cmp = icmp slt i8 %x, 1
  %neg = sub i8 0, %x
  %abs = select i1 %cmp, i8 %neg, i8 %x
  ret i8 %abs
}

define i32 @abs_canonical_5(i8 %x) {
; CHECK-LABEL: @abs_canonical_5(
; CHECK-NEXT:    [[CONV:%.*]] = sext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[CONV]], i1 true)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cmp = icmp sgt i8 %x, 0
  %conv = sext i8 %x to i32
  %neg = sub i32 0, %conv
  %abs = select i1 %cmp, i32 %conv, i32 %neg
  ret i32 %abs
}

define i32 @abs_canonical_6(i32 %a, i32 %b) {
; CHECK-LABEL: @abs_canonical_6(
; CHECK-NEXT:    [[T1:%.*]] = sub i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[T1]], i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %t1 = sub i32 %a, %b
  %cmp = icmp sgt i32 %t1, -1
  %t2 = sub i32 %b, %a
  %abs = select i1 %cmp, i32 %t1, i32 %t2
  ret i32 %abs
}

define <2 x i8> @abs_canonical_7(<2 x i8> %a, <2 x i8 > %b) {
; CHECK-LABEL: @abs_canonical_7(
; CHECK-NEXT:    [[T1:%.*]] = sub <2 x i8> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[T1]], i1 false)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;

  %t1 = sub <2 x i8> %a, %b
  %cmp = icmp sgt <2 x i8> %t1, <i8 -1, i8 -1>
  %t2 = sub <2 x i8> %b, %a
  %abs = select <2 x i1> %cmp, <2 x i8> %t1, <2 x i8> %t2
  ret <2 x i8> %abs
}

define i32 @abs_canonical_8(i32 %a) {
; CHECK-LABEL: @abs_canonical_8(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[A:%.*]], i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %t = sub i32 0, %a
  %cmp = icmp slt i32 %t, 0
  %abs = select i1 %cmp, i32 %a, i32 %t
  ret i32 %abs
}

define i32 @abs_canonical_9(i32 %a, i32 %b) {
; CHECK-LABEL: @abs_canonical_9(
; CHECK-NEXT:    [[T1:%.*]] = sub i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = sub i32 [[B]], [[A]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[T1]], i1 false)
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP1]], [[T2]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %t1 = sub i32 %a, %b
  %cmp = icmp sgt i32 %t1, -1
  %t2 = sub i32 %b, %a
  %abs = select i1 %cmp, i32 %t1, i32 %t2
  %add = add i32 %abs, %t2 ; increase use count for %t2.
  ret i32 %add
}

define i32 @abs_canonical_10(i32 %a, i32 %b) {
; CHECK-LABEL: @abs_canonical_10(
; CHECK-NEXT:    [[T1:%.*]] = sub i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[T1]], i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %t2 = sub i32 %b, %a
  %t1 = sub i32 %a, %b
  %cmp = icmp sgt i32 %t1, -1
  %abs = select i1 %cmp, i32 %t1, i32 %t2
  ret i32 %abs
}

; We have a canonical form of nabs to make CSE easier.

define i8 @nabs_canonical_1(i8 %x) {
; CHECK-LABEL: @nabs_canonical_1(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[ABS]]
;
  %cmp = icmp sgt i8 %x, 0
  %neg = sub i8 0, %x
  %abs = select i1 %cmp, i8 %neg, i8 %x
  ret i8 %abs
}

; Vectors should work too.

define <2 x i8> @nabs_canonical_2(<2 x i8> %x) {
; CHECK-LABEL: @nabs_canonical_2(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[X:%.*]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[ABS]]
;
  %cmp = icmp sgt <2 x i8> %x, <i8 -1, i8 -1>
  %neg = sub <2 x i8> zeroinitializer, %x
  %abs = select <2 x i1> %cmp, <2 x i8> %neg, <2 x i8> %x
  ret <2 x i8> %abs
}

; Even if a constant has undef elements.

define <2 x i8> @nabs_canonical_2_vec_undef_elts(<2 x i8> %x) {
; CHECK-LABEL: @nabs_canonical_2_vec_undef_elts(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[X:%.*]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[ABS]]
;
  %cmp = icmp sgt <2 x i8> %x, <i8 -1, i8 undef>
  %neg = sub <2 x i8> zeroinitializer, %x
  %abs = select <2 x i1> %cmp, <2 x i8> %neg, <2 x i8> %x
  ret <2 x i8> %abs
}

; NSW should not change.

define i8 @nabs_canonical_3(i8 %x) {
; CHECK-LABEL: @nabs_canonical_3(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 true)
; CHECK-NEXT:    [[ABS:%.*]] = sub nsw i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[ABS]]
;
  %cmp = icmp slt i8 %x, 0
  %neg = sub nsw i8 0, %x
  %abs = select i1 %cmp, i8 %x, i8 %neg
  ret i8 %abs
}

define i8 @nabs_canonical_4(i8 %x) {
; CHECK-LABEL: @nabs_canonical_4(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[ABS]]
;
  %cmp = icmp slt i8 %x, 1
  %neg = sub i8 0, %x
  %abs = select i1 %cmp, i8 %x, i8 %neg
  ret i8 %abs
}

define i32 @nabs_canonical_5(i8 %x) {
; CHECK-LABEL: @nabs_canonical_5(
; CHECK-NEXT:    [[CONV:%.*]] = sext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[CONV]], i1 true)
; CHECK-NEXT:    [[ABS:%.*]] = sub nsw i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %cmp = icmp sgt i8 %x, 0
  %conv = sext i8 %x to i32
  %neg = sub i32 0, %conv
  %abs = select i1 %cmp, i32 %neg, i32 %conv
  ret i32 %abs
}

define i32 @nabs_canonical_6(i32 %a, i32 %b) {
; CHECK-LABEL: @nabs_canonical_6(
; CHECK-NEXT:    [[T1:%.*]] = sub i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[T1]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %t1 = sub i32 %a, %b
  %cmp = icmp sgt i32 %t1, -1
  %t2 = sub i32 %b, %a
  %abs = select i1 %cmp, i32 %t2, i32 %t1
  ret i32 %abs
}

define <2 x i8> @nabs_canonical_7(<2 x i8> %a, <2 x i8 > %b) {
; CHECK-LABEL: @nabs_canonical_7(
; CHECK-NEXT:    [[T1:%.*]] = sub <2 x i8> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[T1]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[ABS]]
;
  %t1 = sub <2 x i8> %a, %b
  %cmp = icmp sgt <2 x i8> %t1, <i8 -1, i8 -1>
  %t2 = sub <2 x i8> %b, %a
  %abs = select <2 x i1> %cmp, <2 x i8> %t2, <2 x i8> %t1
  ret <2 x i8> %abs
}

define i32 @nabs_canonical_8(i32 %a) {
; CHECK-LABEL: @nabs_canonical_8(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[A:%.*]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %t = sub i32 0, %a
  %cmp = icmp slt i32 %t, 0
  %abs = select i1 %cmp, i32 %t, i32 %a
  ret i32 %abs
}

define i32 @nabs_canonical_9(i32 %a, i32 %b) {
; CHECK-LABEL: @nabs_canonical_9(
; CHECK-NEXT:    [[T1:%.*]] = sub i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = sub i32 [[B]], [[A]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[T1]], i1 false)
; CHECK-NEXT:    [[ADD:%.*]] = sub i32 [[T2]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %t1 = sub i32 %a, %b
  %cmp = icmp sgt i32 %t1, -1
  %t2 = sub i32 %b, %a
  %abs = select i1 %cmp, i32 %t2, i32 %t1
  %add = add i32 %t2, %abs ; increase use count for %t2
  ret i32 %add
}

define i32 @nabs_canonical_10(i32 %a, i32 %b) {
; CHECK-LABEL: @nabs_canonical_10(
; CHECK-NEXT:    [[T1:%.*]] = sub i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.abs.i32(i32 [[T1]], i1 false)
; CHECK-NEXT:    [[ABS:%.*]] = sub i32 0, [[TMP1]]
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %t2 = sub i32 %b, %a
  %t1 = sub i32 %a, %b
  %cmp = icmp slt i32 %t1, 1
  %abs = select i1 %cmp, i32 %t1, i32 %t2
  ret i32 %abs
}

; The following 5 tests use a shift+add+xor to implement abs():
; B = ashr i8 A, 7  -- smear the sign bit.
; xor (add A, B), B -- add -1 and flip bits if negative

define i8 @shifty_abs_commute0(i8 %x) {
; CHECK-LABEL: @shifty_abs_commute0(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %signbit = ashr i8 %x, 7
  %add = add i8 %signbit, %x
  %abs = xor i8 %add, %signbit
  ret i8 %abs
}

define i8 @shifty_abs_commute0_nsw(i8 %x) {
; CHECK-LABEL: @shifty_abs_commute0_nsw(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %signbit = ashr i8 %x, 7
  %add = add nsw i8 %signbit, %x
  %abs = xor i8 %add, %signbit
  ret i8 %abs
}

; The nuw flag creates a contradiction. If the shift produces all 1s, the only
; way for the add to not wrap is for %x to be 0, but then the shift couldn't
; have produced all 1s. We partially optimize this.
define i8 @shifty_abs_commute0_nuw(i8 %x) {
; CHECK-LABEL: @shifty_abs_commute0_nuw(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i8 [[X:%.*]], 0
; CHECK-NEXT:    [[ABS:%.*]] = select i1 [[TMP1]], i8 [[X]], i8 0
; CHECK-NEXT:    ret i8 [[ABS]]
;
  %signbit = ashr i8 %x, 7
  %add = add nuw i8 %signbit, %x
  %abs = xor i8 %add, %signbit
  ret i8 %abs
}

define <2 x i8> @shifty_abs_commute1(<2 x i8> %x) {
; CHECK-LABEL: @shifty_abs_commute1(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %signbit = ashr <2 x i8> %x, <i8 7, i8 7>
  %add = add <2 x i8> %signbit, %x
  %abs = xor <2 x i8> %signbit, %add
  ret <2 x i8> %abs
}

define <2 x i8> @shifty_abs_commute2(<2 x i8> %x) {
; CHECK-LABEL: @shifty_abs_commute2(
; CHECK-NEXT:    [[Y:%.*]] = mul <2 x i8> [[X:%.*]], <i8 3, i8 3>
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[Y]], i1 false)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %y = mul <2 x i8> %x, <i8 3, i8 3>   ; extra op to thwart complexity-based canonicalization
  %signbit = ashr <2 x i8> %y, <i8 7, i8 7>
  %add = add <2 x i8> %y, %signbit
  %abs = xor <2 x i8> %signbit, %add
  ret <2 x i8> %abs
}

define i8 @shifty_abs_commute3(i8 %x) {
; CHECK-LABEL: @shifty_abs_commute3(
; CHECK-NEXT:    [[Y:%.*]] = mul i8 [[X:%.*]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[Y]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %y = mul i8 %x, 3                    ; extra op to thwart complexity-based canonicalization
  %signbit = ashr i8 %y, 7
  %add = add i8 %y, %signbit
  %abs = xor i8 %add, %signbit
  ret i8 %abs
}

; Negative test - don't transform if it would increase instruction count.

declare void @extra_use(i8)
declare void @extra_use_i1(i1)

define i8 @shifty_abs_too_many_uses(i8 %x) {
; CHECK-LABEL: @shifty_abs_too_many_uses(
; CHECK-NEXT:    [[SIGNBIT:%.*]] = ashr i8 [[X:%.*]], 7
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[SIGNBIT]], [[X]]
; CHECK-NEXT:    [[ABS:%.*]] = xor i8 [[ADD]], [[SIGNBIT]]
; CHECK-NEXT:    call void @extra_use(i8 [[SIGNBIT]])
; CHECK-NEXT:    ret i8 [[ABS]]
;
  %signbit = ashr i8 %x, 7
  %add = add i8 %x, %signbit
  %abs = xor i8 %add, %signbit
  call void @extra_use(i8 %signbit)
  ret i8 %abs
}

; There's another way to make abs() using shift, xor, and subtract.
; PR36036 - https://bugs.llvm.org/show_bug.cgi?id=36036

define i8 @shifty_sub(i8 %x) {
; CHECK-LABEL: @shifty_sub(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %sh = ashr i8 %x, 7
  %xor = xor i8 %x, %sh
  %r = sub i8 %xor, %sh
  ret i8 %r
}

define i8 @shifty_sub_nsw_commute(i8 %x) {
; CHECK-LABEL: @shifty_sub_nsw_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %sh = ashr i8 %x, 7
  %xor = xor i8 %sh, %x
  %r = sub nsw i8 %xor, %sh
  ret i8 %r
}

define <4 x i32> @shifty_sub_nuw_vec_commute(<4 x i32> %x) {
; CHECK-LABEL: @shifty_sub_nuw_vec_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <4 x i32> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[TMP1]], <4 x i32> [[X]], <4 x i32> zeroinitializer
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %sh = ashr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %xor = xor <4 x i32> %sh, %x
  %r = sub nuw <4 x i32> %xor, %sh
  ret <4 x i32> %r
}

define i12 @shifty_sub_nsw_nuw(i12 %x) {
; CHECK-LABEL: @shifty_sub_nsw_nuw(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i12 [[X:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[TMP1]], i12 [[X]], i12 0
; CHECK-NEXT:    ret i12 [[R]]
;
  %sh = ashr i12 %x, 11
  %xor = xor i12 %x, %sh
  %r = sub nsw nuw i12 %xor, %sh
  ret i12 %r
}

define i8 @negate_abs(i8 %x) {
; CHECK-LABEL: @negate_abs(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[R:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %n = sub i8 0, %x
  %c = icmp slt i8 %x, 0
  %s = select i1 %c, i8 %n, i8 %x
  %r = sub i8 0, %s
  ret i8 %r
}

define <2 x i8> @negate_nabs(<2 x i8> %x) {
; CHECK-LABEL: @negate_nabs(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.abs.v2i8(<2 x i8> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %n = sub <2 x i8> zeroinitializer, %x
  %c = icmp slt <2 x i8> %x, zeroinitializer
  %s = select <2 x i1> %c, <2 x i8> %x, <2 x i8> %n
  %r = sub <2 x i8> zeroinitializer, %s
  ret <2 x i8> %r
}

define i1 @abs_must_be_positive(i32 %x) {
; CHECK-LABEL: @abs_must_be_positive(
; CHECK-NEXT:    ret i1 true
;
  %negx = sub nsw i32 0, %x
  %c = icmp sge i32 %x, 0
  %sel = select i1 %c, i32 %x, i32 %negx
  %c2 = icmp sge i32 %sel, 0
  ret i1 %c2
}

define i8 @abs_swapped(i8 %a) {
; CHECK-LABEL: @abs_swapped(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    call void @extra_use(i8 [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[A]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %neg = sub i8 0, %a
  call void @extra_use(i8 %neg)
  %cmp1 = icmp sgt i8 %a, 0
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  ret i8 %m1
}

define i8 @nabs_swapped(i8 %a) {
; CHECK-LABEL: @nabs_swapped(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    call void @extra_use(i8 [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[A]], i1 false)
; CHECK-NEXT:    [[M2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[M2]]
;
  %neg = sub i8 0, %a
  call void @extra_use(i8 %neg)
  %cmp2 = icmp sgt i8 %a, 0
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  ret i8 %m2
}

define i8 @abs_different_constants(i8 %a) {
; CHECK-LABEL: @abs_different_constants(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    call void @extra_use(i8 [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[A]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %neg = sub i8 0, %a
  call void @extra_use(i8 %neg)
  %cmp1 = icmp sgt i8 %a, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  ret i8 %m1
}

define i8 @nabs_different_constants(i8 %a) {
; CHECK-LABEL: @nabs_different_constants(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    call void @extra_use(i8 [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[A]], i1 false)
; CHECK-NEXT:    [[M2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[M2]]
;
  %neg = sub i8 0, %a
  call void @extra_use(i8 %neg)
  %cmp2 = icmp sgt i8 %a, -1
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  ret i8 %m2
}

@g = external global i64

; PR45539 - https://bugs.llvm.org/show_bug.cgi?id=45539

define i64 @infinite_loop_constant_expression_abs(i64 %arg) {
; CHECK-LABEL: @infinite_loop_constant_expression_abs(
; CHECK-NEXT:    [[T:%.*]] = sub i64 ptrtoint (i64* @g to i64), [[ARG:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.abs.i64(i64 [[T]], i1 true)
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %t = sub i64 ptrtoint (i64* @g to i64), %arg
  %t1 = icmp slt i64 %t, 0
  %t2 = sub nsw i64 0, %t
  %t3 = select i1 %t1, i64 %t2, i64 %t
  ret i64 %t3
}

define i8 @abs_extra_use_icmp(i8 %x) {
; CHECK-LABEL: @abs_extra_use_icmp(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @extra_use_i1(i1 [[C]])
; CHECK-NEXT:    [[N:%.*]] = sub i8 0, [[X]]
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 [[N]], i8 [[X]]
; CHECK-NEXT:    ret i8 [[S]]
;
  %c = icmp slt i8 %x, 0
  call void @extra_use_i1(i1 %c)
  %n = sub i8 0, %x
  %s = select i1 %c, i8 %n, i8 %x
  ret i8 %s
}

define i8 @abs_extra_use_sub(i8 %x) {
; CHECK-LABEL: @abs_extra_use_sub(
; CHECK-NEXT:    [[N:%.*]] = sub i8 0, [[X:%.*]]
; CHECK-NEXT:    call void @extra_use(i8 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %c = icmp slt i8 %x, 0
  %n = sub i8 0, %x
  call void @extra_use(i8 %n)
  %s = select i1 %c, i8 %n, i8 %x
  ret i8 %s
}

define i8 @abs_extra_use_icmp_sub(i8 %x) {
; CHECK-LABEL: @abs_extra_use_icmp_sub(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @extra_use_i1(i1 [[C]])
; CHECK-NEXT:    [[N:%.*]] = sub i8 0, [[X]]
; CHECK-NEXT:    call void @extra_use(i8 [[N]])
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 [[N]], i8 [[X]]
; CHECK-NEXT:    ret i8 [[S]]
;
  %c = icmp slt i8 %x, 0
  call void @extra_use_i1(i1 %c)
  %n = sub i8 0, %x
  call void @extra_use(i8 %n)
  %s = select i1 %c, i8 %n, i8 %x
  ret i8 %s
}

define i8 @nabs_extra_use_icmp(i8 %x) {
; CHECK-LABEL: @nabs_extra_use_icmp(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @extra_use_i1(i1 [[C]])
; CHECK-NEXT:    [[N:%.*]] = sub i8 0, [[X]]
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 [[X]], i8 [[N]]
; CHECK-NEXT:    ret i8 [[S]]
;
  %c = icmp slt i8 %x, 0
  call void @extra_use_i1(i1 %c)
  %n = sub i8 0, %x
  %s = select i1 %c, i8 %x, i8 %n
  ret i8 %s
}

define i8 @nabs_extra_use_sub(i8 %x) {
; CHECK-LABEL: @nabs_extra_use_sub(
; CHECK-NEXT:    [[N:%.*]] = sub i8 0, [[X:%.*]]
; CHECK-NEXT:    call void @extra_use(i8 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    [[S:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[S]]
;
  %c = icmp slt i8 %x, 0
  %n = sub i8 0, %x
  call void @extra_use(i8 %n)
  %s = select i1 %c, i8 %x, i8 %n
  ret i8 %s
}

define i8 @nabs_extra_use_icmp_sub(i8 %x) {
; CHECK-LABEL: @nabs_extra_use_icmp_sub(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @extra_use_i1(i1 [[C]])
; CHECK-NEXT:    [[N:%.*]] = sub i8 0, [[X]]
; CHECK-NEXT:    call void @extra_use(i8 [[N]])
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 [[X]], i8 [[N]]
; CHECK-NEXT:    ret i8 [[S]]
;
  %c = icmp slt i8 %x, 0
  call void @extra_use_i1(i1 %c)
  %n = sub i8 0, %x
  call void @extra_use(i8 %n)
  %s = select i1 %c, i8 %x, i8 %n
  ret i8 %s
}
