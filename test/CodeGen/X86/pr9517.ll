; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -o - %s -mtriple=x86_64--unknown-linux-gnu | FileCheck %s

@base = external dso_local local_unnamed_addr global i16, align 2

; We should be able to merge the two loads here
define i16 @unify_through_trivial_asm() {
; CHECK-LABEL: unify_through_trivial_asm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl {{.*}}(%rip), %eax
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %eax
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
  %x = load i16, i16* @base, align 2
  tail call void asm sideeffect "nop", "r,~{dirflag},~{fpsr},~{flags}"(i16 %x)
  %x2 = load i16, i16* @base, align 2
  %v = add i16 %x2, 1
  ret i16 %v
}

; The asm call prevents the merging the loads here. 
define i16 @unify_through_trival_asm_w_memory_clobber() {
; CHECK-LABEL: unify_through_trival_asm_w_memory_clobber:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl {{.*}}(%rip), %eax
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %eax
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
  %x = load i16, i16* @base, align 2
  tail call void asm sideeffect "nop", "+r,~{dirflag},~{fpsr},~{flags},~{base},~{memory}"(i16 %x)
  %x2 = load i16, i16* @base, align 2
  %v = add i16 %x2, 1
  ret i16 %v
}

define dso_local void @fulltest() local_unnamed_addr {
; CHECK-LABEL: fulltest:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $2, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $3, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $4, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $5, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $6, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $7, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movzwl {{.*}}(%rip), %edx
; CHECK-NEXT:    addl $16, %edx
; CHECK-NEXT:    movb $8, %al
; CHECK-NEXT:    # kill: def $dx killed $dx killed $edx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    outb %al, %dx
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    retq
entry:
  %0 = load i16, i16* @base, align 2
  %add = add i16 %0, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 0, i16 %add)
  %1 = load i16, i16* @base, align 2
  %add3 = add i16 %1, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 1, i16 %add3)
  %2 = load i16, i16* @base, align 2
  %add6 = add i16 %2, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 2, i16 %add6)
  %3 = load i16, i16* @base, align 2
  %add9 = add i16 %3, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 3, i16 %add9)
  %4 = load i16, i16* @base, align 2
  %add12 = add i16 %4, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 4, i16 %add12)
  %5 = load i16, i16* @base, align 2
  %add15 = add i16 %5, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 5, i16 %add15)
  %6 = load i16, i16* @base, align 2
  %add18 = add i16 %6, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 6, i16 %add18)
  %7 = load i16, i16* @base, align 2
  %add21 = add i16 %7, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 7, i16 %add21)
  %8 = load i16, i16* @base, align 2
  %add24 = add i16 %8, 16
  tail call void asm sideeffect "outb %al,${1:w}", "{ax},{dx},~{dirflag},~{fpsr},~{flags}"(i8 8, i16 %add24)
  ret void
}
