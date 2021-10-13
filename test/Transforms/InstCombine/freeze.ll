; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @fold(i32 %x) {
; CHECK-LABEL: @fold(
; CHECK-NEXT:    [[Y:%.*]] = freeze i32 [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Y]]
;
  %y = freeze i32 %x
  %z = freeze i32 %y
  ret i32 %z
}

define i32 @make_const() {
; CHECK-LABEL: @make_const(
; CHECK-NEXT:    ret i32 10
;
  %x = freeze i32 10
  ret i32 %x
}

define i32 @and_freeze_undef(i32 %x) {
; CHECK-LABEL: @and_freeze_undef(
; CHECK-NEXT:    ret i32 0
;
  %f = freeze i32 undef
  %res = and i32 %x, %f
  ret i32 %res
}

declare void @use_i32(i32)

define i32 @and_freeze_undef_multipleuses(i32 %x) {
; CHECK-LABEL: @and_freeze_undef_multipleuses(
; CHECK-NEXT:    call void @use_i32(i32 0)
; CHECK-NEXT:    ret i32 0
;
  %f = freeze i32 undef
  %res = and i32 %x, %f
  call void @use_i32(i32 %f)
  ret i32 %res
}

define i32 @or_freeze_undef(i32 %x) {
; CHECK-LABEL: @or_freeze_undef(
; CHECK-NEXT:    ret i32 -1
;
  %f = freeze i32 undef
  %res = or i32 %x, %f
  ret i32 %res
}

define i32 @or_freeze_undef_multipleuses(i32 %x) {
; CHECK-LABEL: @or_freeze_undef_multipleuses(
; CHECK-NEXT:    call void @use_i32(i32 0)
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
  %f = freeze i32 undef
  %res = or i32 %x, %f
  call void @use_i32(i32 %f)
  ret i32 %res
}

declare void @use_i32_i1(i32, i1)

define void @or_select_multipleuses(i32 %x, i1 %y) {
; CHECK-LABEL: @or_select_multipleuses(
; CHECK-NEXT:    call void @use_i32_i1(i32 32, i1 [[Y:%.*]])
; CHECK-NEXT:    ret void
;
  %f = freeze i1 undef
  %a = select i1 %f, i32 %x, i32 32 ; prefers %f to be false
  %b = or i1 %f, %y ; prefers %f to be true
  call void @use_i32_i1(i32 %a, i1 %b)
  ret void
}

define void @or_select_multipleuses_logical(i32 %x, i1 %y) {
; CHECK-LABEL: @or_select_multipleuses_logical(
; CHECK-NEXT:    call void @use_i32_i1(i32 32, i1 [[Y:%.*]])
; CHECK-NEXT:    ret void
;
  %f = freeze i1 undef
  %a = select i1 %f, i32 %x, i32 32 ; prefers %f to be false
  %b = select i1 %f, i1 true, i1 %y ; prefers %f to be true
  call void @use_i32_i1(i32 %a, i1 %b)
  ret void
}

; Move the freeze forward to prevent poison from spreading.

define i32 @early_freeze_test1(i32 %x, i32 %y) {
; CHECK-LABEL: @early_freeze_test1(
; CHECK-NEXT:    [[V1:%.*]] = add i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i32 [[V1]]
; CHECK-NEXT:    [[V2:%.*]] = shl i32 [[V1_FR]], 1
; CHECK-NEXT:    [[V3:%.*]] = and i32 [[V2]], 2
; CHECK-NEXT:    ret i32 [[V3]]
;
  %v1 = add i32 %x, %y
  %v2 = shl i32 %v1, 1
  %v3 = and i32 %v2, 2
  %v3.fr = freeze i32 %v3
  ret i32 %v3.fr
}

define i1 @early_freeze_test2(i32* %ptr) {
; CHECK-LABEL: @early_freeze_test2(
; CHECK-NEXT:    [[V1:%.*]] = load i32, i32* [[PTR:%.*]], align 4
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i32 [[V1]]
; CHECK-NEXT:    [[V2:%.*]] = and i32 [[V1_FR]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[V2]], 0
; CHECK-NEXT:    ret i1 [[COND]]
;
  %v1 = load i32, i32* %ptr
  %v2 = and i32 %v1, 1
  %cond = icmp eq i32 %v2, 0
  %cond.fr = freeze i1 %cond
  ret i1 %cond.fr
}

define i32 @early_freeze_test3(i32 %v1) {
; CHECK-LABEL: @early_freeze_test3(
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i32 [[V1:%.*]]
; CHECK-NEXT:    [[V2:%.*]] = shl i32 [[V1_FR]], 1
; CHECK-NEXT:    [[V3:%.*]] = add i32 [[V2]], 2
; CHECK-NEXT:    [[V4:%.*]] = or i32 [[V3]], 1
; CHECK-NEXT:    ret i32 [[V4]]
;
  %v2 = shl i32 %v1, 1
  %v3 = add nuw i32 %v2, 2
  %v4 = or i32 %v3, 1
  %v4.fr = freeze i32 %v4
  ret i32 %v4.fr
}

; If replace all dominated uses of v to freeze(v).

define void @freeze_dominated_uses_test1(i32 %v) {
; CHECK-LABEL: @freeze_dominated_uses_test1(
; CHECK-NEXT:    [[V_FR:%.*]] = freeze i32 [[V:%.*]]
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    ret void
;
  %v.fr = freeze i32 %v
  call void @use_i32(i32 %v)
  call void @use_i32(i32 %v.fr)
  ret void
}

define void @freeze_dominated_uses_test2(i32 %v) {
; CHECK-LABEL: @freeze_dominated_uses_test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @use_i32(i32 [[V:%.*]])
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[V]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[BB0:%.*]], label [[BB1:%.*]]
; CHECK:       bb0:
; CHECK-NEXT:    [[V_FR:%.*]] = freeze i32 [[V]]
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    call void @use_i32(i32 [[V]])
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  call void @use_i32(i32 %v)
  %cond = icmp eq i32 %v, 0
  br i1 %cond, label %bb0, label %bb1

bb0:
  %v.fr = freeze i32 %v
  call void @use_i32(i32 %v.fr)
  call void @use_i32(i32 %v)
  br label %end

bb1:
  call void @use_i32(i32 %v)
  br label %end

end:
  ret void
}

; If there is a duplicate freeze, it will be removed.

define void @freeze_dominated_uses_test3(i32 %v, i1 %cond) {
; CHECK-LABEL: @freeze_dominated_uses_test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V_FR1:%.*]] = freeze i32 [[V:%.*]]
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR1]])
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB0:%.*]], label [[BB1:%.*]]
; CHECK:       bb0:
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR1]])
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR1]])
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  %v.fr1 = freeze i32 %v
  call void @use_i32(i32 %v.fr1)
  br i1 %cond, label %bb0, label %bb1

