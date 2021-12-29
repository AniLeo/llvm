; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -openmp-opt-cgscc -S < %s | FileCheck %s
; RUN: opt -passes=openmp-opt-cgscc -S < %s | FileCheck %s
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@0 = private unnamed_addr constant %struct.ident_t { i32 0, i32 34, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str0, i32 0, i32 0) }, align 8
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str1, i32 0, i32 0) }, align 8
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str2, i32 0, i32 0) }, align 8
@.str0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@.str1 = private unnamed_addr constant [23 x i8] c";file001;loc0001;0;0;;\00", align 1
@.str2 = private unnamed_addr constant [23 x i8] c";file002;loc0002;0;0;;\00", align 1

; UTC_ARGS: --disable
; CHECK-DAG: @0 = private unnamed_addr constant %struct.ident_t { i32 0, i32 34, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str0, i32 0, i32 0) }, align 8
; CHECK-DAG: @1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str1, i32 0, i32 0) }, align 8
; CHECK-DAG: @2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str2, i32 0, i32 0) }, align 8
; CHECK-DAG: @.str0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
; CHECK-DAG: @.str1 = private unnamed_addr constant [23 x i8] c";file001;loc0001;0;0;;\00", align 1
; CHECK-DAG: @.str2 = private unnamed_addr constant [23 x i8] c";file002;loc0002;0;0;;\00", align 1
; UTC_ARGS: --enable


declare i32 @__kmpc_global_thread_num(%struct.ident_t*)
declare void @useI32(i32)

define void @external(i1 %c) {
; CHECK-LABEL: define {{[^@]+}}@external
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C2:%.*]] = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @[[GLOB0:[0-9]+]])
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    call void @internal(i32 [[C2]], i32 [[C2]])
; CHECK-NEXT:    call void @useI32(i32 [[C2]])
; CHECK-NEXT:    br label [[M:%.*]]
; CHECK:       e:
; CHECK-NEXT:    call void @internal(i32 [[C2]], i32 [[C2]])
; CHECK-NEXT:    call void @useI32(i32 [[C2]])
; CHECK-NEXT:    br label [[M]]
; CHECK:       m:
; CHECK-NEXT:    call void @internal(i32 0, i32 [[C2]])
; CHECK-NEXT:    call void @useI32(i32 [[C2]])
; CHECK-NEXT:    ret void
;
entry:
  br i1 %c, label %t, label %e
t:
  %c0 = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @0)
  call void @internal(i32 %c0, i32 %c0)
  call void @useI32(i32 %c0)
  br label %m
e:
  %c1 = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @0)
  call void @internal(i32 %c1, i32 %c1)
  call void @useI32(i32 %c1)
  br label %m
m:
  %c2 = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @0)
  call void @internal(i32 0, i32 %c2)
  call void @useI32(i32 %c2)
  ret void
}

define internal void @internal(i32 %not_gtid, i32 %gtid) {
; CHECK-LABEL: define {{[^@]+}}@internal
; CHECK-SAME: (i32 [[NOT_GTID:%.*]], i32 [[GTID:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[GTID]], [[GTID]]
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    call void @useI32(i32 [[GTID]])
; CHECK-NEXT:    call void @external(i1 [[C]])
; CHECK-NEXT:    br label [[M:%.*]]
; CHECK:       e:
; CHECK-NEXT:    call void @useI32(i32 [[GTID]])
; CHECK-NEXT:    br label [[M]]
; CHECK:       m:
; CHECK-NEXT:    call void @useI32(i32 [[GTID]])
; CHECK-NEXT:    ret void
;
entry:
  %cc = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @0)
  %c = icmp eq i32 %cc, %gtid
  br i1 %c, label %t, label %e
t:
  %c0 = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @0)
  call void @useI32(i32 %c0)
  call void @external(i1 %c)
  br label %m
e:
  %c1 = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @0)
  call void @useI32(i32 %c1)
  br label %m
m:
  %c2 = tail call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @0)
  call void @useI32(i32 %c2)
  ret void
}


