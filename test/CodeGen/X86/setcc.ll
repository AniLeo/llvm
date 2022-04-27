; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-apple-darwin | FileCheck %s --check-prefixes=X64
; rdar://7329206

define zeroext i16 @t1(i16 zeroext %x) nounwind readnone ssp {
; X86-LABEL: t1:
; X86:       ## %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpw $27, {{[0-9]+}}(%esp)
; X86-NEXT:    setae %al
; X86-NEXT:    shll $5, %eax
; X86-NEXT:    retl
;
; X64-LABEL: t1:
; X64:       ## %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpw $27, %di
; X64-NEXT:    setae %al
; X64-NEXT:    shll $5, %eax
; X64-NEXT:    retq
  %t0 = icmp ugt i16 %x, 26
  %if = select i1 %t0, i16 32, i16 0
  ret i16 %if
}

define zeroext i16 @t2(i16 zeroext %x) nounwind readnone ssp {
; X86-LABEL: t2:
; X86:       ## %bb.0:
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpw $26, {{[0-9]+}}(%esp)
; X86-NEXT:    setb %al
; X86-NEXT:    shll $5, %eax
; X86-NEXT:    retl
;
; X64-LABEL: t2:
; X64:       ## %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpw $26, %di
; X64-NEXT:    setb %al
; X64-NEXT:    shll $5, %eax
; X64-NEXT:    retq
  %t0 = icmp ult i16 %x, 26
  %if = select i1 %t0, i16 32, i16 0
  ret i16 %if
}

define i64 @t3(i64 %x) nounwind readnone ssp {
; X86-LABEL: t3:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    cmpl $18, {{[0-9]+}}(%esp)
; X86-NEXT:    sbbl $0, %eax
; X86-NEXT:    setb %al
; X86-NEXT:    movzbl %al, %eax
; X86-NEXT:    shll $6, %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: t3:
; X64:       ## %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpq $18, %rdi
; X64-NEXT:    setb %al
; X64-NEXT:    shlq $6, %rax
; X64-NEXT:    retq
  %t0 = icmp ult i64 %x, 18
  %if = select i1 %t0, i64 64, i64 0
  ret i64 %if
}

@v4 = common global i32 0, align 4

define i32 @t4(i32 %a) {
; X86-LABEL: t4:
; X86:       ## %bb.0:
; X86-NEXT:    movl L_v4$non_lazy_ptr, %ecx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    cmpl $1, (%ecx)
; X86-NEXT:    adcw $1, %ax
; X86-NEXT:    shll $16, %eax
; X86-NEXT:    retl
;
; X64-LABEL: t4:
; X64:       ## %bb.0:
; X64-NEXT:    movq _v4@GOTPCREL(%rip), %rcx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    cmpl $1, (%rcx)
; X64-NEXT:    adcw $1, %ax
; X64-NEXT:    shll $16, %eax
; X64-NEXT:    retq
  %t0 = load i32, i32* @v4, align 4
  %not.tobool = icmp eq i32 %t0, 0
  %conv.i = sext i1 %not.tobool to i16
  %call.lobit = lshr i16 %conv.i, 15
  %add.i.1 = add nuw nsw i16 %call.lobit, 1
  %conv4.2 = zext i16 %add.i.1 to i32
  %add = shl nuw nsw i32 %conv4.2, 16
  ret i32 %add
}

define i8 @t5(i32 %a) {
; X86-LABEL: t5:
; X86:       ## %bb.0:
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setns %al
; X86-NEXT:    retl
;
; X64-LABEL: t5:
; X64:       ## %bb.0:
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    setns %al
; X64-NEXT:    retq
  %.lobit = lshr i32 %a, 31
  %trunc = trunc i32 %.lobit to i8
  %.not = xor i8 %trunc, 1
  ret i8 %.not
}

define zeroext i1 @t6(i32 %a) {
; X86-LABEL: t6:
; X86:       ## %bb.0:
; X86-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; X86-NEXT:    setns %al
; X86-NEXT:    retl
;
; X64-LABEL: t6:
; X64:       ## %bb.0:
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    setns %al
; X64-NEXT:    retq
  %.lobit = lshr i32 %a, 31
  %trunc = trunc i32 %.lobit to i1
  %.not = xor i1 %trunc, 1
  ret i1 %.not
}

