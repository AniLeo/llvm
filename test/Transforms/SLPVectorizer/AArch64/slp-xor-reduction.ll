; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -mtriple=aarch64 -slp-vectorizer | FileCheck %s

%struct.buf = type { [8 x i8] }

define i8 @reduce_xor(%struct.buf* %a, %struct.buf* %b) {
; CHECK-LABEL: @reduce_xor(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [[STRUCT_BUF:%.*]], %struct.buf* [[A:%.*]], i64 0, i32 0, i64 0
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B:%.*]], i64 0, i32 0, i64 0
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 1
; CHECK-NEXT:    [[ARRAYIDX3_1:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 1
; CHECK-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 2
; CHECK-NEXT:    [[ARRAYIDX3_2:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 2
; CHECK-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 3
; CHECK-NEXT:    [[ARRAYIDX3_3:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 3
; CHECK-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 4
; CHECK-NEXT:    [[ARRAYIDX3_4:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 4
; CHECK-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 5
; CHECK-NEXT:    [[ARRAYIDX3_5:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 5
; CHECK-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 6
; CHECK-NEXT:    [[ARRAYIDX3_6:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 6
; CHECK-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 7
; CHECK-NEXT:    [[ARRAYIDX3_7:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 7
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[ARRAYIDX]] to <8 x i8>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x i8>, <8 x i8>* [[TMP0]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[ARRAYIDX3]] to <8 x i8>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <8 x i8>, <8 x i8>* [[TMP2]], align 1
; CHECK-NEXT:    [[TMP4:%.*]] = and <8 x i8> [[TMP3]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i8 @llvm.vector.reduce.xor.v8i8(<8 x i8> [[TMP4]])
; CHECK-NEXT:    [[OP_EXTRA:%.*]] = xor i8 [[TMP5]], 1
; CHECK-NEXT:    ret i8 [[OP_EXTRA]]
;
entry:
  %arrayidx = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 0
  %0 = load i8, i8* %arrayidx, align 1
  %arrayidx3 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 0
  %1 = load i8, i8* %arrayidx3, align 1
  %and12 = and i8 %1, %0
  %arrayidx.1 = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 1
  %2 = load i8, i8* %arrayidx.1, align 1
  %arrayidx3.1 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 1
  %3 = load i8, i8* %arrayidx3.1, align 1
  %and12.1 = and i8 %3, %2
  %4 = xor i8 %and12, %and12.1
  %arrayidx.2 = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 2
  %5 = load i8, i8* %arrayidx.2, align 1
  %arrayidx3.2 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 2
  %6 = load i8, i8* %arrayidx3.2, align 1
  %and12.2 = and i8 %6, %5
  %7 = xor i8 %4, %and12.2
  %arrayidx.3 = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 3
  %8 = load i8, i8* %arrayidx.3, align 1
  %arrayidx3.3 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 3
  %9 = load i8, i8* %arrayidx3.3, align 1
  %and12.3 = and i8 %9, %8
  %10 = xor i8 %7, %and12.3
  %arrayidx.4 = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 4
  %11 = load i8, i8* %arrayidx.4, align 1
  %arrayidx3.4 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 4
  %12 = load i8, i8* %arrayidx3.4, align 1
  %and12.4 = and i8 %12, %11
  %13 = xor i8 %10, %and12.4
  %arrayidx.5 = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 5
  %14 = load i8, i8* %arrayidx.5, align 1
  %arrayidx3.5 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 5
  %15 = load i8, i8* %arrayidx3.5, align 1
  %and12.5 = and i8 %15, %14
  %16 = xor i8 %13, %and12.5
  %arrayidx.6 = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 6
  %17 = load i8, i8* %arrayidx.6, align 1
  %arrayidx3.6 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 6
  %18 = load i8, i8* %arrayidx3.6, align 1
  %and12.6 = and i8 %18, %17
  %19 = xor i8 %16, %and12.6
  %arrayidx.7 = getelementptr inbounds %struct.buf, %struct.buf* %a, i64 0, i32 0, i64 7
  %20 = load i8, i8* %arrayidx.7, align 1
  %arrayidx3.7 = getelementptr inbounds %struct.buf, %struct.buf* %b, i64 0, i32 0, i64 7
  %21 = load i8, i8* %arrayidx3.7, align 1
  %and12.7 = and i8 %21, %20
  %22 = xor i8 %19, %and12.7
  %xor13.7 = xor i8 %22, 1
  ret i8 %xor13.7
}
