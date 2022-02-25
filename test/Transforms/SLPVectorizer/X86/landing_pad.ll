; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer,verify -slp-threshold=-99999 -S | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"

define void @foo() personality i32* ()* @bar {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2.loopexit:
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP0:%.*]] = phi <4 x i32> [ [[SHUFFLE:%.*]], [[BB9:%.*]] ], [ poison, [[BB2_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x i32> [ [[TMP5:%.*]], [[BB6:%.*]] ], [ poison, [[BB1:%.*]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = invoke i32 poison(i8 addrspace(1)* nonnull poison, i32 0, i32 0, i32 poison) [ "deopt"() ]
; CHECK-NEXT:    to label [[BB4:%.*]] unwind label [[BB10:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    br i1 poison, label [[BB11:%.*]], label [[BB5:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    br label [[BB7:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[TMP3:%.*]] = phi <2 x i32> [ <i32 0, i32 poison>, [[BB8:%.*]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x i32> [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP5]] = insertelement <2 x i32> poison, i32 [[TMP4]], i32 1
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb7:
; CHECK-NEXT:    [[LOCAL_5_84111:%.*]] = phi i32 [ poison, [[BB8]] ], [ poison, [[BB5]] ]
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i32> poison, i32 [[LOCAL_5_84111]], i32 1
; CHECK-NEXT:    [[TMP7:%.*]] = invoke i32 poison(i8 addrspace(1)* nonnull poison, i32 poison, i32 poison, i32 poison) [ "deopt"() ]
; CHECK-NEXT:    to label [[BB8]] unwind label [[BB12:%.*]]
; CHECK:       bb8:
; CHECK-NEXT:    br i1 poison, label [[BB7]], label [[BB6]]
; CHECK:       bb9:
; CHECK-NEXT:    [[INDVARS_IV528799:%.*]] = phi i64 [ poison, [[BB10]] ], [ poison, [[BB12]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = phi <2 x i32> [ [[SHUFFLE1:%.*]], [[BB10]] ], [ [[TMP11:%.*]], [[BB12]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <2 x i32> [[TMP8]], <2 x i32> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[SHUFFLE]] = shufflevector <4 x i32> [[TMP9]], <4 x i32> poison, <4 x i32> <i32 undef, i32 undef, i32 0, i32 1>
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb10:
; CHECK-NEXT:    [[TMP10:%.*]] = phi <2 x i32> [ [[TMP1]], [[BB3]] ]
; CHECK-NEXT:    [[LANDING_PAD68:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    [[SHUFFLE1]] = shufflevector <2 x i32> [[TMP10]], <2 x i32> poison, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:    br label [[BB9]]
; CHECK:       bb11:
; CHECK-NEXT:    ret void
; CHECK:       bb12:
; CHECK-NEXT:    [[TMP11]] = phi <2 x i32> [ [[TMP6]], [[BB7]] ]
; CHECK-NEXT:    [[LANDING_PAD149:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    br label [[BB9]]
;
bb1:
  br label %bb3

bb2.loopexit:
  br label %bb2

bb2:
  %local_8_3681 = phi i32 [ poison, %bb9 ], [ 1, %bb2.loopexit ]
  %local_2_44 = phi i32 [ poison, %bb9 ], [ poison, %bb2.loopexit ]
  %local_5_47 = phi i32 [ %local_5_19, %bb9 ], [ poison, %bb2.loopexit ]
  %local_10_52 = phi i32 [ %local_10_24, %bb9 ], [ poison, %bb2.loopexit ]
  ret void

bb3:
  %local_10_38123 = phi i32 [ %.lcssa773, %bb6 ], [ poison, %bb1 ]
  %local_5_33118 = phi i32 [ poison, %bb6 ], [ poison, %bb1 ]
  %0 = invoke i32 poison(i8 addrspace(1)* nonnull poison, i32 0, i32 0, i32 poison) [ "deopt"() ]
  to label %bb4 unwind label %bb10

bb4:
  br i1 poison, label %bb11, label %bb5

bb5:
  br label %bb7

bb6:
  %.lcssa773 = phi i32 [ poison, %bb8 ]
  %.lcssa770 = phi i32 [ 0, %bb8 ]
  br label %bb3

bb7:
  %local_5_84111 = phi i32 [ poison, %bb8 ], [ poison, %bb5 ]
  %1 = invoke i32 poison(i8 addrspace(1)* nonnull poison, i32 poison, i32 poison, i32 poison) [ "deopt"() ]
  to label %bb8 unwind label %bb12

bb8:
  br i1 poison, label %bb7, label %bb6

bb9:
  %indvars.iv528799 = phi i64 [ poison, %bb10 ], [ poison, %bb12 ]
  %local_5_19 = phi i32 [ %local_5_33118.lcssa, %bb10 ], [ %local_5_84111.lcssa, %bb12 ]
  %local_10_24 = phi i32 [ %local_10_38123.lcssa, %bb10 ], [ %local_10_89113.lcssa, %bb12 ]
  br label %bb2

bb10:
  %local_10_38123.lcssa = phi i32 [ %local_10_38123, %bb3 ]
  %local_5_33118.lcssa = phi i32 [ %local_5_33118, %bb3 ]
  %landing_pad68 = landingpad { i8*, i32 }
  cleanup
  br label %bb9

bb11:
  ret void

bb12:
  %local_10_89113.lcssa = phi i32 [ poison, %bb7 ]
  %local_5_84111.lcssa = phi i32 [ %local_5_84111, %bb7 ]
  %landing_pad149 = landingpad { i8*, i32 }
  cleanup
  br label %bb9
}

declare i32* @bar()


