; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -dse -S %s | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"

; Test case for PR16520. The store in %if.then is dead, because the same value
; has been stored earlier to the same location.
define void @test1_pr16520(i1 %b, i8* nocapture %r) {
; CHECK-LABEL: @test1_pr16520(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8 1, i8* [[R:%.*]], align 1
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i8 1, i8* [[R]], align 1
; CHECK-NEXT:    tail call void @fn_mayread_or_clobber()
; CHECK-NEXT:    br label [[IF_END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    tail call void @fn_mayread_or_clobber()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:
  store i8 1, i8* %r, align 1
  br i1 %b, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  store i8 1, i8* %r, align 1
  tail call void @fn_mayread_or_clobber()
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void @fn_mayread_or_clobber()
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

declare void @fn_mayread_or_clobber()


declare void @fn_readonly() readonly

define void @test2(i1 %b, i8* nocapture %r) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8 1, i8* [[R:%.*]], align 1
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @fn_readonly()
; CHECK-NEXT:    br label [[IF_END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    tail call void @fn_readonly()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    store i8 1, i8* [[R]], align 1
; CHECK-NEXT:    ret void
;
entry:
  store i8 1, i8* %r, align 1
  br i1 %b, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void @fn_readonly()
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void @fn_readonly()
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  store i8 1, i8* %r, align 1
  ret void
}

define void @test3(i1 %b, i8* nocapture %r) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8 1, i8* [[R:%.*]], align 1
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @fn_mayread_or_clobber()
; CHECK-NEXT:    br label [[IF_END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    tail call void @fn_readonly()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    store i8 1, i8* [[R]], align 1
; CHECK-NEXT:    ret void
;
entry:
  store i8 1, i8* %r, align 1
  br i1 %b, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void @fn_mayread_or_clobber()
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void @fn_readonly()
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  store i8 1, i8* %r, align 1
  ret void
}

define void @test4(i1 %b, i8* nocapture %r) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8 1, i8* [[R:%.*]], align 1
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @fn_readonly()
; CHECK-NEXT:    br label [[IF_END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    tail call void @fn_mayread_or_clobber()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    store i8 1, i8* [[R]], align 1
; CHECK-NEXT:    ret void
;
entry:
  store i8 1, i8* %r, align 1
  br i1 %b, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void @fn_readonly()
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void @fn_mayread_or_clobber()
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  store i8 1, i8* %r, align 1
  ret void
}

define void @test5(i1 %b, i8* nocapture %r) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8 1, i8* [[R:%.*]], align 1
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @fn_readonly()
; CHECK-NEXT:    br label [[IF_END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    tail call void @fn_mayread_or_clobber()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    store i8 1, i8* [[R]], align 1
; CHECK-NEXT:    ret void
;
entry:
  store i8 1, i8* %r, align 1
  br i1 %b, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void @fn_readonly()
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void @fn_mayread_or_clobber()
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  store i8 1, i8* %r, align 1
  ret void
}

declare i1 @cond() readnone

define void @test6(i32* noalias %P) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_HEADER:%.*]]
; CHECK:       for.header:
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[C1:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C1]], label [[FOR_BODY:%.*]], label [[END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    [[LV:%.*]] = load i32, i32* [[P]], align 4
; CHECK-NEXT:    br label [[FOR_HEADER]]
; CHECK:       end:
; CHECK-NEXT:    store i32 3, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
entry:
  br label %for.header

for.header:
  store i32 1, i32* %P, align 4
  %c1 = call i1 @cond()
  br i1 %c1, label %for.body, label %end

for.body:
  store i32 1, i32* %P, align 4
  %lv = load i32, i32* %P
  br label %for.header

end:
  store i32 3, i32* %P, align 4
  ret void
}

; Make sure the store in %bb3 can be eliminated in the presences of early returns.
define void @test7(i32* noalias %P) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  ret void
bb3:
  store i32 0, i32* %P
  ret void
}

; Make sure the store in %bb3 won't be eliminated because it may be clobbered before.
define void @test8(i32* noalias %P) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    call void @fn_mayread_or_clobber()
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  call void @fn_mayread_or_clobber()
  br label %bb3
bb2:
  ret void
bb3:
  store i32 0, i32* %P
  ret void
}

; Make sure the store in %bb3 will be eliminated because only the early exit path
; may be clobbered.
define void @test9(i32* noalias %P) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @fn_mayread_or_clobber()
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    store i32 0, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  call void @fn_mayread_or_clobber()
  ret void
bb3:
  store i32 0, i32* %P
  ret void
}

define void @pr49927(i32* %q, i32* %p) {
; CHECK-LABEL: @pr49927(
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    store i32 [[V]], i32* [[Q:%.*]], align 4
; CHECK-NEXT:    store i32 [[V]], i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
  %v = load i32, i32* %p, align 4
  store i32 %v, i32* %q, align 4
  ; FIXME: this store can be eliminated
  store i32 %v, i32* %p, align 4
  ret void
}
