; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

declare void @foo()
declare void @bar()
declare void @baz()

declare void @usei32(i32)
declare void @usei32i32agg({ i32, i32 })

; Most basic test - we explode the original aggregate into it's elements,
; and then merge them back together exactly the way they were.
; We should just return the source aggregate.
define { i32, i32 } @test0({ i32, i32 } %srcagg) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    ret { i32, i32 } [[SRCAGG:%.*]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %i1, 1
  ret { i32, i32 } %i3
}

; Arrays are still aggregates
define [2 x i32] @test1([2 x i32] %srcagg) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret [2 x i32] [[SRCAGG:%.*]]
;
  %i0 = extractvalue [2 x i32] %srcagg, 0
  %i1 = extractvalue [2 x i32] %srcagg, 1
  %i2 = insertvalue [2 x i32] undef, i32 %i0, 0
  %i3 = insertvalue [2 x i32] %i2, i32 %i1, 1
  ret [2 x i32] %i3
}

; Right now we don't deal with case where there are more than 2 elements.
; FIXME: should we?
define [3 x i32] @test2([3 x i32] %srcagg) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue [3 x i32] [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = extractvalue [3 x i32] [[SRCAGG]], 1
; CHECK-NEXT:    [[I2:%.*]] = extractvalue [3 x i32] [[SRCAGG]], 2
; CHECK-NEXT:    [[I3:%.*]] = insertvalue [3 x i32] undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I4:%.*]] = insertvalue [3 x i32] [[I3]], i32 [[I1]], 1
; CHECK-NEXT:    [[I5:%.*]] = insertvalue [3 x i32] [[I4]], i32 [[I2]], 2
; CHECK-NEXT:    ret [3 x i32] [[I5]]
;
  %i0 = extractvalue [3 x i32] %srcagg, 0
  %i1 = extractvalue [3 x i32] %srcagg, 1
  %i2 = extractvalue [3 x i32] %srcagg, 2
  %i3 = insertvalue [3 x i32] undef, i32 %i0, 0
  %i4 = insertvalue [3 x i32] %i3, i32 %i1, 1
  %i5 = insertvalue [3 x i32] %i4, i32 %i2, 2
  ret [3 x i32] %i5
}

; Likewise, we only deal with a single-level aggregates.
; FIXME: should we?
define {{ i32, i32 }} @test3({{ i32, i32 }} %srcagg) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { { i32, i32 } } [[SRCAGG:%.*]], 0, 0
; CHECK-NEXT:    [[I1:%.*]] = extractvalue { { i32, i32 } } [[SRCAGG]], 0, 1
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { { i32, i32 } } undef, i32 [[I0]], 0, 0
; CHECK-NEXT:    [[I3:%.*]] = insertvalue { { i32, i32 } } [[I2]], i32 [[I1]], 0, 1
; CHECK-NEXT:    ret { { i32, i32 } } [[I3]]
;
  %i0 = extractvalue {{ i32, i32 }} %srcagg, 0, 0
  %i1 = extractvalue {{ i32, i32 }} %srcagg, 0, 1
  %i2 = insertvalue {{ i32, i32 }} undef, i32 %i0, 0, 0
  %i3 = insertvalue {{ i32, i32 }} %i2, i32 %i1, 0, 1
  ret {{ i32, i32 }} %i3
}

; This is fine, however, all elements are on the same level
define { i32, { i32 } } @test4({ i32, { i32 } } %srcagg) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret { i32, { i32 } } [[SRCAGG:%.*]]
;
  %i0 = extractvalue { i32, { i32 } } %srcagg, 0
  %i1 = extractvalue { i32, { i32 } } %srcagg, 1
  %i2 = insertvalue { i32, { i32 } } undef, i32 %i0, 0
  %i3 = insertvalue { i32, { i32 } } %i2, { i32 } %i1, 1
  ret { i32, { i32 } } %i3
}

