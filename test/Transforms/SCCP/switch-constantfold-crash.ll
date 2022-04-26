; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: opt -passes=ipsccp < %s -S | FileCheck --check-prefixes=CHECK,ONCE %s
; RUN: opt -passes='ipsccp,ipsccp' < %s -S | FileCheck --check-prefixes=CHECK,TWICE %s

define void @barney() {
; CHECK-LABEL: define {{[^@]+}}@barney() {
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB9:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    unreachable
; CHECK:       bb9:
; CHECK-NEXT:    br label [[BB6:%.*]]
;
bb:
  br label %bb9

bb6:                                              ; preds = %bb9
  unreachable

bb7:                                              ; preds = %bb9
  unreachable

bb9:                                              ; preds = %bb
  switch i16 0, label %bb6 [
  i16 61, label %bb7
  ]
}

define void @blam() {
; CHECK-LABEL: define {{[^@]+}}@blam() {
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB16:%.*]]
; CHECK:       bb16:
; CHECK-NEXT:    br label [[BB38:%.*]]
; CHECK:       bb38:
; CHECK-NEXT:    unreachable
;
bb:
  br label %bb16

bb16:                                             ; preds = %bb
  switch i32 0, label %bb38 [
  i32 66, label %bb17
  i32 63, label %bb18
  i32 86, label %bb19
  ]

bb17:                                             ; preds = %bb16
  unreachable

bb18:                                             ; preds = %bb16
  unreachable

bb19:                                             ; preds = %bb16
  unreachable

bb38:                                             ; preds = %bb16
  unreachable
}


define void @hoge() {
; CHECK-LABEL: define {{[^@]+}}@hoge() {
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    unreachable
;
bb:
  switch i16 undef, label %bb1 [
  i16 135, label %bb2
  i16 66, label %bb2
  ]

bb1:                                              ; preds = %bb
  ret void

bb2:                                              ; preds = %bb, %bb
  switch i16 0, label %bb3 [
  i16 61, label %bb4
  i16 54, label %bb4
  i16 49, label %bb4
  ]

bb3:                                              ; preds = %bb2
  unreachable

bb4:                                              ; preds = %bb2, %bb2, %bb2
  unreachable
}

; Test case from PR49573. %default.bb is unfeasible. Make sure it gets replaced
; by an unreachable block.
define void @pr49573_main() {
; ONCE-LABEL: define {{[^@]+}}@pr49573_main() {
; ONCE-NEXT:  entry:
; ONCE-NEXT:    [[TGT:%.*]] = call i16 @pr49573_fn()
; ONCE-NEXT:    switch i16 2, label [[DEFAULT_UNREACHABLE:%.*]] [
; ONCE-NEXT:    i16 0, label [[CASE_0:%.*]]
; ONCE-NEXT:    i16 2, label [[CASE_2:%.*]]
; ONCE-NEXT:    ]
; ONCE:       case.0:
; ONCE-NEXT:    unreachable
; ONCE:       default.unreachable:
; ONCE-NEXT:    unreachable
; ONCE:       case.2:
; ONCE-NEXT:    br label [[NEXT:%.*]]
; ONCE:       next:
; ONCE-NEXT:    [[TGT_2:%.*]] = call i16 @pr49573_fn_2()
; ONCE-NEXT:    switch i16 2, label [[DEFAULT_UNREACHABLE]] [
; ONCE-NEXT:    i16 0, label [[CASE_0]]
; ONCE-NEXT:    i16 2, label [[CASE_2]]
; ONCE-NEXT:    ]
;
; TWICE-LABEL: define {{[^@]+}}@pr49573_main() {
; TWICE-NEXT:  entry:
; TWICE-NEXT:    [[TGT:%.*]] = call i16 @pr49573_fn()
; TWICE-NEXT:    br label [[CASE_2:%.*]]
; TWICE:       case.2:
; TWICE-NEXT:    br label [[NEXT:%.*]]
; TWICE:       next:
; TWICE-NEXT:    [[TGT_2:%.*]] = call i16 @pr49573_fn_2()
; TWICE-NEXT:    br label [[CASE_2]]
;
entry:
  %tgt = call i16 @pr49573_fn()
  switch i16 %tgt, label %default.bb [
  i16 0, label %case.0
  i16 1, label %case.1
  i16 2, label %case.2
  ]

case.0:
  unreachable

default.bb:
  ret void

case.1:
  ret void

case.2:
  br label %next

next:
  %tgt.2 = call i16 @pr49573_fn_2()
  switch i16 %tgt.2, label %default.bb [
  i16 0, label %case.0
  i16 2, label %case.2
  ]
}

; Make sure a new unreachable BB is created.
define void @pr49573_main_2() {
; ONCE-LABEL: define {{[^@]+}}@pr49573_main_2() {
; ONCE-NEXT:  entry:
; ONCE-NEXT:    [[TGT:%.*]] = call i16 @pr49573_fn()
; ONCE-NEXT:    switch i16 2, label [[DEFAULT_UNREACHABLE:%.*]] [
; ONCE-NEXT:    i16 0, label [[CASE_0:%.*]]
; ONCE-NEXT:    i16 2, label [[CASE_2:%.*]]
; ONCE-NEXT:    ]
; ONCE:       case.0:
; ONCE-NEXT:    unreachable
; ONCE:       default.unreachable:
; ONCE-NEXT:    unreachable
; ONCE:       case.2:
; ONCE-NEXT:    ret void
;
; TWICE-LABEL: define {{[^@]+}}@pr49573_main_2() {
; TWICE-NEXT:  entry:
; TWICE-NEXT:    [[TGT:%.*]] = call i16 @pr49573_fn()
; TWICE-NEXT:    br label [[CASE_2:%.*]]
; TWICE:       case.2:
; TWICE-NEXT:    ret void
;
entry:
  %tgt = call i16 @pr49573_fn()
  switch i16 %tgt, label %default.bb [
  i16 0, label %case.0
  i16 1, label %case.1
  i16 2, label %case.2
  ]

case.0:
  unreachable

default.bb:
  ret void

case.1:
  ret void

case.2:
  ret void
}

define internal i16 @pr49573_fn() {
; CHECK-LABEL: define {{[^@]+}}@pr49573_fn() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    ret i16 undef
;
entry:
  br i1 undef, label %then, label %else

then:
  ret i16 0

else:
  ret i16 2
}

define internal i16 @pr49573_fn_2() {
; CHECK-LABEL: define {{[^@]+}}@pr49573_fn_2() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    ret i16 undef
;
entry:
  br i1 undef, label %then, label %else

then:
  ret i16 0

else:
  ret i16 2
}
