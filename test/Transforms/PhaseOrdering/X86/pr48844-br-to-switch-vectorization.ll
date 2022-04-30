; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -O2 -mattr=avx < %s | FileCheck %s
; RUN: opt -S -passes="default<O2>" -mattr=avx < %s | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; FIXME: The br -> switch conversion blocks vectorization.

define dso_local void @test(i32* %start, i32* %end) #0 {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[I11_NOT1:%.*]] = icmp eq i32* [[START:%.*]], [[END:%.*]]
; CHECK-NEXT:    br i1 [[I11_NOT1]], label [[EXIT:%.*]], label [[BB12:%.*]]
; CHECK:       bb12:
; CHECK-NEXT:    [[PTR2:%.*]] = phi i32* [ [[PTR_NEXT:%.*]], [[LATCH:%.*]] ], [ [[START]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[PTR2]], align 4
; CHECK-NEXT:    switch i32 [[VAL]], label [[LATCH]] [
; CHECK-NEXT:    i32 -12, label [[STORE:%.*]]
; CHECK-NEXT:    i32 13, label [[STORE]]
; CHECK-NEXT:    ]
; CHECK:       store:
; CHECK-NEXT:    store i32 42, i32* [[PTR2]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[PTR_NEXT]] = getelementptr inbounds i32, i32* [[PTR2]], i64 1
; CHECK-NEXT:    [[I11_NOT:%.*]] = icmp eq i32* [[PTR_NEXT]], [[END]]
; CHECK-NEXT:    br i1 [[I11_NOT]], label [[EXIT]], label [[BB12]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %header

header:
  %ptr = phi i32* [ %start, %entry ], [ %ptr.next, %latch ]
  %i11 = icmp ne i32* %ptr, %end
  br i1 %i11, label %bb12, label %exit

bb12:
  %val = load i32, i32* %ptr, align 4
  %c1 = icmp eq i32 %val, 13
  %c2 = icmp eq i32 %val, -12
  %c3 = or i1 %c1, %c2
  br i1 %c3, label %store, label %latch

store:
  store i32 42, i32* %ptr, align 4
  br label %latch

latch:
  %ptr.next = getelementptr inbounds i32, i32* %ptr, i32 1
  br label %header

exit:
  ret void
}
