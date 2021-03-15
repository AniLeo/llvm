; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -constraint-elimination -S %s | FileCheck %s

; Tests for cases with explicit checks that %ptr + x >= %ptr. The information can
; be used to determine that certain GEPs do not overflow.

define i1 @overflow_check_1(i32* %dst) {
; CHECK-LABEL: @overflow_check_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 5
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    br i1 [[DST_5_UGE]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[TRUE_DST_4_UGE:%.*]] = icmp uge i32* [[DST_4]], [[DST]]
; CHECK-NEXT:    ret i1 [[TRUE_DST_4_UGE]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  br i1 %dst.5.uge, label %then, label %else

then:
  %dst.4 = getelementptr i32, i32* %dst, i64 4
  %true.dst.4.uge = icmp uge i32* %dst.4, %dst
  ret i1 %true.dst.4.uge

else:
  ret i1 0
}

define i1 @overflow_check_2_and(i32* %dst) {
; CHECK-LABEL: @overflow_check_2_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 5
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[DST_5_UGE]], [[DST_5_UGE]]
; CHECK-NEXT:    br i1 [[AND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[TRUE_DST_4_UGE:%.*]] = icmp uge i32* [[DST_4]], [[DST]]
; CHECK-NEXT:    ret i1 [[TRUE_DST_4_UGE]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %and = and i1 %dst.5.uge, %dst.5.uge
  br i1 %and, label %then, label %else

then:
  %dst.4 = getelementptr i32, i32* %dst, i64 4
  %true.dst.4.uge = icmp uge i32* %dst.4, %dst
  ret i1 %true.dst.4.uge

else:
  ret i1 true
}

define i1 @overflow_check_3_and(i32* %dst) {
; CHECK-LABEL: @overflow_check_3_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 5
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[DST_5_UGE]], [[DST_5_UGE]]
; CHECK-NEXT:    br i1 [[AND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[DST_4_UGE:%.*]] = icmp uge i32* [[DST_4]], [[DST]]
; CHECK-NEXT:    ret i1 [[DST_4_UGE]]
; CHECK:       else:
; CHECK-NEXT:    [[ELSE_DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[ELSE_DST_4_UGE:%.*]] = icmp uge i32* [[ELSE_DST_4]], [[DST]]
; CHECK-NEXT:    ret i1 [[ELSE_DST_4_UGE]]
;
entry:
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %and = and i1 %dst.5.uge, %dst.5.uge
  br i1 %and, label %then, label %else

then:
  %dst.4 = getelementptr i32, i32* %dst, i64 4
  %dst.4.uge = icmp uge i32* %dst.4, %dst
  ret i1 %dst.4.uge

else:
  %else.dst.4 = getelementptr i32, i32* %dst, i64 4
  %else.dst.4.uge = icmp uge i32* %else.dst.4, %dst
  ret i1 %else.dst.4.uge
}

define i1 @overflow_check_4_and(i32* %dst) {
; CHECK-LABEL: @overflow_check_4_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 5
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[DST_5_UGE]], [[DST_5_UGE]]
; CHECK-NEXT:    br i1 [[AND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[TRUE_DST_4_UGE:%.*]] = icmp uge i32* [[DST_4]], [[DST]]
; CHECK-NEXT:    [[DST_5_2:%.*]] = getelementptr i32, i32* [[DST]], i64 5
; CHECK-NEXT:    [[TRUE_DST_5_UGE:%.*]] = icmp uge i32* [[DST_5_2]], [[DST]]
; CHECK-NEXT:    [[RES_0:%.*]] = xor i1 [[TRUE_DST_4_UGE]], [[TRUE_DST_5_UGE]]
; CHECK-NEXT:    [[DST_6:%.*]] = getelementptr i32, i32* [[DST]], i64 6
; CHECK-NEXT:    [[C_DST_6_UGE:%.*]] = icmp uge i32* [[DST_6]], [[DST]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[RES_0]], [[C_DST_6_UGE]]
; CHECK-NEXT:    ret i1 [[RES_1]]
; CHECK:       else:
; CHECK-NEXT:    [[ELSE_DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[ELSE_DST_4_UGE:%.*]] = icmp uge i32* [[ELSE_DST_4]], [[DST]]
; CHECK-NEXT:    [[ELSE_DST_6:%.*]] = getelementptr i32, i32* [[DST]], i64 6
; CHECK-NEXT:    [[ELSE_DST_6_UGE:%.*]] = icmp uge i32* [[ELSE_DST_6]], [[DST]]
; CHECK-NEXT:    [[ELSE_RES_0:%.*]] = xor i1 [[ELSE_DST_4_UGE]], [[ELSE_DST_6_UGE]]
; CHECK-NEXT:    ret i1 [[ELSE_RES_0]]
;
entry:
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %and = and i1 %dst.5.uge, %dst.5.uge
  br i1 %and, label %then, label %else

then:
  %dst.4 = getelementptr i32, i32* %dst, i64 4
  %true.dst.4.uge = icmp uge i32* %dst.4, %dst
  %dst.5.2 = getelementptr i32, i32* %dst, i64 5
  %true.dst.5.uge = icmp uge i32* %dst.5.2, %dst
  %res.0 = xor i1 %true.dst.4.uge, %true.dst.5.uge

  %dst.6 = getelementptr i32, i32* %dst, i64 6
  %c.dst.6.uge = icmp uge i32* %dst.6, %dst
  %res.1 = xor i1 %res.0, %c.dst.6.uge

  ret i1 %res.1

else:
  %else.dst.4 = getelementptr i32, i32* %dst, i64 4
  %else.dst.4.uge = icmp uge i32* %else.dst.4, %dst
  %else.dst.6 = getelementptr i32, i32* %dst, i64 6
  %else.dst.6.uge = icmp uge i32* %else.dst.6, %dst
  %else.res.0 = xor i1 %else.dst.4.uge, %else.dst.6.uge

  ret i1 %else.res.0
}

define i1 @overflow_check_3_or(i32* %dst) {
; CHECK-LABEL: @overflow_check_3_or(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 5
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[DST_5_UGE]], [[DST_5_UGE]]
; CHECK-NEXT:    br i1 [[OR]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[TRUE_DST_4_UGE:%.*]] = icmp uge i32* [[DST_4]], [[DST]]
; CHECK-NEXT:    ret i1 [[TRUE_DST_4_UGE]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %or = or i1 %dst.5.uge, %dst.5.uge
  br i1 %or, label %then, label %else

then:
  %dst.4 = getelementptr i32, i32* %dst, i64 4
  %true.dst.4.uge = icmp uge i32* %dst.4, %dst
  ret i1 %true.dst.4.uge

else:
  ret i1 0
}

define i1 @upper_and_lower_checks_1(i32* %dst, i32 %n) {
; CHECK-LABEL: @upper_and_lower_checks_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[N_EXT:%.*]] = zext i32 [[N:%.*]] to i64
; CHECK-NEXT:    [[UPPER:%.*]] = getelementptr inbounds i32, i32* [[DST:%.*]], i64 [[N_EXT]]
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST]], i64 5
; CHECK-NEXT:    [[DST_5_ULT:%.*]] = icmp ult i32* [[DST_5]], [[UPPER]]
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[DST_5_ULT]], [[DST_5_UGE]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[TRUE_DST_4_ULT:%.*]] = icmp ult i32* [[DST_4]], [[UPPER]]
; CHECK-NEXT:    [[TRUE_DST_4_UGE:%.*]] = icmp uge i32* [[DST_4]], [[DST]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[TRUE_DST_4_ULT]], [[TRUE_DST_4_UGE]]
; CHECK-NEXT:    ret i1 [[AND]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %n.ext = zext i32 %n to i64
  %upper = getelementptr inbounds i32, i32* %dst, i64 %n.ext
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.ult = icmp ult i32* %dst.5, %upper
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %and.1 = and i1 %dst.5.ult, %dst.5.uge
  br i1 %and.1, label %then, label %else

then:
  %dst.4 = getelementptr i32, i32* %dst, i64 4
  %true.dst.4.ult = icmp ult i32* %dst.4, %upper
  %true.dst.4.uge = icmp uge i32* %dst.4, %dst
  %and = and i1 %true.dst.4.ult, %true.dst.4.uge
  ret i1 %and

else:
  ret i1 0
}

define i1 @upper_and_lower_checks_2_dst6(i32* %dst, i32 %n) {
; CHECK-LABEL: @upper_and_lower_checks_2_dst6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[N_EXT:%.*]] = zext i32 [[N:%.*]] to i64
; CHECK-NEXT:    [[UPPER:%.*]] = getelementptr inbounds i32, i32* [[DST:%.*]], i64 [[N_EXT]]
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST]], i64 5
; CHECK-NEXT:    [[DST_5_ULT:%.*]] = icmp ult i32* [[DST_5]], [[UPPER]]
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[DST_5_ULT]], [[DST_5_UGE]]
; CHECK-NEXT:    br i1 [[AND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_6:%.*]] = getelementptr i32, i32* [[DST]], i64 6
; CHECK-NEXT:    [[C_DST_6_ULT:%.*]] = icmp ult i32* [[DST_6]], [[UPPER]]
; CHECK-NEXT:    [[TRUE_DST_6_UGE:%.*]] = icmp uge i32* [[DST_6]], [[DST]]
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[C_DST_6_ULT]], [[TRUE_DST_6_UGE]]
; CHECK-NEXT:    ret i1 [[RES]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %n.ext = zext i32 %n to i64
  %upper = getelementptr inbounds i32, i32* %dst, i64 %n.ext
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.ult = icmp ult i32* %dst.5, %upper
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %and = and i1 %dst.5.ult, %dst.5.uge
  br i1 %and, label %then, label %else

then:
  %dst.6 = getelementptr i32, i32* %dst, i64 6
  %c.dst.6.ult = icmp ult i32* %dst.6, %upper
  %true.dst.6.uge = icmp uge i32* %dst.6, %dst
  %res = and i1 %c.dst.6.ult, %true.dst.6.uge
  ret i1 %res

else:
  ret i1 0
}

