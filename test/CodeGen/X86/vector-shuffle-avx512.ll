; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux-gnu -mcpu=skx | FileCheck %s --check-prefixes=CHECK,SKX,X64,SKX64
; RUN: llc < %s -mtriple=x86_64-pc-linux-gnu -mcpu=knl | FileCheck %s --check-prefixes=CHECK,KNL,X64,KNL64
; RUN: llc < %s -mtriple=i386-pc-linux-gnu -mcpu=skx | FileCheck %s --check-prefixes=CHECK,SKX,X86,SKX32
; RUN: llc < %s -mtriple=i386-pc-linux-gnu -mcpu=knl | FileCheck %s --check-prefixes=CHECK,KNL,X86,KNL32

;expand 128 -> 256 include <4 x float> <2 x double>
define <8 x float> @expand(<4 x float> %a) {
; SKX-LABEL: expand:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; SKX-NEXT:    movb $5, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand:
; KNL:       # %bb.0:
; KNL-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,1,1,3]
; KNL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; KNL-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0],ymm1[1],ymm0[2],ymm1[3,4,5,6,7]
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <4 x float> %a, <4 x float> zeroinitializer, <8 x i32> <i32 0, i32 5, i32 1, i32 5, i32 5, i32 5, i32 5, i32 5>
   ret <8 x float> %res
}

