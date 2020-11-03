; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -reassociate -S | FileCheck %s

; If we don't know that operands have no common bits set,
; we can't convert the `or` into an `add`.
define i32 @test1(i32 %a, i32 %b) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[C:%.*]] = or i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %c = or i32 %a, %b
  ret i32 %c
}

; But if we *do* know  that operands have no common bits set,
; we *can* convert the `or` into an `add`.
define i32 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[X_NUMLZ:%.*]] = tail call i32 @llvm.ctlz.i32(i32 [[X:%.*]], i1 true), [[RNG0:!range !.*]]
; CHECK-NEXT:    [[RES:%.*]] = add nuw nsw i32 [[X_NUMLZ]], -32
; CHECK-NEXT:    ret i32 [[RES]]
;
  %x.numlz = tail call i32 @llvm.ctlz.i32(i32 %x, i1 true), !range !0
  %res = or i32 %x.numlz, -32
  ret i32 %res
}

; And that allows reassociation in general.
define i32 @test3(i32 %x, i32 %bit) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[X_NUMLZ:%.*]] = tail call i32 @llvm.ctlz.i32(i32 [[X:%.*]], i1 true), [[RNG0]]
; CHECK-NEXT:    [[BIT_PLUS_ONE:%.*]] = add i32 [[BIT:%.*]], -31
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[BIT_PLUS_ONE]], [[X_NUMLZ]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %x.numlz = tail call i32 @llvm.ctlz.i32(i32 %x, i1 true), !range !0
  %zero.minus.x.numactivebits = or i32 %x.numlz, -32
  %bit.plus.one = add i32 %bit, 1
  %res = add i32 %bit.plus.one, %zero.minus.x.numactivebits
  ret i32 %res
}

declare i32 @llvm.ctlz.i32(i32, i1 immarg) #2

!0 = !{i32 0, i32 33}
