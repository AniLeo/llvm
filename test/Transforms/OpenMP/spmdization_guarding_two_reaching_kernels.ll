; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -passes=openmp-opt < %s | FileCheck %s
; RUN: opt -S -passes=openmp-opt -openmp-opt-disable-spmdization < %s | FileCheck %s
;
; int G;
;
; void leaf() {
;   G = 42;
; }
;
; void spmd_helper() {
;   leaf();
; #pragma omp parallel
;   unknown();
; }
; void spmd() {
; #pragma omp target
;   spmd_helper();
; }
;
; void generic_helper() {
;   leaf();
; }
; void generic() {
; #pragma omp target
;   generic_helper();
; }
;
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8
@__omp_offloading_2b_10393b5_spmd_l12_exec_mode = weak constant i8 1
@__omp_offloading_2b_10393b5_generic_l20_exec_mode = weak constant i8 1
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 2, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8
@G = external global i32, align 4
@llvm.compiler.used = appending global [2 x i8*] [i8* @__omp_offloading_2b_10393b5_spmd_l12_exec_mode, i8* @__omp_offloading_2b_10393b5_generic_l20_exec_mode], section "llvm.metadata"

;.
; CHECK: @[[GLOB0:[0-9]+]] = private unnamed_addr constant [23 x i8] c"
; CHECK: @[[GLOB1:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
; CHECK: @[[__OMP_OFFLOADING_2B_10393B5_SPMD_L12_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 1
; CHECK: @[[__OMP_OFFLOADING_2B_10393B5_GENERIC_L20_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 1
; CHECK: @[[GLOB2:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 2, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = external global i32, align 4
; CHECK: @[[LLVM_COMPILER_USED:[a-zA-Z0-9_$"\\.-]+]] = appending global [2 x i8*] [i8* @__omp_offloading_2b_10393b5_spmd_l12_exec_mode, i8* @__omp_offloading_2b_10393b5_generic_l20_exec_mode], section "llvm.metadata"
; CHECK: @[[__OMP_OUTLINED___WRAPPER_ID:[a-zA-Z0-9_$"\\.-]+]] = private constant i8 undef
;.
define weak void @__omp_offloading_2b_10393b5_spmd_l12() #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_offloading_2b_10393b5_spmd_l12
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WORKER_WORK_FN_ADDR:%.*]] = alloca i8*, align 8
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* @[[GLOB1]], i8 1, i1 false, i1 true)
; CHECK-NEXT:    [[BLOCK_HW_SIZE:%.*]] = call i32 @__kmpc_get_hardware_num_threads_in_block()
; CHECK-NEXT:    [[WARP_SIZE:%.*]] = call i32 @__kmpc_get_warp_size()
; CHECK-NEXT:    [[BLOCK_SIZE:%.*]] = sub i32 [[BLOCK_HW_SIZE]], [[WARP_SIZE]]
; CHECK-NEXT:    [[THREAD_IS_MAIN_OR_WORKER:%.*]] = icmp slt i32 [[TMP0]], [[BLOCK_SIZE]]
; CHECK-NEXT:    br i1 [[THREAD_IS_MAIN_OR_WORKER]], label [[IS_WORKER_CHECK:%.*]], label [[WORKER_STATE_MACHINE_FINISHED:%.*]]
; CHECK:       is_worker_check:
; CHECK-NEXT:    [[THREAD_IS_WORKER:%.*]] = icmp ne i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[THREAD_IS_WORKER]], label [[WORKER_STATE_MACHINE_BEGIN:%.*]], label [[THREAD_USER_CODE_CHECK:%.*]]
; CHECK:       worker_state_machine.begin:
; CHECK-NEXT:    call void @__kmpc_barrier_simple_generic(%struct.ident_t* @[[GLOB1]], i32 [[TMP0]])
; CHECK-NEXT:    [[WORKER_IS_ACTIVE:%.*]] = call i1 @__kmpc_kernel_parallel(i8** [[WORKER_WORK_FN_ADDR]])
; CHECK-NEXT:    [[WORKER_WORK_FN:%.*]] = load i8*, i8** [[WORKER_WORK_FN_ADDR]], align 8
; CHECK-NEXT:    [[WORKER_WORK_FN_ADDR_CAST:%.*]] = bitcast i8* [[WORKER_WORK_FN]] to void (i16, i32)*
; CHECK-NEXT:    [[WORKER_IS_DONE:%.*]] = icmp eq i8* [[WORKER_WORK_FN]], null
; CHECK-NEXT:    br i1 [[WORKER_IS_DONE]], label [[WORKER_STATE_MACHINE_FINISHED]], label [[WORKER_STATE_MACHINE_IS_ACTIVE_CHECK:%.*]]
; CHECK:       worker_state_machine.finished:
; CHECK-NEXT:    ret void
; CHECK:       worker_state_machine.is_active.check:
; CHECK-NEXT:    br i1 [[WORKER_IS_ACTIVE]], label [[WORKER_STATE_MACHINE_PARALLEL_REGION_CHECK:%.*]], label [[WORKER_STATE_MACHINE_DONE_BARRIER:%.*]]
; CHECK:       worker_state_machine.parallel_region.check:
; CHECK-NEXT:    br i1 true, label [[WORKER_STATE_MACHINE_PARALLEL_REGION_EXECUTE:%.*]], label [[WORKER_STATE_MACHINE_PARALLEL_REGION_CHECK1:%.*]]
; CHECK:       worker_state_machine.parallel_region.execute:
; CHECK-NEXT:    call void @__omp_outlined___wrapper(i16 0, i32 [[TMP0]])
; CHECK-NEXT:    br label [[WORKER_STATE_MACHINE_PARALLEL_REGION_END:%.*]]
; CHECK:       worker_state_machine.parallel_region.check1:
; CHECK-NEXT:    br label [[WORKER_STATE_MACHINE_PARALLEL_REGION_END]]
; CHECK:       worker_state_machine.parallel_region.end:
; CHECK-NEXT:    call void @__kmpc_kernel_end_parallel()
; CHECK-NEXT:    br label [[WORKER_STATE_MACHINE_DONE_BARRIER]]
; CHECK:       worker_state_machine.done.barrier:
; CHECK-NEXT:    call void @__kmpc_barrier_simple_generic(%struct.ident_t* @[[GLOB1]], i32 [[TMP0]])
; CHECK-NEXT:    br label [[WORKER_STATE_MACHINE_BEGIN]]
; CHECK:       thread.user_code.check:
; CHECK-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[WORKER_EXIT:%.*]]
; CHECK:       user_code.entry:
; CHECK-NEXT:    call void @spmd_helper() #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* @[[GLOB1]], i8 1, i1 true)
; CHECK-NEXT:    ret void
; CHECK:       worker.exit:
; CHECK-NEXT:    ret void
;
entry:
  %0 = call i32 @__kmpc_target_init(%struct.ident_t* @1, i8 1, i1 true, i1 true)
  %exec_user_code = icmp eq i32 %0, -1
  br i1 %exec_user_code, label %user_code.entry, label %worker.exit

user_code.entry:                                  ; preds = %entry
  call void @spmd_helper() #5
  call void @__kmpc_target_deinit(%struct.ident_t* @1, i8 1, i1 true)
  ret void

worker.exit:                                      ; preds = %entry
  ret void
}

declare i32 @__kmpc_target_init(%struct.ident_t*, i8, i1, i1)

declare void @__kmpc_target_deinit(%struct.ident_t*, i8, i1)

; Function Attrs: convergent noinline norecurse nounwind
define weak void @__omp_offloading_2b_10393b5_generic_l20() #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_offloading_2b_10393b5_generic_l20
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* @[[GLOB1]], i8 1, i1 false, i1 true)
; CHECK-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[WORKER_EXIT:%.*]]
; CHECK:       user_code.entry:
; CHECK-NEXT:    call void @generic_helper() #[[ATTR5:[0-9]+]]
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* @[[GLOB1]], i8 1, i1 true)
; CHECK-NEXT:    ret void
; CHECK:       worker.exit:
; CHECK-NEXT:    ret void
;
entry:
  %0 = call i32 @__kmpc_target_init(%struct.ident_t* @1, i8 1, i1 true, i1 true)
  %exec_user_code = icmp eq i32 %0, -1
  br i1 %exec_user_code, label %user_code.entry, label %worker.exit

user_code.entry:                                  ; preds = %entry
  call void @generic_helper() #5
  call void @__kmpc_target_deinit(%struct.ident_t* @1, i8 1, i1 true)
  ret void

worker.exit:                                      ; preds = %entry
  ret void
}

; Function Attrs: convergent noinline nounwind
define internal void @spmd_helper() #1 {
; CHECK-LABEL: define {{[^@]+}}@spmd_helper
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS:%.*]] = alloca [0 x i8*], align 8
; CHECK-NEXT:    call void @leaf() #[[ATTR6:[0-9]+]]
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* noundef @[[GLOB2]]) #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast [0 x i8*]* [[CAPTURED_VARS_ADDRS]] to i8**
; CHECK-NEXT:    call void @__kmpc_parallel_51(%struct.ident_t* noundef @[[GLOB2]], i32 [[TMP0]], i32 noundef 1, i32 noundef -1, i32 noundef -1, i8* noundef bitcast (void (i32*, i32*)* @__omp_outlined__ to i8*), i8* noundef @__omp_outlined___wrapper.ID, i8** noundef [[TMP1]], i64 noundef 0)
; CHECK-NEXT:    ret void
;
entry:
  %captured_vars_addrs = alloca [0 x i8*], align 8
  call void @leaf() #5
  %0 = call i32 @__kmpc_global_thread_num(%struct.ident_t* @2)
  %1 = bitcast [0 x i8*]* %captured_vars_addrs to i8**
  call void @__kmpc_parallel_51(%struct.ident_t* @2, i32 %0, i32 1, i32 -1, i32 -1, i8* bitcast (void (i32*, i32*)* @__omp_outlined__ to i8*), i8* bitcast (void (i16, i32)* @__omp_outlined___wrapper to i8*), i8** %1, i64 0)
  ret void
}

