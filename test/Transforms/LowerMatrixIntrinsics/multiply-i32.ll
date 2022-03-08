; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s


define <4 x i32> @multiply_2x2(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @multiply_2x2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <4 x i32> [[A:%.*]], <4 x i32> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <4 x i32> [[A]], <4 x i32> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <4 x i32> [[B:%.*]], <4 x i32> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <4 x i32> [[B]], <4 x i32> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x i32> poison, i32 [[TMP0]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = mul <1 x i32> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[BLOCK4:%.*]] = shufflevector <2 x i32> [[SPLIT1]], <2 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT5:%.*]] = insertelement <1 x i32> poison, i32 [[TMP2]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT6:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT5]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = mul <1 x i32> [[BLOCK4]], [[SPLAT_SPLAT6]]
; CHECK-NEXT:    [[TMP4:%.*]] = add <1 x i32> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <1 x i32> [[TMP4]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <2 x i32> undef, <2 x i32> [[TMP5]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK7:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT8:%.*]] = insertelement <1 x i32> poison, i32 [[TMP7]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT9:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT8]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = mul <1 x i32> [[BLOCK7]], [[SPLAT_SPLAT9]]
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x i32> [[SPLIT1]], <2 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <1 x i32> poison, i32 [[TMP9]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT11]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = mul <1 x i32> [[BLOCK10]], [[SPLAT_SPLAT12]]
; CHECK-NEXT:    [[TMP11:%.*]] = add <1 x i32> [[TMP8]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <1 x i32> [[TMP11]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <2 x i32> [[TMP6]], <2 x i32> [[TMP12]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT14:%.*]] = insertelement <1 x i32> poison, i32 [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT15:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT14]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = mul <1 x i32> [[BLOCK13]], [[SPLAT_SPLAT15]]
; CHECK-NEXT:    [[BLOCK16:%.*]] = shufflevector <2 x i32> [[SPLIT1]], <2 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT17:%.*]] = insertelement <1 x i32> poison, i32 [[TMP16]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT18:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT17]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP17:%.*]] = mul <1 x i32> [[BLOCK16]], [[SPLAT_SPLAT18]]
; CHECK-NEXT:    [[TMP18:%.*]] = add <1 x i32> [[TMP15]], [[TMP17]]
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <1 x i32> [[TMP18]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <2 x i32> undef, <2 x i32> [[TMP19]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK19:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT20:%.*]] = insertelement <1 x i32> poison, i32 [[TMP21]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT20]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP22:%.*]] = mul <1 x i32> [[BLOCK19]], [[SPLAT_SPLAT21]]
; CHECK-NEXT:    [[BLOCK22:%.*]] = shufflevector <2 x i32> [[SPLIT1]], <2 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT23:%.*]] = insertelement <1 x i32> poison, i32 [[TMP23]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT23]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP24:%.*]] = mul <1 x i32> [[BLOCK22]], [[SPLAT_SPLAT24]]
; CHECK-NEXT:    [[TMP25:%.*]] = add <1 x i32> [[TMP22]], [[TMP24]]
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <1 x i32> [[TMP25]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP27:%.*]] = shufflevector <2 x i32> [[TMP20]], <2 x i32> [[TMP26]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[TMP28:%.*]] = shufflevector <2 x i32> [[TMP13]], <2 x i32> [[TMP27]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x i32> [[TMP28]]
;
entry:
  %c = call <4 x i32> @llvm.matrix.multiply.v4i32.v4i32.v4i32(<4 x i32> %a, <4 x i32> %b, i32 2, i32 2, i32 2)
  ret <4 x i32> %c
}

declare <4 x i32> @llvm.matrix.multiply.v4i32.v4i32.v4i32(<4 x i32>, <4 x i32>, i32, i32, i32)

