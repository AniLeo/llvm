; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define internal void @add({i32, i32}* %this, i32* sret(i32) %r) {
;
; IS__TUNIT____: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@add
; IS__TUNIT____-SAME: ({ i32, i32 }* noalias nocapture nofree nonnull readnone align 8 dereferenceable(8) [[THIS:%.*]], i32* noalias nocapture nofree noundef nonnull writeonly sret(i32) align 4 dereferenceable(4) [[R:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@add
; IS__CGSCC____-SAME: ({ i32, i32 }* nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[THIS:%.*]], i32* nocapture nofree noundef nonnull writeonly sret(i32) align 4 dereferenceable(4) [[R:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:    [[AP:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[THIS]], i32 0, i32 0
; IS__CGSCC____-NEXT:    [[BP:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[THIS]], i32 0, i32 1
; IS__CGSCC____-NEXT:    [[A:%.*]] = load i32, i32* [[AP]], align 8
; IS__CGSCC____-NEXT:    [[B:%.*]] = load i32, i32* [[BP]], align 4
; IS__CGSCC____-NEXT:    [[AB:%.*]] = add i32 [[A]], [[B]]
; IS__CGSCC____-NEXT:    store i32 [[AB]], i32* [[R]], align 4
; IS__CGSCC____-NEXT:    ret void
;
  %ap = getelementptr {i32, i32}, {i32, i32}* %this, i32 0, i32 0
  %bp = getelementptr {i32, i32}, {i32, i32}* %this, i32 0, i32 1
  %a = load i32, i32* %ap
  %b = load i32, i32* %bp
  %ab = add i32 %a, %b
  store i32 %ab, i32* %r
  ret void
}

define void @f() {
; IS__TUNIT____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@f
; IS__TUNIT____-SAME: () #[[ATTR1:[0-9]+]] {
; IS__TUNIT____-NEXT:    [[R:%.*]] = alloca i32, align 4
; IS__TUNIT____-NEXT:    call void @add({ i32, i32 }* noalias nocapture nofree nonnull readnone align 8 dereferenceable(8) undef, i32* noalias nocapture nofree noundef nonnull writeonly sret(i32) align 4 dereferenceable(4) [[R]]) #[[ATTR2:[0-9]+]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_OPM-SAME: () #[[ATTR1:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    [[R:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    [[PAIR:%.*]] = alloca { i32, i32 }, align 8
; IS__CGSCC_OPM-NEXT:    call void @add({ i32, i32 }* nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[PAIR]], i32* nocapture nofree noundef nonnull writeonly sret(i32) align 4 dereferenceable(4) [[R]]) #[[ATTR2:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_NPM-SAME: () #[[ATTR1:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    [[R:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    [[PAIR:%.*]] = alloca { i32, i32 }, align 8
; IS__CGSCC_NPM-NEXT:    call void @add({ i32, i32 }* noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[PAIR]], i32* noalias nocapture nofree noundef nonnull writeonly sret(i32) align 4 dereferenceable(4) [[R]]) #[[ATTR2:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    ret void
;
  %r = alloca i32
  %pair = alloca {i32, i32}

  call void @add({i32, i32}* %pair, i32* sret(i32) %r)
  ret void
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind willreturn writeonly }
; IS__TUNIT____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR2]] = { nofree nosync nounwind willreturn writeonly }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind willreturn }
; IS__CGSCC____: attributes #[[ATTR1:[0-9]+]] = { nofree nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR2:[0-9]+]] = { nounwind willreturn }
;.