define i1 @upper_and_lower_checks_2_dst7(i32* %dst, i32 %n) {
; CHECK-LABEL: @upper_and_lower_checks_2_dst7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[N_EXT:%.*]] = zext i32 [[N:%.*]] to i64
; CHECK-NEXT:    [[UPPER:%.*]] = getelementptr inbounds i32, i32* [[DST:%.*]], i64 [[N_EXT]]
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST]], i64 5
; CHECK-NEXT:    [[DST_5_ULT:%.*]] = icmp ult i32* [[DST_5]], [[UPPER]]
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[DST_5_ULT]], [[DST_5_UGE]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_7:%.*]] = getelementptr i32, i32* [[DST]], i64 7
; CHECK-NEXT:    [[C_DST_7_ULT:%.*]] = icmp ult i32* [[DST_7]], [[UPPER]]
; CHECK-NEXT:    [[C_DST_7_UGE:%.*]] = icmp uge i32* [[DST_7]], [[DST]]
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[C_DST_7_ULT]], [[C_DST_7_UGE]]
; CHECK-NEXT:    ret i1 [[RES]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %n.ext = zext i32 %n to i64
  %upper = getelementptr inbounds i32, i32* %dst, i64 %n.ext
  %dst.5 = getelementptr i32, i32* %dst, i64 5
  %dst.5.ult = icmp ult i32* %dst.5, %upper
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %or.cond = and i1 %dst.5.ult, %dst.5.uge
  br i1 %or.cond, label %then, label %else

then:
  %dst.7 = getelementptr i32, i32* %dst, i64 7
  %c.dst.7.ult = icmp ult i32* %dst.7, %upper
  %c.dst.7.uge = icmp uge i32* %dst.7, %dst
  %res = and i1 %c.dst.7.ult, %c.dst.7.uge
  ret i1 %res

else:
  ret i1 0
}

