; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -mtriple=x86_64-- -mcpu=x86-64    -S | FileCheck %s --check-prefixes=SSE2
; RUN: opt < %s -slp-vectorizer -mtriple=x86_64-- -mcpu=x86-64-v2 -S | FileCheck %s --check-prefixes=SSE42
; RUN: opt < %s -slp-vectorizer -mtriple=x86_64-- -mcpu=x86-64-v3 -S | FileCheck %s --check-prefixes=AVX
; RUN: opt < %s -slp-vectorizer -mtriple=x86_64-- -mcpu=x86-64-v4 -S | FileCheck %s --check-prefixes=AVX

; PR51746
; typedef int v4si __attribute__ ((vector_size (16)));
;
; inline int reduce_and4(int acc, v4si v1, v4si v2, v4si v3, v4si v4) {
;   acc &= v1[0] & v1[1] & v1[2] & v1[3];
;   acc &= v2[0] & v2[1] & v2[2] & v2[3];
;   acc &= v3[0] & v3[1] & v3[2] & v3[3];
;   acc &= v4[0] & v4[1] & v4[2] & v4[3];
;   return acc;
; }

define i32 @reduce_and4(i32 %acc, <4 x i32> %v1, <4 x i32> %v2, <4 x i32> %v3, <4 x i32> %v4) {
; SSE2-LABEL: @reduce_and4(
; SSE2-NEXT:  entry:
; SSE2-NEXT:    [[VECEXT:%.*]] = extractelement <4 x i32> [[V1:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT1:%.*]] = extractelement <4 x i32> [[V1]], i64 1
; SSE2-NEXT:    [[VECEXT2:%.*]] = extractelement <4 x i32> [[V1]], i64 2
; SSE2-NEXT:    [[VECEXT4:%.*]] = extractelement <4 x i32> [[V1]], i64 3
; SSE2-NEXT:    [[VECEXT7:%.*]] = extractelement <4 x i32> [[V2:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT8:%.*]] = extractelement <4 x i32> [[V2]], i64 1
; SSE2-NEXT:    [[VECEXT10:%.*]] = extractelement <4 x i32> [[V2]], i64 2
; SSE2-NEXT:    [[VECEXT12:%.*]] = extractelement <4 x i32> [[V2]], i64 3
; SSE2-NEXT:    [[TMP0:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT8]], i32 0
; SSE2-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> [[TMP0]], i32 [[VECEXT7]], i32 1
; SSE2-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> [[TMP1]], i32 [[VECEXT10]], i32 2
; SSE2-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[VECEXT12]], i32 3
; SSE2-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[VECEXT1]], i32 4
; SSE2-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[VECEXT]], i32 5
; SSE2-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[VECEXT2]], i32 6
; SSE2-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[VECEXT4]], i32 7
; SSE2-NEXT:    [[VECEXT15:%.*]] = extractelement <4 x i32> [[V3:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT16:%.*]] = extractelement <4 x i32> [[V3]], i64 1
; SSE2-NEXT:    [[VECEXT18:%.*]] = extractelement <4 x i32> [[V3]], i64 2
; SSE2-NEXT:    [[VECEXT20:%.*]] = extractelement <4 x i32> [[V3]], i64 3
; SSE2-NEXT:    [[VECEXT23:%.*]] = extractelement <4 x i32> [[V4:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT24:%.*]] = extractelement <4 x i32> [[V4]], i64 1
; SSE2-NEXT:    [[VECEXT26:%.*]] = extractelement <4 x i32> [[V4]], i64 2
; SSE2-NEXT:    [[VECEXT28:%.*]] = extractelement <4 x i32> [[V4]], i64 3
; SSE2-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT24]], i32 0
; SSE2-NEXT:    [[TMP9:%.*]] = insertelement <8 x i32> [[TMP8]], i32 [[VECEXT23]], i32 1
; SSE2-NEXT:    [[TMP10:%.*]] = insertelement <8 x i32> [[TMP9]], i32 [[VECEXT26]], i32 2
; SSE2-NEXT:    [[TMP11:%.*]] = insertelement <8 x i32> [[TMP10]], i32 [[VECEXT28]], i32 3
; SSE2-NEXT:    [[TMP12:%.*]] = insertelement <8 x i32> [[TMP11]], i32 [[VECEXT16]], i32 4
; SSE2-NEXT:    [[TMP13:%.*]] = insertelement <8 x i32> [[TMP12]], i32 [[VECEXT15]], i32 5
; SSE2-NEXT:    [[TMP14:%.*]] = insertelement <8 x i32> [[TMP13]], i32 [[VECEXT18]], i32 6
; SSE2-NEXT:    [[TMP15:%.*]] = insertelement <8 x i32> [[TMP14]], i32 [[VECEXT20]], i32 7
; SSE2-NEXT:    [[TMP16:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP15]])
; SSE2-NEXT:    [[TMP17:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP7]])
; SSE2-NEXT:    [[OP_RDX:%.*]] = and i32 [[TMP16]], [[TMP17]]
; SSE2-NEXT:    [[OP_RDX1:%.*]] = and i32 [[OP_RDX]], [[ACC:%.*]]
; SSE2-NEXT:    ret i32 [[OP_RDX1]]
;
; SSE42-LABEL: @reduce_and4(
; SSE42-NEXT:  entry:
; SSE42-NEXT:    [[TMP0:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V4:%.*]])
; SSE42-NEXT:    [[TMP1:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V3:%.*]])
; SSE42-NEXT:    [[OP_RDX:%.*]] = and i32 [[TMP0]], [[TMP1]]
; SSE42-NEXT:    [[TMP2:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V2:%.*]])
; SSE42-NEXT:    [[OP_RDX1:%.*]] = and i32 [[OP_RDX]], [[TMP2]]
; SSE42-NEXT:    [[TMP3:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V1:%.*]])
; SSE42-NEXT:    [[OP_RDX2:%.*]] = and i32 [[OP_RDX1]], [[TMP3]]
; SSE42-NEXT:    [[OP_RDX3:%.*]] = and i32 [[OP_RDX2]], [[ACC:%.*]]
; SSE42-NEXT:    ret i32 [[OP_RDX3]]
;
; AVX-LABEL: @reduce_and4(
; AVX-NEXT:  entry:
; AVX-NEXT:    [[VECEXT:%.*]] = extractelement <4 x i32> [[V1:%.*]], i64 0
; AVX-NEXT:    [[VECEXT1:%.*]] = extractelement <4 x i32> [[V1]], i64 1
; AVX-NEXT:    [[VECEXT2:%.*]] = extractelement <4 x i32> [[V1]], i64 2
; AVX-NEXT:    [[VECEXT4:%.*]] = extractelement <4 x i32> [[V1]], i64 3
; AVX-NEXT:    [[VECEXT7:%.*]] = extractelement <4 x i32> [[V2:%.*]], i64 0
; AVX-NEXT:    [[VECEXT8:%.*]] = extractelement <4 x i32> [[V2]], i64 1
; AVX-NEXT:    [[VECEXT10:%.*]] = extractelement <4 x i32> [[V2]], i64 2
; AVX-NEXT:    [[VECEXT12:%.*]] = extractelement <4 x i32> [[V2]], i64 3
; AVX-NEXT:    [[TMP0:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT8]], i32 0
; AVX-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> [[TMP0]], i32 [[VECEXT7]], i32 1
; AVX-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> [[TMP1]], i32 [[VECEXT10]], i32 2
; AVX-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[VECEXT12]], i32 3
; AVX-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[VECEXT1]], i32 4
; AVX-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[VECEXT]], i32 5
; AVX-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[VECEXT2]], i32 6
; AVX-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[VECEXT4]], i32 7
; AVX-NEXT:    [[VECEXT15:%.*]] = extractelement <4 x i32> [[V3:%.*]], i64 0
; AVX-NEXT:    [[VECEXT16:%.*]] = extractelement <4 x i32> [[V3]], i64 1
; AVX-NEXT:    [[VECEXT18:%.*]] = extractelement <4 x i32> [[V3]], i64 2
; AVX-NEXT:    [[VECEXT20:%.*]] = extractelement <4 x i32> [[V3]], i64 3
; AVX-NEXT:    [[VECEXT23:%.*]] = extractelement <4 x i32> [[V4:%.*]], i64 0
; AVX-NEXT:    [[VECEXT24:%.*]] = extractelement <4 x i32> [[V4]], i64 1
; AVX-NEXT:    [[VECEXT26:%.*]] = extractelement <4 x i32> [[V4]], i64 2
; AVX-NEXT:    [[VECEXT28:%.*]] = extractelement <4 x i32> [[V4]], i64 3
; AVX-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT24]], i32 0
; AVX-NEXT:    [[TMP9:%.*]] = insertelement <8 x i32> [[TMP8]], i32 [[VECEXT23]], i32 1
; AVX-NEXT:    [[TMP10:%.*]] = insertelement <8 x i32> [[TMP9]], i32 [[VECEXT26]], i32 2
; AVX-NEXT:    [[TMP11:%.*]] = insertelement <8 x i32> [[TMP10]], i32 [[VECEXT28]], i32 3
; AVX-NEXT:    [[TMP12:%.*]] = insertelement <8 x i32> [[TMP11]], i32 [[VECEXT16]], i32 4
; AVX-NEXT:    [[TMP13:%.*]] = insertelement <8 x i32> [[TMP12]], i32 [[VECEXT15]], i32 5
; AVX-NEXT:    [[TMP14:%.*]] = insertelement <8 x i32> [[TMP13]], i32 [[VECEXT18]], i32 6
; AVX-NEXT:    [[TMP15:%.*]] = insertelement <8 x i32> [[TMP14]], i32 [[VECEXT20]], i32 7
; AVX-NEXT:    [[TMP16:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP15]])
; AVX-NEXT:    [[TMP17:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP7]])
; AVX-NEXT:    [[OP_RDX:%.*]] = and i32 [[TMP16]], [[TMP17]]
; AVX-NEXT:    [[OP_RDX1:%.*]] = and i32 [[OP_RDX]], [[ACC:%.*]]
; AVX-NEXT:    ret i32 [[OP_RDX1]]
;
entry:
  %vecext = extractelement <4 x i32> %v1, i64 0
  %vecext1 = extractelement <4 x i32> %v1, i64 1
  %vecext2 = extractelement <4 x i32> %v1, i64 2
  %vecext4 = extractelement <4 x i32> %v1, i64 3
  %vecext7 = extractelement <4 x i32> %v2, i64 0
  %vecext8 = extractelement <4 x i32> %v2, i64 1
  %vecext10 = extractelement <4 x i32> %v2, i64 2
  %vecext12 = extractelement <4 x i32> %v2, i64 3
  %vecext15 = extractelement <4 x i32> %v3, i64 0
  %vecext16 = extractelement <4 x i32> %v3, i64 1
  %vecext18 = extractelement <4 x i32> %v3, i64 2
  %vecext20 = extractelement <4 x i32> %v3, i64 3
  %vecext23 = extractelement <4 x i32> %v4, i64 0
  %vecext24 = extractelement <4 x i32> %v4, i64 1
  %vecext26 = extractelement <4 x i32> %v4, i64 2
  %vecext28 = extractelement <4 x i32> %v4, i64 3
  %and25 = and i32 %vecext1, %acc
  %and27 = and i32 %and25, %vecext
  %and29 = and i32 %and27, %vecext2
  %and17 = and i32 %and29, %vecext4
  %and19 = and i32 %and17, %vecext8
  %and21 = and i32 %and19, %vecext7
  %and9 = and i32 %and21, %vecext10
  %and11 = and i32 %and9, %vecext12
  %and13 = and i32 %and11, %vecext16
  %and = and i32 %and13, %vecext15
  %and3 = and i32 %and, %vecext18
  %and5 = and i32 %and3, %vecext20
  %and6 = and i32 %and5, %vecext24
  %and14 = and i32 %and6, %vecext23
  %and22 = and i32 %and14, %vecext26
  %and30 = and i32 %and22, %vecext28
  ret i32 %and30
}

