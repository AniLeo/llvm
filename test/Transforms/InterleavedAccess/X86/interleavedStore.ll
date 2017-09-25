; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-pc-linux -mattr=+avx2 -interleaved-access -S | FileCheck %s

define void @interleaved_store_vf32_i8_stride4(<32 x i8> %x1, <32 x i8> %x2, <32 x i8> %x3, <32 x i8> %x4, <128 x i8>* %p) {
; CHECK-LABEL: @interleaved_store_vf32_i8_stride4(
; CHECK-NEXT:    [[V1:%.*]] = shufflevector <32 x i8> [[X1:%.*]], <32 x i8> [[X2:%.*]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[V2:%.*]] = shufflevector <32 x i8> [[X3:%.*]], <32 x i8> [[X4:%.*]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <64 x i8> [[V1]], <64 x i8> [[V2]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <64 x i8> [[V1]], <64 x i8> [[V2]], <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <64 x i8> [[V1]], <64 x i8> [[V2]], <32 x i32> <i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <64 x i8> [[V1]], <64 x i8> [[V2]], <32 x i32> <i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <32 x i8> [[TMP1]], <32 x i8> [[TMP2]], <32 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <32 x i8> [[TMP1]], <32 x i8> [[TMP2]], <32 x i32> <i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <32 x i8> [[TMP3]], <32 x i8> [[TMP4]], <32 x i32> <i32 0, i32 32, i32 1, i32 33, i32 2, i32 34, i32 3, i32 35, i32 4, i32 36, i32 5, i32 37, i32 6, i32 38, i32 7, i32 39, i32 16, i32 48, i32 17, i32 49, i32 18, i32 50, i32 19, i32 51, i32 20, i32 52, i32 21, i32 53, i32 22, i32 54, i32 23, i32 55>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <32 x i8> [[TMP3]], <32 x i8> [[TMP4]], <32 x i32> <i32 8, i32 40, i32 9, i32 41, i32 10, i32 42, i32 11, i32 43, i32 12, i32 44, i32 13, i32 45, i32 14, i32 46, i32 15, i32 47, i32 24, i32 56, i32 25, i32 57, i32 26, i32 58, i32 27, i32 59, i32 28, i32 60, i32 29, i32 61, i32 30, i32 62, i32 31, i32 63>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <32 x i8> [[TMP5]], <32 x i8> [[TMP7]], <32 x i32> <i32 8, i32 9, i32 40, i32 41, i32 10, i32 11, i32 42, i32 43, i32 12, i32 13, i32 44, i32 45, i32 14, i32 15, i32 46, i32 47, i32 24, i32 25, i32 56, i32 57, i32 26, i32 27, i32 58, i32 59, i32 28, i32 29, i32 60, i32 61, i32 30, i32 31, i32 62, i32 63>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <32 x i8> [[TMP6]], <32 x i8> [[TMP8]], <32 x i32> <i32 8, i32 9, i32 40, i32 41, i32 10, i32 11, i32 42, i32 43, i32 12, i32 13, i32 44, i32 45, i32 14, i32 15, i32 46, i32 47, i32 24, i32 25, i32 56, i32 57, i32 26, i32 27, i32 58, i32 59, i32 28, i32 29, i32 60, i32 61, i32 30, i32 31, i32 62, i32 63>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <32 x i8> [[TMP5]], <32 x i8> [[TMP7]], <32 x i32> <i32 0, i32 1, i32 32, i32 33, i32 2, i32 3, i32 34, i32 35, i32 4, i32 5, i32 36, i32 37, i32 6, i32 7, i32 38, i32 39, i32 16, i32 17, i32 48, i32 49, i32 18, i32 19, i32 50, i32 51, i32 20, i32 21, i32 52, i32 53, i32 22, i32 23, i32 54, i32 55>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <32 x i8> [[TMP6]], <32 x i8> [[TMP8]], <32 x i32> <i32 0, i32 1, i32 32, i32 33, i32 2, i32 3, i32 34, i32 35, i32 4, i32 5, i32 36, i32 37, i32 6, i32 7, i32 38, i32 39, i32 16, i32 17, i32 48, i32 49, i32 18, i32 19, i32 50, i32 51, i32 20, i32 21, i32 52, i32 53, i32 22, i32 23, i32 54, i32 55>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <32 x i8> [[TMP11]], <32 x i8> [[TMP9]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <32 x i8> [[TMP12]], <32 x i8> [[TMP10]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <32 x i8> [[TMP11]], <32 x i8> [[TMP9]], <32 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <32 x i8> [[TMP12]], <32 x i8> [[TMP10]], <32 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <32 x i8> [[TMP13]], <32 x i8> [[TMP14]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <32 x i8> [[TMP15]], <32 x i8> [[TMP16]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <64 x i8> [[TMP17]], <64 x i8> [[TMP18]], <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
; CHECK-NEXT:    store <128 x i8> [[TMP19]], <128 x i8>* [[P:%.*]]
; CHECK-NEXT:    ret void
;
  %v1 = shufflevector <32 x i8> %x1, <32 x i8> %x2, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %v2 = shufflevector <32 x i8> %x3, <32 x i8> %x4, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %interleaved.vec = shufflevector <64 x i8> %v1, <64 x i8> %v2, <128 x i32> <i32 0, i32 32, i32 64, i32 96, i32 1, i32 33, i32 65, i32 97, i32 2, i32 34, i32 66, i32 98, i32 3, i32 35, i32 67, i32 99, i32 4, i32 36, i32 68, i32 100, i32 5, i32 37, i32 69, i32 101, i32 6, i32 38, i32 70, i32 102, i32 7, i32 39, i32 71, i32 103, i32 8, i32 40, i32 72, i32 104, i32 9, i32 41, i32 73, i32 105, i32 10, i32 42, i32 74, i32 106, i32 11, i32 43, i32 75, i32 107, i32 12, i32 44, i32 76, i32 108, i32 13, i32 45, i32 77, i32 109, i32 14, i32 46, i32 78, i32 110, i32 15, i32 47, i32 79, i32 111, i32 16, i32 48, i32 80, i32 112, i32 17, i32 49, i32 81, i32 113, i32 18, i32 50, i32 82, i32 114, i32 19, i32 51, i32 83, i32 115, i32 20, i32 52, i32 84, i32 116, i32 21, i32 53, i32 85, i32 117, i32 22, i32 54, i32 86, i32 118, i32 23, i32 55, i32 87, i32 119, i32 24, i32 56, i32 88, i32 120, i32 25, i32 57, i32 89, i32 121, i32 26, i32 58, i32 90, i32 122, i32 27, i32 59, i32 91, i32 123, i32 28, i32 60, i32 92, i32 124, i32 29, i32 61, i32 93, i32 125, i32 30, i32 62, i32 94, i32 126, i32 31, i32 63, i32 95, i32 127>
  store <128 x i8> %interleaved.vec, <128 x i8>* %p
  ret void
}

define void @interleaved_store_vf16_i8_stride4(<16 x i8> %x1, <16 x i8> %x2, <16 x i8> %x3, <16 x i8> %x4, <64 x i8>* %p) {
; CHECK-LABEL: @interleaved_store_vf16_i8_stride4(
; CHECK-NEXT:    [[V1:%.*]] = shufflevector <16 x i8> [[X1:%.*]], <16 x i8> [[X2:%.*]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[V2:%.*]] = shufflevector <16 x i8> [[X3:%.*]], <16 x i8> [[X4:%.*]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <32 x i8> [[V1]], <32 x i8> [[V2]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <32 x i8> [[V1]], <32 x i8> [[V2]], <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <32 x i8> [[V1]], <32 x i8> [[V2]], <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <32 x i8> [[V1]], <32 x i8> [[V2]], <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <16 x i8> [[TMP1]], <16 x i8> [[TMP2]], <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <16 x i8> [[TMP1]], <16 x i8> [[TMP2]], <16 x i32> <i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <16 x i8> [[TMP3]], <16 x i8> [[TMP4]], <16 x i32> <i32 0, i32 16, i32 1, i32 17, i32 2, i32 18, i32 3, i32 19, i32 4, i32 20, i32 5, i32 21, i32 6, i32 22, i32 7, i32 23>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <16 x i8> [[TMP3]], <16 x i8> [[TMP4]], <16 x i32> <i32 8, i32 24, i32 9, i32 25, i32 10, i32 26, i32 11, i32 27, i32 12, i32 28, i32 13, i32 29, i32 14, i32 30, i32 15, i32 31>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <16 x i8> [[TMP5]], <16 x i8> [[TMP7]], <16 x i32> <i32 8, i32 9, i32 24, i32 25, i32 10, i32 11, i32 26, i32 27, i32 12, i32 13, i32 28, i32 29, i32 14, i32 15, i32 30, i32 31>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <16 x i8> [[TMP6]], <16 x i8> [[TMP8]], <16 x i32> <i32 8, i32 9, i32 24, i32 25, i32 10, i32 11, i32 26, i32 27, i32 12, i32 13, i32 28, i32 29, i32 14, i32 15, i32 30, i32 31>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <16 x i8> [[TMP5]], <16 x i8> [[TMP7]], <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 2, i32 3, i32 18, i32 19, i32 4, i32 5, i32 20, i32 21, i32 6, i32 7, i32 22, i32 23>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <16 x i8> [[TMP6]], <16 x i8> [[TMP8]], <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 2, i32 3, i32 18, i32 19, i32 4, i32 5, i32 20, i32 21, i32 6, i32 7, i32 22, i32 23>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <16 x i8> [[TMP11]], <16 x i8> [[TMP9]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <16 x i8> [[TMP12]], <16 x i8> [[TMP10]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <32 x i8> [[TMP13]], <32 x i8> [[TMP14]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    store <64 x i8> [[TMP15]], <64 x i8>* [[P:%.*]]
; CHECK-NEXT:    ret void
;
%v1 = shufflevector <16 x i8> %x1, <16 x i8> %x2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
%v2 = shufflevector <16 x i8> %x3, <16 x i8> %x4, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
%interleaved.vec = shufflevector <32 x i8> %v1, <32 x i8> %v2, <64 x i32> <i32 0,i32 16,i32 32,i32 48,i32 1,i32 17,i32 33,i32 49,i32 2,i32 18,i32 34,i32 50,i32 3,i32 19,i32 35,i32 51,i32 4,i32 20,i32 36,i32 52,i32 5,i32 21,i32 37,i32 53,i32 6,i32 22,i32 38,i32 54,i32 7,i32 23,i32 39,i32 55,i32 8,i32 24,i32 40,i32 56,i32 9,i32 25,i32 41,i32 57,i32 10,i32 26,i32 42,i32 58,i32 11,i32 27,i32 43,i32 59,i32 12,i32 28,i32 44,i32 60,i32 13,i32 29,i32 45,i32 61,i32 14,i32 30,i32 46,i32 62,i32 15,i32 31,i32 47,i32 63>
store <64 x i8> %interleaved.vec, <64 x i8>* %p
ret void
}

define void @interleaved_store_vf8_i8_stride4(<8 x i8> %x1, <8 x i8> %x2, <8 x i8> %x3, <8 x i8> %x4, <32 x i8>* %p) {
; CHECK-LABEL: @interleaved_store_vf8_i8_stride4(
; CHECK-NEXT:    [[V1:%.*]] = shufflevector <8 x i8> [[X1:%.*]], <8 x i8> [[X2:%.*]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[V2:%.*]] = shufflevector <8 x i8> [[X3:%.*]], <8 x i8> [[X4:%.*]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i8> [[V1]], <16 x i8> [[V2]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i8> [[V1]], <16 x i8> [[V2]], <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <16 x i8> [[V1]], <16 x i8> [[V2]], <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <16 x i8> [[V1]], <16 x i8> [[V2]], <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <8 x i8> [[TMP1]], <8 x i8> [[TMP2]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <8 x i8> [[TMP3]], <8 x i8> [[TMP4]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <16 x i8> [[TMP5]], <16 x i8> [[TMP6]], <16 x i32> <i32 0, i32 1, i32 16, i32 17, i32 2, i32 3, i32 18, i32 19, i32 4, i32 5, i32 20, i32 21, i32 6, i32 7, i32 22, i32 23>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <16 x i8> [[TMP5]], <16 x i8> [[TMP6]], <16 x i32> <i32 8, i32 9, i32 24, i32 25, i32 10, i32 11, i32 26, i32 27, i32 12, i32 13, i32 28, i32 29, i32 14, i32 15, i32 30, i32 31>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <16 x i8> [[TMP7]], <16 x i8> [[TMP8]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    store <32 x i8> [[TMP9]], <32 x i8>* [[P:%.*]]
; CHECK-NEXT:    ret void
;
  %v1 = shufflevector <8 x i8> %x1, <8 x i8> %x2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %v2 = shufflevector <8 x i8> %x3, <8 x i8> %x4, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %interleaved.vec = shufflevector <16 x i8> %v1, <16 x i8> %v2, <32 x i32> <i32 0,i32 8,i32 16,i32 24,i32 1,i32 9,i32 17,i32 25,i32 2,i32 10,i32 18,i32 26,i32 3,i32 11,i32 19,i32 27,i32 4,i32 12,i32 20,i32 28,i32 5,i32 13,i32 21,i32 29,i32 6,i32 14,i32 22,i32 30,i32 7,i32 15,i32 23,i32 31>
  store <32 x i8> %interleaved.vec, <32 x i8>* %p
ret void
}

define void @interleaved_store_vf8_i8_stride3(<8 x i8> %a, <8 x i8> %b, <8 x i8> %c, <24 x i8>* %p) {
; CHECK-LABEL: @interleaved_store_vf8_i8_stride3(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i8> [[A:%.*]], <8 x i8> [[B:%.*]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i8> [[C:%.*]], <8 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[INTERLEAVED_VEC:%.*]] = shufflevector <16 x i8> [[TMP1]], <16 x i8> [[TMP2]], <24 x i32> <i32 0, i32 8, i32 16, i32 1, i32 9, i32 17, i32 2, i32 10, i32 18, i32 3, i32 11, i32 19, i32 4, i32 12, i32 20, i32 5, i32 13, i32 21, i32 6, i32 14, i32 22, i32 7, i32 15, i32 23>
; CHECK-NEXT:    store <24 x i8> [[INTERLEAVED_VEC]], <24 x i8>* [[P:%.*]], align 1
; CHECK-NEXT:    ret void
;
%1 = shufflevector <8 x i8> %a, <8 x i8> %b, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
%2 = shufflevector <8 x i8> %c, <8 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
%interleaved.vec = shufflevector <16 x i8> %1, <16 x i8> %2, <24 x i32> <i32 0, i32 8, i32 16, i32 1, i32 9, i32 17, i32 2, i32 10, i32 18, i32 3, i32 11, i32 19, i32 4, i32 12, i32 20, i32 5, i32 13, i32 21, i32 6, i32 14, i32 22, i32 7, i32 15, i32 23>
store <24 x i8> %interleaved.vec, <24 x i8>* %p, align 1
ret void
}

define void @interleaved_store_vf16_i8_stride3(<16 x i8> %a, <16 x i8> %b, <16 x i8> %c, <48 x i8>* %p) {
; CHECK-LABEL: @interleaved_store_vf16_i8_stride3(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> [[B:%.*]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i8> [[C:%.*]], <16 x i8> undef, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[INTERLEAVED_VEC:%.*]] = shufflevector <32 x i8> [[TMP1]], <32 x i8> [[TMP2]], <48 x i32> <i32 0, i32 16, i32 32, i32 1, i32 17, i32 33, i32 2, i32 18, i32 34, i32 3, i32 19, i32 35, i32 4, i32 20, i32 36, i32 5, i32 21, i32 37, i32 6, i32 22, i32 38, i32 7, i32 23, i32 39, i32 8, i32 24, i32 40, i32 9, i32 25, i32 41, i32 10, i32 26, i32 42, i32 11, i32 27, i32 43, i32 12, i32 28, i32 44, i32 13, i32 29, i32 45, i32 14, i32 30, i32 46, i32 15, i32 31, i32 47>
; CHECK-NEXT:    store <48 x i8> [[INTERLEAVED_VEC]], <48 x i8>* [[P:%.*]], align 1
; CHECK-NEXT:    ret void
;
%1 = shufflevector <16 x i8> %a, <16 x i8> %b, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
%2 = shufflevector <16 x i8> %c, <16 x i8> undef, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
%interleaved.vec = shufflevector <32 x i8> %1, <32 x i8> %2, <48 x i32> <i32 0, i32 16, i32 32, i32 1, i32 17, i32 33, i32 2, i32 18, i32 34, i32 3, i32 19, i32 35, i32 4, i32 20, i32 36, i32 5, i32 21, i32 37, i32 6, i32 22, i32 38, i32 7, i32 23, i32 39, i32 8, i32 24, i32 40, i32 9, i32 25, i32 41, i32 10, i32 26, i32 42, i32 11, i32 27, i32 43, i32 12, i32 28, i32 44, i32 13, i32 29, i32 45, i32 14, i32 30, i32 46, i32 15, i32 31, i32 47>
store <48 x i8> %interleaved.vec, <48 x i8>* %p, align 1
ret void
}

define void @interleaved_store_vf32_i8_stride3(<32 x i8> %a, <32 x i8> %b, <32 x i8> %c, <96 x i8>* %p) {
; CHECK-LABEL: @interleaved_store_vf32_i8_stride3(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <32 x i8> [[A:%.*]], <32 x i8> [[B:%.*]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <32 x i8> [[C:%.*]], <32 x i8> undef, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[INTERLEAVED_VEC:%.*]] = shufflevector <64 x i8> [[TMP1]], <64 x i8> [[TMP2]], <96 x i32> <i32 0, i32 32, i32 64, i32 1, i32 33, i32 65, i32 2, i32 34, i32 66, i32 3, i32 35, i32 67, i32 4, i32 36, i32 68, i32 5, i32 37, i32 69, i32 6, i32 38, i32 70, i32 7, i32 39, i32 71, i32 8, i32 40, i32 72, i32 9, i32 41, i32 73, i32 10, i32 42, i32 74, i32 11, i32 43, i32 75, i32 12, i32 44, i32 76, i32 13, i32 45, i32 77, i32 14, i32 46, i32 78, i32 15, i32 47, i32 79, i32 16, i32 48, i32 80, i32 17, i32 49, i32 81, i32 18, i32 50, i32 82, i32 19, i32 51, i32 83, i32 20, i32 52, i32 84, i32 21, i32 53, i32 85, i32 22, i32 54, i32 86, i32 23, i32 55, i32 87, i32 24, i32 56, i32 88, i32 25, i32 57, i32 89, i32 26, i32 58, i32 90, i32 27, i32 59, i32 91, i32 28, i32 60, i32 92, i32 29, i32 61, i32 93, i32 30, i32 62, i32 94, i32 31, i32 63, i32 95>
; CHECK-NEXT:    store <96 x i8> [[INTERLEAVED_VEC]], <96 x i8>* [[P:%.*]], align 1
; CHECK-NEXT:    ret void
;
%1 = shufflevector <32 x i8> %a, <32 x i8> %b, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
%2 = shufflevector <32 x i8> %c, <32 x i8> undef, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
%interleaved.vec = shufflevector <64 x i8> %1, <64 x i8> %2, <96 x i32> <i32 0, i32 32, i32 64, i32 1, i32 33, i32 65, i32 2, i32 34, i32 66, i32 3, i32 35, i32 67, i32 4, i32 36, i32 68, i32 5, i32 37, i32 69, i32 6, i32 38, i32 70, i32 7, i32 39, i32 71, i32 8, i32 40, i32 72, i32 9, i32 41, i32 73, i32 10, i32 42, i32 74, i32 11, i32 43, i32 75, i32 12, i32 44, i32 76, i32 13, i32 45, i32 77, i32 14, i32 46, i32 78, i32 15, i32 47, i32 79, i32 16, i32 48, i32 80, i32 17, i32 49, i32 81, i32 18, i32 50, i32 82, i32 19, i32 51, i32 83, i32 20, i32 52, i32 84, i32 21, i32 53, i32 85, i32 22, i32 54, i32 86, i32 23, i32 55, i32 87, i32 24, i32 56, i32 88, i32 25, i32 57, i32 89, i32 26, i32 58, i32 90, i32 27, i32 59, i32 91, i32 28, i32 60, i32 92, i32 29, i32 61, i32 93, i32 30, i32 62, i32 94, i32 31, i32 63, i32 95>
store <96 x i8> %interleaved.vec, <96 x i8>* %p, align 1
ret void
}

define void @interleaved_store_vf64_i8_stride3(<64 x i8> %a, <64 x i8> %b, <64 x i8> %c, <192 x i8>* %p) {
; CHECK-LABEL: @interleaved_store_vf64_i8_stride3(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <64 x i8> [[A:%.*]], <64 x i8> [[B:%.*]], <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <64 x i8> [[C:%.*]], <64 x i8> undef, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <128 x i8> [[TMP1]], <128 x i8> [[TMP2]], <192 x i32> <i32 0, i32 64, i32 128, i32 1, i32 65, i32 129, i32 2, i32 66, i32 130, i32 3, i32 67, i32 131, i32 4, i32 68, i32 132, i32 5, i32 69, i32 133, i32 6, i32 70, i32 134, i32 7, i32 71, i32 135, i32 8, i32 72, i32 136, i32 9, i32 73, i32 137, i32 10, i32 74, i32 138, i32 11, i32 75, i32 139, i32 12, i32 76, i32 140, i32 13, i32 77, i32 141, i32 14, i32 78, i32 142, i32 15, i32 79, i32 143, i32 16, i32 80, i32 144, i32 17, i32 81, i32 145, i32 18, i32 82, i32 146, i32 19, i32 83, i32 147, i32 20, i32 84, i32 148, i32 21, i32 85, i32 149, i32 22, i32 86, i32 150, i32 23, i32 87, i32 151, i32 24, i32 88, i32 152, i32 25, i32 89, i32 153, i32 26, i32 90, i32 154, i32 27, i32 91, i32 155, i32 28, i32 92, i32 156, i32 29, i32 93, i32 157, i32 30, i32 94, i32 158, i32 31, i32 95, i32 159, i32 32, i32 96, i32 160, i32 33, i32 97, i32 161, i32 34, i32 98, i32 162, i32 35, i32 99, i32 163, i32 36, i32 100, i32 164, i32 37, i32 101, i32 165, i32 38, i32 102, i32 166, i32 39, i32 103, i32 167, i32 40, i32 104, i32 168, i32 41, i32 105, i32 169, i32 42, i32 106, i32 170, i32 43, i32 107, i32 171, i32 44, i32 108, i32 172, i32 45, i32 109, i32 173, i32 46, i32 110, i32 174, i32 47, i32 111, i32 175, i32 48, i32 112, i32 176, i32 49, i32 113, i32 177, i32 50, i32 114, i32 178, i32 51, i32 115, i32 179, i32 52, i32 116, i32 180, i32 53, i32 117, i32 181, i32 54, i32 118, i32 182, i32 55, i32 119, i32 183, i32 56, i32 120, i32 184, i32 57, i32 121, i32 185, i32 58, i32 122, i32 186, i32 59, i32 123, i32 187, i32 60, i32 124, i32 188, i32 61, i32 125, i32 189, i32 62, i32 126, i32 190, i32 63, i32 127, i32 191>
; CHECK-NEXT:    store <192 x i8> [[TMP3]], <192 x i8>* [[P:%.*]], align 1
; CHECK-NEXT:    ret void
;
%1 = shufflevector <64 x i8> %a, <64 x i8> %b, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
%2 = shufflevector <64 x i8> %c, <64 x i8> undef, <128 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
%3 = shufflevector <128 x i8> %1, <128 x i8> %2, <192 x i32> <i32 0, i32 64, i32 128, i32 1, i32 65, i32 129, i32 2, i32 66, i32 130, i32 3, i32 67, i32 131, i32 4, i32 68, i32 132, i32 5, i32 69, i32 133, i32 6, i32 70, i32 134, i32 7, i32 71, i32 135, i32 8, i32 72, i32 136, i32 9, i32 73, i32 137, i32 10, i32 74, i32 138, i32 11, i32 75, i32 139, i32 12, i32 76, i32 140, i32 13, i32 77, i32 141, i32 14, i32 78, i32 142, i32 15, i32 79, i32 143, i32 16, i32 80, i32 144, i32 17, i32 81, i32 145, i32 18, i32 82, i32 146, i32 19, i32 83, i32 147, i32 20, i32 84, i32 148, i32 21, i32 85, i32 149, i32 22, i32 86, i32 150, i32 23, i32 87, i32 151, i32 24, i32 88, i32 152, i32 25, i32 89, i32 153, i32 26, i32 90, i32 154, i32 27, i32 91, i32 155, i32 28, i32 92, i32 156, i32 29, i32 93, i32 157, i32 30, i32 94, i32 158, i32 31, i32 95, i32 159, i32 32, i32 96, i32 160, i32 33, i32 97, i32 161, i32 34, i32 98, i32 162, i32 35, i32 99, i32 163, i32 36, i32 100, i32 164, i32 37, i32 101, i32 165, i32 38, i32 102, i32 166, i32 39, i32 103, i32 167, i32 40, i32 104, i32 168, i32 41, i32 105, i32 169, i32 42, i32 106, i32 170, i32 43, i32 107, i32 171, i32 44, i32 108, i32 172, i32 45, i32 109, i32 173, i32 46, i32 110, i32 174, i32 47, i32 111, i32 175, i32 48, i32 112, i32 176, i32 49, i32 113, i32 177, i32 50, i32 114, i32 178, i32 51, i32 115, i32 179, i32 52, i32 116, i32 180, i32 53, i32 117, i32 181, i32 54, i32 118, i32 182, i32 55, i32 119, i32 183, i32 56, i32 120, i32 184, i32 57, i32 121, i32 185, i32 58, i32 122, i32 186, i32 59, i32 123, i32 187, i32 60, i32 124, i32 188, i32 61, i32 125, i32 189, i32 62, i32 126, i32 190, i32 63, i32 127, i32 191>
store <192 x i8> %3, <192 x i8>* %p, align 1
ret void
}

