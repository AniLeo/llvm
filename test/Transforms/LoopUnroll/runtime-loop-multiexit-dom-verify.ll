; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-unroll -unroll-runtime=true -unroll-runtime-epilog=false -unroll-runtime-multi-exit=true -unroll-count=4  -verify-dom-info -S | FileCheck %s

; REQUIRES: asserts
; The tests below are for verifying dom tree after runtime unrolling
; with multiple exit/exiting blocks.

; We explicitly set the unroll count so that expensiveTripCount computation is allowed.

; mergedexit block has edges from loop exit blocks.
define i64 @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[TRIP:%.*]] = zext i32 undef to i64
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 2, [[PREHEADER]] ], [ [[ADD_IV_3:%.*]], [[LATCH_3:%.*]] ]
; CHECK-NEXT:    [[ADD_IV:%.*]] = add nuw nsw i64 [[IV]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i64 [[ADD_IV]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[LATCH:%.*]], label [[HEADEREXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[SHFT:%.*]] = ashr i64 [[ADD_IV]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i64 [[SHFT]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[HEADER_1:%.*]], label [[LATCHEXIT:%.*]]
; CHECK:       header.1:
; CHECK-NEXT:    [[ADD_IV_1:%.*]] = add nuw nsw i64 [[ADD_IV]], 2
; CHECK-NEXT:    [[CMP1_1:%.*]] = icmp ult i64 [[ADD_IV_1]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_1]], label [[LATCH_1:%.*]], label [[HEADEREXIT]]
; CHECK:       latch.1:
; CHECK-NEXT:    [[SHFT_1:%.*]] = ashr i64 [[ADD_IV_1]], 1
; CHECK-NEXT:    [[CMP2_1:%.*]] = icmp ult i64 [[SHFT_1]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_1]], label [[HEADER_2:%.*]], label [[LATCHEXIT]]
; CHECK:       header.2:
; CHECK-NEXT:    [[ADD_IV_2:%.*]] = add nuw nsw i64 [[ADD_IV_1]], 2
; CHECK-NEXT:    [[CMP1_2:%.*]] = icmp ult i64 [[ADD_IV_2]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_2]], label [[LATCH_2:%.*]], label [[HEADEREXIT]]
; CHECK:       latch.2:
; CHECK-NEXT:    [[SHFT_2:%.*]] = ashr i64 [[ADD_IV_2]], 1
; CHECK-NEXT:    [[CMP2_2:%.*]] = icmp ult i64 [[SHFT_2]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_2]], label [[HEADER_3:%.*]], label [[LATCHEXIT]]
; CHECK:       header.3:
; CHECK-NEXT:    [[ADD_IV_3]] = add nuw nsw i64 [[ADD_IV_2]], 2
; CHECK-NEXT:    [[CMP1_3:%.*]] = icmp ult i64 [[ADD_IV_3]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_3]], label [[LATCH_3]], label [[HEADEREXIT]]
; CHECK:       latch.3:
; CHECK-NEXT:    [[SHFT_3:%.*]] = ashr i64 [[ADD_IV_3]], 1
; CHECK-NEXT:    [[CMP2_3:%.*]] = icmp ult i64 [[SHFT_3]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_3]], label [[HEADER]], label [[LATCHEXIT]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       headerexit:
; CHECK-NEXT:    [[ADDPHI:%.*]] = phi i64 [ [[ADD_IV]], [[HEADER]] ], [ [[ADD_IV_1]], [[HEADER_1]] ], [ [[ADD_IV_2]], [[HEADER_2]] ], [ [[ADD_IV_3]], [[HEADER_3]] ]
; CHECK-NEXT:    br label [[MERGEDEXIT:%.*]]
; CHECK:       latchexit:
; CHECK-NEXT:    [[SHFTPHI:%.*]] = phi i64 [ [[SHFT]], [[LATCH]] ], [ [[SHFT_1]], [[LATCH_1]] ], [ [[SHFT_2]], [[LATCH_2]] ], [ [[SHFT_3]], [[LATCH_3]] ]
; CHECK-NEXT:    br label [[MERGEDEXIT]]
; CHECK:       mergedexit:
; CHECK-NEXT:    [[RETVAL:%.*]] = phi i64 [ [[ADDPHI]], [[HEADEREXIT]] ], [ [[SHFTPHI]], [[LATCHEXIT]] ]
; CHECK-NEXT:    ret i64 [[RETVAL]]
;
entry:
  br label %preheader

preheader:                                              ; preds = %bb
  %trip = zext i32 undef to i64
  br label %header

header:                                              ; preds = %latch, %preheader
  %iv = phi i64 [ 2, %preheader ], [ %add.iv, %latch ]
  %add.iv = add nuw nsw i64 %iv, 2
  %cmp1 = icmp ult i64 %add.iv, %trip
  br i1 %cmp1, label %latch, label %headerexit

latch:                                             ; preds = %header
  %shft = ashr i64 %add.iv, 1
  %cmp2 = icmp ult i64 %shft, %trip
  br i1 %cmp2, label %header, label %latchexit

headerexit:                                              ; preds = %header
  %addphi = phi i64 [ %add.iv, %header ]
  br label %mergedexit

latchexit:                                              ; preds = %latch
  %shftphi = phi i64 [ %shft, %latch ]
  br label %mergedexit

mergedexit:                                              ; preds = %latchexit, %headerexit
  %retval = phi i64 [ %addphi, %headerexit ], [ %shftphi, %latchexit ]
  ret i64 %retval
}