; int reduce_and4_transpose(int acc, v4si v1, v4si v2, v4si v3, v4si v4) {
;   acc &= v1[0] & v2[0] & v3[0] & v4[0];
;   acc &= v1[1] & v2[1] & v3[1] & v4[1];
;   acc &= v1[2] & v2[2] & v3[2] & v4[2];
;   acc &= v1[3] & v2[3] & v3[3] & v4[3];
;   return acc;
; }

define i32 @reduce_and4_transpose(i32 %acc, <4 x i32> %v1, <4 x i32> %v2, <4 x i32> %v3, <4 x i32> %v4) {
; SSE2-LABEL: @reduce_and4_transpose(
; SSE2-NEXT:    [[VECEXT:%.*]] = extractelement <4 x i32> [[V1:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT1:%.*]] = extractelement <4 x i32> [[V2:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT2:%.*]] = extractelement <4 x i32> [[V3:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT4:%.*]] = extractelement <4 x i32> [[V4:%.*]], i64 0
; SSE2-NEXT:    [[VECEXT7:%.*]] = extractelement <4 x i32> [[V1]], i64 1
; SSE2-NEXT:    [[VECEXT8:%.*]] = extractelement <4 x i32> [[V2]], i64 1
; SSE2-NEXT:    [[VECEXT10:%.*]] = extractelement <4 x i32> [[V3]], i64 1
; SSE2-NEXT:    [[VECEXT12:%.*]] = extractelement <4 x i32> [[V4]], i64 1
; SSE2-NEXT:    [[VECEXT15:%.*]] = extractelement <4 x i32> [[V1]], i64 2
; SSE2-NEXT:    [[VECEXT16:%.*]] = extractelement <4 x i32> [[V2]], i64 2
; SSE2-NEXT:    [[VECEXT18:%.*]] = extractelement <4 x i32> [[V3]], i64 2
; SSE2-NEXT:    [[VECEXT20:%.*]] = extractelement <4 x i32> [[V4]], i64 2
; SSE2-NEXT:    [[VECEXT23:%.*]] = extractelement <4 x i32> [[V1]], i64 3
; SSE2-NEXT:    [[VECEXT24:%.*]] = extractelement <4 x i32> [[V2]], i64 3
; SSE2-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT24]], i32 0
; SSE2-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> [[TMP1]], i32 [[VECEXT16]], i32 1
; SSE2-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[VECEXT8]], i32 2
; SSE2-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[VECEXT1]], i32 3
; SSE2-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[VECEXT23]], i32 4
; SSE2-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[VECEXT15]], i32 5
; SSE2-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[VECEXT7]], i32 6
; SSE2-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[VECEXT]], i32 7
; SSE2-NEXT:    [[VECEXT26:%.*]] = extractelement <4 x i32> [[V3]], i64 3
; SSE2-NEXT:    [[VECEXT28:%.*]] = extractelement <4 x i32> [[V4]], i64 3
; SSE2-NEXT:    [[TMP9:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT28]], i32 0
; SSE2-NEXT:    [[TMP10:%.*]] = insertelement <8 x i32> [[TMP9]], i32 [[VECEXT20]], i32 1
; SSE2-NEXT:    [[TMP11:%.*]] = insertelement <8 x i32> [[TMP10]], i32 [[VECEXT12]], i32 2
; SSE2-NEXT:    [[TMP12:%.*]] = insertelement <8 x i32> [[TMP11]], i32 [[VECEXT4]], i32 3
; SSE2-NEXT:    [[TMP13:%.*]] = insertelement <8 x i32> [[TMP12]], i32 [[VECEXT26]], i32 4
; SSE2-NEXT:    [[TMP14:%.*]] = insertelement <8 x i32> [[TMP13]], i32 [[VECEXT18]], i32 5
; SSE2-NEXT:    [[TMP15:%.*]] = insertelement <8 x i32> [[TMP14]], i32 [[VECEXT10]], i32 6
; SSE2-NEXT:    [[TMP16:%.*]] = insertelement <8 x i32> [[TMP15]], i32 [[VECEXT2]], i32 7
; SSE2-NEXT:    [[TMP17:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP16]])
; SSE2-NEXT:    [[TMP18:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP8]])
; SSE2-NEXT:    [[OP_RDX:%.*]] = and i32 [[TMP17]], [[TMP18]]
; SSE2-NEXT:    [[OP_RDX1:%.*]] = and i32 [[OP_RDX]], [[ACC:%.*]]
; SSE2-NEXT:    ret i32 [[OP_RDX1]]
;
; SSE42-LABEL: @reduce_and4_transpose(
; SSE42-NEXT:    [[TMP1:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V4:%.*]])
; SSE42-NEXT:    [[TMP2:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V3:%.*]])
; SSE42-NEXT:    [[OP_RDX:%.*]] = and i32 [[TMP1]], [[TMP2]]
; SSE42-NEXT:    [[TMP3:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V2:%.*]])
; SSE42-NEXT:    [[OP_RDX1:%.*]] = and i32 [[OP_RDX]], [[TMP3]]
; SSE42-NEXT:    [[TMP4:%.*]] = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> [[V1:%.*]])
; SSE42-NEXT:    [[OP_RDX2:%.*]] = and i32 [[OP_RDX1]], [[TMP4]]
; SSE42-NEXT:    [[OP_RDX3:%.*]] = and i32 [[OP_RDX2]], [[ACC:%.*]]
; SSE42-NEXT:    ret i32 [[OP_RDX3]]
;
; AVX-LABEL: @reduce_and4_transpose(
; AVX-NEXT:    [[VECEXT:%.*]] = extractelement <4 x i32> [[V1:%.*]], i64 0
; AVX-NEXT:    [[VECEXT1:%.*]] = extractelement <4 x i32> [[V2:%.*]], i64 0
; AVX-NEXT:    [[VECEXT2:%.*]] = extractelement <4 x i32> [[V3:%.*]], i64 0
; AVX-NEXT:    [[VECEXT4:%.*]] = extractelement <4 x i32> [[V4:%.*]], i64 0
; AVX-NEXT:    [[VECEXT7:%.*]] = extractelement <4 x i32> [[V1]], i64 1
; AVX-NEXT:    [[VECEXT8:%.*]] = extractelement <4 x i32> [[V2]], i64 1
; AVX-NEXT:    [[VECEXT10:%.*]] = extractelement <4 x i32> [[V3]], i64 1
; AVX-NEXT:    [[VECEXT12:%.*]] = extractelement <4 x i32> [[V4]], i64 1
; AVX-NEXT:    [[VECEXT15:%.*]] = extractelement <4 x i32> [[V1]], i64 2
; AVX-NEXT:    [[VECEXT16:%.*]] = extractelement <4 x i32> [[V2]], i64 2
; AVX-NEXT:    [[VECEXT18:%.*]] = extractelement <4 x i32> [[V3]], i64 2
; AVX-NEXT:    [[VECEXT20:%.*]] = extractelement <4 x i32> [[V4]], i64 2
; AVX-NEXT:    [[VECEXT23:%.*]] = extractelement <4 x i32> [[V1]], i64 3
; AVX-NEXT:    [[VECEXT24:%.*]] = extractelement <4 x i32> [[V2]], i64 3
; AVX-NEXT:    [[TMP1:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT24]], i32 0
; AVX-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> [[TMP1]], i32 [[VECEXT16]], i32 1
; AVX-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 [[VECEXT8]], i32 2
; AVX-NEXT:    [[TMP4:%.*]] = insertelement <8 x i32> [[TMP3]], i32 [[VECEXT1]], i32 3
; AVX-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[VECEXT23]], i32 4
; AVX-NEXT:    [[TMP6:%.*]] = insertelement <8 x i32> [[TMP5]], i32 [[VECEXT15]], i32 5
; AVX-NEXT:    [[TMP7:%.*]] = insertelement <8 x i32> [[TMP6]], i32 [[VECEXT7]], i32 6
; AVX-NEXT:    [[TMP8:%.*]] = insertelement <8 x i32> [[TMP7]], i32 [[VECEXT]], i32 7
; AVX-NEXT:    [[VECEXT26:%.*]] = extractelement <4 x i32> [[V3]], i64 3
; AVX-NEXT:    [[VECEXT28:%.*]] = extractelement <4 x i32> [[V4]], i64 3
; AVX-NEXT:    [[TMP9:%.*]] = insertelement <8 x i32> poison, i32 [[VECEXT28]], i32 0
; AVX-NEXT:    [[TMP10:%.*]] = insertelement <8 x i32> [[TMP9]], i32 [[VECEXT20]], i32 1
; AVX-NEXT:    [[TMP11:%.*]] = insertelement <8 x i32> [[TMP10]], i32 [[VECEXT12]], i32 2
; AVX-NEXT:    [[TMP12:%.*]] = insertelement <8 x i32> [[TMP11]], i32 [[VECEXT4]], i32 3
; AVX-NEXT:    [[TMP13:%.*]] = insertelement <8 x i32> [[TMP12]], i32 [[VECEXT26]], i32 4
; AVX-NEXT:    [[TMP14:%.*]] = insertelement <8 x i32> [[TMP13]], i32 [[VECEXT18]], i32 5
; AVX-NEXT:    [[TMP15:%.*]] = insertelement <8 x i32> [[TMP14]], i32 [[VECEXT10]], i32 6
; AVX-NEXT:    [[TMP16:%.*]] = insertelement <8 x i32> [[TMP15]], i32 [[VECEXT2]], i32 7
; AVX-NEXT:    [[TMP17:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP16]])
; AVX-NEXT:    [[TMP18:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> [[TMP8]])
; AVX-NEXT:    [[OP_RDX:%.*]] = and i32 [[TMP17]], [[TMP18]]
; AVX-NEXT:    [[OP_RDX1:%.*]] = and i32 [[OP_RDX]], [[ACC:%.*]]
; AVX-NEXT:    ret i32 [[OP_RDX1]]
;
  %vecext = extractelement <4 x i32> %v1, i64 0
  %vecext1 = extractelement <4 x i32> %v2, i64 0
  %vecext2 = extractelement <4 x i32> %v3, i64 0
  %vecext4 = extractelement <4 x i32> %v4, i64 0
  %vecext7 = extractelement <4 x i32> %v1, i64 1
  %vecext8 = extractelement <4 x i32> %v2, i64 1
  %vecext10 = extractelement <4 x i32> %v3, i64 1
  %vecext12 = extractelement <4 x i32> %v4, i64 1
  %vecext15 = extractelement <4 x i32> %v1, i64 2
  %vecext16 = extractelement <4 x i32> %v2, i64 2
  %vecext18 = extractelement <4 x i32> %v3, i64 2
  %vecext20 = extractelement <4 x i32> %v4, i64 2
  %vecext23 = extractelement <4 x i32> %v1, i64 3
  %vecext24 = extractelement <4 x i32> %v2, i64 3
  %vecext26 = extractelement <4 x i32> %v3, i64 3
  %vecext28 = extractelement <4 x i32> %v4, i64 3
  %and = and i32 %vecext23, %acc
  %and3 = and i32 %and, %vecext15
  %and5 = and i32 %and3, %vecext7
  %and6 = and i32 %and5, %vecext
  %and9 = and i32 %and6, %vecext24
  %and11 = and i32 %and9, %vecext16
  %and13 = and i32 %and11, %vecext8
  %and14 = and i32 %and13, %vecext1
  %and17 = and i32 %and14, %vecext26
  %and19 = and i32 %and17, %vecext18
  %and21 = and i32 %and19, %vecext10
  %and22 = and i32 %and21, %vecext2
  %and25 = and i32 %and22, %vecext28
  %and27 = and i32 %and25, %vecext20
  %and29 = and i32 %and27, %vecext12
  %and30 = and i32 %and29, %vecext4
  ret i32 %and30
}
