; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -opaque-pointers -S | FileCheck %s

; Test merging GEP of GEP with constant indices.

target datalayout = "i24:8:8"

%struct.A = type { [123 x i8], i32 }
%struct.B = type { i8, [3 x i16], %struct.A, float }
%struct.C = type { i8, i32, i32 }

; result = (i32*) p + 3
define ptr @mergeBasic(ptr %p) {
; CHECK-LABEL: @mergeBasic(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 3
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds i32, ptr %p, i64 1
  %2 = getelementptr inbounds i32, ptr %1, i64 2
  ret ptr %2
}

; Converted to i8* and merged.
; result = (i8*) p + 10
define ptr @mergeDifferentTypes(ptr %p) {
; CHECK-LABEL: @mergeDifferentTypes(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[P:%.*]], i64 10
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds i8, ptr %p, i64 2
  %2 = getelementptr inbounds i64, ptr %1, i64 1
  ret ptr %2
}

; Converted to i8* and merged.
; result = (i8*) p + 10
define ptr @mergeReverse(ptr %p) {
; CHECK-LABEL: @mergeReverse(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[P:%.*]], i64 10
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds i64, ptr %p, i64 1
  %2 = getelementptr inbounds i8, ptr %1, i64 2
  ret ptr %2
}

; Offsets of first and last GEP cancel out.
; result = p
define ptr @zeroSum(ptr %p) {
; CHECK-LABEL: @zeroSum(
; CHECK-NEXT:    ret ptr [[P:%.*]]
;
  %1 = getelementptr inbounds i32, ptr %p, i64 1
  %2 = getelementptr inbounds i8, ptr %1, i64 -4
  ret ptr %2
}

; result = (i8*) (([20 x i8]*) p + 1) + 17
define ptr @array1(ptr %p) {
; CHECK-LABEL: @array1(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [20 x i8], ptr [[P:%.*]], i64 1, i64 17
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds [20 x i8], ptr %p, i64 1, i64 1
  %2 = getelementptr inbounds i64, ptr %1, i64 2
  ret ptr %2
}

; Converted to i8* and merged.
; result = (i8*) p + 20
define ptr @array2(ptr %p) {
; CHECK-LABEL: @array2(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[P:%.*]], i64 20
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds i64, ptr %p, i64 2
  %2 = getelementptr inbounds [3 x i8], ptr %1, i64 1, i64 1
  ret ptr %2
}

; Converted to i8* and merged.
; result = (i8*) p + 36
define ptr @struct1(ptr %p) {
; CHECK-LABEL: @struct1(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[P:%.*]], i64 36
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds i64, ptr %p, i64 3
  %2 = getelementptr inbounds %struct.C, ptr %1, i64 1
  ret ptr %2
}

; result = &((struct.A*) p - 1).member1
define ptr @struct2(ptr %p) {
; CHECK-LABEL: @struct2(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_A:%.*]], ptr [[P:%.*]], i64 -1, i32 1
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds %struct.A, ptr %p, i64 0, i32 1
  %2 = getelementptr inbounds i8, ptr %1, i64 -128
  ret ptr %2
}

; result = (i8*) &((struct.B) p)[0].member2.member0 + 7
define ptr @structStruct(ptr %p) {
; CHECK-LABEL: @structStruct(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_B:%.*]], ptr [[P:%.*]], i64 0, i32 2, i32 0, i64 7
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds %struct.B, ptr %p, i64 0, i32 2, i32 0, i64 3
  %2 = getelementptr inbounds %struct.A, ptr %1, i64 0, i32 0, i64 4
  ret ptr %2
}

; First GEP offset is not divisible by last GEP's source element size, but first
; GEP points to an array such that the last GEP offset is divisible by the
; array's element size, so the first GEP can be rewritten with an extra index.
; result = (i16*) &((struct.B*) p)[i].member1 + 2
define ptr @appendIndex(ptr %p, i64 %i) {
; CHECK-LABEL: @appendIndex(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_B:%.*]], ptr [[P:%.*]], i64 [[I:%.*]], i32 1, i64 2
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds %struct.B, ptr %p, i64 %i, i32 1
  %2 = getelementptr inbounds i32, ptr %1, i64 1
  ret ptr %2
}

