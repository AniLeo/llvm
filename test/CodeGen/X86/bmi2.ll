; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+bmi,+bmi2,+cmov | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+bmi,+bmi2 | FileCheck %s --check-prefix=X64

define i32 @bzhi32(i32 %x, i32 %y)   {
; X86-LABEL: bzhi32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    addl %ecx, %ecx
; X86-NEXT:    bzhil %eax, %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: bzhi32:
; X64:       # %bb.0:
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    bzhil %esi, %edi, %eax
; X64-NEXT:    retq
  %x1 = add i32 %x, %x
  %tmp = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %x1, i32 %y)
  ret i32 %tmp
}

define i32 @bzhi32_load(i32* %x, i32 %y)   {
; X86-LABEL: bzhi32_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    bzhil %eax, (%ecx), %eax
; X86-NEXT:    retl
;
; X64-LABEL: bzhi32_load:
; X64:       # %bb.0:
; X64-NEXT:    bzhil %esi, (%rdi), %eax
; X64-NEXT:    retq
  %x1 = load i32, i32* %x
  %tmp = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %x1, i32 %y)
  ret i32 %tmp
}

; PR48768 - 'bzhi' clears the overflow flag, so we don't need a separate 'test'.
define i1 @bzhi32_overflow(i32 %x, i32 %y) {
; X86-LABEL: bzhi32_overflow:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    bzhil %eax, {{[0-9]+}}(%esp), %eax
; X86-NEXT:    setle %al
; X86-NEXT:    retl
;
; X64-LABEL: bzhi32_overflow:
; X64:       # %bb.0:
; X64-NEXT:    bzhil %esi, %edi, %eax
; X64-NEXT:    setle %al
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %x, i32 %y)
  %cmp = icmp slt i32 %tmp, 1
  ret i1 %cmp
}

declare i32 @llvm.x86.bmi.bzhi.32(i32, i32)

define i32 @pdep32(i32 %x, i32 %y)   {
; X86-LABEL: pdep32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    addl %ecx, %ecx
; X86-NEXT:    pdepl %ecx, %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32:
; X64:       # %bb.0:
; X64-NEXT:    addl %esi, %esi
; X64-NEXT:    pdepl %esi, %edi, %eax
; X64-NEXT:    retq
  %y1 = add i32 %y, %y
  %tmp = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 %y1)
  ret i32 %tmp
}

define i32 @pdep32_load(i32 %x, i32* %y)   {
; X86-LABEL: pdep32_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    pdepl (%eax), %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_load:
; X64:       # %bb.0:
; X64-NEXT:    pdepl (%rsi), %edi, %eax
; X64-NEXT:    retq
  %y1 = load i32, i32* %y
  %tmp = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 %y1)
  ret i32 %tmp
}

define i32 @pdep32_anyext(i16 %x)   {
; X86-LABEL: pdep32_anyext:
; X86:       # %bb.0:
; X86-NEXT:    movswl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl $-1431655766, %ecx # imm = 0xAAAAAAAA
; X86-NEXT:    pdepl %ecx, %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_anyext:
; X64:       # %bb.0:
; X64-NEXT:    movl $-1431655766, %eax # imm = 0xAAAAAAAA
; X64-NEXT:    pdepl %eax, %edi, %eax
; X64-NEXT:    retq
  %x1 = sext i16 %x to i32
  %tmp = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x1, i32 -1431655766)
  ret i32 %tmp
}

define i32 @pdep32_demandedbits(i32 %x) {
; X86-LABEL: pdep32_demandedbits:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl $1431655765, %ecx # imm = 0x55555555
; X86-NEXT:    pdepl %ecx, %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_demandedbits:
; X64:       # %bb.0:
; X64-NEXT:    movl $1431655765, %eax # imm = 0x55555555
; X64-NEXT:    pdepl %eax, %edi, %eax
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 1431655765)
  %tmp2 = and i32 %tmp, 1431655765
  ret i32 %tmp2
}

define i32 @pdep32_demandedbits2(i32 %x, i32 %y) {
; X86-LABEL: pdep32_demandedbits2:
; X86:       # %bb.0:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pdepl {{[0-9]+}}(%esp), %eax, %eax
; X86-NEXT:    andl $128, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_demandedbits2:
; X64:       # %bb.0:
; X64-NEXT:    pdepl %esi, %edi, %eax
; X64-NEXT:    andl $128, %eax
; X64-NEXT:    retq
  %tmp = and i32 %x, 255
  %tmp2 = tail call i32 @llvm.x86.bmi.pdep.32(i32 %tmp, i32 %y)
  %tmp3 = and i32 %tmp2, 128
  ret i32 %tmp3
}

define i32 @pdep32_demandedbits_mask(i32 %x, i16 %y) {
; X86-LABEL: pdep32_demandedbits_mask:
; X86:       # %bb.0:
; X86-NEXT:    movswl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    pdepl %eax, %ecx, %eax
; X86-NEXT:    andl $32768, %eax # imm = 0x8000
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_demandedbits_mask:
; X64:       # %bb.0:
; X64-NEXT:    pdepl %esi, %edi, %eax
; X64-NEXT:    andl $32768, %eax # imm = 0x8000
; X64-NEXT:    retq
  %tmp = sext i16 %y to i32
  %tmp2 = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 %tmp)
  %tmp3 = and i32 %tmp2, 32768
  ret i32 %tmp3
}

define i32 @pdep32_demandedbits_mask2(i32 %x, i16 %y) {
; X86-LABEL: pdep32_demandedbits_mask2:
; X86:       # %bb.0:
; X86-NEXT:    movswl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    pdepl %eax, %ecx, %eax
; X86-NEXT:    movzwl %ax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_demandedbits_mask2:
; X64:       # %bb.0:
; X64-NEXT:    pdepl %esi, %edi, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    retq
  %tmp = sext i16 %y to i32
  %tmp2 = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 %tmp)
  %tmp3 = and i32 %tmp2, 65535
  ret i32 %tmp3
}

