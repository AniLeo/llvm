; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s --check-prefix=X64

@a = common dso_local global i32 0, align 4
@b = common dso_local global i32 0, align 4
@c = common dso_local global i32 0, align 4
@e = common dso_local global i32 0, align 4
@x = common dso_local global i32 0, align 4
@f = common dso_local global i32 0, align 4
@h = common dso_local global i32 0, align 4
@i = common dso_local global i32 0, align 4

; Test -Os to make sure immediates with multiple users don't get pulled in to
; instructions (8-bit immediates are exceptions).

define dso_local i32 @foo() optsize {
; X86-LABEL: foo:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $1234, %eax # imm = 0x4D2
; X86-NEXT:    movl %eax, a
; X86-NEXT:    movl %eax, b
; X86-NEXT:    movl $12, c
; X86-NEXT:    cmpl $12, e
; X86-NEXT:    jne .LBB0_2
; X86-NEXT:  # %bb.1: # %if.then
; X86-NEXT:    movl $1, x
; X86-NEXT:  .LBB0_2: # %if.end
; X86-NEXT:    movl $1234, f # imm = 0x4D2
; X86-NEXT:    movl $555, %eax # imm = 0x22B
; X86-NEXT:    movl %eax, h
; X86-NEXT:    addl %eax, i
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: foo:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl $1234, %eax # imm = 0x4D2
; X64-NEXT:    movl %eax, a(%rip)
; X64-NEXT:    movl %eax, b(%rip)
; X64-NEXT:    movl $12, c(%rip)
; X64-NEXT:    cmpl $12, e(%rip)
; X64-NEXT:    jne .LBB0_2
; X64-NEXT:  # %bb.1: # %if.then
; X64-NEXT:    movl $1, x(%rip)
; X64-NEXT:  .LBB0_2: # %if.end
; X64-NEXT:    movl $1234, f(%rip) # imm = 0x4D2
; X64-NEXT:    movl $555, %eax # imm = 0x22B
; X64-NEXT:    movl %eax, h(%rip)
; X64-NEXT:    addl %eax, i(%rip)
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
entry:
  store i32 1234, ptr @a
  store i32 1234, ptr @b
  store i32 12, ptr @c
  %0 = load i32, ptr @e
  %cmp = icmp eq i32 %0, 12
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, ptr @x
  br label %if.end

; New block.. Make sure 1234 isn't live across basic blocks from before.
if.end:                                           ; preds = %if.then, %entry
  store i32 1234, ptr @f
  store i32 555, ptr @h
  %1 = load i32, ptr @i
  %add1 = add nsw i32 %1, 555
  store i32 %add1, ptr @i
  ret i32 0
}

; Test PGSO to make sure immediates with multiple users don't get pulled in to
; instructions (8-bit immediates are exceptions).

define dso_local i32 @foo_pgso() !prof !14 {
; X86-LABEL: foo_pgso:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $1234, %eax # imm = 0x4D2
; X86-NEXT:    movl %eax, a
; X86-NEXT:    movl %eax, b
; X86-NEXT:    movl $12, c
; X86-NEXT:    cmpl $12, e
; X86-NEXT:    jne .LBB1_2
; X86-NEXT:  # %bb.1: # %if.then
; X86-NEXT:    movl $1, x
; X86-NEXT:  .LBB1_2: # %if.end
; X86-NEXT:    movl $1234, f # imm = 0x4D2
; X86-NEXT:    movl $555, %eax # imm = 0x22B
; X86-NEXT:    movl %eax, h
; X86-NEXT:    addl %eax, i
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: foo_pgso:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl $1234, %eax # imm = 0x4D2
; X64-NEXT:    movl %eax, a(%rip)
; X64-NEXT:    movl %eax, b(%rip)
; X64-NEXT:    movl $12, c(%rip)
; X64-NEXT:    cmpl $12, e(%rip)
; X64-NEXT:    jne .LBB1_2
; X64-NEXT:  # %bb.1: # %if.then
; X64-NEXT:    movl $1, x(%rip)
; X64-NEXT:  .LBB1_2: # %if.end
; X64-NEXT:    movl $1234, f(%rip) # imm = 0x4D2
; X64-NEXT:    movl $555, %eax # imm = 0x22B
; X64-NEXT:    movl %eax, h(%rip)
; X64-NEXT:    addl %eax, i(%rip)
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
entry:
  store i32 1234, ptr @a
  store i32 1234, ptr @b
  store i32 12, ptr @c
  %0 = load i32, ptr @e
  %cmp = icmp eq i32 %0, 12
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, ptr @x
  br label %if.end

; New block.. Make sure 1234 isn't live across basic blocks from before.
if.end:                                           ; preds = %if.then, %entry
  store i32 1234, ptr @f
  store i32 555, ptr @h
  %1 = load i32, ptr @i
  %add1 = add nsw i32 %1, 555
  store i32 %add1, ptr @i
  ret i32 0
}

