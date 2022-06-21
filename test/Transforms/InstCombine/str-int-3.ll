; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Verify that calls to atoi and related conversion functions with members
; of constant structs as arguments are folded to constants as expected.
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare i32 @atoi(i8*)
declare i64 @atol(i8*)
declare i64 @atoll(i8*)

declare i64 @strtol(i8*, i8**, i32)
declare i64 @strtoll(i8*, i8**, i32)

%struct.A = type { [4 x i8], [5 x i8], [7 x i8] }

@a = constant [2 x %struct.A] [%struct.A { [4 x i8] c"1\00\00\00", [5 x i8] c"12\00\00\00", [7 x i8] c"56789\00\00" }, %struct.A { [4 x i8] c"123\00", [5 x i8] c"1234\00", [7 x i8] c"67890\00\00" }]


; Fold atoi(a[I].M) for constant I in [0, 1] and member M in [a, b]
; to a constant.

define void @fold_atoi_member(i32* %pi) {
; CHECK-LABEL: @fold_atoi_member(
; CHECK-NEXT:    store i32 1, i32* [[PI:%.*]], align 4
; CHECK-NEXT:    [[PIA0B:%.*]] = getelementptr i32, i32* [[PI]], i64 1
; CHECK-NEXT:    store i32 12, i32* [[PIA0B]], align 4
; CHECK-NEXT:    [[PIA1A:%.*]] = getelementptr i32, i32* [[PI]], i64 2
; CHECK-NEXT:    store i32 123, i32* [[PIA1A]], align 4
; CHECK-NEXT:    [[PIA1B:%.*]] = getelementptr i32, i32* [[PI]], i64 3
; CHECK-NEXT:    store i32 1234, i32* [[PIA1B]], align 4
; CHECK-NEXT:    ret void
;
; Fold atoi(a[0].a) to 1.
  %pa0a = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 0, i64 0
  %ia0a = call i32 @atoi(i8* %pa0a)
  %pia0a = getelementptr i32, i32* %pi, i32 0
  store i32 %ia0a, i32* %pia0a

; Fold atoi(a[0].b) to 12.
  %pa0b = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 1, i64 0
  %ia0b = call i32 @atoi(i8* %pa0b)
  %pia0b = getelementptr i32, i32* %pi, i32 1
  store i32 %ia0b, i32* %pia0b

; Fold atoi(a[1].a) to 123.
  %pa1a = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 0, i64 0
  %ia1a = call i32 @atoi(i8* %pa1a)
  %pia1a = getelementptr i32, i32* %pi, i32 2
  store i32 %ia1a, i32* %pia1a

; Fold atoi(a[1].b) to 1234.
  %pa1b = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 1, i64 0
  %ia1b = call i32 @atoi(i8* %pa1b)
  %pia1b = getelementptr i32, i32* %pi, i32 3
  store i32 %ia1b, i32* %pia1b

  ret void
}


; Do not fold atoi with an excessive offset.  It's undefined so folding
; it (e.g., to zero) would be valid and might prevent crashes or returning
; a bogus value but could also prevent detecting the bug by sanitizers.

define void @call_atoi_offset_out_of_bounds(i32* %pi) {
; CHECK-LABEL: @call_atoi_offset_out_of_bounds(
; CHECK-NEXT:    [[IA_0_0_32:%.*]] = call i32 @atoi(i8* getelementptr inbounds ([2 x %struct.A], [2 x %struct.A]* @a, i64 1, i64 0, i32 0, i64 0))
; CHECK-NEXT:    store i32 [[IA_0_0_32]], i32* [[PI:%.*]], align 4
; CHECK-NEXT:    [[IA_0_0_33:%.*]] = call i32 @atoi(i8* getelementptr ([2 x %struct.A], [2 x %struct.A]* @a, i64 1, i64 0, i32 0, i64 1))
; CHECK-NEXT:    store i32 [[IA_0_0_33]], i32* [[PI]], align 4
; CHECK-NEXT:    ret void
;
; Do not fold atoi((const char*)a + sizeof a).
  %pa_0_0_32 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 0, i64 32
  %ia_0_0_32 = call i32 @atoi(i8* %pa_0_0_32)
  %pia_0_0_32 = getelementptr i32, i32* %pi, i32 0
  store i32 %ia_0_0_32, i32* %pia_0_0_32

; Likewise, do not fold atoi((const char*)a + sizeof a + 1).
  %pa_0_0_33 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 0, i64 33
  %ia_0_0_33 = call i32 @atoi(i8* %pa_0_0_33)
  %pia_0_0_33 = getelementptr i32, i32* %pi, i32 0
  store i32 %ia_0_0_33, i32* %pia_0_0_33

  ret void
}


; Fold atol(a[I].M) for constant I in [0, 1] and member M in [a, b, c]
; to a constant.

define void @fold_atol_member(i64* %pi) {
; CHECK-LABEL: @fold_atol_member(
; CHECK-NEXT:    store i64 1, i64* [[PI:%.*]], align 4
; CHECK-NEXT:    [[PIA0B:%.*]] = getelementptr i64, i64* [[PI]], i64 1
; CHECK-NEXT:    store i64 12, i64* [[PIA0B]], align 4
; CHECK-NEXT:    [[PIA0C:%.*]] = getelementptr i64, i64* [[PI]], i64 2
; CHECK-NEXT:    store i64 56789, i64* [[PIA0C]], align 4
; CHECK-NEXT:    [[PIA1A:%.*]] = getelementptr i64, i64* [[PI]], i64 3
; CHECK-NEXT:    store i64 123, i64* [[PIA1A]], align 4
; CHECK-NEXT:    [[PIA1B:%.*]] = getelementptr i64, i64* [[PI]], i64 4
; CHECK-NEXT:    store i64 1234, i64* [[PIA1B]], align 4
; CHECK-NEXT:    [[PIA1C:%.*]] = getelementptr i64, i64* [[PI]], i64 5
; CHECK-NEXT:    store i64 67890, i64* [[PIA1C]], align 4
; CHECK-NEXT:    ret void
;
; Fold atol(a[0].a) to 1.
  %pa0a = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 0, i64 0
  %ia0a = call i64 @atol(i8* %pa0a)
  %pia0a = getelementptr i64, i64* %pi, i32 0
  store i64 %ia0a, i64* %pia0a

; Fold atol(a[0].b) to 12.
  %pa0b = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 1, i64 0
  %ia0b = call i64 @atol(i8* %pa0b)
  %pia0b = getelementptr i64, i64* %pi, i32 1
  store i64 %ia0b, i64* %pia0b

; Fold atol(a[0].c) to 56789.
  %pa0c = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 2, i64 0
  %ia0c = call i64 @atol(i8* %pa0c)
  %pia0c = getelementptr i64, i64* %pi, i32 2
  store i64 %ia0c, i64* %pia0c

; Fold atol(a[1].a) to 123.
  %pa1a = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 0, i64 0
  %ia1a = call i64 @atol(i8* %pa1a)
  %pia1a = getelementptr i64, i64* %pi, i32 3
  store i64 %ia1a, i64* %pia1a

; Fold atol(a[1].b) to 1234.
  %pa1b = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 1, i64 0
  %ia1b = call i64 @atol(i8* %pa1b)
  %pia1b = getelementptr i64, i64* %pi, i32 4
  store i64 %ia1b, i64* %pia1b

; Fold atol(a[1].c) to 67890.
  %pa1c = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 2, i64 0
  %ia1c = call i64 @atol(i8* %pa1c)
  %pia1c = getelementptr i64, i64* %pi, i32 5
  store i64 %ia1c, i64* %pia1c

  ret void
}


; Fold atoll(a[I].M + C) for constant I in [0, 1], member M in [a, b, c],
; and C in a valid range to a constant.

define void @fold_atoll_member_pC(i64* %pi) {
; CHECK-LABEL: @fold_atoll_member_pC(
; CHECK-NEXT:    store i64 1, i64* [[PI:%.*]], align 4
; CHECK-NEXT:    [[PIA0BP1:%.*]] = getelementptr i64, i64* [[PI]], i64 1
; CHECK-NEXT:    store i64 2, i64* [[PIA0BP1]], align 4
; CHECK-NEXT:    [[PIA0CP3:%.*]] = getelementptr i64, i64* [[PI]], i64 2
; CHECK-NEXT:    store i64 89, i64* [[PIA0CP3]], align 4
; CHECK-NEXT:    [[PIA1AP2:%.*]] = getelementptr i64, i64* [[PI]], i64 3
; CHECK-NEXT:    store i64 3, i64* [[PIA1AP2]], align 4
; CHECK-NEXT:    [[PIA1BP3:%.*]] = getelementptr i64, i64* [[PI]], i64 4
; CHECK-NEXT:    store i64 4, i64* [[PIA1BP3]], align 4
; CHECK-NEXT:    [[PIA1CP4:%.*]] = getelementptr i64, i64* [[PI]], i64 5
; CHECK-NEXT:    store i64 0, i64* [[PIA1CP4]], align 4
; CHECK-NEXT:    ret void
;
; Fold atoll(a[0].a) to 1.
  %pa0a = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 0, i64 0
  %ia0a = call i64 @atol(i8* %pa0a)
  %pia0a = getelementptr i64, i64* %pi, i32 0
  store i64 %ia0a, i64* %pia0a

; Fold atoll(a[0].b + 1) to 2.
  %pa0bp1 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 1, i64 1
  %ia0bp1 = call i64 @atol(i8* %pa0bp1)
  %pia0bp1 = getelementptr i64, i64* %pi, i32 1
  store i64 %ia0bp1, i64* %pia0bp1

; Fold atoll(a[0].c + 3) to 89.
  %pa0cp3 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 2, i64 3
  %ia0cp3 = call i64 @atol(i8* %pa0cp3)
  %pia0cp3 = getelementptr i64, i64* %pi, i32 2
  store i64 %ia0cp3, i64* %pia0cp3

; Fold atoll(a[1].a + 2) to 3.
  %pa1ap2 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 0, i64 2
  %ia1ap2 = call i64 @atol(i8* %pa1ap2)
  %pia1ap2 = getelementptr i64, i64* %pi, i32 3
  store i64 %ia1ap2, i64* %pia1ap2

; Fold atoll(a[1].b + 3) to 4.
  %pa1bp3 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 1, i64 3
  %ia1bp3 = call i64 @atol(i8* %pa1bp3)
  %pia1bp3 = getelementptr i64, i64* %pi, i32 4
  store i64 %ia1bp3, i64* %pia1bp3

; Fold atoll(a[1].c + 4) to 0.
  %pa1cp4 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 2, i64 4
  %ia1cp4 = call i64 @atol(i8* %pa1cp4)
  %pia1cp4 = getelementptr i64, i64* %pi, i32 5
  store i64 %ia1cp4, i64* %pia1cp4

  ret void
}


; Fold strtol(a[I].M + C, 0, 0) for constant I in [0, 1], member M in [a, b, c],
; and C in a valid range to a constant.

define void @fold_strtol_member_pC(i64* %pi) {
; CHECK-LABEL: @fold_strtol_member_pC(
; CHECK-NEXT:    store i64 1, i64* [[PI:%.*]], align 4
; CHECK-NEXT:    [[PIA0BP1:%.*]] = getelementptr i64, i64* [[PI]], i64 1
; CHECK-NEXT:    store i64 2, i64* [[PIA0BP1]], align 4
; CHECK-NEXT:    [[PIA0CP3:%.*]] = getelementptr i64, i64* [[PI]], i64 2
; CHECK-NEXT:    store i64 89, i64* [[PIA0CP3]], align 4
; CHECK-NEXT:    [[PIA1AP2:%.*]] = getelementptr i64, i64* [[PI]], i64 3
; CHECK-NEXT:    store i64 3, i64* [[PIA1AP2]], align 4
; CHECK-NEXT:    [[PIA1BP3:%.*]] = getelementptr i64, i64* [[PI]], i64 4
; CHECK-NEXT:    store i64 4, i64* [[PIA1BP3]], align 4
; CHECK-NEXT:    [[PIA1CP4:%.*]] = getelementptr i64, i64* [[PI]], i64 5
; CHECK-NEXT:    store i64 0, i64* [[PIA1CP4]], align 4
; CHECK-NEXT:    ret void
;
; Fold strtol(a[0].a, 0, 0) to 1.
  %pa0a = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 0, i64 0
  %ia0a = call i64 @strtol(i8* %pa0a, i8** null, i32 0)
  %pia0a = getelementptr i64, i64* %pi, i32 0
  store i64 %ia0a, i64* %pia0a

; Fold strtol(a[0].b + 1, 0, 0, i8** null, i32 0) to 2.
  %pa0bp1 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 1, i64 1
  %ia0bp1 = call i64 @strtol(i8* %pa0bp1, i8** null, i32 0)
  %pia0bp1 = getelementptr i64, i64* %pi, i32 1
  store i64 %ia0bp1, i64* %pia0bp1

; Fold strtol(a[0].c + 3, 0, 0, i8** null, i32 0) to 89.
  %pa0cp3 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 2, i64 3
  %ia0cp3 = call i64 @strtol(i8* %pa0cp3, i8** null, i32 0)
  %pia0cp3 = getelementptr i64, i64* %pi, i32 2
  store i64 %ia0cp3, i64* %pia0cp3

; Fold strtol(a[1].a + 2, 0, 0, i8** null, i32 0) to 3.
  %pa1ap2 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 0, i64 2
  %ia1ap2 = call i64 @strtol(i8* %pa1ap2, i8** null, i32 0)
  %pia1ap2 = getelementptr i64, i64* %pi, i32 3
  store i64 %ia1ap2, i64* %pia1ap2

; Fold strtol(a[1].b + 3, 0, 0, i8** null, i32 0) to 4.
  %pa1bp3 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 1, i64 3
  %ia1bp3 = call i64 @strtol(i8* %pa1bp3, i8** null, i32 0)
  %pia1bp3 = getelementptr i64, i64* %pi, i32 4
  store i64 %ia1bp3, i64* %pia1bp3

; Fold strtol(a[1].c + 4, 0, 0, i8** null, i32 0) to 0.
  %pa1cp4 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 2, i64 4
  %ia1cp4 = call i64 @strtol(i8* %pa1cp4, i8** null, i32 0)
  %pia1cp4 = getelementptr i64, i64* %pi, i32 5
  store i64 %ia1cp4, i64* %pia1cp4

  ret void
}


; Fold strtoll(a[I].M + C, 0, 0) for constant I in [0, 1], member M
; in [a, b, c], and C in a valid range to a constant.

define void @fold_strtoll_member_pC(i64* %pi) {
; CHECK-LABEL: @fold_strtoll_member_pC(
; CHECK-NEXT:    store i64 1, i64* [[PI:%.*]], align 4
; CHECK-NEXT:    [[PIA0BP1:%.*]] = getelementptr i64, i64* [[PI]], i64 1
; CHECK-NEXT:    store i64 2, i64* [[PIA0BP1]], align 4
; CHECK-NEXT:    [[PIA0CP3:%.*]] = getelementptr i64, i64* [[PI]], i64 2
; CHECK-NEXT:    store i64 89, i64* [[PIA0CP3]], align 4
; CHECK-NEXT:    [[PIA1AP2:%.*]] = getelementptr i64, i64* [[PI]], i64 3
; CHECK-NEXT:    store i64 3, i64* [[PIA1AP2]], align 4
; CHECK-NEXT:    [[PIA1BP3:%.*]] = getelementptr i64, i64* [[PI]], i64 4
; CHECK-NEXT:    store i64 4, i64* [[PIA1BP3]], align 4
; CHECK-NEXT:    [[PIA1CP4:%.*]] = getelementptr i64, i64* [[PI]], i64 5
; CHECK-NEXT:    store i64 0, i64* [[PIA1CP4]], align 4
; CHECK-NEXT:    ret void
;
; Fold strtoll(a[0].a, 0, 0) to 1.
  %pa0a = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 0, i64 0
  %ia0a = call i64 @strtoll(i8* %pa0a, i8** null, i32 0)
  %pia0a = getelementptr i64, i64* %pi, i32 0
  store i64 %ia0a, i64* %pia0a

; Fold strtoll(a[0].b + 1, 0, 0, i8** null, i32 0) to 2.
  %pa0bp1 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 1, i64 1
  %ia0bp1 = call i64 @strtoll(i8* %pa0bp1, i8** null, i32 0)
  %pia0bp1 = getelementptr i64, i64* %pi, i32 1
  store i64 %ia0bp1, i64* %pia0bp1

; Fold strtoll(a[0].c + 3, 0, 0, i8** null, i32 0) to 89.
  %pa0cp3 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 0, i32 2, i64 3
  %ia0cp3 = call i64 @strtoll(i8* %pa0cp3, i8** null, i32 0)
  %pia0cp3 = getelementptr i64, i64* %pi, i32 2
  store i64 %ia0cp3, i64* %pia0cp3

; Fold strtoll(a[1].a + 2, 0, 0, i8** null, i32 0) to 3.
  %pa1ap2 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 0, i64 2
  %ia1ap2 = call i64 @strtoll(i8* %pa1ap2, i8** null, i32 0)
  %pia1ap2 = getelementptr i64, i64* %pi, i32 3
  store i64 %ia1ap2, i64* %pia1ap2

; Fold strtoll(a[1].b + 3, 0, 0, i8** null, i32 0) to 4.
  %pa1bp3 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 1, i64 3
  %ia1bp3 = call i64 @strtoll(i8* %pa1bp3, i8** null, i32 0)
  %pia1bp3 = getelementptr i64, i64* %pi, i32 4
  store i64 %ia1bp3, i64* %pia1bp3

; Fold strtoll(a[1].c + 4, 0, 0, i8** null, i32 0) to 0.
  %pa1cp4 = getelementptr [2 x %struct.A], [2 x %struct.A]* @a, i64 0, i64 1, i32 2, i64 4
  %ia1cp4 = call i64 @strtoll(i8* %pa1cp4, i8** null, i32 0)
  %pia1cp4 = getelementptr i64, i64* %pi, i32 5
  store i64 %ia1cp4, i64* %pia1cp4

  ret void
}
