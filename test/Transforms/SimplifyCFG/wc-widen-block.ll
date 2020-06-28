; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=simplify-cfg -S < %s | FileCheck %s

define i32 @basic(i1 %cond_0, i32* %p) {
; CHECK-LABEL: @basic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[RETURN:%.*]], label [[DEOPT]], !prof !0
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  %v = load i32, i32* %p
  %cond_1 = icmp eq i32 %v, 0
  br i1 %cond_1, label %return, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}

define i32 @mergeable(i1 %cond_0, i1 %cond_1) {
; CHECK-LABEL: @mergeable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND_NOT:%.*]] = xor i1 [[EXIPLICIT_GUARD_COND]], true
; CHECK-NEXT:    [[COND_1_NOT:%.*]] = xor i1 [[COND_1:%.*]], true
; CHECK-NEXT:    [[BRMERGE:%.*]] = or i1 [[EXIPLICIT_GUARD_COND_NOT]], [[COND_1_NOT]]
; CHECK-NEXT:    br i1 [[BRMERGE]], label [[DEOPT:%.*]], label [[RETURN:%.*]], !prof !1
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  br i1 %cond_1, label %return, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}

define i32 @basic_swapped_branch(i1 %cond_0, i32* %p) {
; CHECK-LABEL: @basic_swapped_branch(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[DEOPT]], label [[RETURN:%.*]], !prof !0
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  %v = load i32, i32* %p
  %cond_1 = icmp eq i32 %v, 0
  br i1 %cond_1, label %deopt2, label %return, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}

define i32 @todo_sink_side_effect(i1 %cond_0, i1 %cond_1) {
; CHECK-LABEL: @todo_sink_side_effect(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    br i1 [[COND_1:%.*]], label [[RETURN:%.*]], label [[DEOPT2:%.*]], !prof !0
; CHECK:       deopt2:
; CHECK-NEXT:    [[DEOPTRET2:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET2]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  call void @unknown()
  br i1 %cond_1, label %return, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}

define i32 @neg_unsinkable_side_effect(i1 %cond_0) {
; CHECK-LABEL: @neg_unsinkable_side_effect(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    [[V:%.*]] = call i32 @unknown_i32()
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[RETURN:%.*]], label [[DEOPT2:%.*]], !prof !0
; CHECK:       deopt2:
; CHECK-NEXT:    [[DEOPTRET2:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET2]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  %v = call i32 @unknown_i32()
  %cond_1 = icmp eq i32 %v, 0
  br i1 %cond_1, label %return, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}


define i32 @neg_inf_loop(i1 %cond_0, i1 %cond_1) {
; CHECK-LABEL: @neg_inf_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    br i1 [[COND_1:%.*]], label [[RETURN:%.*]], label [[DEOPT]], !prof !0
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  call void @unknown()
  br i1 %cond_1, label %return, label %deopt, !prof !0

return:
  ret i32 0
}


define i32 @todo_phi(i1 %cond_0, i1 %cond_1) {
; CHECK-LABEL: @todo_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"(i32 [[PHI]]) ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    br i1 [[COND_1:%.*]], label [[RETURN:%.*]], label [[DEOPT2:%.*]], !prof !0
; CHECK:       deopt2:
; CHECK-NEXT:    [[DEOPTRET2:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET2]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %phi = phi i32 [0, %entry]
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"(i32 %phi) ]
  ret i32 %deoptret

guarded:
  br i1 %cond_1, label %return, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}


define i32 @neg_loop(i1 %cond_0, i1 %cond_1) {
; CHECK-LABEL: @neg_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[GUARDED:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    br i1 [[COND_1:%.*]], label [[LOOP:%.*]], label [[DEOPT2:%.*]], !prof !0
; CHECK:       deopt2:
; CHECK-NEXT:    [[DEOPTRET2:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET2]]
;
entry:
  br label %guarded

loop:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  call void @unknown()
  br i1 %cond_1, label %loop, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2
}

; This one is subtle - We can't widen only one branch use of the
; widenable condition as two branches are correlated.  We'd have to
; widen them *both*.
define i32 @neg_correlated(i1 %cond_0, i1 %cond_1, i32* %p) {
; CHECK-LABEL: @neg_correlated(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[COND_0:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND2:%.*]] = and i1 [[COND_1:%.*]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND2]], label [[GUARDED2:%.*]], label [[DEOPT2:%.*]], !prof !0
; CHECK:       deopt2:
; CHECK-NEXT:    [[DEOPTRET2:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET2]]
; CHECK:       guarded2:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND_2:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[COND_2]], label [[RETURN:%.*]], label [[DEOPT3:%.*]], !prof !0
; CHECK:       deopt3:
; CHECK-NEXT:    [[DEOPTRET3:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET3]]
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %cond_0, %widenable_cond
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  %exiplicit_guard_cond2 = and i1 %cond_1, %widenable_cond
  br i1 %exiplicit_guard_cond2, label %guarded2, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

guarded2:
  %v = load i32, i32* %p
  %cond_2 = icmp eq i32 %v, 0
  br i1 %cond_2, label %return, label %deopt3, !prof !0

deopt3:
  %deoptret3 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret3

return:
  ret i32 0
}

define i32 @trivial_wb(i1 %cond_0, i32* %p) {
; CHECK-LABEL: @trivial_wb(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    br i1 [[WIDENABLE_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[RETURN:%.*]], label [[DEOPT]], !prof !0
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  br i1 %widenable_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  %v = load i32, i32* %p
  %cond_1 = icmp eq i32 %v, 0
  br i1 %cond_1, label %return, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}


define i32 @swapped_wb(i1 %cond_0, i32* %p) {
; CHECK-LABEL: @swapped_wb(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[WIDENABLE_COND]], [[COND_0:%.*]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED:%.*]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPTRET:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPTRET]]
; CHECK:       guarded:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[RETURN:%.*]], label [[DEOPT]], !prof !0
; CHECK:       return:
; CHECK-NEXT:    ret i32 0
;
entry:
  %widenable_cond = call i1 @llvm.experimental.widenable.condition()
  %exiplicit_guard_cond = and i1 %widenable_cond, %cond_0
  br i1 %exiplicit_guard_cond, label %guarded, label %deopt, !prof !0

deopt:
  %deoptret = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret

guarded:
  %v = load i32, i32* %p
  %cond_1 = icmp eq i32 %v, 0
  br i1 %cond_1, label %return, label %deopt2, !prof !0

deopt2:
  %deoptret2 = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deoptret2

return:
  ret i32 0
}




declare void @unknown()
declare i32 @unknown_i32()

declare i1 @llvm.experimental.widenable.condition()
declare i32 @llvm.experimental.deoptimize.i32(...)

!0 = !{!"branch_weights", i32 1048576, i32 1}
!1 = !{i32 1, i32 -2147483648}
