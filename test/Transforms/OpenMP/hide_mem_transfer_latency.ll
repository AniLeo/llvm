; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: -p --function-signature --scrub-attributes
; RUN: opt -S -passes=openmpopt -aa-pipeline=basic-aa -openmp-hide-memory-transfer-latency < %s | FileCheck %s
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

; CHECK: %struct.__tgt_async_info = type { i8* }

%struct.ident_t = type { i32, i32, i32, i32, i8* }
%struct.__tgt_offload_entry = type { i8*, i8*, i64, i32, i32 }

@.offload_maptypes = private unnamed_addr constant [1 x i64] [i64 35]
@.__omp_offloading_heavyComputation1.region_id = weak constant i8 0
@.offload_sizes.1 = private unnamed_addr constant [1 x i64] [i64 8]
@.offload_maptypes.2 = private unnamed_addr constant [1 x i64] [i64 800]

@.__omp_offloading_heavyComputation2.region_id = weak constant i8 0
@.offload_maptypes.3 = private unnamed_addr constant [2 x i64] [i64 35, i64 35]

@.__omp_offloading_heavyComputation3.region_id = weak constant i8 0
@.offload_sizes.2 = private unnamed_addr constant [2 x i64] [i64 4, i64 0]
@.offload_maptypes.4 = private unnamed_addr constant [2 x i64] [i64 800, i64 544]

@.offload_maptypes.5 = private unnamed_addr constant [1 x i64] [i64 33]

;double heavyComputation1() {
;  double a = rand() % 777;
;  double random = rand();
;
;  //#pragma omp target data map(a)
;  void* args[1];
;  args[0] = &a;
;  __tgt_target_data_begin(..., args, ...)
;
;  #pragma omp target teams
;  for (int i = 0; i < 1000; ++i) {
;    a *= i*i / 2;
;  }
;
;  return random + a;
;}
define dso_local double @heavyComputation1() {
; CHECK-LABEL: define {{[^@]+}}@heavyComputation1()
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a = alloca double, align 8
; CHECK-NEXT:    %.offload_baseptrs = alloca [1 x i8*], align 8
; CHECK-NEXT:    %.offload_ptrs = alloca [1 x i8*], align 8
; CHECK-NEXT:    %.offload_baseptrs4 = alloca [1 x i8*], align 8
; CHECK-NEXT:    %.offload_ptrs5 = alloca [1 x i8*], align 8
; CHECK-NEXT:    %0 = bitcast double* %a to i8*
; CHECK-NEXT:    %call = tail call i32 (...) @rand()
; CHECK-NEXT:    %rem = srem i32 %call, 777
; CHECK-NEXT:    %conv = sitofp i32 %rem to double
; CHECK-NEXT:    store double %conv, double* %a, align 8
; CHECK-NEXT:    %call1 = tail call i32 (...) @rand()
; CHECK-NEXT:    %1 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_baseptrs, i64 0, i64 0
; CHECK-NEXT:    %2 = bitcast [1 x i8*]* %.offload_baseptrs to double**
; CHECK-NEXT:    store double* %a, double** %2, align 8
; CHECK-NEXT:    %3 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_ptrs, i64 0, i64 0
; CHECK-NEXT:    %4 = bitcast [1 x i8*]* %.offload_ptrs to double**
; CHECK-NEXT:    store double* %a, double** %4, align 8

; CHECK-NEXT:    %handle = call %struct.__tgt_async_info @__tgt_target_data_begin_mapper_issue(i64 -1, i32 1, i8** %1, i8** %3, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_sizes.1, i64 0, i64 0), i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes, i64 0, i64 0), i8** null)
; CHECK-NEXT:    call void @__tgt_target_data_begin_mapper_wait(i64 -1, %struct.__tgt_async_info %handle)

