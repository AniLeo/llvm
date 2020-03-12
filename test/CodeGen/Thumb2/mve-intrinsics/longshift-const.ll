; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

declare {i32, i32} @llvm.arm.mve.asrl(i32, i32, i32)
declare {i32, i32} @llvm.arm.mve.lsll(i32, i32, i32)

define i64 @asrl_0(i64 %X) {
; CHECK-LABEL: asrl_0:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #0
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 0)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_23(i64 %X) {
; CHECK-LABEL: asrl_23:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #23
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 23)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_32(i64 %X) {
; CHECK-LABEL: asrl_32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #32
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_33(i64 %X) {
; CHECK-LABEL: asrl_33:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #33
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 33)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_63(i64 %X) {
; CHECK-LABEL: asrl_63:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #63
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 63)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_64(i64 %X) {
; CHECK-LABEL: asrl_64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #64
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 64)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_m2(i64 %X) {
; CHECK-LABEL: asrl_m2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #1
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -2)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_m32(i64 %X) {
; CHECK-LABEL: asrl_m32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #31
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_m33(i64 %X) {
; CHECK-LABEL: asrl_m33:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #32
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -33)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @asrl_m64(i64 %X) {
; CHECK-LABEL: asrl_m64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #63
; CHECK-NEXT:    asrl r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.asrl(i32 %2, i32 %1, i32 -64)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}




define i64 @lsll_0(i64 %X) {
; CHECK-LABEL: lsll_0:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #0
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 0)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_23(i64 %X) {
; CHECK-LABEL: lsll_23:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #23
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 23)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_32(i64 %X) {
; CHECK-LABEL: lsll_32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #32
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_33(i64 %X) {
; CHECK-LABEL: lsll_33:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #33
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 33)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_63(i64 %X) {
; CHECK-LABEL: lsll_63:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #63
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 63)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_64(i64 %X) {
; CHECK-LABEL: lsll_64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r2, #64
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 64)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_m2(i64 %X) {
; CHECK-LABEL: lsll_m2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #1
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -2)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_m32(i64 %X) {
; CHECK-LABEL: lsll_m32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #31
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -32)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_m33(i64 %X) {
; CHECK-LABEL: lsll_m33:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #32
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -33)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}

define i64 @lsll_m64(i64 %X) {
; CHECK-LABEL: lsll_m64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mvn r2, #63
; CHECK-NEXT:    lsll r0, r1, r2
; CHECK-NEXT:    bx lr
entry:
  %0 = lshr i64 %X, 32
  %1 = trunc i64 %0 to i32
  %2 = trunc i64 %X to i32
  %3 = call { i32, i32 } @llvm.arm.mve.lsll(i32 %2, i32 %1, i32 -64)
  %4 = extractvalue { i32, i32 } %3, 1
  %5 = zext i32 %4 to i64
  %6 = shl nuw i64 %5, 32
  %7 = extractvalue { i32, i32 } %3, 0
  %8 = zext i32 %7 to i64
  %9 = or i64 %6, %8
  ret i64 %9
}
