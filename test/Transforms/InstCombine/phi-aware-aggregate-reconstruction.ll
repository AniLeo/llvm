; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

declare void @foo()
declare void @bar()
declare void @baz()
declare void @qux()
declare void @quux()

declare i1 @geni1()

declare void @usei32(i32)
declare void @usei32i32agg({ i32, i32 })

; Most basic test - diamond structure
define { i32, i32 } @test0({ i32, i32 } %agg_left, { i32, i32 } %agg_right, i1 %c) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       right:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[I8:%.*]] = phi { i32, i32 } [ [[AGG_RIGHT:%.*]], [[RIGHT]] ], [ [[AGG_LEFT:%.*]], [[LEFT]] ]
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    ret { i32, i32 } [[I8]]
;
entry:
  br i1 %c, label %left, label %right

left:
  %i0 = extractvalue { i32, i32 } %agg_left, 0
  %i2 = extractvalue { i32, i32 } %agg_left, 1
  call void @foo()
  br label %end

right:
  %i3 = extractvalue { i32, i32 } %agg_right, 0
  %i4 = extractvalue { i32, i32 } %agg_right, 1
  call void @bar()
  br label %end

end:
  %i5 = phi i32 [ %i0, %left ], [ %i3, %right ]
  %i6 = phi i32 [ %i2, %left ], [ %i4, %right ]
  call void @baz()
  %i7 = insertvalue { i32, i32 } undef, i32 %i5, 0
  %i8 = insertvalue { i32, i32 } %i7, i32 %i6, 1
  ret { i32, i32 } %i8
}

; Second element is coming from wrong aggregate
define { i32, i32 } @negative_test1({ i32, i32 } %agg_left, { i32, i32 } %agg_right, i1 %c) {
; CHECK-LABEL: @negative_test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    [[I4:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT:%.*]], 1
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT:%.*]], 0
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       right:
; CHECK-NEXT:    [[I3:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT]], 0
; CHECK-NEXT:    [[I2:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT]], 1
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[I5:%.*]] = phi i32 [ [[I0]], [[LEFT]] ], [ [[I3]], [[RIGHT]] ]
; CHECK-NEXT:    [[I6:%.*]] = phi i32 [ [[I4]], [[LEFT]] ], [ [[I2]], [[RIGHT]] ]
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    [[I7:%.*]] = insertvalue { i32, i32 } undef, i32 [[I5]], 0
; CHECK-NEXT:    [[I8:%.*]] = insertvalue { i32, i32 } [[I7]], i32 [[I6]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I8]]
;
entry:
  %i0 = extractvalue { i32, i32 } %agg_left, 0
  %i2 = extractvalue { i32, i32 } %agg_left, 1
  %i3 = extractvalue { i32, i32 } %agg_right, 0
  %i4 = extractvalue { i32, i32 } %agg_right, 1
  br i1 %c, label %left, label %right

left:
  call void @foo()
  br label %end

right:
  call void @bar()
  br label %end

end:
  %i5 = phi i32 [ %i0, %left ], [ %i3, %right ]
  %i6 = phi i32 [ %i4, %left ], [ %i2, %right ]
  call void @baz()
  %i7 = insertvalue { i32, i32 } undef, i32 %i5, 0
  %i8 = insertvalue { i32, i32 } %i7, i32 %i6, 1
  ret { i32, i32 } %i8
}

; When coming from %left, elements are swapped
define { i32, i32 } @negative_test2({ i32, i32 } %agg_left, { i32, i32 } %agg_right, i1 %c) {
; CHECK-LABEL: @negative_test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    [[I2:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT:%.*]], 1
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT]], 0
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       right:
; CHECK-NEXT:    [[I4:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT:%.*]], 1
; CHECK-NEXT:    [[I3:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT]], 0
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[I5:%.*]] = phi i32 [ [[I2]], [[LEFT]] ], [ [[I3]], [[RIGHT]] ]
; CHECK-NEXT:    [[I6:%.*]] = phi i32 [ [[I0]], [[LEFT]] ], [ [[I4]], [[RIGHT]] ]
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    [[I7:%.*]] = insertvalue { i32, i32 } undef, i32 [[I5]], 0
; CHECK-NEXT:    [[I8:%.*]] = insertvalue { i32, i32 } [[I7]], i32 [[I6]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I8]]
;
entry:
  %i0 = extractvalue { i32, i32 } %agg_left, 0
  %i2 = extractvalue { i32, i32 } %agg_left, 1
  %i3 = extractvalue { i32, i32 } %agg_right, 0
  %i4 = extractvalue { i32, i32 } %agg_right, 1
  br i1 %c, label %left, label %right

