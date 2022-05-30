; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=ipsccp -S %s | FileCheck %s

@y = common global [1 x i32] zeroinitializer, align 4
@x = common global [1 x i32] zeroinitializer, align 4

define i32 @eq_undereferenceable(i32* %p) {
; CHECK-LABEL: @eq_undereferenceable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 1, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32* [[P:%.*]], getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 1, i64 0)
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 2, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 1, i64 0), align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  store i32 1, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
  %cmp = icmp eq i32* %p, getelementptr inbounds (i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 0, i64 0), i64 1)
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 2, i32* %p, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %0 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
  ret i32 %0
}


define i32 @eq_dereferenceable(i32* %p) {
; CHECK-LABEL: @eq_dereferenceable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 1, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32* [[P:%.*]], getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 0, i64 0)
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 2, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 0, i64 0), align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  store i32 1, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
  %cmp = icmp eq i32* %p, getelementptr inbounds (i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 0, i64 0), i64 0)
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 2, i32* %p, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %0 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @y, i64 0, i64 0), align 4
  ret i32 %0
}

define i1 @eq_undereferenceable_cmp_simp(i32* %p) {
; CHECK-LABEL: @eq_undereferenceable_cmp_simp(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_0:%.*]] = icmp eq i32* [[P:%.*]], getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 1, i64 0)
; CHECK-NEXT:    br i1 [[CMP_0]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 2, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 1, i64 0), align 4
; CHECK-NEXT:    ret i1 true
; CHECK:       if.end:
; CHECK-NEXT:    ret i1 false
;
entry:
  %cmp.0 = icmp eq i32* %p, getelementptr inbounds (i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 0, i64 0), i64 1)
  br i1 %cmp.0, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 2, i32* %p, align 4
  %cmp.1 = icmp eq i32* %p, getelementptr inbounds (i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 0, i64 0), i64 1)
  ret i1 %cmp.1

if.end:                                           ; preds = %if.then, %entry
  %cmp.2 = icmp eq i32* %p, getelementptr inbounds (i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @x, i64 0, i64 0), i64 1)
  ret i1 %cmp.2
}
