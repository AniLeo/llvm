; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt --codegen-opt-level=2 -mtriple=x86_64 -lower-amx-type %s -S | FileCheck %s

%struct.__tile_str = type { i16, i16, <256 x i32> }

@buf = dso_local global [1024 x i8] zeroinitializer, align 64
@buf2 = dso_local global [1024 x i8] zeroinitializer, align 64

; test bitcast x86_amx to <256 x i32>
define dso_local void @test_user_empty(i16 %m, i16 %n, i8 *%buf, i64 %s) {
; CHECK-LABEL: @test_user_empty(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[N:%.*]], i8* [[BUF:%.*]], i64 [[S:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  %t1 = call x86_amx @llvm.x86.tileloadd64.internal(i16 %m, i16 %n, i8* %buf, i64 %s)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  ret void
}

; test bitcast <256 x i32> to x86_amx
define dso_local void @test_user_empty2(<256 x i32> %in) {
; CHECK-LABEL: @test_user_empty2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  %t = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %in)
  ret void
}

define dso_local <256 x i32> @test_amx_load_bitcast_v256i32(<256 x i32>* %in, i16 %m, i16 %n, i8 *%buf, i64 %s) {
; CHECK-LABEL: @test_amx_load_bitcast_v256i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[T1:%.*]] = load <256 x i32>, <256 x i32>* [[IN:%.*]], align 64
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <256 x i32>* [[TMP0]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T1]], <256 x i32>* [[TMP0]], align 1024
; CHECK-NEXT:    [[TMP2:%.*]] = sext i16 [[N:%.*]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[N]], i8* [[TMP1]], i64 [[TMP2]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], i8* [[BUF:%.*]], i64 [[S:%.*]], x86_amx [[TMP3]])
; CHECK-NEXT:    ret <256 x i32> [[T1]]
;
entry:
  %t1 = load <256 x i32>, <256 x i32>* %in, align 64
  %t2 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t1)
  call void @llvm.x86.tilestored64.internal(i16 %m, i16 %n, i8* %buf, i64 %s, x86_amx %t2)
  ret <256 x i32> %t1
}

define dso_local <225 x i32> @test_amx_load_bitcast_v225i32(<225 x i32>* %in, i16 %m, i16 %n, i8 *%buf, i64 %s) {
; CHECK-LABEL: @test_amx_load_bitcast_v225i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <225 x i32>, align 64
; CHECK-NEXT:    [[T1:%.*]] = load <225 x i32>, <225 x i32>* [[IN:%.*]], align 64
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <225 x i32>* [[TMP0]] to i8*
; CHECK-NEXT:    store <225 x i32> [[T1]], <225 x i32>* [[TMP0]], align 1024
; CHECK-NEXT:    [[TMP2:%.*]] = sext i16 [[N:%.*]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[N]], i8* [[TMP1]], i64 [[TMP2]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], i8* [[BUF:%.*]], i64 [[S:%.*]], x86_amx [[TMP3]])
; CHECK-NEXT:    ret <225 x i32> [[T1]]
;
entry:
  %t1 = load <225 x i32>, <225 x i32>* %in, align 64
  %t2 = call x86_amx @llvm.x86.cast.vector.to.tile.v225i32(<225 x i32> %t1)
  call void @llvm.x86.tilestored64.internal(i16 %m, i16 %n, i8* %buf, i64 %s, x86_amx %t2)
  ret <225 x i32> %t1
}

define dso_local <256 x i32> @test_amx_bitcast_store(<256 x i32>* %out, i16 %m, i16 %n, i8 *%buf, i64 %s) {
; CHECK-LABEL: @test_amx_bitcast_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[M]], i8* [[BUF:%.*]], i64 [[S:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <256 x i32>* [[TMP0]] to i8*
; CHECK-NEXT:    [[TMP2:%.*]] = sext i16 [[M]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[M]], i8* [[TMP1]], i64 [[TMP2]], x86_amx [[T1]])
; CHECK-NEXT:    [[TMP3:%.*]] = load <256 x i32>, <256 x i32>* [[TMP0]], align 1024
; CHECK-NEXT:    store <256 x i32> [[TMP3]], <256 x i32>* [[OUT:%.*]], align 1024
; CHECK-NEXT:    ret <256 x i32> [[TMP3]]
;
entry:
  %t1 = call x86_amx @llvm.x86.tileloadd64.internal(i16 %m, i16 %m, i8* %buf, i64 %s)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  store <256 x i32> %t2, <256 x i32>* %out
  ret <256 x i32> %t2
}

