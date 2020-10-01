; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -instcombine | FileCheck %s

declare i8 @llvm.bitreverse.i8(i8)
declare i32 @llvm.bitreverse.i32(i32)

define i1 @test1(i32 %arg) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i1 true
;
  %a = or i32 %arg, 4294901760
  %b = call i32 @llvm.bitreverse.i32(i32 %a)
  %and = and i32 %b, 65535
  %res = icmp eq i32 %and, 65535
  ret i1 %res
}

define i1 @test2(i32 %arg) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i1 true
;
  %a = or i32 %arg, 1
  %b = call i32 @llvm.bitreverse.i32(i32 %a)
  %c = and i32 %b, 2147483648
  %d = call i32 @llvm.bitreverse.i32(i32 %c)
  %res = icmp eq i32 %d, 1
  ret i1 %res
}

define i1 @test3(i32 %arg) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i1 false
;
  %a = or i32 %arg, 65536
  %b = call i32 @llvm.bitreverse.i32(i32 %a)
  %and = and i32 %b, 32768
  %res = icmp eq i32 %and, 0
  ret i1 %res
}

; known bits for the bitreverse will say the result is in the range [0, 64)
; but the metadata says [0, 16). So make sure the range metadata wins.
;    add %reverse, 1111 0000
; should become
;    or  %reverse, 1111 0000

define i8 @add_bitreverse(i8 %a) {
; CHECK-LABEL: @add_bitreverse(
; CHECK-NEXT:    [[B:%.*]] = and i8 [[A:%.*]], -4
; CHECK-NEXT:    [[REVERSE:%.*]] = call i8 @llvm.bitreverse.i8(i8 [[B]]), [[RNG0:!range !.*]]
; CHECK-NEXT:    [[C:%.*]] = or i8 [[REVERSE]], -16
; CHECK-NEXT:    ret i8 [[C]]
;
  %b = and i8 %a, 252
  %reverse = call i8 @llvm.bitreverse.i8(i8 %b), !range !1
  %c = add i8 %reverse, -16
  ret i8 %c
}
!1 = !{i8 0, i8 16}
