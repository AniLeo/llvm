; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -post-RA-scheduler=true | FileCheck %s

declare void @bar(i32)
declare void @car(i32)
declare void @dar(i32)
declare void @ear(i32)
declare void @far(i32)
declare i1 @qux()

@GHJK = global i32 0
@HABC = global i32 0

; BranchFolding should tail-merge the stores since they all precede
; direct branches to the same place.

define void @tail_merge_me() nounwind {
; CHECK-LABEL: tail_merge_me:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB0_1
; CHECK-NEXT:  # %bb.6: # %A
; CHECK-NEXT:    xorl %edi, %edi
; CHECK-NEXT:    callq bar
; CHECK-NEXT:    jmp .LBB0_4
; CHECK-NEXT:  .LBB0_1: # %next
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB0_3
; CHECK-NEXT:  # %bb.2: # %B
; CHECK-NEXT:    movl $1, %edi
; CHECK-NEXT:    callq car
; CHECK-NEXT:    jmp .LBB0_4
; CHECK-NEXT:  .LBB0_3: # %C
; CHECK-NEXT:    movl $2, %edi
; CHECK-NEXT:    callq dar
; CHECK-NEXT:  .LBB0_4: # %M
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    movl $1, {{.*}}(%rip)
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB0_5
; CHECK-NEXT:  # %bb.7: # %return
; CHECK-NEXT:    movl $1000, %edi # imm = 0x3E8
; CHECK-NEXT:    callq ear
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_5: # %altret
; CHECK-NEXT:    movl $1001, %edi # imm = 0x3E9
; CHECK-NEXT:    callq far
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %a = call i1 @qux()
  br i1 %a, label %A, label %next
next:
  %b = call i1 @qux()
  br i1 %b, label %B, label %C

A:
  call void @bar(i32 0)
  store i32 0, i32* @GHJK
  br label %M

B:
  call void @car(i32 1)
  store i32 0, i32* @GHJK
  br label %M

C:
  call void @dar(i32 2)
  store i32 0, i32* @GHJK
  br label %M

M:
  store i32 1, i32* @HABC
  %c = call i1 @qux()
  br i1 %c, label %return, label %altret

return:
  call void @ear(i32 1000)
  ret void
altret:
  call void @far(i32 1001)
  ret void
}

declare i8* @choose(i8*, i8*)

; BranchFolding should tail-duplicate the indirect jump to avoid
; redundant branching.

define void @tail_duplicate_me() nounwind {
; CHECK-LABEL: tail_duplicate_me:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    movl $.Ltmp0, %edi
; CHECK-NEXT:    movl $.Ltmp1, %esi
; CHECK-NEXT:    movl %eax, %ebx
; CHECK-NEXT:    callq choose
; CHECK-NEXT:    movq %rax, %r14
; CHECK-NEXT:    testb $1, %bl
; CHECK-NEXT:    je .LBB1_1
; CHECK-NEXT:  # %bb.7: # %A
; CHECK-NEXT:    xorl %edi, %edi
; CHECK-NEXT:    callq bar
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    jmpq *%r14
; CHECK-NEXT:  .Ltmp0: # Block address taken
; CHECK-NEXT:  .LBB1_4: # %return
; CHECK-NEXT:    movl $1000, %edi # imm = 0x3E8
; CHECK-NEXT:    callq ear
; CHECK-NEXT:    jmp .LBB1_5
; CHECK-NEXT:  .LBB1_1: # %next
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB1_3
; CHECK-NEXT:  # %bb.2: # %B
; CHECK-NEXT:    movl $1, %edi
; CHECK-NEXT:    callq car
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    jmpq *%r14
; CHECK-NEXT:  .Ltmp1: # Block address taken
; CHECK-NEXT:  .LBB1_6: # %altret
; CHECK-NEXT:    movl $1001, %edi # imm = 0x3E9
; CHECK-NEXT:    callq far
; CHECK-NEXT:  .LBB1_5: # %return
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB1_3: # %C
; CHECK-NEXT:    movl $2, %edi
; CHECK-NEXT:    callq dar
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    jmpq *%r14
entry:
  %a = call i1 @qux()
  %c = call i8* @choose(i8* blockaddress(@tail_duplicate_me, %return),
                        i8* blockaddress(@tail_duplicate_me, %altret))
  br i1 %a, label %A, label %next
next:
  %b = call i1 @qux()
  br i1 %b, label %B, label %C

A:
  call void @bar(i32 0)
  store i32 0, i32* @GHJK
  br label %M

B:
  call void @car(i32 1)
  store i32 0, i32* @GHJK
  br label %M

C:
  call void @dar(i32 2)
  store i32 0, i32* @GHJK
  br label %M

M:
  indirectbr i8* %c, [label %return, label %altret]

return:
  call void @ear(i32 1000)
  ret void
altret:
  call void @far(i32 1001)
  ret void
}

