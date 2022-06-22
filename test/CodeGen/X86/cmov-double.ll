; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -o - %s | FileCheck %s
target triple = "x86_64-unknown-unknown"

; select with and i1/or i1 condition should be implemented as a series of 2
; cmovs, not by producing two conditions and using and on them.

define dso_local i32 @select_and(i32 %a0, i32 %a1, float %a2, float %a3, i32 %a4, i32 %a5) {
; CHECK-LABEL: select_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edx, %eax
; CHECK-NEXT:    ucomiss %xmm0, %xmm1
; CHECK-NEXT:    cmovbel %ecx, %eax
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    cmovael %ecx, %eax
; CHECK-NEXT:    retq
  %cmp0 = icmp ult i32 %a0, %a1
  %cmp1 = fcmp olt float %a2, %a3
  %and = and i1 %cmp0, %cmp1
  %res = select i1 %and, i32 %a4, i32 %a5
  ret i32 %res
}

; select with and i1 condition should be implemented as a series of 2 cmovs, not
; by producing two conditions and using and on them.

define dso_local i32 @select_or(i32 %a0, i32 %a1, float %a2, float %a3, i32 %a4, i32 %a5) {
; CHECK-LABEL: select_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    ucomiss %xmm0, %xmm1
; CHECK-NEXT:    cmoval %edx, %eax
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    cmovbl %edx, %eax
; CHECK-NEXT:    retq
  %cmp0 = icmp ult i32 %a0, %a1
  %cmp1 = fcmp olt float %a2, %a3
  %and = or i1 %cmp0, %cmp1
  %res = select i1 %and, i32 %a4, i32 %a5
  ret i32 %res
}

; If one of the conditions is materialized as a 0/1 value anyway, then the
; sequence of 2 cmovs should not be used.

@var32 = dso_local global i32 0
define dso_local i32 @select_noopt(i32 %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4) {
; CHECK-LABEL: select_noopt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    setb %cl
; CHECK-NEXT:    cmpl %edx, %esi
; CHECK-NEXT:    setb %dl
; CHECK-NEXT:    orb %cl, %dl
; CHECK-NEXT:    movzbl %dl, %ecx
; CHECK-NEXT:    movl %ecx, var32(%rip)
; CHECK-NEXT:    testb %cl, %cl
; CHECK-NEXT:    cmovel %r8d, %eax
; CHECK-NEXT:    retq
  %cmp0 = icmp ult i32 %a0, %a1
  %cmp1 = icmp ult i32 %a1, %a2
  %or = or i1 %cmp0, %cmp1
  %zero_one = zext i1 %or to i32
  store volatile i32 %zero_one, ptr @var32
  %res = select i1 %or, i32 %a3, i32 %a4
  ret i32 %res
}
