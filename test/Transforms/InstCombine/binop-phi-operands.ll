; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare void @use(i32)
declare void @sideeffect()

; negative test (but we could allow this?) - don't hoist to conditional predecessor block

define i32 @add_const_incoming0_speculative(i1 %b, i32 %x, i32 %y) {
; CHECK-LABEL: @add_const_incoming0_speculative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i32 [ 42, [[IF]] ], [ [[X:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i32 [ 17, [[IF]] ], [ [[Y:%.*]], [[ENTRY]] ]
; CHECK-NEXT:    [[R:%.*]] = add i32 [[P0]], [[P1]]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i32 [ 42, %if ], [ %x, %entry ]
  %p1 = phi i32 [ 17, %if ], [ %y, %entry ]
  %r = add i32 %p0, %p1
  ret i32 %r
}

define i32 @add_const_incoming0_nonspeculative(i1 %b, i32 %x, i32 %y) {
; CHECK-LABEL: @add_const_incoming0_nonspeculative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[TMP0]], [[IF]] ], [ 59, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i32 [ 42, %entry ], [ %x, %if ]
  %p1 = phi i32 [ 17, %entry ], [ %y, %if ]
  %r = add i32 %p0, %p1
  ret i32 %r
}

; negative test (but we could allow this?) - don't hoist to conditional predecessor block

define i32 @sub_const_incoming0(i1 %b, i32 %x, i32 %y) {
; CHECK-LABEL: @sub_const_incoming0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i32 [ 42, [[IF]] ], [ [[X:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i32 [ 17, [[IF]] ], [ [[Y:%.*]], [[ENTRY]] ]
; CHECK-NEXT:    [[R:%.*]] = sub i32 [[P1]], [[P0]]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i32 [ 42, %if ], [ %x, %entry ]
  %p1 = phi i32 [ 17, %if ], [ %y, %entry ]
  %r = sub i32 %p1, %p0
  ret i32 %r
}

define i32 @sub_const_incoming1(i1 %b, i32 %x, i32 %y) {
; CHECK-LABEL: @sub_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[TMP0]], [[IF]] ], [ 25, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i32 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i32 [ %y, %if ], [ 17, %entry ]
  %r = sub i32 %p0, %p1
  ret i32 %r
}

define i8 @mul_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @mul_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = mul i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ -54, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ 17, %entry ]
  %r = mul i8 %p0, %p1
  ret i8 %r
}

define i8 @and_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @and_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ 17, %entry ]
  %r = and i8 %p0, %p1
  ret i8 %r
}

define i8 @xor_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @xor_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = xor i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 59, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ 17, %entry ]
  %r = xor i8 %p0, %p1
  ret i8 %r
}

define i64 @or_const_incoming1(i1 %b, i64 %x, i64 %y) {
; CHECK-LABEL: @or_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = or i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i64 [ [[TMP0]], [[IF]] ], [ 19, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i64 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i64 [ %x, %if ], [ 3, %entry ]
  %p1 = phi i64 [ %y, %if ], [ 16, %entry ]
  %r = or i64 %p0, %p1
  ret i64 %r
}

define i64 @or_const_incoming01(i1 %b, i64 %x, i64 %y) {
; CHECK-LABEL: @or_const_incoming01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = or i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i64 [ [[TMP0]], [[IF]] ], [ 19, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i64 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i64 [ 3, %entry ], [ %x, %if]
  %p1 = phi i64 [ %y, %if ], [ 16, %entry ]
  %r = or i64 %p0, %p1
  ret i64 %r
}

define i64 @or_const_incoming10(i1 %b, i64 %x, i64 %y) {
; CHECK-LABEL: @or_const_incoming10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = or i64 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i64 [ [[TMP0]], [[IF]] ], [ 19, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i64 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i64 [ %y, %if ], [ 16, %entry ]
  %p1 = phi i64 [ 3, %entry ], [ %x, %if]
  %r = or i64 %p0, %p1
  ret i64 %r
}

; negative test (but we could allow this?) - don't hoist to conditional predecessor block

define i8 @ashr_const_incoming0_speculative(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @ashr_const_incoming0_speculative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i8 [ 42, [[IF]] ], [ [[X:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i8 [ 3, [[IF]] ], [ [[Y:%.*]], [[ENTRY]] ]
; CHECK-NEXT:    [[R:%.*]] = ashr i8 [[P0]], [[P1]]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ 42, %if ], [ %x, %entry ]
  %p1 = phi i8 [ 3, %if ], [ %y, %entry ]
  %r = ashr i8 %p0, %p1
  ret i8 %r
}

define i8 @ashr_const_incoming0(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @ashr_const_incoming0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = ashr i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 5, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ 42, %entry ], [ %x, %if ]
  %p1 = phi i8 [ 3, %entry ], [ %y, %if ]
  %r = ashr i8 %p0, %p1
  ret i8 %r
}

define i8 @lshr_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @lshr_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 5, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ 3, %entry ]
  %r = lshr i8 %p0, %p1
  ret i8 %r
}

define i8 @shl_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @shl_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = shl nuw nsw i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 80, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ 3, %entry ]
  %r = shl nsw nuw i8 %p0, %p1
  ret i8 %r
}

