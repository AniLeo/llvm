; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+mmx \
; RUN:     -enable-legalize-types-checking | FileCheck %s
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+mmx \
; RUN:     -enable-legalize-types-checking | FileCheck %s

; Check all soft floating point library function calls.

define fp128 @add(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __addtf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
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
entry:
  %div = call fp128 @llvm.experimental.constrained.fdiv.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %div
}

attributes #0 = { strictfp }

declare fp128 @llvm.experimental.constrained.fadd.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fsub.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fmul.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fdiv.f128(fp128, fp128, metadata, metadata)
