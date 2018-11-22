; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s -check-prefixes=X32
; RUN: llc < %s -mtriple=x86_64-linux -mattr=+sse2 | FileCheck %s -check-prefixes=X64,X64-LIN
; RUN: llc < %s -mtriple=x86_64-win32 -mattr=+sse2 | FileCheck %s -check-prefixes=X64,X64-WIN

; Though it is undefined, we want xor undef,undef to produce zero.
define <4 x i32> @test1() nounwind {
; X32-LABEL: test1:
; X32:       # %bb.0:
; X32-NEXT:    xorps %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test1:
; X64:       # %bb.0:
; X64-NEXT:    xorps %xmm0, %xmm0
; X64-NEXT:    retq
  %tmp = xor <4 x i32> undef, undef
  ret <4 x i32> %tmp
}

; Though it is undefined, we want xor undef,undef to produce zero.
define i32 @test2() nounwind{
; X32-LABEL: test2:
; X32:       # %bb.0:
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test2:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
  %tmp = xor i32 undef, undef
  ret i32 %tmp
}

define i32 @test3(i32 %a, i32 %b) nounwind  {
; X32-LABEL: test3:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    notl %eax
; X32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl %eax
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test3:
; X64-LIN:       # %bb.0: # %entry
; X64-LIN-NEXT:    movl %esi, %eax
; X64-LIN-NEXT:    notl %eax
; X64-LIN-NEXT:    andl %edi, %eax
; X64-LIN-NEXT:    shrl %eax
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test3:
; X64-WIN:       # %bb.0: # %entry
; X64-WIN-NEXT:    movl %edx, %eax
; X64-WIN-NEXT:    notl %eax
; X64-WIN-NEXT:    andl %ecx, %eax
; X64-WIN-NEXT:    shrl %eax
; X64-WIN-NEXT:    retq
entry:
  %tmp1not = xor i32 %b, -2
  %tmp3 = and i32 %tmp1not, %a
  %tmp4 = lshr i32 %tmp3, 1
  ret i32 %tmp4
}

define i32 @test4(i32 %a, i32 %b) nounwind  {
; X32-LABEL: test4:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    .p2align 4, 0x90
; X32-NEXT:  .LBB3_1: # %bb
; X32-NEXT:    # =>This Inner Loop Header: Depth=1
; X32-NEXT:    xorl %ecx, %eax
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    notl %edx
; X32-NEXT:    andl %ecx, %edx
; X32-NEXT:    addl %edx, %edx
; X32-NEXT:    movl %edx, %ecx
; X32-NEXT:    jne .LBB3_1
; X32-NEXT:  # %bb.2: # %bb12
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test4:
; X64-LIN:       # %bb.0: # %entry
; X64-LIN-NEXT:    movl %edi, %eax
; X64-LIN-NEXT:    .p2align 4, 0x90
; X64-LIN-NEXT:  .LBB3_1: # %bb
; X64-LIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-LIN-NEXT:    xorl %esi, %eax
; X64-LIN-NEXT:    movl %eax, %ecx
; X64-LIN-NEXT:    notl %ecx
; X64-LIN-NEXT:    andl %esi, %ecx
; X64-LIN-NEXT:    addl %ecx, %ecx
; X64-LIN-NEXT:    movl %ecx, %esi
; X64-LIN-NEXT:    jne .LBB3_1
; X64-LIN-NEXT:  # %bb.2: # %bb12
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test4:
; X64-WIN:       # %bb.0: # %entry
; X64-WIN-NEXT:    movl %ecx, %eax
; X64-WIN-NEXT:    .p2align 4, 0x90
; X64-WIN-NEXT:  .LBB3_1: # %bb
; X64-WIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-WIN-NEXT:    xorl %edx, %eax
; X64-WIN-NEXT:    movl %eax, %ecx
; X64-WIN-NEXT:    notl %ecx
; X64-WIN-NEXT:    andl %edx, %ecx
; X64-WIN-NEXT:    addl %ecx, %ecx
; X64-WIN-NEXT:    movl %ecx, %edx
; X64-WIN-NEXT:    jne .LBB3_1
; X64-WIN-NEXT:  # %bb.2: # %bb12
; X64-WIN-NEXT:    retq
entry:
  br label %bb
bb:
  %b_addr.0 = phi i32 [ %b, %entry ], [ %tmp8, %bb ]
  %a_addr.0 = phi i32 [ %a, %entry ], [ %tmp3, %bb ]
  %tmp3 = xor i32 %a_addr.0, %b_addr.0
  %tmp4not = xor i32 %tmp3, 2147483647
  %tmp6 = and i32 %tmp4not, %b_addr.0
  %tmp8 = shl i32 %tmp6, 1
  %tmp10 = icmp eq i32 %tmp8, 0
  br i1 %tmp10, label %bb12, label %bb
bb12:
  ret i32 %tmp3
}