; All element of the newly-created aggregate must come from the same base
; aggregate. Here the second element comes from some other origin.
define { i32, i32 } @negative_test5({ i32, i32 } %srcagg, i32 %replacement) {
; CHECK-LABEL: @negative_test5(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I3:%.*]] = insertvalue { i32, i32 } [[I2]], i32 [[REPLACEMENT:%.*]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I3]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  ; %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %replacement, 1
  ret { i32, i32 } %i3
}

; Here we don't know the value of second element of %otheragg,
define { i32, i32 } @negative_test6({ i32, i32 } %srcagg, { i32, i32 } %otheragg) {
; CHECK-LABEL: @negative_test6(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } [[OTHERAGG:%.*]], i32 [[I0]], 0
; CHECK-NEXT:    ret { i32, i32 } [[I2]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  ; %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } %otheragg, i32 %i0, 0
  ret { i32, i32 } %i2
}

; All element of the newly-created aggregate must come from the same base
; aggregate. Here different elements come from different base aggregates.
define { i32, i32 } @negative_test7({ i32, i32 } %srcagg0, { i32, i32 } %srcagg1) {
; CHECK-LABEL: @negative_test7(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG0:%.*]], 0
; CHECK-NEXT:    [[I3:%.*]] = extractvalue { i32, i32 } [[SRCAGG1:%.*]], 1
; CHECK-NEXT:    [[I4:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I5:%.*]] = insertvalue { i32, i32 } [[I4]], i32 [[I3]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I5]]
;
  %i0 = extractvalue { i32, i32 } %srcagg0, 0
  ; %i1 = extractvalue { i32, i32 } %srcagg0, 1

  ; %i2 = extractvalue { i32, i32 } %srcagg1, 0
  %i3 = extractvalue { i32, i32 } %srcagg1, 1

  %i4 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i5 = insertvalue { i32, i32 } %i4, i32 %i3, 1
  ret { i32, i32 } %i5
}

