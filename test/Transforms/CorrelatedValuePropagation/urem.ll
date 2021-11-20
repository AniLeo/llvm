; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s

define void @test_nop(i32 %n) {
; CHECK-LABEL: @test_nop(
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[N:%.*]], 100
; CHECK-NEXT:    ret void
;
  %div = udiv i32 %n, 100
  ret void
}

define void @test1(i32 %n) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i32 [[N:%.*]], 65535
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[DIV_LHS_TRUNC:%.*]] = trunc i32 [[N]] to i16
; CHECK-NEXT:    [[DIV1:%.*]] = urem i16 [[DIV_LHS_TRUNC]], 100
; CHECK-NEXT:    [[DIV_ZEXT:%.*]] = zext i16 [[DIV1]] to i32
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry: %cmp = icmp ule i32 %n, 65535
  br i1 %cmp, label %bb, label %exit

bb:
  %div = urem i32 %n, 100
  br label %exit

exit:
  ret void
}

define void @test2(i32 %n) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i32 [[N:%.*]], 65536
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[DIV:%.*]] = urem i32 [[N]], 100
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp ule i32 %n, 65536
  br i1 %cmp, label %bb, label %exit

bb:
  %div = urem i32 %n, 100
  br label %exit

exit:
  ret void
}

define void @test3(i32 %m, i32 %n) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[M:%.*]], 65535
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i32 [[N:%.*]], 65535
; CHECK-NEXT:    [[CMP:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[DIV_LHS_TRUNC:%.*]] = trunc i32 [[M]] to i16
; CHECK-NEXT:    [[DIV_RHS_TRUNC:%.*]] = trunc i32 [[N]] to i16
; CHECK-NEXT:    [[DIV1:%.*]] = urem i16 [[DIV_LHS_TRUNC]], [[DIV_RHS_TRUNC]]
; CHECK-NEXT:    [[DIV_ZEXT:%.*]] = zext i16 [[DIV1]] to i32
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp ult i32 %m, 65535
  %cmp2 = icmp ult i32 %n, 65535
  %cmp = and i1 %cmp1, %cmp2
  br i1 %cmp, label %bb, label %exit

bb:
  %div = urem i32 %m, %n
  br label %exit

exit:
  ret void
}

define void @test4(i32 %m, i32 %n) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[M:%.*]], 65535
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i32 [[N:%.*]], 65536
; CHECK-NEXT:    [[CMP:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[DIV:%.*]] = urem i32 [[M]], [[N]]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp1 = icmp ult i32 %m, 65535
  %cmp2 = icmp ule i32 %n, 65536
  %cmp = and i1 %cmp1, %cmp2
  br i1 %cmp, label %bb, label %exit

bb:
  %div = urem i32 %m, %n
  br label %exit

exit:
  ret void
}

define void @test5(i32 %n) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TRUNC:%.*]] = and i32 [[N:%.*]], 63
; CHECK-NEXT:    [[DIV_LHS_TRUNC:%.*]] = trunc i32 [[TRUNC]] to i8
; CHECK-NEXT:    [[DIV1:%.*]] = urem i8 [[DIV_LHS_TRUNC]], 42
; CHECK-NEXT:    [[DIV_ZEXT:%.*]] = zext i8 [[DIV1]] to i32
; CHECK-NEXT:    ret void
;
  %trunc = and i32 %n, 63
  %div = urem i32 %trunc, 42
  ret void
}

define void @test6(i32 %n) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i32 [[N:%.*]], 255
; CHECK-NEXT:    br i1 [[CMP]], label [[BB:%.*]], label [[EXIT:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[DIV1_LHS_TRUNC:%.*]] = trunc i32 [[N]] to i8
; CHECK-NEXT:    [[DIV12:%.*]] = urem i8 [[DIV1_LHS_TRUNC]], 100
; CHECK-NEXT:    [[DIV1_ZEXT:%.*]] = zext i8 [[DIV12]] to i32
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp ule i32 %n, 255
  br i1 %cmp, label %bb, label %exit

bb:
  %div = srem i32 %n, 100
  br label %exit

exit:
  ret void
}

