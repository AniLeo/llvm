; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mcpu=generic -mattr=+avx < %s | FileCheck %s

; When commuting a VADDSDrr instruction, verify that the 'IsUndef' flag is
; correctly propagated to the operands of the resulting instruction.
; Test for PR23103;

declare zeroext i1 @foo(<1 x double>)

define <1 x double> @pr23103(ptr align 8 %Vp) {
; CHECK-LABEL: pr23103:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    callq foo@PLT
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %V = load <1 x double>, ptr %Vp, align 8
  %call = call zeroext i1 @foo(<1 x double> %V)
  %fadd = fadd <1 x double> %V, undef
  ret <1 x double> %fadd
}
