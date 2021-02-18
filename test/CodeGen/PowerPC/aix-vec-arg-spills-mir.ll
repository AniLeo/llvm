; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr7 -mattr=+altivec -vec-extabi \
; RUN:     -stop-after=machine-cp -mtriple powerpc-ibm-aix-xcoff < %s | \
; RUN:   FileCheck %s --check-prefix=MIR32

; RUN: llc -verify-machineinstrs -mcpu=pwr7 -mattr=+altivec -vec-extabi \
; RUN:     -stop-after=machine-cp -mtriple powerpc64-ibm-aix-xcoff < %s | \
; RUN:   FileCheck %s --check-prefix=MIR64

%struct.Test = type { double, double, double, double }

@__const.caller.t = private unnamed_addr constant %struct.Test { double 0.000000e+00, double 1.000000e+00, double 2.000000e+00, double 3.000000e+00 }, align 8

define double @caller() {
; MIR32-LABEL: name: caller
; MIR32: bb.0.entry:
; MIR32:   renamable $r3 = LWZtoc @__const.caller.t, $r2 :: (load 4 from got)
; MIR32:   renamable $r4 = LI 31
; MIR32:   renamable $v2 = LVX renamable $r3, killed renamable $r4
; MIR32:   renamable $r4 = LI 16
; MIR32:   renamable $v3 = LVX renamable $r3, killed renamable $r4
; MIR32:   renamable $v4 = LVSL $zero, renamable $r3
; MIR32:   renamable $v2 = VPERM renamable $v3, killed renamable $v2, renamable $v4
; MIR32:   renamable $r4 = LI 172
; MIR32:   STXVW4X killed renamable $v2, $r1, killed renamable $r4 :: (store 16 + 16, align 4)
; MIR32:   renamable $v2 = LVX $zero, killed renamable $r3
; MIR32:   renamable $v2 = VPERM killed renamable $v2, killed renamable $v3, killed renamable $v4
; MIR32:   renamable $r3 = LI 156
; MIR32:   STXVW4X killed renamable $v2, $r1, killed renamable $r3 :: (store 16, align 4)
; MIR32:   ADJCALLSTACKDOWN 188, 0, implicit-def dead $r1, implicit $r1
; MIR32:   renamable $vsl0 = XXLXORz
; MIR32:   $f1 = XXLXORdpz
; MIR32:   $f2 = XXLXORdpz
; MIR32:   $v2 = XXLXORz
; MIR32:   $v3 = XXLXORz
; MIR32:   $v4 = XXLXORz
; MIR32:   $v5 = XXLXORz
; MIR32:   $v6 = XXLXORz
; MIR32:   $v7 = XXLXORz
; MIR32:   $v8 = XXLXORz
; MIR32:   $v9 = XXLXORz
; MIR32:   $v10 = XXLXORz
; MIR32:   $v11 = XXLXORz
; MIR32:   $v12 = XXLXORz
; MIR32:   $v13 = XXLXORz
; MIR32:   $f3 = XXLXORdpz
; MIR32:   $f4 = XXLXORdpz
; MIR32:   $f5 = XXLXORdpz
; MIR32:   $f6 = XXLXORdpz
; MIR32:   $f7 = XXLXORdpz
; MIR32:   renamable $r3 = LI 136
; MIR32:   $f8 = XXLXORdpz
; MIR32:   renamable $r4 = LI 120
; MIR32:   renamable $r5 = LWZtoc %const.0, $r2 :: (load 4 from got)
; MIR32:   STXVW4X renamable $vsl0, $r1, killed renamable $r3 :: (store 16, align 8)
; MIR32:   $f9 = XXLXORdpz
; MIR32:   renamable $r3 = LI 104
; MIR32:   STXVW4X renamable $vsl0, $r1, killed renamable $r4 :: (store 16, align 8)
; MIR32:   $f10 = XXLXORdpz
; MIR32:   STXVW4X renamable $vsl0, $r1, killed renamable $r3 :: (store 16, align 8)
; MIR32:   renamable $r3 = LI 88
; MIR32:   $f11 = XXLXORdpz
; MIR32:   STXVW4X renamable $vsl0, $r1, killed renamable $r3 :: (store 16, align 8)
; MIR32:   renamable $r3 = LI 72
; MIR32:   renamable $v0 = LXVD2X $zero, killed renamable $r5 :: (load 16 from constant-pool)
; MIR32:   $f12 = XXLXORdpz
; MIR32:   STXVW4X killed renamable $vsl0, $r1, killed renamable $r3 :: (store 16, align 8)
; MIR32:   $f13 = XXLXORdpz
; MIR32:   renamable $r5 = LI 48
; MIR32:   renamable $r6 = LI 512
; MIR32:   $r3 = LI 128
; MIR32:   $r4 = LI 256
; MIR32:   STXVD2X killed renamable $v0, $r1, killed renamable $r5 :: (store 16)
; MIR32:   STW killed renamable $r6, 152, $r1 :: (store 4)
; MIR32:   BL_NOP <mcsymbol .callee[PR]>, csr_aix32_altivec, implicit-def dead $lr, implicit $rm, implicit $r3, implicit $r4, implicit $f1, implicit $f2, implicit $v2, implicit $v3, implicit $v4, implicit $v5, implicit killed $v6, implicit killed $v7, implicit killed $v8, implicit killed $v9, implicit killed $v10, implicit killed $v11, implicit killed $v12, implicit killed $v13, implicit $f3, implicit $f4, implicit $f5, implicit $f6, implicit $f7, implicit $f8, implicit $f9, implicit $f10, implicit $f11, implicit $f12, implicit $f13, implicit $r2, implicit-def $r1, implicit-def $f1
; MIR32:   ADJCALLSTACKUP 188, 0, implicit-def dead $r1, implicit $r1
; MIR32:   BLR implicit $lr, implicit $rm, implicit $f1

; MIR64-LABEL: name: caller
; MIR64: bb.0.entry:
; MIR64:   renamable $x3 = LDtoc @__const.caller.t, $x2 :: (load 8 from got)
; MIR64:   renamable $x4 = LI8 16
; MIR64:   renamable $vsl0 = LXVD2X renamable $x3, killed renamable $x4 :: (load 16 + 16, align 8)
; MIR64:   renamable $x4 = LI8 208
; MIR64:   STXVD2X killed renamable $vsl0, $x1, killed renamable $x4 :: (store 16 + 16, align 4)
; MIR64:   renamable $vsl0 = LXVD2X $zero8, killed renamable $x3 :: (load 16, align 8)
; MIR64:   renamable $x3 = LI8 192
; MIR64:   STXVD2X killed renamable $vsl0, $x1, killed renamable $x3 :: (store 16, align 4)
; MIR64:   ADJCALLSTACKDOWN 224, 0, implicit-def dead $r1, implicit $r1
; MIR64:   $f1 = XXLXORdpz
; MIR64:   $f2 = XXLXORdpz
; MIR64:   $v2 = XXLXORz
; MIR64:   $v3 = XXLXORz
; MIR64:   $v4 = XXLXORz
; MIR64:   $v5 = XXLXORz
; MIR64:   $v6 = XXLXORz
; MIR64:   $v7 = XXLXORz
; MIR64:   $v8 = XXLXORz
; MIR64:   $v9 = XXLXORz
; MIR64:   $v10 = XXLXORz
; MIR64:   $v11 = XXLXORz
; MIR64:   $v12 = XXLXORz
; MIR64:   $v13 = XXLXORz
; MIR64:   $f3 = XXLXORdpz
; MIR64:   renamable $x3 = LDtocCPT %const.0, $x2 :: (load 8 from got)
; MIR64:   $f4 = XXLXORdpz
; MIR64:   $f5 = XXLXORdpz
; MIR64:   $f6 = XXLXORdpz
; MIR64:   renamable $x4 = LDtocCPT %const.1, $x2 :: (load 8 from got)
; MIR64:   renamable $vsl0 = LXVD2X $zero8, killed renamable $x3 :: (load 16 from constant-pool)
; MIR64:   $f7 = XXLXORdpz
; MIR64:   $f8 = XXLXORdpz
; MIR64:   renamable $x3 = LI8 160
; MIR64:   $f9 = XXLXORdpz
; MIR64:   renamable $x5 = LI8 144
; MIR64:   renamable $vsl13 = LXVD2X $zero8, killed renamable $x4 :: (load 16 from constant-pool)
; MIR64:   STXVD2X renamable $vsl0, $x1, killed renamable $x3 :: (store 16, align 8)
; MIR64:   $f10 = XXLXORdpz
; MIR64:   renamable $x3 = LI8 128
; MIR64:   STXVD2X renamable $vsl0, $x1, killed renamable $x5 :: (store 16, align 8)
; MIR64:   $f11 = XXLXORdpz
; MIR64:   renamable $x4 = LI8 80
; MIR64:   STXVD2X killed renamable $vsl0, $x1, killed renamable $x3 :: (store 16, align 8)
; MIR64:   $f12 = XXLXORdpz
; MIR64:   STXVD2X killed renamable $vsl13, $x1, killed renamable $x4 :: (store 16)
; MIR64:   $f13 = XXLXORdpz
; MIR64:   renamable $x5 = LI8 512
; MIR64:   renamable $x6 = LI8 0
; MIR64:   $x3 = LI8 128
; MIR64:   $x4 = LI8 256
; MIR64:   STD killed renamable $x5, 184, $x1 :: (store 8)
; MIR64:   STD killed renamable $x6, 176, $x1 :: (store 8)
; MIR64:   BL8_NOP <mcsymbol .callee[PR]>, csr_ppc64_altivec, implicit-def dead $lr8, implicit $rm, implicit $x3, implicit $x4, implicit $f1, implicit $f2, implicit killed $v2, implicit killed $v3, implicit killed $v4, implicit killed $v5, implicit killed $v6, implicit killed $v7, implicit killed $v8, implicit killed $v9, implicit killed $v10, implicit killed $v11, implicit killed $v12, implicit killed $v13, implicit $f3, implicit $f4, implicit $f5, implicit $f6, implicit $f7, implicit $f8, implicit $f9, implicit $f10, implicit $f11, implicit $f12, implicit $f13, implicit $x2, implicit-def $r1, implicit-def $f1
; MIR64:   ADJCALLSTACKUP 224, 0, implicit-def dead $r1, implicit $r1
; MIR64:   BLR8 implicit $lr8, implicit $rm, implicit $f1
  entry:
    %call = tail call double @callee(i32 signext 128, i32 signext 256, double 0.000000e+00, double 0.000000e+00, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 2.400000e+01, double 2.500000e+01>, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, i32 signext 512, %struct.Test* nonnull byval(%struct.Test) align 4 @__const.caller.t)
      ret double %call
}

declare double @callee(i32 signext, i32 signext, double, double, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, double, double, double, double, double, double, double, double, double, double, double, i32 signext, %struct.Test* byval(%struct.Test) align 8)
