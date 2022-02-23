; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i32 @t1(i16 zeroext %x, i32 %y) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[Y:%.*]], 1
; CHECK-NEXT:    [[D1:%.*]] = lshr i32 [[CONV]], [[TMP0]]
; CHECK-NEXT:    ret i32 [[D1]]
;
entry:
  %conv = zext i16 %x to i32
  %s = shl i32 2, %y
  %d = sdiv i32 %conv, %s
  ret i32 %d
}

define <2 x i32> @t1vec(<2 x i16> %x, <2 x i32> %y) {
; CHECK-LABEL: @t1vec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = zext <2 x i16> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[TMP0:%.*]] = add <2 x i32> [[Y:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[D1:%.*]] = lshr <2 x i32> [[CONV]], [[TMP0]]
; CHECK-NEXT:    ret <2 x i32> [[D1]]
;
entry:
  %conv = zext <2 x i16> %x to <2 x i32>
  %s = shl <2 x i32> <i32 2, i32 2>, %y
  %d = sdiv <2 x i32> %conv, %s
  ret <2 x i32> %d
}

; rdar://11721329
define i64 @t2(i64 %x, i32 %y) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[Y:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i64 [[X:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %1 = shl i32 1, %y
  %2 = zext i32 %1 to i64
  %3 = udiv i64 %x, %2
  ret i64 %3
}

; PR13250
define i64 @t3(i64 %x, i32 %y) {
; CHECK-LABEL: @t3(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[Y:%.*]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = lshr i64 [[X:%.*]], [[TMP2]]
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %1 = shl i32 4, %y
  %2 = zext i32 %1 to i64
  %3 = udiv i64 %x, %2
  ret i64 %3
}

define i32 @t4(i32 %x, i32 %y) {
; CHECK-LABEL: @t4(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[Y:%.*]], 5
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[Y]], i32 5
; CHECK-NEXT:    [[TMP3:%.*]] = lshr i32 [[X:%.*]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = shl i32 1, %y
  %2 = icmp ult i32 %1, 32
  %3 = select i1 %2, i32 32, i32 %1
  %4 = udiv i32 %x, %3
  ret i32 %4
}

define i32 @t5(i1 %x, i1 %y, i32 %V) {
; CHECK-LABEL: @t5(
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[X:%.*]], i32 5, i32 6
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[Y:%.*]], i32 [[TMP1]], i32 [[V:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = lshr i32 [[V]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = shl i32 1, %V
  %2 = select i1 %x, i32 32, i32 64
  %3 = select i1 %y, i32 %2, i32 %1
  %4 = udiv i32 %V, %3
  ret i32 %4
}

define i32 @t6(i32 %x, i32 %z) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[X_IS_ZERO:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[DIVISOR:%.*]] = select i1 [[X_IS_ZERO]], i32 1, i32 [[X]]
; CHECK-NEXT:    [[Y:%.*]] = udiv i32 [[Z:%.*]], [[DIVISOR]]
; CHECK-NEXT:    ret i32 [[Y]]
;
  %x_is_zero = icmp eq i32 %x, 0
  %divisor = select i1 %x_is_zero, i32 1, i32 %x
  %y = udiv i32 %z, %divisor
  ret i32 %y
}

; (X << C1) / X -> 1 << C1 optimizations

define i32 @t7(i32 %x) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    ret i32 4
;
  %shl = shl nsw i32 %x, 2
  %r = sdiv i32 %shl, %x
  ret i32 %r
}

; make sure the previous opt doesn't take place for wrapped shifts

define i32 @t8(i32 %x) {
; CHECK-LABEL: @t8(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], 2
; CHECK-NEXT:    [[R:%.*]] = sdiv i32 [[SHL]], [[X]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %shl = shl i32 %x, 2
  %r = sdiv i32 %shl, %x
  ret i32 %r
}

define <2 x i32> @t9(<2 x i32> %x) {
; CHECK-LABEL: @t9(
; CHECK-NEXT:    ret <2 x i32> <i32 4, i32 8>
;
  %shl = shl nsw <2 x i32> %x, <i32 2, i32 3>
  %r = sdiv <2 x i32> %shl, %x
  ret <2 x i32> %r
}

define i32 @t10(i32 %x, i32 %y) {
; CHECK-LABEL: @t10(
; CHECK-NEXT:    [[R:%.*]] = shl nsw i32 1, [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %shl = shl nsw i32 %x, %y
  %r = sdiv i32 %shl, %x
  ret i32 %r
}

define <2 x i32> @t11(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @t11(
; CHECK-NEXT:    [[R:%.*]] = shl nsw <2 x i32> <i32 1, i32 1>, [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shl = shl nsw <2 x i32> %x, %y
  %r = sdiv <2 x i32> %shl, %x
  ret <2 x i32> %r
}

define i32 @t12(i32 %x) {
; CHECK-LABEL: @t12(
; CHECK-NEXT:    ret i32 4
;
  %shl = shl nuw i32 %x, 2
  %r = udiv i32 %shl, %x
  ret i32 %r
}

; make sure the previous opt doesn't take place for wrapped shifts

define i32 @t13(i32 %x) {
; CHECK-LABEL: @t13(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], 2
; CHECK-NEXT:    [[R:%.*]] = udiv i32 [[SHL]], [[X]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %shl = shl i32 %x, 2
  %r = udiv i32 %shl, %x
  ret i32 %r
}

define <2 x i32> @t14(<2 x i32> %x) {
; CHECK-LABEL: @t14(
; CHECK-NEXT:    ret <2 x i32> <i32 4, i32 8>
;
  %shl = shl nuw <2 x i32> %x, <i32 2, i32 3>
  %r = udiv <2 x i32> %shl, %x
  ret <2 x i32> %r
}

define i32 @t15(i32 %x, i32 %y) {
; CHECK-LABEL: @t15(
; CHECK-NEXT:    [[R:%.*]] = shl nuw i32 1, [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %shl = shl nuw i32 %x, %y
  %r = udiv i32 %shl, %x
  ret i32 %r
}

define <2 x i32> @t16(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @t16(
; CHECK-NEXT:    [[R:%.*]] = shl nuw <2 x i32> <i32 1, i32 1>, [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shl = shl nuw <2 x i32> %x, %y
  %r = udiv <2 x i32> %shl, %x
  ret <2 x i32> %r
}
