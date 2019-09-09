; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+sse | FileCheck %s --check-prefixes=X64,X64-SSE
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+sse | FileCheck %s --check-prefixes=X64,X64-SSE
; RUN: llc < %s -O2 -mtriple=i686-linux-gnu -mattr=+mmx | FileCheck %s --check-prefix=X32
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+avx | FileCheck %s --check-prefixes=X64,X64-AVX
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+avx | FileCheck %s --check-prefixes=X64,X64-AVX
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+avx512f | FileCheck %s --check-prefixes=X64,X64-AVX
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+avx512f | FileCheck %s --check-prefixes=X64,X64-AVX

; Check soft floating point conversion function calls.

@vi32 = common global i32 0, align 4
@vi64 = common global i64 0, align 8
@vu32 = common global i32 0, align 4
@vu64 = common global i64 0, align 8
@vf32 = common global float 0.000000e+00, align 4
@vf64 = common global double 0.000000e+00, align 8
@vf80 = common global x86_fp80 0xK00000000000000000000, align 8
@vf128 = common global fp128 0xL00000000000000000000000000000000, align 16

define void @TestFPExtF32_F128() nounwind {
; X64-SSE-LABEL: TestFPExtF32_F128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-SSE-NEXT:    callq __extendsftf2
; X64-SSE-NEXT:    movaps %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPExtF32_F128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $24, %esp
; X32-NEXT:    flds vf32
; X32-NEXT:    fstps {{[0-9]+}}(%esp)
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, (%esp)
; X32-NEXT:    calll __extendsftf2
; X32-NEXT:    subl $4, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, vf128+12
; X32-NEXT:    movl %edx, vf128+8
; X32-NEXT:    movl %ecx, vf128+4
; X32-NEXT:    movl %eax, vf128
; X32-NEXT:    addl $24, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPExtF32_F128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-AVX-NEXT:    callq __extendsftf2
; X64-AVX-NEXT:    vmovaps %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load float, float* @vf32, align 4
  %conv = fpext float %0 to fp128
  store fp128 %conv, fp128* @vf128, align 16
  ret void
}

define void @TestFPExtF64_F128() nounwind {
; X64-SSE-LABEL: TestFPExtF64_F128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X64-SSE-NEXT:    callq __extenddftf2
; X64-SSE-NEXT:    movaps %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPExtF64_F128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $40, %esp
; X32-NEXT:    fldl vf64
; X32-NEXT:    fstpl {{[0-9]+}}(%esp)
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, (%esp)
; X32-NEXT:    calll __extenddftf2
; X32-NEXT:    subl $4, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, vf128+12
; X32-NEXT:    movl %edx, vf128+8
; X32-NEXT:    movl %ecx, vf128+4
; X32-NEXT:    movl %eax, vf128
; X32-NEXT:    addl $40, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPExtF64_F128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X64-AVX-NEXT:    callq __extenddftf2
; X64-AVX-NEXT:    vmovaps %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load double, double* @vf64, align 8
  %conv = fpext double %0 to fp128
  store fp128 %conv, fp128* @vf128, align 16
  ret void
}

define void @TestFPExtF80_F128() nounwind {
; X64-SSE-LABEL: TestFPExtF80_F128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    subq $24, %rsp
; X64-SSE-NEXT:    fldt {{.*}}(%rip)
; X64-SSE-NEXT:    fstpt (%rsp)
; X64-SSE-NEXT:    callq __extendxftf2
; X64-SSE-NEXT:    movaps %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    addq $24, %rsp
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPExtF80_F128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $40, %esp
; X32-NEXT:    fldt vf80
; X32-NEXT:    fstpt {{[0-9]+}}(%esp)
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, (%esp)
; X32-NEXT:    calll __extendxftf2
; X32-NEXT:    subl $4, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, vf128+12
; X32-NEXT:    movl %edx, vf128+8
; X32-NEXT:    movl %ecx, vf128+4
; X32-NEXT:    movl %eax, vf128
; X32-NEXT:    addl $40, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPExtF80_F128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    subq $24, %rsp
; X64-AVX-NEXT:    fldt {{.*}}(%rip)
; X64-AVX-NEXT:    fstpt (%rsp)
; X64-AVX-NEXT:    callq __extendxftf2
; X64-AVX-NEXT:    vmovaps %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    addq $24, %rsp
; X64-AVX-NEXT:    retq
entry:
  %0 = load x86_fp80, x86_fp80* @vf80, align 8
  %conv = fpext x86_fp80 %0 to fp128
  store fp128 %conv, fp128* @vf128, align 16
  ret void
}

