; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=8 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=9 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM


define internal void @dead() {
  call i32 @test(i32* null, i32* null)
  ret void
}

define internal i32 @test(i32* %X, i32* %Y) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@test
; IS__TUNIT____-SAME: (i32* noalias nocapture nofree noundef writeonly align 4 [[X:%.*]])
; IS__TUNIT____-NEXT:    br i1 true, label [[LIVE:%.*]], label [[DEAD:%.*]]
; IS__TUNIT____:       live:
; IS__TUNIT____-NEXT:    store i32 0, i32* [[X]], align 4
; IS__TUNIT____-NEXT:    ret i32 undef
; IS__TUNIT____:       dead:
; IS__TUNIT____-NEXT:    unreachable
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@test
; IS__CGSCC_OPM-SAME: (i32* nocapture nofree noundef writeonly align 4 [[X:%.*]])
; IS__CGSCC_OPM-NEXT:    br i1 true, label [[LIVE:%.*]], label [[DEAD:%.*]]
; IS__CGSCC_OPM:       live:
; IS__CGSCC_OPM-NEXT:    store i32 0, i32* [[X]], align 4
; IS__CGSCC_OPM-NEXT:    ret i32 undef
; IS__CGSCC_OPM:       dead:
; IS__CGSCC_OPM-NEXT:    unreachable
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@test
; IS__CGSCC_NPM-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[X:%.*]])
; IS__CGSCC_NPM-NEXT:    br i1 true, label [[LIVE:%.*]], label [[DEAD:%.*]]
; IS__CGSCC_NPM:       live:
; IS__CGSCC_NPM-NEXT:    store i32 0, i32* [[X]], align 4
; IS__CGSCC_NPM-NEXT:    ret i32 undef
; IS__CGSCC_NPM:       dead:
; IS__CGSCC_NPM-NEXT:    unreachable
;
  br i1 true, label %live, label %dead
live:
  store i32 0, i32* %X
  ret i32 0
dead:
  call i32 @caller(i32* null)
  call void @dead()
  ret i32 1
}

define internal i32 @caller(i32* %B) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller
; IS__TUNIT____-SAME: (i32* noalias nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B:%.*]])
; IS__TUNIT____-NEXT:    [[A:%.*]] = alloca i32, align 4
; IS__TUNIT____-NEXT:    store i32 1, i32* [[A]], align 4
; IS__TUNIT____-NEXT:    [[C:%.*]] = call i32 @test(i32* noalias nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B]])
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@caller
; IS__CGSCC_OPM-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B:%.*]])
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    store i32 1, i32* [[A]], align 4
; IS__CGSCC_OPM-NEXT:    [[C:%.*]] = call i32 @test(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B]])
; IS__CGSCC_OPM-NEXT:    ret i32 0
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@caller
; IS__CGSCC_NPM-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B:%.*]])
; IS__CGSCC_NPM-NEXT:    [[A:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 1, i32* [[A]], align 4
; IS__CGSCC_NPM-NEXT:    [[C:%.*]] = call i32 @test(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B]])
; IS__CGSCC_NPM-NEXT:    ret i32 undef
;
  %A = alloca i32
  store i32 1, i32* %A
  %C = call i32 @test(i32* %B, i32* %A)
  ret i32 %C
}

define i32 @callercaller() {
; NOT_CGSCC_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@callercaller()
; NOT_CGSCC_NPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; NOT_CGSCC_NPM-NEXT:    store i32 2, i32* [[B]], align 4
; NOT_CGSCC_NPM-NEXT:    [[X:%.*]] = call i32 @caller(i32* noalias nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B]])
; NOT_CGSCC_NPM-NEXT:    ret i32 0
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@callercaller()
; IS__CGSCC_NPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 2, i32* [[B]], align 4
; IS__CGSCC_NPM-NEXT:    [[X:%.*]] = call i32 @caller(i32* noalias nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[B]])
; IS__CGSCC_NPM-NEXT:    ret i32 0
;
  %B = alloca i32
  store i32 2, i32* %B
  %X = call i32 @caller(i32* %B)
  ret i32 %X
}

