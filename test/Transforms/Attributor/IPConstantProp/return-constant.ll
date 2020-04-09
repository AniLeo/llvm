; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; FIXME: icmp folding is missing

define i1 @invokecaller(i1 %C) personality i32 (...)* @__gxx_personality_v0 {
; CHECK-LABEL: define {{[^@]+}}@invokecaller
; CHECK-SAME: (i1 [[C:%.*]]) #0 personality i32 (...)* @__gxx_personality_v0
; CHECK-NEXT:    [[X:%.*]] = call i32 @foo(i1 [[C]])
; CHECK-NEXT:    br label [[OK:%.*]]
; CHECK:       OK:
; CHECK-NEXT:    ret i1 true
; CHECK:       FAIL:
; CHECK-NEXT:    unreachable
;
  %X = invoke i32 @foo( i1 %C ) to label %OK unwind label %FAIL             ; <i32> [#uses=1]
OK:
  %Y = icmp ne i32 %X, 0          ; <i1> [#uses=1]
  ret i1 %Y
FAIL:
  %exn = landingpad {i8*, i32}
  cleanup
  ret i1 false
}

define internal i32 @foo(i1 %C) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@foo
; IS__TUNIT____-SAME: (i1 [[C:%.*]])
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       T:
; IS__TUNIT____-NEXT:    ret i32 undef
; IS__TUNIT____:       F:
; IS__TUNIT____-NEXT:    ret i32 undef
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@foo
; IS__CGSCC____-SAME: (i1 [[C:%.*]])
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       T:
; IS__CGSCC____-NEXT:    ret i32 52
; IS__CGSCC____:       F:
; IS__CGSCC____-NEXT:    ret i32 52
;
  br i1 %C, label %T, label %F

T:              ; preds = %0
  ret i32 52

F:              ; preds = %0
  ret i32 52
}

define i1 @caller(i1 %C) {
; CHECK-LABEL: define {{[^@]+}}@caller
; CHECK-SAME: (i1 [[C:%.*]])
; CHECK-NEXT:    ret i1 true
;
  %X = call i32 @foo( i1 %C )             ; <i32> [#uses=1]
  %Y = icmp ne i32 %X, 0          ; <i1> [#uses=1]
  ret i1 %Y
}

declare i32 @__gxx_personality_v0(...)