; BranchFolding shouldn't try to merge the tails of two blocks
; with only a branch in common, regardless of the fallthrough situation.

define i1 @dont_merge_oddly(float* %result) nounwind {
; CHECK-LABEL: dont_merge_oddly:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    movss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    ucomiss %xmm1, %xmm2
; CHECK-NEXT:    jbe .LBB2_3
; CHECK-NEXT:  # %bb.1: # %bb
; CHECK-NEXT:    ucomiss %xmm0, %xmm1
; CHECK-NEXT:    ja .LBB2_4
; CHECK-NEXT:  .LBB2_2: # %bb30
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB2_3: # %bb21
; CHECK-NEXT:    ucomiss %xmm0, %xmm2
; CHECK-NEXT:    jbe .LBB2_2
; CHECK-NEXT:  .LBB2_4: # %bb26
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
entry:
  %tmp4 = getelementptr float, float* %result, i32 2
  %tmp5 = load float, float* %tmp4, align 4
  %tmp7 = getelementptr float, float* %result, i32 4
  %tmp8 = load float, float* %tmp7, align 4
  %tmp10 = getelementptr float, float* %result, i32 6
  %tmp11 = load float, float* %tmp10, align 4
  %tmp12 = fcmp olt float %tmp8, %tmp11
  br i1 %tmp12, label %bb, label %bb21

bb:
  %tmp23469 = fcmp olt float %tmp5, %tmp8
  br i1 %tmp23469, label %bb26, label %bb30

bb21:
  %tmp23 = fcmp olt float %tmp5, %tmp11
  br i1 %tmp23, label %bb26, label %bb30

bb26:
  ret i1 0

bb30:
  ret i1 1
}

; Do any-size tail-merging when two candidate blocks will both require
; an unconditional jump to complete a two-way conditional branch.
;
; This test only works when register allocation happens to use %rax for both
; load addresses.

%0 = type { %struct.rtx_def* }
%struct.lang_decl = type opaque
%struct.rtx_def = type { i16, i8, i8, [1 x %union.rtunion] }
%struct.tree_decl = type { [24 x i8], i8*, i32, %union.tree_node*, i32, i8, i8, i8, i8, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %union.tree_node*, %struct.rtx_def*, %union..2anon, %0, %union.tree_node*, %struct.lang_decl* }
%union..2anon = type { i32 }
%union.rtunion = type { i8* }
%union.tree_node = type { %struct.tree_decl }

