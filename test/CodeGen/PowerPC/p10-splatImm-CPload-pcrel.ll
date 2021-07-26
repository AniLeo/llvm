; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | FileCheck %s --check-prefixes=CHECK-LE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | FileCheck %s \
; RUN:     --check-prefixes=CHECK-NOPCREL-BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -mattr=-pcrelative-memops -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s --check-prefixes=CHECK-NOPCREL-LE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -mattr=-prefix-instrs -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s --check-prefixes=CHECK-NOPREFIX
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -target-abi=elfv2 -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s --check-prefixes=CHECK-BE

define dso_local <2 x double> @testDoubleToDoubleFail() local_unnamed_addr {
; CHECK-LE-LABEL: testDoubleToDoubleFail:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xxsplti32dx vs34, 0, 1081435463
; CHECK-LE-NEXT:    xxsplti32dx vs34, 1, -1374389535
; CHECK-LE-NEXT:    blr
;
; CHECK-NOPCREL-BE-LABEL: testDoubleToDoubleFail:
; CHECK-NOPCREL-BE:       # %bb.0: # %entry
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs34, 0, 1081435463
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs34, 1, -1374389535
; CHECK-NOPCREL-BE-NEXT:    blr
;
; CHECK-NOPCREL-LE-LABEL: testDoubleToDoubleFail:
; CHECK-NOPCREL-LE:       # %bb.0: # %entry
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs34, 0, 1081435463
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs34, 1, -1374389535
; CHECK-NOPCREL-LE-NEXT:    blr
;
; CHECK-NOPREFIX-LABEL: testDoubleToDoubleFail:
; CHECK-NOPREFIX:       # %bb.0: # %entry
; CHECK-NOPREFIX-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-NOPREFIX-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-NOPREFIX-NEXT:    lxv vs34, 0(r3)
; CHECK-NOPREFIX-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleToDoubleFail:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxsplti32dx vs34, 0, 1081435463
; CHECK-BE-NEXT:    xxsplti32dx vs34, 1, -1374389535
; CHECK-BE-NEXT:    blr
entry:
  ret <2 x double> <double 3.423300e+02, double 3.423300e+02>
}

define dso_local <2 x double> @testFloatDenormToDouble() local_unnamed_addr {
; CHECK-LE-LABEL: testFloatDenormToDouble:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xxsplti32dx vs34, 0, 940259579
; CHECK-LE-NEXT:    xxsplti32dx vs34, 1, -2147483648
; CHECK-LE-NEXT:    blr
;
; CHECK-NOPCREL-BE-LABEL: testFloatDenormToDouble:
; CHECK-NOPCREL-BE:       # %bb.0: # %entry
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs34, 0, 940259579
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs34, 1, -2147483648
; CHECK-NOPCREL-BE-NEXT:    blr
;
; CHECK-NOPCREL-LE-LABEL: testFloatDenormToDouble:
; CHECK-NOPCREL-LE:       # %bb.0: # %entry
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs34, 0, 940259579
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs34, 1, -2147483648
; CHECK-NOPCREL-LE-NEXT:    blr
;
; CHECK-NOPREFIX-LABEL: testFloatDenormToDouble:
; CHECK-NOPREFIX:       # %bb.0: # %entry
; CHECK-NOPREFIX-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-NOPREFIX-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-NOPREFIX-NEXT:    lxv vs34, 0(r3)
; CHECK-NOPREFIX-NEXT:    blr
;
; CHECK-BE-LABEL: testFloatDenormToDouble:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxsplti32dx vs34, 0, 940259579
; CHECK-BE-NEXT:    xxsplti32dx vs34, 1, -2147483648
; CHECK-BE-NEXT:    blr
entry:
  ret <2 x double> <double 0x380B38FB80000000, double 0x380B38FB80000000>
}

define dso_local <2 x double> @testDoubleToDoubleNaNFail() local_unnamed_addr {
; CHECK-LE-LABEL: testDoubleToDoubleNaNFail:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xxsplti32dx vs34, 0, -1
; CHECK-LE-NEXT:    xxsplti32dx vs34, 1, -16
; CHECK-LE-NEXT:    blr
;
; CHECK-NOPCREL-BE-LABEL: testDoubleToDoubleNaNFail:
; CHECK-NOPCREL-BE:       # %bb.0: # %entry
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs34, 0, -1
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs34, 1, -16
; CHECK-NOPCREL-BE-NEXT:    blr
;
; CHECK-NOPCREL-LE-LABEL: testDoubleToDoubleNaNFail:
; CHECK-NOPCREL-LE:       # %bb.0: # %entry
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs34, 0, -1
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs34, 1, -16
; CHECK-NOPCREL-LE-NEXT:    blr
;
; CHECK-NOPREFIX-LABEL: testDoubleToDoubleNaNFail:
; CHECK-NOPREFIX:       # %bb.0: # %entry
; CHECK-NOPREFIX-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-NOPREFIX-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-NOPREFIX-NEXT:    lxv vs34, 0(r3)
; CHECK-NOPREFIX-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleToDoubleNaNFail:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxsplti32dx vs34, 0, -1
; CHECK-BE-NEXT:    xxsplti32dx vs34, 1, -16
; CHECK-BE-NEXT:    blr
entry:
  ret <2 x double> <double 0xFFFFFFFFFFFFFFF0, double 0xFFFFFFFFFFFFFFF0>
}

