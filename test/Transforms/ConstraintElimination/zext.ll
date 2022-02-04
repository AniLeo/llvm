; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

define i1 @uge_zext(i8 %x, i16 %y) {
; CHECK-LABEL: @uge_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i8 [[X:%.*]] to i16
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i16 [[X_EXT]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i16 [[X_EXT]], [[Y]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp uge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp uge i16 [[Y]], [[X_EXT]]
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i16 [[Y]], [[X_EXT]]
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i16 [[X_EXT]], [[Y]]
; CHECK-NEXT:    [[R_4:%.*]] = xor i1 true, false
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_5:%.*]] = xor i1 [[R_4]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp uge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_6:%.*]] = xor i1 [[R_5]], [[C_6]]
; CHECK-NEXT:    ret i1 [[R_6]]
;
entry:
  %x.ext = zext i8 %x to i16
  %c.1 = icmp uge i16 %x.ext, %y
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp uge i16 %x.ext, %y
  %c.2 = icmp uge i16 %x.ext, 10
  %r.1 = xor i1 %t.1, %c.2
  %c.3 = icmp uge i16 %y, %x.ext
  %r.2 = xor i1 %r.1, %c.3
  %c.4 = icmp uge i16 10, %x.ext
  %r.3 = xor i1 %r.2, %c.4
  ret i1 %r.3

bb2:
  %t.2 = icmp uge i16 %y, %x.ext
  %f.1 = icmp uge i16 %x.ext, %y
  %r.4 = xor i1 %t.2, %f.1
  %c.5 = icmp uge i16 %x.ext, 10
  %r.5 = xor i1 %r.4, %c.5
  %c.6 = icmp uge i16 10, %x.ext
  %r.6 = xor i1 %r.5, %c.6
  ret i1 %r.6
}

define i1 @uge_compare_short_and_extended(i8 %x, i8 %y) {
; CHECK-LABEL: @uge_compare_short_and_extended(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i8 [[X]] to i16
; CHECK-NEXT:    [[Y_EXT:%.*]] = zext i8 [[Y]] to i16
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i16 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp uge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i16 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i16 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i16 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    [[R_4:%.*]] = xor i1 true, false
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_5:%.*]] = xor i1 [[R_4]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp uge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_6:%.*]] = xor i1 [[R_5]], [[C_6]]
; CHECK-NEXT:    ret i1 [[R_6]]
;
entry:
  %c.1 = icmp uge i8 %x, %y
  %x.ext = zext i8 %x to i16
  %y.ext = zext i8 %y to i16
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp uge i16 %x.ext, %y.ext
  %c.2 = icmp uge i16 %x.ext, 10
  %r.1 = xor i1 %t.1, %c.2
  %c.3 = icmp sge i16 %y.ext, %x.ext
  %r.2 = xor i1 %r.1, %c.3
  %c.4 = icmp uge i16 10, %x.ext
  %r.3 = xor i1 %r.2, %c.4
  ret i1 %r.3

bb2:
  %t.2 = icmp uge i16 %y.ext, %x.ext
  %f.1 = icmp uge i16 %x.ext, %y.ext
  %r.4 = xor i1 %t.2, %f.1
  %c.5 = icmp uge i16 %x.ext, 10
  %r.5 = xor i1 %r.4, %c.5
  %c.6 = icmp uge i16 10, %x.ext
  %r.6 = xor i1 %r.5, %c.6
  ret i1 %r.6
}

define i1 @uge_zext_add(i8 %x, i16 %y) {
; CHECK-LABEL: @uge_zext_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_ADD_1:%.*]] = add nuw nsw i8 [[X:%.*]], 1
; CHECK-NEXT:    [[X_ADD_1_EXT:%.*]] = zext i8 [[X_ADD_1]] to i16
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i8 [[X]] to i16
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i16 [[X_ADD_1_EXT]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i16 [[X_EXT]], [[Y]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp uge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 [[T_1]], [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp uge i16 [[Y]], [[X_EXT]]
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i16 [[Y]], [[X_EXT]]
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge i16 [[X_EXT]], [[Y]]
; CHECK-NEXT:    [[R_4:%.*]] = xor i1 true, false
; CHECK-NEXT:    [[C_5:%.*]] = icmp uge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_5:%.*]] = xor i1 [[R_4]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp uge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_6:%.*]] = xor i1 [[R_5]], [[C_6]]
; CHECK-NEXT:    ret i1 [[R_6]]
;
entry:
  %x.add.1 = add nuw nsw i8 %x, 1
  %x.add.1.ext = zext i8 %x.add.1 to i16
  %x.ext = zext i8 %x to i16
  %c.1 = icmp uge i16 %x.add.1.ext, %y
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp uge i16 %x.ext, %y
  %c.2 = icmp uge i16 %x.ext, 10
  %r.1 = xor i1 %t.1, %c.2
  %c.3 = icmp uge i16 %y, %x.ext
  %r.2 = xor i1 %r.1, %c.3
  %c.4 = icmp uge i16 10, %x.ext
  %r.3 = xor i1 %r.2, %c.4
  ret i1 %r.3