define i16 @test5(i16 %a, i16 %b) nounwind  {
; X32-LABEL: test5:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    .p2align 4, 0x90
; X32-NEXT:  .LBB4_1: # %bb
; X32-NEXT:    # =>This Inner Loop Header: Depth=1
; X32-NEXT:    xorl %ecx, %eax
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    notl %edx
; X32-NEXT:    andl %ecx, %edx
; X32-NEXT:    addl %edx, %edx
; X32-NEXT:    testw %dx, %dx
; X32-NEXT:    movl %edx, %ecx
; X32-NEXT:    jne .LBB4_1
; X32-NEXT:  # %bb.2: # %bb12
; X32-NEXT:    # kill: def $ax killed $ax killed $eax
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test5:
; X64-LIN:       # %bb.0: # %entry
; X64-LIN-NEXT:    movl %edi, %eax
; X64-LIN-NEXT:    .p2align 4, 0x90
; X64-LIN-NEXT:  .LBB4_1: # %bb
; X64-LIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-LIN-NEXT:    xorl %esi, %eax
; X64-LIN-NEXT:    movl %eax, %ecx
; X64-LIN-NEXT:    notl %ecx
; X64-LIN-NEXT:    andl %esi, %ecx
; X64-LIN-NEXT:    addl %ecx, %ecx
; X64-LIN-NEXT:    testw %cx, %cx
; X64-LIN-NEXT:    movl %ecx, %esi
; X64-LIN-NEXT:    jne .LBB4_1
; X64-LIN-NEXT:  # %bb.2: # %bb12
; X64-LIN-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test5:
; X64-WIN:       # %bb.0: # %entry
; X64-WIN-NEXT:    # kill: def $dx killed $dx def $edx
; X64-WIN-NEXT:    movl %ecx, %eax
; X64-WIN-NEXT:    .p2align 4, 0x90
; X64-WIN-NEXT:  .LBB4_1: # %bb
; X64-WIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-WIN-NEXT:    xorl %edx, %eax
; X64-WIN-NEXT:    movl %eax, %ecx
; X64-WIN-NEXT:    notl %ecx
; X64-WIN-NEXT:    andl %edx, %ecx
; X64-WIN-NEXT:    addl %ecx, %ecx
; X64-WIN-NEXT:    testw %cx, %cx
; X64-WIN-NEXT:    movl %ecx, %edx
; X64-WIN-NEXT:    jne .LBB4_1
; X64-WIN-NEXT:  # %bb.2: # %bb12
; X64-WIN-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-WIN-NEXT:    retq
entry:
  br label %bb
bb:
  %b_addr.0 = phi i16 [ %b, %entry ], [ %tmp8, %bb ]
  %a_addr.0 = phi i16 [ %a, %entry ], [ %tmp3, %bb ]
  %tmp3 = xor i16 %a_addr.0, %b_addr.0
  %tmp4not = xor i16 %tmp3, 32767
  %tmp6 = and i16 %tmp4not, %b_addr.0
  %tmp8 = shl i16 %tmp6, 1
  %tmp10 = icmp eq i16 %tmp8, 0
  br i1 %tmp10, label %bb12, label %bb
bb12:
  ret i16 %tmp3
}

