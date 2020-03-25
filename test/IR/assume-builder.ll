; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='assume-builder,verify' --enable-knowledge-retention -S %s | FileCheck %s --check-prefixes=BASIC
; RUN: opt -passes='assume-builder,verify' --enable-knowledge-retention --assume-preserve-all -S %s | FileCheck %s --check-prefixes=ALL

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @func(i32*, i32*)
declare void @func_cold(i32*) cold
declare void @func_strbool(i32*) "no-jump-tables"
declare void @func_many(i32*) "no-jump-tables" nounwind "less-precise-fpmad" willreturn norecurse
declare void @func_argattr(i32* align 8, i32* nonnull) nounwind

define void @test(i32* %P, i32* %P1, i32* %P2, i32* %P3) {
; BASIC-LABEL: @test(
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[P:%.*]], i64 16), "nonnull"(i32* [[P]]) ]
; BASIC-NEXT:    call void @func(i32* nonnull dereferenceable(16) [[P]], i32* null)
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[P1:%.*]], i64 12), "nonnull"(i32* [[P]]) ]
; BASIC-NEXT:    call void @func(i32* dereferenceable(12) [[P1]], i32* nonnull [[P]])
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "cold"(), "dereferenceable"(i32* [[P1]], i64 12) ]
; BASIC-NEXT:    call void @func_cold(i32* dereferenceable(12) [[P1]]) #0
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "cold"(), "dereferenceable"(i32* [[P1]], i64 12) ]
; BASIC-NEXT:    call void @func_cold(i32* dereferenceable(12) [[P1]])
; BASIC-NEXT:    call void @func(i32* [[P1]], i32* [[P]])
; BASIC-NEXT:    call void @func_strbool(i32* [[P1]])
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[P]], i64 8), "dereferenceable"(i32* [[P]], i64 16) ]
; BASIC-NEXT:    call void @func(i32* dereferenceable(16) [[P]], i32* dereferenceable(8) [[P]])
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[P1]], i64 8) ]
; BASIC-NEXT:    call void @func_many(i32* align 8 [[P1]])
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[P2:%.*]], i64 8), "nonnull"(i32* [[P3:%.*]]) ]
; BASIC-NEXT:    call void @func_argattr(i32* [[P2]], i32* [[P3]])
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[P]]), "nonnull"(i32* [[P1]]) ]
; BASIC-NEXT:    call void @func(i32* nonnull [[P1]], i32* nonnull [[P]])
; BASIC-NEXT:    ret void
;
; ALL-LABEL: @test(
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[P:%.*]], i64 16), "nonnull"(i32* [[P]]) ]
; ALL-NEXT:    call void @func(i32* nonnull dereferenceable(16) [[P]], i32* null)
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[P1:%.*]], i64 12), "nonnull"(i32* [[P]]) ]
; ALL-NEXT:    call void @func(i32* dereferenceable(12) [[P1]], i32* nonnull [[P]])
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "cold"(), "dereferenceable"(i32* [[P1]], i64 12) ]
; ALL-NEXT:    call void @func_cold(i32* dereferenceable(12) [[P1]]) #0
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "cold"(), "dereferenceable"(i32* [[P1]], i64 12) ]
; ALL-NEXT:    call void @func_cold(i32* dereferenceable(12) [[P1]])
; ALL-NEXT:    call void @func(i32* [[P1]], i32* [[P]])
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "no-jump-tables"() ]
; ALL-NEXT:    call void @func_strbool(i32* [[P1]])
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[P]], i64 8), "dereferenceable"(i32* [[P]], i64 16) ]
; ALL-NEXT:    call void @func(i32* dereferenceable(16) [[P]], i32* dereferenceable(8) [[P]])
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[P1]], i64 8), "less-precise-fpmad"(), "no-jump-tables"(), "norecurse"(), "nounwind"(), "willreturn"() ]
; ALL-NEXT:    call void @func_many(i32* align 8 [[P1]])
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[P2:%.*]], i64 8), "nonnull"(i32* [[P3:%.*]]), "nounwind"() ]
; ALL-NEXT:    call void @func_argattr(i32* [[P2]], i32* [[P3]])
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[P]]), "nonnull"(i32* [[P1]]) ]
; ALL-NEXT:    call void @func(i32* nonnull [[P1]], i32* nonnull [[P]])
; ALL-NEXT:    ret void
;
  call void @func(i32* nonnull dereferenceable(16) %P, i32* null)
  call void @func(i32* dereferenceable(12) %P1, i32* nonnull %P)
  call void @func_cold(i32* dereferenceable(12) %P1) cold
  call void @func_cold(i32* dereferenceable(12) %P1)
  call void @func(i32* %P1, i32* %P)
  call void @func_strbool(i32* %P1)
  call void @func(i32* dereferenceable(16) %P, i32* dereferenceable(8) %P)
  call void @func_many(i32* align 8 %P1)
  call void @func_argattr(i32* %P2, i32* %P3)
  call void @func(i32* nonnull %P1, i32* nonnull %P)
  ret void
}

