; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7 | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-darwin13.3.0"

define void @_foo(double %p1, double %p2, double %p3) #0 {
; CHECK-LABEL: @_foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TAB1:%.*]] = alloca [256 x i32], align 16
; CHECK-NEXT:    [[TAB2:%.*]] = alloca [256 x i32], align 16
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[MUL19:%.*]] = fmul double [[P1:%.*]], 1.638400e+04
; CHECK-NEXT:    [[MUL20:%.*]] = fmul double [[P3:%.*]], 1.638400e+04
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[MUL20]], 8.192000e+03
; CHECK-NEXT:    [[MUL21:%.*]] = fmul double [[P2:%.*]], 1.638400e+04
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV266:%.*]] = phi i64 [ 0, [[BB1]] ], [ [[INDVARS_IV_NEXT267:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[T_0259:%.*]] = phi double [ 0.000000e+00, [[BB1]] ], [ [[ADD27:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[P3_ADDR_0258:%.*]] = phi double [ [[ADD]], [[BB1]] ], [ [[ADD28:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[VECINIT_I_I237:%.*]] = insertelement <2 x double> poison, double [[T_0259]], i32 0
; CHECK-NEXT:    [[X13:%.*]] = tail call i32 @_xfn(<2 x double> [[VECINIT_I_I237]])
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [256 x i32], [256 x i32]* [[TAB1]], i64 0, i64 [[INDVARS_IV266]]
; CHECK-NEXT:    store i32 [[X13]], i32* [[ARRAYIDX]], align 4, [[TBAA0:!tbaa !.*]]
; CHECK-NEXT:    [[VECINIT_I_I:%.*]] = insertelement <2 x double> poison, double [[P3_ADDR_0258]], i32 0
; CHECK-NEXT:    [[X14:%.*]] = tail call i32 @_xfn(<2 x double> [[VECINIT_I_I]])
; CHECK-NEXT:    [[ARRAYIDX26:%.*]] = getelementptr inbounds [256 x i32], [256 x i32]* [[TAB2]], i64 0, i64 [[INDVARS_IV266]]
; CHECK-NEXT:    store i32 [[X14]], i32* [[ARRAYIDX26]], align 4, [[TBAA0]]
; CHECK-NEXT:    [[ADD27]] = fadd double [[MUL19]], [[T_0259]]
; CHECK-NEXT:    [[ADD28]] = fadd double [[MUL21]], [[P3_ADDR_0258]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT267]] = add nuw nsw i64 [[INDVARS_IV266]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT267]], 256
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[RETURN:%.*]], label [[FOR_BODY]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  %tab1 = alloca [256 x i32], align 16
  %tab2 = alloca [256 x i32], align 16
  br label %bb1


bb1:
  %mul19 = fmul double %p1, 1.638400e+04
  %mul20 = fmul double %p3, 1.638400e+04
  %add = fadd double %mul20, 8.192000e+03
  %mul21 = fmul double %p2, 1.638400e+04
  ; The SLPVectorizer crashed when scheduling this block after it inserted an
  ; insertelement instruction (during vectorizing the for.body block) at this position.
  br label %for.body

for.body:
  %indvars.iv266 = phi i64 [ 0, %bb1 ], [ %indvars.iv.next267, %for.body ]
  %t.0259 = phi double [ 0.000000e+00, %bb1 ], [ %add27, %for.body ]
  %p3.addr.0258 = phi double [ %add, %bb1 ], [ %add28, %for.body ]
  %vecinit.i.i237 = insertelement <2 x double> poison, double %t.0259, i32 0
  %x13 = tail call i32 @_xfn(<2 x double> %vecinit.i.i237) #2
  %arrayidx = getelementptr inbounds [256 x i32], [256 x i32]* %tab1, i64 0, i64 %indvars.iv266
  store i32 %x13, i32* %arrayidx, align 4, !tbaa !4
  %vecinit.i.i = insertelement <2 x double> poison, double %p3.addr.0258, i32 0
  %x14 = tail call i32 @_xfn(<2 x double> %vecinit.i.i) #2
  %arrayidx26 = getelementptr inbounds [256 x i32], [256 x i32]* %tab2, i64 0, i64 %indvars.iv266
  store i32 %x14, i32* %arrayidx26, align 4, !tbaa !4
  %add27 = fadd double %mul19, %t.0259
  %add28 = fadd double %mul21, %p3.addr.0258
  %indvars.iv.next267 = add nuw nsw i64 %indvars.iv266, 1
  %exitcond = icmp eq i64 %indvars.iv.next267, 256
  br i1 %exitcond, label %return, label %for.body

return:
  ret void
}

declare i32 @_xfn(<2 x double>) #4

!3 = !{!"int", !5, i64 0}
!4 = !{!3, !3, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
