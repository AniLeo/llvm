; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-pc-win32       -mattr=+avx512bw  | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-win32        -mattr=+avx512bw  | FileCheck %s --check-prefix=CHECK64 --check-prefix=WIN64
; RUN: llc < %s -mtriple=x86_64-linux-gnu    -mattr=+avx512bw  | FileCheck %s --check-prefix=CHECK64 --check-prefix=LINUXOSX64

; Test regcall when receiving arguments of v64i1 type
define x86_regcallcc i64 @test_argv64i1(<64 x i1> %x0, <64 x i1> %x1, <64 x i1> %x2, <64 x i1> %x3, <64 x i1> %x4, <64 x i1> %x5, <64 x i1> %x6, <64 x i1> %x7, <64 x i1> %x8, <64 x i1> %x9, <64 x i1> %x10, <64 x i1> %x11, <64 x i1> %x12)  {
; X32-LABEL: test_argv64i1:
; X32:       # %bb.0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-8, %esp
; X32-NEXT:    subl $16, %esp
; X32-NEXT:    kmovd %edx, %k0
; X32-NEXT:    kmovd %edi, %k1
; X32-NEXT:    kunpckdq %k0, %k1, %k0
; X32-NEXT:    kmovd %eax, %k1
; X32-NEXT:    kmovd %ecx, %k2
; X32-NEXT:    kunpckdq %k1, %k2, %k1
; X32-NEXT:    kmovq %k1, {{[0-9]+}}(%esp)
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    kmovq %k0, (%esp)
; X32-NEXT:    addl (%esp), %eax
; X32-NEXT:    adcl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    addl 8(%ebp), %eax
; X32-NEXT:    adcl 12(%ebp), %ecx
; X32-NEXT:    addl 16(%ebp), %eax
; X32-NEXT:    adcl 20(%ebp), %ecx
; X32-NEXT:    addl 24(%ebp), %eax
; X32-NEXT:    adcl 28(%ebp), %ecx
; X32-NEXT:    addl 32(%ebp), %eax
; X32-NEXT:    adcl 36(%ebp), %ecx
; X32-NEXT:    addl 40(%ebp), %eax
; X32-NEXT:    adcl 44(%ebp), %ecx
; X32-NEXT:    addl 48(%ebp), %eax
; X32-NEXT:    adcl 52(%ebp), %ecx
; X32-NEXT:    addl 56(%ebp), %eax
; X32-NEXT:    adcl 60(%ebp), %ecx
; X32-NEXT:    addl 64(%ebp), %eax
; X32-NEXT:    adcl 68(%ebp), %ecx
; X32-NEXT:    addl 72(%ebp), %eax
; X32-NEXT:    adcl 76(%ebp), %ecx
; X32-NEXT:    addl 80(%ebp), %eax
; X32-NEXT:    adcl 84(%ebp), %ecx
; X32-NEXT:    addl 88(%ebp), %eax
; X32-NEXT:    adcl 92(%ebp), %ecx
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; WIN64-LABEL: test_argv64i1:
; WIN64:       # %bb.0:
; WIN64-NEXT:    addq %rcx, %rax
; WIN64-NEXT:    addq %rdx, %rax
; WIN64-NEXT:    addq %rdi, %rax
; WIN64-NEXT:    addq %rsi, %rax
; WIN64-NEXT:    addq %r8, %rax
; WIN64-NEXT:    addq %r9, %rax
; WIN64-NEXT:    addq %r10, %rax
; WIN64-NEXT:    addq %r11, %rax
; WIN64-NEXT:    addq %r12, %rax
; WIN64-NEXT:    addq %r14, %rax
; WIN64-NEXT:    addq %r15, %rax
; WIN64-NEXT:    addq {{[0-9]+}}(%rsp), %rax
; WIN64-NEXT:    retq
;
; LINUXOSX64-LABEL: test_argv64i1:
; LINUXOSX64:       # %bb.0:
; LINUXOSX64-NEXT:    addq %rcx, %rax
; LINUXOSX64-NEXT:    addq %rdx, %rax
; LINUXOSX64-NEXT:    addq %rdi, %rax
; LINUXOSX64-NEXT:    addq %rsi, %rax
; LINUXOSX64-NEXT:    addq %r8, %rax
; LINUXOSX64-NEXT:    addq %r9, %rax
; LINUXOSX64-NEXT:    addq %r12, %rax
; LINUXOSX64-NEXT:    addq %r13, %rax
; LINUXOSX64-NEXT:    addq %r14, %rax
; LINUXOSX64-NEXT:    addq %r15, %rax
; LINUXOSX64-NEXT:    addq {{[0-9]+}}(%rsp), %rax
; LINUXOSX64-NEXT:    addq {{[0-9]+}}(%rsp), %rax
; LINUXOSX64-NEXT:    retq
  %y0 = bitcast <64 x i1> %x0 to i64
  %y1 = bitcast <64 x i1> %x1 to i64
  %y2 = bitcast <64 x i1> %x2 to i64
  %y3 = bitcast <64 x i1> %x3 to i64
  %y4 = bitcast <64 x i1> %x4 to i64
  %y5 = bitcast <64 x i1> %x5 to i64
  %y6 = bitcast <64 x i1> %x6 to i64
  %y7 = bitcast <64 x i1> %x7 to i64
  %y8 = bitcast <64 x i1> %x8 to i64
  %y9 = bitcast <64 x i1> %x9 to i64
  %y10 = bitcast <64 x i1> %x10 to i64
  %y11 = bitcast <64 x i1> %x11 to i64
  %y12 = bitcast <64 x i1> %x12 to i64
  %add1 = add i64 %y0, %y1
  %add2 = add i64 %add1, %y2
  %add3 = add i64 %add2, %y3
  %add4 = add i64 %add3, %y4
  %add5 = add i64 %add4, %y5
  %add6 = add i64 %add5, %y6
  %add7 = add i64 %add6, %y7
  %add8 = add i64 %add7, %y8
  %add9 = add i64 %add8, %y9
  %add10 = add i64 %add9, %y10
  %add11 = add i64 %add10, %y11
  %add12 = add i64 %add11, %y12
  ret i64 %add12
}

