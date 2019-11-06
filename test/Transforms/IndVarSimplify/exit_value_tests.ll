; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -indvars -loop-deletion -simplifycfg -S | FileCheck %s

; Test that we can evaluate the exit values of various expression types.  Since
; these loops all have predictable exit values we can replace the use outside
; of the loop with a closed-form computation.

define i32 @polynomial_constant() {
; <label>:0
; CHECK-LABEL: @polynomial_constant(
; CHECK-NEXT:  Out:
; CHECK-NEXT:    ret i32 500500
;
  br label %Loop

Loop:		; preds = %Loop, %0
  %A1 = phi i32 [ 0, %0 ], [ %A2, %Loop ]		; <i32> [#uses=3]
  %B1 = phi i32 [ 0, %0 ], [ %B2, %Loop ]		; <i32> [#uses=1]
  %A2 = add i32 %A1, 1		; <i32> [#uses=1]
  %B2 = add i32 %B1, %A1		; <i32> [#uses=2]
  %C = icmp eq i32 %A1, 1000		; <i1> [#uses=1]
  br i1 %C, label %Out, label %Loop

Out:		; preds = %Loop
  ret i32 %B2
}

define i32 @NSquare(i32 %N) {
; <label>:0
; CHECK-LABEL: @NSquare(
; CHECK-NEXT:  Out:
; CHECK-NEXT:    [[Y:%.*]] = mul i32 [[N:%.*]], [[N]]
; CHECK-NEXT:    ret i32 [[Y]]
;
  br label %Loop

Loop:		; preds = %Loop, %0
  %X = phi i32 [ 0, %0 ], [ %X2, %Loop ]		; <i32> [#uses=4]
  %X2 = add i32 %X, 1		; <i32> [#uses=1]
  %c = icmp eq i32 %X, %N		; <i1> [#uses=1]
  br i1 %c, label %Out, label %Loop

Out:		; preds = %Loop
  %Y = mul i32 %X, %X		; <i32> [#uses=1]
  ret i32 %Y
}

define i32 @NSquareOver2(i32 %N) {
; <label>:0
; CHECK-LABEL: @NSquareOver2(
; CHECK-NEXT:  Out:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[N:%.*]] to i33
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[N]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[TMP1]] to i33
; CHECK-NEXT:    [[TMP3:%.*]] = mul i33 [[TMP0]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = lshr i33 [[TMP3]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = trunc i33 [[TMP4]] to i32
; CHECK-NEXT:    [[TMP6:%.*]] = add i32 [[N]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = add i32 [[TMP6]], 15
; CHECK-NEXT:    ret i32 [[TMP7]]
;
  br label %Loop

Loop:		; preds = %Loop, %0
  %X = phi i32 [ 0, %0 ], [ %X2, %Loop ]		; <i32> [#uses=3]
  %Y = phi i32 [ 15, %0 ], [ %Y2, %Loop ]		; <i32> [#uses=1]
  %Y2 = add i32 %Y, %X		; <i32> [#uses=2]
  %X2 = add i32 %X, 1		; <i32> [#uses=1]
  %c = icmp eq i32 %X, %N		; <i1> [#uses=1]
  br i1 %c, label %Out, label %Loop

Out:		; preds = %Loop
  ret i32 %Y2
}

define i32 @strength_reduced() {
; <label>:0
; CHECK-LABEL: @strength_reduced(
; CHECK-NEXT:  Out:
; CHECK-NEXT:    ret i32 500500
;
  br label %Loop

Loop:		; preds = %Loop, %0
  %A1 = phi i32 [ 0, %0 ], [ %A2, %Loop ]		; <i32> [#uses=3]
  %B1 = phi i32 [ 0, %0 ], [ %B2, %Loop ]		; <i32> [#uses=1]
  %A2 = add i32 %A1, 1		; <i32> [#uses=1]
  %B2 = add i32 %B1, %A1		; <i32> [#uses=2]
  %C = icmp eq i32 %A1, 1000		; <i1> [#uses=1]
  br i1 %C, label %Out, label %Loop

Out:		; preds = %Loop
  ret i32 %B2
}

define i32 @chrec_equals() {
; CHECK-LABEL: @chrec_equals(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 101
;
entry:
  br label %no_exit

no_exit:		; preds = %no_exit, %entry
  %i0 = phi i32 [ 0, %entry ], [ %i1, %no_exit ]		; <i32> [#uses=3]
  %ISq = mul i32 %i0, %i0		; <i32> [#uses=1]
  %i1 = add i32 %i0, 1		; <i32> [#uses=2]
  %tmp.1 = icmp ne i32 %ISq, 10000		; <i1> [#uses=1]
  br i1 %tmp.1, label %no_exit, label %loopexit

loopexit:		; preds = %no_exit
  ret i32 %i1
}

define i16 @cast_chrec_test() {
; <label>:0
; CHECK-LABEL: @cast_chrec_test(
; CHECK-NEXT:  Out:
; CHECK-NEXT:    ret i16 1000
;
  br label %Loop

Loop:		; preds = %Loop, %0
  %A1 = phi i32 [ 0, %0 ], [ %A2, %Loop ]		; <i32> [#uses=2]
  %B1 = trunc i32 %A1 to i16		; <i16> [#uses=2]
  %A2 = add i32 %A1, 1		; <i32> [#uses=1]
  %C = icmp eq i16 %B1, 1000		; <i1> [#uses=1]
  br i1 %C, label %Out, label %Loop

Out:		; preds = %Loop
  ret i16 %B1
}

define i32 @linear_div_fold() {
; CHECK-LABEL: @linear_div_fold(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 34
;
entry:
  br label %loop

loop:		; preds = %loop, %entry
  %i = phi i32 [ 4, %entry ], [ %i.next, %loop ]		; <i32> [#uses=3]
  %i.next = add i32 %i, 8		; <i32> [#uses=1]
  %RV = udiv i32 %i, 2		; <i32> [#uses=1]
  %c = icmp ne i32 %i, 68		; <i1> [#uses=1]
  br i1 %c, label %loop, label %loopexit

loopexit:		; preds = %loop
  ret i32 %RV
}

define i32 @unroll_phi_select_constant_nonzero(i32 %arg1, i32 %arg2) {
; CHECK-LABEL: @unroll_phi_select_constant_nonzero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 [[ARG2:%.*]]
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %selector = phi i32 [%arg1, %entry], [%arg2, %loop]
  %i.next = add nsw nuw i32 %i, 1
  %c = icmp ult i32 %i, 4
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %selector
}

declare i32 @f()

; After LCSSA formation, there's no LCSSA phi for %f since it isn't directly
; used outside the loop, and thus we can't directly replace %selector w/ %f.
define i32 @neg_unroll_phi_select_constant_nonzero(i32 %arg) {
; CHECK-LABEL: @neg_unroll_phi_select_constant_nonzero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[SELECTOR:%.*]] = phi i32 [ [[ARG:%.*]], [[ENTRY]] ], [ [[F:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[F]] = call i32 @f()
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[I]], 4
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[LOOPEXIT:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    [[SELECTOR_LCSSA:%.*]] = phi i32 [ [[SELECTOR]], [[LOOP]] ]
; CHECK-NEXT:    ret i32 [[SELECTOR_LCSSA]]
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %selector = phi i32 [%arg, %entry], [%f, %loop]
  %f = call i32 @f()
  %i.next = add nsw nuw i32 %i, 1
  %c = icmp ult i32 %i, 4
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %selector
}


define i32 @unroll_phi_select_constant_zero(i32 %arg1, i32 %arg2) {
; CHECK-LABEL: @unroll_phi_select_constant_zero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 [[ARG1:%.*]]
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %selector = phi i32 [%arg1, %entry], [%arg2, %loop]
  %i.next = add i32 %i, 1
  %c = icmp ne i32 %i, 0
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %selector
}

define i32 @unroll_phi_select(i32 %arg1, i32 %arg2, i16 %len) {
; CHECK-LABEL: @unroll_phi_select(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 [[ARG2:%.*]]
;
entry:
  %length = zext i16 %len to i32
  br label %loop

loop:
  %i = phi i32 [ -1, %entry ], [ %i.next, %loop ]
  %selector = phi i32 [%arg1, %entry], [%arg2, %loop]
  %i.next = add nsw i32 %i, 1
  %c = icmp slt i32 %i, %length
  br i1 %c, label %loop, label %loopexit

loopexit:
  ret i32 %selector
}

