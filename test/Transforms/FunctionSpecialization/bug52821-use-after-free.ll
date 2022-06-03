; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -function-specialization -S < %s | FileCheck %s

%mystruct = type { i32, [2 x i64] }

define internal %mystruct* @myfunc(%mystruct* %arg) {
; CHECK-LABEL: @myfunc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br i1 true, label [[FOR_COND2:%.*]], label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    call void @callee(%mystruct* nonnull null)
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.cond2:
; CHECK-NEXT:    br i1 false, label [[FOR_END:%.*]], label [[FOR_BODY2:%.*]]
; CHECK:       for.body2:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [[MYSTRUCT:%.*]], %mystruct* null, i64 0, i32 1, i64 3
; CHECK-NEXT:    br label [[FOR_COND2]]
; CHECK:       for.end:
; CHECK-NEXT:    ret %mystruct* [[ARG:%.*]]
;
entry:
  br label %for.cond

for.cond:                                     ; preds = %for.body, %entry
  %phi = phi %mystruct* [ undef, %for.body ], [ null, %entry ]
  %cond = icmp eq %mystruct* %phi, null
  br i1 %cond, label %for.cond2, label %for.body

for.body:                                     ; preds = %for.cond
  call void @callee(%mystruct* nonnull %phi)
  br label %for.cond

for.cond2:                                     ; preds = %for.body2, %for.cond
  %phi2 = phi %mystruct* [ undef, %for.body2 ], [ null, %for.cond ]
  br i1 false, label %for.end, label %for.body2

for.body2:                                     ; preds = %for.cond2
  %arrayidx = getelementptr inbounds %mystruct, %mystruct* %phi2, i64 0, i32 1, i64 3
  br label %for.cond2

for.end:                                      ; preds = %for.cond2
  ret %mystruct* %arg
}

define %mystruct* @caller() {
; CHECK-LABEL: @caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call %mystruct* @myfunc(%mystruct* undef)
; CHECK-NEXT:    ret %mystruct* [[CALL]]
;
entry:
  %call = call %mystruct* @myfunc(%mystruct* undef)
  ret %mystruct* %call
}

declare void @callee(%mystruct*)
