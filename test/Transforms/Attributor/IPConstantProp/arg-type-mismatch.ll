; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; This test is just to verify that we do not crash/assert due to mismatch in
; argument type between the caller and callee.

define dso_local i16 @foo(i16 %a) {
; NOT_CGSCC_NPM: Function Attrs: norecurse
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@foo
; NOT_CGSCC_NPM-SAME: (i16 [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; NOT_CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i16 bitcast (i16 (i16, i16)* @bar to i16 (i16, i32)*)(i16 [[A]], i32 7)
; NOT_CGSCC_NPM-NEXT:    ret i16 [[CALL]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@foo
; IS__CGSCC_NPM-SAME: (i16 [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i16 bitcast (i16 (i16, i16)* @bar to i16 (i16, i32)*)(i16 [[A]], i32 7)
; IS__CGSCC_NPM-NEXT:    ret i16 [[CALL]]
;
  %call = call i16 bitcast (i16 (i16, i16) * @bar to i16 (i16, i32) *)(i16 %a, i32 7)
  ret i16 %call
}

define internal i16 @bar(i16 %p1, i16 %p2) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (i16 [[P1:%.*]], i16 returned [[P2:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    ret i16 [[P2]]
;
  ret i16 %p2
}


;.
; NOT_CGSCC_NPM: attributes #[[ATTR0]] = { norecurse }
; NOT_CGSCC_NPM: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
; IS__CGSCC_NPM: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone }
; IS__CGSCC_NPM: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
