; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR36543

; Don't promote arguments of musttail callee

%T = type { i32, i32, i32, i32 }

define internal i32 @test(%T* %p) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: (%T* nocapture nofree readonly [[P:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[A_GEP:%.*]] = getelementptr [[T:%.*]], %T* [[P]], i64 0, i32 3
; CHECK-NEXT:    [[B_GEP:%.*]] = getelementptr [[T]], %T* [[P]], i64 0, i32 2
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* [[A_GEP]], align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[B_GEP]], align 4
; CHECK-NEXT:    [[V:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[V]]
;
  %a.gep = getelementptr %T, %T* %p, i64 0, i32 3
  %b.gep = getelementptr %T, %T* %p, i64 0, i32 2
  %a = load i32, i32* %a.gep
  %b = load i32, i32* %b.gep
  %v = add i32 %a, %b
  ret i32 %v
}

define i32 @caller(%T* %p) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; CHECK-LABEL: define {{[^@]+}}@caller
; CHECK-SAME: (%T* nocapture nofree readonly [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[V:%.*]] = musttail call i32 @test(%T* nocapture nofree readonly [[P]]) #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    ret i32 [[V]]
;
  %v = musttail call i32 @test(%T* %p)
  ret i32 %v
}

; Don't promote arguments of musttail caller

define i32 @foo(%T* %p, i32 %v) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (%T* nocapture nofree readnone [[P:%.*]], i32 [[V:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define internal i32 @test2(%T* %p, i32 %p2) {
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test2
; IS__CGSCC____-SAME: (%T* nocapture nofree readonly [[P:%.*]], i32 [[P2:%.*]]) #[[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 0
;
  %a.gep = getelementptr %T, %T* %p, i64 0, i32 3
  %b.gep = getelementptr %T, %T* %p, i64 0, i32 2
  %a = load i32, i32* %a.gep
  %b = load i32, i32* %b.gep
  %v = add i32 %a, %b
  %ca = musttail call i32 @foo(%T* undef, i32 %v)
  ret i32 %ca
}

define i32 @caller2(%T* %g) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@caller2
; CHECK-SAME: (%T* nocapture nofree readnone [[G:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret i32 0
;
  %v = call i32 @test2(%T* %g, i32 0)
  ret i32 %v
}

; In the version above we can remove the call to foo completely.
; In the version below we keep the call and verify the return value
; is kept as well.

define i32 @bar(%T* %p, i32 %v) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (%T* nocapture nofree nonnull writeonly dereferenceable(4) [[P:%.*]], i32 [[V:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:    [[I32PTR:%.*]] = getelementptr [[T:%.*]], %T* [[P]], i64 0, i32 0
; CHECK-NEXT:    store i32 [[V]], i32* [[I32PTR]], align 4
; CHECK-NEXT:    ret i32 0
;
  %i32ptr = getelementptr %T, %T* %p, i64 0, i32 0
  store i32 %v, i32* %i32ptr
  ret i32 0
}

define internal i32 @test2b(%T* %p, i32 %p2) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn
; CHECK-LABEL: define {{[^@]+}}@test2b
; CHECK-SAME: (%T* nocapture nofree readonly [[P:%.*]], i32 [[P2:%.*]]) #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:    [[A_GEP:%.*]] = getelementptr [[T:%.*]], %T* [[P]], i64 0, i32 3
; CHECK-NEXT:    [[B_GEP:%.*]] = getelementptr [[T]], %T* [[P]], i64 0, i32 2
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* [[A_GEP]], align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[B_GEP]], align 4
; CHECK-NEXT:    [[V:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[CA:%.*]] = musttail call i32 @bar(%T* undef, i32 [[V]]) #[[ATTR5:[0-9]+]]
; CHECK-NEXT:    ret i32 [[CA]]
;
  %a.gep = getelementptr %T, %T* %p, i64 0, i32 3
  %b.gep = getelementptr %T, %T* %p, i64 0, i32 2
  %a = load i32, i32* %a.gep
  %b = load i32, i32* %b.gep
  %v = add i32 %a, %b
  %ca = musttail call i32 @bar(%T* undef, i32 %v)
  ret i32 %ca
}

define i32 @caller2b(%T* %g) {
; IS__TUNIT____: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller2b
; IS__TUNIT____-SAME: (%T* nocapture nofree readonly [[G:%.*]]) #[[ATTR3]] {
; IS__TUNIT____-NEXT:    [[V:%.*]] = call i32 @test2b(%T* nocapture nofree readonly [[G]], i32 undef) #[[ATTR6:[0-9]+]]
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller2b
; IS__CGSCC____-SAME: (%T* nocapture nofree readonly [[G:%.*]]) #[[ATTR3]] {
; IS__CGSCC____-NEXT:    [[V:%.*]] = call i32 @test2b(%T* nocapture nofree readonly [[G]], i32 noundef 0) #[[ATTR6:[0-9]+]]
; IS__CGSCC____-NEXT:    ret i32 0
;
  %v = call i32 @test2b(%T* %g, i32 0)
  ret i32 %v
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind readonly willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR2]] = { argmemonly nofree norecurse nosync nounwind willreturn writeonly }
; IS__TUNIT____: attributes #[[ATTR3]] = { argmemonly nofree norecurse nosync nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR4]] = { nofree nosync nounwind readonly willreturn }
; IS__TUNIT____: attributes #[[ATTR5]] = { nofree nosync nounwind willreturn writeonly }
; IS__TUNIT____: attributes #[[ATTR6]] = { nofree nosync nounwind willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind readonly willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR2]] = { argmemonly nofree norecurse nosync nounwind willreturn writeonly }
; IS__CGSCC____: attributes #[[ATTR3]] = { argmemonly nofree norecurse nosync nounwind willreturn }
; IS__CGSCC____: attributes #[[ATTR4]] = { readonly willreturn }
; IS__CGSCC____: attributes #[[ATTR5]] = { nounwind willreturn writeonly }
; IS__CGSCC____: attributes #[[ATTR6]] = { nounwind willreturn }
;.
