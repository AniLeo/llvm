; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

; X | ~(X | Y) --> X | ~Y

define i32 @test1(i32 %x, i32 %y) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %or = or i32 %x, %y
  %not = xor i32 %or, -1
  %z = or i32 %x, %not
  ret i32 %z
}

; Commute (rename) the inner 'or' operands:
; Y | ~(X | Y) --> ~X | Y

define i32 @test2(i32 %x, i32 %y) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[X_NOT:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X_NOT]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %or = or i32 %x, %y
  %not = xor i32 %or, -1
  %z = or i32 %y, %not
  ret i32 %z
}

; X | ~(X ^ Y) --> X | ~Y

define i32 @test3(i32 %x, i32 %y) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %xor = xor i32 %x, %y
  %not = xor i32 %xor, -1
  %z = or i32 %x, %not
  ret i32 %z
}

; Commute (rename) the 'xor' operands:
; Y | ~(X ^ Y) --> ~X | Y

define i32 @test4(i32 %x, i32 %y) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[X_NOT:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X_NOT]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %xor = xor i32 %x, %y
  %not = xor i32 %xor, -1
  %z = or i32 %y, %not
  ret i32 %z
}

; (X ^ Y) | ~X  --> ~(X & Y)

define i32 @test5(i32 %x, i32 %y) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOTX:%.*]] = xor i32 [[X]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[XOR]], [[NOTX]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %xor = xor i32 %x, %y
  %notx = xor i32 %x, -1
  %z = or i32 %xor, %notx
  ret i32 %z
}

; Commute the 'or' operands
; ~X | (X ^ Y) --> ~(X & Y)

define <2 x i4> @test5_commuted(<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @test5_commuted(
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i4> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOTX:%.*]] = xor <2 x i4> [[X]], <i4 -1, i4 -1>
; CHECK-NEXT:    [[Z:%.*]] = or <2 x i4> [[XOR]], [[NOTX]]
; CHECK-NEXT:    ret <2 x i4> [[Z]]
;
  %xor = xor <2 x i4> %x, %y
  %notx = xor <2 x i4> %x, <i4 -1, i4 -1>
  %z = or <2 x i4> %notx, %xor
  ret <2 x i4> %z
}

; Commute the inner 'xor' operands
; (Y ^ X) | ~X  --> ~(Y & X)

define i64 @test5_commuted_x_y(i64 %x, i64 %y) {
; CHECK-LABEL: @test5_commuted_x_y(
; CHECK-NEXT:    [[XOR:%.*]] = xor i64 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[NOTX:%.*]] = xor i64 [[X]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i64 [[XOR]], [[NOTX]]
; CHECK-NEXT:    ret i64 [[Z]]
;
  %xor = xor i64 %y, %x
  %notx = xor i64 %x, -1
  %z = or i64  %xor, %notx
  ret i64 %z
}


define i8 @test5_extra_use_not(i8 %x, i8 %y, i8* %dst) {
; CHECK-LABEL: @test5_extra_use_not(
; CHECK-NEXT:    [[XOR:%.*]] = xor i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X]], -1
; CHECK-NEXT:    store i8 [[NOTX]], i8* [[DST:%.*]], align 1
; CHECK-NEXT:    [[Z:%.*]] = or i8 [[XOR]], [[NOTX]]
; CHECK-NEXT:    ret i8 [[Z]]
;
  %xor = xor i8 %x, %y
  %notx = xor i8 %x, -1
  store i8 %notx, i8* %dst
  %z = or i8 %notx, %xor
  ret i8 %z
}


define i65 @test5_extra_use_xor(i65 %x, i65 %y, i65* %dst) {
; CHECK-LABEL: @test5_extra_use_xor(
; CHECK-NEXT:    [[XOR:%.*]] = xor i65 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    store i65 [[XOR]], i65* [[DST:%.*]], align 4
; CHECK-NEXT:    [[NOTX:%.*]] = xor i65 [[X]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i65 [[XOR]], [[NOTX]]
; CHECK-NEXT:    ret i65 [[Z]]
;
  %xor = xor i65 %x, %y
  store i65 %xor, i65* %dst
  %notx = xor i65 %x, -1
  %z = or i65 %notx, %xor
  ret i65 %z
}

define i16 @test5_extra_use_not_xor(i16 %x, i16 %y, i16* %dst_not, i16* %dst_xor) {
; CHECK-LABEL: @test5_extra_use_not_xor(
; CHECK-NEXT:    [[XOR:%.*]] = xor i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    store i16 [[XOR]], i16* [[DST_XOR:%.*]], align 2
; CHECK-NEXT:    [[NOTX:%.*]] = xor i16 [[X]], -1
; CHECK-NEXT:    store i16 [[NOTX]], i16* [[DST_NOT:%.*]], align 2
; CHECK-NEXT:    [[Z:%.*]] = or i16 [[XOR]], [[NOTX]]
; CHECK-NEXT:    ret i16 [[Z]]
;
  %xor = xor i16 %x, %y
  store i16 %xor, i16* %dst_xor
  %notx = xor i16 %x, -1
  store i16 %notx, i16* %dst_not
  %z = or i16 %notx, %xor
  ret i16 %z
}

define i32 @test7(i32 %x, i32 %y) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %xor = xor i32 %x, %y
  %z = or i32 %y, %xor
  ret i32 %z
}

define i32 @test8(i32 %x, i32 %y) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[X_NOT:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X_NOT]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %not = xor i32 %y, -1
  %xor = xor i32 %x, %not
  %z = or i32 %y, %xor
  ret i32 %z
}

define i32 @test9(i32 %x, i32 %y) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %not = xor i32 %x, -1
  %xor = xor i32 %not, %y
  %z = or i32 %x, %xor
  ret i32 %z
}

