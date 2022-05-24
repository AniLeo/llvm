; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -instcombine-infinite-loop-threshold=2 -S | FileCheck %s

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
declare void @use_p32(i32*)

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

define <3 x i4> @partial_undef_vec() {
; CHECK-LABEL: @partial_undef_vec(
; CHECK-NEXT:    ret <3 x i4> <i4 0, i4 1, i4 0>
;
  %f = freeze <3 x i4> <i4 poison, i4 1, i4 undef>
  ret <3 x i4> %f
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
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[V_FR:%.*]] = freeze i32 [[V:%.*]]
; CHECK-NEXT:    call void @use_p32(i32* nonnull [[A]])
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[V_FR]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[BB0:%.*]], label [[BB1:%.*]]
; CHECK:       bb0:
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    call void @use_i32(i32 [[V_FR]])
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  %a = alloca i32
  call void @use_p32(i32* %a)
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

declare i32 @get_i32()

define i32 @freeze_use_in_different_branches(i1 %c) {
; CHECK-LABEL: @freeze_use_in_different_branches(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = call i32 @get_i32()
; CHECK-NEXT:    [[FR:%.*]] = freeze i32 [[X]]
; CHECK-NEXT:    call void @use_i32(i32 0)
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    ret i32 0
; CHECK:       else:
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    ret i32 1
;
entry:
  %x = call i32 @get_i32()
  call void @use_i32(i32 0)
  br i1 %c, label %if, label %else

if:
  call void @use_i32(i32 %x)
  ret i32 0

else:
  call void @use_i32(i32 %x)
  %fr = freeze i32 %x
  call void @use_i32(i32 %fr)
  ret i32 1
}

define i32 @freeze_phi_use(i1 %c) {
; CHECK-LABEL: @freeze_phi_use(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = call i32 @get_i32()
; CHECK-NEXT:    [[FR:%.*]] = freeze i32 [[X]]
; CHECK-NEXT:    call void @use_i32(i32 0)
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[JOIN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[FR]], [[IF]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    ret i32 [[PHI]]
;
entry:
  %x = call i32 @get_i32()
  call void @use_i32(i32 0)
  br i1 %c, label %if, label %join

if:
  br label %join

join:
  %phi = phi i32 [ %x, %if ], [ 0, %entry ]
  %fr = freeze i32 %x
  call void @use_i32(i32 %fr)
  ret i32 %phi
}

define i32 @freeze_phi_followed_by_phi(i1 %c, i32 %y, i32 %z) {
; CHECK-LABEL: @freeze_phi_followed_by_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[JOIN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[X:%.*]] = phi i32 [ [[Y:%.*]], [[IF]] ], [ [[Z:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[Z]], [[IF]] ], [ [[Y]], [[ENTRY]] ]
; CHECK-NEXT:    [[FR:%.*]] = freeze i32 [[X]]
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    ret i32 [[PHI]]
;
entry:
  br i1 %c, label %if, label %join

if:
  br label %join

join:
  %x = phi i32 [ %y, %if ], [ %z, %entry ]
  %phi = phi i32 [ %z, %if ], [ %y, %entry ]
  call void @use_i32(i32 %x)
  %fr = freeze i32 %x
  call void @use_i32(i32 %fr)
  ret i32 %phi
}

define i32 @freeze_invoke_use_in_phi(i1 %c) personality i8* undef {
; CHECK-LABEL: @freeze_invoke_use_in_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = invoke i32 @get_i32()
; CHECK-NEXT:    to label [[INVOKE_CONT:%.*]] unwind label [[INVOKE_UNWIND:%.*]]
; CHECK:       invoke.cont:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[X]], [[ENTRY:%.*]] ], [ 0, [[INVOKE_CONT]] ]
; CHECK-NEXT:    [[FR:%.*]] = freeze i32 [[X]]
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[PHI]])
; CHECK-NEXT:    br label [[INVOKE_CONT]]
; CHECK:       invoke.unwind:
; CHECK-NEXT:    [[TMP0:%.*]] = landingpad i8
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    unreachable
;
entry:
  %x = invoke i32 @get_i32()
  to label %invoke.cont unwind label %invoke.unwind

invoke.cont:
  %phi = phi i32 [ %x, %entry ], [ 0, %invoke.cont ]
  %fr = freeze i32 %x
  call void @use_i32(i32 %fr)
  call void @use_i32(i32 %phi)
  br label %invoke.cont

invoke.unwind:
  landingpad i8 cleanup
  unreachable
}

