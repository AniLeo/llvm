; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=adce -S < %s | FileCheck %s

declare void @may_not_return(i32) nounwind readnone
declare void @will_return(i32) nounwind readnone willreturn

define void @test(i32 %a) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[B:%.*]] = add i32 [[A:%.*]], 1
; CHECK-NEXT:    call void @may_not_return(i32 [[B]])
; CHECK-NEXT:    ret void
;
  %b = add i32 %a, 1
  call void @may_not_return(i32 %b)
  %c = add i32 %b, 1
  call void @will_return(i32 %c)
  ret void
}
