; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -jump-threading | FileCheck %s

; This test used to cause jump threading to try to split an edge of a callbr.

@a = global i32 0

define i32 @c() {
; CHECK-LABEL: @c(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_ELSE:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @b()
; CHECK-NEXT:    [[PHITMP:%.*]] = icmp ne i32 [[CALL]], 0
; CHECK-NEXT:    br i1 [[PHITMP]], label [[IF_THEN2:%.*]], label [[IF_END4:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    callbr void asm sideeffect "", "i"(i8* blockaddress(@c, [[IF_THEN2]]))
; CHECK-NEXT:    to label [[IF_END_THREAD:%.*]] [label %if.then2]
; CHECK:       if.end.thread:
; CHECK-NEXT:    br label [[IF_THEN2]]
; CHECK:       if.then2:
; CHECK-NEXT:    [[CALL3:%.*]] = call i32 @b()
; CHECK-NEXT:    br label [[IF_END4]]
; CHECK:       if.end4:
; CHECK-NEXT:    ret i32 undef
;
entry:
  %0 = load i32, i32* @a
  %tobool = icmp eq i32 %0, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  %call = call i32 @b() #2
  %phitmp = icmp ne i32 %call, 0
  br label %if.end

if.else:                                          ; preds = %entry
  callbr void asm sideeffect "", "i"(i8* blockaddress(@c, %if.end)) #2
  to label %normal [label %if.end]

normal:                                           ; preds = %if.else
  br label %if.end

if.end:                                           ; preds = %if.else, %normal, %if.then
  %d.0 = phi i1 [ %phitmp, %if.then ], [ undef, %normal ], [ undef, %if.else ]
  br i1 %d.0, label %if.then2, label %if.end4

if.then2:                                         ; preds = %if.end
  %call3 = call i32 @b()
  br label %if.end4

if.end4:                                          ; preds = %if.then2, %if.end
  ret i32 undef
}

declare i32 @b()
