; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -indvars -S | FileCheck %s
; rdar://10359193: assert "IndVar type must match IVInit type"

target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
target triple = "thumbv7-apple-darwin"

define void @test() nounwind {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond.loopexit:
; CHECK-NEXT:    br label [[WHILE_COND_BACKEDGE:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br i1 true, label [[WHILE_END:%.*]], label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN165:%.*]], label [[WHILE_COND_BACKEDGE]]
; CHECK:       while.cond.backedge:
; CHECK-NEXT:    br label [[WHILE_COND]]
; CHECK:       if.then165:
; CHECK-NEXT:    br i1 undef, label [[WHILE_COND_BACKEDGE]], label [[FOR_BODY_LR_PH_I81:%.*]]
; CHECK:       for.body.lr.ph.i81:
; CHECK-NEXT:    br label [[FOR_BODY_I86:%.*]]
; CHECK:       for.body.i86:
; CHECK-NEXT:    [[CMP196_I:%.*]] = icmp ult i32 0, undef
; CHECK-NEXT:    br i1 [[CMP196_I]], label [[FOR_BODY21_LR_PH_I:%.*]], label [[FOR_END_I129:%.*]]
; CHECK:       for.body21.lr.ph.i:
; CHECK-NEXT:    br label [[FOR_BODY21_I:%.*]]
; CHECK:       for.body21.i:
; CHECK-NEXT:    [[DESTYPIXELPTR_010_I:%.*]] = phi i8* [ null, [[FOR_BODY21_LR_PH_I]] ], [ [[INCDEC_PTR_I:%.*]], [[IF_END_I126:%.*]] ]
; CHECK-NEXT:    [[X_09_I:%.*]] = phi i32 [ 0, [[FOR_BODY21_LR_PH_I]] ], [ [[INC_I125:%.*]], [[IF_END_I126]] ]
; CHECK-NEXT:    br i1 undef, label [[IF_END_I126]], label [[IF_ELSE_I124:%.*]]
; CHECK:       if.else.i124:
; CHECK-NEXT:    store i8 undef, i8* [[DESTYPIXELPTR_010_I]], align 1
; CHECK-NEXT:    br label [[IF_END_I126]]
; CHECK:       if.end.i126:
; CHECK-NEXT:    [[INCDEC_PTR_I]] = getelementptr inbounds i8, i8* [[DESTYPIXELPTR_010_I]], i32 1
; CHECK-NEXT:    [[INC_I125]] = add nuw i32 [[X_09_I]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i32 [[INC_I125]], undef
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY21_I]], label [[FOR_END_I129_LOOPEXIT:%.*]]
; CHECK:       for.end.i129.loopexit:
; CHECK-NEXT:    br label [[FOR_END_I129]]
; CHECK:       for.end.i129:
; CHECK-NEXT:    br i1 false, label [[FOR_BODY_I86]], label [[WHILE_COND_LOOPEXIT:%.*]]
; CHECK:       while.end:
; CHECK-NEXT:    br label [[BAIL:%.*]]
; CHECK:       bail:
; CHECK-NEXT:    unreachable
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond

while.cond:
  br i1 undef, label %while.end, label %while.body

while.body:                                       ; preds = %while.cond
  br i1 undef, label %if.then165, label %while.cond

if.then165:                                       ; preds = %while.body
  br i1 undef, label %while.cond, label %for.body.lr.ph.i81

for.body.lr.ph.i81:                               ; preds = %if.then165
  br label %for.body.i86

for.body.i86:                                     ; preds = %for.end.i129, %for.body.lr.ph.i81
  %cmp196.i = icmp ult i32 0, undef
  br i1 %cmp196.i, label %for.body21.lr.ph.i, label %for.end.i129

for.body21.lr.ph.i:                               ; preds = %for.body.i86
  br label %for.body21.i

for.body21.i:
  %destYPixelPtr.010.i = phi i8* [ null, %for.body21.lr.ph.i ], [ %incdec.ptr.i, %if.end.i126 ]
  %x.09.i = phi i32 [ 0, %for.body21.lr.ph.i ], [ %inc.i125, %if.end.i126 ]
  br i1 undef, label %if.end.i126, label %if.else.i124

if.else.i124:                                     ; preds = %for.body21.i
  store i8 undef, i8* %destYPixelPtr.010.i, align 1
  br label %if.end.i126

if.end.i126:                                      ; preds = %if.else.i124, %for.body21.i
  %incdec.ptr.i = getelementptr inbounds i8, i8* %destYPixelPtr.010.i, i32 1
  %inc.i125 = add i32 %x.09.i, 1
  %cmp19.i = icmp ult i32 %inc.i125, undef
  br i1 %cmp19.i, label %for.body21.i, label %for.end.i129

for.end.i129:                                     ; preds = %if.end.i126, %for.body.i86
  br i1 undef, label %for.body.i86, label %while.cond

while.end:                                        ; preds = %while.cond
  br label %bail

bail:                                             ; preds = %while.end, %lor.lhs.false44, %lor.lhs.false41, %if.end29, %if.end
  unreachable

return:                                           ; preds = %lor.lhs.false20, %lor.lhs.false12, %lor.lhs.false, %entry
  ret void
}