left:
  call void @foo()
  br label %end

right:
  call void @bar()
  br label %end

end:
  %i5 = phi i32 [ %i2, %left ], [ %i3, %right ]
  %i6 = phi i32 [ %i0, %left ], [ %i4, %right ]
  call void @baz()
  %i7 = insertvalue { i32, i32 } undef, i32 %i5, 0
  %i8 = insertvalue { i32, i32 } %i7, i32 %i6, 1
  ret { i32, i32 } %i8
}

; FIXME: we should probably be able to handle multiple levels of PHI indirection
define { i32, i32 } @test3({ i32, i32 } %agg_00, { i32, i32 } %agg_01, { i32, i32 } %agg_10, i1 %c0, i1 %c1) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C0:%.*]], label [[BB0_DISPATCH:%.*]], label [[BB10:%.*]]
; CHECK:       bb0.dispatch:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB00:%.*]], label [[BB01:%.*]]
; CHECK:       bb00:
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[AGG_00:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = extractvalue { i32, i32 } [[AGG_00]], 1
; CHECK-NEXT:    br label [[BB0_MERGE:%.*]]
; CHECK:       bb01:
; CHECK-NEXT:    [[I2:%.*]] = extractvalue { i32, i32 } [[AGG_01:%.*]], 0
; CHECK-NEXT:    [[I3:%.*]] = extractvalue { i32, i32 } [[AGG_01]], 1
; CHECK-NEXT:    br label [[BB0_MERGE]]
; CHECK:       bb0.merge:
; CHECK-NEXT:    [[I4:%.*]] = phi i32 [ [[I0]], [[BB00]] ], [ [[I2]], [[BB01]] ]
; CHECK-NEXT:    [[I5:%.*]] = phi i32 [ [[I1]], [[BB00]] ], [ [[I3]], [[BB01]] ]
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       bb10:
; CHECK-NEXT:    [[I6:%.*]] = extractvalue { i32, i32 } [[AGG_10:%.*]], 0
; CHECK-NEXT:    [[I7:%.*]] = extractvalue { i32, i32 } [[AGG_10]], 1
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[I8:%.*]] = phi i32 [ [[I4]], [[BB0_MERGE]] ], [ [[I6]], [[BB10]] ]
; CHECK-NEXT:    [[I9:%.*]] = phi i32 [ [[I5]], [[BB0_MERGE]] ], [ [[I7]], [[BB10]] ]
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    [[I10:%.*]] = insertvalue { i32, i32 } undef, i32 [[I8]], 0
; CHECK-NEXT:    [[I11:%.*]] = insertvalue { i32, i32 } [[I10]], i32 [[I9]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I11]]
;
entry:
  br i1 %c0, label %bb0.dispatch, label %bb10

bb0.dispatch:
  br i1 %c1, label %bb00, label %bb01

bb00:
  %i0 = extractvalue { i32, i32 } %agg_00, 0
  %i1 = extractvalue { i32, i32 } %agg_00, 1
  br label %bb0.merge

bb01:
  %i2 = extractvalue { i32, i32 } %agg_01, 0
  %i3 = extractvalue { i32, i32 } %agg_01, 1
  br label %bb0.merge

bb0.merge:
  %i4 = phi i32 [ %i0, %bb00 ], [ %i2, %bb01 ]
  %i5 = phi i32 [ %i1, %bb00 ], [ %i3, %bb01 ]
  br label %end

bb10:
  %i6 = extractvalue { i32, i32 } %agg_10, 0
  %i7 = extractvalue { i32, i32 } %agg_10, 1
  br label %end

end:
  %i8 = phi i32 [ %i4, %bb0.merge ], [ %i6, %bb10 ]
  %i9 = phi i32 [ %i5, %bb0.merge ], [ %i7, %bb10 ]
  call void @baz()
  %i10 = insertvalue { i32, i32 } undef, i32 %i8, 0
  %i11 = insertvalue { i32, i32 } %i10, i32 %i9, 1
  ret { i32, i32 } %i11
}

