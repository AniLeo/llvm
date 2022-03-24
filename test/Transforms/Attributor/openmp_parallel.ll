; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 514, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8

; %a is write only, %b is read only, neither is captured or freed, or ...
; FIXME: %a and %b are *not* readnone!

;.
; CHECK: @[[GLOB0:[0-9]+]] = private unnamed_addr constant [23 x i8] c"
; CHECK: @[[GLOB1:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 514, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
; CHECK: @[[GLOB2:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
;.
define dso_local void @func(float* nocapture %a, float* %b, i32 %N) local_unnamed_addr #0 {
; IS__TUNIT_OPM: Function Attrs: nounwind uwtable
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@func
; IS__TUNIT_OPM-SAME: (float* nocapture nofree writeonly [[A:%.*]], float* nocapture nofree readonly [[B:%.*]], i32 [[N:%.*]]) local_unnamed_addr #[[ATTR0:[0-9]+]] {
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    [[A_ADDR:%.*]] = alloca float*, align 8
; IS__TUNIT_OPM-NEXT:    [[B_ADDR:%.*]] = alloca float*, align 8
; IS__TUNIT_OPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__TUNIT_OPM-NEXT:    store float* [[A]], float** [[A_ADDR]], align 8
; IS__TUNIT_OPM-NEXT:    store float* [[B]], float** [[B_ADDR]], align 8
; IS__TUNIT_OPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB2]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float**, float**)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* noalias nocapture nofree nonnull readnone align 4 dereferenceable(4) undef, float** nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[A_ADDR]], float** nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B_ADDR]])
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM: Function Attrs: nounwind uwtable
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@func
; IS__TUNIT_NPM-SAME: (float* nocapture nofree writeonly [[A:%.*]], float* nocapture nofree readonly [[B:%.*]], i32 [[N:%.*]]) local_unnamed_addr #[[ATTR0:[0-9]+]] {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    [[A_ADDR:%.*]] = alloca float*, align 8
; IS__TUNIT_NPM-NEXT:    [[B_ADDR:%.*]] = alloca float*, align 8
; IS__TUNIT_NPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store float* [[A]], float** [[A_ADDR]], align 8
; IS__TUNIT_NPM-NEXT:    store float* [[B]], float** [[B_ADDR]], align 8
; IS__TUNIT_NPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB2]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float**, float**)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* noalias nocapture nofree nonnull readnone align 4 dereferenceable(4) undef, float** noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[A_ADDR]], float** noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B_ADDR]])
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: nounwind uwtable
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@func
; IS__CGSCC_OPM-SAME: (float* nocapture nofree [[A:%.*]], float* nofree [[B:%.*]], i32 [[N:%.*]]) local_unnamed_addr #[[ATTR0:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[A_ADDR:%.*]] = alloca float*, align 8
; IS__CGSCC_OPM-NEXT:    [[B_ADDR:%.*]] = alloca float*, align 8
; IS__CGSCC_OPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    store float* [[A]], float** [[A_ADDR]], align 8
; IS__CGSCC_OPM-NEXT:    store float* [[B]], float** [[B_ADDR]], align 8
; IS__CGSCC_OPM-NEXT:    store i32 199, i32* [[N_ADDR]], align 4
; IS__CGSCC_OPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB2]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float**, float**)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* noalias nocapture nofree noundef nonnull readnone align 4 dereferenceable(4) [[N_ADDR]], float** nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[A_ADDR]], float** nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B_ADDR]])
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: nounwind uwtable
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@func
; IS__CGSCC_NPM-SAME: (float* nocapture nofree [[A:%.*]], float* nofree [[B:%.*]], i32 [[N:%.*]]) local_unnamed_addr #[[ATTR0:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[A_ADDR:%.*]] = alloca float*, align 8
; IS__CGSCC_NPM-NEXT:    [[B_ADDR:%.*]] = alloca float*, align 8
; IS__CGSCC_NPM-NEXT:    [[N_ADDR:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    store float* [[A]], float** [[A_ADDR]], align 8
; IS__CGSCC_NPM-NEXT:    store float* [[B]], float** [[B_ADDR]], align 8
; IS__CGSCC_NPM-NEXT:    store i32 199, i32* [[N_ADDR]], align 4
; IS__CGSCC_NPM-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB2]], i32 noundef 3, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*, float**, float**)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* noalias nocapture nofree noundef nonnull readnone align 4 dereferenceable(4) [[N_ADDR]], float** noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[A_ADDR]], float** noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B_ADDR]])
; IS__CGSCC_NPM-NEXT:    ret void
;
entry:
  %a.addr = alloca float*, align 8
  %b.addr = alloca float*, align 8
  %N.addr = alloca i32, align 4
  store float* %a, float** %a.addr, align 8
  store float* %b, float** %b.addr, align 8
  store i32 199, i32* %N.addr, align 4
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @2, i32 3, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*, float**, float**)* @.omp_outlined. to void (i32*, i32*, ...)*), i32* nonnull %N.addr, float** nonnull %a.addr, float** nonnull %b.addr)
  ret void
}