define void @TestFPToSIF128_I32() nounwind {
; X64-SSE-LABEL: TestFPToSIF128_I32:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    callq __fixtfsi
; X64-SSE-NEXT:    movl %eax, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPToSIF128_I32:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl vf128+12
; X32-NEXT:    pushl vf128+8
; X32-NEXT:    pushl vf128+4
; X32-NEXT:    pushl vf128
; X32-NEXT:    calll __fixtfsi
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    movl %eax, vi32
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPToSIF128_I32:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    callq __fixtfsi
; X64-AVX-NEXT:    movl %eax, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load fp128, fp128* @vf128, align 16
  %conv = fptosi fp128 %0 to i32
  store i32 %conv, i32* @vi32, align 4
  ret void
}

define void @TestFPToUIF128_U32() nounwind {
; X64-SSE-LABEL: TestFPToUIF128_U32:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    callq __fixunstfsi
; X64-SSE-NEXT:    movl %eax, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPToUIF128_U32:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl vf128+12
; X32-NEXT:    pushl vf128+8
; X32-NEXT:    pushl vf128+4
; X32-NEXT:    pushl vf128
; X32-NEXT:    calll __fixunstfsi
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    movl %eax, vu32
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPToUIF128_U32:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    callq __fixunstfsi
; X64-AVX-NEXT:    movl %eax, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load fp128, fp128* @vf128, align 16
  %conv = fptoui fp128 %0 to i32
  store i32 %conv, i32* @vu32, align 4
  ret void
}

define void @TestFPToSIF128_I64() nounwind {
; X64-SSE-LABEL: TestFPToSIF128_I64:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    callq __fixtfsi
; X64-SSE-NEXT:    cltq
; X64-SSE-NEXT:    movq %rax, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPToSIF128_I64:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl vf128+12
; X32-NEXT:    pushl vf128+8
; X32-NEXT:    pushl vf128+4
; X32-NEXT:    pushl vf128
; X32-NEXT:    calll __fixtfsi
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    movl %eax, vi64
; X32-NEXT:    sarl $31, %eax
; X32-NEXT:    movl %eax, vi64+4
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPToSIF128_I64:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    callq __fixtfsi
; X64-AVX-NEXT:    cltq
; X64-AVX-NEXT:    movq %rax, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load fp128, fp128* @vf128, align 16
  %conv = fptosi fp128 %0 to i32
  %conv1 = sext i32 %conv to i64
  store i64 %conv1, i64* @vi64, align 8
  ret void
}

define void @TestFPToUIF128_U64() nounwind {
; X64-SSE-LABEL: TestFPToUIF128_U64:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    callq __fixunstfsi
; X64-SSE-NEXT:    movl %eax, %eax
; X64-SSE-NEXT:    movq %rax, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPToUIF128_U64:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl vf128+12
; X32-NEXT:    pushl vf128+8
; X32-NEXT:    pushl vf128+4
; X32-NEXT:    pushl vf128
; X32-NEXT:    calll __fixunstfsi
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    movl %eax, vu64
; X32-NEXT:    movl $0, vu64+4
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPToUIF128_U64:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    callq __fixunstfsi
; X64-AVX-NEXT:    movl %eax, %eax
; X64-AVX-NEXT:    movq %rax, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load fp128, fp128* @vf128, align 16
  %conv = fptoui fp128 %0 to i32
  %conv1 = zext i32 %conv to i64
  store i64 %conv1, i64* @vu64, align 8
  ret void
}

