; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; FIXME: DOT should be replaced with 3

define i32 @test-ashr(i32 %c) {
; CHECK-LABEL: define {{[^@]+}}@test-ashr
; CHECK-SAME: (i32 [[C:%.*]])
; CHECK-NEXT:  chk65:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[C]], 65
; CHECK-NEXT:    br i1 [[CMP]], label [[RETURN:%.*]], label [[CHK0:%.*]]
; CHECK:       chk0:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[C]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[RETURN]], label [[BB_IF:%.*]]
; CHECK:       bb_if:
; CHECK-NEXT:    [[ASHR_VAL:%.*]] = ashr exact i32 [[C]], 2
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[ASHR_VAL]], 15
; CHECK-NEXT:    br i1 [[CMP2]], label [[BB_THEN:%.*]], label [[RETURN]]
; CHECK:       bb_then:
; CHECK-NEXT:    [[CMP3:%.*]] = icmp eq i32 [[ASHR_VAL]], 16
; CHECK-NEXT:    [[DOT:%.*]] = select i1 [[CMP3]], i32 3, i32 2
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL:%.*]] = phi i32 [ 0, [[CHK65:%.*]] ], [ 1, [[CHK0]] ], [ [[DOT]], [[BB_THEN]] ], [ 4, [[BB_IF]] ]
; CHECK-NEXT:    ret i32 [[RETVAL]]
;
chk65:
  %cmp = icmp sgt i32 %c, 65
  br i1 %cmp, label %return, label %chk0

chk0:
  %cmp1 = icmp slt i32 %c, 0
  br i1 %cmp, label %return, label %bb_if

bb_if:
  %ashr.val = ashr exact i32 %c, 2
  %cmp2 = icmp sgt i32 %ashr.val, 15
  br i1 %cmp2, label %bb_then, label %return

bb_then:
  %cmp3 = icmp eq i32 %ashr.val, 16
  %. = select i1 %cmp3, i32 3, i32 2
  br label %return

return:
  %retval = phi i32 [0, %chk65], [1, %chk0], [%., %bb_then], [4, %bb_if]
  ret i32 %retval
}
