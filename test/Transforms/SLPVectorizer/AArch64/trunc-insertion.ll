; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -disable-verify -slp-vectorizer -S | FileCheck %s
target triple = "aarch64-unknown-linux-gnu"
@d = internal unnamed_addr global i32 5, align 4

define dso_local void @l() local_unnamed_addr {
; CHECK-LABEL: @l(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP0:%.*]] = phi <2 x i16> [ undef, [[BB:%.*]] ], [ [[TMP12:%.*]], [[BB25:%.*]] ]
; CHECK-NEXT:    br i1 undef, label [[BB3:%.*]], label [[BB11:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    [[I4:%.*]] = zext i1 undef to i32
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i16> [[TMP0]], undef
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ugt <2 x i16> [[TMP1]], <i16 8, i16 8>
; CHECK-NEXT:    [[TMP3:%.*]] = zext <2 x i1> [[TMP2]] to <2 x i32>
; CHECK-NEXT:    br label [[BB25]]
; CHECK:       bb11:
; CHECK-NEXT:    [[I12:%.*]] = zext i1 undef to i32
; CHECK-NEXT:    [[TMP4:%.*]] = xor <2 x i16> [[TMP0]], undef
; CHECK-NEXT:    [[TMP5:%.*]] = sext <2 x i16> [[TMP4]] to <2 x i64>
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ule <2 x i64> undef, [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = zext <2 x i1> [[TMP6]] to <2 x i32>
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ult <2 x i32> undef, [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = zext <2 x i1> [[TMP8]] to <2 x i32>
; CHECK-NEXT:    br label [[BB25]]
; CHECK:       bb25:
; CHECK-NEXT:    [[I28:%.*]] = phi i32 [ [[I12]], [[BB11]] ], [ [[I4]], [[BB3]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = phi <2 x i32> [ [[TMP9]], [[BB11]] ], [ [[TMP3]], [[BB3]] ]
; CHECK-NEXT:    [[TMP11:%.*]] = trunc <2 x i32> [[TMP10]] to <2 x i8>
; CHECK-NEXT:    [[TMP12]] = phi <2 x i16> [ [[TMP4]], [[BB11]] ], [ [[TMP1]], [[BB3]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x i8> [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = zext i8 [[TMP13]] to i32
; CHECK-NEXT:    [[I31:%.*]] = and i32 undef, [[TMP14]]
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x i8> [[TMP11]], i32 1
; CHECK-NEXT:    [[TMP16:%.*]] = zext i8 [[TMP15]] to i32
; CHECK-NEXT:    [[I32:%.*]] = and i32 [[I31]], [[TMP16]]
; CHECK-NEXT:    [[I33:%.*]] = and i32 [[I32]], [[I28]]
; CHECK-NEXT:    br i1 undef, label [[BB34:%.*]], label [[BB1]]
; CHECK:       bb34:
; CHECK-NEXT:    [[I35:%.*]] = phi i32 [ [[I33]], [[BB25]] ]
; CHECK-NEXT:    br label [[BB36:%.*]]
; CHECK:       bb36:
; CHECK-NEXT:    store i32 [[I35]], i32* @d, align 4
; CHECK-NEXT:    ret void
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb25, %bb
  %i = phi i16 [ undef, %bb ], [ %i29, %bb25 ]
  %i2 = phi i16 [ undef, %bb ], [ %i30, %bb25 ]
  br i1 undef, label %bb3, label %bb11

bb3:                                              ; preds = %bb1
  %i4 = zext i1 undef to i32
  %i5 = xor i16 %i2, undef
  %i6 = icmp ugt i16 %i5, 8
  %i7 = zext i1 %i6 to i32
  %i8 = xor i16 %i, undef
  %i9 = icmp ugt i16 %i8, 8
  %i10 = zext i1 %i9 to i32
  br label %bb25

bb11:                                             ; preds = %bb1
  %i12 = zext i1 undef to i32
  %i13 = xor i16 %i2, undef
  %i14 = sext i16 %i13 to i64
  %i15 = icmp ule i64 undef, %i14
  %i16 = zext i1 %i15 to i32
  %i17 = icmp ult i32 undef, %i16
  %i18 = zext i1 %i17 to i32
  %i19 = xor i16 %i, undef
  %i20 = sext i16 %i19 to i64
  %i21 = icmp ule i64 undef, %i20
  %i22 = zext i1 %i21 to i32
  %i23 = icmp ult i32 undef, %i22
  %i24 = zext i1 %i23 to i32
  br label %bb25

bb25:                                             ; preds = %bb11, %bb3
  %i26 = phi i32 [ %i24, %bb11 ], [ %i10, %bb3 ]
  %i27 = phi i32 [ %i18, %bb11 ], [ %i7, %bb3 ]
  %i28 = phi i32 [ %i12, %bb11 ], [ %i4, %bb3 ]
  %i29 = phi i16 [ %i19, %bb11 ], [ %i8, %bb3 ]
  %i30 = phi i16 [ %i13, %bb11 ], [ %i5, %bb3 ]
  %i31 = and i32 undef, %i26
  %i32 = and i32 %i31, %i27
  %i33 = and i32 %i32, %i28
  br i1 undef, label %bb34, label %bb1

bb34:                                             ; preds = %bb25
  %i35 = phi i32 [ %i33, %bb25 ]
  br label %bb36

bb36:                                             ; preds = %bb34
  store i32 %i35, i32* @d, align 4
  ret void
}
