; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics -fuse-matrix-use-loops=false -fuse-matrix-tile-size=2 -matrix-allow-contract -force-fuse-matrix -instcombine -verify-dom-info %s -S | FileCheck %s
; RUN: opt -passes=lower-matrix-intrinsics,instcombine -fuse-matrix-use-loops=false -fuse-matrix-tile-size=2 -matrix-allow-contract -force-fuse-matrix -verify-dom-info %s -S | FileCheck %s

; REQUIRES: aarch64-registered-target

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "aarch64-apple-ios"

; Test tiling without generating explicit loops.

define void @multiply(<16 x double> * %A, <16 x double> * %B, <16 x double>* %C) {
; CHECK-LABEL: @multiply(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STORE_BEGIN:%.*]] = ptrtoint <16 x double>* [[C:%.*]] to i64
; CHECK-NEXT:    [[STORE_END:%.*]] = add nuw nsw i64 [[STORE_BEGIN]], 128
; CHECK-NEXT:    [[LOAD_BEGIN:%.*]] = ptrtoint <16 x double>* [[A:%.*]] to i64
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ugt i64 [[STORE_END]], [[LOAD_BEGIN]]
; CHECK-NEXT:    br i1 [[TMP0]], label [[ALIAS_CONT:%.*]], label [[NO_ALIAS:%.*]]
; CHECK:       alias_cont:
; CHECK-NEXT:    [[LOAD_END:%.*]] = add nuw nsw i64 [[LOAD_BEGIN]], 128
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i64 [[LOAD_END]], [[STORE_BEGIN]]
; CHECK-NEXT:    br i1 [[TMP1]], label [[COPY:%.*]], label [[NO_ALIAS]]
; CHECK:       copy:
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <16 x double>, align 128
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <16 x double>* [[TMP2]] to i8*
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <16 x double>* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 128 dereferenceable(128) [[TMP3]], i8* noundef nonnull align 8 dereferenceable(128) [[TMP4]], i64 128, i1 false)
; CHECK-NEXT:    br label [[NO_ALIAS]]
; CHECK:       no_alias:
; CHECK-NEXT:    [[TMP5:%.*]] = phi <16 x double>* [ [[A]], [[ENTRY:%.*]] ], [ [[A]], [[ALIAS_CONT]] ], [ [[TMP2]], [[COPY]] ]
; CHECK-NEXT:    [[STORE_BEGIN4:%.*]] = ptrtoint <16 x double>* [[C]] to i64
; CHECK-NEXT:    [[STORE_END5:%.*]] = add nuw nsw i64 [[STORE_BEGIN4]], 128
; CHECK-NEXT:    [[LOAD_BEGIN6:%.*]] = ptrtoint <16 x double>* [[B:%.*]] to i64
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ugt i64 [[STORE_END5]], [[LOAD_BEGIN6]]
; CHECK-NEXT:    br i1 [[TMP6]], label [[ALIAS_CONT1:%.*]], label [[NO_ALIAS3:%.*]]
; CHECK:       alias_cont1:
; CHECK-NEXT:    [[LOAD_END7:%.*]] = add nuw nsw i64 [[LOAD_BEGIN6]], 128
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ugt i64 [[LOAD_END7]], [[STORE_BEGIN4]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[COPY2:%.*]], label [[NO_ALIAS3]]
; CHECK:       copy2:
; CHECK-NEXT:    [[TMP8:%.*]] = alloca <16 x double>, align 128
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <16 x double>* [[TMP8]] to i8*
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast <16 x double>* [[B]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 128 dereferenceable(128) [[TMP9]], i8* noundef nonnull align 8 dereferenceable(128) [[TMP10]], i64 128, i1 false)
; CHECK-NEXT:    br label [[NO_ALIAS3]]
; CHECK:       no_alias3:
; CHECK-NEXT:    [[TMP11:%.*]] = phi <16 x double>* [ [[B]], [[NO_ALIAS]] ], [ [[B]], [[ALIAS_CONT1]] ], [ [[TMP8]], [[COPY2]] ]
; CHECK-NEXT:    [[VEC_CAST:%.*]] = bitcast <16 x double>* [[TMP5]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST]], align 8
; CHECK-NEXT:    [[VEC_GEP:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST8:%.*]] = bitcast double* [[VEC_GEP]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD9:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST8]], align 8
; CHECK-NEXT:    [[VEC_CAST11:%.*]] = bitcast <16 x double>* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD12:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST11]], align 8
; CHECK-NEXT:    [[VEC_GEP13:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST14:%.*]] = bitcast double* [[VEC_GEP13]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD15:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST14]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <2 x double> [[COL_LOAD12]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP12:%.*]] = fmul contract <2 x double> [[COL_LOAD]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[SPLAT_SPLAT18:%.*]] = shufflevector <2 x double> [[COL_LOAD12]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP13:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD9]], <2 x double> [[SPLAT_SPLAT18]], <2 x double> [[TMP12]])
; CHECK-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <2 x double> [[COL_LOAD15]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP14:%.*]] = fmul contract <2 x double> [[COL_LOAD]], [[SPLAT_SPLAT21]]
; CHECK-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <2 x double> [[COL_LOAD15]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP15:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD9]], <2 x double> [[SPLAT_SPLAT24]], <2 x double> [[TMP14]])
; CHECK-NEXT:    [[TMP16:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 8
; CHECK-NEXT:    [[VEC_CAST26:%.*]] = bitcast double* [[TMP16]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD27:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST26]], align 8
; CHECK-NEXT:    [[VEC_GEP28:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 12
; CHECK-NEXT:    [[VEC_CAST29:%.*]] = bitcast double* [[VEC_GEP28]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD30:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST29]], align 8
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST32:%.*]] = bitcast double* [[TMP17]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD33:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST32]], align 8
; CHECK-NEXT:    [[VEC_GEP34:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST35:%.*]] = bitcast double* [[VEC_GEP34]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD36:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST35]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT40:%.*]] = shufflevector <2 x double> [[COL_LOAD33]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP18:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD27]], <2 x double> [[SPLAT_SPLAT40]], <2 x double> [[TMP13]])
; CHECK-NEXT:    [[SPLAT_SPLAT43:%.*]] = shufflevector <2 x double> [[COL_LOAD33]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP19:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD30]], <2 x double> [[SPLAT_SPLAT43]], <2 x double> [[TMP18]])
; CHECK-NEXT:    [[SPLAT_SPLAT47:%.*]] = shufflevector <2 x double> [[COL_LOAD36]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP20:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD27]], <2 x double> [[SPLAT_SPLAT47]], <2 x double> [[TMP15]])
; CHECK-NEXT:    [[SPLAT_SPLAT50:%.*]] = shufflevector <2 x double> [[COL_LOAD36]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP21:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD30]], <2 x double> [[SPLAT_SPLAT50]], <2 x double> [[TMP20]])
; CHECK-NEXT:    [[VEC_CAST52:%.*]] = bitcast <16 x double>* [[C]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP19]], <2 x double>* [[VEC_CAST52]], align 8
; CHECK-NEXT:    [[VEC_GEP53:%.*]] = getelementptr <16 x double>, <16 x double>* [[C]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST54:%.*]] = bitcast double* [[VEC_GEP53]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP21]], <2 x double>* [[VEC_CAST54]], align 8
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST56:%.*]] = bitcast double* [[TMP22]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD57:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST56]], align 8
; CHECK-NEXT:    [[VEC_GEP58:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST59:%.*]] = bitcast double* [[VEC_GEP58]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD60:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST59]], align 8
; CHECK-NEXT:    [[VEC_CAST62:%.*]] = bitcast <16 x double>* [[TMP11]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD63:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST62]], align 8
; CHECK-NEXT:    [[VEC_GEP64:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST65:%.*]] = bitcast double* [[VEC_GEP64]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD66:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST65]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT69:%.*]] = shufflevector <2 x double> [[COL_LOAD63]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP23:%.*]] = fmul contract <2 x double> [[COL_LOAD57]], [[SPLAT_SPLAT69]]
; CHECK-NEXT:    [[SPLAT_SPLAT72:%.*]] = shufflevector <2 x double> [[COL_LOAD63]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP24:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD60]], <2 x double> [[SPLAT_SPLAT72]], <2 x double> [[TMP23]])
; CHECK-NEXT:    [[SPLAT_SPLAT75:%.*]] = shufflevector <2 x double> [[COL_LOAD66]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP25:%.*]] = fmul contract <2 x double> [[COL_LOAD57]], [[SPLAT_SPLAT75]]
; CHECK-NEXT:    [[SPLAT_SPLAT78:%.*]] = shufflevector <2 x double> [[COL_LOAD66]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP26:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD60]], <2 x double> [[SPLAT_SPLAT78]], <2 x double> [[TMP25]])
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 10
; CHECK-NEXT:    [[VEC_CAST80:%.*]] = bitcast double* [[TMP27]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD81:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST80]], align 8
; CHECK-NEXT:    [[VEC_GEP82:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 14
; CHECK-NEXT:    [[VEC_CAST83:%.*]] = bitcast double* [[VEC_GEP82]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD84:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST83]], align 8
; CHECK-NEXT:    [[TMP28:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST86:%.*]] = bitcast double* [[TMP28]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD87:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST86]], align 8
; CHECK-NEXT:    [[VEC_GEP88:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST89:%.*]] = bitcast double* [[VEC_GEP88]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD90:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST89]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT94:%.*]] = shufflevector <2 x double> [[COL_LOAD87]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP29:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD81]], <2 x double> [[SPLAT_SPLAT94]], <2 x double> [[TMP24]])
; CHECK-NEXT:    [[SPLAT_SPLAT97:%.*]] = shufflevector <2 x double> [[COL_LOAD87]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP30:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD84]], <2 x double> [[SPLAT_SPLAT97]], <2 x double> [[TMP29]])
; CHECK-NEXT:    [[SPLAT_SPLAT101:%.*]] = shufflevector <2 x double> [[COL_LOAD90]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP31:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD81]], <2 x double> [[SPLAT_SPLAT101]], <2 x double> [[TMP26]])
; CHECK-NEXT:    [[SPLAT_SPLAT104:%.*]] = shufflevector <2 x double> [[COL_LOAD90]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP32:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD84]], <2 x double> [[SPLAT_SPLAT104]], <2 x double> [[TMP31]])
; CHECK-NEXT:    [[TMP33:%.*]] = getelementptr <16 x double>, <16 x double>* [[C]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST106:%.*]] = bitcast double* [[TMP33]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP30]], <2 x double>* [[VEC_CAST106]], align 8
; CHECK-NEXT:    [[VEC_GEP107:%.*]] = getelementptr <16 x double>, <16 x double>* [[C]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST108:%.*]] = bitcast double* [[VEC_GEP107]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP32]], <2 x double>* [[VEC_CAST108]], align 8
; CHECK-NEXT:    [[VEC_CAST110:%.*]] = bitcast <16 x double>* [[TMP5]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD111:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST110]], align 8
; CHECK-NEXT:    [[VEC_GEP112:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 4
; CHECK-NEXT:    [[VEC_CAST113:%.*]] = bitcast double* [[VEC_GEP112]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD114:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST113]], align 8
; CHECK-NEXT:    [[TMP34:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 8
; CHECK-NEXT:    [[VEC_CAST116:%.*]] = bitcast double* [[TMP34]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD117:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST116]], align 8
; CHECK-NEXT:    [[VEC_GEP118:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 12
; CHECK-NEXT:    [[VEC_CAST119:%.*]] = bitcast double* [[VEC_GEP118]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD120:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST119]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT123:%.*]] = shufflevector <2 x double> [[COL_LOAD117]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP35:%.*]] = fmul contract <2 x double> [[COL_LOAD111]], [[SPLAT_SPLAT123]]
; CHECK-NEXT:    [[SPLAT_SPLAT126:%.*]] = shufflevector <2 x double> [[COL_LOAD117]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP36:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD114]], <2 x double> [[SPLAT_SPLAT126]], <2 x double> [[TMP35]])
; CHECK-NEXT:    [[SPLAT_SPLAT129:%.*]] = shufflevector <2 x double> [[COL_LOAD120]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP37:%.*]] = fmul contract <2 x double> [[COL_LOAD111]], [[SPLAT_SPLAT129]]
; CHECK-NEXT:    [[SPLAT_SPLAT132:%.*]] = shufflevector <2 x double> [[COL_LOAD120]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP38:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD114]], <2 x double> [[SPLAT_SPLAT132]], <2 x double> [[TMP37]])
; CHECK-NEXT:    [[TMP39:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 8
; CHECK-NEXT:    [[VEC_CAST134:%.*]] = bitcast double* [[TMP39]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD135:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST134]], align 8
; CHECK-NEXT:    [[VEC_GEP136:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 12
; CHECK-NEXT:    [[VEC_CAST137:%.*]] = bitcast double* [[VEC_GEP136]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD138:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST137]], align 8
; CHECK-NEXT:    [[TMP40:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 10
; CHECK-NEXT:    [[VEC_CAST140:%.*]] = bitcast double* [[TMP40]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD141:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST140]], align 8
; CHECK-NEXT:    [[VEC_GEP142:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 14
; CHECK-NEXT:    [[VEC_CAST143:%.*]] = bitcast double* [[VEC_GEP142]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD144:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST143]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT148:%.*]] = shufflevector <2 x double> [[COL_LOAD141]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP41:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD135]], <2 x double> [[SPLAT_SPLAT148]], <2 x double> [[TMP36]])
; CHECK-NEXT:    [[SPLAT_SPLAT151:%.*]] = shufflevector <2 x double> [[COL_LOAD141]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP42:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD138]], <2 x double> [[SPLAT_SPLAT151]], <2 x double> [[TMP41]])
; CHECK-NEXT:    [[SPLAT_SPLAT155:%.*]] = shufflevector <2 x double> [[COL_LOAD144]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP43:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD135]], <2 x double> [[SPLAT_SPLAT155]], <2 x double> [[TMP38]])
; CHECK-NEXT:    [[SPLAT_SPLAT158:%.*]] = shufflevector <2 x double> [[COL_LOAD144]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP44:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD138]], <2 x double> [[SPLAT_SPLAT158]], <2 x double> [[TMP43]])
; CHECK-NEXT:    [[TMP45:%.*]] = getelementptr <16 x double>, <16 x double>* [[C]], i64 0, i64 8
; CHECK-NEXT:    [[VEC_CAST160:%.*]] = bitcast double* [[TMP45]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP42]], <2 x double>* [[VEC_CAST160]], align 8
; CHECK-NEXT:    [[VEC_GEP161:%.*]] = getelementptr <16 x double>, <16 x double>* [[C]], i64 0, i64 12
; CHECK-NEXT:    [[VEC_CAST162:%.*]] = bitcast double* [[VEC_GEP161]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP44]], <2 x double>* [[VEC_CAST162]], align 8
; CHECK-NEXT:    [[TMP46:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 2
; CHECK-NEXT:    [[VEC_CAST164:%.*]] = bitcast double* [[TMP46]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD165:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST164]], align 8
; CHECK-NEXT:    [[VEC_GEP166:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 6
; CHECK-NEXT:    [[VEC_CAST167:%.*]] = bitcast double* [[VEC_GEP166]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD168:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST167]], align 8
; CHECK-NEXT:    [[TMP47:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 8
; CHECK-NEXT:    [[VEC_CAST170:%.*]] = bitcast double* [[TMP47]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD171:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST170]], align 8
; CHECK-NEXT:    [[VEC_GEP172:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 12
; CHECK-NEXT:    [[VEC_CAST173:%.*]] = bitcast double* [[VEC_GEP172]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD174:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST173]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT177:%.*]] = shufflevector <2 x double> [[COL_LOAD171]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP48:%.*]] = fmul contract <2 x double> [[COL_LOAD165]], [[SPLAT_SPLAT177]]
; CHECK-NEXT:    [[SPLAT_SPLAT180:%.*]] = shufflevector <2 x double> [[COL_LOAD171]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP49:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD168]], <2 x double> [[SPLAT_SPLAT180]], <2 x double> [[TMP48]])
; CHECK-NEXT:    [[SPLAT_SPLAT183:%.*]] = shufflevector <2 x double> [[COL_LOAD174]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP50:%.*]] = fmul contract <2 x double> [[COL_LOAD165]], [[SPLAT_SPLAT183]]
; CHECK-NEXT:    [[SPLAT_SPLAT186:%.*]] = shufflevector <2 x double> [[COL_LOAD174]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP51:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD168]], <2 x double> [[SPLAT_SPLAT186]], <2 x double> [[TMP50]])
; CHECK-NEXT:    [[TMP52:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 10
; CHECK-NEXT:    [[VEC_CAST188:%.*]] = bitcast double* [[TMP52]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD189:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST188]], align 8
; CHECK-NEXT:    [[VEC_GEP190:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP5]], i64 0, i64 14
; CHECK-NEXT:    [[VEC_CAST191:%.*]] = bitcast double* [[VEC_GEP190]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD192:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST191]], align 8
; CHECK-NEXT:    [[TMP53:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 10
; CHECK-NEXT:    [[VEC_CAST194:%.*]] = bitcast double* [[TMP53]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD195:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST194]], align 8
; CHECK-NEXT:    [[VEC_GEP196:%.*]] = getelementptr <16 x double>, <16 x double>* [[TMP11]], i64 0, i64 14
; CHECK-NEXT:    [[VEC_CAST197:%.*]] = bitcast double* [[VEC_GEP196]] to <2 x double>*
; CHECK-NEXT:    [[COL_LOAD198:%.*]] = load <2 x double>, <2 x double>* [[VEC_CAST197]], align 8
; CHECK-NEXT:    [[SPLAT_SPLAT202:%.*]] = shufflevector <2 x double> [[COL_LOAD195]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP54:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD189]], <2 x double> [[SPLAT_SPLAT202]], <2 x double> [[TMP49]])
; CHECK-NEXT:    [[SPLAT_SPLAT205:%.*]] = shufflevector <2 x double> [[COL_LOAD195]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP55:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD192]], <2 x double> [[SPLAT_SPLAT205]], <2 x double> [[TMP54]])
; CHECK-NEXT:    [[SPLAT_SPLAT209:%.*]] = shufflevector <2 x double> [[COL_LOAD198]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP56:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD189]], <2 x double> [[SPLAT_SPLAT209]], <2 x double> [[TMP51]])
; CHECK-NEXT:    [[SPLAT_SPLAT212:%.*]] = shufflevector <2 x double> [[COL_LOAD198]], <2 x double> undef, <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP57:%.*]] = call contract <2 x double> @llvm.fmuladd.v2f64(<2 x double> [[COL_LOAD192]], <2 x double> [[SPLAT_SPLAT212]], <2 x double> [[TMP56]])
; CHECK-NEXT:    [[TMP58:%.*]] = getelementptr <16 x double>, <16 x double>* [[C]], i64 0, i64 10
; CHECK-NEXT:    [[VEC_CAST214:%.*]] = bitcast double* [[TMP58]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP55]], <2 x double>* [[VEC_CAST214]], align 8
; CHECK-NEXT:    [[VEC_GEP215:%.*]] = getelementptr <16 x double>, <16 x double>* [[C]], i64 0, i64 14
; CHECK-NEXT:    [[VEC_CAST216:%.*]] = bitcast double* [[VEC_GEP215]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP57]], <2 x double>* [[VEC_CAST216]], align 8
; CHECK-NEXT:    ret void
;


;; np.dot(a[0:2, 0:2], b[0:2, 0:2])


;; + np.dot(a[0:2, 2:4], b[2:4, 0:2])


;; -> c[0:2, 0:2]


;; np.dot(a[2:4, 0:2], b[0:2, 0:2])


;; + np.dot(a[2:4, 2:4], b[2:4, 0:2])


;; -> c[2:4, 0:2]


;; np.dot(a[0:2, 0:2], b[0:2, 2:4])


;; + np.dot(a[0:2, 2:4], b[2:4, 2:4])


;; -> c[0:2, 2:4]


;;  np.dot(a[2:4, 0:2], b[2:4, 0:2])


;; + np.dot(a[2:4, 2:4], b[2:4, 2:4])


;; ->  c[2:4, 2:4]

entry:
  %a = load <16 x double>, <16 x double>* %A, align 8
  %b = load <16 x double>, <16 x double>* %B, align 8

  %c = call <16 x double> @llvm.matrix.multiply(<16 x double> %a, <16 x double> %b, i32 4, i32 4, i32 4)

  store <16 x double> %c, <16 x double>* %C, align 8
  ret void
}

declare <16 x double> @llvm.matrix.multiply(<16 x double>, <16 x double>, i32, i32, i32)
