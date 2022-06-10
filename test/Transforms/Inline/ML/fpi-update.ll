target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-grtev4-linux-gnu"

; TODO: we could instantiate the MLInliner with a non-model generated evaluator
; and drop the requirement
; REQUIRES: llvm_inliner_model_autogenerated

; RUN: opt -enable-ml-inliner=release -passes='scc-oz-module-inliner,print<inline-advisor>' \
; RUN:     -keep-inline-advisor-for-printing -max-devirt-iterations=0 \
; RUN:     -mandatory-inlining-first=0 -S < %s 2>&1 | FileCheck %s 

define void @caller(i32 %i) #1 {
  call void @callee(i32 %i)
  ret void
}

define void @callee(i32 %i) #0 {
entry:
  br label %loop
loop:
  %cond = icmp slt i32 %i, 0
  br i1 %cond, label %loop, label %exit
exit:
  ret void
}

attributes #0 = { alwaysinline }
attributes #1 = { noinline optnone }

; CHECK: [MLInlineAdvisor] FPI:
; CHECK: caller:
; CHECK: MaxLoopDepth: 1
