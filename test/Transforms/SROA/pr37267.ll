; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sroa -S | FileCheck %s
target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-n32:64-S128"
target triple = "sparcv9-sun-solaris"

; PR37267
; Check that we don't crash on this test.

define i16 @f1() {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[RC:%.*]] = add i16 2, 2
; CHECK-NEXT:    ret i16 [[RC]]
;

bb1:
; This 12-byte alloca is split into partitions as [0,2), [2,4), [4,8), [8,10), [10, 12).
; The reported error happened when rewriteIntegerStore try to widen a split tail of slice 1 for [4, 8) partition.
; alloca  012345678901
; slice 1:  WWWW
; slice 2:        WWWW
; slice 3:        RR
; slice 4:  RR

  %a.3 = alloca [6 x i16], align 1
; slice 1: [2,6)
  %_tmp3 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 1
  store i32 131074, ptr %_tmp3, align 1
; slice 2: [8,12)
  %_tmp8 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 4
  store i32 131074, ptr %_tmp8, align 1
; slice 3: [8,10)
  %_tmp12 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 4
  %_tmp13 = load i16, ptr %_tmp12, align 1
; slice 4: [2,4)
  %_tmp15 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 1
  %_tmp16 = load i16, ptr %_tmp15, align 1

  %rc = add i16 %_tmp13, %_tmp16
  ret i16 %rc
}

define i16 @f2() {
; CHECK-LABEL: @f2(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[A_3_SROA_2_2_INSERT_EXT:%.*]] = zext i16 undef to i32
; CHECK-NEXT:    [[A_3_SROA_2_2_INSERT_MASK:%.*]] = and i32 undef, -65536
; CHECK-NEXT:    [[A_3_SROA_2_2_INSERT_INSERT:%.*]] = or i32 [[A_3_SROA_2_2_INSERT_MASK]], [[A_3_SROA_2_2_INSERT_EXT]]
; CHECK-NEXT:    [[A_3_SROA_0_2_INSERT_EXT:%.*]] = zext i16 undef to i32
; CHECK-NEXT:    [[A_3_SROA_0_2_INSERT_SHIFT:%.*]] = shl i32 [[A_3_SROA_0_2_INSERT_EXT]], 16
; CHECK-NEXT:    [[A_3_SROA_0_2_INSERT_MASK:%.*]] = and i32 [[A_3_SROA_2_2_INSERT_INSERT]], 65535
; CHECK-NEXT:    [[A_3_SROA_0_2_INSERT_INSERT:%.*]] = or i32 [[A_3_SROA_0_2_INSERT_MASK]], [[A_3_SROA_0_2_INSERT_SHIFT]]
; CHECK-NEXT:    [[RC:%.*]] = add i16 2, undef
; CHECK-NEXT:    ret i16 [[RC]]
;

bb1:
; This 12-byte alloca is split into partitions as [0,2), [2,4), [4,8), [8,10), [10, 12).
; The reported error happened when visitLoadInst rewrites a split tail of slice 1 for [4, 8) partition.
; alloca  012345678901
; slice 1:  RRRR
; slice 2:        WWWW
; slice 3:        RR
; slice 4:  RR

  %a.3 = alloca [6 x i16], align 1
; slice 1: [2,6)
  %_tmp3 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 1
  %_tmp6 = load i32, ptr %_tmp3, align 1
; slice 2: [8,12)
  %_tmp8 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 4
  store i32 131074, ptr %_tmp8, align 1
; slice 3: [8,10)
  %_tmp12 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 4
  %_tmp13 = load i16, ptr %_tmp12, align 1
; slice 4: [2,4)
  %_tmp15 = getelementptr inbounds [6 x i16], ptr %a.3, i16 0, i16 1
  %_tmp16 = load i16, ptr %_tmp15, align 1

  %rc = add i16 %_tmp13, %_tmp16
  ret i16 %rc
}
