; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -loop-unroll -verify-loop-info | FileCheck %s
; RUN: opt < %s -S -passes='require<opt-remark-emit>,loop-unroll,verify<loops>' | FileCheck %s
;
; Unit tests for LoopInfo::markAsRemoved.

declare i1 @check() nounwind

; Ensure that tail->inner is removed and rely on verify-loopinfo to
; check soundness.
define void @skiplevelexit() nounwind {
; CHECK-LABEL: @skiplevelexit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[OUTER:%.*]]
; CHECK:       outer:
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[TMP0:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 true, label [[OUTER_BACKEDGE:%.*]], label [[TAIL:%.*]]
; CHECK:       tail:
; CHECK-NEXT:    ret void
; CHECK:       outer.backedge:
; CHECK-NEXT:    br label [[OUTER]]
;
entry:
  br label %outer

outer:
  br label %inner

inner:
  %iv = phi i32 [ 0, %outer ], [ %inc, %tail ]
  %inc = add i32 %iv, 1
  call zeroext i1 @check()
  br i1 true, label %outer.backedge, label %tail

tail:
  br i1 false, label %inner, label %exit

outer.backedge:
  br label %outer

exit:
  ret void
}

; Remove the middle loop of a triply nested loop tree.
; Ensure that only the middle loop is removed and rely on verify-loopinfo to
; check soundness.
define void @unloopNested() {
; CHECK-LABEL: @unloopNested(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER:%.*]]
; CHECK:       while.cond.outer:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    [[CMP:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP]], label [[WHILE_BODY:%.*]], label [[WHILE_END:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[CMP3:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP3]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CMP_I48:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP_I48]], label [[IF_THEN_I:%.*]], label [[IF_ELSE20_I:%.*]]
; CHECK:       if.then.i:
; CHECK-NEXT:    [[CMP8_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP8_I]], label [[MERGE:%.*]], label [[IF_ELSE_I:%.*]]
; CHECK:       if.else.i:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       if.else20.i:
; CHECK-NEXT:    [[CMP25_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP25_I]], label [[MERGE]], label [[IF_ELSE28_I:%.*]]
; CHECK:       if.else28.i:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    br label [[WHILE_COND2_I:%.*]]
; CHECK:       while.cond2.i:
; CHECK-NEXT:    [[CMP_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP_I]], label [[WHILE_COND2_BACKEDGE_I:%.*]], label [[WHILE_END_I:%.*]]
; CHECK:       while.cond2.backedge.i:
; CHECK-NEXT:    br label [[WHILE_COND2_I]]
; CHECK:       while.end.i:
; CHECK-NEXT:    [[CMP1114_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP1114_I]], label [[WHILE_BODY12_LR_PH_I:%.*]], label [[WHILE_END14_I:%.*]]
; CHECK:       while.body12.lr.ph.i:
; CHECK-NEXT:    br label [[WHILE_END14_I]]
; CHECK:       while.end14.i:
; CHECK-NEXT:    [[CALL15_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CALL15_I]], label [[IF_END_I:%.*]], label [[EXIT:%.*]]
; CHECK:       if.end.i:
; CHECK-NEXT:    br label [[WHILE_COND2_BACKEDGE_I]]
; CHECK:       exit:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER]]
; CHECK:       while.end:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond.outer

while.cond.outer:
  br label %while.cond

while.cond:
  %cmp = call zeroext i1 @check()
  br i1 %cmp, label %while.body, label %while.end

while.body:
  %cmp3 = call zeroext i1 @check()
  br i1 %cmp3, label %if.then, label %if.end

if.then:
  br label %return

if.end:
  %cmp.i48 = call zeroext i1 @check()
  br i1 %cmp.i48, label %if.then.i, label %if.else20.i

if.then.i:
  %cmp8.i = call zeroext i1 @check()
  br i1 %cmp8.i, label %merge, label %if.else.i

if.else.i:
  br label %merge

if.else20.i:
  %cmp25.i = call zeroext i1 @check()
  br i1 %cmp25.i, label %merge, label %if.else28.i

