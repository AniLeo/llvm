; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define void @f() {
; IS__TUNIT____-LABEL: define {{[^@]+}}@f() {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    call void @g()
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@f() {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[A:%.*]] = alloca i32, align 1
; IS__CGSCC____-NEXT:    call void @g(i32* noalias nocapture nofree noundef nonnull readonly dereferenceable(4) [[A]])
; IS__CGSCC____-NEXT:    ret void
;
entry:
  %a = alloca i32, align 1
  call void @g(i32* %a)
  ret void
}

define internal void @g(i32* %a) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@g() {
; IS__TUNIT____-NEXT:    call void @z(i32 undef)
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@g
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull readonly dereferenceable(4) [[A:%.*]]) {
; IS__CGSCC____-NEXT:    [[AA:%.*]] = load i32, i32* [[A]], align 1
; IS__CGSCC____-NEXT:    call void @z(i32 [[AA]])
; IS__CGSCC____-NEXT:    ret void
;
  %aa = load i32, i32* %a, align 1
  call void @z(i32 %aa)
  ret void
}

declare void @z(i32)

; Test2
; Different alignemnt privatizable arguments
define internal i32 @test(i32* %X, i64* %Y) {
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[X:%.*]], i64* nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[Y:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:    [[A:%.*]] = load i32, i32* [[X]], align 4
; IS__CGSCC____-NEXT:    [[B:%.*]] = load i64, i64* [[Y]], align 8
; IS__CGSCC____-NEXT:    [[C:%.*]] = add i32 [[A]], 1
; IS__CGSCC____-NEXT:    [[D:%.*]] = add i64 [[B]], 1
; IS__CGSCC____-NEXT:    [[COND:%.*]] = icmp sgt i64 [[D]], -1
; IS__CGSCC____-NEXT:    br i1 [[COND]], label [[RETURN1:%.*]], label [[RETURN2:%.*]]
; IS__CGSCC____:       Return1:
; IS__CGSCC____-NEXT:    ret i32 [[C]]
; IS__CGSCC____:       Return2:
; IS__CGSCC____-NEXT:    ret i32 [[A]]
;
  %A = load i32, i32* %X
  %B = load i64, i64* %Y
  %C = add i32 %A, 1
  %D = add i64 %B, 1
  %cond = icmp sgt i64 %D, -1
  br i1 %cond, label %Return1, label %Return2
Return1:
  ret i32 %C
Return2:
  ret i32 %A
}

define internal i32 @caller(i32* %A) {
; IS__CGSCC____: Function Attrs: argmemonly nofree nosync nounwind willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC____-NEXT:    [[B:%.*]] = alloca i64, align 8
; IS__CGSCC____-NEXT:    store i64 1, i64* [[B]], align 8
; IS__CGSCC____-NEXT:    [[C:%.*]] = call i32 @test(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i64* noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B]]) #[[ATTR3:[0-9]+]]
; IS__CGSCC____-NEXT:    ret i32 [[C]]
;
  %B = alloca i64
  store i64 1, i64* %B
  %C = call i32 @test(i32* %A, i64* %B)
  ret i32 %C
}

define i32 @callercaller() {
; IS__TUNIT____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@callercaller
; IS__TUNIT____-SAME: () #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__TUNIT____-NEXT:    ret i32 3
;
; IS__CGSCC____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@callercaller
; IS__CGSCC____-SAME: () #[[ATTR2:[0-9]+]] {
; IS__CGSCC____-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC____-NEXT:    store i32 2, i32* [[B]], align 4
; IS__CGSCC____-NEXT:    [[X:%.*]] = call i32 @caller(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4:[0-9]+]]
; IS__CGSCC____-NEXT:    ret i32 [[X]]
;
  %B = alloca i32
  store i32 2, i32* %B
  %X = call i32 @caller(i32* %B)
  ret i32 %X
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind readonly willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { argmemonly nofree nosync nounwind willreturn }
; IS__CGSCC____: attributes #[[ATTR2]] = { nofree nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR3]] = { readonly willreturn }
; IS__CGSCC____: attributes #[[ATTR4]] = { nounwind willreturn }
;.
