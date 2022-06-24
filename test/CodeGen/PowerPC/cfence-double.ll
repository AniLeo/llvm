; REQUIRES: asserts
; RUN: not --crash llc -opaque-pointers -mtriple=powerpc64le-unknown-unknown \
; RUN:   < %s 2>&1 | FileCheck %s
; RUN: not --crash llc -opaque-pointers -mtriple=powerpc64-unknown-unknown \
; RUN:   < %s 2>&1 | FileCheck %s

; CHECK: Assertion `VT.isInteger() && Operand.getValueType().isInteger() && "Invalid ANY_EXTEND!"' failed

define double @foo(double* %dp) {
entry:
  %0 = load atomic double, double* %dp acquire, align 8
  ret double %0
}