%struct.S = type { i32, i8, i32* }

define i32 @test2(%struct.S* %0, i32* %1, i8* %2) {
; BASIC-LABEL: @test2(
; BASIC-NEXT:    [[TMP4:%.*]] = alloca %struct.S*, align 8
; BASIC-NEXT:    [[TMP5:%.*]] = alloca i32*, align 8
; BASIC-NEXT:    [[TMP6:%.*]] = alloca i8*, align 8
; BASIC-NEXT:    [[TMP7:%.*]] = alloca [[STRUCT_S:%.*]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; BASIC-NEXT:    store %struct.S* [[TMP0:%.*]], %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8), "nonnull"(i32** [[TMP5]]) ]
; BASIC-NEXT:    store i32* [[TMP1:%.*]], i32** [[TMP5]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8** [[TMP6]], i64 8), "nonnull"(i8** [[TMP6]]) ]
; BASIC-NEXT:    store i8* [[TMP2:%.*]], i8** [[TMP6]]
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8), "nonnull"(i32** [[TMP5]]) ]
; BASIC-NEXT:    [[TMP8:%.*]] = load i32*, i32** [[TMP5]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP8]], i64 4), "dereferenceable"(i32* [[TMP8]], i64 4), "nonnull"(i32* [[TMP8]]) ]
; BASIC-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP8]], align 4
; BASIC-NEXT:    [[TMP10:%.*]] = trunc i32 [[TMP9]] to i8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8** [[TMP6]], i64 8), "dereferenceable"(i8** [[TMP6]], i64 8), "nonnull"(i8** [[TMP6]]) ]
; BASIC-NEXT:    [[TMP11:%.*]] = load i8*, i8** [[TMP6]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8* [[TMP11]], i64 1), "nonnull"(i8* [[TMP11]]) ]
; BASIC-NEXT:    store i8 [[TMP10]], i8* [[TMP11]], align 1
; BASIC-NEXT:    [[TMP12:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; BASIC-NEXT:    [[TMP13:%.*]] = load %struct.S*, %struct.S** [[TMP4]]
; BASIC-NEXT:    [[TMP14:%.*]] = bitcast %struct.S* [[TMP13]] to i8*
; BASIC-NEXT:    [[TMP15:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; BASIC-NEXT:    [[TMP16:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    [[TMP17:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP16]], i32 0, i32 0
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP17]], i64 8), "dereferenceable"(i32* [[TMP17]], i64 4), "nonnull"(i32* [[TMP17]]) ]
; BASIC-NEXT:    [[TMP18:%.*]] = load i32, i32* [[TMP17]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; BASIC-NEXT:    [[TMP19:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    [[TMP20:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP19]], i32 0, i32 1
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8* [[TMP20]], i64 4), "dereferenceable"(i8* [[TMP20]], i64 1), "nonnull"(i8* [[TMP20]]) ]
; BASIC-NEXT:    [[TMP21:%.*]] = load i8, i8* [[TMP20]], align 4
; BASIC-NEXT:    [[TMP22:%.*]] = sext i8 [[TMP21]] to i32
; BASIC-NEXT:    [[TMP23:%.*]] = add nsw i32 [[TMP18]], [[TMP22]]
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; BASIC-NEXT:    [[TMP24:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    [[TMP25:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP24]], i32 0, i32 2
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP25]], i64 8), "dereferenceable"(i32** [[TMP25]], i64 8), "nonnull"(i32** [[TMP25]]) ]
; BASIC-NEXT:    [[TMP26:%.*]] = load i32*, i32** [[TMP25]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP26]], i64 4), "dereferenceable"(i32* [[TMP26]], i64 4), "nonnull"(i32* [[TMP26]]) ]
; BASIC-NEXT:    [[TMP27:%.*]] = load i32, i32* [[TMP26]], align 4
; BASIC-NEXT:    [[TMP28:%.*]] = add nsw i32 [[TMP23]], [[TMP27]]
; BASIC-NEXT:    ret i32 [[TMP28]]
;
; ALL-LABEL: @test2(
; ALL-NEXT:    [[TMP4:%.*]] = alloca %struct.S*, align 8
; ALL-NEXT:    [[TMP5:%.*]] = alloca i32*, align 8
; ALL-NEXT:    [[TMP6:%.*]] = alloca i8*, align 8
; ALL-NEXT:    [[TMP7:%.*]] = alloca [[STRUCT_S:%.*]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; ALL-NEXT:    store %struct.S* [[TMP0:%.*]], %struct.S** [[TMP4]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8), "nonnull"(i32** [[TMP5]]) ]
; ALL-NEXT:    store i32* [[TMP1:%.*]], i32** [[TMP5]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8** [[TMP6]], i64 8), "nonnull"(i8** [[TMP6]]) ]
; ALL-NEXT:    store i8* [[TMP2:%.*]], i8** [[TMP6]]
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8), "nonnull"(i32** [[TMP5]]) ]
; ALL-NEXT:    [[TMP8:%.*]] = load i32*, i32** [[TMP5]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP8]], i64 4), "dereferenceable"(i32* [[TMP8]], i64 4), "nonnull"(i32* [[TMP8]]) ]
; ALL-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP8]], align 4
; ALL-NEXT:    [[TMP10:%.*]] = trunc i32 [[TMP9]] to i8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8** [[TMP6]], i64 8), "dereferenceable"(i8** [[TMP6]], i64 8), "nonnull"(i8** [[TMP6]]) ]
; ALL-NEXT:    [[TMP11:%.*]] = load i8*, i8** [[TMP6]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8* [[TMP11]], i64 1), "nonnull"(i8* [[TMP11]]) ]
; ALL-NEXT:    store i8 [[TMP10]], i8* [[TMP11]], align 1
; ALL-NEXT:    [[TMP12:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; ALL-NEXT:    [[TMP13:%.*]] = load %struct.S*, %struct.S** [[TMP4]]
; ALL-NEXT:    [[TMP14:%.*]] = bitcast %struct.S* [[TMP13]] to i8*
; ALL-NEXT:    [[TMP15:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; ALL-NEXT:    [[TMP16:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; ALL-NEXT:    [[TMP17:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP16]], i32 0, i32 0
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP17]], i64 8), "dereferenceable"(i32* [[TMP17]], i64 4), "nonnull"(i32* [[TMP17]]) ]
; ALL-NEXT:    [[TMP18:%.*]] = load i32, i32* [[TMP17]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; ALL-NEXT:    [[TMP19:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; ALL-NEXT:    [[TMP20:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP19]], i32 0, i32 1
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8* [[TMP20]], i64 4), "dereferenceable"(i8* [[TMP20]], i64 1), "nonnull"(i8* [[TMP20]]) ]
; ALL-NEXT:    [[TMP21:%.*]] = load i8, i8* [[TMP20]], align 4
; ALL-NEXT:    [[TMP22:%.*]] = sext i8 [[TMP21]] to i32
; ALL-NEXT:    [[TMP23:%.*]] = add nsw i32 [[TMP18]], [[TMP22]]
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8), "nonnull"(%struct.S** [[TMP4]]) ]
; ALL-NEXT:    [[TMP24:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; ALL-NEXT:    [[TMP25:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP24]], i32 0, i32 2
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP25]], i64 8), "dereferenceable"(i32** [[TMP25]], i64 8), "nonnull"(i32** [[TMP25]]) ]
; ALL-NEXT:    [[TMP26:%.*]] = load i32*, i32** [[TMP25]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP26]], i64 4), "dereferenceable"(i32* [[TMP26]], i64 4), "nonnull"(i32* [[TMP26]]) ]
; ALL-NEXT:    [[TMP27:%.*]] = load i32, i32* [[TMP26]], align 4
; ALL-NEXT:    [[TMP28:%.*]] = add nsw i32 [[TMP23]], [[TMP27]]
; ALL-NEXT:    ret i32 [[TMP28]]
;
  %4 = alloca %struct.S*, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.S, align 8
  store %struct.S* %0, %struct.S** %4, align 8
  store i32* %1, i32** %5, align 8
  store i8* %2, i8** %6
  %8 = load i32*, i32** %5, align 8
  %9 = load i32, i32* %8, align 4
  %10 = trunc i32 %9 to i8
  %11 = load i8*, i8** %6, align 8
  store i8 %10, i8* %11, align 1
  %12 = bitcast %struct.S* %7 to i8*
  %13 = load %struct.S*, %struct.S** %4
  %14 = bitcast %struct.S* %13 to i8*
  %15 = bitcast %struct.S* %7 to i8*
  %16 = load %struct.S*, %struct.S** %4, align 8
  %17 = getelementptr inbounds %struct.S, %struct.S* %16, i32 0, i32 0
  %18 = load i32, i32* %17, align 8
  %19 = load %struct.S*, %struct.S** %4, align 8
  %20 = getelementptr inbounds %struct.S, %struct.S* %19, i32 0, i32 1
  %21 = load i8, i8* %20, align 4
  %22 = sext i8 %21 to i32
  %23 = add nsw i32 %18, %22
  %24 = load %struct.S*, %struct.S** %4, align 8
  %25 = getelementptr inbounds %struct.S, %struct.S* %24, i32 0, i32 2
  %26 = load i32*, i32** %25, align 8
  %27 = load i32, i32* %26, align 4
  %28 = add nsw i32 %23, %27
  ret i32 %28
}

