; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define internal fastcc i32 @hash(i32* %ts, i32 %mod) nounwind {
; IS__CGSCC____-LABEL: define {{[^@]+}}@hash()
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    unreachable
;
entry:
  unreachable
}

define void @encode(i32* %m, i32* %ts, i32* %new) nounwind {
; CHECK-LABEL: define {{[^@]+}}@encode
; CHECK-SAME: (i32* nocapture nofree readnone [[M:%.*]], i32* nocapture nofree readnone [[TS:%.*]], i32* nocapture nofree readnone [[NEW:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    unreachable
;
entry:
  %0 = call fastcc i32 @hash( i32* %ts, i32 0 ) nounwind		; <i32> [#uses=0]
  unreachable
}
