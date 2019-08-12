; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-darwin -mcpu=generic | FileCheck %s -check-prefixes=CHECK,GENERIC
; RUN: llc < %s -mtriple=x86_64-darwin -mcpu=atom | FileCheck %s -check-prefixes=CHECK,ATOM

@Te0 = external global [256 x i32]		; <[256 x i32]*> [#uses=5]
@Te1 = external global [256 x i32]		; <[256 x i32]*> [#uses=4]
@Te3 = external global [256 x i32]		; <[256 x i32]*> [#uses=2]

define void @t(i8* nocapture %in, i8* nocapture %out, i32* nocapture %rk, i32 %r) nounwind {
; GENERIC-LABEL: t:
; GENERIC:       ## %bb.0: ## %entry
; GENERIC-NEXT:    pushq %rbp
; GENERIC-NEXT:    pushq %r14
; GENERIC-NEXT:    pushq %rbx
; GENERIC-NEXT:    ## kill: def $ecx killed $ecx def $rcx
; GENERIC-NEXT:    movl (%rdx), %eax
; GENERIC-NEXT:    movl 4(%rdx), %ebx
; GENERIC-NEXT:    decl %ecx
; GENERIC-NEXT:    leaq 20(%rdx), %r14
; GENERIC-NEXT:    movq _Te0@{{.*}}(%rip), %r9
; GENERIC-NEXT:    movq _Te1@{{.*}}(%rip), %r8
; GENERIC-NEXT:    movq _Te3@{{.*}}(%rip), %r10
; GENERIC-NEXT:    movq %rcx, %r11
; GENERIC-NEXT:    .p2align 4, 0x90
; GENERIC-NEXT:  LBB0_1: ## %bb
; GENERIC-NEXT:    ## =>This Inner Loop Header: Depth=1
; GENERIC-NEXT:    movzbl %al, %edi
; GENERIC-NEXT:    ## kill: def $eax killed $eax def $rax
; GENERIC-NEXT:    shrl $24, %eax
; GENERIC-NEXT:    movl %ebx, %ebp
; GENERIC-NEXT:    shrl $16, %ebp
; GENERIC-NEXT:    movzbl %bpl, %ebp
; GENERIC-NEXT:    movl (%r8,%rbp,4), %ebp
; GENERIC-NEXT:    xorl (%r9,%rax,4), %ebp
; GENERIC-NEXT:    xorl -12(%r14), %ebp
; GENERIC-NEXT:    shrl $24, %ebx
; GENERIC-NEXT:    movl (%r10,%rdi,4), %edi
; GENERIC-NEXT:    xorl (%r9,%rbx,4), %edi
; GENERIC-NEXT:    xorl -8(%r14), %edi
; GENERIC-NEXT:    movl %ebp, %eax
; GENERIC-NEXT:    shrl $24, %eax
; GENERIC-NEXT:    movl (%r9,%rax,4), %eax
; GENERIC-NEXT:    testq %r11, %r11
; GENERIC-NEXT:    je LBB0_3
; GENERIC-NEXT:  ## %bb.2: ## %bb1
; GENERIC-NEXT:    ## in Loop: Header=BB0_1 Depth=1
; GENERIC-NEXT:    movl %edi, %ebx
; GENERIC-NEXT:    shrl $16, %ebx
; GENERIC-NEXT:    movzbl %bl, %ebx
; GENERIC-NEXT:    xorl (%r8,%rbx,4), %eax
; GENERIC-NEXT:    xorl -4(%r14), %eax
; GENERIC-NEXT:    shrl $24, %edi
; GENERIC-NEXT:    movzbl %bpl, %ebx
; GENERIC-NEXT:    movl (%r10,%rbx,4), %ebx
; GENERIC-NEXT:    xorl (%r9,%rdi,4), %ebx
; GENERIC-NEXT:    xorl (%r14), %ebx
; GENERIC-NEXT:    decq %r11
; GENERIC-NEXT:    addq $16, %r14
; GENERIC-NEXT:    jmp LBB0_1
; GENERIC-NEXT:  LBB0_3: ## %bb2
; GENERIC-NEXT:    shlq $4, %rcx
; GENERIC-NEXT:    andl $-16777216, %eax ## imm = 0xFF000000
; GENERIC-NEXT:    movl %edi, %ebx
; GENERIC-NEXT:    shrl $16, %ebx
; GENERIC-NEXT:    movzbl %bl, %ebx
; GENERIC-NEXT:    movzbl 2(%r8,%rbx,4), %ebx
; GENERIC-NEXT:    shll $16, %ebx
; GENERIC-NEXT:    orl %eax, %ebx
; GENERIC-NEXT:    xorl 16(%rcx,%rdx), %ebx
; GENERIC-NEXT:    shrl $8, %edi
; GENERIC-NEXT:    movzbl 3(%r9,%rdi,4), %eax
; GENERIC-NEXT:    shll $24, %eax
; GENERIC-NEXT:    movzbl %bpl, %edi
; GENERIC-NEXT:    movzbl 2(%r8,%rdi,4), %edi
; GENERIC-NEXT:    shll $16, %edi
; GENERIC-NEXT:    orl %eax, %edi
; GENERIC-NEXT:    xorl 20(%rcx,%rdx), %edi
; GENERIC-NEXT:    movl %ebx, %eax
; GENERIC-NEXT:    shrl $24, %eax
; GENERIC-NEXT:    movb %al, (%rsi)
; GENERIC-NEXT:    shrl $16, %ebx
; GENERIC-NEXT:    movb %bl, 1(%rsi)
; GENERIC-NEXT:    movl %edi, %eax
; GENERIC-NEXT:    shrl $24, %eax
; GENERIC-NEXT:    movb %al, 4(%rsi)
; GENERIC-NEXT:    shrl $16, %edi
; GENERIC-NEXT:    movb %dil, 5(%rsi)
; GENERIC-NEXT:    popq %rbx
; GENERIC-NEXT:    popq %r14
; GENERIC-NEXT:    popq %rbp
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: t:
; ATOM:       ## %bb.0: ## %entry
; ATOM-NEXT:    pushq %rbp
; ATOM-NEXT:    pushq %r15
; ATOM-NEXT:    pushq %r14
; ATOM-NEXT:    pushq %rbx
; ATOM-NEXT:    ## kill: def $ecx killed $ecx def $rcx
; ATOM-NEXT:    movl (%rdx), %r15d
; ATOM-NEXT:    movl 4(%rdx), %eax
; ATOM-NEXT:    leaq 20(%rdx), %r14
; ATOM-NEXT:    movq _Te0@{{.*}}(%rip), %r9
; ATOM-NEXT:    movq _Te1@{{.*}}(%rip), %r8
; ATOM-NEXT:    movq _Te3@{{.*}}(%rip), %r10
; ATOM-NEXT:    decl %ecx
; ATOM-NEXT:    movq %rcx, %r11
; ATOM-NEXT:    .p2align 4, 0x90
; ATOM-NEXT:  LBB0_1: ## %bb
; ATOM-NEXT:    ## =>This Inner Loop Header: Depth=1
; ATOM-NEXT:    movl %eax, %edi
; ATOM-NEXT:    movl %r15d, %ebp
; ATOM-NEXT:    shrl $24, %eax
; ATOM-NEXT:    shrl $16, %edi
; ATOM-NEXT:    shrl $24, %ebp
; ATOM-NEXT:    movzbl %dil, %edi
; ATOM-NEXT:    movl (%r8,%rdi,4), %ebx
; ATOM-NEXT:    movzbl %r15b, %edi
; ATOM-NEXT:    xorl (%r9,%rbp,4), %ebx
; ATOM-NEXT:    movl (%r10,%rdi,4), %edi
; ATOM-NEXT:    xorl -12(%r14), %ebx
; ATOM-NEXT:    xorl (%r9,%rax,4), %edi
; ATOM-NEXT:    movl %ebx, %eax
; ATOM-NEXT:    xorl -8(%r14), %edi
; ATOM-NEXT:    shrl $24, %eax
; ATOM-NEXT:    movl (%r9,%rax,4), %r15d
; ATOM-NEXT:    testq %r11, %r11
; ATOM-NEXT:    movl %edi, %eax
; ATOM-NEXT:    je LBB0_3
; ATOM-NEXT:  ## %bb.2: ## %bb1
; ATOM-NEXT:    ## in Loop: Header=BB0_1 Depth=1
; ATOM-NEXT:    shrl $16, %eax
; ATOM-NEXT:    shrl $24, %edi
; ATOM-NEXT:    decq %r11
; ATOM-NEXT:    movzbl %al, %ebp
; ATOM-NEXT:    movzbl %bl, %eax
; ATOM-NEXT:    movl (%r10,%rax,4), %eax
; ATOM-NEXT:    xorl (%r8,%rbp,4), %r15d
; ATOM-NEXT:    xorl (%r9,%rdi,4), %eax
; ATOM-NEXT:    xorl -4(%r14), %r15d
; ATOM-NEXT:    xorl (%r14), %eax
; ATOM-NEXT:    addq $16, %r14
; ATOM-NEXT:    jmp LBB0_1
; ATOM-NEXT:  LBB0_3: ## %bb2
; ATOM-NEXT:    shrl $16, %eax
; ATOM-NEXT:    shrl $8, %edi
; ATOM-NEXT:    movzbl %bl, %ebp
; ATOM-NEXT:    andl $-16777216, %r15d ## imm = 0xFF000000
; ATOM-NEXT:    shlq $4, %rcx
; ATOM-NEXT:    movzbl %al, %eax
; ATOM-NEXT:    movzbl 3(%r9,%rdi,4), %edi
; ATOM-NEXT:    movzbl 2(%r8,%rbp,4), %ebp
; ATOM-NEXT:    movzbl 2(%r8,%rax,4), %eax
; ATOM-NEXT:    shll $24, %edi
; ATOM-NEXT:    shll $16, %ebp
; ATOM-NEXT:    shll $16, %eax
; ATOM-NEXT:    orl %edi, %ebp
; ATOM-NEXT:    orl %r15d, %eax
; ATOM-NEXT:    xorl 20(%rcx,%rdx), %ebp
; ATOM-NEXT:    xorl 16(%rcx,%rdx), %eax
; ATOM-NEXT:    movl %eax, %edi
; ATOM-NEXT:    shrl $16, %eax
; ATOM-NEXT:    shrl $24, %edi
; ATOM-NEXT:    movb %dil, (%rsi)
; ATOM-NEXT:    movb %al, 1(%rsi)
; ATOM-NEXT:    movl %ebp, %eax
; ATOM-NEXT:    shrl $16, %ebp
; ATOM-NEXT:    shrl $24, %eax
; ATOM-NEXT:    movb %al, 4(%rsi)
; ATOM-NEXT:    movb %bpl, 5(%rsi)
; ATOM-NEXT:    popq %rbx
; ATOM-NEXT:    popq %r14
; ATOM-NEXT:    popq %r15
; ATOM-NEXT:    popq %rbp
; ATOM-NEXT:    retq
entry:
	%0 = load i32, i32* %rk, align 4		; <i32> [#uses=1]
	%1 = getelementptr i32, i32* %rk, i64 1		; <i32*> [#uses=1]
	%2 = load i32, i32* %1, align 4		; <i32> [#uses=1]
	%tmp15 = add i32 %r, -1		; <i32> [#uses=1]
	%tmp.16 = zext i32 %tmp15 to i64		; <i64> [#uses=2]
	br label %bb

bb:		; preds = %bb1, %entry
	%indvar = phi i64 [ 0, %entry ], [ %indvar.next, %bb1 ]		; <i64> [#uses=3]
	%s1.0 = phi i32 [ %2, %entry ], [ %56, %bb1 ]		; <i32> [#uses=2]
	%s0.0 = phi i32 [ %0, %entry ], [ %43, %bb1 ]		; <i32> [#uses=2]
	%tmp18 = shl i64 %indvar, 4		; <i64> [#uses=4]
	%rk26 = bitcast i32* %rk to i8*		; <i8*> [#uses=6]
	%3 = lshr i32 %s0.0, 24		; <i32> [#uses=1]
	%4 = zext i32 %3 to i64		; <i64> [#uses=1]
	%5 = getelementptr [256 x i32], [256 x i32]* @Te0, i64 0, i64 %4		; <i32*> [#uses=1]
	%6 = load i32, i32* %5, align 4		; <i32> [#uses=1]
	%7 = lshr i32 %s1.0, 16		; <i32> [#uses=1]
	%8 = and i32 %7, 255		; <i32> [#uses=1]
	%9 = zext i32 %8 to i64		; <i64> [#uses=1]
	%10 = getelementptr [256 x i32], [256 x i32]* @Te1, i64 0, i64 %9		; <i32*> [#uses=1]
	%11 = load i32, i32* %10, align 4		; <i32> [#uses=1]
	%ctg2.sum2728 = or i64 %tmp18, 8		; <i64> [#uses=1]
	%12 = getelementptr i8, i8* %rk26, i64 %ctg2.sum2728		; <i8*> [#uses=1]
	%13 = bitcast i8* %12 to i32*		; <i32*> [#uses=1]
	%14 = load i32, i32* %13, align 4		; <i32> [#uses=1]
	%15 = xor i32 %11, %6		; <i32> [#uses=1]
	%16 = xor i32 %15, %14		; <i32> [#uses=3]
	%17 = lshr i32 %s1.0, 24		; <i32> [#uses=1]
	%18 = zext i32 %17 to i64		; <i64> [#uses=1]
	%19 = getelementptr [256 x i32], [256 x i32]* @Te0, i64 0, i64 %18		; <i32*> [#uses=1]
	%20 = load i32, i32* %19, align 4		; <i32> [#uses=1]
	%21 = and i32 %s0.0, 255		; <i32> [#uses=1]
	%22 = zext i32 %21 to i64		; <i64> [#uses=1]
	%23 = getelementptr [256 x i32], [256 x i32]* @Te3, i64 0, i64 %22		; <i32*> [#uses=1]
	%24 = load i32, i32* %23, align 4		; <i32> [#uses=1]
	%ctg2.sum2930 = or i64 %tmp18, 12		; <i64> [#uses=1]
	%25 = getelementptr i8, i8* %rk26, i64 %ctg2.sum2930		; <i8*> [#uses=1]
	%26 = bitcast i8* %25 to i32*		; <i32*> [#uses=1]
	%27 = load i32, i32* %26, align 4		; <i32> [#uses=1]
	%28 = xor i32 %24, %20		; <i32> [#uses=1]
	%29 = xor i32 %28, %27		; <i32> [#uses=4]
	%30 = lshr i32 %16, 24		; <i32> [#uses=1]
	%31 = zext i32 %30 to i64		; <i64> [#uses=1]
	%32 = getelementptr [256 x i32], [256 x i32]* @Te0, i64 0, i64 %31		; <i32*> [#uses=1]
	%33 = load i32, i32* %32, align 4		; <i32> [#uses=2]
	%exitcond = icmp eq i64 %indvar, %tmp.16		; <i1> [#uses=1]
	br i1 %exitcond, label %bb2, label %bb1

bb1:		; preds = %bb
	%ctg2.sum31 = add i64 %tmp18, 16		; <i64> [#uses=1]
	%34 = getelementptr i8, i8* %rk26, i64 %ctg2.sum31		; <i8*> [#uses=1]
	%35 = bitcast i8* %34 to i32*		; <i32*> [#uses=1]
	%36 = lshr i32 %29, 16		; <i32> [#uses=1]
	%37 = and i32 %36, 255		; <i32> [#uses=1]
	%38 = zext i32 %37 to i64		; <i64> [#uses=1]
	%39 = getelementptr [256 x i32], [256 x i32]* @Te1, i64 0, i64 %38		; <i32*> [#uses=1]
	%40 = load i32, i32* %39, align 4		; <i32> [#uses=1]
	%41 = load i32, i32* %35, align 4		; <i32> [#uses=1]
	%42 = xor i32 %40, %33		; <i32> [#uses=1]
	%43 = xor i32 %42, %41		; <i32> [#uses=1]
	%44 = lshr i32 %29, 24		; <i32> [#uses=1]
	%45 = zext i32 %44 to i64		; <i64> [#uses=1]
	%46 = getelementptr [256 x i32], [256 x i32]* @Te0, i64 0, i64 %45		; <i32*> [#uses=1]
	%47 = load i32, i32* %46, align 4		; <i32> [#uses=1]
	%48 = and i32 %16, 255		; <i32> [#uses=1]
	%49 = zext i32 %48 to i64		; <i64> [#uses=1]
	%50 = getelementptr [256 x i32], [256 x i32]* @Te3, i64 0, i64 %49		; <i32*> [#uses=1]
	%51 = load i32, i32* %50, align 4		; <i32> [#uses=1]
	%ctg2.sum32 = add i64 %tmp18, 20		; <i64> [#uses=1]
	%52 = getelementptr i8, i8* %rk26, i64 %ctg2.sum32		; <i8*> [#uses=1]
	%53 = bitcast i8* %52 to i32*		; <i32*> [#uses=1]
	%54 = load i32, i32* %53, align 4		; <i32> [#uses=1]
	%55 = xor i32 %51, %47		; <i32> [#uses=1]
	%56 = xor i32 %55, %54		; <i32> [#uses=1]
	%indvar.next = add i64 %indvar, 1		; <i64> [#uses=1]
	br label %bb

bb2:		; preds = %bb
	%tmp10 = shl i64 %tmp.16, 4		; <i64> [#uses=2]
	%ctg2.sum = add i64 %tmp10, 16		; <i64> [#uses=1]
	%tmp1213 = getelementptr i8, i8* %rk26, i64 %ctg2.sum		; <i8*> [#uses=1]
	%57 = bitcast i8* %tmp1213 to i32*		; <i32*> [#uses=1]
	%58 = and i32 %33, -16777216		; <i32> [#uses=1]
	%59 = lshr i32 %29, 16		; <i32> [#uses=1]
	%60 = and i32 %59, 255		; <i32> [#uses=1]
	%61 = zext i32 %60 to i64		; <i64> [#uses=1]
	%62 = getelementptr [256 x i32], [256 x i32]* @Te1, i64 0, i64 %61		; <i32*> [#uses=1]
	%63 = load i32, i32* %62, align 4		; <i32> [#uses=1]
	%64 = and i32 %63, 16711680		; <i32> [#uses=1]
	%65 = or i32 %64, %58		; <i32> [#uses=1]
	%66 = load i32, i32* %57, align 4		; <i32> [#uses=1]
	%67 = xor i32 %65, %66		; <i32> [#uses=2]
	%68 = lshr i32 %29, 8		; <i32> [#uses=1]
	%69 = zext i32 %68 to i64		; <i64> [#uses=1]
	%70 = getelementptr [256 x i32], [256 x i32]* @Te0, i64 0, i64 %69		; <i32*> [#uses=1]
	%71 = load i32, i32* %70, align 4		; <i32> [#uses=1]
	%72 = and i32 %71, -16777216		; <i32> [#uses=1]
	%73 = and i32 %16, 255		; <i32> [#uses=1]
	%74 = zext i32 %73 to i64		; <i64> [#uses=1]
	%75 = getelementptr [256 x i32], [256 x i32]* @Te1, i64 0, i64 %74		; <i32*> [#uses=1]
	%76 = load i32, i32* %75, align 4		; <i32> [#uses=1]
	%77 = and i32 %76, 16711680		; <i32> [#uses=1]
	%78 = or i32 %77, %72		; <i32> [#uses=1]
	%ctg2.sum25 = add i64 %tmp10, 20		; <i64> [#uses=1]
	%79 = getelementptr i8, i8* %rk26, i64 %ctg2.sum25		; <i8*> [#uses=1]
	%80 = bitcast i8* %79 to i32*		; <i32*> [#uses=1]
	%81 = load i32, i32* %80, align 4		; <i32> [#uses=1]
	%82 = xor i32 %78, %81		; <i32> [#uses=2]
	%83 = lshr i32 %67, 24		; <i32> [#uses=1]
	%84 = trunc i32 %83 to i8		; <i8> [#uses=1]
	store i8 %84, i8* %out, align 1
	%85 = lshr i32 %67, 16		; <i32> [#uses=1]
	%86 = trunc i32 %85 to i8		; <i8> [#uses=1]
	%87 = getelementptr i8, i8* %out, i64 1		; <i8*> [#uses=1]
	store i8 %86, i8* %87, align 1
	%88 = getelementptr i8, i8* %out, i64 4		; <i8*> [#uses=1]
	%89 = lshr i32 %82, 24		; <i32> [#uses=1]
	%90 = trunc i32 %89 to i8		; <i8> [#uses=1]
	store i8 %90, i8* %88, align 1
	%91 = lshr i32 %82, 16		; <i32> [#uses=1]
	%92 = trunc i32 %91 to i8		; <i8> [#uses=1]
	%93 = getelementptr i8, i8* %out, i64 5		; <i8*> [#uses=1]
	store i8 %92, i8* %93, align 1
	ret void
}

; Check that DAGCombiner doesn't mess up the IV update when the exiting value
; is equal to the stride.
; It must not fold (cmp (add iv, 1), 1) --> (cmp iv, 0).

define i32 @f(i32 %i, i32* nocapture %a) nounwind uwtable readonly ssp {
; GENERIC-LABEL: f:
; GENERIC:       ## %bb.0: ## %entry
; GENERIC-NEXT:    xorl %eax, %eax
; GENERIC-NEXT:    cmpl $1, %edi
; GENERIC-NEXT:    je LBB1_3
; GENERIC-NEXT:  ## %bb.1: ## %for.body.lr.ph
; GENERIC-NEXT:    movslq %edi, %rax
; GENERIC-NEXT:    leaq (%rsi,%rax,4), %rcx
; GENERIC-NEXT:    xorl %eax, %eax
; GENERIC-NEXT:    xorl %edx, %edx
; GENERIC-NEXT:    .p2align 4, 0x90
; GENERIC-NEXT:  LBB1_2: ## %for.body
; GENERIC-NEXT:    ## =>This Inner Loop Header: Depth=1
; GENERIC-NEXT:    movl (%rcx), %esi
; GENERIC-NEXT:    cmpl %edx, %esi
; GENERIC-NEXT:    cmoval %esi, %edx
; GENERIC-NEXT:    cmoval %edi, %eax
; GENERIC-NEXT:    incl %edi
; GENERIC-NEXT:    addq $4, %rcx
; GENERIC-NEXT:    cmpl $1, %edi
; GENERIC-NEXT:    jne LBB1_2
; GENERIC-NEXT:  LBB1_3: ## %for.end
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: f:
; ATOM:       ## %bb.0: ## %entry
; ATOM-NEXT:    xorl %eax, %eax
; ATOM-NEXT:    cmpl $1, %edi
; ATOM-NEXT:    je LBB1_3
; ATOM-NEXT:  ## %bb.1: ## %for.body.lr.ph
; ATOM-NEXT:    movslq %edi, %rax
; ATOM-NEXT:    xorl %edx, %edx
; ATOM-NEXT:    leaq (%rsi,%rax,4), %rcx
; ATOM-NEXT:    xorl %eax, %eax
; ATOM-NEXT:    .p2align 4, 0x90
; ATOM-NEXT:  LBB1_2: ## %for.body
; ATOM-NEXT:    ## =>This Inner Loop Header: Depth=1
; ATOM-NEXT:    movl (%rcx), %esi
; ATOM-NEXT:    cmpl %edx, %esi
; ATOM-NEXT:    cmoval %esi, %edx
; ATOM-NEXT:    cmoval %edi, %eax
; ATOM-NEXT:    incl %edi
; ATOM-NEXT:    leaq 4(%rcx), %rcx
; ATOM-NEXT:    cmpl $1, %edi
; ATOM-NEXT:    jne LBB1_2
; ATOM-NEXT:  LBB1_3: ## %for.end
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
entry:
  %cmp4 = icmp eq i32 %i, 1
  br i1 %cmp4, label %for.end, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %0 = sext i32 %i to i64
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %indvars.iv = phi i64 [ %0, %for.body.lr.ph ], [ %indvars.iv.next, %for.body ]
  %bi.06 = phi i32 [ 0, %for.body.lr.ph ], [ %i.addr.0.bi.0, %for.body ]
  %b.05 = phi i32 [ 0, %for.body.lr.ph ], [ %.b.0, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp ugt i32 %1, %b.05
  %.b.0 = select i1 %cmp1, i32 %1, i32 %b.05
  %2 = trunc i64 %indvars.iv to i32
  %i.addr.0.bi.0 = select i1 %cmp1, i32 %2, i32 %bi.06
  %indvars.iv.next = add i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, 1
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  %bi.0.lcssa = phi i32 [ 0, %entry ], [ %i.addr.0.bi.0, %for.body ]
  ret i32 %bi.0.lcssa
}
