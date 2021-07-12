; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr7 -mattr=+altivec \
; RUN:     -vec-extabi -mtriple powerpc-ibm-aix-xcoff < %s | \
; RUN:   FileCheck %s --check-prefix=32BIT

; RUN: llc -verify-machineinstrs -mcpu=pwr7 -mattr=+altivec \
; RUN:     -vec-extabi -mtriple powerpc64-ibm-aix-xcoff < %s | \
; RUN:   FileCheck %s --check-prefix=64BIT
%struct.Test = type { double, double, double, double }

@__const.caller.t = private unnamed_addr constant %struct.Test { double 0.000000e+00, double 1.000000e+00, double 2.000000e+00, double 3.000000e+00 }, align 8

define double @caller() {
; 32BIT-LABEL: caller:
; 32BIT:       # %bb.0: # %entry
; 32BIT-NEXT:    mflr 0
; 32BIT-NEXT:    stw 0, 8(1)
; 32BIT-NEXT:    stwu 1, -192(1)
; 32BIT-NEXT:    lwz 3, L..C0(2) # @__const.caller.t
; 32BIT-NEXT:    li 4, 31
; 32BIT-NEXT:    xxlxor 0, 0, 0
; 32BIT-NEXT:    lwz 5, L..C1(2) # %const.0
; 32BIT-NEXT:    li 6, 512
; 32BIT-NEXT:    xxlxor 1, 1, 1
; 32BIT-NEXT:    xxlxor 2, 2, 2
; 32BIT-NEXT:    lvx 2, 3, 4
; 32BIT-NEXT:    li 4, 16
; 32BIT-NEXT:    lvsl 4, 0, 3
; 32BIT-NEXT:    xxlxor 37, 37, 37
; 32BIT-NEXT:    lvx 3, 3, 4
; 32BIT-NEXT:    li 4, 172
; 32BIT-NEXT:    lxvd2x 32, 0, 5
; 32BIT-NEXT:    xxlxor 38, 38, 38
; 32BIT-NEXT:    xxlxor 39, 39, 39
; 32BIT-NEXT:    li 5, 48
; 32BIT-NEXT:    vperm 2, 3, 2, 4
; 32BIT-NEXT:    xxlxor 40, 40, 40
; 32BIT-NEXT:    xxlxor 41, 41, 41
; 32BIT-NEXT:    xxlxor 42, 42, 42
; 32BIT-NEXT:    xxlxor 43, 43, 43
; 32BIT-NEXT:    xxlxor 44, 44, 44
; 32BIT-NEXT:    stxvw4x 34, 1, 4
; 32BIT-NEXT:    li 4, 120
; 32BIT-NEXT:    xxlxor 45, 45, 45
; 32BIT-NEXT:    lvx 2, 0, 3
; 32BIT-NEXT:    li 3, 156
; 32BIT-NEXT:    xxlxor 3, 3, 3
; 32BIT-NEXT:    xxlxor 4, 4, 4
; 32BIT-NEXT:    vperm 2, 2, 3, 4
; 32BIT-NEXT:    xxlxor 35, 35, 35
; 32BIT-NEXT:    xxlxor 36, 36, 36
; 32BIT-NEXT:    xxlxor 5, 5, 5
; 32BIT-NEXT:    xxlxor 6, 6, 6
; 32BIT-NEXT:    xxlxor 7, 7, 7
; 32BIT-NEXT:    stxvw4x 34, 1, 3
; 32BIT-NEXT:    li 3, 136
; 32BIT-NEXT:    xxlxor 34, 34, 34
; 32BIT-NEXT:    stxvw4x 0, 1, 3
; 32BIT-NEXT:    li 3, 104
; 32BIT-NEXT:    stxvw4x 0, 1, 4
; 32BIT-NEXT:    li 4, 256
; 32BIT-NEXT:    stxvw4x 0, 1, 3
; 32BIT-NEXT:    li 3, 88
; 32BIT-NEXT:    xxlxor 8, 8, 8
; 32BIT-NEXT:    xxlxor 9, 9, 9
; 32BIT-NEXT:    stxvw4x 0, 1, 3
; 32BIT-NEXT:    li 3, 72
; 32BIT-NEXT:    xxlxor 10, 10, 10
; 32BIT-NEXT:    stxvw4x 0, 1, 3
; 32BIT-NEXT:    li 3, 128
; 32BIT-NEXT:    xxlxor 11, 11, 11
; 32BIT-NEXT:    stxvd2x 32, 1, 5
; 32BIT-NEXT:    stw 6, 152(1)
; 32BIT-NEXT:    xxlxor 12, 12, 12
; 32BIT-NEXT:    xxlxor 13, 13, 13
; 32BIT-NEXT:    bl .callee[PR]
; 32BIT-NEXT:    nop
; 32BIT-NEXT:    addi 1, 1, 192
; 32BIT-NEXT:    lwz 0, 8(1)
; 32BIT-NEXT:    mtlr 0
; 32BIT-NEXT:    blr
;
; 64BIT-LABEL: caller:
; 64BIT:       # %bb.0: # %entry
; 64BIT-NEXT:    mflr 0
; 64BIT-NEXT:    std 0, 16(1)
; 64BIT-NEXT:    stdu 1, -224(1)
; 64BIT-NEXT:    ld 3, L..C0(2) # @__const.caller.t
; 64BIT-NEXT:    li 4, 16
; 64BIT-NEXT:    li 5, 144
; 64BIT-NEXT:    xxlxor 1, 1, 1
; 64BIT-NEXT:    li 6, 0
; 64BIT-NEXT:    xxlxor 2, 2, 2
; 64BIT-NEXT:    xxlxor 34, 34, 34
; 64BIT-NEXT:    lxvd2x 0, 3, 4
; 64BIT-NEXT:    li 4, 208
; 64BIT-NEXT:    xxlxor 35, 35, 35
; 64BIT-NEXT:    xxlxor 36, 36, 36
; 64BIT-NEXT:    xxlxor 37, 37, 37
; 64BIT-NEXT:    stxvd2x 0, 1, 4
; 64BIT-NEXT:    li 4, 160
; 64BIT-NEXT:    xxlxor 38, 38, 38
; 64BIT-NEXT:    lxvd2x 0, 0, 3
; 64BIT-NEXT:    li 3, 192
; 64BIT-NEXT:    xxlxor 39, 39, 39
; 64BIT-NEXT:    xxlxor 40, 40, 40
; 64BIT-NEXT:    xxlxor 41, 41, 41
; 64BIT-NEXT:    stxvd2x 0, 1, 3
; 64BIT-NEXT:    ld 3, L..C1(2) # %const.0
; 64BIT-NEXT:    xxlxor 0, 0, 0
; 64BIT-NEXT:    xxlxor 42, 42, 42
; 64BIT-NEXT:    stxvw4x 0, 1, 4
; 64BIT-NEXT:    li 4, 80
; 64BIT-NEXT:    xxlxor 43, 43, 43
; 64BIT-NEXT:    lxvd2x 13, 0, 3
; 64BIT-NEXT:    li 3, 128
; 64BIT-NEXT:    xxlxor 44, 44, 44
; 64BIT-NEXT:    stxvw4x 0, 1, 5
; 64BIT-NEXT:    xxlxor 45, 45, 45
; 64BIT-NEXT:    stxvw4x 0, 1, 3
; 64BIT-NEXT:    li 5, 512
; 64BIT-NEXT:    xxlxor 3, 3, 3
; 64BIT-NEXT:    xxlxor 4, 4, 4
; 64BIT-NEXT:    stxvd2x 13, 1, 4
; 64BIT-NEXT:    li 4, 256
; 64BIT-NEXT:    std 5, 184(1)
; 64BIT-NEXT:    xxlxor 5, 5, 5
; 64BIT-NEXT:    std 6, 176(1)
; 64BIT-NEXT:    xxlxor 6, 6, 6
; 64BIT-NEXT:    xxlxor 7, 7, 7
; 64BIT-NEXT:    xxlxor 8, 8, 8
; 64BIT-NEXT:    xxlxor 9, 9, 9
; 64BIT-NEXT:    xxlxor 10, 10, 10
; 64BIT-NEXT:    xxlxor 11, 11, 11
; 64BIT-NEXT:    xxlxor 12, 12, 12
; 64BIT-NEXT:    xxlxor 13, 13, 13
; 64BIT-NEXT:    bl .callee[PR]
; 64BIT-NEXT:    nop
; 64BIT-NEXT:    addi 1, 1, 224
; 64BIT-NEXT:    ld 0, 16(1)
; 64BIT-NEXT:    mtlr 0
; 64BIT-NEXT:    blr

  entry:
    %call = tail call double @callee(i32 signext 128, i32 signext 256, double 0.000000e+00, double 0.000000e+00, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 0.000000e+00, double 0.000000e+00>, <2 x double> <double 2.400000e+01, double 2.500000e+01>, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, i32 signext 512, %struct.Test* nonnull byval(%struct.Test) align 4 @__const.caller.t)
      ret double %call
}

declare double @callee(i32 signext, i32 signext, double, double, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, <2 x double>, double, double, double, double, double, double, double, double, double, double, double, i32 signext, %struct.Test* byval(%struct.Test) align 8)
