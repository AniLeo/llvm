; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | FileCheck %s \
; RUN:     --check-prefix=CHECK-NOPCREL
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -mattr=-pcrelative-memops -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s --check-prefix=CHECK-NOPCREL
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -mattr=-prefix-instrs -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s --check-prefix=CHECK-NOPCREL
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -target-abi=elfv2 -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s

define dso_local <2 x double> @testDoubleToDoubleFail() local_unnamed_addr {
; CHECK-LABEL: testDoubleToDoubleFail:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plxv vs34, .LCPI0_0@PCREL(0), 1
; CHECK-NEXT:    blr
;
; CHECK-NOPCREL-LABEL: testDoubleToDoubleFail:
; CHECK-NOPCREL:       # %bb.0: # %entry
; CHECK-NOPCREL-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-NOPCREL-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-NOPCREL-NEXT:    lxvx vs34, 0, r3
; CHECK-NOPCREL-NEXT:    blr

entry:
  ret <2 x double> <double 3.423300e+02, double 3.423300e+02>
}

define dso_local <2 x double> @testFloatDenormToDouble() local_unnamed_addr {
; CHECK-LABEL: testFloatDenormToDouble:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plxv vs34, .LCPI1_0@PCREL(0), 1
; CHECK-NEXT:    blr
;
; CHECK-NOPCREL-LABEL: testFloatDenormToDouble:
; CHECK-NOPCREL:       # %bb.0: # %entry
; CHECK-NOPCREL-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-NOPCREL-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-NOPCREL-NEXT:    lxvx vs34, 0, r3
; CHECK-NOPCREL-NEXT:    blr

entry:
  ret <2 x double> <double 0x380B38FB80000000, double 0x380B38FB80000000>
}

define dso_local <2 x double> @testDoubleToDoubleNaNFail() local_unnamed_addr {
; CHECK-LABEL: testDoubleToDoubleNaNFail:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plxv vs34, .LCPI2_0@PCREL(0), 1
; CHECK-NEXT:    blr
;
; CHECK-NOPCREL-LABEL: testDoubleToDoubleNaNFail:
; CHECK-NOPCREL:       # %bb.0: # %entry
; CHECK-NOPCREL-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-NOPCREL-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-NOPCREL-NEXT:    lxvx vs34, 0, r3
; CHECK-NOPCREL-NEXT:    blr

entry:
  ret <2 x double> <double 0xFFFFFFFFFFFFFFF0, double 0xFFFFFFFFFFFFFFF0>
}

define dso_local double @testDoubleNonRepresentableScalar() local_unnamed_addr {
; CHECK-LABEL: testDoubleNonRepresentableScalar:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plfd f1, .LCPI3_0@PCREL(0), 1
; CHECK-NEXT:    blr
;
; CHECK-NOPCREL-LABEL: testDoubleNonRepresentableScalar:
; CHECK-NOPCREL:       # %bb.0: # %entry
; CHECK-NOPCREL-NEXT:    addis r3, r2, .LCPI3_0@toc@ha
; CHECK-NOPCREL-NEXT:    lfd f1, .LCPI3_0@toc@l(r3)
; CHECK-NOPCREL-NEXT:    blr

entry:
  ret double 3.423300e+02
}

define dso_local float @testFloatDenormScalar() local_unnamed_addr {
; CHECK-LABEL: testFloatDenormScalar:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plfs f1, .LCPI4_0@PCREL(0), 1
; CHECK-NEXT:    blr
;
; CHECK-NOPCREL-LABEL: testFloatDenormScalar:
; CHECK-NOPCREL:       # %bb.0: # %entry
; CHECK-NOPCREL-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-NOPCREL-NEXT:    lfs f1, .LCPI4_0@toc@l(r3)
; CHECK-NOPCREL-NEXT:    blr

entry:
  ret float 0x380B38FB80000000
}

define dso_local double @testFloatDenormToDoubleScalar() local_unnamed_addr {
; CHECK-LABEL: testFloatDenormToDoubleScalar:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    plfs f1, .LCPI5_0@PCREL(0), 1
; CHECK-NEXT:    blr
;
; CHECK-NOPCREL-LABEL: testFloatDenormToDoubleScalar:
; CHECK-NOPCREL:       # %bb.0: # %entry
; CHECK-NOPCREL-NEXT:    addis r3, r2, .LCPI5_0@toc@ha
; CHECK-NOPCREL-NEXT:    lfs f1, .LCPI5_0@toc@l(r3)
; CHECK-NOPCREL-NEXT:    blr

entry:
  ret double 0x380B38FB80000000
}
