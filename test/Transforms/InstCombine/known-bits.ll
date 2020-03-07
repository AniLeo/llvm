; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine -expensive-combines=0 < %s | FileCheck %s --check-prefixes=CHECK,EXPENSIVE-OFF
; RUN: opt -S -instcombine -expensive-combines=1 < %s | FileCheck %s --check-prefixes=CHECK,EXPENSIVE-ON

define void @test_shl(i1 %x) {
; EXPENSIVE-OFF-LABEL: @test_shl(
; EXPENSIVE-OFF-NEXT:    [[Y:%.*]] = zext i1 [[X:%.*]] to i8
; EXPENSIVE-OFF-NEXT:    [[Z:%.*]] = shl i8 64, [[Y]]
; EXPENSIVE-OFF-NEXT:    [[A:%.*]] = and i8 [[Z]], 1
; EXPENSIVE-OFF-NEXT:    call void @sink(i8 [[A]])
; EXPENSIVE-OFF-NEXT:    ret void
;
; EXPENSIVE-ON-LABEL: @test_shl(
; EXPENSIVE-ON-NEXT:    call void @sink(i8 0)
; EXPENSIVE-ON-NEXT:    ret void
;
  %y = zext i1 %x to i8
  %z = shl i8 64, %y
  %a = and i8 %z, 1
  call void @sink(i8 %a)
  ret void
}

define void @test_lshr(i1 %x) {
; EXPENSIVE-OFF-LABEL: @test_lshr(
; EXPENSIVE-OFF-NEXT:    [[Y:%.*]] = zext i1 [[X:%.*]] to i8
; EXPENSIVE-OFF-NEXT:    [[Z:%.*]] = lshr i8 64, [[Y]]
; EXPENSIVE-OFF-NEXT:    [[A:%.*]] = and i8 [[Z]], 1
; EXPENSIVE-OFF-NEXT:    call void @sink(i8 [[A]])
; EXPENSIVE-OFF-NEXT:    ret void
;
; EXPENSIVE-ON-LABEL: @test_lshr(
; EXPENSIVE-ON-NEXT:    call void @sink(i8 0)
; EXPENSIVE-ON-NEXT:    ret void
;
  %y = zext i1 %x to i8
  %z = lshr i8 64, %y
  %a = and i8 %z, 1
  call void @sink(i8 %a)
  ret void
}

define void @test_ashr(i1 %x) {
; EXPENSIVE-OFF-LABEL: @test_ashr(
; EXPENSIVE-OFF-NEXT:    [[Y:%.*]] = zext i1 [[X:%.*]] to i8
; EXPENSIVE-OFF-NEXT:    [[Z:%.*]] = ashr i8 -16, [[Y]]
; EXPENSIVE-OFF-NEXT:    [[A:%.*]] = and i8 [[Z]], 3
; EXPENSIVE-OFF-NEXT:    call void @sink(i8 [[A]])
; EXPENSIVE-OFF-NEXT:    ret void
;
; EXPENSIVE-ON-LABEL: @test_ashr(
; EXPENSIVE-ON-NEXT:    call void @sink(i8 0)
; EXPENSIVE-ON-NEXT:    ret void
;
  %y = zext i1 %x to i8
  %z = ashr i8 -16, %y
  %a = and i8 %z, 3
  call void @sink(i8 %a)
  ret void
}

define void @test_udiv(i8 %x) {
; EXPENSIVE-OFF-LABEL: @test_udiv(
; EXPENSIVE-OFF-NEXT:    [[Y:%.*]] = udiv i8 10, [[X:%.*]]
; EXPENSIVE-OFF-NEXT:    [[Z:%.*]] = and i8 [[Y]], 64
; EXPENSIVE-OFF-NEXT:    call void @sink(i8 [[Z]])
; EXPENSIVE-OFF-NEXT:    ret void
;
; EXPENSIVE-ON-LABEL: @test_udiv(
; EXPENSIVE-ON-NEXT:    call void @sink(i8 0)
; EXPENSIVE-ON-NEXT:    ret void
;
  %y = udiv i8 10, %x
  %z = and i8 %y, 64
  call void @sink(i8 %z)
  ret void
}

declare void @sink(i8)
