; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O1                   -S < %s  | FileCheck %s
; RUN: opt -passes='default<O1>' -S < %s  | FileCheck %s

; This is an important benchmark for color-space-conversion.
; It should reduce to contain only 1 'not' op.

declare void @use(i8, i8, i8, i8)

define void @cmyk(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i8 [[R:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[TMP0]], i8 [[R]], i8 [[B]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt i8 [[TMP1]], [[G:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP2]], i8 [[TMP1]], i8 [[G]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i8 [[TMP3]], -1
; CHECK-NEXT:    [[SUB31:%.*]] = sub i8 [[TMP3]], [[R]]
; CHECK-NEXT:    [[SUB35:%.*]] = sub i8 [[TMP3]], [[G]]
; CHECK-NEXT:    [[SUB39:%.*]] = sub i8 [[TMP3]], [[B]]
; CHECK-NEXT:    call void @use(i8 [[SUB31]], i8 [[SUB35]], i8 [[SUB39]], i8 [[TMP4]])
; CHECK-NEXT:    ret void
;
entry:
  %conv = sext i8 %r to i32
  %sub = sub nsw i32 255, %conv
  %conv1 = trunc i32 %sub to i8
  %conv2 = sext i8 %g to i32
  %sub3 = sub nsw i32 255, %conv2
  %conv4 = trunc i32 %sub3 to i8
  %conv5 = sext i8 %b to i32
  %sub6 = sub nsw i32 255, %conv5
  %conv7 = trunc i32 %sub6 to i8
  %conv8 = sext i8 %conv1 to i32
  %conv9 = sext i8 %conv4 to i32
  %cmp = icmp slt i32 %conv8, %conv9
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %conv12 = sext i8 %conv7 to i32
  %cmp13 = icmp slt i32 %conv8, %conv12
  %cond = select i1 %cmp13, i32 %conv8, i32 %conv12
  %conv17 = trunc i32 %cond to i8
  br label %if.end

if.else:
  %conv19 = sext i8 %conv7 to i32
  %cmp20 = icmp slt i32 %conv9, %conv19
  %cond27 = select i1 %cmp20, i32 %conv9, i32 %conv19
  %conv28 = trunc i32 %cond27 to i8
  br label %if.end

if.end:
  %k.0 = phi i8 [ %conv17, %if.then ], [ %conv28, %if.else ]
  %conv30 = sext i8 %k.0 to i32
  %sub31 = sub nsw i32 %conv8, %conv30
  %conv32 = trunc i32 %sub31 to i8
  %sub35 = sub nsw i32 %conv9, %conv30
  %conv36 = trunc i32 %sub35 to i8
  %conv37 = sext i8 %conv7 to i32
  %sub39 = sub nsw i32 %conv37, %conv30
  %conv40 = trunc i32 %sub39 to i8
  call void @use(i8 %conv32, i8 %conv36, i8 %conv40, i8 %k.0)
  ret void
}
