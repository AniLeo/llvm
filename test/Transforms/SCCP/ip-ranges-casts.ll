; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -ipsccp -S | FileCheck %s

; x = [100, 301)
define internal i1 @f.trunc(i32 %x) {
; CHECK-LABEL: @f.trunc(
; CHECK-NEXT:    [[T_1:%.*]] = trunc i32 [[X:%.*]] to i16
; CHECK-NEXT:    [[C_2:%.*]] = icmp sgt i16 [[T_1]], 299
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i16 [[T_1]], 101
; CHECK-NEXT:    [[RES_1:%.*]] = add i1 false, [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = add i1 [[RES_1]], false
; CHECK-NEXT:    [[RES_3:%.*]] = add i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    [[T_2:%.*]] = trunc i32 [[X]] to i8
; CHECK-NEXT:    [[C_5:%.*]] = icmp sgt i8 [[T_2]], 44
; CHECK-NEXT:    [[C_6:%.*]] = icmp sgt i8 [[T_2]], 43
; CHECK-NEXT:    [[C_7:%.*]] = icmp slt i8 [[T_2]], 100
; CHECK-NEXT:    [[C_8:%.*]] = icmp slt i8 [[T_2]], 101
; CHECK-NEXT:    [[RES_4:%.*]] = add i1 [[RES_3]], [[C_5]]
; CHECK-NEXT:    [[RES_5:%.*]] = add i1 [[RES_4]], [[C_6]]
; CHECK-NEXT:    [[RES_6:%.*]] = add i1 [[RES_5]], [[C_7]]
; CHECK-NEXT:    [[RES_7:%.*]] = add i1 [[RES_6]], [[C_8]]
; CHECK-NEXT:    ret i1 [[RES_7]]
;

  %t.1 = trunc i32 %x to i16
  %c.1 = icmp sgt i16 %t.1, 300
  %c.2 = icmp sgt i16 %t.1, 299
  %c.3 = icmp slt i16 %t.1, 100
  %c.4 = icmp slt i16 %t.1, 101
  %res.1 = add i1 %c.1, %c.2
  %res.2 = add i1 %res.1, %c.3
  %res.3 = add i1 %res.2, %c.4
  %t.2 = trunc i32 %x to i8
  %c.5 = icmp sgt i8 %t.2, 300
  %c.6 = icmp sgt i8 %t.2, 299
  %c.7 = icmp slt i8 %t.2, 100
  %c.8 = icmp slt i8 %t.2, 101
  %res.4 = add i1 %res.3, %c.5
  %res.5 = add i1 %res.4, %c.6
  %res.6 = add i1 %res.5, %c.7
  %res.7 = add i1 %res.6, %c.8
  ret i1 %res.7
}

define i1 @caller1() {
; CHECK-LABEL: @caller1(
; CHECK-NEXT:    [[CALL_1:%.*]] = tail call i1 @f.trunc(i32 100)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i1 @f.trunc(i32 300)
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CALL_1]], [[CALL_2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %call.1 = tail call i1 @f.trunc(i32 100)
  %call.2 = tail call i1 @f.trunc(i32 300)
  %res = and i1 %call.1, %call.2
  ret i1 %res
}


; x = [100, 301)
define internal i1 @f.zext(i32 %x, i32 %y) {
; CHECK-LABEL: @f.zext(
; CHECK-NEXT:    [[T_1:%.*]] = zext i32 [[X:%.*]] to i64
; CHECK-NEXT:    [[C_2:%.*]] = icmp sgt i64 [[T_1]], 299
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i64 [[T_1]], 101
; CHECK-NEXT:    [[RES_1:%.*]] = add i1 false, [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = add i1 [[RES_1]], false
; CHECK-NEXT:    [[RES_3:%.*]] = add i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    [[T_2:%.*]] = zext i32 [[Y:%.*]] to i64
; CHECK-NEXT:    [[C_5:%.*]] = icmp sgt i64 [[T_2]], 300
; CHECK-NEXT:    [[C_6:%.*]] = icmp sgt i64 [[T_2]], 299
; CHECK-NEXT:    [[C_8:%.*]] = icmp slt i64 [[T_2]], 1
; CHECK-NEXT:    [[RES_4:%.*]] = add i1 [[RES_3]], [[C_5]]
; CHECK-NEXT:    [[RES_5:%.*]] = add i1 [[RES_4]], [[C_6]]
; CHECK-NEXT:    [[RES_6:%.*]] = add i1 [[RES_5]], false
; CHECK-NEXT:    [[RES_7:%.*]] = add i1 [[RES_6]], [[C_8]]
; CHECK-NEXT:    ret i1 [[RES_7]]
;

  %t.1 = zext i32 %x to i64
  %c.1 = icmp sgt i64 %t.1, 300
  %c.2 = icmp sgt i64 %t.1, 299
  %c.3 = icmp slt i64 %t.1, 100
  %c.4 = icmp slt i64 %t.1, 101
  %res.1 = add i1 %c.1, %c.2
  %res.2 = add i1 %res.1, %c.3
  %res.3 = add i1 %res.2, %c.4
  %t.2 = zext i32 %y to i64
  %c.5 = icmp sgt i64 %t.2, 300
  %c.6 = icmp sgt i64 %t.2, 299
  %c.7 = icmp slt i64 %t.2, 0
  %c.8 = icmp slt i64 %t.2, 1
  %res.4 = add i1 %res.3, %c.5
  %res.5 = add i1 %res.4, %c.6
  %res.6 = add i1 %res.5, %c.7
  %res.7 = add i1 %res.6, %c.8
  ret i1 %res.7
}

define i1 @caller.zext() {
; CHECK-LABEL: @caller.zext(
; CHECK-NEXT:    [[CALL_1:%.*]] = tail call i1 @f.zext(i32 100, i32 -120)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i1 @f.zext(i32 300, i32 900)
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CALL_1]], [[CALL_2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %call.1 = tail call i1 @f.zext(i32 100, i32 -120)
  %call.2 = tail call i1 @f.zext(i32 300, i32 900)
  %res = and i1 %call.1, %call.2
  ret i1 %res
}

; x = [100, 301)
define internal i1 @f.sext(i32 %x, i32 %y) {
; CHECK-LABEL: @f.sext(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[X:%.*]] to i64
; CHECK-NEXT:    [[C_2:%.*]] = icmp sgt i64 [[TMP1]], 299
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i64 [[TMP1]], 101
; CHECK-NEXT:    [[RES_1:%.*]] = add i1 false, [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = add i1 [[RES_1]], false
; CHECK-NEXT:    [[RES_3:%.*]] = add i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    [[T_2:%.*]] = sext i32 [[Y:%.*]] to i64
; CHECK-NEXT:    [[C_6:%.*]] = icmp sgt i64 [[T_2]], 899
; CHECK-NEXT:    [[C_8:%.*]] = icmp slt i64 [[T_2]], -119
; CHECK-NEXT:    [[RES_4:%.*]] = add i1 [[RES_3]], false
; CHECK-NEXT:    [[RES_5:%.*]] = add i1 [[RES_4]], [[C_6]]
; CHECK-NEXT:    [[RES_6:%.*]] = add i1 [[RES_5]], false
; CHECK-NEXT:    [[RES_7:%.*]] = add i1 [[RES_6]], [[C_8]]
; CHECK-NEXT:    ret i1 [[RES_7]]
;
  %t.1 = sext i32 %x to i64
  %c.1 = icmp sgt i64 %t.1, 300
  %c.2 = icmp sgt i64 %t.1, 299
  %c.3 = icmp slt i64 %t.1, 100
  %c.4 = icmp slt i64 %t.1, 101
  %res.1 = add i1 %c.1, %c.2
  %res.2 = add i1 %res.1, %c.3
  %res.3 = add i1 %res.2, %c.4
  %t.2 = sext i32 %y to i64
  %c.5 = icmp sgt i64 %t.2, 900
  %c.6 = icmp sgt i64 %t.2, 899
  %c.7 = icmp slt i64 %t.2, -120
  %c.8 = icmp slt i64 %t.2, -119
  %res.4 = add i1 %res.3, %c.5
  %res.5 = add i1 %res.4, %c.6
  %res.6 = add i1 %res.5, %c.7
  %res.7 = add i1 %res.6, %c.8
  ret i1 %res.7
}

define i1 @caller.sext() {
; CHECK-LABEL: @caller.sext(
; CHECK-NEXT:    [[CALL_1:%.*]] = tail call i1 @f.sext(i32 100, i32 -120)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i1 @f.sext(i32 300, i32 900)
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CALL_1]], [[CALL_2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %call.1 = tail call i1 @f.sext(i32 100, i32 -120)
  %call.2 = tail call i1 @f.sext(i32 300, i32 900)
  %res = and i1 %call.1, %call.2
  ret i1 %res
}

; There's nothing we can do besides going to the full range or overdefined.
define internal i1 @f.fptosi(i32 %x) {
; CHECK-LABEL: @f.fptosi(
; CHECK-NEXT:    [[TO_DOUBLE:%.*]] = sitofp i32 [[X:%.*]] to double
; CHECK-NEXT:    [[ADD:%.*]] = fadd double 0.000000e+00, [[TO_DOUBLE]]
; CHECK-NEXT:    [[TO_I32:%.*]] = fptosi double [[ADD]] to i32
; CHECK-NEXT:    [[C_1:%.*]] = icmp sgt i32 [[TO_I32]], 300
; CHECK-NEXT:    [[C_2:%.*]] = icmp sgt i32 [[TO_I32]], 299
; CHECK-NEXT:    [[C_3:%.*]] = icmp slt i32 [[TO_I32]], 100
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i32 [[TO_I32]], 101
; CHECK-NEXT:    [[RES_1:%.*]] = add i1 [[C_1]], [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = add i1 [[RES_1]], [[C_3]]
; CHECK-NEXT:    [[RES_3:%.*]] = add i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[RES_3]]
;
  %to.double = sitofp i32 %x to double
  %add = fadd double 0.000000e+00, %to.double
  %to.i32 = fptosi double %add to i32
  %c.1 = icmp sgt i32 %to.i32, 300
  %c.2 = icmp sgt i32 %to.i32, 299
  %c.3 = icmp slt i32 %to.i32, 100
  %c.4 = icmp slt i32 %to.i32, 101
  %res.1 = add i1 %c.1, %c.2
  %res.2 = add i1 %res.1, %c.3
  %res.3 = add i1 %res.2, %c.4
  ret i1 %res.3
}

define i1 @caller.fptosi() {
; CHECK-LABEL: @caller.fptosi(
; CHECK-NEXT:    [[CALL_1:%.*]] = tail call i1 @f.fptosi(i32 100)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i1 @f.fptosi(i32 300)
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CALL_1]], [[CALL_2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %call.1 = tail call i1 @f.fptosi(i32 100)
  %call.2 = tail call i1 @f.fptosi(i32 300)
  %res = and i1 %call.1, %call.2
  ret i1 %res
}

; There's nothing we can do besides going to the full range or overdefined.
define internal i1 @f.fpext(i16 %x) {
; CHECK-LABEL: @f.fpext(
; CHECK-NEXT:    [[TO_FLOAT:%.*]] = sitofp i16 [[X:%.*]] to float
; CHECK-NEXT:    [[TO_DOUBLE:%.*]] = fpext float [[TO_FLOAT]] to double
; CHECK-NEXT:    [[TO_I64:%.*]] = fptoui float [[TO_FLOAT]] to i64
; CHECK-NEXT:    [[C_1:%.*]] = icmp sgt i64 [[TO_I64]], 300
; CHECK-NEXT:    [[C_2:%.*]] = icmp sgt i64 [[TO_I64]], 299
; CHECK-NEXT:    [[C_3:%.*]] = icmp slt i64 [[TO_I64]], 100
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i64 [[TO_I64]], 101
; CHECK-NEXT:    [[RES_1:%.*]] = add i1 [[C_1]], [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = add i1 [[RES_1]], [[C_3]]
; CHECK-NEXT:    [[RES_3:%.*]] = add i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[RES_3]]
;
  %to.float = sitofp i16 %x to float
  %to.double = fpext float %to.float  to double
  %to.i64= fptoui float %to.float to i64
  %c.1 = icmp sgt i64 %to.i64, 300
  %c.2 = icmp sgt i64 %to.i64, 299
  %c.3 = icmp slt i64 %to.i64, 100
  %c.4 = icmp slt i64 %to.i64, 101
  %res.1 = add i1 %c.1, %c.2
  %res.2 = add i1 %res.1, %c.3
  %res.3 = add i1 %res.2, %c.4
  ret i1 %res.3
}

; There's nothing we can do besides going to the full range or overdefined.
define i1 @caller.fpext() {
; CHECK-LABEL: @caller.fpext(
; CHECK-NEXT:    [[CALL_1:%.*]] = tail call i1 @f.fpext(i16 100)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i1 @f.fpext(i16 300)
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CALL_1]], [[CALL_2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %call.1 = tail call i1 @f.fpext(i16 100)
  %call.2 = tail call i1 @f.fpext(i16 300)
  %res = and i1 %call.1, %call.2
  ret i1 %res
}

; There's nothing we can do besides going to the full range or overdefined.
define internal i1 @f.inttoptr.ptrtoint(i64 %x) {
; CHECK-LABEL: @f.inttoptr.ptrtoint(
; CHECK-NEXT:    [[TO_PTR:%.*]] = inttoptr i64 [[X:%.*]] to i8*
; CHECK-NEXT:    [[TO_I64:%.*]] = ptrtoint i8* [[TO_PTR]] to i64
; CHECK-NEXT:    [[C_1:%.*]] = icmp sgt i64 [[TO_I64]], 300
; CHECK-NEXT:    [[C_2:%.*]] = icmp sgt i64 [[TO_I64]], 299
; CHECK-NEXT:    [[C_3:%.*]] = icmp slt i64 [[TO_I64]], 100
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i64 [[TO_I64]], 101
; CHECK-NEXT:    [[RES_1:%.*]] = add i1 [[C_1]], [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = add i1 [[RES_1]], [[C_3]]
; CHECK-NEXT:    [[RES_3:%.*]] = add i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[RES_3]]
;
  %to.ptr = inttoptr i64 %x to i8*
  %to.i64 = ptrtoint i8* %to.ptr to i64
  %c.1 = icmp sgt i64 %to.i64, 300
  %c.2 = icmp sgt i64 %to.i64, 299
  %c.3 = icmp slt i64 %to.i64, 100
  %c.4 = icmp slt i64 %to.i64, 101
  %res.1 = add i1 %c.1, %c.2
  %res.2 = add i1 %res.1, %c.3
  %res.3 = add i1 %res.2, %c.4
  ret i1 %res.3
}

define i1 @caller.inttoptr.ptrtoint() {
; CHECK-LABEL: @caller.inttoptr.ptrtoint(
; CHECK-NEXT:    [[CALL_1:%.*]] = tail call i1 @f.inttoptr.ptrtoint(i64 100)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i1 @f.inttoptr.ptrtoint(i64 300)
; CHECK-NEXT:    [[RES:%.*]] = and i1 [[CALL_1]], [[CALL_2]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %call.1 = tail call i1 @f.inttoptr.ptrtoint(i64 100)
  %call.2 = tail call i1 @f.inttoptr.ptrtoint(i64 300)
  %res = and i1 %call.1, %call.2
  ret i1 %res
}

; Make sure we do not create constant ranges for int to fp casts.
define i1 @int_range_to_double_cast(i32 %a) {
; CHECK-LABEL: @int_range_to_double_cast(
; CHECK-NEXT:    [[R:%.*]] = and i32 [[A:%.*]], 255
; CHECK-NEXT:    [[TMP4:%.*]] = sitofp i32 [[R]] to double
; CHECK-NEXT:    [[TMP10:%.*]] = fadd double 0.000000e+00, [[TMP4]]
; CHECK-NEXT:    [[TMP11:%.*]] = fcmp olt double [[TMP4]], [[TMP10]]
; CHECK-NEXT:    ret i1 [[TMP11]]
;
  %r = and i32 %a, 255
  %tmp4 = sitofp i32 %r to double
  %tmp10 = fadd double 0.000000e+00, %tmp4
  %tmp11 = fcmp olt double %tmp4, %tmp10
  ret i1 %tmp11
}

; Make sure we do not use ranges to propagate info from vectors.
define i16 @vector_binop_and_cast() {
; CHECK-LABEL: @vector_binop_and_cast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VECINIT7:%.*]] = insertelement <8 x i16> <i16 undef, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>, i16 undef, i32 0
; CHECK-NEXT:    [[REM:%.*]] = srem <8 x i16> <i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>, [[VECINIT7]]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x i16> [[REM]] to i128
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i128 [[TMP0]] to i16
; CHECK-NEXT:    ret i16 [[TMP1]]
;
entry:
  %vecinit7 = insertelement <8 x i16> <i16 undef, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>, i16 undef, i32 0
  %rem = srem <8 x i16> <i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>, %vecinit7
  %0 = bitcast <8 x i16> %rem to i128
  %1 = trunc i128 %0 to i16
  ret i16 %1
}

define internal i64 @f.sext_to_zext(i32 %t) {
; CHECK-LABEL: @f.sext_to_zext(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[T:%.*]] to i64
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %a = sext i32 %t to i64
  ret i64 %a
}

define i64 @caller.sext_to_zext(i32 %i) {
; CHECK-LABEL: @caller.sext_to_zext(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[I:%.*]], 9
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    [[T:%.*]] = call i64 @f.sext_to_zext(i32 [[CONV]])
; CHECK-NEXT:    ret i64 [[T]]
;
  %cmp = icmp sle i32 %i, 9
  %conv = zext i1 %cmp to i32
  %t = call i64 @f.sext_to_zext(i32 %conv)
  ret i64 %t
}
