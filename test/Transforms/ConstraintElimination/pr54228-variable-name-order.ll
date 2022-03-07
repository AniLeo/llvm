; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s


declare void @fn()

define i1 @test_pr54228(i32 %a, i32 %b, i1 %i.0, i1 %i.1) {
; CHECK-LABEL: @test_pr54228(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[I_0:%.*]], label [[PH_1:%.*]], label [[LOOP_HEADER:%.*]]
; CHECK:       ph.1:
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i32 [[A:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_1]])
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       loop.header:
; CHECK-NEXT:    br i1 [[I_1:%.*]], label [[LOOP_THEN:%.*]], label [[LOOP_LATCH:%.*]]
; CHECK:       loop.then:
; CHECK-NEXT:    call void @fn()
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_2]])
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[C_3:%.*]] = icmp eq i32 [[B]], 1
; CHECK-NEXT:    br i1 [[C_3]], label [[EXIT:%.*]], label [[LOOP_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    [[C_4:%.*]] = icmp eq i32 [[A]], 0
; CHECK-NEXT:    ret i1 true
;
entry:
  br i1 %i.0, label %ph.1, label %loop.header

ph.1:                                             ; preds = %entry
  %c.1 = icmp eq i32 %a, 0
  call void @llvm.assume(i1 %c.1)
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %ph.1, %entry
  br i1 %i.1, label %loop.then, label %loop.latch

loop.then:                                        ; preds = %loop.header
  call void @fn()
  %c.2 = icmp eq i32 %b, 0
  call void @llvm.assume(i1 %c.2)
  br label %loop.latch

loop.latch:                                       ; preds = %loop.then, %loop.header
  %c.3 = icmp eq i32 %b, 1
  br i1 %c.3, label %exit, label %loop.header

exit:                                             ; preds = %loop.latch
  %c.4 = icmp eq i32 %a, 0
  ret i1 %c.4
}

declare void @llvm.assume(i1 noundef)
