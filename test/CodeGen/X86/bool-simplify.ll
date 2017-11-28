; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1,-avx,+rdrnd,+rdseed | FileCheck %s

define i32 @foo(<2 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: foo:
; CHECK:       # BB#0:
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    cmovnel %esi, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %t1 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %c, <2 x i64> %c)
  %t2 = icmp ne i32 %t1, 0
  %t3 = select i1 %t2, i32 %a, i32 %b
  ret i32 %t3
}

define i32 @bar(<2 x i64> %c) {
; CHECK-LABEL: bar:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    jne .LBB1_2
; CHECK-NEXT:  # BB#1: # %if-true-block
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB1_2: # %endif-block
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retq
entry:
  %0 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %c, <2 x i64> %c)
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %if-true-block, label %endif-block
if-true-block:
  ret i32 0
endif-block:
  ret i32 1
}

define i32 @bax(<2 x i64> %c) {
; CHECK-LABEL: bax:
; CHECK:       # BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %t1 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %c, <2 x i64> %c)
  %t2 = icmp eq i32 %t1, 1
  %t3 = zext i1 %t2 to i32
  ret i32 %t3
}

define i16 @rnd16(i16 %arg) nounwind {
; CHECK-LABEL: rnd16:
; CHECK:       # BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    rdrandw %cx
; CHECK-NEXT:    cmovbw %di, %ax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    # kill: %ax<def> %ax<kill> %eax<kill>
; CHECK-NEXT:    retq
  %1 = tail call { i16, i32 } @llvm.x86.rdrand.16() nounwind
  %2 = extractvalue { i16, i32 } %1, 0
  %3 = extractvalue { i16, i32 } %1, 1
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i16 0, i16 %arg
  %6 = add i16 %5, %2
  ret i16 %6
}

define i32 @rnd32(i32 %arg) nounwind {
; CHECK-LABEL: rnd32:
; CHECK:       # BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    rdrandl %ecx
; CHECK-NEXT:    cmovbl %edi, %eax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    retq
  %1 = tail call { i32, i32 } @llvm.x86.rdrand.32() nounwind
  %2 = extractvalue { i32, i32 } %1, 0
  %3 = extractvalue { i32, i32 } %1, 1
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i32 0, i32 %arg
  %6 = add i32 %5, %2
  ret i32 %6
}

define i64 @rnd64(i64 %arg) nounwind {
; CHECK-LABEL: rnd64:
; CHECK:       # BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    rdrandq %rcx
; CHECK-NEXT:    cmovbq %rdi, %rax
; CHECK-NEXT:    addq %rcx, %rax
; CHECK-NEXT:    retq
  %1 = tail call { i64, i32 } @llvm.x86.rdrand.64() nounwind
  %2 = extractvalue { i64, i32 } %1, 0
  %3 = extractvalue { i64, i32 } %1, 1
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i64 0, i64 %arg
  %6 = add i64 %5, %2
  ret i64 %6
}

define i16 @seed16(i16 %arg) nounwind {
; CHECK-LABEL: seed16:
; CHECK:       # BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    rdseedw %cx
; CHECK-NEXT:    cmovbw %di, %ax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    # kill: %ax<def> %ax<kill> %eax<kill>
; CHECK-NEXT:    retq
  %1 = tail call { i16, i32 } @llvm.x86.rdseed.16() nounwind
  %2 = extractvalue { i16, i32 } %1, 0
  %3 = extractvalue { i16, i32 } %1, 1
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i16 0, i16 %arg
  %6 = add i16 %5, %2
  ret i16 %6
}

define i32 @seed32(i32 %arg) nounwind {
; CHECK-LABEL: seed32:
; CHECK:       # BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    rdseedl %ecx
; CHECK-NEXT:    cmovbl %edi, %eax
; CHECK-NEXT:    addl %ecx, %eax
; CHECK-NEXT:    retq
  %1 = tail call { i32, i32 } @llvm.x86.rdseed.32() nounwind
  %2 = extractvalue { i32, i32 } %1, 0
  %3 = extractvalue { i32, i32 } %1, 1
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i32 0, i32 %arg
  %6 = add i32 %5, %2
  ret i32 %6
}

define i64 @seed64(i64 %arg) nounwind {
; CHECK-LABEL: seed64:
; CHECK:       # BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    rdseedq %rcx
; CHECK-NEXT:    cmovbq %rdi, %rax
; CHECK-NEXT:    addq %rcx, %rax
; CHECK-NEXT:    retq
  %1 = tail call { i64, i32 } @llvm.x86.rdseed.64() nounwind
  %2 = extractvalue { i64, i32 } %1, 0
  %3 = extractvalue { i64, i32 } %1, 1
  %4 = icmp eq i32 %3, 0
  %5 = select i1 %4, i64 0, i64 %arg
  %6 = add i64 %5, %2
  ret i64 %6
}

declare i32 @llvm.x86.sse41.ptestz(<2 x i64>, <2 x i64>) nounwind readnone
declare { i16, i32 } @llvm.x86.rdrand.16() nounwind
declare { i32, i32 } @llvm.x86.rdrand.32() nounwind
declare { i64, i32 } @llvm.x86.rdrand.64() nounwind
declare { i16, i32 } @llvm.x86.rdseed.16() nounwind
declare { i32, i32 } @llvm.x86.rdseed.32() nounwind
declare { i64, i32 } @llvm.x86.rdseed.64() nounwind
