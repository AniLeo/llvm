; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse4.2 |  FileCheck %s

; Verify when widening a divide/remainder operation, we only generate a
; divide/rem per element since divide/remainder can trap.

define void @vectorDiv (ptr addrspace(1) %nsource, ptr addrspace(1) %dsource, ptr addrspace(1) %qdest) nounwind {
; CHECK-LABEL: vectorDiv:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq %rdi, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movslq -{{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    movq (%rdi,%rcx,8), %rdi
; CHECK-NEXT:    movq (%rsi,%rcx,8), %r10
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    shrq $32, %rax
; CHECK-NEXT:    movq %r10, %rsi
; CHECK-NEXT:    shrq $32, %rsi
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %esi
; CHECK-NEXT:    movl %eax, %r9d
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %r10d
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    pinsrd $1, %r9d, %xmm0
; CHECK-NEXT:    movq %xmm0, (%r8,%rcx,8)
; CHECK-NEXT:    retq
entry:
  %nsource.addr = alloca ptr addrspace(1), align 4
  %dsource.addr = alloca ptr addrspace(1), align 4
  %qdest.addr = alloca ptr addrspace(1), align 4
  %index = alloca i32, align 4
  store ptr addrspace(1) %nsource, ptr %nsource.addr
  store ptr addrspace(1) %dsource, ptr %dsource.addr
  store ptr addrspace(1) %qdest, ptr %qdest.addr
  %tmp = load ptr addrspace(1), ptr %qdest.addr
  %tmp1 = load i32, ptr %index
  %arrayidx = getelementptr <2 x i32>, ptr addrspace(1) %tmp, i32 %tmp1
  %tmp2 = load ptr addrspace(1), ptr %nsource.addr
  %tmp3 = load i32, ptr %index
  %arrayidx4 = getelementptr <2 x i32>, ptr addrspace(1) %tmp2, i32 %tmp3
  %tmp5 = load <2 x i32>, ptr addrspace(1) %arrayidx4
  %tmp6 = load ptr addrspace(1), ptr %dsource.addr
  %tmp7 = load i32, ptr %index
  %arrayidx8 = getelementptr <2 x i32>, ptr addrspace(1) %tmp6, i32 %tmp7
  %tmp9 = load <2 x i32>, ptr addrspace(1) %arrayidx8
  %tmp10 = sdiv <2 x i32> %tmp5, %tmp9
  store <2 x i32> %tmp10, ptr addrspace(1) %arrayidx
  ret void
}

define <3 x i8> @test_char_div(<3 x i8> %num, <3 x i8> %div) {
; CHECK-LABEL: test_char_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsbl %dil, %eax
; CHECK-NEXT:    idivb %cl
; CHECK-NEXT:    movl %eax, %edi
; CHECK-NEXT:    movsbl %sil, %eax
; CHECK-NEXT:    idivb %r8b
; CHECK-NEXT:    movl %eax, %esi
; CHECK-NEXT:    movsbl %dl, %eax
; CHECK-NEXT:    idivb %r9b
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    movl %esi, %edx
; CHECK-NEXT:    retq
  %div.r = sdiv <3 x i8> %num, %div
  ret <3 x i8>  %div.r
}

define <3 x i8> @test_uchar_div(<3 x i8> %num, <3 x i8> %div) {
; CHECK-LABEL: test_uchar_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    divb %cl
; CHECK-NEXT:    movl %eax, %edi
; CHECK-NEXT:    movzbl %sil, %eax
; CHECK-NEXT:    divb %r8b
; CHECK-NEXT:    movl %eax, %esi
; CHECK-NEXT:    movzbl %dl, %eax
; CHECK-NEXT:    divb %r9b
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    movl %esi, %edx
; CHECK-NEXT:    retq
  %div.r = udiv <3 x i8> %num, %div
  ret <3 x i8>  %div.r
}

define <5 x i16> @test_short_div(<5 x i16> %num, <5 x i16> %div) {
; CHECK-LABEL: test_short_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pextrw $4, %xmm0, %eax
; CHECK-NEXT:    pextrw $4, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %eax, %r8d
; CHECK-NEXT:    pextrw $3, %xmm0, %eax
; CHECK-NEXT:    pextrw $3, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %eax, %r9d
; CHECK-NEXT:    pextrw $2, %xmm0, %eax
; CHECK-NEXT:    pextrw $2, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %eax, %edi
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    movd %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    pextrw $1, %xmm0, %eax
; CHECK-NEXT:    pextrw $1, %xmm1, %esi
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %si
; CHECK-NEXT:    # kill: def $ax killed $ax def $eax
; CHECK-NEXT:    movd %ecx, %xmm0
; CHECK-NEXT:    pinsrw $1, %eax, %xmm0
; CHECK-NEXT:    pinsrw $2, %edi, %xmm0
; CHECK-NEXT:    pinsrw $3, %r9d, %xmm0
; CHECK-NEXT:    pinsrw $4, %r8d, %xmm0
; CHECK-NEXT:    retq
  %div.r = sdiv <5 x i16> %num, %div
  ret <5 x i16>  %div.r
}

define <4 x i16> @test_ushort_div(<4 x i16> %num, <4 x i16> %div) {
; CHECK-LABEL: test_ushort_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pextrw $1, %xmm0, %eax
; CHECK-NEXT:    pextrw $1, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divw %cx
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    movd %xmm1, %esi
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divw %si
; CHECK-NEXT:    # kill: def $ax killed $ax def $eax
; CHECK-NEXT:    movd %eax, %xmm2
; CHECK-NEXT:    pinsrw $1, %ecx, %xmm2
; CHECK-NEXT:    pextrw $2, %xmm0, %eax
; CHECK-NEXT:    pextrw $2, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divw %cx
; CHECK-NEXT:    # kill: def $ax killed $ax def $eax
; CHECK-NEXT:    pinsrw $2, %eax, %xmm2
; CHECK-NEXT:    pextrw $3, %xmm0, %eax
; CHECK-NEXT:    pextrw $3, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divw %cx
; CHECK-NEXT:    # kill: def $ax killed $ax def $eax
; CHECK-NEXT:    pinsrw $3, %eax, %xmm2
; CHECK-NEXT:    movdqa %xmm2, %xmm0
; CHECK-NEXT:    retq
  %div.r = udiv <4 x i16> %num, %div
  ret <4 x i16>  %div.r
}

define <3 x i32> @test_uint_div(<3 x i32> %num, <3 x i32> %div) {
; CHECK-LABEL: test_uint_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pextrd $2, %xmm0, %eax
; CHECK-NEXT:    pextrd $2, %xmm1, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    pextrd $1, %xmm0, %eax
; CHECK-NEXT:    pextrd $1, %xmm1, %esi
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %esi
; CHECK-NEXT:    movl %eax, %esi
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    movd %xmm1, %edi
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %edi
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    pinsrd $1, %esi, %xmm0
; CHECK-NEXT:    pinsrd $2, %ecx, %xmm0
; CHECK-NEXT:    retq
  %div.r = udiv <3 x i32> %num, %div
  ret <3 x i32>  %div.r
}

define <3 x i64> @test_long_div(<3 x i64> %num, <3 x i64> %div) {
; CHECK-LABEL: test_long_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdx, %r10
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    cqto
; CHECK-NEXT:    idivq %rcx
; CHECK-NEXT:    movq %rax, %rcx
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    cqto
; CHECK-NEXT:    idivq %r8
; CHECK-NEXT:    movq %rax, %rsi
; CHECK-NEXT:    movq %r10, %rax
; CHECK-NEXT:    cqto
; CHECK-NEXT:    idivq %r9
; CHECK-NEXT:    movq %rax, %rdi
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    movq %rdi, %rcx
; CHECK-NEXT:    retq
  %div.r = sdiv <3 x i64> %num, %div
  ret <3 x i64>  %div.r
}

define <3 x i64> @test_ulong_div(<3 x i64> %num, <3 x i64> %div) {
; CHECK-LABEL: test_ulong_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdx, %r10
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq %rcx
; CHECK-NEXT:    movq %rax, %rcx
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq %r8
; CHECK-NEXT:    movq %rax, %rsi
; CHECK-NEXT:    movq %r10, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq %r9
; CHECK-NEXT:    movq %rax, %rdi
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    movq %rdi, %rcx
; CHECK-NEXT:    retq
  %div.r = udiv <3 x i64> %num, %div
  ret <3 x i64>  %div.r
}

define <4 x i8> @test_char_rem(<4 x i8> %num, <4 x i8> %rem) {
; CHECK-LABEL: test_char_rem:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pextrb $1, %xmm1, %ecx
; CHECK-NEXT:    pextrb $1, %xmm0, %eax
; CHECK-NEXT:    cbtw
; CHECK-NEXT:    idivb %cl
; CHECK-NEXT:    movsbl %ah, %ecx
; CHECK-NEXT:    movd %xmm1, %edx
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    cbtw
; CHECK-NEXT:    idivb %dl
; CHECK-NEXT:    movsbl %ah, %eax
; CHECK-NEXT:    movd %eax, %xmm2
; CHECK-NEXT:    pinsrb $1, %ecx, %xmm2
; CHECK-NEXT:    pextrb $2, %xmm1, %ecx
; CHECK-NEXT:    pextrb $2, %xmm0, %eax
; CHECK-NEXT:    cbtw
; CHECK-NEXT:    idivb %cl
; CHECK-NEXT:    movsbl %ah, %eax
; CHECK-NEXT:    pinsrb $2, %eax, %xmm2
; CHECK-NEXT:    pextrb $3, %xmm1, %ecx
; CHECK-NEXT:    pextrb $3, %xmm0, %eax
; CHECK-NEXT:    cbtw
; CHECK-NEXT:    idivb %cl
; CHECK-NEXT:    movsbl %ah, %eax
; CHECK-NEXT:    pinsrb $3, %eax, %xmm2
; CHECK-NEXT:    movdqa %xmm2, %xmm0
; CHECK-NEXT:    retq
  %rem.r = srem <4 x i8> %num, %rem
  ret <4 x i8>  %rem.r
}

define <5 x i16> @test_short_rem(<5 x i16> %num, <5 x i16> %rem) {
; CHECK-LABEL: test_short_rem:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pextrw $4, %xmm0, %eax
; CHECK-NEXT:    pextrw $4, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %edx, %r8d
; CHECK-NEXT:    pextrw $3, %xmm0, %eax
; CHECK-NEXT:    pextrw $3, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %edx, %r9d
; CHECK-NEXT:    pextrw $2, %xmm0, %eax
; CHECK-NEXT:    pextrw $2, %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %edx, %edi
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    movd %xmm1, %ecx
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %cx
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    pextrw $1, %xmm0, %eax
; CHECK-NEXT:    pextrw $1, %xmm1, %esi
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    cwtd
; CHECK-NEXT:    idivw %si
; CHECK-NEXT:    # kill: def $dx killed $dx def $edx
; CHECK-NEXT:    movd %ecx, %xmm0
; CHECK-NEXT:    pinsrw $1, %edx, %xmm0
; CHECK-NEXT:    pinsrw $2, %edi, %xmm0
; CHECK-NEXT:    pinsrw $3, %r9d, %xmm0
; CHECK-NEXT:    pinsrw $4, %r8d, %xmm0
; CHECK-NEXT:    retq
  %rem.r = srem <5 x i16> %num, %rem
  ret <5 x i16>  %rem.r
}

define <4 x i32> @test_uint_rem(<4 x i32> %num, <4 x i32> %rem) {
; CHECK-LABEL: test_uint_rem:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pextrd $1, %xmm0, %eax
; CHECK-NEXT:    pextrd $1, %xmm1, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    movd %xmm1, %esi
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %esi
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    pinsrd $1, %ecx, %xmm2
; CHECK-NEXT:    pextrd $2, %xmm0, %eax
; CHECK-NEXT:    pextrd $2, %xmm1, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    pinsrd $2, %edx, %xmm2
; CHECK-NEXT:    pextrd $3, %xmm0, %eax
; CHECK-NEXT:    pextrd $3, %xmm1, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    pinsrd $3, %edx, %xmm2
; CHECK-NEXT:    movdqa %xmm2, %xmm0
; CHECK-NEXT:    retq
  %rem.r = srem <4 x i32> %num, %rem
  ret <4 x i32>  %rem.r
}


define <5 x i64> @test_ulong_rem(<5 x i64> %num, <5 x i64> %rem) {
; CHECK-LABEL: test_ulong_rem:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rdx, %xmm0
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rdx, %xmm1
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; CHECK-NEXT:    movq %r8, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rdx, %xmm0
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rdx, %xmm2
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm0[0]
; CHECK-NEXT:    movq %r9, %rax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divq {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rdx, 32(%rdi)
; CHECK-NEXT:    movdqa %xmm2, 16(%rdi)
; CHECK-NEXT:    movdqa %xmm1, (%rdi)
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %rem.r = urem <5 x i64> %num, %rem
  ret <5 x i64>  %rem.r
}

define void @test_int_div(ptr %dest, ptr %old, i32 %n) {
; CHECK-LABEL: test_int_div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testl %edx, %edx
; CHECK-NEXT:    jle .LBB12_3
; CHECK-NEXT:  # %bb.1: # %bb.nph
; CHECK-NEXT:    movl %edx, %r10d
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB12_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl (%rdi,%rcx), %r8d
; CHECK-NEXT:    movl 4(%rdi,%rcx), %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl 4(%rsi,%rcx)
; CHECK-NEXT:    movl %eax, %r9d
; CHECK-NEXT:    movl %r8d, %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl (%rsi,%rcx)
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    pinsrd $1, %r9d, %xmm0
; CHECK-NEXT:    movl 8(%rdi,%rcx), %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl 8(%rsi,%rcx)
; CHECK-NEXT:    movl %eax, 8(%rdi,%rcx)
; CHECK-NEXT:    movq %xmm0, (%rdi,%rcx)
; CHECK-NEXT:    addq $16, %rcx
; CHECK-NEXT:    decl %r10d
; CHECK-NEXT:    jne .LBB12_2
; CHECK-NEXT:  .LBB12_3: # %for.end
; CHECK-NEXT:    retq
entry:
  %cmp13 = icmp sgt i32 %n, 0
  br i1 %cmp13, label %bb.nph, label %for.end

bb.nph:
  br label %for.body

for.body:
  %i.014 = phi i32 [ 0, %bb.nph ], [ %inc, %for.body ]
  %arrayidx11 = getelementptr <3 x i32>, ptr %dest, i32 %i.014
  %tmp4 = load <3 x i32>, ptr %arrayidx11 ; <<3 x i32>> [#uses=1]
  %arrayidx7 = getelementptr inbounds <3 x i32>, ptr %old, i32 %i.014
  %tmp8 = load <3 x i32>, ptr %arrayidx7 ; <<3 x i32>> [#uses=1]
  %div = sdiv <3 x i32> %tmp4, %tmp8
  store <3 x i32> %div, ptr %arrayidx11
  %inc = add nsw i32 %i.014, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  ret void
}
