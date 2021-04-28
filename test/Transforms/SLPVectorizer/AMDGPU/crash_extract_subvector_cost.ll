; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -slp-vectorizer %s | FileCheck %s

define <2 x i16> @uadd_sat_v9i16_combine_vi16(<9 x i16> %arg0, <9 x i16> %arg1) {
; CHECK-LABEL: @uadd_sat_v9i16_combine_vi16(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[ARG0_1:%.*]] = extractelement <9 x i16> undef, i64 7
; CHECK-NEXT:    [[ARG0_2:%.*]] = extractelement <9 x i16> [[ARG0:%.*]], i64 8
; CHECK-NEXT:    [[ARG1_1:%.*]] = extractelement <9 x i16> [[ARG1:%.*]], i64 7
; CHECK-NEXT:    [[ARG1_2:%.*]] = extractelement <9 x i16> [[ARG1]], i64 8
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i16> poison, i16 [[ARG0_1]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i16> [[TMP0]], i16 [[ARG0_2]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i16> poison, i16 [[ARG1_1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x i16> [[TMP2]], i16 [[ARG1_2]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = call <2 x i16> @llvm.uadd.sat.v2i16(<2 x i16> [[TMP1]], <2 x i16> [[TMP3]])
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x i16> [[TMP4]], i32 0
; CHECK-NEXT:    [[INS_1:%.*]] = insertelement <2 x i16> undef, i16 [[TMP5]], i64 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x i16> [[TMP4]], i32 1
; CHECK-NEXT:    [[INS_2:%.*]] = insertelement <2 x i16> [[INS_1]], i16 [[TMP6]], i64 1
; CHECK-NEXT:    ret <2 x i16> [[INS_2]]
;
bb:
  %arg0.1 = extractelement <9 x i16> undef, i64 7
  %arg0.2 = extractelement <9 x i16> %arg0, i64 8
  %arg1.1 = extractelement <9 x i16> %arg1, i64 7
  %arg1.2 = extractelement <9 x i16> %arg1, i64 8
  %add.1 = call i16 @llvm.uadd.sat.i16(i16 %arg0.1, i16 %arg1.1)
  %add.2 = call i16 @llvm.uadd.sat.i16(i16 %arg0.2, i16 %arg1.2)
  %ins.1 = insertelement <2 x i16> undef, i16 %add.1, i64 0
  %ins.2 = insertelement <2 x i16> %ins.1, i16 %add.2, i64 1
  ret <2 x i16> %ins.2
}

declare i16 @llvm.uadd.sat.i16(i16, i16) #0
attributes #0 = { nounwind readnone speculatable willreturn }