define <8 x float> @expand1(<4 x float> %a ) {
; SKX-LABEL: expand1:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; SKX-NEXT:    movb $-86, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand1:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; KNL-NEXT:    vmovaps {{.*#+}} ymm1 = [16,0,18,1,20,2,22,3]
; KNL-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; KNL-NEXT:    vpermt2ps %zmm2, %zmm1, %zmm0
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <4 x float> zeroinitializer, <4 x float> %a, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
   ret <8 x float> %res
}

;Expand 128 -> 256 test <2 x double> -> <4 x double>
define <4 x double> @expand2(<2 x double> %a) {
; CHECK-LABEL: expand2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; CHECK-NEXT:    vperm2f128 {{.*#+}} ymm1 = zero,zero,ymm0[0,1]
; CHECK-NEXT:    vmovaps %xmm0, %xmm0
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; CHECK-NEXT:    ret{{[l|q]}}
   %res = shufflevector <2 x double> %a, <2 x double> zeroinitializer, <4 x i32> <i32 0, i32 2, i32 2, i32 1>
   ret <4 x double> %res
}

;expand 128 -> 256 include case <4 x i32> <8 x i32>
define <8 x i32> @expand3(<4 x i32> %a ) {
; SKX-LABEL: expand3:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; SKX-NEXT:    movb $-127, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandd %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand3:
; KNL:       # %bb.0:
; KNL-NEXT:    vbroadcastsd %xmm0, %ymm0
; KNL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; KNL-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3,4,5,6],ymm0[7]
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <4 x i32> zeroinitializer, <4 x i32> %a, <8 x i32> <i32 4, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0,i32 5>
   ret <8 x i32> %res
}

;expand 128 -> 256 include case <2 x i64> <4 x i64>
define <4 x i64> @expand4(<2 x i64> %a ) {
; SKX-LABEL: expand4:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; SKX-NEXT:    movb $9, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandq %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand4:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; KNL-NEXT:    vperm2f128 {{.*#+}} ymm1 = zero,zero,ymm0[0,1]
; KNL-NEXT:    vmovaps %xmm0, %xmm0
; KNL-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3],ymm0[4,5],ymm1[6,7]
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <2 x i64> zeroinitializer, <2 x i64> %a, <4 x i32> <i32 2, i32 0, i32 0, i32 3>
   ret <4 x i64> %res
}

;Negative test for 128-> 256
define <8 x float> @expand5(<4 x float> %a ) {
; SKX-LABEL: expand5:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; SKX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; SKX-NEXT:    vmovaps {{.*#+}} ymm2 = [8,0,10,0,12,0,14,0]
; SKX-NEXT:    vpermt2ps %ymm1, %ymm2, %ymm0
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand5:
; KNL:       # %bb.0:
; KNL-NEXT:    vbroadcastss %xmm0, %ymm0
; KNL-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; KNL-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0],ymm0[1],ymm1[2],ymm0[3],ymm1[4],ymm0[5],ymm1[6],ymm0[7]
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <4 x float> zeroinitializer, <4 x float> %a, <8 x i32> <i32 0, i32 4, i32 1, i32 4, i32 2, i32 4, i32 3, i32 4>
   ret <8 x float> %res
}

;expand 256 -> 512 include <8 x float> <16 x float>
define <8 x float> @expand6(<4 x float> %a ) {
; CHECK-LABEL: expand6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; CHECK-NEXT:    ret{{[l|q]}}
   %res = shufflevector <4 x float> zeroinitializer, <4 x float> %a, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
   ret <8 x float> %res
}

define <16 x float> @expand7(<8 x float> %a) {
; SKX-LABEL: expand7:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; SKX-NEXT:    movw $1285, %ax # imm = 0x505
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps %zmm0, %zmm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand7:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL-NEXT:    movw $1285, %ax # imm = 0x505
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vexpandps %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <8 x float> %a, <8 x float> zeroinitializer, <16 x i32> <i32 0, i32 8, i32 1, i32 8, i32 8, i32 8, i32 8, i32 8, i32 2, i32 8, i32 3, i32 8, i32 8, i32 8, i32 8, i32 8>
   ret <16 x float> %res
}

define <16 x float> @expand8(<8 x float> %a ) {
; SKX-LABEL: expand8:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; SKX-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps %zmm0, %zmm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand8:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vexpandps %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <8 x float> zeroinitializer, <8 x float> %a, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
   ret <16 x float> %res
}

;expand 256 -> 512 include <4 x double> <8 x double>
define <8 x double> @expand9(<4 x double> %a) {
; SKX-LABEL: expand9:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; SKX-NEXT:    movb $-127, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandpd %zmm0, %zmm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand9:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL-NEXT:    movb $-127, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vexpandpd %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <4 x double> %a, <4 x double> zeroinitializer, <8 x i32> <i32 0, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 1>
   ret <8 x double> %res
}

define <16 x i32> @expand10(<8 x i32> %a ) {
; SKX-LABEL: expand10:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; SKX-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand10:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <8 x i32> zeroinitializer, <8 x i32> %a, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
   ret <16 x i32> %res
}

define <8 x i64> @expand11(<4 x i64> %a) {
; SKX-LABEL: expand11:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; SKX-NEXT:    movb $-127, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpexpandq %zmm0, %zmm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand11:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL-NEXT:    movb $-127, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpexpandq %zmm0, %zmm0 {%k1} {z}
; KNL-NEXT:    ret{{[l|q]}}
   %res = shufflevector <4 x i64> %a, <4 x i64> zeroinitializer, <8 x i32> <i32 0, i32 4, i32 4, i32 4, i32 4, i32 4, i32 4, i32 1>
   ret <8 x i64> %res
}

;Negative test for 256-> 512
define <16 x float> @expand12(<8 x float> %a) {
; CHECK-LABEL: expand12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; CHECK-NEXT:    vmovaps {{.*#+}} zmm2 = [0,16,2,16,4,16,6,16,0,16,1,16,2,16,3,16]
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpermt2ps %zmm0, %zmm2, %zmm1
; CHECK-NEXT:    vmovaps %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
   %res = shufflevector <8 x float> zeroinitializer, <8 x float> %a, <16 x i32> <i32 0, i32 8, i32 1, i32 8, i32 2, i32 8, i32 3, i32 8,i32 0, i32 8, i32 1, i32 8, i32 2, i32 8, i32 3, i32 8>
   ret <16 x float> %res
}

define <16 x float> @expand13(<8 x float> %a ) {
; CHECK-LABEL: expand13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vinsertf64x4 $1, %ymm0, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
   %res = shufflevector <8 x float> zeroinitializer, <8 x float> %a, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
   ret <16 x float> %res
}

; The function checks for a case where the vector is mixed values vector ,and the mask points on zero elements from this vector.

define <8 x float> @expand14(<4 x float> %a) {
; SKX-LABEL: expand14:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; SKX-NEXT:    movb $20, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vexpandps %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand14:
; KNL:       # %bb.0:
; KNL-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; KNL-NEXT:    vmovaps {{.*#+}} ymm1 = [16,17,0,19,1,21,22,23]
; KNL-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; KNL-NEXT:    vpermt2ps %zmm2, %zmm1, %zmm0
; KNL-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; KNL-NEXT:    ret{{[l|q]}}
   %addV = fadd <4 x float> <float 0.0,float 1.0,float 2.0,float 0.0> , <float 0.0,float 1.0,float 2.0,float 0.0>
   %res = shufflevector <4 x float> %addV, <4 x float> %a, <8 x i32> <i32 3, i32 3, i32 4, i32 0, i32 5, i32 0, i32 0, i32 0>
   ret <8 x float> %res
}

;Negative test.
define <8 x float> @expand15(<4 x float> %a) {
; SKX-LABEL: expand15:
; SKX:       # %bb.0:
; SKX-NEXT:    # kill: def $xmm0 killed $xmm0 def $ymm0
; SKX-NEXT:    vmovaps {{.*#+}} ymm1 = <u,u,0,u,1,u,u,u>
; SKX-NEXT:    vpermps %ymm0, %ymm1, %ymm0
; SKX-NEXT:    vblendps {{.*#+}} ymm0 = mem[0,1],ymm0[2],mem[3],ymm0[4],mem[5,6,7]
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: expand15:
; KNL:       # %bb.0:
; KNL-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,1,1,3]
; KNL-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,0,1,3]
; KNL-NEXT:    vblendps {{.*#+}} ymm0 = mem[0,1],ymm0[2],mem[3],ymm0[4],mem[5,6,7]
; KNL-NEXT:    ret{{[l|q]}}
   %addV = fadd <4 x float> <float 0.0,float 1.0,float 2.0,float 0.0> , <float 0.0,float 1.0,float 2.0,float 0.0>
   %res = shufflevector <4 x float> %addV, <4 x float> %a, <8 x i32> <i32 0, i32 1, i32 4, i32 0, i32 5, i32 0, i32 0, i32 0>
   ret <8 x float> %res
}


; Shuffle to blend test

define <64 x i8> @test_mm512_mask_blend_epi8(<64 x i8> %A, <64 x i8> %W){
; SKX64-LABEL: test_mm512_mask_blend_epi8:
; SKX64:       # %bb.0: # %entry
; SKX64-NEXT:    movabsq $-6148914691236517206, %rax # imm = 0xAAAAAAAAAAAAAAAA
; SKX64-NEXT:    kmovq %rax, %k1
; SKX64-NEXT:    vpblendmb %zmm0, %zmm1, %zmm0 {%k1}
; SKX64-NEXT:    retq
;
; KNL-LABEL: test_mm512_mask_blend_epi8:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    vpbroadcastw {{.*#+}} ymm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; KNL-NEXT:    vinserti64x4 $1, %ymm2, %zmm2, %zmm2
; KNL-NEXT:    vpternlogq $216, %zmm2, %zmm1, %zmm0
; KNL-NEXT:    ret{{[l|q]}}
;
; SKX32-LABEL: test_mm512_mask_blend_epi8:
; SKX32:       # %bb.0: # %entry
; SKX32-NEXT:    movl $-1431655766, %eax # imm = 0xAAAAAAAA
; SKX32-NEXT:    kmovd %eax, %k0
; SKX32-NEXT:    kunpckdq %k0, %k0, %k1
; SKX32-NEXT:    vpblendmb %zmm0, %zmm1, %zmm0 {%k1}
; SKX32-NEXT:    retl
entry:
  %0 = shufflevector <64 x i8> %A, <64 x i8> %W, <64 x i32>  <i32 64, i32 1, i32 66, i32 3, i32 68, i32 5, i32 70, i32 7, i32 72, i32 9, i32 74, i32 11, i32 76, i32 13, i32 78, i32 15, i32 80, i32 17, i32 82, i32 19, i32 84, i32 21, i32 86, i32 23, i32 88, i32 25, i32 90, i32 27, i32 92, i32 29, i32 94, i32 31, i32 96, i32 33, i32 98, i32 35, i32 100, i32 37, i32 102, i32 39, i32 104, i32 41, i32 106, i32 43, i32 108, i32 45, i32 110, i32 47, i32 112, i32 49, i32 114, i32 51, i32 116, i32 53, i32 118, i32 55, i32 120, i32 57, i32 122, i32 59, i32 124, i32 61, i32 126, i32 63>
  ret <64 x i8> %0
}

define <32 x i16> @test_mm512_mask_blend_epi16(<32 x i16> %A, <32 x i16> %W){
; SKX-LABEL: test_mm512_mask_blend_epi16:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    movl $-1431655766, %eax # imm = 0xAAAAAAAA
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpblendmw %zmm0, %zmm1, %zmm0 {%k1}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL64-LABEL: test_mm512_mask_blend_epi16:
; KNL64:       # %bb.0: # %entry
; KNL64-NEXT:    vpternlogd $216, {{.*}}(%rip){1to16}, %zmm1, %zmm0
; KNL64-NEXT:    retq
;
; KNL32-LABEL: test_mm512_mask_blend_epi16:
; KNL32:       # %bb.0: # %entry
; KNL32-NEXT:    vpternlogd $216, {{\.LCPI.*}}{1to16}, %zmm1, %zmm0
; KNL32-NEXT:    retl
entry:
  %0 = shufflevector <32 x i16> %A, <32 x i16> %W, <32 x i32>  <i32 32, i32 1, i32 34, i32 3, i32 36, i32 5, i32 38, i32 7, i32 40, i32 9, i32 42, i32 11, i32 44, i32 13, i32 46, i32 15, i32 48, i32 17, i32 50, i32 19, i32 52, i32 21, i32 54, i32 23, i32 56, i32 25, i32 58, i32 27, i32 60, i32 29, i32 62, i32 31>
  ret <32 x i16> %0
}

define <16 x i32> @test_mm512_mask_blend_epi32(<16 x i32> %A, <16 x i32> %W){
; SKX-LABEL: test_mm512_mask_blend_epi32:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: test_mm512_mask_blend_epi32:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpblendmd %zmm0, %zmm1, %zmm0 {%k1}
; KNL-NEXT:    ret{{[l|q]}}
entry:
  %0 = shufflevector <16 x i32> %A, <16 x i32> %W, <16 x i32>  <i32 16, i32 1, i32 18, i32 3, i32 20, i32 5, i32 22, i32 7, i32 24, i32 9, i32 26, i32 11, i32 28, i32 13, i32 30, i32 15>
  ret <16 x i32> %0
}

define <8 x i64> @test_mm512_mask_blend_epi64(<8 x i64> %A, <8 x i64> %W){
; SKX-LABEL: test_mm512_mask_blend_epi64:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    movb $-86, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpblendmq %zmm0, %zmm1, %zmm0 {%k1}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: test_mm512_mask_blend_epi64:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    movb $-86, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vpblendmq %zmm0, %zmm1, %zmm0 {%k1}
; KNL-NEXT:    ret{{[l|q]}}
entry:
  %0 = shufflevector <8 x i64> %A, <8 x i64> %W, <8 x i32>  <i32 8, i32 1, i32 10, i32 3, i32 12, i32 5, i32 14, i32 7>
  ret <8 x i64> %0
}

define <16 x float> @test_mm512_mask_blend_ps(<16 x float> %A, <16 x float> %W){
; SKX-LABEL: test_mm512_mask_blend_ps:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: test_mm512_mask_blend_ps:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vblendmps %zmm0, %zmm1, %zmm0 {%k1}
; KNL-NEXT:    ret{{[l|q]}}
entry:
  %0 = shufflevector <16 x float> %A, <16 x float> %W, <16 x i32>  <i32 16, i32 1, i32 18, i32 3, i32 20, i32 5, i32 22, i32 7, i32 24, i32 9, i32 26, i32 11, i32 28, i32 13, i32 30, i32 15>
  ret <16 x float> %0
}

define <8 x double> @test_mm512_mask_blend_pd(<8 x double> %A, <8 x double> %W){
; SKX-LABEL: test_mm512_mask_blend_pd:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    movb $-88, %al
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: test_mm512_mask_blend_pd:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    movb $-88, %al
; KNL-NEXT:    kmovw %eax, %k1
; KNL-NEXT:    vblendmpd %zmm0, %zmm1, %zmm0 {%k1}
; KNL-NEXT:    ret{{[l|q]}}
entry:
  %0 = shufflevector <8 x double> %A, <8 x double> %W, <8 x i32>  <i32 8, i32 9, i32 10, i32 3, i32 12, i32 5, i32 14, i32 7>
  ret <8 x double> %0
}


define <32 x i8> @test_mm256_mask_blend_epi8(<32 x i8> %A, <32 x i8> %W){
; SKX-LABEL: test_mm256_mask_blend_epi8:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    movl $-1431655766, %eax # imm = 0xAAAAAAAA
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpblendmb %ymm0, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: test_mm256_mask_blend_epi8:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    vmovdqa {{.*#+}} ymm2 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
; KNL-NEXT:    vpblendvb %ymm2, %ymm1, %ymm0, %ymm0
; KNL-NEXT:    ret{{[l|q]}}
entry:
  %0 = shufflevector <32 x i8> %A, <32 x i8> %W, <32 x i32>  <i32 32, i32 1, i32 34, i32 3, i32 36, i32 5, i32 38, i32 7, i32 40, i32 9, i32 42, i32 11, i32 44, i32 13, i32 46, i32 15, i32 48, i32 17, i32 50, i32 19, i32 52, i32 21, i32 54, i32 23, i32 56, i32 25, i32 58, i32 27, i32 60, i32 29, i32 62, i32 31>
  ret <32 x i8> %0
}

define <16 x i8> @test_mm_mask_blend_epi8(<16 x i8> %A, <16 x i8> %W){
; SKX-LABEL: test_mm_mask_blend_epi8:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    movw $-21846, %ax # imm = 0xAAAA
; SKX-NEXT:    kmovd %eax, %k1
; SKX-NEXT:    vpblendmb %xmm0, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    ret{{[l|q]}}
;
; KNL-LABEL: test_mm_mask_blend_epi8:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    vmovdqa {{.*#+}} xmm2 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
; KNL-NEXT:    vpblendvb %xmm2, %xmm1, %xmm0, %xmm0
; KNL-NEXT:    ret{{[l|q]}}
entry:
  %0 = shufflevector <16 x i8> %A, <16 x i8> %W, <16 x i32>  <i32 16, i32 1, i32 18, i32 3, i32 20, i32 5, i32 22, i32 7, i32 24, i32 9, i32 26, i32 11, i32 28, i32 13, i32 30, i32 15>
  ret <16 x i8> %0
}

; PR34370
define <8 x float> @test_masked_permps_v8f32(<8 x float>* %vp, <8 x float> %vec2) {
; SKX64-LABEL: test_masked_permps_v8f32:
; SKX64:       # %bb.0:
; SKX64-NEXT:    vmovaps (%rdi), %ymm2
; SKX64-NEXT:    vmovaps {{.*#+}} ymm1 = [7,6,3,11,7,6,14,15]
; SKX64-NEXT:    vpermi2ps %ymm0, %ymm2, %ymm1
; SKX64-NEXT:    vmovaps %ymm1, %ymm0
; SKX64-NEXT:    retq
;
; KNL64-LABEL: test_masked_permps_v8f32:
; KNL64:       # %bb.0:
; KNL64-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL64-NEXT:    vmovaps (%rdi), %ymm1
; KNL64-NEXT:    vmovaps {{.*#+}} ymm2 = [7,6,3,19,7,6,22,23]
; KNL64-NEXT:    vpermt2ps %zmm0, %zmm2, %zmm1
; KNL64-NEXT:    vmovaps %ymm1, %ymm0
; KNL64-NEXT:    retq
;
; SKX32-LABEL: test_masked_permps_v8f32:
; SKX32:       # %bb.0:
; SKX32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX32-NEXT:    vmovaps (%eax), %ymm2
; SKX32-NEXT:    vmovaps {{.*#+}} ymm1 = [7,6,3,11,7,6,14,15]
; SKX32-NEXT:    vpermi2ps %ymm0, %ymm2, %ymm1
; SKX32-NEXT:    vmovaps %ymm1, %ymm0
; SKX32-NEXT:    retl
;
; KNL32-LABEL: test_masked_permps_v8f32:
; KNL32:       # %bb.0:
; KNL32-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; KNL32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL32-NEXT:    vmovaps (%eax), %ymm1
; KNL32-NEXT:    vmovaps {{.*#+}} ymm2 = [7,6,3,19,7,6,22,23]
; KNL32-NEXT:    vpermt2ps %zmm0, %zmm2, %zmm1
; KNL32-NEXT:    vmovaps %ymm1, %ymm0
; KNL32-NEXT:    retl
  %vec = load <8 x float>, <8 x float>* %vp
  %shuf = shufflevector <8 x float> %vec, <8 x float> undef, <8 x i32> <i32 7, i32 6, i32 3, i32 0, i32 7, i32 6, i32 3, i32 0>
  %res = select <8 x i1> <i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0>, <8 x float> %shuf, <8 x float> %vec2
  ret <8 x float> %res
}

define <16 x float> @test_masked_permps_v16f32(<16 x float>* %vp, <16 x float> %vec2) {
; X64-LABEL: test_masked_permps_v16f32:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps (%rdi), %zmm2
; X64-NEXT:    vmovaps {{.*#+}} zmm1 = [15,13,11,19,14,12,22,23,7,6,3,27,7,29,3,31]
; X64-NEXT:    vpermi2ps %zmm0, %zmm2, %zmm1
; X64-NEXT:    vmovaps %zmm1, %zmm0
; X64-NEXT:    retq
;
; X86-LABEL: test_masked_permps_v16f32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovaps (%eax), %zmm2
; X86-NEXT:    vmovaps {{.*#+}} zmm1 = [15,13,11,19,14,12,22,23,7,6,3,27,7,29,3,31]
; X86-NEXT:    vpermi2ps %zmm0, %zmm2, %zmm1
; X86-NEXT:    vmovaps %zmm1, %zmm0
; X86-NEXT:    retl
  %vec = load <16 x float>, <16 x float>* %vp
  %shuf = shufflevector <16 x float> %vec, <16 x float> undef, <16 x i32> <i32 15, i32 13, i32 11, i32 9, i32 14, i32 12, i32 10, i32 8, i32 7, i32 6, i32 3, i32 0, i32 7, i32 6, i32 3, i32 0>
  %res = select <16 x i1> <i1 1, i1 1, i1 1, i1 0, i1 1, i1 1, i1 0, i1 0, i1 1, i1 1, i1 1, i1 0, i1 1, i1 0, i1 1, i1 0>, <16 x float> %shuf, <16 x float> %vec2
  ret <16 x float> %res
}

define void @test_demandedelts_pshufb_v32i8_v16i8(<2 x i32>* %src, <8 x i32>* %dst) {
; SKX64-LABEL: test_demandedelts_pshufb_v32i8_v16i8:
; SKX64:       # %bb.0:
; SKX64-NEXT:    vmovdqa 32(%rdi), %xmm0
; SKX64-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[12,13,14,15,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; SKX64-NEXT:    vmovdqa %ymm0, 672(%rsi)
; SKX64-NEXT:    vmovdqa 208(%rdi), %xmm0
; SKX64-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,6,7,0,1,2,3],zero,zero,zero,zero,zero,zero,zero,zero
; SKX64-NEXT:    vmovdqa %ymm0, 832(%rsi)
; SKX64-NEXT:    vzeroupper
; SKX64-NEXT:    retq
;
; KNL64-LABEL: test_demandedelts_pshufb_v32i8_v16i8:
; KNL64:       # %bb.0:
; KNL64-NEXT:    vmovdqa 32(%rdi), %xmm0
; KNL64-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[12,13,14,15,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; KNL64-NEXT:    vmovdqa %ymm0, 672(%rsi)
; KNL64-NEXT:    vmovdqa 208(%rdi), %xmm0
; KNL64-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,6,7,0,1,2,3],zero,zero,zero,zero,zero,zero,zero,zero
; KNL64-NEXT:    vmovdqa %ymm0, 832(%rsi)
; KNL64-NEXT:    retq
;
; SKX32-LABEL: test_demandedelts_pshufb_v32i8_v16i8:
; SKX32:       # %bb.0:
; SKX32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; SKX32-NEXT:    vmovdqa 32(%ecx), %xmm0
; SKX32-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[12,13,14,15,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; SKX32-NEXT:    vmovdqa %ymm0, 672(%eax)
; SKX32-NEXT:    vmovdqa 208(%ecx), %xmm0
; SKX32-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,6,7,0,1,2,3],zero,zero,zero,zero,zero,zero,zero,zero
; SKX32-NEXT:    vmovdqa %ymm0, 832(%eax)
; SKX32-NEXT:    vzeroupper
; SKX32-NEXT:    retl
;
; KNL32-LABEL: test_demandedelts_pshufb_v32i8_v16i8:
; KNL32:       # %bb.0:
; KNL32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL32-NEXT:    vmovdqa 32(%eax), %xmm0
; KNL32-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[12,13,14,15,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; KNL32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; KNL32-NEXT:    vmovdqa %ymm0, 672(%ecx)
; KNL32-NEXT:    vmovdqa 208(%eax), %xmm0
; KNL32-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4,5,6,7,0,1,2,3],zero,zero,zero,zero,zero,zero,zero,zero
; KNL32-NEXT:    vmovdqa %ymm0, 832(%ecx)
; KNL32-NEXT:    retl
  %t64 = bitcast <2 x i32>* %src to <16 x i32>*
  %t87 = load <16 x i32>, <16 x i32>* %t64, align 64
  %t88 = extractelement <16 x i32> %t87, i64 11
  %t89 = insertelement <8 x i32> <i32 undef, i32 undef, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, i32 %t88, i64 0
  %t90 = insertelement <8 x i32> %t89, i32 %t88, i64 1
  %ptridx49.i = getelementptr inbounds <8 x i32>, <8 x i32>* %dst, i64 21
  store <8 x i32> %t90, <8 x i32>* %ptridx49.i, align 32
  %ptridx56.i = getelementptr inbounds <2 x i32>, <2 x i32>* %src, i64 24
  %t00 = bitcast <2 x i32>* %ptridx56.i to <16 x i32>*
  %t09 = load <16 x i32>, <16 x i32>* %t00, align 64
  %t10 = extractelement <16 x i32> %t09, i64 5
  %t11 = insertelement <8 x i32> <i32 undef, i32 undef, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, i32 %t10, i64 0
  %t12 = extractelement <16 x i32> %t09, i64 4
  %t13 = insertelement <8 x i32> %t11, i32 %t12, i64 1
  %ptridx64.i = getelementptr inbounds <8 x i32>, <8 x i32>* %dst, i64 26
  store <8 x i32> %t13, <8 x i32>* %ptridx64.i, align 32
  ret void
}

define <32 x float> @PR47534(<8 x float> %tmp) {
; CHECK-LABEL: PR47534:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vbroadcasti64x4 {{.*#+}} zmm1 = [7,25,26,27,7,29,30,31,7,25,26,27,7,29,30,31]
; CHECK-NEXT:    # zmm1 = mem[0,1,2,3,0,1,2,3]
; CHECK-NEXT:    vpermi2ps %zmm2, %zmm0, %zmm1
; CHECK-NEXT:    ret{{[l|q]}}
  %tmp1 = shufflevector <8 x float> %tmp, <8 x float> undef, <32 x i32> <i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %tmp2 = shufflevector <32 x float> <float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float undef, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00>, <32 x float> undef, <32 x i32> <i32 39, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 29, i32 30, i32 31>
  %tmp18 = shufflevector <32 x float> %tmp2, <32 x float> %tmp1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 39, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 29, i32 30, i32 31>
  ret <32 x float> %tmp18
}

%union1= type { <16 x float> }
@src1 = external dso_local local_unnamed_addr global %union1, align 64

define void @PR43170(<16 x float>* %a0) {
; SKX64-LABEL: PR43170:
; SKX64:       # %bb.0: # %entry
; SKX64-NEXT:    vmovaps {{.*}}(%rip), %ymm0
; SKX64-NEXT:    vmovaps %zmm0, (%rdi)
; SKX64-NEXT:    vzeroupper
; SKX64-NEXT:    retq
;
; KNL64-LABEL: PR43170:
; KNL64:       # %bb.0: # %entry
; KNL64-NEXT:    vmovaps {{.*}}(%rip), %ymm0
; KNL64-NEXT:    vmovaps %zmm0, (%rdi)
; KNL64-NEXT:    retq
;
; SKX32-LABEL: PR43170:
; SKX32:       # %bb.0: # %entry
; SKX32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX32-NEXT:    vmovaps src1, %ymm0
; SKX32-NEXT:    vmovaps %zmm0, (%eax)
; SKX32-NEXT:    vzeroupper
; SKX32-NEXT:    retl
;
; KNL32-LABEL: PR43170:
; KNL32:       # %bb.0: # %entry
; KNL32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL32-NEXT:    vmovaps src1, %ymm0
; KNL32-NEXT:    vmovaps %zmm0, (%eax)
; KNL32-NEXT:    retl
entry:
  %0 = load <8 x float>, <8 x float>* bitcast (%union1* @src1 to <8 x float>*), align 64
  %1 = shufflevector <8 x float> %0, <8 x float> zeroinitializer, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <16 x float> %1, <16 x float>* %a0, align 64
  ret void
}
