; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=skylake | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=skx | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=skylake | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=skx | FileCheck %s --check-prefix=X64

define void @fetch_r16g16_snorm_unorm8(<4 x i8>*, i8*, i32, i32, { [2048 x i32], [128 x i64] }*) nounwind {
; X86-LABEL: fetch_r16g16_snorm_unorm8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X86-NEXT:    vpmaxsw %xmm1, %xmm0, %xmm0
; X86-NEXT:    vpsrlw $7, %xmm0, %xmm0
; X86-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2],zero,xmm0[u,u,u,u,u,u,u,u,u,u,u,u,u]
; X86-NEXT:    vmovd %xmm0, %ecx
; X86-NEXT:    orl $-16777216, %ecx # imm = 0xFF000000
; X86-NEXT:    movl %ecx, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: fetch_r16g16_snorm_unorm8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-NEXT:    vpmaxsw %xmm1, %xmm0, %xmm0
; X64-NEXT:    vpsrlw $7, %xmm0, %xmm0
; X64-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2],zero,xmm0[u,u,u,u,u,u,u,u,u,u,u,u,u]
; X64-NEXT:    vmovd %xmm0, %eax
; X64-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rdi)
; X64-NEXT:    retq
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
