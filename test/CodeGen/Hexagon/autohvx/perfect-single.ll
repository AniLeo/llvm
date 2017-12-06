; RUN: llc -march=hexagon < %s | FileCheck %s

; CHECK-LABEL: perfect_single_64:
; CHECK: vdeal
; CHECK-NOT: delta
define <64 x i8> @perfect_single_64(<64 x i8> %v0) #0 {
  %p = shufflevector <64 x i8> %v0, <64 x i8> undef, <64 x i32> <i32 0, i32 32, i32 2, i32 34, i32 4, i32 36, i32 6, i32 38, i32 8, i32 40, i32 10, i32 42, i32 12, i32 44, i32 14, i32 46, i32 16, i32 48, i32 18, i32 50, i32 20, i32 52, i32 22, i32 54, i32 24, i32 56, i32 26, i32 58, i32 28, i32 60, i32 30, i32 62, i32 1, i32 33, i32 3, i32 35, i32 5, i32 37, i32 7, i32 39, i32 9, i32 41, i32 11, i32 43, i32 13, i32 45, i32 15, i32 47, i32 17, i32 49, i32 19, i32 51, i32 21, i32 53, i32 23, i32 55, i32 25, i32 57, i32 27, i32 59, i32 29, i32 61, i32 31, i32 63>
  ret <64 x i8> %p
}

; CHECK-LABEL: perfect_single_128:
; CHECK: vdeal
; CHECK-NOT: delta
define <128 x i8> @perfect_single_128(<128 x i8> %v0) #1 {
  %p = shufflevector <128 x i8> %v0, <128 x i8> undef, <128 x i32> <i32 0, i32 64, i32 2, i32 66, i32 4, i32 68, i32 6, i32 70, i32 8, i32 72, i32 10, i32 74, i32 12, i32 76, i32 14, i32 78, i32 16, i32 80, i32 18, i32 82, i32 20, i32 84, i32 22, i32 86, i32 24, i32 88, i32 26, i32 90, i32 28, i32 92, i32 30, i32 94, i32 32, i32 96, i32 34, i32 98, i32 36, i32 100, i32 38, i32 102, i32 40, i32 104, i32 42, i32 106, i32 44, i32 108, i32 46, i32 110, i32 48, i32 112, i32 50, i32 114, i32 52, i32 116, i32 54, i32 118, i32 56, i32 120, i32 58, i32 122, i32 60, i32 124, i32 62, i32 126, i32 1, i32 65, i32 3, i32 67, i32 5, i32 69, i32 7, i32 71, i32 9, i32 73, i32 11, i32 75, i32 13, i32 77, i32 15, i32 79, i32 17, i32 81, i32 19, i32 83, i32 21, i32 85, i32 23, i32 87, i32 25, i32 89, i32 27, i32 91, i32 29, i32 93, i32 31, i32 95, i32 33, i32 97, i32 35, i32 99, i32 37, i32 101, i32 39, i32 103, i32 41, i32 105, i32 43, i32 107, i32 45, i32 109, i32 47, i32 111, i32 49, i32 113, i32 51, i32 115, i32 53, i32 117, i32 55, i32 119, i32 57, i32 121, i32 59, i32 123, i32 61, i32 125, i32 63, i32 127>
  ret <128 x i8> %p
}

attributes #0 = { readnone nounwind "target-cpu"="hexagonv60" "target-features"="+hvx,+hvx-length64b" }
attributes #1 = { readnone nounwind "target-cpu"="hexagonv60" "target-features"="+hvx,+hvx-length128b" }
