; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv7m-arm-none-eabi"

define void @h(i32* nocapture %p, i32 %x) local_unnamed_addr #0 {
; CHECK-LABEL: @h(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[REM21:%.*]] = urem i32 [[X]], 10
; CHECK-NEXT:    store i32 [[REM21]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:

  %cmp = icmp sgt i32 %x, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:
  %rem2 = srem i32 %x, 10
  store i32 %rem2, i32* %p, align 4
  br label %if.end

if.end:
  ret void
}

; looping case where loop has exactly one block
; at the point of srem, we know that %a is always greater than 0,
; because of the assume before it, so we can transform it to urem.
declare void @llvm.assume(i1)
define void @test4(i32 %n) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP:%.*]], label [[EXIT:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ [[N]], [[ENTRY:%.*]] ], [ [[REM1:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt i32 [[A]], 4
; CHECK-NEXT:    call void @llvm.assume(i1 [[COND]])
; CHECK-NEXT:    [[REM1]] = urem i32 [[A]], 6
; CHECK-NEXT:    [[LOOPCOND:%.*]] = icmp sgt i32 [[REM1]], 8
; CHECK-NEXT:    br i1 [[LOOPCOND]], label [[LOOP]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp = icmp sgt i32 %n, 0
  br i1 %cmp, label %loop, label %exit

loop:
  %a = phi i32 [ %n, %entry ], [ %rem, %loop ]
  %cond = icmp sgt i32 %a, 4
  call void @llvm.assume(i1 %cond)
  %rem = srem i32 %a, 6
  %loopcond = icmp sgt i32 %rem, 8
  br i1 %loopcond, label %loop, label %exit

exit:
  ret void
}

; Now, let's try various domain combinations for operands.

define i8 @test5_pos_pos(i8 %x, i8 %y) {
; CHECK-LABEL: @test5_pos_pos(
; CHECK-NEXT:    [[C0:%.*]] = icmp sge i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sge i8 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[REM1:%.*]] = urem i8 [[X]], [[Y]]
; CHECK-NEXT:    ret i8 [[REM1]]
;
  %c0 = icmp sge i8 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sge i8 %y, 0
  call void @llvm.assume(i1 %c1)

  %rem = srem i8 %x, %y
  ret i8 %rem
}
define i8 @test6_pos_neg(i8 %x, i8 %y) {
; CHECK-LABEL: @test6_pos_neg(
; CHECK-NEXT:    [[C0:%.*]] = icmp sge i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sle i8 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[Y_NONNEG:%.*]] = sub i8 0, [[Y]]
; CHECK-NEXT:    [[REM1:%.*]] = urem i8 [[X]], [[Y_NONNEG]]
; CHECK-NEXT:    ret i8 [[REM1]]
;
  %c0 = icmp sge i8 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sle i8 %y, 0
  call void @llvm.assume(i1 %c1)

  %rem = srem i8 %x, %y
  ret i8 %rem
}
define i8 @test7_neg_pos(i8 %x, i8 %y) {
; CHECK-LABEL: @test7_neg_pos(
; CHECK-NEXT:    [[C0:%.*]] = icmp sle i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sge i8 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[X_NONNEG:%.*]] = sub i8 0, [[X]]
; CHECK-NEXT:    [[REM1:%.*]] = urem i8 [[X_NONNEG]], [[Y]]
; CHECK-NEXT:    [[REM1_NEG:%.*]] = sub i8 0, [[REM1]]
; CHECK-NEXT:    ret i8 [[REM1_NEG]]
;
  %c0 = icmp sle i8 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sge i8 %y, 0
  call void @llvm.assume(i1 %c1)

  %rem = srem i8 %x, %y
  ret i8 %rem
}
define i8 @test8_neg_neg(i8 %x, i8 %y) {
; CHECK-LABEL: @test8_neg_neg(
; CHECK-NEXT:    [[C0:%.*]] = icmp sle i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp sle i8 [[Y:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    [[X_NONNEG:%.*]] = sub i8 0, [[X]]
; CHECK-NEXT:    [[Y_NONNEG:%.*]] = sub i8 0, [[Y]]
; CHECK-NEXT:    [[REM1:%.*]] = urem i8 [[X_NONNEG]], [[Y_NONNEG]]
; CHECK-NEXT:    [[REM1_NEG:%.*]] = sub i8 0, [[REM1]]
; CHECK-NEXT:    ret i8 [[REM1_NEG]]
;
  %c0 = icmp sle i8 %x, 0
  call void @llvm.assume(i1 %c0)
  %c1 = icmp sle i8 %y, 0
  call void @llvm.assume(i1 %c1)

  %rem = srem i8 %x, %y
  ret i8 %rem
}

; After making remainder unsigned, can we narrow it?
define i16 @test9_narrow(i16 %x, i16 %y) {
; CHECK-LABEL: @test9_narrow(
; CHECK-NEXT:    [[C0:%.*]] = icmp ult i16 [[X:%.*]], 128
; CHECK-NEXT:    call void @llvm.assume(i1 [[C0]])
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i16 [[Y:%.*]], 128
; CHECK-NEXT:    call void @llvm.assume(i1 [[C1]])
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    [[REM1_LHS_TRUNC:%.*]] = trunc i16 [[X]] to i8
; CHECK-NEXT:    [[REM1_RHS_TRUNC:%.*]] = trunc i16 [[Y]] to i8
; CHECK-NEXT:    [[REM12:%.*]] = urem i8 [[REM1_LHS_TRUNC]], [[REM1_RHS_TRUNC]]
; CHECK-NEXT:    [[REM1_ZEXT:%.*]] = zext i8 [[REM12]] to i16
; CHECK-NEXT:    ret i16 [[REM1_ZEXT]]
;
  %c0 = icmp ult i16 %x, 128
  call void @llvm.assume(i1 %c0)
  %c1 = icmp ult i16 %y, 128
  call void @llvm.assume(i1 %c1)
  br label %end

end:
  %rem = srem i16 %x, %y
  ret i16 %rem
}
