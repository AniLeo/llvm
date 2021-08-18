; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --include-generated-funcs
; RUN: opt -S -passes=openmp-opt < %s | FileCheck %s

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8
@_ZL6Device = internal global double 0.000000e+00, align 8
@__omp_offloading_fd02_85283c04_main_l11_exec_mode = weak constant i8 0

define weak void @__omp_offloading_fd02_85283c04_main_l11(double* nonnull align 8 dereferenceable(8) %X) local_unnamed_addr {
entry:
  %0 = tail call i32 @__kmpc_target_init(%struct.ident_t* nonnull @1, i1 true, i1 false, i1 false) #0
  %exec_user_code = icmp eq i32 %0, -1
  br i1 %exec_user_code, label %user_code.entry, label %common.ret

common.ret:
  ret void

user_code.entry:
  %1 = load double, double* @_ZL6Device, align 8, !tbaa !11
  %2 = tail call i32 @__kmpc_get_hardware_thread_id_in_block() #0
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %region.guarded, label %region.barrier

region.guarded:
  store double %1, double* %X, align 8, !tbaa !11
  br label %region.barrier

region.barrier:
  tail call void @__kmpc_barrier_simple_spmd(%struct.ident_t* nonnull @1, i32 %2)
  tail call void @__kmpc_target_deinit(%struct.ident_t* nonnull @1, i1 true, i1 false) #0
  br label %common.ret
}

declare i32 @__kmpc_target_init(%struct.ident_t*, i1, i1, i1) local_unnamed_addr

declare void @__kmpc_target_deinit(%struct.ident_t*, i1, i1) local_unnamed_addr

define internal void @__omp_offloading__fd02_85283c04_Device_l6_ctor() {
entry:
  %call.i = tail call double @__nv_log(double noundef 2.000000e+00) #1
  %call.i2 = tail call double @__nv_log(double noundef 2.000000e+00) #1
  %div = fdiv double %call.i, %call.i2
  store double %div, double* @_ZL6Device, align 8, !tbaa !11
  ret void
}

declare double @__nv_log(double)

declare i32 @__kmpc_get_hardware_thread_id_in_block()

declare void @__kmpc_barrier_simple_spmd(%struct.ident_t*, i32)

attributes #0 = { nounwind }
attributes #1 = { convergent nounwind }

!omp_offload.info = !{!0, !1, !2}
!nvvm.annotations = !{!3, !4}
!llvm.module.flags = !{!5, !6, !7, !8, !9}
!llvm.ident = !{!10}

!0 = !{i32 0, i32 64770, i32 -2060960764, !"__omp_offloading__fd02_85283c04_Device_l6_ctor", i32 6, i32 1}
!1 = !{i32 0, i32 64770, i32 -2060960764, !"main", i32 11, i32 2}
!2 = !{i32 1, !"_ZL6Device", i32 0, i32 0}
!3 = !{void ()* @__omp_offloading__fd02_85283c04_Device_l6_ctor, !"kernel", i32 1}
!4 = !{void (double*)* @__omp_offloading_fd02_85283c04_main_l11, !"kernel", i32 1}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"openmp", i32 50}
!7 = !{i32 7, !"openmp-device", i32 50}
!8 = !{i32 7, !"PIC Level", i32 2}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = !{!"clang version 14.0.0"}
!11 = !{!12, !12, i64 0}
!12 = !{!"double", !13, i64 0}
!13 = !{!"omnipotent char", !14, i64 0}
!14 = !{!"Simple C++ TBAA"}
; CHECK-LABEL: define {{[^@]+}}@__omp_offloading_fd02_85283c04_main_l11
; CHECK-SAME: (double* nonnull align 8 dereferenceable(8) [[X:%.*]]) local_unnamed_addr {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @__kmpc_target_init(%struct.ident_t* nonnull @[[GLOB1:[0-9]+]], i1 true, i1 false, i1 false) #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[COMMON_RET:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       user_code.entry:
; CHECK-NEXT:    [[TMP1:%.*]] = load double, double* @_ZL6Device, align 8, !tbaa [[TBAA11:![0-9]+]]
; CHECK-NEXT:    [[TMP2:%.*]] = tail call i32 @__kmpc_get_hardware_thread_id_in_block() #[[ATTR1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[REGION_GUARDED:%.*]], label [[REGION_BARRIER:%.*]]
; CHECK:       region.guarded:
; CHECK-NEXT:    store double [[TMP1]], double* [[X]], align 8, !tbaa [[TBAA11]]
; CHECK-NEXT:    br label [[REGION_BARRIER]]
; CHECK:       region.barrier:
; CHECK-NEXT:    tail call void @__kmpc_barrier_simple_spmd(%struct.ident_t* nonnull @[[GLOB1]], i32 [[TMP2]]) #[[ATTR1]]
; CHECK-NEXT:    tail call void @__kmpc_target_deinit(%struct.ident_t* nonnull @[[GLOB1]], i1 true, i1 false) #[[ATTR1]]
; CHECK-NEXT:    br label [[COMMON_RET]]
;