; Test regcall when passing arguments of v64i1 type
define i64 @caller_argv64i1() #0 {
; X32-LABEL: caller_argv64i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %edi
; X32-NEXT:    subl $88, %esp
; X32-NEXT:    vmovaps {{.*#+}} xmm0 = [2,1,2,1]
; X32-NEXT:    vmovups %xmm0, {{[0-9]+}}(%esp)
; X32-NEXT:    vmovaps {{.*#+}} zmm0 = [2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1]
; X32-NEXT:    vmovups %zmm0, (%esp)
; X32-NEXT:    movl $1, {{[0-9]+}}(%esp)
; X32-NEXT:    movl $2, {{[0-9]+}}(%esp)
; X32-NEXT:    movl $2, %eax
; X32-NEXT:    movl $1, %ecx
; X32-NEXT:    movl $2, %edx
; X32-NEXT:    movl $1, %edi
; X32-NEXT:    vzeroupper
; X32-NEXT:    calll _test_argv64i1
; X32-NEXT:    movl %ecx, %edx
; X32-NEXT:    addl $88, %esp
; X32-NEXT:    popl %edi
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_argv64i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %r15
; WIN64-NEXT:    .seh_pushreg 15
; WIN64-NEXT:    pushq %r14
; WIN64-NEXT:    .seh_pushreg 14
; WIN64-NEXT:    pushq %r12
; WIN64-NEXT:    .seh_pushreg 12
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $48, %rsp
; WIN64-NEXT:    .seh_stackalloc 48
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 32
; WIN64-NEXT:    vmovaps %xmm6, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 16
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    movabsq $4294967298, %rax # imm = 0x100000002
; WIN64-NEXT:    movq %rax, (%rsp)
; WIN64-NEXT:    movq %rax, %rcx
; WIN64-NEXT:    movq %rax, %rdx
; WIN64-NEXT:    movq %rax, %rdi
; WIN64-NEXT:    movq %rax, %rsi
; WIN64-NEXT:    movq %rax, %r8
; WIN64-NEXT:    movq %rax, %r9
; WIN64-NEXT:    movq %rax, %r10
; WIN64-NEXT:    movq %rax, %r11
; WIN64-NEXT:    movq %rax, %r12
; WIN64-NEXT:    movq %rax, %r14
; WIN64-NEXT:    movq %rax, %r15
; WIN64-NEXT:    callq test_argv64i1
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $48, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    popq %r12
; WIN64-NEXT:    popq %r14
; WIN64-NEXT:    popq %r15
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_argv64i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %r15
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    pushq %r14
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 24
; LINUXOSX64-NEXT:    pushq %r13
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 32
; LINUXOSX64-NEXT:    pushq %r12
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 40
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 48
; LINUXOSX64-NEXT:    .cfi_offset %r12, -40
; LINUXOSX64-NEXT:    .cfi_offset %r13, -32
; LINUXOSX64-NEXT:    .cfi_offset %r14, -24
; LINUXOSX64-NEXT:    .cfi_offset %r15, -16
; LINUXOSX64-NEXT:    movabsq $4294967298, %rax # imm = 0x100000002
; LINUXOSX64-NEXT:    movq %rax, %rcx
; LINUXOSX64-NEXT:    movq %rax, %rdx
; LINUXOSX64-NEXT:    movq %rax, %rdi
; LINUXOSX64-NEXT:    movq %rax, %rsi
; LINUXOSX64-NEXT:    movq %rax, %r8
; LINUXOSX64-NEXT:    movq %rax, %r9
; LINUXOSX64-NEXT:    movq %rax, %r12
; LINUXOSX64-NEXT:    movq %rax, %r13
; LINUXOSX64-NEXT:    movq %rax, %r14
; LINUXOSX64-NEXT:    movq %rax, %r15
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_adjust_cfa_offset 8
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_adjust_cfa_offset 8
; LINUXOSX64-NEXT:    callq test_argv64i1
; LINUXOSX64-NEXT:    addq $24, %rsp
; LINUXOSX64-NEXT:    .cfi_adjust_cfa_offset -16
; LINUXOSX64-NEXT:    popq %r12
; LINUXOSX64-NEXT:    popq %r13
; LINUXOSX64-NEXT:    popq %r14
; LINUXOSX64-NEXT:    popq %r15
; LINUXOSX64-NEXT:    retq
entry:
  %v0 = bitcast i64 4294967298 to <64 x i1>
  %call = call x86_regcallcc i64 @test_argv64i1(<64 x i1> %v0, <64 x i1> %v0, <64 x i1> %v0,
                                                <64 x i1> %v0, <64 x i1> %v0, <64 x i1> %v0,
                                                <64 x i1> %v0, <64 x i1> %v0, <64 x i1> %v0,
                                                <64 x i1> %v0, <64 x i1> %v0, <64 x i1> %v0,
                                                <64 x i1> %v0)
  ret i64 %call
}

; Test regcall when returning v64i1 type
define x86_regcallcc <64 x i1> @test_retv64i1()  {
; X32-LABEL: test_retv64i1:
; X32:       # %bb.0:
; X32-NEXT:    movl $2, %eax
; X32-NEXT:    movl $1, %ecx
; X32-NEXT:    retl
;
; CHECK64-LABEL: test_retv64i1:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movabsq $4294967298, %rax # imm = 0x100000002
; CHECK64-NEXT:    retq
  %a = bitcast i64 4294967298 to <64 x i1>
 ret <64 x i1> %a
}

; Test regcall when processing result of v64i1 type
define <64 x i1> @caller_retv64i1() #0 {
; X32-LABEL: caller_retv64i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    calll _test_retv64i1
; X32-NEXT:    kmovd %eax, %k0
; X32-NEXT:    kmovd %ecx, %k1
; X32-NEXT:    kunpckdq %k0, %k1, %k0
; X32-NEXT:    vpmovm2b %k0, %zmm0
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_retv64i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $40, %rsp
; WIN64-NEXT:    .seh_stackalloc 40
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 16
; WIN64-NEXT:    vmovaps %xmm6, (%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 0
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    callq test_retv64i1
; WIN64-NEXT:    kmovq %rax, %k0
; WIN64-NEXT:    vpmovm2b %k0, %zmm0
; WIN64-NEXT:    vmovaps (%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $40, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_retv64i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    callq test_retv64i1
; LINUXOSX64-NEXT:    kmovq %rax, %k0
; LINUXOSX64-NEXT:    vpmovm2b %k0, %zmm0
; LINUXOSX64-NEXT:    popq %rax
; LINUXOSX64-NEXT:    retq
entry:
  %call = call x86_regcallcc <64 x i1> @test_retv64i1()
  ret <64 x i1> %call
}

; Test regcall when receiving arguments of v32i1 type
declare i32 @test_argv32i1helper(<32 x i1> %x0, <32 x i1> %x1, <32 x i1> %x2)
define x86_regcallcc i32 @test_argv32i1(<32 x i1> %x0, <32 x i1> %x1, <32 x i1> %x2)  {
; X32-LABEL: test_argv32i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esp
; X32-NEXT:    subl $72, %esp
; X32-NEXT:    vmovups %xmm7, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm6, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm5, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm4, (%esp) # 16-byte Spill
; X32-NEXT:    kmovd %edx, %k0
; X32-NEXT:    kmovd %ecx, %k1
; X32-NEXT:    kmovd %eax, %k2
; X32-NEXT:    vpmovm2b %k2, %zmm0
; X32-NEXT:    vpmovm2b %k1, %zmm1
; X32-NEXT:    vpmovm2b %k0, %zmm2
; X32-NEXT:    # kill: def %ymm0 killed %ymm0 killed %zmm0
; X32-NEXT:    # kill: def %ymm1 killed %ymm1 killed %zmm1
; X32-NEXT:    # kill: def %ymm2 killed %ymm2 killed %zmm2
; X32-NEXT:    calll _test_argv32i1helper
; X32-NEXT:    vmovups (%esp), %xmm4 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm5 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm6 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm7 # 16-byte Reload
; X32-NEXT:    addl $72, %esp
; X32-NEXT:    popl %esp
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; WIN64-LABEL: test_argv32i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %r11
; WIN64-NEXT:    .seh_pushreg 11
; WIN64-NEXT:    pushq %r10
; WIN64-NEXT:    .seh_pushreg 10
; WIN64-NEXT:    pushq %rsp
; WIN64-NEXT:    .seh_pushreg 4
; WIN64-NEXT:    subq $32, %rsp
; WIN64-NEXT:    .seh_stackalloc 32
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    kmovd %edx, %k0
; WIN64-NEXT:    kmovd %ecx, %k1
; WIN64-NEXT:    kmovd %eax, %k2
; WIN64-NEXT:    vpmovm2b %k2, %zmm0
; WIN64-NEXT:    vpmovm2b %k1, %zmm1
; WIN64-NEXT:    vpmovm2b %k0, %zmm2
; WIN64-NEXT:    # kill: def %ymm0 killed %ymm0 killed %zmm0
; WIN64-NEXT:    # kill: def %ymm1 killed %ymm1 killed %zmm1
; WIN64-NEXT:    # kill: def %ymm2 killed %ymm2 killed %zmm2
; WIN64-NEXT:    callq test_argv32i1helper
; WIN64-NEXT:    nop
; WIN64-NEXT:    addq $32, %rsp
; WIN64-NEXT:    popq %rsp
; WIN64-NEXT:    popq %r10
; WIN64-NEXT:    popq %r11
; WIN64-NEXT:    vzeroupper
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: test_argv32i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rsp
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    subq $128, %rsp
; LINUXOSX64-NEXT:    vmovaps %xmm15, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm14, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm13, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm12, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm11, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm10, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm9, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm8, (%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 144
; LINUXOSX64-NEXT:    .cfi_offset %rsp, -16
; LINUXOSX64-NEXT:    .cfi_offset %xmm8, -144
; LINUXOSX64-NEXT:    .cfi_offset %xmm9, -128
; LINUXOSX64-NEXT:    .cfi_offset %xmm10, -112
; LINUXOSX64-NEXT:    .cfi_offset %xmm11, -96
; LINUXOSX64-NEXT:    .cfi_offset %xmm12, -80
; LINUXOSX64-NEXT:    .cfi_offset %xmm13, -64
; LINUXOSX64-NEXT:    .cfi_offset %xmm14, -48
; LINUXOSX64-NEXT:    .cfi_offset %xmm15, -32
; LINUXOSX64-NEXT:    kmovd %edx, %k0
; LINUXOSX64-NEXT:    kmovd %ecx, %k1
; LINUXOSX64-NEXT:    kmovd %eax, %k2
; LINUXOSX64-NEXT:    vpmovm2b %k2, %zmm0
; LINUXOSX64-NEXT:    vpmovm2b %k1, %zmm1
; LINUXOSX64-NEXT:    vpmovm2b %k0, %zmm2
; LINUXOSX64-NEXT:    # kill: def %ymm0 killed %ymm0 killed %zmm0
; LINUXOSX64-NEXT:    # kill: def %ymm1 killed %ymm1 killed %zmm1
; LINUXOSX64-NEXT:    # kill: def %ymm2 killed %ymm2 killed %zmm2
; LINUXOSX64-NEXT:    callq test_argv32i1helper
; LINUXOSX64-NEXT:    vmovaps (%rsp), %xmm8 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm9 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm10 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm11 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm12 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm13 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm14 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm15 # 16-byte Reload
; LINUXOSX64-NEXT:    addq $128, %rsp
; LINUXOSX64-NEXT:    popq %rsp
; LINUXOSX64-NEXT:    vzeroupper
; LINUXOSX64-NEXT:    retq
entry:
  %res = call i32 @test_argv32i1helper(<32 x i1> %x0, <32 x i1> %x1, <32 x i1> %x2)
  ret i32 %res
}

; Test regcall when passing arguments of v32i1 type
define i32 @caller_argv32i1() #0 {
; X32-LABEL: caller_argv32i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl $1, %eax
; X32-NEXT:    movl $1, %ecx
; X32-NEXT:    movl $1, %edx
; X32-NEXT:    calll _test_argv32i1
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_argv32i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $40, %rsp
; WIN64-NEXT:    .seh_stackalloc 40
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 16
; WIN64-NEXT:    vmovaps %xmm6, (%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 0
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    movl $1, %eax
; WIN64-NEXT:    movl $1, %ecx
; WIN64-NEXT:    movl $1, %edx
; WIN64-NEXT:    callq test_argv32i1
; WIN64-NEXT:    vmovaps (%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $40, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_argv32i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    movl $1, %eax
; LINUXOSX64-NEXT:    movl $1, %ecx
; LINUXOSX64-NEXT:    movl $1, %edx
; LINUXOSX64-NEXT:    callq test_argv32i1
; LINUXOSX64-NEXT:    popq %rcx
; LINUXOSX64-NEXT:    retq
entry:
  %v0 = bitcast i32 1 to <32 x i1>
  %call = call x86_regcallcc i32 @test_argv32i1(<32 x i1> %v0, <32 x i1> %v0, <32 x i1> %v0)
  ret i32 %call
}

; Test regcall when returning v32i1 type
define x86_regcallcc <32 x i1> @test_retv32i1()  {
; X32-LABEL: test_retv32i1:
; X32:       # %bb.0:
; X32-NEXT:    movl $1, %eax
; X32-NEXT:    retl
;
; CHECK64-LABEL: test_retv32i1:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movl $1, %eax
; CHECK64-NEXT:    retq
  %a = bitcast i32 1 to <32 x i1>
  ret <32 x i1> %a
}

; Test regcall when processing result of v32i1 type
define i32 @caller_retv32i1() #0 {
; X32-LABEL: caller_retv32i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    calll _test_retv32i1
; X32-NEXT:    incl %eax
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_retv32i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $40, %rsp
; WIN64-NEXT:    .seh_stackalloc 40
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 16
; WIN64-NEXT:    vmovaps %xmm6, (%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 0
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    callq test_retv32i1
; WIN64-NEXT:    incl %eax
; WIN64-NEXT:    vmovaps (%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $40, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_retv32i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    callq test_retv32i1
; LINUXOSX64-NEXT:    incl %eax
; LINUXOSX64-NEXT:    popq %rcx
; LINUXOSX64-NEXT:    retq
entry:
  %call = call x86_regcallcc <32 x i1> @test_retv32i1()
  %c = bitcast <32 x i1> %call to i32
  %add = add i32 %c, 1
  ret i32 %add
}

; Test regcall when receiving arguments of v16i1 type
declare i16 @test_argv16i1helper(<16 x i1> %x0, <16 x i1> %x1, <16 x i1> %x2)
define x86_regcallcc i16 @test_argv16i1(<16 x i1> %x0, <16 x i1> %x1, <16 x i1> %x2)  {
; X32-LABEL: test_argv16i1:
; X32:       # %bb.0:
; X32-NEXT:    pushl %esp
; X32-NEXT:    subl $72, %esp
; X32-NEXT:    vmovups %xmm7, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm6, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm5, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm4, (%esp) # 16-byte Spill
; X32-NEXT:    kmovd %edx, %k0
; X32-NEXT:    kmovd %ecx, %k1
; X32-NEXT:    kmovd %eax, %k2
; X32-NEXT:    vpmovm2b %k2, %zmm0
; X32-NEXT:    vpmovm2b %k1, %zmm1
; X32-NEXT:    vpmovm2b %k0, %zmm2
; X32-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; X32-NEXT:    # kill: def %xmm1 killed %xmm1 killed %zmm1
; X32-NEXT:    # kill: def %xmm2 killed %xmm2 killed %zmm2
; X32-NEXT:    vzeroupper
; X32-NEXT:    calll _test_argv16i1helper
; X32-NEXT:    vmovups (%esp), %xmm4 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm5 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm6 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm7 # 16-byte Reload
; X32-NEXT:    addl $72, %esp
; X32-NEXT:    popl %esp
; X32-NEXT:    retl
;
; WIN64-LABEL: test_argv16i1:
; WIN64:       # %bb.0:
; WIN64-NEXT:    pushq %r11
; WIN64-NEXT:    .seh_pushreg 11
; WIN64-NEXT:    pushq %r10
; WIN64-NEXT:    .seh_pushreg 10
; WIN64-NEXT:    pushq %rsp
; WIN64-NEXT:    .seh_pushreg 4
; WIN64-NEXT:    subq $32, %rsp
; WIN64-NEXT:    .seh_stackalloc 32
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    kmovd %edx, %k0
; WIN64-NEXT:    kmovd %ecx, %k1
; WIN64-NEXT:    kmovd %eax, %k2
; WIN64-NEXT:    vpmovm2b %k2, %zmm0
; WIN64-NEXT:    vpmovm2b %k1, %zmm1
; WIN64-NEXT:    vpmovm2b %k0, %zmm2
; WIN64-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; WIN64-NEXT:    # kill: def %xmm1 killed %xmm1 killed %zmm1
; WIN64-NEXT:    # kill: def %xmm2 killed %xmm2 killed %zmm2
; WIN64-NEXT:    vzeroupper
; WIN64-NEXT:    callq test_argv16i1helper
; WIN64-NEXT:    nop
; WIN64-NEXT:    addq $32, %rsp
; WIN64-NEXT:    popq %rsp
; WIN64-NEXT:    popq %r10
; WIN64-NEXT:    popq %r11
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: test_argv16i1:
; LINUXOSX64:       # %bb.0:
; LINUXOSX64-NEXT:    pushq %rsp
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    subq $128, %rsp
; LINUXOSX64-NEXT:    vmovaps %xmm15, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm14, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm13, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm12, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm11, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm10, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm9, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm8, (%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 144
; LINUXOSX64-NEXT:    .cfi_offset %rsp, -16
; LINUXOSX64-NEXT:    .cfi_offset %xmm8, -144
; LINUXOSX64-NEXT:    .cfi_offset %xmm9, -128
; LINUXOSX64-NEXT:    .cfi_offset %xmm10, -112
; LINUXOSX64-NEXT:    .cfi_offset %xmm11, -96
; LINUXOSX64-NEXT:    .cfi_offset %xmm12, -80
; LINUXOSX64-NEXT:    .cfi_offset %xmm13, -64
; LINUXOSX64-NEXT:    .cfi_offset %xmm14, -48
; LINUXOSX64-NEXT:    .cfi_offset %xmm15, -32
; LINUXOSX64-NEXT:    kmovd %edx, %k0
; LINUXOSX64-NEXT:    kmovd %ecx, %k1
; LINUXOSX64-NEXT:    kmovd %eax, %k2
; LINUXOSX64-NEXT:    vpmovm2b %k2, %zmm0
; LINUXOSX64-NEXT:    vpmovm2b %k1, %zmm1
; LINUXOSX64-NEXT:    vpmovm2b %k0, %zmm2
; LINUXOSX64-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; LINUXOSX64-NEXT:    # kill: def %xmm1 killed %xmm1 killed %zmm1
; LINUXOSX64-NEXT:    # kill: def %xmm2 killed %xmm2 killed %zmm2
; LINUXOSX64-NEXT:    vzeroupper
; LINUXOSX64-NEXT:    callq test_argv16i1helper
; LINUXOSX64-NEXT:    vmovaps (%rsp), %xmm8 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm9 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm10 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm11 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm12 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm13 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm14 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm15 # 16-byte Reload
; LINUXOSX64-NEXT:    addq $128, %rsp
; LINUXOSX64-NEXT:    popq %rsp
; LINUXOSX64-NEXT:    retq
  %res = call i16 @test_argv16i1helper(<16 x i1> %x0, <16 x i1> %x1, <16 x i1> %x2)
  ret i16 %res
}

; Test regcall when passing arguments of v16i1 type
define i16 @caller_argv16i1() #0 {
; X32-LABEL: caller_argv16i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl $1, %eax
; X32-NEXT:    movl $1, %ecx
; X32-NEXT:    movl $1, %edx
; X32-NEXT:    calll _test_argv16i1
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_argv16i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $40, %rsp
; WIN64-NEXT:    .seh_stackalloc 40
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 16
; WIN64-NEXT:    vmovaps %xmm6, (%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 0
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    movl $1, %eax
; WIN64-NEXT:    movl $1, %ecx
; WIN64-NEXT:    movl $1, %edx
; WIN64-NEXT:    callq test_argv16i1
; WIN64-NEXT:    vmovaps (%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $40, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_argv16i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    movl $1, %eax
; LINUXOSX64-NEXT:    movl $1, %ecx
; LINUXOSX64-NEXT:    movl $1, %edx
; LINUXOSX64-NEXT:    callq test_argv16i1
; LINUXOSX64-NEXT:    popq %rcx
; LINUXOSX64-NEXT:    retq
entry:
  %v0 = bitcast i16 1 to <16 x i1>
  %call = call x86_regcallcc i16 @test_argv16i1(<16 x i1> %v0, <16 x i1> %v0, <16 x i1> %v0)
  ret i16 %call
}

; Test regcall when returning v16i1 type
define x86_regcallcc <16 x i1> @test_retv16i1()  {
; X32-LABEL: test_retv16i1:
; X32:       # %bb.0:
; X32-NEXT:    movw $1, %ax
; X32-NEXT:    retl
;
; CHECK64-LABEL: test_retv16i1:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movw $1, %ax
; CHECK64-NEXT:    retq
  %a = bitcast i16 1 to <16 x i1>
  ret <16 x i1> %a
}

; Test regcall when processing result of v16i1 type
define i16 @caller_retv16i1() #0 {
; X32-LABEL: caller_retv16i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    calll _test_retv16i1
; X32-NEXT:    # kill: def %ax killed %ax def %eax
; X32-NEXT:    incl %eax
; X32-NEXT:    # kill: def %ax killed %ax killed %eax
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_retv16i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $40, %rsp
; WIN64-NEXT:    .seh_stackalloc 40
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 16
; WIN64-NEXT:    vmovaps %xmm6, (%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 0
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    callq test_retv16i1
; WIN64-NEXT:    # kill: def %ax killed %ax def %eax
; WIN64-NEXT:    incl %eax
; WIN64-NEXT:    # kill: def %ax killed %ax killed %eax
; WIN64-NEXT:    vmovaps (%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $40, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_retv16i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    callq test_retv16i1
; LINUXOSX64-NEXT:    # kill: def %ax killed %ax def %eax
; LINUXOSX64-NEXT:    incl %eax
; LINUXOSX64-NEXT:    # kill: def %ax killed %ax killed %eax
; LINUXOSX64-NEXT:    popq %rcx
; LINUXOSX64-NEXT:    retq
entry:
  %call = call x86_regcallcc <16 x i1> @test_retv16i1()
  %c = bitcast <16 x i1> %call to i16
  %add = add i16 %c, 1
  ret i16 %add
}

; Test regcall when receiving arguments of v8i1 type
declare i8 @test_argv8i1helper(<8 x i1> %x0, <8 x i1> %x1, <8 x i1> %x2)
define x86_regcallcc i8 @test_argv8i1(<8 x i1> %x0, <8 x i1> %x1, <8 x i1> %x2)  {
; X32-LABEL: test_argv8i1:
; X32:       # %bb.0:
; X32-NEXT:    pushl %esp
; X32-NEXT:    subl $72, %esp
; X32-NEXT:    vmovups %xmm7, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm6, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm5, {{[0-9]+}}(%esp) # 16-byte Spill
; X32-NEXT:    vmovups %xmm4, (%esp) # 16-byte Spill
; X32-NEXT:    kmovd %edx, %k0
; X32-NEXT:    kmovd %ecx, %k1
; X32-NEXT:    kmovd %eax, %k2
; X32-NEXT:    vpmovm2w %k2, %zmm0
; X32-NEXT:    vpmovm2w %k1, %zmm1
; X32-NEXT:    vpmovm2w %k0, %zmm2
; X32-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; X32-NEXT:    # kill: def %xmm1 killed %xmm1 killed %zmm1
; X32-NEXT:    # kill: def %xmm2 killed %xmm2 killed %zmm2
; X32-NEXT:    vzeroupper
; X32-NEXT:    calll _test_argv8i1helper
; X32-NEXT:    vmovups (%esp), %xmm4 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm5 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm6 # 16-byte Reload
; X32-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm7 # 16-byte Reload
; X32-NEXT:    addl $72, %esp
; X32-NEXT:    popl %esp
; X32-NEXT:    retl
;
; WIN64-LABEL: test_argv8i1:
; WIN64:       # %bb.0:
; WIN64-NEXT:    pushq %r11
; WIN64-NEXT:    .seh_pushreg 11
; WIN64-NEXT:    pushq %r10
; WIN64-NEXT:    .seh_pushreg 10
; WIN64-NEXT:    pushq %rsp
; WIN64-NEXT:    .seh_pushreg 4
; WIN64-NEXT:    subq $32, %rsp
; WIN64-NEXT:    .seh_stackalloc 32
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    kmovd %edx, %k0
; WIN64-NEXT:    kmovd %ecx, %k1
; WIN64-NEXT:    kmovd %eax, %k2
; WIN64-NEXT:    vpmovm2w %k2, %zmm0
; WIN64-NEXT:    vpmovm2w %k1, %zmm1
; WIN64-NEXT:    vpmovm2w %k0, %zmm2
; WIN64-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; WIN64-NEXT:    # kill: def %xmm1 killed %xmm1 killed %zmm1
; WIN64-NEXT:    # kill: def %xmm2 killed %xmm2 killed %zmm2
; WIN64-NEXT:    vzeroupper
; WIN64-NEXT:    callq test_argv8i1helper
; WIN64-NEXT:    nop
; WIN64-NEXT:    addq $32, %rsp
; WIN64-NEXT:    popq %rsp
; WIN64-NEXT:    popq %r10
; WIN64-NEXT:    popq %r11
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: test_argv8i1:
; LINUXOSX64:       # %bb.0:
; LINUXOSX64-NEXT:    pushq %rsp
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    subq $128, %rsp
; LINUXOSX64-NEXT:    vmovaps %xmm15, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm14, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm13, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm12, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm11, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm10, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm9, {{[0-9]+}}(%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    vmovaps %xmm8, (%rsp) # 16-byte Spill
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 144
; LINUXOSX64-NEXT:    .cfi_offset %rsp, -16
; LINUXOSX64-NEXT:    .cfi_offset %xmm8, -144
; LINUXOSX64-NEXT:    .cfi_offset %xmm9, -128
; LINUXOSX64-NEXT:    .cfi_offset %xmm10, -112
; LINUXOSX64-NEXT:    .cfi_offset %xmm11, -96
; LINUXOSX64-NEXT:    .cfi_offset %xmm12, -80
; LINUXOSX64-NEXT:    .cfi_offset %xmm13, -64
; LINUXOSX64-NEXT:    .cfi_offset %xmm14, -48
; LINUXOSX64-NEXT:    .cfi_offset %xmm15, -32
; LINUXOSX64-NEXT:    kmovd %edx, %k0
; LINUXOSX64-NEXT:    kmovd %ecx, %k1
; LINUXOSX64-NEXT:    kmovd %eax, %k2
; LINUXOSX64-NEXT:    vpmovm2w %k2, %zmm0
; LINUXOSX64-NEXT:    vpmovm2w %k1, %zmm1
; LINUXOSX64-NEXT:    vpmovm2w %k0, %zmm2
; LINUXOSX64-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; LINUXOSX64-NEXT:    # kill: def %xmm1 killed %xmm1 killed %zmm1
; LINUXOSX64-NEXT:    # kill: def %xmm2 killed %xmm2 killed %zmm2
; LINUXOSX64-NEXT:    vzeroupper
; LINUXOSX64-NEXT:    callq test_argv8i1helper
; LINUXOSX64-NEXT:    vmovaps (%rsp), %xmm8 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm9 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm10 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm11 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm12 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm13 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm14 # 16-byte Reload
; LINUXOSX64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm15 # 16-byte Reload
; LINUXOSX64-NEXT:    addq $128, %rsp
; LINUXOSX64-NEXT:    popq %rsp
; LINUXOSX64-NEXT:    retq
  %res = call i8 @test_argv8i1helper(<8 x i1> %x0, <8 x i1> %x1, <8 x i1> %x2)
  ret i8 %res
}

; Test regcall when passing arguments of v8i1 type
define i8 @caller_argv8i1() #0 {
; X32-LABEL: caller_argv8i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl $1, %eax
; X32-NEXT:    movl $1, %ecx
; X32-NEXT:    movl $1, %edx
; X32-NEXT:    calll _test_argv8i1
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_argv8i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $40, %rsp
; WIN64-NEXT:    .seh_stackalloc 40
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 16
; WIN64-NEXT:    vmovaps %xmm6, (%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 0
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    movl $1, %eax
; WIN64-NEXT:    movl $1, %ecx
; WIN64-NEXT:    movl $1, %edx
; WIN64-NEXT:    callq test_argv8i1
; WIN64-NEXT:    vmovaps (%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $40, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_argv8i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    movl $1, %eax
; LINUXOSX64-NEXT:    movl $1, %ecx
; LINUXOSX64-NEXT:    movl $1, %edx
; LINUXOSX64-NEXT:    callq test_argv8i1
; LINUXOSX64-NEXT:    popq %rcx
; LINUXOSX64-NEXT:    retq
entry:
  %v0 = bitcast i8 1 to <8 x i1>
  %call = call x86_regcallcc i8 @test_argv8i1(<8 x i1> %v0, <8 x i1> %v0, <8 x i1> %v0)
  ret i8 %call
}

; Test regcall when returning v8i1 type
define x86_regcallcc <8 x i1> @test_retv8i1()  {
; X32-LABEL: test_retv8i1:
; X32:       # %bb.0:
; X32-NEXT:    movb $1, %al
; X32-NEXT:    retl
;
; CHECK64-LABEL: test_retv8i1:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movb $1, %al
; CHECK64-NEXT:    retq
  %a = bitcast i8 1 to <8 x i1>
  ret <8 x i1> %a
}

; Test regcall when processing result of v8i1 type
define <8 x i1> @caller_retv8i1() #0 {
; X32-LABEL: caller_retv8i1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    calll _test_retv8i1
; X32-NEXT:    # kill: def %al killed %al def %eax
; X32-NEXT:    kmovd %eax, %k0
; X32-NEXT:    vpmovm2w %k0, %zmm0
; X32-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; WIN64-LABEL: caller_retv8i1:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rsi
; WIN64-NEXT:    .seh_pushreg 6
; WIN64-NEXT:    pushq %rdi
; WIN64-NEXT:    .seh_pushreg 7
; WIN64-NEXT:    subq $40, %rsp
; WIN64-NEXT:    .seh_stackalloc 40
; WIN64-NEXT:    vmovaps %xmm7, {{[0-9]+}}(%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 7, 16
; WIN64-NEXT:    vmovaps %xmm6, (%rsp) # 16-byte Spill
; WIN64-NEXT:    .seh_savexmm 6, 0
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    callq test_retv8i1
; WIN64-NEXT:    # kill: def %al killed %al def %eax
; WIN64-NEXT:    kmovd %eax, %k0
; WIN64-NEXT:    vpmovm2w %k0, %zmm0
; WIN64-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; WIN64-NEXT:    vmovaps (%rsp), %xmm6 # 16-byte Reload
; WIN64-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm7 # 16-byte Reload
; WIN64-NEXT:    addq $40, %rsp
; WIN64-NEXT:    popq %rdi
; WIN64-NEXT:    popq %rsi
; WIN64-NEXT:    vzeroupper
; WIN64-NEXT:    retq
; WIN64-NEXT:    .seh_handlerdata
; WIN64-NEXT:    .text
; WIN64-NEXT:    .seh_endproc
;
; LINUXOSX64-LABEL: caller_retv8i1:
; LINUXOSX64:       # %bb.0: # %entry
; LINUXOSX64-NEXT:    pushq %rax
; LINUXOSX64-NEXT:    .cfi_def_cfa_offset 16
; LINUXOSX64-NEXT:    callq test_retv8i1
; LINUXOSX64-NEXT:    # kill: def %al killed %al def %eax
; LINUXOSX64-NEXT:    kmovd %eax, %k0
; LINUXOSX64-NEXT:    vpmovm2w %k0, %zmm0
; LINUXOSX64-NEXT:    # kill: def %xmm0 killed %xmm0 killed %zmm0
; LINUXOSX64-NEXT:    popq %rax
; LINUXOSX64-NEXT:    vzeroupper
; LINUXOSX64-NEXT:    retq
entry:
  %call = call x86_regcallcc <8 x i1> @test_retv8i1()
  ret <8 x i1> %call
}
