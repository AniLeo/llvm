; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-unroll -S < %s | FileCheck %s

define i32 @test(i32 %a, i32 %b, i32 %c) optsize {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[REF_TMP:%.*]] = alloca [3 x i32], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [3 x i32]* [[REF_TMP]] to i8*
; CHECK-NEXT:    [[ARRAYINIT_BEGIN:%.*]] = getelementptr inbounds [3 x i32], [3 x i32]* [[REF_TMP]], i64 0, i64 0
; CHECK-NEXT:    store i32 [[A:%.*]], i32* [[ARRAYINIT_BEGIN]], align 4
; CHECK-NEXT:    [[ARRAYINIT_ELEMENT:%.*]] = getelementptr inbounds [3 x i32], [3 x i32]* [[REF_TMP]], i64 0, i64 1
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[ARRAYINIT_ELEMENT]], align 4
; CHECK-NEXT:    [[ARRAYINIT_ELEMENT1:%.*]] = getelementptr inbounds [3 x i32], [3 x i32]* [[REF_TMP]], i64 0, i64 2
; CHECK-NEXT:    store i32 [[C:%.*]], i32* [[ARRAYINIT_ELEMENT1]], align 4
; CHECK-NEXT:    [[ADD_PTR_I_I:%.*]] = getelementptr inbounds [3 x i32], [3 x i32]* [[REF_TMP]], i64 0, i64 3
; CHECK-NEXT:    [[CMP_I_I_I3:%.*]] = icmp slt i32 [[A]], [[B]]
; CHECK-NEXT:    [[SPEC_SELECT_I_I4:%.*]] = select i1 [[CMP_I_I_I3]], i32* [[ARRAYINIT_ELEMENT]], i32* [[ARRAYINIT_BEGIN]]
; CHECK-NEXT:    [[INCDEC_PTR_I_I5:%.*]] = getelementptr inbounds [3 x i32], [3 x i32]* [[REF_TMP]], i64 0, i64 2
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i32, i32* [[SPEC_SELECT_I_I4]], align 4
; CHECK-NEXT:    [[DOTPRE2:%.*]] = load i32, i32* [[INCDEC_PTR_I_I5]], align 4
; CHECK-NEXT:    [[CMP_I_I_I:%.*]] = icmp slt i32 [[DOTPRE]], [[DOTPRE2]]
; CHECK-NEXT:    [[SPEC_SELECT_I_I:%.*]] = select i1 [[CMP_I_I_I]], i32* [[INCDEC_PTR_I_I5]], i32* [[SPEC_SELECT_I_I4]]
; CHECK-NEXT:    [[INCDEC_PTR_I_I:%.*]] = getelementptr inbounds i32, i32* [[INCDEC_PTR_I_I5]], i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[SPEC_SELECT_I_I]], align 4
; CHECK-NEXT:    ret i32 [[TMP1]]
;
entry:
  %ref.tmp = alloca [3 x i32], align 4
  %0 = bitcast [3 x i32]* %ref.tmp to i8*
  %arrayinit.begin = getelementptr inbounds [3 x i32], [3 x i32]* %ref.tmp, i64 0, i64 0
  store i32 %a, i32* %arrayinit.begin, align 4
  %arrayinit.element = getelementptr inbounds [3 x i32], [3 x i32]* %ref.tmp, i64 0, i64 1
  store i32 %b, i32* %arrayinit.element, align 4
  %arrayinit.element1 = getelementptr inbounds [3 x i32], [3 x i32]* %ref.tmp, i64 0, i64 2
  store i32 %c, i32* %arrayinit.element1, align 4
  %add.ptr.i.i = getelementptr inbounds [3 x i32], [3 x i32]* %ref.tmp, i64 0, i64 3
  %cmp.i.i.i3 = icmp slt i32 %a, %b
  %spec.select.i.i4 = select i1 %cmp.i.i.i3, i32* %arrayinit.element, i32* %arrayinit.begin
  %incdec.ptr.i.i5 = getelementptr inbounds [3 x i32], [3 x i32]* %ref.tmp, i64 0, i64 2
  br label %loop

loop:          ; preds = %entry, %loop
  %incdec.ptr.i.i7 = phi i32* [ %incdec.ptr.i.i5, %entry ], [ %incdec.ptr.i.i, %loop ]
  %spec.select.i.i6 = phi i32* [ %spec.select.i.i4, %entry ], [ %spec.select.i.i, %loop ]
  %.pre = load i32, i32* %spec.select.i.i6, align 4
  %.pre2 = load i32, i32* %incdec.ptr.i.i7, align 4
  %cmp.i.i.i = icmp slt i32 %.pre, %.pre2
  %spec.select.i.i = select i1 %cmp.i.i.i, i32* %incdec.ptr.i.i7, i32* %spec.select.i.i6
  %incdec.ptr.i.i = getelementptr inbounds i32, i32* %incdec.ptr.i.i7, i64 1
  %cmp1.i.i = icmp eq i32* %incdec.ptr.i.i, %add.ptr.i.i
  br i1 %cmp1.i.i, label %exit, label %loop

exit:           ; preds = %loop
  %1 = load i32, i32* %spec.select.i.i, align 4
  ret i32 %1
}
