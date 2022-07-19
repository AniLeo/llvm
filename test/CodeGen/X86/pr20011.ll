; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s --check-prefix=X64

%destTy = type { i2, i2 }

define void @crash(i64 %x0, i64 %y0, ptr nocapture %dest) nounwind {
; X86-LABEL: crash:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %dl
; X86-NEXT:    shlb $2, %dl
; X86-NEXT:    andb $3, %cl
; X86-NEXT:    orb %dl, %cl
; X86-NEXT:    andb $15, %cl
; X86-NEXT:    movb %cl, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: crash:
; X64:       # %bb.0:
; X64-NEXT:    shlb $2, %sil
; X64-NEXT:    andb $3, %dil
; X64-NEXT:    orb %sil, %dil
; X64-NEXT:    andb $15, %dil
; X64-NEXT:    movb %dil, (%rdx)
; X64-NEXT:    retq
  %x1 = trunc i64 %x0 to i2
  %y1 = trunc i64 %y0 to i2
  %1 = insertelement <2 x i2> undef, i2 %x1, i32 0
  %2 = insertelement <2 x i2> %1, i2 %y1, i32 1
  store <2 x i2> %2, ptr %dest, align 1
  ret void
}
