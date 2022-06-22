; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown < %s | FileCheck %s

; Verify that backwards propagation of a mask does not affect
; nodes with multiple result values. In both tests, the stored
; 32-bit value should be masked to an 8-bit number (and 255).

@b = dso_local local_unnamed_addr global i32 918, align 4
@d = dso_local local_unnamed_addr global i32 8089, align 4
@c = common dso_local local_unnamed_addr global i32 0, align 4
@a = common dso_local local_unnamed_addr global i32 0, align 4

define dso_local void @PR37667() {
; CHECK-LABEL: PR37667:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl b(%rip), %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl d(%rip)
; CHECK-NEXT:    orl c(%rip), %edx
; CHECK-NEXT:    movzbl %dl, %eax
; CHECK-NEXT:    movl %eax, a(%rip)
; CHECK-NEXT:    retq
  %t0 = load i32, ptr @c, align 4
  %t1 = load i32, ptr @b, align 4
  %t2 = load i32, ptr @d, align 4
  %rem = urem i32 %t1, %t2
  %or = or i32 %rem, %t0
  %conv1 = and i32 %or, 255
  store i32 %conv1, ptr @a, align 4
  ret void
}

define dso_local void @PR37060() {
; CHECK-LABEL: PR37060:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl c(%rip)
; CHECK-NEXT:    xorl b(%rip), %edx
; CHECK-NEXT:    movzbl %dl, %eax
; CHECK-NEXT:    movl %eax, a(%rip)
; CHECK-NEXT:    retq
  %t0 = load i32, ptr @c, align 4
  %rem = srem i32 -1, %t0
  %t2 = load i32, ptr @b, align 4
  %xor = xor i32 %t2, %rem
  %conv3 = and i32 %xor, 255
  store i32 %conv3, ptr @a, align 4
  ret void
}

