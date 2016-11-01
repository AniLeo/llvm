; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Instcombine should recognize that this code can be adjusted to fit the canonical max/min pattern.

; No change

define i32 @smax1(i32 %n) {
; CHECK-LABEL: @smax1(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 %n, i32 0
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp sgt i32 %n, 0
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; No change

define i32 @smin1(i32 %n) {
; CHECK-LABEL: @smin1(
; CHECK-NEXT:    [[T:%.*]] = icmp slt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 %n, i32 0
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp slt i32 %n, 0
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; Canonicalize icmp predicate.

define i32 @smax2(i32 %n) {
; CHECK-LABEL: @smax2(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 %n, i32 0
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp sge i32 %n, 1
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; Canonicalize icmp predicate.

define i32 @smin2(i32 %n) {
; CHECK-LABEL: @smin2(
; CHECK-NEXT:    [[T:%.*]] = icmp slt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 %n, i32 0
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp sle i32 %n, -1
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; Swap signed pred and select ops.

define i32 @smax3(i32 %n) {
; CHECK-LABEL: @smax3(
; CHECK-NEXT:    [[T:%.*]] = icmp slt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 0, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp sgt i32 %n, -1
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; Swap vector signed pred and select ops.

define <2 x i32> @smax3_vec(<2 x i32> %n) {
; CHECK-LABEL: @smax3_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp slt <2 x i32> %n, zeroinitializer
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> zeroinitializer, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp sgt <2 x i32> %n, <i32 -1, i32 -1>
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> zeroinitializer
  ret <2 x i32> %m
}

; Swap signed pred and select ops.

define i32 @smin3(i32 %n) {
; CHECK-LABEL: @smin3(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 0, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp slt i32 %n, 1
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; Swap vector signed pred and select ops.

define <2 x i32> @smin3_vec(<2 x i32> %n) {
; CHECK-LABEL: @smin3_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt <2 x i32> %n, zeroinitializer
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> zeroinitializer, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp slt <2 x i32> %n, <i32 1, i32 1>
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> zeroinitializer
  ret <2 x i32> %m
}

; Swap unsigned pred and select ops.

define i32 @umax3(i32 %n) {
; CHECK-LABEL: @umax3(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 %n, 5
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 5, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp ugt i32 %n, 4
  %m = select i1 %t, i32 %n, i32 5
  ret i32 %m
}

; Swap vector unsigned pred and select ops.

define <2 x i32> @umax3_vec(<2 x i32> %n) {
; CHECK-LABEL: @umax3_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> %n, <i32 5, i32 5>
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> <i32 5, i32 5>, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp ugt <2 x i32> %n, <i32 4, i32 4>
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> <i32 5, i32 5>
  ret <2 x i32> %m
}

; Swap unsigned pred and select ops.

define i32 @umin3(i32 %n) {
; CHECK-LABEL: @umin3(
; CHECK-NEXT:    [[T:%.*]] = icmp ugt i32 %n, 6
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 6, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp ult i32 %n, 7
  %m = select i1 %t, i32 %n, i32 6
  ret i32 %m
}

; Swap vector unsigned pred and select ops.

define <2 x i32> @umin3_vec(<2 x i32> %n) {
; CHECK-LABEL: @umin3_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp ugt <2 x i32> %n, <i32 6, i32 6>
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> <i32 6, i32 6>, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp ult <2 x i32> %n, <i32 7, i32 7>
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> <i32 6, i32 6>
  ret <2 x i32> %m
}

; Canonicalize signed pred and swap pred and select ops.

define i32 @smax4(i32 %n) {
; CHECK-LABEL: @smax4(
; CHECK-NEXT:    [[T:%.*]] = icmp slt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 0, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp sge i32 %n, 0
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; Canonicalize vector signed pred and swap pred and select ops.

define <2 x i32> @smax4_vec(<2 x i32> %n) {
; CHECK-LABEL: @smax4_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp slt <2 x i32> %n, zeroinitializer
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> zeroinitializer, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp sge <2 x i32> %n, zeroinitializer
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> zeroinitializer
  ret <2 x i32> %m
}

; Canonicalize signed pred and swap pred and select ops.

define i32 @smin4(i32 %n) {
; CHECK-LABEL: @smin4(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt i32 %n, 0
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 0, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp sle i32 %n, 0
  %m = select i1 %t, i32 %n, i32 0
  ret i32 %m
}

; Canonicalize vector signed pred and swap pred and select ops.

define <2 x i32> @smin4_vec(<2 x i32> %n) {
; CHECK-LABEL: @smin4_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp sgt <2 x i32> %n, zeroinitializer
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> zeroinitializer, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp sle <2 x i32> %n, zeroinitializer
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> zeroinitializer
  ret <2 x i32> %m
}

; Canonicalize unsigned pred and swap pred and select ops.

define i32 @umax4(i32 %n) {
; CHECK-LABEL: @umax4(
; CHECK-NEXT:    [[T:%.*]] = icmp ult i32 %n, 8
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 8, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp uge i32 %n, 8
  %m = select i1 %t, i32 %n, i32 8
  ret i32 %m
}

; Canonicalize vector unsigned pred and swap pred and select ops.

define <2 x i32> @umax4_vec(<2 x i32> %n) {
; CHECK-LABEL: @umax4_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp ult <2 x i32> %n, <i32 8, i32 8>
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> <i32 8, i32 8>, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp uge <2 x i32> %n, <i32 8, i32 8>
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> <i32 8, i32 8>
  ret <2 x i32> %m
}

; Canonicalize unsigned pred and swap pred and select ops.

define i32 @umin4(i32 %n) {
; CHECK-LABEL: @umin4(
; CHECK-NEXT:    [[T:%.*]] = icmp ugt i32 %n, 9
; CHECK-NEXT:    [[M:%.*]] = select i1 [[T]], i32 9, i32 %n
; CHECK-NEXT:    ret i32 [[M]]
;
  %t = icmp ule i32 %n, 9
  %m = select i1 %t, i32 %n, i32 9
  ret i32 %m
}

; Canonicalize vector unsigned pred and swap pred and select ops.

define <2 x i32> @umin4_vec(<2 x i32> %n) {
; CHECK-LABEL: @umin4_vec(
; CHECK-NEXT:    [[T:%.*]] = icmp ugt <2 x i32> %n, <i32 9, i32 9>
; CHECK-NEXT:    [[M:%.*]] = select <2 x i1> [[T]], <2 x i32> <i32 9, i32 9>, <2 x i32> %n
; CHECK-NEXT:    ret <2 x i32> [[M]]
;
  %t = icmp ule <2 x i32> %n, <i32 9, i32 9>
  %m = select <2 x i1> %t, <2 x i32> %n, <2 x i32> <i32 9, i32 9>
  ret <2 x i32> %m
}

define i64 @smax_sext(i32 %a) {
; CHECK-LABEL: @smax_sext(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[A_EXT]], 0
; CHECK-NEXT:    [[MAX:%.*]] = select i1 [[CMP]], i64 0, i64 [[A_EXT]]
; CHECK-NEXT:    ret i64 [[MAX]]
;
  %a_ext = sext i32 %a to i64
  %cmp = icmp sgt i32 %a, -1
  %max = select i1 %cmp, i64 %a_ext, i64 0
  ret i64 %max
}

define <2 x i64> @smax_sext_vec(<2 x i32> %a) {
; CHECK-LABEL: @smax_sext_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt <2 x i64> [[A_EXT]], zeroinitializer
; CHECK-NEXT:    [[MAX:%.*]] = select <2 x i1> [[CMP]], <2 x i64> zeroinitializer, <2 x i64> [[A_EXT]]
; CHECK-NEXT:    ret <2 x i64> [[MAX]]
;
  %a_ext = sext <2 x i32> %a to <2 x i64>
  %cmp = icmp sgt <2 x i32> %a, <i32 -1, i32 -1>
  %max = select <2 x i1> %cmp, <2 x i64> %a_ext, <2 x i64> zeroinitializer
  ret <2 x i64> %max
}

define i64 @smin_sext(i32 %a) {
; CHECK-LABEL: @smin_sext(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i64 [[A_EXT]], 0
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[CMP]], i64 0, i64 [[A_EXT]]
; CHECK-NEXT:    ret i64 [[MIN]]
;
  %a_ext = sext i32 %a to i64
  %cmp = icmp slt i32 %a, 1
  %min = select i1 %cmp, i64 %a_ext, i64 0
  ret i64 %min
}

define <2 x i64>@smin_sext_vec(<2 x i32> %a) {
; CHECK-LABEL: @smin_sext_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt <2 x i64> [[A_EXT]], zeroinitializer
; CHECK-NEXT:    [[MIN:%.*]] = select <2 x i1> [[CMP]], <2 x i64> zeroinitializer, <2 x i64> [[A_EXT]]
; CHECK-NEXT:    ret <2 x i64> [[MIN]]
;
  %a_ext = sext <2 x i32> %a to <2 x i64>
  %cmp = icmp slt <2 x i32> %a, <i32 1, i32 1>
  %min = select <2 x i1> %cmp, <2 x i64> %a_ext, <2 x i64> zeroinitializer
  ret <2 x i64> %min
}

define i64 @umax_sext(i32 %a) {
; CHECK-LABEL: @umax_sext(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[A_EXT]], 3
; CHECK-NEXT:    [[MAX:%.*]] = select i1 [[CMP]], i64 3, i64 [[A_EXT]]
; CHECK-NEXT:    ret i64 [[MAX]]
;
  %a_ext = sext i32 %a to i64
  %cmp = icmp ugt i32 %a, 2
  %max = select i1 %cmp, i64 %a_ext, i64 3
  ret i64 %max
}

define <2 x i64> @umax_sext_vec(<2 x i32> %a) {
; CHECK-LABEL: @umax_sext_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult <2 x i64> [[A_EXT]], <i64 3, i64 3>
; CHECK-NEXT:    [[MAX:%.*]] = select <2 x i1> [[CMP]], <2 x i64> <i64 3, i64 3>, <2 x i64> [[A_EXT]]
; CHECK-NEXT:    ret <2 x i64> [[MAX]]
;
  %a_ext = sext <2 x i32> %a to <2 x i64>
  %cmp = icmp ugt <2 x i32> %a, <i32 2, i32 2>
  %max = select <2 x i1> %cmp, <2 x i64> %a_ext, <2 x i64> <i64 3, i64 3>
  ret <2 x i64> %max
}

define i64 @umin_sext(i32 %a) {
; CHECK-LABEL: @umin_sext(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i64 [[A_EXT]], 2
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[CMP]], i64 2, i64 [[A_EXT]]
; CHECK-NEXT:    ret i64 [[MIN]]
;
  %a_ext = sext i32 %a to i64
  %cmp = icmp ult i32 %a, 3
  %min = select i1 %cmp, i64 %a_ext, i64 2
  ret i64 %min
}

define <2 x i64> @umin_sext_vec(<2 x i32> %a) {
; CHECK-LABEL: @umin_sext_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt <2 x i64> [[A_EXT]], <i64 2, i64 2>
; CHECK-NEXT:    [[MIN:%.*]] = select <2 x i1> [[CMP]], <2 x i64> <i64 2, i64 2>, <2 x i64> [[A_EXT]]
; CHECK-NEXT:    ret <2 x i64> [[MIN]]
;
  %a_ext = sext <2 x i32> %a to <2 x i64>
  %cmp = icmp ult <2 x i32> %a, <i32 3, i32 3>
  %min = select <2 x i1> %cmp, <2 x i64> %a_ext, <2 x i64> <i64 2, i64 2>
  ret <2 x i64> %min
}

define i64 @umax_sext2(i32 %a) {
; CHECK-LABEL: @umax_sext2(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i64 [[A_EXT]], 2
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[CMP]], i64 [[A_EXT]], i64 2
; CHECK-NEXT:    ret i64 [[MIN]]
;
  %a_ext = sext i32 %a to i64
  %cmp = icmp ult i32 %a, 3
  %min = select i1 %cmp, i64 2, i64 %a_ext
  ret i64 %min
}

define <2 x i64> @umax_sext2_vec(<2 x i32> %a) {
; CHECK-LABEL: @umax_sext2_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt <2 x i64> [[A_EXT]], <i64 2, i64 2>
; CHECK-NEXT:    [[MIN:%.*]] = select <2 x i1> [[CMP]], <2 x i64> [[A_EXT]], <2 x i64> <i64 2, i64 2>
; CHECK-NEXT:    ret <2 x i64> [[MIN]]
;
  %a_ext = sext <2 x i32> %a to <2 x i64>
  %cmp = icmp ult <2 x i32> %a, <i32 3, i32 3>
  %min = select <2 x i1> %cmp, <2 x i64> <i64 2, i64 2>, <2 x i64> %a_ext
  ret <2 x i64> %min
}

define i64 @umin_sext2(i32 %a) {
; CHECK-LABEL: @umin_sext2(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[A_EXT]], 3
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[CMP]], i64 [[A_EXT]], i64 3
; CHECK-NEXT:    ret i64 [[MIN]]
;
  %a_ext = sext i32 %a to i64
  %cmp = icmp ugt i32 %a, 2
  %min = select i1 %cmp, i64 3, i64 %a_ext
  ret i64 %min
}

define <2 x i64> @umin_sext2_vec(<2 x i32> %a) {
; CHECK-LABEL: @umin_sext2_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult <2 x i64> [[A_EXT]], <i64 3, i64 3>
; CHECK-NEXT:    [[MIN:%.*]] = select <2 x i1> [[CMP]], <2 x i64> [[A_EXT]], <2 x i64> <i64 3, i64 3>
; CHECK-NEXT:    ret <2 x i64> [[MIN]]
;
  %a_ext = sext <2 x i32> %a to <2 x i64>
  %cmp = icmp ugt <2 x i32> %a, <i32 2, i32 2>
  %min = select <2 x i1> %cmp, <2 x i64> <i64 3, i64 3>, <2 x i64> %a_ext
  ret <2 x i64> %min
}

define i64 @umax_zext(i32 %a) {
; CHECK-LABEL: @umax_zext(
; CHECK-NEXT:    [[A_EXT:%.*]] = zext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[A_EXT]], 3
; CHECK-NEXT:    [[MAX:%.*]] = select i1 [[CMP]], i64 3, i64 [[A_EXT]]
; CHECK-NEXT:    ret i64 [[MAX]]
;
  %a_ext = zext i32 %a to i64
  %cmp = icmp ugt i32 %a, 2
  %max = select i1 %cmp, i64 %a_ext, i64 3
  ret i64 %max
}

define <2 x i64> @umax_zext_vec(<2 x i32> %a) {
; CHECK-LABEL: @umax_zext_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = zext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult <2 x i64> [[A_EXT]], <i64 3, i64 3>
; CHECK-NEXT:    [[MAX:%.*]] = select <2 x i1> [[CMP]], <2 x i64> <i64 3, i64 3>, <2 x i64> [[A_EXT]]
; CHECK-NEXT:    ret <2 x i64> [[MAX]]
;
  %a_ext = zext <2 x i32> %a to <2 x i64>
  %cmp = icmp ugt <2 x i32> %a, <i32 2, i32 2>
  %max = select <2 x i1> %cmp, <2 x i64> %a_ext, <2 x i64> <i64 3, i64 3>
  ret <2 x i64> %max
}

define i64 @umin_zext(i32 %a) {
; CHECK-LABEL: @umin_zext(
; CHECK-NEXT:    [[A_EXT:%.*]] = zext i32 %a to i64
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i64 [[A_EXT]], 2
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[CMP]], i64 2, i64 [[A_EXT]]
; CHECK-NEXT:    ret i64 [[MIN]]
;
  %a_ext = zext i32 %a to i64
  %cmp = icmp ult i32 %a, 3
  %min = select i1 %cmp, i64 %a_ext, i64 2
  ret i64 %min
}

define <2 x i64> @umin_zext_vec(<2 x i32> %a) {
; CHECK-LABEL: @umin_zext_vec(
; CHECK-NEXT:    [[A_EXT:%.*]] = zext <2 x i32> %a to <2 x i64>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt <2 x i64> [[A_EXT]], <i64 2, i64 2>
; CHECK-NEXT:    [[MIN:%.*]] = select <2 x i1> [[CMP]], <2 x i64> <i64 2, i64 2>, <2 x i64> [[A_EXT]]
; CHECK-NEXT:    ret <2 x i64> [[MIN]]
;
  %a_ext = zext <2 x i32> %a to <2 x i64>
  %cmp = icmp ult <2 x i32> %a, <i32 3, i32 3>
  %min = select <2 x i1> %cmp, <2 x i64> %a_ext, <2 x i64> <i64 2, i64 2>
  ret <2 x i64> %min
}

