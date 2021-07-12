; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=15 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=15 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
;
;    void bar(int, float, double);
;
;    void foo(int N) {
;      float p = 3;
;      double q = 5;
;      N = 7;
;
;    #pragma omp parallel for firstprivate(q)
;      for (int i = 2; i < N; i++) {
;        bar(i, p, q);
;      }
;    }
;
; Verify the constant value of q is propagated into the outlined function.
;
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr global %struct.ident_t { i32 0, i32 514, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
@1 = private unnamed_addr global %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8

;.
; CHECK: @[[_STR:[a-zA-Z0-9_$"\\.-]+]] = private unnamed_addr constant [23 x i8] c"
; CHECK: @[[GLOB0:[0-9]+]] = private unnamed_addr global [[STRUCT_IDENT_T:%.*]] { i32 0, i32 514, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
; CHECK: @[[GLOB1:[0-9]+]] = private unnamed_addr global [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
;.
define dso_local void @foo(i32 %N) {
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@foo
; IS__TUNIT_OPM-SAME: (i32 [[N:%.*]]) {
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__TUNIT_OPM-NEXT:    [[P:%.*]] = alloca float, align 4
; IS__TUNIT_OPM-NEXT:    store i32 [[N]], i32* [[N_ADDR]], align 4
; IS__TUNIT_OPM-NEXT:    store float 3.000000e+00, float* [[P]], align 4
; IS__TUNIT_OPM-NEXT:    store i32 7, i32* [[N_ADDR]], align 4
; IS__TUNIT_OPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float*, i64)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[N_ADDR]], float* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P]], i64 undef)
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@foo
; IS__TUNIT_NPM-SAME: (i32 [[N:%.*]]) {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    [[P:%.*]] = alloca float, align 4
; IS__TUNIT_NPM-NEXT:    store i32 [[N]], i32* [[N_ADDR]], align 4
; IS__TUNIT_NPM-NEXT:    store float 3.000000e+00, float* [[P]], align 4
; IS__TUNIT_NPM-NEXT:    store i32 7, i32* [[N_ADDR]], align 4
; IS__TUNIT_NPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float*, i64)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[N_ADDR]], float* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P]], i64 undef)
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@foo
; IS__CGSCC_OPM-SAME: (i32 [[N:%.*]]) {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    [[P:%.*]] = alloca float, align 4
; IS__CGSCC_OPM-NEXT:    store i32 [[N]], i32* [[N_ADDR]], align 4
; IS__CGSCC_OPM-NEXT:    store float 3.000000e+00, float* [[P]], align 4
; IS__CGSCC_OPM-NEXT:    store i32 7, i32* [[N_ADDR]], align 4
; IS__CGSCC_OPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float*, i64)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[N_ADDR]], float* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P]], i64 noundef 4617315517961601024)
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@foo
; IS__CGSCC_NPM-SAME: (i32 [[N:%.*]]) {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    [[P:%.*]] = alloca float, align 4
; IS__CGSCC_NPM-NEXT:    store i32 [[N]], i32* [[N_ADDR]], align 4
; IS__CGSCC_NPM-NEXT:    store float 3.000000e+00, float* [[P]], align 4
; IS__CGSCC_NPM-NEXT:    store i32 7, i32* [[N_ADDR]], align 4
; IS__CGSCC_NPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float*, i64)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[N_ADDR]], float* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P]], i64 noundef 4617315517961601024)
; IS__CGSCC_NPM-NEXT:    ret void
;
entry:
  %N.addr = alloca i32, align 4
  %p = alloca float, align 4
  store i32 %N, i32* %N.addr, align 4
  store float 3.000000e+00, float* %p, align 4
  store i32 7, i32* %N.addr, align 4
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 3, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*, float*, i64)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* nonnull %N.addr, float* nonnull %p, i64 4617315517961601024)
  ret void
}