; Not sure what should happen for cycles.
define { i32, i32 } @test4({ i32, i32 } %agg_left, { i32, i32 } %agg_right, i1 %c0) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C0:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT:%.*]], 0
; CHECK-NEXT:    [[I2:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT]], 1
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[MIDDLE:%.*]]
; CHECK:       right:
; CHECK-NEXT:    [[I3:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT:%.*]], 0
; CHECK-NEXT:    [[I4:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT]], 1
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[MIDDLE]]
; CHECK:       middle:
; CHECK-NEXT:    [[I5:%.*]] = phi i32 [ [[I0]], [[LEFT]] ], [ [[I3]], [[RIGHT]] ], [ [[I5]], [[MIDDLE]] ]
; CHECK-NEXT:    [[I6:%.*]] = phi i32 [ [[I2]], [[LEFT]] ], [ [[I4]], [[RIGHT]] ], [ [[I6]], [[MIDDLE]] ]
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    [[C1:%.*]] = call i1 @geni1()
; CHECK-NEXT:    br i1 [[C1]], label [[END:%.*]], label [[MIDDLE]]
; CHECK:       end:
; CHECK-NEXT:    [[I7:%.*]] = insertvalue { i32, i32 } undef, i32 [[I5]], 0
; CHECK-NEXT:    [[I8:%.*]] = insertvalue { i32, i32 } [[I7]], i32 [[I6]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I8]]
;
entry:
  br i1 %c0, label %left, label %right

left:
  %i0 = extractvalue { i32, i32 } %agg_left, 0
  %i2 = extractvalue { i32, i32 } %agg_left, 1
  call void @foo()
  br label %middle

right:
  %i3 = extractvalue { i32, i32 } %agg_right, 0
  %i4 = extractvalue { i32, i32 } %agg_right, 1
  call void @bar()
  br label %middle

middle:
  %i5 = phi i32 [ %i0, %left ], [ %i3, %right ], [ %i5, %middle ]
  %i6 = phi i32 [ %i2, %left ], [ %i4, %right ], [ %i6, %middle ]
  call void @baz()
  %i7 = insertvalue { i32, i32 } undef, i32 %i5, 0
  %i8 = insertvalue { i32, i32 } %i7, i32 %i6, 1
  %c1 = call i1 @geni1()
  br i1 %c1, label %end, label %middle

end:
  ret { i32, i32 } %i8
}

; But here since we start without an explicit self-cycle, we already manage to fold it.
define { i32, i32 } @test5({ i32, i32 } %agg_left, { i32, i32 } %agg_right, i1 %c0) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C0:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[MIDDLE:%.*]]
; CHECK:       right:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[MIDDLE]]
; CHECK:       middle:
; CHECK-NEXT:    [[I8:%.*]] = phi { i32, i32 } [ [[I8]], [[MIDDLE]] ], [ [[AGG_RIGHT:%.*]], [[RIGHT]] ], [ [[AGG_LEFT:%.*]], [[LEFT]] ]
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    [[C1:%.*]] = call i1 @geni1()
; CHECK-NEXT:    br i1 [[C1]], label [[END:%.*]], label [[MIDDLE]]
; CHECK:       end:
; CHECK-NEXT:    ret { i32, i32 } [[I8]]
;
entry:
  br i1 %c0, label %left, label %right

left:
  %i0 = extractvalue { i32, i32 } %agg_left, 0
  %i2 = extractvalue { i32, i32 } %agg_left, 1
  call void @foo()
  br label %middle

right:
  %i3 = extractvalue { i32, i32 } %agg_right, 0
  %i4 = extractvalue { i32, i32 } %agg_right, 1
  call void @bar()
  br label %middle

middle:
  %i5 = phi i32 [ %i0, %left ], [ %i3, %right ], [ %i9, %middle ]
  %i6 = phi i32 [ %i2, %left ], [ %i4, %right ], [ %i10, %middle ]
  call void @baz()
  %i7 = insertvalue { i32, i32 } undef, i32 %i5, 0
  %i8 = insertvalue { i32, i32 } %i7, i32 %i6, 1
  %i9 = extractvalue { i32, i32 } %i8, 0
  %i10 = extractvalue { i32, i32 } %i8, 1
  %c1 = call i1 @geni1()
  br i1 %c1, label %end, label %middle