if.else28.i:
  br label %merge

merge:
  br label %while.cond2.i

while.cond2.i:
  %cmp.i = call zeroext i1 @check()
  br i1 %cmp.i, label %while.cond2.backedge.i, label %while.end.i

while.cond2.backedge.i:
  br label %while.cond2.i

while.end.i:
  %cmp1114.i = call zeroext i1 @check()
  br i1 %cmp1114.i, label %while.body12.lr.ph.i, label %while.end14.i

while.body12.lr.ph.i:
  br label %while.end14.i

while.end14.i:
  %call15.i = call zeroext i1 @check()
  br i1 %call15.i, label %if.end.i, label %exit

if.end.i:
  br label %while.cond2.backedge.i

exit:
  br i1 false, label %while.cond, label %if.else

if.else:
  br label %while.cond.outer

while.end:
  br label %return

return:
  ret void
}

; Remove the middle loop of a deeply nested loop tree.
; Ensure that only the middle loop is removed and rely on verify-loopinfo to
; check soundness.
;
; This test must be disabled until trip count computation can be optimized...
; rdar:14038809 [SCEV]: Optimize trip count computation for multi-exit loops.
define void @unloopDeepNested() nounwind {
; CHECK-LABEL: @unloopDeepNested(
; CHECK-NEXT:  for.cond8.preheader.i:
; CHECK-NEXT:    [[CMP113_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP113_I]], label [[MAKE_DATA_EXIT:%.*]], label [[FOR_BODY13_LR_PH_I:%.*]]
; CHECK:       for.body13.lr.ph.i:
; CHECK-NEXT:    br label [[MAKE_DATA_EXIT]]
; CHECK:       make_data.exit:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER_OUTER:%.*]]
; CHECK:       while.cond.outer.outer:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER:%.*]]
; CHECK:       while.cond.outer:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER_I:%.*]]
; CHECK:       while.cond.outer.i:
; CHECK-NEXT:    [[TMP192_PH_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[TMP192_PH_I]], label [[WHILE_COND_OUTER_SPLIT_US_I:%.*]], label [[WHILE_BODY_LOOPEXIT:%.*]]
; CHECK:       while.cond.outer.split.us.i:
; CHECK-NEXT:    br label [[WHILE_COND_US_I:%.*]]
; CHECK:       while.cond.us.i:
; CHECK-NEXT:    [[CMP_US_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP_US_I]], label [[NEXT_DATA_EXIT:%.*]], label [[WHILE_BODY_US_I:%.*]]
; CHECK:       while.body.us.i:
; CHECK-NEXT:    [[CMP7_US_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP7_US_I]], label [[IF_THEN_US_I:%.*]], label [[IF_ELSE_I:%.*]]
; CHECK:       if.then.us.i:
; CHECK-NEXT:    br label [[WHILE_COND_US_I]]
; CHECK:       if.else.i:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER_I]]
; CHECK:       next_data.exit:
; CHECK-NEXT:    [[TMP192_PH_I_LCSSA28:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[TMP192_PH_I_LCSSA28]], label [[WHILE_END:%.*]], label [[WHILE_BODY:%.*]]
; CHECK:       while.body.loopexit:
; CHECK-NEXT:    br label [[WHILE_BODY]]
; CHECK:       while.body:
; CHECK-NEXT:    br label [[WHILE_COND_I:%.*]]
; CHECK:       while.cond.i:
; CHECK-NEXT:    [[CMP_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP_I]], label [[VALID_DATA_EXIT:%.*]], label [[WHILE_BODY_I:%.*]]
; CHECK:       while.body.i:
; CHECK-NEXT:    [[CMP7_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP7_I]], label [[VALID_DATA_EXIT]], label [[IF_END_I:%.*]]
; CHECK:       if.end.i:
; CHECK-NEXT:    br label [[WHILE_COND_I]]
; CHECK:       valid_data.exit:
; CHECK-NEXT:    [[CMP:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN12:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then12:
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TOBOOL3_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[TOBOOL3_I]], label [[COPY_DATA_EXIT:%.*]], label [[WHILE_BODY_LR_PH_I:%.*]]
; CHECK:       while.body.lr.ph.i:
; CHECK-NEXT:    br label [[COPY_DATA_EXIT]]
; CHECK:       copy_data.exit:
; CHECK-NEXT:    [[CMP38:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP38]], label [[IF_THEN39:%.*]], label [[WHILE_COND_OUTER]]
; CHECK:       if.then39:
; CHECK-NEXT:    [[CMP5_I:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP5_I]], label [[WHILE_COND_OUTER_OUTER_BACKEDGE:%.*]], label [[FOR_COND8_PREHEADER_I8_THREAD:%.*]]
; CHECK:       for.cond8.preheader.i8.thread:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER_OUTER_BACKEDGE]]
; CHECK:       while.cond.outer.outer.backedge:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER_OUTER]]
; CHECK:       while.end:
; CHECK-NEXT:    ret void
;
for.cond8.preheader.i:
  %cmp113.i = call zeroext i1 @check()
  br i1 %cmp113.i, label %make_data.exit, label %for.body13.lr.ph.i

