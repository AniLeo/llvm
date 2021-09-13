; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt %s -passes='module(globalopt),cgscc(argpromotion),function(sroa)' -S | FileCheck %s

target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

%struct.ss = type { i32, i32 }

; Argpromote + sroa should change this to passing the two integers by value.
define internal i32 @f(%struct.ss* inalloca(%struct.ss)  %s) {
; CHECK-LABEL: define {{[^@]+}}@f
; CHECK-SAME: (i32 [[S_0_0_VAL:%.*]], i32 [[S_0_1_VAL:%.*]]) unnamed_addr {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[R:%.*]] = add i32 [[S_0_0_VAL]], [[S_0_1_VAL]]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  %f0 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 1
  %a = load i32, i32* %f0, align 4
  %b = load i32, i32* %f1, align 4
  %r = add i32 %a, %b
  ret i32 %r
}

define i32 @main() {
; CHECK-LABEL: define {{[^@]+}}@main() local_unnamed_addr {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[R:%.*]] = call fastcc i32 @f(i32 1, i32 2)
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  %S = alloca inalloca %struct.ss
  %f0 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i32 1, i32* %f0, align 4
  store i32 2, i32* %f1, align 4
  %r = call i32 @f(%struct.ss* inalloca(%struct.ss) %S)
  ret i32 %r
}

; Argpromote can't promote %a because of the icmp use.
define internal i1 @g(%struct.ss* %a, %struct.ss* inalloca(%struct.ss) %b) nounwind  {
; CHECK-LABEL: define {{[^@]+}}@g
; CHECK-SAME: (%struct.ss* [[A:%.*]], %struct.ss* [[B:%.*]]) unnamed_addr #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = icmp eq %struct.ss* [[A]], [[B]]
; CHECK-NEXT:    ret i1 [[C]]
;
entry:
  %c = icmp eq %struct.ss* %a, %b
  ret i1 %c
}

define i32 @test() {
; CHECK-LABEL: define {{[^@]+}}@test() local_unnamed_addr {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[S:%.*]] = alloca inalloca [[STRUCT_SS:%.*]], align 4
; CHECK-NEXT:    [[C:%.*]] = call fastcc i1 @g(%struct.ss* [[S]], %struct.ss* [[S]])
; CHECK-NEXT:    ret i32 0
;
entry:
  %S = alloca inalloca %struct.ss
  %c = call i1 @g(%struct.ss* %S, %struct.ss* inalloca(%struct.ss) %S)
  ret i32 0
}
