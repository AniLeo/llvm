; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

; Fold icmp with a constant operand.

define i1 @tautological_ule(i8 %x) {
; CHECK-LABEL: @tautological_ule(
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ule i8 %x, 255
  ret i1 %cmp
}

define <2 x i1> @tautological_ule_vec(<2 x i8> %x) {
; CHECK-LABEL: @tautological_ule_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %cmp = icmp ule <2 x i8> %x, <i8 255, i8 255>
  ret <2 x i1> %cmp
}

define <2 x i1> @tautological_ule_vec_partial_undef(<2 x i8> %x) {
; CHECK-LABEL: @tautological_ule_vec_partial_undef(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %cmp = icmp ule <2 x i8> %x, <i8 255, i8 undef>
  ret <2 x i1> %cmp
}

define i1 @tautological_ugt(i8 %x) {
; CHECK-LABEL: @tautological_ugt(
; CHECK-NEXT:    ret i1 false
;
  %cmp = icmp ugt i8 %x, 255
  ret i1 %cmp
}

define <2 x i1> @tautological_ugt_vec(<2 x i8> %x) {
; CHECK-LABEL: @tautological_ugt_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %cmp = icmp ugt <2 x i8> %x, <i8 255, i8 255>
  ret <2 x i1> %cmp
}

define <2 x i1> @tautological_ugt_vec_partial_undef(<2 x i8> %x) {
; CHECK-LABEL: @tautological_ugt_vec_partial_undef(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %cmp = icmp ugt <2 x i8> %x, <i8 undef, i8 255>
  ret <2 x i1> %cmp
}

; 'urem x, C2' produces [0, C2)
define i1 @urem3(i32 %X) {
; CHECK-LABEL: @urem3(
; CHECK-NEXT:    ret i1 true
;
  %A = urem i32 %X, 10
  %B = icmp ult i32 %A, 15
  ret i1 %B
}

define <2 x i1> @urem3_vec(<2 x i32> %X) {
; CHECK-LABEL: @urem3_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %A = urem <2 x i32> %X, <i32 10, i32 10>
  %B = icmp ult <2 x i32> %A, <i32 15, i32 15>
  ret <2 x i1> %B
}

define <2 x i1> @urem3_vec_partial_undef(<2 x i32> %X) {
; CHECK-LABEL: @urem3_vec_partial_undef(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %A = urem <2 x i32> %X, <i32 10, i32 10>
  %B = icmp ult <2 x i32> %A, <i32 undef, i32 15>
  ret <2 x i1> %B
}

;'srem x, C2' produces (-|C2|, |C2|)
define i1 @srem1(i32 %X) {
; CHECK-LABEL: @srem1(
; CHECK-NEXT:    ret i1 false
;
  %A = srem i32 %X, -5
  %B = icmp sgt i32 %A, 5
  ret i1 %B
}

define <2 x i1> @srem1_vec(<2 x i32> %X) {
; CHECK-LABEL: @srem1_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %A = srem <2 x i32> %X, <i32 -5, i32 -5>
  %B = icmp sgt <2 x i32> %A, <i32 5, i32 5>
  ret <2 x i1> %B
}

define <2 x i1> @srem1_vec_partial_undef(<2 x i32> %X) {
; CHECK-LABEL: @srem1_vec_partial_undef(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %A = srem <2 x i32> %X, <i32 -5, i32 -5>
  %B = icmp sgt <2 x i32> %A, <i32 5, i32 undef>
  ret <2 x i1> %B
}

;'udiv C2, x' produces [0, C2]
define i1 @udiv5(i32 %X) {
; CHECK-LABEL: @udiv5(
; CHECK-NEXT:    ret i1 false
;
  %A = udiv i32 123, %X
  %C = icmp ugt i32 %A, 124
  ret i1 %C
}

define <2 x i1> @udiv5_vec(<2 x i32> %X) {
; CHECK-LABEL: @udiv5_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %A = udiv <2 x i32> <i32 123, i32 123>, %X
  %C = icmp ugt <2 x i32> %A, <i32 124, i32 124>
  ret <2 x i1> %C
}

; 'udiv x, C2' produces [0, UINT_MAX / C2]
define i1 @udiv1(i32 %X) {
; CHECK-LABEL: @udiv1(
; CHECK-NEXT:    ret i1 true
;
  %A = udiv i32 %X, 1000000
  %B = icmp ult i32 %A, 5000
  ret i1 %B
}

define <2 x i1> @udiv1_vec(<2 x i32> %X) {
; CHECK-LABEL: @udiv1_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %A = udiv <2 x i32> %X, <i32 1000000, i32 1000000>
  %B = icmp ult <2 x i32> %A, <i32 5000, i32 5000>
  ret <2 x i1> %B
}

; 'sdiv C2, x' produces [-|C2|, |C2|]
define i1 @compare_dividend(i32 %a) {
; CHECK-LABEL: @compare_dividend(
; CHECK-NEXT:    ret i1 false
;
  %div = sdiv i32 2, %a
  %cmp = icmp eq i32 %div, 3
  ret i1 %cmp
}

define <2 x i1> @compare_dividend_vec(<2 x i32> %a) {
; CHECK-LABEL: @compare_dividend_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %div = sdiv <2 x i32> <i32 2, i32 2>, %a
  %cmp = icmp eq <2 x i32> %div, <i32 3, i32 3>
  ret <2 x i1> %cmp
}

; 'sdiv x, C2' produces [INT_MIN / C2, INT_MAX / C2]
;    where C2 != -1 and C2 != 0 and C2 != 1
define i1 @sdiv1(i32 %X) {
; CHECK-LABEL: @sdiv1(
; CHECK-NEXT:    ret i1 true
;
  %A = sdiv i32 %X, 1000000
  %B = icmp slt i32 %A, 3000
  ret i1 %B
}

define <2 x i1> @sdiv1_vec(<2 x i32> %X) {
; CHECK-LABEL: @sdiv1_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %A = sdiv <2 x i32> %X, <i32 1000000, i32 1000000>
  %B = icmp slt <2 x i32> %A, <i32 3000, i32 3000>
  ret <2 x i1> %B
}

; 'shl nuw C2, x' produces [C2, C2 << CLZ(C2)]
define i1 @shl5(i32 %X) {
; CHECK-LABEL: @shl5(
; CHECK-NEXT:    ret i1 true
;
  %sub = shl nuw i32 4, %X
  %cmp = icmp ugt i32 %sub, 3
  ret i1 %cmp
}

define <2 x i1> @shl5_vec(<2 x i32> %X) {
; CHECK-LABEL: @shl5_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %sub = shl nuw <2 x i32> <i32 4, i32 4>, %X
  %cmp = icmp ugt <2 x i32> %sub, <i32 3, i32 3>
  ret <2 x i1> %cmp
}

define <2 x i1> @shl5_vec_partial_undef(<2 x i32> %X) {
; CHECK-LABEL: @shl5_vec_partial_undef(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %sub = shl nuw <2 x i32> <i32 4, i32 4>, %X
  %cmp = icmp ugt <2 x i32> %sub, <i32 undef, i32 3>
  ret <2 x i1> %cmp
}

; 'shl nsw C2, x' produces [C2 << CLO(C2)-1, C2]
define i1 @shl2(i32 %X) {
; CHECK-LABEL: @shl2(
; CHECK-NEXT:    ret i1 false
;
  %sub = shl nsw i32 -1, %X
  %cmp = icmp eq i32 %sub, 31
  ret i1 %cmp
}

define <2 x i1> @shl2_vec(<2 x i32> %X) {
; CHECK-LABEL: @shl2_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %sub = shl nsw <2 x i32> <i32 -1, i32 -1>, %X
  %cmp = icmp eq <2 x i32> %sub, <i32 31, i32 31>
  ret <2 x i1> %cmp
}

; 'shl nsw C2, x' produces [C2 << CLO(C2)-1, C2]
define i1 @shl4(i32 %X) {
; CHECK-LABEL: @shl4(
; CHECK-NEXT:    ret i1 true
;
  %sub = shl nsw i32 -1, %X
  %cmp = icmp sle i32 %sub, -1
  ret i1 %cmp
}

define <2 x i1> @shl4_vec(<2 x i32> %X) {
; CHECK-LABEL: @shl4_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %sub = shl nsw <2 x i32> <i32 -1, i32 -1>, %X
  %cmp = icmp sle <2 x i32> %sub, <i32 -1, i32 -1>
  ret <2 x i1> %cmp
}

; 'shl nsw C2, x' produces [C2, C2 << CLZ(C2)-1]
define i1 @icmp_shl_nsw_1(i64 %a) {
; CHECK-LABEL: @icmp_shl_nsw_1(
; CHECK-NEXT:    ret i1 true
;
  %shl = shl nsw i64 1, %a
  %cmp = icmp sge i64 %shl, 0
  ret i1 %cmp
}

define <2 x i1> @icmp_shl_nsw_1_vec(<2 x i64> %a) {
; CHECK-LABEL: @icmp_shl_nsw_1_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %shl = shl nsw <2 x i64> <i64 1, i64 1>, %a
  %cmp = icmp sge <2 x i64> %shl, zeroinitializer
  ret <2 x i1> %cmp
}

; 'shl nsw C2, x' produces [C2 << CLO(C2)-1, C2]
define i1 @icmp_shl_nsw_neg1(i64 %a) {
; CHECK-LABEL: @icmp_shl_nsw_neg1(
; CHECK-NEXT:    ret i1 false
;
  %shl = shl nsw i64 -1, %a
  %cmp = icmp sge i64 %shl, 3
  ret i1 %cmp
}

define <2 x i1> @icmp_shl_nsw_neg1_vec(<2 x i64> %a) {
; CHECK-LABEL: @icmp_shl_nsw_neg1_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %shl = shl nsw <2 x i64> <i64 -1, i64 -1>, %a
  %cmp = icmp sge <2 x i64> %shl, <i64 3, i64 3>
  ret <2 x i1> %cmp
}

; 'lshr x, C2' produces [0, UINT_MAX >> C2]
define i1 @lshr2(i32 %x) {
; CHECK-LABEL: @lshr2(
; CHECK-NEXT:    ret i1 false
;
  %s = lshr i32 %x, 30
  %c = icmp ugt i32 %s, 8
  ret i1 %c
}

define <2 x i1> @lshr2_vec(<2 x i32> %x) {
; CHECK-LABEL: @lshr2_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %s = lshr <2 x i32> %x, <i32 30, i32 30>
  %c = icmp ugt <2 x i32> %s, <i32 8, i32 8>
  ret <2 x i1> %c
}

; 'lshr C2, x' produces [C2 >> (Width-1), C2]
define i1 @exact_lshr_ugt_false(i32 %a) {
; CHECK-LABEL: @exact_lshr_ugt_false(
; CHECK-NEXT:    ret i1 false
;
  %shr = lshr exact i32 30, %a
  %cmp = icmp ult i32 %shr, 15
  ret i1 %cmp
}

define <2 x i1> @exact_lshr_ugt_false_vec(<2 x i32> %a) {
; CHECK-LABEL: @exact_lshr_ugt_false_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %shr = lshr exact <2 x i32> <i32 30, i32 30>, %a
  %cmp = icmp ult <2 x i32> %shr, <i32 15, i32 15>
  ret <2 x i1> %cmp
}

; 'lshr C2, x' produces [C2 >> (Width-1), C2]
define i1 @lshr_sgt_false(i32 %a) {
; CHECK-LABEL: @lshr_sgt_false(
; CHECK-NEXT:    ret i1 false
;
  %shr = lshr i32 1, %a
  %cmp = icmp sgt i32 %shr, 1
  ret i1 %cmp
}

define <2 x i1> @lshr_sgt_false_vec(<2 x i32> %a) {
; CHECK-LABEL: @lshr_sgt_false_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %shr = lshr <2 x i32> <i32 1, i32 1>, %a
  %cmp = icmp sgt <2 x i32> %shr, <i32 1, i32 1>
  ret <2 x i1> %cmp
}

; 'ashr x, C2' produces [INT_MIN >> C2, INT_MAX >> C2]
define i1 @ashr2(i32 %x) {
; CHECK-LABEL: @ashr2(
; CHECK-NEXT:    ret i1 false
;
  %s = ashr i32 %x, 30
  %c = icmp slt i32 %s, -5
  ret i1 %c
}

define <2 x i1> @ashr2_vec(<2 x i32> %x) {
; CHECK-LABEL: @ashr2_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %s = ashr <2 x i32> %x, <i32 30, i32 30>
  %c = icmp slt <2 x i32> %s, <i32 -5, i32 -5>
  ret <2 x i1> %c
}

; 'ashr C2, x' produces [C2, C2 >> (Width-1)]
define i1 @ashr_sgt_false(i32 %a) {
; CHECK-LABEL: @ashr_sgt_false(
; CHECK-NEXT:    ret i1 false
;
  %shr = ashr i32 -30, %a
  %cmp = icmp sgt i32 %shr, -1
  ret i1 %cmp
}

define <2 x i1> @ashr_sgt_false_vec(<2 x i32> %a) {
; CHECK-LABEL: @ashr_sgt_false_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %shr = ashr <2 x i32> <i32 -30, i32 -30>, %a
  %cmp = icmp sgt <2 x i32> %shr, <i32 -1, i32 -1>
  ret <2 x i1> %cmp
}

; 'ashr C2, x' produces [C2, C2 >> (Width-1)]
define i1 @exact_ashr_sgt_false(i32 %a) {
; CHECK-LABEL: @exact_ashr_sgt_false(
; CHECK-NEXT:    ret i1 false
;
  %shr = ashr exact i32 -30, %a
  %cmp = icmp sgt i32 %shr, -15
  ret i1 %cmp
}

define <2 x i1> @exact_ashr_sgt_false_vec(<2 x i32> %a) {
; CHECK-LABEL: @exact_ashr_sgt_false_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %shr = ashr exact <2 x i32> <i32 -30, i32 -30>, %a
  %cmp = icmp sgt <2 x i32> %shr, <i32 -15, i32 -15>
  ret <2 x i1> %cmp
}

; 'or x, C2' produces [C2, UINT_MAX]
define i1 @or1(i32 %X) {
; CHECK-LABEL: @or1(
; CHECK-NEXT:    ret i1 false
;
  %A = or i32 %X, 62
  %B = icmp ult i32 %A, 50
  ret i1 %B
}

define <2 x i1> @or1_vec(<2 x i32> %X) {
; CHECK-LABEL: @or1_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %A = or <2 x i32> %X, <i32 62, i32 62>
  %B = icmp ult <2 x i32> %A, <i32 50, i32 50>
  ret <2 x i1> %B
}

define <2 x i1> @or1_vec_partial_undef(<2 x i32> %X) {
; CHECK-LABEL: @or1_vec_partial_undef(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %A = or <2 x i32> %X, <i32 62, i32 62>
  %B = icmp ult <2 x i32> %A, <i32 undef, i32 50>
  ret <2 x i1> %B
}

; Single bit OR.
define i1 @or2_true(i8 %x) {
; CHECK-LABEL: @or2_true(
; CHECK-NEXT:    [[Y:%.*]] = or i8 [[X:%.*]], 64
; CHECK-NEXT:    [[Z:%.*]] = icmp sge i8 [[Y]], -64
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or i8 %x, 64
  %z = icmp sge i8 %y, -64
  ret i1 %z
}

define i1 @or2_unknown(i8 %x) {
; CHECK-LABEL: @or2_unknown(
; CHECK-NEXT:    [[Y:%.*]] = or i8 [[X:%.*]], 64
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i8 [[Y]], -64
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or i8 %x, 64
  %z = icmp sgt i8 %y, -64
  ret i1 %z
}

; Multi bit OR.
; 78 = 0b01001110; -50 = 0b11001110
define i1 @or3_true(i8 %x) {
; CHECK-LABEL: @or3_true(
; CHECK-NEXT:    [[Y:%.*]] = or i8 [[X:%.*]], 78
; CHECK-NEXT:    [[Z:%.*]] = icmp sge i8 [[Y]], -50
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or i8 %x, 78
  %z = icmp sge i8 %y, -50
  ret i1 %z
}

define i1 @or3_unknown(i8 %x) {
; CHECK-LABEL: @or3_unknown(
; CHECK-NEXT:    [[Y:%.*]] = or i8 [[X:%.*]], 78
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i8 [[Y]], -50
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or i8 %x, 78
  %z = icmp sgt i8 %y, -50
  ret i1 %z
}

; OR with sign bit.
define i1 @or4_true(i8 %x) {
; CHECK-LABEL: @or4_true(
; CHECK-NEXT:    ret i1 true
;
  %y = or i8 %x, -64
  %z = icmp sge i8 %y, -64
  ret i1 %z
}

define i1 @or4_unknown(i8 %x) {
; CHECK-LABEL: @or4_unknown(
; CHECK-NEXT:    [[Y:%.*]] = or i8 [[X:%.*]], -64
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i8 [[Y]], -64
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or i8 %x, -64
  %z = icmp sgt i8 %y, -64
  ret i1 %z
}

; If sign bit is set, signed & unsigned ranges are the same.
define i1 @or5_true(i8 %x) {
; CHECK-LABEL: @or5_true(
; CHECK-NEXT:    ret i1 true
;
  %y = or i8 %x, -64
  %z = icmp uge i8 %y, -64
  ret i1 %z
}

define i1 @or5_unknown(i8 %x) {
; CHECK-LABEL: @or5_unknown(
; CHECK-NEXT:    [[Y:%.*]] = or i8 [[X:%.*]], -64
; CHECK-NEXT:    [[Z:%.*]] = icmp ugt i8 [[Y]], -64
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or i8 %x, -64
  %z = icmp ugt i8 %y, -64
  ret i1 %z
}

; 'and x, C2' produces [0, C2]
define i1 @and1(i32 %X) {
; CHECK-LABEL: @and1(
; CHECK-NEXT:    ret i1 false
;
  %A = and i32 %X, 62
  %B = icmp ugt i32 %A, 70
  ret i1 %B
}

define <2 x i1> @and1_vec(<2 x i32> %X) {
; CHECK-LABEL: @and1_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %A = and <2 x i32> %X, <i32 62, i32 62>
  %B = icmp ugt <2 x i32> %A, <i32 70, i32 70>
  ret <2 x i1> %B
}

; If the sign bit is not set, signed and unsigned ranges are the same.
define i1 @and2(i32 %X) {
; CHECK-LABEL: @and2(
; CHECK-NEXT:    ret i1 false
;
  %A = and i32 %X, 62
  %B = icmp sgt i32 %A, 70
  ret i1 %B
}

; -75 = 0b10110101, 53 = 0b00110101
define i1 @and3_true1(i8 %x) {
; CHECK-LABEL: @and3_true1(
; CHECK-NEXT:    [[Y:%.*]] = and i8 [[X:%.*]], -75
; CHECK-NEXT:    [[Z:%.*]] = icmp sge i8 [[Y]], -75
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = and i8 %x, -75
  %z = icmp sge i8 %y, -75
  ret i1 %z
}

define i1 @and3_unknown1(i8 %x) {
; CHECK-LABEL: @and3_unknown1(
; CHECK-NEXT:    [[Y:%.*]] = and i8 [[X:%.*]], -75
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i8 [[Y]], -75
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = and i8 %x, -75
  %z = icmp sgt i8 %y, -75
  ret i1 %z
}

define i1 @and3_true2(i8 %x) {
; CHECK-LABEL: @and3_true2(
; CHECK-NEXT:    [[Y:%.*]] = and i8 [[X:%.*]], -75
; CHECK-NEXT:    [[Z:%.*]] = icmp sle i8 [[Y]], 53
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = and i8 %x, -75
  %z = icmp sle i8 %y, 53
  ret i1 %z
}

define i1 @and3_unknown2(i8 %x) {
; CHECK-LABEL: @and3_unknown2(
; CHECK-NEXT:    [[Y:%.*]] = and i8 [[X:%.*]], -75
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i8 [[Y]], 53
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = and i8 %x, -75
  %z = icmp slt i8 %y, 53
  ret i1 %z
}

; 'add nuw x, C2' produces [C2, UINT_MAX]
define i1 @tautological9(i32 %x) {
; CHECK-LABEL: @tautological9(
; CHECK-NEXT:    ret i1 true
;
  %add = add nuw i32 %x, 13
  %cmp = icmp ne i32 %add, 12
  ret i1 %cmp
}

define <2 x i1> @tautological9_vec(<2 x i32> %x) {
; CHECK-LABEL: @tautological9_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %add = add nuw <2 x i32> %x, <i32 13, i32 13>
  %cmp = icmp ne <2 x i32> %add, <i32 12, i32 12>
  ret <2 x i1> %cmp
}

; The upper bound of the 'add' is 0.

define i1 @add_nsw_neg_const1(i32 %x) {
; CHECK-LABEL: @add_nsw_neg_const1(
; CHECK-NEXT:    ret i1 false
;
  %add = add nsw i32 %x, -2147483647
  %cmp = icmp sgt i32 %add, 0
  ret i1 %cmp
}

define i1 @add_nsw_sgt(i8 %x) {
; CHECK-LABEL: @add_nsw_sgt(
; CHECK-NEXT:    ret i1 true
;
  %add = add nsw i8 %x, 5
  %cmp = icmp sgt i8 %add, -124
  ret i1 %cmp
}

; nuw should not inhibit the fold.

define i1 @add_nsw_nuw_sgt(i8 %x) {
; CHECK-LABEL: @add_nsw_nuw_sgt(
; CHECK-NEXT:    ret i1 true
;
  %add = add nsw nuw i8 %x, 5
  %cmp = icmp sgt i8 %add, -124
  ret i1 %cmp
}

; negative test - minimum x is -128, so add could be -124.

define i1 @add_nsw_sgt_limit(i8 %x) {
; CHECK-LABEL: @add_nsw_sgt_limit(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i8 [[X:%.*]], 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[ADD]], -124
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i8 %x, 4
  %cmp = icmp sgt i8 %add, -124
  ret i1 %cmp
}

define i1 @add_nsw_slt(i8 %x) {
; CHECK-LABEL: @add_nsw_slt(
; CHECK-NEXT:    ret i1 false
;
  %add = add nsw i8 %x, 5
  %cmp = icmp slt i8 %add, -123
  ret i1 %cmp
}

; nuw should not inhibit the fold.

define i1 @add_nsw_nuw_slt(i8 %x) {
; CHECK-LABEL: @add_nsw_nuw_slt(
; CHECK-NEXT:    ret i1 false
;
  %add = add nsw nuw i8 %x, 5
  %cmp = icmp slt i8 %add, -123
  ret i1 %cmp
}

; negative test - minimum x is -128, so add could be -123.

define i1 @add_nsw_slt_limit(i8 %x) {
; CHECK-LABEL: @add_nsw_slt_limit(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[ADD]], -122
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i8 %x, 5
  %cmp = icmp slt i8 %add, -122
  ret i1 %cmp
}

; InstCombine can fold this, but not InstSimplify.

define i1 @add_nsw_neg_const2(i32 %x) {
; CHECK-LABEL: @add_nsw_neg_const2(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], -2147483647
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[ADD]], -1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i32 %x, -2147483647
  %cmp = icmp sgt i32 %add, -1
  ret i1 %cmp
}

; The upper bound of the 'add' is 1 (move the constants to prove we're doing range-based analysis).

define i1 @add_nsw_neg_const3(i32 %x) {
; CHECK-LABEL: @add_nsw_neg_const3(
; CHECK-NEXT:    ret i1 false
;
  %add = add nsw i32 %x, -2147483646
  %cmp = icmp sgt i32 %add, 1
  ret i1 %cmp
}

; InstCombine can fold this, but not InstSimplify.

define i1 @add_nsw_neg_const4(i32 %x) {
; CHECK-LABEL: @add_nsw_neg_const4(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], -2147483646
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[ADD]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i32 %x, -2147483646
  %cmp = icmp sgt i32 %add, 0
  ret i1 %cmp
}

; The upper bound of the 'add' is 2147483647 - 42 = 2147483605 (move the constants again and try a different cmp predicate).

define i1 @add_nsw_neg_const5(i32 %x) {
; CHECK-LABEL: @add_nsw_neg_const5(
; CHECK-NEXT:    ret i1 true
;
  %add = add nsw i32 %x, -42
  %cmp = icmp ne i32 %add, 2147483606
  ret i1 %cmp
}

; InstCombine can fold this, but not InstSimplify.

define i1 @add_nsw_neg_const6(i32 %x) {
; CHECK-LABEL: @add_nsw_neg_const6(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], -42
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[ADD]], 2147483605
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i32 %x, -42
  %cmp = icmp ne i32 %add, 2147483605
  ret i1 %cmp
}

; The lower bound of the 'add' is -1.

define i1 @add_nsw_pos_const1(i32 %x) {
; CHECK-LABEL: @add_nsw_pos_const1(
; CHECK-NEXT:    ret i1 false
;
  %add = add nsw i32 %x, 2147483647
  %cmp = icmp slt i32 %add, -1
  ret i1 %cmp
}

; InstCombine can fold this, but not InstSimplify.

define i1 @add_nsw_pos_const2(i32 %x) {
; CHECK-LABEL: @add_nsw_pos_const2(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], 2147483647
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[ADD]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i32 %x, 2147483647
  %cmp = icmp slt i32 %add, 0
  ret i1 %cmp
}

; The lower bound of the 'add' is -2 (move the constants to prove we're doing range-based analysis).

define i1 @add_nsw_pos_const3(i32 %x) {
; CHECK-LABEL: @add_nsw_pos_const3(
; CHECK-NEXT:    ret i1 false
;
  %add = add nsw i32 %x, 2147483646
  %cmp = icmp slt i32 %add, -2
  ret i1 %cmp
}

; InstCombine can fold this, but not InstSimplify.

define i1 @add_nsw_pos_const4(i32 %x) {
; CHECK-LABEL: @add_nsw_pos_const4(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], 2147483646
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[ADD]], -1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i32 %x, 2147483646
  %cmp = icmp slt i32 %add, -1
  ret i1 %cmp
}

; The lower bound of the 'add' is -2147483648 + 42 = -2147483606 (move the constants again and change the cmp predicate).

define i1 @add_nsw_pos_const5(i32 %x) {
; CHECK-LABEL: @add_nsw_pos_const5(
; CHECK-NEXT:    ret i1 false
;
  %add = add nsw i32 %x, 42
  %cmp = icmp eq i32 %add, -2147483607
  ret i1 %cmp
}

; InstCombine can fold this, but not InstSimplify.

define i1 @add_nsw_pos_const6(i32 %x) {
; CHECK-LABEL: @add_nsw_pos_const6(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], 42
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ADD]], -2147483606
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i32 %x, 42
  %cmp = icmp eq i32 %add, -2147483606
  ret i1 %cmp
}

; Verify that vectors work too.

define <2 x i1> @add_nsw_pos_const5_splat_vec(<2 x i32> %x) {
; CHECK-LABEL: @add_nsw_pos_const5_splat_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %add = add nsw <2 x i32> %x, <i32 42, i32 42>
  %cmp = icmp ne <2 x i32> %add, <i32 -2147483607, i32 -2147483607>
  ret <2 x i1> %cmp
}

; PR34838 - https://bugs.llvm.org/show_bug.cgi?id=34838
; The shift is known to create poison, so we can simplify the cmp.

define i1 @ne_shl_by_constant_produces_poison(i8 %x) {
; CHECK-LABEL: @ne_shl_by_constant_produces_poison(
; CHECK-NEXT:    ret i1 poison
;
  %zx = zext i8 %x to i16      ; zx  = 0x00xx
  %xor = xor i16 %zx, 32767    ; xor = 0x7fyy
  %sub = sub nsw i16 %zx, %xor ; sub = 0x80zz  (the top bit is known one)
  %poison = shl nsw i16 %sub, 2    ; oops! this shl can't be nsw; that's POISON
  %cmp = icmp ne i16 %poison, 1
  ret i1 %cmp
}

define i1 @eq_shl_by_constant_produces_poison(i8 %x) {
; CHECK-LABEL: @eq_shl_by_constant_produces_poison(
; CHECK-NEXT:    ret i1 poison
;
  %clear_high_bit = and i8 %x, 127                 ; 0x7f
  %set_next_high_bits = or i8 %clear_high_bit, 112 ; 0x70
  %poison = shl nsw i8 %set_next_high_bits, 3
  %cmp = icmp eq i8 %poison, 15
  ret i1 %cmp
}

; Shift-by-variable that produces poison is more complicated but still possible.
; We guarantee that the shift will change the sign of the shifted value (and
; therefore produce poison) by limiting its range from 1 to 3.

define i1 @eq_shl_by_variable_produces_poison(i8 %x) {
; CHECK-LABEL: @eq_shl_by_variable_produces_poison(
; CHECK-NEXT:    ret i1 poison
;
  %clear_high_bit = and i8 %x, 127                 ; 0x7f
  %set_next_high_bits = or i8 %clear_high_bit, 112 ; 0x70
  %notundef_shiftamt = and i8 %x, 3
  %nonzero_shiftamt = or i8 %notundef_shiftamt, 1
  %poison = shl nsw i8 %set_next_high_bits, %nonzero_shiftamt
  %cmp = icmp eq i8 %poison, 15
  ret i1 %cmp
}

; No overflow, so mul constant must be a factor of cmp constant.

define i1 @mul_nuw_urem_cmp_constant1(i8 %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_constant1(
; CHECK-NEXT:    ret i1 false
;
  %m = mul nuw i8 %x, 43
  %r = icmp eq i8 %m, 42
  ret i1 %r
}

; Invert predicate and check vector type.

define <2 x i1> @mul_nuw_urem_cmp_constant_vec_splat(<2 x i8> %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_constant_vec_splat(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %m = mul nuw <2 x i8> %x, <i8 45, i8 45>
  %r = icmp ne <2 x i8> %m, <i8 15, i8 15>
  ret <2 x i1> %r
}

; Undefs in vector constants are ok.

define <2 x i1> @mul_nuw_urem_cmp_constant_vec_splat_undef1(<2 x i8> %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_constant_vec_splat_undef1(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %m = mul nuw <2 x i8> %x, <i8 45, i8 45>
  %r = icmp ne <2 x i8> %m, <i8 15, i8 undef>
  ret <2 x i1> %r
}

; Undefs in vector constants are ok.

define <2 x i1> @mul_nuw_urem_cmp_constant_vec_splat_undef2(<2 x i8> %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_constant_vec_splat_undef2(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %m = mul nuw <2 x i8> %x, <i8 undef, i8 45>
  %r = icmp ne <2 x i8> %m, <i8 15, i8 15>
  ret <2 x i1> %r
}

; Check "negative" numbers (constants should be analyzed as unsigned).

define i1 @mul_nuw_urem_cmp_constant2(i8 %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_constant2(
; CHECK-NEXT:    ret i1 false
;
  %m = mul nuw i8 %x, -42
  %r = icmp eq i8 %m, -84
  ret i1 %r
}

; Negative test - require nuw.

define i1 @mul_urem_cmp_constant1(i8 %x) {
; CHECK-LABEL: @mul_urem_cmp_constant1(
; CHECK-NEXT:    [[M:%.*]] = mul i8 [[X:%.*]], 43
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], 42
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul i8 %x, 43
  %r = icmp eq i8 %m, 42
  ret i1 %r
}

; Negative test - x could be 0.

define i1 @mul_nuw_urem_cmp_constant0(i8 %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_constant0(
; CHECK-NEXT:    [[M:%.*]] = mul nuw i8 [[X:%.*]], 23
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul nuw i8 %x, 23
  %r = icmp eq i8 %m, 0
  ret i1 %r
}

; Negative test - cmp constant is multiple of mul constant.

define i1 @mul_nuw_urem_cmp_constant_is_0(i8 %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_constant_is_0(
; CHECK-NEXT:    [[M:%.*]] = mul nuw i8 [[X:%.*]], 42
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], 84
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul nuw i8 %x, 42
  %r = icmp eq i8 %m, 84
  ret i1 %r
}

; Negative test - cmp constant is multiple (treated as unsigned).

define i1 @mul_nuw_urem_cmp_neg_constant_is_0(i8 %x) {
; CHECK-LABEL: @mul_nuw_urem_cmp_neg_constant_is_0(
; CHECK-NEXT:    [[M:%.*]] = mul nuw i8 [[X:%.*]], 43
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], -127
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul nuw i8 %x, 43
  %r = icmp eq i8 %m, -127
  ret i1 %r
}

; No overflow, so mul constant must be a factor of cmp constant.

define i1 @mul_nsw_srem_cmp_constant1(i8 %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_constant1(
; CHECK-NEXT:    ret i1 false
;
  %m = mul nsw i8 %x, 43
  %r = icmp eq i8 %m, 45
  ret i1 %r
}

; Invert predicate and check vector type.

define <2 x i1> @mul_nsw_srem_cmp_constant_vec_splat(<2 x i8> %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_constant_vec_splat(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %m = mul nsw <2 x i8> %x, <i8 45, i8 45>
  %r = icmp ne <2 x i8> %m, <i8 15, i8 15>
  ret <2 x i1> %r
}

; Undefs in vector constants are ok.

define <2 x i1> @mul_nsw_srem_cmp_constant_vec_splat_undef1(<2 x i8> %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_constant_vec_splat_undef1(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %m = mul nsw <2 x i8> %x, <i8 45, i8 45>
  %r = icmp ne <2 x i8> %m, <i8 15, i8 undef>
  ret <2 x i1> %r
}

; Undefs in vector constants are ok.

define <2 x i1> @mul_nsw_srem_cmp_constant_vec_splat_undef2(<2 x i8> %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_constant_vec_splat_undef2(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %m = mul nsw <2 x i8> %x, <i8 undef, i8 45>
  %r = icmp ne <2 x i8> %m, <i8 15, i8 15>
  ret <2 x i1> %r
}

; Check negative numbers (constants should be analyzed as signed).

define i1 @mul_nsw_srem_cmp_constant2(i8 %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_constant2(
; CHECK-NEXT:    ret i1 false
;
  %m = mul nsw i8 %x, 43
  %r = icmp eq i8 %m, -127
  ret i1 %r
}

; Negative test - require nsw.

define i1 @mul_srem_cmp_constant1(i8 %x) {
; CHECK-LABEL: @mul_srem_cmp_constant1(
; CHECK-NEXT:    [[M:%.*]] = mul i8 [[X:%.*]], 43
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], 42
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul i8 %x, 43
  %r = icmp eq i8 %m, 42
  ret i1 %r
}

; Negative test - x could be 0.

define i1 @mul_nsw_srem_cmp_constant0(i8 %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_constant0(
; CHECK-NEXT:    [[M:%.*]] = mul nsw i8 [[X:%.*]], 23
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul nsw i8 %x, 23
  %r = icmp eq i8 %m, 0
  ret i1 %r
}

; Negative test - cmp constant is multiple of mul constant.

define i1 @mul_nsw_srem_cmp_constant_is_0(i8 %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_constant_is_0(
; CHECK-NEXT:    [[M:%.*]] = mul nsw i8 [[X:%.*]], 42
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], 84
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul nsw i8 %x, 42
  %r = icmp eq i8 %m, 84
  ret i1 %r
}

; Negative test - cmp constant is multiple (treated as signed).

define i1 @mul_nsw_srem_cmp_neg_constant_is_0(i8 %x) {
; CHECK-LABEL: @mul_nsw_srem_cmp_neg_constant_is_0(
; CHECK-NEXT:    [[M:%.*]] = mul nsw i8 [[X:%.*]], -42
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[M]], -84
; CHECK-NEXT:    ret i1 [[R]]
;
  %m = mul nsw i8 %x, -42
  %r = icmp eq i8 %m, -84
  ret i1 %r
}

; Don't crash trying to div/rem-by-zero.

define i1 @mul_nsw_by_zero(i8 %x) {
; CHECK-LABEL: @mul_nsw_by_zero(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret i1 false
; CHECK:       bb3:
; CHECK-NEXT:    br label [[BB2:%.*]]
;
bb1:
  br label %bb3
bb2:
  %r = icmp eq i8 %m, 45
  ret i1 %r
bb3:
  %m = mul nsw i8 %x, 0
  br label %bb2
}

; Don't crash trying to div/rem-by-zero.

define i1 @mul_nuw_by_zero(i8 %x) {
; CHECK-LABEL: @mul_nuw_by_zero(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret i1 false
; CHECK:       bb3:
; CHECK-NEXT:    br label [[BB2:%.*]]
;
bb1:
  br label %bb3
bb2:
  %r = icmp eq i8 %m, 45
  ret i1 %r
bb3:
  %m = mul nuw i8 %x, 0
  br label %bb2
}


define <2 x i1> @heterogeneous_constvector(<2 x i8> %x) {
; CHECK-LABEL: @heterogeneous_constvector(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %c = icmp ult <2 x i8> %x, <i8 undef, i8 poison>
  ret <2 x i1> %c
}