define dso_local void @test_src_add(<256 x i32> %x, <256 x i32> %y, i16 %r, i16 %c, i8* %buf, i64 %s) {
; CHECK-LABEL: @test_src_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[ADD:%.*]] = add <256 x i32> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <256 x i32>* [[TMP0]] to i8*
; CHECK-NEXT:    store <256 x i32> [[ADD]], <256 x i32>* [[TMP0]], align 1024
; CHECK-NEXT:    [[TMP2:%.*]] = sext i16 [[C:%.*]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[R:%.*]], i16 [[C]], i8* [[TMP1]], i64 [[TMP2]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[R]], i16 [[C]], i8* [[BUF:%.*]], i64 [[S:%.*]], x86_amx [[TMP3]])
; CHECK-NEXT:    ret void
;
entry:
  %add = add <256 x i32> %y, %x
  %t = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %add)
  call void @llvm.x86.tilestored64.internal(i16 %r, i16 %c, i8* %buf, i64 %s, x86_amx %t)
  ret void
}

define dso_local void @test_src_add2(<256 x i32> %x, i16 %r, i16 %c, i8* %buf, i64 %s) {
; CHECK-LABEL: @test_src_add2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[R:%.*]], i16 [[C:%.*]], i8* [[BUF:%.*]], i64 [[S:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <256 x i32>* [[TMP0]] to i8*
; CHECK-NEXT:    [[TMP2:%.*]] = sext i16 [[C]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[R]], i16 [[C]], i8* [[TMP1]], i64 [[TMP2]], x86_amx [[T1]])
; CHECK-NEXT:    [[TMP3:%.*]] = load <256 x i32>, <256 x i32>* [[TMP0]], align 1024
; CHECK-NEXT:    [[ADD:%.*]] = add <256 x i32> [[TMP3]], [[X:%.*]]
; CHECK-NEXT:    ret void
;
entry:
  %t1 = call x86_amx @llvm.x86.tileloadd64.internal(i16 %r, i16 %c, i8* %buf, i64 %s)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  %add = add <256 x i32> %t2, %x
  ret void
}

define dso_local void @__tile_loadd(%struct.__tile_str* nocapture %0, i8* %1, i64 %2) local_unnamed_addr {
; CHECK-LABEL: @__tile_loadd(
; CHECK-NEXT:    [[TMP4:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR:%.*]], %struct.__tile_str* [[TMP0:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = load i16, i16* [[TMP5]], align 64
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP0]], i64 0, i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i16, i16* [[TMP7]], align 2
; CHECK-NEXT:    [[TMP9:%.*]] = shl i64 [[TMP2:%.*]], 32
; CHECK-NEXT:    [[TMP10:%.*]] = ashr exact i64 [[TMP9]], 32
; CHECK-NEXT:    [[TMP11:%.*]] = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP6]], i16 [[TMP8]], i8* [[TMP1:%.*]], i64 [[TMP10]])
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <256 x i32>* [[TMP4]] to i8*
; CHECK-NEXT:    [[TMP13:%.*]] = sext i16 [[TMP8]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[TMP6]], i16 [[TMP8]], i8* [[TMP12]], i64 [[TMP13]], x86_amx [[TMP11]])
; CHECK-NEXT:    [[TMP14:%.*]] = load <256 x i32>, <256 x i32>* [[TMP4]], align 1024
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP0]], i64 0, i32 2
; CHECK-NEXT:    store <256 x i32> [[TMP14]], <256 x i32>* [[TMP15]], align 64
; CHECK-NEXT:    ret void
;
  %4 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %0, i64 0, i32 0
  %5 = load i16, i16* %4, align 64
  %6 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %0, i64 0, i32 1
  %7 = load i16, i16* %6, align 2
  %8 = shl i64 %2, 32
  %9 = ashr exact i64 %8, 32
  %10 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 %5, i16 %7, i8* %1, i64 %9)
  %11 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %10)
  %12 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %0, i64 0, i32 2
  store <256 x i32> %11, <256 x i32>* %12, align 64
  ret void
}