define i32 @pdep32_knownbits(i32 %x) {
; X86-LABEL: pdep32_knownbits:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl $1431655765, %ecx # imm = 0x55555555
; X86-NEXT:    pdepl %ecx, %eax, %eax
; X86-NEXT:    imull %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_knownbits:
; X64:       # %bb.0:
; X64-NEXT:    movl $1431655765, %eax # imm = 0x55555555
; X64-NEXT:    pdepl %eax, %edi, %eax
; X64-NEXT:    imull %eax, %eax
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 1431655765)
  %tmp2 = and i32 %tmp, 1431655765
  %tmp3 = mul i32 %tmp, %tmp2
  ret i32 %tmp3
}

define i32 @pdep32_knownbits2(i32 %x, i32 %y) {
; X86-LABEL: pdep32_knownbits2:
; X86:       # %bb.0:
; X86-NEXT:    movl $-256, %eax
; X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pdepl {{[0-9]+}}(%esp), %eax, %eax
; X86-NEXT:    imull %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pdep32_knownbits2:
; X64:       # %bb.0:
; X64-NEXT:    andl $-256, %edi
; X64-NEXT:    pdepl %esi, %edi, %eax
; X64-NEXT:    imull %eax, %eax
; X64-NEXT:    retq
  %tmp = and i32 %x, -256
  %tmp2 = tail call i32 @llvm.x86.bmi.pdep.32(i32 %tmp, i32 %y)
  %tmp3 = and i32 %tmp2, -256
  %tmp4 = mul i32 %tmp2, %tmp3
  ret i32 %tmp4
}

declare i32 @llvm.x86.bmi.pdep.32(i32, i32)

define i32 @pext32(i32 %x, i32 %y)   {
; X86-LABEL: pext32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    addl %ecx, %ecx
; X86-NEXT:    pextl %ecx, %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pext32:
; X64:       # %bb.0:
; X64-NEXT:    addl %esi, %esi
; X64-NEXT:    pextl %esi, %edi, %eax
; X64-NEXT:    retq
  %y1 = add i32 %y, %y
  %tmp = tail call i32 @llvm.x86.bmi.pext.32(i32 %x, i32 %y1)
  ret i32 %tmp
}

define i32 @pext32_load(i32 %x, i32* %y)   {
; X86-LABEL: pext32_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    pextl (%eax), %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pext32_load:
; X64:       # %bb.0:
; X64-NEXT:    pextl (%rsi), %edi, %eax
; X64-NEXT:    retq
  %y1 = load i32, i32* %y
  %tmp = tail call i32 @llvm.x86.bmi.pext.32(i32 %x, i32 %y1)
  ret i32 %tmp
}

define i32 @pext32_knownbits(i32 %x)   {
; X86-LABEL: pext32_knownbits:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl $1431655765, %ecx # imm = 0x55555555
; X86-NEXT:    pextl %ecx, %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: pext32_knownbits:
; X64:       # %bb.0:
; X64-NEXT:    movl $1431655765, %eax # imm = 0x55555555
; X64-NEXT:    pextl %eax, %edi, %eax
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.x86.bmi.pext.32(i32 %x, i32 1431655765)
  %tmp2 = and i32 %tmp, 65535
  ret i32 %tmp2
}

declare i32 @llvm.x86.bmi.pext.32(i32, i32)

define i32 @mulx32(i32 %x, i32 %y, i32* %p)   {
; X86-LABEL: mulx32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    addl %edx, %edx
; X86-NEXT:    addl %eax, %eax
; X86-NEXT:    mulxl %eax, %eax, %edx
; X86-NEXT:    movl %edx, (%ecx)
; X86-NEXT:    retl
;
; X64-LABEL: mulx32:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    addl %eax, %eax
; X64-NEXT:    imulq %rdi, %rax
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    shrq $32, %rcx
; X64-NEXT:    movl %ecx, (%rdx)
; X64-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-NEXT:    retq
  %x1 = add i32 %x, %x
  %y1 = add i32 %y, %y
  %x2 = zext i32 %x1 to i64
  %y2 = zext i32 %y1 to i64
  %r1 = mul i64 %x2, %y2
  %h1 = lshr i64 %r1, 32
  %h  = trunc i64 %h1 to i32
  %l  = trunc i64 %r1 to i32
  store i32 %h, i32* %p
  ret i32 %l
}

define i32 @mulx32_load(i32 %x, i32* %y, i32* %p)   {
; X86-LABEL: mulx32_load:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    addl %edx, %edx
; X86-NEXT:    mulxl (%eax), %eax, %edx
; X86-NEXT:    movl %edx, (%ecx)
; X86-NEXT:    retl
;
; X64-LABEL: mulx32_load:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    addl %eax, %eax
; X64-NEXT:    movl (%rsi), %ecx
; X64-NEXT:    imulq %rcx, %rax
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    shrq $32, %rcx
; X64-NEXT:    movl %ecx, (%rdx)
; X64-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-NEXT:    retq
  %x1 = add i32 %x, %x
  %y1 = load i32, i32* %y
  %x2 = zext i32 %x1 to i64
  %y2 = zext i32 %y1 to i64
  %r1 = mul i64 %x2, %y2
  %h1 = lshr i64 %r1, 32
  %h  = trunc i64 %h1 to i32
  %l  = trunc i64 %r1 to i32
  store i32 %h, i32* %p
  ret i32 %l
}
