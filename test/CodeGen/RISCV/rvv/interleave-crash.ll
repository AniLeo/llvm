; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -O1 -mattr=+m,+experimental-v -riscv-v-vector-bits-min=1024 < %s | FileCheck %s --check-prefix=RV64-1024

define void @interleave256(<256 x i16>* %agg.result, <128 x i16>* %0, <128 x i16>* %1) {
; RV64-1024-LABEL: interleave256:
; RV64-1024:       # %bb.0: # %entry
; RV64-1024-NEXT:    addi a3, zero, 128
; RV64-1024-NEXT:    vsetvli a4, a3, e16,m2,ta,mu
; RV64-1024-NEXT:    vle16.v v12, (a1)
; RV64-1024-NEXT:    vle16.v v8, (a2)
; RV64-1024-NEXT:    addi a1, zero, 256
; RV64-1024-NEXT:    vsetvli a2, a1, e16,m4,ta,mu
; RV64-1024-NEXT:    vmv.v.i v28, 0
; RV64-1024-NEXT:    vsetvli a2, a3, e16,m4,tu,mu
; RV64-1024-NEXT:    vmv4r.v v16, v28
; RV64-1024-NEXT:    vslideup.vi v16, v12, 0
; RV64-1024-NEXT:    vsetvli a2, a3, e16,m2,ta,mu
; RV64-1024-NEXT:    vmv.v.i v12, 0
; RV64-1024-NEXT:    vsetvli a2, a1, e16,m4,tu,mu
; RV64-1024-NEXT:    vslideup.vx v16, v12, a3
; RV64-1024-NEXT:    lui a2, %hi(.LCPI0_0)
; RV64-1024-NEXT:    addi a2, a2, %lo(.LCPI0_0)
; RV64-1024-NEXT:    vsetvli a4, a1, e16,m4,ta,mu
; RV64-1024-NEXT:    vle16.v v20, (a2)
; RV64-1024-NEXT:    vrgather.vv v24, v16, v20
; RV64-1024-NEXT:    vsetvli a2, a3, e16,m4,tu,mu
; RV64-1024-NEXT:    vslideup.vi v28, v8, 0
; RV64-1024-NEXT:    vsetvli a2, a1, e16,m4,tu,mu
; RV64-1024-NEXT:    vslideup.vx v28, v12, a3
; RV64-1024-NEXT:    lui a2, %hi(.LCPI0_1)
; RV64-1024-NEXT:    addi a2, a2, %lo(.LCPI0_1)
; RV64-1024-NEXT:    vsetvli a3, a1, e16,m4,ta,mu
; RV64-1024-NEXT:    vle16.v v12, (a2)
; RV64-1024-NEXT:    vrgather.vv v8, v24, v12
; RV64-1024-NEXT:    lui a2, 1026731
; RV64-1024-NEXT:    addiw a2, a2, -1365
; RV64-1024-NEXT:    slli a2, a2, 12
; RV64-1024-NEXT:    addi a2, a2, -1365
; RV64-1024-NEXT:    slli a2, a2, 12
; RV64-1024-NEXT:    addi a2, a2, -1365
; RV64-1024-NEXT:    slli a2, a2, 12
; RV64-1024-NEXT:    addi a2, a2, -1366
; RV64-1024-NEXT:    vsetivli a3, 4, e64,m1,ta,mu
; RV64-1024-NEXT:    vmv.s.x v25, a2
; RV64-1024-NEXT:    vsetivli a2, 2, e64,m1,tu,mu
; RV64-1024-NEXT:    vmv1r.v v0, v25
; RV64-1024-NEXT:    vslideup.vi v0, v25, 1
; RV64-1024-NEXT:    vsetivli a2, 3, e64,m1,tu,mu
; RV64-1024-NEXT:    vslideup.vi v0, v25, 2
; RV64-1024-NEXT:    vsetivli a2, 4, e64,m1,tu,mu
; RV64-1024-NEXT:    vslideup.vi v0, v25, 3
; RV64-1024-NEXT:    lui a2, %hi(.LCPI0_2)
; RV64-1024-NEXT:    addi a2, a2, %lo(.LCPI0_2)
; RV64-1024-NEXT:    vsetvli a3, a1, e16,m4,ta,mu
; RV64-1024-NEXT:    vle16.v v12, (a2)
; RV64-1024-NEXT:    vsetvli a2, a1, e16,m4,tu,mu
; RV64-1024-NEXT:    vrgather.vv v8, v28, v12, v0.t
; RV64-1024-NEXT:    vsetvli a1, a1, e16,m4,ta,mu
; RV64-1024-NEXT:    vse16.v v8, (a0)
; RV64-1024-NEXT:    ret
entry:
  %ve = load <128 x i16>, <128 x i16>* %0, align 256
  %vo = load <128 x i16>, <128 x i16>* %1, align 256
  %2 = shufflevector <128 x i16> %ve, <128 x i16> poison, <256 x i32> <i32 0, i32 undef, i32 1, i32 undef, i32 2, i32 undef, i32 3, i32 undef, i32 4, i32 undef, i32 5, i32 undef, i32 6, i32 undef, i32 7, i32 undef, i32 8, i32 undef, i32 9, i32 undef, i32 10, i32 undef, i32 11, i32 undef, i32 12, i32 undef, i32 13, i32 undef, i32 14, i32 undef, i32 15, i32 undef, i32 16, i32 undef, i32 17, i32 undef, i32 18, i32 undef, i32 19, i32 undef, i32 20, i32 undef, i32 21, i32 undef, i32 22, i32 undef, i32 23, i32 undef, i32 24, i32 undef, i32 25, i32 undef, i32 26, i32 undef, i32 27, i32 undef, i32 28, i32 undef, i32 29, i32 undef, i32 30, i32 undef, i32 31, i32 undef, i32 32, i32 undef, i32 33, i32 undef, i32 34, i32 undef, i32 35, i32 undef, i32 36, i32 undef, i32 37, i32 undef, i32 38, i32 undef, i32 39, i32 undef, i32 40, i32 undef, i32 41, i32 undef, i32 42, i32 undef, i32 43, i32 undef, i32 44, i32 undef, i32 45, i32 undef, i32 46, i32 undef, i32 47, i32 undef, i32 48, i32 undef, i32 49, i32 undef, i32 50, i32 undef, i32 51, i32 undef, i32 52, i32 undef, i32 53, i32 undef, i32 54, i32 undef, i32 55, i32 undef, i32 56, i32 undef, i32 57, i32 undef, i32 58, i32 undef, i32 59, i32 undef, i32 60, i32 undef, i32 61, i32 undef, i32 62, i32 undef, i32 63, i32 undef, i32 64, i32 undef, i32 65, i32 undef, i32 66, i32 undef, i32 67, i32 undef, i32 68, i32 undef, i32 69, i32 undef, i32 70, i32 undef, i32 71, i32 undef, i32 72, i32 undef, i32 73, i32 undef, i32 74, i32 undef, i32 75, i32 undef, i32 76, i32 undef, i32 77, i32 undef, i32 78, i32 undef, i32 79, i32 undef, i32 80, i32 undef, i32 81, i32 undef, i32 82, i32 undef, i32 83, i32 undef, i32 84, i32 undef, i32 85, i32 undef, i32 86, i32 undef, i32 87, i32 undef, i32 88, i32 undef, i32 89, i32 undef, i32 90, i32 undef, i32 91, i32 undef, i32 92, i32 undef, i32 93, i32 undef, i32 94, i32 undef, i32 95, i32 undef, i32 96, i32 undef, i32 97, i32 undef, i32 98, i32 undef, i32 99, i32 undef, i32 100, i32 undef, i32 101, i32 undef, i32 102, i32 undef, i32 103, i32 undef, i32 104, i32 undef, i32 105, i32 undef, i32 106, i32 undef, i32 107, i32 undef, i32 108, i32 undef, i32 109, i32 undef, i32 110, i32 undef, i32 111, i32 undef, i32 112, i32 undef, i32 113, i32 undef, i32 114, i32 undef, i32 115, i32 undef, i32 116, i32 undef, i32 117, i32 undef, i32 118, i32 undef, i32 119, i32 undef, i32 120, i32 undef, i32 121, i32 undef, i32 122, i32 undef, i32 123, i32 undef, i32 124, i32 undef, i32 125, i32 undef, i32 126, i32 undef, i32 127, i32 undef>
  %3 = shufflevector <128 x i16> %vo, <128 x i16> poison, <256 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 75, i32 76, i32 77, i32 78, i32 79, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 91, i32 92, i32 93, i32 94, i32 95, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 107, i32 108, i32 109, i32 110, i32 111, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122, i32 123, i32 124, i32 125, i32 126, i32 127, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %4 = shufflevector <256 x i16> %2, <256 x i16> %3, <256 x i32> <i32 0, i32 256, i32 2, i32 257, i32 4, i32 258, i32 6, i32 259, i32 8, i32 260, i32 10, i32 261, i32 12, i32 262, i32 14, i32 263, i32 16, i32 264, i32 18, i32 265, i32 20, i32 266, i32 22, i32 267, i32 24, i32 268, i32 26, i32 269, i32 28, i32 270, i32 30, i32 271, i32 32, i32 272, i32 34, i32 273, i32 36, i32 274, i32 38, i32 275, i32 40, i32 276, i32 42, i32 277, i32 44, i32 278, i32 46, i32 279, i32 48, i32 280, i32 50, i32 281, i32 52, i32 282, i32 54, i32 283, i32 56, i32 284, i32 58, i32 285, i32 60, i32 286, i32 62, i32 287, i32 64, i32 288, i32 66, i32 289, i32 68, i32 290, i32 70, i32 291, i32 72, i32 292, i32 74, i32 293, i32 76, i32 294, i32 78, i32 295, i32 80, i32 296, i32 82, i32 297, i32 84, i32 298, i32 86, i32 299, i32 88, i32 300, i32 90, i32 301, i32 92, i32 302, i32 94, i32 303, i32 96, i32 304, i32 98, i32 305, i32 100, i32 306, i32 102, i32 307, i32 104, i32 308, i32 106, i32 309, i32 108, i32 310, i32 110, i32 311, i32 112, i32 312, i32 114, i32 313, i32 116, i32 314, i32 118, i32 315, i32 120, i32 316, i32 122, i32 317, i32 124, i32 318, i32 126, i32 319, i32 128, i32 320, i32 130, i32 321, i32 132, i32 322, i32 134, i32 323, i32 136, i32 324, i32 138, i32 325, i32 140, i32 326, i32 142, i32 327, i32 144, i32 328, i32 146, i32 329, i32 148, i32 330, i32 150, i32 331, i32 152, i32 332, i32 154, i32 333, i32 156, i32 334, i32 158, i32 335, i32 160, i32 336, i32 162, i32 337, i32 164, i32 338, i32 166, i32 339, i32 168, i32 340, i32 170, i32 341, i32 172, i32 342, i32 174, i32 343, i32 176, i32 344, i32 178, i32 345, i32 180, i32 346, i32 182, i32 347, i32 184, i32 348, i32 186, i32 349, i32 188, i32 350, i32 190, i32 351, i32 192, i32 352, i32 194, i32 353, i32 196, i32 354, i32 198, i32 355, i32 200, i32 356, i32 202, i32 357, i32 204, i32 358, i32 206, i32 359, i32 208, i32 360, i32 210, i32 361, i32 212, i32 362, i32 214, i32 363, i32 216, i32 364, i32 218, i32 365, i32 220, i32 366, i32 222, i32 367, i32 224, i32 368, i32 226, i32 369, i32 228, i32 370, i32 230, i32 371, i32 232, i32 372, i32 234, i32 373, i32 236, i32 374, i32 238, i32 375, i32 240, i32 376, i32 242, i32 377, i32 244, i32 378, i32 246, i32 379, i32 248, i32 380, i32 250, i32 381, i32 252, i32 382, i32 254, i32 383>
  store <256 x i16> %4, <256 x i16>* %agg.result, align 512
  ret void
}
