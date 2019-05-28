; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-linux -mcpu=corei7-avx | FileCheck %s
; RUN: opt -instsimplify -disable-output < %s

define <4 x i32*> @AGEP0(i32* %ptr) nounwind {
; CHECK-LABEL: AGEP0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastss {{[0-9]+}}(%esp), %xmm0
; CHECK-NEXT:    vpaddd {{\.LCPI.*}}, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %vecinit.i = insertelement <4 x i32*> undef, i32* %ptr, i32 0
  %vecinit2.i = insertelement <4 x i32*> %vecinit.i, i32* %ptr, i32 1
  %vecinit4.i = insertelement <4 x i32*> %vecinit2.i, i32* %ptr, i32 2
  %vecinit6.i = insertelement <4 x i32*> %vecinit4.i, i32* %ptr, i32 3
  %A2 = getelementptr i32, <4 x i32*> %vecinit6.i, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %A3 = getelementptr i32, <4 x i32*> %A2, <4 x i32> <i32 10, i32 14, i32 19, i32 233>
  ret <4 x i32*> %A3
}

define i32 @AGEP1(<4 x i32*> %param) nounwind {
; CHECK-LABEL: AGEP1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vextractps $3, %xmm0, %eax
; CHECK-NEXT:    movl 16(%eax), %eax
; CHECK-NEXT:    retl
  %A2 = getelementptr i32, <4 x i32*> %param, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %k = extractelement <4 x i32*> %A2, i32 3
  %v = load i32, i32* %k
  ret i32 %v
}

define i32 @AGEP2(<4 x i32*> %param, <4 x i32> %off) nounwind {
; CHECK-LABEL: AGEP2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpslld $2, %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpextrd $3, %xmm0, %eax
; CHECK-NEXT:    movl (%eax), %eax
; CHECK-NEXT:    retl
  %A2 = getelementptr i32, <4 x i32*> %param, <4 x i32> %off
  %k = extractelement <4 x i32*> %A2, i32 3
  %v = load i32, i32* %k
  ret i32 %v
}

define <4 x i32*> @AGEP3(<4 x i32*> %param, <4 x i32> %off) nounwind {
; CHECK-LABEL: AGEP3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    vpslld $2, %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    movl %esp, %eax
; CHECK-NEXT:    vpinsrd $3, %eax, %xmm0, %xmm0
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    retl
  %A2 = getelementptr i32, <4 x i32*> %param, <4 x i32> %off
  %v = alloca i32
  %k = insertelement <4 x i32*> %A2, i32* %v, i32 3
  ret <4 x i32*> %k
}

define <4 x i16*> @AGEP4(<4 x i16*> %param, <4 x i32> %off) nounwind {
; Multiply offset by two (add it to itself).
; add the base to the offset
; CHECK-LABEL: AGEP4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %A = getelementptr i16, <4 x i16*> %param, <4 x i32> %off
  ret <4 x i16*> %A
}

define <4 x i8*> @AGEP5(<4 x i8*> %param, <4 x i8> %off) nounwind {
; CHECK-LABEL: AGEP5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpslld $24, %xmm1, %xmm1
; CHECK-NEXT:    vpsrad $24, %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %A = getelementptr i8, <4 x i8*> %param, <4 x i8> %off
  ret <4 x i8*> %A
}


; The size of each element is 1 byte. No need to multiply by element size.
define <4 x i8*> @AGEP6(<4 x i8*> %param, <4 x i32> %off) nounwind {
; CHECK-LABEL: AGEP6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %A = getelementptr i8, <4 x i8*> %param, <4 x i32> %off
  ret <4 x i8*> %A
}

define <4 x i8*> @AGEP7(<4 x i8*> %param, i32 %off) nounwind {
; CHECK-LABEL: AGEP7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastss {{[0-9]+}}(%esp), %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %A = getelementptr i8, <4 x i8*> %param, i32 %off
  ret <4 x i8*> %A
}

define <4 x i16*> @AGEP8(i16* %param, <4 x i32> %off) nounwind {
; Multiply offset by two (add it to itself).
; add the base to the offset
; CHECK-LABEL: AGEP8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vbroadcastss {{[0-9]+}}(%esp), %xmm1
; CHECK-NEXT:    vpaddd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retl
  %A = getelementptr i16, i16* %param, <4 x i32> %off
  ret <4 x i16*> %A
}

