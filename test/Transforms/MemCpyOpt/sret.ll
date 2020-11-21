; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -memcpyopt -S -enable-memcpyopt-memoryssa=0 | FileCheck %s
; RUN: opt < %s -basic-aa -memcpyopt -S -enable-memcpyopt-memoryssa=1 -verify-memoryssa | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"
target triple = "i686-apple-darwin9"

%0 = type { x86_fp80, x86_fp80 }

define void @ccosl(%0* noalias sret(%0) %agg.result, %0* byval(%0) align 8 %z) nounwind {
; CHECK-LABEL: @ccosl(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IZ:%.*]] = alloca [[TMP0:%.*]], align 16
; CHECK-NEXT:    [[MEMTMP:%.*]] = alloca [[TMP0]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [[TMP0]], %0* [[Z:%.*]], i32 0, i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = load x86_fp80, x86_fp80* [[TMP1]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = fsub x86_fp80 0xK80000000000000000000, [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr [[TMP0]], %0* [[IZ]], i32 0, i32 1
; CHECK-NEXT:    [[REAL:%.*]] = getelementptr [[TMP0]], %0* [[IZ]], i32 0, i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr [[TMP0]], %0* [[Z]], i32 0, i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = load x86_fp80, x86_fp80* [[TMP7]], align 16
; CHECK-NEXT:    store x86_fp80 [[TMP3]], x86_fp80* [[REAL]], align 16
; CHECK-NEXT:    store x86_fp80 [[TMP8]], x86_fp80* [[TMP4]], align 16
; CHECK-NEXT:    call void @ccoshl(%0* noalias sret(%0) [[AGG_RESULT:%.*]], %0* byval(%0) align 8 [[IZ]]) [[ATTR0:#.*]]
; CHECK-NEXT:    [[MEMTMP14:%.*]] = bitcast %0* [[MEMTMP]] to i8*
; CHECK-NEXT:    [[AGG_RESULT15:%.*]] = bitcast %0* [[AGG_RESULT]] to i8*
; CHECK-NEXT:    ret void
;
entry:
  %iz = alloca %0
  %memtmp = alloca %0, align 16
  %tmp1 = getelementptr %0, %0* %z, i32 0, i32 1
  %tmp2 = load x86_fp80, x86_fp80* %tmp1, align 16
  %tmp3 = fsub x86_fp80 0xK80000000000000000000, %tmp2
  %tmp4 = getelementptr %0, %0* %iz, i32 0, i32 1
  %real = getelementptr %0, %0* %iz, i32 0, i32 0
  %tmp7 = getelementptr %0, %0* %z, i32 0, i32 0
  %tmp8 = load x86_fp80, x86_fp80* %tmp7, align 16
  store x86_fp80 %tmp3, x86_fp80* %real, align 16
  store x86_fp80 %tmp8, x86_fp80* %tmp4, align 16
  call void @ccoshl(%0* noalias sret(%0) %memtmp, %0* byval(%0) align 8 %iz) nounwind
  %memtmp14 = bitcast %0* %memtmp to i8*
  %agg.result15 = bitcast %0* %agg.result to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %agg.result15, i8* align 16 %memtmp14, i32 32, i1 false)
  ret void
}

declare void @ccoshl(%0* noalias nocapture sret(%0), %0* byval(%0)) nounwind

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1) nounwind
