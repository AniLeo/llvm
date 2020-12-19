; RUN: opt < %s -S -indvars -loop-deletion -simplifycfg -simplifycfg-require-and-preserve-domtree=1 | FileCheck %s
; PR5794

; Indvars and loop deletion should be able to eliminate all looping
; in this testcase.

; CHECK:      define i32 @pmat(i32 %m, i32 %n, double* %y) #0 {
; CHECK-NEXT: entry:
; CHECK-NEXT:   ret i32 0
; CHECK-NEXT: }

target datalayout = "e-p:64:64:64"

define i32 @pmat(i32 %m, i32 %n, double* %y) nounwind {
entry:
  %cmp4 = icmp sgt i32 %m, 0
  br i1 %cmp4, label %bb.n10, label %w.e12

w.c:
  %cmp = icmp slt i32 %inc11, %m
  br i1 %cmp, label %w.c2.p, label %w.c.w.e12c

w.c.w.e12c:
  br label %w.c.w.e12c.s

w.c.w.e12c.s:
  br label %w.e12

bb.n10:
  %cmp51 = icmp sgt i32 %n, 0
  br i1 %cmp51, label %bb.n10.w.c.w.e12c.sc, label %bb.n10.bb.n10.sc

bb.n10.bb.n10.sc:
  br label %bb.n10.s

bb.n10.w.c.w.e12c.sc:
  br label %w.c.w.e12c.s

bb.n10.s:
  br label %w.c2.p

w.c2.p:
  %i.05 = phi i32 [ 0, %bb.n10.s ], [ %inc11, %w.c ]
  br i1 false, label %bb.n, label %w.e

w.c2:
  br i1 undef, label %w.b6, label %w.c2.w.ec

w.c2.w.ec:
  br label %w.e

bb.n:
  br label %w.b6

w.b6:
  br label %w.c2

w.e:
  %i.08 = phi i32 [ undef, %w.c2.w.ec ], [ %i.05, %w.c2.p ]
  %inc11 = add nsw i32 %i.08, 1
  br label %w.c

w.e12:
  ret i32 0
}

; CHECK: attributes #0 = { nounwind }
