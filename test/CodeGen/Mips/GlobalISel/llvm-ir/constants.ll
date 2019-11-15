; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel  -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32

define i64 @any_i64() {
; MIPS32-LABEL: any_i64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ori $2, $zero, 0
; MIPS32-NEXT:    lui $3, 32768
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i64 -9223372036854775808
}

define i32 @any_i32() {
; MIPS32-LABEL: any_i32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lui $2, 32768
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i32 -2147483648
}

define signext i16 @signed_i16() {
; MIPS32-LABEL: signed_i16:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $1, $zero, 32768
; MIPS32-NEXT:    sll $1, $1, 16
; MIPS32-NEXT:    sra $2, $1, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i16 -32768
}

define signext i8 @signed_i8() {
; MIPS32-LABEL: signed_i8:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $1, $zero, 65408
; MIPS32-NEXT:    sll $1, $1, 24
; MIPS32-NEXT:    sra $2, $1, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i8 -128
}

define zeroext i16 @unsigned_i16() {
; MIPS32-LABEL: unsigned_i16:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $1, $zero, 32768
; MIPS32-NEXT:    andi $2, $1, 65535
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i16 -32768
}

define zeroext i8 @unsigned_i8() {
; MIPS32-LABEL: unsigned_i8:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $1, $zero, 65408
; MIPS32-NEXT:    andi $2, $1, 255
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i8 -128
}

define zeroext i1 @i1_true() {
; MIPS32-LABEL: i1_true:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $1, $zero, 65535
; MIPS32-NEXT:    andi $2, $1, 1
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i1 true
}

define zeroext i1 @i1_false() {
; MIPS32-LABEL: i1_false:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ori $1, $zero, 0
; MIPS32-NEXT:    andi $2, $1, 1
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i1 false
}

define i32 @_0xABCD0000() {
; MIPS32-LABEL: _0xABCD0000:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lui $2, 43981
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i32 -1412628480
}

define i32 @_0x00008000() {
; MIPS32-LABEL: _0x00008000:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ori $2, $zero, 32768
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i32 32768
}

define i32 @_0xFFFFFFF6() {
; MIPS32-LABEL: _0xFFFFFFF6:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $2, $zero, 65526
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i32 -10
}

define i32 @_0x0A0B0C0D() {
; MIPS32-LABEL: _0x0A0B0C0D:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lui $1, 2571
; MIPS32-NEXT:    ori $2, $1, 3085
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  ret i32 168496141
}
