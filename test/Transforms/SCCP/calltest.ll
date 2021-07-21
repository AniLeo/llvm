; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -sccp -loop-deletion -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s

declare double @sqrt(double) readnone nounwind willreturn
%empty = type {}
declare %empty @has_side_effects()

; No matter how hard you try, sqrt(1.0) is always 1.0.  This allows the
; optimizer to delete this loop.
define double @test_0(i32 %param) {
; CHECK-LABEL: @test_0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret double 1.000000e+00
;
entry:
  br label %Loop
Loop:		; preds = %Loop, %entry
  %I2 = phi i32 [ 0, %entry ], [ %I3, %Loop ]
  %V = phi double [ 1.000000e+00, %entry ], [ %V2, %Loop ]
  %V2 = call double @sqrt( double %V )
  %I3 = add i32 %I2, 1
  %tmp.7 = icmp ne i32 %I3, %param
  br i1 %tmp.7, label %Loop, label %Exit
Exit:		; preds = %Loop
  ret double %V
}

define i32 @test_1() {
; CHECK-LABEL: @test_1(
; CHECK-NEXT:    [[TMP1:%.*]] = call [[EMPTY:%.*]] @has_side_effects()
; CHECK-NEXT:    ret i32 0
;
  %1 = call %empty @has_side_effects()
  ret i32 0
}

define i32 @test_not_willreturn() {
; CHECK-LABEL: @test_not_willreturn(
; CHECK-NEXT:    [[TMP1:%.*]] = call [[EMPTY:%.*]] @has_side_effects() #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    ret i32 0
;
  %1 = call %empty @has_side_effects() nounwind readonly
  ret i32 0
}
