; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; %a is negative, %b is positive
define i16 @oppositesign(i16 %x, i16 %y) {
; CHECK-LABEL: @oppositesign(
; CHECK-NEXT:    [[A:%.*]] = or i16 [[X:%.*]], -32768
; CHECK-NEXT:    [[B:%.*]] = and i16 [[Y:%.*]], 32767
; CHECK-NEXT:    [[C:%.*]] = add nsw i16 [[A]], [[B]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = or i16 %x, 32768
  %b = and i16 %y, 32767
  %c = add i16 %a, %b
  ret i16 %c
}

define i16 @zero_sign_bit(i16 %a) {
; CHECK-LABEL: @zero_sign_bit(
; CHECK-NEXT:    [[TMP1:%.*]] = and i16 [[A:%.*]], 32767
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw i16 [[TMP1]], 512
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %1 = and i16 %a, 32767
  %2 = add i16 %1, 512
  ret i16 %2
}

define i16 @zero_sign_bit2(i16 %a, i16 %b) {
; CHECK-LABEL: @zero_sign_bit2(
; CHECK-NEXT:    [[TMP1:%.*]] = and i16 [[A:%.*]], 32767
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[B:%.*]], 32767
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw i16 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i16 [[TMP3]]
;
  %1 = and i16 %a, 32767
  %2 = and i16 %b, 32767
  %3 = add i16 %1, %2
  ret i16 %3
}

declare i16 @bounded(i16 %input);
declare i32 @__gxx_personality_v0(...);
!0 = !{i16 0, i16 32768} ; [0, 32767]
!1 = !{i16 0, i16 32769} ; [0, 32768]

define i16 @add_bounded_values(i16 %a, i16 %b) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK-LABEL: @add_bounded_values(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = call i16 @bounded(i16 [[A:%.*]]), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[D:%.*]] = invoke i16 @bounded(i16 [[B:%.*]])
; CHECK-NEXT:    to label [[CONT:%.*]] unwind label [[LPAD:%.*]], !range [[RNG0]]
; CHECK:       cont:
; CHECK-NEXT:    [[E:%.*]] = add nuw i16 [[C]], [[D]]
; CHECK-NEXT:    ret i16 [[E]]
; CHECK:       lpad:
; CHECK-NEXT:    [[TMP0:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    filter [0 x i8*] zeroinitializer
; CHECK-NEXT:    ret i16 42
;
entry:
  %c = call i16 @bounded(i16 %a), !range !0
  %d = invoke i16 @bounded(i16 %b) to label %cont unwind label %lpad, !range !0
cont:
; %c and %d are in [0, 32767]. Therefore, %c + %d doesn't unsigned overflow.
  %e = add i16 %c, %d
  ret i16 %e
lpad:
  %0 = landingpad { i8*, i32 }
  filter [0 x i8*] zeroinitializer
  ret i16 42
}

define i16 @add_bounded_values_2(i16 %a, i16 %b) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK-LABEL: @add_bounded_values_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = call i16 @bounded(i16 [[A:%.*]]), !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    [[D:%.*]] = invoke i16 @bounded(i16 [[B:%.*]])
; CHECK-NEXT:    to label [[CONT:%.*]] unwind label [[LPAD:%.*]], !range [[RNG1]]
; CHECK:       cont:
; CHECK-NEXT:    [[E:%.*]] = add i16 [[C]], [[D]]
; CHECK-NEXT:    ret i16 [[E]]
; CHECK:       lpad:
; CHECK-NEXT:    [[TMP0:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    filter [0 x i8*] zeroinitializer
; CHECK-NEXT:    ret i16 42
;
entry:
  %c = call i16 @bounded(i16 %a), !range !1
  %d = invoke i16 @bounded(i16 %b) to label %cont unwind label %lpad, !range !1
cont:
; Similar to add_bounded_values, but %c and %d are in [0, 32768]. Therefore,
; %c + %d may unsigned overflow and we cannot add NUW.
  %e = add i16 %c, %d
  ret i16 %e
lpad:
  %0 = landingpad { i8*, i32 }
  filter [0 x i8*] zeroinitializer
  ret i16 42
}

; %a has at most one bit set
; %b has a 0 bit other than the sign bit
define i16 @ripple_nsw1(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_nsw1(
; CHECK-NEXT:    [[A:%.*]] = and i16 [[Y:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = and i16 [[X:%.*]], -16385
; CHECK-NEXT:    [[C:%.*]] = add nuw nsw i16 [[A]], [[B]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = and i16 %y, 1
  %b = and i16 %x, 49151
  %c = add i16 %a, %b
  ret i16 %c
}

; Like the previous test, but flip %a and %b
define i16 @ripple_nsw2(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_nsw2(
; CHECK-NEXT:    [[A:%.*]] = and i16 [[Y:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = and i16 [[X:%.*]], -16385
; CHECK-NEXT:    [[C:%.*]] = add nuw nsw i16 [[B]], [[A]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = and i16 %y, 1
  %b = and i16 %x, 49151
  %c = add i16 %b, %a
  ret i16 %c
}

define i16 @ripple_nsw3(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_nsw3(
; CHECK-NEXT:    [[A:%.*]] = and i16 [[Y:%.*]], -21845
; CHECK-NEXT:    [[B:%.*]] = and i16 [[X:%.*]], 21843
; CHECK-NEXT:    [[C:%.*]] = add nuw nsw i16 [[A]], [[B]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = and i16 %y, 43691
  %b = and i16 %x, 21843
  %c = add i16 %a, %b
  ret i16 %c
}

; Like the previous test, but flip %a and %b
define i16 @ripple_nsw4(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_nsw4(
; CHECK-NEXT:    [[A:%.*]] = and i16 [[Y:%.*]], -21845
; CHECK-NEXT:    [[B:%.*]] = and i16 [[X:%.*]], 21843
; CHECK-NEXT:    [[C:%.*]] = add nuw nsw i16 [[B]], [[A]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = and i16 %y, 43691
  %b = and i16 %x, 21843
  %c = add i16 %b, %a
  ret i16 %c
}

define i16 @ripple_nsw5(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_nsw5(
; CHECK-NEXT:    [[A:%.*]] = or i16 [[Y:%.*]], -21845
; CHECK-NEXT:    [[B:%.*]] = or i16 [[X:%.*]], -10923
; CHECK-NEXT:    [[C:%.*]] = add nsw i16 [[A]], [[B]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = or i16 %y, 43691
  %b = or i16 %x, 54613
  %c = add i16 %a, %b
  ret i16 %c
}

; Like the previous test, but flip %a and %b
define i16 @ripple_nsw6(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_nsw6(
; CHECK-NEXT:    [[A:%.*]] = or i16 [[Y:%.*]], -21845
; CHECK-NEXT:    [[B:%.*]] = or i16 [[X:%.*]], -10923
; CHECK-NEXT:    [[C:%.*]] = add nsw i16 [[B]], [[A]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = or i16 %y, 43691
  %b = or i16 %x, 54613
  %c = add i16 %b, %a
  ret i16 %c
}

; We know nothing about %x
define i32 @ripple_no_nsw1(i32 %x, i32 %y) {
; CHECK-LABEL: @ripple_no_nsw1(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[Y:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = add i32 [[A]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[B]]
;
  %a = and i32 %y, 1
  %b = add i32 %a, %x
  ret i32 %b
}

; %a has at most one bit set
; %b has a 0 bit, but it is the sign bit
define i16 @ripple_no_nsw2(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_no_nsw2(
; CHECK-NEXT:    [[A:%.*]] = and i16 [[Y:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = and i16 [[X:%.*]], 32767
; CHECK-NEXT:    [[C:%.*]] = add nuw i16 [[A]], [[B]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = and i16 %y, 1
  %b = and i16 %x, 32767
  %c = add i16 %a, %b
  ret i16 %c
}

define i16 @ripple_no_nsw3(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_no_nsw3(
; CHECK-NEXT:    [[A:%.*]] = and i16 [[Y:%.*]], -21845
; CHECK-NEXT:    [[B:%.*]] = and i16 [[X:%.*]], 21845
; CHECK-NEXT:    [[C:%.*]] = add i16 [[A]], [[B]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = and i16 %y, 43691
  %b = and i16 %x, 21845
  %c = add i16 %a, %b
  ret i16 %c
}

; Like the previous test, but flip %a and %b
define i16 @ripple_no_nsw4(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_no_nsw4(
; CHECK-NEXT:    [[A:%.*]] = and i16 [[Y:%.*]], -21845
; CHECK-NEXT:    [[B:%.*]] = and i16 [[X:%.*]], 21845
; CHECK-NEXT:    [[C:%.*]] = add i16 [[B]], [[A]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = and i16 %y, 43691
  %b = and i16 %x, 21845
  %c = add i16 %b, %a
  ret i16 %c
}

define i16 @ripple_no_nsw5(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_no_nsw5(
; CHECK-NEXT:    [[A:%.*]] = or i16 [[Y:%.*]], -21847
; CHECK-NEXT:    [[B:%.*]] = or i16 [[X:%.*]], -10923
; CHECK-NEXT:    [[C:%.*]] = add i16 [[A]], [[B]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = or i16 %y, 43689
  %b = or i16 %x, 54613
  %c = add i16 %a, %b
  ret i16 %c
}

; Like the previous test, but flip %a and %b
define i16 @ripple_no_nsw6(i16 %x, i16 %y) {
; CHECK-LABEL: @ripple_no_nsw6(
; CHECK-NEXT:    [[A:%.*]] = or i16 [[Y:%.*]], -21847
; CHECK-NEXT:    [[B:%.*]] = or i16 [[X:%.*]], -10923
; CHECK-NEXT:    [[C:%.*]] = add i16 [[B]], [[A]]
; CHECK-NEXT:    ret i16 [[C]]
;
  %a = or i16 %y, 43689
  %b = or i16 %x, 54613
  %c = add i16 %b, %a
  ret i16 %c
}