define dso_local double @testDoubleNonRepresentableScalar() local_unnamed_addr {
; CHECK-LE-LABEL: testDoubleNonRepresentableScalar:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xxsplti32dx vs1, 0, 1081435463
; CHECK-LE-NEXT:    xxsplti32dx vs1, 1, -1374389535
; CHECK-LE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-LE-NEXT:    blr
;
; CHECK-NOPCREL-BE-LABEL: testDoubleNonRepresentableScalar:
; CHECK-NOPCREL-BE:       # %bb.0: # %entry
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs1, 0, 1081435463
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs1, 1, -1374389535
; CHECK-NOPCREL-BE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-NOPCREL-BE-NEXT:    blr
;
; CHECK-NOPCREL-LE-LABEL: testDoubleNonRepresentableScalar:
; CHECK-NOPCREL-LE:       # %bb.0: # %entry
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs1, 0, 1081435463
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs1, 1, -1374389535
; CHECK-NOPCREL-LE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-NOPCREL-LE-NEXT:    blr
;
; CHECK-NOPREFIX-LABEL: testDoubleNonRepresentableScalar:
; CHECK-NOPREFIX:       # %bb.0: # %entry
; CHECK-NOPREFIX-NEXT:    addis r3, r2, .LCPI3_0@toc@ha
; CHECK-NOPREFIX-NEXT:    lfd f1, .LCPI3_0@toc@l(r3)
; CHECK-NOPREFIX-NEXT:    blr
;
; CHECK-BE-LABEL: testDoubleNonRepresentableScalar:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxsplti32dx vs1, 0, 1081435463
; CHECK-BE-NEXT:    xxsplti32dx vs1, 1, -1374389535
; CHECK-BE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-BE-NEXT:    blr
entry:
  ret double 3.423300e+02
}

define dso_local float @testFloatDenormScalar() local_unnamed_addr {
; CHECK-LE-LABEL: testFloatDenormScalar:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-LE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-LE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-LE-NEXT:    blr
;
; CHECK-NOPCREL-BE-LABEL: testFloatDenormScalar:
; CHECK-NOPCREL-BE:       # %bb.0: # %entry
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-NOPCREL-BE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-NOPCREL-BE-NEXT:    blr
;
; CHECK-NOPCREL-LE-LABEL: testFloatDenormScalar:
; CHECK-NOPCREL-LE:       # %bb.0: # %entry
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-NOPCREL-LE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-NOPCREL-LE-NEXT:    blr
;
; CHECK-NOPREFIX-LABEL: testFloatDenormScalar:
; CHECK-NOPREFIX:       # %bb.0: # %entry
; CHECK-NOPREFIX-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-NOPREFIX-NEXT:    lfs f1, .LCPI4_0@toc@l(r3)
; CHECK-NOPREFIX-NEXT:    blr
;
; CHECK-BE-LABEL: testFloatDenormScalar:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-BE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-BE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-BE-NEXT:    blr
entry:
  ret float 0x380B38FB80000000
}

define dso_local double @testFloatDenormToDoubleScalar() local_unnamed_addr {
; CHECK-LE-LABEL: testFloatDenormToDoubleScalar:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-LE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-LE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-LE-NEXT:    blr
;
; CHECK-NOPCREL-BE-LABEL: testFloatDenormToDoubleScalar:
; CHECK-NOPCREL-BE:       # %bb.0: # %entry
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-NOPCREL-BE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-NOPCREL-BE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-NOPCREL-BE-NEXT:    blr
;
; CHECK-NOPCREL-LE-LABEL: testFloatDenormToDoubleScalar:
; CHECK-NOPCREL-LE:       # %bb.0: # %entry
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-NOPCREL-LE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-NOPCREL-LE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-NOPCREL-LE-NEXT:    blr
;
; CHECK-NOPREFIX-LABEL: testFloatDenormToDoubleScalar:
; CHECK-NOPREFIX:       # %bb.0: # %entry
; CHECK-NOPREFIX-NEXT:    addis r3, r2, .LCPI5_0@toc@ha
; CHECK-NOPREFIX-NEXT:    lfs f1, .LCPI5_0@toc@l(r3)
; CHECK-NOPREFIX-NEXT:    blr
;
; CHECK-BE-LABEL: testFloatDenormToDoubleScalar:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxsplti32dx vs1, 0, 940259579
; CHECK-BE-NEXT:    xxsplti32dx vs1, 1, -2147483648
; CHECK-BE-NEXT:    # kill: def $f1 killed $f1 killed $vsl1
; CHECK-BE-NEXT:    blr
entry:
  ret double 0x380B38FB80000000
}
