; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer -mtriple=x86_64-unknown-linux-gnu -slp-threshold=-1000 < %s | FileCheck %s

define i32 @main(i32 %0) {
; CHECK-LABEL: @main(
; CHECK-NEXT:  for.cond.preheader:
; CHECK-NEXT:    br i1 false, label [[FOR_END:%.*]], label [[FOR_INC_PREHEADER:%.*]]
; CHECK:       for.inc.preheader:
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 poison, i32 poison>, i32 [[TMP0:%.*]], i32 6
; CHECK-NEXT:    br i1 false, label [[FOR_END]], label [[L1_PREHEADER:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[DOTPR:%.*]] = phi i32 [ 0, [[FOR_INC_PREHEADER]] ], [ 0, [[FOR_COND_PREHEADER:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> poison, i32 [[DOTPR]], i32 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <8 x i32> [[TMP2]], <8 x i32> poison, <8 x i32> <i32 undef, i32 undef, i32 undef, i32 0, i32 0, i32 0, i32 0, i32 0>
; CHECK-NEXT:    br label [[L1_PREHEADER]]
; CHECK:       L1.preheader:
; CHECK-NEXT:    [[TMP3:%.*]] = phi <8 x i32> [ [[SHUFFLE]], [[FOR_END]] ], [ [[TMP1]], [[FOR_INC_PREHEADER]] ]
; CHECK-NEXT:    ret i32 0
;
for.cond.preheader:
  br i1 false, label %for.end, label %for.inc.preheader

for.inc.preheader:
  br i1 false, label %for.end, label %L1.preheader

for.end:
  %.pr = phi i32 [ 0, %for.inc.preheader ], [ 0, %for.cond.preheader ]
  br label %L1.preheader

L1.preheader:
  %1 = phi i32 [ %.pr, %for.end ], [ %0, %for.inc.preheader ]
  %2 = phi i32 [ %.pr, %for.end ], [ 0, %for.inc.preheader ]
  %3 = phi i32 [ %.pr, %for.end ], [ 0, %for.inc.preheader ]
  %4 = phi i32 [ %.pr, %for.end ], [ undef, %for.inc.preheader ]
  %j.2.ph1 = phi i32 [ %.pr, %for.end ], [ 0, %for.inc.preheader ]
  %k.0.ph = phi i32 [ undef, %for.end ], [ 0, %for.inc.preheader ]
  %o.1.ph = phi i32 [ undef, %for.end ], [ 0, %for.inc.preheader ]
  %n.1.ph = phi i32 [ undef, %for.end ], [ 0, %for.inc.preheader ]
  ret i32 0
}
