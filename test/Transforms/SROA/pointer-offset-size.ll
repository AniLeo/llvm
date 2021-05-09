; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -sroa -S | FileCheck %s
target datalayout = "e-p:64:64:64:32"

%struct.test = type { %struct.basic, %struct.basic }
%struct.basic = type { i16, i8 }

define i16 @test(%struct.test* %ts2.i) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[S_SROA_0:%.*]] = alloca [3 x i8], align 8
; CHECK-NEXT:    [[S_SROA_0_0__SROA_CAST:%.*]] = bitcast %struct.test* [[TS2_I:%.*]] to i8*
; CHECK-NEXT:    [[S_SROA_0_0__SROA_IDX:%.*]] = getelementptr inbounds [3 x i8], [3 x i8]* [[S_SROA_0]], i32 0, i32 0
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 [[S_SROA_0_0__SROA_CAST]], i8* align 8 [[S_SROA_0_0__SROA_IDX]], i32 3, i1 false)
; CHECK-NEXT:    [[X1_I_I:%.*]] = getelementptr inbounds [[STRUCT_TEST:%.*]], %struct.test* [[TS2_I]], i32 0, i32 0, i32 0
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* [[X1_I_I]], align 2
; CHECK-NEXT:    ret i16 [[TMP0]]
;
entry:
  %s = alloca %struct.test
  %0 = bitcast %struct.test* %ts2.i to i8*
  %1 = bitcast %struct.test* %s to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %0, i8* %1, i32 3, i1 false)
  %x1.i.i = getelementptr inbounds %struct.test, %struct.test* %ts2.i, i32 0, i32 0, i32 0
  %2 = load i16, i16* %x1.i.i
  ret i16 %2
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1)
