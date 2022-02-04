; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i64 @test1(i32 %x) nounwind {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i64 0
;
  %y = lshr i32 %x, 1
  %r = udiv i32 %y, -1
  %z = sext i32 %r to i64
  ret i64 %z
}
define i64 @test2(i32 %x) nounwind {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i64 0
;
  %y = lshr i32 %x, 31
  %r = udiv i32 %y, 3
  %z = sext i32 %r to i64
  ret i64 %z
}

; The udiv instructions shouldn't be optimized away, and the
; sext instructions should be optimized to zext.

define i64 @test1_PR2274(i32 %x, i32 %g) nounwind {
; CHECK-LABEL: @test1_PR2274(
; CHECK-NEXT:    [[Y:%.*]] = lshr i32 [[X:%.*]], 30
; CHECK-NEXT:    [[R:%.*]] = udiv i32 [[Y]], [[G:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = zext i32 [[R]] to i64
; CHECK-NEXT:    ret i64 [[Z]]
;
  %y = lshr i32 %x, 30
  %r = udiv i32 %y, %g
  %z = sext i32 %r to i64
  ret i64 %z
}
define i64 @test2_PR2274(i32 %x, i32 %v) nounwind {
; CHECK-LABEL: @test2_PR2274(
; CHECK-NEXT:    [[Y:%.*]] = lshr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[R:%.*]] = udiv i32 [[Y]], [[V:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = zext i32 [[R]] to i64
; CHECK-NEXT:    ret i64 [[Z]]
;
  %y = lshr i32 %x, 31
  %r = udiv i32 %y, %v
  %z = sext i32 %r to i64
  ret i64 %z
}

; The udiv should be simplified according to the rule:
; X udiv (C1 << N), where C1 is `1<<C2` --> X >> (N+C2)
@b = external global [1 x i16]

define i32 @PR30366(i1 %a) {
; CHECK-LABEL: @PR30366(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[A:%.*]] to i32
; CHECK-NEXT:    [[D:%.*]] = lshr i32 [[Z]], zext (i16 ptrtoint ([1 x i16]* @b to i16) to i32)
; CHECK-NEXT:    ret i32 [[D]]
;
  %z = zext i1 %a to i32
  %d = udiv i32 %z, zext (i16 shl (i16 1, i16 ptrtoint ([1 x i16]* @b to i16)) to i32)
  ret i32 %d
}

; OSS-Fuzz #4857
; https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=4857
define i177 @ossfuzz_4857(i177 %X, i177 %Y) {
; CHECK-LABEL: @ossfuzz_4857(
; CHECK-NEXT:    ret i177 0
;
  %B5 = udiv i177 %Y, -1
  %B4 = add i177 %B5, -1
  %B2 = add i177 %B4, -1
  %B6 = mul i177 %B5, %B2
  %B3 = add i177 %B2, %B2
  %B9 = xor i177 %B4, %B3
  %B13 = ashr i177 %Y, %B2
  %B22 = add i177 %B9, %B13
  %B1 = udiv i177 %B5, %B6
  %C9 = icmp ult i177 %Y, %B22
  store i1 %C9, i1* undef
  ret i177 %B1
}

define i32 @udiv_demanded(i32 %a) {
; CHECK-LABEL: @udiv_demanded(
; CHECK-NEXT:    [[U:%.*]] = udiv i32 [[A:%.*]], 12
; CHECK-NEXT:    ret i32 [[U]]
;
  %o = or i32 %a, 3
  %u = udiv i32 %o, 12
  ret i32 %u
}

define i32 @udiv_exact_demanded(i32 %a) {
; CHECK-LABEL: @udiv_exact_demanded(
; CHECK-NEXT:    [[O:%.*]] = and i32 [[A:%.*]], -3
; CHECK-NEXT:    [[U:%.*]] = udiv exact i32 [[O]], 12
; CHECK-NEXT:    ret i32 [[U]]
;
  %o = and i32 %a, -3
  %u = udiv exact i32 %o, 12
  ret i32 %u
}
