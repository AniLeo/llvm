; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @sterix(i32, i8, i64) {
; CHECK-LABEL: @sterix(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = zext i32 [[TMP0:%.*]] to i64
; CHECK-NEXT:    [[CONV1:%.*]] = sext i8 [[TMP1:%.*]] to i32
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[CONV1]], 1945964878
; CHECK-NEXT:    [[SH_PROM:%.*]] = trunc i64 [[TMP2:%.*]] to i32
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[MUL]], [[SH_PROM]]
; CHECK-NEXT:    [[CONV2:%.*]] = zext i32 [[SHR]] to i64
; CHECK-NEXT:    [[MUL3:%.*]] = mul nuw nsw i64 [[CONV]], [[CONV2]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt i64 [[MUL3]], 4294967295
; CHECK-NEXT:    br i1 [[TMP3]], label [[LOR_END:%.*]], label [[LOR_RHS:%.*]]
; CHECK:       lor.rhs:
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[MUL3]], [[TMP2]]
; CHECK-NEXT:    [[CONV4:%.*]] = trunc i64 [[AND]] to i32
; CHECK-NEXT:    [[TOBOOL7:%.*]] = icmp eq i32 [[CONV4]], 0
; CHECK-NEXT:    [[PHITMP:%.*]] = zext i1 [[TOBOOL7]] to i32
; CHECK-NEXT:    br label [[LOR_END]]
; CHECK:       lor.end:
; CHECK-NEXT:    [[TMP4:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[PHITMP]], [[LOR_RHS]] ]
; CHECK-NEXT:    ret i32 [[TMP4]]
;
entry:
  %conv = zext i32 %0 to i64
  %conv1 = sext i8 %1 to i32
  %mul = mul i32 %conv1, 1945964878
  %sh_prom = trunc i64 %2 to i32
  %shr = lshr i32 %mul, %sh_prom
  %conv2 = zext i32 %shr to i64
  %mul3 = mul nuw nsw i64 %conv, %conv2
  %conv6 = and i64 %mul3, 4294967295
  %tobool = icmp ne i64 %conv6, %mul3
  br i1 %tobool, label %lor.end, label %lor.rhs

lor.rhs:
  %and = and i64 %2, %mul3
  %conv4 = trunc i64 %and to i32
  %tobool7 = icmp ne i32 %conv4, 0
  %lnot = xor i1 %tobool7, true
  br label %lor.end

lor.end:
  %3 = phi i1 [ true, %entry ], [ %lnot, %lor.rhs ]
  %conv8 = zext i1 %3 to i32
  ret i32 %conv8
}

; https://bugs.llvm.org/show_bug.cgi?id=33765

@glob = external global i16

define void @PR33765(i8 %beth) {
; CHECK-LABEL: @PR33765(
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[BETH:%.*]] to i32
; CHECK-NEXT:    br i1 false, label [[IF_THEN9:%.*]], label [[IF_THEN9]]
; CHECK:       if.then9:
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[CONV]], [[CONV]]
; CHECK-NEXT:    [[TINKY:%.*]] = load i16, i16* @glob, align 2
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[MUL]] to i16
; CHECK-NEXT:    [[CONV14:%.*]] = and i16 [[TINKY]], [[TMP1]]
; CHECK-NEXT:    store i16 [[CONV14]], i16* @glob, align 2
; CHECK-NEXT:    ret void
;
  %conv = zext i8 %beth to i32
  %mul = mul nuw nsw i32 %conv, %conv
  %conv3 = and i32 %mul, 255
  %tobool8 = icmp ne i32 %mul, %conv3
  br i1 %tobool8, label %if.then9, label %if.then9

if.then9:
  %tinky = load i16, i16* @glob
  %conv13 = sext i16 %tinky to i32
  %and = and i32 %mul, %conv13
  %conv14 = trunc i32 %and to i16
  store i16 %conv14, i16* @glob
  ret void
}

; Repro case for bug involving mutating a list while
; iterating it.

declare i16 @aux(i8)

define i16 @iter_breaker(i16 %a, i16 %b) {
; CHECK-LABEL: @iter_breaker(
; CHECK-NEXT:    [[UMUL:%.*]] = call { i16, i1 } @llvm.umul.with.overflow.i16(i16 [[A:%.*]], i16 [[B:%.*]])
; CHECK-NEXT:    [[UMUL_VALUE:%.*]] = extractvalue { i16, i1 } [[UMUL]], 0
; CHECK-NEXT:    [[DID_OVF:%.*]] = extractvalue { i16, i1 } [[UMUL]], 1
; CHECK-NEXT:    br i1 [[DID_OVF]], label [[RET1:%.*]], label [[RET2:%.*]]
; CHECK:       ret1:
; CHECK-NEXT:    [[TRUNC_REMAIN:%.*]] = trunc i16 [[UMUL_VALUE]] to i8
; CHECK-NEXT:    [[VAL:%.*]] = call i16 @aux(i8 [[TRUNC_REMAIN]])
; CHECK-NEXT:    ret i16 [[VAL]]
; CHECK:       ret2:
; CHECK-NEXT:    ret i16 [[UMUL_VALUE]]
;
  %a_wide = zext i16 %a to i32
  %b_wide = zext i16 %b to i32
  %mul_wide = mul i32 %a_wide, %b_wide              ; uses of %mul_wide will be iterated

  %trunc_remain = trunc i32 %mul_wide to i8         ; this use will be replaced w/ new value
  ; when iteration visits it, switching
  ; iteration to the uses of new value

  %trunc_unnecessary = trunc i32 %mul_wide to i16   ; uses of %trunc_unnecessary will have
  ; been updated to uses of new value

  %did_ovf = icmp ugt i32 %mul_wide, 65535
  br i1 %did_ovf, label %ret1, label %ret2

ret1:
  %val = call i16 @aux(i8 %trunc_remain)
  ret i16 %val

ret2:
  ret i16 %trunc_unnecessary              ; crash visiting this use after corrupting iterator
}
