; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512vnni --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vnni --show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64

declare <16 x i32> @llvm.x86.avx512.vpdpbusd.512(<16 x i32>, <16 x i32>, <16 x i32>)

define <16 x i32> @test_int_x86_avx512_ask_vpdpbusd_512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2) {
; CHECK-LABEL: test_int_x86_avx512_ask_vpdpbusd_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpdpbusd %zmm2, %zmm1, %zmm0 # encoding: [0x62,0xf2,0x75,0x48,0x50,0xc2]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpbusd.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  ret <16 x i32> %1
}

define { <16 x i32>, <16 x i32> } @test_int_x86_avx512_mask_vpdpbusd_512(<16 x i32> %x0, <16 x i32> %x1, ptr %x2p, <16 x i32> %x4, i16 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpdpbusd_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1 # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x08]
; X86-NEXT:    vpdpbusd (%eax), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x50,0x00]
; X86-NEXT:    vpdpbusd %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x50,0xda]
; X86-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpdpbusd_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpdpbusd (%rdi), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x50,0x07]
; X64-NEXT:    vpdpbusd %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x50,0xda]
; X64-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <16 x i32>, ptr %x2p
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpbusd.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  %2 = bitcast i16 %x3 to <16 x i1>
  %3 = select <16 x i1> %2, <16 x i32> %1, <16 x i32> %x0
  %4 = call <16 x i32> @llvm.x86.avx512.vpdpbusd.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x4)
  %5 = bitcast i16 %x3 to <16 x i1>
  %6 = select <16 x i1> %5, <16 x i32> %4, <16 x i32> zeroinitializer
  %res1 = insertvalue { <16 x i32>, <16 x i32> } poison, <16 x i32> %3, 0
  %res2 = insertvalue { <16 x i32>, <16 x i32> }  %res1, <16 x i32> %6, 1
  ret { <16 x i32>, <16 x i32> } %res2
}

declare <16 x i32> @llvm.x86.avx512.vpdpbusds.512(<16 x i32>, <16 x i32>, <16 x i32>)

define <16 x i32>@test_int_x86_avx512_vpdpbusds_512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2) {
; CHECK-LABEL: test_int_x86_avx512_vpdpbusds_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpdpbusds %zmm2, %zmm1, %zmm0 # encoding: [0x62,0xf2,0x75,0x48,0x51,0xc2]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpbusds.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  ret <16 x i32> %1
}

define { <16 x i32>, <16 x i32> } @test_int_x86_avx512_mask_vpdpbusds_512(<16 x i32> %x0, <16 x i32> %x1, ptr %x2p, <16 x i32> %x4, i16 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpdpbusds_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1 # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x08]
; X86-NEXT:    vpdpbusds (%eax), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x51,0x00]
; X86-NEXT:    vpdpbusds %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x51,0xda]
; X86-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpdpbusds_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpdpbusds (%rdi), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x51,0x07]
; X64-NEXT:    vpdpbusds %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x51,0xda]
; X64-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <16 x i32>, ptr %x2p
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpbusds.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  %2 = bitcast i16 %x3 to <16 x i1>
  %3 = select <16 x i1> %2, <16 x i32> %1, <16 x i32> %x0
  %4 = call <16 x i32> @llvm.x86.avx512.vpdpbusds.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x4)
  %5 = bitcast i16 %x3 to <16 x i1>
  %6 = select <16 x i1> %5, <16 x i32> %4, <16 x i32> zeroinitializer
  %res1 = insertvalue { <16 x i32>, <16 x i32> } poison, <16 x i32> %3, 0
  %res2 = insertvalue { <16 x i32>, <16 x i32> }  %res1, <16 x i32> %6, 1
  ret { <16 x i32>, <16 x i32> } %res2
}

declare <16 x i32> @llvm.x86.avx512.vpdpwssd.512(<16 x i32>, <16 x i32>, <16 x i32>)

define <16 x i32>@test_int_x86_avx512_vpdpwssd_512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2) {
; CHECK-LABEL: test_int_x86_avx512_vpdpwssd_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpdpwssd %zmm2, %zmm1, %zmm0 # encoding: [0x62,0xf2,0x75,0x48,0x52,0xc2]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpwssd.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  ret <16 x i32> %1
}

