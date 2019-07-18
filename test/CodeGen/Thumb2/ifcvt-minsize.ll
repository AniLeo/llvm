; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8m.main-none-none-eabi %s -o - -verify-machineinstrs | FileCheck %s

declare i32 @fn(i32) #0

define i32 @f1(i32 %a) #0 {
; CHECK-LABEL: f1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    bl fn
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    cbz r4, .LBB0_2
; CHECK-NEXT:  @ %bb.1: @ %return
; CHECK-NEXT:    pop {r4, pc}
; CHECK-NEXT:  .LBB0_2: @ %if.end
; CHECK-NEXT:    bl fn
; CHECK-NEXT:    adds r0, #1
; CHECK-NEXT:    pop {r4, pc}
entry:
  %call = tail call i32 @fn(i32 %a) #2
  %tobool = icmp eq i32 %a, 0
  br i1 %tobool, label %if.end, label %return

if.end:                                           ; preds = %entry
  %call1 = tail call i32 @fn(i32 0) #2
  %add = add nsw i32 %call1, 1
  br label %return

return:                                           ; preds = %entry, %if.end
  %retval.0 = phi i32 [ %add, %if.end ], [ 0, %entry ]
  ret i32 %retval.0
}

define i32 @f2(i32 %a) #0 {
; CHECK-LABEL: f2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    bl fn
; CHECK-NEXT:    movs r0, #0
; CHECK-NEXT:    cmp r4, #1
; CHECK-NEXT:    bne .LBB1_2
; CHECK-NEXT:  @ %bb.1: @ %if.end
; CHECK-NEXT:    bl fn
; CHECK-NEXT:    adds r0, #1
; CHECK-NEXT:  .LBB1_2: @ %return
; CHECK-NEXT:    pop {r4, pc}
entry:
  %call = tail call i32 @fn(i32 %a) #2
  %tobool = icmp eq i32 %a, 1
  br i1 %tobool, label %if.end, label %return

if.end:                                           ; preds = %entry
  %call1 = tail call i32 @fn(i32 0) #2
  %add = add nsw i32 %call1, 1
  br label %return

return:                                           ; preds = %entry, %if.end
  %retval.0 = phi i32 [ %add, %if.end ], [ 0, %entry ]
  ret i32 %retval.0
}

define void @f3(i32 %x) #0 {
; CHECK-LABEL: f3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r0, #1
; CHECK-NEXT:    itt eq
; CHECK-NEXT:    moveq r0, #0
; CHECK-NEXT:    bleq fn
; CHECK-NEXT:    pop {r7, pc}
entry:
  %p = icmp eq i32 %x, 1
  br i1 %p, label %t, label %f

t:
  call i32 @fn(i32 0)
  br label %f

f:
  ret void
}

attributes #0 = { minsize nounwind optsize }

