; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
;
; Verify that memrchr calls with one or more constant arguments are folded
; as expected.

declare i8* @memrchr(i8*, i32, i64)

@ax = external global [0 x i8]
@a12345 = constant [5 x i8] c"\01\02\03\04\05"
@a123123 = constant [6 x i8] c"\01\02\03\01\02\03"


; Fold memrchr(ax, C, 0) to null.

define i8* @fold_memrchr_ax_c_0(i32 %C) {
; CHECK-LABEL: @fold_memrchr_ax_c_0(
; CHECK-NEXT:    ret i8* null
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 %C, i64 0)
  ret i8* %ret
}


; Fold memrchr(a12345, 3, 0) to null.

define i8* @fold_memrchr_a12345_3_0() {
; CHECK-LABEL: @fold_memrchr_a12345_3_0(
; CHECK-NEXT:    ret i8* null
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 3, i64 0)
  ret i8* %ret
}


; Fold memrchr(a12345, 1, 1) to a12345.

define i8* @fold_memrchr_a12345_1_1() {
; CHECK-LABEL: @fold_memrchr_a12345_1_1(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0)
;
  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 1, i64 1)
  ret i8* %ret
}


; Fold memrchr(a12345, 5, 1) to null.

define i8* @fold_memrchr_a12345_5_1() {
; CHECK-LABEL: @fold_memrchr_a12345_5_1(
; CHECK-NEXT:    ret i8* null
;
  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 5, i64 1)
  ret i8* %ret
}


; Fold memrchr(a123123, 1, 1) to a123123.

define i8* @fold_memrchr_a123123_1_1() {
; CHECK-LABEL: @fold_memrchr_a123123_1_1(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([6 x i8], [6 x i8]* @a123123, i64 0, i64 0)
;
  %ptr = getelementptr [6 x i8], [6 x i8]* @a123123, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 1, i64 1)
  ret i8* %ret
}


; Fold memrchr(a123123, 3, 1) to null.

define i8* @fold_memrchr_a123123_3_1() {
; CHECK-LABEL: @fold_memrchr_a123123_3_1(
; CHECK-NEXT:    ret i8* null
;
  %ptr = getelementptr [6 x i8], [6 x i8]* @a123123, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 3, i64 1)
  ret i8* %ret
}


; Fold memrchr(ax, C, 1) to *ax == C ? ax : null.

define i8* @fold_memrchr_ax_c_1(i32 %C) {
; CHECK-LABEL: @fold_memrchr_ax_c_1(
; CHECK-NEXT:    [[MEMRCHR_CHAR0:%.*]] = load i8, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), align 1
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[C:%.*]] to i8
; CHECK-NEXT:    [[MEMRCHR_CHAR0CMP:%.*]] = icmp eq i8 [[MEMRCHR_CHAR0]], [[TMP1]]
; CHECK-NEXT:    [[MEMRCHR_SEL:%.*]] = select i1 [[MEMRCHR_CHAR0CMP]], i8* getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), i8* null
; CHECK-NEXT:    ret i8* [[MEMRCHR_SEL]]
;
  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 %C, i64 1)
  ret i8* %ret
}


; Fold memrchr(a12345, 5, 5) to a12345 + 4.

define i8* @fold_memrchr_a12345_5_5() {
; CHECK-LABEL: @fold_memrchr_a12345_5_5(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(5) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 5, i64 5)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 5, i64 5)
  ret i8* %ret
}


; Fold memrchr(a12345, 5, 4) to null.

define i8* @fold_memrchr_a12345_5_4() {
; CHECK-LABEL: @fold_memrchr_a12345_5_4(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(4) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 5, i64 4)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 5, i64 4)
  ret i8* %ret
}


; Fold memrchr(a12345, 4, 5) to a12345 + 3.

define i8* @fold_memrchr_a12345_4_5() {
; CHECK-LABEL: @fold_memrchr_a12345_4_5(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(5) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 4, i64 5)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 4, i64 5)
  ret i8* %ret
}


; Fold memrchr(a12345 + 1, 1, 4) to null.

define i8* @fold_memrchr_a12345p1_1_4() {
; CHECK-LABEL: @fold_memrchr_a12345p1_1_4(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(4) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 1), i32 5, i64 4)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 1
  %ret = call i8* @memrchr(i8* %ptr, i32 5, i64 4)
  ret i8* %ret
}


; Fold memrchr(a12345, 2, 5) to a12345 + 1.

define i8* @fold_memrchr_a12345_2_5() {
; CHECK-LABEL: @fold_memrchr_a12345_2_5(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(5) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 2, i64 5)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 2, i64 5)
  ret i8* %ret
}


; Fold memrchr(a12345, 0, %N) to null.

define i8* @fold_memrchr_a12345_0_n(i64 %N) {
; CHECK-LABEL: @fold_memrchr_a12345_0_n(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 0, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 0, i64 %N)
  ret i8* %ret
}


; Fold memrchr(a123123, 3, 5) to a123123 + 2.

define i8* @fold_memrchr_a123123_3_5() {
; CHECK-LABEL: @fold_memrchr_a123123_3_5(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(5) getelementptr inbounds ([6 x i8], [6 x i8]* @a123123, i64 0, i64 0), i32 3, i64 5)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [6 x i8], [6 x i8]* @a123123, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 3, i64 5)
  ret i8* %ret
}


; Fold memrchr(a123123, 3, 6) to a123123 + 5.

define i8* @fold_memrchr_a123123_3_6() {
; CHECK-LABEL: @fold_memrchr_a123123_3_6(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @a123123, i64 0, i64 0), i32 3, i64 6)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [6 x i8], [6 x i8]* @a123123, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 3, i64 6)
  ret i8* %ret
}

; Fold memrchr(a123123, 2, 6) to a123123 + 4.

define i8* @fold_memrchr_a123123_2_6() {
; CHECK-LABEL: @fold_memrchr_a123123_2_6(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @a123123, i64 0, i64 0), i32 2, i64 6)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [6 x i8], [6 x i8]* @a123123, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 2, i64 6)
  ret i8* %ret
}

; Fold memrchr(a123123, 1, 6) to a123123 + 3.

define i8* @fold_memrchr_a123123_1_6() {
; CHECK-LABEL: @fold_memrchr_a123123_1_6(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @a123123, i64 0, i64 0), i32 1, i64 6)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [6 x i8], [6 x i8]* @a123123, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 1, i64 6)
  ret i8* %ret
}


; Fold memrchr(a123123, 0, 6) to null.

define i8* @fold_memrchr_a123123_0_6() {
; CHECK-LABEL: @fold_memrchr_a123123_0_6(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @a123123, i64 0, i64 0), i32 0, i64 6)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [6 x i8], [6 x i8]* @a123123, i32 0, i32 0
  %ret = call i8* @memrchr(i8* %ptr, i32 0, i64 6)
  ret i8* %ret
}
