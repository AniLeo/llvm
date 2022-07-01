; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s


define <8 x float> @transpose(<8 x float> %a) {
; CHECK-LABEL: @transpose(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <8 x float> [[A:%.*]], <8 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <8 x float> [[A]], <8 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <8 x float> [[A]], <8 x float> poison, <2 x i32> <i32 4, i32 5>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <8 x float> [[A]], <8 x float> poison, <2 x i32> <i32 6, i32 7>
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <2 x float> [[SPLIT]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x float> undef, float [[TMP0]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x float> [[SPLIT1]], i64 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x float> [[TMP1]], float [[TMP2]], i64 1
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x float> [[TMP3]], float [[TMP4]], i64 2
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x float> [[TMP5]], float [[TMP6]], i64 3
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x float> [[SPLIT]], i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <4 x float> undef, float [[TMP8]], i64 0
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x float> [[SPLIT1]], i64 1
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x float> [[TMP9]], float [[TMP10]], i64 1
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <4 x float> [[TMP11]], float [[TMP12]], i64 2
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <4 x float> [[TMP13]], float [[TMP14]], i64 3
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <4 x float> [[TMP7]], <4 x float> [[TMP15]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x float> [[TMP16]]
;
entry:
  %c  = call <8 x float> @llvm.matrix.transpose(<8 x float> %a, i32 2, i32 4)
  ret <8 x float> %c
}

declare <8 x float> @llvm.matrix.transpose(<8 x float>, i32, i32)

define <8 x float> @transpose_single_column(<8 x float> %a) {
; CHECK-LABEL: @transpose_single_column(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <8 x float> [[A:%.*]], <8 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <8 x float> [[SPLIT]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <1 x float> undef, float [[TMP0]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <8 x float> [[SPLIT]], i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <1 x float> undef, float [[TMP2]], i64 0
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <8 x float> [[SPLIT]], i64 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <1 x float> undef, float [[TMP4]], i64 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <8 x float> [[SPLIT]], i64 3
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <1 x float> undef, float [[TMP6]], i64 0
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <8 x float> [[SPLIT]], i64 4
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <1 x float> undef, float [[TMP8]], i64 0
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <8 x float> [[SPLIT]], i64 5
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <1 x float> undef, float [[TMP10]], i64 0
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <8 x float> [[SPLIT]], i64 6
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <1 x float> undef, float [[TMP12]], i64 0
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <8 x float> [[SPLIT]], i64 7
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <1 x float> undef, float [[TMP14]], i64 0
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <1 x float> [[TMP1]], <1 x float> [[TMP3]], <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <1 x float> [[TMP5]], <1 x float> [[TMP7]], <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <1 x float> [[TMP9]], <1 x float> [[TMP11]], <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <1 x float> [[TMP13]], <1 x float> [[TMP15]], <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <2 x float> [[TMP16]], <2 x float> [[TMP17]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP21:%.*]] = shufflevector <2 x float> [[TMP18]], <2 x float> [[TMP19]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <4 x float> [[TMP20]], <4 x float> [[TMP21]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x float> [[TMP22]]
;
entry:
  %c  = call <8 x float> @llvm.matrix.transpose(<8 x float> %a, i32 8, i32 1)
  ret <8 x float> %c
}

declare <12 x float> @llvm.matrix.transpose.v12f32(<12 x float>, i32, i32)

define <12 x float> @transpose_float_3x4(<12 x float> %a) {
; CHECK-LABEL: @transpose_float_3x4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <12 x float> [[A:%.*]], <12 x float> poison, <3 x i32> <i32 0, i32 1, i32 2>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <12 x float> [[A]], <12 x float> poison, <3 x i32> <i32 3, i32 4, i32 5>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <12 x float> [[A]], <12 x float> poison, <3 x i32> <i32 6, i32 7, i32 8>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <12 x float> [[A]], <12 x float> poison, <3 x i32> <i32 9, i32 10, i32 11>
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <3 x float> [[SPLIT]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x float> undef, float [[TMP0]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <3 x float> [[SPLIT1]], i64 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x float> [[TMP1]], float [[TMP2]], i64 1
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <3 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x float> [[TMP3]], float [[TMP4]], i64 2
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <3 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x float> [[TMP5]], float [[TMP6]], i64 3
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <3 x float> [[SPLIT]], i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <4 x float> undef, float [[TMP8]], i64 0
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <3 x float> [[SPLIT1]], i64 1
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x float> [[TMP9]], float [[TMP10]], i64 1
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <3 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <4 x float> [[TMP11]], float [[TMP12]], i64 2
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <3 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <4 x float> [[TMP13]], float [[TMP14]], i64 3
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <3 x float> [[SPLIT]], i64 2
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <4 x float> undef, float [[TMP16]], i64 0
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <3 x float> [[SPLIT1]], i64 2
; CHECK-NEXT:    [[TMP19:%.*]] = insertelement <4 x float> [[TMP17]], float [[TMP18]], i64 1
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <3 x float> [[SPLIT2]], i64 2
; CHECK-NEXT:    [[TMP21:%.*]] = insertelement <4 x float> [[TMP19]], float [[TMP20]], i64 2
; CHECK-NEXT:    [[TMP22:%.*]] = extractelement <3 x float> [[SPLIT3]], i64 2
; CHECK-NEXT:    [[TMP23:%.*]] = insertelement <4 x float> [[TMP21]], float [[TMP22]], i64 3
; CHECK-NEXT:    [[TMP24:%.*]] = shufflevector <4 x float> [[TMP7]], <4 x float> [[TMP15]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP25:%.*]] = shufflevector <4 x float> [[TMP23]], <4 x float> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <8 x float> [[TMP24]], <8 x float> [[TMP25]], <12 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
; CHECK-NEXT:    ret <12 x float> [[TMP26]]
;
entry:
  %c  = call <12 x float> @llvm.matrix.transpose.v12f32(<12 x float> %a, i32 3, i32 4)
  ret <12 x float> %c
}
