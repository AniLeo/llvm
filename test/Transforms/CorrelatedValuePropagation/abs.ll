; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s

declare void @llvm.assume(i1)
declare i8 @llvm.abs(i8, i1)

; If we don't know anything about the argument, we can't do anything.

define i8 @test0(i8 %x) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test1(i8 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X:%.*]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

; But if we know that the argument is always positive, we can bypass @llvm.abs.

define i8 @test2(i8 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sge i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sge i8 %x, -1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test3(i8 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sge i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sge i8 %x, -1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test4(i8 %x) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sge i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sge i8 %x, 0
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test5(i8 %x) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sge i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sge i8 %x, 0
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test6(i8 %x) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sge i8 [[X:%.*]], 1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sge i8 %x, 1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test7(i8 %x) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sge i8 [[X:%.*]], 1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sge i8 %x, 1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

; Likewise, INT_MIN is fine for otherwise-positive value.

define i8 @test8(i8 %x) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ule i8 [[X:%.*]], 127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp ule i8 %x, 127
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test9(i8 %x) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ule i8 [[X:%.*]], 127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp ule i8 %x, 127
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test10(i8 %x) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ule i8 [[X:%.*]], -128
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp ule i8 %x, 128
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test11(i8 %x) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ule i8 [[X:%.*]], -128
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp ule i8 %x, 128
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test12(i8 %x) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ule i8 [[X:%.*]], -127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp ule i8 %x, 129
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test13(i8 %x) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ule i8 [[X:%.*]], -127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp ule i8 %x, 129
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

; Likewise, if we know that argument is always negative,
; we can expand @llvm.abs into a direct negation.
; For negative arguments, we must be careful to include 0 though.

define i8 @test14(i8 %x) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sle i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sle i8 %x, -1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test15(i8 %x) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sle i8 [[X:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sle i8 %x, -1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test16(i8 %x) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sle i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sle i8 %x, 0
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test17(i8 %x) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sle i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sle i8 %x, 0
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test18(i8 %x) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sle i8 [[X:%.*]], 1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sle i8 %x, 1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test19(i8 %x) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[LIM:%.*]] = icmp sle i8 [[X:%.*]], 1
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp sle i8 %x, 1
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

; And again, INT_MIN is also fine for otherwise-negative range.

define i8 @test20(i8 %x) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    [[LIM:%.*]] = icmp uge i8 [[X:%.*]], 127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp uge i8 %x, 127
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test21(i8 %x) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    [[LIM:%.*]] = icmp uge i8 [[X:%.*]], 127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp uge i8 %x, 127
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test22(i8 %x) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    [[LIM:%.*]] = icmp uge i8 [[X:%.*]], -128
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp uge i8 %x, 128
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test23(i8 %x) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    [[LIM:%.*]] = icmp uge i8 [[X:%.*]], -128
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp uge i8 %x, 128
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

define i8 @test24(i8 %x) {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[LIM:%.*]] = icmp uge i8 [[X:%.*]], -127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp uge i8 %x, 129
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test25(i8 %x) {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    [[LIM:%.*]] = icmp uge i8 [[X:%.*]], -127
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;

  %lim = icmp uge i8 %x, 129
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}

; If all else fails, we can sometimes at least inferr NSW.

define i8 @test26(i8 %x) {
; CHECK-LABEL: @test26(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ne i8 [[X:%.*]], -128
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;
  %lim = icmp ne i8 %x, 128
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 0)
  ret i8 %r
}
define i8 @test27(i8 %x) {
; CHECK-LABEL: @test27(
; CHECK-NEXT:    [[LIM:%.*]] = icmp ne i8 [[X:%.*]], -128
; CHECK-NEXT:    call void @llvm.assume(i1 [[LIM]])
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.abs.i8(i8 [[X]], i1 true)
; CHECK-NEXT:    ret i8 [[R]]
;
  %lim = icmp ne i8 %x, 128
  call void @llvm.assume(i1 %lim)
  %r = call i8 @llvm.abs(i8 %x, i1 1)
  ret i8 %r
}
