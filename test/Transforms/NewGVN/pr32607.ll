; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -newgvn %s -S -o - | FileCheck %s
define hidden void @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  top:
; CHECK-NEXT:    br label [[IF:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br i1 false, label [[L50:%.*]], label [[IF]]
; CHECK:       L50:
; CHECK-NEXT:    store i8 poison, i8* null
; CHECK-NEXT:    ret void
;
top:
  %.promoted = load double, double* undef, align 8
  br label %if

;; This is really a multi-valued phi, because the phi is defined by an expression of the phi.
;; This means that we can't propagate the value over the backedge, because we'll just cycle
;; through every value.

if:                                               ; preds = %if, %top
  %0 = phi double [ %1, %if ], [ %.promoted, %top ]
  %1 = fadd double %0, 1.0
  br i1 false, label %L50, label %if

L50:                                              ; preds = %if
  %.lcssa = phi double [ %1, %if ]
  store double %.lcssa, double* undef, align 8
  ret void
}

