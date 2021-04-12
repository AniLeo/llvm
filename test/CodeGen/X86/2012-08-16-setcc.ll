; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

; rdar://12081007

define i32 @and_1(i8 zeroext %a, i8 zeroext %b, i32 %x) {
; CHECK-LABEL: and_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andl %esi, %eax
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %1 = and i8 %b, %a
  %2 = icmp ne i8 %1, 0
  %3 = select i1 %2, i32 %x, i32 0
  ret i32 %3
}

define zeroext i1 @and_2(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: and_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testl %edi, %esi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    retq
  %1 = and i8 %b, %a
  %2 = icmp ne i8 %1, 0
  ret i1 %2
}

define i32 @xor_1(i8 zeroext %a, i8 zeroext %b, i32 %x) {
; CHECK-LABEL: xor_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %esi, %edi
; CHECK-NEXT:    cmovnel %edx, %eax
; CHECK-NEXT:    retq
  %1 = xor i8 %b, %a
  %2 = icmp ne i8 %1, 0
  %3 = select i1 %2, i32 %x, i32 0
  ret i32 %3
}

define zeroext i1 @xor_2(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: xor_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %esi, %edi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    retq
  %1 = xor i8 %b, %a
  %2 = icmp ne i8 %1, 0
  ret i1 %2
}

