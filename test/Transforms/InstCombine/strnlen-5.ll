; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Verify that equality tests of strnlen calls against zero are folded
; correctly.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare i64 @strnlen(i8*, i64)

@ax = external global [0 x i8]
@a5 = external global [5 x i8]
@s5 = constant [6 x i8] c"12345\00"


; Fold strnlen(ax, 0) == 0 to true.

define i1 @fold_strnlen_ax_0_eqz() {
; CHECK-LABEL: @fold_strnlen_ax_0_eqz(
; CHECK-NEXT:    ret i1 true
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 0)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}


; Fold strnlen(ax, 0) > 0 to false.

define i1 @fold_strnlen_ax_0_gtz() {
; CHECK-LABEL: @fold_strnlen_ax_0_gtz(
; CHECK-NEXT:    ret i1 false
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 0)
  %gtz = icmp ugt i64 %len, 0
  ret i1 %gtz
}


; Fold strnlen(ax, 1) == 0 to *ax == 0.

define i1 @fold_strnlen_ax_1_eqz() {
; CHECK-LABEL: @fold_strnlen_ax_1_eqz(
; CHECK-NEXT:    [[CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[EQZ:%.*]] = icmp eq i8 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[EQZ]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 1)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}


; Likewise, fold strnlen(ax, 1) < 1 to *ax == 0.

define i1 @fold_strnlen_ax_1_lt1() {
; CHECK-LABEL: @fold_strnlen_ax_1_lt1(
; CHECK-NEXT:    [[STRNLEN_CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[STRNLEN_CHAR0CMP_NOT:%.*]] = icmp eq i8 [[STRNLEN_CHAR0]], 0
; CHECK-NEXT:    ret i1 [[STRNLEN_CHAR0CMP_NOT]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 1)
  %nez = icmp ult i64 %len, 1
  ret i1 %nez
}


; Fold strnlen(ax, 1) != 0 to *ax != 0.

define i1 @fold_strnlen_ax_1_neqz() {
; CHECK-LABEL: @fold_strnlen_ax_1_neqz(
; CHECK-NEXT:    [[CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[NEZ:%.*]] = icmp ne i8 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[NEZ]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 1)
  %nez = icmp ne i64 %len, 0
  ret i1 %nez
}


; Likewise, fold strnlen(ax, 1) > 0 to *ax != 0.

define i1 @fold_strnlen_ax_1_gtz() {
; CHECK-LABEL: @fold_strnlen_ax_1_gtz(
; CHECK-NEXT:    [[STRNLEN_CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[STRNLEN_CHAR0CMP:%.*]] = icmp ne i8 [[STRNLEN_CHAR0]], 0
; CHECK-NEXT:    ret i1 [[STRNLEN_CHAR0CMP]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 1)
  %nez = icmp ugt i64 %len, 0
  ret i1 %nez
}


; Fold strnlen(ax, 9) == 0 to *ax == 0.

define i1 @fold_strnlen_ax_9_eqz() {
; CHECK-LABEL: @fold_strnlen_ax_9_eqz(
; CHECK-NEXT:    [[CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[EQZ:%.*]] = icmp eq i8 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[EQZ]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 9)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}


; Do not fold strnlen(ax, n) == 0 for n that might be zero.

define i1 @call_strnlen_ax_n_eqz(i64 %n) {
; CHECK-LABEL: @call_strnlen_ax_n_eqz(
; CHECK-NEXT:    [[LEN:%.*]] = tail call i64 @strnlen(i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), i64 [[N:%.*]])
; CHECK-NEXT:    [[EQZ:%.*]] = icmp eq i64 [[LEN]], 0
; CHECK-NEXT:    ret i1 [[EQZ]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 %n)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}


; Fold strnlen(ax, n) == 0 to *ax == 0 for %0 that's not zero.

define i1 @fold_strnlen_ax_nz_eqz(i64 %n) {
; CHECK-LABEL: @fold_strnlen_ax_nz_eqz(
; CHECK-NEXT:    [[CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[EQZ:%.*]] = icmp eq i8 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[EQZ]]
;

  %max = or i64 %n, 1
  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 %max)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}


; Fold strnlen(ax, n) > 0 to *ax != 0 for n that's not zero.

define i1 @fold_strnlen_ax_nz_gtz(i64 %n) {
; CHECK-LABEL: @fold_strnlen_ax_nz_gtz(
; CHECK-NEXT:    [[CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[GTZ:%.*]] = icmp ne i8 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[GTZ]]
;

  %max = or i64 %n, 1
  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i64 0, i64 0
  %len = tail call i64 @strnlen(i8* %ptr, i64 %max)
  %gtz = icmp ugt i64 %len, 0
  ret i1 %gtz
}


; Fold strnlen(a5 + i, n) == 0 to a5[i] == 0 for a nonconstant a5
; and a nonzero n.

define i1 @fold_strnlen_a5_pi_nz_eqz(i64 %i, i64 %n) {
; CHECK-LABEL: @fold_strnlen_a5_pi_nz_eqz(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [5 x i8], [5 x i8]* @a5, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[CHAR0:%.*]] = load i8, i8* [[PTR]], align 1
; CHECK-NEXT:    [[EQZ:%.*]] = icmp eq i8 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[EQZ]]
;

  %nz = or i64 %n, 1
  %ptr = getelementptr inbounds [5 x i8], [5 x i8]* @a5, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 %nz)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}


; Fold strnlen(s5 + i, n) == 0 for a constant s5 and nonzero n.
; This is first folded to s5[i] == 0 like the above and then finally
; to %0 == 5.

define i1 @fold_strnlen_s5_pi_nz_eqz(i64 %i, i64 %n) {
; CHECK-LABEL: @fold_strnlen_s5_pi_nz_eqz(
; CHECK-NEXT:    [[EQZ:%.*]] = icmp eq i64 [[I:%.*]], 5
; CHECK-NEXT:    ret i1 [[EQZ]]
;

  %nz = or i64 %n, 1
  %ptr = getelementptr inbounds [6 x i8], [6 x i8]* @s5, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 %nz)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}


; Do not fold strnlen(s5 + i, n) for a constant s5 when n might be zero.

define i1 @call_strnlen_s5_pi_n_eqz(i64 %i, i64 %n) {
; CHECK-LABEL: @call_strnlen_s5_pi_n_eqz(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr inbounds [6 x i8], [6 x i8]* @s5, i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[LEN:%.*]] = call i64 @strnlen(i8* nonnull [[PTR]], i64 [[N:%.*]])
; CHECK-NEXT:    [[EQZ:%.*]] = icmp eq i64 [[LEN]], 0
; CHECK-NEXT:    ret i1 [[EQZ]]
;

  %ptr = getelementptr inbounds [6 x i8], [6 x i8]* @s5, i64 0, i64 %i
  %len = call i64 @strnlen(i8* %ptr, i64 %n)
  %eqz = icmp eq i64 %len, 0
  ret i1 %eqz
}