; mergedexit has edges from loop exit blocks and a block outside the loop.
define  void @test2(i1 %cond, i32 %n) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[PREHEADER:%.*]], label [[MERGEDEXIT:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[TRIP:%.*]] = zext i32 [[N:%.*]] to i64
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 2, [[PREHEADER]] ], [ [[ADD_IV_3:%.*]], [[LATCH_3:%.*]] ]
; CHECK-NEXT:    [[ADD_IV:%.*]] = add nuw nsw i64 [[IV]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i64 [[ADD_IV]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[LATCH:%.*]], label [[HEADEREXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[SHFT:%.*]] = ashr i64 [[ADD_IV]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i64 [[SHFT]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[HEADER_1:%.*]], label [[LATCHEXIT:%.*]]
; CHECK:       header.1:
; CHECK-NEXT:    [[ADD_IV_1:%.*]] = add nuw nsw i64 [[ADD_IV]], 2
; CHECK-NEXT:    [[CMP1_1:%.*]] = icmp ult i64 [[ADD_IV_1]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_1]], label [[LATCH_1:%.*]], label [[HEADEREXIT]]
; CHECK:       latch.1:
; CHECK-NEXT:    [[SHFT_1:%.*]] = ashr i64 [[ADD_IV_1]], 1
; CHECK-NEXT:    [[CMP2_1:%.*]] = icmp ult i64 [[SHFT_1]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_1]], label [[HEADER_2:%.*]], label [[LATCHEXIT]]
; CHECK:       header.2:
; CHECK-NEXT:    [[ADD_IV_2:%.*]] = add nuw nsw i64 [[ADD_IV_1]], 2
; CHECK-NEXT:    [[CMP1_2:%.*]] = icmp ult i64 [[ADD_IV_2]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_2]], label [[LATCH_2:%.*]], label [[HEADEREXIT]]
; CHECK:       latch.2:
; CHECK-NEXT:    [[SHFT_2:%.*]] = ashr i64 [[ADD_IV_2]], 1
; CHECK-NEXT:    [[CMP2_2:%.*]] = icmp ult i64 [[SHFT_2]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_2]], label [[HEADER_3:%.*]], label [[LATCHEXIT]]
; CHECK:       header.3:
; CHECK-NEXT:    [[ADD_IV_3]] = add nuw nsw i64 [[ADD_IV_2]], 2
; CHECK-NEXT:    [[CMP1_3:%.*]] = icmp ult i64 [[ADD_IV_3]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_3]], label [[LATCH_3]], label [[HEADEREXIT]]
; CHECK:       latch.3:
; CHECK-NEXT:    [[SHFT_3:%.*]] = ashr i64 [[ADD_IV_3]], 1
; CHECK-NEXT:    [[CMP2_3:%.*]] = icmp ult i64 [[SHFT_3]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_3]], label [[HEADER]], label [[LATCHEXIT]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       headerexit:
; CHECK-NEXT:    br label [[MERGEDEXIT]]
; CHECK:       latchexit:
; CHECK-NEXT:    br label [[MERGEDEXIT]]
; CHECK:       mergedexit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 %cond, label %preheader, label %mergedexit

preheader:                                              ; preds = %entry
  %trip = zext i32 %n to i64
  br label %header

header:                                              ; preds = %latch, %preheader
  %iv = phi i64 [ 2, %preheader ], [ %add.iv, %latch ]
  %add.iv = add nuw nsw i64 %iv, 2
  %cmp1 = icmp ult i64 %add.iv, %trip
  br i1 %cmp1, label %latch, label %headerexit

latch:                                             ; preds = %header
  %shft = ashr i64 %add.iv, 1
  %cmp2 = icmp ult i64 %shft, %trip
  br i1 %cmp2, label %header, label %latchexit

headerexit:                                              ; preds = %header
  br label %mergedexit

latchexit:                                              ; preds = %latch
  br label %mergedexit

mergedexit:                                              ; preds = %latchexit, %headerexit, %entry
  ret void
}