; Offset of either GEP is not divisible by the other's size, converted to i8*
; and merged.
; Here i24 is 8-bit aligned.
; result = (i8*) p + 7
define ptr @notDivisible(ptr %p) {
; CHECK-LABEL: @notDivisible(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[P:%.*]], i64 7
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds i24, ptr %p, i64 1
  %2 = getelementptr inbounds i32, ptr %1, i64 1
  ret ptr %2
}

; Negative test. Two GEP should not be merged if not both offsets are constant
; or divisible by the other's size.
define ptr @partialConstant2(ptr %p, i64 %a) {
; CHECK-LABEL: @partialConstant2(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [4 x i64], ptr [[TMP1]], i64 [[A:%.*]], i64 2
; CHECK-NEXT:    ret ptr [[TMP2]]
;
  %1 = getelementptr inbounds i32, ptr %p, i64 1
  %2 = getelementptr inbounds [4 x i64], ptr %1, i64 %a, i64 2
  ret ptr %2
}

; Negative test. Two GEP should not be merged if there is another use of the
; first GEP by the second GEP.
define ptr @partialConstant3(ptr %p) {
; CHECK-LABEL: @partialConstant3(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    [[TMP2:%.*]] = ptrtoint ptr [[TMP1]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [4 x i64], ptr [[TMP1]], i64 [[TMP2]], i64 2
; CHECK-NEXT:    ret ptr [[TMP3]]
;
  %1 = getelementptr inbounds i32, ptr %p, i64 1
  %2 = ptrtoint ptr %1 to i64
  %3 = getelementptr inbounds [4 x i64], ptr %1, i64 %2, i64 2
  ret ptr %3
}

; Two GEP instructions can be merged if one is constant-indexed and the other
; is an aggregate type with a constant last index, and the resulting pointer
; address by adding the constant offset aliases the address of another member.
; result = &((struct.C*) p + a).member2
define ptr @partialConstantMemberAliasing1(ptr %p, i64 %a) {
; CHECK-LABEL: @partialConstantMemberAliasing1(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_C:%.*]], ptr [[P:%.*]], i64 [[A:%.*]], i32 2
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  %1 = getelementptr inbounds %struct.C, ptr %p, i64 %a, i32 1
  %2 = getelementptr inbounds i32, ptr %1, i64 1
  ret ptr %2
}

; Negative test. Similar to above, but the new address does not alias the
; address of another member.
define ptr @partialConstantMemberAliasing2(ptr %p, i64 %a) {
; CHECK-LABEL: @partialConstantMemberAliasing2(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_C:%.*]], ptr [[P:%.*]], i64 [[A:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[TMP1]], i64 1
; CHECK-NEXT:    ret ptr [[TMP2]]
;
  %1 = getelementptr inbounds %struct.C, ptr %p, i64 %a, i32 1
  %2 = getelementptr inbounds i8, ptr %1, i64 1
  ret ptr %2
}

; Negative test. Similar to above, but the new address falls outside the address
; range of the object currently pointed by the non-constant GEP.
define ptr @partialConstantMemberAliasing3(ptr %p, i64 %a) {
; CHECK-LABEL: @partialConstantMemberAliasing3(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_C:%.*]], ptr [[P:%.*]], i64 [[A:%.*]], i32 2
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, ptr [[TMP1]], i64 1
; CHECK-NEXT:    ret ptr [[TMP2]]
;
  %1 = getelementptr inbounds %struct.C, ptr %p, i64 %a, i32 2
  %2 = getelementptr inbounds i32, ptr %1, i64 1
  ret ptr %2
}
