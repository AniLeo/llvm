; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes='lto<O2>' -S | FileCheck %s

target datalayout = "i32:32:32-i64:64:64"
target triple = "x86_64--"

; Verify that the "late" simplifycfg options are set. This should get converted into a lookup table.

define i32 @f(i32 %c) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[C:%.*]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 42, label [[RETURN:%.*]]
; CHECK-NEXT:    i32 43, label [[SW_BB1:%.*]]
; CHECK-NEXT:    i32 44, label [[SW_BB2:%.*]]
; CHECK-NEXT:    i32 45, label [[SW_BB3:%.*]]
; CHECK-NEXT:    i32 46, label [[SW_BB4:%.*]]
; CHECK-NEXT:    i32 47, label [[SW_BB5:%.*]]
; CHECK-NEXT:    i32 48, label [[SW_BB6:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb1:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb2:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb3:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb4:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb5:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb6:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.default:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ 15, [[SW_DEFAULT]] ], [ 1, [[SW_BB6]] ], [ 62, [[SW_BB5]] ], [ 27, [[SW_BB4]] ], [ -1, [[SW_BB3]] ], [ 0, [[SW_BB2]] ], [ 123, [[SW_BB1]] ], [ 55, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  switch i32 %c, label %sw.default [
  i32 42, label %return
  i32 43, label %sw.bb1
  i32 44, label %sw.bb2
  i32 45, label %sw.bb3
  i32 46, label %sw.bb4
  i32 47, label %sw.bb5
  i32 48, label %sw.bb6
  ]

sw.bb1:
  br label %return
sw.bb2:
  br label %return
sw.bb3:
  br label %return
sw.bb4:
  br label %return
sw.bb5:
  br label %return
sw.bb6:
  br label %return
sw.default:
  br label %return
return:
  %r = phi i32 [ 15, %sw.default ], [ 1, %sw.bb6 ], [ 62, %sw.bb5 ], [ 27, %sw.bb4 ], [ -1, %sw.bb3 ], [ 0, %sw.bb2 ], [ 123, %sw.bb1 ], [ 55, %entry ]
  ret i32 %r
}