; exitsucc is from loop exit block only.
define i64 @test3(i32 %n) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[PREHEADER:%.*]]
; CHECK:       preheader:
; CHECK-NEXT:    [[TRIP:%.*]] = zext i32 [[N:%.*]] to i64
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 2, [[PREHEADER]] ], [ [[ADD_IV_3:%.*]], [[LATCH_3:%.*]] ]
; CHECK-NEXT:    [[ADD_IV:%.*]] = add nuw nsw i64 [[IV]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i64 [[ADD_IV]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[LATCH:%.*]], label [[HEADEREXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[SHFT:%.*]] = ashr i64 [[ADD_IV]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i64 [[SHFT]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[HEADER_1:%.*]], label [[LATCHEXIT:%.*]]
; CHECK:       header.1:
; CHECK-NEXT:    [[ADD_IV_1:%.*]] = add nuw nsw i64 [[ADD_IV]], 2
; CHECK-NEXT:    [[CMP1_1:%.*]] = icmp ult i64 [[ADD_IV_1]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_1]], label [[LATCH_1:%.*]], label [[HEADEREXIT]]
; CHECK:       latch.1:
; CHECK-NEXT:    [[SHFT_1:%.*]] = ashr i64 [[ADD_IV_1]], 1
; CHECK-NEXT:    [[CMP2_1:%.*]] = icmp ult i64 [[SHFT_1]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_1]], label [[HEADER_2:%.*]], label [[LATCHEXIT]]
; CHECK:       header.2:
; CHECK-NEXT:    [[ADD_IV_2:%.*]] = add nuw nsw i64 [[ADD_IV_1]], 2
; CHECK-NEXT:    [[CMP1_2:%.*]] = icmp ult i64 [[ADD_IV_2]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_2]], label [[LATCH_2:%.*]], label [[HEADEREXIT]]
; CHECK:       latch.2:
; CHECK-NEXT:    [[SHFT_2:%.*]] = ashr i64 [[ADD_IV_2]], 1
; CHECK-NEXT:    [[CMP2_2:%.*]] = icmp ult i64 [[SHFT_2]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_2]], label [[HEADER_3:%.*]], label [[LATCHEXIT]]
; CHECK:       header.3:
; CHECK-NEXT:    [[ADD_IV_3]] = add nuw nsw i64 [[ADD_IV_2]], 2
; CHECK-NEXT:    [[CMP1_3:%.*]] = icmp ult i64 [[ADD_IV_3]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP1_3]], label [[LATCH_3]], label [[HEADEREXIT]]
; CHECK:       latch.3:
; CHECK-NEXT:    [[SHFT_3:%.*]] = ashr i64 [[ADD_IV_3]], 1
; CHECK-NEXT:    [[CMP2_3:%.*]] = icmp ult i64 [[SHFT_3]], [[TRIP]]
; CHECK-NEXT:    br i1 [[CMP2_3]], label [[HEADER]], label [[LATCHEXIT]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       headerexit:
; CHECK-NEXT:    br label [[EXITSUCC:%.*]]
; CHECK:       latchexit:
; CHECK-NEXT:    [[SHFTPHI:%.*]] = phi i64 [ [[SHFT]], [[LATCH]] ], [ [[SHFT_1]], [[LATCH_1]] ], [ [[SHFT_2]], [[LATCH_2]] ], [ [[SHFT_3]], [[LATCH_3]] ]
; CHECK-NEXT:    ret i64 [[SHFTPHI]]
; CHECK:       exitsucc:
; CHECK-NEXT:    ret i64 96
;
entry:
  br label %preheader

preheader:                                              ; preds = %bb
  %trip = zext i32 %n to i64
  br label %header

header:                                              ; preds = %latch, %preheader
  %iv = phi i64 [ 2, %preheader ], [ %add.iv, %latch ]
  %add.iv = add nuw nsw i64 %iv, 2
  %cmp1 = icmp ult i64 %add.iv, %trip
  br i1 %cmp1, label %latch, label %headerexit

latch:                                             ; preds = %header
  %shft = ashr i64 %add.iv, 1
  %cmp2 = icmp ult i64 %shft, %trip
  br i1 %cmp2, label %header, label %latchexit

headerexit:                                              ; preds = %header
  br label %exitsucc

latchexit:                                              ; preds = %latch
  %shftphi = phi i64 [ %shft, %latch ]
  ret i64 %shftphi

exitsucc:                                              ; preds = %headerexit
  ret i64 96
}