; FIXME: %N should not be loaded but 199 should be used.

define internal void @.omp_outlined.(i32* noalias nocapture readonly %.global_tid., i32* noalias nocapture readnone %.bound_tid., i32* nocapture nonnull readonly align 4 dereferenceable(4) %N, float** nocapture nonnull readonly align 8 dereferenceable(8) %a, float** nocapture nonnull readonly align 8 dereferenceable(8) %b) #1 {
; IS________OPM: Function Attrs: alwaysinline nofree norecurse nounwind uwtable
; IS________OPM-LABEL: define {{[^@]+}}@.omp_outlined.
; IS________OPM-SAME: (i32* noalias nocapture nofree readonly [[DOTGLOBAL_TID_:%.*]], i32* noalias nocapture nofree readnone [[DOTBOUND_TID_:%.*]], i32* noalias nocapture nofree nonnull readnone align 4 dereferenceable(4) [[N:%.*]], float** nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[A:%.*]], float** nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B:%.*]]) #[[ATTR1:[0-9]+]] {
; IS________OPM-NEXT:  entry:
; IS________OPM-NEXT:    [[DOTOMP_LB:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    [[DOTOMP_UB:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    [[DOTOMP_STRIDE:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    [[DOTOMP_IS_LAST:%.*]] = alloca i32, align 4
; IS________OPM-NEXT:    br label [[OMP_PRECOND_THEN:%.*]]
; IS________OPM:       omp.precond.then:
; IS________OPM-NEXT:    [[TMP0:%.*]] = bitcast i32* [[DOTOMP_LB]] to i8*
; IS________OPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP0]])
; IS________OPM-NEXT:    store i32 0, i32* [[DOTOMP_LB]], align 4
; IS________OPM-NEXT:    [[TMP1:%.*]] = bitcast i32* [[DOTOMP_UB]] to i8*
; IS________OPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP1]])
; IS________OPM-NEXT:    store i32 197, i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    [[TMP2:%.*]] = bitcast i32* [[DOTOMP_STRIDE]] to i8*
; IS________OPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP2]])
; IS________OPM-NEXT:    store i32 1, i32* [[DOTOMP_STRIDE]], align 4
; IS________OPM-NEXT:    [[TMP3:%.*]] = bitcast i32* [[DOTOMP_IS_LAST]] to i8*
; IS________OPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP3]])
; IS________OPM-NEXT:    store i32 0, i32* [[DOTOMP_IS_LAST]], align 4
; IS________OPM-NEXT:    [[TMP4:%.*]] = load i32, i32* [[DOTGLOBAL_TID_]], align 4
; IS________OPM-NEXT:    call void @__kmpc_for_static_init_4(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 [[TMP4]], i32 noundef 34, i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_IS_LAST]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_LB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_UB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_STRIDE]], i32 noundef 1, i32 noundef 1)
; IS________OPM-NEXT:    [[TMP5:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    [[CMP4:%.*]] = icmp sgt i32 [[TMP5]], 197
; IS________OPM-NEXT:    [[COND:%.*]] = select i1 [[CMP4]], i32 197, i32 [[TMP5]]
; IS________OPM-NEXT:    store i32 [[COND]], i32* [[DOTOMP_UB]], align 4
; IS________OPM-NEXT:    [[TMP6:%.*]] = load i32, i32* [[DOTOMP_LB]], align 4
; IS________OPM-NEXT:    [[CMP513:%.*]] = icmp sgt i32 [[TMP6]], [[COND]]
; IS________OPM-NEXT:    br i1 [[CMP513]], label [[OMP_LOOP_EXIT:%.*]], label [[OMP_INNER_FOR_BODY_LR_PH:%.*]]
; IS________OPM:       omp.inner.for.body.lr.ph:
; IS________OPM-NEXT:    [[TMP7:%.*]] = load float*, float** [[B]], align 8
; IS________OPM-NEXT:    [[TMP8:%.*]] = load float*, float** [[A]], align 8
; IS________OPM-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP6]] to i64
; IS________OPM-NEXT:    [[TMP10:%.*]] = sext i32 [[COND]] to i64
; IS________OPM-NEXT:    br label [[OMP_INNER_FOR_BODY:%.*]]
; IS________OPM:       omp.inner.for.body:
; IS________OPM-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[OMP_INNER_FOR_BODY]] ], [ [[TMP9]], [[OMP_INNER_FOR_BODY_LR_PH]] ]
; IS________OPM-NEXT:    [[INDVARS_IV_NEXT]] = add nsw i64 [[INDVARS_IV]], 1
; IS________OPM-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[TMP7]], i64 [[INDVARS_IV_NEXT]]
; IS________OPM-NEXT:    [[TMP11:%.*]] = load float, float* [[ARRAYIDX]], align 4
; IS________OPM-NEXT:    [[CONV7:%.*]] = fadd float [[TMP11]], 1.000000e+00
; IS________OPM-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds float, float* [[TMP8]], i64 [[INDVARS_IV_NEXT]]
; IS________OPM-NEXT:    store float [[CONV7]], float* [[ARRAYIDX9]], align 4
; IS________OPM-NEXT:    [[CMP5:%.*]] = icmp slt i64 [[INDVARS_IV]], [[TMP10]]
; IS________OPM-NEXT:    br i1 [[CMP5]], label [[OMP_INNER_FOR_BODY]], label [[OMP_LOOP_EXIT]]
; IS________OPM:       omp.loop.exit:
; IS________OPM-NEXT:    call void @__kmpc_for_static_fini(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 [[TMP4]])
; IS________OPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP3]])
; IS________OPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP2]])
; IS________OPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP1]])
; IS________OPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP0]])
; IS________OPM-NEXT:    br label [[OMP_PRECOND_END:%.*]]
; IS________OPM:       omp.precond.end:
; IS________OPM-NEXT:    ret void
;
; IS________NPM: Function Attrs: alwaysinline nofree norecurse nounwind uwtable
; IS________NPM-LABEL: define {{[^@]+}}@.omp_outlined.
; IS________NPM-SAME: (i32* noalias nocapture nofree readonly [[DOTGLOBAL_TID_:%.*]], i32* noalias nocapture nofree readnone [[DOTBOUND_TID_:%.*]], i32* noalias nocapture nofree nonnull readnone align 4 dereferenceable(4) [[N:%.*]], float** noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[A:%.*]], float** noalias nocapture nofree noundef nonnull readonly align 8 dereferenceable(8) [[B:%.*]]) #[[ATTR1:[0-9]+]] {
; IS________NPM-NEXT:  entry:
; IS________NPM-NEXT:    [[DOTOMP_LB:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    [[DOTOMP_UB:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    [[DOTOMP_STRIDE:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    [[DOTOMP_IS_LAST:%.*]] = alloca i32, align 4
; IS________NPM-NEXT:    br label [[OMP_PRECOND_THEN:%.*]]
; IS________NPM:       omp.precond.then:
; IS________NPM-NEXT:    [[TMP0:%.*]] = bitcast i32* [[DOTOMP_LB]] to i8*
; IS________NPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP0]])
; IS________NPM-NEXT:    store i32 0, i32* [[DOTOMP_LB]], align 4
; IS________NPM-NEXT:    [[TMP1:%.*]] = bitcast i32* [[DOTOMP_UB]] to i8*
; IS________NPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP1]])
; IS________NPM-NEXT:    store i32 197, i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    [[TMP2:%.*]] = bitcast i32* [[DOTOMP_STRIDE]] to i8*
; IS________NPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP2]])
; IS________NPM-NEXT:    store i32 1, i32* [[DOTOMP_STRIDE]], align 4
; IS________NPM-NEXT:    [[TMP3:%.*]] = bitcast i32* [[DOTOMP_IS_LAST]] to i8*
; IS________NPM-NEXT:    call void @llvm.lifetime.start.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP3]])
; IS________NPM-NEXT:    store i32 0, i32* [[DOTOMP_IS_LAST]], align 4
; IS________NPM-NEXT:    [[TMP4:%.*]] = load i32, i32* [[DOTGLOBAL_TID_]], align 4
; IS________NPM-NEXT:    call void @__kmpc_for_static_init_4(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 [[TMP4]], i32 noundef 34, i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_IS_LAST]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_LB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_UB]], i32* noundef nonnull align 4 dereferenceable(4) [[DOTOMP_STRIDE]], i32 noundef 1, i32 noundef 1)
; IS________NPM-NEXT:    [[TMP5:%.*]] = load i32, i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    [[CMP4:%.*]] = icmp sgt i32 [[TMP5]], 197
; IS________NPM-NEXT:    [[COND:%.*]] = select i1 [[CMP4]], i32 197, i32 [[TMP5]]
; IS________NPM-NEXT:    store i32 [[COND]], i32* [[DOTOMP_UB]], align 4
; IS________NPM-NEXT:    [[TMP6:%.*]] = load i32, i32* [[DOTOMP_LB]], align 4
; IS________NPM-NEXT:    [[CMP513:%.*]] = icmp sgt i32 [[TMP6]], [[COND]]
; IS________NPM-NEXT:    br i1 [[CMP513]], label [[OMP_LOOP_EXIT:%.*]], label [[OMP_INNER_FOR_BODY_LR_PH:%.*]]
; IS________NPM:       omp.inner.for.body.lr.ph:
; IS________NPM-NEXT:    [[TMP7:%.*]] = load float*, float** [[B]], align 8
; IS________NPM-NEXT:    [[TMP8:%.*]] = load float*, float** [[A]], align 8
; IS________NPM-NEXT:    [[TMP9:%.*]] = sext i32 [[TMP6]] to i64
; IS________NPM-NEXT:    [[TMP10:%.*]] = sext i32 [[COND]] to i64
; IS________NPM-NEXT:    br label [[OMP_INNER_FOR_BODY:%.*]]
; IS________NPM:       omp.inner.for.body:
; IS________NPM-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[OMP_INNER_FOR_BODY]] ], [ [[TMP9]], [[OMP_INNER_FOR_BODY_LR_PH]] ]
; IS________NPM-NEXT:    [[INDVARS_IV_NEXT]] = add nsw i64 [[INDVARS_IV]], 1
; IS________NPM-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[TMP7]], i64 [[INDVARS_IV_NEXT]]
; IS________NPM-NEXT:    [[TMP11:%.*]] = load float, float* [[ARRAYIDX]], align 4
; IS________NPM-NEXT:    [[CONV7:%.*]] = fadd float [[TMP11]], 1.000000e+00
; IS________NPM-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds float, float* [[TMP8]], i64 [[INDVARS_IV_NEXT]]
; IS________NPM-NEXT:    store float [[CONV7]], float* [[ARRAYIDX9]], align 4
; IS________NPM-NEXT:    [[CMP5:%.*]] = icmp slt i64 [[INDVARS_IV]], [[TMP10]]
; IS________NPM-NEXT:    br i1 [[CMP5]], label [[OMP_INNER_FOR_BODY]], label [[OMP_LOOP_EXIT]]
; IS________NPM:       omp.loop.exit:
; IS________NPM-NEXT:    call void @__kmpc_for_static_fini(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) @[[GLOB1]], i32 [[TMP4]])
; IS________NPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP3]])
; IS________NPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP2]])
; IS________NPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP1]])
; IS________NPM-NEXT:    call void @llvm.lifetime.end.p0i8(i64 noundef 4, i8* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[TMP0]])
; IS________NPM-NEXT:    br label [[OMP_PRECOND_END:%.*]]
; IS________NPM:       omp.precond.end:
; IS________NPM-NEXT:    ret void
;
entry:
  %.omp.lb = alloca i32, align 4
  %.omp.ub = alloca i32, align 4
  %.omp.stride = alloca i32, align 4
  %.omp.is_last = alloca i32, align 4
  %0 = load i32, i32* %N, align 4
  %sub2 = add nsw i32 %0, -2
  %cmp = icmp sgt i32 %0, 1
  br i1 %cmp, label %omp.precond.then, label %omp.precond.end

