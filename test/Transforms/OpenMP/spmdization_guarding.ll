; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -passes=openmp-opt < %s | FileCheck %s
; RUN: opt -S -passes=openmp-opt -openmp-opt-disable-spmdization < %s | FileCheck %s --check-prefix=CHECK-DISABLED
;
;    void pure(void) __attribute__((pure, assume("ompx_spmd_amenable")));
;    int no_openmp(int *) __attribute__((assume("omp_no_openmp","ompx_spmd_amenable")));
;
;    void sequential_loop(int *x, int N) {
;    #pragma omp target teams
;      {
;        x[0] = 0;
;        x[1] = 1;
;        x[N] = N;
;        for (int i = 2; i < N - 1; ++i)
;          x[i] = i - 1;
;        #pragma omp parallel
;        {}
;        int r1 = no_openmp(x);
;        x[r1] = r1;
;        int r2 = no_openmp(x);
;        x[r2] = r2;
;        int r3 = no_openmp(x);
;        x[r3] = r3;
;
;        no_openmp(x);
;        pure();
;        no_openmp(x);
;        pure();
;        no_openmp(x);
;        pure();
;      }
;    }
;
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8
@__omp_offloading_2a_fbfa7a_sequential_loop_l6_exec_mode = weak constant i8 1
@llvm.compiler.used = appending global [1 x i8*] [i8* @__omp_offloading_2a_fbfa7a_sequential_loop_l6_exec_mode], section "llvm.metadata"

