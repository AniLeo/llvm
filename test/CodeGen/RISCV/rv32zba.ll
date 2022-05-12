; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=CHECK,RV32I
; RUN: llc -mtriple=riscv32 -mattr=+m,+zba -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=CHECK,RV32ZBA

define signext i16 @sh1add(i64 %0, i16* %1) {
; RV32I-LABEL: sh1add:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    lh a0, 0(a0)
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: sh1add:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a0, a0, a2
; RV32ZBA-NEXT:    lh a0, 0(a0)
; RV32ZBA-NEXT:    ret
  %3 = getelementptr inbounds i16, i16* %1, i64 %0
  %4 = load i16, i16* %3
  ret i16 %4
}

define i32 @sh2add(i64 %0, i32* %1) {
; RV32I-LABEL: sh2add:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 2
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: sh2add:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a0, a0, a2
; RV32ZBA-NEXT:    lw a0, 0(a0)
; RV32ZBA-NEXT:    ret
  %3 = getelementptr inbounds i32, i32* %1, i64 %0
  %4 = load i32, i32* %3
  ret i32 %4
}

define i64 @sh3add(i64 %0, i64* %1) {
; RV32I-LABEL: sh3add:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 3
; RV32I-NEXT:    add a1, a2, a0
; RV32I-NEXT:    lw a0, 0(a1)
; RV32I-NEXT:    lw a1, 4(a1)
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: sh3add:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a1, a0, a2
; RV32ZBA-NEXT:    lw a0, 0(a1)
; RV32ZBA-NEXT:    lw a1, 4(a1)
; RV32ZBA-NEXT:    ret
  %3 = getelementptr inbounds i64, i64* %1, i64 %0
  %4 = load i64, i64* %3
  ret i64 %4
}