; exit block (%default) has an exiting block and another exit block as predecessors.
define void @test4(i16 %c3) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  preheader:
; CHECK-NEXT:    [[C1:%.*]] = zext i32 undef to i64
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[C1]], i64 1)
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[UMAX]], -1
; CHECK-NEXT:    [[XTRAITER:%.*]] = and i64 [[UMAX]], 3
; CHECK-NEXT:    [[LCMP_MOD:%.*]] = icmp ne i64 [[XTRAITER]], 0
; CHECK-NEXT:    br i1 [[LCMP_MOD]], label [[HEADER_PROL_PREHEADER:%.*]], label [[HEADER_PROL_LOOPEXIT:%.*]]
; CHECK:       header.prol.preheader:
; CHECK-NEXT:    br label [[HEADER_PROL:%.*]]
; CHECK:       header.prol:
; CHECK-NEXT:    [[INDVARS_IV_PROL:%.*]] = phi i64 [ 0, [[HEADER_PROL_PREHEADER]] ], [ [[INDVARS_IV_NEXT_PROL:%.*]], [[LATCH_PROL:%.*]] ]
; CHECK-NEXT:    [[PROL_ITER:%.*]] = phi i64 [ 0, [[HEADER_PROL_PREHEADER]] ], [ [[PROL_ITER_NEXT:%.*]], [[LATCH_PROL]] ]
; CHECK-NEXT:    br label [[EXITING_PROL:%.*]]
; CHECK:       exiting.prol:
; CHECK-NEXT:    switch i16 [[C3:%.*]], label [[DEFAULT_LOOPEXIT_LOOPEXIT1:%.*]] [
; CHECK-NEXT:    i16 45, label [[OTHEREXIT_LOOPEXIT2:%.*]]
; CHECK-NEXT:    i16 95, label [[LATCH_PROL]]
; CHECK-NEXT:    ]
; CHECK:       latch.prol:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_PROL]] = add nuw nsw i64 [[INDVARS_IV_PROL]], 1
; CHECK-NEXT:    [[C2_PROL:%.*]] = icmp ult i64 [[INDVARS_IV_NEXT_PROL]], [[C1]]
; CHECK-NEXT:    [[PROL_ITER_NEXT]] = add i64 [[PROL_ITER]], 1
; CHECK-NEXT:    [[PROL_ITER_CMP:%.*]] = icmp ne i64 [[PROL_ITER_NEXT]], [[XTRAITER]]
; CHECK-NEXT:    br i1 [[PROL_ITER_CMP]], label [[HEADER_PROL]], label [[HEADER_PROL_LOOPEXIT_UNR_LCSSA:%.*]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       header.prol.loopexit.unr-lcssa:
; CHECK-NEXT:    [[INDVARS_IV_UNR_PH:%.*]] = phi i64 [ [[INDVARS_IV_NEXT_PROL]], [[LATCH_PROL]] ]
; CHECK-NEXT:    br label [[HEADER_PROL_LOOPEXIT]]
; CHECK:       header.prol.loopexit:
; CHECK-NEXT:    [[INDVARS_IV_UNR:%.*]] = phi i64 [ 0, [[PREHEADER:%.*]] ], [ [[INDVARS_IV_UNR_PH]], [[HEADER_PROL_LOOPEXIT_UNR_LCSSA]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[TMP0]], 3
; CHECK-NEXT:    br i1 [[TMP1]], label [[LATCHEXIT:%.*]], label [[PREHEADER_NEW:%.*]]
; CHECK:       preheader.new:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_UNR]], [[PREHEADER_NEW]] ], [ [[INDVARS_IV_NEXT_3:%.*]], [[LATCH_3:%.*]] ]
; CHECK-NEXT:    br label [[EXITING:%.*]]
; CHECK:       exiting:
; CHECK-NEXT:    switch i16 [[C3]], label [[DEFAULT_LOOPEXIT_LOOPEXIT:%.*]] [
; CHECK-NEXT:    i16 45, label [[OTHEREXIT_LOOPEXIT:%.*]]
; CHECK-NEXT:    i16 95, label [[LATCH:%.*]]
; CHECK-NEXT:    ]
; CHECK:       latch:
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    br label [[EXITING_1:%.*]]
; CHECK:       exiting.1:
; CHECK-NEXT:    switch i16 [[C3]], label [[DEFAULT_LOOPEXIT_LOOPEXIT]] [
; CHECK-NEXT:    i16 45, label [[OTHEREXIT_LOOPEXIT]]
; CHECK-NEXT:    i16 95, label [[LATCH_1:%.*]]
; CHECK-NEXT:    ]
; CHECK:       latch.1:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_1:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT]], 1
; CHECK-NEXT:    br label [[EXITING_2:%.*]]
; CHECK:       exiting.2:
; CHECK-NEXT:    switch i16 [[C3]], label [[DEFAULT_LOOPEXIT_LOOPEXIT]] [
; CHECK-NEXT:    i16 45, label [[OTHEREXIT_LOOPEXIT]]
; CHECK-NEXT:    i16 95, label [[LATCH_2:%.*]]
; CHECK-NEXT:    ]
; CHECK:       latch.2:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_2:%.*]] = add nuw nsw i64 [[INDVARS_IV_NEXT_1]], 1
; CHECK-NEXT:    br label [[EXITING_3:%.*]]
; CHECK:       exiting.3:
; CHECK-NEXT:    switch i16 [[C3]], label [[DEFAULT_LOOPEXIT_LOOPEXIT]] [
; CHECK-NEXT:    i16 45, label [[OTHEREXIT_LOOPEXIT]]
; CHECK-NEXT:    i16 95, label [[LATCH_3]]
; CHECK-NEXT:    ]
; CHECK:       latch.3:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_3]] = add nuw nsw i64 [[INDVARS_IV_NEXT_2]], 1
; CHECK-NEXT:    [[C2_3:%.*]] = icmp ult i64 [[INDVARS_IV_NEXT_3]], [[C1]]
; CHECK-NEXT:    br i1 [[C2_3]], label [[HEADER]], label [[LATCHEXIT_UNR_LCSSA:%.*]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       latchexit.unr-lcssa:
; CHECK-NEXT:    br label [[LATCHEXIT]]
; CHECK:       latchexit:
; CHECK-NEXT:    ret void
; CHECK:       default.loopexit.loopexit:
; CHECK-NEXT:    br label [[DEFAULT_LOOPEXIT:%.*]]
; CHECK:       default.loopexit.loopexit1:
; CHECK-NEXT:    br label [[DEFAULT_LOOPEXIT]]
; CHECK:       default.loopexit:
; CHECK-NEXT:    br label [[DEFAULT:%.*]]
; CHECK:       default:
; CHECK-NEXT:    ret void
; CHECK:       otherexit.loopexit:
; CHECK-NEXT:    br label [[OTHEREXIT:%.*]]
; CHECK:       otherexit.loopexit2:
; CHECK-NEXT:    br label [[OTHEREXIT]]
; CHECK:       otherexit:
; CHECK-NEXT:    br label [[DEFAULT]]
;
preheader:
  %c1 = zext i32 undef to i64
  br label %header

header:                                       ; preds = %latch, %preheader
  %indvars.iv = phi i64 [ 0, %preheader ], [ %indvars.iv.next, %latch ]
  br label %exiting

exiting:                                           ; preds = %header
  switch i16 %c3, label %default [
  i16 45, label %otherexit
  i16 95, label %latch
  ]

latch:                                          ; preds = %exiting
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %c2 = icmp ult i64 %indvars.iv.next, %c1
  br i1 %c2, label %header, label %latchexit

latchexit:                                          ; preds = %latch
  ret void

default:                                          ; preds = %otherexit, %exiting
  ret void

otherexit:                                           ; preds = %exiting
  br label %default
}

