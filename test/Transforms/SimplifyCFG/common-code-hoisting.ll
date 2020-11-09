; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -hoist-common-insts=1 -S < %s                    | FileCheck %s --check-prefix=HOIST
; RUN: opt -simplifycfg -hoist-common-insts=0 -S < %s                    | FileCheck %s --check-prefix=NOHOIST
; RUN: opt -simplifycfg                       -S < %s                    | FileCheck %s --check-prefix=NOHOIST

; This example is produced from a very basic C code:
;
;   void f0();
;   void f1();
;   void f2();
;
;   void loop(int width) {
;       if(width < 1)
;           return;
;       for(int i = 0; i < width - 1; ++i) {
;           f0();
;           f1();
;       }
;       f0();
;       f2();
;   }

; We have a choice here. We can either
; * hoist the f0() call into loop header,
;   * which potentially makes loop rotation unprofitable since loop header might
;     have grown above certain threshold, and such unrotated loops will be
;     ignored by LoopVectorizer, preventing vectorization
;   * or loop rotation will succeed, resulting in some weird PHIs that will also
;     harm vectorization
; * or not hoist f0() call before performing loop rotation,
;   at the cost of potential code bloat and/or potentially successfully rotating
;   the loops, vectorizing them at the cost of compile time.

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i1 @gen1()

declare void @f0()
declare void @f1()
declare void @f2()

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

define void @_Z4loopi(i1 %cmp) {
; HOIST-LABEL: @_Z4loopi(
; HOIST-NEXT:  entry:
; HOIST-NEXT:    br i1 [[CMP:%.*]], label [[RETURN:%.*]], label [[FOR_COND:%.*]]
; HOIST:       for.cond:
; HOIST-NEXT:    [[CMP1:%.*]] = call i1 @gen1()
; HOIST-NEXT:    call void @f0()
; HOIST-NEXT:    br i1 [[CMP1]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; HOIST:       for.body:
; HOIST-NEXT:    call void @f1()
; HOIST-NEXT:    br label [[FOR_COND]]
; HOIST:       for.end:
; HOIST-NEXT:    call void @f2()
; HOIST-NEXT:    br label [[RETURN]]
; HOIST:       return:
; HOIST-NEXT:    ret void
;
; NOHOIST-LABEL: @_Z4loopi(
; NOHOIST-NEXT:  entry:
; NOHOIST-NEXT:    br i1 [[CMP:%.*]], label [[RETURN:%.*]], label [[FOR_COND:%.*]]
; NOHOIST:       for.cond:
; NOHOIST-NEXT:    [[CMP1:%.*]] = call i1 @gen1()
; NOHOIST-NEXT:    br i1 [[CMP1]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; NOHOIST:       for.body:
; NOHOIST-NEXT:    call void @f0()
; NOHOIST-NEXT:    call void @f1()
; NOHOIST-NEXT:    br label [[FOR_COND]]
; NOHOIST:       for.end:
; NOHOIST-NEXT:    call void @f0()
; NOHOIST-NEXT:    call void @f2()
; NOHOIST-NEXT:    br label [[RETURN]]
; NOHOIST:       return:
; NOHOIST-NEXT:    ret void
;
entry:
  br i1 %cmp, label %if.then, label %if.end

if.then:
  br label %return

if.end:
  br label %for.cond

for.cond:
  %cmp1 = call i1 @gen1()
  br i1 %cmp1, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  br label %for.end

for.body:
  call void @f0()
  call void @f1()
  br label %for.inc

for.inc:
  br label %for.cond

for.end:
  call void @f0()
  call void @f2()
  br label %return

return:
  ret void
}
