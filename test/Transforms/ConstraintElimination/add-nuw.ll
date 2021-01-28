; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constraint-elimination -S %s | FileCheck %s

define void @test.not.uge.ult(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD_PTR_I:%.*]] = add nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[ADD_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[T_0:%.*]] = icmp ult i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_1:%.*]] = add nuw i8 [[START]], 1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_2:%.*]] = add nuw i8 [[START]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp ult i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_3:%.*]] = add nuw i8 [[START]], 3
; CHECK-NEXT:    [[T_3:%.*]] = icmp ult i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_4:%.*]] = add nuw i8 [[START]], 4
; CHECK-NEXT:    [[C_4:%.*]] = icmp ult i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
;
entry:
  %add.ptr.i = add nuw i8 %start, 3
  %c.1 = icmp uge i8 %add.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %t.0 = icmp ult i8 %start, %high
  call void @use(i1 %t.0)
  %start.1 = add nuw i8 %start, 1
  %t.1 = icmp ult i8 %start.1, %high
  call void @use(i1 %t.1)
  %start.2 = add nuw i8 %start, 2
  %t.2 = icmp ult i8 %start.2, %high
  call void @use(i1 %t.2)
  %start.3 = add nuw i8 %start, 3
  %t.3 = icmp ult i8 %start.3, %high
  call void @use(i1 %t.3)
  %start.4 = add nuw i8 %start, 4
  %c.4 = icmp ult i8 %start.4, %high
  call void @use(i1 %c.4)
  ret void
}

define void @test.not.uge.ule(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ule(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD_PTR_I:%.*]] = add nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[ADD_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[T_0:%.*]] = icmp ule i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_1:%.*]] = add nuw i8 [[START]], 1
; CHECK-NEXT:    [[T_1:%.*]] = icmp ule i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_2:%.*]] = add nuw i8 [[START]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp ule i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_3:%.*]] = add nuw i8 [[START]], 3
; CHECK-NEXT:    [[T_3:%.*]] = icmp ule i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_4:%.*]] = add nuw i8 [[START]], 4
; CHECK-NEXT:    [[T_4:%.*]] = icmp ule i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[START_5:%.*]] = add nuw i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp ule i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %add.ptr.i = add nuw i8 %start, 3
  %c.1 = icmp uge i8 %add.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %t.0 = icmp ule i8 %start, %high
  call void @use(i1 %t.0)
  %start.1 = add nuw i8 %start, 1
  %t.1 = icmp ule i8 %start.1, %high
  call void @use(i1 %t.1)
  %start.2 = add nuw i8 %start, 2
  %t.2 = icmp ule i8 %start.2, %high
  call void @use(i1 %t.2)
  %start.3 = add nuw i8 %start, 3
  %t.3 = icmp ule i8 %start.3, %high
  call void @use(i1 %t.3)
  %start.4 = add nuw i8 %start, 4
  %t.4 = icmp ule i8 %start.4, %high
  call void @use(i1 %t.4)

  %start.5 = add nuw i8 %start, 5
  %c.5 = icmp ule i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define void @test.not.uge.ugt(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.ugt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD_PTR_I:%.*]] = add nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[ADD_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[F_0:%.*]] = icmp ugt i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_1:%.*]] = add nuw i8 [[START]], 1