define i8 @test6(i8 %a, i8 %b) nounwind  {
; X32-LABEL: test6:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    .p2align 4, 0x90
; X32-NEXT:  .LBB5_1: # %bb
; X32-NEXT:    # =>This Inner Loop Header: Depth=1
; X32-NEXT:    xorb %cl, %al
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    notb %dl
; X32-NEXT:    andb %cl, %dl
; X32-NEXT:    addb %dl, %dl
; X32-NEXT:    movl %edx, %ecx
; X32-NEXT:    jne .LBB5_1
; X32-NEXT:  # %bb.2: # %bb12
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test6:
; X64-LIN:       # %bb.0: # %entry
; X64-LIN-NEXT:    movl %edi, %eax
; X64-LIN-NEXT:    .p2align 4, 0x90
; X64-LIN-NEXT:  .LBB5_1: # %bb
; X64-LIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-LIN-NEXT:    xorb %sil, %al
; X64-LIN-NEXT:    movl %eax, %ecx
; X64-LIN-NEXT:    notb %cl
; X64-LIN-NEXT:    andb %sil, %cl
; X64-LIN-NEXT:    addb %cl, %cl
; X64-LIN-NEXT:    movl %ecx, %esi
; X64-LIN-NEXT:    jne .LBB5_1
; X64-LIN-NEXT:  # %bb.2: # %bb12
; X64-LIN-NEXT:    # kill: def $al killed $al killed $eax
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test6:
; X64-WIN:       # %bb.0: # %entry
; X64-WIN-NEXT:    movl %ecx, %eax
; X64-WIN-NEXT:    .p2align 4, 0x90
; X64-WIN-NEXT:  .LBB5_1: # %bb
; X64-WIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-WIN-NEXT:    xorb %dl, %al
; X64-WIN-NEXT:    movl %eax, %ecx
; X64-WIN-NEXT:    notb %cl
; X64-WIN-NEXT:    andb %dl, %cl
; X64-WIN-NEXT:    addb %cl, %cl
; X64-WIN-NEXT:    movl %ecx, %edx
; X64-WIN-NEXT:    jne .LBB5_1
; X64-WIN-NEXT:  # %bb.2: # %bb12
; X64-WIN-NEXT:    retq
entry:
  br label %bb
bb:
  %b_addr.0 = phi i8 [ %b, %entry ], [ %tmp8, %bb ]
  %a_addr.0 = phi i8 [ %a, %entry ], [ %tmp3, %bb ]
  %tmp3 = xor i8 %a_addr.0, %b_addr.0
  %tmp4not = xor i8 %tmp3, 127
  %tmp6 = and i8 %tmp4not, %b_addr.0
  %tmp8 = shl i8 %tmp6, 1
  %tmp10 = icmp eq i8 %tmp8, 0
  br i1 %tmp10, label %bb12, label %bb
bb12:
  ret i8 %tmp3
}

define i32 @test7(i32 %a, i32 %b) nounwind  {
; X32-LABEL: test7:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    .p2align 4, 0x90
; X32-NEXT:  .LBB6_1: # %bb
; X32-NEXT:    # =>This Inner Loop Header: Depth=1
; X32-NEXT:    xorl %ecx, %eax
; X32-NEXT:    movl %eax, %edx
; X32-NEXT:    xorl $2147483646, %edx # imm = 0x7FFFFFFE
; X32-NEXT:    andl %ecx, %edx
; X32-NEXT:    addl %edx, %edx
; X32-NEXT:    movl %edx, %ecx
; X32-NEXT:    jne .LBB6_1
; X32-NEXT:  # %bb.2: # %bb12
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test7:
; X64-LIN:       # %bb.0: # %entry
; X64-LIN-NEXT:    movl %edi, %eax
; X64-LIN-NEXT:    .p2align 4, 0x90
; X64-LIN-NEXT:  .LBB6_1: # %bb
; X64-LIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-LIN-NEXT:    xorl %esi, %eax
; X64-LIN-NEXT:    movl %eax, %ecx
; X64-LIN-NEXT:    xorl $2147483646, %ecx # imm = 0x7FFFFFFE
; X64-LIN-NEXT:    andl %esi, %ecx
; X64-LIN-NEXT:    addl %ecx, %ecx
; X64-LIN-NEXT:    movl %ecx, %esi
; X64-LIN-NEXT:    jne .LBB6_1
; X64-LIN-NEXT:  # %bb.2: # %bb12
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test7:
; X64-WIN:       # %bb.0: # %entry
; X64-WIN-NEXT:    movl %ecx, %eax
; X64-WIN-NEXT:    .p2align 4, 0x90
; X64-WIN-NEXT:  .LBB6_1: # %bb
; X64-WIN-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-WIN-NEXT:    xorl %edx, %eax
; X64-WIN-NEXT:    movl %eax, %ecx
; X64-WIN-NEXT:    xorl $2147483646, %ecx # imm = 0x7FFFFFFE
; X64-WIN-NEXT:    andl %edx, %ecx
; X64-WIN-NEXT:    addl %ecx, %ecx
; X64-WIN-NEXT:    movl %ecx, %edx
; X64-WIN-NEXT:    jne .LBB6_1
; X64-WIN-NEXT:  # %bb.2: # %bb12
; X64-WIN-NEXT:    retq
entry:
  br label %bb
bb:
  %b_addr.0 = phi i32 [ %b, %entry ], [ %tmp8, %bb ]
  %a_addr.0 = phi i32 [ %a, %entry ], [ %tmp3, %bb ]
  %tmp3 = xor i32 %a_addr.0, %b_addr.0
  %tmp4not = xor i32 %tmp3, 2147483646
  %tmp6 = and i32 %tmp4not, %b_addr.0
  %tmp8 = shl i32 %tmp6, 1
  %tmp10 = icmp eq i32 %tmp8, 0
  br i1 %tmp10, label %bb12, label %bb
bb12:
  ret i32 %tmp3
}

