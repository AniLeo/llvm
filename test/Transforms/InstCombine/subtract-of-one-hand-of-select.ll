; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -instcombine | FileCheck %s

; Fold
;   sub (select %Cond, %TrueVal, %FalseVal), %Op1
; to
;   select %Cond, (sub %TrueVal, %Op1), (sub %FalseVal, %Op1)

; https://bugs.llvm.org/show_bug.cgi?id=44426

; Base tests

define i8 @t0_sub_of_trueval(i1 %c, i8 %Op1, i8 %FalseVal) {
; CHECK-LABEL: @t0_sub_of_trueval(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 [[FALSEVAL:%.*]], [[OP1:%.*]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C:%.*]], i8 0, i8 [[TMP1]], !prof !0
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = select i1 %c, i8 %Op1, i8 %FalseVal, !prof !0 ; while there, ensure preservation of prof md
  %r = sub i8 %o, %Op1
  ret i8 %r
}
define i8 @t1_sub_of_falseval(i1 %c, i8 %TrueVal, i8 %Op1) {
; CHECK-LABEL: @t1_sub_of_falseval(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 [[TRUEVAL:%.*]], [[OP1:%.*]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C:%.*]], i8 [[TMP1]], i8 0, !prof !0
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = select i1 %c, i8 %TrueVal, i8 %Op1, !prof !0 ; while there, ensure preservation of prof md
  %r = sub i8 %o, %Op1
  ret i8 %r
}

; Vectors

define <2 x i8> @t2_vec(i1 %c, <2 x i8> %Op1, <2 x i8> %FalseVal) {
; CHECK-LABEL: @t2_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i8> [[FALSEVAL:%.*]], [[OP1:%.*]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C:%.*]], <2 x i8> zeroinitializer, <2 x i8> [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %o = select i1 %c, <2 x i8> %Op1, <2 x i8> %FalseVal
  %r = sub <2 x i8> %o, %Op1
  ret <2 x i8> %r
}

; Extra use

declare void @use8(i8)

define i8 @n3_extrause(i1 %c, i8 %Op1, i8 %FalseVal) {
; CHECK-LABEL: @n3_extrause(
; CHECK-NEXT:    [[O:%.*]] = select i1 [[C:%.*]], i8 [[OP1:%.*]], i8 [[FALSEVAL:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[O]])
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[O]], [[OP1]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = select i1 %c, i8 %Op1, i8 %FalseVal
  call void @use8(i8 %o)
  %r = sub i8 %o, %Op1
  ret i8 %r
}

; Negative tests

define i8 @n4_wrong_hands(i1 %c, i8 %TrueVal, i8 %FalseVal, i8 %Op1) {
; CHECK-LABEL: @n4_wrong_hands(
; CHECK-NEXT:    [[O:%.*]] = select i1 [[C:%.*]], i8 [[TRUEVAL:%.*]], i8 [[FALSEVAL:%.*]]
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[O]], [[OP1:%.*]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = select i1 %c, i8 %TrueVal, i8 %FalseVal ; none of the hands is %Op1
  %r = sub i8 %o, %Op1
  ret i8 %r
}

define i8 @n5_wrong_sub(i1 %c, i8 %Op1, i8 %FalseVal) {
; CHECK-LABEL: @n5_wrong_sub(
; CHECK-NEXT:    [[O:%.*]] = select i1 [[C:%.*]], i8 [[OP1:%.*]], i8 [[FALSEVAL:%.*]]
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[OP1]], [[O]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = select i1 %c, i8 %Op1, i8 %FalseVal
  %r = sub i8 %Op1, %o ; wrong order
  ret i8 %r
}

; CHECK: !0 = !{!"branch_weights", i32 0, i32 100}
!0  = !{!"branch_weights", i32 0, i32 100}