; Test -O2 to make sure that all immediates get pulled in to their users.
define dso_local i32 @foo2() {
; X86-LABEL: foo2:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $1234, a # imm = 0x4D2
; X86-NEXT:    movl $1234, b # imm = 0x4D2
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: foo2:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl $1234, a(%rip) # imm = 0x4D2
; X64-NEXT:    movl $1234, b(%rip) # imm = 0x4D2
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
entry:
  store i32 1234, ptr @a
  store i32 1234, ptr @b
  ret i32 0
}

declare void @llvm.memset.p0.i32(ptr nocapture, i8, i32, i1) #1

@AA = common dso_local global [100 x i8] zeroinitializer, align 1

; memset gets lowered in DAG. Constant merging should hoist all the
; immediates used to store to the individual memory locations. Make
; sure we don't directly store the immediates.
define dso_local void @foomemset() optsize {
; X86-LABEL: foomemset:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $555819297, %eax # imm = 0x21212121
; X86-NEXT:    movl %eax, AA+20
; X86-NEXT:    movl %eax, AA+16
; X86-NEXT:    movl %eax, AA+12
; X86-NEXT:    movl %eax, AA+8
; X86-NEXT:    movl %eax, AA+4
; X86-NEXT:    movl %eax, AA
; X86-NEXT:    retl
;
; X64-LABEL: foomemset:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movabsq $2387225703656530209, %rax # imm = 0x2121212121212121
; X64-NEXT:    movq %rax, AA+16(%rip)
; X64-NEXT:    movq %rax, AA+8(%rip)
; X64-NEXT:    movq %rax, AA(%rip)
; X64-NEXT:    retq
entry:
  call void @llvm.memset.p0.i32(ptr @AA, i8 33, i32 24, i1 false)
  ret void
}

; memset gets lowered in DAG. Constant merging should hoist all the
; immediates used to store to the individual memory locations. Make
; sure we don't directly store the immediates.
define dso_local void @foomemset_pgso() !prof !14 {
; X86-LABEL: foomemset_pgso:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $555819297, %eax # imm = 0x21212121
; X86-NEXT:    movl %eax, AA+20
; X86-NEXT:    movl %eax, AA+16
; X86-NEXT:    movl %eax, AA+12
; X86-NEXT:    movl %eax, AA+8
; X86-NEXT:    movl %eax, AA+4
; X86-NEXT:    movl %eax, AA
; X86-NEXT:    retl
;
; X64-LABEL: foomemset_pgso:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movabsq $2387225703656530209, %rax # imm = 0x2121212121212121
; X64-NEXT:    movq %rax, AA+16(%rip)
; X64-NEXT:    movq %rax, AA+8(%rip)
; X64-NEXT:    movq %rax, AA(%rip)
; X64-NEXT:    retq
entry:
  call void @llvm.memset.p0.i32(ptr @AA, i8 33, i32 24, i1 false)
  ret void
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