end:
  ret { i32, i32 } %i8
}

; Diamond structure, but with "padding" block before the use.
define { i32, i32 } @test6({ i32, i32 } %agg_left, { i32, i32 } %agg_right, i1 %c0, i1 %c1) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C0:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT:%.*]], 0
; CHECK-NEXT:    [[I2:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT]], 1
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       right:
; CHECK-NEXT:    [[I3:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT:%.*]], 0
; CHECK-NEXT:    [[I4:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT]], 1
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[I5:%.*]] = phi i32 [ [[I0]], [[LEFT]] ], [ [[I3]], [[RIGHT]] ]
; CHECK-NEXT:    [[I6:%.*]] = phi i32 [ [[I2]], [[LEFT]] ], [ [[I4]], [[RIGHT]] ]
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[END:%.*]], label [[PASSTHROUGH:%.*]]
; CHECK:       passthrough:
; CHECK-NEXT:    call void @qux()
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    call void @quux()
; CHECK-NEXT:    [[I7:%.*]] = insertvalue { i32, i32 } undef, i32 [[I5]], 0
; CHECK-NEXT:    [[I8:%.*]] = insertvalue { i32, i32 } [[I7]], i32 [[I6]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I8]]
;
entry:
  br i1 %c0, label %left, label %right

left:
  %i0 = extractvalue { i32, i32 } %agg_left, 0
  %i2 = extractvalue { i32, i32 } %agg_left, 1
  call void @foo()
  br label %merge

right:
  %i3 = extractvalue { i32, i32 } %agg_right, 0
  %i4 = extractvalue { i32, i32 } %agg_right, 1
  call void @bar()
  br label %merge

merge:
  %i5 = phi i32 [ %i0, %left ], [ %i3, %right ]
  %i6 = phi i32 [ %i2, %left ], [ %i4, %right ]
  call void @baz()
  br i1 %c1, label %end, label %passthrough

passthrough:
  call void @qux()
  br label %end

end:
  call void @quux()
  %i7 = insertvalue { i32, i32 } undef, i32 %i5, 0
  %i8 = insertvalue { i32, i32 } %i7, i32 %i6, 1
  ret { i32, i32 } %i8
}

; All the definitions of the aggregate elements must happen in the same block.
define { i32, i32 } @negative_test7({ i32, i32 } %agg_left, { i32, i32 } %agg_right, i1 %c0, i1 %c1) {
; CHECK-LABEL: @negative_test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[I0:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT:%.*]], 0
; CHECK-NEXT:    call void @usei32(i32 [[I0]])
; CHECK-NEXT:    br i1 [[C0:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    [[I1:%.*]] = extractvalue { i32, i32 } [[AGG_LEFT]], 1
; CHECK-NEXT:    call void @usei32(i32 [[I1]])
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       right:
; CHECK-NEXT:    [[I2:%.*]] = extractvalue { i32, i32 } [[AGG_RIGHT:%.*]], 1
; CHECK-NEXT:    call void @usei32(i32 [[I2]])
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[I3:%.*]] = phi i32 [ [[I1]], [[LEFT]] ], [ [[I2]], [[RIGHT]] ]
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    [[I7:%.*]] = insertvalue { i32, i32 } undef, i32 [[I0]], 0
; CHECK-NEXT:    [[I8:%.*]] = insertvalue { i32, i32 } [[I7]], i32 [[I3]], 1
; CHECK-NEXT:    ret { i32, i32 } [[I8]]
;
entry:
  %i0 = extractvalue { i32, i32 } %agg_left, 0
  call void @usei32(i32 %i0)
  br i1 %c0, label %left, label %right

left:
  %i1 = extractvalue { i32, i32 } %agg_left, 1
  call void @usei32(i32 %i1)
  br label %merge

right:
  %i2 = extractvalue { i32, i32 } %agg_right, 1
  call void @usei32(i32 %i2)
  br label %merge

merge:
  %i3 = phi i32 [ %i1, %left ], [ %i2, %right ]
  call void @bar()
  br label %end

end:
  call void @baz()
  %i7 = insertvalue { i32, i32 } undef, i32 %i0, 0
  %i8 = insertvalue { i32, i32 } %i7, i32 %i3, 1
  ret { i32, i32 } %i8
}
