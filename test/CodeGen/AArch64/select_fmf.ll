; RUN: llc < %s -mtriple=arm64-- -debug-only=isel -o /dev/null 2>&1 | FileCheck %s --check-prefix=FMFDEBUG

; This test provides fmf coverage for DAG combining of selects

; FMFDEBUG-LABEL: Optimized lowered selection DAG: %bb.0 'select_select_fold_select_and:'
; FMFDEBUG:         [[AND:t[0-9]+]]: i1 = and {{t[0-9]+}}, {{t[0-9]+}}
; FMFDEBUG:         [[FMAX:t[0-9]+]]: f32 = fmaxnum nnan ninf nsz arcp contract afn reassoc {{t[0-9]+}}, {{t[0-9]+}}
; FMFDEBUG-NEXT:    select nnan ninf nsz arcp contract afn reassoc [[AND]], [[FMAX]], {{t[0-9]+}}
; FMFDEBUG:       Type-legalized selection DAG: %bb.0 'select_select_fold_select_and:'

; select Cond0, (select Cond1, X, Y), Y -> select (and Cond0, Cond1), X, Y
define float @select_select_fold_select_and(float %w, float %x, float %y, float %z) {
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

; FMFDEBUG-LABEL: Optimized lowered selection DAG: %bb.0 'select_select_fold_select_or:'
; FMFDEBUG:         [[OR:t[0-9]+]]: i1 = or {{t[0-9]+}}, {{t[0-9]+}}
; FMFDEBUG:         [[FMAX:t[0-9]+]]: f32 = fmaxnum nnan ninf nsz arcp contract afn reassoc {{t[0-9]+}}, {{t[0-9]+}}
; FMFDEBUG-NEXT:    select nnan ninf nsz arcp contract afn reassoc [[OR]], {{t[0-9]+}}, [[FMAX]]
; FMFDEBUG:       Type-legalized selection DAG: %bb.0 'select_select_fold_select_or:'

; select Cond0, X, (select Cond1, X, Y) -> select (or Cond0, Cond1), X, Y
define float @select_select_fold_select_or(float %w, float %x, float %y, float %z) {
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