; exit block (%exitB) has an exiting block and another exit block as predecessors.
; exiting block comes from inner loop.
define void @test5(i1 %c) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = icmp sgt i32 undef, 79
; CHECK-NEXT:    br i1 [[TMP]], label [[OUTERLATCHEXIT:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[OUTERH_PROL_PREHEADER:%.*]], label [[OUTERH_PROL_LOOPEXIT:%.*]]
; CHECK:       outerH.prol.preheader:
; CHECK-NEXT:    br label [[OUTERH_PROL:%.*]]
; CHECK:       outerH.prol:
; CHECK-NEXT:    [[TMP4_PROL:%.*]] = phi i32 [ [[TMP6_PROL:%.*]], [[OUTERLATCH_PROL:%.*]] ], [ undef, [[OUTERH_PROL_PREHEADER]] ]
; CHECK-NEXT:    [[PROL_ITER:%.*]] = phi i32 [ 0, [[OUTERH_PROL_PREHEADER]] ], [ [[PROL_ITER_NEXT:%.*]], [[OUTERLATCH_PROL]] ]
; CHECK-NEXT:    br label [[INNERH_PROL:%.*]]
; CHECK:       innerH.prol:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[INNEREXITING_PROL:%.*]], label [[OTHEREXITB_LOOPEXIT1:%.*]]
; CHECK:       innerexiting.prol:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_PROL:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT2:%.*]]
; CHECK:       innerLatch.prol:
; CHECK-NEXT:    br i1 false, label [[INNERH_1_PROL:%.*]], label [[OUTERLATCH_PROL]]
; CHECK:       innerH.1.prol:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_1_PROL:%.*]], label [[OTHEREXITB_LOOPEXIT1]]
; CHECK:       innerexiting.1.prol:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_1_PROL:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT2]]
; CHECK:       innerLatch.1.prol:
; CHECK-NEXT:    br i1 false, label [[INNERH_2_PROL:%.*]], label [[OUTERLATCH_PROL]]
; CHECK:       innerH.2.prol:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_2_PROL:%.*]], label [[OTHEREXITB_LOOPEXIT1]]
; CHECK:       innerexiting.2.prol:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_2_PROL:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT2]]
; CHECK:       innerLatch.2.prol:
; CHECK-NEXT:    br i1 false, label [[INNERH_3_PROL:%.*]], label [[OUTERLATCH_PROL]]
; CHECK:       innerH.3.prol:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_3_PROL:%.*]], label [[OTHEREXITB_LOOPEXIT1]]
; CHECK:       innerexiting.3.prol:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_3_PROL:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT2]]
; CHECK:       innerLatch.3.prol:
; CHECK-NEXT:    br i1 false, label [[INNERH_PROL]], label [[OUTERLATCH_PROL]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       outerLatch.prol:
; CHECK-NEXT:    [[TMP6_PROL]] = add i32 [[TMP4_PROL]], 1
; CHECK-NEXT:    [[TMP7_PROL:%.*]] = icmp sgt i32 [[TMP6_PROL]], 79
; CHECK-NEXT:    [[PROL_ITER_NEXT]] = add i32 [[PROL_ITER]], 1
; CHECK-NEXT:    [[PROL_ITER_CMP:%.*]] = icmp ne i32 [[PROL_ITER_NEXT]], 0
; CHECK-NEXT:    br i1 [[PROL_ITER_CMP]], label [[OUTERH_PROL]], label [[OUTERH_PROL_LOOPEXIT_UNR_LCSSA:%.*]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       outerH.prol.loopexit.unr-lcssa:
; CHECK-NEXT:    [[TMP4_UNR_PH:%.*]] = phi i32 [ [[TMP6_PROL]], [[OUTERLATCH_PROL]] ]
; CHECK-NEXT:    br label [[OUTERH_PROL_LOOPEXIT]]
; CHECK:       outerH.prol.loopexit:
; CHECK-NEXT:    [[TMP4_UNR:%.*]] = phi i32 [ undef, [[BB1]] ], [ [[TMP4_UNR_PH]], [[OUTERH_PROL_LOOPEXIT_UNR_LCSSA]] ]
; CHECK-NEXT:    br i1 false, label [[OUTERLATCHEXIT_LOOPEXIT:%.*]], label [[BB1_NEW:%.*]]
; CHECK:       bb1.new:
; CHECK-NEXT:    br label [[OUTERH:%.*]]
; CHECK:       outerH:
; CHECK-NEXT:    [[TMP4:%.*]] = phi i32 [ [[TMP4_UNR]], [[BB1_NEW]] ], [ [[TMP6_3:%.*]], [[OUTERLATCH_3:%.*]] ]
; CHECK-NEXT:    br label [[INNERH:%.*]]
; CHECK:       innerH:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT:%.*]]
; CHECK:       innerexiting:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT:%.*]]
; CHECK:       innerLatch:
; CHECK-NEXT:    br i1 false, label [[INNERH_1:%.*]], label [[OUTERLATCH:%.*]]
; CHECK:       innerH.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_1:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT]]
; CHECK:       innerexiting.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_1:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT]]
; CHECK:       innerLatch.1:
; CHECK-NEXT:    br i1 false, label [[INNERH_2:%.*]], label [[OUTERLATCH]]
; CHECK:       innerH.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_2:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT]]
; CHECK:       innerexiting.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_2:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT]]
; CHECK:       innerLatch.2:
; CHECK-NEXT:    br i1 false, label [[INNERH_3:%.*]], label [[OUTERLATCH]]
; CHECK:       innerH.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_3:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT]]
; CHECK:       innerexiting.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_3:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT]]
; CHECK:       innerLatch.3:
; CHECK-NEXT:    br i1 false, label [[INNERH]], label [[OUTERLATCH]], !llvm.loop [[LOOP6]]
; CHECK:       outerLatch:
; CHECK-NEXT:    [[TMP6:%.*]] = add i32 [[TMP4]], 1
; CHECK-NEXT:    br label [[INNERH_13:%.*]]
; CHECK:       innerH.13:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_14:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT12:%.*]]
; CHECK:       innerexiting.14:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_15:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT13:%.*]]
; CHECK:       innerLatch.15:
; CHECK-NEXT:    br i1 false, label [[INNERH_1_1:%.*]], label [[OUTERLATCH_1:%.*]]
; CHECK:       innerH.1.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_1_1:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT12]]
; CHECK:       innerexiting.1.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_1_1:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT13]]
; CHECK:       innerLatch.1.1:
; CHECK-NEXT:    br i1 false, label [[INNERH_2_1:%.*]], label [[OUTERLATCH_1]]
; CHECK:       innerH.2.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_2_1:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT12]]
; CHECK:       innerexiting.2.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_2_1:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT13]]
; CHECK:       innerLatch.2.1:
; CHECK-NEXT:    br i1 false, label [[INNERH_3_1:%.*]], label [[OUTERLATCH_1]]
; CHECK:       innerH.3.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_3_1:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT12]]
; CHECK:       innerexiting.3.1:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_3_1:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT13]]
; CHECK:       innerLatch.3.1:
; CHECK-NEXT:    br i1 false, label [[INNERH_13]], label [[OUTERLATCH_1]], !llvm.loop [[LOOP6]]
; CHECK:       outerLatch.1:
; CHECK-NEXT:    [[TMP6_1:%.*]] = add i32 [[TMP6]], 1
; CHECK-NEXT:    br label [[INNERH_26:%.*]]
; CHECK:       innerH.26:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_27:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT14:%.*]]
; CHECK:       innerexiting.27:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_28:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT15:%.*]]
; CHECK:       innerLatch.28:
; CHECK-NEXT:    br i1 false, label [[INNERH_1_2:%.*]], label [[OUTERLATCH_2:%.*]]
; CHECK:       innerH.1.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_1_2:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT14]]
; CHECK:       innerexiting.1.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_1_2:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT15]]
; CHECK:       innerLatch.1.2:
; CHECK-NEXT:    br i1 false, label [[INNERH_2_2:%.*]], label [[OUTERLATCH_2]]
; CHECK:       innerH.2.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_2_2:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT14]]
; CHECK:       innerexiting.2.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_2_2:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT15]]
; CHECK:       innerLatch.2.2:
; CHECK-NEXT:    br i1 false, label [[INNERH_3_2:%.*]], label [[OUTERLATCH_2]]
; CHECK:       innerH.3.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_3_2:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT14]]
; CHECK:       innerexiting.3.2:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_3_2:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT15]]
; CHECK:       innerLatch.3.2:
; CHECK-NEXT:    br i1 false, label [[INNERH_26]], label [[OUTERLATCH_2]], !llvm.loop [[LOOP6]]
; CHECK:       outerLatch.2:
; CHECK-NEXT:    [[TMP6_2:%.*]] = add i32 [[TMP6_1]], 1
; CHECK-NEXT:    br label [[INNERH_39:%.*]]
; CHECK:       innerH.39:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_310:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT16:%.*]]
; CHECK:       innerexiting.310:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_311:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT17:%.*]]
; CHECK:       innerLatch.311:
; CHECK-NEXT:    br i1 false, label [[INNERH_1_3:%.*]], label [[OUTERLATCH_3]]
; CHECK:       innerH.1.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_1_3:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT16]]
; CHECK:       innerexiting.1.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_1_3:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT17]]
; CHECK:       innerLatch.1.3:
; CHECK-NEXT:    br i1 false, label [[INNERH_2_3:%.*]], label [[OUTERLATCH_3]]
; CHECK:       innerH.2.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_2_3:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT16]]
; CHECK:       innerexiting.2.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_2_3:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT17]]
; CHECK:       innerLatch.2.3:
; CHECK-NEXT:    br i1 false, label [[INNERH_3_3:%.*]], label [[OUTERLATCH_3]]
; CHECK:       innerH.3.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNEREXITING_3_3:%.*]], label [[OTHEREXITB_LOOPEXIT_LOOPEXIT16]]
; CHECK:       innerexiting.3.3:
; CHECK-NEXT:    br i1 [[C]], label [[INNERLATCH_3_3:%.*]], label [[EXITB_LOOPEXIT_LOOPEXIT_LOOPEXIT17]]
; CHECK:       innerLatch.3.3:
; CHECK-NEXT:    br i1 false, label [[INNERH_39]], label [[OUTERLATCH_3]], !llvm.loop [[LOOP6]]
; CHECK:       outerLatch.3:
; CHECK-NEXT:    [[TMP6_3]] = add i32 [[TMP6_2]], 1
; CHECK-NEXT:    [[TMP7_3:%.*]] = icmp sgt i32 [[TMP6_3]], 79
; CHECK-NEXT:    br i1 [[TMP7_3]], label [[OUTERLATCHEXIT_LOOPEXIT_UNR_LCSSA:%.*]], label [[OUTERH]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       outerLatchExit.loopexit.unr-lcssa:
; CHECK-NEXT:    br label [[OUTERLATCHEXIT_LOOPEXIT]]
; CHECK:       outerLatchExit.loopexit:
; CHECK-NEXT:    br label [[OUTERLATCHEXIT]]
; CHECK:       outerLatchExit:
; CHECK-NEXT:    ret void
; CHECK:       exitB.loopexit.loopexit.loopexit:
; CHECK-NEXT:    br label [[EXITB_LOOPEXIT_LOOPEXIT:%.*]]
; CHECK:       exitB.loopexit.loopexit.loopexit13:
; CHECK-NEXT:    br label [[EXITB_LOOPEXIT_LOOPEXIT]]
; CHECK:       exitB.loopexit.loopexit.loopexit15:
; CHECK-NEXT:    br label [[EXITB_LOOPEXIT_LOOPEXIT]]
; CHECK:       exitB.loopexit.loopexit.loopexit17:
; CHECK-NEXT:    br label [[EXITB_LOOPEXIT_LOOPEXIT]]
; CHECK:       exitB.loopexit.loopexit:
; CHECK-NEXT:    br label [[EXITB_LOOPEXIT:%.*]]
; CHECK:       exitB.loopexit.loopexit2:
; CHECK-NEXT:    br label [[EXITB_LOOPEXIT]]
; CHECK:       exitB.loopexit:
; CHECK-NEXT:    br label [[EXITB:%.*]]
; CHECK:       exitB:
; CHECK-NEXT:    ret void
; CHECK:       otherexitB.loopexit.loopexit:
; CHECK-NEXT:    br label [[OTHEREXITB_LOOPEXIT:%.*]]
; CHECK:       otherexitB.loopexit.loopexit12:
; CHECK-NEXT:    br label [[OTHEREXITB_LOOPEXIT]]
; CHECK:       otherexitB.loopexit.loopexit14:
; CHECK-NEXT:    br label [[OTHEREXITB_LOOPEXIT]]
; CHECK:       otherexitB.loopexit.loopexit16:
; CHECK-NEXT:    br label [[OTHEREXITB_LOOPEXIT]]
; CHECK:       otherexitB.loopexit:
; CHECK-NEXT:    br label [[OTHEREXITB:%.*]]
; CHECK:       otherexitB.loopexit1:
; CHECK-NEXT:    br label [[OTHEREXITB]]
; CHECK:       otherexitB:
; CHECK-NEXT:    br label [[EXITB]]
;
bb:
  %tmp = icmp sgt i32 undef, 79
  br i1 %tmp, label %outerLatchExit, label %bb1

bb1:                                              ; preds = %bb
  br label %outerH

outerH:                                              ; preds = %outerLatch, %bb1
  %tmp4 = phi i32 [ %tmp6, %outerLatch ], [ undef, %bb1 ]
  br label %innerH

innerH:                                              ; preds = %innerLatch, %outerH
  br i1 %c, label %innerexiting, label %otherexitB

innerexiting:                                             ; preds = %innerH
  br i1 %c, label %innerLatch, label %exitB

innerLatch:                                             ; preds = %innerexiting
  %tmp13 = fcmp olt double undef, 2.000000e+00
  br i1 %tmp13, label %innerH, label %outerLatch

outerLatch:                                              ; preds = %innerLatch
  %tmp6 = add i32 %tmp4, 1
  %tmp7 = icmp sgt i32 %tmp6, 79
  br i1 %tmp7, label %outerLatchExit, label %outerH

outerLatchExit:                                              ; preds = %outerLatch, %bb
  ret void

exitB:                                             ; preds = %innerexiting, %otherexitB
  ret void

otherexitB:                                              ; preds = %innerH
  br label %exitB

}