define void @local_and_global_gtid_calls() {
; CHECK-LABEL: define {{[^@]+}}@local_and_global_gtid_calls() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TID5:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* @[[GLOB3:[0-9]+]])
; CHECK-NEXT:    [[DOTKMPC_LOC_ADDR:%.*]] = alloca [[STRUCT_IDENT_T:%.*]], align 8
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    ret void
;
entry:
  %.kmpc_loc.addr = alloca %struct.ident_t, align 8
  %tid0 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr)
  %tid1 = call i32 @__kmpc_global_thread_num(%struct.ident_t* @1)
  %tid2 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr)
  call void @useI32(i32 %tid0)
  call void @useI32(i32 %tid1)
  call void @useI32(i32 %tid2)
  %tid3 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr)
  %tid4 = call i32 @__kmpc_global_thread_num(%struct.ident_t* @2)
  %tid5 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr)
  call void @useI32(i32 %tid3)
  call void @useI32(i32 %tid4)
  call void @useI32(i32 %tid5)
  ret void
}

define void @local_gtid_calls_only() {
; CHECK-LABEL: define {{[^@]+}}@local_gtid_calls_only() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TID5:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* @[[GLOB3]])
; CHECK-NEXT:    [[DOTKMPC_LOC_ADDR1:%.*]] = alloca [[STRUCT_IDENT_T:%.*]], align 8
; CHECK-NEXT:    [[DOTKMPC_LOC_ADDR2:%.*]] = alloca [[STRUCT_IDENT_T]], align 8
; CHECK-NEXT:    [[DOTKMPC_LOC_ADDR3:%.*]] = alloca [[STRUCT_IDENT_T]], align 8
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    ret void
;
entry:
  %.kmpc_loc.addr1 = alloca %struct.ident_t, align 8
  %.kmpc_loc.addr2 = alloca %struct.ident_t, align 8
  %.kmpc_loc.addr3 = alloca %struct.ident_t, align 8
  %tid0 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr1)
  %tid1 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr2)
  %tid2 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr3)
  call void @useI32(i32 %tid0)
  call void @useI32(i32 %tid1)
  call void @useI32(i32 %tid2)
  %tid3 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr1)
  %tid4 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr2)
  %tid5 = call i32 @__kmpc_global_thread_num(%struct.ident_t* %.kmpc_loc.addr3)
  call void @useI32(i32 %tid3)
  call void @useI32(i32 %tid4)
  call void @useI32(i32 %tid5)
  ret void
}

declare i32 @omp_get_level()
define void @local_and_global_glvl_calls() {
; CHECK-LABEL: define {{[^@]+}}@local_and_global_glvl_calls() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TID5:%.*]] = call i32 @omp_get_level()
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    ret void
;
entry:
  %tid0 = call i32 @omp_get_level()
  %tid1 = call i32 @omp_get_level()
  %tid2 = call i32 @omp_get_level()
  call void @useI32(i32 %tid0)
  call void @useI32(i32 %tid1)
  call void @useI32(i32 %tid2)
  %tid3 = call i32 @omp_get_level()
  %tid4 = call i32 @omp_get_level()
  %tid5 = call i32 @omp_get_level()
  call void @useI32(i32 %tid3)
  call void @useI32(i32 %tid4)
  call void @useI32(i32 %tid5)
  ret void
}

define void @local_glvl_calls_only() {
; CHECK-LABEL: define {{[^@]+}}@local_glvl_calls_only() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TID5:%.*]] = call i32 @omp_get_level()
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    call void @useI32(i32 [[TID5]])
; CHECK-NEXT:    ret void
;
entry:
  %tid0 = call i32 @omp_get_level()
  %tid1 = call i32 @omp_get_level()
  %tid2 = call i32 @omp_get_level()
  call void @useI32(i32 %tid0)
  call void @useI32(i32 %tid1)
  call void @useI32(i32 %tid2)
  %tid3 = call i32 @omp_get_level()
  %tid4 = call i32 @omp_get_level()
  %tid5 = call i32 @omp_get_level()
  call void @useI32(i32 %tid3)
  call void @useI32(i32 %tid4)
  call void @useI32(i32 %tid5)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 7, !"openmp", i32 50}
