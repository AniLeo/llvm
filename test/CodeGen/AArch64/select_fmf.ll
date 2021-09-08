; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-- | FileCheck %s

; This test provides fmf coverage for DAG combining of selects

; select Cond0, (select Cond1, X, Y), Y -> select (and Cond0, Cond1), X, Y
define float @select_select_fold_select_and(float %w, float %x, float %y, float %z) {
; CHECK-LABEL: select_select_fold_select_and:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmp s1, s2
; CHECK-NEXT:    fminnm s1, s1, s2
; CHECK-NEXT:    fmaxnm s2, s0, s3
; CHECK-NEXT:    fmov s4, #0.50000000
; CHECK-NEXT:    fccmp s1, s0, #4, lt
; CHECK-NEXT:    fcsel s2, s2, s0, gt
; CHECK-NEXT:    fadd s1, s0, s4
; CHECK-NEXT:    fadd s4, s1, s2
; CHECK-NEXT:    fcmp s4, s1
; CHECK-NEXT:    b.le .LBB0_2
; CHECK-NEXT:  // %bb.1: // %if.then.i157.i.i
; CHECK-NEXT:    fmov s0, #1.00000000
; CHECK-NEXT:    fadd s0, s2, s0
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2: // %if.end.i159.i.i
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    movk w8, #48844, lsl #16
; CHECK-NEXT:    mov w9, #13107
; CHECK-NEXT:    movk w9, #48819, lsl #16
; CHECK-NEXT:    fmov s2, w8
; CHECK-NEXT:    fadd s0, s0, s2
; CHECK-NEXT:    fmov s2, w9
; CHECK-NEXT:    fadd s2, s3, s2
; CHECK-NEXT:    fcmp s1, #0.0
; CHECK-NEXT:    fcsel s0, s0, s2, gt
; CHECK-NEXT:    ret
  %tmp21 = fcmp fast olt float %x, %y
  %tmp22 = select fast i1 %tmp21, float %x, float %y
  %tmp24 = fcmp fast ogt float %tmp22, %w
  %tmp78 = fcmp fast ogt float %w, %z
  %select0 = select fast i1 %tmp78, float %w, float %z
  %select1 = select fast i1 %tmp21, float %select0, float %w
  %select2 = select fast i1 %tmp24, float %select1, float %w
  %tmp82 = fadd fast float %w, 5.000000e-01
  %tmp102 = fadd fast float %tmp82, %select2
  %cmp.i155.i.i = fcmp fast ogt float %tmp102, %tmp82
  br i1 %cmp.i155.i.i, label %if.then.i157.i.i, label %if.end.i159.i.i

if.then.i157.i.i:                                 ; preds = %0
  %add.i156.i.i = fadd fast float %select2, 1.000000e+00
  br label %exit

if.end.i159.i.i:                                  ; preds = %0
  %sub.i158.i.i = fadd fast float %w, 0xBFD99999A0000000
  %sub15.i.i.i = fadd fast float %z, 0xBFD6666660000000
  %tmp191 = fcmp fast ogt float %tmp82, 0.000000e+00
  %select3 = select fast i1 %tmp191, float %sub.i158.i.i, float %sub15.i.i.i
  br label %exit

exit:                                     ; preds = %if.end.i159.i.i, %if.then.i157.i.i
  %phi1 = phi float [ %add.i156.i.i, %if.then.i157.i.i ], [ %select3, %if.end.i159.i.i ]
  ret float %phi1
}

; select Cond0, X, (select Cond1, X, Y) -> select (or Cond0, Cond1), X, Y
define float @select_select_fold_select_or(float %w, float %x, float %y, float %z) {
; CHECK-LABEL: select_select_fold_select_or:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fcmp s1, s2
; CHECK-NEXT:    fminnm s1, s1, s2
; CHECK-NEXT:    fmaxnm s2, s0, s3
; CHECK-NEXT:    fmov s4, #0.50000000
; CHECK-NEXT:    fccmp s1, s0, #0, ge
; CHECK-NEXT:    fcsel s2, s0, s2, gt
; CHECK-NEXT:    fadd s1, s0, s4
; CHECK-NEXT:    fadd s4, s1, s2
; CHECK-NEXT:    fcmp s4, s1
; CHECK-NEXT:    b.le .LBB1_2
; CHECK-NEXT:  // %bb.1: // %if.then.i157.i.i
; CHECK-NEXT:    fmov s0, #1.00000000
; CHECK-NEXT:    fadd s0, s2, s0
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_2: // %if.end.i159.i.i
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    movk w8, #48844, lsl #16
; CHECK-NEXT:    mov w9, #13107
; CHECK-NEXT:    movk w9, #48819, lsl #16
; CHECK-NEXT:    fmov s2, w8
; CHECK-NEXT:    fadd s0, s0, s2
; CHECK-NEXT:    fmov s2, w9
; CHECK-NEXT:    fadd s2, s3, s2
; CHECK-NEXT:    fcmp s1, #0.0
; CHECK-NEXT:    fcsel s0, s0, s2, gt
; CHECK-NEXT:    ret
  %tmp21 = fcmp fast olt float %x, %y
  %tmp22 = select fast i1 %tmp21, float %x, float %y
  %tmp24 = fcmp fast ogt float %tmp22, %w
  %tmp78 = fcmp fast ogt float %w, %z
  %select0 = select fast i1 %tmp78, float %w, float %z
  %select1 = select fast i1 %tmp21, float %w, float %select0
  %select2 = select fast i1 %tmp24, float %w, float %select1
  %tmp82 = fadd fast float %w, 5.000000e-01
  %tmp102 = fadd fast float %tmp82, %select2
  %cmp.i155.i.i = fcmp fast ogt float %tmp102, %tmp82
  br i1 %cmp.i155.i.i, label %if.then.i157.i.i, label %if.end.i159.i.i

if.then.i157.i.i:                                 ; preds = %0
  %add.i156.i.i = fadd fast float %select2, 1.000000e+00
  br label %exit

if.end.i159.i.i:                                  ; preds = %0
  %sub.i158.i.i = fadd fast float %w, 0xBFD99999A0000000
  %sub15.i.i.i = fadd fast float %z, 0xBFD6666660000000
  %tmp191 = fcmp fast ogt float %tmp82, 0.000000e+00
  %select3 = select fast i1 %tmp191, float %sub.i158.i.i, float %sub15.i.i.i
  br label %exit

exit:                                     ; preds = %if.end.i159.i.i, %if.then.i157.i.i
  %phi1 = phi float [ %add.i156.i.i, %if.then.i157.i.i ], [ %select3, %if.end.i159.i.i ]
  ret float %phi1
}
