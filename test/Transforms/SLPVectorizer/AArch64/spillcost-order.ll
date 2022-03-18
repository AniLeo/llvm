; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S %s | FileCheck %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-ios13.0.0"

declare i1 @cond()
declare i32* @get_ptr()

define void @test(i64* %ptr, i64* noalias %res) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[CALL_I_I:%.*]] = call i32* @get_ptr()
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i32, i32* [[CALL_I_I]], i32 2
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr i32, i32* [[CALL_I_I]], i32 1
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr i32, i32* [[CALL_I_I]], i32 3
; CHECK-NEXT:    [[RES_1:%.*]] = getelementptr i64, i64* [[RES:%.*]], i64 1
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[CALL_I_I]] to <2 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i32>, <2 x i32>* [[TMP0]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[GEP_1]] to <2 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x i32>, <2 x i32>* [[TMP2]], align 2
; CHECK-NEXT:    [[TMP4:%.*]] = zext <2 x i32> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = zext <2 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    [[TMP6:%.*]] = sub nsw <2 x i64> [[TMP4]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i64* [[RES]] to <2 x i64>*
; CHECK-NEXT:    store <2 x i64> [[TMP6]], <2 x i64>* [[TMP7]], align 8
; CHECK-NEXT:    [[C:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C]], label [[FOR_BODY]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                  ; preds = %for.body, %entry
  %call.i.i = call i32* @get_ptr()
  %l.0.0 = load i32, i32* %call.i.i, align 2
  %gep.1 = getelementptr i32, i32* %call.i.i, i32 2
  %l.1.0 = load i32, i32* %gep.1, align 2
  %ext.0.0 = zext i32 %l.0.0 to i64
  %ext.1.0 = zext i32 %l.1.0 to i64
  %sub.1 = sub nsw i64 %ext.0.0, %ext.1.0

  %gep.2 = getelementptr i32, i32* %call.i.i, i32 1
  %l.0.1 = load i32, i32* %gep.2, align 2
  %gep.3 = getelementptr i32, i32* %call.i.i, i32 3
  %l.1.1 = load i32, i32* %gep.3, align 2
  %ext.0.1 = zext i32 %l.0.1 to i64
  %ext.1.1 = zext i32 %l.1.1 to i64
  %sub.2 = sub nsw i64 %ext.0.1, %ext.1.1

  store i64 %sub.1, i64* %res
  %res.1 = getelementptr i64, i64* %res, i64 1
  store i64 %sub.2, i64* %res.1

  %c = call i1 @cond()
  br i1 %c, label %for.body, label %exit

exit:
  ret void
}
