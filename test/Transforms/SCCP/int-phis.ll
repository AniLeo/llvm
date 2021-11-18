; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sccp -S | FileCheck %s

declare void @use(i1)

define void @read_dmatrix() #0 {
; CHECK-LABEL: @read_dmatrix(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[HEIGHT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[HEIGHT]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 0, [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_COND6:%.*]], label [[FOR_END16:%.*]]
; CHECK:       for.cond6:
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end16:
; CHECK-NEXT:    ret void
;
entry:
  %height = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.cond6, %entry
  %j.0 = phi i32 [ undef, %entry ], [ 0, %for.cond6 ]
  %0 = load i32, i32* %height, align 4
  %cmp = icmp slt i32 0, %0
  br i1 %cmp, label %for.cond6, label %for.end16

for.cond6:                                        ; preds = %for.cond
  br label %for.cond

for.end16:                                        ; preds = %for.cond
  %sub21 = sub nsw i32 %j.0, 1
  ret void
}

declare i1 @cond()

define void @emptyTT() #0 {
; CHECK-LABEL: @emptyTT(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[C:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C]], label [[FOR_COND]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.cond, %entry
  %.compoundliteral.sroa.0.0 = phi i64 [ undef, %entry ], [ 0, %for.cond ]
  %bf.clear = and i64 %.compoundliteral.sroa.0.0, -67108864
  %c = call i1 @cond()
  br i1 %c, label %for.cond, label %exit

exit:
  ret void
}