define void @TestFPTruncF128_F32() nounwind {
; X64-SSE-LABEL: TestFPTruncF128_F32:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    callq __trunctfsf2
; X64-SSE-NEXT:    movss %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPTruncF128_F32:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl vf128+12
; X32-NEXT:    pushl vf128+8
; X32-NEXT:    pushl vf128+4
; X32-NEXT:    pushl vf128
; X32-NEXT:    calll __trunctfsf2
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    fstps vf32
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPTruncF128_F32:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    callq __trunctfsf2
; X64-AVX-NEXT:    vmovss %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load fp128, fp128* @vf128, align 16
  %conv = fptrunc fp128 %0 to float
  store float %conv, float* @vf32, align 4
  ret void
}

define void @TestFPTruncF128_F64() nounwind {
; X64-SSE-LABEL: TestFPTruncF128_F64:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    callq __trunctfdf2
; X64-SSE-NEXT:    movsd %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPTruncF128_F64:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl vf128+12
; X32-NEXT:    pushl vf128+8
; X32-NEXT:    pushl vf128+4
; X32-NEXT:    pushl vf128
; X32-NEXT:    calll __trunctfdf2
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    fstpl vf64
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPTruncF128_F64:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    callq __trunctfdf2
; X64-AVX-NEXT:    vmovsd %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load fp128, fp128* @vf128, align 16
  %conv = fptrunc fp128 %0 to double
  store double %conv, double* @vf64, align 8
  ret void
}

define void @TestFPTruncF128_F80() nounwind {
; X64-SSE-LABEL: TestFPTruncF128_F80:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    subq $24, %rsp
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    callq __trunctfxf2
; X64-SSE-NEXT:    fstpt (%rsp)
; X64-SSE-NEXT:    movq (%rsp), %rax
; X64-SSE-NEXT:    movq %rax, {{.*}}(%rip)
; X64-SSE-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; X64-SSE-NEXT:    movw %ax, vf80+{{.*}}(%rip)
; X64-SSE-NEXT:    addq $24, %rsp
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestFPTruncF128_F80:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl vf128+12
; X32-NEXT:    pushl vf128+8
; X32-NEXT:    pushl vf128+4
; X32-NEXT:    pushl vf128
; X32-NEXT:    calll __trunctfxf2
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    fstpt vf80
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestFPTruncF128_F80:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    subq $24, %rsp
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    callq __trunctfxf2
; X64-AVX-NEXT:    fstpt (%rsp)
; X64-AVX-NEXT:    movq (%rsp), %rax
; X64-AVX-NEXT:    movq %rax, {{.*}}(%rip)
; X64-AVX-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; X64-AVX-NEXT:    movw %ax, vf80+{{.*}}(%rip)
; X64-AVX-NEXT:    addq $24, %rsp
; X64-AVX-NEXT:    retq
entry:
  %0 = load fp128, fp128* @vf128, align 16
  %conv = fptrunc fp128 %0 to x86_fp80
  store x86_fp80 %conv, x86_fp80* @vf80, align 8
  ret void
}

define void @TestSIToFPI32_F128() nounwind {
; X64-SSE-LABEL: TestSIToFPI32_F128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movl {{.*}}(%rip), %edi
; X64-SSE-NEXT:    callq __floatsitf
; X64-SSE-NEXT:    movaps %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestSIToFPI32_F128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    pushl vi32
; X32-NEXT:    pushl %eax
; X32-NEXT:    calll __floatsitf
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, vf128+12
; X32-NEXT:    movl %edx, vf128+8
; X32-NEXT:    movl %ecx, vf128+4
; X32-NEXT:    movl %eax, vf128
; X32-NEXT:    addl $24, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestSIToFPI32_F128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    movl {{.*}}(%rip), %edi
; X64-AVX-NEXT:    callq __floatsitf
; X64-AVX-NEXT:    vmovaps %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load i32, i32* @vi32, align 4
  %conv = sitofp i32 %0 to fp128
  store fp128 %conv, fp128* @vf128, align 16
  ret void
}

