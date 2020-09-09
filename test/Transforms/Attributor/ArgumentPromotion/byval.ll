; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

%struct.ss = type { i32, i64 }

define internal i32 @f(%struct.ss* byval  %b) nounwind  {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@f
; IS__TUNIT_OPM-SAME: (%struct.ss* noalias nocapture nofree noundef nonnull byval align 8 dereferenceable(12) [[B:%.*]]) [[ATTR0:#.*]] {
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS:%.*]], %struct.ss* [[B]], i32 0, i32 0
; IS__TUNIT_OPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 8
; IS__TUNIT_OPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__TUNIT_OPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 8
; IS__TUNIT_OPM-NEXT:    ret i32 [[TMP1]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@f
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]]) [[ATTR0:#.*]] {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    [[B_PRIV:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__TUNIT_NPM-NEXT:    [[B_PRIV_CAST:%.*]] = bitcast %struct.ss* [[B_PRIV]] to i32*
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[B_PRIV_CAST]], align 4
; IS__TUNIT_NPM-NEXT:    [[B_PRIV_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 1
; IS__TUNIT_NPM-NEXT:    store i64 [[TMP1]], i64* [[B_PRIV_0_1]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 0
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 8
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 8
; IS__TUNIT_NPM-NEXT:    ret i32 [[TMP1]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_OPM-SAME: (%struct.ss* noalias nocapture nofree noundef nonnull byval align 32 dereferenceable(12) [[B:%.*]]) [[ATTR0:#.*]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS:%.*]], %struct.ss* [[B]], i32 0, i32 0
; IS__CGSCC_OPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 32
; IS__CGSCC_OPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__CGSCC_OPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 32
; IS__CGSCC_OPM-NEXT:    ret i32 [[TMP1]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]]) [[ATTR0:#.*]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[B_PRIV:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__CGSCC_NPM-NEXT:    [[B_PRIV_CAST:%.*]] = bitcast %struct.ss* [[B_PRIV]] to i32*
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP0]], i32* [[B_PRIV_CAST]], align 8
; IS__CGSCC_NPM-NEXT:    [[B_PRIV_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    store i64 [[TMP1]], i64* [[B_PRIV_0_1]], align 4
; IS__CGSCC_NPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 0
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 8
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 8
; IS__CGSCC_NPM-NEXT:    ret i32 [[TMP1]]
;
entry:
  %tmp = getelementptr %struct.ss, %struct.ss* %b, i32 0, i32 0
  %tmp1 = load i32, i32* %tmp, align 4
  %tmp2 = add i32 %tmp1, 1
  store i32 %tmp2, i32* %tmp, align 4
  ret i32 %tmp1
}


define internal i32 @g(%struct.ss* byval align 32 %b) nounwind {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@g
; IS__TUNIT_OPM-SAME: (%struct.ss* noalias nocapture nofree noundef nonnull byval align 32 dereferenceable(12) [[B:%.*]]) [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS:%.*]], %struct.ss* [[B]], i32 0, i32 0
; IS__TUNIT_OPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 32
; IS__TUNIT_OPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__TUNIT_OPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 32
; IS__TUNIT_OPM-NEXT:    ret i32 [[TMP2]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@g
; IS__TUNIT_NPM-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]]) [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    [[B_PRIV:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__TUNIT_NPM-NEXT:    [[B_PRIV_CAST:%.*]] = bitcast %struct.ss* [[B_PRIV]] to i32*
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[B_PRIV_CAST]], align 4
; IS__TUNIT_NPM-NEXT:    [[B_PRIV_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 1
; IS__TUNIT_NPM-NEXT:    store i64 [[TMP1]], i64* [[B_PRIV_0_1]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 0
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 32
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 32
; IS__TUNIT_NPM-NEXT:    ret i32 [[TMP2]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@g
; IS__CGSCC_OPM-SAME: (%struct.ss* noalias nocapture nofree noundef nonnull byval align 32 dereferenceable(12) [[B:%.*]]) [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS:%.*]], %struct.ss* [[B]], i32 0, i32 0
; IS__CGSCC_OPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 32
; IS__CGSCC_OPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__CGSCC_OPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 32
; IS__CGSCC_OPM-NEXT:    ret i32 [[TMP2]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@g
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]]) [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[B_PRIV:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__CGSCC_NPM-NEXT:    [[B_PRIV_CAST:%.*]] = bitcast %struct.ss* [[B_PRIV]] to i32*
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP0]], i32* [[B_PRIV_CAST]], align 32
; IS__CGSCC_NPM-NEXT:    [[B_PRIV_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    store i64 [[TMP1]], i64* [[B_PRIV_0_1]], align 4
; IS__CGSCC_NPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 0
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 32
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 32
; IS__CGSCC_NPM-NEXT:    ret i32 [[TMP2]]
;
entry:
  %tmp = getelementptr %struct.ss, %struct.ss* %b, i32 0, i32 0
  %tmp1 = load i32, i32* %tmp, align 4
  %tmp2 = add i32 %tmp1, 1
  store i32 %tmp2, i32* %tmp, align 4
  ret i32 %tmp2
}


define i32 @main() nounwind  {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@main
; IS__TUNIT_OPM-SAME: () [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__TUNIT_OPM-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__TUNIT_OPM-NEXT:    store i32 1, i32* [[TMP1]], align 8
; IS__TUNIT_OPM-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__TUNIT_OPM-NEXT:    store i64 2, i64* [[TMP4]], align 4
; IS__TUNIT_OPM-NEXT:    [[C0:%.*]] = call i32 @f(%struct.ss* noalias nocapture nofree noundef nonnull readonly byval align 8 dereferenceable(12) [[S]]) [[ATTR0]]
; IS__TUNIT_OPM-NEXT:    [[C1:%.*]] = call i32 @g(%struct.ss* noalias nocapture nofree noundef nonnull readonly byval align 32 dereferenceable(12) [[S]]) [[ATTR0]]
; IS__TUNIT_OPM-NEXT:    [[A:%.*]] = add i32 [[C0]], [[C1]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[A]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@main
; IS__TUNIT_NPM-SAME: () [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__TUNIT_NPM-NEXT:    store i32 1, i32* [[TMP1]], align 8
; IS__TUNIT_NPM-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__TUNIT_NPM-NEXT:    store i64 2, i64* [[TMP4]], align 4
; IS__TUNIT_NPM-NEXT:    [[S_CAST:%.*]] = bitcast %struct.ss* [[S]] to i32*
; IS__TUNIT_NPM-NEXT:    [[TMP0:%.*]] = load i32, i32* [[S_CAST]], align 8
; IS__TUNIT_NPM-NEXT:    [[S_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = load i64, i64* [[S_0_1]], align 8
; IS__TUNIT_NPM-NEXT:    [[C0:%.*]] = call i32 @f(i32 [[TMP0]], i64 [[TMP1]]) [[ATTR0]]
; IS__TUNIT_NPM-NEXT:    [[S_CAST1:%.*]] = bitcast %struct.ss* [[S]] to i32*
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = load i32, i32* [[S_CAST1]], align 32
; IS__TUNIT_NPM-NEXT:    [[S_0_12:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__TUNIT_NPM-NEXT:    [[TMP3:%.*]] = load i64, i64* [[S_0_12]], align 32
; IS__TUNIT_NPM-NEXT:    [[C1:%.*]] = call i32 @g(i32 [[TMP2]], i64 [[TMP3]]) [[ATTR0]]
; IS__TUNIT_NPM-NEXT:    [[A:%.*]] = add i32 [[C0]], [[C1]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@main
; IS__CGSCC_OPM-SAME: () [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__CGSCC_OPM-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__CGSCC_OPM-NEXT:    store i32 1, i32* [[TMP1]], align 32
; IS__CGSCC_OPM-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC_OPM-NEXT:    store i64 2, i64* [[TMP4]], align 4
; IS__CGSCC_OPM-NEXT:    [[C0:%.*]] = call i32 @f(%struct.ss* noalias nocapture nofree noundef nonnull readnone byval align 32 dereferenceable(12) [[S]]) [[ATTR1:#.*]]
; IS__CGSCC_OPM-NEXT:    [[C1:%.*]] = call i32 @g(%struct.ss* noalias nocapture nofree noundef nonnull readnone byval align 32 dereferenceable(12) [[S]]) [[ATTR1]]
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = add i32 [[C0]], [[C1]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@main
; IS__CGSCC_NPM-SAME: () [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 4
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__CGSCC_NPM-NEXT:    store i32 1, i32* [[TMP1]], align 32
; IS__CGSCC_NPM-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    store i64 2, i64* [[TMP4]], align 4
; IS__CGSCC_NPM-NEXT:    [[S_CAST:%.*]] = bitcast %struct.ss* [[S]] to i32*
; IS__CGSCC_NPM-NEXT:    [[TMP0:%.*]] = load i32, i32* [[S_CAST]], align 32
; IS__CGSCC_NPM-NEXT:    [[S_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = load i64, i64* [[S_0_1]], align 8
; IS__CGSCC_NPM-NEXT:    [[C0:%.*]] = call i32 @f(i32 [[TMP0]], i64 [[TMP1]]) [[ATTR1:#.*]]
; IS__CGSCC_NPM-NEXT:    [[S_CAST1:%.*]] = bitcast %struct.ss* [[S]] to i32*
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = load i32, i32* [[S_CAST1]], align 32
; IS__CGSCC_NPM-NEXT:    [[S_0_12:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    [[TMP3:%.*]] = load i64, i64* [[S_0_12]], align 32
; IS__CGSCC_NPM-NEXT:    [[C1:%.*]] = call i32 @g(i32 [[TMP2]], i64 [[TMP3]]) [[ATTR1]]
; IS__CGSCC_NPM-NEXT:    [[A:%.*]] = add i32 [[C0]], [[C1]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[A]]
;
entry:
  %S = alloca %struct.ss
  %tmp1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  store i32 1, i32* %tmp1, align 8
  %tmp4 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i64 2, i64* %tmp4, align 4
  %c0 = call i32 @f(%struct.ss* byval %S) nounwind
  %c1 = call i32 @g(%struct.ss* byval %S) nounwind
  %a = add i32 %c0, %c1
  ret i32 %a
}


