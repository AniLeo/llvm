; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; The original C source looked like this:
;
;   long long a101, b101, e101;
;   volatile long c101;
;   int d101;
;
;   static inline int bar(p1, p2)
;   {
;       return 0;
;   }
;
;   void foo(unsigned p1)
;   {
;       long long *f = &b101, *g = &e101;
;       c101 = 0;
;       (void)((*f |= a101) - (*g = bar(d101)));
;       c101 = (*f |= a101 &= p1) == d101;
;   }
;
; When compiled with Clang it gives a warning
;   warning: too few arguments in call to 'bar'
;
; This ll reproducer has been reduced to only include tha call.
;
; Note that -lint will report this as UB, but it passes -verify.

; This test is just to verify that we do not crash/assert due to mismatch in
; argument count between the caller and callee.

; FIXME we should recognize this as UB and make it an unreachable.

define dso_local i16 @foo(i16 %a) {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i16 [[A:%.*]])
; CHECK-NEXT:    [[CALL:%.*]] = call i16 @bar()
; CHECK-NEXT:    ret i16 [[CALL]]
;
  %call = call i16 bitcast (i16 (i16, i16) * @bar to i16 (i16) *)(i16 %a)
  ret i16 %call
}

define internal i16 @bar(i16 %p1, i16 %p2) {
; CHECK-LABEL: define {{[^@]+}}@bar()
; CHECK-NEXT:    ret i16 0
;
  ret i16 0
}

define dso_local i16 @foo2(i16 %a) {
; CHECK-LABEL: define {{[^@]+}}@foo2
; CHECK-SAME: (i16 [[A:%.*]])
; CHECK-NEXT:    [[CALL:%.*]] = call i16 bitcast (i16 (i16, i16)* @bar2 to i16 (i16)*)(i16 [[A]])
; CHECK-NEXT:    ret i16 [[CALL]]
;
  %call = call i16 bitcast (i16 (i16, i16) * @bar2 to i16 (i16) *)(i16 %a)
  ret i16 %call
}

define internal i16 @bar2(i16 %p1, i16 %p2) {
; CHECK-LABEL: define {{[^@]+}}@bar2
; CHECK-SAME: (i16 [[P1:%.*]], i16 [[P2:%.*]])
; CHECK-NEXT:    [[A:%.*]] = add i16 [[P1]], [[P2]]
; CHECK-NEXT:    ret i16 [[A]]
;
  %a = add i16 %p1, %p2
  ret i16 %a
}


;-------------------------------------------------------------------------------
; Additional tests to verify that we still optimize when having a mismatch
; in argument count due to varargs (as long as all non-variadic arguments have
; been provided),

define dso_local i16 @vararg_tests(i16 %a) {
; NOT_CGSCC_OPM-LABEL: define {{[^@]+}}@vararg_tests
; NOT_CGSCC_OPM-SAME: (i16 [[A:%.*]])
; NOT_CGSCC_OPM-NEXT:    [[CALL2:%.*]] = call i16 bitcast (i16 (i16, i16, ...)* @vararg_no_prop to i16 (i16)*)(i16 7)
; NOT_CGSCC_OPM-NEXT:    [[ADD:%.*]] = add i16 7, [[CALL2]]
; NOT_CGSCC_OPM-NEXT:    ret i16 [[ADD]]
;
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@vararg_tests
; IS__CGSCC_OPM-SAME: (i16 [[A:%.*]])
; IS__CGSCC_OPM-NEXT:    [[CALL1:%.*]] = call i16 (i16, ...) @vararg_prop(i16 7, i16 8, i16 [[A]])
; IS__CGSCC_OPM-NEXT:    [[CALL2:%.*]] = call i16 bitcast (i16 (i16, i16, ...)* @vararg_no_prop to i16 (i16)*)(i16 7)
; IS__CGSCC_OPM-NEXT:    [[ADD:%.*]] = add i16 [[CALL1]], [[CALL2]]
; IS__CGSCC_OPM-NEXT:    ret i16 [[ADD]]
;
  %call1 = call i16 (i16, ...) @vararg_prop(i16 7, i16 8, i16 %a)
  %call2 = call i16 bitcast (i16 (i16, i16, ...) * @vararg_no_prop to i16 (i16) *) (i16 7)
  %add = add i16 %call1, %call2
  ret i16 %add
}

define internal i16 @vararg_prop(i16 %p1, ...) {
; IS__CGSCC____-LABEL: define {{[^@]+}}@vararg_prop
; IS__CGSCC____-SAME: (i16 returned [[P1:%.*]], ...)
; IS__CGSCC____-NEXT:    ret i16 7
;
  ret i16 %p1
}

define internal i16 @vararg_no_prop(i16 %p1, i16 %p2, ...) {
; CHECK-LABEL: define {{[^@]+}}@vararg_no_prop
; CHECK-SAME: (i16 returned [[P1:%.*]], i16 [[P2:%.*]], ...)
; CHECK-NEXT:    ret i16 7
;
  ret i16 %p1
}

