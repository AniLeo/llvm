; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s --check-prefix=X64

define signext i16 @foo(i16 signext %x) nounwind {
; X86-LABEL: foo:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $21998, %eax # imm = 0x55EE
; X86-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: foo:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $21998, %eax # imm = 0x55EE
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
entry:
  %0 = xor i16 %x, 21998
  ret i16 %0
}

define signext i16 @bar(i16 signext %x) nounwind {
; X86-LABEL: bar:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $54766, %eax # imm = 0xD5EE
; X86-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: bar:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl $54766, %eax # imm = 0xD5EE
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
entry:
  %0 = xor i16 %x, 54766
  ret i16 %0
}

define signext i16 @baz(i16* %x, i16 signext %y) nounwind {
; X86-LABEL: baz:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl (%eax), %eax
; X86-NEXT:    subw {{[0-9]+}}(%esp), %ax
; X86-NEXT:    retl
;
; X64-LABEL: baz:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    subl %esi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
entry:
  %0 = load i16, i16* %x
  %sub = sub i16 %0, %y
  ret i16 %sub
}

define void @bat(i16* %a, i16* %x, i16 signext %y) nounwind {
; X86-LABEL: bat:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzwl (%ecx), %ecx
; X86-NEXT:    subw {{[0-9]+}}(%esp), %cx
; X86-NEXT:    movw %cx, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: bat:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movzwl (%rsi), %eax
; X64-NEXT:    subl %edx, %eax
; X64-NEXT:    movw %ax, (%rdi)
; X64-NEXT:    retq
entry:
  %0 = load i16, i16* %x
  %sub = sub i16 %0, %y
  store i16 %sub, i16* %a
  ret void
}
