; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define internal i32 @testf(i1 %c) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@testf
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[IF_COND:%.*]], label [[IF_END:%.*]]
; IS__CGSCC____:       if.cond:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       if.then:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       if.end:
; IS__CGSCC____-NEXT:    ret i32 10
;
entry:
  br i1 %c, label %if.cond, label %if.end

if.cond:
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %entry, %if.then
  ret i32 11

if.end:                                          ; preds = %if.then1, %entry
  ret i32 10
}

define internal i32 @test1(i1 %c) {
; IS__CGSCC____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test1
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    br label [[IF_THEN:%.*]]
; IS__CGSCC____:       if.then:
; IS__CGSCC____-NEXT:    [[CALL:%.*]] = call i32 @testf(i1 [[C]]) #[[ATTR2:[0-9]+]]
; IS__CGSCC____-NEXT:    [[RES:%.*]] = icmp eq i32 [[CALL]], 10
; IS__CGSCC____-NEXT:    br i1 [[RES]], label [[RET1:%.*]], label [[RET2:%.*]]
; IS__CGSCC____:       ret1:
; IS__CGSCC____-NEXT:    ret i32 99
; IS__CGSCC____:       ret2:
; IS__CGSCC____-NEXT:    ret i32 0
;
entry:
  br label %if.then

if.then:                                          ; preds = %entry, %if.then
  %call = call i32 @testf(i1 %c)
  %res = icmp eq i32 %call, 10
  br i1 %res, label %ret1, label %ret2

ret1:                                           ; preds = %if.then, %entry
  ret i32 99

ret2:                                           ; preds = %if.then, %entry
  ret i32 0
}

define i32 @main(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@main
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:    ret i32 99
;
; IS__CGSCC____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@main
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) #[[ATTR1]] {
; IS__CGSCC____-NEXT:    [[RES:%.*]] = call noundef i32 @test1(i1 [[C]]) #[[ATTR2]]
; IS__CGSCC____-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @test1(i1 %c)
  ret i32 %res
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nofree nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR2]] = { readnone willreturn }
;.
