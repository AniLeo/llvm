; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ppc32 | FileCheck %s

declare  i32 @llvm.smul.fix.sat.i32  (i32, i32, i32)

define i32 @func1(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: func1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lis 5, 32767
; CHECK-NEXT:    mulhw. 6, 3, 4
; CHECK-NEXT:    lis 7, -32768
; CHECK-NEXT:    mullw 3, 3, 4
; CHECK-NEXT:    ori 4, 5, 65535
; CHECK-NEXT:    srawi 5, 3, 31
; CHECK-NEXT:    cmplw 1, 6, 5
; CHECK-NEXT:    bc 12, 0, .LBB0_1
; CHECK-NEXT:    b .LBB0_2
; CHECK-NEXT:  .LBB0_1:
; CHECK-NEXT:    addi 4, 7, 0
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    bclr 12, 6, 0
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    ori 3, 4, 0
; CHECK-NEXT:    blr
  %tmp = call i32 @llvm.smul.fix.sat.i32(i32 %x, i32 %y, i32 0)
  ret i32 %tmp
}

define i32 @func2(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: func2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulhw. 6, 3, 4
; CHECK-NEXT:    lis 5, 32767
; CHECK-NEXT:    mullw 3, 3, 4
; CHECK-NEXT:    rotlwi 3, 3, 31
; CHECK-NEXT:    ori 4, 5, 65535
; CHECK-NEXT:    rlwimi 3, 6, 31, 0, 0
; CHECK-NEXT:    bc 12, 1, .LBB1_1
; CHECK-NEXT:    b .LBB1_2
; CHECK-NEXT:  .LBB1_1:
; CHECK-NEXT:    addi 3, 4, 0
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    cmpwi 6, -1
; CHECK-NEXT:    lis 4, -32768
; CHECK-NEXT:    bc 12, 0, .LBB1_3
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB1_3:
; CHECK-NEXT:    addi 3, 4, 0
; CHECK-NEXT:    blr
  %tmp = call i32 @llvm.smul.fix.sat.i32(i32 %x, i32 %y, i32 1)
  ret i32 %tmp
}
