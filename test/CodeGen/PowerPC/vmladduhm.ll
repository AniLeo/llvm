; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr9 -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mcpu=pwr9 -mtriple=powerpc64-ibm-aix-xcoff -vec-extabi < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mcpu=pwr8 -mtriple=powerpc64-ibm-aix-xcoff -vec-extabi < %s | FileCheck %s
define <8 x i16> @mul(<8 x i16> %m, <8 x i16> %n) {
; CHECK-LABEL: mul:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vxor 4, 4, 4
; CHECK-NEXT:    vmladduhm 2, 2, 3, 4
; CHECK-NEXT:    blr
entry:
  %0 = mul <8 x i16> %m, %n
  ret <8 x i16> %0
}

define <8 x i16> @madd(<8 x i16> %m, <8 x i16> %n, <8 x i16> %o) {
; CHECK-LABEL: madd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmladduhm 2, 2, 3, 4
; CHECK-NEXT:    blr
entry:
  %0 = mul <8 x i16> %m, %n
  %1 = add <8 x i16> %0, %o
  ret <8 x i16> %1
}
