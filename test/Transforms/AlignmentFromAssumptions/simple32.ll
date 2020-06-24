; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-n32-S64"
; RUN: opt < %s -alignment-from-assumptions -S | FileCheck %s
; RUN: opt < %s -passes=alignment-from-assumptions -S | FileCheck %s

define i32 @foo(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 32
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  %0 = load i32, i32* %a, align 4
  ret i32 %0

}

define i32 @foo2(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@foo2
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32, i64 24) ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 2
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 16
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32, i64 24)]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 2
  %0 = load i32, i32* %arrayidx, align 4
  ret i32 %0

}

define i32 @foo2a(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@foo2a
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32, i64 28) ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 -1
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 32
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32, i64 28)]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 -1
  %0 = load i32, i32* %arrayidx, align 4
  ret i32 %0

}

define i32 @goo(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@goo
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 32
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  %0 = load i32, i32* %a, align 4
  ret i32 %0

}

define i32 @hoo(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@hoo
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[R_06:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 32
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[TMP0]], [[R_06]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 8
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP1]], 2048
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD]], [[FOR_BODY]] ]
; CHECK-NEXT:    ret i32 [[ADD_LCSSA]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %r.06 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %r.06
  %indvars.iv.next = add i64 %indvars.iv, 8
  %1 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %1, 2048
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %add.lcssa = phi i32 [ %add, %for.body ]
  ret i32 %add.lcssa

}

define i32 @joo(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@joo
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 4, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[R_06:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 16
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[TMP0]], [[R_06]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 8
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP1]], 2048
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD]], [[FOR_BODY]] ]
; CHECK-NEXT:    ret i32 [[ADD_LCSSA]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 4, %entry ], [ %indvars.iv.next, %for.body ]
  %r.06 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %r.06
  %indvars.iv.next = add i64 %indvars.iv, 8
  %1 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %1, 2048
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %add.lcssa = phi i32 [ %add, %for.body ]
  ret i32 %add.lcssa

}

define i32 @koo(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@koo
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[R_06:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 16
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[TMP0]], [[R_06]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 4
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP1]], 2048
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD]], [[FOR_BODY]] ]
; CHECK-NEXT:    ret i32 [[ADD_LCSSA]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %r.06 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %r.06
  %indvars.iv.next = add i64 %indvars.iv, 4
  %1 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %1, 2048
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %add.lcssa = phi i32 [ %add, %for.body ]
  ret i32 %add.lcssa

}

define i32 @koo2(i32* nocapture %a) nounwind uwtable readonly {
; CHECK-LABEL: define {{[^@]+}}@koo2
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #0
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ -4, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[R_06:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]], align 16
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[TMP0]], [[R_06]]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add i64 [[INDVARS_IV]], 4
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP1]], 2048
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD]], [[FOR_BODY]] ]
; CHECK-NEXT:    ret i32 [[ADD_LCSSA]]
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %indvars.iv = phi i64 [ -4, %entry ], [ %indvars.iv.next, %for.body ]
  %r.06 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %r.06
  %indvars.iv.next = add i64 %indvars.iv, 4
  %1 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %1, 2048
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %add.lcssa = phi i32 [ %add, %for.body ]
  ret i32 %add.lcssa

}

define i32 @moo(i32* nocapture %a) nounwind uwtable {
; CHECK-LABEL: define {{[^@]+}}@moo
; CHECK-SAME: (i32* nocapture [[A:%.*]]) #1
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* align 32 [[TMP0]], i8 0, i64 64, i1 false)
; CHECK-NEXT:    ret i32 undef
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  %0 = bitcast i32* %a to i8*
  tail call void @llvm.memset.p0i8.i64(i8* align 4 %0, i8 0, i64 64, i1 false)
  ret i32 undef

}

define i32 @moo2(i32* nocapture %a, i32* nocapture %b) nounwind uwtable {
; CHECK-LABEL: define {{[^@]+}}@moo2
; CHECK-SAME: (i32* nocapture [[A:%.*]], i32* nocapture [[B:%.*]]) #1
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[A]], i64 32) ]
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[B]], i64 128) ]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[B]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 32 [[TMP0]], i8* align 128 [[TMP1]], i64 64, i1 false)
; CHECK-NEXT:    ret i32 undef
;
entry:
  call void @llvm.assume(i1 true) ["align"(i32* %a, i64 32)]
  call void @llvm.assume(i1 true) ["align"(i32* %b, i64 128)]
  %0 = bitcast i32* %a to i8*
  %1 = bitcast i32* %b to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %0, i8* align 4 %1, i64 64, i1 false)
  ret i32 undef

}

declare void @llvm.assume(i1) nounwind

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind

