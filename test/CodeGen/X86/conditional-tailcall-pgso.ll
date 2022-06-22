; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-linux   -show-mc-encoding | FileCheck %s --check-prefix=CHECK32
; RUN: llc < %s -mtriple=x86_64-linux -show-mc-encoding | FileCheck %s --check-prefix=CHECK64
; RUN: llc < %s -mtriple=x86_64-win32 -show-mc-encoding | FileCheck %s --check-prefix=WIN64

declare void @foo()
declare void @bar()

define void @f(i32 %x, i32 %y) !prof !14 {
; CHECK32-LABEL: f:
; CHECK32:       # %bb.0: # %entry
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; CHECK32-NEXT:    cmpl {{[0-9]+}}(%esp), %eax # encoding: [0x3b,0x44,0x24,0x08]
; CHECK32-NEXT:    jne bar@PLT # TAILCALL
; CHECK32-NEXT:    # encoding: [0x75,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: bar@PLT-1, kind: FK_PCRel_1
; CHECK32-NEXT:  # %bb.1: # %bb1
; CHECK32-NEXT:    jmp foo@PLT # TAILCALL
; CHECK32-NEXT:    # encoding: [0xeb,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: foo@PLT-1, kind: FK_PCRel_1
;
; CHECK64-LABEL: f:
; CHECK64:       # %bb.0: # %entry
; CHECK64-NEXT:    cmpl %esi, %edi # encoding: [0x39,0xf7]
; CHECK64-NEXT:    jne bar@PLT # TAILCALL
; CHECK64-NEXT:    # encoding: [0x75,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: bar@PLT-1, kind: FK_PCRel_1
; CHECK64-NEXT:  # %bb.1: # %bb1
; CHECK64-NEXT:    jmp foo@PLT # TAILCALL
; CHECK64-NEXT:    # encoding: [0xeb,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: foo@PLT-1, kind: FK_PCRel_1
;
; WIN64-LABEL: f:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    cmpl %edx, %ecx # encoding: [0x39,0xd1]
; WIN64-NEXT:    jne bar # TAILCALL
; WIN64-NEXT:    # encoding: [0x75,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: bar-1, kind: FK_PCRel_1
; WIN64-NEXT:  # %bb.1: # %bb1
; WIN64-NEXT:    jmp foo # TAILCALL
; WIN64-NEXT:    # encoding: [0xeb,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: foo-1, kind: FK_PCRel_1
entry:
	%p = icmp eq i32 %x, %y
  br i1 %p, label %bb1, label %bb2
bb1:
  tail call void @foo()
  ret void
bb2:
  tail call void @bar()
  ret void

; Check that the asm doesn't just look good, but uses the correct encoding.
}

