; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -instcombine -S < %s | FileCheck %s

%struct.test = type { i8, [3 x i8] }

define i32 @get(%struct.test* nocapture readonly %arg) {
; CHECK-LABEL: @get(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[I:%.*]] = getelementptr inbounds [[STRUCT_TEST:%.*]], %struct.test* [[ARG:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[I1:%.*]] = load i8, i8* [[I]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[I1]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8 [[TMP0]], 0
; CHECK-NEXT:    [[I9:%.*]] = zext i1 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[I9]]
;
bb:
  %i = getelementptr inbounds %struct.test, %struct.test* %arg, i64 0, i32 0
  %i1 = load i8, i8* %i, align 4
  %i2 = and i8 %i1, 1
  %i3 = icmp eq i8 %i2, 0
  br i1 %i3, label %bb4, label %bb8

bb4:
  %i5 = lshr i8 %i1, 1
  %i6 = and i8 %i5, 1
  %i7 = zext i8 %i6 to i32
  br label %bb8

bb8:
  %i9 = phi i32 [ 1, %bb ], [ %i7, %bb4 ]
  ret i32 %i9
}
