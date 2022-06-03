; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -slp-threshold=-1000 -mtriple=x86_64 -S | FileCheck %s

; The inputs to vector phi should remain undef.

define i32 @phi3UndefInput(i1 %cond, i8 %arg0, i8 %arg1, i8 %arg2, i8 %arg3) {
; CHECK-LABEL: @phi3UndefInput(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i8> poison, i8 [[ARG0:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i8> [[TMP0]], i8 [[ARG1:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8> [[TMP1]], i8 [[ARG2:%.*]], i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i8> [[TMP2]], i8 [[ARG3:%.*]], i32 3
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <4 x i8> [ [[TMP3]], [[BB2]] ], [ <i8 0, i8 poison, i8 poison, i8 poison>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = zext <4 x i8> [[TMP4]] to <4 x i32>
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    ret i32 [[TMP6]]
;
entry:
  br i1 %cond, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %phi0 = phi i8 [ %arg0, %bb2 ], [ 0, %entry ]
  %phi1 = phi i8 [ %arg1, %bb2 ], [ undef, %entry ]
  %phi2 = phi i8 [ %arg2, %bb2 ], [ undef, %entry ]
  %phi3 = phi i8 [ %arg3, %bb2 ], [ undef, %entry ]
  %zext0 = zext i8 %phi0 to i32
  %zext1 = zext i8 %phi1 to i32
  %zext2 = zext i8 %phi2 to i32
  %zext3 = zext i8 %phi3 to i32
  %or1 = or i32 %zext0, %zext1
  %or2 = or i32 %or1, %zext2
  %or3 = or i32 %or2, %zext3
  ret i32 %or3
}

define i32 @phi2UndefInput(i1 %cond, i8 %arg0, i8 %arg1, i8 %arg2, i8 %arg3) {
; CHECK-LABEL: @phi2UndefInput(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i8> poison, i8 [[ARG0:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i8> [[TMP0]], i8 [[ARG1:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8> [[TMP1]], i8 [[ARG2:%.*]], i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i8> [[TMP2]], i8 [[ARG3:%.*]], i32 3
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <4 x i8> [ [[TMP3]], [[BB2]] ], [ <i8 0, i8 0, i8 poison, i8 poison>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = zext <4 x i8> [[TMP4]] to <4 x i32>
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    ret i32 [[TMP6]]
;
entry:
  br i1 %cond, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %phi0 = phi i8 [ %arg0, %bb2 ], [ 0, %entry ]
  %phi1 = phi i8 [ %arg1, %bb2 ], [ 0, %entry ]
  %phi2 = phi i8 [ %arg2, %bb2 ], [ undef, %entry ]
  %phi3 = phi i8 [ %arg3, %bb2 ], [ undef, %entry ]
  %zext0 = zext i8 %phi0 to i32
  %zext1 = zext i8 %phi1 to i32
  %zext2 = zext i8 %phi2 to i32
  %zext3 = zext i8 %phi3 to i32
  %or1 = or i32 %zext0, %zext1
  %or2 = or i32 %or1, %zext2
  %or3 = or i32 %or2, %zext3
  ret i32 %or3
}

define i32 @phi1UndefInput(i1 %cond, i8 %arg0, i8 %arg1, i8 %arg2, i8 %arg3) {
; CHECK-LABEL: @phi1UndefInput(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i8> poison, i8 [[ARG0:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i8> [[TMP0]], i8 [[ARG1:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8> [[TMP1]], i8 [[ARG2:%.*]], i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i8> [[TMP2]], i8 [[ARG3:%.*]], i32 3
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <4 x i8> [ [[TMP3]], [[BB2]] ], [ <i8 0, i8 0, i8 0, i8 poison>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = zext <4 x i8> [[TMP4]] to <4 x i32>
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    ret i32 [[TMP6]]
;
entry:
  br i1 %cond, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %phi0 = phi i8 [ %arg0, %bb2 ], [ 0, %entry ]
  %phi1 = phi i8 [ %arg1, %bb2 ], [ 0, %entry ]
  %phi2 = phi i8 [ %arg2, %bb2 ], [ 0, %entry ]
  %phi3 = phi i8 [ %arg3, %bb2 ], [ undef, %entry ]
  %zext0 = zext i8 %phi0 to i32
  %zext1 = zext i8 %phi1 to i32
  %zext2 = zext i8 %phi2 to i32
  %zext3 = zext i8 %phi3 to i32
  %or1 = or i32 %zext0, %zext1
  %or2 = or i32 %or1, %zext2
  %or3 = or i32 %or2, %zext3
  ret i32 %or3
}


define i32 @phi1Undef1PoisonInput(i1 %cond, i8 %arg0, i8 %arg1, i8 %arg2, i8 %arg3) {
; CHECK-LABEL: @phi1Undef1PoisonInput(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i8> poison, i8 [[ARG0:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i8> [[TMP0]], i8 [[ARG1:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8> [[TMP1]], i8 [[ARG2:%.*]], i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i8> [[TMP2]], i8 [[ARG3:%.*]], i32 3
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <4 x i8> [ [[TMP3]], [[BB2]] ], [ <i8 0, i8 0, i8 poison, i8 poison>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = zext <4 x i8> [[TMP4]] to <4 x i32>
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    ret i32 [[TMP6]]
;
entry:
  br i1 %cond, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %phi0 = phi i8 [ %arg0, %bb2 ], [ 0, %entry ]
  %phi1 = phi i8 [ %arg1, %bb2 ], [ 0, %entry ]
  %phi2 = phi i8 [ %arg2, %bb2 ], [ poison, %entry ]
  %phi3 = phi i8 [ %arg3, %bb2 ], [ undef, %entry ]
  %zext0 = zext i8 %phi0 to i32
  %zext1 = zext i8 %phi1 to i32
  %zext2 = zext i8 %phi2 to i32
  %zext3 = zext i8 %phi3 to i32
  %or1 = or i32 %zext0, %zext1
  %or2 = or i32 %or1, %zext2
  %or3 = or i32 %or2, %zext3
  ret i32 %or3
}


define i32 @phi1Undef2PoisonInputs(i1 %cond, i8 %arg0, i8 %arg1, i8 %arg2, i8 %arg3) {
; CHECK-LABEL: @phi1Undef2PoisonInputs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i8> poison, i8 [[ARG1:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i8> [[TMP0]], i8 [[ARG0:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8> [[TMP1]], i8 [[ARG2:%.*]], i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i8> [[TMP2]], i8 [[ARG3:%.*]], i32 3
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <4 x i8> [ [[TMP3]], [[BB2]] ], [ <i8 0, i8 poison, i8 poison, i8 poison>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = zext <4 x i8> [[TMP4]] to <4 x i32>
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    ret i32 [[TMP6]]
;
entry:
  br i1 %cond, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %phi0 = phi i8 [ %arg0, %bb2 ], [ poison, %entry ]
  %phi1 = phi i8 [ %arg1, %bb2 ], [ 0, %entry ]
  %phi2 = phi i8 [ %arg2, %bb2 ], [ poison, %entry ]
  %phi3 = phi i8 [ %arg3, %bb2 ], [ undef, %entry ]
  %zext0 = zext i8 %phi0 to i32
  %zext1 = zext i8 %phi1 to i32
  %zext2 = zext i8 %phi2 to i32
  %zext3 = zext i8 %phi3 to i32
  %or1 = or i32 %zext0, %zext1
  %or2 = or i32 %or1, %zext2
  %or3 = or i32 %or2, %zext3
  ret i32 %or3
}

define i32 @phi1Undef1PoisonGapInput(i1 %cond, i8 %arg0, i8 %arg1, i8 %arg2, i8 %arg3) {
; CHECK-LABEL: @phi1Undef1PoisonGapInput(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i8> poison, i8 [[ARG1:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i8> [[TMP0]], i8 [[ARG3:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8> [[TMP1]], i8 [[ARG0:%.*]], i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i8> [[TMP2]], i8 [[ARG2:%.*]], i32 3
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <4 x i8> [ [[TMP3]], [[BB2]] ], [ <i8 0, i8 0, i8 poison, i8 poison>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = zext <4 x i8> [[TMP4]] to <4 x i32>
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> [[TMP5]])
; CHECK-NEXT:    ret i32 [[TMP6]]
;
entry:
  br i1 %cond, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %phi0 = phi i8 [ %arg0, %bb2 ], [ poison, %entry ]
  %phi1 = phi i8 [ %arg1, %bb2 ], [ 0, %entry ]
  %phi2 = phi i8 [ %arg2, %bb2 ], [ undef, %entry ]
  %phi3 = phi i8 [ %arg3, %bb2 ], [ 0, %entry ]
  %zext0 = zext i8 %phi0 to i32
  %zext1 = zext i8 %phi1 to i32
  %zext2 = zext i8 %phi2 to i32
  %zext3 = zext i8 %phi3 to i32
  %or1 = or i32 %zext0, %zext1
  %or2 = or i32 %or1, %zext2
  %or3 = or i32 %or2, %zext3
  ret i32 %or3
}
