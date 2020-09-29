; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -msan-check-access-address=0 -passes=msan 2>&1 | FileCheck %s
; RUN: opt < %s -S -msan-check-access-address=0 -msan | FileCheck %s
; RUN: opt < %s -S -msan-check-access-address=0 -msan-track-origins=2 -passes=msan 2>&1 | FileCheck %s --check-prefixes=CHECK,ORIGIN
; RUN: opt < %s -S -msan-check-access-address=0 -msan-track-origins=2 -msan | FileCheck %s --check-prefixes=CHECK,ORIGIN

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define <4 x i64> @test_mm256_abs_epi8(<4 x i64> noundef %a) local_unnamed_addr #0 {
; CHECK-LABEL: @test_mm256_abs_epi8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x i64>, <4 x i64>* bitcast ([100 x i64]* @__msan_param_tls to <4 x i64>*), align 8
; ORIGIN-NEXT:   [[TMP1:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__msan_param_origin_tls, i32 0, i32 0), align 4
; CHECK:         call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <4 x i64> [[TMP0]] to <32 x i8>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64> [[A:%.*]] to <32 x i8>
; CHECK-NEXT:    [[TMP4:%.*]] = tail call <32 x i8> @llvm.abs.v32i8(<32 x i8> [[TMP3]], i1 false)
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast <32 x i8> [[TMP2]] to <4 x i64>
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <32 x i8> [[TMP4]] to <4 x i64>
; CHECK-NEXT:    store <4 x i64> [[TMP5]], <4 x i64>* bitcast ([100 x i64]* @__msan_retval_tls to <4 x i64>*), align 8
; ORIGIN-NEXT:   store i32 [[TMP1]], i32* @__msan_retval_origin_tls, align 4
; CHECK:         ret <4 x i64> [[TMP6]]
;
entry:
  %0 = bitcast <4 x i64> %a to <32 x i8>
  %1 = tail call <32 x i8> @llvm.abs.v32i8(<32 x i8> %0, i1 false)
  %2 = bitcast <32 x i8> %1 to <4 x i64>
  ret <4 x i64> %2
}

define <4 x i64> @test_mm256_abs_epi16(<4 x i64> %a) local_unnamed_addr #0 {
; CHECK-LABEL: @test_mm256_abs_epi16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x i64>, <4 x i64>* bitcast ([100 x i64]* @__msan_param_tls to <4 x i64>*), align 8
; ORIGIN-NEXT:   [[TMP1:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__msan_param_origin_tls, i32 0, i32 0), align 4
; CHECK:         call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <4 x i64> [[TMP0]] to <16 x i16>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64> [[A:%.*]] to <16 x i16>
; CHECK-NEXT:    [[TMP4:%.*]] = tail call <16 x i16> @llvm.abs.v16i16(<16 x i16> [[TMP3]], i1 false)
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast <16 x i16> [[TMP2]] to <4 x i64>
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <16 x i16> [[TMP4]] to <4 x i64>
; CHECK-NEXT:    store <4 x i64> [[TMP5]], <4 x i64>* bitcast ([100 x i64]* @__msan_retval_tls to <4 x i64>*), align 8
; ORIGIN-NEXT:   store i32 [[TMP1]], i32* @__msan_retval_origin_tls, align 4
; CHECK:         ret <4 x i64> [[TMP6]]
;
entry:
  %0 = bitcast <4 x i64> %a to <16 x i16>
  %1 = tail call <16 x i16> @llvm.abs.v16i16(<16 x i16> %0, i1 false)
  %2 = bitcast <16 x i16> %1 to <4 x i64>
  ret <4 x i64> %2
}

define <4 x i64> @test_mm256_abs_epi32(<4 x i64> %a) local_unnamed_addr #0 {
; CHECK-LABEL: @test_mm256_abs_epi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x i64>, <4 x i64>* bitcast ([100 x i64]* @__msan_param_tls to <4 x i64>*), align 8
; ORIGIN-NEXT:   [[TMP1:%.*]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__msan_param_origin_tls, i32 0, i32 0), align 4
; CHECK:         call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <4 x i64> [[TMP0]] to <8 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64> [[A:%.*]] to <8 x i32>
; CHECK-NEXT:    [[TMP4:%.*]] = tail call <8 x i32> @llvm.abs.v8i32(<8 x i32> [[TMP3]], i1 false)
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast <8 x i32> [[TMP2]] to <4 x i64>
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <8 x i32> [[TMP4]] to <4 x i64>
; CHECK-NEXT:    store <4 x i64> [[TMP5]], <4 x i64>* bitcast ([100 x i64]* @__msan_retval_tls to <4 x i64>*), align 8
; ORIGIN-NEXT:   store i32 [[TMP1]], i32* @__msan_retval_origin_tls, align 4
; CHECK:         ret <4 x i64> [[TMP6]]
;
entry:
  %0 = bitcast <4 x i64> %a to <8 x i32>
  %1 = tail call <8 x i32> @llvm.abs.v8i32(<8 x i32> %0, i1 false)
  %2 = bitcast <8 x i32> %1 to <4 x i64>
  ret <4 x i64> %2
}

declare <32 x i8> @llvm.abs.v32i8(<32 x i8>, i1 immarg) #1
declare <16 x i16> @llvm.abs.v16i16(<16 x i16>, i1 immarg) #1
declare <8 x i32> @llvm.abs.v8i32(<8 x i32>, i1 immarg) #1

attributes #0 = { nounwind readnone sanitize_memory }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 12.0.0"}
