; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

@gp = global i32* null, align 8

declare noalias i8* @malloc(i64)

define i1 @compare_global_trivialeq() {
; CHECK-LABEL: @compare_global_trivialeq(
; CHECK-NEXT:    ret i1 false
;
  %m = call i8* @malloc(i64 4)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8
  %cmp = icmp eq i32* %bc, %lgp
  ret i1 %cmp
}

define i1 @compare_global_trivialne() {
; CHECK-LABEL: @compare_global_trivialne(
; CHECK-NEXT:    ret i1 true
;
  %m = call i8* @malloc(i64 4)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8
  %cmp = icmp ne i32* %bc, %lgp
  ret i1 %cmp
}


; Although the %m is marked nocapture in the deopt operand in call to function f,
; we cannot remove the alloc site: call to malloc
; The comparison should fold to false irrespective of whether the call to malloc can be elided or not
declare void @f()
define i1 @compare_and_call_with_deopt() {
; CHECK-LABEL: @compare_and_call_with_deopt(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(24) i8* @malloc(i64 24)
; CHECK-NEXT:    tail call void @f() [ "deopt"(i8* [[M]]) ]
; CHECK-NEXT:    ret i1 false
;
  %m = call i8* @malloc(i64 24)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8, !nonnull !0
  %cmp = icmp eq i32* %lgp, %bc
  tail call void @f() [ "deopt"(i8* %m) ]
  ret i1 %cmp
}

; Same functon as above with deopt operand in function f, but comparison is NE
define i1 @compare_ne_and_call_with_deopt() {
; CHECK-LABEL: @compare_ne_and_call_with_deopt(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(24) i8* @malloc(i64 24)
; CHECK-NEXT:    tail call void @f() [ "deopt"(i8* [[M]]) ]
; CHECK-NEXT:    ret i1 true
;
  %m = call i8* @malloc(i64 24)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8, !nonnull !0
  %cmp = icmp ne i32* %lgp, %bc
  tail call void @f() [ "deopt"(i8* %m) ]
  ret i1 %cmp
}

; Same function as above, but global not marked nonnull, and we cannot fold the comparison
define i1 @compare_ne_global_maybe_null() {
; CHECK-LABEL: @compare_ne_global_maybe_null(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(24) i8* @malloc(i64 24)
; CHECK-NEXT:    [[BC:%.*]] = bitcast i8* [[M]] to i32*
; CHECK-NEXT:    [[LGP:%.*]] = load i32*, i32** @gp, align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32* [[LGP]], [[BC]]
; CHECK-NEXT:    tail call void @f() [ "deopt"(i8* [[M]]) ]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %m = call i8* @malloc(i64 24)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp
  %cmp = icmp ne i32* %lgp, %bc
  tail call void @f() [ "deopt"(i8* %m) ]
  ret i1 %cmp
}

; FIXME: The comparison should fold to false since %m escapes (call to function escape)
; after the comparison.
declare void @escape(i8*)
define i1 @compare_and_call_after() {
; CHECK-LABEL: @compare_and_call_after(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(24) i8* @malloc(i64 24)
; CHECK-NEXT:    [[BC:%.*]] = bitcast i8* [[M]] to i32*
; CHECK-NEXT:    [[LGP:%.*]] = load i32*, i32** @gp, align 8, !nonnull !0
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32* [[LGP]], [[BC]]
; CHECK-NEXT:    br i1 [[CMP]], label [[ESCAPE_CALL:%.*]], label [[JUST_RETURN:%.*]]
; CHECK:       escape_call:
; CHECK-NEXT:    call void @escape(i8* [[M]])
; CHECK-NEXT:    ret i1 true
; CHECK:       just_return:
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %m = call i8* @malloc(i64 24)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8, !nonnull !0
  %cmp = icmp eq i32* %bc, %lgp
  br i1 %cmp, label %escape_call, label %just_return

escape_call:
  call void @escape(i8* %m)
  ret i1 true

just_return:
  ret i1 %cmp
}

define i1 @compare_distinct_mallocs() {
; CHECK-LABEL: @compare_distinct_mallocs(
; CHECK-NEXT:    ret i1 false
;
  %m = call i8* @malloc(i64 4)
  %n = call i8* @malloc(i64 4)
  %cmp = icmp eq i8* %m, %n
  ret i1 %cmp
}

; the compare is folded to true since the folding compare looks through bitcasts.
; call to malloc and the bitcast instructions are elided after that since there are no uses of the malloc
define i1 @compare_samepointer_under_bitcast() {
; CHECK-LABEL: @compare_samepointer_under_bitcast(
; CHECK-NEXT:    ret i1 true
;
  %m = call i8* @malloc(i64 4)
  %bc = bitcast i8* %m to i32*
  %bcback = bitcast i32* %bc to i8*
  %cmp = icmp eq i8* %m, %bcback
  ret i1 %cmp
}

; the compare is folded to true since the folding compare looks through bitcasts.
; The malloc call for %m cannot be elided since it is used in the call to function f.
define i1 @compare_samepointer_escaped() {
; CHECK-LABEL: @compare_samepointer_escaped(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    call void @f() [ "deopt"(i8* [[M]]) ]
; CHECK-NEXT:    ret i1 true
;
  %m = call i8* @malloc(i64 4)
  %bc = bitcast i8* %m to i32*
  %bcback = bitcast i32* %bc to i8*
  %cmp = icmp eq i8* %m, %bcback
  call void @f() [ "deopt"(i8* %m) ]
  ret i1 %cmp
}

; Technically, we can fold the %cmp2 comparison, even though %m escapes through
; the ret statement since `ret` terminates the function and we cannot reach from
; the ret to cmp.
; FIXME: Folding this %cmp2 when %m escapes through ret could be an issue with
; cross-threading data dependencies since we do not make the distinction between
; atomic and non-atomic loads in capture tracking.
define i8* @compare_ret_escape(i8* %c) {
; CHECK-LABEL: @compare_ret_escape(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    [[N:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[N]], [[C:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[RETST:%.*]], label [[CHK:%.*]]
; CHECK:       retst:
; CHECK-NEXT:    ret i8* [[M]]
; CHECK:       chk:
; CHECK-NEXT:    [[BC:%.*]] = bitcast i8* [[M]] to i32*
; CHECK-NEXT:    [[LGP:%.*]] = load i32*, i32** @gp, align 8, !nonnull !0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32* [[LGP]], [[BC]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[RETST]], label [[CHK2:%.*]]
; CHECK:       chk2:
; CHECK-NEXT:    ret i8* [[N]]
;
  %m = call i8* @malloc(i64 4)
  %n = call i8* @malloc(i64 4)
  %cmp = icmp eq i8* %n, %c
  br i1 %cmp, label %retst, label %chk

retst:
  ret i8* %m

chk:
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8, !nonnull !0
  %cmp2 = icmp eq i32* %bc, %lgp
  br i1 %cmp2, label %retst,  label %chk2

chk2:
  ret i8* %n
}

; The malloc call for %m cannot be elided since it is used in the call to function f.
; However, the cmp can be folded to true as %n doesnt escape and %m, %n are distinct allocations
define i1 @compare_distinct_pointer_escape() {
; CHECK-LABEL: @compare_distinct_pointer_escape(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    tail call void @f() [ "deopt"(i8* [[M]]) ]
; CHECK-NEXT:    ret i1 true
;
  %m = call i8* @malloc(i64 4)
  %n = call i8* @malloc(i64 4)
  tail call void @f() [ "deopt"(i8* %m) ]
  %cmp = icmp ne i8* %m, %n
  ret i1 %cmp
}

; The next block of tests demonstrate a very subtle correctness requirement.
; We can generally assume any *single* heap layout we chose for the result of
; a malloc call, but we can't simultanious assume two different ones.  As a
; result, we must make sure that we only fold conditions if we can ensure that
; we fold *all* potentially address capturing compares the same.  This is
; the same point that applies to allocas, applied to noaiias/malloc.

; These two functions represents either a) forging a pointer via inttoptr or
; b) indexing off an adjacent allocation.  In either case, the operation is
; obscured by an uninlined helper and not visible to instcombine.
declare i8* @hidden_inttoptr()
declare i8* @hidden_offset(i8* %other)

; FIXME: Missed oppurtunity
define i1 @ptrtoint_single_cmp() {
; CHECK-LABEL: @ptrtoint_single_cmp(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[M]], inttoptr (i64 2048 to i8*)
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %m = call i8* @malloc(i64 4)
  %rhs = inttoptr i64 2048 to i8*
  %cmp = icmp eq i8* %m, %rhs
  ret i1 %cmp
}

define i1 @offset_single_cmp() {
; CHECK-LABEL: @offset_single_cmp(
; CHECK-NEXT:    ret i1 false
;
  %m = call i8* @malloc(i64 4)
  %n = call i8* @malloc(i64 4)
  %rhs = getelementptr i8, i8* %n, i32 4
  %cmp = icmp eq i8* %m, %rhs
  ret i1 %cmp
}

define i1 @neg_consistent_fold1() {
; CHECK-LABEL: @neg_consistent_fold1(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    [[RHS2:%.*]] = call i8* @hidden_inttoptr()
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8* [[M]], inttoptr (i64 2048 to i8*)
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8* [[RHS2]], inttoptr (i64 2048 to i8*)
; CHECK-NEXT:    [[TMP2:%.*]] = and i1 [[CMP1]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %m = call i8* @malloc(i64 4)
  %rhs = inttoptr i64 2048 to i8*
  %rhs2 = call i8* @hidden_inttoptr()
  %cmp1 = icmp eq i8* %m, %rhs
  %cmp2 = icmp eq i8* %m, %rhs2
  %res = and i1 %cmp1, %cmp2
  ret i1 %res
}

define i1 @neg_consistent_fold2() {
; CHECK-LABEL: @neg_consistent_fold2(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    [[N:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    [[RHS:%.*]] = getelementptr i8, i8* [[N]], i64 4
; CHECK-NEXT:    [[RHS2:%.*]] = call i8* @hidden_offset(i8* [[N]])
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8* [[M]], [[RHS]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8* [[M]], [[RHS2]]
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %m = call i8* @malloc(i64 4)
  %n = call i8* @malloc(i64 4)
  %rhs = getelementptr i8, i8* %n, i32 4
  %rhs2 = call i8* @hidden_offset(i8* %n)
  %cmp1 = icmp eq i8* %m, %rhs
  %cmp2 = icmp eq i8* %m, %rhs2
  %res = and i1 %cmp1, %cmp2
  ret i1 %res
}

define i1 @neg_consistent_fold3() {
; CHECK-LABEL: @neg_consistent_fold3(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    [[BC:%.*]] = bitcast i8* [[M]] to i32*
; CHECK-NEXT:    [[LGP:%.*]] = load i32*, i32** @gp, align 8
; CHECK-NEXT:    [[RHS2:%.*]] = call i8* @hidden_inttoptr()
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32* [[LGP]], [[BC]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8* [[M]], [[RHS2]]
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %m = call i8* @malloc(i64 4)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8
  %rhs2 = call i8* @hidden_inttoptr()
  %cmp1 = icmp eq i32* %bc, %lgp
  %cmp2 = icmp eq i8* %m, %rhs2
  %res = and i1 %cmp1, %cmp2
  ret i1 %res
}

; FIXME: This appears correct, but the current implementation relies
; on visiting both cmps in the same pass.  We may have an simplification order
; under which one is missed, and that would be a bug.
define i1 @neg_consistent_fold4() {
; CHECK-LABEL: @neg_consistent_fold4(
; CHECK-NEXT:    ret i1 false
;
  %m = call i8* @malloc(i64 4)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8
  %cmp1 = icmp eq i32* %bc, %lgp
  %cmp2 = icmp eq i32* %bc, %lgp
  %res = and i1 %cmp1, %cmp2
  ret i1 %res
}

declare void @unknown(i8*)

; Points out that a nocapture call can't cause a consistent result issue
; as it is (by assumption) not able to contain a comparison which might
; capture the address.

define i1 @consistent_nocapture_inttoptr() {
; CHECK-LABEL: @consistent_nocapture_inttoptr(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    call void @unknown(i8* nocapture [[M]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[M]], inttoptr (i64 2048 to i8*)
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %m = call i8* @malloc(i64 4)
  call void @unknown(i8* nocapture %m)
  %rhs = inttoptr i64 2048 to i8*
  %cmp = icmp eq i8* %m, %rhs
  ret i1 %cmp
}

define i1 @consistent_nocapture_offset() {
; CHECK-LABEL: @consistent_nocapture_offset(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    call void @unknown(i8* nocapture [[M]])
; CHECK-NEXT:    ret i1 false
;
  %m = call i8* @malloc(i64 4)
  call void @unknown(i8* nocapture %m)
  %n = call i8* @malloc(i64 4)
  %rhs = getelementptr i8, i8* %n, i32 4
  %cmp = icmp eq i8* %m, %rhs
  ret i1 %cmp
}

define i1 @consistent_nocapture_through_global() {
; CHECK-LABEL: @consistent_nocapture_through_global(
; CHECK-NEXT:    [[M:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    call void @unknown(i8* nocapture [[M]])
; CHECK-NEXT:    ret i1 false
;
  %m = call i8* @malloc(i64 4)
  call void @unknown(i8* nocapture %m)
  %bc = bitcast i8* %m to i32*
  %lgp = load i32*, i32** @gp, align 8, !nonnull !0
  %cmp = icmp eq i32* %bc, %lgp
  ret i1 %cmp
}

!0 = !{}