define internal void @.omp_outlined.(i32* noalias %.global_tid., i32* noalias %.bound_tid., i32* dereferenceable(4) %N, float* dereferenceable(4) %p, i64 %q) {
; IS________OPM-LABEL: define {{[^@]+}}@.omp_outlined.
; IS________OPM-SAME: (i32* noalias nocapture nofree readonly [[DOTGLOBAL_TID_:%.*]], i32* noalias nocapture nofree readnone [[DOTBOUND_TID_:%.*]], i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[N:%.*]], float* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P:%.*]], i64 [[Q:%.*]]) {
; IS________OPM-NEXT:  entry:
; IS________OPM-NEXT:    [[Q_ADDR:%.*]] = alloca i64, align 8
; IS________OPM-NEXT:    [[DOTOMP_LB:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    [[DOTOMP_UB:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    [[DOTOMP_STRIDE:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    [[DOTOMP_IS_LAST:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    store i64 4617315517961601024, i64* [[Q_ADDR]], align 8
; IS________OPM-NEXT:    [[CONV:%.*]] = bitcast i64* [[Q_ADDR]] to double*
; IS________OPM-NEXT:    [[TMP:%.*]] = load i32, i32* [[N]], align 4
; IS________OPM-NEXT:    [[SUB3:%.*]] = add nsw i32 [[TMP]], -3
; IS________OPM-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[TMP]], 2
; IS________OPM-NEXT:    br i1 [[CMP]], label [[OMP_PRECOND_THEN:%.*]], label [[OMP_PRECOND_END:%.*]]
; IS________OPM:       omp.precond.then:
; IS________OPM-NEXT:    store i32 0, i32* [[DOTOMP_LB]], align 4
; IS________OPM-NEXT:    store i32 [[SUB3]], i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    store i32 1, i32* [[DOTOMP_STRIDE]], align 4
; IS________OPM-NEXT:    store i32 0, i32* [[DOTOMP_IS_LAST]], align 4
; IS________OPM-NEXT:    [[TMP5:%.*]] = load i32, i32* [[DOTGLOBAL_TID_]], align 4
; IS________OPM-NEXT:    call void @__kmpc_for_static_init_4(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB0]], i32 [[TMP5]], i32 noundef 34, i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_IS_LAST]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_LB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_UB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_STRIDE]], i32 noundef 1, i32 noundef 1)
; IS________OPM-NEXT:    [[TMP6:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[TMP6]], [[SUB3]]
; IS________OPM-NEXT:    br i1 [[CMP6]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; IS________OPM:       cond.true:
; IS________OPM-NEXT:    br label [[COND_END:%.*]]
; IS________OPM:       cond.false:
; IS________OPM-NEXT:    [[TMP7:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    br label [[COND_END]]
; IS________OPM:       cond.end:
; IS________OPM-NEXT:    [[COND:%.*]] = phi i32 [ [[SUB3]], [[COND_TRUE]] ], [ [[TMP7]], [[COND_FALSE]] ]
; IS________OPM-NEXT:    store i32 [[COND]], i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    [[TMP8:%.*]] = load i32, i32* [[DOTOMP_LB]], align 4
; IS________OPM-NEXT:    br label [[OMP_INNER_FOR_COND:%.*]]
; IS________OPM:       omp.inner.for.cond:
; IS________OPM-NEXT:    [[DOTOMP_IV_0:%.*]] = phi i32 [ [[TMP8]], [[COND_END]] ], [ [[ADD11:%.*]], [[OMP_INNER_FOR_INC:%.*]] ]
; IS________OPM-NEXT:    [[TMP9:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    [[CMP8:%.*]] = icmp sgt i32 [[DOTOMP_IV_0]], [[TMP9]]
; IS________OPM-NEXT:    br i1 [[CMP8]], label [[OMP_INNER_FOR_COND_CLEANUP:%.*]], label [[OMP_INNER_FOR_BODY:%.*]]
; IS________OPM:       omp.inner.for.cond.cleanup:
; IS________OPM-NEXT:    br label [[OMP_INNER_FOR_END:%.*]]
; IS________OPM:       omp.inner.for.body:
; IS________OPM-NEXT:    [[ADD10:%.*]] = add nsw i32 [[DOTOMP_IV_0]], 2
; IS________OPM-NEXT:    [[TMP10:%.*]] = load float, float* [[P]], align 4
; IS________OPM-NEXT:    [[TMP11:%.*]] = load double, double* [[CONV]], align 8
; IS________OPM-NEXT:    call void @bar(i32 [[ADD10]], float [[TMP10]], double [[TMP11]])
; IS________OPM-NEXT:    br label [[OMP_BODY_CONTINUE:%.*]]
; IS________OPM:       omp.body.continue:
; IS________OPM-NEXT:    br label [[OMP_INNER_FOR_INC]]
; IS________OPM:       omp.inner.for.inc:
; IS________OPM-NEXT:    [[ADD11]] = add nsw i32 [[DOTOMP_IV_0]], 1
; IS________OPM-NEXT:    br label [[OMP_INNER_FOR_COND]]
; IS________OPM:       omp.inner.for.end:
; IS________OPM-NEXT:    br label [[OMP_LOOP_EXIT:%.*]]
; IS________OPM:       omp.loop.exit:
; IS________OPM-NEXT:    [[TMP12:%.*]] = load i32, i32* [[DOTGLOBAL_TID_]], align 4
; IS________OPM-NEXT:    call void @__kmpc_for_static_fini(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB0]], i32 [[TMP12]])
; IS________OPM-NEXT:    br label [[OMP_PRECOND_END]]
; IS________OPM:       omp.precond.end:
; IS________OPM-NEXT:    ret void
;
; IS________NPM-LABEL: define {{[^@]+}}@.omp_outlined.
; IS________NPM-SAME: (i32* noalias nocapture nofree readonly [[DOTGLOBAL_TID_:%.*]], i32* noalias nocapture nofree readnone [[DOTBOUND_TID_:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[N:%.*]], float* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P:%.*]], i64 [[Q:%.*]]) {
; IS________NPM-NEXT:  entry:
; IS________NPM-NEXT:    [[Q_ADDR:%.*]] = alloca i64, align 8
; IS________NPM-NEXT:    [[DOTOMP_LB:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    [[DOTOMP_UB:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    [[DOTOMP_STRIDE:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    [[DOTOMP_IS_LAST:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    store i64 4617315517961601024, i64* [[Q_ADDR]], align 8
; IS________NPM-NEXT:    [[CONV:%.*]] = bitcast i64* [[Q_ADDR]] to double*
; IS________NPM-NEXT:    [[TMP:%.*]] = load i32, i32* [[N]], align 4
; IS________NPM-NEXT:    [[SUB3:%.*]] = add nsw i32 [[TMP]], -3
; IS________NPM-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[TMP]], 2
; IS________NPM-NEXT:    br i1 [[CMP]], label [[OMP_PRECOND_THEN:%.*]], label [[OMP_PRECOND_END:%.*]]
; IS________NPM:       omp.precond.then:
; IS________NPM-NEXT:    store i32 0, i32* [[DOTOMP_LB]], align 4
; IS________NPM-NEXT:    store i32 [[SUB3]], i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    store i32 1, i32* [[DOTOMP_STRIDE]], align 4
; IS________NPM-NEXT:    store i32 0, i32* [[DOTOMP_IS_LAST]], align 4
; IS________NPM-NEXT:    [[TMP5:%.*]] = load i32, i32* [[DOTGLOBAL_TID_]], align 4
; IS________NPM-NEXT:    call void @__kmpc_for_static_init_4(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB0]], i32 [[TMP5]], i32 noundef 34, i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_IS_LAST]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_LB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_UB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_STRIDE]], i32 noundef 1, i32 noundef 1)
; IS________NPM-NEXT:    [[TMP6:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[TMP6]], [[SUB3]]
; IS________NPM-NEXT:    br i1 [[CMP6]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; IS________NPM:       cond.true:
; IS________NPM-NEXT:    br label [[COND_END:%.*]]
; IS________NPM:       cond.false:
; IS________NPM-NEXT:    [[TMP7:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    br label [[COND_END]]
; IS________NPM:       cond.end:
; IS________NPM-NEXT:    [[COND:%.*]] = phi i32 [ [[SUB3]], [[COND_TRUE]] ], [ [[TMP7]], [[COND_FALSE]] ]
; IS________NPM-NEXT:    store i32 [[COND]], i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    [[TMP8:%.*]] = load i32, i32* [[DOTOMP_LB]], align 4
; IS________NPM-NEXT:    br label [[OMP_INNER_FOR_COND:%.*]]
; IS________NPM:       omp.inner.for.cond:
; IS________NPM-NEXT:    [[DOTOMP_IV_0:%.*]] = phi i32 [ [[TMP8]], [[COND_END]] ], [ [[ADD11:%.*]], [[OMP_INNER_FOR_INC:%.*]] ]
; IS________NPM-NEXT:    [[TMP9:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    [[CMP8:%.*]] = icmp sgt i32 [[DOTOMP_IV_0]], [[TMP9]]
; IS________NPM-NEXT:    br i1 [[CMP8]], label [[OMP_INNER_FOR_COND_CLEANUP:%.*]], label [[OMP_INNER_FOR_BODY:%.*]]
; IS________NPM:       omp.inner.for.cond.cleanup:
; IS________NPM-NEXT:    br label [[OMP_INNER_FOR_END:%.*]]
; IS________NPM:       omp.inner.for.body:
; IS________NPM-NEXT:    [[ADD10:%.*]] = add nsw i32 [[DOTOMP_IV_0]], 2
; IS________NPM-NEXT:    [[TMP10:%.*]] = load float, float* [[P]], align 4
; IS________NPM-NEXT:    [[TMP11:%.*]] = load double, double* [[CONV]], align 8
; IS________NPM-NEXT:    call void @bar(i32 [[ADD10]], float [[TMP10]], double [[TMP11]])
; IS________NPM-NEXT:    br label [[OMP_BODY_CONTINUE:%.*]]
; IS________NPM:       omp.body.continue:
; IS________NPM-NEXT:    br label [[OMP_INNER_FOR_INC]]
; IS________NPM:       omp.inner.for.inc:
; IS________NPM-NEXT:    [[ADD11]] = add nsw i32 [[DOTOMP_IV_0]], 1
; IS________NPM-NEXT:    br label [[OMP_INNER_FOR_COND]]
; IS________NPM:       omp.inner.for.end:
; IS________NPM-NEXT:    br label [[OMP_LOOP_EXIT:%.*]]
; IS________NPM:       omp.loop.exit:
; IS________NPM-NEXT:    [[TMP12:%.*]] = load i32, i32* [[DOTGLOBAL_TID_]], align 4
; IS________NPM-NEXT:    call void @__kmpc_for_static_fini(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB0]], i32 [[TMP12]])
; IS________NPM-NEXT:    br label [[OMP_PRECOND_END]]
; IS________NPM:       omp.precond.end:
; IS________NPM-NEXT:    ret void
;
entry:
  %q.addr = alloca i64, align 8
  %.omp.lb = alloca i32, align 4
  %.omp.ub = alloca i32, align 4
  %.omp.stride = alloca i32, align 4
  %.omp.is_last = alloca i32, align 4
  store i64 %q, i64* %q.addr, align 8
  %conv = bitcast i64* %q.addr to double*
  %tmp = load i32, i32* %N, align 4
  %sub3 = add nsw i32 %tmp, -3
  %cmp = icmp sgt i32 %tmp, 2
  br i1 %cmp, label %omp.precond.then, label %omp.precond.end

omp.precond.then:                                 ; preds = %entry
  store i32 0, i32* %.omp.lb, align 4
  store i32 %sub3, i32* %.omp.ub, align 4
  store i32 1, i32* %.omp.stride, align 4
  store i32 0, i32* %.omp.is_last, align 4
  %tmp5 = load i32, i32* %.global_tid., align 4
  call void @__kmpc_for_static_init_4(%struct.ident_t* nonnull @0, i32 %tmp5, i32 34, i32* nonnull %.omp.is_last, i32* nonnull %.omp.lb, i32* nonnull %.omp.ub, i32* nonnull %.omp.stride, i32 1, i32 1)
  %tmp6 = load i32, i32* %.omp.ub, align 4
  %cmp6 = icmp sgt i32 %tmp6, %sub3
  br i1 %cmp6, label %cond.true, label %cond.false

cond.true:                                        ; preds = %omp.precond.then
  br label %cond.end

cond.false:                                       ; preds = %omp.precond.then
  %tmp7 = load i32, i32* %.omp.ub, align 4
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %sub3, %cond.true ], [ %tmp7, %cond.false ]
  store i32 %cond, i32* %.omp.ub, align 4
  %tmp8 = load i32, i32* %.omp.lb, align 4
  br label %omp.inner.for.cond

omp.inner.for.cond:                               ; preds = %omp.inner.for.inc, %cond.end
  %.omp.iv.0 = phi i32 [ %tmp8, %cond.end ], [ %add11, %omp.inner.for.inc ]
  %tmp9 = load i32, i32* %.omp.ub, align 4
  %cmp8 = icmp sgt i32 %.omp.iv.0, %tmp9
  br i1 %cmp8, label %omp.inner.for.cond.cleanup, label %omp.inner.for.body

omp.inner.for.cond.cleanup:                       ; preds = %omp.inner.for.cond
  br label %omp.inner.for.end

omp.inner.for.body:                               ; preds = %omp.inner.for.cond
  %add10 = add nsw i32 %.omp.iv.0, 2
  %tmp10 = load float, float* %p, align 4
  %tmp11 = load double, double* %conv, align 8
  call void @bar(i32 %add10, float %tmp10, double %tmp11)
  br label %omp.body.continue

omp.body.continue:                                ; preds = %omp.inner.for.body
  br label %omp.inner.for.inc

omp.inner.for.inc:                                ; preds = %omp.body.continue
  %add11 = add nsw i32 %.omp.iv.0, 1
  br label %omp.inner.for.cond

omp.inner.for.end:                                ; preds = %omp.inner.for.cond.cleanup
  br label %omp.loop.exit

omp.loop.exit:                                    ; preds = %omp.inner.for.end
  %tmp12 = load i32, i32* %.global_tid., align 4
  call void @__kmpc_for_static_fini(%struct.ident_t* nonnull @0, i32 %tmp12)
  br label %omp.precond.end

omp.precond.end:                                  ; preds = %omp.loop.exit, %entry
  ret void
}

declare dso_local void @__kmpc_for_static_init_4(%struct.ident_t*, i32, i32, i32*, i32*, i32*, i32*, i32, i32)

declare dso_local void @bar(i32, float, double)

declare dso_local void @__kmpc_for_static_fini(%struct.ident_t*, i32)

declare !callback !0 dso_local void @__kmpc_fork_call(%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...)

!1 = !{i64 2, i64 -1, i64 -1, i1 true}
!0 = !{!1}
;.
; CHECK: [[META0:![0-9]+]] = !{!1}
; CHECK: [[META1:![0-9]+]] = !{i64 2, i64 -1, i64 -1, i1 true}
;.
