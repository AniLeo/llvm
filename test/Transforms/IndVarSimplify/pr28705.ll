; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; PR28705
; RUN: opt < %s -indvars -S | FileCheck %s

; Check IndVarSimplify doesn't replace external use of the induction var
; "%inc.i.i" with "%.sroa.speculated + 1" because it is not profitable.
;
;
define void @foo(i32 %sub.ptr.div.i, i8* %ref.i1174) local_unnamed_addr {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_I1137:%.*]] = icmp ugt i32 [[SUB_PTR_DIV_I:%.*]], 3
; CHECK-NEXT:    [[DOTSROA_SPECULATED:%.*]] = select i1 [[CMP_I1137]], i32 3, i32 [[SUB_PTR_DIV_I]]
; CHECK-NEXT:    [[CMP6483126:%.*]] = icmp eq i32 [[DOTSROA_SPECULATED]], 0
; CHECK-NEXT:    br i1 [[CMP6483126]], label [[XZ_EXIT:%.*]], label [[FOR_BODY650_LR_PH:%.*]]
; CHECK:       for.body650.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY650:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    [[INC_I_I_LCSSA:%.*]] = phi i32 [ [[INC_I_I:%.*]], [[FOR_BODY650]] ]
; CHECK-NEXT:    br label [[XZ_EXIT]]
; CHECK:       XZ.exit:
; CHECK-NEXT:    [[DB_SROA_9_0_LCSSA:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[INC_I_I_LCSSA]], [[LOOPEXIT:%.*]] ]
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       for.body650:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[FOR_BODY650_LR_PH]] ], [ [[INC655:%.*]], [[FOR_BODY650]] ]
; CHECK-NEXT:    [[IV2:%.*]] = phi i32 [ 1, [[FOR_BODY650_LR_PH]] ], [ [[INC_I_I]], [[FOR_BODY650]] ]
; CHECK-NEXT:    [[ARRAYIDX_I_I1105:%.*]] = getelementptr inbounds i8, i8* [[REF_I1174:%.*]], i32 [[IV2]]
; CHECK-NEXT:    store i8 7, i8* [[ARRAYIDX_I_I1105]], align 1
; CHECK-NEXT:    [[INC_I_I]] = add nuw nsw i32 [[IV2]], 1
; CHECK-NEXT:    [[INC655]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[CMP648:%.*]] = icmp eq i32 [[INC655]], [[DOTSROA_SPECULATED]]
; CHECK-NEXT:    br i1 [[CMP648]], label [[LOOPEXIT]], label [[FOR_BODY650]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  %cmp.i1137 = icmp ugt i32 %sub.ptr.div.i, 3
  %.sroa.speculated = select i1 %cmp.i1137, i32 3, i32 %sub.ptr.div.i
  %cmp6483126 = icmp eq i32 %.sroa.speculated, 0
  br i1 %cmp6483126, label %XZ.exit, label %for.body650.lr.ph

for.body650.lr.ph:
  br label %for.body650

loopexit:
  %inc.i.i.lcssa = phi i32 [ %inc.i.i, %for.body650 ]
  br label %XZ.exit

XZ.exit:
  %DB.sroa.9.0.lcssa = phi i32 [ 1, %entry ], [ %inc.i.i.lcssa, %loopexit ]
  br label %end

for.body650:
  %iv = phi i32 [ 0, %for.body650.lr.ph ], [ %inc655, %for.body650 ]
  %iv2 = phi i32 [ 1, %for.body650.lr.ph ], [ %inc.i.i, %for.body650 ]
  %arrayidx.i.i1105 = getelementptr inbounds i8, i8* %ref.i1174, i32 %iv2
  store i8 7, i8* %arrayidx.i.i1105, align 1
  %inc.i.i = add i32 %iv2, 1
  %inc655 = add i32 %iv, 1
  %cmp648 = icmp eq i32 %inc655, %.sroa.speculated
  br i1 %cmp648, label %loopexit, label %for.body650

end:
  ret void
}