; (A ^ B) | (~A ^ B) --> -1

define i32 @test10(i32 %A, i32 %B) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[XOR1:%.*]] = xor i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A]], [[B]]
; CHECK-NEXT:    [[XOR2:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[XOR1]], [[XOR2]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %xor1 = xor i32 %B, %A
  %not = xor i32 %A, -1
  %xor2 = xor i32 %not, %B
  %or = or i32 %xor1, %xor2
  ret i32 %or
}

define i32 @test10_commuted(i32 %A, i32 %B) {
; CHECK-LABEL: @test10_commuted(
; CHECK-NEXT:    [[XOR1:%.*]] = xor i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A]], [[B]]
; CHECK-NEXT:    [[XOR2:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[XOR1]], [[XOR2]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %xor1 = xor i32 %B, %A
  %not = xor i32 %A, -1
  %xor2 = xor i32 %not, %B
  %or = or i32 %xor2, %xor1
  ret i32 %or
}

define i32 @test10_extrause(i32 %A, i32 %B, i32* %dst) {
; CHECK-LABEL: @test10_extrause(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    store i32 [[NOT]], i32* [[DST:%.*]], align 4
; CHECK-NEXT:    ret i32 -1
;
  %xor1 = xor i32 %B, %A
  %not = xor i32 %A, -1
  store i32 %not, i32* %dst
  %xor2 = xor i32 %not, %B
  %or = or i32 %xor1, %xor2
  ret i32 %or
}

define i32 @test10_commuted_extrause(i32 %A, i32 %B, i32* %dst) {
; CHECK-LABEL: @test10_commuted_extrause(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    store i32 [[NOT]], i32* [[DST:%.*]], align 4
; CHECK-NEXT:    ret i32 -1
;
  %xor1 = xor i32 %B, %A
  %not = xor i32 %A, -1
  store i32 %not, i32* %dst
  %xor2 = xor i32 %not, %B
  %or = or i32 %xor2, %xor1
  ret i32 %or
}

; (A ^ B) | ~(A ^ B) --> -1
define i32 @test10_canonical(i32 %A, i32 %B) {
; CHECK-LABEL: @test10_canonical(
; CHECK-NEXT:    [[XOR1:%.*]] = xor i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[XOR2:%.*]] = xor i32 [[A]], [[B]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[XOR2]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[XOR1]], [[NOT]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %xor1 = xor i32 %B, %A
  %xor2 = xor i32 %A, %B
  %not = xor i32 %xor2, -1
  %or = or i32 %xor1, %not
  ret i32 %or
}

; (x | y) & ((~x) ^ y) -> (x & y)
define i32 @test11(i32 %x, i32 %y) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %or = or i32 %x, %y
  %neg = xor i32 %x, -1
  %xor = xor i32 %neg, %y
  %and = and i32 %or, %xor
  ret i32 %and
}

; ((~x) ^ y) & (x | y) -> (x & y)
define i32 @test12(i32 %x, i32 %y) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %neg = xor i32 %x, -1
  %xor = xor i32 %neg, %y
  %or = or i32 %x, %y
  %and = and i32 %xor, %or
  ret i32 %and
}

define i32 @test12_commuted(i32 %x, i32 %y) {
; CHECK-LABEL: @test12_commuted(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %neg = xor i32 %x, -1
  %xor = xor i32 %neg, %y
  %or = or i32 %y, %x
  %and = and i32 %xor, %or
  ret i32 %and
}

; ((x | y) ^ (x ^ y)) -> (x & y)
define i32 @test13(i32 %x, i32 %y) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = xor i32 %y, %x
  %2 = or i32 %y, %x
  %3 = xor i32 %2, %1
  ret i32 %3
}

; ((x | ~y) ^ (~x | y)) -> x ^ y
define i32 @test14(i32 %x, i32 %y) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %x, %noty
  %or2 = or i32 %notx, %y
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

define i32 @test14_commuted(i32 %x, i32 %y) {
; CHECK-LABEL: @test14_commuted(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %noty, %x
  %or2 = or i32 %notx, %y
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((x & ~y) ^ (~x & y)) -> x ^ y
define i32 @test15(i32 %x, i32 %y) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %and1 = and i32 %x, %noty
  %and2 = and i32 %notx, %y
  %xor = xor i32 %and1, %and2
  ret i32 %xor
}

define i32 @test15_commuted(i32 %x, i32 %y) {
; CHECK-LABEL: @test15_commuted(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %and1 = and i32 %noty, %x
  %and2 = and i32 %notx, %y
  %xor = xor i32 %and1, %and2
  ret i32 %xor
}

; ((a ^ b) & C1) | (b & C2) -> (a & C1) ^ b iff C1 == ~C2

define i32 @or_and_xor_not_constant_commute0(i32 %a, i32 %b) {
; CHECK-LABEL: @or_and_xor_not_constant_commute0(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 1
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %or = xor i32 %a, %b
  %and1 = and i32 %or, 1
  %and2 = and i32 %b, -2
  %xor = or i32 %and1, %and2
  ret i32 %xor
}

define i9 @or_and_xor_not_constant_commute1(i9 %a, i9 %b) {
; CHECK-LABEL: @or_and_xor_not_constant_commute1(
; CHECK-NEXT:    [[TMP1:%.*]] = and i9 [[A:%.*]], 42
; CHECK-NEXT:    [[XOR:%.*]] = xor i9 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i9 [[XOR]]
;
  %or = xor i9 %b, %a
  %and1 = and i9 %or, 42
  %and2 = and i9 %b, -43
  %xor = or i9 %and1, %and2
  ret i9 %xor
}

define <2 x i9> @or_and_xor_not_constant_commute2_splat(<2 x i9> %a, <2 x i9> %b) {
; CHECK-LABEL: @or_and_xor_not_constant_commute2_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i9> [[A:%.*]], <i9 42, i9 42>
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i9> [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x i9> [[XOR]]
;
  %or = xor <2 x i9> %b, %a
  %and1 = and <2 x i9> %or, <i9 42, i9 42>
  %and2 = and <2 x i9> %b, <i9 -43, i9 -43>
  %xor = or <2 x i9> %and2, %and1
  ret <2 x i9> %xor
}

define <2 x i9> @or_and_xor_not_constant_commute3_splat(<2 x i9> %a, <2 x i9> %b) {
; CHECK-LABEL: @or_and_xor_not_constant_commute3_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i9> [[A:%.*]], <i9 42, i9 42>
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i9> [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x i9> [[XOR]]
;
  %or = xor <2 x i9> %a, %b
  %and1 = and <2 x i9> %or, <i9 42, i9 42>
  %and2 = and <2 x i9> %b, <i9 -43, i9 -43>
  %xor = or <2 x i9> %and2, %and1
  ret <2 x i9> %xor
}

define i8 @not_or(i8 %x) {
; CHECK-LABEL: @not_or(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[NOTX]], 7
; CHECK-NEXT:    ret i8 [[OR]]
;
  %notx = xor i8 %x, -1
  %or = or i8 %notx, 7
  ret i8 %or
}

define i8 @not_or_xor(i8 %x) {
; CHECK-LABEL: @not_or_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X:%.*]], -8
; CHECK-NEXT:    [[XOR:%.*]] = xor i8 [[TMP1]], -13
; CHECK-NEXT:    ret i8 [[XOR]]
;
  %notx = xor i8 %x, -1
  %or = or i8 %notx, 7
  %xor = xor i8 %or, 12
  ret i8 %xor
}

define i8 @xor_or(i8 %x) {
; CHECK-LABEL: @xor_or(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 7
; CHECK-NEXT:    [[OR:%.*]] = xor i8 [[TMP1]], 32
; CHECK-NEXT:    ret i8 [[OR]]
;
  %xor = xor i8 %x, 32
  %or = or i8 %xor, 7
  ret i8 %or
}

define i8 @xor_or2(i8 %x) {
; CHECK-LABEL: @xor_or2(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 7
; CHECK-NEXT:    [[OR:%.*]] = xor i8 [[TMP1]], 32
; CHECK-NEXT:    ret i8 [[OR]]
;
  %xor = xor i8 %x, 33
  %or = or i8 %xor, 7
  ret i8 %or
}

define i8 @xor_or_xor(i8 %x) {
; CHECK-LABEL: @xor_or_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 7
; CHECK-NEXT:    [[XOR2:%.*]] = xor i8 [[TMP1]], 44
; CHECK-NEXT:    ret i8 [[XOR2]]
;
  %xor1 = xor i8 %x, 33
  %or = or i8 %xor1, 7
  %xor2 = xor i8 %or, 12
  ret i8 %xor2
}

define i8 @or_xor_or(i8 %x) {
; CHECK-LABEL: @or_xor_or(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 39
; CHECK-NEXT:    [[OR2:%.*]] = xor i8 [[TMP1]], 8
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %or1 = or i8 %x, 33
  %xor = xor i8 %or1, 12
  %or2 = or i8 %xor, 7
  ret i8 %or2
}

define i8 @test17(i8 %A, i8 %B) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[XOR1:%.*]] = xor i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[A]], [[B]]
; CHECK-NEXT:    [[XOR2:%.*]] = xor i8 [[TMP1]], 33
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[XOR1]], [[XOR2]]
; CHECK-NEXT:    [[RES:%.*]] = mul i8 [[OR]], [[XOR2]]
; CHECK-NEXT:    ret i8 [[RES]]
;
  %xor1 = xor i8 %B, %A
  %not = xor i8 %A, 33
  %xor2 = xor i8 %not, %B
  %or = or i8 %xor1, %xor2
  %res = mul i8 %or, %xor2 ; to increase the use count for the xor
  ret i8 %res
}

define i8 @test18(i8 %A, i8 %B) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[XOR1:%.*]] = xor i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[A]], [[B]]
; CHECK-NEXT:    [[XOR2:%.*]] = xor i8 [[TMP1]], 33
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[XOR2]], [[XOR1]]
; CHECK-NEXT:    [[RES:%.*]] = mul i8 [[OR]], [[XOR2]]
; CHECK-NEXT:    ret i8 [[RES]]
;
  %xor1 = xor i8 %B, %A
  %not = xor i8 %A, 33
  %xor2 = xor i8 %not, %B
  %or = or i8 %xor2, %xor1
  %res = mul i8 %or, %xor2 ; to increase the use count for the xor
  ret i8 %res
}

; ((x | y) ^ (~x | ~y)) -> ~(x ^ y)
define i32 @test19(i32 %x, i32 %y) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %x, %y
  %or2 = or i32 %notx, %noty
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((x | y) ^ (~y | ~x)) -> ~(x ^ y)
define i32 @test20(i32 %x, i32 %y) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %x, %y
  %or2 = or i32 %noty, %notx
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((~x | ~y) ^ (x | y)) -> ~(x ^ y)
define i32 @test21(i32 %x, i32 %y) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %notx, %noty
  %or2 = or i32 %x, %y
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((~x | ~y) ^ (y | x)) -> ~(x ^ y)
define i32 @test22(i32 %x, i32 %y) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %notx, %noty
  %or2 = or i32 %y, %x
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; (X ^ C1) | C2 --> (X | C2) ^ (C1&~C2)
define i8 @test23(i8 %A) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    ret i8 -1
;
  %B = or i8 %A, -2
  %C = xor i8 %B, 13
  %D = or i8 %C, 1
  %E = xor i8 %D, 12
  ret i8 %E
}

define i8 @test23v(<2 x i8> %A) {
; CHECK-LABEL: @test23v(
; CHECK-NEXT:    ret i8 -1
;
  %B = or <2 x i8> %A, <i8 -2, i8 0>
  %CV = xor <2 x i8> %B, <i8 13, i8 13>
  %C = extractelement <2 x i8> %CV, i32 0
  %D = or i8 %C, 1
  %E = xor i8 %D, 12
  ret i8 %E
}

; ~(a | b) | (~a & b);
define i32 @PR45977_f1(i32 %a, i32 %b) {
; CHECK-LABEL: @PR45977_f1(
; CHECK-NEXT:    [[NOT:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    ret i32 [[NOT]]
;
  %not = xor i32 %a, -1
  %andnot = and i32 %not, %b
  %or = or i32 %a, %b
  %notor = xor i32 %or, -1
  %res = or i32 %notor, %andnot
  ret i32 %res
}

; (a | b) ^ (a | ~b)
define i32 @PR45977_f2(i32 %a, i32 %b) {
; CHECK-LABEL: @PR45977_f2(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %or = or i32 %a, %b
  %not = xor i32 %b, -1
  %ornot = or i32 %a, %not
  %res = xor i32 %or, %ornot
  ret i32 %res
}
