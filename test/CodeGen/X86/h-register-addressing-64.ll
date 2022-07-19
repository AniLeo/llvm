; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=-bmi | FileCheck %s

; Use h-register extract and zero-extend.

define double @foo8(ptr nocapture inreg %p, i64 inreg %x) nounwind readonly {
; CHECK-LABEL: foo8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
  %t0 = lshr i64 %x, 8
  %t1 = and i64 %t0, 255
  %t2 = getelementptr double, ptr %p, i64 %t1
  %t3 = load double, ptr %t2, align 8
  ret double %t3
}

define float @foo4(ptr nocapture inreg %p, i64 inreg %x) nounwind readonly {
; CHECK-LABEL: foo4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    retq
  %t0 = lshr i64 %x, 8
  %t1 = and i64 %t0, 255
  %t2 = getelementptr float, ptr %p, i64 %t1
  %t3 = load float, ptr %t2, align 8
  ret float %t3
}

define i16 @foo2(ptr nocapture inreg %p, i64 inreg %x) nounwind readonly {
; CHECK-LABEL: foo2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    movzwl (%rdi,%rax,2), %eax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %x, 8
  %t1 = and i64 %t0, 255
  %t2 = getelementptr i16, ptr %p, i64 %t1
  %t3 = load i16, ptr %t2, align 8
  ret i16 %t3
}

define i8 @foo1(ptr nocapture inreg %p, i64 inreg %x) nounwind readonly {
; CHECK-LABEL: foo1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    movzbl (%rdi,%rax), %eax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %x, 8
  %t1 = and i64 %t0, 255
  %t2 = getelementptr i8, ptr %p, i64 %t1
  %t3 = load i8, ptr %t2, align 8
  ret i8 %t3
}

define i8 @bar8(ptr nocapture inreg %p, i64 inreg %x) nounwind readonly {
; CHECK-LABEL: bar8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    movzbl (%rdi,%rax,8), %eax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %x, 5
  %t1 = and i64 %t0, 2040
  %t2 = getelementptr i8, ptr %p, i64 %t1
  %t3 = load i8, ptr %t2, align 8
  ret i8 %t3
}

define i8 @bar4(ptr nocapture inreg %p, i64 inreg %x) nounwind readonly {
; CHECK-LABEL: bar4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    movzbl (%rdi,%rax,4), %eax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %x, 6
  %t1 = and i64 %t0, 1020
  %t2 = getelementptr i8, ptr %p, i64 %t1
  %t3 = load i8, ptr %t2, align 8
  ret i8 %t3
}

define i8 @bar2(ptr nocapture inreg %p, i64 inreg %x) nounwind readonly {
; CHECK-LABEL: bar2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movzbl %ah, %eax
; CHECK-NEXT:    movzbl (%rdi,%rax,2), %eax
; CHECK-NEXT:    retq
  %t0 = lshr i64 %x, 7
  %t1 = and i64 %t0, 510
  %t2 = getelementptr i8, ptr %p, i64 %t1
  %t3 = load i8, ptr %t2, align 8
  ret i8 %t3
}
