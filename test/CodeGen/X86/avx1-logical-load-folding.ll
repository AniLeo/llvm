; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O3 -disable-peephole -mtriple=i686-apple-macosx10.9.0 -mcpu=corei7-avx -mattr=+avx | FileCheck %s --check-prefix=X86
; RUN: llc < %s -O3 -disable-peephole -mtriple=x86_64-apple-macosx10.9.0 -mcpu=corei7-avx -mattr=+avx | FileCheck %s --check-prefix=X64

; Function Attrs: nounwind ssp uwtable
define void @test1(ptr %A, ptr %C) #0 {
; X86-LABEL: test1:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test1:
; X64:       ## %bb.0:
; X64-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vmovss %xmm0, (%rsi)
; X64-NEXT:    retq
  %tmp2 = load <8 x float>, ptr %A, align 32
  %tmp3 = bitcast <8 x float> %tmp2 to <8 x i32>
  %tmp4 = and <8 x i32> %tmp3, <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
  %tmp5 = bitcast <8 x i32> %tmp4 to <8 x float>
  %tmp6 = extractelement <8 x float> %tmp5, i32 0
  store float %tmp6, ptr %C
  ret void
}

; Function Attrs: nounwind ssp uwtable
define void @test2(ptr %A, ptr %C) #0 {
; X86-LABEL: test2:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    vmovaps (%ecx), %xmm0
; X86-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test2:
; X64:       ## %bb.0:
; X64-NEXT:    vmovaps (%rdi), %xmm0
; X64-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vmovss %xmm0, (%rsi)
; X64-NEXT:    retq
  %tmp2 = load <8 x float>, ptr %A, align 32
  %tmp3 = bitcast <8 x float> %tmp2 to <8 x i32>
  %tmp4 = or <8 x i32> %tmp3, <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
  %tmp5 = bitcast <8 x i32> %tmp4 to <8 x float>
  %tmp6 = extractelement <8 x float> %tmp5, i32 0
  store float %tmp6, ptr %C
  ret void
}

; Function Attrs: nounwind ssp uwtable
define void @test3(ptr %A, ptr %C) #0 {
; X86-LABEL: test3:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    vmovaps (%ecx), %xmm0
; X86-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test3:
; X64:       ## %bb.0:
; X64-NEXT:    vmovaps (%rdi), %xmm0
; X64-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vmovss %xmm0, (%rsi)
; X64-NEXT:    retq
  %tmp2 = load <8 x float>, ptr %A, align 32
  %tmp3 = bitcast <8 x float> %tmp2 to <8 x i32>
  %tmp4 = xor <8 x i32> %tmp3, <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
  %tmp5 = bitcast <8 x i32> %tmp4 to <8 x float>
  %tmp6 = extractelement <8 x float> %tmp5, i32 0
  store float %tmp6, ptr %C
  ret void
}

define void @test4(ptr %A, ptr %C) #0 {
; X86-LABEL: test4:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    vmovaps (%ecx), %xmm0
; X86-NEXT:    vandnps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test4:
; X64:       ## %bb.0:
; X64-NEXT:    vmovaps (%rdi), %xmm0
; X64-NEXT:    vandnps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vmovss %xmm0, (%rsi)
; X64-NEXT:    retq
  %tmp2 = load <8 x float>, ptr %A, align 32
  %tmp3 = bitcast <8 x float> %tmp2 to <8 x i32>
  %tmp4 = xor <8 x i32> %tmp3, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %tmp5 = and <8 x i32> %tmp4, <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
  %tmp6 = bitcast <8 x i32> %tmp5 to <8 x float>
  %tmp7 = extractelement <8 x float> %tmp6, i32 0
  store float %tmp7, ptr %C
  ret void
}