define void @non_power_of_2(i24 %n) {
; CHECK-LABEL: @non_power_of_2(
; CHECK-NEXT:    [[DIV:%.*]] = urem i24 [[N:%.*]], 42
; CHECK-NEXT:    ret void
;
  %div = urem i24 %n, 42
  ret void
}

define void @urem_implied_cond_uge(i8 %x) {
; CHECK-LABEL: @urem_implied_cond_uge(
; CHECK-NEXT:    [[U:%.*]] = urem i8 [[X:%.*]], 5
; CHECK-NEXT:    [[C1:%.*]] = icmp uge i8 [[U]], 2
; CHECK-NEXT:    br i1 [[C1]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[C2:%.*]] = icmp ult i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C2]])
; CHECK-NEXT:    [[C3:%.*]] = icmp ule i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C3]])
; CHECK-NEXT:    [[C4:%.*]] = icmp uge i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C4]])
; CHECK-NEXT:    [[C5:%.*]] = icmp ugt i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C5]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    [[C2_2:%.*]] = icmp ult i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C2_2]])
; CHECK-NEXT:    [[C3_2:%.*]] = icmp ule i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C3_2]])
; CHECK-NEXT:    [[C4_2:%.*]] = icmp uge i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C4_2]])
; CHECK-NEXT:    [[C5_2:%.*]] = icmp ugt i8 [[X]], 2
; CHECK-NEXT:    call void @use(i1 [[C5_2]])
; CHECK-NEXT:    ret void
;
  %u = urem i8 %x, 5
  %c1 = icmp uge i8 %u, 2
  br i1 %c1, label %if, label %else

if:
  %c2 = icmp ult i8 %x, 2
  call void @use(i1 %c2)
  %c3 = icmp ule i8 %x, 2
  call void @use(i1 %c3)
  %c4 = icmp uge i8 %x, 2
  call void @use(i1 %c4)
  %c5 = icmp ugt i8 %x, 2
  call void @use(i1 %c5)
  ret void

else:
  %c2.2 = icmp ult i8 %x, 2
  call void @use(i1 %c2.2)
  %c3.2 = icmp ule i8 %x, 2
  call void @use(i1 %c3.2)
  %c4.2 = icmp uge i8 %x, 2
  call void @use(i1 %c4.2)
  %c5.2 = icmp ugt i8 %x, 2
  call void @use(i1 %c5.2)
  ret void
}

define void @urem_implied_cond_uge_out_of_range(i8 %x) {
; CHECK-LABEL: @urem_implied_cond_uge_out_of_range(
; CHECK-NEXT:    [[U:%.*]] = urem i8 [[X:%.*]], 5
; CHECK-NEXT:    br i1 false, label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[C2:%.*]] = icmp ult i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C2]])
; CHECK-NEXT:    [[C3:%.*]] = icmp ule i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C3]])
; CHECK-NEXT:    [[C4:%.*]] = icmp uge i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C4]])
; CHECK-NEXT:    [[C5:%.*]] = icmp ugt i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C5]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    [[C2_2:%.*]] = icmp ult i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C2_2]])
; CHECK-NEXT:    [[C3_2:%.*]] = icmp ule i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C3_2]])
; CHECK-NEXT:    [[C4_2:%.*]] = icmp uge i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C4_2]])
; CHECK-NEXT:    [[C5_2:%.*]] = icmp ugt i8 [[X]], 5
; CHECK-NEXT:    call void @use(i1 [[C5_2]])
; CHECK-NEXT:    ret void
;
  %u = urem i8 %x, 5
  %c1 = icmp uge i8 %u, 5
  br i1 %c1, label %if, label %else

if:
  %c2 = icmp ult i8 %x, 5
  call void @use(i1 %c2)
  %c3 = icmp ule i8 %x, 5
  call void @use(i1 %c3)
  %c4 = icmp uge i8 %x, 5
  call void @use(i1 %c4)
  %c5 = icmp ugt i8 %x, 5
  call void @use(i1 %c5)
  ret void

else:
  %c2.2 = icmp ult i8 %x, 5
  call void @use(i1 %c2.2)
  %c3.2 = icmp ule i8 %x, 5
  call void @use(i1 %c3.2)
  %c4.2 = icmp uge i8 %x, 5
  call void @use(i1 %c4.2)
  %c5.2 = icmp ugt i8 %x, 5
  call void @use(i1 %c5.2)
  ret void
}