define void @TestUIToFPU32_F128() #2 {
; X64-SSE-LABEL: TestUIToFPU32_F128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movl {{.*}}(%rip), %edi
; X64-SSE-NEXT:    callq __floatunsitf
; X64-SSE-NEXT:    movaps %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestUIToFPU32_F128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $32, %esp
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    pushl vu32
; X32-NEXT:    pushl %eax
; X32-NEXT:    calll __floatunsitf
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, vf128+12
; X32-NEXT:    movl %edx, vf128+8
; X32-NEXT:    movl %ecx, vf128+4
; X32-NEXT:    movl %eax, vf128
; X32-NEXT:    addl $24, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestUIToFPU32_F128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    movl {{.*}}(%rip), %edi
; X64-AVX-NEXT:    callq __floatunsitf
; X64-AVX-NEXT:    vmovaps %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load i32, i32* @vu32, align 4
  %conv = uitofp i32 %0 to fp128
  store fp128 %conv, fp128* @vf128, align 16
  ret void
}

define void @TestSIToFPI64_F128() nounwind {
; X64-SSE-LABEL: TestSIToFPI64_F128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movq {{.*}}(%rip), %rdi
; X64-SSE-NEXT:    callq __floatditf
; X64-SSE-NEXT:    movaps %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestSIToFPI64_F128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $28, %esp
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    pushl vi64+4
; X32-NEXT:    pushl vi64
; X32-NEXT:    pushl %eax
; X32-NEXT:    calll __floatditf
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, vf128+12
; X32-NEXT:    movl %edx, vf128+8
; X32-NEXT:    movl %ecx, vf128+4
; X32-NEXT:    movl %eax, vf128
; X32-NEXT:    addl $24, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestSIToFPI64_F128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    movq {{.*}}(%rip), %rdi
; X64-AVX-NEXT:    callq __floatditf
; X64-AVX-NEXT:    vmovaps %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load i64, i64* @vi64, align 8
  %conv = sitofp i64 %0 to fp128
  store fp128 %conv, fp128* @vf128, align 16
  ret void
}

define void @TestUIToFPU64_F128() #2 {
; X64-SSE-LABEL: TestUIToFPU64_F128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movq {{.*}}(%rip), %rdi
; X64-SSE-NEXT:    callq __floatunditf
; X64-SSE-NEXT:    movaps %xmm0, {{.*}}(%rip)
; X64-SSE-NEXT:    popq %rax
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestUIToFPU64_F128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $28, %esp
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    pushl vu64+4
; X32-NEXT:    pushl vu64
; X32-NEXT:    pushl %eax
; X32-NEXT:    calll __floatunditf
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, vf128+12
; X32-NEXT:    movl %edx, vf128+8
; X32-NEXT:    movl %ecx, vf128+4
; X32-NEXT:    movl %eax, vf128
; X32-NEXT:    addl $24, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestUIToFPU64_F128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    movq {{.*}}(%rip), %rdi
; X64-AVX-NEXT:    callq __floatunditf
; X64-AVX-NEXT:    vmovaps %xmm0, {{.*}}(%rip)
; X64-AVX-NEXT:    popq %rax
; X64-AVX-NEXT:    retq
entry:
  %0 = load i64, i64* @vu64, align 8
  %conv = uitofp i64 %0 to fp128
  store fp128 %conv, fp128* @vf128, align 16
  ret void
}

