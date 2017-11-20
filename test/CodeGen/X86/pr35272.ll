; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=skx | FileCheck %s

define <2 x i48> @PR35272(<2 x i64> %a0, <2 x i48> %a1, <2 x i48> %a2) {
; CHECK-LABEL: PR35272:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; CHECK-NEXT:    vpcmpeqq %xmm3, %xmm0, %k1
; CHECK-NEXT:    vpblendmq %xmm1, %xmm2, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %1 = icmp eq <2 x i64> %a0, zeroinitializer
  %2 = select <2 x i1> %1, <2 x i48> %a1, <2 x i48> %a2
  ret <2 x i48> %2
}
