; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instsimplify < %s | FileCheck %s

declare void @bar(i8* %a, i8* nonnull %b)

; 'y' must be nonnull.

define i1 @caller1(i8* %x, i8* %y) {
; CHECK-LABEL: @caller1(
; CHECK-NEXT:    call void @bar(i8* %x, i8* %y)
; CHECK-NEXT:    ret i1 false
;
  call void @bar(i8* %x, i8* %y)
  %null_check = icmp eq i8* %y, null
  ret i1 %null_check
}

; Don't know anything about 'y'.

define i1 @caller2(i8* %x, i8* %y) {
; CHECK-LABEL: @caller2(
; CHECK-NEXT:    call void @bar(i8* %y, i8* %x)
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp eq i8* %y, null
; CHECK-NEXT:    ret i1 [[NULL_CHECK]]
;
  call void @bar(i8* %y, i8* %x)
  %null_check = icmp eq i8* %y, null
  ret i1 %null_check
}

; 'y' must be nonnull.

define i1 @caller3(i8* %x, i8* %y) {
; CHECK-LABEL: @caller3(
; CHECK-NEXT:    call void @bar(i8* %x, i8* %y)
; CHECK-NEXT:    ret i1 true
;
  call void @bar(i8* %x, i8* %y)
  %null_check = icmp ne i8* %y, null
  ret i1 %null_check
}

; FIXME: The call is guaranteed to execute, so 'y' must be nonnull throughout.

define i1 @caller4(i8* %x, i8* %y) {
; CHECK-LABEL: @caller4(
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp ne i8* %y, null
; CHECK-NEXT:    call void @bar(i8* %x, i8* %y)
; CHECK-NEXT:    ret i1 [[NULL_CHECK]]
;
  %null_check = icmp ne i8* %y, null
  call void @bar(i8* %x, i8* %y)
  ret i1 %null_check
}

; The call to bar() does not dominate the null check, so no change.

define i1 @caller5(i8* %x, i8* %y) {
; CHECK-LABEL: @caller5(
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp eq i8* %y, null
; CHECK-NEXT:    br i1 [[NULL_CHECK]], label %t, label %f
; CHECK:       t:
; CHECK-NEXT:    ret i1 [[NULL_CHECK]]
; CHECK:       f:
; CHECK-NEXT:    call void @bar(i8* %x, i8* %y)
; CHECK-NEXT:    ret i1 [[NULL_CHECK]]
;
  %null_check = icmp eq i8* %y, null
  br i1 %null_check, label %t, label %f
t:
  ret i1 %null_check
f:
  call void @bar(i8* %x, i8* %y)
  ret i1 %null_check
}

; Make sure that an invoke works similarly to a call.

declare i32 @esfp(...)

define i1 @caller6(i8* %x, i8* %y) personality i8* bitcast (i32 (...)* @esfp to i8*){
; CHECK-LABEL: @caller6(
; CHECK-NEXT:    invoke void @bar(i8* %x, i8* nonnull %y)
; CHECK-NEXT:    to label %cont unwind label %exc
; CHECK:       cont:
; CHECK-NEXT:    ret i1 false
;
  invoke void @bar(i8* %x, i8* nonnull %y)
    to label %cont unwind label %exc

cont:
  %null_check = icmp eq i8* %y, null
  ret i1 %null_check

exc:
  %lp = landingpad { i8*, i32 }
    filter [0 x i8*] zeroinitializer
  unreachable
}