omp.precond.then:                                 ; preds = %entry
  %1 = bitcast i32* %.omp.lb to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %1) #3
  store i32 0, i32* %.omp.lb, align 4
  %2 = bitcast i32* %.omp.ub to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %2) #3
  store i32 %sub2, i32* %.omp.ub, align 4
  %3 = bitcast i32* %.omp.stride to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  store i32 1, i32* %.omp.stride, align 4
  %4 = bitcast i32* %.omp.is_last to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #3
  store i32 0, i32* %.omp.is_last, align 4
  %5 = load i32, i32* %.global_tid., align 4
  call void @__kmpc_for_static_init_4(%struct.ident_t* nonnull @1, i32 %5, i32 34, i32* nonnull %.omp.is_last, i32* nonnull %.omp.lb, i32* nonnull %.omp.ub, i32* nonnull %.omp.stride, i32 1, i32 1) #3
  %6 = load i32, i32* %.omp.ub, align 4
  %cmp4 = icmp sgt i32 %6, %sub2
  %cond = select i1 %cmp4, i32 %sub2, i32 %6
  store i32 %cond, i32* %.omp.ub, align 4
  %7 = load i32, i32* %.omp.lb, align 4
  %cmp513 = icmp sgt i32 %7, %cond
  br i1 %cmp513, label %omp.loop.exit, label %omp.inner.for.body.lr.ph

