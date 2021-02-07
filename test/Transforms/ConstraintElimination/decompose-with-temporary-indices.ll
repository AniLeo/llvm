; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constraint-elimination -S %s | FileCheck %s

declare void @use(i1)


define void @test_uge_temporary_indices_decompose(i8 %start, i8 %n, i8 %idx) {
; CHECK-LABEL: @test_uge_temporary_indices_decompose(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_PRE:%.*]] = icmp ult i8 [[IDX:%.*]], [[N:%.*]]
; CHECK-NEXT:    [[START_ADD_IDX:%.*]] = add nuw nsw i8 [[START:%.*]], [[IDX]]
; CHECK-NEXT:    [[START_ADD_N:%.*]] = add nuw nsw i8 [[START]], [[N]]
; CHECK-NEXT:    [[START_ADD_1:%.*]] = add nuw nsw i8 [[START]], 1
; CHECK-NEXT:    br i1 [[CMP_PRE]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[T_0:%.*]] = icmp ult i8 [[START_ADD_IDX]], [[START_ADD_N]]
; CHECK-NEXT:    call void @use(i1 [[T_0]])
; CHECK-NEXT:    [[F_0:%.*]] = icmp uge i8 [[START_ADD_IDX]], [[START_ADD_N]]
; CHECK-NEXT:    call void @use(i1 [[F_0]])
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[START_ADD_1]], [[START_ADD_N]]
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i8 [[START_ADD_IDX]], [[START_ADD_1]]
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    ret void
; CHECK:       if.end:
; CHECK-NEXT:    [[F_1:%.*]] = icmp ult i8 [[START_ADD_IDX]], [[START_ADD_N]]
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i8 [[START_ADD_IDX]], [[START_ADD_N]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i8 [[START_ADD_1]], [[START_ADD_N]]
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp ult i8 [[START_ADD_IDX]], [[START_ADD_1]]
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
;
entry:
  %cmp.pre = icmp ult i8 %idx, %n
  %start.add.idx = add nuw nsw i8 %start, %idx
  %start.add.n = add nuw nsw i8 %start, %n
  %start.add.1 = add nuw nsw i8 %start, 1
  br i1 %cmp.pre, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %t.0 = icmp ult i8 %start.add.idx, %start.add.n
  call void @use(i1 %t.0)

  %f.0 = icmp uge i8 %start.add.idx, %start.add.n
  call void @use(i1 %f.0)

  %c.1 = icmp ult i8 %start.add.1, %start.add.n
  call void @use(i1 %c.1)

  %c.2 = icmp ult i8 %start.add.idx, %start.add.1
  call void @use(i1 %c.2)

  ret void


if.end:                                           ; preds = %entry
  %f.1 = icmp ult i8 %start.add.idx, %start.add.n
  call void @use(i1 %f.1)

  %t.1 = icmp uge i8 %start.add.idx, %start.add.n
  call void @use(i1 %t.1)

  %c.3 = icmp ult i8 %start.add.1, %start.add.n
  call void @use(i1 %c.3)

  %c.4 = icmp ult i8 %start.add.idx, %start.add.1
  call void @use(i1 %c.4)

  ret void
}
