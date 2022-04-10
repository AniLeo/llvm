; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -tbaa -licm -S | FileCheck %s
; RUN: opt -aa-pipeline=tbaa,basic-aa -passes='require<aa>,require<targetir>,require<scalar-evolution>,require<opt-remark-emit>,loop-mssa(licm)' -S %s | FileCheck %s
target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

@X = global i32 7   ; <i32*> [#uses=4]

define void @test1(i32 %i) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[X_PROMOTED:%.*]] = load i32, i32* @X, align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[X21:%.*]] = phi i32 [ [[X_PROMOTED]], [[ENTRY:%.*]] ], [ [[X2:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[X2]] = add i32 [[X21]], 1
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[OUT:%.*]], label [[LOOP]]
; CHECK:       Out:
; CHECK-NEXT:    [[X2_LCSSA:%.*]] = phi i32 [ [[X2]], [[LOOP]] ]
; CHECK-NEXT:    store i32 [[X2_LCSSA]], i32* @X, align 4
; CHECK-NEXT:    ret void
;
Entry:
  br label %Loop

Loop:   ; preds = %Loop, %0
  %j = phi i32 [ 0, %Entry ], [ %Next, %Loop ]    ; <i32> [#uses=1]
  %x = load i32, i32* @X   ; <i32> [#uses=1]
  %x2 = add i32 %x, 1   ; <i32> [#uses=1]
  store i32 %x2, i32* @X
  %Next = add i32 %j, 1   ; <i32> [#uses=2]
  %cond = icmp eq i32 %Next, 0    ; <i1> [#uses=1]
  br i1 %cond, label %Out, label %Loop

Out:
  ret void
}

define void @test2(i32 %i) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[DOTPROMOTED:%.*]] = load i32, i32* getelementptr inbounds (i32, i32* @X, i64 1), align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[V1:%.*]] = phi i32 [ [[V:%.*]], [[LOOP]] ], [ [[DOTPROMOTED]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[V]] = add i32 [[V1]], 1
; CHECK-NEXT:    br i1 false, label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       Exit:
; CHECK-NEXT:    [[V_LCSSA:%.*]] = phi i32 [ [[V]], [[LOOP]] ]
; CHECK-NEXT:    store i32 [[V_LCSSA]], i32* getelementptr inbounds (i32, i32* @X, i64 1), align 4
; CHECK-NEXT:    ret void
;
Entry:
  br label %Loop

Loop:   ; preds = %Loop, %0
  %X1 = getelementptr i32, i32* @X, i64 1    ; <i32*> [#uses=1]
  %A = load i32, i32* %X1    ; <i32> [#uses=1]
  %V = add i32 %A, 1    ; <i32> [#uses=1]
  %X2 = getelementptr i32, i32* @X, i64 1    ; <i32*> [#uses=1]
  store i32 %V, i32* %X2
  br i1 false, label %Loop, label %Exit

Exit:   ; preds = %Loop
  ret void
}

define void @test3(i32 %i) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[X:%.*]] = load volatile i32, i32* @X, align 4
; CHECK-NEXT:    [[X2:%.*]] = add i32 [[X]], 1
; CHECK-NEXT:    store i32 [[X2]], i32* @X, align 4
; CHECK-NEXT:    br i1 true, label [[OUT:%.*]], label [[LOOP]]
; CHECK:       Out:
; CHECK-NEXT:    ret void
;
  br label %Loop
Loop:
  ; Should not promote this to a register
  %x = load volatile i32, i32* @X
  %x2 = add i32 %x, 1
  store i32 %x2, i32* @X
  br i1 true, label %Out, label %Loop

Out:    ; preds = %Loop
  ret void
}

; Should not promote this to a register
define void @test3b(i32 %i) {
; CHECK-LABEL: @test3b(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* @X, align 4
; CHECK-NEXT:    [[X2:%.*]] = add i32 [[X]], 1
; CHECK-NEXT:    store volatile i32 [[X2]], i32* @X, align 4
; CHECK-NEXT:    br i1 true, label [[OUT:%.*]], label [[LOOP]]
; CHECK:       Out:
; CHECK-NEXT:    ret void
;
  br label %Loop
Loop:
  %x = load i32, i32* @X
  %x2 = add i32 %x, 1
  store volatile i32 %x2, i32* @X
  br i1 true, label %Out, label %Loop

Out:    ; preds = %Loop
  ret void
}

; PR8041
; Should have promoted 'handle2' accesses.
; Should not have promoted offsetx1 loads.
define void @test4(i8* %x, i8 %n) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[HANDLE1:%.*]] = alloca i8*, align 8
; CHECK-NEXT:    [[HANDLE2:%.*]] = alloca i8*, align 8
; CHECK-NEXT:    store i8* [[X:%.*]], i8** [[HANDLE1]], align 8
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr i8, i8* [[X]], i64 8
; CHECK-NEXT:    [[OFFSETX1:%.*]] = load i8*, i8** [[HANDLE1]], align 8
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    br label [[SUBLOOP:%.*]]
; CHECK:       subloop:
; CHECK-NEXT:    [[NEWOFFSETX21:%.*]] = phi i8* [ [[TMP]], [[LOOP]] ], [ [[NEWOFFSETX2:%.*]], [[SUBLOOP]] ]
; CHECK-NEXT:    [[COUNT:%.*]] = phi i8 [ 0, [[LOOP]] ], [ [[NEXTCOUNT:%.*]], [[SUBLOOP]] ]
; CHECK-NEXT:    store i8 [[N:%.*]], i8* [[NEWOFFSETX21]], align 1
; CHECK-NEXT:    [[NEWOFFSETX2]] = getelementptr i8, i8* [[NEWOFFSETX21]], i64 -1
; CHECK-NEXT:    [[NEXTCOUNT]] = add i8 [[COUNT]], 1
; CHECK-NEXT:    [[INNEREXITCOND:%.*]] = icmp sge i8 [[NEXTCOUNT]], 8
; CHECK-NEXT:    br i1 [[INNEREXITCOND]], label [[INNEREXIT:%.*]], label [[SUBLOOP]]
; CHECK:       innerexit:
; CHECK-NEXT:    [[NEWOFFSETX2_LCSSA:%.*]] = phi i8* [ [[NEWOFFSETX2]], [[SUBLOOP]] ]
; CHECK-NEXT:    [[VAL:%.*]] = load i8, i8* [[OFFSETX1]], align 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8 [[VAL]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[NEWOFFSETX2_LCSSA_LCSSA:%.*]] = phi i8* [ [[NEWOFFSETX2_LCSSA]], [[INNEREXIT]] ]
; CHECK-NEXT:    store i8* [[NEWOFFSETX2_LCSSA_LCSSA]], i8** [[HANDLE2]], align 8
; CHECK-NEXT:    ret void
;
  %handle1 = alloca i8*
  %handle2 = alloca i8*
  store i8* %x, i8** %handle1
  br label %loop

loop:
  %tmp = getelementptr i8, i8* %x, i64 8
  store i8* %tmp, i8** %handle2
  br label %subloop

subloop:
  %count = phi i8 [ 0, %loop ], [ %nextcount, %subloop ]
  %offsetx2 = load i8*, i8** %handle2
  store i8 %n, i8* %offsetx2
  %newoffsetx2 = getelementptr i8, i8* %offsetx2, i64 -1
  store i8* %newoffsetx2, i8** %handle2
  %nextcount = add i8 %count, 1
  %innerexitcond = icmp sge i8 %nextcount, 8
  br i1 %innerexitcond, label %innerexit, label %subloop

innerexit:
  %offsetx1 = load i8*, i8** %handle1
  %val = load i8, i8* %offsetx1
  %cond = icmp eq i8 %val, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}

define void @test5(i32 %i, i32** noalias %P2) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[X_PROMOTED:%.*]] = load i32, i32* @X, align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[X21:%.*]] = phi i32 [ [[X_PROMOTED]], [[ENTRY:%.*]] ], [ [[X2:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[X2]] = add i32 [[X21]], 1
; CHECK-NEXT:    store atomic i32* @X, i32** [[P2:%.*]] monotonic, align 8
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[OUT:%.*]], label [[LOOP]]
; CHECK:       Out:
; CHECK-NEXT:    [[X2_LCSSA:%.*]] = phi i32 [ [[X2]], [[LOOP]] ]
; CHECK-NEXT:    store i32 [[X2_LCSSA]], i32* @X, align 4
; CHECK-NEXT:    ret void
;
Entry:
  br label %Loop

Loop:   ; preds = %Loop, %0
  %j = phi i32 [ 0, %Entry ], [ %Next, %Loop ]    ; <i32> [#uses=1]
  %x = load i32, i32* @X   ; <i32> [#uses=1]
  %x2 = add i32 %x, 1   ; <i32> [#uses=1]
  store i32 %x2, i32* @X

  store atomic i32* @X, i32** %P2 monotonic, align 8

  %Next = add i32 %j, 1   ; <i32> [#uses=2]
  %cond = icmp eq i32 %Next, 0    ; <i1> [#uses=1]
  br i1 %cond, label %Out, label %Loop

Out:
  ret void

}


; PR14753 - Preserve TBAA tags when promoting values in a loop.
define void @test6(i32 %n, float* nocapture %a, i32* %gi) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[GI:%.*]], align 4, !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 0, [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[FOR_BODY_LR_PH:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[GI_PROMOTED:%.*]] = load i32, i32* [[GI]], align 4, !tbaa [[TBAA0]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INC1:%.*]] = phi i32 [ [[GI_PROMOTED]], [[FOR_BODY_LR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[STOREMERGE2:%.*]] = phi i32 [ 0, [[FOR_BODY_LR_PH]] ], [ [[INC]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[IDXPROM:%.*]] = sext i32 [[STOREMERGE2]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    store float 0.000000e+00, float* [[ARRAYIDX]], align 4, !tbaa [[TBAA4:![0-9]+]]
; CHECK-NEXT:    [[INC]] = add nsw i32 [[INC1]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_COND_FOR_END_CRIT_EDGE:%.*]]
; CHECK:       for.cond.for.end_crit_edge:
; CHECK-NEXT:    [[INC_LCSSA:%.*]] = phi i32 [ [[INC]], [[FOR_BODY]] ]
; CHECK-NEXT:    store i32 [[INC_LCSSA]], i32* [[GI]], align 4, !tbaa [[TBAA0]]
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %gi, align 4, !tbaa !0
  %cmp1 = icmp slt i32 0, %n
  br i1 %cmp1, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %storemerge2 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %idxprom = sext i32 %storemerge2 to i64
  %arrayidx = getelementptr inbounds float, float* %a, i64 %idxprom
  store float 0.000000e+00, float* %arrayidx, align 4, !tbaa !3
  %0 = load i32, i32* %gi, align 4, !tbaa !0
  %inc = add nsw i32 %0, 1
  store i32 %inc, i32* %gi, align 4, !tbaa !0
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.body, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.cond.for.end_crit_edge, %entry
  ret void

}

declare i32 @opaque(i32) argmemonly
declare void @capture(i32*)

; We can promote even if opaque may throw.
define i32 @test7() {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @capture(i32* [[LOCAL]])
; CHECK-NEXT:    [[LOCAL_PROMOTED:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[X21:%.*]] = phi i32 [ [[LOCAL_PROMOTED]], [[ENTRY:%.*]] ], [ [[X2:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[X2]] = call i32 @opaque(i32 [[X21]])
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[X2_LCSSA:%.*]] = phi i32 [ [[X2]], [[LOOP]] ]
; CHECK-NEXT:    store i32 [[X2_LCSSA]], i32* [[LOCAL]], align 4
; CHECK-NEXT:    [[RET:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    ret i32 [[RET]]
;
entry:
  %local = alloca i32
  call void @capture(i32* %local)
  br label %loop

loop:
  %j = phi i32 [ 0, %entry ], [ %next, %loop ]
  %x = load i32, i32* %local
  %x2 = call i32 @opaque(i32 %x) ; Note this does not capture %local
  store i32 %x2, i32* %local
  %next = add i32 %j, 1
  %cond = icmp eq i32 %next, 0
  br i1 %cond, label %exit, label %loop

exit:
  %ret = load i32, i32* %local
  ret i32 %ret
}

; Hoist the load even if we cannot sink the store, since the store is really
; control-flow dependent.
define i32 @test7bad() {
; CHECK-LABEL: @test7bad(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @capture(i32* [[LOCAL]])
; CHECK-NEXT:    [[LOCAL_PROMOTED:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[X22:%.*]] = phi i32 [ [[LOCAL_PROMOTED]], [[ENTRY:%.*]] ], [ [[X21:%.*]], [[ELSE:%.*]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[ELSE]] ]
; CHECK-NEXT:    [[X2:%.*]] = call i32 @opaque(i32 [[X22]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X2]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF:%.*]], label [[ELSE]]
; CHECK:       if:
; CHECK-NEXT:    store i32 [[X2]], i32* [[LOCAL]], align 4
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[X21]] = phi i32 [ [[X2]], [[IF]] ], [ [[X22]], [[LOOP]] ]
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RET:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    ret i32 [[RET]]
;
entry:
  %local = alloca i32
  call void @capture(i32* %local)
  br label %loop
loop:
  %j = phi i32 [ 0, %entry ], [ %next, %else ]
  %x = load i32, i32* %local
  %x2 = call i32 @opaque(i32 %x) ; Note this does not capture %local
  %cmp = icmp eq i32 %x2, 0
  br i1 %cmp, label %if, label %else

if:
  store i32 %x2, i32* %local
  br label %else

else:
  %next = add i32 %j, 1
  %cond = icmp eq i32 %next, 0
  br i1 %cond, label %exit, label %loop

exit:
  %ret = load i32, i32* %local
  ret i32 %ret
}

; Even if neither the load nor the store or guaranteed to execute because
; opaque() may throw, we can still promote - the load not being guaranteed
; doesn't block us, because %local is always dereferenceable.
define i32 @test8() {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @capture(i32* [[LOCAL]])
; CHECK-NEXT:    [[LOCAL_PROMOTED:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[X21:%.*]] = phi i32 [ [[LOCAL_PROMOTED]], [[ENTRY:%.*]] ], [ [[X2:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[THROWAWAY:%.*]] = call i32 @opaque(i32 [[J]])
; CHECK-NEXT:    [[X2]] = call i32 @opaque(i32 [[X21]])
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[X2_LCSSA:%.*]] = phi i32 [ [[X2]], [[LOOP]] ]
; CHECK-NEXT:    store i32 [[X2_LCSSA]], i32* [[LOCAL]], align 4
; CHECK-NEXT:    [[RET:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    ret i32 [[RET]]
;
entry:
  %local = alloca i32
  call void @capture(i32* %local)
  br label %loop

loop:
  %j = phi i32 [ 0, %entry ], [ %next, %loop ]
  %throwaway = call i32 @opaque(i32 %j)
  %x = load i32, i32* %local
  %x2 = call i32 @opaque(i32 %x)
  store i32 %x2, i32* %local
  %next = add i32 %j, 1
  %cond = icmp eq i32 %next, 0
  br i1 %cond, label %exit, label %loop

exit:
  %ret = load i32, i32* %local
  ret i32 %ret
}


; If the store is "guaranteed modulo exceptions", and the load depends on
; control flow, we can only promote if the pointer is otherwise known to be
; dereferenceable
define i32 @test9() {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @capture(i32* [[LOCAL]])
; CHECK-NEXT:    [[LOCAL_PROMOTED:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[X21:%.*]] = phi i32 [ [[LOCAL_PROMOTED]], [[ENTRY:%.*]] ], [ [[X2:%.*]], [[ELSE:%.*]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[ELSE]] ]
; CHECK-NEXT:    [[J2:%.*]] = call i32 @opaque(i32 [[J]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[J2]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF:%.*]], label [[ELSE]]
; CHECK:       if:
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[X2]] = phi i32 [ 0, [[LOOP]] ], [ [[X21]], [[IF]] ]
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[X2_LCSSA:%.*]] = phi i32 [ [[X2]], [[ELSE]] ]
; CHECK-NEXT:    store i32 [[X2_LCSSA]], i32* [[LOCAL]], align 4
; CHECK-NEXT:    [[RET:%.*]] = load i32, i32* [[LOCAL]], align 4
; CHECK-NEXT:    ret i32 [[RET]]
;
entry:
  %local = alloca i32
  call void @capture(i32* %local)
  br label %loop

loop:
  %j = phi i32 [ 0, %entry ], [ %next, %else ]
  %j2 = call i32 @opaque(i32 %j)
  %cmp = icmp eq i32 %j2, 0
  br i1 %cmp, label %if, label %else

if:
  %x = load i32, i32* %local
  br label %else

else:
  %x2 = phi i32 [ 0, %loop ], [ %x, %if]
  store i32 %x2, i32* %local
  %next = add i32 %j, 1
  %cond = icmp eq i32 %next, 0
  br i1 %cond, label %exit, label %loop

exit:
  %ret = load i32, i32* %local
  ret i32 %ret
}

define i32 @test9bad(i32 %i) {
; CHECK-LABEL: @test9bad(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @capture(i32* [[LOCAL]])
; CHECK-NEXT:    [[NOTDEREF:%.*]] = getelementptr i32, i32* [[LOCAL]], i32 [[I:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[ELSE:%.*]] ]
; CHECK-NEXT:    [[J2:%.*]] = call i32 @opaque(i32 [[J]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[J2]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF:%.*]], label [[ELSE]]
; CHECK:       if:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[NOTDEREF]], align 4
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[X2:%.*]] = phi i32 [ 0, [[LOOP]] ], [ [[X]], [[IF]] ]
; CHECK-NEXT:    store i32 [[X2]], i32* [[NOTDEREF]], align 4
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RET:%.*]] = load i32, i32* [[NOTDEREF]], align 4
; CHECK-NEXT:    ret i32 [[RET]]
;
entry:
  %local = alloca i32
  call void @capture(i32* %local)
  %notderef = getelementptr i32, i32* %local, i32 %i
  br label %loop

loop:
  %j = phi i32 [ 0, %entry ], [ %next, %else ]
  %j2 = call i32 @opaque(i32 %j)
  %cmp = icmp eq i32 %j2, 0
  br i1 %cmp, label %if, label %else

if:
  %x = load i32, i32* %notderef
  br label %else

else:
  %x2 = phi i32 [ 0, %loop ], [ %x, %if]
  store i32 %x2, i32* %notderef
  %next = add i32 %j, 1
  %cond = icmp eq i32 %next, 0
  br i1 %cond, label %exit, label %loop

exit:
  %ret = load i32, i32* %notderef
  ret i32 %ret
}

define void @test10(i32 %i) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[X_PROMOTED:%.*]] = load atomic i32, i32* @X unordered, align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[X21:%.*]] = phi i32 [ [[X_PROMOTED]], [[ENTRY:%.*]] ], [ [[X2:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[X2]] = add i32 [[X21]], 1
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[OUT:%.*]], label [[LOOP]]
; CHECK:       Out:
; CHECK-NEXT:    [[X2_LCSSA:%.*]] = phi i32 [ [[X2]], [[LOOP]] ]
; CHECK-NEXT:    store atomic i32 [[X2_LCSSA]], i32* @X unordered, align 4
; CHECK-NEXT:    ret void
;
Entry:
  br label %Loop


Loop:   ; preds = %Loop, %0
  %j = phi i32 [ 0, %Entry ], [ %Next, %Loop ]    ; <i32> [#uses=1]
  %x = load atomic i32, i32* @X unordered, align 4
  %x2 = add i32 %x, 1
  store atomic i32 %x2, i32* @X unordered, align 4
  %Next = add i32 %j, 1
  %cond = icmp eq i32 %Next, 0
  br i1 %cond, label %Out, label %Loop

Out:
  ret void

}

; Early exit is known not to be taken on first iteration and thus doesn't
; effect whether load is known to execute.
define void @test11(i32 %i) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[X_PROMOTED:%.*]] = load i32, i32* @X, align 4
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       Loop:
; CHECK-NEXT:    [[X21:%.*]] = phi i32 [ [[X_PROMOTED]], [[ENTRY:%.*]] ], [ [[X2:%.*]], [[BODY:%.*]] ]
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[NEXT:%.*]], [[BODY]] ]
; CHECK-NEXT:    [[EARLY_TEST:%.*]] = icmp ult i32 [[J]], 32
; CHECK-NEXT:    br i1 [[EARLY_TEST]], label [[BODY]], label [[EARLY:%.*]]
; CHECK:       body:
; CHECK-NEXT:    [[X2]] = add i32 [[X21]], 1
; CHECK-NEXT:    [[NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[NEXT]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[OUT:%.*]], label [[LOOP]]
; CHECK:       Early:
; CHECK-NEXT:    [[X21_LCSSA:%.*]] = phi i32 [ [[X21]], [[LOOP]] ]
; CHECK-NEXT:    store i32 [[X21_LCSSA]], i32* @X, align 4
; CHECK-NEXT:    ret void
; CHECK:       Out:
; CHECK-NEXT:    [[X2_LCSSA:%.*]] = phi i32 [ [[X2]], [[BODY]] ]
; CHECK-NEXT:    store i32 [[X2_LCSSA]], i32* @X, align 4
; CHECK-NEXT:    ret void
;
Entry:
  br label %Loop


Loop:   ; preds = %Loop, %0
  %j = phi i32 [ 0, %Entry ], [ %Next, %body ]    ; <i32> [#uses=1]
  %early.test = icmp ult i32 %j, 32
  br i1 %early.test, label %body, label %Early
body:
  %x = load i32, i32* @X   ; <i32> [#uses=1]
  %x2 = add i32 %x, 1   ; <i32> [#uses=1]
  store i32 %x2, i32* @X
  %Next = add i32 %j, 1   ; <i32> [#uses=2]
  %cond = icmp eq i32 %Next, 0    ; <i1> [#uses=1]
  br i1 %cond, label %Out, label %Loop

Early:
  ret void
Out:
  ret void

}

@glb = external global i8, align 1

; Test case for PR51248.
define void @test_sink_store_only(i8 %var, i64 %start) writeonly {
; CHECK-LABEL: @test_sink_store_only(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i8 [[VAR:%.*]], 3
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 [[DIV]], 0
; CHECK-NEXT:    [[GLB_PROMOTED:%.*]] = load i8, i8* @glb, align 1
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[MERGE1:%.*]] = phi i8 [ [[GLB_PROMOTED]], [[ENTRY:%.*]] ], [ [[MERGE:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[LOOP_LATCH]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[I]], 4
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       loop.body:
; CHECK-NEXT:    br i1 [[CMP2]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[MERGE]] = phi i8 [ [[DIV]], [[COND_TRUE]] ], [ 0, [[COND_FALSE]] ]
; CHECK-NEXT:    [[ADD]] = add i64 [[I]], 4
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       for.end:
; CHECK-NEXT:    [[MERGE1_LCSSA:%.*]] = phi i8 [ [[MERGE1]], [[LOOP_HEADER]] ]
; CHECK-NEXT:    store i8 [[MERGE1_LCSSA]], i8* @glb, align 1
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %i = phi i64 [ 0, %entry ], [ %add, %loop.latch ]
  %cmp = icmp ult i64 %i, 4
  br i1 %cmp, label %loop.body, label %for.end

loop.body:
  %div = sdiv i8 %var, 3
  %cmp2 = icmp slt i8 %div, 0
  br i1 %cmp2, label %cond.true, label %cond.false

cond.true:
  br label %loop.latch

cond.false:
  br label %loop.latch

loop.latch:
  %merge = phi i8 [ %div, %cond.true ], [ 0, %cond.false ]
  store i8 %merge, i8* @glb, align 1
  %add = add i64 %i, 4
  br label %loop.header

for.end:
  ret void
}

!0 = !{!4, !4, i64 0}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
!3 = !{!5, !5, i64 0}
!4 = !{!"int", !1}
!5 = !{!"float", !1}