; CHECK-NEXT:    %5 = bitcast double* %a to i64*
; CHECK-NEXT:    %6 = load i64, i64* %5, align 8
; CHECK-NEXT:    %7 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_baseptrs4, i64 0, i64 0
; CHECK-NEXT:    %8 = bitcast [1 x i8*]* %.offload_baseptrs4 to i64*
; CHECK-NEXT:    store i64 %6, i64* %8, align 8
; CHECK-NEXT:    %9 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_ptrs5, i64 0, i64 0
; CHECK-NEXT:    %10 = bitcast [1 x i8*]* %.offload_ptrs5 to i64*
; CHECK-NEXT:    store i64 %6, i64* %10, align 8
; CHECK-NEXT:    %11 = call i32 @__tgt_target_teams_mapper(i64 -1, i8* nonnull @.__omp_offloading_heavyComputation1.region_id, i32 1, i8** nonnull %7, i8** nonnull %9, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_sizes.1, i64 0, i64 0), i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes.2, i64 0, i64 0), i8** null, i32 0, i32 0)
; CHECK-NEXT:    %.not = icmp eq i32 %11, 0
; CHECK-NEXT:    br i1 %.not, label %omp_offload.cont, label %omp_offload.failed
; CHECK:       omp_offload.failed:
; CHECK-NEXT:    call void @heavyComputation1FallBack(i64 %6)
; CHECK-NEXT:    br label %omp_offload.cont
; CHECK:       omp_offload.cont:
; CHECK-NEXT:    %conv2 = sitofp i32 %call1 to double
; CHECK-NEXT:    call void @__tgt_target_data_end_mapper(i64 -1, i32 1, i8** nonnull %1, i8** nonnull %3, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_sizes.1, i64 0, i64 0), i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes, i64 0, i64 0), i8** null)
; CHECK-NEXT:    %12 = load double, double* %a, align 8
; CHECK-NEXT:    %add = fadd double %12, %conv2
; CHECK-NEXT:    ret double %add
;
entry:
  %a = alloca double, align 8
  %.offload_baseptrs = alloca [1 x i8*], align 8
  %.offload_ptrs = alloca [1 x i8*], align 8
  %.offload_baseptrs4 = alloca [1 x i8*], align 8
  %.offload_ptrs5 = alloca [1 x i8*], align 8

  %0 = bitcast double* %a to i8*
  %call = tail call i32 (...) @rand()
  %rem = srem i32 %call, 777
  %conv = sitofp i32 %rem to double
  store double %conv, double* %a, align 8

  ; FIXME: call to @__tgt_target_data_begin_mapper_issue(...) should be moved here.
  %call1 = tail call i32 (...) @rand()

  %1 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_baseptrs, i64 0, i64 0
  %2 = bitcast [1 x i8*]* %.offload_baseptrs to double**
  store double* %a, double** %2, align 8
  %3 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_ptrs, i64 0, i64 0
  %4 = bitcast [1 x i8*]* %.offload_ptrs to double**
  store double* %a, double** %4, align 8
  call void @__tgt_target_data_begin_mapper(i64 -1, i32 1, i8** nonnull %1, i8** nonnull %3, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_sizes.1, i64 0, i64 0), i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes, i64 0, i64 0), i8** null)

  %5 = bitcast double* %a to i64*
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_baseptrs4, i64 0, i64 0
  %8 = bitcast [1 x i8*]* %.offload_baseptrs4 to i64*
  store i64 %6, i64* %8, align 8
  %9 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_ptrs5, i64 0, i64 0
  %10 = bitcast [1 x i8*]* %.offload_ptrs5 to i64*
  store i64 %6, i64* %10, align 8

  ; FIXME: call to @__tgt_target_data_begin_mapper_wait(...) should be moved here.
  %11 = call i32 @__tgt_target_teams_mapper(i64 -1, i8* nonnull @.__omp_offloading_heavyComputation1.region_id, i32 1, i8** nonnull %7, i8** nonnull %9, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_sizes.1, i64 0, i64 0), i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes.2, i64 0, i64 0), i8** null, i32 0, i32 0)
  %.not = icmp eq i32 %11, 0
  br i1 %.not, label %omp_offload.cont, label %omp_offload.failed

omp_offload.failed:                               ; preds = %entry
  call void @heavyComputation1FallBack(i64 %6)
  br label %omp_offload.cont

omp_offload.cont:                                 ; preds = %omp_offload.failed, %entry
  %conv2 = sitofp i32 %call1 to double
  call void @__tgt_target_data_end_mapper(i64 -1, i32 1, i8** nonnull %1, i8** nonnull %3, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_sizes.1, i64 0, i64 0), i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes, i64 0, i64 0), i8** null)
  %12 = load double, double* %a, align 8
  %add = fadd double %12, %conv2
  ret double %add
}