for.body13.lr.ph.i:
  br label %make_data.exit

make_data.exit:
  br label %while.cond.outer.outer

while.cond.outer.outer:
  br label %while.cond.outer

while.cond.outer:
  br label %while.cond

while.cond:
  br label %while.cond.outer.i

while.cond.outer.i:
  %tmp192.ph.i = call zeroext i1 @check()
  br i1 %tmp192.ph.i, label %while.cond.outer.split.us.i, label %while.body.loopexit

while.cond.outer.split.us.i:
  br label %while.cond.us.i

while.cond.us.i:
  %cmp.us.i = call zeroext i1 @check()
  br i1 %cmp.us.i, label %next_data.exit, label %while.body.us.i

while.body.us.i:
  %cmp7.us.i = call zeroext i1 @check()
  br i1 %cmp7.us.i, label %if.then.us.i, label %if.else.i

if.then.us.i:
  br label %while.cond.us.i

if.else.i:
  br label %while.cond.outer.i

next_data.exit:
  %tmp192.ph.i.lcssa28 = call zeroext i1 @check()
  br i1 %tmp192.ph.i.lcssa28, label %while.end, label %while.body

while.body.loopexit:
  br label %while.body

while.body:
  br label %while.cond.i

while.cond.i:
  %cmp.i = call zeroext i1 @check()
  br i1 %cmp.i, label %valid_data.exit, label %while.body.i

while.body.i:
  %cmp7.i = call zeroext i1 @check()
  br i1 %cmp7.i, label %valid_data.exit, label %if.end.i

if.end.i:
  br label %while.cond.i

valid_data.exit:
  br i1 true, label %if.then, label %while.cond

if.then:
  %cmp = call zeroext i1 @check()
  br i1 %cmp, label %if.then12, label %if.end

if.then12:
  br label %if.end

if.end:
  %tobool3.i = call zeroext i1 @check()
  br i1 %tobool3.i, label %copy_data.exit, label %while.body.lr.ph.i

while.body.lr.ph.i:
  br label %copy_data.exit

copy_data.exit:
  %cmp38 = call zeroext i1 @check()
  br i1 %cmp38, label %if.then39, label %while.cond.outer

if.then39:
  %cmp5.i = call zeroext i1 @check()
  br i1 %cmp5.i, label %while.cond.outer.outer.backedge, label %for.cond8.preheader.i8.thread

for.cond8.preheader.i8.thread:
  br label %while.cond.outer.outer.backedge

while.cond.outer.outer.backedge:
  br label %while.cond.outer.outer

while.end:
  ret void
}

