; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S -o - | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"

define float @func1(float %a, float %b, float %c, i1 %cond) {
; CHECK-LABEL: @func1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[B_PN:%.*]] = phi float [ [[B:%.*]], [[COND_TRUE]] ], [ [[C:%.*]], [[COND_FALSE]] ]
; CHECK-NEXT:    [[E:%.*]] = fsub fast float [[A:%.*]], [[B_PN]]
; CHECK-NEXT:    ret float [[E]]
;
entry:
  br i1 %cond, label %cond.true, label %cond.false

cond.true:
  %sub0 = fsub fast float %a, %b
  br label %cond.end

cond.false:
  %sub1 = fsub fast float %a, %c
  br label %cond.end

; The fast-math flags should always be transfered if possible.
cond.end:
  %e = phi float [ %sub0, %cond.true ], [ %sub1, %cond.false ]
  ret float %e
}

define float @func2(float %a, float %b, float %c, i1 %cond) {
; CHECK-LABEL: @func2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[B_PN:%.*]] = phi float [ [[B:%.*]], [[COND_TRUE]] ], [ [[C:%.*]], [[COND_FALSE]] ]
; CHECK-NEXT:    [[E:%.*]] = fsub float [[A:%.*]], [[B_PN]]
; CHECK-NEXT:    ret float [[E]]
;
entry:
  br i1 %cond, label %cond.true, label %cond.false

cond.true:
  %sub0 = fsub fast float %a, %b
  br label %cond.end

cond.false:
  %sub1 = fsub float %a, %c
  br label %cond.end

; The fast-math flags should always be transfered if possible.
cond.end:
  %e = phi float [ %sub0, %cond.true ], [ %sub1, %cond.false ]
  ret float %e
}

define float @func3(float %a, float %b, float %c, i1 %cond) {
; CHECK-LABEL: @func3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[E_IN:%.*]] = phi float [ [[A:%.*]], [[COND_TRUE]] ], [ [[B:%.*]], [[COND_FALSE]] ]
; CHECK-NEXT:    [[E:%.*]] = fadd fast float [[E_IN]], -2.000000e+00
; CHECK-NEXT:    ret float [[E]]
;
entry:
  br i1 %cond, label %cond.true, label %cond.false

cond.true:
  %sub0 = fsub fast float %a, 2.0
  br label %cond.end

cond.false:
  %sub1 = fsub fast float %b, 2.0
  br label %cond.end

cond.end:
  %e = phi float [ %sub0, %cond.true ], [ %sub1, %cond.false ]
  ret float %e
}

define float @func4(float %a, float %b, float %c, i1 %cond) {
; CHECK-LABEL: @func4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[E_IN:%.*]] = phi float [ [[A:%.*]], [[COND_TRUE]] ], [ [[B:%.*]], [[COND_FALSE]] ]
; CHECK-NEXT:    [[E:%.*]] = fadd float [[E_IN]], -2.000000e+00
; CHECK-NEXT:    ret float [[E]]
;
entry:
  br i1 %cond, label %cond.true, label %cond.false

cond.true:
  %sub0 = fsub fast float %a, 2.0
  br label %cond.end

cond.false:
  %sub1 = fsub float %b, 2.0
  br label %cond.end

cond.end:
  %e = phi float [ %sub0, %cond.true ], [ %sub1, %cond.false ]
  ret float %e
}