define void @urem_implied_cond_ne_zero(i8 %x) {
; CHECK-LABEL: @urem_implied_cond_ne_zero(
; CHECK-NEXT:    [[U:%.*]] = urem i8 [[X:%.*]], 5
; CHECK-NEXT:    [[C1:%.*]] = icmp ne i8 [[U]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[C2:%.*]] = icmp ult i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C2]])
; CHECK-NEXT:    [[C3:%.*]] = icmp ule i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C3]])
; CHECK-NEXT:    [[C4:%.*]] = icmp uge i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C4]])
; CHECK-NEXT:    [[C5:%.*]] = icmp ugt i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C5]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    [[C2_2:%.*]] = icmp ult i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C2_2]])
; CHECK-NEXT:    [[C3_2:%.*]] = icmp ule i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C3_2]])
; CHECK-NEXT:    [[C4_2:%.*]] = icmp uge i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C4_2]])
; CHECK-NEXT:    [[C5_2:%.*]] = icmp ugt i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C5_2]])
; CHECK-NEXT:    ret void
;
  %u = urem i8 %x, 5
  %c1 = icmp ne i8 %u, 0
  br i1 %c1, label %if, label %else

if:
  %c2 = icmp ult i8 %x, 1
  call void @use(i1 %c2)
  %c3 = icmp ule i8 %x, 1
  call void @use(i1 %c3)
  %c4 = icmp uge i8 %x, 1
  call void @use(i1 %c4)
  %c5 = icmp ugt i8 %x, 1
  call void @use(i1 %c5)
  ret void

else:
  %c2.2 = icmp ult i8 %x, 1
  call void @use(i1 %c2.2)
  %c3.2 = icmp ule i8 %x, 1
  call void @use(i1 %c3.2)
  %c4.2 = icmp uge i8 %x, 1
  call void @use(i1 %c4.2)
  %c5.2 = icmp ugt i8 %x, 1
  call void @use(i1 %c5.2)
  ret void
}

define void @urem_implied_cond_ne_non_zero(i8 %x) {
; CHECK-LABEL: @urem_implied_cond_ne_non_zero(
; CHECK-NEXT:    [[U:%.*]] = urem i8 [[X:%.*]], 5
; CHECK-NEXT:    [[C1:%.*]] = icmp ne i8 [[U]], 1
; CHECK-NEXT:    br i1 [[C1]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[C2:%.*]] = icmp ult i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C2]])
; CHECK-NEXT:    [[C3:%.*]] = icmp ule i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C3]])
; CHECK-NEXT:    [[C4:%.*]] = icmp uge i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C4]])
; CHECK-NEXT:    [[C5:%.*]] = icmp ugt i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C5]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    [[C2_2:%.*]] = icmp ult i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C2_2]])
; CHECK-NEXT:    [[C3_2:%.*]] = icmp ule i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C3_2]])
; CHECK-NEXT:    [[C4_2:%.*]] = icmp uge i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C4_2]])
; CHECK-NEXT:    [[C5_2:%.*]] = icmp ugt i8 [[X]], 1
; CHECK-NEXT:    call void @use(i1 [[C5_2]])
; CHECK-NEXT:    ret void
;
  %u = urem i8 %x, 5
  %c1 = icmp ne i8 %u, 1
  br i1 %c1, label %if, label %else

if:
  %c2 = icmp ult i8 %x, 1
  call void @use(i1 %c2)
  %c3 = icmp ule i8 %x, 1
  call void @use(i1 %c3)
  %c4 = icmp uge i8 %x, 1
  call void @use(i1 %c4)
  %c5 = icmp ugt i8 %x, 1
  call void @use(i1 %c5)
  ret void

else:
  %c2.2 = icmp ult i8 %x, 1
  call void @use(i1 %c2.2)
  %c3.2 = icmp ule i8 %x, 1
  call void @use(i1 %c3.2)
  %c4.2 = icmp uge i8 %x, 1
  call void @use(i1 %c4.2)
  %c5.2 = icmp ugt i8 %x, 1
  call void @use(i1 %c5.2)
  ret void
}

declare void @use(i1)
