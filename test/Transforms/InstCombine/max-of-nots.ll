; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

define i32 @compute_min_2(i32 %x, i32 %y) {
; CHECK-LABEL: @compute_min_2(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i32 %x, %y
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 %x, i32 %y
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %not_x = sub i32 -1, %x
  %not_y = sub i32 -1, %y
  %cmp = icmp sgt i32 %not_x, %not_y
  %not_min = select i1 %cmp, i32 %not_x, i32 %not_y
  %min = sub i32 -1, %not_min
  ret i32 %min
}

define i32 @compute_min_3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @compute_min_3(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i32 %x, %y
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 %x, i32 %y
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i32 [[TMP2]], %z
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP3]], i32 [[TMP2]], i32 %z
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %not_x = sub i32 -1, %x
  %not_y = sub i32 -1, %y
  %not_z = sub i32 -1, %z
  %cmp_1 = icmp sgt i32 %not_x, %not_y
  %not_min_1 = select i1 %cmp_1, i32 %not_x, i32 %not_y
  %cmp_2 = icmp sgt i32 %not_min_1, %not_z
  %not_min_2 = select i1 %cmp_2, i32 %not_min_1, i32 %not_z
  %min = sub i32 -1, %not_min_2
  ret i32 %min
}

; Don't increase the critical path by moving the 'not' op after the 'select'.

define i32 @compute_min_arithmetic(i32 %x, i32 %y) {
; CHECK-LABEL: @compute_min_arithmetic(
; CHECK-NEXT:    [[NOT_VALUE:%.*]] = sub i32 3, %x
; CHECK-NEXT:    [[NOT_Y:%.*]] = xor i32 %y, -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[NOT_VALUE]], [[NOT_Y]]
; CHECK-NEXT:    [[NOT_MIN:%.*]] = select i1 [[CMP]], i32 [[NOT_VALUE]], i32 [[NOT_Y]]
; CHECK-NEXT:    ret i32 [[NOT_MIN]]
;
  %not_value = sub i32 3, %x
  %not_y = sub i32 -1, %y
  %cmp = icmp sgt i32 %not_value, %not_y
  %not_min = select i1 %cmp, i32 %not_value, i32 %not_y
  ret i32 %not_min
}

declare void @fake_use(i32)

define i32 @compute_min_pessimization(i32 %x, i32 %y) {
; CHECK-LABEL: @compute_min_pessimization(
; CHECK-NEXT:    [[NOT_VALUE:%.*]] = sub i32 3, %x
; CHECK-NEXT:    call void @fake_use(i32 [[NOT_VALUE]])
; CHECK-NEXT:    [[NOT_Y:%.*]] = xor i32 %y, -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[NOT_VALUE]], [[NOT_Y]]
; CHECK-NEXT:    [[NOT_MIN:%.*]] = select i1 [[CMP]], i32 [[NOT_VALUE]], i32 [[NOT_Y]]
; CHECK-NEXT:    [[MIN:%.*]] = xor i32 [[NOT_MIN]], -1
; CHECK-NEXT:    ret i32 [[MIN]]
;
  %not_value = sub i32 3, %x
  call void @fake_use(i32 %not_value)
  %not_y = sub i32 -1, %y
  %cmp = icmp sgt i32 %not_value, %not_y
  %not_min = select i1 %cmp, i32 %not_value, i32 %not_y
  %min = sub i32 -1, %not_min
  ret i32 %min
}

define i32 @max_of_nots(i32 %x, i32 %y) {
; CHECK-LABEL: @max_of_nots(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 %y, 0
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 %y, i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i32 [[TMP2]], %x
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP3]], i32 [[TMP2]], i32 %x
; CHECK-NEXT:    [[TMP5:%.*]] = xor i32 [[TMP4]], -1
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %c0 = icmp sgt i32 %y, 0
  %xor_y = xor i32 %y, -1
  %s0 = select i1 %c0, i32 %xor_y, i32 -1
  %xor_x = xor i32 %x, -1
  %c1 = icmp slt i32 %s0, %xor_x
  %smax96 = select i1 %c1, i32 %xor_x, i32 %s0
  ret i32 %smax96
}

 ; negative test case (i.e. can not simplify) : ABS(MIN(NOT x,y))
define i32 @abs_of_min_of_not(i32 %x, i32 %y) {
; CHECK-LABEL: @abs_of_min_of_not(
; CHECK-NEXT:    [[XORD:%.*]] = xor i32 %x, -1
; CHECK-NEXT:    [[YADD:%.*]] = add i32 %y, 2
; CHECK-NEXT:    [[COND_I:%.*]] = icmp slt i32 [[YADD]], [[XORD]]
; CHECK-NEXT:    [[MIN:%.*]] = select i1 [[COND_I]], i32 [[YADD]], i32 [[XORD]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[MIN]], -1
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[MIN]]
; CHECK-NEXT:    [[ABS:%.*]] = select i1 [[CMP2]], i32 [[MIN]], i32 [[SUB]]
; CHECK-NEXT:    ret i32 [[ABS]]
;

  %xord = xor i32 %x, -1
  %yadd = add i32 %y, 2
  %cond.i = icmp sge i32 %yadd, %xord
  %min = select i1 %cond.i, i32 %xord, i32 %yadd
  %cmp2 = icmp sgt i32 %min, -1
  %sub = sub i32 0, %min
  %abs = select i1 %cmp2, i32 %min, i32 %sub
  ret i32  %abs
}