; rdar://7553032
define i32 @test8(i32 %a) nounwind {
; X32-LABEL: test8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    notl %eax
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test8:
; X64-LIN:       # %bb.0: # %entry
; X64-LIN-NEXT:    movl %edi, %eax
; X64-LIN-NEXT:    notl %eax
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test8:
; X64-WIN:       # %bb.0: # %entry
; X64-WIN-NEXT:    movl %ecx, %eax
; X64-WIN-NEXT:    notl %eax
; X64-WIN-NEXT:    retq
entry:
  %t1 = sub i32 0, %a
  %t2 = add i32 %t1, -1
  ret i32 %t2
}

define i32 @test9(i32 %a) nounwind {
; X32-LABEL: test9:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    notl %eax
; X32-NEXT:    andl $4096, %eax # imm = 0x1000
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test9:
; X64-LIN:       # %bb.0:
; X64-LIN-NEXT:    movl %edi, %eax
; X64-LIN-NEXT:    notl %eax
; X64-LIN-NEXT:    andl $4096, %eax # imm = 0x1000
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test9:
; X64-WIN:       # %bb.0:
; X64-WIN-NEXT:    movl %ecx, %eax
; X64-WIN-NEXT:    notl %eax
; X64-WIN-NEXT:    andl $4096, %eax # imm = 0x1000
; X64-WIN-NEXT:    retq
  %1 = and i32 %a, 4096
  %2 = xor i32 %1, 4096
  ret i32 %2
}

; PR15948
define <4 x i32> @test10(<4 x i32> %a) nounwind {
; X32-LABEL: test10:
; X32:       # %bb.0:
; X32-NEXT:    andnps {{\.LCPI.*}}, %xmm0
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test10:
; X64-LIN:       # %bb.0:
; X64-LIN-NEXT:    andnps {{.*}}(%rip), %xmm0
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test10:
; X64-WIN:       # %bb.0:
; X64-WIN-NEXT:    movaps (%rcx), %xmm0
; X64-WIN-NEXT:    andnps __xmm@{{.*}}(%rip), %xmm0
; X64-WIN-NEXT:    retq
  %1 = and <4 x i32> %a, <i32 4096, i32 4096, i32 4096, i32 4096>
  %2 = xor <4 x i32> %1, <i32 4096, i32 4096, i32 4096, i32 4096>
  ret <4 x i32> %2
}