define i32 @test3(%struct.S* %0, i32* %1, i8* %2) "null-pointer-is-valid"="true" {
; BASIC-LABEL: @test3(
; BASIC-NEXT:    [[TMP4:%.*]] = alloca %struct.S*, align 8
; BASIC-NEXT:    [[TMP5:%.*]] = alloca i32*, align 8
; BASIC-NEXT:    [[TMP6:%.*]] = alloca i8*, align 8
; BASIC-NEXT:    [[TMP7:%.*]] = alloca [[STRUCT_S:%.*]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; BASIC-NEXT:    store %struct.S* [[TMP0:%.*]], %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8) ]
; BASIC-NEXT:    store i32* [[TMP1:%.*]], i32** [[TMP5]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8** [[TMP6]], i64 8), "dereferenceable"(i8** [[TMP6]], i64 8) ]
; BASIC-NEXT:    store i8* [[TMP2:%.*]], i8** [[TMP6]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8) ]
; BASIC-NEXT:    [[TMP8:%.*]] = load i32*, i32** [[TMP5]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP8]], i64 4), "dereferenceable"(i32* [[TMP8]], i64 4) ]
; BASIC-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP8]], align 4
; BASIC-NEXT:    [[TMP10:%.*]] = trunc i32 [[TMP9]] to i8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8** [[TMP6]], i64 8) ]
; BASIC-NEXT:    [[TMP11:%.*]] = load i8*, i8** [[TMP6]]
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8* [[TMP11]], i64 1) ]
; BASIC-NEXT:    store i8 [[TMP10]], i8* [[TMP11]], align 1
; BASIC-NEXT:    [[TMP12:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; BASIC-NEXT:    [[TMP13:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    [[TMP14:%.*]] = bitcast %struct.S* [[TMP13]] to i8*
; BASIC-NEXT:    [[TMP15:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; BASIC-NEXT:    [[TMP16:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    [[TMP17:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP16]], i32 0, i32 0
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP17]], i64 8), "dereferenceable"(i32* [[TMP17]], i64 4) ]
; BASIC-NEXT:    [[TMP18:%.*]] = load i32, i32* [[TMP17]], align 8
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; BASIC-NEXT:    [[TMP19:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    [[TMP20:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP19]], i32 0, i32 1
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8* [[TMP20]], i64 4), "dereferenceable"(i8* [[TMP20]], i64 1) ]
; BASIC-NEXT:    [[TMP21:%.*]] = load i8, i8* [[TMP20]], align 4
; BASIC-NEXT:    [[TMP22:%.*]] = sext i8 [[TMP21]] to i32
; BASIC-NEXT:    [[TMP23:%.*]] = add nsw i32 [[TMP18]], [[TMP22]]
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; BASIC-NEXT:    [[TMP24:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; BASIC-NEXT:    [[TMP25:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP24]], i32 0, i32 2
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32** [[TMP25]], i64 8) ]
; BASIC-NEXT:    [[TMP26:%.*]] = load i32*, i32** [[TMP25]]
; BASIC-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP26]], i64 4), "dereferenceable"(i32* [[TMP26]], i64 4) ]
; BASIC-NEXT:    [[TMP27:%.*]] = load i32, i32* [[TMP26]], align 4
; BASIC-NEXT:    [[TMP28:%.*]] = add nsw i32 [[TMP23]], [[TMP27]]
; BASIC-NEXT:    ret i32 [[TMP28]]
;
; ALL-LABEL: @test3(
; ALL-NEXT:    [[TMP4:%.*]] = alloca %struct.S*, align 8
; ALL-NEXT:    [[TMP5:%.*]] = alloca i32*, align 8
; ALL-NEXT:    [[TMP6:%.*]] = alloca i8*, align 8
; ALL-NEXT:    [[TMP7:%.*]] = alloca [[STRUCT_S:%.*]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; ALL-NEXT:    store %struct.S* [[TMP0:%.*]], %struct.S** [[TMP4]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8) ]
; ALL-NEXT:    store i32* [[TMP1:%.*]], i32** [[TMP5]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8** [[TMP6]], i64 8), "dereferenceable"(i8** [[TMP6]], i64 8) ]
; ALL-NEXT:    store i8* [[TMP2:%.*]], i8** [[TMP6]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32** [[TMP5]], i64 8), "dereferenceable"(i32** [[TMP5]], i64 8) ]
; ALL-NEXT:    [[TMP8:%.*]] = load i32*, i32** [[TMP5]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP8]], i64 4), "dereferenceable"(i32* [[TMP8]], i64 4) ]
; ALL-NEXT:    [[TMP9:%.*]] = load i32, i32* [[TMP8]], align 4
; ALL-NEXT:    [[TMP10:%.*]] = trunc i32 [[TMP9]] to i8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8** [[TMP6]], i64 8) ]
; ALL-NEXT:    [[TMP11:%.*]] = load i8*, i8** [[TMP6]]
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i8* [[TMP11]], i64 1) ]
; ALL-NEXT:    store i8 [[TMP10]], i8* [[TMP11]], align 1
; ALL-NEXT:    [[TMP12:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; ALL-NEXT:    [[TMP13:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; ALL-NEXT:    [[TMP14:%.*]] = bitcast %struct.S* [[TMP13]] to i8*
; ALL-NEXT:    [[TMP15:%.*]] = bitcast %struct.S* [[TMP7]] to i8*
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; ALL-NEXT:    [[TMP16:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; ALL-NEXT:    [[TMP17:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP16]], i32 0, i32 0
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP17]], i64 8), "dereferenceable"(i32* [[TMP17]], i64 4) ]
; ALL-NEXT:    [[TMP18:%.*]] = load i32, i32* [[TMP17]], align 8
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; ALL-NEXT:    [[TMP19:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; ALL-NEXT:    [[TMP20:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP19]], i32 0, i32 1
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8* [[TMP20]], i64 4), "dereferenceable"(i8* [[TMP20]], i64 1) ]
; ALL-NEXT:    [[TMP21:%.*]] = load i8, i8* [[TMP20]], align 4
; ALL-NEXT:    [[TMP22:%.*]] = sext i8 [[TMP21]] to i32
; ALL-NEXT:    [[TMP23:%.*]] = add nsw i32 [[TMP18]], [[TMP22]]
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(%struct.S** [[TMP4]], i64 8), "dereferenceable"(%struct.S** [[TMP4]], i64 8) ]
; ALL-NEXT:    [[TMP24:%.*]] = load %struct.S*, %struct.S** [[TMP4]], align 8
; ALL-NEXT:    [[TMP25:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.S* [[TMP24]], i32 0, i32 2
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32** [[TMP25]], i64 8) ]
; ALL-NEXT:    [[TMP26:%.*]] = load i32*, i32** [[TMP25]]
; ALL-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[TMP26]], i64 4), "dereferenceable"(i32* [[TMP26]], i64 4) ]
; ALL-NEXT:    [[TMP27:%.*]] = load i32, i32* [[TMP26]], align 4
; ALL-NEXT:    [[TMP28:%.*]] = add nsw i32 [[TMP23]], [[TMP27]]
; ALL-NEXT:    ret i32 [[TMP28]]
;
  %4 = alloca %struct.S*, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.S, align 8
  store %struct.S* %0, %struct.S** %4, align 8
  store i32* %1, i32** %5, align 8
  store i8* %2, i8** %6, align 8
  %8 = load i32*, i32** %5, align 8
  %9 = load i32, i32* %8, align 4
  %10 = trunc i32 %9 to i8
  %11 = load i8*, i8** %6
  store i8 %10, i8* %11, align 1
  %12 = bitcast %struct.S* %7 to i8*
  %13 = load %struct.S*, %struct.S** %4, align 8
  %14 = bitcast %struct.S* %13 to i8*
  %15 = bitcast %struct.S* %7 to i8*
  %16 = load %struct.S*, %struct.S** %4, align 8
  %17 = getelementptr inbounds %struct.S, %struct.S* %16, i32 0, i32 0
  %18 = load i32, i32* %17, align 8
  %19 = load %struct.S*, %struct.S** %4, align 8
  %20 = getelementptr inbounds %struct.S, %struct.S* %19, i32 0, i32 1
  %21 = load i8, i8* %20, align 4
  %22 = sext i8 %21 to i32
  %23 = add nsw i32 %18, %22
  %24 = load %struct.S*, %struct.S** %4, align 8
  %25 = getelementptr inbounds %struct.S, %struct.S* %24, i32 0, i32 2
  %26 = load i32*, i32** %25
  %27 = load i32, i32* %26, align 4
  %28 = add nsw i32 %23, %27
  ret i32 %28
}
