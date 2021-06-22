; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -mtriple=aarch64 -slp-vectorizer | FileCheck %s

%struct.buf = type { [8 x i8] }

define i8 @reduce_xor(%struct.buf* %a, %struct.buf* %b) {
; CHECK-LABEL: @reduce_xor(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [[STRUCT_BUF:%.*]], %struct.buf* [[A:%.*]], i64 0, i32 0, i64 0
; CHECK-NEXT:    [[TMP0:%.*]] = load i8, i8* [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B:%.*]], i64 0, i32 0, i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[ARRAYIDX3]], align 1
; CHECK-NEXT:    [[AND12:%.*]] = and i8 [[TMP1]], [[TMP0]]
; CHECK-NEXT:    [[ARRAYIDX_1:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 1
; CHECK-NEXT:    [[TMP2:%.*]] = load i8, i8* [[ARRAYIDX_1]], align 1
; CHECK-NEXT:    [[ARRAYIDX3_1:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i8, i8* [[ARRAYIDX3_1]], align 1
; CHECK-NEXT:    [[AND12_1:%.*]] = and i8 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i8 [[AND12]], [[AND12_1]]
; CHECK-NEXT:    [[ARRAYIDX_2:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 2
; CHECK-NEXT:    [[TMP5:%.*]] = load i8, i8* [[ARRAYIDX_2]], align 1
; CHECK-NEXT:    [[ARRAYIDX3_2:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 2
; CHECK-NEXT:    [[TMP6:%.*]] = load i8, i8* [[ARRAYIDX3_2]], align 1
; CHECK-NEXT:    [[AND12_2:%.*]] = and i8 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = xor i8 [[TMP4]], [[AND12_2]]
; CHECK-NEXT:    [[ARRAYIDX_3:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 3
; CHECK-NEXT:    [[TMP8:%.*]] = load i8, i8* [[ARRAYIDX_3]], align 1
; CHECK-NEXT:    [[ARRAYIDX3_3:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 3
; CHECK-NEXT:    [[TMP9:%.*]] = load i8, i8* [[ARRAYIDX3_3]], align 1
; CHECK-NEXT:    [[AND12_3:%.*]] = and i8 [[TMP9]], [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = xor i8 [[TMP7]], [[AND12_3]]
; CHECK-NEXT:    [[ARRAYIDX_4:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 4
; CHECK-NEXT:    [[TMP11:%.*]] = load i8, i8* [[ARRAYIDX_4]], align 1
; CHECK-NEXT:    [[ARRAYIDX3_4:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 4
; CHECK-NEXT:    [[TMP12:%.*]] = load i8, i8* [[ARRAYIDX3_4]], align 1
; CHECK-NEXT:    [[AND12_4:%.*]] = and i8 [[TMP12]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = xor i8 [[TMP10]], [[AND12_4]]
; CHECK-NEXT:    [[ARRAYIDX_5:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 5
; CHECK-NEXT:    [[TMP14:%.*]] = load i8, i8* [[ARRAYIDX_5]], align 1
; CHECK-NEXT:    [[ARRAYIDX3_5:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 5
; CHECK-NEXT:    [[TMP15:%.*]] = load i8, i8* [[ARRAYIDX3_5]], align 1
; CHECK-NEXT:    [[AND12_5:%.*]] = and i8 [[TMP15]], [[TMP14]]
; CHECK-NEXT:    [[TMP16:%.*]] = xor i8 [[TMP13]], [[AND12_5]]
; CHECK-NEXT:    [[ARRAYIDX_6:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 6
; CHECK-NEXT:    [[TMP17:%.*]] = load i8, i8* [[ARRAYIDX_6]], align 1
; CHECK-NEXT:    [[ARRAYIDX3_6:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 6
; CHECK-NEXT:    [[TMP18:%.*]] = load i8, i8* [[ARRAYIDX3_6]], align 1
; CHECK-NEXT:    [[AND12_6:%.*]] = and i8 [[TMP18]], [[TMP17]]
; CHECK-NEXT:    [[TMP19:%.*]] = xor i8 [[TMP16]], [[AND12_6]]
; CHECK-NEXT:    [[ARRAYIDX_7:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[A]], i64 0, i32 0, i64 7
; CHECK-NEXT:    [[TMP20:%.*]] = load i8, i8* [[ARRAYIDX_7]], align 1
; CHECK-NEXT:    [[ARRAYIDX3_7:%.*]] = getelementptr inbounds [[STRUCT_BUF]], %struct.buf* [[B]], i64 0, i32 0, i64 7
; CHECK-NEXT:    [[TMP21:%.*]] = load i8, i8* [[ARRAYIDX3_7]], align 1
; CHECK-NEXT:    [[AND12_7:%.*]] = and i8 [[TMP21]], [[TMP20]]
; CHECK-NEXT:    [[TMP22:%.*]] = xor i8 [[TMP19]], [[AND12_7]]
; CHECK-NEXT:    [[XOR13_7:%.*]] = xor i8 [[TMP22]], 1
; CHECK-NEXT:    ret i8 [[XOR13_7]]
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