define dso_local void @__tile_dpbssd(%struct.__tile_str* nocapture %0, %struct.__tile_str* nocapture readonly byval(%struct.__tile_str) align 64 %1, %struct.__tile_str* nocapture readonly byval(%struct.__tile_str) align 64 %2) local_unnamed_addr {
; CHECK-LABEL: @__tile_dpbssd(
; CHECK-NEXT:    [[TMP4:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP5:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP6:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP7:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR:%.*]], %struct.__tile_str* [[TMP1:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = load i16, i16* [[TMP8]], align 64
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP2:%.*]], i64 0, i32 1
; CHECK-NEXT:    [[TMP11:%.*]] = load i16, i16* [[TMP10]], align 2
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP1]], i64 0, i32 1
; CHECK-NEXT:    [[TMP13:%.*]] = load i16, i16* [[TMP12]], align 2
; CHECK-NEXT:    [[TMP14:%.*]] = udiv i16 [[TMP13]], 4
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP0:%.*]], i64 0, i32 2
; CHECK-NEXT:    [[TMP16:%.*]] = load <256 x i32>, <256 x i32>* [[TMP15]], align 64
; CHECK-NEXT:    [[TMP17:%.*]] = bitcast <256 x i32>* [[TMP7]] to i8*
; CHECK-NEXT:    store <256 x i32> [[TMP16]], <256 x i32>* [[TMP7]], align 1024
; CHECK-NEXT:    [[TMP18:%.*]] = sext i16 [[TMP11]] to i64
; CHECK-NEXT:    [[TMP19:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP9]], i16 [[TMP11]], i8* [[TMP17]], i64 [[TMP18]])
; CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP1]], i64 0, i32 2
; CHECK-NEXT:    [[TMP21:%.*]] = load <256 x i32>, <256 x i32>* [[TMP20]], align 64
; CHECK-NEXT:    [[TMP22:%.*]] = bitcast <256 x i32>* [[TMP6]] to i8*
; CHECK-NEXT:    store <256 x i32> [[TMP21]], <256 x i32>* [[TMP6]], align 1024
; CHECK-NEXT:    [[TMP23:%.*]] = sext i16 [[TMP13]] to i64
; CHECK-NEXT:    [[TMP24:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP9]], i16 [[TMP13]], i8* [[TMP22]], i64 [[TMP23]])
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP2]], i64 0, i32 2
; CHECK-NEXT:    [[TMP26:%.*]] = load <256 x i32>, <256 x i32>* [[TMP25]], align 64
; CHECK-NEXT:    [[TMP27:%.*]] = bitcast <256 x i32>* [[TMP5]] to i8*
; CHECK-NEXT:    store <256 x i32> [[TMP26]], <256 x i32>* [[TMP5]], align 1024
; CHECK-NEXT:    [[TMP28:%.*]] = sext i16 [[TMP11]] to i64
; CHECK-NEXT:    [[TMP29:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP14]], i16 [[TMP11]], i8* [[TMP27]], i64 [[TMP28]])
; CHECK-NEXT:    [[TMP30:%.*]] = tail call x86_amx @llvm.x86.tdpbssd.internal(i16 [[TMP9]], i16 [[TMP11]], i16 [[TMP13]], x86_amx [[TMP19]], x86_amx [[TMP24]], x86_amx [[TMP29]])
; CHECK-NEXT:    [[TMP31:%.*]] = bitcast <256 x i32>* [[TMP4]] to i8*
; CHECK-NEXT:    [[TMP32:%.*]] = sext i16 [[TMP11]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[TMP9]], i16 [[TMP11]], i8* [[TMP31]], i64 [[TMP32]], x86_amx [[TMP30]])
; CHECK-NEXT:    [[TMP33:%.*]] = load <256 x i32>, <256 x i32>* [[TMP4]], align 1024
; CHECK-NEXT:    store <256 x i32> [[TMP33]], <256 x i32>* [[TMP15]], align 64
; CHECK-NEXT:    ret void
;
  %4 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %1, i64 0, i32 0
  %5 = load i16, i16* %4, align 64
  %6 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %2, i64 0, i32 1
  %7 = load i16, i16* %6, align 2
  %8 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %1, i64 0, i32 1
  %9 = load i16, i16* %8, align 2
  %10 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %0, i64 0, i32 2
  %11 = load <256 x i32>, <256 x i32>* %10, align 64
  %12 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %11)
  %13 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %1, i64 0, i32 2
  %14 = load <256 x i32>, <256 x i32>* %13, align 64
  %15 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %14)
  %16 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %2, i64 0, i32 2
  %17 = load <256 x i32>, <256 x i32>* %16, align 64
  %18 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %17)
  %19 = tail call x86_amx @llvm.x86.tdpbssd.internal(i16 %5, i16 %7, i16 %9, x86_amx %12, x86_amx %15, x86_amx %18)
  %20 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %19)
  store <256 x i32> %20, <256 x i32>* %10, align 64
  ret void
}

