; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=16 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=16 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define void @f() {
; IS________OPM-LABEL: define {{[^@]+}}@f() {
; IS________OPM-NEXT:  entry:
; IS________OPM-NEXT:    [[A:%.*]] = alloca i32, align 1
; IS________OPM-NEXT:    call void @g(i32* noalias nocapture nofree noundef nonnull readonly dereferenceable(4) [[A]])
; IS________OPM-NEXT:    ret void
;
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@f() {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    [[A:%.*]] = alloca i32, align 1
; IS__TUNIT_NPM-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 1
; IS__TUNIT_NPM-NEXT:    call void @g(i32 [[TMP0]])
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@f() {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    call void @g(i32 undef)
; IS__CGSCC_NPM-NEXT:    ret void
;
entry:
  %a = alloca i32, align 1
  call void @g(i32* %a)
  ret void
}

define internal void @g(i32* %a) {
; IS________OPM-LABEL: define {{[^@]+}}@g
; IS________OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly dereferenceable(4) [[A:%.*]]) {
; IS________OPM-NEXT:    [[AA:%.*]] = load i32, i32* [[A]], align 1
; IS________OPM-NEXT:    call void @z(i32 [[AA]])
; IS________OPM-NEXT:    ret void
;
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@g
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]]) {
; IS__TUNIT_NPM-NEXT:    [[A_PRIV:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[A_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[AA:%.*]] = load i32, i32* [[A_PRIV]], align 1
; IS__TUNIT_NPM-NEXT:    call void @z(i32 [[AA]])
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@g
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]]) {
; IS__CGSCC_NPM-NEXT:    [[A_PRIV:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 undef, i32* [[A_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[AA:%.*]] = load i32, i32* [[A_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    call void @z(i32 [[AA]])
; IS__CGSCC_NPM-NEXT:    ret void
;
  %aa = load i32, i32* %a, align 1
  call void @z(i32 %aa)
  ret void
}

declare void @z(i32)

; Test2
; Different alignemnt privatizable arguments
define internal i32 @test(i32* %X, i64* %Y) {
; IS__TUNIT_OPM: Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@test
; IS__TUNIT_OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[X:%.*]], i64* noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[Y:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__TUNIT_OPM-NEXT:    [[A:%.*]] = load i32, i32* [[X]], align 4
; IS__TUNIT_OPM-NEXT:    [[B:%.*]] = load i64, i64* [[Y]], align 8
; IS__TUNIT_OPM-NEXT:    [[C:%.*]] = add i32 [[A]], 1
; IS__TUNIT_OPM-NEXT:    [[D:%.*]] = add i64 [[B]], 1
; IS__TUNIT_OPM-NEXT:    [[COND:%.*]] = icmp sgt i64 [[D]], -1
; IS__TUNIT_OPM-NEXT:    br i1 [[COND]], label [[RETURN1:%.*]], label [[RETURN2:%.*]]
; IS__TUNIT_OPM:       Return1:
; IS__TUNIT_OPM-NEXT:    ret i32 [[C]]
; IS__TUNIT_OPM:       Return2:
; IS__TUNIT_OPM-NEXT:    ret i32 [[A]]
;
; IS__TUNIT_NPM: Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@test
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__TUNIT_NPM-NEXT:    [[Y_PRIV:%.*]] = alloca i64, align 8
; IS__TUNIT_NPM-NEXT:    store i64 [[TMP1]], i64* [[Y_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[X_PRIV:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[X_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[A:%.*]] = load i32, i32* [[X_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[B:%.*]] = load i64, i64* [[Y_PRIV]], align 8
; IS__TUNIT_NPM-NEXT:    [[C:%.*]] = add i32 [[A]], 1
; IS__TUNIT_NPM-NEXT:    [[D:%.*]] = add i64 [[B]], 1
; IS__TUNIT_NPM-NEXT:    [[COND:%.*]] = icmp sgt i64 [[D]], -1
; IS__TUNIT_NPM-NEXT:    br i1 [[COND]], label [[RETURN1:%.*]], label [[RETURN2:%.*]]
; IS__TUNIT_NPM:       Return1:
; IS__TUNIT_NPM-NEXT:    ret i32 [[C]]
; IS__TUNIT_NPM:       Return2:
; IS__TUNIT_NPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@test
; IS__CGSCC_OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[X:%.*]], i64* noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[Y:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = load i32, i32* [[X]], align 4
; IS__CGSCC_OPM-NEXT:    [[B:%.*]] = load i64, i64* [[Y]], align 8
; IS__CGSCC_OPM-NEXT:    [[C:%.*]] = add i32 [[A]], 1
; IS__CGSCC_OPM-NEXT:    [[D:%.*]] = add i64 [[B]], 1
; IS__CGSCC_OPM-NEXT:    [[COND:%.*]] = icmp sgt i64 [[D]], -1
; IS__CGSCC_OPM-NEXT:    br i1 [[COND]], label [[RETURN1:%.*]], label [[RETURN2:%.*]]
; IS__CGSCC_OPM:       Return1:
; IS__CGSCC_OPM-NEXT:    ret i32 [[C]]
; IS__CGSCC_OPM:       Return2:
; IS__CGSCC_OPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@test
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    [[Y_PRIV:%.*]] = alloca i64, align 8
; IS__CGSCC_NPM-NEXT:    store i64 1, i64* [[Y_PRIV]], align 8
; IS__CGSCC_NPM-NEXT:    [[X_PRIV:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP0]], i32* [[X_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[A:%.*]] = load i32, i32* [[X_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[B:%.*]] = load i64, i64* [[Y_PRIV]], align 8
; IS__CGSCC_NPM-NEXT:    [[C:%.*]] = add i32 [[TMP0]], 1
; IS__CGSCC_NPM-NEXT:    [[D:%.*]] = add i64 [[B]], 1
; IS__CGSCC_NPM-NEXT:    [[COND:%.*]] = icmp sgt i64 [[D]], -1
; IS__CGSCC_NPM-NEXT:    br i1 [[COND]], label [[RETURN1:%.*]], label [[RETURN2:%.*]]
; IS__CGSCC_NPM:       Return1:
; IS__CGSCC_NPM-NEXT:    ret i32 [[C]]
; IS__CGSCC_NPM:       Return2:
; IS__CGSCC_NPM-NEXT:    ret i32 [[TMP0]]
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
; IS__TUNIT_OPM: Function Attrs: argmemonly nofree nosync nounwind willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@caller
; IS__TUNIT_OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__TUNIT_OPM-NEXT:    [[B:%.*]] = alloca i64, align 8
; IS__TUNIT_OPM-NEXT:    store i64 1, i64* [[B]], align 8
; IS__TUNIT_OPM-NEXT:    [[C:%.*]] = call i32 @test(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i64* noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B]]) #[[ATTR3:[0-9]+]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[C]]
;
; IS__TUNIT_NPM: Function Attrs: argmemonly nofree nosync nounwind willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@caller
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__TUNIT_NPM-NEXT:    [[A_PRIV:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[A_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[B:%.*]] = alloca i64, align 8
; IS__TUNIT_NPM-NEXT:    store i64 1, i64* [[B]], align 8
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = load i32, i32* [[A_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP3:%.*]] = load i64, i64* [[B]], align 8
; IS__TUNIT_NPM-NEXT:    [[C:%.*]] = call i32 @test(i32 [[TMP2]], i64 [[TMP3]]) #[[ATTR3:[0-9]+]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[C]]
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@caller
; IS__CGSCC_OPM-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    [[B:%.*]] = alloca i64, align 8
; IS__CGSCC_OPM-NEXT:    store i64 1, i64* [[B]], align 8
; IS__CGSCC_OPM-NEXT:    [[C:%.*]] = call i32 @test(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]], i64* noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B]]) #[[ATTR3:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[C]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@caller
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]]) #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[A_PRIV:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 2, i32* [[A_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = load i32, i32* [[A_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[C:%.*]] = call i32 @test(i32 [[TMP2]], i64 undef) #[[ATTR1:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[C]]
;
  %B = alloca i64
  store i64 1, i64* %B
  %C = call i32 @test(i32* %A, i64* %B)
  ret i32 %C
}

define i32 @callercaller() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@callercaller
; IS__TUNIT_OPM-SAME: () #[[ATTR2:[0-9]+]] {
; IS__TUNIT_OPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__TUNIT_OPM-NEXT:    store i32 2, i32* [[B]], align 4
; IS__TUNIT_OPM-NEXT:    [[X:%.*]] = call i32 @caller(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4:[0-9]+]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[X]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@callercaller
; IS__TUNIT_NPM-SAME: () #[[ATTR2:[0-9]+]] {
; IS__TUNIT_NPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 2, i32* [[B]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; IS__TUNIT_NPM-NEXT:    [[X:%.*]] = call i32 @caller(i32 [[TMP1]]) #[[ATTR4:[0-9]+]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[X]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@callercaller
; IS__CGSCC_OPM-SAME: () #[[ATTR2:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    store i32 2, i32* [[B]], align 4
; IS__CGSCC_OPM-NEXT:    [[X:%.*]] = call i32 @caller(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[B]]) #[[ATTR4:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[X]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@callercaller
; IS__CGSCC_NPM-SAME: () #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[X:%.*]] = call i32 @caller(i32 undef) #[[ATTR2:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[X]]
;
  %B = alloca i32
  store i32 2, i32* %B
  %X = call i32 @caller(i32* %B)
  ret i32 %X
}
;.
; IS__TUNIT____: attributes #[[ATTR0:[0-9]+]] = { argmemonly nofree nosync nounwind readonly willreturn }
; IS__TUNIT____: attributes #[[ATTR1:[0-9]+]] = { argmemonly nofree nosync nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR2:[0-9]+]] = { nofree nosync nounwind readnone }
; IS__TUNIT____: attributes #[[ATTR3:[0-9]+]] = { nofree nosync nounwind readonly willreturn }
; IS__TUNIT____: attributes #[[ATTR4:[0-9]+]] = { nofree nosync nounwind willreturn }
;.
; IS__CGSCC_OPM: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind readonly willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR1]] = { argmemonly nofree norecurse nosync nounwind willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR2]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR3]] = { nosync nounwind readonly willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR4]] = { nounwind willreturn }
;.
; IS__CGSCC_NPM: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR1]] = { nosync nounwind readnone willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR2]] = { nounwind readnone willreturn }
;.
