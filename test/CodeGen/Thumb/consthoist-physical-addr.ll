; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc %s -o - -asm-verbose=false | FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-arm-none-eabi"

define i32 @C(i32 %x, i32* nocapture %y) #0 {
; CHECK-LABEL: C:
; CHECK:         .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:    movs r2, #0
; CHECK-NEXT:    ldr r3, .LCPI0_0
; CHECK-NEXT:  .LBB0_1:
; CHECK-NEXT:    cmp r2, #128
; CHECK-NEXT:    beq .LBB0_5
; CHECK-NEXT:    movs r4, #0
; CHECK-NEXT:    str r4, [r3, #8]
; CHECK-NEXT:    lsls r4, r2, #2
; CHECK-NEXT:    adds r5, r4, r0
; CHECK-NEXT:    str r5, [r3]
; CHECK-NEXT:    movs r5, #1
; CHECK-NEXT:    str r5, [r3, #12]
; CHECK-NEXT:    isb sy
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    ldr r5, [r3, #12]
; CHECK-NEXT:    cmp r5, #0
; CHECK-NEXT:    bne .LBB0_3
; CHECK-NEXT:    ldr r5, [r3, #4]
; CHECK-NEXT:    str r5, [r1, r4]
; CHECK-NEXT:    adds r2, r2, #1
; CHECK-NEXT:    b .LBB0_1
; CHECK-NEXT:  .LBB0_5:
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    pop {r4, r5, r7, pc}
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  .LCPI0_0:
; CHECK-NEXT:    .long 805355524
entry:
  br label %for.cond

for.cond:                                         ; preds = %B.exit, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %B.exit ]
  %exitcond = icmp eq i32 %i.0, 128
  br i1 %exitcond, label %for.end, label %for.body

for.body:                                         ; preds = %for.cond
  %mul = shl i32 %i.0, 2
  %add = add i32 %mul, %x
  store volatile i32 0, i32* inttoptr (i32 805355532 to i32*), align 4
  store volatile i32 %add, i32* inttoptr (i32 805355524 to i32*), align 4
  store volatile i32 1, i32* inttoptr (i32 805355536 to i32*), align 16
  tail call void @llvm.arm.isb(i32 15) #1
  br label %while.cond.i

while.cond.i:                                     ; preds = %while.cond.i, %for.body
  %0 = load volatile i32, i32* inttoptr (i32 805355536 to i32*), align 16
  %tobool.i = icmp eq i32 %0, 0
  br i1 %tobool.i, label %B.exit, label %while.cond.i

B.exit:                                           ; preds = %while.cond.i
  %1 = load volatile i32, i32* inttoptr (i32 805355528 to i32*), align 8
  %arrayidx = getelementptr inbounds i32, i32* %y, i32 %i.0
  store i32 %1, i32* %arrayidx, align 4
  %inc = add nuw nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0
}

; Function Attrs: nounwind
declare void @llvm.arm.isb(i32) #1

attributes #0 = { minsize nounwind optsize }
attributes #1 = { nounwind }
