; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='loop-mssa(simple-loop-unswitch<nontrivial>),loop-mssa(simple-loop-unswitch<nontrivial>),verify<loops>' -S < %s | FileCheck %s

; Below bugs have caused endless unswitch.
;
; https://bugs.llvm.org/show_bug.cgi?id=50279
; https://bugs.llvm.org/show_bug.cgi?id=50302
;
; This test's loop should be unswitched only one time even though we run
; SimpleLoopUnswitch pass two times.

@a = dso_local local_unnamed_addr global i32 0, align 4
@c = dso_local local_unnamed_addr global i32 0, align 4
@b = dso_local local_unnamed_addr global i8 0, align 1

; Function Attrs: nofree norecurse nosync nounwind uwtable
define dso_local void @d() {
; CHECK-LABEL: @d(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br i1 false, label [[FOR_END:%.*]], label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* null, align 2
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i16 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[FOR_END_SPLIT:%.*]], label [[FOR_END_SPLIT_US:%.*]]
; CHECK:       for.end.split.us:
; CHECK-NEXT:    br label [[G_US:%.*]]
; CHECK:       g.us:
; CHECK-NEXT:    br label [[G_SPLIT_US6:%.*]]
; CHECK:       for.cond1.us1:
; CHECK-NEXT:    [[TMP2:%.*]] = load i16, i16* null, align 2
; CHECK-NEXT:    [[TOBOOL4_NOT_US:%.*]] = icmp eq i16 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TOBOOL4_NOT_US]], label [[FOR_COND5_PREHEADER_US4:%.*]], label [[G_LOOPEXIT_US:%.*]]
; CHECK:       for.cond5.us2:
; CHECK-NEXT:    br i1 false, label [[FOR_COND1_LOOPEXIT_US5:%.*]], label [[FOR_INC_US3:%.*]]
; CHECK:       for.inc.us3:
; CHECK-NEXT:    store i8 0, i8* @b, align 1
; CHECK-NEXT:    br label [[FOR_COND5_US2:%.*]]
; CHECK:       for.cond5.preheader.us4:
; CHECK-NEXT:    br label [[FOR_COND5_US2]]
; CHECK:       for.cond1.loopexit.us5:
; CHECK-NEXT:    br label [[FOR_COND1_US1:%.*]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       g.loopexit.us:
; CHECK-NEXT:    br label [[G_US]]
; CHECK:       g.split.us6:
; CHECK-NEXT:    br label [[FOR_COND1_US1]]
; CHECK:       for.end.split:
; CHECK-NEXT:    br label [[G:%.*]]
; CHECK:       g.loopexit:
; CHECK-NEXT:    br label [[G]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       g:
; CHECK-NEXT:    [[TMP3:%.*]] = load i16, i16* null, align 2
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i16 [[TMP3]], 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[G_SPLIT_US:%.*]], label [[G_SPLIT:%.*]]
; CHECK:       g.split.us:
; CHECK-NEXT:    br label [[FOR_COND1_US:%.*]]
; CHECK:       for.cond1.us:
; CHECK-NEXT:    br label [[FOR_COND5_PREHEADER_US:%.*]]
; CHECK:       for.cond5.us:
; CHECK-NEXT:    br i1 false, label [[FOR_COND1_LOOPEXIT_US:%.*]], label [[FOR_INC_US:%.*]]
; CHECK:       for.inc.us:
; CHECK-NEXT:    store i8 0, i8* @b, align 1
; CHECK-NEXT:    br label [[FOR_COND5_US:%.*]]
; CHECK:       for.cond5.preheader.us:
; CHECK-NEXT:    br label [[FOR_COND5_US]]
; CHECK:       for.cond1.loopexit.us:
; CHECK-NEXT:    br label [[FOR_COND1_US]]
; CHECK:       g.split:
; CHECK-NEXT:    br label [[FOR_COND1:%.*]]
; CHECK:       for.cond1.loopexit:
; CHECK-NEXT:    br label [[FOR_COND1]], !llvm.loop [[LOOP0]]
; CHECK:       for.cond1:
; CHECK-NEXT:    [[TMP5:%.*]] = load i16, i16* null, align 2
; CHECK-NEXT:    [[TOBOOL4_NOT:%.*]] = icmp eq i16 [[TMP5]], 0
; CHECK-NEXT:    br i1 [[TOBOOL4_NOT]], label [[FOR_COND5_PREHEADER:%.*]], label [[G_LOOPEXIT:%.*]]
; CHECK:       for.cond5.preheader:
; CHECK-NEXT:    br label [[FOR_COND5:%.*]]
; CHECK:       for.cond5:
; CHECK-NEXT:    br i1 false, label [[FOR_COND1_LOOPEXIT:%.*]], label [[FOR_INC:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    store i8 0, i8* @b, align 1
; CHECK-NEXT:    br label [[FOR_COND5]]
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.cond, %entry
  br i1 false, label %for.end, label %for.cond

for.end:                                          ; preds = %for.cond
  br label %g

g:                                                ; preds = %for.cond1, %for.end
  br label %for.cond1

for.cond1:                                        ; preds = %for.cond5, %g
  %0 = load i16, i16* null, align 2
  %tobool4.not = icmp eq i16 %0, 0
  br i1 %tobool4.not, label %for.cond5, label %g

for.cond5:                                        ; preds = %for.inc, %for.cond1
  br i1 false, label %for.cond1, label %for.inc

for.inc:                                          ; preds = %for.cond5
  store i8 0, i8* @b, align 1
  br label %for.cond5
}