; Function Attrs: convergent noinline norecurse nounwind
define internal void @__omp_outlined__(i32* noalias %.global_tid., i32* noalias %.bound_tid.) #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_outlined__
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[DOTGLOBAL_TID_:%.*]], i32* noalias nocapture nofree readnone [[DOTBOUND_TID_:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca i32*, align 8
; CHECK-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca i32*, align 8
; CHECK-NEXT:    call void @unknown() #[[ATTR7:[0-9]+]]
; CHECK-NEXT:    ret void
;
entry:
  %.global_tid..addr = alloca i32*, align 8
  %.bound_tid..addr = alloca i32*, align 8
  store i32* %.global_tid., i32** %.global_tid..addr, align 8
  store i32* %.bound_tid., i32** %.bound_tid..addr, align 8
  call void @unknown() #5
  ret void
}

; Function Attrs: convergent noinline norecurse nounwind
define internal void @__omp_outlined___wrapper(i16 zeroext %0, i32 %1) #2 {
; CHECK-LABEL: define {{[^@]+}}@__omp_outlined___wrapper
; CHECK-SAME: (i16 zeroext [[TMP0:%.*]], i32 [[TMP1:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTADDR:%.*]] = alloca i16, align 2
; CHECK-NEXT:    [[DOTADDR1:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[DOTZERO_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[GLOBAL_ARGS:%.*]] = alloca i8**, align 8
; CHECK-NEXT:    call void @__kmpc_get_shared_variables(i8*** [[GLOBAL_ARGS]])
; CHECK-NEXT:    call void @__omp_outlined__(i32* noalias nocapture noundef nonnull readnone align 4 dereferenceable(4) [[DOTADDR1]], i32* noalias nocapture noundef nonnull readnone align 4 dereferenceable(4) [[DOTZERO_ADDR]]) #[[ATTR1]]
; CHECK-NEXT:    ret void
;
entry:
  %.addr = alloca i16, align 2
  %.addr1 = alloca i32, align 4
  %.zero.addr = alloca i32, align 4
  %global_args = alloca i8**, align 8
  store i16 %0, i16* %.addr, align 2
  store i32 %1, i32* %.addr1, align 4
  store i32 0, i32* %.zero.addr, align 4
  call void @__kmpc_get_shared_variables(i8*** %global_args)
  call void @__omp_outlined__(i32* %.addr1, i32* %.zero.addr) #3
  ret void
}

declare void @__kmpc_get_shared_variables(i8***)

; Function Attrs: nounwind
declare i32 @__kmpc_global_thread_num(%struct.ident_t*) #3

; Function Attrs: alwaysinline
declare void @__kmpc_parallel_51(%struct.ident_t*, i32, i32, i32, i32, i8*, i8*, i8**, i64) #4

; Function Attrs: convergent noinline nounwind
define internal void @leaf() #1 {
; CHECK-LABEL: define {{[^@]+}}@leaf
; CHECK-SAME: () #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 42, i32* @G, align 4
; CHECK-NEXT:    ret void
;
entry:
  store i32 42, i32* @G, align 4
  ret void
}

; Function Attrs: convergent noinline nounwind
define internal void @generic_helper() #1 {
; CHECK-LABEL: define {{[^@]+}}@generic_helper
; CHECK-SAME: () #[[ATTR3]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @leaf() #[[ATTR6]]
; CHECK-NEXT:    ret void
;
entry:
  call void @leaf() #5
  ret void
}

declare void @unknown()

attributes #0 = { convergent noinline norecurse nounwind  "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #1 = { convergent noinline nounwind  "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #2 = { convergent noinline norecurse nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #3 = { nounwind }
attributes #4 = { alwaysinline }
attributes #5 = { convergent }

!omp_offload.info = !{!0, !1}
!nvvm.annotations = !{!2, !3}
!llvm.module.flags = !{!4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = !{i32 0, i32 43, i32 17011637, !"spmd", i32 12, i32 0}
!1 = !{i32 0, i32 43, i32 17011637, !"generic", i32 20, i32 1}
!2 = !{void ()* @__omp_offloading_2b_10393b5_spmd_l12, !"kernel", i32 1}
!3 = !{void ()* @__omp_offloading_2b_10393b5_generic_l20, !"kernel", i32 1}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"openmp", i32 50}
!6 = !{i32 7, !"openmp-device", i32 50}
!7 = !{i32 7, !"PIC Level", i32 2}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"clang version 14.0.0"}
;.
; CHECK: attributes #[[ATTR0]] = { convergent noinline norecurse nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK: attributes #[[ATTR1]] = { nounwind }
; CHECK: attributes #[[ATTR2:[0-9]+]] = { alwaysinline }
; CHECK: attributes #[[ATTR3]] = { convergent nofree noinline norecurse nosync nounwind willreturn writeonly "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK: attributes #[[ATTR4]] = { convergent nounwind }
; CHECK: attributes #[[ATTR5]] = { convergent nounwind writeonly }
; CHECK: attributes #[[ATTR6]] = { convergent nofree nosync nounwind willreturn writeonly }
; CHECK: attributes #[[ATTR7]] = { convergent }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 0, i32 43, i32 17011637, !"spmd", i32 12, i32 0}
; CHECK: [[META1:![0-9]+]] = !{i32 0, i32 43, i32 17011637, !"generic", i32 20, i32 1}
; CHECK: [[META2:![0-9]+]] = !{void ()* @__omp_offloading_2b_10393b5_spmd_l12, !"kernel", i32 1}
; CHECK: [[META3:![0-9]+]] = !{void ()* @__omp_offloading_2b_10393b5_generic_l20, !"kernel", i32 1}
; CHECK: [[META4:![0-9]+]] = !{i32 1, !"wchar_size", i32 4}
; CHECK: [[META5:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META6:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK: [[META7:![0-9]+]] = !{i32 7, !"PIC Level", i32 2}
; CHECK: [[META8:![0-9]+]] = !{i32 7, !"frame-pointer", i32 2}
; CHECK: [[META9:![0-9]+]] = !{!"clang version 14.0.0"}
;.