define void @f_non_leaf(i32 %x, i32 %y) !prof !14 {
; CHECK32-LABEL: f_non_leaf:
; CHECK32:       # %bb.0: # %entry
; CHECK32-NEXT:    pushl %ebx # encoding: [0x53]
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    .cfi_offset %ebx, -8
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; CHECK32-NEXT:    #APP
; CHECK32-NEXT:    #NO_APP
; CHECK32-NEXT:    cmpl {{[0-9]+}}(%esp), %eax # encoding: [0x3b,0x44,0x24,0x0c]
; CHECK32-NEXT:    jne .LBB1_2 # encoding: [0x75,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: .LBB1_2-1, kind: FK_PCRel_1
; CHECK32-NEXT:  # %bb.1: # %bb1
; CHECK32-NEXT:    popl %ebx # encoding: [0x5b]
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    jmp foo@PLT # TAILCALL
; CHECK32-NEXT:    # encoding: [0xeb,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: foo@PLT-1, kind: FK_PCRel_1
; CHECK32-NEXT:  .LBB1_2: # %bb2
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %ebx # encoding: [0x5b]
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    jmp bar@PLT # TAILCALL
; CHECK32-NEXT:    # encoding: [0xeb,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: bar@PLT-1, kind: FK_PCRel_1
;
; CHECK64-LABEL: f_non_leaf:
; CHECK64:       # %bb.0: # %entry
; CHECK64-NEXT:    pushq %rbx # encoding: [0x53]
; CHECK64-NEXT:    .cfi_def_cfa_offset 16
; CHECK64-NEXT:    .cfi_offset %rbx, -16
; CHECK64-NEXT:    #APP
; CHECK64-NEXT:    #NO_APP
; CHECK64-NEXT:    cmpl %esi, %edi # encoding: [0x39,0xf7]
; CHECK64-NEXT:    jne .LBB1_2 # encoding: [0x75,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: .LBB1_2-1, kind: FK_PCRel_1
; CHECK64-NEXT:  # %bb.1: # %bb1
; CHECK64-NEXT:    popq %rbx # encoding: [0x5b]
; CHECK64-NEXT:    .cfi_def_cfa_offset 8
; CHECK64-NEXT:    jmp foo@PLT # TAILCALL
; CHECK64-NEXT:    # encoding: [0xeb,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: foo@PLT-1, kind: FK_PCRel_1
; CHECK64-NEXT:  .LBB1_2: # %bb2
; CHECK64-NEXT:    .cfi_def_cfa_offset 16
; CHECK64-NEXT:    popq %rbx # encoding: [0x5b]
; CHECK64-NEXT:    .cfi_def_cfa_offset 8
; CHECK64-NEXT:    jmp bar@PLT # TAILCALL
; CHECK64-NEXT:    # encoding: [0xeb,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: bar@PLT-1, kind: FK_PCRel_1
;
; WIN64-LABEL: f_non_leaf:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rbx # encoding: [0x53]
; WIN64-NEXT:    .seh_pushreg %rbx
; WIN64-NEXT:    .seh_endprologue
; WIN64-NEXT:    #APP
; WIN64-NEXT:    #NO_APP
; WIN64-NEXT:    cmpl %edx, %ecx # encoding: [0x39,0xd1]
; WIN64-NEXT:    jne .LBB1_2 # encoding: [0x75,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: .LBB1_2-1, kind: FK_PCRel_1
; WIN64-NEXT:  # %bb.1: # %bb1
; WIN64-NEXT:    popq %rbx # encoding: [0x5b]
; WIN64-NEXT:    jmp foo # TAILCALL
; WIN64-NEXT:    # encoding: [0xeb,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: foo-1, kind: FK_PCRel_1
; WIN64-NEXT:  .LBB1_2: # %bb2
; WIN64-NEXT:    nop # encoding: [0x90]
; WIN64-NEXT:    popq %rbx # encoding: [0x5b]
; WIN64-NEXT:    jmp bar # TAILCALL
; WIN64-NEXT:    # encoding: [0xeb,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: bar-1, kind: FK_PCRel_1
; WIN64-NEXT:    .seh_endproc
entry:
  ; Force %ebx to be spilled on the stack, turning this into
  ; not a "leaf" function for Win64.
  tail call void asm sideeffect "", "~{ebx}"()

	%p = icmp eq i32 %x, %y
  br i1 %p, label %bb1, label %bb2
bb1:
  tail call void @foo()
  ret void
bb2:
  tail call void @bar()
  ret void

}

