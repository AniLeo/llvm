; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -o - -mtriple=i686-unknown-unknown %s | FileCheck %s --check-prefixes=ALL,X32
; RUN: llc -o - -mtriple=x86_64-unknown-unknown %s | FileCheck %s --check-prefixes=ALL,X64
;
; Test patterns that require preserving and restoring flags.

@b = common global i8 0, align 1
@c = common global i32 0, align 4
@a = common global i8 0, align 1
@d = common global i8 0, align 1
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare void @external(i32)

; A test that re-uses flags in interesting ways due to volatile accesses.
; Specifically, the first increment's flags are reused for the branch despite
; being clobbered by the second increment.
define i32 @test1() nounwind {
; X32-LABEL: test1:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb b, %cl
; X32-NEXT:    movl %ecx, %eax
; X32-NEXT:    incb %al
; X32-NEXT:    movb %al, b
; X32-NEXT:    incl c
; X32-NEXT:    sete %dl
; X32-NEXT:    movb a, %ah
; X32-NEXT:    movb %ah, %ch
; X32-NEXT:    incb %ch
; X32-NEXT:    cmpb %cl, %ah
; X32-NEXT:    sete d
; X32-NEXT:    movb %ch, a
; X32-NEXT:    testb %dl, %dl
; X32-NEXT:    jne .LBB0_2
; X32-NEXT:  # %bb.1: # %if.then
; X32-NEXT:    movsbl %al, %eax
; X32-NEXT:    pushl %eax
; X32-NEXT:    calll external
; X32-NEXT:    addl $4, %esp
; X32-NEXT:  .LBB0_2: # %if.end
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test1:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rax
; X64-NEXT:    movb {{.*}}(%rip), %cl
; X64-NEXT:    leal 1(%rcx), %eax
; X64-NEXT:    movb %al, {{.*}}(%rip)
; X64-NEXT:    incl {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    movb {{.*}}(%rip), %sil
; X64-NEXT:    leal 1(%rsi), %edi
; X64-NEXT:    cmpb %cl, %sil
; X64-NEXT:    sete {{.*}}(%rip)
; X64-NEXT:    movb %dil, {{.*}}(%rip)
; X64-NEXT:    testb %dl, %dl
; X64-NEXT:    jne .LBB0_2
; X64-NEXT:  # %bb.1: # %if.then
; X64-NEXT:    movsbl %al, %edi
; X64-NEXT:    callq external
; X64-NEXT:  .LBB0_2: # %if.end
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
entry:
  %bval = load i8, i8* @b
  %inc = add i8 %bval, 1
  store volatile i8 %inc, i8* @b
  %cval = load volatile i32, i32* @c
  %inc1 = add nsw i32 %cval, 1
  store volatile i32 %inc1, i32* @c
  %aval = load volatile i8, i8* @a
  %inc2 = add i8 %aval, 1
  store volatile i8 %inc2, i8* @a
  %cmp = icmp eq i8 %aval, %bval
  %conv5 = zext i1 %cmp to i8
  store i8 %conv5, i8* @d
  %tobool = icmp eq i32 %inc1, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:
  %conv6 = sext i8 %inc to i32
  call void @external(i32 %conv6)
  br label %if.end

if.end:
  ret i32 0
}

; Preserve increment flags across a call.
define i32 @test2(i32* %ptr) nounwind {
; X32-LABEL: test2:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %ebx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    incl (%eax)
; X32-NEXT:    setne %bl
; X32-NEXT:    pushl $42
; X32-NEXT:    calll external
; X32-NEXT:    addl $4, %esp
; X32-NEXT:    testb %bl, %bl
; X32-NEXT:    jne .LBB1_2
; X32-NEXT:  # %bb.1: # %then
; X32-NEXT:    movl $64, %eax
; X32-NEXT:    popl %ebx
; X32-NEXT:    retl
; X32-NEXT:  .LBB1_2: # %else
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    popl %ebx
; X32-NEXT:    retl
;
; X64-LABEL: test2:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbx
; X64-NEXT:    incl (%rdi)
; X64-NEXT:    setne %bl
; X64-NEXT:    movl $42, %edi
; X64-NEXT:    callq external
; X64-NEXT:    testb %bl, %bl
; X64-NEXT:    jne .LBB1_2
; X64-NEXT:  # %bb.1: # %then
; X64-NEXT:    movl $64, %eax
; X64-NEXT:    popq %rbx
; X64-NEXT:    retq
; X64-NEXT:  .LBB1_2: # %else
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    popq %rbx
; X64-NEXT:    retq
entry:
  %val = load i32, i32* %ptr
  %inc = add i32 %val, 1
  store i32 %inc, i32* %ptr
  %cmp = icmp eq i32 %inc, 0
  call void @external(i32 42)
  br i1 %cmp, label %then, label %else

then:
  ret i32 64

else:
  ret i32 0
}

declare void @external_a()
declare void @external_b()

; This lowers to a conditional tail call instead of a conditional branch. This
; is tricky because we can only do this from a leaf function, and so we have to
; use volatile stores similar to test1 to force the save and restore of
; a condition without calling another function. We then set up subsequent calls
; in tail position.
define void @test_tail_call(i32* %ptr) nounwind optsize {
; X32-LABEL: test_tail_call:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    incl (%eax)
; X32-NEXT:    setne %al
; X32-NEXT:    incb a
; X32-NEXT:    sete d
; X32-NEXT:    testb %al, %al
; X32-NEXT:    jne external_b # TAILCALL
; X32-NEXT:  # %bb.1: # %then
; X32-NEXT:    jmp external_a # TAILCALL
;
; X64-LABEL: test_tail_call:
; X64:       # %bb.0: # %entry
; X64-NEXT:    incl (%rdi)
; X64-NEXT:    setne %al
; X64-NEXT:    incb {{.*}}(%rip)
; X64-NEXT:    sete {{.*}}(%rip)
; X64-NEXT:    testb %al, %al
; X64-NEXT:    jne external_b # TAILCALL
; X64-NEXT:  # %bb.1: # %then
; X64-NEXT:    jmp external_a # TAILCALL
entry:
  %val = load i32, i32* %ptr
  %inc = add i32 %val, 1
  store i32 %inc, i32* %ptr
  %cmp = icmp eq i32 %inc, 0
  %aval = load volatile i8, i8* @a
  %inc2 = add i8 %aval, 1
  store volatile i8 %inc2, i8* @a
  %cmp2 = icmp eq i8 %inc2, 0
  %conv5 = zext i1 %cmp2 to i8
  store i8 %conv5, i8* @d
  br i1 %cmp, label %then, label %else

then:
  tail call void @external_a()
  ret void

else:
  tail call void @external_b()
  ret void
}

; Test a function that gets special select lowering into CFG with copied EFLAGS
; threaded across the CFG. This requires our EFLAGS copy rewriting to handle
; cross-block rewrites in at least some narrow cases.
define void @PR37100(i8 %arg1, i16 %arg2, i64 %arg3, i8 %arg4, i8* %ptr1, i32* %ptr2, i32 %x) nounwind {
; X32-LABEL: PR37100:
; X32:       # %bb.0: # %bb
; X32-NEXT:    pushl %ebp
; X32-NEXT:    pushl %ebx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X32-NEXT:    movb {{[0-9]+}}(%esp), %ch
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    jmp .LBB3_1
; X32-NEXT:    .p2align 4, 0x90
; X32-NEXT:  .LBB3_5: # %bb1
; X32-NEXT:    # in Loop: Header=BB3_1 Depth=1
; X32-NEXT:    movl %esi, %eax
; X32-NEXT:    cltd
; X32-NEXT:    idivl %edi
; X32-NEXT:  .LBB3_1: # %bb1
; X32-NEXT:    # =>This Inner Loop Header: Depth=1
; X32-NEXT:    movsbl %cl, %eax
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    sarl $31, %edx
; X32-NEXT:    cmpl %eax, {{[0-9]+}}(%esp)
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    sbbl %edx, %eax
; X32-NEXT:    setl %al
; X32-NEXT:    setl %dl
; X32-NEXT:    movzbl %dl, %edi
; X32-NEXT:    negl %edi
; X32-NEXT:    testb %al, %al
; X32-NEXT:    jne .LBB3_3
; X32-NEXT:  # %bb.2: # %bb1
; X32-NEXT:    # in Loop: Header=BB3_1 Depth=1
; X32-NEXT:    movb %ch, %cl
; X32-NEXT:  .LBB3_3: # %bb1
; X32-NEXT:    # in Loop: Header=BB3_1 Depth=1
; X32-NEXT:    movb %cl, (%ebp)
; X32-NEXT:    movl (%ebx), %edx
; X32-NEXT:    testb %al, %al
; X32-NEXT:    jne .LBB3_5
; X32-NEXT:  # %bb.4: # %bb1
; X32-NEXT:    # in Loop: Header=BB3_1 Depth=1
; X32-NEXT:    movl %edx, %edi
; X32-NEXT:    jmp .LBB3_5
;
; X64-LABEL: PR37100:
; X64:       # %bb.0: # %bb
; X64-NEXT:    movq %rdx, %rsi
; X64-NEXT:    movl {{[0-9]+}}(%rsp), %r10d
; X64-NEXT:    movzbl %cl, %r11d
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB3_1: # %bb1
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movsbq %dil, %rax
; X64-NEXT:    xorl %ecx, %ecx
; X64-NEXT:    cmpq %rax, %rsi
; X64-NEXT:    setl %cl
; X64-NEXT:    negl %ecx
; X64-NEXT:    cmpq %rax, %rsi
; X64-NEXT:    movzbl %al, %edi
; X64-NEXT:    cmovgel %r11d, %edi
; X64-NEXT:    movb %dil, (%r8)
; X64-NEXT:    cmovgel (%r9), %ecx
; X64-NEXT:    movl %r10d, %eax
; X64-NEXT:    cltd
; X64-NEXT:    idivl %ecx
; X64-NEXT:    jmp .LBB3_1
bb:
  br label %bb1

bb1:
  %tmp = phi i8 [ %tmp8, %bb1 ], [ %arg1, %bb ]
  %tmp2 = phi i16 [ %tmp12, %bb1 ], [ %arg2, %bb ]
  %tmp3 = icmp sgt i16 %tmp2, 7
  %tmp4 = select i1 %tmp3, i16 %tmp2, i16 7
  %tmp5 = sext i8 %tmp to i64
  %tmp6 = icmp slt i64 %arg3, %tmp5
  %tmp7 = sext i1 %tmp6 to i32
  %tmp8 = select i1 %tmp6, i8 %tmp, i8 %arg4
  store volatile i8 %tmp8, i8* %ptr1
  %tmp9 = load volatile i32, i32* %ptr2
  %tmp10 = select i1 %tmp6, i32 %tmp7, i32 %tmp9
  %tmp11 = srem i32 %x, %tmp10
  %tmp12 = trunc i32 %tmp11 to i16
  br label %bb1
}

; Use a particular instruction pattern in order to lower to the post-RA pseudo
; used to lower SETB into an SBB pattern in order to make sure that kind of
; usage of a copied EFLAGS continues to work.
define void @PR37431(i32* %arg1, i8* %arg2, i8* %arg3, i32 %arg4, i64 %arg5) nounwind {
; X32-LABEL: PR37431:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl (%ecx), %ecx
; X32-NEXT:    movl %ecx, %edx
; X32-NEXT:    sarl $31, %edx
; X32-NEXT:    cmpl %ecx, {{[0-9]+}}(%esp)
; X32-NEXT:    sbbl %edx, %eax
; X32-NEXT:    setb %cl
; X32-NEXT:    sbbb %dl, %dl
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:    movb %dl, (%edi)
; X32-NEXT:    movzbl %cl, %ecx
; X32-NEXT:    xorl %edi, %edi
; X32-NEXT:    subl %ecx, %edi
; X32-NEXT:    cltd
; X32-NEXT:    idivl %edi
; X32-NEXT:    movb %dl, (%esi)
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    retl
;
; X64-LABEL: PR37431:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    movq %rdx, %r9
; X64-NEXT:    movslq (%rdi), %rdx
; X64-NEXT:    cmpq %rdx, %r8
; X64-NEXT:    sbbb %cl, %cl
; X64-NEXT:    cmpq %rdx, %r8
; X64-NEXT:    movb %cl, (%rsi)
; X64-NEXT:    sbbl %ecx, %ecx
; X64-NEXT:    cltd
; X64-NEXT:    idivl %ecx
; X64-NEXT:    movb %dl, (%r9)
; X64-NEXT:    retq
entry:
  %tmp = load i32, i32* %arg1
  %tmp1 = sext i32 %tmp to i64
  %tmp2 = icmp ugt i64 %tmp1, %arg5
  %tmp3 = zext i1 %tmp2 to i8
  %tmp4 = sub i8 0, %tmp3
  store i8 %tmp4, i8* %arg2
  %tmp5 = sext i8 %tmp4 to i32
  %tmp6 = srem i32 %arg4, %tmp5
  %tmp7 = trunc i32 %tmp6 to i8
  store i8 %tmp7, i8* %arg3
  ret void
}
