; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon < %s | FileCheck %s

define <64 x i8> @test_00(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_00:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v0,v0,r7)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <64 x i8> %v0
}

define <64 x i8> @test_01(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_01:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  ret <64 x i8> %v0
}

define <64 x i8> @test_02(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_02:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v1,v0,r7)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>
  ret <64 x i8> %v0
}

define <64 x i8> @test_03(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_03:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vsetq(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v0,v1)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
  ret <64 x i8> %v0
}

define <64 x i8> @test_04(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_04:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vror(v0,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <64 x i8> %v0
}

define <64 x i8> @test_05(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_05:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v0,v0,r7)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  ret <64 x i8> %v0
}

define <64 x i8> @test_06(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_06:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = valign(v1,v0,r7)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>
  ret <64 x i8> %v0
}

define <64 x i8> @test_07(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_07:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v1,v0,r7)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
  ret <64 x i8> %v0
}

define <64 x i8> @test_08(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_08:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v0,v1,r7)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <64 x i8> %v0
}

define <64 x i8> @test_09(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_09:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vsetq(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v1,v0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  ret <64 x i8> %v0
}

define <64 x i8> @test_10(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v1,v1,r7)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>
  ret <64 x i8> %v0
}

define <64 x i8> @test_11(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_11:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
  ret <64 x i8> %v0
}

define <64 x i8> @test_12(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = valign(v0,v1,r7)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  ret <64 x i8> %v0
}

define <64 x i8> @test_13(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_13:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v0,v1,r7)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  ret <64 x i8> %v0
}

define <64 x i8> @test_14(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_14:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vror(v1,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95>
  ret <64 x i8> %v0
}

define <64 x i8> @test_15(<64 x i8> %a0, <64 x i8> %a1) #0 {
; CHECK-LABEL: test_15:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r7 = #32
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0 = vshuff(v1,v1,r7)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> %a1, <64 x i32> <i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127>
  ret <64 x i8> %v0
}

attributes #0 = { nounwind readnone "target-features"="+hvx,+hvx-length64b" }
