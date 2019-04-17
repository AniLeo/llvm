; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Test an already canonical branch to make sure we don't flip those.
define i32 @eq(i32 %X, i32 %Y) {
; CHECK-LABEL: @eq(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !0
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp eq i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !0
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @ne(i32 %X, i32 %Y) {
; CHECK-LABEL: @ne(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !1
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp ne i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !1
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @ugt(i32 %X, i32 %Y) {
; CHECK-LABEL: @ugt(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !2
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp ugt i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !2
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @uge(i32 %X, i32 %Y) {
; CHECK-LABEL: @uge(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !3
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp uge i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !3
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @ult(i32 %X, i32 %Y) {
; CHECK-LABEL: @ult(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !4
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp ult i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !4
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @ule(i32 %X, i32 %Y) {
; CHECK-LABEL: @ule(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !5
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp ule i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !5
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @sgt(i32 %X, i32 %Y) {
; CHECK-LABEL: @sgt(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !6
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp sgt i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !6
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @sge(i32 %X, i32 %Y) {
; CHECK-LABEL: @sge(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !7
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp sge i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !7
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @slt(i32 %X, i32 %Y) {
; CHECK-LABEL: @slt(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !8
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp slt i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !8
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @sle(i32 %X, i32 %Y) {
; CHECK-LABEL: @sle(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !9
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = icmp sle i32 %X, %Y
  br i1 %C, label %T, label %F, !prof !9
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_false(float %X, float %Y) {
; CHECK-LABEL: @f_false(
; CHECK-NEXT:    br i1 false, label [[T:%.*]], label [[F:%.*]], !prof !10
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp false float %X, %Y
  br i1 %C, label %T, label %F, !prof !10
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_oeq(float %X, float %Y) {
; CHECK-LABEL: @f_oeq(
; CHECK-NEXT:    [[C:%.*]] = fcmp oeq float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !11
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp oeq float %X, %Y
  br i1 %C, label %T, label %F, !prof !11
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_ogt(float %X, float %Y) {
; CHECK-LABEL: @f_ogt(
; CHECK-NEXT:    [[C:%.*]] = fcmp ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !12
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp ogt float %X, %Y
  br i1 %C, label %T, label %F, !prof !12
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_oge(float %X, float %Y) {
; CHECK-LABEL: @f_oge(
; CHECK-NEXT:    [[C:%.*]] = fcmp ult float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !13
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp oge float %X, %Y
  br i1 %C, label %T, label %F, !prof !13
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_olt(float %X, float %Y) {
; CHECK-LABEL: @f_olt(
; CHECK-NEXT:    [[C:%.*]] = fcmp olt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !14
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp olt float %X, %Y
  br i1 %C, label %T, label %F, !prof !14
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_ole(float %X, float %Y) {
; CHECK-LABEL: @f_ole(
; CHECK-NEXT:    [[C:%.*]] = fcmp ugt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !15
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp ole float %X, %Y
  br i1 %C, label %T, label %F, !prof !15
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_one(float %X, float %Y) {
; CHECK-LABEL: @f_one(
; CHECK-NEXT:    [[C:%.*]] = fcmp ueq float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[F:%.*]], label [[T:%.*]], !prof !16
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp one float %X, %Y
  br i1 %C, label %T, label %F, !prof !16
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_ord(float %X, float %Y) {
; CHECK-LABEL: @f_ord(
; CHECK-NEXT:    [[C:%.*]] = fcmp ord float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !17
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp ord float %X, %Y
  br i1 %C, label %T, label %F, !prof !17
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_uno(float %X, float %Y) {
; CHECK-LABEL: @f_uno(
; CHECK-NEXT:    [[C:%.*]] = fcmp uno float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !18
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp uno float %X, %Y
  br i1 %C, label %T, label %F, !prof !18
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_ueq(float %X, float %Y) {
; CHECK-LABEL: @f_ueq(
; CHECK-NEXT:    [[C:%.*]] = fcmp ueq float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !19
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp ueq float %X, %Y
  br i1 %C, label %T, label %F, !prof !19
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_ugt(float %X, float %Y) {
; CHECK-LABEL: @f_ugt(
; CHECK-NEXT:    [[C:%.*]] = fcmp ugt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !20
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp ugt float %X, %Y
  br i1 %C, label %T, label %F, !prof !20
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_uge(float %X, float %Y) {
; CHECK-LABEL: @f_uge(
; CHECK-NEXT:    [[C:%.*]] = fcmp uge float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !21
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp uge float %X, %Y
  br i1 %C, label %T, label %F, !prof !21
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_ult(float %X, float %Y) {
; CHECK-LABEL: @f_ult(
; CHECK-NEXT:    [[C:%.*]] = fcmp ult float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !22
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp ult float %X, %Y
  br i1 %C, label %T, label %F, !prof !22
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_ule(float %X, float %Y) {
; CHECK-LABEL: @f_ule(
; CHECK-NEXT:    [[C:%.*]] = fcmp ule float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !23
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp ule float %X, %Y
  br i1 %C, label %T, label %F, !prof !23
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_une(float %X, float %Y) {
; CHECK-LABEL: @f_une(
; CHECK-NEXT:    [[C:%.*]] = fcmp une float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]], !prof !24
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp une float %X, %Y
  br i1 %C, label %T, label %F, !prof !24
T:
  ret i32 12
F:
  ret i32 123
}

define i32 @f_true(float %X, float %Y) {
; CHECK-LABEL: @f_true(
; CHECK-NEXT:    br i1 true, label [[T:%.*]], label [[F:%.*]], !prof !25
; CHECK:       T:
; CHECK-NEXT:    ret i32 12
; CHECK:       F:
; CHECK-NEXT:    ret i32 123
;
  %C = fcmp true float %X, %Y
  br i1 %C, label %T, label %F, !prof !25
T:
  ret i32 12
F:
  ret i32 123
}


!0  = !{!"branch_weights", i32 0,  i32 99}
!1  = !{!"branch_weights", i32 1,  i32 99}
!2  = !{!"branch_weights", i32 2,  i32 99}
!3  = !{!"branch_weights", i32 3,  i32 99}
!4  = !{!"branch_weights", i32 4,  i32 99}
!5  = !{!"branch_weights", i32 5,  i32 99}
!6  = !{!"branch_weights", i32 6,  i32 99}
!7  = !{!"branch_weights", i32 7,  i32 99}
!8  = !{!"branch_weights", i32 8,  i32 99}
!9  = !{!"branch_weights", i32 9,  i32 99}
!10 = !{!"branch_weights", i32 10, i32 99}
!11 = !{!"branch_weights", i32 11, i32 99}
!12 = !{!"branch_weights", i32 12, i32 99}
!13 = !{!"branch_weights", i32 13, i32 99}
!14 = !{!"branch_weights", i32 14, i32 99}
!15 = !{!"branch_weights", i32 15, i32 99}
!16 = !{!"branch_weights", i32 16, i32 99}
!17 = !{!"branch_weights", i32 17, i32 99}
!18 = !{!"branch_weights", i32 18, i32 99}
!19 = !{!"branch_weights", i32 19, i32 99}
!20 = !{!"branch_weights", i32 20, i32 99}
!21 = !{!"branch_weights", i32 21, i32 99}
!22 = !{!"branch_weights", i32 22, i32 99}
!23 = !{!"branch_weights", i32 23, i32 99}
!24 = !{!"branch_weights", i32 24, i32 99}
!25 = !{!"branch_weights", i32 25, i32 99}

; Ensure that the branch metadata is reversed to match the reversals above.
; CHECK: !0 = {{.*}} i32 0, i32 99}
; CHECK: !1 = {{.*}} i32 99, i32 1}
; CHECK: !2 = {{.*}} i32 2, i32 99}
; CHECK: !3 = {{.*}} i32 99, i32 3}
; CHECK: !4 = {{.*}} i32 4, i32 99}
; CHECK: !5 = {{.*}} i32 99, i32 5}
; CHECK: !6 = {{.*}} i32 6, i32 99}
; CHECK: !7 = {{.*}} i32 99, i32 7}
; CHECK: !8 = {{.*}} i32 8, i32 99}
; CHECK: !9 = {{.*}} i32 99, i32 9}
; CHECK: !10 = {{.*}} i32 10, i32 99}
; CHECK: !11 = {{.*}} i32 11, i32 99}
; CHECK: !12 = {{.*}} i32 12, i32 99}
; CHECK: !13 = {{.*}} i32 99, i32 13}
; CHECK: !14 = {{.*}} i32 14, i32 99}
; CHECK: !15 = {{.*}} i32 99, i32 15}
; CHECK: !16 = {{.*}} i32 99, i32 16}
; CHECK: !17 = {{.*}} i32 17, i32 99}
; CHECK: !18 = {{.*}} i32 18, i32 99}
; CHECK: !19 = {{.*}} i32 19, i32 99}
; CHECK: !20 = {{.*}} i32 20, i32 99}
; CHECK: !21 = {{.*}} i32 21, i32 99}
; CHECK: !22 = {{.*}} i32 22, i32 99}
; CHECK: !23 = {{.*}} i32 23, i32 99}
; CHECK: !24 = {{.*}} i32 24, i32 99}
; CHECK: !25 = {{.*}} i32 25, i32 99}

