; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=ipsccp -S | FileCheck %s

; Test for PR39772

%struct.Node = type { %struct.Node*, %struct.Node*, i32 }

define i32 @check(%struct.Node* %node) {
; CHECK-LABEL: define i32 @check(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq %struct.Node* [[NODE:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[CLEANUP:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[LEFT:%.*]] = getelementptr inbounds [[STRUCT_NODE:%.*]], %struct.Node* [[NODE]], i32 0, i32 0
; CHECK-NEXT:    [[TMP0:%.*]] = load %struct.Node*, %struct.Node** [[LEFT]]
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @check(%struct.Node* [[TMP0]])
; CHECK-NEXT:    [[RIGHT:%.*]] = getelementptr inbounds [[STRUCT_NODE]], %struct.Node* [[NODE]], i32 0, i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = load %struct.Node*, %struct.Node** [[RIGHT]]
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @check(%struct.Node* [[TMP1]])
; CHECK-NEXT:    [[TMP2:%.*]] = load %struct.Node*, %struct.Node** [[RIGHT]]
; CHECK-NEXT:    [[HEIGHT:%.*]] = getelementptr inbounds [[STRUCT_NODE]], %struct.Node* [[TMP2]], i32 0, i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[HEIGHT]]
; CHECK-NEXT:    [[CMP3:%.*]] = icmp ne i32 [[TMP3]], [[CALL1]]
; CHECK-NEXT:    br i1 [[CMP3]], label [[IF_THEN4:%.*]], label [[IF_END5:%.*]]
; CHECK:       if.then4:
; CHECK-NEXT:    unreachable
; CHECK:       if.end5:
; CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[CALL]], [[CALL1]]
; CHECK-NEXT:    br i1 [[CMP6]], label [[IF_THEN7:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then7:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[CALL]], 1
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       if.else:
; CHECK-NEXT:    [[ADD8:%.*]] = add nsw i32 [[CALL1]], 1
; CHECK-NEXT:    br label [[CLEANUP]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ 0, [[IF_THEN]] ], [ [[ADD]], [[IF_THEN7]] ], [ [[ADD8]], [[IF_ELSE]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_0]]
;
entry:
  %cmp = icmp eq %struct.Node* %node, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %left = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 0
  %0 = load %struct.Node*, %struct.Node** %left
  %call = call i32 @check(%struct.Node* %0)
  %right = getelementptr inbounds %struct.Node, %struct.Node* %node, i32 0, i32 1
  %1 = load %struct.Node*, %struct.Node** %right
  %call1 = call i32 @check(%struct.Node* %1)
  %2 = load %struct.Node*, %struct.Node** %right
  %height = getelementptr inbounds %struct.Node, %struct.Node* %2, i32 0, i32 2
  %3 = load i32, i32* %height
  %cmp3 = icmp ne i32 %3, %call1
  br i1 %cmp3, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  unreachable

if.end5:                                          ; preds = %if.end
  %cmp6 = icmp sgt i32 %call, %call1
  br i1 %cmp6, label %if.then7, label %if.else

if.then7:                                         ; preds = %if.end5
  %add = add nsw i32 %call, 1
  br label %cleanup

if.else:                                          ; preds = %if.end5
  %add8 = add nsw i32 %call1, 1
  br label %cleanup

cleanup:                                          ; preds = %if.else, %if.then7, %if.then
  %retval.0 = phi i32 [ 0, %if.then ], [ %add, %if.then7 ], [ %add8, %if.else ]
  ret i32 %retval.0
}

declare i8* @test2_callee(i32, i32)

define void @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br label [[IF_ELSE33:%.*]]
; CHECK:       if.else33:
; CHECK-NEXT:    br label [[IF_THEN38:%.*]]
; CHECK:       if.then38:
; CHECK-NEXT:    [[CALL42:%.*]] = call i8* @test2_callee(i32 0, i32 0)
; CHECK-NEXT:    unreachable
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc46, %entry
  %op.0 = phi i32 [ 0, %entry ], [ 0, %for.inc46 ]
  br label %for.body

for.body:                                         ; preds = %for.cond
  %cmp24 = icmp eq i32 %op.0, 38
  br i1 %cmp24, label %if.then26, label %if.else33

if.then26:                                        ; preds = %for.body
  unreachable

if.else33:                                        ; preds = %for.body
  %cmp34 = icmp ne i32 %op.0, 80
  %cmp36 = icmp ne i32 %op.0, 81
  %or.cond = and i1 %cmp34, %cmp36
  br i1 %or.cond, label %if.then38, label %for.inc46

if.then38:                                        ; preds = %if.else33
  %call42 = call i8* @test2_callee(i32 %op.0, i32 0)
  unreachable

for.inc46:                                        ; preds = %if.else33
  br label %for.cond
}
