; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -licm -S | FileCheck %s
; RUN: opt -aa-pipeline=tbaa,basic-aa -passes='require<aa>,require<targetir>,require<scalar-evolution>,require<opt-remark-emit>,loop-mssa(licm)' -S %s | FileCheck %s

; Make sure we don't hoist a conditionally-executed store out of the loop;
; it would violate the concurrency memory model

@g = common global i32 0, align 4

define void @bar(i32 %n, i32 %b) nounwind uwtable ssp {
; CHECK-LABEL: @bar(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC5:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_0]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[FOR_INC]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* @g, align 4
; CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP3]], 1
; CHECK-NEXT:    store i32 [[INC]], i32* @g, align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC5]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc5, %for.inc ]
  %cmp = icmp slt i32 %i.0, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %tobool = icmp eq i32 %b, 0
  br i1 %tobool, label %for.inc, label %if.then

if.then:                                          ; preds = %for.body
  %tmp3 = load i32, i32* @g, align 4
  %inc = add nsw i32 %tmp3, 1
  store i32 %inc, i32* @g, align 4
  br label %for.inc


for.inc:                                          ; preds = %for.body, %if.then
  %inc5 = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}
