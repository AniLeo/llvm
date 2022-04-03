; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -loop-idiom < %s -S | FileCheck %s

target datalayout = "e-p:32:32:32-p1:64:64:64-p2:16:16:16-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:32-n8:16:32:64"
target triple = "x86_64-apple-darwin10.0.0"

; Two dimensional nested loop should be promoted to one big memset.
define void @test10(i8 addrspace(2)* %X) nounwind ssp {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.memset.p2i8.i16(i8 addrspace(2)* align 1 [[X:%.*]], i8 0, i16 10000, i1 false)
; CHECK-NEXT:    br label [[BB_NPH:%.*]]
; CHECK:       bb.nph:
; CHECK-NEXT:    [[I_04:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[INC12:%.*]], [[FOR_INC10:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = mul nuw nsw i16 [[I_04]], 100
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i8, i8 addrspace(2)* [[X]], i16 [[TMP0]]
; CHECK-NEXT:    br label [[FOR_BODY5:%.*]]
; CHECK:       for.body5:
; CHECK-NEXT:    [[J_02:%.*]] = phi i16 [ 0, [[BB_NPH]] ], [ [[INC:%.*]], [[FOR_BODY5]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nsw i16 [[I_04]], 100
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i16 [[J_02]], [[MUL]]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, i8 addrspace(2)* [[X]], i16 [[ADD]]
; CHECK-NEXT:    [[INC]] = add nsw i16 [[J_02]], 1
; CHECK-NEXT:    [[CMP4:%.*]] = icmp eq i16 [[INC]], 100
; CHECK-NEXT:    br i1 [[CMP4]], label [[FOR_INC10]], label [[FOR_BODY5]]
; CHECK:       for.inc10:
; CHECK-NEXT:    [[INC12]] = add nsw i16 [[I_04]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[INC12]], 100
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_END13:%.*]], label [[BB_NPH]]
; CHECK:       for.end13:
; CHECK-NEXT:    ret void
;

entry:
  br label %bb.nph

bb.nph:                                           ; preds = %entry, %for.inc10
  %i.04 = phi i16 [ 0, %entry ], [ %inc12, %for.inc10 ]
  br label %for.body5

for.body5:                                        ; preds = %for.body5, %bb.nph
  %j.02 = phi i16 [ 0, %bb.nph ], [ %inc, %for.body5 ]
  %mul = mul nsw i16 %i.04, 100
  %add = add nsw i16 %j.02, %mul
  %arrayidx = getelementptr inbounds i8, i8 addrspace(2)* %X, i16 %add
  store i8 0, i8 addrspace(2)* %arrayidx, align 1
  %inc = add nsw i16 %j.02, 1
  %cmp4 = icmp eq i16 %inc, 100
  br i1 %cmp4, label %for.inc10, label %for.body5

for.inc10:                                        ; preds = %for.body5
  %inc12 = add nsw i16 %i.04, 1
  %cmp = icmp eq i16 %inc12, 100
  br i1 %cmp, label %for.end13, label %bb.nph

for.end13:                                        ; preds = %for.inc10
  ret void
}

define void @test11_pattern(i32 addrspace(2)* nocapture %P) nounwind ssp {
; CHECK-LABEL: @test11_pattern(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr i32, i32 addrspace(2)* [[P:%.*]], i64 [[INDVAR]]
; CHECK-NEXT:    store i32 1, i32 addrspace(2)* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], 10000
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvar = phi i64 [ 0, %entry ], [ %indvar.next, %for.body ]
  %arrayidx = getelementptr i32, i32 addrspace(2)* %P, i64 %indvar
  store i32 1, i32 addrspace(2)* %arrayidx, align 4
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, 10000
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

; PR9815 - This is a partial overlap case that cannot be safely transformed
; into a memcpy.
@g_50 = addrspace(2) global [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 1, i32 0, i32 0], align 16


define i32 @test14() nounwind {
; CHECK-LABEL: @test14(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[TMP5:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP5]], 4
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[ADD]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [7 x i32], [7 x i32] addrspace(2)* @g_50, i32 0, i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32 addrspace(2)* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ADD4:%.*]] = add nsw i32 [[TMP5]], 5
; CHECK-NEXT:    [[IDXPROM5:%.*]] = sext i32 [[ADD4]] to i64
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds [7 x i32], [7 x i32] addrspace(2)* @g_50, i32 0, i64 [[IDXPROM5]]
; CHECK-NEXT:    store i32 [[TMP2]], i32 addrspace(2)* [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[TMP5]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], 2
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32 addrspace(2)* getelementptr inbounds ([7 x i32], [7 x i32] addrspace(2)* @g_50, i32 0, i64 6), align 4
; CHECK-NEXT:    ret i32 [[TMP8]]
;

entry:
  br label %for.body

for.body:                                         ; preds = %for.inc, %for.body.lr.ph
  %tmp5 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %add = add nsw i32 %tmp5, 4
  %idxprom = sext i32 %add to i64
  %arrayidx = getelementptr inbounds [7 x i32], [7 x i32] addrspace(2)* @g_50, i32 0, i64 %idxprom
  %tmp2 = load i32, i32 addrspace(2)* %arrayidx, align 4
  %add4 = add nsw i32 %tmp5, 5
  %idxprom5 = sext i32 %add4 to i64
  %arrayidx6 = getelementptr inbounds [7 x i32], [7 x i32] addrspace(2)* @g_50, i32 0, i64 %idxprom5
  store i32 %tmp2, i32 addrspace(2)* %arrayidx6, align 4
  %inc = add nsw i32 %tmp5, 1
  %cmp = icmp slt i32 %inc, 2
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.inc
  %tmp8 = load i32, i32 addrspace(2)* getelementptr inbounds ([7 x i32], [7 x i32] addrspace(2)* @g_50, i32 0, i64 6), align 4
  ret i32 %tmp8
}