define fastcc void @c_expand_expr_stmt(%union.tree_node* %expr) nounwind {
; CHECK-LABEL: c_expand_expr_stmt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB3_9
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    movb 0, %bl
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB3_8
; CHECK-NEXT:  # %bb.2: # %bb.i
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je .LBB3_8
; CHECK-NEXT:  # %bb.3: # %lvalue_p.exit
; CHECK-NEXT:    movq 0, %rax
; CHECK-NEXT:    movzbl (%rax), %ecx
; CHECK-NEXT:    testl %ecx, %ecx
; CHECK-NEXT:    je .LBB3_10
; CHECK-NEXT:  # %bb.4: # %lvalue_p.exit
; CHECK-NEXT:    cmpl $2, %ecx
; CHECK-NEXT:    jne .LBB3_15
; CHECK-NEXT:  # %bb.5: # %bb.i1
; CHECK-NEXT:    movq 32(%rax), %rax
; CHECK-NEXT:    movzbl 16(%rax), %ecx
; CHECK-NEXT:    testl %ecx, %ecx
; CHECK-NEXT:    je .LBB3_13
; CHECK-NEXT:  # %bb.6: # %bb.i1
; CHECK-NEXT:    cmpl $2, %ecx
; CHECK-NEXT:    jne .LBB3_15
; CHECK-NEXT:  # %bb.7: # %bb.i.i
; CHECK-NEXT:    xorl %edi, %edi
; CHECK-NEXT:    callq lvalue_p
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    jmp .LBB3_16
; CHECK-NEXT:  .LBB3_8: # %bb1
; CHECK-NEXT:    cmpb $23, %bl
; CHECK-NEXT:  .LBB3_9: # %bb3
; CHECK-NEXT:  .LBB3_15:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:  .LBB3_16: # %lvalue_p.exit4
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB3_9
; CHECK-NEXT:  # %bb.17: # %lvalue_p.exit4
; CHECK-NEXT:    testb %bl, %bl
; CHECK-NEXT:  .LBB3_10: # %bb2.i3
; CHECK-NEXT:    movq 8(%rax), %rax
; CHECK-NEXT:    movb 16(%rax), %cl
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpb $23, %cl
; CHECK-NEXT:    je .LBB3_16
; CHECK-NEXT:  # %bb.11: # %bb2.i3
; CHECK-NEXT:    cmpb $16, %cl
; CHECK-NEXT:    je .LBB3_16
; CHECK-NEXT:    jmp .LBB3_9
; CHECK-NEXT:  .LBB3_13: # %bb2.i.i2
; CHECK-NEXT:    movq 8(%rax), %rax
; CHECK-NEXT:    movb 16(%rax), %cl
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpb $16, %cl
; CHECK-NEXT:    je .LBB3_16
; CHECK-NEXT:  # %bb.14: # %bb2.i.i2
; CHECK-NEXT:    cmpb $23, %cl
; CHECK-NEXT:    je .LBB3_16
; CHECK-NEXT:    jmp .LBB3_9
entry:
  %tmp4 = load i8, i8* null, align 8                  ; <i8> [#uses=3]
  switch i8 %tmp4, label %bb3 [
    i8 18, label %bb
  ]

bb:                                               ; preds = %entry
  switch i32 undef, label %bb1 [
    i32 0, label %bb2.i
    i32 37, label %bb.i
  ]

bb.i:                                             ; preds = %bb
  switch i32 undef, label %bb1 [
    i32 0, label %lvalue_p.exit
  ]

bb2.i:                                            ; preds = %bb
  br label %bb3

lvalue_p.exit:                                    ; preds = %bb.i
  %tmp21 = load %union.tree_node*, %union.tree_node** null, align 8  ; <%union.tree_node*> [#uses=3]
  %tmp22 = getelementptr inbounds %union.tree_node, %union.tree_node* %tmp21, i64 0, i32 0, i32 0, i64 0 ; <i8*> [#uses=1]
  %tmp23 = load i8, i8* %tmp22, align 8               ; <i8> [#uses=1]
  %tmp24 = zext i8 %tmp23 to i32                  ; <i32> [#uses=1]
  switch i32 %tmp24, label %lvalue_p.exit4 [
    i32 0, label %bb2.i3
    i32 2, label %bb.i1
  ]

bb.i1:                                            ; preds = %lvalue_p.exit
  %tmp25 = getelementptr inbounds %union.tree_node, %union.tree_node* %tmp21, i64 0, i32 0, i32 2 ; <i32*> [#uses=1]
  %tmp26 = bitcast i32* %tmp25 to %union.tree_node** ; <%union.tree_node**> [#uses=1]
  %tmp27 = load %union.tree_node*, %union.tree_node** %tmp26, align 8 ; <%union.tree_node*> [#uses=2]
  %tmp28 = getelementptr inbounds %union.tree_node, %union.tree_node* %tmp27, i64 0, i32 0, i32 0, i64 16 ; <i8*> [#uses=1]
  %tmp29 = load i8, i8* %tmp28, align 8               ; <i8> [#uses=1]
  %tmp30 = zext i8 %tmp29 to i32                  ; <i32> [#uses=1]
  switch i32 %tmp30, label %lvalue_p.exit4 [
    i32 0, label %bb2.i.i2
    i32 2, label %bb.i.i
  ]

bb.i.i:                                           ; preds = %bb.i1
  %tmp34 = tail call fastcc i32 @lvalue_p(%union.tree_node* null) nounwind ; <i32> [#uses=1]
  %phitmp = icmp ne i32 %tmp34, 0                 ; <i1> [#uses=1]
  br label %lvalue_p.exit4

bb2.i.i2:                                         ; preds = %bb.i1
  %tmp35 = getelementptr inbounds %union.tree_node, %union.tree_node* %tmp27, i64 0, i32 0, i32 0, i64 8 ; <i8*> [#uses=1]
  %tmp36 = bitcast i8* %tmp35 to %union.tree_node** ; <%union.tree_node**> [#uses=1]
  %tmp37 = load %union.tree_node*, %union.tree_node** %tmp36, align 8 ; <%union.tree_node*> [#uses=1]
  %tmp38 = getelementptr inbounds %union.tree_node, %union.tree_node* %tmp37, i64 0, i32 0, i32 0, i64 16 ; <i8*> [#uses=1]
  %tmp39 = load i8, i8* %tmp38, align 8               ; <i8> [#uses=1]
  switch i8 %tmp39, label %bb2 [
    i8 16, label %lvalue_p.exit4
    i8 23, label %lvalue_p.exit4
  ]

bb2.i3:                                           ; preds = %lvalue_p.exit
  %tmp40 = getelementptr inbounds %union.tree_node, %union.tree_node* %tmp21, i64 0, i32 0, i32 0, i64 8 ; <i8*> [#uses=1]
  %tmp41 = bitcast i8* %tmp40 to %union.tree_node** ; <%union.tree_node**> [#uses=1]
  %tmp42 = load %union.tree_node*, %union.tree_node** %tmp41, align 8 ; <%union.tree_node*> [#uses=1]
  %tmp43 = getelementptr inbounds %union.tree_node, %union.tree_node* %tmp42, i64 0, i32 0, i32 0, i64 16 ; <i8*> [#uses=1]
  %tmp44 = load i8, i8* %tmp43, align 8               ; <i8> [#uses=1]
  switch i8 %tmp44, label %bb2 [
    i8 16, label %lvalue_p.exit4
    i8 23, label %lvalue_p.exit4
  ]

lvalue_p.exit4:                                   ; preds = %bb2.i3, %bb2.i3, %bb2.i.i2, %bb2.i.i2, %bb.i.i, %bb.i1, %lvalue_p.exit
  %tmp45 = phi i1 [ %phitmp, %bb.i.i ], [ false, %bb2.i.i2 ], [ false, %bb2.i.i2 ], [ false, %bb.i1 ], [ false, %bb2.i3 ], [ false, %bb2.i3 ], [ false, %lvalue_p.exit ] ; <i1> [#uses=1]
  %tmp46 = icmp eq i8 %tmp4, 0                    ; <i1> [#uses=1]
  %or.cond = or i1 %tmp45, %tmp46                 ; <i1> [#uses=1]
  br i1 %or.cond, label %bb2, label %bb3

bb1:                                              ; preds = %bb2.i.i, %bb.i, %bb
  %.old = icmp eq i8 %tmp4, 23                    ; <i1> [#uses=1]
  br i1 %.old, label %bb2, label %bb3

bb2:                                              ; preds = %bb1, %lvalue_p.exit4, %bb2.i3, %bb2.i.i2
  br label %bb3

bb3:                                              ; preds = %bb2, %bb1, %lvalue_p.exit4, %bb2.i, %entry
  %expr_addr.0 = phi %union.tree_node* [ null, %bb2 ], [ %expr, %bb2.i ], [ %expr, %entry ], [ %expr, %bb1 ], [ %expr, %lvalue_p.exit4 ] ; <%union.tree_node*> [#uses=0]
  unreachable
}

declare fastcc i32 @lvalue_p(%union.tree_node* nocapture) nounwind readonly

declare fastcc %union.tree_node* @default_conversion(%union.tree_node*) nounwind


; If one tail merging candidate falls through into the other,
; tail merging is likely profitable regardless of how few
; instructions are involved. This function should have only
; one ret instruction.

define void @foo(i1* %V) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    je .LBB4_2
; CHECK-NEXT:  # %bb.1: # %bb
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq func
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:  .LBB4_2: # %return
; CHECK-NEXT:    retq
entry:
  %t0 = icmp eq i1* %V, null
  br i1 %t0, label %return, label %bb

bb:
  call void @func()
  ret void

return:
  ret void
}

declare void @func()

; one - One instruction may be tail-duplicated even with optsize.

@XYZ = external global i32

declare void @tail_call_me()

define void @one(i32 %v) nounwind optsize {
; CHECK-LABEL: one:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    je .LBB5_3
; CHECK-NEXT:  # %bb.1: # %bby
; CHECK-NEXT:    cmpl $16, %edi
; CHECK-NEXT:    je .LBB5_4
; CHECK-NEXT:  # %bb.2: # %bb7
; CHECK-NEXT:    jmp tail_call_me # TAILCALL
; CHECK-NEXT:  .LBB5_3: # %bbx
; CHECK-NEXT:    cmpl $128, %edi
; CHECK-NEXT:    jne tail_call_me # TAILCALL
; CHECK-NEXT:  .LBB5_4: # %return
; CHECK-NEXT:    retq
entry:
  %0 = icmp eq i32 %v, 0
  br i1 %0, label %bbx, label %bby

bby:
  switch i32 %v, label %bb7 [
    i32 16, label %return
  ]

bb7:
  tail call void @tail_call_me()
  ret void

bbx:
  switch i32 %v, label %bb12 [
    i32 128, label %return
  ]

bb12:
  tail call void @tail_call_me()
  ret void

return:
  ret void
}

; two - Same as one, but with two instructions in the common
; tail instead of one. This is too much to be merged, given
; the optsize attribute.

define void @two() nounwind optsize {
; CHECK-LABEL: two:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je .LBB6_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB6_1: # %bb7
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    movl $1, {{.*}}(%rip)
entry:
  %0 = icmp eq i32 undef, 0
  br i1 %0, label %bbx, label %bby

bby:
  switch i32 undef, label %bb7 [
    i32 16, label %return
  ]

bb7:
  store volatile i32 0, i32* @XYZ
  store volatile i32 1, i32* @XYZ
  unreachable

bbx:
  switch i32 undef, label %bb12 [
    i32 128, label %return
  ]

bb12:
  store volatile i32 0, i32* @XYZ
  store volatile i32 1, i32* @XYZ
  unreachable

return:
  ret void
}

; two_minsize - Same as two, but with minsize instead of optsize.

define void @two_minsize() nounwind minsize {
; CHECK-LABEL: two_minsize:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je .LBB7_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB7_1: # %bb7
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    movl $1, {{.*}}(%rip)
entry:
  %0 = icmp eq i32 undef, 0
  br i1 %0, label %bbx, label %bby

bby:
  switch i32 undef, label %bb7 [
    i32 16, label %return
  ]

bb7:
  store volatile i32 0, i32* @XYZ
  store volatile i32 1, i32* @XYZ
  unreachable

bbx:
  switch i32 undef, label %bb12 [
    i32 128, label %return
  ]

bb12:
  store volatile i32 0, i32* @XYZ
  store volatile i32 1, i32* @XYZ
  unreachable

return:
  ret void
}

; two_nosize - Same as two, but without the optsize attribute.
; Now two instructions are enough to be tail-duplicated.

define void @two_nosize(i32 %x, i32 %y, i32 %z) nounwind {
; CHECK-LABEL: two_nosize:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    je .LBB8_3
; CHECK-NEXT:  # %bb.1: # %bby
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    je .LBB8_4
; CHECK-NEXT:  # %bb.2: # %bb7
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    jmp tail_call_me # TAILCALL
; CHECK-NEXT:  .LBB8_3: # %bbx
; CHECK-NEXT:    cmpl $-1, %edx
; CHECK-NEXT:    je .LBB8_4
; CHECK-NEXT:  # %bb.5: # %bb12
; CHECK-NEXT:    movl $0, {{.*}}(%rip)
; CHECK-NEXT:    jmp tail_call_me # TAILCALL
; CHECK-NEXT:  .LBB8_4: # %return
; CHECK-NEXT:    retq
entry:
  %0 = icmp eq i32 %x, 0
  br i1 %0, label %bbx, label %bby

bby:
  switch i32 %y, label %bb7 [
    i32 0, label %return
  ]

bb7:
  store volatile i32 0, i32* @XYZ
  tail call void @tail_call_me()
  ret void

bbx:
  switch i32 %z, label %bb12 [
    i32 -1, label %return
  ]

bb12:
  store volatile i32 0, i32* @XYZ
  tail call void @tail_call_me()
  ret void

return:
  ret void
}

; Tail-merging should merge the two ret instructions since one side
; can fall-through into the ret and the other side has to branch anyway.

define i64 @TESTE(i64 %parami, i64 %paraml) nounwind readnone {
; CHECK-LABEL: TESTE:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    cmovgq %rdi, %rax
; CHECK-NEXT:    testq %rsi, %rsi
; CHECK-NEXT:    jle .LBB9_2
; CHECK-NEXT:  # %bb.1: # %bb.nph
; CHECK-NEXT:    imulq %rdi, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:  .LBB9_2: # %for.end
; CHECK-NEXT:    retq
entry:
  %cmp = icmp slt i64 %parami, 1                  ; <i1> [#uses=1]
  %varx.0 = select i1 %cmp, i64 1, i64 %parami    ; <i64> [#uses=1]
  %cmp410 = icmp slt i64 %paraml, 1               ; <i1> [#uses=1]
  br i1 %cmp410, label %for.end, label %bb.nph

bb.nph:                                           ; preds = %entry
  %tmp15 = mul i64 %paraml, %parami                   ; <i64> [#uses=1]
  ret i64 %tmp15

for.end:                                          ; preds = %entry
  ret i64 %varx.0
}

; We should tail merge small blocks that don't end in a tail call or return
; instruction. Those blocks are typically unreachable and will be placed
; out-of-line after the main return, so we should try to eliminate as many of
; them as possible.

declare void @abort()
define void @merge_aborts() {
; CHECK-LABEL: merge_aborts:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB10_5
; CHECK-NEXT:  # %bb.1: # %cont1
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB10_5
; CHECK-NEXT:  # %bb.2: # %cont2
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB10_5
; CHECK-NEXT:  # %bb.3: # %cont3
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB10_5
; CHECK-NEXT:  # %bb.4: # %cont4
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB10_5: # %abort1
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq abort
entry:
  %c1 = call i1 @qux()
  br i1 %c1, label %cont1, label %abort1
abort1:
  call void @abort()
  unreachable
cont1:
  %c2 = call i1 @qux()
  br i1 %c2, label %cont2, label %abort2
abort2:
  call void @abort()
  unreachable
cont2:
  %c3 = call i1 @qux()
  br i1 %c3, label %cont3, label %abort3
abort3:
  call void @abort()
  unreachable
cont3:
  %c4 = call i1 @qux()
  br i1 %c4, label %cont4, label %abort4
abort4:
  call void @abort()
  unreachable
cont4:
  ret void
}

; Use alternating abort functions so that the blocks we wish to merge are not
; layout successors during branch folding.

declare void @alt_abort()

define void @merge_alternating_aborts() {
; CHECK-LABEL: merge_alternating_aborts:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB11_5
; CHECK-NEXT:  # %bb.1: # %cont1
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB11_6
; CHECK-NEXT:  # %bb.2: # %cont2
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB11_5
; CHECK-NEXT:  # %bb.3: # %cont3
; CHECK-NEXT:    callq qux
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB11_6
; CHECK-NEXT:  # %bb.4: # %cont4
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB11_5: # %abort1
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq abort
; CHECK-NEXT:  .LBB11_6: # %abort2
; CHECK-NEXT:    callq alt_abort
entry:
  %c1 = call i1 @qux()
  br i1 %c1, label %cont1, label %abort1
abort1:
  call void @abort()
  unreachable
cont1:
  %c2 = call i1 @qux()
  br i1 %c2, label %cont2, label %abort2
abort2:
  call void @alt_abort()
  unreachable
cont2:
  %c3 = call i1 @qux()
  br i1 %c3, label %cont3, label %abort3
abort3:
  call void @abort()
  unreachable
cont3:
  %c4 = call i1 @qux()
  br i1 %c4, label %cont4, label %abort4
abort4:
  call void @alt_abort()
  unreachable
cont4:
  ret void
}
