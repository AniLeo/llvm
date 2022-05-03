; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -slp-vectorizer -opaque-pointers -mcpu=x86-64    -S | FileCheck %s --check-prefixes=SSE
; RUN: opt < %s -mtriple=x86_64-unknown -slp-vectorizer -opaque-pointers -mcpu=x86-64-v2 -S | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -slp-vectorizer -opaque-pointers -mcpu=x86-64-v3 -S | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -mtriple=x86_64-unknown -slp-vectorizer -opaque-pointers -mcpu=x86-64-v4 -S | FileCheck %s --check-prefixes=AVX

define { i64, i64 } @compute_min(ptr nocapture noundef nonnull readonly align 2 dereferenceable(16) %x, ptr nocapture noundef nonnull readonly align 2 dereferenceable(16) %y) {
; SSE-LABEL: @compute_min(
; SSE-NEXT:  entry:
; SSE-NEXT:    [[TMP0:%.*]] = load i16, ptr [[Y:%.*]], align 2
; SSE-NEXT:    [[TMP1:%.*]] = load i16, ptr [[X:%.*]], align 2
; SSE-NEXT:    [[TMP2:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP0]], i16 [[TMP1]])
; SSE-NEXT:    [[ARRAYIDX_I_I_1:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 1
; SSE-NEXT:    [[ARRAYIDX_I_I10_1:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 1
; SSE-NEXT:    [[TMP3:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_1]], align 2
; SSE-NEXT:    [[TMP4:%.*]] = load i16, ptr [[ARRAYIDX_I_I_1]], align 2
; SSE-NEXT:    [[TMP5:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP3]], i16 [[TMP4]])
; SSE-NEXT:    [[ARRAYIDX_I_I_2:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 2
; SSE-NEXT:    [[ARRAYIDX_I_I10_2:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 2
; SSE-NEXT:    [[TMP6:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_2]], align 2
; SSE-NEXT:    [[TMP7:%.*]] = load i16, ptr [[ARRAYIDX_I_I_2]], align 2
; SSE-NEXT:    [[TMP8:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP6]], i16 [[TMP7]])
; SSE-NEXT:    [[ARRAYIDX_I_I_3:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 3
; SSE-NEXT:    [[ARRAYIDX_I_I10_3:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 3
; SSE-NEXT:    [[TMP9:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_3]], align 2
; SSE-NEXT:    [[TMP10:%.*]] = load i16, ptr [[ARRAYIDX_I_I_3]], align 2
; SSE-NEXT:    [[TMP11:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP9]], i16 [[TMP10]])
; SSE-NEXT:    [[ARRAYIDX_I_I_4:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 4
; SSE-NEXT:    [[ARRAYIDX_I_I10_4:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 4
; SSE-NEXT:    [[TMP12:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_4]], align 2
; SSE-NEXT:    [[TMP13:%.*]] = load i16, ptr [[ARRAYIDX_I_I_4]], align 2
; SSE-NEXT:    [[TMP14:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP12]], i16 [[TMP13]])
; SSE-NEXT:    [[ARRAYIDX_I_I_5:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 5
; SSE-NEXT:    [[ARRAYIDX_I_I10_5:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 5
; SSE-NEXT:    [[TMP15:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_5]], align 2
; SSE-NEXT:    [[TMP16:%.*]] = load i16, ptr [[ARRAYIDX_I_I_5]], align 2
; SSE-NEXT:    [[TMP17:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP15]], i16 [[TMP16]])
; SSE-NEXT:    [[ARRAYIDX_I_I_6:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 6
; SSE-NEXT:    [[ARRAYIDX_I_I10_6:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 6
; SSE-NEXT:    [[TMP18:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_6]], align 2
; SSE-NEXT:    [[TMP19:%.*]] = load i16, ptr [[ARRAYIDX_I_I_6]], align 2
; SSE-NEXT:    [[TMP20:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP18]], i16 [[TMP19]])
; SSE-NEXT:    [[ARRAYIDX_I_I_7:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 7
; SSE-NEXT:    [[ARRAYIDX_I_I10_7:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 7
; SSE-NEXT:    [[TMP21:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_7]], align 2
; SSE-NEXT:    [[TMP22:%.*]] = load i16, ptr [[ARRAYIDX_I_I_7]], align 2
; SSE-NEXT:    [[TMP23:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP21]], i16 [[TMP22]])
; SSE-NEXT:    [[RETVAL_SROA_4_0_INSERT_EXT:%.*]] = zext i16 [[TMP11]] to i64
; SSE-NEXT:    [[RETVAL_SROA_4_0_INSERT_SHIFT:%.*]] = shl nuw i64 [[RETVAL_SROA_4_0_INSERT_EXT]], 48
; SSE-NEXT:    [[RETVAL_SROA_3_0_INSERT_EXT:%.*]] = zext i16 [[TMP8]] to i64
; SSE-NEXT:    [[RETVAL_SROA_3_0_INSERT_SHIFT:%.*]] = shl nuw nsw i64 [[RETVAL_SROA_3_0_INSERT_EXT]], 32
; SSE-NEXT:    [[RETVAL_SROA_3_0_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_4_0_INSERT_SHIFT]], [[RETVAL_SROA_3_0_INSERT_SHIFT]]
; SSE-NEXT:    [[RETVAL_SROA_2_0_INSERT_EXT:%.*]] = zext i16 [[TMP5]] to i64
; SSE-NEXT:    [[RETVAL_SROA_2_0_INSERT_SHIFT:%.*]] = shl nuw nsw i64 [[RETVAL_SROA_2_0_INSERT_EXT]], 16
; SSE-NEXT:    [[RETVAL_SROA_2_0_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_3_0_INSERT_INSERT]], [[RETVAL_SROA_2_0_INSERT_SHIFT]]
; SSE-NEXT:    [[RETVAL_SROA_0_0_INSERT_EXT:%.*]] = zext i16 [[TMP2]] to i64
; SSE-NEXT:    [[RETVAL_SROA_0_0_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_2_0_INSERT_INSERT]], [[RETVAL_SROA_0_0_INSERT_EXT]]
; SSE-NEXT:    [[DOTFCA_0_INSERT:%.*]] = insertvalue { i64, i64 } poison, i64 [[RETVAL_SROA_0_0_INSERT_INSERT]], 0
; SSE-NEXT:    [[RETVAL_SROA_9_8_INSERT_EXT:%.*]] = zext i16 [[TMP23]] to i64
; SSE-NEXT:    [[RETVAL_SROA_9_8_INSERT_SHIFT:%.*]] = shl nuw i64 [[RETVAL_SROA_9_8_INSERT_EXT]], 48
; SSE-NEXT:    [[RETVAL_SROA_8_8_INSERT_EXT:%.*]] = zext i16 [[TMP20]] to i64
; SSE-NEXT:    [[RETVAL_SROA_8_8_INSERT_SHIFT:%.*]] = shl nuw nsw i64 [[RETVAL_SROA_8_8_INSERT_EXT]], 32
; SSE-NEXT:    [[RETVAL_SROA_8_8_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_9_8_INSERT_SHIFT]], [[RETVAL_SROA_8_8_INSERT_SHIFT]]
; SSE-NEXT:    [[RETVAL_SROA_7_8_INSERT_EXT:%.*]] = zext i16 [[TMP17]] to i64
; SSE-NEXT:    [[RETVAL_SROA_7_8_INSERT_SHIFT:%.*]] = shl nuw nsw i64 [[RETVAL_SROA_7_8_INSERT_EXT]], 16
; SSE-NEXT:    [[RETVAL_SROA_7_8_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_8_8_INSERT_INSERT]], [[RETVAL_SROA_7_8_INSERT_SHIFT]]
; SSE-NEXT:    [[RETVAL_SROA_5_8_INSERT_EXT:%.*]] = zext i16 [[TMP14]] to i64
; SSE-NEXT:    [[RETVAL_SROA_5_8_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_7_8_INSERT_INSERT]], [[RETVAL_SROA_5_8_INSERT_EXT]]
; SSE-NEXT:    [[DOTFCA_1_INSERT:%.*]] = insertvalue { i64, i64 } [[DOTFCA_0_INSERT]], i64 [[RETVAL_SROA_5_8_INSERT_INSERT]], 1
; SSE-NEXT:    ret { i64, i64 } [[DOTFCA_1_INSERT]]
;
; AVX-LABEL: @compute_min(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[TMP0:%.*]] = load i16, ptr [[Y:%.*]], align 2
; AVX-NEXT:    [[TMP1:%.*]] = load i16, ptr [[X:%.*]], align 2
; AVX-NEXT:    [[TMP2:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP0]], i16 [[TMP1]])
; AVX-NEXT:    [[ARRAYIDX_I_I_1:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 1
; AVX-NEXT:    [[ARRAYIDX_I_I10_1:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 1
; AVX-NEXT:    [[TMP3:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_1]], align 2
; AVX-NEXT:    [[TMP4:%.*]] = load i16, ptr [[ARRAYIDX_I_I_1]], align 2
; AVX-NEXT:    [[TMP5:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP3]], i16 [[TMP4]])
; AVX-NEXT:    [[ARRAYIDX_I_I_2:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 2
; AVX-NEXT:    [[ARRAYIDX_I_I10_2:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 2
; AVX-NEXT:    [[ARRAYIDX_I_I_4:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 4
; AVX-NEXT:    [[ARRAYIDX_I_I10_4:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 4
; AVX-NEXT:    [[TMP6:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_4]], align 2
; AVX-NEXT:    [[TMP7:%.*]] = load i16, ptr [[ARRAYIDX_I_I_4]], align 2
; AVX-NEXT:    [[TMP8:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP6]], i16 [[TMP7]])
; AVX-NEXT:    [[ARRAYIDX_I_I_5:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 5
; AVX-NEXT:    [[ARRAYIDX_I_I10_5:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 5
; AVX-NEXT:    [[TMP9:%.*]] = load i16, ptr [[ARRAYIDX_I_I10_5]], align 2
; AVX-NEXT:    [[TMP10:%.*]] = load i16, ptr [[ARRAYIDX_I_I_5]], align 2
; AVX-NEXT:    [[TMP11:%.*]] = tail call i16 @llvm.smin.i16(i16 [[TMP9]], i16 [[TMP10]])
; AVX-NEXT:    [[ARRAYIDX_I_I_6:%.*]] = getelementptr inbounds [8 x i16], ptr [[X]], i64 0, i64 6
; AVX-NEXT:    [[ARRAYIDX_I_I10_6:%.*]] = getelementptr inbounds [8 x i16], ptr [[Y]], i64 0, i64 6
; AVX-NEXT:    [[TMP12:%.*]] = load <2 x i16>, ptr [[ARRAYIDX_I_I10_2]], align 2
; AVX-NEXT:    [[TMP13:%.*]] = load <2 x i16>, ptr [[ARRAYIDX_I_I_2]], align 2
; AVX-NEXT:    [[TMP14:%.*]] = call <2 x i16> @llvm.smin.v2i16(<2 x i16> [[TMP12]], <2 x i16> [[TMP13]])
; AVX-NEXT:    [[TMP15:%.*]] = zext <2 x i16> [[TMP14]] to <2 x i64>
; AVX-NEXT:    [[TMP16:%.*]] = shl nuw <2 x i64> [[TMP15]], <i64 32, i64 48>
; AVX-NEXT:    [[TMP17:%.*]] = extractelement <2 x i64> [[TMP16]], i32 0
; AVX-NEXT:    [[TMP18:%.*]] = extractelement <2 x i64> [[TMP16]], i32 1
; AVX-NEXT:    [[RETVAL_SROA_3_0_INSERT_INSERT:%.*]] = or i64 [[TMP18]], [[TMP17]]
; AVX-NEXT:    [[RETVAL_SROA_2_0_INSERT_EXT:%.*]] = zext i16 [[TMP5]] to i64
; AVX-NEXT:    [[RETVAL_SROA_2_0_INSERT_SHIFT:%.*]] = shl nuw nsw i64 [[RETVAL_SROA_2_0_INSERT_EXT]], 16
; AVX-NEXT:    [[RETVAL_SROA_2_0_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_3_0_INSERT_INSERT]], [[RETVAL_SROA_2_0_INSERT_SHIFT]]
; AVX-NEXT:    [[RETVAL_SROA_0_0_INSERT_EXT:%.*]] = zext i16 [[TMP2]] to i64
; AVX-NEXT:    [[RETVAL_SROA_0_0_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_2_0_INSERT_INSERT]], [[RETVAL_SROA_0_0_INSERT_EXT]]
; AVX-NEXT:    [[DOTFCA_0_INSERT:%.*]] = insertvalue { i64, i64 } poison, i64 [[RETVAL_SROA_0_0_INSERT_INSERT]], 0
; AVX-NEXT:    [[TMP19:%.*]] = load <2 x i16>, ptr [[ARRAYIDX_I_I10_6]], align 2
; AVX-NEXT:    [[TMP20:%.*]] = load <2 x i16>, ptr [[ARRAYIDX_I_I_6]], align 2
; AVX-NEXT:    [[TMP21:%.*]] = call <2 x i16> @llvm.smin.v2i16(<2 x i16> [[TMP19]], <2 x i16> [[TMP20]])
; AVX-NEXT:    [[TMP22:%.*]] = zext <2 x i16> [[TMP21]] to <2 x i64>
; AVX-NEXT:    [[TMP23:%.*]] = shl nuw <2 x i64> [[TMP22]], <i64 32, i64 48>
; AVX-NEXT:    [[TMP24:%.*]] = extractelement <2 x i64> [[TMP23]], i32 0
; AVX-NEXT:    [[TMP25:%.*]] = extractelement <2 x i64> [[TMP23]], i32 1
; AVX-NEXT:    [[RETVAL_SROA_8_8_INSERT_INSERT:%.*]] = or i64 [[TMP25]], [[TMP24]]
; AVX-NEXT:    [[RETVAL_SROA_7_8_INSERT_EXT:%.*]] = zext i16 [[TMP11]] to i64
; AVX-NEXT:    [[RETVAL_SROA_7_8_INSERT_SHIFT:%.*]] = shl nuw nsw i64 [[RETVAL_SROA_7_8_INSERT_EXT]], 16
; AVX-NEXT:    [[RETVAL_SROA_7_8_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_8_8_INSERT_INSERT]], [[RETVAL_SROA_7_8_INSERT_SHIFT]]
; AVX-NEXT:    [[RETVAL_SROA_5_8_INSERT_EXT:%.*]] = zext i16 [[TMP8]] to i64
; AVX-NEXT:    [[RETVAL_SROA_5_8_INSERT_INSERT:%.*]] = or i64 [[RETVAL_SROA_7_8_INSERT_INSERT]], [[RETVAL_SROA_5_8_INSERT_EXT]]
; AVX-NEXT:    [[DOTFCA_1_INSERT:%.*]] = insertvalue { i64, i64 } [[DOTFCA_0_INSERT]], i64 [[RETVAL_SROA_5_8_INSERT_INSERT]], 1
; AVX-NEXT:    ret { i64, i64 } [[DOTFCA_1_INSERT]]
;
entry:
  %0 = load i16, ptr %y, align 2
  %1 = load i16, ptr %x, align 2
  %2 = tail call i16 @llvm.smin.i16(i16 %0, i16 %1)
  %arrayidx.i.i.1 = getelementptr inbounds [8 x i16], ptr %x, i64 0, i64 1
  %arrayidx.i.i10.1 = getelementptr inbounds [8 x i16], ptr %y, i64 0, i64 1
  %3 = load i16, ptr %arrayidx.i.i10.1, align 2
  %4 = load i16, ptr %arrayidx.i.i.1, align 2
  %5 = tail call i16 @llvm.smin.i16(i16 %3, i16 %4)
  %arrayidx.i.i.2 = getelementptr inbounds [8 x i16], ptr %x, i64 0, i64 2
  %arrayidx.i.i10.2 = getelementptr inbounds [8 x i16], ptr %y, i64 0, i64 2
  %6 = load i16, ptr %arrayidx.i.i10.2, align 2
  %7 = load i16, ptr %arrayidx.i.i.2, align 2
  %8 = tail call i16 @llvm.smin.i16(i16 %6, i16 %7)
  %arrayidx.i.i.3 = getelementptr inbounds [8 x i16], ptr %x, i64 0, i64 3
  %arrayidx.i.i10.3 = getelementptr inbounds [8 x i16], ptr %y, i64 0, i64 3
  %9 = load i16, ptr %arrayidx.i.i10.3, align 2
  %10 = load i16, ptr %arrayidx.i.i.3, align 2
  %11 = tail call i16 @llvm.smin.i16(i16 %9, i16 %10)
  %arrayidx.i.i.4 = getelementptr inbounds [8 x i16], ptr %x, i64 0, i64 4
  %arrayidx.i.i10.4 = getelementptr inbounds [8 x i16], ptr %y, i64 0, i64 4
  %12 = load i16, ptr %arrayidx.i.i10.4, align 2
  %13 = load i16, ptr %arrayidx.i.i.4, align 2
  %14 = tail call i16 @llvm.smin.i16(i16 %12, i16 %13)
  %arrayidx.i.i.5 = getelementptr inbounds [8 x i16], ptr %x, i64 0, i64 5
  %arrayidx.i.i10.5 = getelementptr inbounds [8 x i16], ptr %y, i64 0, i64 5
  %15 = load i16, ptr %arrayidx.i.i10.5, align 2
  %16 = load i16, ptr %arrayidx.i.i.5, align 2
  %17 = tail call i16 @llvm.smin.i16(i16 %15, i16 %16)
  %arrayidx.i.i.6 = getelementptr inbounds [8 x i16], ptr %x, i64 0, i64 6
  %arrayidx.i.i10.6 = getelementptr inbounds [8 x i16], ptr %y, i64 0, i64 6
  %18 = load i16, ptr %arrayidx.i.i10.6, align 2
  %19 = load i16, ptr %arrayidx.i.i.6, align 2
  %20 = tail call i16 @llvm.smin.i16(i16 %18, i16 %19)
  %arrayidx.i.i.7 = getelementptr inbounds [8 x i16], ptr %x, i64 0, i64 7
  %arrayidx.i.i10.7 = getelementptr inbounds [8 x i16], ptr %y, i64 0, i64 7
  %21 = load i16, ptr %arrayidx.i.i10.7, align 2
  %22 = load i16, ptr %arrayidx.i.i.7, align 2
  %23 = tail call i16 @llvm.smin.i16(i16 %21, i16 %22)
  %retval.sroa.4.0.insert.ext = zext i16 %11 to i64
  %retval.sroa.4.0.insert.shift = shl nuw i64 %retval.sroa.4.0.insert.ext, 48
  %retval.sroa.3.0.insert.ext = zext i16 %8 to i64
  %retval.sroa.3.0.insert.shift = shl nuw nsw i64 %retval.sroa.3.0.insert.ext, 32
  %retval.sroa.3.0.insert.insert = or i64 %retval.sroa.4.0.insert.shift, %retval.sroa.3.0.insert.shift
  %retval.sroa.2.0.insert.ext = zext i16 %5 to i64
  %retval.sroa.2.0.insert.shift = shl nuw nsw i64 %retval.sroa.2.0.insert.ext, 16
  %retval.sroa.2.0.insert.insert = or i64 %retval.sroa.3.0.insert.insert, %retval.sroa.2.0.insert.shift
  %retval.sroa.0.0.insert.ext = zext i16 %2 to i64
  %retval.sroa.0.0.insert.insert = or i64 %retval.sroa.2.0.insert.insert, %retval.sroa.0.0.insert.ext
  %.fca.0.insert = insertvalue { i64, i64 } poison, i64 %retval.sroa.0.0.insert.insert, 0
  %retval.sroa.9.8.insert.ext = zext i16 %23 to i64
  %retval.sroa.9.8.insert.shift = shl nuw i64 %retval.sroa.9.8.insert.ext, 48
  %retval.sroa.8.8.insert.ext = zext i16 %20 to i64
  %retval.sroa.8.8.insert.shift = shl nuw nsw i64 %retval.sroa.8.8.insert.ext, 32
  %retval.sroa.8.8.insert.insert = or i64 %retval.sroa.9.8.insert.shift, %retval.sroa.8.8.insert.shift
  %retval.sroa.7.8.insert.ext = zext i16 %17 to i64
  %retval.sroa.7.8.insert.shift = shl nuw nsw i64 %retval.sroa.7.8.insert.ext, 16
  %retval.sroa.7.8.insert.insert = or i64 %retval.sroa.8.8.insert.insert, %retval.sroa.7.8.insert.shift
  %retval.sroa.5.8.insert.ext = zext i16 %14 to i64
  %retval.sroa.5.8.insert.insert = or i64 %retval.sroa.7.8.insert.insert, %retval.sroa.5.8.insert.ext
  %.fca.1.insert = insertvalue { i64, i64 } %.fca.0.insert, i64 %retval.sroa.5.8.insert.insert, 1
  ret { i64, i64 } %.fca.1.insert
}
declare i16 @llvm.smin.i16(i16, i16)