omp.inner.for.body.lr.ph:                         ; preds = %omp.precond.then
  %8 = load float*, float** %b, align 8
  %9 = load float*, float** %a, align 8
  %10 = sext i32 %7 to i64
  %11 = sext i32 %cond to i64
  br label %omp.inner.for.body

omp.inner.for.body:                               ; preds = %omp.inner.for.body, %omp.inner.for.body.lr.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %omp.inner.for.body ], [ %10, %omp.inner.for.body.lr.ph ]
  %indvars.iv.next = add nsw i64 %indvars.iv, 1
  %arrayidx = getelementptr inbounds float, float* %8, i64 %indvars.iv.next
  %12 = load float, float* %arrayidx, align 4
  %conv7 = fadd float %12, 1.000000e+00
  %arrayidx9 = getelementptr inbounds float, float* %9, i64 %indvars.iv.next
  store float %conv7, float* %arrayidx9, align 4
  %cmp5 = icmp slt i64 %indvars.iv, %11
  br i1 %cmp5, label %omp.inner.for.body, label %omp.loop.exit

omp.loop.exit:                                    ; preds = %omp.inner.for.body, %omp.precond.then
  call void @__kmpc_for_static_fini(%struct.ident_t* nonnull @1, i32 %5)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %2) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %1) #3
  br label %omp.precond.end

omp.precond.end:                                  ; preds = %omp.loop.exit, %entry
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

declare dso_local void @__kmpc_for_static_init_4(%struct.ident_t*, i32, i32, i32*, i32*, i32*, i32*, i32, i32) local_unnamed_addr

; Function Attrs: nounwind
declare void @__kmpc_for_static_fini(%struct.ident_t*, i32) local_unnamed_addr #3

; Function Attrs: nounwind
declare !callback !1 void @__kmpc_fork_call(%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) local_unnamed_addr #3

attributes #0 = { nounwind uwtable }
attributes #1 = { alwaysinline nofree norecurse nounwind uwtable }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 7, !"openmp", i32 50}
!1 = !{!2}
!2 = !{i64 2, i64 -1, i64 -1, i1 true}
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { nounwind uwtable }
; CHECK: attributes #[[ATTR1:[0-9]+]] = { alwaysinline nofree norecurse nounwind uwtable }
; CHECK: attributes #[[ATTR2:[0-9]+]] = { argmemonly nocallback nofree nosync nounwind willreturn }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META1:![0-9]+]] = !{!2}
; CHECK: [[META2:![0-9]+]] = !{i64 2, i64 -1, i64 -1, i1 true}
;.