define i32 @TestConst128(fp128 %v) nounwind {
; X64-SSE-LABEL: TestConst128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm1
; X64-SSE-NEXT:    callq __gttf2
; X64-SSE-NEXT:    xorl %ecx, %ecx
; X64-SSE-NEXT:    testl %eax, %eax
; X64-SSE-NEXT:    setg %cl
; X64-SSE-NEXT:    movl %ecx, %eax
; X64-SSE-NEXT:    popq %rcx
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestConst128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    pushl $1073676288 # imm = 0x3FFF0000
; X32-NEXT:    pushl $0
; X32-NEXT:    pushl $0
; X32-NEXT:    pushl $0
; X32-NEXT:    pushl {{[0-9]+}}(%esp)
; X32-NEXT:    pushl {{[0-9]+}}(%esp)
; X32-NEXT:    pushl {{[0-9]+}}(%esp)
; X32-NEXT:    pushl {{[0-9]+}}(%esp)
; X32-NEXT:    calll __gttf2
; X32-NEXT:    addl $32, %esp
; X32-NEXT:    xorl %ecx, %ecx
; X32-NEXT:    testl %eax, %eax
; X32-NEXT:    setg %cl
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestConst128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm1
; X64-AVX-NEXT:    callq __gttf2
; X64-AVX-NEXT:    xorl %ecx, %ecx
; X64-AVX-NEXT:    testl %eax, %eax
; X64-AVX-NEXT:    setg %cl
; X64-AVX-NEXT:    movl %ecx, %eax
; X64-AVX-NEXT:    popq %rcx
; X64-AVX-NEXT:    retq
entry:
  %cmp = fcmp ogt fp128 %v, 0xL00000000000000003FFF000000000000
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; C code:
;  struct TestBits_ieee_ext {
;    unsigned v1;
;    unsigned v2;
; };
; union TestBits_LDU {
;   FP128 ld;
;   struct TestBits_ieee_ext bits;
; };
; int TestBits128(FP128 ld) {
;   union TestBits_LDU u;
;   u.ld = ld * ld;
;   return ((u.bits.v1 | u.bits.v2)  == 0);
; }
define i32 @TestBits128(fp128 %ld) nounwind {
; X64-SSE-LABEL: TestBits128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    subq $24, %rsp
; X64-SSE-NEXT:    movaps %xmm0, %xmm1
; X64-SSE-NEXT:    callq __multf3
; X64-SSE-NEXT:    movaps %xmm0, (%rsp)
; X64-SSE-NEXT:    movq (%rsp), %rcx
; X64-SSE-NEXT:    movq %rcx, %rdx
; X64-SSE-NEXT:    shrq $32, %rdx
; X64-SSE-NEXT:    xorl %eax, %eax
; X64-SSE-NEXT:    orl %ecx, %edx
; X64-SSE-NEXT:    sete %al
; X64-SSE-NEXT:    addq $24, %rsp
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestBits128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $20, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    leal {{[0-9]+}}(%esp), %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    pushl %edx
; X32-NEXT:    pushl %ecx
; X32-NEXT:    pushl %eax
; X32-NEXT:    pushl %esi
; X32-NEXT:    pushl %edx
; X32-NEXT:    pushl %ecx
; X32-NEXT:    pushl %eax
; X32-NEXT:    pushl %edi
; X32-NEXT:    calll __multf3
; X32-NEXT:    addl $44, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    orl (%esp), %ecx
; X32-NEXT:    sete %al
; X32-NEXT:    addl $20, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    retl
;
; X64-AVX-LABEL: TestBits128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    subq $24, %rsp
; X64-AVX-NEXT:    vmovaps %xmm0, %xmm1
; X64-AVX-NEXT:    callq __multf3
; X64-AVX-NEXT:    vmovaps %xmm0, (%rsp)
; X64-AVX-NEXT:    movq (%rsp), %rcx
; X64-AVX-NEXT:    movq %rcx, %rdx
; X64-AVX-NEXT:    shrq $32, %rdx
; X64-AVX-NEXT:    xorl %eax, %eax
; X64-AVX-NEXT:    orl %ecx, %edx
; X64-AVX-NEXT:    sete %al
; X64-AVX-NEXT:    addq $24, %rsp
; X64-AVX-NEXT:    retq
entry:
  %mul = fmul fp128 %ld, %ld
  %0 = bitcast fp128 %mul to i128
  %shift = lshr i128 %0, 32
  %or5 = or i128 %shift, %0
  %or = trunc i128 %or5 to i32
  %cmp = icmp eq i32 %or, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
; If TestBits128 fails due to any llvm or clang change,
; please make sure the original simplified C code will
; be compiled into correct IL and assembly code, not
; just this TestBits128 test case. Better yet, try to
; test the whole libm and its test cases.
}

; C code: (compiled with -target x86_64-linux-android)
; typedef long double __float128;
; __float128 TestPair128(unsigned long a, unsigned long b) {
;   unsigned __int128 n;
;   unsigned __int128 v1 = ((unsigned __int128)a << 64);
;   unsigned __int128 v2 = (unsigned __int128)b;
;   n = (v1 | v2) + 3;
;   return *(__float128*)&n;
; }
define fp128 @TestPair128(i64 %a, i64 %b) nounwind {
; X64-SSE-LABEL: TestPair128:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    addq $3, %rsi
; X64-SSE-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; X64-SSE-NEXT:    adcq $0, %rdi
; X64-SSE-NEXT:    movq %rdi, -{{[0-9]+}}(%rsp)
; X64-SSE-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestPair128:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:    addl $3, %ecx
; X32-NEXT:    adcl $0, %edx
; X32-NEXT:    adcl $0, %esi
; X32-NEXT:    adcl $0, %edi
; X32-NEXT:    movl %edx, 4(%eax)
; X32-NEXT:    movl %ecx, (%eax)
; X32-NEXT:    movl %esi, 8(%eax)
; X32-NEXT:    movl %edi, 12(%eax)
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    retl $4
;
; X64-AVX-LABEL: TestPair128:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    addq $3, %rsi
; X64-AVX-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; X64-AVX-NEXT:    adcq $0, %rdi
; X64-AVX-NEXT:    movq %rdi, -{{[0-9]+}}(%rsp)
; X64-AVX-NEXT:    vmovaps -{{[0-9]+}}(%rsp), %xmm0
; X64-AVX-NEXT:    retq
entry:
  %conv = zext i64 %a to i128
  %shl = shl nuw i128 %conv, 64
  %conv1 = zext i64 %b to i128
  %or = or i128 %shl, %conv1
  %add = add i128 %or, 3
  %0 = bitcast i128 %add to fp128
  ret fp128 %0
}

define fp128 @TestTruncCopysign(fp128 %x, i32 %n) nounwind {
; X64-SSE-LABEL: TestTruncCopysign:
; X64-SSE:       # %bb.0: # %entry
; X64-SSE-NEXT:    cmpl $50001, %edi # imm = 0xC351
; X64-SSE-NEXT:    jl .LBB17_2
; X64-SSE-NEXT:  # %bb.1: # %if.then
; X64-SSE-NEXT:    pushq %rax
; X64-SSE-NEXT:    callq __trunctfdf2
; X64-SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; X64-SSE-NEXT:    orps %xmm1, %xmm0
; X64-SSE-NEXT:    callq __extenddftf2
; X64-SSE-NEXT:    addq $8, %rsp
; X64-SSE-NEXT:  .LBB17_2: # %cleanup
; X64-SSE-NEXT:    retq
;
; X32-LABEL: TestTruncCopysign:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $36, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    cmpl $50001, {{[0-9]+}}(%esp) # imm = 0xC351
; X32-NEXT:    jl .LBB17_4
; X32-NEXT:  # %bb.1: # %if.then
; X32-NEXT:    pushl %eax
; X32-NEXT:    pushl %ecx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %edx
; X32-NEXT:    calll __trunctfdf2
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    fstpl {{[0-9]+}}(%esp)
; X32-NEXT:    testb $-128, {{[0-9]+}}(%esp)
; X32-NEXT:    flds {{\.LCPI.*}}
; X32-NEXT:    flds {{\.LCPI.*}}
; X32-NEXT:    jne .LBB17_3
; X32-NEXT:  # %bb.2: # %if.then
; X32-NEXT:    fstp %st(1)
; X32-NEXT:    fldz
; X32-NEXT:  .LBB17_3: # %if.then
; X32-NEXT:    fstp %st(0)
; X32-NEXT:    subl $16, %esp
; X32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl %eax, (%esp)
; X32-NEXT:    fstpl {{[0-9]+}}(%esp)
; X32-NEXT:    calll __extenddftf2
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:  .LBB17_4: # %cleanup
; X32-NEXT:    movl %edx, (%esi)
; X32-NEXT:    movl %edi, 4(%esi)
; X32-NEXT:    movl %ecx, 8(%esi)
; X32-NEXT:    movl %eax, 12(%esi)
; X32-NEXT:    movl %esi, %eax
; X32-NEXT:    addl $36, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    retl $4
;
; X64-AVX-LABEL: TestTruncCopysign:
; X64-AVX:       # %bb.0: # %entry
; X64-AVX-NEXT:    cmpl $50001, %edi # imm = 0xC351
; X64-AVX-NEXT:    jl .LBB17_2
; X64-AVX-NEXT:  # %bb.1: # %if.then
; X64-AVX-NEXT:    pushq %rax
; X64-AVX-NEXT:    callq __trunctfdf2
; X64-AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vmovddup {{.*#+}} xmm1 = [+Inf,+Inf]
; X64-AVX-NEXT:    # xmm1 = mem[0,0]
; X64-AVX-NEXT:    vorps %xmm0, %xmm1, %xmm0
; X64-AVX-NEXT:    callq __extenddftf2
; X64-AVX-NEXT:    addq $8, %rsp
; X64-AVX-NEXT:  .LBB17_2: # %cleanup
; X64-AVX-NEXT:    retq
entry:
  %cmp = icmp sgt i32 %n, 50000
  br i1 %cmp, label %if.then, label %cleanup

if.then:                                          ; preds = %entry
  %conv = fptrunc fp128 %x to double
  %call = tail call double @copysign(double 0x7FF0000000000000, double %conv) #2
  %conv1 = fpext double %call to fp128
  br label %cleanup

cleanup:                                          ; preds = %entry, %if.then
  %retval.0 = phi fp128 [ %conv1, %if.then ], [ %x, %entry ]
  ret fp128 %retval.0
}

define i1 @PR34866(i128 %x) nounwind {
; X64-SSE-LABEL: PR34866:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-SSE-NEXT:    xorq -{{[0-9]+}}(%rsp), %rsi
; X64-SSE-NEXT:    xorq -{{[0-9]+}}(%rsp), %rdi
; X64-SSE-NEXT:    orq %rsi, %rdi
; X64-SSE-NEXT:    sete %al
; X64-SSE-NEXT:    retq
;
; X32-LABEL: PR34866:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    orl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    sete %al
; X32-NEXT:    retl
;
; X64-AVX-LABEL: PR34866:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-AVX-NEXT:    xorq -{{[0-9]+}}(%rsp), %rsi
; X64-AVX-NEXT:    xorq -{{[0-9]+}}(%rsp), %rdi
; X64-AVX-NEXT:    orq %rsi, %rdi
; X64-AVX-NEXT:    sete %al
; X64-AVX-NEXT:    retq
  %bc_mmx = bitcast fp128 0xL00000000000000000000000000000000 to i128
  %cmp = icmp eq i128 %bc_mmx, %x
  ret i1 %cmp
}

define i1 @PR34866_commute(i128 %x) nounwind {
; X64-SSE-LABEL: PR34866_commute:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movaps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-SSE-NEXT:    xorq -{{[0-9]+}}(%rsp), %rsi
; X64-SSE-NEXT:    xorq -{{[0-9]+}}(%rsp), %rdi
; X64-SSE-NEXT:    orq %rsi, %rdi
; X64-SSE-NEXT:    sete %al
; X64-SSE-NEXT:    retq
;
; X32-LABEL: PR34866_commute:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    orl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    orl %ecx, %eax
; X32-NEXT:    sete %al
; X32-NEXT:    retl
;
; X64-AVX-LABEL: PR34866_commute:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm0
; X64-AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-AVX-NEXT:    xorq -{{[0-9]+}}(%rsp), %rsi
; X64-AVX-NEXT:    xorq -{{[0-9]+}}(%rsp), %rdi
; X64-AVX-NEXT:    orq %rsi, %rdi
; X64-AVX-NEXT:    sete %al
; X64-AVX-NEXT:    retq
  %bc_mmx = bitcast fp128 0xL00000000000000000000000000000000 to i128
  %cmp = icmp eq i128 %x, %bc_mmx
  ret i1 %cmp
}


declare double @copysign(double, double) #1

attributes #2 = { nounwind readnone }