define i32 @freeze_invoke_use_after_phi(i1 %c) personality i8* undef {
; CHECK-LABEL: @freeze_invoke_use_after_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = invoke i32 @get_i32()
; CHECK-NEXT:    to label [[INVOKE_CONT:%.*]] unwind label [[INVOKE_UNWIND:%.*]]
; CHECK:       invoke.cont:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[X]], [[ENTRY:%.*]] ], [ 0, [[INVOKE_CONT]] ]
; CHECK-NEXT:    [[FR:%.*]] = freeze i32 [[X]]
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[PHI]])
; CHECK-NEXT:    br label [[INVOKE_CONT]]
; CHECK:       invoke.unwind:
; CHECK-NEXT:    [[TMP0:%.*]] = landingpad i8
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    unreachable
;
entry:
  %x = invoke i32 @get_i32()
  to label %invoke.cont unwind label %invoke.unwind

invoke.cont:
  %phi = phi i32 [ %x, %entry ], [ 0, %invoke.cont ]
  call void @use_i32(i32 %x)
  %fr = freeze i32 %x
  call void @use_i32(i32 %fr)
  call void @use_i32(i32 %phi)
  br label %invoke.cont

invoke.unwind:
  landingpad i8 cleanup
  unreachable
}

define i32 @freeze_callbr_use_after_phi(i1 %c) {
; CHECK-LABEL: @freeze_callbr_use_after_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = callbr i32 asm sideeffect "", "=r"() #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    to label [[CALLBR_CONT:%.*]] []
; CHECK:       callbr.cont:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[X]], [[ENTRY:%.*]] ], [ 0, [[CALLBR_CONT]] ]
; CHECK-NEXT:    [[FR:%.*]] = freeze i32 [[X]]
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[FR]])
; CHECK-NEXT:    call void @use_i32(i32 [[PHI]])
; CHECK-NEXT:    br label [[CALLBR_CONT]]
;
entry:
  %x = callbr i32 asm sideeffect "", "=r"()
  to label %callbr.cont []

callbr.cont:
  %phi = phi i32 [ %x, %entry ], [ 0, %callbr.cont ]
  call void @use_i32(i32 %x)
  %fr = freeze i32 %x
  call void @use_i32(i32 %fr)
  call void @use_i32(i32 %phi)
  br label %callbr.cont
}

define i1 @combine_and_after_freezing_uses(i32 %x) {
; CHECK-LABEL: @combine_and_after_freezing_uses(
; CHECK-NEXT:    [[X_FR:%.*]] = freeze i32 [[X:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X_FR]], 15
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], 15
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %and1 = and i32 %x, 4
  %cmp1 = icmp ne i32 %and1, 0
  %x.fr = freeze i32 %x
  %and2 = and i32 %x.fr, 11
  %cmp2 = icmp eq i32 %and2, 11
  %and = and i1 %cmp1, %cmp2
  ret i1 %and
}