define i8 @sdiv_not_safe_to_speculate(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @sdiv_not_safe_to_speculate(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i8 [ 42, [[IF]] ], [ [[X:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i8 [ 3, [[IF]] ], [ [[Y:%.*]], [[ENTRY]] ]
; CHECK-NEXT:    [[R:%.*]] = sdiv exact i8 [[P0]], [[P1]]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ 42, %if ], [ %x, %entry ]
  %p1 = phi i8 [ 3, %if ], [ %y, %entry ]
  %r = sdiv exact i8 %p0, %p1
  ret i8 %r
}

define i8 @sdiv_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @sdiv_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = sdiv i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ -2, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ -42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ 17, %entry ]
  %r = sdiv i8 %p0, %p1
  ret i8 %r
}

define i8 @udiv_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @udiv_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = udiv i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 12, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ -42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ 17, %entry ]
  %r = udiv i8 %p0, %p1
  ret i8 %r
}

define i8 @srem_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @srem_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = srem i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 8, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ -17, %entry ]
  %r = srem i8 %p0, %p1
  ret i8 %r
}

define i8 @urem_const_incoming1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @urem_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = urem i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi i8 [ [[TMP0]], [[IF]] ], [ 42, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ %x, %if ], [ 42, %entry ]
  %p1 = phi i8 [ %y, %if ], [ -17, %entry ]
  %r = urem i8 %p0, %p1
  ret i8 %r
}

