; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin | FileCheck %s
; rdar://7329206

; Use sbb x, x to materialize carry bit in a GPR. The value is either
; all 1's or all 0's.

define zeroext i16 @t1(i16 zeroext %x) nounwind readnone ssp {
; CHECK-LABEL: t1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpl $26, %edi
; CHECK-NEXT:    seta %al
; CHECK-NEXT:    shll $5, %eax
; CHECK-NEXT:    retq
;
  %t0 = icmp ugt i16 %x, 26
  %if = select i1 %t0, i16 32, i16 0
  ret i16 %if
}

define zeroext i16 @t2(i16 zeroext %x) nounwind readnone ssp {
; CHECK-LABEL: t2:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpl $26, %edi
; CHECK-NEXT:    sbbl %eax, %eax
; CHECK-NEXT:    andl $32, %eax
; CHECK-NEXT:    retq
;
  %t0 = icmp ult i16 %x, 26
  %if = select i1 %t0, i16 32, i16 0
  ret i16 %if
}

define i64 @t3(i64 %x) nounwind readnone ssp {
; CHECK-LABEL: t3:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq $18, %rdi
; CHECK-NEXT:    sbbq %rax, %rax
; CHECK-NEXT:    andl $64, %eax
; CHECK-NEXT:    retq
;
  %t0 = icmp ult i64 %x, 18
  %if = select i1 %t0, i64 64, i64 0
  ret i64 %if
}

@v4 = common global i32 0, align 4

define i32 @t4(i32 %a) {
; CHECK-LABEL: t4:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movq _v4@{{.*}}(%rip), %rax
; CHECK-NEXT:    cmpl $1, (%rax)
; CHECK-NEXT:    sbbl %eax, %eax
; CHECK-NEXT:    andl $32768, %eax ## imm = 0x8000
; CHECK-NEXT:    leal 65536(%rax,%rax), %eax
; CHECK-NEXT:    retq
;
  %t0 = load i32, i32* @v4, align 4
  %not.tobool = icmp eq i32 %t0, 0
  %conv.i = sext i1 %not.tobool to i16
  %call.lobit = lshr i16 %conv.i, 15
  %add.i.1 = add nuw nsw i16 %call.lobit, 1
  %conv4.2 = zext i16 %add.i.1 to i32
  %add = shl nuw nsw i32 %conv4.2, 16
  ret i32 %add
}

define i8 @t5(i32 %a) #0 {
; CHECK-LABEL: t5:
; CHECK:       ## BB#0:
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    retq
;
  %.lobit = lshr i32 %a, 31
  %trunc = trunc i32 %.lobit to i8
  %.not = xor i8 %trunc, 1
  ret i8 %.not
}

define zeroext i1 @t6(i32 %a) #0 {
; CHECK-LABEL: t6:
; CHECK:       ## BB#0:
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    retq
;
  %.lobit = lshr i32 %a, 31
  %trunc = trunc i32 %.lobit to i1
  %.not = xor i1 %trunc, 1
  ret i1 %.not
}

attributes #0 = { "target-cpu"="skylake-avx512" }
