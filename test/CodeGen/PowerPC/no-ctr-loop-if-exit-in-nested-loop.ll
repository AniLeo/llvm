; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr8 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -verify-machineinstrs < %s | FileCheck %s
define signext i32 @test(i32* noalias %PtrA, i32* noalias %PtrB, i32 signext %LenA, i32 signext %LenB) #0 {
; CHECK-LABEL: test:
; CHECK-NOT: mtctr
; CHECK-NOT: bdnz
; CHECK-NOT: bdz
; CHECK:     blr
entry:
  br label %block2

block2:                                           ; preds = %entry
  br label %block3

block3:                                           ; preds = %block8, %block2
  %OuterInd.0 = phi i32 [ 0, %block2 ], [ %inc, %block8 ]
  %InnerInd.0 = phi i32 [ 0, %block2 ], [ %inc1, %block8 ]
  %inc = add nsw i32 %OuterInd.0, 1
  br label %block4

block4:                                           ; preds = %if.then4, %block3
  %InnerInd.1 = phi i32 [ %InnerInd.0, %block3 ], [ %inc1, %if.then4 ]
  %cmp = icmp sge i32 %inc, %LenA
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %block4
  %sub = sub nsw i32 %inc, 1
  %idxprom = sext i32 %sub to i64
  %arrayidx = getelementptr inbounds i32, i32* %PtrA, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  ret i32 %0

if.end:                                           ; preds = %block4
  br label %block5

block5:                                           ; preds = %if.end
  %inc1 = add nsw i32 %InnerInd.1, 1
  %idxprom2 = sext i32 %InnerInd.1 to i64
  %arrayidx3 = getelementptr inbounds i32, i32* %PtrB, i64 %idxprom2
  %1 = load i32, i32* %arrayidx3, align 4
  %tobool = icmp ne i32 %1, 0
  br i1 %tobool, label %if.then4, label %if.end9

if.then4:                                         ; preds = %block5
  %idxprom5 = sext i32 %inc to i64
  %arrayidx6 = getelementptr inbounds i32, i32* %PtrA, i64 %idxprom5
  %2 = load i32, i32* %arrayidx6, align 4
  %idxprom7 = sext i32 %inc1 to i64
  %arrayidx8 = getelementptr inbounds i32, i32* %PtrB, i64 %idxprom7
  store i32 %2, i32* %arrayidx8, align 4
  br label %block4

if.end9:                                          ; preds = %block5
  br label %block6

block6:                                           ; preds = %if.end9
  %idxprom10 = sext i32 %inc to i64
  %arrayidx11 = getelementptr inbounds i32, i32* %PtrA, i64 %idxprom10
  %3 = load i32, i32* %arrayidx11, align 4
  %inc12 = add nsw i32 %3, 1
  store i32 %inc12, i32* %arrayidx11, align 4
  br label %block8

block8:                                           ; preds = %block6
  br label %block3
}