; CHECK-NEXT:    [[F_1:%.*]] = icmp ugt i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_2:%.*]] = add nuw i8 [[START]], 2
; CHECK-NEXT:    [[F_2:%.*]] = icmp ugt i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_3:%.*]] = add nuw i8 [[START]], 3
; CHECK-NEXT:    [[F_3:%.*]] = icmp ugt i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_4:%.*]] = add nuw i8 [[START]], 4
; CHECK-NEXT:    [[F_4:%.*]] = icmp ugt i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_5:%.*]] = add nuw i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp ugt i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %add.ptr.i = add nuw i8 %start, 3
  %c.1 = icmp uge i8 %add.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %f.0 = icmp ugt i8 %start, %high
  call void @use(i1 %f.0)

  %start.1 = add nuw i8 %start, 1
  %f.1 = icmp ugt i8 %start.1, %high
  call void @use(i1 %f.1)

  %start.2 = add nuw i8 %start, 2
  %f.2 = icmp ugt i8 %start.2, %high
  call void @use(i1 %f.2)

  %start.3 = add nuw i8 %start, 3
  %f.3 = icmp ugt i8 %start.3, %high
  call void @use(i1 %f.3)

  %start.4 = add nuw i8 %start, 4
  %f.4 = icmp ugt i8 %start.4, %high
  call void @use(i1 %f.4)

  %start.5 = add nuw i8 %start, 5
  %c.5 = icmp ugt i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define void @test.not.uge.uge(i8 %start, i8 %low, i8 %high) {
; CHECK-LABEL: @test.not.uge.uge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD_PTR_I:%.*]] = add nuw i8 [[START:%.*]], 3
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[ADD_PTR_I]], [[HIGH:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[F_0:%.*]] = icmp ugt i8 [[START]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_1:%.*]] = add nuw i8 [[START]], 1
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i8 [[START_1]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_2:%.*]] = add nuw i8 [[START]], 2
; CHECK-NEXT:    [[F_2:%.*]] = icmp uge i8 [[START_2]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_3:%.*]] = add nuw i8 [[START]], 3
; CHECK-NEXT:    [[F_3:%.*]] = icmp uge i8 [[START_3]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[START_4:%.*]] = add nuw i8 [[START]], 4
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i8 [[START_4]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    [[START_5:%.*]] = add nuw i8 [[START]], 5
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i8 [[START_5]], [[HIGH]]
; CHECK-NEXT:    call void @use(i1 [[C_5]])
; CHECK-NEXT:    ret void
;
entry:
  %add.ptr.i = add nuw i8 %start, 3
  %c.1 = icmp uge i8 %add.ptr.i, %high
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %f.0 = icmp ugt i8 %start, %high
  call void @use(i1 %f.0)

  %start.1 = add nuw i8 %start, 1
  %f.1 = icmp uge i8 %start.1, %high
  call void @use(i1 %f.1)

  %start.2 = add nuw i8 %start, 2
  %f.2 = icmp uge i8 %start.2, %high
  call void @use(i1 %f.2)

  %start.3 = add nuw i8 %start, 3
  %f.3 = icmp uge i8 %start.3, %high
  call void @use(i1 %f.3)

  %start.4 = add nuw i8 %start, 4
  %c.4 = icmp uge i8 %start.4, %high
  call void @use(i1 %c.4)

  %start.5 = add nuw i8 %start, 5
  %c.5 = icmp uge i8 %start.5, %high
  call void @use(i1 %c.5)

  ret void
}

