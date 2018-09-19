; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define i32 @shl48sar47(i64 %a) #0 {
; CHECK-LABEL: shl48sar47:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswq %di, %rax
; CHECK-NEXT:    addl %eax, %eax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 48
  %2 = ashr exact i64 %1, 47
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i32 @shl48sar49(i64 %a) #0 {
; CHECK-LABEL: shl48sar49:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswq %di, %rax
; CHECK-NEXT:    shrq %rax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 48
  %2 = ashr exact i64 %1, 49
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i32 @shl56sar55(i64 %a) #0 {
; CHECK-LABEL: shl56sar55:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsbq %dil, %rax
; CHECK-NEXT:    addl %eax, %eax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 56
  %2 = ashr exact i64 %1, 55
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i32 @shl56sar57(i64 %a) #0 {
; CHECK-LABEL: shl56sar57:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsbq %dil, %rax
; CHECK-NEXT:    shrq %rax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = shl i64 %a, 56
  %2 = ashr exact i64 %1, 57
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define i8 @all_sign_bit_ashr(i8 %x) {
; CHECK-LABEL: all_sign_bit_ashr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    negb %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %and = and i8 %x, 1
  %neg = sub i8 0, %and
  %sar = ashr i8 %neg, 6
  ret i8 %sar
}

define <4 x i32> @all_sign_bit_ashr_vec(<4 x i32> %x) {
; CHECK-LABEL: all_sign_bit_ashr_vec:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pand {{.*}}(%rip), %xmm0
; CHECK-NEXT:    pxor %xmm1, %xmm1
; CHECK-NEXT:    psubd %xmm0, %xmm1
; CHECK-NEXT:    movdqa %xmm1, %xmm0
; CHECK-NEXT:    retq
  %and = and <4 x i32> %x, <i32 1, i32 1, i32 1 , i32 1>
  %neg = sub <4 x i32> zeroinitializer, %and
  %sar = ashr <4 x i32> %neg, <i32 1, i32 31, i32 5, i32 0>
  ret <4 x i32> %sar
}

attributes #0 = { nounwind }