; Function Attrs: convergent norecurse nounwind
;.
; CHECK: @[[GLOB0:[0-9]+]] = private unnamed_addr constant [23 x i8] c"
; CHECK: @[[GLOB1:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
; CHECK: @[[__OMP_OFFLOADING_2A_FBFA7A_SEQUENTIAL_LOOP_L6_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 2
; CHECK: @[[LLVM_COMPILER_USED:[a-zA-Z0-9_$"\\.-]+]] = appending global [1 x i8*] [i8* @__omp_offloading_2a_fbfa7a_sequential_loop_l6_exec_mode], section "llvm.metadata"
;.
; CHECK-DISABLED: @[[GLOB0:[0-9]+]] = private unnamed_addr constant [23 x i8] c"
; CHECK-DISABLED: @[[GLOB1:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
; CHECK-DISABLED: @[[__OMP_OFFLOADING_2A_FBFA7A_SEQUENTIAL_LOOP_L6_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 1
; CHECK-DISABLED: @[[LLVM_COMPILER_USED:[a-zA-Z0-9_$"\\.-]+]] = appending global [1 x i8*] [i8* @__omp_offloading_2a_fbfa7a_sequential_loop_l6_exec_mode], section "llvm.metadata"
; CHECK-DISABLED: @[[__OMP_OUTLINED__1_WRAPPER_ID:[a-zA-Z0-9_$"\\.-]+]] = private constant i8 undef
;.
define weak void @__omp_offloading_2a_fbfa7a_sequential_loop_l6(i32* %x, i64 %N) #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_offloading_2a_fbfa7a_sequential_loop_l6
; CHECK-SAME: (i32* [[X:%.*]], i64 [[N:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[N_ADDR_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[N]] to i32
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* nonnull @[[GLOB1]], i1 true, i1 false, i1 false) #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[WORKER_EXIT:%.*]]
; CHECK:       user_code.entry:
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @[[GLOB1]]) #[[ATTR4]]
; CHECK-NEXT:    [[ARRAYIDX1_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 1
; CHECK-NEXT:    [[SEXT:%.*]] = shl i64 [[N]], 32
; CHECK-NEXT:    [[IDXPROM_I:%.*]] = ashr exact i64 [[SEXT]], 32
; CHECK-NEXT:    [[ARRAYIDX2_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM_I]]
; CHECK-NEXT:    br label [[REGION_CHECK_TID:%.*]]
; CHECK:       region.check.tid:
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @__kmpc_get_hardware_thread_id_in_block()
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[REGION_GUARDED:%.*]], label [[REGION_BARRIER:%.*]]
; CHECK:       region.guarded:
; CHECK-NEXT:    store i32 0, i32* [[X]], align 4, !noalias !8
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1_I]], align 4, !noalias !8
; CHECK-NEXT:    store i32 [[N_ADDR_SROA_0_0_EXTRACT_TRUNC]], i32* [[ARRAYIDX2_I]], align 4, !noalias !8
; CHECK-NEXT:    br label [[REGION_GUARDED_END:%.*]]
; CHECK:       region.guarded.end:
; CHECK-NEXT:    br label [[REGION_BARRIER]]
; CHECK:       region.barrier:
; CHECK-NEXT:    call void @__kmpc_barrier_simple_spmd(%struct.ident_t* @[[GLOB1]], i32 [[TMP2]])
; CHECK-NEXT:    br label [[REGION_EXIT:%.*]]
; CHECK:       region.exit:
; CHECK-NEXT:    br label [[FOR_COND_I:%.*]]
; CHECK:       for.cond.i:
; CHECK-NEXT:    [[I_0_I:%.*]] = phi i32 [ 2, [[REGION_EXIT]] ], [ [[INC_I:%.*]], [[REGION_EXIT3:%.*]] ]
; CHECK-NEXT:    [[SUB_I:%.*]] = add nsw i32 [[N_ADDR_SROA_0_0_EXTRACT_TRUNC]], -1
; CHECK-NEXT:    [[CMP_I:%.*]] = icmp slt i32 [[I_0_I]], [[SUB_I]]
; CHECK-NEXT:    br i1 [[CMP_I]], label [[FOR_BODY_I:%.*]], label [[__OMP_OUTLINED___EXIT:%.*]]
; CHECK:       for.body.i:
; CHECK-NEXT:    [[SUB3_I:%.*]] = add nsw i32 [[I_0_I]], -1
; CHECK-NEXT:    [[IDXPROM4_I:%.*]] = zext i32 [[I_0_I]] to i64
; CHECK-NEXT:    [[ARRAYIDX5_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM4_I]]
; CHECK-NEXT:    br label [[REGION_CHECK_TID5:%.*]]
; CHECK:       region.check.tid5:
; CHECK-NEXT:    [[TMP4:%.*]] = call i32 @__kmpc_get_hardware_thread_id_in_block()
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i32 [[TMP4]], 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[REGION_GUARDED4:%.*]], label [[REGION_BARRIER2:%.*]]
; CHECK:       region.guarded4:
; CHECK-NEXT:    store i32 [[SUB3_I]], i32* [[ARRAYIDX5_I]], align 4, !noalias !8
; CHECK-NEXT:    br label [[REGION_GUARDED_END1:%.*]]
; CHECK:       region.guarded.end1:
; CHECK-NEXT:    br label [[REGION_BARRIER2]]
; CHECK:       region.barrier2:
; CHECK-NEXT:    call void @__kmpc_barrier_simple_spmd(%struct.ident_t* @[[GLOB1]], i32 [[TMP4]])
; CHECK-NEXT:    br label [[REGION_EXIT3]]
; CHECK:       region.exit3:
; CHECK-NEXT:    [[INC_I]] = add nuw nsw i32 [[I_0_I]], 1
; CHECK-NEXT:    br label [[FOR_COND_I]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       __omp_outlined__.exit:
; CHECK-NEXT:    call void @__kmpc_parallel_51(%struct.ident_t* null, i32 0, i32 1, i32 -1, i32 -1, i8* bitcast (void (i32*, i32*)* @__omp_outlined__1 to i8*), i8* bitcast (void (i16, i32)* @__omp_outlined__1_wrapper to i8*), i8** null, i64 0)
; CHECK-NEXT:    [[CALL_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7:[0-9]+]], !noalias !8
; CHECK-NEXT:    [[IDXPROM6_I:%.*]] = sext i32 [[CALL_I]] to i64
; CHECK-NEXT:    [[ARRAYIDX7_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM6_I]]
; CHECK-NEXT:    br label [[REGION_CHECK_TID10:%.*]]
; CHECK:       region.check.tid10:
; CHECK-NEXT:    [[TMP6:%.*]] = call i32 @__kmpc_get_hardware_thread_id_in_block()
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i32 [[TMP6]], 0
; CHECK-NEXT:    br i1 [[TMP7]], label [[REGION_GUARDED9:%.*]], label [[REGION_BARRIER7:%.*]]
; CHECK:       region.guarded9:
; CHECK-NEXT:    store i32 [[CALL_I]], i32* [[ARRAYIDX7_I]], align 4, !noalias !8
; CHECK-NEXT:    br label [[REGION_GUARDED_END6:%.*]]
; CHECK:       region.guarded.end6:
; CHECK-NEXT:    br label [[REGION_BARRIER7]]
; CHECK:       region.barrier7:
; CHECK-NEXT:    call void @__kmpc_barrier_simple_spmd(%struct.ident_t* @[[GLOB1]], i32 [[TMP6]])
; CHECK-NEXT:    br label [[REGION_EXIT8:%.*]]
; CHECK:       region.exit8:
; CHECK-NEXT:    [[CALL8_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-NEXT:    [[IDXPROM9_I:%.*]] = sext i32 [[CALL8_I]] to i64
; CHECK-NEXT:    [[ARRAYIDX10_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM9_I]]
; CHECK-NEXT:    br label [[REGION_CHECK_TID15:%.*]]
; CHECK:       region.check.tid15:
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @__kmpc_get_hardware_thread_id_in_block()
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i32 [[TMP8]], 0
; CHECK-NEXT:    br i1 [[TMP9]], label [[REGION_GUARDED14:%.*]], label [[REGION_BARRIER12:%.*]]
; CHECK:       region.guarded14:
; CHECK-NEXT:    store i32 [[CALL8_I]], i32* [[ARRAYIDX10_I]], align 4, !noalias !8
; CHECK-NEXT:    br label [[REGION_GUARDED_END11:%.*]]
; CHECK:       region.guarded.end11:
; CHECK-NEXT:    br label [[REGION_BARRIER12]]
; CHECK:       region.barrier12:
; CHECK-NEXT:    call void @__kmpc_barrier_simple_spmd(%struct.ident_t* @[[GLOB1]], i32 [[TMP8]])
; CHECK-NEXT:    br label [[REGION_EXIT13:%.*]]
; CHECK:       region.exit13:
; CHECK-NEXT:    [[CALL11_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-NEXT:    [[IDXPROM12_I:%.*]] = sext i32 [[CALL11_I]] to i64
; CHECK-NEXT:    [[ARRAYIDX13_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM12_I]]
; CHECK-NEXT:    br label [[REGION_CHECK_TID20:%.*]]
; CHECK:       region.check.tid20:
; CHECK-NEXT:    [[TMP10:%.*]] = call i32 @__kmpc_get_hardware_thread_id_in_block()
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i32 [[TMP10]], 0
; CHECK-NEXT:    br i1 [[TMP11]], label [[REGION_GUARDED19:%.*]], label [[REGION_BARRIER17:%.*]]
; CHECK:       region.guarded19:
; CHECK-NEXT:    store i32 [[CALL11_I]], i32* [[ARRAYIDX13_I]], align 4, !noalias !8
; CHECK-NEXT:    br label [[REGION_GUARDED_END16:%.*]]
; CHECK:       region.guarded.end16:
; CHECK-NEXT:    br label [[REGION_BARRIER17]]
; CHECK:       region.barrier17:
; CHECK-NEXT:    call void @__kmpc_barrier_simple_spmd(%struct.ident_t* @[[GLOB1]], i32 [[TMP10]])
; CHECK-NEXT:    br label [[REGION_EXIT18:%.*]]
; CHECK:       region.exit18:
; CHECK-NEXT:    [[CALL14_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-NEXT:    [[CALL15_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-NEXT:    [[CALL16_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* nonnull @[[GLOB1]], i1 true, i1 false) #[[ATTR4]]
; CHECK-NEXT:    ret void
; CHECK:       worker.exit:
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@__omp_offloading_2a_fbfa7a_sequential_loop_l6
; CHECK-DISABLED-SAME: (i32* [[X:%.*]], i64 [[N:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-DISABLED-NEXT:  entry:
; CHECK-DISABLED-NEXT:    [[WORKER_WORK_FN_ADDR:%.*]] = alloca i8*, align 8
; CHECK-DISABLED-NEXT:    [[N_ADDR_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[N]] to i32
; CHECK-DISABLED-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* nonnull @[[GLOB1]], i1 false, i1 false, i1 true) #[[ATTR4:[0-9]+]]
; CHECK-DISABLED-NEXT:    [[THREAD_IS_WORKER:%.*]] = icmp ne i32 [[TMP0]], -1
; CHECK-DISABLED-NEXT:    br i1 [[THREAD_IS_WORKER]], label [[WORKER_STATE_MACHINE_BEGIN:%.*]], label [[THREAD_USER_CODE_CHECK:%.*]]
; CHECK-DISABLED:       worker_state_machine.begin:
; CHECK-DISABLED-NEXT:    call void @__kmpc_barrier_simple_spmd(%struct.ident_t* @[[GLOB1]], i32 [[TMP0]])
; CHECK-DISABLED-NEXT:    [[WORKER_IS_ACTIVE:%.*]] = call i1 @__kmpc_kernel_parallel(i8** [[WORKER_WORK_FN_ADDR]])
; CHECK-DISABLED-NEXT:    [[WORKER_WORK_FN:%.*]] = load i8*, i8** [[WORKER_WORK_FN_ADDR]], align 8
; CHECK-DISABLED-NEXT:    [[WORKER_WORK_FN_ADDR_CAST:%.*]] = bitcast i8* [[WORKER_WORK_FN]] to void (i16, i32)*
; CHECK-DISABLED-NEXT:    [[WORKER_IS_DONE:%.*]] = icmp eq i8* [[WORKER_WORK_FN]], null
; CHECK-DISABLED-NEXT:    br i1 [[WORKER_IS_DONE]], label [[WORKER_STATE_MACHINE_FINISHED:%.*]], label [[WORKER_STATE_MACHINE_IS_ACTIVE_CHECK:%.*]]
; CHECK-DISABLED:       worker_state_machine.finished:
; CHECK-DISABLED-NEXT:    ret void
; CHECK-DISABLED:       worker_state_machine.is_active.check:
; CHECK-DISABLED-NEXT:    br i1 [[WORKER_IS_ACTIVE]], label [[WORKER_STATE_MACHINE_PARALLEL_REGION_CHECK:%.*]], label [[WORKER_STATE_MACHINE_DONE_BARRIER:%.*]]
; CHECK-DISABLED:       worker_state_machine.parallel_region.check:
; CHECK-DISABLED-NEXT:    br i1 true, label [[WORKER_STATE_MACHINE_PARALLEL_REGION_EXECUTE:%.*]], label [[WORKER_STATE_MACHINE_PARALLEL_REGION_CHECK1:%.*]]
; CHECK-DISABLED:       worker_state_machine.parallel_region.execute:
; CHECK-DISABLED-NEXT:    call void @__omp_outlined__1_wrapper(i16 0, i32 [[TMP0]])
; CHECK-DISABLED-NEXT:    br label [[WORKER_STATE_MACHINE_PARALLEL_REGION_END:%.*]]
; CHECK-DISABLED:       worker_state_machine.parallel_region.check1:
; CHECK-DISABLED-NEXT:    br label [[WORKER_STATE_MACHINE_PARALLEL_REGION_END]]
; CHECK-DISABLED:       worker_state_machine.parallel_region.end:
; CHECK-DISABLED-NEXT:    call void @__kmpc_kernel_end_parallel()
; CHECK-DISABLED-NEXT:    br label [[WORKER_STATE_MACHINE_DONE_BARRIER]]
; CHECK-DISABLED:       worker_state_machine.done.barrier:
; CHECK-DISABLED-NEXT:    call void @__kmpc_barrier_simple_spmd(%struct.ident_t* @[[GLOB1]], i32 [[TMP0]])
; CHECK-DISABLED-NEXT:    br label [[WORKER_STATE_MACHINE_BEGIN]]
; CHECK-DISABLED:       thread.user_code.check:
; CHECK-DISABLED-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-DISABLED-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[WORKER_EXIT:%.*]]
; CHECK-DISABLED:       user_code.entry:
; CHECK-DISABLED-NEXT:    [[TMP1:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @[[GLOB1]]) #[[ATTR4]]
; CHECK-DISABLED-NEXT:    store i32 0, i32* [[X]], align 4, !noalias !8
; CHECK-DISABLED-NEXT:    [[ARRAYIDX1_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 1
; CHECK-DISABLED-NEXT:    store i32 1, i32* [[ARRAYIDX1_I]], align 4, !noalias !8
; CHECK-DISABLED-NEXT:    [[SEXT:%.*]] = shl i64 [[N]], 32
; CHECK-DISABLED-NEXT:    [[IDXPROM_I:%.*]] = ashr exact i64 [[SEXT]], 32
; CHECK-DISABLED-NEXT:    [[ARRAYIDX2_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM_I]]
; CHECK-DISABLED-NEXT:    store i32 [[N_ADDR_SROA_0_0_EXTRACT_TRUNC]], i32* [[ARRAYIDX2_I]], align 4, !noalias !8
; CHECK-DISABLED-NEXT:    br label [[FOR_COND_I:%.*]]
; CHECK-DISABLED:       for.cond.i:
; CHECK-DISABLED-NEXT:    [[I_0_I:%.*]] = phi i32 [ 2, [[USER_CODE_ENTRY]] ], [ [[INC_I:%.*]], [[FOR_BODY_I:%.*]] ]
; CHECK-DISABLED-NEXT:    [[SUB_I:%.*]] = add nsw i32 [[N_ADDR_SROA_0_0_EXTRACT_TRUNC]], -1
; CHECK-DISABLED-NEXT:    [[CMP_I:%.*]] = icmp slt i32 [[I_0_I]], [[SUB_I]]
; CHECK-DISABLED-NEXT:    br i1 [[CMP_I]], label [[FOR_BODY_I]], label [[__OMP_OUTLINED___EXIT:%.*]]
; CHECK-DISABLED:       for.body.i:
; CHECK-DISABLED-NEXT:    [[SUB3_I:%.*]] = add nsw i32 [[I_0_I]], -1
; CHECK-DISABLED-NEXT:    [[IDXPROM4_I:%.*]] = zext i32 [[I_0_I]] to i64
; CHECK-DISABLED-NEXT:    [[ARRAYIDX5_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM4_I]]
; CHECK-DISABLED-NEXT:    store i32 [[SUB3_I]], i32* [[ARRAYIDX5_I]], align 4, !noalias !8
; CHECK-DISABLED-NEXT:    [[INC_I]] = add nuw nsw i32 [[I_0_I]], 1
; CHECK-DISABLED-NEXT:    br label [[FOR_COND_I]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK-DISABLED:       __omp_outlined__.exit:
; CHECK-DISABLED-NEXT:    call void @__kmpc_parallel_51(%struct.ident_t* null, i32 0, i32 1, i32 -1, i32 -1, i8* bitcast (void (i32*, i32*)* @__omp_outlined__1 to i8*), i8* @__omp_outlined__1_wrapper.ID, i8** null, i64 0)
; CHECK-DISABLED-NEXT:    [[CALL_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7:[0-9]+]], !noalias !8
; CHECK-DISABLED-NEXT:    [[IDXPROM6_I:%.*]] = sext i32 [[CALL_I]] to i64
; CHECK-DISABLED-NEXT:    [[ARRAYIDX7_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM6_I]]
; CHECK-DISABLED-NEXT:    store i32 [[CALL_I]], i32* [[ARRAYIDX7_I]], align 4, !noalias !8
; CHECK-DISABLED-NEXT:    [[CALL8_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-DISABLED-NEXT:    [[IDXPROM9_I:%.*]] = sext i32 [[CALL8_I]] to i64
; CHECK-DISABLED-NEXT:    [[ARRAYIDX10_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM9_I]]
; CHECK-DISABLED-NEXT:    store i32 [[CALL8_I]], i32* [[ARRAYIDX10_I]], align 4, !noalias !8
; CHECK-DISABLED-NEXT:    [[CALL11_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-DISABLED-NEXT:    [[IDXPROM12_I:%.*]] = sext i32 [[CALL11_I]] to i64
; CHECK-DISABLED-NEXT:    [[ARRAYIDX13_I:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 [[IDXPROM12_I]]
; CHECK-DISABLED-NEXT:    store i32 [[CALL11_I]], i32* [[ARRAYIDX13_I]], align 4, !noalias !8
; CHECK-DISABLED-NEXT:    [[CALL14_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-DISABLED-NEXT:    [[CALL15_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-DISABLED-NEXT:    [[CALL16_I:%.*]] = call i32 @no_openmp(i32* nonnull [[X]]) #[[ATTR7]], !noalias !8
; CHECK-DISABLED-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* nonnull @[[GLOB1]], i1 false, i1 true) #[[ATTR4]]
; CHECK-DISABLED-NEXT:    ret void
; CHECK-DISABLED:       worker.exit:
; CHECK-DISABLED-NEXT:    ret void
;
entry:
  %N.addr.sroa.0.0.extract.trunc = trunc i64 %N to i32
  %0 = call i32 @__kmpc_target_init(%struct.ident_t* nonnull @1, i1 false, i1 true, i1 true) #3
  %exec_user_code = icmp eq i32 %0, -1
  br i1 %exec_user_code, label %user_code.entry, label %worker.exit

user_code.entry:                                  ; preds = %entry
  %1 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  store i32 0, i32* %x, align 4, !noalias !8
  %arrayidx1.i = getelementptr inbounds i32, i32* %x, i64 1
  store i32 1, i32* %arrayidx1.i, align 4, !noalias !8
  %sext = shl i64 %N, 32
  %idxprom.i = ashr exact i64 %sext, 32
  %arrayidx2.i = getelementptr inbounds i32, i32* %x, i64 %idxprom.i
  store i32 %N.addr.sroa.0.0.extract.trunc, i32* %arrayidx2.i, align 4, !noalias !8
  br label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i, %user_code.entry
  %i.0.i = phi i32 [ 2, %user_code.entry ], [ %inc.i, %for.body.i ]
  %sub.i = add nsw i32 %N.addr.sroa.0.0.extract.trunc, -1
  %cmp.i = icmp slt i32 %i.0.i, %sub.i
  br i1 %cmp.i, label %for.body.i, label %__omp_outlined__.exit

for.body.i:                                       ; preds = %for.cond.i
  %sub3.i = add nsw i32 %i.0.i, -1
  %idxprom4.i = zext i32 %i.0.i to i64
  %arrayidx5.i = getelementptr inbounds i32, i32* %x, i64 %idxprom4.i
  store i32 %sub3.i, i32* %arrayidx5.i, align 4, !noalias !8
  %inc.i = add nuw nsw i32 %i.0.i, 1
  br label %for.cond.i, !llvm.loop !11

__omp_outlined__.exit:                            ; preds = %for.cond.i
  call void @__kmpc_parallel_51(%struct.ident_t* null, i32 0, i32 1, i32 -1, i32 -1, i8* bitcast (void (i32*, i32*)* @__omp_outlined__1 to i8*), i8* bitcast (void (i16, i32)* @__omp_outlined__1_wrapper to i8*), i8** null, i64 0)
  %call.i = call i32 @no_openmp(i32* nonnull %x) #5, !noalias !8
  %idxprom6.i = sext i32 %call.i to i64
  %arrayidx7.i = getelementptr inbounds i32, i32* %x, i64 %idxprom6.i
  store i32 %call.i, i32* %arrayidx7.i, align 4, !noalias !8
  %call8.i = call i32 @no_openmp(i32* nonnull %x) #5, !noalias !8
  %idxprom9.i = sext i32 %call8.i to i64
  %arrayidx10.i = getelementptr inbounds i32, i32* %x, i64 %idxprom9.i
  store i32 %call8.i, i32* %arrayidx10.i, align 4, !noalias !8
  %call11.i = call i32 @no_openmp(i32* nonnull %x) #5, !noalias !8
  %idxprom12.i = sext i32 %call11.i to i64
  %arrayidx13.i = getelementptr inbounds i32, i32* %x, i64 %idxprom12.i
  store i32 %call11.i, i32* %arrayidx13.i, align 4, !noalias !8
  %call14.i = call i32 @no_openmp(i32* nonnull %x) #5, !noalias !8
  %call15.i = call i32 @no_openmp(i32* nonnull %x) #5, !noalias !8
  %call16.i = call i32 @no_openmp(i32* nonnull %x) #5, !noalias !8
  call void @__kmpc_target_deinit(%struct.ident_t* nonnull @1, i1 false, i1 true) #3
  ret void

worker.exit:                                      ; preds = %entry
  ret void
}

define internal void @__omp_outlined__1(i32* noalias %.global_tid., i32* noalias %.bound_tid.) {
; CHECK-LABEL: define {{[^@]+}}@__omp_outlined__1
; CHECK-SAME: (i32* noalias [[DOTGLOBAL_TID_:%.*]], i32* noalias [[DOTBOUND_TID_:%.*]]) {
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@__omp_outlined__1
; CHECK-DISABLED-SAME: (i32* noalias [[DOTGLOBAL_TID_:%.*]], i32* noalias [[DOTBOUND_TID_:%.*]]) {
; CHECK-DISABLED-NEXT:    ret void
;
  ret void
}
define internal void @__omp_outlined__1_wrapper(i16 zeroext %0, i32 %1) {
; CHECK-LABEL: define {{[^@]+}}@__omp_outlined__1_wrapper
; CHECK-SAME: (i16 zeroext [[TMP0:%.*]], i32 [[TMP1:%.*]]) {
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@__omp_outlined__1_wrapper
; CHECK-DISABLED-SAME: (i16 zeroext [[TMP0:%.*]], i32 [[TMP1:%.*]]) {
; CHECK-DISABLED-NEXT:    ret void
;
  ret void
}

declare void @__kmpc_parallel_51(%struct.ident_t*, i32, i32, i32, i32, i8*, i8*, i8**, i64)

declare i32 @__kmpc_target_init(%struct.ident_t*, i1, i1, i1)

; Function Attrs: convergent
declare i32 @no_openmp(i32*) #1

; Function Attrs: convergent nounwind readonly willreturn
declare void @pure() #2

; Function Attrs: nounwind
declare i32 @__kmpc_global_thread_num(%struct.ident_t*) #3

declare void @__kmpc_target_deinit(%struct.ident_t*, i1, i1)

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.experimental.noalias.scope.decl(metadata) #4

attributes #0 = { convergent norecurse nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #1 = { convergent "frame-pointer"="all" "llvm.assume"="omp_no_openmp,ompx_spmd_amenable" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #2 = { convergent nounwind readonly willreturn "frame-pointer"="all" "llvm.assume"="ompx_spmd_amenable" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #3 = { nounwind }
attributes #4 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #5 = { convergent nounwind "llvm.assume"="omp_no_openmp,ompx_spmd_amenable" }

!omp_offload.info = !{!0}
!nvvm.annotations = !{!1}
!llvm.module.flags = !{!2, !3, !4, !5, !6}
!llvm.ident = !{!7}

!0 = !{i32 0, i32 42, i32 16513658, !"sequential_loop", i32 6, i32 0}
!1 = !{void (i32*, i64)* @__omp_offloading_2a_fbfa7a_sequential_loop_l6, !"kernel", i32 1}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"openmp", i32 50}
!4 = !{i32 7, !"openmp-device", i32 50}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"frame-pointer", i32 2}
!7 = !{!"clang version 14.0.0"}
!8 = !{!9}
!9 = distinct !{!9, !10, !"__omp_outlined__: %__context"}
!10 = distinct !{!10, !"__omp_outlined__"}
!11 = distinct !{!11, !12}
!12 = !{!"llvm.loop.mustprogress"}
;.
; CHECK: attributes #[[ATTR0]] = { convergent norecurse nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK: attributes #[[ATTR1:[0-9]+]] = { alwaysinline }
; CHECK: attributes #[[ATTR2:[0-9]+]] = { convergent "frame-pointer"="all" "llvm.assume"="omp_no_openmp,ompx_spmd_amenable" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK: attributes #[[ATTR3:[0-9]+]] = { convergent nounwind readonly willreturn "frame-pointer"="all" "llvm.assume"="ompx_spmd_amenable" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK: attributes #[[ATTR4]] = { nounwind }
; CHECK: attributes #[[ATTR5:[0-9]+]] = { inaccessiblememonly nofree nosync nounwind willreturn }
; CHECK: attributes #[[ATTR6:[0-9]+]] = { convergent nounwind }
; CHECK: attributes #[[ATTR7]] = { convergent nounwind "llvm.assume"="omp_no_openmp,ompx_spmd_amenable" }
;.
; CHECK-DISABLED: attributes #[[ATTR0]] = { convergent norecurse nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK-DISABLED: attributes #[[ATTR1:[0-9]+]] = { alwaysinline }
; CHECK-DISABLED: attributes #[[ATTR2:[0-9]+]] = { convergent "frame-pointer"="all" "llvm.assume"="omp_no_openmp,ompx_spmd_amenable" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK-DISABLED: attributes #[[ATTR3:[0-9]+]] = { convergent nounwind readonly willreturn "frame-pointer"="all" "llvm.assume"="ompx_spmd_amenable" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK-DISABLED: attributes #[[ATTR4]] = { nounwind }
; CHECK-DISABLED: attributes #[[ATTR5:[0-9]+]] = { inaccessiblememonly nofree nosync nounwind willreturn }
; CHECK-DISABLED: attributes #[[ATTR6:[0-9]+]] = { convergent nounwind }
; CHECK-DISABLED: attributes #[[ATTR7]] = { convergent nounwind "llvm.assume"="omp_no_openmp,ompx_spmd_amenable" }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 0, i32 42, i32 16513658, !"sequential_loop", i32 6, i32 0}
; CHECK: [[META1:![0-9]+]] = !{void (i32*, i64)* @__omp_offloading_2a_fbfa7a_sequential_loop_l6, !"kernel", i32 1}
; CHECK: [[META2:![0-9]+]] = !{i32 1, !"wchar_size", i32 4}
; CHECK: [[META3:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META4:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK: [[META5:![0-9]+]] = !{i32 7, !"PIC Level", i32 2}
; CHECK: [[META6:![0-9]+]] = !{i32 7, !"frame-pointer", i32 2}
; CHECK: [[META7:![0-9]+]] = !{!"clang version 14.0.0"}
; CHECK: [[META8:![0-9]+]] = !{!9}
; CHECK: [[META9:![0-9]+]] = distinct !{!9, !10, !"__omp_outlined__: %__context"}
; CHECK: [[META10:![0-9]+]] = distinct !{!10, !"__omp_outlined__"}
; CHECK: [[LOOP11]] = distinct !{!11, !12}
; CHECK: [[META12:![0-9]+]] = !{!"llvm.loop.mustprogress"}
;.
; CHECK-DISABLED: [[META0:![0-9]+]] = !{i32 0, i32 42, i32 16513658, !"sequential_loop", i32 6, i32 0}
; CHECK-DISABLED: [[META1:![0-9]+]] = !{void (i32*, i64)* @__omp_offloading_2a_fbfa7a_sequential_loop_l6, !"kernel", i32 1}
; CHECK-DISABLED: [[META2:![0-9]+]] = !{i32 1, !"wchar_size", i32 4}
; CHECK-DISABLED: [[META3:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK-DISABLED: [[META4:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK-DISABLED: [[META5:![0-9]+]] = !{i32 7, !"PIC Level", i32 2}
; CHECK-DISABLED: [[META6:![0-9]+]] = !{i32 7, !"frame-pointer", i32 2}
; CHECK-DISABLED: [[META7:![0-9]+]] = !{!"clang version 14.0.0"}
; CHECK-DISABLED: [[META8:![0-9]+]] = !{!9}
; CHECK-DISABLED: [[META9:![0-9]+]] = distinct !{!9, !10, !"__omp_outlined__: %__context"}
; CHECK-DISABLED: [[META10:![0-9]+]] = distinct !{!10, !"__omp_outlined__"}
; CHECK-DISABLED: [[LOOP11]] = distinct !{!11, !12}
; CHECK-DISABLED: [[META12:![0-9]+]] = !{!"llvm.loop.mustprogress"}
;.
