; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Verify that an excessive size to memchr() isn't truncated to an in-bounds
; value that results in the call being incorrectly folded (as might happen
; when LLVM is compiled in ILP32 mode).

declare i8* @memchr(i8*, i32, i64)

@ax = external global [0 x i8]
@a12345 = constant [5 x i8] c"\01\02\03\04\05"


; Do not fold memchr(ax, 1, UINT_MAX + (size_t)1) to null.  Only the first
; byte in ax must be dereferenceable.

define i8* @call_memchr_ax_2_uimax_p1() {
; CHECK-LABEL: @call_memchr_ax_2_uimax_p1(
; CHECK-NEXT:    [[RES:%.*]] = call i8* @memchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), i32 1, i64 4294967296)
; CHECK-NEXT:    ret i8* [[RES]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 1, i64 4294967296)
  ret i8* %res
}


; Do not fold memchr(ax, 1, UINT_MAX + (size_t)2) to *ax == 1 ? ax : null.
; As above, only the first byte in ax must be dereferenceable.

define i8* @call_memchr_ax_2_uimax_p2() {
; CHECK-LABEL: @call_memchr_ax_2_uimax_p2(
; CHECK-NEXT:    [[RES:%.*]] = call i8* @memchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([0 x i8], [0 x i8]* @ax, i64 0, i64 0), i32 1, i64 4294967296)
; CHECK-NEXT:    ret i8* [[RES]]
;

  %ptr = getelementptr [0 x i8], [0 x i8]* @ax, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 1, i64 4294967296)
  ret i8* %res
}


; Fold memchr(a12345, 3, UINT_MAX + (size_t)2) to a12345 + 2 (and not to
; null).

define i8* @fold_memchr_a12345_3_uimax_p2() {
; CHECK-LABEL: @fold_memchr_a12345_3_uimax_p2(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 2)
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 3, i64 4294967297)
  ret i8* %res
}


; Do not fold memchr(a12345, c, UINT_MAX + (size_t)2).

define i8* @fold_memchr_a12345_c_uimax_p2(i32 %0) {
; CHECK-LABEL: @fold_memchr_a12345_c_uimax_p2(
; CHECK-NEXT:    [[RES:%.*]] = call i8* @memchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 [[TMP0:%.*]], i64 4294967297)
; CHECK-NEXT:    ret i8* [[RES]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i32 0, i32 0
  %res = call i8* @memchr(i8* %ptr, i32 %0, i64 4294967297)
  ret i8* %res
}