define i32 @PR17487(i1 %tobool) {
; X32-LABEL: PR17487:
; X32:       # %bb.0:
; X32-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; X32-NEXT:    pandn {{\.LCPI.*}}, %xmm0
; X32-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[3,1,2,3]
; X32-NEXT:    movd %xmm1, %ecx
; X32-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X32-NEXT:    movd %xmm0, %edx
; X32-NEXT:    xorl $1, %edx
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    orl %ecx, %edx
; X32-NEXT:    setne %al
; X32-NEXT:    retl
;
; X64-LIN-LABEL: PR17487:
; X64-LIN:       # %bb.0:
; X64-LIN-NEXT:    movd %edi, %xmm0
; X64-LIN-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; X64-LIN-NEXT:    pandn {{.*}}(%rip), %xmm0
; X64-LIN-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-LIN-NEXT:    movq %xmm0, %rcx
; X64-LIN-NEXT:    xorl %eax, %eax
; X64-LIN-NEXT:    cmpq $1, %rcx
; X64-LIN-NEXT:    setne %al
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: PR17487:
; X64-WIN:       # %bb.0:
; X64-WIN-NEXT:    movzbl %cl, %eax
; X64-WIN-NEXT:    movd %eax, %xmm0
; X64-WIN-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; X64-WIN-NEXT:    pandn __xmm@{{.*}}(%rip), %xmm0
; X64-WIN-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; X64-WIN-NEXT:    movq %xmm0, %rcx
; X64-WIN-NEXT:    xorl %eax, %eax
; X64-WIN-NEXT:    cmpq $1, %rcx
; X64-WIN-NEXT:    setne %al
; X64-WIN-NEXT:    retq
  %tmp = insertelement <2 x i1> undef, i1 %tobool, i32 1
  %tmp1 = zext <2 x i1> %tmp to <2 x i64>
  %tmp2 = xor <2 x i64> %tmp1, <i64 1, i64 1>
  %tmp3 = extractelement <2 x i64> %tmp2, i32 1
  %add = add nsw i64 0, %tmp3
  %cmp6 = icmp ne i64 %add, 1
  %conv7 = zext i1 %cmp6 to i32
  ret i32 %conv7
}

define i32 @test11(i32 %b) {
; X32-LABEL: test11:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    movl $-2, %eax
; X32-NEXT:    roll %cl, %eax
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test11:
; X64-LIN:       # %bb.0:
; X64-LIN-NEXT:    movl %edi, %ecx
; X64-LIN-NEXT:    movl $-2, %eax
; X64-LIN-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-LIN-NEXT:    roll %cl, %eax
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test11:
; X64-WIN:       # %bb.0:
; X64-WIN-NEXT:    movl $-2, %eax
; X64-WIN-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-WIN-NEXT:    roll %cl, %eax
; X64-WIN-NEXT:    retq
  %shl = shl i32 1, %b
  %neg = xor i32 %shl, -1
  ret i32 %neg
}

%struct.ref_s = type { %union.v, i16, i16 }
%union.v = type { i64 }

define %struct.ref_s* @test12(%struct.ref_s* %op, i64 %osbot, i64 %intval) {
; X32-LABEL: test12:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    notl %eax
; X32-NEXT:    leal (%eax,%eax,2), %eax
; X32-NEXT:    shll $2, %eax
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    retl
;
; X64-LIN-LABEL: test12:
; X64-LIN:       # %bb.0:
; X64-LIN-NEXT:    notl %edx
; X64-LIN-NEXT:    movslq %edx, %rax
; X64-LIN-NEXT:    shlq $4, %rax
; X64-LIN-NEXT:    addq %rdi, %rax
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: test12:
; X64-WIN:       # %bb.0:
; X64-WIN-NEXT:    notl %r8d
; X64-WIN-NEXT:    movslq %r8d, %rax
; X64-WIN-NEXT:    shlq $4, %rax
; X64-WIN-NEXT:    addq %rcx, %rax
; X64-WIN-NEXT:    retq
  %neg = shl i64 %intval, 32
  %sext = xor i64 %neg, -4294967296
  %idx.ext = ashr exact i64 %sext, 32
  %add.ptr = getelementptr inbounds %struct.ref_s, %struct.ref_s* %op, i64 %idx.ext
  ret %struct.ref_s* %add.ptr
}

define i32 @PR39657(i8* %p, i64 %x) {
; X32-LABEL: PR39657:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    notl %ecx
; X32-NEXT:    movl (%eax,%ecx,4), %eax
; X32-NEXT:    retl
;
; X64-LIN-LABEL: PR39657:
; X64-LIN:       # %bb.0:
; X64-LIN-NEXT:    notq %rsi
; X64-LIN-NEXT:    movl (%rdi,%rsi,4), %eax
; X64-LIN-NEXT:    retq
;
; X64-WIN-LABEL: PR39657:
; X64-WIN:       # %bb.0:
; X64-WIN-NEXT:    notq %rdx
; X64-WIN-NEXT:    movl (%rcx,%rdx,4), %eax
; X64-WIN-NEXT:    retq
  %sh = shl i64 %x, 2
  %mul = xor i64 %sh, -4
  %add.ptr = getelementptr inbounds i8, i8* %p, i64 %mul
  %bc = bitcast i8* %add.ptr to i32*
  %load = load i32, i32* %bc, align 4
  ret i32 %load
}