bb2:
  %t.2 = icmp uge i16 %y, %x.ext
  %f.1 = icmp uge i16 %x.ext, %y
  %r.4 = xor i1 %t.2, %f.1
  %c.5 = icmp uge i16 %x.ext, 10
  %r.5 = xor i1 %r.4, %c.5
  %c.6 = icmp uge i16 10, %x.ext
  %r.6 = xor i1 %r.5, %c.6
  ret i1 %r.6
}

define i1 @sge_zext(i8 %x, i16 %y) {
; CHECK-LABEL: @sge_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i8 [[X:%.*]] to i16
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i16 [[X_EXT]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp sge i16 [[X_EXT]], [[Y]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i16 [[Y]], [[X_EXT]]
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i16 [[Y]], [[X_EXT]]
; CHECK-NEXT:    [[F_1:%.*]] = icmp sge i16 [[X_EXT]], [[Y]]
; CHECK-NEXT:    [[R_4:%.*]] = xor i1 true, false
; CHECK-NEXT:    [[C_5:%.*]] = icmp sge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_5:%.*]] = xor i1 [[R_4]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp sge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_6:%.*]] = xor i1 [[R_5]], [[C_6]]
; CHECK-NEXT:    ret i1 [[R_6]]
;
entry:
  %x.ext = zext i8 %x to i16
  %c.1 = icmp sge i16 %x.ext, %y
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp sge i16 %x.ext, %y
  %c.2 = icmp sge i16 %x.ext, 10
  %r.1 = xor i1 %t.1, %c.2
  %c.3 = icmp sge i16 %y, %x.ext
  %r.2 = xor i1 %r.1, %c.3
  %c.4 = icmp sge i16 10, %x.ext
  %r.3 = xor i1 %r.2, %c.4
  ret i1 %r.3

bb2:
  %t.2 = icmp sge i16 %y, %x.ext
  %f.1 = icmp sge i16 %x.ext, %y
  %r.4 = xor i1 %t.2, %f.1
  %c.5 = icmp sge i16 %x.ext, 10
  %r.5 = xor i1 %r.4, %c.5
  %c.6 = icmp sge i16 10, %x.ext
  %r.6 = xor i1 %r.5, %c.6
  ret i1 %r.6
}


define i1 @sge_compare_short_and_extended(i8 %x, i8 %y) {
; CHECK-LABEL: @sge_compare_short_and_extended(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[X_EXT:%.*]] = zext i8 [[X]] to i16
; CHECK-NEXT:    [[Y_EXT:%.*]] = zext i8 [[Y]] to i16
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp sge i16 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 [[T_1]], [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i16 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       bb2:
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i16 [[Y_EXT]], [[X_EXT]]
; CHECK-NEXT:    [[F_1:%.*]] = icmp sge i16 [[X_EXT]], [[Y_EXT]]
; CHECK-NEXT:    [[R_4:%.*]] = xor i1 [[T_2]], [[F_1]]
; CHECK-NEXT:    [[C_5:%.*]] = icmp sge i16 [[X_EXT]], 10
; CHECK-NEXT:    [[R_5:%.*]] = xor i1 [[R_4]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp sge i16 10, [[X_EXT]]
; CHECK-NEXT:    [[R_6:%.*]] = xor i1 [[R_5]], [[C_6]]
; CHECK-NEXT:    ret i1 [[R_6]]
;
entry:
  %c.1 = icmp sge i8 %x, %y
  %x.ext = zext i8 %x to i16
  %y.ext = zext i8 %y to i16
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %t.1 = icmp sge i16 %x.ext, %y.ext
  %c.2 = icmp sge i16 %x.ext, 10
  %r.1 = xor i1 %t.1, %c.2
  %c.3 = icmp sge i16 %y.ext, %x.ext
  %r.2 = xor i1 %r.1, %c.3
  %c.4 = icmp sge i16 10, %x.ext
  %r.3 = xor i1 %r.2, %c.4
  ret i1 %r.3

bb2:
  %t.2 = icmp sge i16 %y.ext, %x.ext
  %f.1 = icmp sge i16 %x.ext, %y.ext
  %r.4 = xor i1 %t.2, %f.1
  %c.5 = icmp sge i16 %x.ext, 10
  %r.5 = xor i1 %r.4, %c.5
  %c.6 = icmp sge i16 10, %x.ext
  %r.6 = xor i1 %r.5, %c.6
  ret i1 %r.6
}
