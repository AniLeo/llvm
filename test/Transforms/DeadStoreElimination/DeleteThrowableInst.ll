; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -S | FileCheck %s

declare i8* @_Znwj(i32) local_unnamed_addr
declare void @foo() readnone

define void @test1(i8** %ptr) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[VAL:%.*]] = inttoptr i64 23452 to i8*
; CHECK-NEXT:    store i8* [[VAL]], i8** [[PTR:%.*]]
; CHECK-NEXT:    ret void
;
  %val = inttoptr i64 23452 to i8*
  store i8* %val, i8** %ptr
  %call = call i8* @_Znwj(i32 1)
  store i8* %call, i8** %ptr
  store i8* %val, i8** %ptr
  ret void
}

define void @test2(i8** %ptr, i8* %p1, i8* %p2) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[VAL:%.*]] = inttoptr i64 23452 to i8*
; CHECK-NEXT:    store i8* [[VAL]], i8** [[PTR:%.*]]
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    store i8* [[P1:%.*]], i8** [[PTR]]
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    store i8* [[VAL]], i8** [[PTR]]
; CHECK-NEXT:    ret void
;
  %val = inttoptr i64 23452 to i8*
  store i8* %val, i8** %ptr
  call void @foo()
  store i8* %p1, i8** %ptr
  call void @foo()
  store i8* %p2, i8** %ptr
  %call = call i8* @_Znwj(i32 1)
  store i8* %call, i8** %ptr
  store i8* %val, i8** %ptr
  ret void
}