define internal void @heavyComputation1FallBack(i64 %a) {
entry:
  ; Fallback for offloading function heavyComputation1.
  ret void
}

;int heavyComputation2(double* a, unsigned size) {
;  int random = rand() % 7;
;
;  //#pragma omp target data map(a[0:size], size)
;  void* args[2];
;  args[0] = &a;
;  args[1] = &size;
;  __tgt_target_data_begin(..., args, ...)
;
;  #pragma omp target teams
;  for (int i = 0; i < size; ++i) {
;    a[i] = ++a[i] * 3.141624;
;  }
;
;  return random;
;}
define dso_local i32 @heavyComputation2(double* %a, i32 %size) {
; CHECK-LABEL: define {{[^@]+}}@heavyComputation2(double* %a, i32 %size)
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %size.addr = alloca i32, align 4
; CHECK-NEXT:    %.offload_baseptrs = alloca [2 x i8*], align 8
; CHECK-NEXT:    %.offload_ptrs = alloca [2 x i8*], align 8
; CHECK-NEXT:    %.offload_sizes = alloca [2 x i64], align 8
; CHECK-NEXT:    %.offload_baseptrs2 = alloca [2 x i8*], align 8
; CHECK-NEXT:    %.offload_ptrs3 = alloca [2 x i8*], align 8
; CHECK-NEXT:    store i32 %size, i32* %size.addr, align 4
; CHECK-NEXT:    %call = tail call i32 (...) @rand()
; CHECK-NEXT:    %conv = zext i32 %size to i64
; CHECK-NEXT:    %0 = shl nuw nsw i64 %conv, 3
; CHECK-NEXT:    %1 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 0
; CHECK-NEXT:    %2 = bitcast [2 x i8*]* %.offload_baseptrs to double**
; CHECK-NEXT:    store double* %a, double** %2, align 8
; CHECK-NEXT:    %3 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 0
; CHECK-NEXT:    %4 = bitcast [2 x i8*]* %.offload_ptrs to double**
; CHECK-NEXT:    store double* %a, double** %4, align 8
; CHECK-NEXT:    %5 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 0
; CHECK-NEXT:    store i64 %0, i64* %5, align 8
; CHECK-NEXT:    %6 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 1
; CHECK-NEXT:    %7 = bitcast i8** %6 to i32**
; CHECK-NEXT:    store i32* %size.addr, i32** %7, align 8
; CHECK-NEXT:    %8 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 1
; CHECK-NEXT:    %9 = bitcast i8** %8 to i32**
; CHECK-NEXT:    store i32* %size.addr, i32** %9, align 8
; CHECK-NEXT:    %10 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 1
; CHECK-NEXT:    store i64 4, i64* %10, align 8

; CHECK-NEXT:    %handle = call %struct.__tgt_async_info @__tgt_target_data_begin_mapper_issue(i64 -1, i32 2, i8** %1, i8** %3, i64* %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)
; CHECK-NEXT:    call void @__tgt_target_data_begin_mapper_wait(i64 -1, %struct.__tgt_async_info %handle)

; CHECK-NEXT:    %11 = load i32, i32* %size.addr, align 4
; CHECK-NEXT:    %size.casted = zext i32 %11 to i64
; CHECK-NEXT:    %12 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 0
; CHECK-NEXT:    %13 = bitcast [2 x i8*]* %.offload_baseptrs2 to i64*
; CHECK-NEXT:    store i64 %size.casted, i64* %13, align 8
; CHECK-NEXT:    %14 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 0
; CHECK-NEXT:    %15 = bitcast [2 x i8*]* %.offload_ptrs3 to i64*
; CHECK-NEXT:    store i64 %size.casted, i64* %15, align 8
; CHECK-NEXT:    %16 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 1
; CHECK-NEXT:    %17 = bitcast i8** %16 to double**
; CHECK-NEXT:    store double* %a, double** %17, align 8
; CHECK-NEXT:    %18 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 1
; CHECK-NEXT:    %19 = bitcast i8** %18 to double**
; CHECK-NEXT:    store double* %a, double** %19, align 8
; CHECK-NEXT:    %20 = call i32 @__tgt_target_teams_mapper(i64 -1, i8* nonnull @.__omp_offloading_heavyComputation2.region_id, i32 2, i8** nonnull %12, i8** nonnull %14, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_sizes.2, i64 0, i64 0), i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.4, i64 0, i64 0), i8** null, i32 0, i32 0)
; CHECK-NEXT:    %.not = icmp eq i32 %20, 0
; CHECK-NEXT:    br i1 %.not, label %omp_offload.cont, label %omp_offload.failed
; CHECK:       omp_offload.failed:
; CHECK-NEXT:    call void @heavyComputation2FallBack(i64 %size.casted, double* %a)
; CHECK-NEXT:    br label %omp_offload.cont
; CHECK:       omp_offload.cont:
; CHECK-NEXT:    %rem = srem i32 %call, 7
; CHECK-NEXT:    call void @__tgt_target_data_end_mapper(i64 -1, i32 2, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)
; CHECK-NEXT:    ret i32 %rem
;
entry:
  %size.addr = alloca i32, align 4
  %.offload_baseptrs = alloca [2 x i8*], align 8
  %.offload_ptrs = alloca [2 x i8*], align 8
  %.offload_sizes = alloca [2 x i64], align 8
  %.offload_baseptrs2 = alloca [2 x i8*], align 8
  %.offload_ptrs3 = alloca [2 x i8*], align 8

  store i32 %size, i32* %size.addr, align 4
  %call = tail call i32 (...) @rand()

  %conv = zext i32 %size to i64
  %0 = shl nuw nsw i64 %conv, 3
  %1 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 0
  %2 = bitcast [2 x i8*]* %.offload_baseptrs to double**
  store double* %a, double** %2, align 8
  %3 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 0
  %4 = bitcast [2 x i8*]* %.offload_ptrs to double**
  store double* %a, double** %4, align 8
  %5 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 0
  store i64 %0, i64* %5, align 8
  %6 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 1
  %7 = bitcast i8** %6 to i32**
  store i32* %size.addr, i32** %7, align 8
  %8 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 1
  %9 = bitcast i8** %8 to i32**
  store i32* %size.addr, i32** %9, align 8
  %10 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 1
  store i64 4, i64* %10, align 8
  call void @__tgt_target_data_begin_mapper(i64 -1, i32 2, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)

  %11 = load i32, i32* %size.addr, align 4
  %size.casted = zext i32 %11 to i64
  %12 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 0
  %13 = bitcast [2 x i8*]* %.offload_baseptrs2 to i64*
  store i64 %size.casted, i64* %13, align 8
  %14 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 0
  %15 = bitcast [2 x i8*]* %.offload_ptrs3 to i64*
  store i64 %size.casted, i64* %15, align 8
  %16 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 1
  %17 = bitcast i8** %16 to double**
  store double* %a, double** %17, align 8
  %18 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 1
  %19 = bitcast i8** %18 to double**
  store double* %a, double** %19, align 8

  ; FIXME: call to @__tgt_target_data_begin_mapper_wait(...) should be moved here.
  %20 = call i32 @__tgt_target_teams_mapper(i64 -1, i8* nonnull @.__omp_offloading_heavyComputation2.region_id, i32 2, i8** nonnull %12, i8** nonnull %14, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_sizes.2, i64 0, i64 0), i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.4, i64 0, i64 0), i8** null, i32 0, i32 0)
  %.not = icmp eq i32 %20, 0
  br i1 %.not, label %omp_offload.cont, label %omp_offload.failed

