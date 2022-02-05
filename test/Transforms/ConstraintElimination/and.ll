; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @use(i1)

define i1 @test_and_ule(i4 %x, i4 %y, i4 %z, i4 %a) {
; CHECK-LABEL: @test_and_ule(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ule i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ule i4 [[Y]], [[Z:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[C_1]], [[C_2]]
; CHECK-NEXT:    br i1 [[AND]], label [[BB1:%.*]], label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp ule i4 [[X]], [[Z]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp ule i4 [[X]], [[Y]]
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[T_3:%.*]] = icmp ule i4 [[Y]], [[Z]]
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], true
; CHECK-NEXT:    [[C_3:%.*]] = icmp ule i4 [[X]], [[A:%.*]]
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_3]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       exit:
; CHECK-NEXT:    [[C_4:%.*]] = icmp ule i4 [[X]], [[Z]]
; CHECK-NEXT:    [[C_5:%.*]] = icmp ule i4 [[X]], [[A]]
; CHECK-NEXT:    [[R_4:%.*]] = xor i1 [[C_4]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp ule i4 [[X]], [[Y]]
; CHECK-NEXT:    [[R_5:%.*]] = xor i1 [[R_4]], [[C_6]]
; CHECK-NEXT:    [[C_7:%.*]] = icmp ule i4 [[Y]], [[Z]]
; CHECK-NEXT:    [[R_6:%.*]] = xor i1 [[R_5]], [[C_7]]
; CHECK-NEXT:    ret i1 [[R_6]]
;
entry:
  %c.1 = icmp ule i4 %x, %y
  %c.2 = icmp ule i4 %y, %z
  %and = and i1 %c.1, %c.2
  br i1 %and, label %bb1, label %exit

bb1:
  %t.1 = icmp ule i4 %x, %z
  %t.2 = icmp ule i4 %x, %y
  %r.1 = xor i1 %t.1, %t.2

  %t.3 = icmp ule i4 %y, %z
  %r.2 = xor i1 %r.1, %t.3


  %c.3 = icmp ule i4 %x, %a
  %r.3 = xor i1 %r.2, %c.3

  ret i1 %r.3

exit:
  %c.4 = icmp ule i4 %x, %z
  %c.5 = icmp ule i4 %x, %a
  %r.4 = xor i1 %c.4, %c.5

  %c.6 = icmp ule i4 %x, %y
  %r.5 = xor i1 %r.4, %c.6

  %c.7 = icmp ule i4 %y, %z
  %r.6 = xor i1 %r.5, %c.7

  ret i1 %r.6
}

; The result of test_and_ule and test_and_select_ule should be same
define i1 @test_and_select_ule(i4 %x, i4 %y, i4 %z, i4 %a) {
; CHECK-LABEL: @test_and_select_ule(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ule i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ule i4 [[Y]], [[Z:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[C_1]], i1 [[C_2]], i1 false
; CHECK-NEXT:    br i1 [[AND]], label [[BB1:%.*]], label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp ule i4 [[X]], [[Z]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp ule i4 [[X]], [[Y]]
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[T_3:%.*]] = icmp ule i4 [[Y]], [[Z]]
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], true
; CHECK-NEXT:    [[C_3:%.*]] = icmp ule i4 [[X]], [[A:%.*]]
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_3]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       exit:
; CHECK-NEXT:    [[C_4:%.*]] = icmp ule i4 [[X]], [[Z]]
; CHECK-NEXT:    [[C_5:%.*]] = icmp ule i4 [[X]], [[A]]
; CHECK-NEXT:    [[R_4:%.*]] = xor i1 [[C_4]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp ule i4 [[X]], [[Y]]
; CHECK-NEXT:    [[R_5:%.*]] = xor i1 [[R_4]], [[C_6]]
; CHECK-NEXT:    [[C_7:%.*]] = icmp ule i4 [[Y]], [[Z]]
; CHECK-NEXT:    [[R_6:%.*]] = xor i1 [[R_5]], [[C_7]]
; CHECK-NEXT:    ret i1 [[R_6]]
;
entry:
  %c.1 = icmp ule i4 %x, %y
  %c.2 = icmp ule i4 %y, %z
  %and = select i1 %c.1, i1 %c.2, i1 false
  br i1 %and, label %bb1, label %exit

bb1:
  %t.1 = icmp ule i4 %x, %z
  %t.2 = icmp ule i4 %x, %y
  %r.1 = xor i1 %t.1, %t.2

  %t.3 = icmp ule i4 %y, %z
  %r.2 = xor i1 %r.1, %t.3

  %c.3 = icmp ule i4 %x, %a
  %r.3 = xor i1 %r.2, %c.3
  ret i1 %r.3

exit:
  %c.4 = icmp ule i4 %x, %z
  %c.5 = icmp ule i4 %x, %a
  %r.4 = xor i1 %c.4, %c.5

  %c.6 = icmp ule i4 %x, %y
  %r.5 = xor i1 %r.4, %c.6

  %c.7 = icmp ule i4 %y, %z
  %r.6 = xor i1 %r.5, %c.7
  ret i1 %r.6
}

define i4 @and_compare_undef(i4 %N, i4 %step) {
; CHECK-LABEL: @and_compare_undef(
; CHECK-NEXT:  step.check:
; CHECK-NEXT:    [[STEP_POS:%.*]] = icmp uge i4 [[STEP:%.*]], 0
; CHECK-NEXT:    [[B1:%.*]] = add i4 undef, -1
; CHECK-NEXT:    [[STEP_ULT_N:%.*]] = icmp ult i4 [[B1]], [[N:%.*]]
; CHECK-NEXT:    [[AND_STEP:%.*]] = and i1 [[STEP_POS]], [[STEP_ULT_N]]
; CHECK-NEXT:    br i1 [[AND_STEP]], label [[PTR_CHECK:%.*]], label [[EXIT:%.*]]
; CHECK:       ptr.check:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret i4 3
;
step.check:
  %step.pos = icmp uge i4 %step, 0
  %B1 = add i4 undef, -1
  %step.ult.N = icmp ult i4 %B1, %N
  %and.step = and i1 %step.pos, %step.ult.N
  br i1 %and.step, label %ptr.check, label %exit

ptr.check:
  br label %exit

exit:
  ret i4 3
}

define i1 @test_and_condition_trivially_false(i1 %c, i8* %ptr.1, i8 %idx, i8* %ptr.2) {
; CHECK-LABEL: @test_and_condition_trivially_false(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[THEN:%.*]], label [[EXIT_3:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp ugt i8* [[PTR_2:%.*]], [[PTR_2]]
; CHECK-NEXT:    [[IDX_EXT:%.*]] = zext i8 [[IDX:%.*]] to i16
; CHECK-NEXT:    [[GEP_IDX_EXT:%.*]] = getelementptr inbounds i8, i8* [[PTR_1:%.*]], i16 [[IDX_EXT]]
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp ult i8* [[PTR_2]], [[GEP_IDX_EXT]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 false, [[CMP_2]]
; CHECK-NEXT:    br i1 [[AND]], label [[EXIT_1:%.*]], label [[EXIT_2:%.*]]
; CHECK:       exit.1:
; CHECK-NEXT:    ret i1 true
; CHECK:       exit.2:
; CHECK-NEXT:    ret i1 false
; CHECK:       exit.3:
; CHECK-NEXT:    [[CMP_3:%.*]] = icmp ne i8 [[IDX]], 0
; CHECK-NEXT:    ret i1 [[CMP_3]]
;
entry:
  br i1 %c, label %then, label %exit.3

then:
  %cmp.1 = icmp ugt i8* %ptr.2, %ptr.2
  %idx.ext = zext i8 %idx to i16
  %gep.idx.ext = getelementptr inbounds i8, i8* %ptr.1, i16 %idx.ext
  %cmp.2 = icmp ult i8* %ptr.2, %gep.idx.ext
  %and = and i1 %cmp.1, %cmp.2
  br i1 %and, label %exit.1, label %exit.2

exit.1:
  ret i1 1

exit.2:
  ret i1 0

exit.3:
  %cmp.3 = icmp ne i8 %idx, 0
  ret i1 %cmp.3
}
