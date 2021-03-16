; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=x86_64 -lower-amx-intrinsics %s -S | FileCheck %s

define dso_local void @test_amx_load_non_O0(i16 signext %row, i16 signext %col, i8 *%ptr, i64 %stride, <256 x i32>* %vptr) {
; CHECK-LABEL: @test_amx_load_non_O0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i16 [[COL:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[STRIDE:%.*]], 2
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_ROWS_HEADER:%.*]]
; CHECK:       tileload.scalarize.rows.header:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_ROWS_IV:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[TILELOAD_SCALARIZE_ROWS_STEP:%.*]], [[TILELOAD_SCALARIZE_ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    [[VEC_PHI_ROW:%.*]] = phi <256 x i32> [ zeroinitializer, [[ENTRY]] ], [ [[TMP11:%.*]], [[TILELOAD_SCALARIZE_ROWS_LATCH]] ]
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_ROWS_BODY:%.*]]
; CHECK:       tileload.scalarize.rows.body:
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_COLS_HEADER:%.*]]
; CHECK:       tileload.scalarize.cols.header:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_COLS_IV:%.*]] = phi i16 [ 0, [[TILELOAD_SCALARIZE_ROWS_BODY]] ], [ [[TILELOAD_SCALARIZE_COLS_STEP:%.*]], [[TILELOAD_SCALARIZE_COLS_LATCH:%.*]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <256 x i32> [ [[VEC_PHI_ROW]], [[TILELOAD_SCALARIZE_ROWS_BODY]] ], [ [[TMP11]], [[TILELOAD_SCALARIZE_COLS_LATCH]] ]
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_COLS_BODY:%.*]]
; CHECK:       tileload.scalarize.cols.body:
; CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[TILELOAD_SCALARIZE_ROWS_IV]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[TILELOAD_SCALARIZE_COLS_IV]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[TMP4]], [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i8* [[PTR:%.*]] to i32*
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr i32, i32* [[TMP6]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = mul i16 [[TILELOAD_SCALARIZE_ROWS_IV]], 16
; CHECK-NEXT:    [[TMP9:%.*]] = add i16 [[TMP8]], [[TILELOAD_SCALARIZE_COLS_IV]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP11]] = insertelement <256 x i32> [[VEC_PHI]], i32 [[TMP10]], i16 [[TMP9]]
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_COLS_LATCH]]
; CHECK:       tileload.scalarize.cols.latch:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_COLS_STEP]] = add i16 [[TILELOAD_SCALARIZE_COLS_IV]], 1
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_COLS_COND:%.*]] = icmp ne i16 [[TILELOAD_SCALARIZE_COLS_STEP]], [[TMP0]]
; CHECK-NEXT:    br i1 [[TILELOAD_SCALARIZE_COLS_COND]], label [[TILELOAD_SCALARIZE_COLS_HEADER]], label [[TILELOAD_SCALARIZE_ROWS_LATCH]]
; CHECK:       tileload.scalarize.rows.latch:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_ROWS_STEP]] = add i16 [[TILELOAD_SCALARIZE_ROWS_IV]], 1
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_ROWS_COND:%.*]] = icmp ne i16 [[TILELOAD_SCALARIZE_ROWS_STEP]], [[ROW:%.*]]
; CHECK-NEXT:    br i1 [[TILELOAD_SCALARIZE_ROWS_COND]], label [[TILELOAD_SCALARIZE_ROWS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <256 x i32> [[TMP11]] to x86_amx
; CHECK-NEXT:    store <256 x i32> [[TMP11]], <256 x i32>* [[VPTR:%.*]], align 64
; CHECK-NEXT:    ret void
;
entry:
  %amx = call x86_amx @llvm.x86.tileloadd64.internal(i16 %row, i16 %col, i8* %ptr, i64 %stride)
  %vec = bitcast x86_amx %amx to <256 x i32>
  store <256 x i32> %vec, <256 x i32>* %vptr, align 64
  ret void
}

define dso_local void @test_amx_load(i16 signext %row, i16 signext %col, i8 *%ptr, i64 %stride, <256 x i32>* %vptr) #0 {
; CHECK-LABEL: @test_amx_load(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i16 [[COL:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[STRIDE:%.*]], 2
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_ROWS_HEADER:%.*]]
; CHECK:       tileload.scalarize.rows.header:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_ROWS_IV:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[TILELOAD_SCALARIZE_ROWS_STEP:%.*]], [[TILELOAD_SCALARIZE_ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    [[VEC_PHI_ROW:%.*]] = phi <256 x i32> [ zeroinitializer, [[ENTRY]] ], [ [[TMP11:%.*]], [[TILELOAD_SCALARIZE_ROWS_LATCH]] ]
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_ROWS_BODY:%.*]]
; CHECK:       tileload.scalarize.rows.body:
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_COLS_HEADER:%.*]]
; CHECK:       tileload.scalarize.cols.header:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_COLS_IV:%.*]] = phi i16 [ 0, [[TILELOAD_SCALARIZE_ROWS_BODY]] ], [ [[TILELOAD_SCALARIZE_COLS_STEP:%.*]], [[TILELOAD_SCALARIZE_COLS_LATCH:%.*]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <256 x i32> [ [[VEC_PHI_ROW]], [[TILELOAD_SCALARIZE_ROWS_BODY]] ], [ [[TMP11]], [[TILELOAD_SCALARIZE_COLS_LATCH]] ]
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_COLS_BODY:%.*]]
; CHECK:       tileload.scalarize.cols.body:
; CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[TILELOAD_SCALARIZE_ROWS_IV]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[TILELOAD_SCALARIZE_COLS_IV]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[TMP4]], [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i8* [[PTR:%.*]] to i32*
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr i32, i32* [[TMP6]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = mul i16 [[TILELOAD_SCALARIZE_ROWS_IV]], 16
; CHECK-NEXT:    [[TMP9:%.*]] = add i16 [[TMP8]], [[TILELOAD_SCALARIZE_COLS_IV]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP11]] = insertelement <256 x i32> [[VEC_PHI]], i32 [[TMP10]], i16 [[TMP9]]
; CHECK-NEXT:    br label [[TILELOAD_SCALARIZE_COLS_LATCH]]
; CHECK:       tileload.scalarize.cols.latch:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_COLS_STEP]] = add i16 [[TILELOAD_SCALARIZE_COLS_IV]], 1
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_COLS_COND:%.*]] = icmp ne i16 [[TILELOAD_SCALARIZE_COLS_STEP]], [[TMP0]]
; CHECK-NEXT:    br i1 [[TILELOAD_SCALARIZE_COLS_COND]], label [[TILELOAD_SCALARIZE_COLS_HEADER]], label [[TILELOAD_SCALARIZE_ROWS_LATCH]]
; CHECK:       tileload.scalarize.rows.latch:
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_ROWS_STEP]] = add i16 [[TILELOAD_SCALARIZE_ROWS_IV]], 1
; CHECK-NEXT:    [[TILELOAD_SCALARIZE_ROWS_COND:%.*]] = icmp ne i16 [[TILELOAD_SCALARIZE_ROWS_STEP]], [[ROW:%.*]]
; CHECK-NEXT:    br i1 [[TILELOAD_SCALARIZE_ROWS_COND]], label [[TILELOAD_SCALARIZE_ROWS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast <256 x i32> [[TMP11]] to x86_amx
; CHECK-NEXT:    store <256 x i32> [[TMP11]], <256 x i32>* [[VPTR:%.*]], align 64
; CHECK-NEXT:    ret void
;
entry:
  %amx = call x86_amx @llvm.x86.tileloadd64.internal(i16 %row, i16 %col, i8* %ptr, i64 %stride)
  %vec = bitcast x86_amx %amx to <256 x i32>
  store <256 x i32> %vec, <256 x i32>* %vptr, align 64
  ret void
}

define dso_local void @test_amx_dp(i16 signext %row, i16 signext %col, i16 signext %k, <256 x i32> %c, <256 x i32> %a, <256 x i32> %b, <256 x i32>* %vptr) #0 {
; CHECK-LABEL: @test_amx_dp(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_AMX:%.*]] = bitcast <256 x i32> [[A:%.*]] to x86_amx
; CHECK-NEXT:    [[B_AMX:%.*]] = bitcast <256 x i32> [[B:%.*]] to x86_amx
; CHECK-NEXT:    [[C_AMX:%.*]] = bitcast <256 x i32> [[C:%.*]] to x86_amx
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i16 [[COL:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i16 [[K:%.*]], 2
; CHECK-NEXT:    br label [[TILEDPBSSD_SCALARIZE_ROWS_HEADER:%.*]]
; CHECK:       tiledpbssd.scalarize.rows.header:
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_ROWS_IV:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[TILEDPBSSD_SCALARIZE_ROWS_STEP:%.*]], [[TILEDPBSSD_SCALARIZE_ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    [[VEC_C_PHI_ROW:%.*]] = phi <256 x i32> [ [[C]], [[ENTRY]] ], [ [[TMP18:%.*]], [[TILEDPBSSD_SCALARIZE_ROWS_LATCH]] ]
; CHECK-NEXT:    [[VEC_D_PHI_ROW:%.*]] = phi <256 x i32> [ zeroinitializer, [[ENTRY]] ], [ [[TMP20:%.*]], [[TILEDPBSSD_SCALARIZE_ROWS_LATCH]] ]
; CHECK-NEXT:    br label [[TILEDPBSSD_SCALARIZE_ROWS_BODY:%.*]]
; CHECK:       tiledpbssd.scalarize.rows.body:
; CHECK-NEXT:    br label [[TILEDPBSSD_SCALARIZE_COLS_HEADER:%.*]]
; CHECK:       tiledpbssd.scalarize.cols.header:
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_COLS_IV:%.*]] = phi i16 [ 0, [[TILEDPBSSD_SCALARIZE_ROWS_BODY]] ], [ [[TILEDPBSSD_SCALARIZE_COLS_STEP:%.*]], [[TILEDPBSSD_SCALARIZE_COLS_LATCH:%.*]] ]
; CHECK-NEXT:    [[VEC_C_PHI_COL:%.*]] = phi <256 x i32> [ [[VEC_C_PHI_ROW]], [[TILEDPBSSD_SCALARIZE_ROWS_BODY]] ], [ [[TMP18]], [[TILEDPBSSD_SCALARIZE_COLS_LATCH]] ]
; CHECK-NEXT:    [[VEC_D_PHI_COL:%.*]] = phi <256 x i32> [ [[VEC_D_PHI_ROW]], [[TILEDPBSSD_SCALARIZE_ROWS_BODY]] ], [ [[TMP20]], [[TILEDPBSSD_SCALARIZE_COLS_LATCH]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = mul i16 [[TILEDPBSSD_SCALARIZE_ROWS_IV]], 16
; CHECK-NEXT:    [[TMP3:%.*]] = add i16 [[TMP2]], [[TILEDPBSSD_SCALARIZE_COLS_IV]]
; CHECK-NEXT:    br label [[TILEDPBSSD_SCALARIZE_COLS_BODY:%.*]]
; CHECK:       tiledpbssd.scalarize.cols.body:
; CHECK-NEXT:    br label [[TILEDPBSSD_SCALARIZE_INNER_HEADER:%.*]]
; CHECK:       tiledpbssd.scalarize.inner.header:
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_INNER_IV:%.*]] = phi i16 [ 0, [[TILEDPBSSD_SCALARIZE_COLS_BODY]] ], [ [[TILEDPBSSD_SCALARIZE_INNER_STEP:%.*]], [[TILEDPBSSD_SCALARIZE_INNER_LATCH:%.*]] ]
; CHECK-NEXT:    [[VEC_C_INNER_PHI:%.*]] = phi <256 x i32> [ [[VEC_C_PHI_COL]], [[TILEDPBSSD_SCALARIZE_COLS_BODY]] ], [ [[TMP18]], [[TILEDPBSSD_SCALARIZE_INNER_LATCH]] ]
; CHECK-NEXT:    br label [[TILEDPBSSD_SCALARIZE_INNER_BODY:%.*]]
; CHECK:       tiledpbssd.scalarize.inner.body:
; CHECK-NEXT:    [[TMP4:%.*]] = mul i16 [[TILEDPBSSD_SCALARIZE_ROWS_IV]], 16
; CHECK-NEXT:    [[TMP5:%.*]] = add i16 [[TMP4]], [[TILEDPBSSD_SCALARIZE_INNER_IV]]
; CHECK-NEXT:    [[TMP6:%.*]] = mul i16 [[TILEDPBSSD_SCALARIZE_INNER_IV]], 16
; CHECK-NEXT:    [[TMP7:%.*]] = add i16 [[TMP6]], [[TILEDPBSSD_SCALARIZE_COLS_IV]]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <256 x i32> [[VEC_C_INNER_PHI]], i16 [[TMP3]]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <256 x i32> [[A]], i16 [[TMP5]]
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i32 [[TMP9]] to <4 x i8>
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <256 x i32> [[B]], i16 [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast i32 [[TMP11]] to <4 x i8>
; CHECK-NEXT:    [[TMP13:%.*]] = sext <4 x i8> [[TMP12]] to <4 x i32>
; CHECK-NEXT:    [[TMP14:%.*]] = sext <4 x i8> [[TMP10]] to <4 x i32>
; CHECK-NEXT:    [[TMP15:%.*]] = mul <4 x i32> [[TMP14]], [[TMP13]]
; CHECK-NEXT:    [[TMP16:%.*]] = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> [[TMP15]])
; CHECK-NEXT:    [[TMP17:%.*]] = add i32 [[TMP8]], [[TMP16]]
; CHECK-NEXT:    [[TMP18]] = insertelement <256 x i32> [[VEC_C_INNER_PHI]], i32 [[TMP17]], i16 [[TMP3]]
; CHECK-NEXT:    br label [[TILEDPBSSD_SCALARIZE_INNER_LATCH]]
; CHECK:       tiledpbssd.scalarize.inner.latch:
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_INNER_STEP]] = add i16 [[TILEDPBSSD_SCALARIZE_INNER_IV]], 1
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_INNER_COND:%.*]] = icmp ne i16 [[TILEDPBSSD_SCALARIZE_INNER_STEP]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TILEDPBSSD_SCALARIZE_INNER_COND]], label [[TILEDPBSSD_SCALARIZE_INNER_HEADER]], label [[TILEDPBSSD_SCALARIZE_COLS_LATCH]]
; CHECK:       tiledpbssd.scalarize.cols.latch:
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_COLS_STEP]] = add i16 [[TILEDPBSSD_SCALARIZE_COLS_IV]], 1
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_COLS_COND:%.*]] = icmp ne i16 [[TILEDPBSSD_SCALARIZE_COLS_STEP]], [[TMP0]]
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <256 x i32> [[TMP18]], i16 [[TMP3]]
; CHECK-NEXT:    [[TMP20]] = insertelement <256 x i32> [[VEC_D_PHI_COL]], i32 [[TMP19]], i16 [[TMP3]]
; CHECK-NEXT:    br i1 [[TILEDPBSSD_SCALARIZE_COLS_COND]], label [[TILEDPBSSD_SCALARIZE_COLS_HEADER]], label [[TILEDPBSSD_SCALARIZE_ROWS_LATCH]]
; CHECK:       tiledpbssd.scalarize.rows.latch:
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_ROWS_STEP]] = add i16 [[TILEDPBSSD_SCALARIZE_ROWS_IV]], 1
; CHECK-NEXT:    [[TILEDPBSSD_SCALARIZE_ROWS_COND:%.*]] = icmp ne i16 [[TILEDPBSSD_SCALARIZE_ROWS_STEP]], [[ROW:%.*]]
; CHECK-NEXT:    br i1 [[TILEDPBSSD_SCALARIZE_ROWS_COND]], label [[TILEDPBSSD_SCALARIZE_ROWS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    [[TMP21:%.*]] = bitcast <256 x i32> [[TMP20]] to x86_amx
; CHECK-NEXT:    store <256 x i32> [[TMP20]], <256 x i32>* [[VPTR:%.*]], align 64
; CHECK-NEXT:    ret void
;
entry:
  %a.amx = bitcast <256 x i32> %a to x86_amx
  %b.amx = bitcast <256 x i32> %b to x86_amx
  %c.amx = bitcast <256 x i32> %c to x86_amx
  %acc = call x86_amx @llvm.x86.tdpbssd.internal(i16 %row, i16 %col, i16 %k, x86_amx %c.amx, x86_amx %a.amx, x86_amx %b.amx)
  %vec = bitcast x86_amx %acc to <256 x i32>
  store <256 x i32> %vec, <256 x i32>* %vptr, align 64
  ret void
}

define dso_local void @test_amx_store(i16 signext %row, i16 signext %col, i8 *%ptr, i64 %stride, <256 x i32>* %vptr, <256 x i32> %vec) #0 {
; CHECK-LABEL: @test_amx_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AMX:%.*]] = bitcast <256 x i32> [[VEC:%.*]] to x86_amx
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i16 [[COL:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[STRIDE:%.*]], 2
; CHECK-NEXT:    br label [[TILESTORE_SCALARIZE_ROWS_HEADER:%.*]]
; CHECK:       tilestore.scalarize.rows.header:
; CHECK-NEXT:    [[TILESTORE_SCALARIZE_ROWS_IV:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[TILESTORE_SCALARIZE_ROWS_STEP:%.*]], [[TILESTORE_SCALARIZE_ROWS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[TILESTORE_SCALARIZE_ROWS_BODY:%.*]]
; CHECK:       tilestore.scalarize.rows.body:
; CHECK-NEXT:    br label [[TILESTORE_SCALARIZE_COLS_HEADER:%.*]]
; CHECK:       tilestore.scalarize.cols.header:
; CHECK-NEXT:    [[TILESTORE_SCALARIZE_COLS_IV:%.*]] = phi i16 [ 0, [[TILESTORE_SCALARIZE_ROWS_BODY]] ], [ [[TILESTORE_SCALARIZE_COLS_STEP:%.*]], [[TILESTORE_SCALARIZE_COLS_LATCH:%.*]] ]
; CHECK-NEXT:    br label [[TILESTORE_SCALARIZE_COLS_BODY:%.*]]
; CHECK:       tilestore.scalarize.cols.body:
; CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[TILESTORE_SCALARIZE_ROWS_IV]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[TILESTORE_SCALARIZE_COLS_IV]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[TMP4]], [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i8* [[PTR:%.*]] to i32*
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr i32, i32* [[TMP6]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = mul i16 [[TILESTORE_SCALARIZE_ROWS_IV]], 16
; CHECK-NEXT:    [[TMP9:%.*]] = add i16 [[TMP8]], [[TILESTORE_SCALARIZE_COLS_IV]]
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <256 x i32> [[VEC]], i16 [[TMP9]]
; CHECK-NEXT:    store i32 [[TMP10]], i32* [[TMP7]], align 4
; CHECK-NEXT:    br label [[TILESTORE_SCALARIZE_COLS_LATCH]]
; CHECK:       tilestore.scalarize.cols.latch:
; CHECK-NEXT:    [[TILESTORE_SCALARIZE_COLS_STEP]] = add i16 [[TILESTORE_SCALARIZE_COLS_IV]], 1
; CHECK-NEXT:    [[TILESTORE_SCALARIZE_COLS_COND:%.*]] = icmp ne i16 [[TILESTORE_SCALARIZE_COLS_STEP]], [[TMP0]]
; CHECK-NEXT:    br i1 [[TILESTORE_SCALARIZE_COLS_COND]], label [[TILESTORE_SCALARIZE_COLS_HEADER]], label [[TILESTORE_SCALARIZE_ROWS_LATCH]]
; CHECK:       tilestore.scalarize.rows.latch:
; CHECK-NEXT:    [[TILESTORE_SCALARIZE_ROWS_STEP]] = add i16 [[TILESTORE_SCALARIZE_ROWS_IV]], 1
; CHECK-NEXT:    [[TILESTORE_SCALARIZE_ROWS_COND:%.*]] = icmp ne i16 [[TILESTORE_SCALARIZE_ROWS_STEP]], [[ROW:%.*]]
; CHECK-NEXT:    br i1 [[TILESTORE_SCALARIZE_ROWS_COND]], label [[TILESTORE_SCALARIZE_ROWS_HEADER]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    ret void
;
entry:
  %amx = bitcast <256 x i32> %vec to x86_amx
  call void @llvm.x86.tilestored64.internal(i16 %row, i16 %col, i8* %ptr, i64 %stride, x86_amx %amx)
  ret void
}

define dso_local void @test_amx_zero(i16 signext %row, i16 signext %col, <256 x i32>* %vptr) #0 {
; CHECK-LABEL: @test_amx_zero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store <256 x i32> zeroinitializer, <256 x i32>* [[VPTR:%.*]], align 64
; CHECK-NEXT:    ret void
;
entry:
  %amx = call x86_amx @llvm.x86.tilezero.internal(i16 %row, i16 %col)
  %vec = bitcast x86_amx %amx to <256 x i32>
  store <256 x i32> %vec, <256 x i32>* %vptr, align 64
  ret void
}

declare x86_amx @llvm.x86.tilezero.internal(i16, i16)
declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, i8*, i64)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare void @llvm.x86.tilestored64.internal(i16, i16, i8*, i64, x86_amx)

attributes #0 = { noinline nounwind optnone }