; Remove a nested loop with irreducible control flow.
; Ensure that only the middle loop is removed and rely on verify-loopinfo to
; check soundness.
define void @unloopIrreducible() nounwind {
; CHECK-LABEL: @unloopIrreducible(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[CMP2113:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP2113]], label [[FOR_BODY22_LR_PH:%.*]], label [[FOR_INC163:%.*]]
; CHECK:       for.body22.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY22:%.*]]
; CHECK:       for.body22:
; CHECK-NEXT:    br label [[FOR_BODY33:%.*]]
; CHECK:       for.body33:
; CHECK-NEXT:    br label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[CMP424:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP424]], label [[FOR_BODY43_LR_PH:%.*]], label [[FOR_END93:%.*]]
; CHECK:       for.body43.lr.ph:
; CHECK-NEXT:    br label [[FOR_END93]]
; CHECK:       for.end93:
; CHECK-NEXT:    [[CMP96:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP96]], label [[IF_THEN97:%.*]], label [[FOR_COND103:%.*]]
; CHECK:       if.then97:
; CHECK-NEXT:    br label [[FOR_COND103T:%.*]]
; CHECK:       for.cond103t:
; CHECK-NEXT:    br label [[FOR_COND103]]
; CHECK:       for.cond103:
; CHECK-NEXT:    [[CMP105:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP105]], label [[FOR_BODY106:%.*]], label [[FOR_END120:%.*]]
; CHECK:       for.body106:
; CHECK-NEXT:    [[CMP108:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP108]], label [[IF_THEN109:%.*]], label [[FOR_INC117:%.*]]
; CHECK:       if.then109:
; CHECK-NEXT:    br label [[FOR_INC117]]
; CHECK:       for.inc117:
; CHECK-NEXT:    br label [[FOR_COND103T]]
; CHECK:       for.end120:
; CHECK-NEXT:    br label [[FOR_INC159:%.*]]
; CHECK:       for.inc159:
; CHECK-NEXT:    br label [[FOR_INC163]]
; CHECK:       for.inc163:
; CHECK-NEXT:    [[CMP12:%.*]] = call zeroext i1 @check()
; CHECK-NEXT:    br i1 [[CMP12]], label [[FOR_BODY]], label [[FOR_END166:%.*]]
; CHECK:       for.end166:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %cmp2113 = call zeroext i1 @check()
  br i1 %cmp2113, label %for.body22.lr.ph, label %for.inc163

for.body22.lr.ph:
  br label %for.body22

for.body22:
  br label %for.body33

for.body33:
  br label %for.end

for.end:
  %cmp424 = call zeroext i1 @check()
  br i1 %cmp424, label %for.body43.lr.ph, label %for.end93

for.body43.lr.ph:
  br label %for.end93

for.end93:
  %cmp96 = call zeroext i1 @check()
  br i1 %cmp96, label %if.then97, label %for.cond103

if.then97:
  br label %for.cond103t

for.cond103t:
  br label %for.cond103

for.cond103:
  %cmp105 = call zeroext i1 @check()
  br i1 %cmp105, label %for.body106, label %for.end120

for.body106:
  %cmp108 = call zeroext i1 @check()
  br i1 %cmp108, label %if.then109, label %for.inc117

if.then109:
  br label %for.inc117

for.inc117:
  br label %for.cond103t

for.end120:
  br label %for.inc159

for.inc159:
  br i1 false, label %for.body22, label %for.cond15.for.inc163_crit_edge

for.cond15.for.inc163_crit_edge:
  br label %for.inc163

for.inc163:
  %cmp12 = call zeroext i1 @check()
  br i1 %cmp12, label %for.body, label %for.end166

for.end166:
  ret void

}