define <64 x i16*> @AGEP9(i16* %param, <64 x i32> %off) nounwind {
; CHECK-LABEL: AGEP9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    andl $-32, %esp
; CHECK-NEXT:    subl $96, %esp
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpaddd %xmm3, %xmm3, %xmm4
; CHECK-NEXT:    vbroadcastss 12(%ebp), %xmm3
; CHECK-NEXT:    vpaddd %xmm4, %xmm3, %xmm4
; CHECK-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; CHECK-NEXT:    vmovaps %ymm0, {{[-0-9]+}}(%e{{[sb]}}p) # 32-byte Spill
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm4
; CHECK-NEXT:    vpaddd %xmm4, %xmm4, %xmm4
; CHECK-NEXT:    vpaddd %xmm4, %xmm3, %xmm4
; CHECK-NEXT:    vpaddd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm3, %xmm1
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm1, %ymm0
; CHECK-NEXT:    vmovaps %ymm0, (%esp) # 32-byte Spill
; CHECK-NEXT:    vextractf128 $1, %ymm2, %xmm4
; CHECK-NEXT:    vpaddd %xmm4, %xmm4, %xmm4
; CHECK-NEXT:    vpaddd %xmm4, %xmm3, %xmm4
; CHECK-NEXT:    vpaddd %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vpaddd %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; CHECK-NEXT:    vmovdqa 40(%ebp), %xmm4
; CHECK-NEXT:    vmovdqa 56(%ebp), %xmm5
; CHECK-NEXT:    vpaddd %xmm5, %xmm5, %xmm5
; CHECK-NEXT:    vpaddd %xmm5, %xmm3, %xmm5
; CHECK-NEXT:    vpaddd %xmm4, %xmm4, %xmm4
; CHECK-NEXT:    vpaddd %xmm4, %xmm3, %xmm4
; CHECK-NEXT:    vinsertf128 $1, %xmm5, %ymm4, %ymm4
; CHECK-NEXT:    vmovdqa 72(%ebp), %xmm5
; CHECK-NEXT:    vmovdqa 88(%ebp), %xmm6
; CHECK-NEXT:    vpaddd %xmm6, %xmm6, %xmm6
; CHECK-NEXT:    vpaddd %xmm6, %xmm3, %xmm6
; CHECK-NEXT:    vpaddd %xmm5, %xmm5, %xmm5
; CHECK-NEXT:    vpaddd %xmm5, %xmm3, %xmm5
; CHECK-NEXT:    vinsertf128 $1, %xmm6, %ymm5, %ymm5
; CHECK-NEXT:    vmovdqa 104(%ebp), %xmm6
; CHECK-NEXT:    vmovdqa 120(%ebp), %xmm7
; CHECK-NEXT:    vpaddd %xmm7, %xmm7, %xmm7
; CHECK-NEXT:    vpaddd %xmm7, %xmm3, %xmm7
; CHECK-NEXT:    vpaddd %xmm6, %xmm6, %xmm6
; CHECK-NEXT:    vpaddd %xmm6, %xmm3, %xmm6
; CHECK-NEXT:    vinsertf128 $1, %xmm7, %ymm6, %ymm6
; CHECK-NEXT:    vmovdqa 152(%ebp), %xmm7
; CHECK-NEXT:    vpaddd %xmm7, %xmm7, %xmm7
; CHECK-NEXT:    vpaddd %xmm7, %xmm3, %xmm7
; CHECK-NEXT:    vmovdqa 136(%ebp), %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm3, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm7, %ymm0, %ymm0
; CHECK-NEXT:    vmovdqa 184(%ebp), %xmm7
; CHECK-NEXT:    vpaddd %xmm7, %xmm7, %xmm7
; CHECK-NEXT:    vpaddd %xmm7, %xmm3, %xmm7
; CHECK-NEXT:    vmovdqa 168(%ebp), %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %xmm1, %xmm3, %xmm1
; CHECK-NEXT:    vinsertf128 $1, %xmm7, %ymm1, %ymm1
; CHECK-NEXT:    movl 8(%ebp), %eax
; CHECK-NEXT:    vmovaps %ymm1, 224(%eax)
; CHECK-NEXT:    vmovaps %ymm0, 192(%eax)
; CHECK-NEXT:    vmovaps %ymm6, 160(%eax)
; CHECK-NEXT:    vmovaps %ymm5, 128(%eax)
; CHECK-NEXT:    vmovaps %ymm4, 96(%eax)
; CHECK-NEXT:    vmovaps %ymm2, 64(%eax)
; CHECK-NEXT:    vmovaps (%esp), %ymm0 # 32-byte Reload
; CHECK-NEXT:    vmovaps %ymm0, 32(%eax)
; CHECK-NEXT:    vmovaps {{[-0-9]+}}(%e{{[sb]}}p), %ymm0 # 32-byte Reload
; CHECK-NEXT:    vmovaps %ymm0, (%eax)
; CHECK-NEXT:    movl %ebp, %esp
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl $4
  %A = getelementptr i16, i16* %param, <64 x i32> %off
  ret <64 x i16*> %A
}

