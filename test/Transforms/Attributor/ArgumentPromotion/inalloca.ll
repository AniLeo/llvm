; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

%struct.ss = type { i32, i32 }

; Argpromote + sroa should change this to passing the two integers by value.
define internal i32 @f(%struct.ss* inalloca(%struct.ss) %s) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@f
; IS__TUNIT____-SAME: (%struct.ss* noalias nocapture nofree noundef nonnull inalloca([[STRUCT_SS:%.*]]) align 4 dereferenceable(8) [[S:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__TUNIT____-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__TUNIT____-NEXT:    [[A:%.*]] = load i32, i32* [[F0]], align 4
; IS__TUNIT____-NEXT:    [[B:%.*]] = load i32, i32* [[F1]], align 4
; IS__TUNIT____-NEXT:    [[R:%.*]] = add i32 [[A]], [[B]]
; IS__TUNIT____-NEXT:    ret i32 [[R]]
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@f
; IS__CGSCC____-SAME: (%struct.ss* noalias nocapture nofree noundef nonnull inalloca([[STRUCT_SS:%.*]]) align 4 dereferenceable(8) [[S:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__CGSCC____-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC____-NEXT:    [[A:%.*]] = load i32, i32* [[F0]], align 4
; IS__CGSCC____-NEXT:    [[B:%.*]] = load i32, i32* [[F1]], align 4
; IS__CGSCC____-NEXT:    [[R:%.*]] = add i32 [[A]], [[B]]
; IS__CGSCC____-NEXT:    ret i32 [[R]]
;
entry:
  %f0 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 1
  %a = load i32, i32* %f0, align 4
  %b = load i32, i32* %f1, align 4
  %r = add i32 %a, %b
  ret i32 %r
}

define i32 @main() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@main
; IS__TUNIT____-SAME: () #[[ATTR1:[0-9]+]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[S:%.*]] = alloca inalloca [[STRUCT_SS:%.*]], align 4
; IS__TUNIT____-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__TUNIT____-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__TUNIT____-NEXT:    store i32 1, i32* [[F0]], align 4
; IS__TUNIT____-NEXT:    store i32 2, i32* [[F1]], align 4
; IS__TUNIT____-NEXT:    [[R:%.*]] = call i32 @f(%struct.ss* noalias nocapture nofree noundef nonnull inalloca([[STRUCT_SS]]) align 4 dereferenceable(8) [[S]]) #[[ATTR2:[0-9]+]]
; IS__TUNIT____-NEXT:    ret i32 [[R]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@main
; IS__CGSCC____-SAME: () #[[ATTR1:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[S:%.*]] = alloca inalloca [[STRUCT_SS:%.*]], align 4
; IS__CGSCC____-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__CGSCC____-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC____-NEXT:    store i32 1, i32* [[F0]], align 4
; IS__CGSCC____-NEXT:    store i32 2, i32* [[F1]], align 4
; IS__CGSCC____-NEXT:    [[R:%.*]] = call i32 @f(%struct.ss* noalias nocapture nofree noundef nonnull inalloca([[STRUCT_SS]]) align 4 dereferenceable(8) [[S]]) #[[ATTR2:[0-9]+]]
; IS__CGSCC____-NEXT:    ret i32 [[R]]
;
entry:
  %S = alloca inalloca %struct.ss
  %f0 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i32 1, i32* %f0, align 4
  store i32 2, i32* %f1, align 4
  %r = call i32 @f(%struct.ss* inalloca(%struct.ss) %S)
  ret i32 %r
}

; Argpromote can't promote %a because of the icmp use.
define internal i1 @g(%struct.ss* %a, %struct.ss* inalloca(%struct.ss) %b) nounwind  {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@g
; IS__CGSCC____-SAME: (%struct.ss* noalias nocapture nofree nonnull readnone align 4 dereferenceable(8) [[A:%.*]], %struct.ss* noalias nocapture nofree nonnull writeonly inalloca([[STRUCT_SS:%.*]]) align 4 dereferenceable(8) [[B:%.*]]) #[[ATTR1]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    ret i1 undef
;
entry:
  %c = icmp eq %struct.ss* %a, %b
  ret i1 %c
}

define i32 @test() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test
; IS__TUNIT____-SAME: () #[[ATTR1]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test
; IS__CGSCC____-SAME: () #[[ATTR1]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    ret i32 0
;
entry:
  %S = alloca inalloca %struct.ss
  %c = call i1 @g(%struct.ss* %S, %struct.ss* inalloca(%struct.ss) %S)
  ret i32 0
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { argmemonly nofree nosync nounwind readonly willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { nofree nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR2]] = { nofree nosync nounwind readonly willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind readonly willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR2]] = { nounwind readonly willreturn }
;.