define dso_local void @__tile_dpbsud(i16 %m, i16 %n, i16 %k, <256 x i32>* %pc, <256 x i32>* %pa, <256 x i32>* %pb) {
; CHECK-LABEL: @__tile_dpbsud(
; CHECK-NEXT:    [[TMP1:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP3:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP4:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP5:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[T0:%.*]] = load <256 x i32>, <256 x i32>* [[PA:%.*]], align 64
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <256 x i32>* [[TMP4]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T0]], <256 x i32>* [[TMP4]], align 1024
; CHECK-NEXT:    [[TMP7:%.*]] = sext i16 [[K]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], i8* [[TMP6]], i64 [[TMP7]])
; CHECK-NEXT:    [[T2:%.*]] = load <256 x i32>, <256 x i32>* [[PB:%.*]], align 64
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <256 x i32>* [[TMP3]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T2]], <256 x i32>* [[TMP3]], align 1024
; CHECK-NEXT:    [[TMP10:%.*]] = sext i16 [[N:%.*]] to i64
; CHECK-NEXT:    [[TMP11:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP5]], i16 [[N]], i8* [[TMP9]], i64 [[TMP10]])
; CHECK-NEXT:    [[T4:%.*]] = load <256 x i32>, <256 x i32>* [[PC:%.*]], align 64
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <256 x i32>* [[TMP2]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T4]], <256 x i32>* [[TMP2]], align 1024
; CHECK-NEXT:    [[TMP13:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    [[TMP14:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], i8* [[TMP12]], i64 [[TMP13]])
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbsud.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP14]], x86_amx [[TMP8]], x86_amx [[TMP11]])
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast <256 x i32>* [[TMP1]] to i8*
; CHECK-NEXT:    [[TMP16:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], i8* [[TMP15]], i64 [[TMP16]], x86_amx [[T6]])
; CHECK-NEXT:    [[TMP17:%.*]] = load <256 x i32>, <256 x i32>* [[TMP1]], align 1024
; CHECK-NEXT:    store <256 x i32> [[TMP17]], <256 x i32>* [[PC]], align 64
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, <256 x i32>* %pa, align 64
  %t1 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t0)
  %t2 = load <256 x i32>, <256 x i32>* %pb, align 64
  %t3 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t2)
  %t4 = load <256 x i32>, <256 x i32>* %pc, align 64
  %t5 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t4)
  %t6 = tail call x86_amx @llvm.x86.tdpbsud.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t6)
  store <256 x i32> %t7, <256 x i32>* %pc, align 64
  ret void
}

define dso_local void @__tile_dpbusd(i16 %m, i16 %n, i16 %k, <256 x i32>* %pc, <256 x i32>* %pa, <256 x i32>* %pb) {
; CHECK-LABEL: @__tile_dpbusd(
; CHECK-NEXT:    [[TMP1:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP3:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP4:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP5:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[T0:%.*]] = load <256 x i32>, <256 x i32>* [[PA:%.*]], align 64
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <256 x i32>* [[TMP4]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T0]], <256 x i32>* [[TMP4]], align 1024
; CHECK-NEXT:    [[TMP7:%.*]] = sext i16 [[K]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], i8* [[TMP6]], i64 [[TMP7]])
; CHECK-NEXT:    [[T2:%.*]] = load <256 x i32>, <256 x i32>* [[PB:%.*]], align 64
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <256 x i32>* [[TMP3]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T2]], <256 x i32>* [[TMP3]], align 1024
; CHECK-NEXT:    [[TMP10:%.*]] = sext i16 [[N:%.*]] to i64
; CHECK-NEXT:    [[TMP11:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP5]], i16 [[N]], i8* [[TMP9]], i64 [[TMP10]])
; CHECK-NEXT:    [[T4:%.*]] = load <256 x i32>, <256 x i32>* [[PC:%.*]], align 64
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <256 x i32>* [[TMP2]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T4]], <256 x i32>* [[TMP2]], align 1024
; CHECK-NEXT:    [[TMP13:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    [[TMP14:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], i8* [[TMP12]], i64 [[TMP13]])
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbusd.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP14]], x86_amx [[TMP8]], x86_amx [[TMP11]])
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast <256 x i32>* [[TMP1]] to i8*
; CHECK-NEXT:    [[TMP16:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], i8* [[TMP15]], i64 [[TMP16]], x86_amx [[T6]])
; CHECK-NEXT:    [[TMP17:%.*]] = load <256 x i32>, <256 x i32>* [[TMP1]], align 1024
; CHECK-NEXT:    store <256 x i32> [[TMP17]], <256 x i32>* [[PC]], align 64
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, <256 x i32>* %pa, align 64
  %t1 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t0)
  %t2 = load <256 x i32>, <256 x i32>* %pb, align 64
  %t3 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t2)
  %t4 = load <256 x i32>, <256 x i32>* %pc, align 64
  %t5 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t4)
  %t6 = tail call x86_amx @llvm.x86.tdpbusd.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t6)
  store <256 x i32> %t7, <256 x i32>* %pc, align 64
  ret void
}

