; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

; The system for the function below grows quite large. Check to make sure
; we can handle that scenario.
define void @test(i64 %x, i8* %y, i8* %z, i8* %w) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds i8, i8* [[Y:%.*]], i64 [[X:%.*]]
; CHECK-NEXT:    [[TMP26:%.*]] = icmp ult i8* [[TMP22]], [[Z:%.*]]
; CHECK-NEXT:    br i1 [[TMP26]], label [[BB28:%.*]], label [[EARLY_EXIT:%.*]]
; CHECK:       early.exit:
; CHECK-NEXT:    unreachable
; CHECK:       bb28:
; CHECK-NEXT:    [[TMP29:%.*]] = getelementptr inbounds i8, i8* [[Y]], i64 [[X]]
; CHECK-NEXT:    [[TMP30:%.*]] = icmp ult i8* [[TMP29]], [[Z]]
; CHECK-NEXT:    br i1 true, label [[EARLY_EXIT]], label [[BB32:%.*]]
; CHECK:       bb32:
; CHECK-NEXT:    [[TMP33:%.*]] = icmp ult i8* [[TMP29]], [[Z]]
; CHECK-NEXT:    br i1 true, label [[BB35:%.*]], label [[EARLY_EXIT]]
; CHECK:       bb35:
; CHECK-NEXT:    [[TMP36:%.*]] = icmp ult i8* [[Y]], [[Z]]
; CHECK-NEXT:    br i1 true, label [[EARLY_EXIT]], label [[BB38:%.*]]
; CHECK:       bb38:
; CHECK-NEXT:    [[TMP41:%.*]] = icmp ult i8* [[Y]], [[Z]]
; CHECK-NEXT:    br i1 true, label [[EARLY_EXIT]], label [[BB43:%.*]]
; CHECK:       bb43:
; CHECK-NEXT:    [[TMP47:%.*]] = getelementptr inbounds i8, i8* [[W:%.*]], i64 [[X]]
; CHECK-NEXT:    [[TMP48:%.*]] = icmp ult i8* [[TMP47]], [[Y]]
; CHECK-NEXT:    br i1 [[TMP48]], label [[EARLY_EXIT]], label [[BB50:%.*]]
; CHECK:       bb50:
; CHECK-NEXT:    [[TMP52:%.*]] = getelementptr inbounds i8, i8* [[W]], i64 [[X]]
; CHECK-NEXT:    [[TMP53:%.*]] = icmp ult i8* [[TMP52]], [[Y]]
; CHECK-NEXT:    br i1 true, label [[EARLY_EXIT]], label [[BB55:%.*]]
; CHECK:       bb55:
; CHECK-NEXT:    [[TMP57:%.*]] = icmp ult i8* [[W]], [[Y]]
; CHECK-NEXT:    br i1 true, label [[BB59:%.*]], label [[EARLY_EXIT]]
; CHECK:       bb59:
; CHECK-NEXT:    [[TMP60:%.*]] = icmp ult i8* [[W]], [[Y]]
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
;
  %tmp22 = getelementptr inbounds i8, i8* %y, i64 %x
  %tmp26 = icmp ult i8* %tmp22, %z
  br i1 %tmp26, label %bb28, label %early.exit

early.exit:
  unreachable

bb28:
  %tmp29 = getelementptr inbounds i8, i8* %y, i64 %x
  %tmp30 = icmp ult i8* %tmp29, %z
  br i1 %tmp30, label %early.exit, label %bb32

bb32:
  %tmp33 = icmp ult i8* %tmp29, %z
  br i1 %tmp33, label %bb35, label %early.exit

bb35:
  %tmp36 = icmp ult i8* %y, %z
  br i1 %tmp36, label %early.exit, label %bb38

bb38:
  %tmp41 = icmp ult i8* %y, %z
  br i1 %tmp41, label %early.exit, label %bb43

bb43:
  %tmp47 = getelementptr inbounds i8, i8* %w, i64 %x
  %tmp48 = icmp ult i8* %tmp47, %y
  br i1 %tmp48, label %early.exit, label %bb50

bb50:
  %tmp52 = getelementptr inbounds i8, i8* %w, i64 %x
  %tmp53 = icmp ult i8* %tmp52, %y
  br i1 %tmp53, label %early.exit, label %bb55

bb55:
  %tmp57 = icmp ult i8* %w, %y
  br i1 %tmp57, label %bb59, label %early.exit

bb59:
  %tmp60 = icmp ult i8* %w, %y
  call void @use(i1 %tmp60)
  ret void
}

declare void @use(i1)
