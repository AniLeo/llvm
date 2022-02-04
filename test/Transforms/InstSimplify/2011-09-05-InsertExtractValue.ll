; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

declare void @bar()

define void @test1() personality i32 (i32, i64, i8*, i8*)* @__gxx_personality_v0 {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    invoke void @bar()
; CHECK-NEXT:    to label [[CONT:%.*]] unwind label [[LPAD:%.*]]
; CHECK:       cont:
; CHECK-NEXT:    ret void
; CHECK:       lpad:
; CHECK-NEXT:    [[EX:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    resume { i8*, i32 } [[EX]]
;
entry:
  invoke void @bar() to label %cont unwind label %lpad
cont:
  ret void
lpad:
  %ex = landingpad { i8*, i32 } cleanup
  %exc_ptr = extractvalue { i8*, i32 } %ex, 0
  %filter = extractvalue { i8*, i32 } %ex, 1
  %exc_ptr2 = insertvalue { i8*, i32 } undef, i8* %exc_ptr, 0
  %filter2 = insertvalue { i8*, i32 } %exc_ptr2, i32 %filter, 1
  resume { i8*, i32 } %filter2
}

declare i32 @__gxx_personality_v0(i32, i64, i8*, i8*)

define { i8, i32 } @test2({ i8*, i32 } %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[EX:%.*]] = extractvalue { i8*, i32 } [[X:%.*]], 1
; CHECK-NEXT:    [[INS:%.*]] = insertvalue { i8, i32 } undef, i32 [[EX]], 1
; CHECK-NEXT:    ret { i8, i32 } [[INS]]
;
  %ex = extractvalue { i8*, i32 } %x, 1
  %ins = insertvalue { i8, i32 } undef, i32 %ex, 1
  ret { i8, i32 } %ins
}

define i32 @test3(i32 %a, float %b) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %agg1 = insertvalue {i32, float} undef, i32 %a, 0
  %agg2 = insertvalue {i32, float} %agg1, float %b, 1
  %ev = extractvalue {i32, float} %agg2, 0
  ret i32 %ev
}

define i8 @test4(<8 x i8> %V) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[ADD:%.*]] = add <8 x i8> [[V:%.*]], bitcast (<1 x double> <double 0x319BEB8FD172E36> to <8 x i8>)
; CHECK-NEXT:    [[EXTRACT:%.*]] = extractelement <8 x i8> [[ADD]], i32 6
; CHECK-NEXT:    ret i8 [[EXTRACT]]
;
  %add     = add <8 x i8> %V, bitcast (double 0x319BEB8FD172E36 to <8 x i8>)
  %extract = extractelement <8 x i8> %add, i32 6
  ret i8 %extract
}

define i32 @test5(<4 x i32> %V) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i32 poison
;
  %extract = extractelement <4 x i32> %V, i32 undef
  ret i32 %extract
}
