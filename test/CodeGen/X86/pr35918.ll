; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=skylake | FileCheck %s --check-prefixes=X86,X86-SKYLAKE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=skx | FileCheck %s --check-prefixes=X86,X86-SKX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=skylake | FileCheck %s --check-prefixes=X64,X64-SKYLAKE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=skx | FileCheck %s --check-prefixes=X64,X64-SKX

define void @fetch_r16g16_snorm_unorm8(<4 x i8>*, i8*, i32, i32, { [2048 x i32], [128 x i64] }*) nounwind {
; X86-SKYLAKE-LABEL: fetch_r16g16_snorm_unorm8:
; X86-SKYLAKE:       # %bb.0: # %entry
; X86-SKYLAKE-NEXT:    subl $12, %esp
; X86-SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SKYLAKE-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SKYLAKE-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X86-SKYLAKE-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X86-SKYLAKE-NEXT:    vpsrad $16, %xmm0, %xmm0
; X86-SKYLAKE-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; X86-SKYLAKE-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; X86-SKYLAKE-NEXT:    vpsrld $7, %xmm0, %xmm0
; X86-SKYLAKE-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4],zero,zero,xmm0[u,u,u,u,u,u,u,u,u,u,u,u]
; X86-SKYLAKE-NEXT:    vmovd %xmm0, %ecx
; X86-SKYLAKE-NEXT:    orl $-16777216, %ecx # imm = 0xFF000000
; X86-SKYLAKE-NEXT:    movl %ecx, (%eax)
; X86-SKYLAKE-NEXT:    addl $12, %esp
; X86-SKYLAKE-NEXT:    retl
;
; X86-SKX-LABEL: fetch_r16g16_snorm_unorm8:
; X86-SKX:       # %bb.0: # %entry
; X86-SKX-NEXT:    subl $12, %esp
; X86-SKX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SKX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SKX-NEXT:    vpshufb {{.*#+}} xmm0 = zero,zero,xmm0[0,1],zero,zero,xmm0[2,3],zero,zero,xmm0[u,u],zero,zero,xmm0[u,u]
; X86-SKX-NEXT:    vpsrad $16, %xmm0, %xmm0
; X86-SKX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X86-SKX-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; X86-SKX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; X86-SKX-NEXT:    vpsrld $7, %xmm0, %xmm0
; X86-SKX-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero
; X86-SKX-NEXT:    vpmovqw %xmm1, {{[0-9]+}}(%esp)
; X86-SKX-NEXT:    vpmovzxbd {{.*#+}} xmm1 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X86-SKX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X86-SKX-NEXT:    vpmovqw %xmm0, {{[0-9]+}}(%esp)
; X86-SKX-NEXT:    vpmovzxbd {{.*#+}} xmm0 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X86-SKX-NEXT:    vshufps {{.*#+}} xmm0 = xmm1[0,2],xmm0[0,2]
; X86-SKX-NEXT:    vpmovdb %xmm0, (%esp)
; X86-SKX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SKX-NEXT:    movzwl (%esp), %ecx
; X86-SKX-NEXT:    orl $-16777216, %ecx # imm = 0xFF000000
; X86-SKX-NEXT:    movl %ecx, (%eax)
; X86-SKX-NEXT:    addl $12, %esp
; X86-SKX-NEXT:    retl
;
; X64-SKYLAKE-LABEL: fetch_r16g16_snorm_unorm8:
; X64-SKYLAKE:       # %bb.0: # %entry
; X64-SKYLAKE-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-SKYLAKE-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-SKYLAKE-NEXT:    vpunpcklwd {{.*#+}} xmm0 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3]
; X64-SKYLAKE-NEXT:    vpsrad $16, %xmm0, %xmm0
; X64-SKYLAKE-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; X64-SKYLAKE-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; X64-SKYLAKE-NEXT:    vpsrld $7, %xmm0, %xmm0
; X64-SKYLAKE-NEXT:    vpackssdw %xmm0, %xmm0, %xmm0
; X64-SKYLAKE-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2],zero,zero,xmm0[u,u,u,u,u,u,u,u,u,u,u,u]
; X64-SKYLAKE-NEXT:    vmovd %xmm0, %eax
; X64-SKYLAKE-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X64-SKYLAKE-NEXT:    movl %eax, (%rdi)
; X64-SKYLAKE-NEXT:    retq
;
; X64-SKX-LABEL: fetch_r16g16_snorm_unorm8:
; X64-SKX:       # %bb.0: # %entry
; X64-SKX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-SKX-NEXT:    vpshufb {{.*#+}} xmm0 = zero,zero,xmm0[0,1],zero,zero,xmm0[2,3],zero,zero,xmm0[u,u],zero,zero,xmm0[u,u]
; X64-SKX-NEXT:    vpsrad $16, %xmm0, %xmm0
; X64-SKX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-SKX-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; X64-SKX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; X64-SKX-NEXT:    vpsrld $7, %xmm0, %xmm0
; X64-SKX-NEXT:    vpmovzxwd {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; X64-SKX-NEXT:    vpmovqw %xmm1, -{{[0-9]+}}(%rsp)
; X64-SKX-NEXT:    vpmovzxbd {{.*#+}} xmm1 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X64-SKX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,2,3,3]
; X64-SKX-NEXT:    vpmovqw %xmm0, -{{[0-9]+}}(%rsp)
; X64-SKX-NEXT:    vpmovzxbd {{.*#+}} xmm0 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X64-SKX-NEXT:    vshufps {{.*#+}} xmm0 = xmm1[0,2],xmm0[0,2]
; X64-SKX-NEXT:    vpmovdb %xmm0, -{{[0-9]+}}(%rsp)
; X64-SKX-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; X64-SKX-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X64-SKX-NEXT:    movl %eax, (%rdi)
; X64-SKX-NEXT:    retq
entry:
  %5 = bitcast i8* %1 to <2 x i16>*
  %6 = load <2 x i16>, <2 x i16>* %5, align 2
  %7 = shufflevector <2 x i16> %6, <2 x i16> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %8 = icmp sgt <4 x i16> %7, zeroinitializer
  %9 = select <4 x i1> %8, <4 x i16> %7, <4 x i16> zeroinitializer
  %10 = lshr <4 x i16> %9, <i16 7, i16 7, i16 7, i16 7>
  %11 = shufflevector <4 x i16> %10, <4 x i16> undef, <2 x i32> <i32 0, i32 1>
  %12 = shufflevector <4 x i16> %10, <4 x i16> undef, <2 x i32> <i32 2, i32 3>
  %13 = bitcast <2 x i16> %11 to <4 x i8>
  %14 = bitcast <2 x i16> %12 to <4 x i8>
  %15 = shufflevector <4 x i8> %13, <4 x i8> %14, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %16 = bitcast <4 x i8> %15 to i32
  %17 = and i32 %16, 65535
  %18 = or i32 %17, -16777216
  %19 = bitcast <4 x i8>* %0 to i32*
  store i32 %18, i32* %19, align 4
  ret void
}
