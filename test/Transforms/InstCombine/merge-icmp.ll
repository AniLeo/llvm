; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

declare void @use.i1(i1)
declare void @use.i8(i8)
declare void @use.i16(i16)

define i1 @and_test1(i16* %x) {
; CHECK-LABEL: @and_test1(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 17791
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp eq i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp eq i16 %and, 17664
  %or = and i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @and_test1_logical(i16* %x) {
; CHECK-LABEL: @and_test1_logical(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 17791
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp eq i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp eq i16 %and, 17664
  %or = select i1 %cmp1, i1 %cmp2, i1 false
  ret i1 %or
}

define <2 x i1> @and_test1_vector(<2 x i16>* %x) {
; CHECK-LABEL: @and_test1_vector(
; CHECK-NEXT:    [[LOAD:%.*]] = load <2 x i16>, <2 x i16>* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i16> [[LOAD]], <i16 17791, i16 17791>
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %load = load <2 x i16>, <2 x i16>* %x, align 4
  %trunc = trunc <2 x i16> %load to <2 x i8>
  %cmp1 = icmp eq <2 x i8> %trunc, <i8 127, i8 127>
  %and = and <2 x i16> %load, <i16 -256, i16 -256>
  %cmp2 = icmp eq <2 x i16> %and, <i16 17664, i16 17664>
  %or = and <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %or
}

define i1 @and_test2(i16* %x) {
; CHECK-LABEL: @and_test2(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 32581
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %and = and i16 %load, -256
  %cmp1 = icmp eq i16 %and, 32512
  %trunc = trunc i16 %load to i8
  %cmp2 = icmp eq i8 %trunc, 69
  %or = and i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @and_test2_logical(i16* %x) {
; CHECK-LABEL: @and_test2_logical(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[LOAD]], 32581
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %load = load i16, i16* %x, align 4
  %and = and i16 %load, -256
  %cmp1 = icmp eq i16 %and, 32512
  %trunc = trunc i16 %load to i8
  %cmp2 = icmp eq i8 %trunc, 69
  %or = select i1 %cmp1, i1 %cmp2, i1 false
  ret i1 %or
}

define <2 x i1> @and_test2_vector(<2 x i16>* %x) {
; CHECK-LABEL: @and_test2_vector(
; CHECK-NEXT:    [[LOAD:%.*]] = load <2 x i16>, <2 x i16>* [[X:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i16> [[LOAD]], <i16 32581, i16 32581>
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %load = load <2 x i16>, <2 x i16>* %x, align 4
  %and = and <2 x i16> %load, <i16 -256, i16 -256>
  %cmp1 = icmp eq <2 x i16> %and, <i16 32512, i16 32512>
  %trunc = trunc <2 x i16> %load to <2 x i8>
  %cmp2 = icmp eq <2 x i8> %trunc, <i8 69, i8 69>
  %or = and <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %or
}

define i1 @or_basic(i16 %load) {
; CHECK-LABEL: @or_basic(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -256
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 17664
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp ne i16 %and, 17664
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_basic_commuted(i16 %load) {
; CHECK-LABEL: @or_basic_commuted(
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD:%.*]], -256
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i16 [[AND]], 32512
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD]] to i8
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 [[TRUNC]], 69
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %and = and i16 %load, -256
  %cmp1 = icmp ne i16 %and, 32512
  %trunc = trunc i16 %load to i8
  %cmp2 = icmp ne i8 %trunc, 69
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define <2 x i1> @or_vector(<2 x i16> %load) {
; CHECK-LABEL: @or_vector(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc <2 x i16> [[LOAD:%.*]] to <2 x i8>
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne <2 x i8> [[TRUNC]], <i8 127, i8 127>
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i16> [[LOAD]], <i16 -256, i16 -256>
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne <2 x i16> [[AND]], <i16 17664, i16 17664>
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i1> [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret <2 x i1> [[OR]]
;
  %trunc = trunc <2 x i16> %load to <2 x i8>
  %cmp1 = icmp ne <2 x i8> %trunc, <i8 127, i8 127>
  %and = and <2 x i16> %load, <i16 -256, i16 -256>
  %cmp2 = icmp ne <2 x i16> %and, <i16 17664, i16 17664>
  %or = or <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %or
}

define i1 @or_nontrivial_mask1(i16 %load) {
; CHECK-LABEL: @or_nontrivial_mask1(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], 3840
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 1280
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, 3840
  %cmp2 = icmp ne i16 %and, 1280
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_nontrivial_mask2(i16 %load) {
; CHECK-LABEL: @or_nontrivial_mask2(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -4096
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 20480
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -4096
  %cmp2 = icmp ne i16 %and, 20480
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_extra_use1(i16 %load) {
; CHECK-LABEL: @or_extra_use1(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    call void @use.i1(i1 [[CMP1]])
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -4096
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 20480
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  call void @use.i1(i1 %cmp1)
  %and = and i16 %load, -4096
  %cmp2 = icmp ne i16 %and, 20480
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_extra_use2(i16 %load) {
; CHECK-LABEL: @or_extra_use2(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -4096
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 20480
; CHECK-NEXT:    call void @use.i1(i1 [[CMP2]])
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -4096
  %cmp2 = icmp ne i16 %and, 20480
  call void @use.i1(i1 %cmp2)
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_extra_use3(i16 %load) {
; CHECK-LABEL: @or_extra_use3(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    call void @use.i8(i8 [[TRUNC]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -4096
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 20480
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  call void @use.i8(i8 %trunc)
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -4096
  %cmp2 = icmp ne i16 %and, 20480
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_extra_use4(i16 %load) {
; CHECK-LABEL: @or_extra_use4(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -4096
; CHECK-NEXT:    call void @use.i16(i16 [[AND]])
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 20480
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -4096
  call void @use.i16(i16 %and)
  %cmp2 = icmp ne i16 %and, 20480
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_wrong_pred1(i16 %load) {
; CHECK-LABEL: @or_wrong_pred1(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -256
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 17664
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp eq i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp ne i16 %and, 17664
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_wrong_pred2(i16 %load) {
; CHECK-LABEL: @or_wrong_pred2(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -256
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i16 [[AND]], 17664
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp eq i16 %and, 17664
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_wrong_pred3(i16 %load) {
; CHECK-LABEL: @or_wrong_pred3(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -256
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i16 [[AND]], 17664
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp eq i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp eq i16 %and, 17664
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_wrong_op(i16 %load, i16 %other) {
; CHECK-LABEL: @or_wrong_op(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[OTHER:%.*]], -256
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 17664
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %other, -256
  %cmp2 = icmp ne i16 %and, 17664
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_wrong_const1(i16 %load) {
; CHECK-LABEL: @or_wrong_const1(
; CHECK-NEXT:    ret i1 true
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -256
  %cmp2 = icmp ne i16 %and, 17665
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @or_wrong_const2(i16 %load) {
; CHECK-LABEL: @or_wrong_const2(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i16 [[LOAD:%.*]] to i8
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[TRUNC]], 127
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[LOAD]], -255
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i16 [[AND]], 17665
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %trunc = trunc i16 %load to i8
  %cmp1 = icmp ne i8 %trunc, 127
  %and = and i16 %load, -255
  %cmp2 = icmp ne i16 %and, 17665
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}
