; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt -function-specialization -force-function-specialization -S < %s | FileCheck %s
; RUN: opt -function-specialization -force-function-specialization -func-specialization-on-address=0 -S < %s | FileCheck %s
; RUN: opt -function-specialization -force-function-specialization -func-specialization-on-address=1 -S < %s | FileCheck %s --check-prefix=ON-ADDRESS

; Global B is not constant. We do not specialise on addresses unless we
; enable that:

; ON-ADDRESS: call i32 @foo.1(i32 %x, i32* @A)
; ON-ADDRESS: call i32 @foo.2(i32 %y, i32* @B)

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

@A = external dso_local constant i32, align 4
@B = external dso_local global i32, align 4

define dso_local i32 @bar(i32 %x, i32 %y) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @foo.1(i32 [[X]], i32* @A)
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @foo(i32 [[Y:%.*]], i32* @B)
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ [[CALL]], [[IF_THEN]] ], [ [[CALL1]], [[IF_ELSE]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_0]]
;
entry:
  %tobool = icmp ne i32 %x, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:
  %call = call i32 @foo(i32 %x, i32* @A)
  br label %return

if.else:
  %call1 = call i32 @foo(i32 %y, i32* @B)
  br label %return

return:
  %retval.0 = phi i32 [ %call, %if.then ], [ %call1, %if.else ]
  ret i32 %retval.0
}

define internal i32 @foo(i32 %x, i32* %b) {
; CHECK-LABEL: define internal i32 @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[B:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], [[TMP0]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %0 = load i32, i32* %b, align 4
  %add = add nsw i32 %x, %0
  ret i32 %add
}

; CHECK-LABEL: define internal i32 @foo.1(i32 %x, i32* %b) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = load i32, i32* @A, align 4
; CHECK-NEXT:    %add = add nsw i32 %x, %0
; CHECK-NEXT:    ret i32 %add
; CHECK-NEXT:  }

; CHECK-NOT: define internal i32 @foo.2(
