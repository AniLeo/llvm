; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -instcombine-infinite-loop-threshold=2 -S | FileCheck %s

define i8 @single(i32 %A) {
; CHECK-LABEL: @single(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i32 [[A:%.*]], -128
; CHECK-NEXT:    [[CONV71:%.*]] = select i1 [[TMP0]], i32 [[A]], i32 -128
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[CONV71]] to i8
; CHECK-NEXT:    ret i8 [[TMP1]]
;
entry:
  %l1 = icmp slt i32 %A, -128
  %l2 = select i1 %l1, i32 128, i32 %A
  %conv7 = trunc i32 %l2 to i8
  ret i8 %conv7
}

define i8 @double(i32 %A) {
; CHECK-LABEL: @double(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i32 [[A:%.*]], -128
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[TMP0]], i32 [[A]], i32 -128
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i32 [[TMP1]], 127
; CHECK-NEXT:    [[CONV71:%.*]] = select i1 [[TMP2]], i32 [[TMP1]], i32 127
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[CONV71]] to i8
; CHECK-NEXT:    ret i8 [[TMP3]]
;
entry:
  %l1 = icmp slt i32 %A, -128
  %l2 = select i1 %l1, i32 128, i32 %A
  %.inv = icmp sgt i32 %A, 127
  %spec.select.i = select i1 %.inv, i32 127, i32 %l2
  %conv7 = trunc i32 %spec.select.i to i8
  ret i8 %conv7
}

define i8 @thisdoesnotloop(i32 %A, i32 %B) {
; CHECK-LABEL: @thisdoesnotloop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L1:%.*]] = icmp slt i32 [[A:%.*]], -128
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i32 [[B:%.*]] to i8
; CHECK-NEXT:    [[CONV7:%.*]] = select i1 [[L1]], i8 -128, i8 [[TMP0]]
; CHECK-NEXT:    ret i8 [[CONV7]]
;
entry:
  %l1 = icmp slt i32 %A, -128
  %l2 = select i1 %l1, i32 128, i32 %B
  %conv7 = trunc i32 %l2 to i8
  ret i8 %conv7
}

define i8 @original(i32 %A, i32 %B) {
; CHECK-LABEL: @original(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[A:%.*]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[A]], i32 -128
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i32 [[TMP2]], 127
; CHECK-NEXT:    [[SPEC_SELECT_I:%.*]] = select i1 [[TMP3]], i32 [[TMP2]], i32 127
; CHECK-NEXT:    [[CONV7:%.*]] = trunc i32 [[SPEC_SELECT_I]] to i8
; CHECK-NEXT:    ret i8 [[CONV7]]
;
  %cmp4.i = icmp slt i32 127, %A
  %cmp6.i = icmp sle i32 -128, %A
  %retval.0.i = select i1 %cmp4.i, i32 127, i32 -128
  %not.cmp4.i = xor i1 %cmp4.i, true
  %cleanup.dest.slot.0.i = and i1 %cmp6.i, %not.cmp4.i
  %spec.select.i = select i1 %cleanup.dest.slot.0.i, i32 %A, i32 %retval.0.i
  %conv7 = trunc i32 %spec.select.i to i8
  ret i8 %conv7
}

define i8 @original_logical(i32 %A, i32 %B) {
; CHECK-LABEL: @original_logical(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[A:%.*]], -128
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[A]], i32 -128
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i32 [[TMP2]], 127
; CHECK-NEXT:    [[SPEC_SELECT_I:%.*]] = select i1 [[TMP3]], i32 [[TMP2]], i32 127
; CHECK-NEXT:    [[CONV7:%.*]] = trunc i32 [[SPEC_SELECT_I]] to i8
; CHECK-NEXT:    ret i8 [[CONV7]]
;
  %cmp4.i = icmp slt i32 127, %A
  %cmp6.i = icmp sle i32 -128, %A
  %retval.0.i = select i1 %cmp4.i, i32 127, i32 -128
  %not.cmp4.i = xor i1 %cmp4.i, true
  %cleanup.dest.slot.0.i = select i1 %cmp6.i, i1 %not.cmp4.i, i1 false
  %spec.select.i = select i1 %cleanup.dest.slot.0.i, i32 %A, i32 %retval.0.i
  %conv7 = trunc i32 %spec.select.i to i8
  ret i8 %conv7
}
