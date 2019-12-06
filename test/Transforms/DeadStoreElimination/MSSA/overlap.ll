; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa -passes=dse -enable-dse-memoryssa -S | FileCheck %s

declare void @use(i64*)

define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[A:%.*]] = alloca i64
; CHECK-NEXT:    call void @use(i64* [[A]])
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast i64* [[A]] to i8*
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr i8, i8* [[PTR1]], i32 1
; CHECK-NEXT:    store i8 10, i8* [[PTR1]]
; CHECK-NEXT:    store i8 20, i8* [[PTR2]]
; CHECK-NEXT:    [[LV:%.*]] = load i64, i64* [[A]]
; CHECK-NEXT:    store i8 0, i8* [[PTR1]]
; CHECK-NEXT:    call void @use(i64* [[A]])
; CHECK-NEXT:    ret void
;
  %a = alloca i64
  call void @use(i64* %a)
  %ptr1 = bitcast i64* %a to i8*
  %ptr2 = getelementptr i8, i8* %ptr1, i32 1

  store i8 10, i8* %ptr1
  store i8 20, i8* %ptr2
  %lv = load i64, i64* %a
  store i8 0, i8* %ptr1

  call void @use(i64* %a)
  ret void
}

define void @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[A:%.*]] = alloca i64
; CHECK-NEXT:    call void @use(i64* [[A]])
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast i64* [[A]] to i8*
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr i8, i8* [[PTR1]], i32 1
; CHECK-NEXT:    store i8 10, i8* [[PTR1]]
; CHECK-NEXT:    store i8 20, i8* [[PTR2]]
; CHECK-NEXT:    br i1 undef, label [[BB1:%.*]], label [[END:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[LV:%.*]] = load i64, i64* [[A]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    store i8 0, i8* [[PTR1]]
; CHECK-NEXT:    call void @use(i64* [[A]])
; CHECK-NEXT:    ret void
;
  %a = alloca i64
  call void @use(i64* %a)
  %ptr1 = bitcast i64* %a to i8*
  %ptr2 = getelementptr i8, i8* %ptr1, i32 1

  store i8 10, i8* %ptr1
  store i8 20, i8* %ptr2
  br i1 undef, label %bb1, label %end

bb1:
  %lv = load i64, i64* %a
  br label %end

end:
  store i8 0, i8* %ptr1
  call void @use(i64* %a)
  ret void
}
