; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -codegenprepare -S < %s | FileCheck %s
; RUN: opt -enable-debugify -codegenprepare -S < %s 2>&1 | FileCheck %s -check-prefix=DEBUG

; Subset of tests from llvm/tests/Transforms/CodeGenPrepare/X86/overflow-intrinsics.ll
; to test shouldFormOverflowOp on SPARC, where it is not profitable to create
; overflow intrinsics if the math part is not used.

target triple = "sparc64-unknown-linux"

define i64 @uaddo1_overflow_used(i64 %a, i64 %b) nounwind ssp {
; CHECK-LABEL: @uaddo1_overflow_used(
; CHECK-NEXT:    [[ADD:%.*]] = add i64 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[ADD]], [[A]]
; CHECK-NEXT:    [[Q:%.*]] = select i1 [[CMP]], i64 [[B]], i64 42
; CHECK-NEXT:    ret i64 [[Q]]
;
  %add = add i64 %b, %a
  %cmp = icmp ult i64 %add, %a
  %Q = select i1 %cmp, i64 %b, i64 42
  ret i64 %Q
}

define i64 @uaddo1_math_overflow_used(i64 %a, i64 %b, i64* %res) nounwind ssp {
; CHECK-LABEL: @uaddo1_math_overflow_used(
; CHECK-NEXT:    [[TMP1:%.*]] = call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 [[B:%.*]], i64 [[A:%.*]])
; CHECK-NEXT:    [[MATH:%.*]] = extractvalue { i64, i1 } [[TMP1]], 0
; CHECK-NEXT:    [[OV:%.*]] = extractvalue { i64, i1 } [[TMP1]], 1
; CHECK-NEXT:    [[Q:%.*]] = select i1 [[OV]], i64 [[B]], i64 42
; CHECK-NEXT:    store i64 [[MATH]], i64* [[RES:%.*]]
; CHECK-NEXT:    ret i64 [[Q]]
;
  %add = add i64 %b, %a
  %cmp = icmp ult i64 %add, %a
  %Q = select i1 %cmp, i64 %b, i64 42
  store i64 %add, i64* %res
  ret i64 %Q
}

define i64 @uaddo2_overflow_used(i64 %a, i64 %b) nounwind ssp {
; CHECK-LABEL: @uaddo2_overflow_used(
; CHECK-NEXT:    [[ADD:%.*]] = add i64 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i64 [[ADD]], [[B]]
; CHECK-NEXT:    [[Q:%.*]] = select i1 [[CMP]], i64 [[B]], i64 42
; CHECK-NEXT:    ret i64 [[Q]]
;
  %add = add i64 %b, %a
  %cmp = icmp ult i64 %add, %b
  %Q = select i1 %cmp, i64 %b, i64 42
  ret i64 %Q
}

define i64 @uaddo2_math_overflow_used(i64 %a, i64 %b, i64* %res) nounwind ssp {
; CHECK-LABEL: @uaddo2_math_overflow_used(
; CHECK-NEXT:    [[TMP1:%.*]] = call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 [[B:%.*]], i64 [[A:%.*]])
; CHECK-NEXT:    [[MATH:%.*]] = extractvalue { i64, i1 } [[TMP1]], 0
; CHECK-NEXT:    [[OV:%.*]] = extractvalue { i64, i1 } [[TMP1]], 1
; CHECK-NEXT:    [[Q:%.*]] = select i1 [[OV]], i64 [[B]], i64 42
; CHECK-NEXT:    store i64 [[MATH]], i64* [[RES:%.*]]
; CHECK-NEXT:    ret i64 [[Q]]
;
  %add = add i64 %b, %a
  %cmp = icmp ult i64 %add, %b
  %Q = select i1 %cmp, i64 %b, i64 42
  store i64 %add, i64* %res
  ret i64 %Q
}

define i64 @uaddo3_overflow_used(i64 %a, i64 %b) nounwind ssp {
; CHECK-LABEL: @uaddo3_overflow_used(
; CHECK-NEXT:    [[ADD:%.*]] = add i64 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i64 [[B]], [[ADD]]
; CHECK-NEXT:    [[Q:%.*]] = select i1 [[CMP]], i64 [[B]], i64 42
; CHECK-NEXT:    ret i64 [[Q]]
;
  %add = add i64 %b, %a
  %cmp = icmp ugt i64 %b, %add
  %Q = select i1 %cmp, i64 %b, i64 42
  ret i64 %Q
}

define i64 @uaddo3_math_overflow_used(i64 %a, i64 %b, i64* %res) nounwind ssp {
; CHECK-LABEL: @uaddo3_math_overflow_used(
; CHECK-NEXT:    [[TMP1:%.*]] = call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 [[B:%.*]], i64 [[A:%.*]])
; CHECK-NEXT:    [[MATH:%.*]] = extractvalue { i64, i1 } [[TMP1]], 0
; CHECK-NEXT:    [[OV:%.*]] = extractvalue { i64, i1 } [[TMP1]], 1
; CHECK-NEXT:    [[Q:%.*]] = select i1 [[OV]], i64 [[B]], i64 42
; CHECK-NEXT:    store i64 [[MATH]], i64* [[RES:%.*]]
; CHECK-NEXT:    ret i64 [[Q]]
;
  %add = add i64 %b, %a
  %cmp = icmp ugt i64 %b, %add
  %Q = select i1 %cmp, i64 %b, i64 42
  store i64 %add, i64* %res
  ret i64 %Q
}

define i1 @usubo_ult_i64_overflow_used(i64 %x, i64 %y, i64* %p) {
; CHECK-LABEL: @usubo_ult_i64_overflow_used(
; CHECK-NEXT:    [[S:%.*]] = sub i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[OV:%.*]] = icmp ult i64 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[OV]]
;
  %s = sub i64 %x, %y
  %ov = icmp ult i64 %x, %y
  ret i1 %ov
}

define i1 @usubo_ult_i64_math_overflow_used(i64 %x, i64 %y, i64* %p) {
; CHECK-LABEL: @usubo_ult_i64_math_overflow_used(
; CHECK-NEXT:    [[S:%.*]] = sub i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    store i64 [[S]], i64* [[P:%.*]]
; CHECK-NEXT:    [[OV:%.*]] = icmp ult i64 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[OV]]
;
  %s = sub i64 %x, %y
  store i64 %s, i64* %p
  %ov = icmp ult i64 %x, %y
  ret i1 %ov
}

; Check that every instruction inserted by -codegenprepare has a debug location.
; DEBUG: CheckModuleDebugify: PASS