define void @test.decompose.nonconst(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @test.decompose.nonconst(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_0:%.*]] = icmp uge i8 [[A:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[B:%.*]], [[C]]
; CHECK-NEXT:    [[AND_0:%.*]] = and i1 [[C_0]], [[C_1]]
; CHECK-NEXT:    br i1 [[AND_0]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[C_2:%.*]] = icmp uge i8 [[A]], 0
; CHECK-NEXT:    [[C_3:%.*]] = icmp uge i8 [[B]], 0
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[C_2]], [[C_3]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[IF_THEN_2:%.*]], label [[IF_END]]
; CHECK:       if.then.2:
; CHECK-NEXT:    [[ADD_0:%.*]] = add nuw i8 [[A]], [[B]]
; CHECK-NEXT:    [[T_0:%.*]] = icmp uge i8 [[ADD_0]], [[C]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[ADD_1:%.*]] = add nuw i8 [[A]], [[A]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i8 [[ADD_0]], [[C]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[ADD_2:%.*]] = add nuw i8 [[A]], [[D:%.*]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i8 [[ADD_2]], [[C]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:
  %c.0 = icmp uge i8 %a, %c
  %c.1 = icmp uge i8 %b, %c
  %and.0 = and i1 %c.0, %c.1
  br i1 %and.0, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %c.2 = icmp uge i8 %a, 0
  %c.3 = icmp uge i8 %b, 0
  %and.1 = and i1 %c.2, %c.3
  br i1 %and.1, label %if.then.2, label %if.end

if.then.2:
  %add.0 = add nuw i8 %a, %b
  %t.0 = icmp uge i8 %add.0, %c
  call void @use(i1 %t.0)
  %add.1 = add nuw i8 %a, %a
  %t.1 = icmp uge i8 %add.0, %c
  call void @use(i1 %t.1)
  %add.2 = add nuw i8 %a, %d
  %c.4 = icmp uge i8 %add.2, %c
  call void @use(i1 %c.4)
  ret void

if.end:                                           ; preds = %entry
  ret void
}

define void @test.decompose.nonconst.no.null.check(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @test.decompose.nonconst.no.null.check(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_0:%.*]] = icmp uge i8 [[A:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[B:%.*]], [[C]]
; CHECK-NEXT:    [[AND_0:%.*]] = and i1 [[C_0]], [[C_1]]
; CHECK-NEXT:    br i1 [[AND_0]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[ADD_0:%.*]] = add nuw i8 [[A]], [[B]]
; CHECK-NEXT:    [[T_0:%.*]] = icmp uge i8 [[ADD_0]], [[C]]
; CHECK-NEXT:    call void @use(i1 [[T_0]])
; CHECK-NEXT:    [[ADD_1:%.*]] = add nuw i8 [[A]], [[A]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i8 [[ADD_0]], [[C]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[ADD_2:%.*]] = add nuw i8 [[A]], [[D:%.*]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i8 [[ADD_2]], [[C]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:
  %c.0 = icmp uge i8 %a, %c
  %c.1 = icmp uge i8 %b, %c
  %and.0 = and i1 %c.0, %c.1
  br i1 %and.0, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %add.0 = add nuw i8 %a, %b
  %t.0 = icmp uge i8 %add.0, %c
  call void @use(i1 %t.0)
  %add.1 = add nuw i8 %a, %a
  %t.1 = icmp uge i8 %add.0, %c
  call void @use(i1 %t.1)
  %add.2 = add nuw i8 %a, %d
  %c.4 = icmp uge i8 %add.2, %c
  call void @use(i1 %c.4)
  ret void

if.end:                                           ; preds = %entry
  ret void
}


define i1 @test_n_must_ule_1_due_to_nuw(i8 %n, i8 %i) {
entry:
  %sub.n.1 = add nuw i8 %n, -1
  %add = add nuw i8 %i, %sub.n.1
  %c.1 = icmp uge i8 %i, %add
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %t = icmp ule i8 %n, 1
  ret i1 %t

if.end:                                           ; preds = %entry
  %f = icmp ule i8 %n, 1
  ret i1 %f
}


define i1 @test_n_unknown_missing_nuw(i8 %n, i8 %i) {
entry:
  %sub.n.1 = add i8 %n, -1
  %add = add i8 %i, %sub.n.1
  %c.1 = icmp uge i8 %i, %add
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %t = icmp ule i8 %n, 1
  ret i1 %t

if.end:                                           ; preds = %entry
  %f = icmp ule i8 %n, 1
  ret i1 %f
}

define i1 @test_n_must_ule_2_due_to_nuw(i8 %n, i8 %i) {
entry:
  %sub.n.1 = add nuw i8 %n, -2
  %add = add nuw i8 %i, %sub.n.1
  %c.1 = icmp uge i8 %i, %add
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %t = icmp ule i8 %n, 2
  ret i1 %t

if.end:                                           ; preds = %entry
  %f = icmp ule i8 %n, 2
  ret i1 %f
}


define i1 @test_n_unknown_missing_nuw2(i8 %n, i8 %i) {
entry:
  %sub.n.1 = add i8 %n, -2
  %add = add i8 %i, %sub.n.1
  %c.1 = icmp uge i8 %i, %add
  br i1 %c.1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %t = icmp ule i8 %n, 1
  ret i1 %t

if.end:                                           ; preds = %entry
  %f = icmp ule i8 %n, 1
  ret i1 %f
}

declare void @use(i1)