define { <16 x i32>, <16 x i32> } @test_int_x86_avx512_mask_vpdpwssd_512(<16 x i32> %x0, <16 x i32> %x1, ptr %x2p, <16 x i32> %x4, i16 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpdpwssd_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1 # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x08]
; X86-NEXT:    vpdpwssd (%eax), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x52,0x00]
; X86-NEXT:    vpdpwssd %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x52,0xda]
; X86-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpdpwssd_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpdpwssd (%rdi), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x52,0x07]
; X64-NEXT:    vpdpwssd %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x52,0xda]
; X64-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <16 x i32>, ptr %x2p
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpwssd.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  %2 = bitcast i16 %x3 to <16 x i1>
  %3 = select <16 x i1> %2, <16 x i32> %1, <16 x i32> %x0
  %4 = call <16 x i32> @llvm.x86.avx512.vpdpwssd.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x4)
  %5 = bitcast i16 %x3 to <16 x i1>
  %6 = select <16 x i1> %5, <16 x i32> %4, <16 x i32> zeroinitializer
  %res1 = insertvalue { <16 x i32>, <16 x i32> } poison, <16 x i32> %3, 0
  %res2 = insertvalue { <16 x i32>, <16 x i32> }  %res1, <16 x i32> %6, 1
  ret { <16 x i32>, <16 x i32> } %res2
}

declare <16 x i32> @llvm.x86.avx512.vpdpwssds.512(<16 x i32>, <16 x i32>, <16 x i32>)

define <16 x i32>@test_int_x86_avx512_ask_vpdpwssds_512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2) {
; CHECK-LABEL: test_int_x86_avx512_ask_vpdpwssds_512:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpdpwssds %zmm2, %zmm1, %zmm0 # encoding: [0x62,0xf2,0x75,0x48,0x53,0xc2]
; CHECK-NEXT:    ret{{[l|q]}} # encoding: [0xc3]
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpwssds.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  ret <16 x i32> %1
}

define { <16 x i32>, <16 x i32> } @test_int_x86_avx512_mask_vpdpwssds_512(<16 x i32> %x0, <16 x i32> %x1, ptr %x2p, <16 x i32> %x4, i16 %x3) {
; X86-LABEL: test_int_x86_avx512_mask_vpdpwssds_512:
; X86:       # %bb.0:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1 # encoding: [0xc5,0xf8,0x90,0x4c,0x24,0x08]
; X86-NEXT:    vpdpwssds (%eax), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x53,0x00]
; X86-NEXT:    vpdpwssds %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x53,0xda]
; X86-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx512_mask_vpdpwssds_512:
; X64:       # %bb.0:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm3 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xd8]
; X64-NEXT:    kmovw %esi, %k1 # encoding: [0xc5,0xf8,0x92,0xce]
; X64-NEXT:    vpdpwssds (%rdi), %zmm1, %zmm0 {%k1} # encoding: [0x62,0xf2,0x75,0x49,0x53,0x07]
; X64-NEXT:    vpdpwssds %zmm2, %zmm1, %zmm3 {%k1} {z} # encoding: [0x62,0xf2,0x75,0xc9,0x53,0xda]
; X64-NEXT:    vmovdqa64 %zmm3, %zmm1 # encoding: [0x62,0xf1,0xfd,0x48,0x6f,0xcb]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <16 x i32>, ptr %x2p
  %1 = call <16 x i32> @llvm.x86.avx512.vpdpwssds.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x2)
  %2 = bitcast i16 %x3 to <16 x i1>
  %3 = select <16 x i1> %2, <16 x i32> %1, <16 x i32> %x0
  %4 = call <16 x i32> @llvm.x86.avx512.vpdpwssds.512(<16 x i32> %x0, <16 x i32> %x1, <16 x i32> %x4)
  %5 = bitcast i16 %x3 to <16 x i1>
  %6 = select <16 x i1> %5, <16 x i32> %4, <16 x i32> zeroinitializer
  %res1 = insertvalue { <16 x i32>, <16 x i32> } poison, <16 x i32> %3, 0
  %res2 = insertvalue { <16 x i32>, <16 x i32> }  %res1, <16 x i32> %6, 1
  ret { <16 x i32>, <16 x i32> } %res2
}