omp_offload.failed:                               ; preds = %entry
  call void @heavyComputation2FallBack(i64 %size.casted, double* %a)
  br label %omp_offload.cont

omp_offload.cont:                                 ; preds = %omp_offload.failed, %entry
  %rem = srem i32 %call, 7
  call void @__tgt_target_data_end_mapper(i64 -1, i32 2, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)
  ret i32 %rem
}

define internal void @heavyComputation2FallBack(i64 %size, double* %a) {
entry:
  ; Fallback for offloading function heavyComputation2.
  ret void
}

;int heavyComputation3(double* restrict a, unsigned size) {
;  int random = rand() % 7;
;
;  //#pragma omp target data map(a[0:size], size)
;  void* args[2];
;  args[0] = &a;
;  args[1] = &size;
;  __tgt_target_data_begin(..., args, ...)
;
;  #pragma omp target teams
;  for (int i = 0; i < size; ++i) {
;    a[i] = ++a[i] * 3.141624;
;  }
;
;  return random;
;}
define dso_local i32 @heavyComputation3(double* noalias %a, i32 %size) {
; CHECK-LABEL: define {{[^@]+}}@heavyComputation3(double* noalias %a, i32 %size)
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %size.addr = alloca i32, align 4
; CHECK-NEXT:    %.offload_baseptrs = alloca [2 x i8*], align 8
; CHECK-NEXT:    %.offload_ptrs = alloca [2 x i8*], align 8
; CHECK-NEXT:    %.offload_sizes = alloca [2 x i64], align 8
; CHECK-NEXT:    %.offload_baseptrs2 = alloca [2 x i8*], align 8
; CHECK-NEXT:    %.offload_ptrs3 = alloca [2 x i8*], align 8
; CHECK-NEXT:    store i32 %size, i32* %size.addr, align 4
; CHECK-NEXT:    %call = tail call i32 (...) @rand()
; CHECK-NEXT:    %conv = zext i32 %size to i64
; CHECK-NEXT:    %0 = shl nuw nsw i64 %conv, 3
; CHECK-NEXT:    %1 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 0
; CHECK-NEXT:    %2 = bitcast [2 x i8*]* %.offload_baseptrs to double**
; CHECK-NEXT:    store double* %a, double** %2, align 8
; CHECK-NEXT:    %3 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 0
; CHECK-NEXT:    %4 = bitcast [2 x i8*]* %.offload_ptrs to double**
; CHECK-NEXT:    store double* %a, double** %4, align 8
; CHECK-NEXT:    %5 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 0
; CHECK-NEXT:    store i64 %0, i64* %5, align 8
; CHECK-NEXT:    %6 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 1
; CHECK-NEXT:    %7 = bitcast i8** %6 to i32**
; CHECK-NEXT:    store i32* %size.addr, i32** %7, align 8
; CHECK-NEXT:    %8 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 1
; CHECK-NEXT:    %9 = bitcast i8** %8 to i32**
; CHECK-NEXT:    store i32* %size.addr, i32** %9, align 8
; CHECK-NEXT:    %10 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 1
; CHECK-NEXT:    store i64 4, i64* %10, align 8

; CHECK-NEXT:    %handle = call %struct.__tgt_async_info @__tgt_target_data_begin_mapper_issue(i64 -1, i32 2, i8** %1, i8** %3, i64* %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)
; CHECK-NEXT:    call void @__tgt_target_data_begin_mapper_wait(i64 -1, %struct.__tgt_async_info %handle)

; CHECK-NEXT:    %11 = load i32, i32* %size.addr, align 4
; CHECK-NEXT:    %size.casted = zext i32 %11 to i64
; CHECK-NEXT:    %12 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 0
; CHECK-NEXT:    %13 = bitcast [2 x i8*]* %.offload_baseptrs2 to i64*
; CHECK-NEXT:    store i64 %size.casted, i64* %13, align 8
; CHECK-NEXT:    %14 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 0
; CHECK-NEXT:    %15 = bitcast [2 x i8*]* %.offload_ptrs3 to i64*
; CHECK-NEXT:    store i64 %size.casted, i64* %15, align 8
; CHECK-NEXT:    %16 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 1
; CHECK-NEXT:    %17 = bitcast i8** %16 to double**
; CHECK-NEXT:    store double* %a, double** %17, align 8
; CHECK-NEXT:    %18 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 1
; CHECK-NEXT:    %19 = bitcast i8** %18 to double**
; CHECK-NEXT:    store double* %a, double** %19, align 8
; CHECK-NEXT:    %20 = call i32 @__tgt_target_teams_mapper(i64 -1, i8* nonnull @.__omp_offloading_heavyComputation3.region_id, i32 2, i8** nonnull %12, i8** nonnull %14, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_sizes.2, i64 0, i64 0), i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.4, i64 0, i64 0), i8** null, i32 0, i32 0)
; CHECK-NEXT:    %.not = icmp eq i32 %20, 0
; CHECK-NEXT:    br i1 %.not, label %omp_offload.cont, label %omp_offload.failed
; CHECK:       omp_offload.failed:
; CHECK-NEXT:    call void @heavyComputation3FallBack(i64 %size.casted, double* %a)
; CHECK-NEXT:    br label %omp_offload.cont
; CHECK:       omp_offload.cont:
; CHECK-NEXT:    %rem = srem i32 %call, 7
; CHECK-NEXT:    call void @__tgt_target_data_end_mapper(i64 -1, i32 2, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)
; CHECK-NEXT:    ret i32 %rem
;
entry:
  %size.addr = alloca i32, align 4
  %.offload_baseptrs = alloca [2 x i8*], align 8
  %.offload_ptrs = alloca [2 x i8*], align 8
  %.offload_sizes = alloca [2 x i64], align 8
  %.offload_baseptrs2 = alloca [2 x i8*], align 8
  %.offload_ptrs3 = alloca [2 x i8*], align 8
  store i32 %size, i32* %size.addr, align 4

  ; FIXME: call to @__tgt_target_data_begin_mapper_issue(...) should be moved here.
  %call = tail call i32 (...) @rand()

  %conv = zext i32 %size to i64
  %0 = shl nuw nsw i64 %conv, 3
  %1 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 0
  %2 = bitcast [2 x i8*]* %.offload_baseptrs to double**
  store double* %a, double** %2, align 8
  %3 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 0
  %4 = bitcast [2 x i8*]* %.offload_ptrs to double**
  store double* %a, double** %4, align 8
  %5 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 0
  store i64 %0, i64* %5, align 8
  %6 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs, i64 0, i64 1
  %7 = bitcast i8** %6 to i32**
  store i32* %size.addr, i32** %7, align 8
  %8 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs, i64 0, i64 1
  %9 = bitcast i8** %8 to i32**
  store i32* %size.addr, i32** %9, align 8
  %10 = getelementptr inbounds [2 x i64], [2 x i64]* %.offload_sizes, i64 0, i64 1
  store i64 4, i64* %10, align 8
  call void @__tgt_target_data_begin_mapper(i64 -1, i32 2, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)

  %11 = load i32, i32* %size.addr, align 4
  %size.casted = zext i32 %11 to i64
  %12 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 0
  %13 = bitcast [2 x i8*]* %.offload_baseptrs2 to i64*
  store i64 %size.casted, i64* %13, align 8
  %14 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 0
  %15 = bitcast [2 x i8*]* %.offload_ptrs3 to i64*
  store i64 %size.casted, i64* %15, align 8
  %16 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_baseptrs2, i64 0, i64 1
  %17 = bitcast i8** %16 to double**
  store double* %a, double** %17, align 8
  %18 = getelementptr inbounds [2 x i8*], [2 x i8*]* %.offload_ptrs3, i64 0, i64 1
  %19 = bitcast i8** %18 to double**
  store double* %a, double** %19, align 8

  ; FIXME: call to @__tgt_target_data_begin_mapper_wait(...) should be moved here.
  %20 = call i32 @__tgt_target_teams_mapper(i64 -1, i8* nonnull @.__omp_offloading_heavyComputation3.region_id, i32 2, i8** nonnull %12, i8** nonnull %14, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_sizes.2, i64 0, i64 0), i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.4, i64 0, i64 0), i8** null, i32 0, i32 0)
  %.not = icmp eq i32 %20, 0
  br i1 %.not, label %omp_offload.cont, label %omp_offload.failed

