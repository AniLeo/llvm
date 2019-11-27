; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android \
; RUN:     -enable-legalize-types-checking \
; RUN:     -disable-strictnode-mutation | FileCheck %s
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu \
; RUN:     -enable-legalize-types-checking \
; RUN:     -disable-strictnode-mutation | FileCheck %s
; RUN: llc < %s -O2 -mtriple=i686-linux-gnu -mattr=+sse2 \
; RUN:     -enable-legalize-types-checking \
; RUN:     -disable-strictnode-mutation | FileCheck %s --check-prefix=X86

; Check all soft floating point library function calls.

define fp128 @add(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __addtf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: add:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll __addtf3
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %add = call fp128 @llvm.experimental.constrained.fadd.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %add
}

define fp128 @sub(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: sub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __subtf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: sub:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll __subtf3
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %sub = call fp128 @llvm.experimental.constrained.fsub.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %sub
}

define fp128 @mul(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: mul:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __multf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: mul:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll __multf3
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %mul = call fp128 @llvm.experimental.constrained.fmul.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %mul
}

define fp128 @div(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __divtf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: div:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll __divtf3
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %div = call fp128 @llvm.experimental.constrained.fdiv.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %div
}

define fp128 @fma(fp128 %x, fp128 %y, fp128 %z) nounwind strictfp {
; CHECK-LABEL: fma:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fmal
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: fma:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll fmal
; X86-NEXT:    addl $60, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %fma = call fp128 @llvm.experimental.constrained.fma.f128(fp128 %x, fp128 %y,  fp128 %z, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %fma
}

define fp128 @frem(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: frem:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fmodl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: frem:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll fmodl
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %div = call fp128 @llvm.experimental.constrained.frem.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %div
}

define fp128 @ceil(fp128 %x) nounwind strictfp {
; CHECK-LABEL: ceil:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq ceill
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: ceil:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll ceill
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %ceil = call fp128 @llvm.experimental.constrained.ceil.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %ceil
}

define fp128 @cos(fp128 %x) nounwind strictfp {
; CHECK-LABEL: cos:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq cosl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: cos:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll cosl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %cos = call fp128 @llvm.experimental.constrained.cos.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %cos
}

define fp128 @exp(fp128 %x) nounwind strictfp {
; CHECK-LABEL: exp:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq expl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: exp:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll expl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %exp = call fp128 @llvm.experimental.constrained.exp.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %exp
}

define fp128 @exp2(fp128 %x) nounwind strictfp {
; CHECK-LABEL: exp2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq exp2l
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: exp2:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll exp2l
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %exp2 = call fp128 @llvm.experimental.constrained.exp2.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %exp2
}

define fp128 @floor(fp128 %x) nounwind strictfp {
; CHECK-LABEL: floor:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq floorl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: floor:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll floorl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %floor = call fp128 @llvm.experimental.constrained.floor.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %floor
}

define fp128 @log(fp128 %x) nounwind strictfp {
; CHECK-LABEL: log:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq logl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: log:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll logl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %log = call fp128 @llvm.experimental.constrained.log.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %log
}

define fp128 @log10(fp128 %x) nounwind strictfp {
; CHECK-LABEL: log10:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq log10l
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: log10:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll log10l
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %log10 = call fp128 @llvm.experimental.constrained.log10.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %log10
}

define fp128 @log2(fp128 %x) nounwind strictfp {
; CHECK-LABEL: log2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq log2l
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: log2:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll log2l
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %log2 = call fp128 @llvm.experimental.constrained.log2.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %log2
}

define fp128 @maxnum(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: maxnum:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fmaxl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: maxnum:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll fmaxl
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %maxnum = call fp128 @llvm.experimental.constrained.maxnum.f128(fp128 %x, fp128 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %maxnum
}

define fp128 @minnum(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: minnum:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fminl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: minnum:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll fminl
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %minnum = call fp128 @llvm.experimental.constrained.minnum.f128(fp128 %x, fp128 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %minnum
}

define fp128 @nearbyint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: nearbyint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq nearbyintl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: nearbyint:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll nearbyintl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %nearbyint = call fp128 @llvm.experimental.constrained.nearbyint.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %nearbyint
}

define fp128 @pow(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: pow:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq powl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: pow:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll powl
; X86-NEXT:    addl $44, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %pow = call fp128 @llvm.experimental.constrained.pow.f128(fp128 %x, fp128 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %pow
}

define fp128 @powi(fp128 %x, i32 %y) nounwind strictfp {
; CHECK-LABEL: powi:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __powitf2
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: powi:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll __powitf2
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %powi = call fp128 @llvm.experimental.constrained.powi.f128(fp128 %x, i32 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %powi
}

define fp128 @rint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: rint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq rintl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: rint:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll rintl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %rint = call fp128 @llvm.experimental.constrained.rint.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %rint
}

define fp128 @round(fp128 %x) nounwind strictfp {
; CHECK-LABEL: round:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq roundl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: round:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll roundl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %round = call fp128 @llvm.experimental.constrained.round.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %round
}

define fp128 @sin(fp128 %x) nounwind strictfp {
; CHECK-LABEL: sin:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq sinl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: sin:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll sinl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %sin = call fp128 @llvm.experimental.constrained.sin.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %sin
}

define fp128 @sqrt(fp128 %x) nounwind strictfp {
; CHECK-LABEL: sqrt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq sqrtl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: sqrt:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll sqrtl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %sqrt = call fp128 @llvm.experimental.constrained.sqrt.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %sqrt
}

define fp128 @trunc(fp128 %x) nounwind strictfp {
; CHECK-LABEL: trunc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq truncl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
;
; X86-LABEL: trunc:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $20, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll truncl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    movl (%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, 8(%esi)
; X86-NEXT:    movl %edx, 12(%esi)
; X86-NEXT:    movl %eax, (%esi)
; X86-NEXT:    movl %ecx, 4(%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $20, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
entry:
  %trunc = call fp128 @llvm.experimental.constrained.trunc.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %trunc
}

define i32 @lrint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: lrint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq lrintl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
;
; X86-LABEL: lrint:
; X86:       # %bb.0: # %entry
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll lrintl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    retl
entry:
  %rint = call i32 @llvm.experimental.constrained.lrint.i32.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret i32 %rint
}

define i64 @llrint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: llrint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq llrintl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
;
; X86-LABEL: llrint:
; X86:       # %bb.0: # %entry
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll llrintl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    retl
entry:
  %rint = call i64 @llvm.experimental.constrained.llrint.i64.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret i64 %rint
}

define i32 @lround(fp128 %x) nounwind strictfp {
; CHECK-LABEL: lround:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq lroundl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
;
; X86-LABEL: lround:
; X86:       # %bb.0: # %entry
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll lroundl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    retl
entry:
  %round = call i32 @llvm.experimental.constrained.lround.i32.f128(fp128 %x, metadata !"fpexcept.strict") #0
  ret i32 %round
}

define i64 @llround(fp128 %x) nounwind strictfp {
; CHECK-LABEL: llround:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq llroundl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
;
; X86-LABEL: llround:
; X86:       # %bb.0: # %entry
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll llroundl
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    retl
entry:
  %round = call i64 @llvm.experimental.constrained.llround.i64.f128(fp128 %x, metadata !"fpexcept.strict") #0
  ret i64 %round
}

attributes #0 = { strictfp }

declare fp128 @llvm.experimental.constrained.fadd.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fsub.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fmul.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fdiv.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fma.f128(fp128, fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.frem.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.ceil.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.cos.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.exp.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.exp2.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.floor.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.log.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.log10.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.log2.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.maxnum.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.minnum.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.nearbyint.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.pow.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.powi.f128(fp128, i32, metadata, metadata)
declare fp128 @llvm.experimental.constrained.rint.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.round.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.sin.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.sqrt.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.trunc.f128(fp128, metadata, metadata)
declare i32 @llvm.experimental.constrained.lrint.i32.f128(fp128, metadata, metadata)
declare i64 @llvm.experimental.constrained.llrint.i64.f128(fp128, metadata, metadata)
declare i32 @llvm.experimental.constrained.lround.i32.f128(fp128, metadata)
declare i64 @llvm.experimental.constrained.llround.i64.f128(fp128, metadata)
