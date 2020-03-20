; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+cdecp0 -mattr=+cdecp1 -verify-machineinstrs -o - %s | FileCheck %s
; RUN: llc -mtriple=thumbebv8.1m.main -mattr=+cdecp0 -mattr=+cdecp1 -verify-machineinstrs -o - %s | FileCheck %s

declare i32 @llvm.arm.cde.cx1(i32 immarg, i32 immarg)
declare i32 @llvm.arm.cde.cx1a(i32 immarg, i32, i32 immarg)
declare { i32, i32 } @llvm.arm.cde.cx1d(i32 immarg, i32 immarg)
declare { i32, i32 } @llvm.arm.cde.cx1da(i32 immarg, i32, i32, i32 immarg)

declare i32 @llvm.arm.cde.cx2(i32 immarg, i32, i32 immarg)
declare i32 @llvm.arm.cde.cx2a(i32 immarg, i32, i32, i32 immarg)
declare { i32, i32 } @llvm.arm.cde.cx2d(i32 immarg, i32, i32 immarg)
declare { i32, i32 } @llvm.arm.cde.cx2da(i32 immarg, i32, i32, i32, i32 immarg)

declare i32 @llvm.arm.cde.cx3(i32 immarg, i32, i32, i32 immarg)
declare i32 @llvm.arm.cde.cx3a(i32 immarg, i32, i32, i32, i32 immarg)
declare { i32, i32 } @llvm.arm.cde.cx3d(i32 immarg, i32, i32, i32 immarg)
declare { i32, i32 } @llvm.arm.cde.cx3da(i32 immarg, i32, i32, i32, i32, i32 immarg)

define arm_aapcs_vfpcc i32 @test_cx1() {
; CHECK-LABEL: test_cx1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx1 p0, r0, #123
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.cde.cx1(i32 0, i32 123)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_cx1a(i32 %acc) {
; CHECK-LABEL: test_cx1a:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx1a p0, r0, #345
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.cde.cx1a(i32 0, i32 %acc, i32 345)
  ret i32 %0
}

define arm_aapcs_vfpcc i64 @test_cx1d() {
; CHECK-LABEL: test_cx1d:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx1d p1, r0, r1, #567
; CHECK-NEXT:    bx lr
entry:
  %0 = call { i32, i32 } @llvm.arm.cde.cx1d(i32 1, i32 567)
  %1 = extractvalue { i32, i32 } %0, 1
  %2 = zext i32 %1 to i64
  %3 = shl i64 %2, 32
  %4 = extractvalue { i32, i32 } %0, 0
  %5 = zext i32 %4 to i64
  %6 = or i64 %3, %5
  ret i64 %6
}

define arm_aapcs_vfpcc i64 @test_cx1da(i64 %acc) {
; CHECK-LABEL: test_cx1da:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $r1 killed $r1 killed $r0_r1 def $r0_r1
; CHECK-NEXT:    @ kill: def $r0 killed $r0 killed $r0_r1 def $r0_r1
; CHECK-NEXT:    cx1da p0, r0, r1, #789
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %acc, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %acc to i32
  %3 = call { i32, i32 } @llvm.arm.cde.cx1da(i32 0, i32 %2, i32 %1, i32 789)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define arm_aapcs_vfpcc i32 @test_cx2(i32 %n) {
; CHECK-LABEL: test_cx2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx2 p0, r0, r0, #11
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.cde.cx2(i32 0, i32 %n, i32 11)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_cx2a(i32 %acc, i32 %n) {
; CHECK-LABEL: test_cx2a:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx2a p1, r0, r1, #22
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.cde.cx2a(i32 1, i32 %acc, i32 %n, i32 22)
  ret i32 %0
}

define arm_aapcs_vfpcc i64 @test_cx2d(i32 %n) #0 {
; CHECK-LABEL: test_cx2d:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx2d p1, r0, r1, r0, #33
; CHECK-NEXT:    bx lr
entry:
  %0 = call { i32, i32 } @llvm.arm.cde.cx2d(i32 1, i32 %n, i32 33)
  %1 = extractvalue { i32, i32 } %0, 1
  %2 = zext i32 %1 to i64
  %3 = shl i64 %2, 32
  %4 = extractvalue { i32, i32 } %0, 0
  %5 = zext i32 %4 to i64
  %6 = or i64 %3, %5
  ret i64 %6
}

define arm_aapcs_vfpcc i64 @test_cx2da(i64 %acc, i32 %n) {
; CHECK-LABEL: test_cx2da:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $r1 killed $r1 killed $r0_r1 def $r0_r1
; CHECK-NEXT:    @ kill: def $r0 killed $r0 killed $r0_r1 def $r0_r1
; CHECK-NEXT:    cx2da p0, r0, r1, r2, #44
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %acc, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %acc to i32
  %3 = call { i32, i32 } @llvm.arm.cde.cx2da(i32 0, i32 %2, i32 %1, i32 %n, i32 44)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define arm_aapcs_vfpcc i32 @test_cx3(i32 %n, i32 %m) {
; CHECK-LABEL: test_cx3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx3 p0, r0, r0, r1, #1
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.cde.cx3(i32 0, i32 %n, i32 %m, i32 1)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @test_cx3a(i32 %acc, i32 %n, i32 %m) {
; CHECK-LABEL: test_cx3a:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx3a p1, r0, r1, r2, #2
; CHECK-NEXT:    bx lr
entry:
  %0 = call i32 @llvm.arm.cde.cx3a(i32 1, i32 %acc, i32 %n, i32 %m, i32 2)
  ret i32 %0
}

define arm_aapcs_vfpcc i64 @test_cx3d(i32 %n, i32 %m) {
; CHECK-LABEL: test_cx3d:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cx3d p1, r0, r1, r0, r1, #3
; CHECK-NEXT:    bx lr
entry:
  %0 = call { i32, i32 } @llvm.arm.cde.cx3d(i32 1, i32 %n, i32 %m, i32 3)
  %1 = extractvalue { i32, i32 } %0, 1
  %2 = zext i32 %1 to i64
  %3 = shl i64 %2, 32
  %4 = extractvalue { i32, i32 } %0, 0
  %5 = zext i32 %4 to i64
  %6 = or i64 %3, %5
  ret i64 %6
}

define arm_aapcs_vfpcc i64 @test_cx3da(i64 %acc, i32 %n, i32 %m) {
; CHECK-LABEL: test_cx3da:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    @ kill: def $r1 killed $r1 killed $r0_r1 def $r0_r1
; CHECK-NEXT:    @ kill: def $r0 killed $r0 killed $r0_r1 def $r0_r1
; CHECK-NEXT:    cx3da p0, r0, r1, r2, r3, #4
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %acc, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %acc to i32
  %3 = call { i32, i32 } @llvm.arm.cde.cx3da(i32 0, i32 %2, i32 %1, i32 %n, i32 %m, i32 4)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}