define dso_local void @__tile_dpbuud(i16 %m, i16 %n, i16 %k, <256 x i32>* %pc, <256 x i32>* %pa, <256 x i32>* %pb) {
; CHECK-LABEL: @__tile_dpbuud(
; CHECK-NEXT:    [[TMP1:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP3:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP4:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP5:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[T0:%.*]] = load <256 x i32>, <256 x i32>* [[PA:%.*]], align 64
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <256 x i32>* [[TMP4]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T0]], <256 x i32>* [[TMP4]], align 1024
; CHECK-NEXT:    [[TMP7:%.*]] = sext i16 [[K]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], i8* [[TMP6]], i64 [[TMP7]])
; CHECK-NEXT:    [[T2:%.*]] = load <256 x i32>, <256 x i32>* [[PB:%.*]], align 64
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <256 x i32>* [[TMP3]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T2]], <256 x i32>* [[TMP3]], align 1024
; CHECK-NEXT:    [[TMP10:%.*]] = sext i16 [[N:%.*]] to i64
; CHECK-NEXT:    [[TMP11:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP5]], i16 [[N]], i8* [[TMP9]], i64 [[TMP10]])
; CHECK-NEXT:    [[T4:%.*]] = load <256 x i32>, <256 x i32>* [[PC:%.*]], align 64
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <256 x i32>* [[TMP2]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T4]], <256 x i32>* [[TMP2]], align 1024
; CHECK-NEXT:    [[TMP13:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    [[TMP14:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], i8* [[TMP12]], i64 [[TMP13]])
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbuud.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP14]], x86_amx [[TMP8]], x86_amx [[TMP11]])
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast <256 x i32>* [[TMP1]] to i8*
; CHECK-NEXT:    [[TMP16:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], i8* [[TMP15]], i64 [[TMP16]], x86_amx [[T6]])
; CHECK-NEXT:    [[TMP17:%.*]] = load <256 x i32>, <256 x i32>* [[TMP1]], align 1024
; CHECK-NEXT:    store <256 x i32> [[TMP17]], <256 x i32>* [[PC]], align 64
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, <256 x i32>* %pa, align 64
  %t1 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t0)
  %t2 = load <256 x i32>, <256 x i32>* %pb, align 64
  %t3 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t2)
  %t4 = load <256 x i32>, <256 x i32>* %pc, align 64
  %t5 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t4)
  %t6 = tail call x86_amx @llvm.x86.tdpbuud.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t6)
  store <256 x i32> %t7, <256 x i32>* %pc, align 64
  ret void
}

