; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -ipsccp < %s | FileCheck %s

; Test that information about the true/false value of conditions themselves
; is also used, not information implied by comparisions.

define i32 @switch(i32 %x) {
; CHECK-LABEL: @switch(
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[CASE_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[CASE_0:%.*]]
; CHECK-NEXT:    i32 2, label [[CASE_2:%.*]]
; CHECK-NEXT:    ]
; CHECK:       case.0:
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[X]], 1
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       case.2:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[X]], 1
; CHECK-NEXT:    br label [[END]]
; CHECK:       case.default:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[ADD]], [[CASE_0]] ], [ [[SUB]], [[CASE_2]] ], [ 1, [[CASE_DEFAULT]] ]
; CHECK-NEXT:    ret i32 [[PHI]]
;
  switch i32 %x, label %case.default [
  i32 0, label %case.0
  i32 2, label %case.2
  ]

case.0:
  %add = add i32 %x, 1
  br label %end

case.2:
  %sub = sub i32 %x, 1
  br label %end

case.default:
  br label %end

end:
  %phi = phi i32 [ %add, %case.0 ], [ %sub, %case.2 ], [ 1, %case.default]
  ret i32 %phi
}

define i1 @assume(i32 %x) {
; CHECK-LABEL: @assume(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp sge i32 %x, 0
  call void @llvm.assume(i1 %cmp)
  ret i1 %cmp
}

define i32 @branch(i32 %x) {
; CHECK-LABEL: @branch(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN1:%.*]], label [[IF_THEN2:%.*]]
; CHECK:       if.then1:
; CHECK-NEXT:    br i1 [[CMP]], label [[IF2_THEN1:%.*]], label [[IF2_THEN2:%.*]]
; CHECK:       if2.then1:
; CHECK-NEXT:    br label [[IF2_END:%.*]]
; CHECK:       if2.then2:
; CHECK-NEXT:    br label [[IF2_END]]
; CHECK:       if2.end:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ 0, [[IF2_THEN1]] ], [ 1, [[IF2_THEN2]] ]
; CHECK-NEXT:    ret i32 [[PHI]]
; CHECK:       if.then2:
; CHECK-NEXT:    br i1 [[CMP]], label [[IF3_THEN1:%.*]], label [[IF3_THEN2:%.*]]
; CHECK:       if3.then1:
; CHECK-NEXT:    br label [[IF3_END:%.*]]
; CHECK:       if3.then2:
; CHECK-NEXT:    br label [[IF3_END]]
; CHECK:       if3.end:
; CHECK-NEXT:    [[PHI2:%.*]] = phi i32 [ 0, [[IF3_THEN1]] ], [ 1, [[IF3_THEN2]] ]
; CHECK-NEXT:    ret i32 [[PHI2]]
;
  %cmp = icmp sge i32 %x, 0
  br i1 %cmp, label %if.then1, label %if.then2

if.then1:
  br i1 %cmp, label %if2.then1, label %if2.then2

if2.then1:
  br label %if2.end

if2.then2:
  br label %if2.end

if2.end:
  %phi = phi i32 [ 0, %if2.then1 ], [ 1, %if2.then2 ]
  ret i32 %phi

if.then2:
  br i1 %cmp, label %if3.then1, label %if3.then2

if3.then1:
  br label %if3.end

if3.then2:
  br label %if3.end

if3.end:
  %phi2 = phi i32 [ 0, %if3.then1 ], [ 1, %if3.then2 ]
  ret i32 %phi2
}

declare void @llvm.assume(i1)
