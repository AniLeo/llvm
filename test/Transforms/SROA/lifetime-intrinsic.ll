; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sroa -S | FileCheck %s

%i32x2 = type { [2 x i32] }

; Note %arr is the union
; union {
;   int i[2];
;   short s[4];
; };

define i16 @with_lifetime(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @with_lifetime(
; CHECK-NEXT:    [[ARR_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i32 [[A:%.*]] to i16
; CHECK-NEXT:    [[ARR_SROA_4_4_EXTRACT_TRUNC:%.*]] = trunc i32 [[B:%.*]] to i16
; CHECK-NEXT:    [[RET:%.*]] = add i16 [[ARR_SROA_0_0_EXTRACT_TRUNC]], [[ARR_SROA_4_4_EXTRACT_TRUNC]]
; CHECK-NEXT:    ret i16 [[RET]]
;
  %arr = alloca %i32x2, align 4
  %p = bitcast %i32x2* %arr to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %p)
  %p0 = getelementptr inbounds %i32x2, %i32x2* %arr, i64 0, i32 0, i32 0
  %p1 = getelementptr inbounds %i32x2, %i32x2* %arr, i64 0, i32 0, i32 1
  store i32 %a, i32* %p0, align 4
  store i32 %b, i32* %p1, align 4
  %p0_i16 = bitcast %i32x2* %arr to i16*
  %s0 = load i16, i16* %p0_i16, align 4
  %p1_i16 = bitcast i32* %p1 to i16*
  %s2 = load i16, i16* %p1_i16, align 4
  %ret = add i16 %s0, %s2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %p)
  ret i16 %ret
}

define i16 @no_lifetime(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @no_lifetime(
; CHECK-NEXT:    [[ARR_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i32 [[A:%.*]] to i16
; CHECK-NEXT:    [[ARR_SROA_2_0_EXTRACT_SHIFT:%.*]] = lshr i32 [[A]], 16
; CHECK-NEXT:    [[ARR_SROA_2_0_EXTRACT_TRUNC:%.*]] = trunc i32 [[ARR_SROA_2_0_EXTRACT_SHIFT]] to i16
; CHECK-NEXT:    [[ARR_SROA_21_4_EXTRACT_TRUNC:%.*]] = trunc i32 [[B:%.*]] to i16
; CHECK-NEXT:    [[ARR_SROA_4_4_EXTRACT_SHIFT:%.*]] = lshr i32 [[B]], 16
; CHECK-NEXT:    [[ARR_SROA_4_4_EXTRACT_TRUNC:%.*]] = trunc i32 [[ARR_SROA_4_4_EXTRACT_SHIFT]] to i16
; CHECK-NEXT:    [[RET:%.*]] = add i16 [[ARR_SROA_0_0_EXTRACT_TRUNC]], [[ARR_SROA_21_4_EXTRACT_TRUNC]]
; CHECK-NEXT:    ret i16 [[RET]]
;
  %arr = alloca %i32x2, align 4
  %p0 = getelementptr inbounds %i32x2, %i32x2* %arr, i64 0, i32 0, i32 0
  %p1 = getelementptr inbounds %i32x2, %i32x2* %arr, i64 0, i32 0, i32 1
  store i32 %a, i32* %p0, align 4
  store i32 %b, i32* %p1, align 4
  %p0_i16 = bitcast %i32x2* %arr to i16*
  %s0 = load i16, i16* %p0_i16, align 4
  %p1_i16 = bitcast i32* %p1 to i16*
  %s2 = load i16, i16* %p1_i16, align 4
  %ret = add i16 %s0, %s2
  ret i16 %ret
}

declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { alwaysinline nounwind }
attributes #1 = { argmemonly nounwind }