; Remove a loop whose exit branches into a sibling loop.
; Ensure that only the loop is removed and rely on verify-loopinfo to
; check soundness.
define void @unloopCriticalEdge() nounwind {
; CHECK-LABEL: @unloopCriticalEdge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND31:%.*]]
; CHECK:       for.cond31:
; CHECK-NEXT:    br i1 false, label [[FOR_BODY35:%.*]], label [[FOR_END94:%.*]]
; CHECK:       for.body35:
; CHECK-NEXT:    br label [[WHILE_COND_I_PREHEADER:%.*]]
; CHECK:       while.cond.i.preheader:
; CHECK-NEXT:    br i1 undef, label [[WHILE_COND_I_PREHEADER_SPLIT:%.*]], label [[WHILE_COND_OUTER_I_LOOPEXIT_SPLIT:%.*]]
; CHECK:       while.cond.i.preheader.split:
; CHECK-NEXT:    br label [[WHILE_COND_I:%.*]]
; CHECK:       while.cond.i:
; CHECK-NEXT:    br i1 true, label [[WHILE_COND_I]], label [[WHILE_COND_OUTER_I_LOOPEXIT:%.*]]
; CHECK:       while.cond.outer.i.loopexit:
; CHECK-NEXT:    br label [[WHILE_COND_OUTER_I_LOOPEXIT_SPLIT]]
; CHECK:       while.cond.outer.i.loopexit.split:
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    br label [[FOR_END78:%.*]]
; CHECK:       for.end78:
; CHECK-NEXT:    br i1 false, label [[PROC2_EXIT:%.*]], label [[FOR_COND_I_PREHEADER:%.*]]
; CHECK:       for.cond.i.preheader:
; CHECK-NEXT:    br label [[FOR_COND_I:%.*]]
; CHECK:       for.cond.i:
; CHECK-NEXT:    br label [[FOR_COND_I]]
; CHECK:       Proc2.exit:
; CHECK-NEXT:    br label [[FOR_COND31]]
; CHECK:       for.end94:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond31

for.cond31:
  br i1 undef, label %for.body35, label %for.end94

for.body35:
  br label %while.cond.i.preheader

while.cond.i.preheader:
  br i1 undef, label %while.cond.i.preheader.split, label %while.cond.outer.i.loopexit.split

while.cond.i.preheader.split:
  br label %while.cond.i

while.cond.i:
  br i1 true, label %while.cond.i, label %while.cond.outer.i.loopexit

while.cond.outer.i.loopexit:
  br label %while.cond.outer.i.loopexit.split

while.cond.outer.i.loopexit.split:
  br i1 false, label %while.cond.i.preheader, label %Func2.exit

Func2.exit:
  br label %while.body

while.body:
  br i1 false, label %while.body, label %while.end

while.end:
  br label %for.end78

for.end78:
  br i1 undef, label %Proc2.exit, label %for.cond.i.preheader

for.cond.i.preheader:
  br label %for.cond.i

for.cond.i:
  br label %for.cond.i

Proc2.exit:
  br label %for.cond31

for.end94:
  ret void
}

