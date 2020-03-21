; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -instcombine | FileCheck %s

declare i32 @llvm.ctpop.i32(i32)
declare <2 x i32> @llvm.ctpop.v2i32(<2 x i32>)

; PR43513
; __builtin_popcount(i | -i) -> 32 - __builtin_cttz(i, false)
define i32 @ctpop1(i32 %0) {
; CHECK-LABEL: @ctpop1(
; CHECK-NEXT:    [[TMP2:%.*]] = sub i32 0, [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP2]], [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = tail call i32 @llvm.ctpop.i32(i32 [[TMP3]]), !range !0
; CHECK-NEXT:    [[TMP5:%.*]] = sub nuw nsw i32 32, [[TMP4]]
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %2 = sub i32 0, %0
  %3 = or i32 %2, %0
  %4 = tail call i32 @llvm.ctpop.i32(i32 %3)
  %5 = sub i32 32, %4
  ret i32 %5
}

define <2 x i32> @ctpop1v(<2 x i32> %0) {
; CHECK-LABEL: @ctpop1v(
; CHECK-NEXT:    [[TMP2:%.*]] = sub <2 x i32> zeroinitializer, [[TMP0:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = or <2 x i32> [[TMP2]], [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = tail call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> [[TMP3]])
; CHECK-NEXT:    [[TMP5:%.*]] = sub nsw <2 x i32> <i32 32, i32 32>, [[TMP4]]
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %2 = sub <2 x i32> zeroinitializer, %0
  %3 = or <2 x i32> %2, %0
  %4 = tail call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> %3)
  %5 = sub <2 x i32> <i32 32, i32 32>, %4
  ret <2 x i32> %5
}

; PR43513
; __builtin_popcount(~i & (i-1)) -> __builtin_cttz(i, false)
define i32 @ctpop2(i32 %0) {
; CHECK-LABEL: @ctpop2(
; CHECK-NEXT:    [[TMP2:%.*]] = xor i32 [[TMP0:%.*]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP0]], -1
; CHECK-NEXT:    [[TMP4:%.*]] = and i32 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = tail call i32 @llvm.ctpop.i32(i32 [[TMP4]]), !range !0
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %2 = xor i32 %0, -1
  %3 = add i32 %0, -1
  %4 = and i32 %3, %2
  %5 = tail call i32 @llvm.ctpop.i32(i32 %4)
  ret i32 %5
}

define <2 x i32> @ctpop2v(<2 x i32> %0) {
; CHECK-LABEL: @ctpop2v(
; CHECK-NEXT:    [[TMP2:%.*]] = xor <2 x i32> [[TMP0:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[TMP3:%.*]] = add <2 x i32> [[TMP0]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[TMP4:%.*]] = and <2 x i32> [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = tail call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> [[TMP4]])
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %2 = xor <2 x i32> %0, <i32 -1, i32 -1>
  %3 = add <2 x i32> %0, <i32 -1, i32 -1>
  %4 = and <2 x i32> %3, %2
  %5 = tail call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> %4)
  ret <2 x i32> %5
}
