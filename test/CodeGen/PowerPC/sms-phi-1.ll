; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=powerpc64le-unknown-linux-gnu -verify-machineinstrs\
; RUN:       -mcpu=pwr9 --ppc-enable-pipeliner 2>&1 | FileCheck %s

define void @main() nounwind #0 {
; CHECK-LABEL: main:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 30, -16(1) # 8-byte Folded Spill
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -48(1)
; CHECK-NEXT:    bl strtol
; CHECK-NEXT:    nop
; CHECK-NEXT:    mr 30, 3
; CHECK-NEXT:    bl calloc
; CHECK-NEXT:    nop
; CHECK-NEXT:    clrldi 4, 30, 32
; CHECK-NEXT:    li 5, 0
; CHECK-NEXT:    addi 3, 3, -4
; CHECK-NEXT:    mtctr 4
; CHECK-NEXT:    mullw 4, 5, 5
; CHECK-NEXT:    li 6, 1
; CHECK-NEXT:    bdz .LBB0_3
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    stwu 4, 4(3)
; CHECK-NEXT:    mullw 4, 6, 6
; CHECK-NEXT:    addi 5, 6, 1
; CHECK-NEXT:    bdz .LBB0_3
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_2: #
; CHECK-NEXT:    stwu 4, 4(3)
; CHECK-NEXT:    mullw 4, 5, 5
; CHECK-NEXT:    addi 5, 5, 1
; CHECK-NEXT:    bdnz .LBB0_2
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    stwu 4, 4(3)
; CHECK-NEXT:    addi 1, 1, 48
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    ld 30, -16(1) # 8-byte Folded Reload
; CHECK-NEXT:    blr
  %1 = tail call i64 @strtol()
  %2 = trunc i64 %1 to i32
  %3 = tail call noalias i8* @calloc()
  %4 = bitcast i8* %3 to i32*
  %5 = zext i32 %2 to i64
  br label %6

6:                                                ; preds = %6, %0
  %7 = phi i64 [ %11, %6 ], [ 0, %0 ]
  %8 = trunc i64 %7 to i32
  %9 = mul nsw i32 %8, %8
  %10 = getelementptr inbounds i32, i32* %4, i64 %7
  store i32 %9, i32* %10, align 4
  %11 = add nuw nsw i64 %7, 1
  %12 = icmp eq i64 %11, %5
  br i1 %12, label %13, label %6

13:                                               ; preds = %6
  ret void
}

declare i8* @calloc() local_unnamed_addr
declare i64 @strtol() local_unnamed_addr
