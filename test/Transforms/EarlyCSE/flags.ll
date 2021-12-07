; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -early-cse -earlycse-debug-hash -S < %s | FileCheck %s
; RUN: opt -basic-aa -early-cse-memssa -S < %s | FileCheck %s

declare void @use(i1)

define void @test1(float %x, float %y) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[CMP1:%.*]] = fcmp oeq float [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    call void @use(i1 [[CMP1]])
; CHECK-NEXT:    call void @use(i1 [[CMP1]])
; CHECK-NEXT:    ret void
;
  %cmp1 = fcmp nnan oeq float %y, %x
  %cmp2 = fcmp oeq float %x, %y
  call void @use(i1 %cmp1)
  call void @use(i1 %cmp2)
  ret void
}

