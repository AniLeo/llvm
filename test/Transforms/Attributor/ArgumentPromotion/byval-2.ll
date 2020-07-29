; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

%struct.ss = type { i32, i64 }

define internal void @f(%struct.ss* byval  %b, i32* byval %X) nounwind  {
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_OPM-SAME: (%struct.ss* noalias nocapture nofree nonnull byval align 8 dereferenceable(12) [[B:%.*]], i32* noalias nocapture nofree nonnull writeonly byval align 4 dereferenceable(4) [[X:%.*]])
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS:%.*]], %struct.ss* [[B]], i32 0, i32 0
; IS__CGSCC_OPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 8
; IS__CGSCC_OPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__CGSCC_OPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 8
; IS__CGSCC_OPM-NEXT:    store i32 0, i32* [[X]], align 4
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_NPM-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]], i32 [[TMP2:%.*]])
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[X_PRIV:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP2]], i32* [[X_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    [[B_PRIV:%.*]] = alloca [[STRUCT_SS:%.*]], align 8
; IS__CGSCC_NPM-NEXT:    [[B_PRIV_CAST:%.*]] = bitcast %struct.ss* [[B_PRIV]] to i32*
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP0]], i32* [[B_PRIV_CAST]], align 4
; IS__CGSCC_NPM-NEXT:    [[B_PRIV_0_1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    store i64 [[TMP1]], i64* [[B_PRIV_0_1]], align 4
; IS__CGSCC_NPM-NEXT:    [[TMP:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[B_PRIV]], i32 0, i32 0
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 8
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = add i32 [[TMP1]], 1
; IS__CGSCC_NPM-NEXT:    store i32 [[TMP2]], i32* [[TMP]], align 8
; IS__CGSCC_NPM-NEXT:    store i32 0, i32* [[X_PRIV]], align 4
; IS__CGSCC_NPM-NEXT:    ret void
;
entry:
  %tmp = getelementptr %struct.ss, %struct.ss* %b, i32 0, i32 0
  %tmp1 = load i32, i32* %tmp, align 4
  %tmp2 = add i32 %tmp1, 1
  store i32 %tmp2, i32* %tmp, align 4

  store i32 0, i32* %X
  ret void
}

define i32 @test(i32* %X) {
;
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test
; IS__TUNIT____-SAME: (i32* nocapture nofree readonly align 4 [[X:%.*]])
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 8
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__TUNIT____-NEXT:    store i32 1, i32* [[TMP1]], align 8
; IS__TUNIT____-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__TUNIT____-NEXT:    store i64 2, i64* [[TMP4]], align 4
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@test
; IS__CGSCC_OPM-SAME: (i32* nocapture nofree nonnull readnone align 4 dereferenceable(4) [[X:%.*]])
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 8
; IS__CGSCC_OPM-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__CGSCC_OPM-NEXT:    store i32 1, i32* [[TMP1]], align 8
; IS__CGSCC_OPM-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC_OPM-NEXT:    store i64 2, i64* [[TMP4]], align 4
; IS__CGSCC_OPM-NEXT:    ret i32 0
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@test
; IS__CGSCC_NPM-SAME: (i32* nocapture nofree nonnull readonly align 4 dereferenceable(4) [[X:%.*]])
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[S:%.*]] = alloca [[STRUCT_SS:%.*]], align 8
; IS__CGSCC_NPM-NEXT:    [[TMP1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; IS__CGSCC_NPM-NEXT:    store i32 1, i32* [[TMP1]], align 8
; IS__CGSCC_NPM-NEXT:    [[TMP4:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; IS__CGSCC_NPM-NEXT:    store i64 2, i64* [[TMP4]], align 4
; IS__CGSCC_NPM-NEXT:    ret i32 0
;
entry:
  %S = alloca %struct.ss
  %tmp1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  store i32 1, i32* %tmp1, align 8
  %tmp4 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i64 2, i64* %tmp4, align 4
  call void @f( %struct.ss* byval %S, i32* byval %X)
  ret i32 0
}
