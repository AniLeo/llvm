; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt < %s -passes=argpromotion -S | FileCheck %s

declare void @use.i32(i32)
declare void @use.p32(i32*)

define internal void @callee(i32* %p1, i32** %p2, i32** %p3, i32** %p4, i32** %p5, i32** %p6, i32** %p7) {
; CHECK-LABEL: define {{[^@]+}}@callee
; CHECK-SAME: (i32 [[P1_0_VAL:%.*]], i32* [[P2_0_VAL:%.*]], i32* [[P3_0_VAL:%.*]], i32* [[P4_0_VAL:%.*]], i32* [[P5_0_VAL:%.*]], i32* [[P6_0_VAL:%.*]], i32* [[P7_0_VAL:%.*]]) {
; CHECK-NEXT:    [[IS_NOT_NULL:%.*]] = icmp ne i32* [[P2_0_VAL]], null
; CHECK-NEXT:    call void @llvm.assume(i1 [[IS_NOT_NULL]])
; CHECK-NEXT:    call void @use.i32(i32 [[P1_0_VAL]])
; CHECK-NEXT:    call void @use.p32(i32* [[P2_0_VAL]])
; CHECK-NEXT:    call void @use.p32(i32* [[P3_0_VAL]])
; CHECK-NEXT:    call void @use.p32(i32* [[P4_0_VAL]])
; CHECK-NEXT:    call void @use.p32(i32* [[P5_0_VAL]])
; CHECK-NEXT:    call void @use.p32(i32* [[P6_0_VAL]])
; CHECK-NEXT:    call void @use.p32(i32* [[P7_0_VAL]])
; CHECK-NEXT:    ret void
;
  %v1 = load i32, i32* %p1, !range !0
  %v2 = load i32*, i32** %p2, !nonnull !1
  %v3 = load i32*, i32** %p3, !dereferenceable !2
  %v4 = load i32*, i32** %p4, !dereferenceable_or_null !2
  %v5 = load i32*, i32** %p5, !align !3
  %v6 = load i32*, i32** %p6, !noundef !1
  %v7 = load i32*, i32** %p7, !nontemporal !4
  call void @use.i32(i32 %v1)
  call void @use.p32(i32* %v2)
  call void @use.p32(i32* %v3)
  call void @use.p32(i32* %v4)
  call void @use.p32(i32* %v5)
  call void @use.p32(i32* %v6)
  call void @use.p32(i32* %v7)
  ret void
}

define void @caller(i32* %p1, i32** %p2, i32** %p3, i32** %p4, i32** %p5, i32** %p6, i32** %p7) {
; CHECK-LABEL: define {{[^@]+}}@caller
; CHECK-SAME: (i32* [[P1:%.*]], i32** [[P2:%.*]], i32** [[P3:%.*]], i32** [[P4:%.*]], i32** [[P5:%.*]], i32** [[P6:%.*]], i32** [[P7:%.*]]) {
; CHECK-NEXT:    [[P1_VAL:%.*]] = load i32, i32* [[P1]], align 4, !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[P2_VAL:%.*]] = load i32*, i32** [[P2]], align 8, !nonnull !1
; CHECK-NEXT:    [[P3_VAL:%.*]] = load i32*, i32** [[P3]], align 8, !dereferenceable !2
; CHECK-NEXT:    [[P4_VAL:%.*]] = load i32*, i32** [[P4]], align 8, !dereferenceable_or_null !2
; CHECK-NEXT:    [[P5_VAL:%.*]] = load i32*, i32** [[P5]], align 8, !align !3
; CHECK-NEXT:    [[P6_VAL:%.*]] = load i32*, i32** [[P6]], align 8, !noundef !1
; CHECK-NEXT:    [[P7_VAL:%.*]] = load i32*, i32** [[P7]], align 8, !nontemporal !4
; CHECK-NEXT:    call void @callee(i32 [[P1_VAL]], i32* [[P2_VAL]], i32* [[P3_VAL]], i32* [[P4_VAL]], i32* [[P5_VAL]], i32* [[P6_VAL]], i32* [[P7_VAL]])
; CHECK-NEXT:    ret void
;
  call void @callee(i32* %p1, i32** %p2, i32** %p3, i32** %p4, i32** %p5, i32** %p6, i32** %p7)
  ret void
}

define internal i32* @callee_conditional(i1 %c, i32** dereferenceable(8) align 8 %p) {
; CHECK-LABEL: define {{[^@]+}}@callee_conditional
; CHECK-SAME: (i1 [[C:%.*]], i32* [[P_0_VAL:%.*]]) {
; CHECK-NEXT:    br i1 [[C]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[IS_NOT_NULL:%.*]] = icmp ne i32* [[P_0_VAL]], null
; CHECK-NEXT:    call void @llvm.assume(i1 [[IS_NOT_NULL]])
; CHECK-NEXT:    ret i32* [[P_0_VAL]]
; CHECK:       else:
; CHECK-NEXT:    ret i32* null
;
  br i1 %c, label %if, label %else

if:
  %v = load i32*, i32** %p, !nonnull !1
  ret i32* %v

else:
  ret i32* null
}

define void @caller_conditional(i1 %c, i32** %p) {
; CHECK-LABEL: define {{[^@]+}}@caller_conditional
; CHECK-SAME: (i1 [[C:%.*]], i32** [[P:%.*]]) {
; CHECK-NEXT:    [[P_VAL:%.*]] = load i32*, i32** [[P]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = call i32* @callee_conditional(i1 [[C]], i32* [[P_VAL]])
; CHECK-NEXT:    ret void
;
  call i32* @callee_conditional(i1 %c, i32** %p)
  ret void
}

!0 = !{i32 0, i32 4}
!1 = !{}
!2 = !{i64 8}
!3 = !{i64 4}
!4 = !{i32 1}