; Here the element order is swapped as compared to the base aggregate.
define { i32, i32 } @negative_test8({ i32, i32 } %srcagg) {
; CHECK-LABEL: @negative_test8(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = extractvalue { i32, i32 } [[SRCAGG]], 1
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 1
; CHECK-NEXT:    [[I3:%.*]] = insertvalue { i32, i32 } [[I2]], i32 [[I1]], 0
; CHECK-NEXT:    ret { i32, i32 } [[I3]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 1
  %i3 = insertvalue { i32, i32 } %i2, i32 %i1, 0
  ret { i32, i32 } %i3
}

; Here both elements of the new aggregate come from the same element of the old aggregate.
define { i32, i32 } @negative_test9({ i32, i32 } %srcagg) {
; CHECK-LABEL: @negative_test9(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I3:%.*]] = insertvalue { i32, i32 } [[I2]], i32 [[I0]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I3]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  ; %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %i0, 1
  ret { i32, i32 } %i3
}

; Here the second element of the new aggregate is undef, , so we must keep this as-is, because in %srcagg it might be poison.
; FIXME: defer to noundef attribute on %srcagg
define { i32, i32 } @negative_test10({ i32, i32 } %srcagg) {
; CHECK-LABEL: @negative_test10(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    ret { i32, i32 } [[I2]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  ; %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  ret { i32, i32 } %i2
}

; Here the second element of the new aggregate is undef, so we must keep this as-is, because in %srcagg it might be poison.
; FIXME: defer to noundef attribute on %srcagg
define { i32, i32 } @negative_test11({ i32, i32 } %srcagg) {
; CHECK-LABEL: @negative_test11(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I3:%.*]] = insertvalue { i32, i32 } [[I2]], i32 undef, 1
; CHECK-NEXT:    ret { i32, i32 } [[I3]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  ; %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 undef, 1
  ret { i32, i32 } %i3
}

; This fold does not care whether or not intermediate instructions have extra uses.
define { i32, i32 } @test12({ i32, i32 } %srcagg) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    call void @usei32(i32 [[I0]])
; CHECK-NEXT:    [[I1:%.*]] = extractvalue { i32, i32 } [[SRCAGG]], 1
; CHECK-NEXT:    call void @usei32(i32 [[I1]])
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    call void @usei32i32agg({ i32, i32 } [[I2]])
; CHECK-NEXT:    ret { i32, i32 } [[SRCAGG]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  call void @usei32(i32 %i0)
  %i1 = extractvalue { i32, i32 } %srcagg, 1
  call void @usei32(i32 %i1)
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  call void @usei32i32agg({ i32, i32 } %i2)
  %i3 = insertvalue { i32, i32 } %i2, i32 %i1, 1
  ret { i32, i32 } %i3
}

; Even though we originally store %i1 into first element, it is later
; overwritten with %i0, so all is fine.
define { i32, i32 } @test13({ i32, i32 } %srcagg) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    ret { i32, i32 } [[SRCAGG:%.*]]
;
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i1, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %i0, 0
  %i4 = insertvalue { i32, i32 } %i3, i32 %i1, 1
  ret { i32, i32 } %i4
}

; The aggregate type must match exactly between the original and recreation.
define { i32, i32 } @negative_test14({ i32, i32, i32 } %srcagg) {
; CHECK-LABEL: @negative_test14(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32, i32 } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = extractvalue { i32, i32, i32 } [[SRCAGG]], 1
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I3:%.*]] = insertvalue { i32, i32 } [[I2]], i32 [[I1]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I3]]
;
  %i0 = extractvalue { i32, i32, i32 } %srcagg, 0
  %i1 = extractvalue { i32, i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %i1, 1
  ret { i32, i32 } %i3
}
define { i32, i32 } @negative_test15({ i32, {i32} } %srcagg) {
; CHECK-LABEL: @negative_test15(
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, { i32 } } [[SRCAGG:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = extractvalue { i32, { i32 } } [[SRCAGG]], 1, 0
; CHECK-NEXT:    [[I2:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I3:%.*]] = insertvalue { i32, i32 } [[I2]], i32 [[I1]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I3]]
;
  %i0 = extractvalue { i32, {i32} } %srcagg, 0
  %i1 = extractvalue { i32, {i32} } %srcagg, 1, 0
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %i1, 1
  ret { i32, i32 } %i3
}

; Just because there are predecessors doesn't mean we should look into them.
define { i32, i32 } @test16({ i32, i32 } %srcagg) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    ret { i32, i32 } [[SRCAGG:%.*]]
;
entry:
  br label %end
end:
  %i0 = extractvalue { i32, i32 } %srcagg, 0
  %i1 = extractvalue { i32, i32 } %srcagg, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %i1, 1
  ret { i32, i32 } %i3
}

; Again, we should first try to perform local reasoning, without looking to predecessors.
define { i32, i32 } @test17({ i32, i32 } %srcagg0, { i32, i32 } %srcagg1, i1 %c) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[INTERMEDIATE:%.*]], label [[END:%.*]]
; CHECK:       intermediate:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[SRCAGG_PHI:%.*]] = phi { i32, i32 } [ [[SRCAGG0:%.*]], [[ENTRY:%.*]] ], [ [[SRCAGG1:%.*]], [[INTERMEDIATE]] ]
; CHECK-NEXT:    ret { i32, i32 } [[SRCAGG_PHI]]
;
entry:
  br i1 %c, label %intermediate, label %end
intermediate:
  br label %end
end:
  %srcagg.phi = phi { i32, i32 } [ %srcagg0, %entry ], [ %srcagg1, %intermediate ]
  %i0 = extractvalue { i32, i32 } %srcagg.phi, 0
  %i1 = extractvalue { i32, i32 } %srcagg.phi, 1
  %i2 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i3 = insertvalue { i32, i32 } %i2, i32 %i1, 1
  ret { i32, i32 } %i3
}