define i1 @upper_and_lower_checks_lt(i32* %dst, i32 %n) {
; CHECK-LABEL: @upper_and_lower_checks_lt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[N_EXT:%.*]] = zext i32 [[N:%.*]] to i64
; CHECK-NEXT:    [[DST_5:%.*]] = getelementptr i32, i32* [[DST:%.*]], i64 [[N_EXT]]
; CHECK-NEXT:    [[DST_5_UGE:%.*]] = icmp uge i32* [[DST_5]], [[DST]]
; CHECK-NEXT:    [[N_EXT_UGE:%.*]] = icmp uge i64 [[N_EXT]], 3
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[DST_5_UGE]], [[N_EXT_UGE]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[DST_3:%.*]] = getelementptr i32, i32* [[DST]], i64 3
; CHECK-NEXT:    [[TRUE_DST_3_UGE:%.*]] = icmp uge i32* [[DST_3]], [[DST]]
; CHECK-NEXT:    [[DST_4:%.*]] = getelementptr i32, i32* [[DST]], i64 4
; CHECK-NEXT:    [[C_DST_4_UGE:%.*]] = icmp uge i32* [[DST_4]], [[DST]]
; CHECK-NEXT:    [[RES_0:%.*]] = xor i1 [[TRUE_DST_3_UGE]], [[C_DST_4_UGE]]
; CHECK-NEXT:    ret i1 [[RES_0]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %n.ext = zext i32 %n to i64
  %dst.5 = getelementptr i32, i32* %dst, i64 %n.ext
  %dst.5.uge = icmp uge i32* %dst.5, %dst
  %n.ext.uge = icmp uge i64 %n.ext, 3
  %or.cond = and i1 %dst.5.uge, %n.ext.uge
  br i1 %or.cond, label %then, label %else

then:
  %dst.3 = getelementptr i32, i32* %dst, i64 3
  %true.dst.3.uge = icmp uge i32* %dst.3, %dst
  %dst.4 = getelementptr i32, i32* %dst, i64 4
  %c.dst.4.uge = icmp uge i32* %dst.4, %dst
  %res.0 = xor i1 %true.dst.3.uge, %c.dst.4.uge
  ret i1 %res.0

else:
  ret i1 0
}