; PR39174
define zeroext i1 @t7(i32 %0) {
; X86-LABEL: t7:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl $19, %ecx
; X86-NEXT:    btl %eax, %ecx
; X86-NEXT:    setb %al
; X86-NEXT:    retl
;
; X64-LABEL: t7:
; X64:       ## %bb.0:
; X64-NEXT:    movl $19, %eax
; X64-NEXT:    btl %edi, %eax
; X64-NEXT:    setb %al
; X64-NEXT:    retq
  %2 = trunc i32 %0 to i5
  %3 = lshr i5 -13, %2
  %4 = and i5 %3, 1
  %5 = icmp ne i5 %4, 0
  ret i1 %5
}

define zeroext i1 @t8(i8 %0, i8 %1) {
; X86-LABEL: t8:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    btl %eax, %ecx
; X86-NEXT:    setb %al
; X86-NEXT:    retl
;
; X64-LABEL: t8:
; X64:       ## %bb.0:
; X64-NEXT:    btl %esi, %edi
; X64-NEXT:    setb %al
; X64-NEXT:    retq
  %3 = lshr i8 %0, %1
  %4 = and i8 %3, 1
  %5 = icmp ne i8 %4, 0
  ret i1 %5
}

define i64 @t9(i32 %0, i32 %1) {
; X86-LABEL: t9:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    btl %edx, %ecx
; X86-NEXT:    setb %al
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: t9:
; X64:       ## %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    btl %esi, %edi
; X64-NEXT:    setb %al
; X64-NEXT:    retq
  %3 = lshr i32 %0, %1
  %4 = and i32 %3, 1
  %5 = icmp ne i32 %4, 0
  %6 = zext i1 %5 to i64
  ret i64 %6
}

define i32 @t10(i32 %0, i32 %1) {
; X86-LABEL: t10:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    btl %edx, %ecx
; X86-NEXT:    setae %al
; X86-NEXT:    retl
;
; X64-LABEL: t10:
; X64:       ## %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    btl %esi, %edi
; X64-NEXT:    setae %al
; X64-NEXT:    retq
  %3 = lshr i32 %0, %1
  %4 = and i32 %3, 1
  %5 = xor i32 %4, 1
  ret i32 %5
}

define i32 @t11(i32 %0, i32 %1) {
; X86-LABEL: t11:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    btl %edx, %ecx
; X86-NEXT:    setae %al
; X86-NEXT:    retl
;
; X64-LABEL: t11:
; X64:       ## %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    btl %esi, %edi
; X64-NEXT:    setae %al
; X64-NEXT:    retq
  %3 = xor i32 %0, -1
  %4 = lshr i32 %3, %1
  %5 = and i32 %4, 1
  ret i32 %5
}

define i32 @t12(i32 %0, i32 %1) {
; X86-LABEL: t12:
; X86:       ## %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    btl %edx, %ecx
; X86-NEXT:    setb %al
; X86-NEXT:    retl
;
; X64-LABEL: t12:
; X64:       ## %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    btl %esi, %edi
; X64-NEXT:    setb %al
; X64-NEXT:    retq
  %3 = xor i32 %0, -1
  %4 = lshr i32 %3, %1
  %5 = and i32 %4, 1
  %6 = xor i32 %5, 1
  ret i32 %6
}

define i16 @shift_and(i16 %a) {
; X86-LABEL: shift_and:
; X86:       ## %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    andb $4, %al
; X86-NEXT:    shrb $2, %al
; X86-NEXT:    movzbl %al, %eax
; X86-NEXT:    ## kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: shift_and:
; X64:       ## %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $10, %eax
; X64-NEXT:    andl $1, %eax
; X64-NEXT:    ## kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %and = and i16 %a, 1024
  %cmp = icmp ne i16 %and, 0
  %conv = zext i1 %cmp to i16
  ret i16 %conv
}

define i32 @PR55138(i32 %x) {
; X86-LABEL: PR55138:
; X86:       ## %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    andb $15, %al
; X86-NEXT:    movzbl %al, %ecx
; X86-NEXT:    movl $27030, %edx ## imm = 0x6996
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    btl %ecx, %edx
; X86-NEXT:    setb %al
; X86-NEXT:    retl
;
; X64-LABEL: PR55138:
; X64:       ## %bb.0:
; X64-NEXT:    andb $15, %dil
; X64-NEXT:    movzbl %dil, %ecx
; X64-NEXT:    movl $27030, %edx ## imm = 0x6996
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    btl %ecx, %edx
; X64-NEXT:    setb %al
; X64-NEXT:    retq
  %urem = and i32 %x, 15
  %shr = lshr i32 27030, %urem
  %and = and i32 %shr, 1
  ret i32 %and
}
