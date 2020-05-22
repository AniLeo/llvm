; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s
; <rdar://problem/8558713>

declare void @throwAnExceptionOrWhatever()

define i32 @test1(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SADD:%.*]] = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[B:%.*]], i32 [[A:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = extractvalue { i32, i1 } [[SADD]], 1
; CHECK-NEXT:    br i1 [[TMP0]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @throwAnExceptionOrWhatever() #2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[SADD_RESULT:%.*]] = extractvalue { i32, i1 } [[SADD]], 0
; CHECK-NEXT:    ret i32 [[SADD_RESULT]]
;
entry:
  %conv = sext i32 %a to i64
  %conv2 = sext i32 %b to i64
  %add = add nsw i64 %conv2, %conv
  %add.off = add i64 %add, 2147483648
  %0 = icmp ugt i64 %add.off, 4294967295
  br i1 %0, label %if.then, label %if.end

if.then:
  tail call void @throwAnExceptionOrWhatever() nounwind
  br label %if.end

if.end:
  %conv9 = trunc i64 %add to i32
  ret i32 %conv9
}

; This form should not be promoted for two reasons: 1) it is unprofitable to
; promote it since the add.off instruction has another use, and 2) it is unsafe
; because the add-with-off makes the high bits of the original add live.

define i32 @test2(i32 %a, i32 %b, i64* %P) nounwind ssp {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[A:%.*]] to i64
; CHECK-NEXT:    [[CONV2:%.*]] = sext i32 [[B:%.*]] to i64
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[CONV2]], [[CONV]]
; CHECK-NEXT:    [[ADD_OFF:%.*]] = add nsw i64 [[ADD]], 2147483648
; CHECK-NEXT:    store i64 [[ADD_OFF]], i64* [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ugt i64 [[ADD_OFF]], 4294967295
; CHECK-NEXT:    br i1 [[TMP0]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @throwAnExceptionOrWhatever() #2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CONV9:%.*]] = trunc i64 [[ADD]] to i32
; CHECK-NEXT:    ret i32 [[CONV9]]
;
entry:
  %conv = sext i32 %a to i64
  %conv2 = sext i32 %b to i64
  %add = add nsw i64 %conv2, %conv
  %add.off = add i64 %add, 2147483648
  store i64 %add.off, i64* %P
  %0 = icmp ugt i64 %add.off, 4294967295
  br i1 %0, label %if.then, label %if.end

if.then:
  tail call void @throwAnExceptionOrWhatever() nounwind
  br label %if.end

if.end:
  %conv9 = trunc i64 %add to i32
  ret i32 %conv9
}

; PR8816
; This is illegal to transform because the high bits of the original add are
; live out.
define i64 @test3(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[A:%.*]] to i64
; CHECK-NEXT:    [[CONV2:%.*]] = sext i32 [[B:%.*]] to i64
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[CONV2]], [[CONV]]
; CHECK-NEXT:    [[ADD_OFF:%.*]] = add nsw i64 [[ADD]], 2147483648
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ugt i64 [[ADD_OFF]], 4294967295
; CHECK-NEXT:    br i1 [[TMP0]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @throwAnExceptionOrWhatever() #2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret i64 [[ADD]]
;
entry:
  %conv = sext i32 %a to i64
  %conv2 = sext i32 %b to i64
  %add = add nsw i64 %conv2, %conv
  %add.off = add i64 %add, 2147483648
  %0 = icmp ugt i64 %add.off, 4294967295
  br i1 %0, label %if.then, label %if.end

if.then:
  tail call void @throwAnExceptionOrWhatever() nounwind
  br label %if.end

if.end:
  ret i64 %add
}

; Should be able to form an i8 sadd computed in an i32.

define zeroext i8 @test4(i8 signext %a, i8 signext %b) nounwind ssp {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SADD:%.*]] = call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[B:%.*]], i8 [[A:%.*]])
; CHECK-NEXT:    [[CMP:%.*]] = extractvalue { i8, i1 } [[SADD]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @throwAnExceptionOrWhatever() #2
; CHECK-NEXT:    unreachable
; CHECK:       if.end:
; CHECK-NEXT:    [[SADD_RESULT:%.*]] = extractvalue { i8, i1 } [[SADD]], 0
; CHECK-NEXT:    ret i8 [[SADD_RESULT]]
;
entry:
  %conv = sext i8 %a to i32
  %conv2 = sext i8 %b to i32
  %add = add nsw i32 %conv2, %conv
  %add4 = add nsw i32 %add, 128
  %cmp = icmp ugt i32 %add4, 255
  br i1 %cmp, label %if.then, label %if.end
if.then:
  tail call void @throwAnExceptionOrWhatever() nounwind
  unreachable

if.end:
  %conv7 = trunc i32 %add to i8
  ret i8 %conv7
}

; PR11438
; This is @test1, but the operands are not sign-extended.  Make sure
; we don't transform this case.

define i32 @test8(i64 %a, i64 %b) nounwind ssp {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[ADD_OFF:%.*]] = add i64 [[ADD]], 2147483648
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ugt i64 [[ADD_OFF]], 4294967295
; CHECK-NEXT:    br i1 [[TMP0]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    tail call void @throwAnExceptionOrWhatever() #2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CONV9:%.*]] = trunc i64 [[ADD]] to i32
; CHECK-NEXT:    ret i32 [[CONV9]]
;
entry:
  %add = add i64 %a, %b
  %add.off = add i64 %add, 2147483648
  %0 = icmp ugt i64 %add.off, 4294967295
  br i1 %0, label %if.then, label %if.end

if.then:
  tail call void @throwAnExceptionOrWhatever() nounwind
  br label %if.end

if.end:
  %conv9 = trunc i64 %add to i32
  ret i32 %conv9
}

