; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv7m-none-eabi | FileCheck %s


define i32 @test(i32 %a, i32 %b, i32 %c, i32 %d) #0 {
; CHECK-LABEL: test:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    adds r4, r3, r0
; CHECK-NEXT:    add.w r12, r2, r1
; CHECK-NEXT:    add r0, r1
; CHECK-NEXT:    adds r1, r3, r2
; CHECK-NEXT:    mul r4, r4, r12
; CHECK-NEXT:    mla r0, r1, r0, r4
; CHECK-NEXT:    pop {r4, pc}
entry:
  %add = add nsw i32 %b, %a
  %add1 = add nsw i32 %d, %c
  %mul = mul nsw i32 %add1, %add
  %add2 = add nsw i32 %d, %a
  %add3 = add nsw i32 %c, %b
  %mul4 = mul nsw i32 %add2, %add3
  %add5 = add nsw i32 %mul, %mul4
  ret i32 %add5
}

define void @loop(i32 %I, i8* %A, i8* %B) #0 {
; CHECK-LABEL: loop:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-NEXT:    mov.w r12, #0
; CHECK-NEXT:    b .LBB1_2
; CHECK-NEXT:  .LBB1_1: @ %for.body
; CHECK-NEXT:    @ in Loop: Header=BB1_2 Depth=1
; CHECK-NEXT:    add.w r4, r12, r12, lsl #1
; CHECK-NEXT:    add.w r3, r2, r12, lsl #2
; CHECK-NEXT:    add r4, r1
; CHECK-NEXT:    add.w r12, r12, #1
; CHECK-NEXT:    ldrsb.w r6, [r4, #2]
; CHECK-NEXT:    ldrsb.w r5, [r4]
; CHECK-NEXT:    mov r7, r6
; CHECK-NEXT:    cmp r5, r6
; CHECK-NEXT:    it gt
; CHECK-NEXT:    movgt r7, r5
; CHECK-NEXT:    ldrsb.w r4, [r4, #1]
; CHECK-NEXT:    cmp r7, r4
; CHECK-NEXT:    it le
; CHECK-NEXT:    movle r7, r4
; CHECK-NEXT:    subs r4, r7, r4
; CHECK-NEXT:    subs r6, r7, r6
; CHECK-NEXT:    strb r6, [r3, #3]
; CHECK-NEXT:    strb r4, [r3, #2]
; CHECK-NEXT:    subs r4, r7, r5
; CHECK-NEXT:    strb r4, [r3, #1]
; CHECK-NEXT:    mvns r4, r7
; CHECK-NEXT:    strb r4, [r3]
; CHECK-NEXT:  .LBB1_2: @ %for.cond
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmp r12, r0
; CHECK-NEXT:    blt .LBB1_1
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %A.addr.0 = phi i8* [ %A, %entry ], [ %incdec.ptr2, %for.body ]
  %B.addr.0 = phi i8* [ %B, %entry ], [ %incdec.ptr47, %for.body ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i.0, %I
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.body:                                         ; preds = %for.cond
  %incdec.ptr = getelementptr inbounds i8, i8* %A.addr.0, i32 1
  %0 = load i8, i8* %A.addr.0, align 1
  %incdec.ptr1 = getelementptr inbounds i8, i8* %A.addr.0, i32 2
  %1 = load i8, i8* %incdec.ptr, align 1
  %incdec.ptr2 = getelementptr inbounds i8, i8* %A.addr.0, i32 3
  %2 = load i8, i8* %incdec.ptr1, align 1
  %3 = icmp sgt i8 %0, %2
  %4 = select i1 %3, i8 %0, i8 %2
  %5 = icmp sgt i8 %4, %1
  %6 = select i1 %5, i8 %4, i8 %1
  %7 = xor i8 %6, -1
  %sub34 = sub i8 %6, %0
  %sub38 = sub i8 %6, %1
  %sub42 = sub i8 %6, %2
  %incdec.ptr44 = getelementptr inbounds i8, i8* %B.addr.0, i32 1
  store i8 %7, i8* %B.addr.0, align 1
  %incdec.ptr45 = getelementptr inbounds i8, i8* %B.addr.0, i32 2
  store i8 %sub34, i8* %incdec.ptr44, align 1
  %incdec.ptr46 = getelementptr inbounds i8, i8* %B.addr.0, i32 3
  store i8 %sub38, i8* %incdec.ptr45, align 1
  %incdec.ptr47 = getelementptr inbounds i8, i8* %B.addr.0, i32 4
  store i8 %sub42, i8* %incdec.ptr46, align 1
  %inc = add nuw nsw i32 %i.0, 1
  br label %for.cond

for.cond.cleanup:                                 ; preds = %for.cond
  ret void
}


attributes #0 = { minsize optsize }
