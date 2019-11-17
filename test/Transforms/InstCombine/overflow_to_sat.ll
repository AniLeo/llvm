; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

define i32 @uadd(i32 %x, i32 %y) {
; CHECK-LABEL: @uadd(
; CHECK-NEXT:    [[S:%.*]] = call i32 @llvm.uadd.sat.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    ret i32 [[S]]
;
  %ao = tail call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x, i32 %y)
  %o = extractvalue { i32, i1 } %ao, 1
  %a = extractvalue { i32, i1 } %ao, 0
  %s = select i1 %o, i32 -1, i32 %a
  ret i32 %s
}

define i32 @usub(i32 %x, i32 %y) {
; CHECK-LABEL: @usub(
; CHECK-NEXT:    [[S:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    ret i32 [[S]]
;
  %ao = tail call { i32, i1 } @llvm.usub.with.overflow.i32(i32 %x, i32 %y)
  %o = extractvalue { i32, i1 } %ao, 1
  %a = extractvalue { i32, i1 } %ao, 0
  %s = select i1 %o, i32 0, i32 %a
  ret i32 %s
}


define i8 @sadd_x_lt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_lt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_x_lt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_lt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_x_le_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_le_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_x_le_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_le_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_x_gt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_gt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_x_gt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_gt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_x_ge_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_ge_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_x_ge_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_x_ge_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}


define i8 @sadd_y_lt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_lt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_y_lt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_lt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_y_le_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_le_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_y_le_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_le_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_y_gt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_gt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_y_gt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_gt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_y_ge_min(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_ge_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @sadd_y_ge_max(i8 %x, i8 %y) {
; CHECK-LABEL: @sadd_y_ge_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}




define i8 @ssub_x_lt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_lt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_lt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_lt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_le_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_le_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_le_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_le_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_lt2_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_lt2_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %x, -1
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_lt2_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_lt2_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[X]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %x, -1
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_gt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_gt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_gt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_gt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_ge_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_ge_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %x, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_ge_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_ge_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %x, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_gt2_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_gt2_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], -2
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %x, -2
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_x_gt2_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_x_gt2_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[X]], -2
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %x, -2
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}


define i8 @ssub_y_lt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_lt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_y_lt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_lt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp slt i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_y_le_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_le_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_y_le_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_le_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[Y]], 1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sle i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_y_gt_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_gt_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_y_gt_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_gt_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sgt i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_y_ge_min(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_ge_min(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 127, i8 -128
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %y, 0
  %s = select i1 %c, i8 127, i8 -128
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}

define i8 @ssub_y_ge_max(i8 %x, i8 %y) {
; CHECK-LABEL: @ssub_y_ge_max(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i8, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i8, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[Y]], -1
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i8 -128, i8 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i8 [[S]], i8 [[A]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %ao = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 %y)
  %o = extractvalue { i8, i1 } %ao, 1
  %a = extractvalue { i8, i1 } %ao, 0
  %c = icmp sge i8 %y, 0
  %s = select i1 %c, i8 -128, i8 127
  %r = select i1 %o, i8 %s, i8 %a
  ret i8 %r
}


define i32 @sadd_i32(i32 %x, i32 %y) {
; CHECK-LABEL: @sadd_i32(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i32, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i32, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i32 -2147483648, i32 2147483647
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i32 [[S]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %ao = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %x, i32 %y)
  %o = extractvalue { i32, i1 } %ao, 1
  %a = extractvalue { i32, i1 } %ao, 0
  %c = icmp slt i32 %x, 0
  %s = select i1 %c, i32 -2147483648, i32 2147483647
  %r = select i1 %o, i32 %s, i32 %a
  ret i32 %r
}

define i32 @ssub_i32(i32 %x, i32 %y) {
; CHECK-LABEL: @ssub_i32(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i32, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i32, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i32 -2147483648, i32 2147483647
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i32 [[S]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %ao = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %x, i32 %y)
  %o = extractvalue { i32, i1 } %ao, 1
  %a = extractvalue { i32, i1 } %ao, 0
  %c = icmp slt i32 %x, 0
  %s = select i1 %c, i32 -2147483648, i32 2147483647
  %r = select i1 %o, i32 %s, i32 %a
  ret i32 %r
}

define i32 @sadd_bounds(i32 %x, i32 %y) {
; CHECK-LABEL: @sadd_bounds(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i32, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i32, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i32 -128, i32 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i32 [[S]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %ao = tail call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %x, i32 %y)
  %o = extractvalue { i32, i1 } %ao, 1
  %a = extractvalue { i32, i1 } %ao, 0
  %c = icmp slt i32 %x, 0
  %s = select i1 %c, i32 -128, i32 127
  %r = select i1 %o, i32 %s, i32 %a
  ret i32 %r
}

define i32 @ssub_bounds(i32 %x, i32 %y) {
; CHECK-LABEL: @ssub_bounds(
; CHECK-NEXT:    [[AO:%.*]] = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[O:%.*]] = extractvalue { i32, i1 } [[AO]], 1
; CHECK-NEXT:    [[A:%.*]] = extractvalue { i32, i1 } [[AO]], 0
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X]], 0
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C]], i32 -128, i32 127
; CHECK-NEXT:    [[R:%.*]] = select i1 [[O]], i32 [[S]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %ao = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %x, i32 %y)
  %o = extractvalue { i32, i1 } %ao, 1
  %a = extractvalue { i32, i1 } %ao, 0
  %c = icmp slt i32 %x, 0
  %s = select i1 %c, i32 -128, i32 127
  %r = select i1 %o, i32 %s, i32 %a
  ret i32 %r
}

declare { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %0, i32 %1)
declare { i32, i1 } @llvm.usub.with.overflow.i32(i32 %0, i32 %1)
declare { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %0, i8 %1)
declare { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %0, i8 %1)
declare { i32, i1 } @llvm.sadd.with.overflow.i32(i32 %0, i32 %1)
declare { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %0, i32 %1)