declare x86_thiscallcc zeroext i1 @baz(ptr, i32)
define x86_thiscallcc zeroext i1 @BlockPlacementTest(ptr %this, i32 %x) !prof !14 {
; CHECK32-LABEL: BlockPlacementTest:
; CHECK32:       # %bb.0: # %entry
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx # encoding: [0x8b,0x54,0x24,0x04]
; CHECK32-NEXT:    testb $42, %dl # encoding: [0xf6,0xc2,0x2a]
; CHECK32-NEXT:    je .LBB2_3 # encoding: [0x74,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: .LBB2_3-1, kind: FK_PCRel_1
; CHECK32-NEXT:  # %bb.1: # %land.rhs
; CHECK32-NEXT:    movb $1, %al # encoding: [0xb0,0x01]
; CHECK32-NEXT:    testb $44, %dl # encoding: [0xf6,0xc2,0x2c]
; CHECK32-NEXT:    je baz@PLT # TAILCALL
; CHECK32-NEXT:    # encoding: [0x74,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: baz@PLT-1, kind: FK_PCRel_1
; CHECK32-NEXT:  .LBB2_2: # %land.end
; CHECK32-NEXT:    # kill: def $al killed $al killed $eax
; CHECK32-NEXT:    retl $4 # encoding: [0xc2,0x04,0x00]
; CHECK32-NEXT:  .LBB2_3:
; CHECK32-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK32-NEXT:    jmp .LBB2_2 # encoding: [0xeb,A]
; CHECK32-NEXT:    # fixup A - offset: 1, value: .LBB2_2-1, kind: FK_PCRel_1
;
; CHECK64-LABEL: BlockPlacementTest:
; CHECK64:       # %bb.0: # %entry
; CHECK64-NEXT:    testb $42, %sil # encoding: [0x40,0xf6,0xc6,0x2a]
; CHECK64-NEXT:    je .LBB2_3 # encoding: [0x74,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: .LBB2_3-1, kind: FK_PCRel_1
; CHECK64-NEXT:  # %bb.1: # %land.rhs
; CHECK64-NEXT:    movb $1, %al # encoding: [0xb0,0x01]
; CHECK64-NEXT:    testb $44, %sil # encoding: [0x40,0xf6,0xc6,0x2c]
; CHECK64-NEXT:    je baz@PLT # TAILCALL
; CHECK64-NEXT:    # encoding: [0x74,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: baz@PLT-1, kind: FK_PCRel_1
; CHECK64-NEXT:  .LBB2_2: # %land.end
; CHECK64-NEXT:    # kill: def $al killed $al killed $eax
; CHECK64-NEXT:    retq # encoding: [0xc3]
; CHECK64-NEXT:  .LBB2_3:
; CHECK64-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; CHECK64-NEXT:    jmp .LBB2_2 # encoding: [0xeb,A]
; CHECK64-NEXT:    # fixup A - offset: 1, value: .LBB2_2-1, kind: FK_PCRel_1
;
; WIN64-LABEL: BlockPlacementTest:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    testb $42, %dl # encoding: [0xf6,0xc2,0x2a]
; WIN64-NEXT:    je .LBB2_3 # encoding: [0x74,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: .LBB2_3-1, kind: FK_PCRel_1
; WIN64-NEXT:  # %bb.1: # %land.rhs
; WIN64-NEXT:    movb $1, %al # encoding: [0xb0,0x01]
; WIN64-NEXT:    testb $44, %dl # encoding: [0xf6,0xc2,0x2c]
; WIN64-NEXT:    je baz # TAILCALL
; WIN64-NEXT:    # encoding: [0x74,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: baz-1, kind: FK_PCRel_1
; WIN64-NEXT:  .LBB2_2: # %land.end
; WIN64-NEXT:    # kill: def $al killed $al killed $eax
; WIN64-NEXT:    retq # encoding: [0xc3]
; WIN64-NEXT:  .LBB2_3:
; WIN64-NEXT:    xorl %eax, %eax # encoding: [0x31,0xc0]
; WIN64-NEXT:    jmp .LBB2_2 # encoding: [0xeb,A]
; WIN64-NEXT:    # fixup A - offset: 1, value: .LBB2_2-1, kind: FK_PCRel_1
entry:
  %and = and i32 %x, 42
  %tobool = icmp eq i32 %and, 0
  br i1 %tobool, label %land.end, label %land.rhs

land.rhs:
  %and6 = and i32 %x, 44
  %tobool7 = icmp eq i32 %and6, 0
  br i1 %tobool7, label %lor.rhs, label %land.end

lor.rhs:
  %call = tail call x86_thiscallcc zeroext i1 @baz(ptr %this, i32 %x) #2
  br label %land.end

land.end:
  %0 = phi i1 [ false, %entry ], [ true, %land.rhs ], [ %call, %lor.rhs ]
  ret i1 %0

; Make sure machine block placement isn't confused by the conditional tail call,
; but sees that it can fall through to the next block.
}

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"ProfileSummary", !1}
!1 = !{!2, !3, !4, !5, !6, !7, !8, !9}
!2 = !{!"ProfileFormat", !"InstrProf"}
!3 = !{!"TotalCount", i64 10000}
!4 = !{!"MaxCount", i64 10}
!5 = !{!"MaxInternalCount", i64 1}
!6 = !{!"MaxFunctionCount", i64 1000}
!7 = !{!"NumCounts", i64 3}
!8 = !{!"NumFunctions", i64 3}
!9 = !{!"DetailedSummary", !10}
!10 = !{!11, !12, !13}
!11 = !{i32 10000, i64 100, i32 1}
!12 = !{i32 999000, i64 100, i32 1}
!13 = !{i32 999999, i64 1, i32 2}
!14 = !{!"function_entry_count", i64 0}
