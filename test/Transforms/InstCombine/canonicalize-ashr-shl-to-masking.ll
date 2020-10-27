; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=37603
; https://reviews.llvm.org/D46760#1123713

; Pattern:
;   x >> y << y
; Should be transformed into:
;   x & (-1 << y)

; ============================================================================ ;
; Basic positive tests
; ============================================================================ ;

define i8 @positive_samevar(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = and i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, %y
  %ret = shl i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst(i8 %x) {
; CHECK-LABEL: @positive_sameconst(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X:%.*]], -8
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr(i8 %x) {
; CHECK-LABEL: @positive_biggerashr(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], 6
; CHECK-NEXT:    [[RET:%.*]] = shl nsw i8 [[TMP0]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 6
  %ret = shl i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl(i8 %x) {
; CHECK-LABEL: @positive_biggershl(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i8 [[X:%.*]], 3
; CHECK-NEXT:    [[RET:%.*]] = shl i8 [[TMP1]], 6
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; shl nuw
; ============================================================================ ;

define i8 @positive_samevar_shlnuw(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar_shlnuw(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = and i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, %y
  %ret = shl nuw i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst_shlnuw(i8 %x) {
; CHECK-LABEL: @positive_sameconst_shlnuw(
; CHECK-NEXT:    [[RET:%.*]] = and i8 [[X:%.*]], -8
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl nuw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_shlnuw(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_shlnuw(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], 6
; CHECK-NEXT:    [[RET:%.*]] = shl nuw nsw i8 [[TMP0]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 6
  %ret = shl nuw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_shlnuw(i8 %x) {
; CHECK-LABEL: @positive_biggershl_shlnuw(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], 3
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[TMP0]], 6
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl nuw i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; shl nsw
; ============================================================================ ;

define i8 @positive_samevar_shlnsw(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar_shlnsw(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = and i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, %y
  %ret = shl nsw i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst_shlnsw(i8 %x) {
; CHECK-LABEL: @positive_sameconst_shlnsw(
; CHECK-NEXT:    [[RET:%.*]] = and i8 [[X:%.*]], -8
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_shlnsw(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_shlnsw(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], 6
; CHECK-NEXT:    [[RET:%.*]] = shl nsw i8 [[TMP0]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 6
  %ret = shl nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_shlnsw(i8 %x) {
; CHECK-LABEL: @positive_biggershl_shlnsw(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], 3
; CHECK-NEXT:    [[RET:%.*]] = shl nsw i8 [[TMP0]], 6
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl nsw i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; shl nuw nsw
; ============================================================================ ;

define i8 @positive_samevar_shlnuwnsw(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar_shlnuwnsw(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = and i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, %y
  %ret = shl nuw nsw i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst_shlnuwnsw(i8 %x) {
; CHECK-LABEL: @positive_sameconst_shlnuwnsw(
; CHECK-NEXT:    [[RET:%.*]] = and i8 [[X:%.*]], -8
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl nuw nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_shlnuwnsw(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_shlnuwnsw(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], 6
; CHECK-NEXT:    [[RET:%.*]] = shl nuw nsw i8 [[TMP0]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 6
  %ret = shl nuw nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_shlnuwnsw(i8 %x) {
; CHECK-LABEL: @positive_biggershl_shlnuwnsw(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], 3
; CHECK-NEXT:    [[RET:%.*]] = shl nuw nsw i8 [[TMP0]], 6
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, 3
  %ret = shl nuw nsw i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; ashr exact
; ============================================================================ ;

define i8 @positive_samevar_ashrexact(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, %y
  %ret = shl i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_sameconst_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = ashr exact i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 6
  %ret = shl i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggershl_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = shl i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; ashr exact, shl nsw
; ============================================================================ ;

define i8 @positive_samevar_shlnsw_ashrexact(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar_shlnsw_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, %y
  %ret = shl nsw i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst_shlnsw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_sameconst_shlnsw_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_shlnsw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_shlnsw_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = ashr exact i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 6
  %ret = shl nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_shlnsw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggershl_shlnsw_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = shl nsw i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl nsw i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; ashr exact, shl nuw
; ============================================================================ ;

define i8 @positive_samevar_shlnuw_ashrexact(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar_shlnuw_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, %y
  %ret = shl nuw i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst_shlnuw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_sameconst_shlnuw_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl nuw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_shlnuw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_shlnuw_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = ashr exact i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 6
  %ret = shl nuw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_shlnuw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggershl_shlnuw_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl nuw i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; ashr exact, shl nuw nsw
; ============================================================================ ;

define i8 @positive_samevar_shlnuwnsw_ashrexact(i8 %x, i8 %y) {
; CHECK-LABEL: @positive_samevar_shlnuwnsw_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, %y
  %ret = shl nuw nsw i8 %tmp0, %y
  ret i8 %ret
}

define i8 @positive_sameconst_shlnuwnsw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_sameconst_shlnuwnsw_ashrexact(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl nuw nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_shlnuwnsw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_shlnuwnsw_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = ashr exact i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 6
  %ret = shl nuw nsw i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_shlnuwnsw_ashrexact(i8 %x) {
; CHECK-LABEL: @positive_biggershl_shlnuwnsw_ashrexact(
; CHECK-NEXT:    [[RET:%.*]] = shl nuw nsw i8 [[X:%.*]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 3
  %ret = shl nuw nsw i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; Vector
; ============================================================================ ;

define <2 x i8> @positive_samevar_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @positive_samevar_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i8> <i8 -1, i8 -1>, [[Y:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = and <2 x i8> [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[RET]]
;
  %tmp0 = ashr <2 x i8> %x, %y
  %ret = shl <2 x i8> %tmp0, %y
  ret <2 x i8> %ret
}

; ============================================================================ ;
; Constant Vectors
; ============================================================================ ;

define <2 x i8> @positive_sameconst_vec(<2 x i8> %x) {
; CHECK-LABEL: @positive_sameconst_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i8> [[X:%.*]], <i8 -8, i8 -8>
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %tmp0 = ashr <2 x i8> %x, <i8 3, i8 3>
  %ret = shl <2 x i8> %tmp0, <i8 3, i8 3>
  ret <2 x i8> %ret
}

define <3 x i8> @positive_sameconst_vec_undef0(<3 x i8> %x) {
; CHECK-LABEL: @positive_sameconst_vec_undef0(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 3, i8 undef, i8 3>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 3, i8 3, i8 3>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 3, i8 undef, i8 3>
  %ret = shl <3 x i8> %tmp0, <i8 3, i8 3, i8 3>
  ret <3 x i8> %ret
}

define <3 x i8> @positive_sameconst_vec_undef1(<3 x i8> %x) {
; CHECK-LABEL: @positive_sameconst_vec_undef1(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 3, i8 3, i8 3>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 3, i8 undef, i8 3>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 3, i8 3, i8 3>
  %ret = shl <3 x i8> %tmp0, <i8 3, i8 undef, i8 3>
  ret <3 x i8> %ret
}

define <3 x i8> @positive_sameconst_vec_undef2(<3 x i8> %x) {
; CHECK-LABEL: @positive_sameconst_vec_undef2(
; CHECK-NEXT:    [[RET:%.*]] = and <3 x i8> [[X:%.*]], <i8 -8, i8 undef, i8 -8>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 3, i8 undef, i8 3>
  %ret = shl <3 x i8> %tmp0, <i8 3, i8 undef, i8 3>
  ret <3 x i8> %ret
}

define <2 x i8> @positive_biggerashr_vec(<2 x i8> %x) {
; CHECK-LABEL: @positive_biggerashr_vec(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <2 x i8> [[X:%.*]], <i8 6, i8 6>
; CHECK-NEXT:    [[RET:%.*]] = shl nsw <2 x i8> [[TMP0]], <i8 3, i8 3>
; CHECK-NEXT:    ret <2 x i8> [[RET]]
;
  %tmp0 = ashr <2 x i8> %x, <i8 6, i8 6>
  %ret = shl <2 x i8> %tmp0, <i8 3, i8 3>
  ret <2 x i8> %ret
}

define <3 x i8> @positive_biggerashr_vec_undef0(<3 x i8> %x) {
; CHECK-LABEL: @positive_biggerashr_vec_undef0(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 6, i8 undef, i8 6>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 3, i8 3, i8 3>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 6, i8 undef, i8 6>
  %ret = shl <3 x i8> %tmp0, <i8 3, i8 3, i8 3>
  ret <3 x i8> %ret
}

define <3 x i8> @positive_biggerashr_vec_undef1(<3 x i8> %x) {
; CHECK-LABEL: @positive_biggerashr_vec_undef1(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 6, i8 6, i8 6>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 3, i8 undef, i8 3>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 6, i8 6, i8 6>
  %ret = shl <3 x i8> %tmp0, <i8 3, i8 undef, i8 3>
  ret <3 x i8> %ret
}

define <3 x i8> @positive_biggerashr_vec_undef2(<3 x i8> %x) {
; CHECK-LABEL: @positive_biggerashr_vec_undef2(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 6, i8 undef, i8 6>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 3, i8 undef, i8 3>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 6, i8 undef, i8 6>
  %ret = shl <3 x i8> %tmp0, <i8 3, i8 undef, i8 3>
  ret <3 x i8> %ret
}

define <2 x i8> @positive_biggershl_vec(<2 x i8> %x) {
; CHECK-LABEL: @positive_biggershl_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i8> [[X:%.*]], <i8 3, i8 3>
; CHECK-NEXT:    [[RET:%.*]] = shl <2 x i8> [[TMP1]], <i8 6, i8 6>
; CHECK-NEXT:    ret <2 x i8> [[RET]]
;
  %tmp0 = ashr <2 x i8> %x, <i8 3, i8 3>
  %ret = shl <2 x i8> %tmp0, <i8 6, i8 6>
  ret <2 x i8> %ret
}

define <3 x i8> @positive_biggershl_vec_undef0(<3 x i8> %x) {
; CHECK-LABEL: @positive_biggershl_vec_undef0(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 3, i8 undef, i8 3>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 6, i8 6, i8 6>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 3, i8 undef, i8 3>
  %ret = shl <3 x i8> %tmp0, <i8 6, i8 6, i8 6>
  ret <3 x i8> %ret
}

define <3 x i8> @positive_biggershl_vec_undef1(<3 x i8> %x) {
; CHECK-LABEL: @positive_biggershl_vec_undef1(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 3, i8 3, i8 3>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 6, i8 undef, i8 6>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 3, i8 3, i8 3>
  %ret = shl <3 x i8> %tmp0, <i8 6, i8 undef, i8 6>
  ret <3 x i8> %ret
}

define <3 x i8> @positive_biggershl_vec_undef2(<3 x i8> %x) {
; CHECK-LABEL: @positive_biggershl_vec_undef2(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <3 x i8> [[X:%.*]], <i8 3, i8 undef, i8 3>
; CHECK-NEXT:    [[RET:%.*]] = shl <3 x i8> [[TMP0]], <i8 6, i8 undef, i8 6>
; CHECK-NEXT:    ret <3 x i8> [[RET]]
;
  %tmp0 = ashr <3 x i8> %x, <i8 3, i8 undef, i8 3>
  %ret = shl <3 x i8> %tmp0, <i8 6, i8 undef, i8 6>
  ret <3 x i8> %ret
}

; ============================================================================ ;
; Positive multi-use tests with constant
; ============================================================================ ;

; FIXME: drop 'exact' once it is no longer needed.

define i8 @positive_sameconst_multiuse(i8 %x) {
; CHECK-LABEL: @positive_sameconst_multiuse(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr exact i8 [[X:%.*]], 3
; CHECK-NEXT:    call void @use32(i8 [[TMP0]])
; CHECK-NEXT:    ret i8 [[X]]
;
  %tmp0 = ashr exact i8 %x, 3
  call void @use32(i8 %tmp0)
  %ret = shl i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggerashr_multiuse(i8 %x) {
; CHECK-LABEL: @positive_biggerashr_multiuse(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr exact i8 [[X:%.*]], 6
; CHECK-NEXT:    call void @use32(i8 [[TMP0]])
; CHECK-NEXT:    [[RET:%.*]] = ashr exact i8 [[X]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 6
  call void @use32(i8 %tmp0)
  %ret = shl i8 %tmp0, 3
  ret i8 %ret
}

define i8 @positive_biggershl_multiuse(i8 %x) {
; CHECK-LABEL: @positive_biggershl_multiuse(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr exact i8 [[X:%.*]], 3
; CHECK-NEXT:    call void @use32(i8 [[TMP0]])
; CHECK-NEXT:    [[RET:%.*]] = shl i8 [[X]], 3
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr exact i8 %x, 3
  call void @use32(i8 %tmp0)
  %ret = shl i8 %tmp0, 6
  ret i8 %ret
}

; ============================================================================ ;
; Constant Non-Splat Vectors
; ============================================================================ ;

define <2 x i8> @positive_biggerashr_vec_nonsplat(<2 x i8> %x) {
; CHECK-LABEL: @positive_biggerashr_vec_nonsplat(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <2 x i8> [[X:%.*]], <i8 3, i8 3>
; CHECK-NEXT:    [[RET:%.*]] = shl <2 x i8> [[TMP0]], <i8 3, i8 6>
; CHECK-NEXT:    ret <2 x i8> [[RET]]
;
  %tmp0 = ashr <2 x i8> %x, <i8 3, i8 3>
  %ret = shl <2 x i8> %tmp0, <i8 3, i8 6>
  ret <2 x i8> %ret
}

define <2 x i8> @positive_biggerLashr_vec_nonsplat(<2 x i8> %x) {
; CHECK-LABEL: @positive_biggerLashr_vec_nonsplat(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr <2 x i8> [[X:%.*]], <i8 3, i8 6>
; CHECK-NEXT:    [[RET:%.*]] = shl <2 x i8> [[TMP0]], <i8 3, i8 3>
; CHECK-NEXT:    ret <2 x i8> [[RET]]
;
  %tmp0 = ashr <2 x i8> %x, <i8 3, i8 6>
  %ret = shl <2 x i8> %tmp0, <i8 3, i8 3>
  ret <2 x i8> %ret
}

; ============================================================================ ;
; Negative tests. Should not be folded.
; ============================================================================ ;

define i8 @negative_twovars(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @negative_twovars(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = shl i8 [[TMP0]], [[Z:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, %y
  %ret = shl i8 %tmp0, %z ; $z, not %y
  ret i8 %ret
}

declare void @use32(i8)

; One use only.
define i8 @negative_oneuse(i8 %x, i8 %y) {
; CHECK-LABEL: @negative_oneuse(
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use32(i8 [[TMP0]])
; CHECK-NEXT:    [[RET:%.*]] = shl i8 [[TMP0]], [[Y]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %tmp0 = ashr i8 %x, %y
  call void @use32(i8 %tmp0)
  %ret = shl i8 %tmp0, %y
  ret i8 %ret
}
