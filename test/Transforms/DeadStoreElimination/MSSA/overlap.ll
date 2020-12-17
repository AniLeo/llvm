; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -dse -S | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa -passes=dse -S | FileCheck %s

declare void @use(i64*)

define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[A:%.*]] = alloca i64, align 8
; CHECK-NEXT:    call void @use(i64* [[A]])
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast i64* [[A]] to i8*
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr i8, i8* [[PTR1]], i32 1
; CHECK-NEXT:    store i8 10, i8* [[PTR1]], align 1
; CHECK-NEXT:    store i8 20, i8* [[PTR2]], align 1
; CHECK-NEXT:    [[LV:%.*]] = load i64, i64* [[A]], align 4
; CHECK-NEXT:    store i8 0, i8* [[PTR1]], align 1
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
; CHECK-NEXT:    [[A:%.*]] = alloca i64, align 8
; CHECK-NEXT:    call void @use(i64* [[A]])
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast i64* [[A]] to i8*
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr i8, i8* [[PTR1]], i32 1
; CHECK-NEXT:    store i8 10, i8* [[PTR1]], align 1
; CHECK-NEXT:    store i8 20, i8* [[PTR2]], align 1
; CHECK-NEXT:    br i1 undef, label [[BB1:%.*]], label [[END:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[LV:%.*]] = load i64, i64* [[A]], align 4
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    store i8 0, i8* [[PTR1]], align 1
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

; TODO: The store to %a0 is dead, because only %a1 is read later.
define void @test3(i1 %c) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[A:%.*]] = alloca [2 x i8], align 1
; CHECK-NEXT:    [[A0:%.*]] = getelementptr [2 x i8], [2 x i8]* [[A]], i32 0, i32 0
; CHECK-NEXT:    [[A1:%.*]] = getelementptr [2 x i8], [2 x i8]* [[A]], i32 0, i32 1
; CHECK-NEXT:    store i8 1, i8* [[A0]], align 1
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    store [2 x i8] zeroinitializer, [2 x i8]* [[A]], align 1
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[A1]], align 1
; CHECK-NEXT:    ret void
;
  %a = alloca [2 x i8]
  %a0 = getelementptr [2 x i8], [2 x i8]* %a, i32 0, i32 0
  %a1 = getelementptr [2 x i8], [2 x i8]* %a, i32 0, i32 1
  store i8 1, i8* %a0
  br i1 %c, label %if, label %else

if:
  store [2 x i8] zeroinitializer, [2 x i8]* %a
  br label %else

else:
  load i8, i8* %a1
  ret void
}