define i32 @addmul6(i32 %a, i32 %b) {
; RV32I-LABEL: addmul6:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 6
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul6:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a0, a0, a0
; RV32ZBA-NEXT:    sh1add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 6
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul10(i32 %a, i32 %b) {
; RV32I-LABEL: addmul10:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 10
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul10:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a0, a0, a0
; RV32ZBA-NEXT:    sh1add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 10
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul12(i32 %a, i32 %b) {
; RV32I-LABEL: addmul12:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 12
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul12:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a0, a0, a0
; RV32ZBA-NEXT:    sh2add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 12
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul18(i32 %a, i32 %b) {
; RV32I-LABEL: addmul18:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 18
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul18:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    sh1add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 18
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul20(i32 %a, i32 %b) {
; RV32I-LABEL: addmul20:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 20
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul20:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a0, a0, a0
; RV32ZBA-NEXT:    sh2add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 20
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul24(i32 %a, i32 %b) {
; RV32I-LABEL: addmul24:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 24
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul24:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a0, a0, a0
; RV32ZBA-NEXT:    sh3add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 24
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul36(i32 %a, i32 %b) {
; RV32I-LABEL: addmul36:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 36
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul36:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    sh2add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 36
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul40(i32 %a, i32 %b) {
; RV32I-LABEL: addmul40:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 40
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul40:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a0, a0, a0
; RV32ZBA-NEXT:    sh3add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 40
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul72(i32 %a, i32 %b) {
; RV32I-LABEL: addmul72:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 72
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addmul72:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    sh3add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 72
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @mul96(i32 %a) {
; RV32I-LABEL: mul96:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 96
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul96:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a0, a0, a0
; RV32ZBA-NEXT:    slli a0, a0, 5
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 96
  ret i32 %c
}

define i32 @mul160(i32 %a) {
; RV32I-LABEL: mul160:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 160
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul160:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a0, a0, a0
; RV32ZBA-NEXT:    slli a0, a0, 5
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 160
  ret i32 %c
}

define i32 @mul288(i32 %a) {
; RV32I-LABEL: mul288:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 288
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul288:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    slli a0, a0, 5
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 288
  ret i32 %c
}

define i32 @mul258(i32 %a) {
; CHECK-LABEL: mul258:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 258
; CHECK-NEXT:    mul a0, a0, a1
; CHECK-NEXT:    ret
  %c = mul i32 %a, 258
  ret i32 %c
}

define i32 @mul260(i32 %a) {
; CHECK-LABEL: mul260:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 260
; CHECK-NEXT:    mul a0, a0, a1
; CHECK-NEXT:    ret
  %c = mul i32 %a, 260
  ret i32 %c
}

define i32 @mul264(i32 %a) {
; CHECK-LABEL: mul264:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 264
; CHECK-NEXT:    mul a0, a0, a1
; CHECK-NEXT:    ret
  %c = mul i32 %a, 264
  ret i32 %c
}

define i32 @mul11(i32 %a) {
; RV32I-LABEL: mul11:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 11
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul11:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a1, a0, a0
; RV32ZBA-NEXT:    sh1add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 11
  ret i32 %c
}

define i32 @mul19(i32 %a) {
; RV32I-LABEL: mul19:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 19
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul19:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a1, a0, a0
; RV32ZBA-NEXT:    sh1add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 19
  ret i32 %c
}

define i32 @mul13(i32 %a) {
; RV32I-LABEL: mul13:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 13
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul13:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a1, a0, a0
; RV32ZBA-NEXT:    sh2add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 13
  ret i32 %c
}

define i32 @mul21(i32 %a) {
; RV32I-LABEL: mul21:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 21
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul21:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a1, a0, a0
; RV32ZBA-NEXT:    sh2add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 21
  ret i32 %c
}

define i32 @mul37(i32 %a) {
; RV32I-LABEL: mul37:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 37
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul37:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a1, a0, a0
; RV32ZBA-NEXT:    sh2add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 37
  ret i32 %c
}

define i32 @mul25(i32 %a) {
; RV32I-LABEL: mul25:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 25
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul25:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a1, a0, a0
; RV32ZBA-NEXT:    sh3add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 25
  ret i32 %c
}

define i32 @mul41(i32 %a) {
; RV32I-LABEL: mul41:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 41
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul41:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a1, a0, a0
; RV32ZBA-NEXT:    sh3add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 41
  ret i32 %c
}

define i32 @mul73(i32 %a) {
; RV32I-LABEL: mul73:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 73
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul73:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a1, a0, a0
; RV32ZBA-NEXT:    sh3add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 73
  ret i32 %c
}

define i32 @mul27(i32 %a) {
; RV32I-LABEL: mul27:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 27
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul27:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    sh1add a0, a0, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 27
  ret i32 %c
}

define i32 @mul45(i32 %a) {
; RV32I-LABEL: mul45:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 45
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul45:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    sh2add a0, a0, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 45
  ret i32 %c
}

define i32 @mul81(i32 %a) {
; RV32I-LABEL: mul81:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 81
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul81:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    sh3add a0, a0, a0
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 81
  ret i32 %c
}

define i32 @mul4098(i32 %a) {
; RV32I-LABEL: mul4098:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 1
; RV32I-NEXT:    addi a1, a1, 2
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul4098:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    slli a1, a0, 12
; RV32ZBA-NEXT:    sh1add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 4098
  ret i32 %c
}

define i32 @mul4100(i32 %a) {
; RV32I-LABEL: mul4100:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 1
; RV32I-NEXT:    addi a1, a1, 4
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul4100:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    slli a1, a0, 12
; RV32ZBA-NEXT:    sh2add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 4100
  ret i32 %c
}

define i32 @mul4104(i32 %a) {
; RV32I-LABEL: mul4104:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 1
; RV32I-NEXT:    addi a1, a1, 8
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: mul4104:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    slli a1, a0, 12
; RV32ZBA-NEXT:    sh3add a0, a0, a1
; RV32ZBA-NEXT:    ret
  %c = mul i32 %a, 4104
  ret i32 %c
}

define i32 @add4104(i32 %a) {
; RV32I-LABEL: add4104:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 1
; RV32I-NEXT:    addi a1, a1, 8
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: add4104:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    li a1, 1026
; RV32ZBA-NEXT:    sh2add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = add i32 %a, 4104
  ret i32 %c
}

define i32 @add8208(i32 %a) {
; RV32I-LABEL: add8208:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 2
; RV32I-NEXT:    addi a1, a1, 16
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: add8208:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    li a1, 1026
; RV32ZBA-NEXT:    sh3add a0, a1, a0
; RV32ZBA-NEXT:    ret
  %c = add i32 %a, 8208
  ret i32 %c
}

define i32 @addshl_5_6(i32 %a, i32 %b) {
; RV32I-LABEL: addshl_5_6:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 5
; RV32I-NEXT:    slli a1, a1, 6
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addshl_5_6:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh1add a0, a1, a0
; RV32ZBA-NEXT:    slli a0, a0, 5
; RV32ZBA-NEXT:    ret
  %c = shl i32 %a, 5
  %d = shl i32 %b, 6
  %e = add i32 %c, %d
  ret i32 %e
}

define i32 @addshl_5_7(i32 %a, i32 %b) {
; RV32I-LABEL: addshl_5_7:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 5
; RV32I-NEXT:    slli a1, a1, 7
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addshl_5_7:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh2add a0, a1, a0
; RV32ZBA-NEXT:    slli a0, a0, 5
; RV32ZBA-NEXT:    ret
  %c = shl i32 %a, 5
  %d = shl i32 %b, 7
  %e = add i32 %c, %d
  ret i32 %e
}

define i32 @addshl_5_8(i32 %a, i32 %b) {
; RV32I-LABEL: addshl_5_8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 5
; RV32I-NEXT:    slli a1, a1, 8
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBA-LABEL: addshl_5_8:
; RV32ZBA:       # %bb.0:
; RV32ZBA-NEXT:    sh3add a0, a1, a0
; RV32ZBA-NEXT:    slli a0, a0, 5
; RV32ZBA-NEXT:    ret
  %c = shl i32 %a, 5
  %d = shl i32 %b, 8
  %e = add i32 %c, %d
  ret i32 %e
}