omp_offload.failed:                               ; preds = %entry
  call void @heavyComputation3FallBack(i64 %size.casted, double* %a)
  br label %omp_offload.cont

omp_offload.cont:                                 ; preds = %omp_offload.failed, %entry
  %rem = srem i32 %call, 7
  call void @__tgt_target_data_end_mapper(i64 -1, i32 2, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([2 x i64], [2 x i64]* @.offload_maptypes.3, i64 0, i64 0), i8** null)
  ret i32 %rem
}

define internal void @heavyComputation3FallBack(i64 %size, double* %a) {
entry:
  ; Fallback for offloading function heavyComputation3.
  ret void
}

;int dataTransferOnly1(double* restrict a, unsigned size) {
;  // Random computation.
;  int random = rand();
;
;  //#pragma omp target data map(to:a[0:size])
;  void* args[1];
;  args[0] = &a;
;  __tgt_target_data_begin(..., args, ...)
;
;  // Random computation.
;  random %= size;
;  return random;
;}
define dso_local i32 @dataTransferOnly1(double* noalias %a, i32 %size) {
; CHECK-LABEL: define {{[^@]+}}@dataTransferOnly1(double* noalias %a, i32 %size)
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %.offload_baseptrs = alloca [1 x i8*], align 8
; CHECK-NEXT:    %.offload_ptrs = alloca [1 x i8*], align 8
; CHECK-NEXT:    %.offload_sizes = alloca [1 x i64], align 8
; CHECK-NEXT:    %call = tail call i32 (...) @rand()
; CHECK-NEXT:    %conv = zext i32 %size to i64
; CHECK-NEXT:    %0 = shl nuw nsw i64 %conv, 3
; CHECK-NEXT:    %1 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_baseptrs, i64 0, i64 0
; CHECK-NEXT:    %2 = bitcast [1 x i8*]* %.offload_baseptrs to double**
; CHECK-NEXT:    store double* %a, double** %2, align 8
; CHECK-NEXT:    %3 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_ptrs, i64 0, i64 0
; CHECK-NEXT:    %4 = bitcast [1 x i8*]* %.offload_ptrs to double**
; CHECK-NEXT:    store double* %a, double** %4, align 8
; CHECK-NEXT:    %5 = getelementptr inbounds [1 x i64], [1 x i64]* %.offload_sizes, i64 0, i64 0
; CHECK-NEXT:    store i64 %0, i64* %5, align 8

; CHECK-NEXT:    %handle = call %struct.__tgt_async_info @__tgt_target_data_begin_mapper_issue(i64 -1, i32 1, i8** %1, i8** %3, i64* %5, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes.5, i64 0, i64 0), i8** null)
; CHECK-NEXT:    call void @__tgt_target_data_begin_mapper_wait(i64 -1, %struct.__tgt_async_info %handle)

