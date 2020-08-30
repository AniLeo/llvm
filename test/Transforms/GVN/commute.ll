; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -gvn -S < %s | FileCheck %s

declare void @use(i32, i32)

define void @binop(i32 %x, i32 %y) {
; CHECK-LABEL: @binop(
; CHECK-NEXT:    [[ADD1:%.*]] = add i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(i32 [[ADD1]], i32 [[ADD1]])
; CHECK-NEXT:    ret void
;
  %add1 = add i32 %x, %y
  %add2 = add i32 %y, %x
  call void @use(i32 %add1, i32 %add2)
  ret void
}

declare void @vse(i1, i1)

define void @cmp(i32 %x, i32 %y) {
; CHECK-LABEL: @cmp(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @vse(i1 [[CMP1]], i1 [[CMP1]])
; CHECK-NEXT:    ret void
;
  %cmp1 = icmp ult i32 %x, %y
  %cmp2 = icmp ugt i32 %y, %x
  call void @vse(i1 %cmp1, i1 %cmp2)
  ret void
}

declare i32 @llvm.umax.i32(i32, i32)

define void @intrinsic(i32 %x, i32 %y) {
; CHECK-LABEL: @intrinsic(
; CHECK-NEXT:    [[M1:%.*]] = call i32 @llvm.umax.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[M2:%.*]] = call i32 @llvm.umax.i32(i32 [[Y]], i32 [[X]])
; CHECK-NEXT:    call void @use(i32 [[M1]], i32 [[M2]])
; CHECK-NEXT:    ret void
;
  %m1 = call i32 @llvm.umax.i32(i32 %x, i32 %y)
  %m2 = call i32 @llvm.umax.i32(i32 %y, i32 %x)
  call void @use(i32 %m1, i32 %m2)
  ret void
}

declare { i32, i1 } @llvm.umul.with.overflow.i32(i32, i32)

define { i32, i1 } @intrinsic2(i32 %x, i32 %y, i1 %cond) {
; CHECK-LABEL: @intrinsic2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    unreachable
; CHECK:       if.end:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 0, [[Y:%.*]]
; CHECK-NEXT:    [[UMUL:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 [[X:%.*]], i32 [[Y]])
; CHECK-NEXT:    ret { i32, i1 } [[UMUL]]
;
entry:
  br i1 %cond, label %if.then, label %if.end

if.then:
  unreachable

if.end:
  %cmp = icmp eq i32 0, %y
  %umul = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 %x, i32 %y)
  ret { i32, i1 } %umul
}