define float @fmul_const_incoming1(i1 %b, float %x, float %y) {
; CHECK-LABEL: @fmul_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = fmul float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi float [ [[TMP0]], [[IF]] ], [ 7.140000e+02, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret float [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi float [ %x, %if ], [ 42.0, %entry ]
  %p1 = phi float [ %y, %if ], [ 17.0, %entry ]
  %r = fmul float %p0, %p1
  ret float %r
}

define float @fadd_const_incoming1(i1 %b, float %x, float %y) {
; CHECK-LABEL: @fadd_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = fadd fast float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi float [ [[TMP0]], [[IF]] ], [ 5.900000e+01, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret float [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi float [ %x, %if ], [ 42.0, %entry ]
  %p1 = phi float [ %y, %if ], [ 17.0, %entry ]
  %r = fadd fast float %p0, %p1
  ret float %r
}

define float @fsub_const_incoming1(i1 %b, float %x, float %y) {
; CHECK-LABEL: @fsub_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = fsub nnan ninf float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi float [ [[TMP0]], [[IF]] ], [ 2.500000e+01, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret float [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi float [ %x, %if ], [ 42.0, %entry ]
  %p1 = phi float [ %y, %if ], [ 17.0, %entry ]
  %r = fsub ninf nnan float %p0, %p1
  ret float %r
}

define float @frem_const_incoming1(i1 %b, float %x, float %y) {
; CHECK-LABEL: @frem_const_incoming1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP0:%.*]] = frem nsz float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[R:%.*]] = phi float [ [[TMP0]], [[IF]] ], [ 8.000000e+00, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret float [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi float [ %x, %if ], [ 42.0, %entry ]
  %p1 = phi float [ %y, %if ], [ 17.0, %entry ]
  %r = frem nsz float %p0, %p1
  ret float %r
}

define i32 @add_const_incoming0_use1(i1 %b, i32 %x, i32 %y) {
; CHECK-LABEL: @add_const_incoming0_use1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i32 [ 42, [[IF]] ], [ [[X:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i32 [ 17, [[IF]] ], [ [[Y:%.*]], [[ENTRY]] ]
; CHECK-NEXT:    call void @use(i32 [[P0]])
; CHECK-NEXT:    [[R:%.*]] = add i32 [[P0]], [[P1]]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i32 [ 42, %if ], [ %x, %entry ]
  %p1 = phi i32 [ 17, %if ], [ %y, %entry ]
  call void @use(i32 %p0)
  %r = add i32 %p0, %p1
  ret i32 %r
}

define i32 @add_const_incoming0_use2(i1 %b, i32 %x, i32 %y) {
; CHECK-LABEL: @add_const_incoming0_use2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i32 [ 42, [[IF]] ], [ [[X:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i32 [ 17, [[IF]] ], [ [[Y:%.*]], [[ENTRY]] ]
; CHECK-NEXT:    call void @use(i32 [[P1]])
; CHECK-NEXT:    [[R:%.*]] = add i32 [[P0]], [[P1]]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i32 [ 42, %if ], [ %x, %entry ]
  %p1 = phi i32 [ 17, %if ], [ %y, %entry ]
  call void @use(i32 %p1)
  %r = add i32 %p0, %p1
  ret i32 %r
}

define i64 @or_notconst_incoming(i1 %b, i64 %x, i64 %y) {
; CHECK-LABEL: @or_notconst_incoming(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i64 [ 42, [[IF]] ], [ [[X:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i64 [ [[Y:%.*]], [[IF]] ], [ 43, [[ENTRY]] ]
; CHECK-NEXT:    [[R:%.*]] = or i64 [[P0]], [[P1]]
; CHECK-NEXT:    ret i64 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i64 [ 42, %if ], [ %x, %entry ]
  %p1 = phi i64 [ %y, %if ], [ 43, %entry ]
  %r = or i64 %p0, %p1
  ret i64 %r
}

; The mul could be hoisted before the call that may not return
; if we are ok with speculating a potentially expensive op.

define i8 @mul_const_incoming0_speculatable(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @mul_const_incoming0_speculatable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i8 [ 42, [[ENTRY:%.*]] ], [ [[X:%.*]], [[IF]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i8 [ 17, [[ENTRY]] ], [ [[Y:%.*]], [[IF]] ]
; CHECK-NEXT:    call void @sideeffect()
; CHECK-NEXT:    [[R:%.*]] = mul i8 [[P0]], [[P1]]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ 42, %entry ], [ %x, %if ]
  %p1 = phi i8 [ 17, %entry ], [ %y, %if ]
  call void @sideeffect()
  %r = mul i8 %p0, %p1
  ret i8 %r
}

; The udiv should never be hoisted before the call that may not return.

define i8 @udiv_const_incoming0_not_speculatable(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @udiv_const_incoming0_not_speculatable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i8 [ 42, [[ENTRY:%.*]] ], [ [[X:%.*]], [[IF]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i8 [ 17, [[ENTRY]] ], [ [[Y:%.*]], [[IF]] ]
; CHECK-NEXT:    call void @sideeffect()
; CHECK-NEXT:    [[R:%.*]] = udiv i8 [[P0]], [[P1]]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ 42, %entry ], [ %x, %if ]
  %p1 = phi i8 [ 17, %entry ], [ %y, %if ]
  call void @sideeffect()
  %r = udiv i8 %p0, %p1
  ret i8 %r
}

; TODO: It is ok to hoist the udiv even though it is not in the same block as the phis.

define i8 @udiv_const_incoming0_different_block(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @udiv_const_incoming0_different_block(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[THEN:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    [[P0:%.*]] = phi i8 [ 42, [[ENTRY:%.*]] ], [ [[X:%.*]], [[IF]] ]
; CHECK-NEXT:    [[P1:%.*]] = phi i8 [ 17, [[ENTRY]] ], [ [[Y:%.*]], [[IF]] ]
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    [[R:%.*]] = udiv i8 [[P0]], [[P1]]
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  br i1 %b, label %if, label %then

if:
  br label %then

then:
  %p0 = phi i8 [ 42, %entry ], [ %x, %if ]
  %p1 = phi i8 [ 17, %entry ], [ %y, %if ]
  br label %end

end:
  %r = udiv i8 %p0, %p1
  ret i8 %r
}

define { i64, i32 } @ParseRetVal(i1 %b, { i64, i32 } ()* %x) {
; CHECK-LABEL: @ParseRetVal(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    [[T4:%.*]] = tail call { i64, i32 } [[X:%.*]]()
; CHECK-NEXT:    [[T5:%.*]] = extractvalue { i64, i32 } [[T4]], 0
; CHECK-NEXT:    [[T6:%.*]] = extractvalue { i64, i32 } [[T4]], 1
; CHECK-NEXT:    br label [[F]]
; CHECK:       f:
; CHECK-NEXT:    [[T16:%.*]] = phi i32 [ [[T6]], [[T]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[T19:%.*]] = phi i64 [ [[T5]], [[T]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    [[T20:%.*]] = insertvalue { i64, i32 } poison, i64 [[T19]], 0
; CHECK-NEXT:    [[T21:%.*]] = insertvalue { i64, i32 } [[T20]], i32 [[T16]], 1
; CHECK-NEXT:    ret { i64, i32 } [[T21]]
;
entry:
  br i1 %b, label %t, label %f

t:
  %t4 = tail call { i64, i32 } %x()
  %t5 = extractvalue { i64, i32 } %t4, 0
  %t6 = extractvalue { i64, i32 } %t4, 1
  %t7 = and i64 %t5, -4294967296
  %t8 = and i64 %t5, 4294901760
  %t9 = and i64 %t5, 65280
  %t10 = and i64 %t5, 255
  br label %f

f:
  %t12 = phi i64 [ %t10, %t ], [ 0, %entry ]
  %t13 = phi i64 [ %t9, %t ], [ 0, %entry ]
  %t14 = phi i64 [ %t8, %t ], [ 0, %entry ]
  %t15 = phi i64 [ %t7, %t ], [ 0, %entry ]
  %t16 = phi i32 [ %t6, %t ], [ 0, %entry ]
  %t17 = or i64 %t13, %t12
  %t18 = or i64 %t17, %t14
  %t19 = or i64 %t18, %t15
  %t20 = insertvalue { i64, i32 } poison, i64 %t19, 0
  %t21 = insertvalue { i64, i32 } %t20, i32 %t16, 1
  ret { i64, i32 } %t21
}