declare i1 @mock_use(i64, i64)
define i1 @fully_propagate_freeze(i32 %0, i32 noundef %1) {
; CHECK-LABEL: @fully_propagate_freeze(
; CHECK-NEXT:    [[DOTFR:%.*]] = freeze i32 [[TMP0:%.*]]
; CHECK-NEXT:    [[DR:%.*]] = lshr i32 [[DOTFR]], 2
; CHECK-NEXT:    [[IDX1:%.*]] = zext i32 [[DR]] to i64
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i32 [[DR]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[ADD]], [[TMP1:%.*]]
; CHECK-NEXT:    [[IDX2:%.*]] = zext i32 [[DR]] to i64
; CHECK-NEXT:    [[V:%.*]] = call i1 @mock_use(i64 [[IDX1]], i64 [[IDX2]])
; CHECK-NEXT:    [[RET:%.*]] = and i1 [[V]], [[CMP]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %dr = lshr i32 %0, 2
  %idx1 = zext i32 %dr to i64
  %add = add i32 %dr, 1
  %cmp = icmp slt i32 %add, %1
  %cmp.fr = freeze i1 %cmp
  %idx2 = zext i32 %dr to i64
  %v = call i1 @mock_use(i64 %idx1, i64 %idx2)
  %ret = and i1 %v, %cmp.fr
  ret i1 %ret
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
; CHECK-NEXT:    [[V11:%.*]] = lshr i32 [[ARG_FR]], 1
; CHECK-NEXT:    ret i32 [[V11]]
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
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i8* [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = getelementptr i8, i8* [[ARG_FR]], i64 16
; CHECK-NEXT:    ret i8* [[V1]]
;
  %v1 = getelementptr inbounds i8, i8* %arg, i64 16
  %v1.fr = freeze i8* %v1
  ret i8* %v1.fr
}

define float @propagate_drop_fneg(float %arg) {
; CHECK-LABEL: @propagate_drop_fneg(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze float [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = fneg float [[ARG_FR]]
; CHECK-NEXT:    ret float [[V1]]
;
  %v1 = fneg ninf nnan float %arg
  %v1.fr = freeze float %v1
  ret float %v1.fr
}


define float @propagate_drop_fadd(float %arg) {
; CHECK-LABEL: @propagate_drop_fadd(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze float [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = fadd float [[ARG_FR]], 2.000000e+00
; CHECK-NEXT:    ret float [[V1]]
;
  %v1 = fadd ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_fsub(float %arg) {
; CHECK-LABEL: @propagate_drop_fsub(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze float [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = fadd float [[ARG_FR]], -2.000000e+00
; CHECK-NEXT:    ret float [[V1]]
;
  %v1 = fsub ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_fmul(float %arg) {
; CHECK-LABEL: @propagate_drop_fmul(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze float [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = fmul float [[ARG_FR]], 2.000000e+00
; CHECK-NEXT:    ret float [[V1]]
;
  %v1 = fmul ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_fdiv(float %arg) {
; CHECK-LABEL: @propagate_drop_fdiv(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze float [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = fmul float [[ARG_FR]], 5.000000e-01
; CHECK-NEXT:    ret float [[V1]]
;
  %v1 = fdiv ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define float @propagate_drop_frem(float %arg) {
; CHECK-LABEL: @propagate_drop_frem(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze float [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = frem float [[ARG_FR]], 2.000000e+00
; CHECK-NEXT:    ret float [[V1]]
;
  %v1 = frem ninf nnan float %arg, 2.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define i1 @propagate_drop_fcmp(float %arg) {
; CHECK-LABEL: @propagate_drop_fcmp(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze float [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = fcmp une float [[ARG_FR]], 2.000000e+00
; CHECK-NEXT:    ret i1 [[V1]]
;
  %v1 = fcmp ninf nnan une float %arg, 2.0
  %v1.fr = freeze i1 %v1
  ret i1 %v1.fr
}

define float @propagate_drop_fmath_select(i1 %arg) {
; CHECK-LABEL: @propagate_drop_fmath_select(
; CHECK-NEXT:    [[ARG_FR:%.*]] = freeze i1 [[ARG:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = select i1 [[ARG_FR]], float 1.000000e+00, float -1.000000e+00
; CHECK-NEXT:    ret float [[V1]]
;
  %v1 = select ninf nnan i1 %arg, float 1.0, float -1.0
  %v1.fr = freeze float %v1
  ret float %v1.fr
}

define void @fold_phi_noop(i32 noundef %init, i32 %n) {
; CHECK-LABEL: @fold_phi_noop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[INIT:%.*]], [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[I_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i32 [ %init, %entry ], [ %i.next, %loop ]
  %i.fr = freeze i32 %i
  %i.next = add i32 %i.fr, 1
  %cond = icmp eq i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  ret void
}

define void @fold_phi_through(i32 %init, i32 %n) {
; CHECK-LABEL: @fold_phi_through(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PHI_FR:%.*]] = freeze i32 [[INIT:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[PHI_FR]], [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[I_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i32 [ %init, %entry ], [ %i.next, %loop ]
  %i.fr = freeze i32 %i
  %i.next = add i32 %i.fr, 1
  %cond = icmp eq i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  ret void
}

define void @fold_phi_neg_flags(i32 %init, i32 %n) {
; CHECK-LABEL: @fold_phi_neg_flags(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[INIT:%.*]], [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_FR:%.*]] = freeze i32 [[I]]
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i32 [[I_FR]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[I_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i32 [ %init, %entry ], [ %i.next, %loop ]
  %i.fr = freeze i32 %i
  %i.next = add nsw nuw i32 %i.fr, 1
  %cond = icmp eq i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  ret void
}

define void @fold_phi_non_add(i32 %init, i32 %n) {
; CHECK-LABEL: @fold_phi_non_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PHI_FR:%.*]] = freeze i32 [[INIT:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[PHI_FR]], [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = shl i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[I_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i32 [ %init, %entry ], [ %i.next, %loop ]
  %i.fr = freeze i32 %i
  %i.next = shl i32 %i.fr, 1
  %cond = icmp eq i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  ret void
}

define void @fold_phi_gep(i8* %init, i8* %end) {
; CHECK-LABEL: @fold_phi_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PHI_FR:%.*]] = freeze i8* [[INIT:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i8* [ [[PHI_FR]], [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[I_NEXT]] = getelementptr i8, i8* [[I]], i64 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8* [[I_NEXT]], [[END:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i8* [ %init, %entry ], [ %i.next, %loop ]
  %i.fr = freeze i8* %i
  %i.next = getelementptr i8, i8* %i.fr, i64 1
  %cond = icmp eq i8* %i.next, %end
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  ret void
}

define i8* @freeze_load_noundef(i8** %ptr) {
; CHECK-LABEL: @freeze_load_noundef(
; CHECK-NEXT:    [[P:%.*]] = load i8*, i8** [[PTR:%.*]], align 8, !noundef !0
; CHECK-NEXT:    ret i8* [[P]]
;
  %p = load i8*, i8** %ptr, !noundef !0
  %p.fr = freeze i8* %p
  ret i8* %p.fr
}

define i8* @freeze_load_dereferenceable(i8** %ptr) {
; CHECK-LABEL: @freeze_load_dereferenceable(
; CHECK-NEXT:    [[P:%.*]] = load i8*, i8** [[PTR:%.*]], align 8, !dereferenceable !1
; CHECK-NEXT:    [[P_FR:%.*]] = freeze i8* [[P]]
; CHECK-NEXT:    ret i8* [[P_FR]]
;
  %p = load i8*, i8** %ptr, !dereferenceable !1
  %p.fr = freeze i8* %p
  ret i8* %p.fr
}

define i8* @freeze_load_dereferenceable_or_null(i8** %ptr) {
; CHECK-LABEL: @freeze_load_dereferenceable_or_null(
; CHECK-NEXT:    [[P:%.*]] = load i8*, i8** [[PTR:%.*]], align 8, !dereferenceable_or_null !1
; CHECK-NEXT:    [[P_FR:%.*]] = freeze i8* [[P]]
; CHECK-NEXT:    ret i8* [[P_FR]]
;
  %p = load i8*, i8** %ptr, !dereferenceable_or_null !1
  %p.fr = freeze i8* %p
  ret i8* %p.fr
}

!0 = !{}
!1 = !{i64 4}