define dso_local void @__tile_dpbf16ps(i16 %m, i16 %n, i16 %k, <256 x i32>* %pc, <256 x i32>* %pa, <256 x i32>* %pb) {
; CHECK-LABEL: @__tile_dpbf16ps(
; CHECK-NEXT:    [[TMP1:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP3:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP4:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP5:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[T0:%.*]] = load <256 x i32>, <256 x i32>* [[PA:%.*]], align 64
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast <256 x i32>* [[TMP4]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T0]], <256 x i32>* [[TMP4]], align 1024
; CHECK-NEXT:    [[TMP7:%.*]] = sext i16 [[K]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], i8* [[TMP6]], i64 [[TMP7]])
; CHECK-NEXT:    [[T2:%.*]] = load <256 x i32>, <256 x i32>* [[PB:%.*]], align 64
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast <256 x i32>* [[TMP3]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T2]], <256 x i32>* [[TMP3]], align 1024
; CHECK-NEXT:    [[TMP10:%.*]] = sext i16 [[N:%.*]] to i64
; CHECK-NEXT:    [[TMP11:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP5]], i16 [[N]], i8* [[TMP9]], i64 [[TMP10]])
; CHECK-NEXT:    [[T4:%.*]] = load <256 x i32>, <256 x i32>* [[PC:%.*]], align 64
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <256 x i32>* [[TMP2]] to i8*
; CHECK-NEXT:    store <256 x i32> [[T4]], <256 x i32>* [[TMP2]], align 1024
; CHECK-NEXT:    [[TMP13:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    [[TMP14:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], i8* [[TMP12]], i64 [[TMP13]])
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbf16ps.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP14]], x86_amx [[TMP8]], x86_amx [[TMP11]])
; CHECK-NEXT:    [[TMP15:%.*]] = bitcast <256 x i32>* [[TMP1]] to i8*
; CHECK-NEXT:    [[TMP16:%.*]] = sext i16 [[N]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], i8* [[TMP15]], i64 [[TMP16]], x86_amx [[T6]])
; CHECK-NEXT:    [[TMP17:%.*]] = load <256 x i32>, <256 x i32>* [[TMP1]], align 1024
; CHECK-NEXT:    store <256 x i32> [[TMP17]], <256 x i32>* [[PC]], align 64
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, <256 x i32>* %pa, align 64
  %t1 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t0)
  %t2 = load <256 x i32>, <256 x i32>* %pb, align 64
  %t3 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t2)
  %t4 = load <256 x i32>, <256 x i32>* %pc, align 64
  %t5 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t4)
  %t6 = tail call x86_amx @llvm.x86.tdpbf16ps.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t6)
  store <256 x i32> %t7, <256 x i32>* %pc, align 64
  ret void
}

define dso_local void @__tile_stored(i8* %0, i64 %1, %struct.__tile_str* nocapture readonly byval(%struct.__tile_str) align 64 %2) local_unnamed_addr {
; CHECK-LABEL: @__tile_stored(
; CHECK-NEXT:    [[TMP4:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR:%.*]], %struct.__tile_str* [[TMP2:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = load i16, i16* [[TMP5]], align 64
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP2]], i64 0, i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i16, i16* [[TMP7]], align 2
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], %struct.__tile_str* [[TMP2]], i64 0, i32 2
; CHECK-NEXT:    [[TMP10:%.*]] = load <256 x i32>, <256 x i32>* [[TMP9]], align 64
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast <256 x i32>* [[TMP4]] to i8*
; CHECK-NEXT:    store <256 x i32> [[TMP10]], <256 x i32>* [[TMP4]], align 1024
; CHECK-NEXT:    [[TMP12:%.*]] = sext i16 [[TMP8]] to i64
; CHECK-NEXT:    [[TMP13:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP6]], i16 [[TMP8]], i8* [[TMP11]], i64 [[TMP12]])
; CHECK-NEXT:    [[TMP14:%.*]] = shl i64 [[TMP1:%.*]], 32
; CHECK-NEXT:    [[TMP15:%.*]] = ashr exact i64 [[TMP14]], 32
; CHECK-NEXT:    tail call void @llvm.x86.tilestored64.internal(i16 [[TMP6]], i16 [[TMP8]], i8* [[TMP0:%.*]], i64 [[TMP15]], x86_amx [[TMP13]])
; CHECK-NEXT:    ret void
;
  %4 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %2, i64 0, i32 0
  %5 = load i16, i16* %4, align 64
  %6 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %2, i64 0, i32 1
  %7 = load i16, i16* %6, align 2
  %8 = getelementptr inbounds %struct.__tile_str, %struct.__tile_str* %2, i64 0, i32 2
  %9 = load <256 x i32>, <256 x i32>* %8, align 64
  %10 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %9)
  %11 = shl i64 %1, 32
  %12 = ashr exact i64 %11, 32
  tail call void @llvm.x86.tilestored64.internal(i16 %5, i16 %7, i8* %0, i64 %12, x86_amx %10)
  ret void
}

declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, i8*, i64)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbsud.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbusd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbuud.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbf16ps.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare void @llvm.x86.tilestored64.internal(i16, i16, i8*, i64, x86_amx)

declare x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32>)
declare x86_amx @llvm.x86.cast.vector.to.tile.v225i32(<225 x i32>)
declare <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx)
declare <225 x i32> @llvm.x86.cast.tile.to.vector.v225i32(x86_amx)