bb0:
  %v.fr2 = freeze i32 %v
  call void @use_i32(i32 %v.fr2)
  br label %end

bb1:
  call void @use_i32(i32 %v)
  br label %end

end:
  ret void
}


define i32 @propagate_drop_flags_add(i32 %arg) {
; CHECK-LABEL: @propagate_drop_flags_add(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = add i32 [[ARG_FR]], 2
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = add nsw nuw i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_flags_add_foldaway(i32 noundef %arg) {
; CHECK-LABEL: @propagate_drop_flags_add_foldaway(
; CHECK-NEXT:    [[V1:%.*]] = add i32 [[ARG:%.*]], 2
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = add nsw nuw i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_flags_sub(i32 %arg) {
; CHECK-LABEL: @propagate_drop_flags_sub(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = add i32 [[ARG_FR]], -2
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = sub nsw nuw i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_flags_mul(i32 %arg) {
; CHECK-LABEL: @propagate_drop_flags_mul(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = shl i32 [[ARG_FR]], 1
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = mul nsw nuw i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_flags_udiv(i32 %arg) {
; CHECK-LABEL: @propagate_drop_flags_udiv(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = lshr i32 [[ARG_FR]], 1
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = udiv exact i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_flags_sdiv(i32 %arg) {
; CHECK-LABEL: @propagate_drop_flags_sdiv(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = ashr i32 [[ARG_FR]], 1
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = sdiv exact i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_shl1(i32 %arg) {
; CHECK-LABEL: @propagate_drop_shl1(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = shl i32 [[ARG_FR]], 2
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = shl nsw nuw i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_shl2(i32 %arg, i32 %unknown) {
; CHECK-LABEL: @propagate_drop_shl2(
; CHECK-NEXT:    [[V1:%.*]] = shl nuw nsw i32 [[ARG:%.*]], [[UNKNOWN:%.*]]
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i32 [[V1]]
; CHECK-NEXT:    ret i32 [[V1_FR]]
;
  %v1 = shl nsw nuw i32 %arg, %unknown
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_ashr1(i32 %arg) {
; CHECK-LABEL: @propagate_drop_ashr1(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = ashr i32 [[ARG_FR]], 2
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = ashr exact i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_ashr2(i32 %arg, i32 %unknown) {
; CHECK-LABEL: @propagate_drop_ashr2(
; CHECK-NEXT:    [[V1:%.*]] = ashr exact i32 [[ARG:%.*]], [[UNKNOWN:%.*]]
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i32 [[V1]]
; CHECK-NEXT:    ret i32 [[V1_FR]]
;
  %v1 = ashr exact i32 %arg, %unknown
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_lshr1(i32 %arg) {
; CHECK-LABEL: @propagate_drop_lshr1(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i32 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = lshr i32 [[ARG_FR]], 2
; CHECK-NEXT:    ret i32 [[V1]]
;
  %v1 = lshr exact i32 %arg, 2
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i32 @propagate_drop_lshr2(i32 %arg, i32 %unknown) {
; CHECK-LABEL: @propagate_drop_lshr2(
; CHECK-NEXT:    [[V1:%.*]] = lshr exact i32 [[ARG:%.*]], [[UNKNOWN:%.*]]
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i32 [[V1]]
; CHECK-NEXT:    ret i32 [[V1_FR]]
;
  %v1 = lshr exact i32 %arg, %unknown
  %v1.fr = freeze i32 %v1
  ret i32 %v1.fr
}

define i8* @propagate_drop_gep1(i8* %arg) {
; CHECK-LABEL: @propagate_drop_gep1(
; CHECK-NEXT:    [[V1:%.*]] = getelementptr inbounds i8, i8* [[ARG:%.*]], i64 16
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i8* [[V1]]
; CHECK-NEXT:    ret i8* [[V1_FR]]
;
  %v1 = getelementptr inbounds i8, i8* %arg, i64 16
  %v1.fr = freeze i8* %v1
  ret i8* %v1.fr
}

define float @propagate_drop_fneg(float %arg) {
; CHECK-LABEL: @propagate_drop_fneg(
; CHECK-NEXT:    [[V1:%.*]] = fneg nnan ninf float [[ARG:%.*]]
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze float [[V1]]
; CHECK-NEXT:    ret float [[V1_FR]]
;
  %v1 = fneg ninf nnan float %arg
  %v1.fr = freeze float %v1
  ret float %v1.fr
}


define float @propagate_drop_fadd(float %arg) {
; CHECK-LABEL: @propagate_drop_fadd(
; CHECK-NEXT:    [[V1:%.*]] = fadd nnan ninf float [[ARG:%.*]], 2.000000e+00
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze float [[V1]]
; CHECK-NEXT:    ret float [[V1_FR]]
;
  %v1 = fadd ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_fsub(float %arg) {
; CHECK-LABEL: @propagate_drop_fsub(
; CHECK-NEXT:    [[V1:%.*]] = fadd nnan ninf float [[ARG:%.*]], -2.000000e+00
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze float [[V1]]
; CHECK-NEXT:    ret float [[V1_FR]]
;
  %v1 = fsub ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_fmul(float %arg) {
; CHECK-LABEL: @propagate_drop_fmul(
; CHECK-NEXT:    [[V1:%.*]] = fmul nnan ninf float [[ARG:%.*]], 2.000000e+00
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze float [[V1]]
; CHECK-NEXT:    ret float [[V1_FR]]
;
  %v1 = fmul ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_fdiv(float %arg) {
; CHECK-LABEL: @propagate_drop_fdiv(
; CHECK-NEXT:    [[V1:%.*]] = fmul nnan ninf float [[ARG:%.*]], 5.000000e-01
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze float [[V1]]
; CHECK-NEXT:    ret float [[V1_FR]]
;
  %v1 = fdiv ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_frem(float %arg) {
; CHECK-LABEL: @propagate_drop_frem(
; CHECK-NEXT:    [[V1:%.*]] = frem nnan ninf float [[ARG:%.*]], 2.000000e+00
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze float [[V1]]
; CHECK-NEXT:    ret float [[V1_FR]]
;
  %v1 = frem ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define i1 @propagate_drop_fcmp(float %arg) {
; CHECK-LABEL: @propagate_drop_fcmp(
; CHECK-NEXT:    [[V1:%.*]] = fcmp nnan ninf une float [[ARG:%.*]], 2.000000e+00
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze i1 [[V1]]
; CHECK-NEXT:    ret i1 [[V1_FR]]
;
  %v1 = fcmp ninf nnan une float %arg, 2.0
  %v1.fr = freeze i1 %v1
  ret i1 %v1.fr
}

define float @propagate_drop_fmath_select(i1 %arg) {
; CHECK-LABEL: @propagate_drop_fmath_select(
; CHECK-NEXT:    [[V1:%.*]] = select nnan ninf i1 [[ARG:%.*]], float 1.000000e+00, float -1.000000e+00
; CHECK-NEXT:    [[V1_FR:%.*]] = freeze float [[V1]]
; CHECK-NEXT:    ret float [[V1_FR]]
;
  %v1 = select ninf nnan i1 %arg, float 1.0, float -1.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}