define <2 x i32> @max_of_nots_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @max_of_nots_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <2 x i32> %y, zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = select <2 x i1> [[TMP1]], <2 x i32> %y, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt <2 x i32> [[TMP2]], %x
; CHECK-NEXT:    [[TMP4:%.*]] = select <2 x i1> [[TMP3]], <2 x i32> [[TMP2]], <2 x i32> %x
; CHECK-NEXT:    [[TMP5:%.*]] = xor <2 x i32> [[TMP4]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %c0 = icmp sgt <2 x i32> %y, zeroinitializer
  %xor_y = xor <2 x i32> %y, <i32 -1, i32 -1>
  %s0 = select <2 x i1> %c0, <2 x i32> %xor_y, <2 x i32> <i32 -1, i32 -1>
  %xor_x = xor <2 x i32> %x, <i32 -1, i32 -1>
  %c1 = icmp slt <2 x i32> %s0, %xor_x
  %smax96 = select <2 x i1> %c1, <2 x i32> %xor_x, <2 x i32> %s0
  ret <2 x i32> %smax96
}

define <2 x i37> @max_of_nots_weird_type_vec(<2 x i37> %x, <2 x i37> %y) {
; CHECK-LABEL: @max_of_nots_weird_type_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <2 x i37> %y, zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = select <2 x i1> [[TMP1]], <2 x i37> %y, <2 x i37> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt <2 x i37> [[TMP2]], %x
; CHECK-NEXT:    [[TMP4:%.*]] = select <2 x i1> [[TMP3]], <2 x i37> [[TMP2]], <2 x i37> %x
; CHECK-NEXT:    [[TMP5:%.*]] = xor <2 x i37> [[TMP4]], <i37 -1, i37 -1>
; CHECK-NEXT:    ret <2 x i37> [[TMP5]]
;
  %c0 = icmp sgt <2 x i37> %y, zeroinitializer
  %xor_y = xor <2 x i37> %y, <i37 -1, i37 -1>
  %s0 = select <2 x i1> %c0, <2 x i37> %xor_y, <2 x i37> <i37 -1, i37 -1>
  %xor_x = xor <2 x i37> %x, <i37 -1, i37 -1>
  %c1 = icmp slt <2 x i37> %s0, %xor_x
  %smax96 = select <2 x i1> %c1, <2 x i37> %xor_x, <2 x i37> %s0
  ret <2 x i37> %smax96
}

; max(min(%a, -1), -1) == -1
define i32 @max_of_min(i32 %a) {
; CHECK-LABEL: @max_of_min(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp sgt i32 %a, 0
  %s0 = select i1 %c0, i32 %not_a, i32 -1
  %c1 = icmp sgt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

; max(min(%a, -1), -1) == -1 (swap predicate and select ops)
define i32 @max_of_min_swap(i32 %a) {
; CHECK-LABEL: @max_of_min_swap(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp slt i32 %a, 0
  %s0 = select i1 %c0, i32 -1, i32 %not_a
  %c1 = icmp sgt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

; min(max(%a, -1), -1) == -1
define i32 @min_of_max(i32 %a) {
; CHECK-LABEL: @min_of_max(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp slt i32 %a, 0
  %s0 = select i1 %c0, i32 %not_a, i32 -1
  %c1 = icmp slt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

; min(max(%a, -1), -1) == -1 (swap predicate and select ops)
define i32 @min_of_max_swap(i32 %a) {
; CHECK-LABEL: @min_of_max_swap(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp sgt i32 %a, 0
  %s0 = select i1 %c0, i32 -1, i32 %not_a
  %c1 = icmp slt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

define <2 x i32> @max_of_min_vec(<2 x i32> %a) {
; CHECK-LABEL: @max_of_min_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 -1, i32 -1>
;
  %not_a = xor <2 x i32> %a, <i32 -1, i32 -1>
  %c0 = icmp sgt <2 x i32> %a, zeroinitializer
  %s0 = select <2 x i1> %c0, <2 x i32> %not_a, <2 x i32> <i32 -1, i32 -1>
  %c1 = icmp sgt <2 x i32> %s0, <i32 -1, i32 -1>
  %s1 = select <2 x i1> %c1, <2 x i32> %s0, <2 x i32> <i32 -1, i32 -1>
  ret <2 x i32> %s1
}

