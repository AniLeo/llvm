; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine -instcombine-infinite-loop-threshold=2 < %s | FileCheck %s

; This used to cause on infinite instcombine loop.

define void @test(i1 %c) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  bb16:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB17:%.*]], label [[BB24:%.*]]
; CHECK:       bb17:
; CHECK-NEXT:    [[TMP0:%.*]] = phi i8* [ [[TMP1:%.*]], [[BB47:%.*]] ], [ undef, [[BB16:%.*]] ]
; CHECK-NEXT:    store i8* [[TMP0]], i8** undef, align 8
; CHECK-NEXT:    ret void
; CHECK:       bb24:
; CHECK-NEXT:    br i1 [[C]], label [[BB44:%.*]], label [[BB49:%.*]]
; CHECK:       bb44:
; CHECK-NEXT:    [[TMP467:%.*]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb47:
; CHECK-NEXT:    [[TMP1]] = phi i8* [ [[TMP2:%.*]], [[BB150:%.*]] ], [ [[TMP1221:%.*]], [[BB119:%.*]] ], [ [[TMP1032:%.*]], [[BB101:%.*]] ], [ [[TMP933:%.*]], [[BB91:%.*]] ], [ [[TMP834:%.*]], [[BB81:%.*]] ], [ [[TMP705:%.*]], [[BB67:%.*]] ], [ [[TMP586:%.*]], [[BB56:%.*]] ], [ [[TMP467]], [[BB44]] ]
; CHECK-NEXT:    br label [[BB17]]
; CHECK:       bb49:
; CHECK-NEXT:    br i1 [[C]], label [[BB56]], label [[BB59:%.*]]
; CHECK:       bb56:
; CHECK-NEXT:    [[TMP586]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb59:
; CHECK-NEXT:    br i1 [[C]], label [[BB67]], label [[BB71:%.*]]
; CHECK:       bb67:
; CHECK-NEXT:    [[TMP705]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb71:
; CHECK-NEXT:    br i1 [[C]], label [[BB81]], label [[BB84:%.*]]
; CHECK:       bb81:
; CHECK-NEXT:    [[TMP834]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb84:
; CHECK-NEXT:    br i1 [[C]], label [[BB91]], label [[BB94:%.*]]
; CHECK:       bb91:
; CHECK-NEXT:    [[TMP933]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb94:
; CHECK-NEXT:    br i1 [[C]], label [[BB101]], label [[BB104:%.*]]
; CHECK:       bb101:
; CHECK-NEXT:    [[TMP1032]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb104:
; CHECK-NEXT:    br i1 [[C]], label [[BB119]], label [[BB123:%.*]]
; CHECK:       bb119:
; CHECK-NEXT:    [[TMP1221]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb123:
; CHECK-NEXT:    br i1 [[C]], label [[BB147:%.*]], label [[BB152:%.*]]
; CHECK:       bb147:
; CHECK-NEXT:    [[TMP1499:%.*]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    br label [[BB150]]
; CHECK:       bb150:
; CHECK-NEXT:    [[TMP2]] = phi i8* [ [[TMP1848:%.*]], [[BB152]] ], [ [[TMP1499]], [[BB147]] ]
; CHECK-NEXT:    br label [[BB47]]
; CHECK:       bb152:
; CHECK-NEXT:    [[TMP1848]] = load i8*, i8** inttoptr (i64 16 to i8**), align 16
; CHECK-NEXT:    store i1 true, i1* undef, align 1
; CHECK-NEXT:    br label [[BB150]]
;
bb16:                                             ; preds = %bb
  br i1 %c, label %bb17, label %bb24

bb17:                                             ; preds = %bb47, %bb17
  %0 = phi i8* [ %1, %bb47 ], [ undef, %bb16 ]
  store i8* %0, i8** undef, align 8
  ret void

bb24:                                             ; preds = %bb24
  br i1 %c, label %bb44, label %bb49

bb44:                                             ; preds = %bb43
  %tmp46 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb47

bb47:                                             ; preds = %bb150, %bb119, %bb101, %bb91, %bb81, %bb67, %bb56, %bb44
  %.in1 = phi i64* [ %.in, %bb150 ], [ %tmp122, %bb119 ], [ %tmp103, %bb101 ], [ %tmp93, %bb91 ], [ %tmp83, %bb81 ], [ %tmp70, %bb67 ], [ %tmp58, %bb56 ], [ %tmp46, %bb44 ]
  %1 = bitcast i64* %.in1 to i8*
  br label %bb17

bb49:                                             ; preds = %bb49
  br i1 %c, label %bb56, label %bb59

bb56:                                             ; preds = %bb55
  %tmp58 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb47

bb59:                                             ; preds = %bb59
  br i1 %c, label %bb67, label %bb71

bb67:                                             ; preds = %bb66
  %tmp70 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb47

bb71:                                             ; preds = %bb71
  br i1 %c, label %bb81, label %bb84

bb81:                                             ; preds = %bb80
  %tmp83 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb47

bb84:                                             ; preds = %bb84
  br i1 %c, label %bb91, label %bb94

bb91:                                             ; preds = %bb90
  %tmp93 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb47

bb94:                                            ; preds = %bb94
  br i1 %c, label %bb101, label %bb104

bb101:                                            ; preds = %bb100
  %tmp103 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb47

bb104:                                            ; preds = %bb104
  br i1 %c, label %bb119, label %bb123

bb119:                                            ; preds = %bb118
  %tmp122 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb47

bb123:                                            ; preds = %bb123
  br i1 %c, label %bb147, label %bb152

bb147:                                            ; preds = %bb146
  %tmp149 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  br label %bb150

bb150:                                            ; preds = %bb152, %bb147
  %.in = phi i64* [ %tmp184, %bb152 ], [ %tmp149, %bb147 ]
  br label %bb47

bb152:                                            ; preds = %bb146
  %tmp184 = load i64*, i64** inttoptr (i64 16 to i64**), align 16
  call void undef()
  br label %bb150
}

; This used to cause an instcombine loop when the problem above was
; addressed in a non-robust fashion.

%type_1 = type {}
%type_2 = type {}
%type_3 = type {}

define void @test_2(i1 %c) local_unnamed_addr {
; CHECK-LABEL: @test_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[COND_TRUE133:%.*]], label [[COND_FALSE138:%.*]]
; CHECK:       cond.true133:
; CHECK-NEXT:    br label [[COND_END144:%.*]]
; CHECK:       cond.false138:
; CHECK-NEXT:    store %type_2* poison, %type_2** null, align 536870912
; CHECK-NEXT:    br label [[COND_END144]]
; CHECK:       cond.end144:
; CHECK-NEXT:    br label [[WHILE_COND]]
;
entry:
  br label %while.cond

while.cond:                                       ; preds = %cond.end144, %entry
  %link.0 = phi %type_2* [ undef, %entry ], [ %cond145, %cond.end144 ]
  %os115 = bitcast %type_2* %link.0 to %type_3*
  %ou116 = getelementptr inbounds %type_3, %type_3* %os115, i32 0
  %os1117 = bitcast %type_3* %ou116 to %type_1*
  br label %for.cond

for.cond:                                         ; preds = %while.cond
  br i1 %c, label %cond.true133, label %cond.false138

cond.true133:                                     ; preds = %sw.epilog
  %0 = load %type_2*, %type_2** undef, align 8
  br label %cond.end144

cond.false138:                                    ; preds = %sw.epilog
  %1 = load %type_2*, %type_2** undef, align 8
  br label %cond.end144

cond.end144:                                      ; preds = %cond.false138, %cond.true133
  %cond145 = phi %type_2* [ %0, %cond.true133 ], [ %1, %cond.false138 ]
  br label %while.cond
}
