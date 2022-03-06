; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

%"a" = type { i64 }
%"b" = type { i8 }

define hidden i64 @f1() align 2 {
; IS__TUNIT____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@f1
; IS__TUNIT____-SAME: () #[[ATTR0:[0-9]+]] align 2 {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    ret i64 undef
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@f1
; IS__CGSCC____-SAME: () #[[ATTR0:[0-9]+]] align 2 {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[REF_TMP:%.*]] = alloca [[A:%.*]], align 8
; IS__CGSCC____-NEXT:    ret i64 undef
;
entry:
  %ref.tmp = alloca %"a", align 8
  %call2 = call i64 @f2(%"a"* %ref.tmp)
  ret i64 %call2
}

define internal i64 @f2(%"a"* %this) align 2 {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@f2
; IS__CGSCC____-SAME: () #[[ATTR0]] align 2 {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[TMP0:%.*]] = bitcast %a* undef to %b*
; IS__CGSCC____-NEXT:    ret i64 undef
;
entry:
  %this.addr = alloca %"a"*, align 8
  store %"a"* %this, %"a"** %this.addr, align 8
  %this1 = load %"a"*, %"a"** %this.addr, align 8
  %0 = bitcast %"a"* %this1 to %"b"*
  call void @f3(%"b"* %0)
  ret i64 undef
}

define internal void @f3(%"b"* %this) align 2 {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@f3
; IS__CGSCC____-SAME: () #[[ATTR0]] align 2 {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[THIS_ADDR:%.*]] = alloca %b*, align 8
; IS__CGSCC____-NEXT:    [[THIS1:%.*]] = load %b*, %b** [[THIS_ADDR]], align 8
; IS__CGSCC____-NEXT:    ret void
;
entry:
  %this.addr = alloca %"b"*, align 8
  store %"b"* %this, %"b"** %this.addr, align 8
  %this1 = load %"b"*, %"b"** %this.addr, align 8
  %call = call i1 @f4(%"b"* %this1)
  ret void
}

define internal i1 @f4(%"b"* %this) align 2 {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@f4
; IS__CGSCC____-SAME: () #[[ATTR0]] align 2 {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[THIS_ADDR:%.*]] = alloca %b*, align 8
; IS__CGSCC____-NEXT:    [[THIS1:%.*]] = load %b*, %b** [[THIS_ADDR]], align 8
; IS__CGSCC____-NEXT:    ret i1 undef
;
entry:
  %this.addr = alloca %"b"*, align 8
  store %"b"* %this, %"b"** %this.addr, align 8
  %this1 = load %"b"*, %"b"** %this.addr, align 8
  %call = call %"a"* @f5(%"b"* %this1)
  ret i1 undef
}

define internal %"a"* @f5(%"b"* %this) align 2 {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@f5
; IS__CGSCC____-SAME: () #[[ATTR0]] align 2 {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    ret %a* undef
;
entry:
  %this.addr = alloca %"b"*, align 8
  store %"b"* %this, %"b"** %this.addr, align 8
  %this1 = load %"b"*, %"b"** %this.addr, align 8
  %0 = bitcast %"b"* %this1 to %"a"*
  ret %"a"* %0
}
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