; Blocks reachable from exits (not_zero44) have the IDom as the block within the loop (Header).
; Update the IDom to the preheader.
define void @test6(i1 %c) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 undef, i64 616)
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[SMAX]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = sub i64 [[TMP0]], undef
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i64 [[TMP1]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw i64 [[TMP2]], 1
; CHECK-NEXT:    [[XTRAITER:%.*]] = and i64 [[TMP3]], 3
; CHECK-NEXT:    [[LCMP_MOD:%.*]] = icmp ne i64 [[XTRAITER]], 0
; CHECK-NEXT:    br i1 [[LCMP_MOD]], label [[HEADER_PROL_PREHEADER:%.*]], label [[HEADER_PROL_LOOPEXIT:%.*]]
; CHECK:       header.prol.preheader:
; CHECK-NEXT:    br label [[HEADER_PROL:%.*]]
; CHECK:       header.prol:
; CHECK-NEXT:    [[INDVARS_IV_PROL:%.*]] = phi i64 [ undef, [[HEADER_PROL_PREHEADER]] ], [ [[INDVARS_IV_NEXT_PROL:%.*]], [[LATCH_PROL:%.*]] ]
; CHECK-NEXT:    [[PROL_ITER:%.*]] = phi i64 [ 0, [[HEADER_PROL_PREHEADER]] ], [ [[PROL_ITER_NEXT:%.*]], [[LATCH_PROL]] ]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LATCH_PROL]], label [[OTHEREXIT_LOOPEXIT1:%.*]]
; CHECK:       latch.prol:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_PROL]] = add nsw i64 [[INDVARS_IV_PROL]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT_PROL]], 616
; CHECK-NEXT:    [[PROL_ITER_NEXT]] = add i64 [[PROL_ITER]], 1
; CHECK-NEXT:    [[PROL_ITER_CMP:%.*]] = icmp ne i64 [[PROL_ITER_NEXT]], [[XTRAITER]]
; CHECK-NEXT:    br i1 [[PROL_ITER_CMP]], label [[HEADER_PROL]], label [[HEADER_PROL_LOOPEXIT_UNR_LCSSA:%.*]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       header.prol.loopexit.unr-lcssa:
; CHECK-NEXT:    [[INDVARS_IV_UNR_PH:%.*]] = phi i64 [ [[INDVARS_IV_NEXT_PROL]], [[LATCH_PROL]] ]
; CHECK-NEXT:    br label [[HEADER_PROL_LOOPEXIT]]
; CHECK:       header.prol.loopexit:
; CHECK-NEXT:    [[INDVARS_IV_UNR:%.*]] = phi i64 [ undef, [[ENTRY:%.*]] ], [ [[INDVARS_IV_UNR_PH]], [[HEADER_PROL_LOOPEXIT_UNR_LCSSA]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ult i64 [[TMP2]], 3
; CHECK-NEXT:    br i1 [[TMP5]], label [[LATCHEXIT:%.*]], label [[ENTRY_NEW:%.*]]
; CHECK:       entry.new:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_UNR]], [[ENTRY_NEW]] ], [ [[INDVARS_IV_NEXT_3:%.*]], [[LATCH_3:%.*]] ]
; CHECK-NEXT:    br i1 [[C]], label [[LATCH:%.*]], label [[OTHEREXIT_LOOPEXIT:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[INDVARS_IV_NEXT:%.*]] = add nsw i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    br i1 [[C]], label [[LATCH_1:%.*]], label [[OTHEREXIT_LOOPEXIT]]
; CHECK:       latch.1:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_1:%.*]] = add nsw i64 [[INDVARS_IV_NEXT]], 2
; CHECK-NEXT:    br i1 [[C]], label [[LATCH_2:%.*]], label [[OTHEREXIT_LOOPEXIT]]
; CHECK:       latch.2:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_2:%.*]] = add nsw i64 [[INDVARS_IV_NEXT_1]], 2
; CHECK-NEXT:    br i1 [[C]], label [[LATCH_3]], label [[OTHEREXIT_LOOPEXIT]]
; CHECK:       latch.3:
; CHECK-NEXT:    [[INDVARS_IV_NEXT_3]] = add nsw i64 [[INDVARS_IV_NEXT_2]], 2
; CHECK-NEXT:    [[TMP6:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT_3]], 616
; CHECK-NEXT:    br i1 [[TMP6]], label [[HEADER]], label [[LATCHEXIT_UNR_LCSSA:%.*]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       latchexit.unr-lcssa:
; CHECK-NEXT:    br label [[LATCHEXIT]]
; CHECK:       latchexit:
; CHECK-NEXT:    br label [[LATCHEXITSUCC:%.*]]
; CHECK:       otherexit.loopexit:
; CHECK-NEXT:    br label [[OTHEREXIT:%.*]]
; CHECK:       otherexit.loopexit1:
; CHECK-NEXT:    br label [[OTHEREXIT]]
; CHECK:       otherexit:
; CHECK-NEXT:    br label [[OTHEREXITSUCC:%.*]]
; CHECK:       otherexitsucc:
; CHECK-NEXT:    br label [[NOT_ZERO44:%.*]]
; CHECK:       not_zero44:
; CHECK-NEXT:    unreachable
; CHECK:       latchexitsucc:
; CHECK-NEXT:    br label [[NOT_ZERO44]]
;
entry:
  br label %header

header:                                          ; preds = %latch, %entry
  %indvars.iv = phi i64 [ undef, %entry ], [ %indvars.iv.next, %latch ]
  br i1 %c, label %latch, label %otherexit

latch:                                         ; preds = %header
  %indvars.iv.next = add nsw i64 %indvars.iv, 2
  %0 = icmp slt i64 %indvars.iv.next, 616
  br i1 %0, label %header, label %latchexit

latchexit:                                          ; preds = %latch
  br label %latchexitsucc

otherexit:                                 ; preds = %header
  br label %otherexitsucc

otherexitsucc:                                          ; preds = %otherexit
  br label %not_zero44

not_zero44:                                       ; preds = %latchexitsucc, %otherexitsucc
  unreachable

latchexitsucc:                                      ; preds = %latchexit
  br label %not_zero44
}

