; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64

@s_0 = external dso_local local_unnamed_addr global i16, align 2
@s_2 = external dso_local local_unnamed_addr global i16, align 2

define void @func_6(i8 %uc_8, i64 %uli_10) nounwind {
; X86-LABEL: func_6:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl $-1, %ecx
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    xorl %ebx, %ebx
; X86-NEXT:    # implicit-def: $si
; X86-NEXT:    .p2align 4, 0x90
; X86-NEXT:  .LBB0_1: # %for.body612
; X86-NEXT:    # =>This Inner Loop Header: Depth=1
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    je .LBB0_2
; X86-NEXT:  # %bb.3: # %if.end1401
; X86-NEXT:    # in Loop: Header=BB0_1 Depth=1
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    addl %eax, %esi
; X86-NEXT:    movw %si, s_2
; X86-NEXT:    movw %bx, s_0
; X86-NEXT:    incl %ecx
; X86-NEXT:    incl %ebx
; X86-NEXT:    cmpw $73, %cx
; X86-NEXT:    jl .LBB0_1
; X86-NEXT:  # %bb.4: # %for.body1703
; X86-NEXT:  .LBB0_2: # %if.then671
;
; X64-LABEL: func_6:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl $23090, %eax # imm = 0x5A32
; X64-NEXT:    xorl %ecx, %ecx
; X64-NEXT:    # implicit-def: $dx
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB0_1: # %for.body612
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    testb %cl, %cl
; X64-NEXT:    je .LBB0_2
; X64-NEXT:  # %bb.3: # %if.end1401
; X64-NEXT:    # in Loop: Header=BB0_1 Depth=1
; X64-NEXT:    testb %cl, %cl
; X64-NEXT:    addl %esi, %edx
; X64-NEXT:    movw %dx, s_2(%rip)
; X64-NEXT:    leal -23090(%rax), %edi
; X64-NEXT:    movw %di, s_0(%rip)
; X64-NEXT:    incq %rax
; X64-NEXT:    leal -23091(%rax), %edi
; X64-NEXT:    cmpw $73, %di
; X64-NEXT:    jl .LBB0_1
; X64-NEXT:  # %bb.4: # %for.body1703
; X64-NEXT:  .LBB0_2: # %if.then671
entry:
  %conv649 = zext i8 %uc_8 to i64
  %xor650 = xor i64 %conv649, 296357731680175678
  %i = trunc i64 %uli_10 to i16
  br label %for.body612

for.body612:                                      ; preds = %for.inc1677, %entry
  %i1 = phi i16 [ undef, %entry ], [ %conv1532, %for.inc1677 ]
  %i2 = phi i16 [ -1, %entry ], [ %add1679, %for.inc1677 ]
  br label %if.then635

if.then635:                                       ; preds = %for.body612
  %conv653 = sext i16 %i2 to i64
  %cmp654.not = icmp eq i64 %xor650, %conv653
  %conv653.op = xor i64 %conv653, 296357731680175678
  %tobool670.not = icmp eq i64 undef, 0
  br i1 %tobool670.not, label %if.end1401, label %if.then671

if.then671:                                       ; preds = %if.then635
  %cmp830 = icmp sgt i16 %i1, 21
  unreachable

if.end1401:                                       ; preds = %if.then635
  %conv1421 = sext i16 %i2 to i32
  %or1422 = or i32 %conv1421, undef
  br label %if.end1510

if.end1510:                                       ; preds = %if.end1401
  br i1 undef, label %cond.false1514, label %cond.end1528

cond.false1514:                                   ; preds = %if.end1510
  %conv1525 = sext i16 %i2 to i64
  %add1526 = add nsw i64 %conv1525, 23091
  br label %cond.end1528

cond.end1528:                                     ; preds = %cond.false1514, %if.end1510
  %cond1529 = phi i64 [ %add1526, %cond.false1514 ], [ undef, %if.end1510 ]
  %conv1532 = add i16 %i1, %i
  store i16 %conv1532, ptr @s_2, align 2
  br label %for.inc1677

for.inc1677:                                      ; preds = %cond.end1528
  %add1679 = add i16 %i2, 1
  store i16 %add1679, ptr @s_0, align 2
  %cmp610 = icmp slt i16 %add1679, 73
  br i1 %cmp610, label %for.body612, label %for.body1703

for.body1703:                                     ; preds = %for.inc1677
  unreachable
}
