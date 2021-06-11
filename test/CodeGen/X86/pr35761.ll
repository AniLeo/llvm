; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux %s -o - | FileCheck %s

@x = dso_local global i8 0, align 1
@y = dso_local global i32 0, align 4
@z = dso_local global i24 0, align 4

define dso_local void @PR35761(i32 %call) {
; CHECK-LABEL: PR35761:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movzbl x(%rip), %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    movzbl y(%rip), %ecx
; CHECK-NEXT:    xorl $255, %ecx
; CHECK-NEXT:    orl %eax, %ecx
; CHECK-NEXT:    movw %cx, z(%rip)
; CHECK-NEXT:    movb $0, z+2(%rip)
; CHECK-NEXT:    retq
entry:
  %0 = load i8, i8* @x, align 1
  %tobool = trunc i8 %0 to i1
  %conv = zext i1 %tobool to i32
  %or = or i32 32767, %call
  %neg = xor i32 %or, -1
  %neg1 = xor i32 %neg, -1
  %1 = load i32, i32* @y, align 4
  %xor = xor i32 %neg1, %1
  %or2 = or i32 %conv, %xor
  %conv3 = trunc i32 %or2 to i8
  %bf.load = load i24, i24* @z, align 4
  %2 = zext i8 %conv3 to i24
  %bf.value = and i24 %2, 4194303
  store i24 %bf.value, i24* @z, align 2
  ret void
}

