; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,X64

define <16 x float> @PR45443() {
; X86-LABEL: PR45443:
; X86:       # %bb.0: # %bb
; X86-NEXT:    vpbroadcastd {{.*#+}} zmm1 = [2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080]
; X86-NEXT:    vfmadd231ps {{.*#+}} zmm0 = (zmm0 * mem) + zmm0
; X86-NEXT:    vpcmpltud {{\.LCPI.*}}{1to16}, %zmm1, %k1
; X86-NEXT:    vpbroadcastd {{.*#+}} ymm2 = [16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215]
; X86-NEXT:    vpand %ymm2, %ymm1, %ymm1
; X86-NEXT:    vinserti64x4 $1, %ymm1, %zmm1, %zmm1
; X86-NEXT:    vptestmd %zmm1, %zmm1, %k1 {%k1}
; X86-NEXT:    vbroadcastss {{\.LCPI.*}}, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: PR45443:
; X64:       # %bb.0: # %bb
; X64-NEXT:    vpbroadcastd {{.*#+}} zmm1 = [2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080,2181038080]
; X64-NEXT:    vfmadd231ps {{.*#+}} zmm0 = (zmm0 * mem) + zmm0
; X64-NEXT:    vpcmpltud {{.*}}(%rip){1to16}, %zmm1, %k1
; X64-NEXT:    vpbroadcastd {{.*#+}} ymm2 = [16777215,16777215,16777215,16777215,16777215,16777215,16777215,16777215]
; X64-NEXT:    vpand %ymm2, %ymm1, %ymm1
; X64-NEXT:    vinserti64x4 $1, %ymm1, %zmm1, %zmm1
; X64-NEXT:    vptestmd %zmm1, %zmm1, %k1 {%k1}
; X64-NEXT:    vbroadcastss {{.*}}(%rip), %zmm0 {%k1}
; X64-NEXT:    retq
bb:
  %tmp = tail call <16 x i32> @llvm.x86.avx512.psll.d.512(<16 x i32> <i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040, i32 1090519040>, <4 x i32> <i32 1, i32 0, i32 undef, i32 undef>)
  %tmp4 = tail call fast <16 x float> @llvm.fma.v16f32(<16 x float> undef, <16 x float> <float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000, float 0x3FE6300000000000>, <16 x float> undef)
  %tmp5 = icmp ult <16 x i32> %tmp, <i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216, i32 16777216>
  %tmp6 = and <16 x i32> %tmp, <i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215, i32 16777215>
  %tmp7 = icmp ne <16 x i32> %tmp6, zeroinitializer
  %tmp8 = and <16 x i1> %tmp7, %tmp5
  %tmp9 = select fast <16 x i1> %tmp8, <16 x float> <float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000, float 0xFFF0000000000000>, <16 x float> %tmp4
  ret <16 x float> %tmp9
}
declare <16 x float> @llvm.fma.v16f32(<16 x float>, <16 x float>, <16 x float>)
declare <16 x i32> @llvm.x86.avx512.psll.d.512(<16 x i32>, <4 x i32>)
