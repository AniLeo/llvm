; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics -S < %s | FileCheck  %s

; Make sure we correctly lower in the presence of getelementptr constant
; expressions.

@foo = global [5 x <4 x double>] zeroinitializer, align 16

define void @test(i32 %r, i32 %c) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[R_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[C_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 [[R:%.*]], i32* [[R_ADDR]], align 4
; CHECK-NEXT:    store i32 [[C:%.*]], i32* [[C_ADDR]], align 4
; CHECK-NEXT:    [[COL_LOAD:%.*]] = load <2 x double>, <2 x double>* bitcast ([5 x <4 x double>]* @foo to <2 x double>*), align 8
; CHECK-NEXT:    [[COL_LOAD1:%.*]] = load <2 x double>, <2 x double>* bitcast (double* getelementptr ([5 x <4 x double>], [5 x <4 x double>]* @foo, i32 0, i32 0, i64 2) to <2 x double>*), align 8
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <2 x double> [[COL_LOAD]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x double> undef, double [[TMP0]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = fmul <1 x double> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[BLOCK2:%.*]] = shufflevector <2 x double> [[COL_LOAD1]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x double> [[COL_LOAD]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT3:%.*]] = insertelement <1 x double> undef, double [[TMP2]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT4:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT3]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = fmul <1 x double> [[BLOCK2]], [[SPLAT_SPLAT4]]
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <1 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <1 x double> [[TMP4]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <2 x double> undef, <2 x double> [[TMP5]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK5:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x double> [[COL_LOAD]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT6:%.*]] = insertelement <1 x double> undef, double [[TMP7]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT7:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT6]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = fmul <1 x double> [[BLOCK5]], [[SPLAT_SPLAT7]]
; CHECK-NEXT:    [[BLOCK8:%.*]] = shufflevector <2 x double> [[COL_LOAD1]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x double> [[COL_LOAD]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT9:%.*]] = insertelement <1 x double> undef, double [[TMP9]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT10:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT9]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = fmul <1 x double> [[BLOCK8]], [[SPLAT_SPLAT10]]
; CHECK-NEXT:    [[TMP11:%.*]] = fadd <1 x double> [[TMP8]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <1 x double> [[TMP11]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <2 x double> [[TMP6]], <2 x double> [[TMP12]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BLOCK11:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x double> [[COL_LOAD1]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT12:%.*]] = insertelement <1 x double> undef, double [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT13:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT12]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = fmul <1 x double> [[BLOCK11]], [[SPLAT_SPLAT13]]
; CHECK-NEXT:    [[BLOCK14:%.*]] = shufflevector <2 x double> [[COL_LOAD1]], <2 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <2 x double> [[COL_LOAD1]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT15:%.*]] = insertelement <1 x double> undef, double [[TMP16]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT16:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT15]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP17:%.*]] = fmul <1 x double> [[BLOCK14]], [[SPLAT_SPLAT16]]
; CHECK-NEXT:    [[TMP18:%.*]] = fadd <1 x double> [[TMP15]], [[TMP17]]
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <1 x double> [[TMP18]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <2 x double> undef, <2 x double> [[TMP19]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK17:%.*]] = shufflevector <2 x double> [[COL_LOAD]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <2 x double> [[COL_LOAD1]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT18:%.*]] = insertelement <1 x double> undef, double [[TMP21]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT19:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT18]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP22:%.*]] = fmul <1 x double> [[BLOCK17]], [[SPLAT_SPLAT19]]
; CHECK-NEXT:    [[BLOCK20:%.*]] = shufflevector <2 x double> [[COL_LOAD1]], <2 x double> undef, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <2 x double> [[COL_LOAD1]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT21:%.*]] = insertelement <1 x double> undef, double [[TMP23]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT22:%.*]] = shufflevector <1 x double> [[SPLAT_SPLATINSERT21]], <1 x double> undef, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP24:%.*]] = fmul <1 x double> [[BLOCK20]], [[SPLAT_SPLAT22]]
; CHECK-NEXT:    [[TMP25:%.*]] = fadd <1 x double> [[TMP22]], [[TMP24]]
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <1 x double> [[TMP25]], <1 x double> undef, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP27:%.*]] = shufflevector <2 x double> [[TMP20]], <2 x double> [[TMP26]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    store <2 x double> [[COL_LOAD]], <2 x double>* bitcast (double* getelementptr inbounds ([5 x <4 x double>], [5 x <4 x double>]* @foo, i64 0, i64 2, i32 0) to <2 x double>*), align 8
; CHECK-NEXT:    store <2 x double> [[COL_LOAD1]], <2 x double>* bitcast (double* getelementptr ([5 x <4 x double>], [5 x <4 x double>]* @foo, i64 0, i64 2, i64 2) to <2 x double>*), align 8
; CHECK-NEXT:    ret void
;
entry:
  %r.addr = alloca i32, align 4
  %c.addr = alloca i32, align 4
  store i32 %r, i32* %r.addr, align 4
  store i32 %c, i32* %c.addr, align 4
  %0 = load <4 x double>, <4 x double>* getelementptr inbounds ([5 x <4 x double>], [5 x <4 x double>]* @foo, i64 0, i64 0), align 8
  %mul = call <4 x double> @llvm.matrix.multiply(<4 x double> %0, <4 x double> %0, i32 2, i32 2, i32 2)
  store <4 x double> %0, <4 x double>* getelementptr inbounds ([5 x <4 x double>], [5 x <4 x double>]* @foo, i64 0, i64 2), align 8
  ret void
}

declare <4 x double> @llvm.matrix.multiply(<4 x double>, <4 x double>, i32, i32, i32)