; CHECK-NEXT:    %rem = urem i32 %call, %size
; CHECK-NEXT:    call void @__tgt_target_data_end_mapper(i64 -1, i32 1, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes.5, i64 0, i64 0), i8** null)
; CHECK-NEXT:    ret i32 %rem
;
entry:
  %.offload_baseptrs = alloca [1 x i8*], align 8
  %.offload_ptrs = alloca [1 x i8*], align 8
  %.offload_sizes = alloca [1 x i64], align 8

  ; FIXME: call to @__tgt_target_data_begin_issue_mapper(...) should be moved here.
  %call = tail call i32 (...) @rand()

  %conv = zext i32 %size to i64
  %0 = shl nuw nsw i64 %conv, 3
  %1 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_baseptrs, i64 0, i64 0
  %2 = bitcast [1 x i8*]* %.offload_baseptrs to double**
  store double* %a, double** %2, align 8
  %3 = getelementptr inbounds [1 x i8*], [1 x i8*]* %.offload_ptrs, i64 0, i64 0
  %4 = bitcast [1 x i8*]* %.offload_ptrs to double**
  store double* %a, double** %4, align 8
  %5 = getelementptr inbounds [1 x i64], [1 x i64]* %.offload_sizes, i64 0, i64 0
  store i64 %0, i64* %5, align 8
  call void @__tgt_target_data_begin_mapper(i64 -1, i32 1, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes.5, i64 0, i64 0), i8** null)

  %rem = urem i32 %call, %size

  call void @__tgt_target_data_end_mapper(i64 -1, i32 1, i8** nonnull %1, i8** nonnull %3, i64* nonnull %5, i64* getelementptr inbounds ([1 x i64], [1 x i64]* @.offload_maptypes.5, i64 0, i64 0), i8** null)
  ret i32 %rem
}

declare void @__tgt_target_data_begin_mapper(i64, i32, i8**, i8**, i64*, i64*, i8**)
declare i32 @__tgt_target_teams_mapper(i64, i8*, i32, i8**, i8**, i64*, i64*, i8**, i32, i32)
declare void @__tgt_target_data_end_mapper(i64, i32, i8**, i8**, i64*, i64*, i8**)

declare dso_local i32 @rand(...)

; CHECK: declare %struct.__tgt_async_info @__tgt_target_data_begin_mapper_issue(i64, i32, i8**, i8**, i64*, i64*, i8**)
; CHECK: declare void @__tgt_target_data_begin_mapper_wait(i64, %struct.__tgt_async_info)
