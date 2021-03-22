; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -gvn --basic-aa -S | FileCheck %s

; load may be speculated, address is not null using context search.
; There is a critical edge.
define i32 @loadpre_critical_edge(i32* align 8 dereferenceable_or_null(48) %arg, i32 %N) {
; CHECK-LABEL: @loadpre_critical_edge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32* [[ARG:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[NULL_EXIT:%.*]], label [[ENTRY_HEADER_CRIT_EDGE:%.*]]
; CHECK:       entry.header_crit_edge:
; CHECK-NEXT:    [[V_PRE:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[V:%.*]] = phi i32 [ [[V_PRE]], [[ENTRY_HEADER_CRIT_EDGE]] ], [ [[SUM:%.*]], [[HEADER]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY_HEADER_CRIT_EDGE]] ], [ [[IV_NEXT:%.*]], [[HEADER]] ]
; CHECK-NEXT:    [[NEW_V:%.*]] = call i32 @ro_foo(i32 [[IV]]) #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    [[SUM]] = add i32 [[NEW_V]], [[V]]
; CHECK-NEXT:    store i32 [[SUM]], i32* [[ARG]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[SUM]]
; CHECK:       null_exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  %cmp = icmp eq i32* %arg, null
  br i1 %cmp, label %null_exit, label %header

header:
  %iv = phi i32 [0, %entry], [%iv.next, %header]
; Call prevents to move load over due to it does not guarantee to return.
  %new_v = call i32 @ro_foo(i32 %iv) readnone
  %v = load i32, i32* %arg
  %sum = add i32 %new_v, %v
  store i32 %sum, i32* %arg
  %iv.next = add i32 %iv, 1
  %cond = icmp eq i32 %iv.next, %N
  br i1 %cond, label %exit, label %header

exit:
  ret i32 %sum

null_exit:
  ret i32 0
}

; load may be speculated, address is not null using context search.
define i32 @loadpre_basic(i32* align 8 dereferenceable_or_null(48) %arg, i32 %N) {
; CHECK-LABEL: @loadpre_basic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32* [[ARG:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[NULL_EXIT:%.*]], label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[V_PRE:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[V:%.*]] = phi i32 [ [[V_PRE]], [[PREHEADER]] ], [ [[SUM:%.*]], [[HEADER]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[PREHEADER]] ], [ [[IV_NEXT:%.*]], [[HEADER]] ]
; CHECK-NEXT:    [[NEW_V:%.*]] = call i32 @ro_foo(i32 [[IV]]) #[[ATTR0]]
; CHECK-NEXT:    [[SUM]] = add i32 [[NEW_V]], [[V]]
; CHECK-NEXT:    store i32 [[SUM]], i32* [[ARG]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[SUM]]
; CHECK:       null_exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  %cmp = icmp eq i32* %arg, null
  br i1 %cmp, label %null_exit, label %preheader

preheader:
  br label %header

header:
  %iv = phi i32 [0, %preheader], [%iv.next, %header]
; Call prevents to move load over due to it does not guarantee to return.
  %new_v = call i32 @ro_foo(i32 %iv) readnone
  %v = load i32, i32* %arg
  %sum = add i32 %new_v, %v
  store i32 %sum, i32* %arg
  %iv.next = add i32 %iv, 1
  %cond = icmp eq i32 %iv.next, %N
  br i1 %cond, label %exit, label %header

exit:
  ret i32 %sum

null_exit:
  ret i32 0
}

; load cannot be speculated, check "address is not null" does not dominate the loop.
define i32 @loadpre_maybe_null(i32* align 8 dereferenceable_or_null(48) %arg, i32 %N, i1 %c) {
; CHECK-LABEL: @loadpre_maybe_null(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[NULL_CHECK:%.*]], label [[PREHEADER:%.*]]
; CHECK:       null_check:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32* [[ARG:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[NULL_EXIT:%.*]], label [[PREHEADER]]
; CHECK:       preheader:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[PREHEADER]] ], [ [[IV_NEXT:%.*]], [[HEADER]] ]
; CHECK-NEXT:    [[NEW_V:%.*]] = call i32 @ro_foo(i32 [[IV]]) #[[ATTR0]]
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    [[SUM:%.*]] = add i32 [[NEW_V]], [[V]]
; CHECK-NEXT:    store i32 [[SUM]], i32* [[ARG]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[SUM]]
; CHECK:       null_exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  br i1 %c, label %null_check, label %preheader

null_check:
  %cmp = icmp eq i32* %arg, null
  br i1 %cmp, label %null_exit, label %preheader

preheader:
  br label %header

header:
  %iv = phi i32 [0, %preheader], [%iv.next, %header]
; Call prevents to move load over due to it does not guarantee to return.
  %new_v = call i32 @ro_foo(i32 %iv) readnone
  %v = load i32, i32* %arg
  %sum = add i32 %new_v, %v
  store i32 %sum, i32* %arg
  %iv.next = add i32 %iv, 1
  %cond = icmp eq i32 %iv.next, %N
  br i1 %cond, label %exit, label %header

exit:
  ret i32 %sum

null_exit:
  ret i32 0
}

; Does not guarantee that returns.
declare i32 @ro_foo(i32) readnone