define <4 x i32> @multiply_1x2(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: @multiply_1x2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <2 x i32> [[A:%.*]], <2 x i32> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <2 x i32> [[B:%.*]], <2 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <2 x i32> [[B]], <2 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <1 x i32> [[SPLIT1]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x i32> poison, i32 [[TMP0]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = mul <1 x i32> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <1 x i32> [[TMP1]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <2 x i32> undef, <2 x i32> [[TMP2]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK3:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <1 x i32> [[SPLIT1]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT4:%.*]] = insertelement <1 x i32> poison, i32 [[TMP4]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT5:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT4]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = mul <1 x i32> [[BLOCK3]], [[SPLAT_SPLAT5]]
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <1 x i32> [[TMP5]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <2 x i32> [[TMP3]], <2 x i32> [[TMP6]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BLOCK6:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <1 x i32> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT7:%.*]] = insertelement <1 x i32> poison, i32 [[TMP8]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT8:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT7]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP9:%.*]] = mul <1 x i32> [[BLOCK6]], [[SPLAT_SPLAT8]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <1 x i32> [[TMP9]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <2 x i32> undef, <2 x i32> [[TMP10]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK9:%.*]] = shufflevector <2 x i32> [[SPLIT]], <2 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <1 x i32> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT10:%.*]] = insertelement <1 x i32> poison, i32 [[TMP12]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT11:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT10]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP13:%.*]] = mul <1 x i32> [[BLOCK9]], [[SPLAT_SPLAT11]]
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <1 x i32> [[TMP13]], <1 x i32> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <2 x i32> [[TMP11]], <2 x i32> [[TMP14]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <2 x i32> [[TMP7]], <2 x i32> [[TMP15]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x i32> [[TMP16]]
;
entry:
  %c = call <4 x i32> @llvm.matrix.multiply.v4i32.v2i32.v2i32(<2 x i32> %a, <2 x i32> %b, i32 2, i32 1, i32 2)
  ret <4 x i32> %c
}

declare <4 x i32> @llvm.matrix.multiply.v4i32.v2i32.v2i32(<2 x i32>, <2 x i32>, i32, i32, i32)

define <9 x i32> @multiply_2x3(<6 x i32> %a, <6 x i32> %b) {
; CHECK-LABEL: @multiply_2x3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <6 x i32> [[A:%.*]], <6 x i32> poison, <3 x i32> <i32 0, i32 1, i32 2>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <6 x i32> [[A]], <6 x i32> poison, <3 x i32> <i32 3, i32 4, i32 5>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <6 x i32> [[B:%.*]], <6 x i32> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <6 x i32> [[B]], <6 x i32> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT4:%.*]] = shufflevector <6 x i32> [[B]], <6 x i32> poison, <2 x i32> <i32 4, i32 5>
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x i32> poison, i32 [[TMP0]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = mul <1 x i32> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[BLOCK5:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT6:%.*]] = insertelement <1 x i32> poison, i32 [[TMP2]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT7:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT6]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = mul <1 x i32> [[BLOCK5]], [[SPLAT_SPLAT7]]
; CHECK-NEXT:    [[TMP4:%.*]] = add <1 x i32> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <1 x i32> [[TMP4]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <3 x i32> undef, <3 x i32> [[TMP5]], <3 x i32> <i32 3, i32 1, i32 2>
; CHECK-NEXT:    [[BLOCK8:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT9:%.*]] = insertelement <1 x i32> poison, i32 [[TMP7]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT10:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT9]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = mul <1 x i32> [[BLOCK8]], [[SPLAT_SPLAT10]]
; CHECK-NEXT:    [[BLOCK11:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT12:%.*]] = insertelement <1 x i32> poison, i32 [[TMP9]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT13:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT12]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = mul <1 x i32> [[BLOCK11]], [[SPLAT_SPLAT13]]
; CHECK-NEXT:    [[TMP11:%.*]] = add <1 x i32> [[TMP8]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <1 x i32> [[TMP11]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <3 x i32> [[TMP6]], <3 x i32> [[TMP12]], <3 x i32> <i32 0, i32 3, i32 2>
; CHECK-NEXT:    [[BLOCK14:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> <i32 2>
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT15:%.*]] = insertelement <1 x i32> poison, i32 [[TMP14]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT16:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT15]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = mul <1 x i32> [[BLOCK14]], [[SPLAT_SPLAT16]]
; CHECK-NEXT:    [[BLOCK17:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> <i32 2>
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <2 x i32> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT18:%.*]] = insertelement <1 x i32> poison, i32 [[TMP16]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT19:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT18]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP17:%.*]] = mul <1 x i32> [[BLOCK17]], [[SPLAT_SPLAT19]]
; CHECK-NEXT:    [[TMP18:%.*]] = add <1 x i32> [[TMP15]], [[TMP17]]
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <1 x i32> [[TMP18]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <3 x i32> [[TMP13]], <3 x i32> [[TMP19]], <3 x i32> <i32 0, i32 1, i32 3>
; CHECK-NEXT:    [[BLOCK20:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT21:%.*]] = insertelement <1 x i32> poison, i32 [[TMP21]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT22:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT21]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP22:%.*]] = mul <1 x i32> [[BLOCK20]], [[SPLAT_SPLAT22]]
; CHECK-NEXT:    [[BLOCK23:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP23:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT24:%.*]] = insertelement <1 x i32> poison, i32 [[TMP23]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT25:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT24]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP24:%.*]] = mul <1 x i32> [[BLOCK23]], [[SPLAT_SPLAT25]]
; CHECK-NEXT:    [[TMP25:%.*]] = add <1 x i32> [[TMP22]], [[TMP24]]
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <1 x i32> [[TMP25]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP27:%.*]] = shufflevector <3 x i32> undef, <3 x i32> [[TMP26]], <3 x i32> <i32 3, i32 1, i32 2>
; CHECK-NEXT:    [[BLOCK26:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP28:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT27:%.*]] = insertelement <1 x i32> poison, i32 [[TMP28]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT28:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT27]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP29:%.*]] = mul <1 x i32> [[BLOCK26]], [[SPLAT_SPLAT28]]
; CHECK-NEXT:    [[BLOCK29:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP30:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT30:%.*]] = insertelement <1 x i32> poison, i32 [[TMP30]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT31:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT30]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP31:%.*]] = mul <1 x i32> [[BLOCK29]], [[SPLAT_SPLAT31]]
; CHECK-NEXT:    [[TMP32:%.*]] = add <1 x i32> [[TMP29]], [[TMP31]]
; CHECK-NEXT:    [[TMP33:%.*]] = shufflevector <1 x i32> [[TMP32]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP34:%.*]] = shufflevector <3 x i32> [[TMP27]], <3 x i32> [[TMP33]], <3 x i32> <i32 0, i32 3, i32 2>
; CHECK-NEXT:    [[BLOCK32:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> <i32 2>
; CHECK-NEXT:    [[TMP35:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT33:%.*]] = insertelement <1 x i32> poison, i32 [[TMP35]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT34:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT33]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP36:%.*]] = mul <1 x i32> [[BLOCK32]], [[SPLAT_SPLAT34]]
; CHECK-NEXT:    [[BLOCK35:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> <i32 2>
; CHECK-NEXT:    [[TMP37:%.*]] = extractelement <2 x i32> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT36:%.*]] = insertelement <1 x i32> poison, i32 [[TMP37]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT37:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT36]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP38:%.*]] = mul <1 x i32> [[BLOCK35]], [[SPLAT_SPLAT37]]
; CHECK-NEXT:    [[TMP39:%.*]] = add <1 x i32> [[TMP36]], [[TMP38]]
; CHECK-NEXT:    [[TMP40:%.*]] = shufflevector <1 x i32> [[TMP39]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP41:%.*]] = shufflevector <3 x i32> [[TMP34]], <3 x i32> [[TMP40]], <3 x i32> <i32 0, i32 1, i32 3>
; CHECK-NEXT:    [[BLOCK38:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP42:%.*]] = extractelement <2 x i32> [[SPLIT4]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT39:%.*]] = insertelement <1 x i32> poison, i32 [[TMP42]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT40:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT39]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP43:%.*]] = mul <1 x i32> [[BLOCK38]], [[SPLAT_SPLAT40]]
; CHECK-NEXT:    [[BLOCK41:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP44:%.*]] = extractelement <2 x i32> [[SPLIT4]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT42:%.*]] = insertelement <1 x i32> poison, i32 [[TMP44]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT43:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT42]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP45:%.*]] = mul <1 x i32> [[BLOCK41]], [[SPLAT_SPLAT43]]
; CHECK-NEXT:    [[TMP46:%.*]] = add <1 x i32> [[TMP43]], [[TMP45]]
; CHECK-NEXT:    [[TMP47:%.*]] = shufflevector <1 x i32> [[TMP46]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP48:%.*]] = shufflevector <3 x i32> undef, <3 x i32> [[TMP47]], <3 x i32> <i32 3, i32 1, i32 2>
; CHECK-NEXT:    [[BLOCK44:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP49:%.*]] = extractelement <2 x i32> [[SPLIT4]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT45:%.*]] = insertelement <1 x i32> poison, i32 [[TMP49]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT46:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT45]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP50:%.*]] = mul <1 x i32> [[BLOCK44]], [[SPLAT_SPLAT46]]
; CHECK-NEXT:    [[BLOCK47:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP51:%.*]] = extractelement <2 x i32> [[SPLIT4]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT48:%.*]] = insertelement <1 x i32> poison, i32 [[TMP51]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT49:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT48]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP52:%.*]] = mul <1 x i32> [[BLOCK47]], [[SPLAT_SPLAT49]]
; CHECK-NEXT:    [[TMP53:%.*]] = add <1 x i32> [[TMP50]], [[TMP52]]
; CHECK-NEXT:    [[TMP54:%.*]] = shufflevector <1 x i32> [[TMP53]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP55:%.*]] = shufflevector <3 x i32> [[TMP48]], <3 x i32> [[TMP54]], <3 x i32> <i32 0, i32 3, i32 2>
; CHECK-NEXT:    [[BLOCK50:%.*]] = shufflevector <3 x i32> [[SPLIT]], <3 x i32> poison, <1 x i32> <i32 2>
; CHECK-NEXT:    [[TMP56:%.*]] = extractelement <2 x i32> [[SPLIT4]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT51:%.*]] = insertelement <1 x i32> poison, i32 [[TMP56]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT52:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT51]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP57:%.*]] = mul <1 x i32> [[BLOCK50]], [[SPLAT_SPLAT52]]
; CHECK-NEXT:    [[BLOCK53:%.*]] = shufflevector <3 x i32> [[SPLIT1]], <3 x i32> poison, <1 x i32> <i32 2>
; CHECK-NEXT:    [[TMP58:%.*]] = extractelement <2 x i32> [[SPLIT4]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT54:%.*]] = insertelement <1 x i32> poison, i32 [[TMP58]], i32 0
; CHECK-NEXT:    [[SPLAT_SPLAT55:%.*]] = shufflevector <1 x i32> [[SPLAT_SPLATINSERT54]], <1 x i32> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP59:%.*]] = mul <1 x i32> [[BLOCK53]], [[SPLAT_SPLAT55]]
; CHECK-NEXT:    [[TMP60:%.*]] = add <1 x i32> [[TMP57]], [[TMP59]]
; CHECK-NEXT:    [[TMP61:%.*]] = shufflevector <1 x i32> [[TMP60]], <1 x i32> poison, <3 x i32> <i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP62:%.*]] = shufflevector <3 x i32> [[TMP55]], <3 x i32> [[TMP61]], <3 x i32> <i32 0, i32 1, i32 3>
; CHECK-NEXT:    [[TMP63:%.*]] = shufflevector <3 x i32> [[TMP20]], <3 x i32> [[TMP41]], <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
; CHECK-NEXT:    [[TMP64:%.*]] = shufflevector <3 x i32> [[TMP62]], <3 x i32> poison, <6 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP65:%.*]] = shufflevector <6 x i32> [[TMP63]], <6 x i32> [[TMP64]], <9 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
; CHECK-NEXT:    ret <9 x i32> [[TMP65]]
;
entry:
  %c = call <9 x i32> @llvm.matrix.multiply.v6i32.v6i32.v6i32(<6 x i32> %a, <6 x i32> %b, i32 3, i32 2, i32 3)
  ret <9 x i32> %c
}

declare <9 x i32> @llvm.matrix.multiply.v6i32.v6i32.v6i32(<6 x i32>, <6 x i32>, i32, i32, i32)