; Test UnloopUpdater::removeBlocksFromAncestors.
;
; Check that the loop backedge is removed from the middle loop 1699,
; but not the inner loop 1676.
define void @removeSubloopBlocks() nounwind {
; CHECK-LABEL: @removeSubloopBlocks(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[TRYAGAIN_OUTER:%.*]]
; CHECK:       tryagain.outer:
; CHECK-NEXT:    br label [[TRYAGAIN:%.*]]
; CHECK:       tryagain:
; CHECK-NEXT:    br i1 false, label [[SW_BB1669:%.*]], label [[SW_BB304:%.*]]
; CHECK:       sw.bb304:
; CHECK-NEXT:    ret void
; CHECK:       sw.bb1669:
; CHECK-NEXT:    br i1 true, label [[SW_DEFAULT1711:%.*]], label [[WHILE_COND1676_PREHEADER:%.*]]
; CHECK:       while.cond1676.preheader:
; CHECK-NEXT:    br label [[WHILE_COND1676:%.*]]
; CHECK:       while.cond1676:
; CHECK-NEXT:    br i1 true, label [[WHILE_END1699:%.*]], label [[WHILE_BODY1694:%.*]]
; CHECK:       while.body1694:
; CHECK-NEXT:    unreachable
; CHECK:       while.end1699:
; CHECK-NEXT:    br label [[SW_DEFAULT1711]]
; CHECK:       sw.default1711:
; CHECK-NEXT:    br label [[DEFCHAR:%.*]]
; CHECK:       defchar:
; CHECK-NEXT:    br i1 undef, label [[IF_END2413:%.*]], label [[IF_THEN2368:%.*]]
; CHECK:       if.then2368:
; CHECK-NEXT:    unreachable
; CHECK:       if.end2413:
; CHECK-NEXT:    unreachable
;
entry:
  br label %tryagain.outer

tryagain.outer:                                   ; preds = %sw.bb304, %entry
  br label %tryagain

tryagain:                                         ; preds = %while.end1699, %tryagain.outer
  br i1 undef, label %sw.bb1669, label %sw.bb304

sw.bb304:                                         ; preds = %tryagain
  br i1 undef, label %return, label %tryagain.outer

sw.bb1669:                                        ; preds = %tryagain
  br i1 undef, label %sw.default1711, label %while.cond1676

while.cond1676:                                   ; preds = %while.body1694, %sw.bb1669
  br i1 undef, label %while.end1699, label %while.body1694

while.body1694:                                   ; preds = %while.cond1676
  br label %while.cond1676

while.end1699:                                    ; preds = %while.cond1676
  br i1 false, label %tryagain, label %sw.default1711

sw.default1711:                                   ; preds = %while.end1699, %sw.bb1669, %tryagain
  br label %defchar

defchar:                                          ; preds = %sw.default1711, %sw.bb376
  br i1 undef, label %if.end2413, label %if.then2368

if.then2368:                                      ; preds = %defchar
  unreachable

if.end2413:                                       ; preds = %defchar
  unreachable

return:                                           ; preds = %sw.bb304
  ret void
}

; PR11335: the most deeply nested block should be removed from the outer loop.
define void @removeSubloopBlocks2() nounwind {
; CHECK-LABEL: @removeSubloopBlocks2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL_I:%.*]] = icmp ne i32 undef, 0
; CHECK-NEXT:    br label [[LBL_616:%.*]]
; CHECK:       lbl_616.loopexit:
; CHECK-NEXT:    br label [[LBL_616]]
; CHECK:       lbl_616:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br i1 false, label [[FOR_COND1_PREHEADER:%.*]], label [[LBL_616_LOOPEXIT:%.*]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    br label [[FOR_COND1:%.*]]
; CHECK:       for.cond1.loopexit:
; CHECK-NEXT:    unreachable
; CHECK:       for.cond1:
; CHECK-NEXT:    br i1 false, label [[FOR_BODY2:%.*]], label [[FOR_COND3:%.*]]
; CHECK:       for.body2:
; CHECK-NEXT:    br label [[FOR_COND_I:%.*]]
; CHECK:       for.cond.i:
; CHECK-NEXT:    br i1 [[TOBOOL_I]], label [[FOR_COND_I]], label [[FOR_COND1_LOOPEXIT:%.*]]
; CHECK:       for.cond3:
; CHECK-NEXT:    ret void
;
entry:
  %tobool.i = icmp ne i32 undef, 0
  br label %lbl_616

lbl_616.loopexit:                                 ; preds = %for.cond
  br label %lbl_616

lbl_616:                                          ; preds = %lbl_616.loopexit, %entry
  br label %for.cond

for.cond:                                         ; preds = %for.cond3, %lbl_616
  br i1 false, label %for.cond1.preheader, label %lbl_616.loopexit

for.cond1.preheader:                              ; preds = %for.cond
  br label %for.cond1

for.cond1.loopexit:                               ; preds = %for.cond.i
  br label %for.cond1

for.cond1:                                        ; preds = %for.cond1.loopexit, %for.cond1.preheader
  br i1 false, label %for.body2, label %for.cond3

for.body2:                                        ; preds = %for.cond1
  br label %for.cond.i

for.cond.i:                                       ; preds = %for.cond.i, %for.body2
  br i1 %tobool.i, label %for.cond.i, label %for.cond1.loopexit

for.cond3:                                        ; preds = %for.cond1
  br i1 false, label %for.cond, label %if.end

if.end:                                           ; preds = %for.cond3
  ret void
}
