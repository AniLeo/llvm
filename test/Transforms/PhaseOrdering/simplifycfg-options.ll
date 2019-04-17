; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O1 -S < %s                    | FileCheck %s --check-prefix=ALL --check-prefix=OLDPM
; RUN: opt -passes='default<O1>' -S < %s  | FileCheck %s --check-prefix=ALL --check-prefix=NEWPM

; Don't simplify unconditional branches from empty blocks in simplifyCFG
; until late in the pipeline because it can destroy canonical loop structure.

define i1 @PR33605(i32 %a, i32 %b, i32* %c) {
; ALL-LABEL: @PR33605(
; ALL-NEXT:  for.body:
; ALL-NEXT:    [[OR:%.*]] = or i32 [[B:%.*]], [[A:%.*]]
; ALL-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[C:%.*]], i64 1
; ALL-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; ALL-NEXT:    [[CMP:%.*]] = icmp eq i32 [[OR]], [[TMP0]]
; ALL-NEXT:    br i1 [[CMP]], label [[IF_END:%.*]], label [[IF_THEN:%.*]]
; ALL:       if.then:
; ALL-NEXT:    store i32 [[OR]], i32* [[ARRAYIDX]], align 4
; ALL-NEXT:    tail call void @foo()
; ALL-NEXT:    br label [[IF_END]]
; ALL:       if.end:
; ALL-NEXT:    [[CHANGED_1_OFF0:%.*]] = phi i1 [ true, [[IF_THEN]] ], [ false, [[FOR_BODY:%.*]] ]
; ALL-NEXT:    [[TMP1:%.*]] = load i32, i32* [[C]], align 4
; ALL-NEXT:    [[CMP_1:%.*]] = icmp eq i32 [[OR]], [[TMP1]]
; ALL-NEXT:    br i1 [[CMP_1]], label [[IF_END_1:%.*]], label [[IF_THEN_1:%.*]]
; ALL:       if.then.1:
; ALL-NEXT:    store i32 [[OR]], i32* [[C]], align 4
; ALL-NEXT:    tail call void @foo()
; ALL-NEXT:    br label [[IF_END_1]]
; ALL:       if.end.1:
; ALL-NEXT:    [[CHANGED_1_OFF0_1:%.*]] = phi i1 [ true, [[IF_THEN_1]] ], [ [[CHANGED_1_OFF0]], [[IF_END]] ]
; ALL-NEXT:    ret i1 [[CHANGED_1_OFF0_1]]
;
entry:
  br label %for.cond

for.cond:
  %i.0 = phi i32 [ 2, %entry ], [ %dec, %if.end ]
  %changed.0.off0 = phi i1 [ false, %entry ], [ %changed.1.off0, %if.end ]
  %dec = add nsw i32 %i.0, -1
  %tobool = icmp eq i32 %i.0, 0
  br i1 %tobool, label %for.cond.cleanup, label %for.body

for.cond.cleanup:
  %changed.0.off0.lcssa = phi i1 [ %changed.0.off0, %for.cond ]
  ret i1 %changed.0.off0.lcssa

for.body:
  %or = or i32 %a, %b
  %idxprom = sext i32 %dec to i64
  %arrayidx = getelementptr inbounds i32, i32* %c, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %cmp = icmp eq i32 %or, %0
  br i1 %cmp, label %if.end, label %if.then

if.then:
  store i32 %or, i32* %arrayidx, align 4
  call void @foo()
  br label %if.end

if.end:
  %changed.1.off0 = phi i1 [ true, %if.then ], [ %changed.0.off0, %for.body ]
  br label %for.cond
}

declare void @foo()

; PR34603 - https://bugs.llvm.org/show_bug.cgi?id=34603
; We should have a select of doubles, not a select of double pointers.
; SimplifyCFG should not flatten this before early-cse has a chance to eliminate redundant ops.

define double @max_of_loads(double* %x, double* %y, i64 %i) {
; ALL-LABEL: @max_of_loads(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[XI_PTR:%.*]] = getelementptr double, double* [[X:%.*]], i64 [[I:%.*]]
; ALL-NEXT:    [[YI_PTR:%.*]] = getelementptr double, double* [[Y:%.*]], i64 [[I]]
; ALL-NEXT:    [[XI:%.*]] = load double, double* [[XI_PTR]], align 8
; ALL-NEXT:    [[YI:%.*]] = load double, double* [[YI_PTR]], align 8
; ALL-NEXT:    [[CMP:%.*]] = fcmp ogt double [[XI]], [[YI]]
; ALL-NEXT:    [[XI_YI:%.*]] = select i1 [[CMP]], double [[XI]], double [[YI]]
; ALL-NEXT:    ret double [[XI_YI]]
;
entry:
  %xi_ptr = getelementptr double, double* %x, i64 %i
  %yi_ptr = getelementptr double, double* %y, i64 %i
  %xi = load double, double* %xi_ptr
  %yi = load double, double* %yi_ptr
  %cmp = fcmp ogt double %xi, %yi
  br i1 %cmp, label %if, label %else

if:
  %xi_ptr_again = getelementptr double, double* %x, i64 %i
  %xi_again = load double, double* %xi_ptr_again
  br label %end

else:
  %yi_ptr_again = getelementptr double, double* %y, i64 %i
  %yi_again = load double, double* %yi_ptr_again
  br label %end

end:
  %max = phi double [ %xi_again,  %if ], [ %yi_again, %else ]
  ret double %max
}

