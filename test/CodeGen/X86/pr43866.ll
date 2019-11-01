; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx | FileCheck %s

@v2_0 = global <2 x i32> zeroinitializer, align 8

define void @test()  {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    andq $-32, %rsp
; CHECK-NEXT:    subq $64, %rsp
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vcmptrueps %ymm2, %ymm2, %ymm2
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; CHECK-NEXT:    vshufps {{.*#+}} ymm1 = ymm1[1,0],ymm0[1,0],ymm1[5,4],ymm0[5,4]
; CHECK-NEXT:    vshufps {{.*#+}} ymm0 = ymm1[2,0],ymm0[0,0],ymm1[6,4],ymm0[4,4]
; CHECK-NEXT:    vmovaps %ymm0, (%rsp)
; CHECK-NEXT:    movq %rbp, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %v8_0 = alloca <8 x i32>, align 32
  %v8_0.0.v8_0.0..sroa_cast = bitcast <8 x i32>* %v8_0 to i8*
  %0 = load <2 x i32>, <2 x i32>* @v2_0, align 8
  %shuffle = shufflevector <2 x i32> %0, <2 x i32> <i32 -1, i32 -1>, <8 x i32> <i32 1, i32 3, i32 0, i32 0, i32 3, i32 3, i32 2, i32 2>
  store volatile <8 x i32> %shuffle, <8 x i32>* %v8_0, align 32
  ret void
}
