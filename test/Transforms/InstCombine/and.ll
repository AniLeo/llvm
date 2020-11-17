; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use8(i8)
declare void @use32(i32)

; There should be no 'and' instructions left in any test.

define i32 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 0
;
  %B = and i32 %A, 0
  ret i32 %B
}

define i32 @test2(i32 %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = and i32 %A, -1
  ret i32 %B
}

define i1 @test3(i1 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i1 false
;
  %B = and i1 %A, false
  ret i1 %B
}

define i1 @test4(i1 %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret i1 [[A:%.*]]
;
  %B = and i1 %A, true
  ret i1 %B
}

define i32 @test5(i32 %A) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = and i32 %A, %A
  ret i32 %B
}

define i1 @test6(i1 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i1 [[A:%.*]]
;
  %B = and i1 %A, %A
  ret i1 %B
}

; A & ~A == 0
define i32 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 0
;
  %NotA = xor i32 %A, -1
  %B = and i32 %A, %NotA
  ret i32 %B
}

; AND associates
define i8 @test8(i8 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i8 0
;
  %B = and i8 %A, 3
  %C = and i8 %B, 4
  ret i8 %C
}

; Test of sign bit, convert to setle %A, 0
define i1 @test9(i32 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[A:%.*]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = and i32 %A, -2147483648
  %C = icmp ne i32 %B, 0
  ret i1 %C
}

; Test of sign bit, convert to setle %A, 0
define i1 @test9a(i32 %A) {
; CHECK-LABEL: @test9a(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[A:%.*]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = and i32 %A, -2147483648
  %C = icmp ne i32 %B, 0
  ret i1 %C
}

define i32 @test10(i32 %A) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i32 1
;
  %B = and i32 %A, 12
  %C = xor i32 %B, 15
  ; (X ^ C1) & C2 --> (X & C2) ^ (C1&C2)
  %D = and i32 %C, 1
  ret i32 %D
}

define i32 @test11(i32 %A, i32* %P) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[B:%.*]] = or i32 [[A:%.*]], 3
; CHECK-NEXT:    [[C:%.*]] = xor i32 [[B]], 12
; CHECK-NEXT:    store i32 [[C]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 3
;
  %B = or i32 %A, 3
  %C = xor i32 %B, 12
  ; additional use of C
  store i32 %C, i32* %P
  ; %C = and uint %B, 3 --> 3
  %D = and i32 %C, 3
  ret i32 %D
}

define i1 @test12(i32 %A, i32 %B) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i1 [[C1]]
;
  %C1 = icmp ult i32 %A, %B
  %C2 = icmp ule i32 %A, %B
  ; (A < B) & (A <= B) === (A < B)
  %D = and i1 %C1, %C2
  ret i1 %D
}

define i1 @test13(i32 %A, i32 %B) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    ret i1 false
;
  %C1 = icmp ult i32 %A, %B
  %C2 = icmp ugt i32 %A, %B
  ; (A < B) & (A > B) === false
  %D = and i1 %C1, %C2
  ret i1 %D
}

define i1 @test14(i8 %A) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[A:%.*]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = and i8 %A, -128
  %C = icmp ne i8 %B, 0
  ret i1 %C
}

define i8 @test15(i8 %A) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    ret i8 0
;
  %B = lshr i8 %A, 7
  ; Always equals zero
  %C = and i8 %B, 2
  ret i8 %C
}

define i8 @test16(i8 %A) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    ret i8 0
;
  %B = shl i8 %A, 2
  %C = and i8 %B, 3
  ret i8 %C
}

define i1 @test18(i32 %A) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[A:%.*]], 127
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = and i32 %A, -128
  ;; C >= 128
  %C = icmp ne i32 %B, 0
  ret i1 %C
}

define <2 x i1> @test18_vec(<2 x i32> %A) {
; CHECK-LABEL: @test18_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt <2 x i32> [[A:%.*]], <i32 127, i32 127>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = and <2 x i32> %A, <i32 -128, i32 -128>
  %C = icmp ne <2 x i32> %B, zeroinitializer
  ret <2 x i1> %C
}

define i1 @test18a(i8 %A) {
; CHECK-LABEL: @test18a(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i8 [[A:%.*]], 2
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = and i8 %A, -2
  %C = icmp eq i8 %B, 0
  ret i1 %C
}

define <2 x i1> @test18a_vec(<2 x i8> %A) {
; CHECK-LABEL: @test18a_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ult <2 x i8> [[A:%.*]], <i8 2, i8 2>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = and <2 x i8> %A, <i8 -2, i8 -2>
  %C = icmp eq <2 x i8> %B, zeroinitializer
  ret <2 x i1> %C
}

define i32 @test19(i32 %A) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[B:%.*]] = shl i32 [[A:%.*]], 3
; CHECK-NEXT:    ret i32 [[B]]
;
  %B = shl i32 %A, 3
  ;; Clearing a zero bit
  %C = and i32 %B, -2
  ret i32 %C
}

define i8 @test20(i8 %A) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    [[C:%.*]] = lshr i8 [[A:%.*]], 7
; CHECK-NEXT:    ret i8 [[C]]
;
  %C = lshr i8 %A, 7
  ;; Unneeded
  %D = and i8 %C, 1
  ret i8 %D
}

define i1 @test23(i32 %A) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[A:%.*]], 2
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %B = icmp sgt i32 %A, 1
  %C = icmp sle i32 %A, 2
  %D = and i1 %B, %C
  ret i1 %D
}

; FIXME: Vectors should fold too.
define <2 x i1> @test23vec(<2 x i32> %A) {
; CHECK-LABEL: @test23vec(
; CHECK-NEXT:    [[B:%.*]] = icmp sgt <2 x i32> [[A:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[C:%.*]] = icmp slt <2 x i32> [[A]], <i32 3, i32 3>
; CHECK-NEXT:    [[D:%.*]] = and <2 x i1> [[B]], [[C]]
; CHECK-NEXT:    ret <2 x i1> [[D]]
;
  %B = icmp sgt <2 x i32> %A, <i32 1, i32 1>
  %C = icmp sle <2 x i32> %A, <i32 2, i32 2>
  %D = and <2 x i1> %B, %C
  ret <2 x i1> %D
}

define i1 @test24(i32 %A) {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[A:%.*]], 2
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %B = icmp sgt i32 %A, 1
  %C = icmp ne i32 %A, 2
  ;; A > 2
  %D = and i1 %B, %C
  ret i1 %D
}

define i1 @test25(i32 %A) {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -50
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[A_OFF]], 50
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %B = icmp sge i32 %A, 50
  %C = icmp slt i32 %A, 100
  %D = and i1 %B, %C
  ret i1 %D
}

; FIXME: Vectors should fold too.
define <2 x i1> @test25vec(<2 x i32> %A) {
; CHECK-LABEL: @test25vec(
; CHECK-NEXT:    [[B:%.*]] = icmp sgt <2 x i32> [[A:%.*]], <i32 49, i32 49>
; CHECK-NEXT:    [[C:%.*]] = icmp slt <2 x i32> [[A]], <i32 100, i32 100>
; CHECK-NEXT:    [[D:%.*]] = and <2 x i1> [[B]], [[C]]
; CHECK-NEXT:    ret <2 x i1> [[D]]
;
  %B = icmp sge <2 x i32> %A, <i32 50, i32 50>
  %C = icmp slt <2 x i32> %A, <i32 100, i32 100>
  %D = and <2 x i1> %B, %C
  ret <2 x i1> %D
}

define i8 @test27(i8 %A) {
; CHECK-LABEL: @test27(
; CHECK-NEXT:    ret i8 0
;
  %B = and i8 %A, 4
  %C = sub i8 %B, 16
  ;; 0xF0
  %D = and i8 %C, -16
  %E = add i8 %D, 16
  ret i8 %E
}

;; This is just a zero-extending shr.
define i32 @test28(i32 %X) {
; CHECK-LABEL: @test28(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 24
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  ;; Sign extend
  %Y = ashr i32 %X, 24
  ;; Mask out sign bits
  %Z = and i32 %Y, 255
  ret i32 %Z
}

define i32 @test29(i8 %X) {
; CHECK-LABEL: @test29(
; CHECK-NEXT:    [[Y:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    ret i32 [[Y]]
;
  %Y = zext i8 %X to i32
  ;; Zero extend makes this unneeded.
  %Z = and i32 %Y, 255
  ret i32 %Z
}

define i32 @test30(i1 %X) {
; CHECK-LABEL: @test30(
; CHECK-NEXT:    [[Y:%.*]] = zext i1 [[X:%.*]] to i32
; CHECK-NEXT:    ret i32 [[Y]]
;
  %Y = zext i1 %X to i32
  %Z = and i32 %Y, 1
  ret i32 %Z
}

define i32 @test31(i1 %X) {
; CHECK-LABEL: @test31(
; CHECK-NEXT:    [[Z:%.*]] = select i1 [[X:%.*]], i32 16, i32 0
; CHECK-NEXT:    ret i32 [[Z]]
;
  %Y = zext i1 %X to i32
  %Z = shl i32 %Y, 4
  %A = and i32 %Z, 16
  ret i32 %A
}

; Demanded bit analysis allows us to eliminate the add.

define <2 x i32> @and_demanded_bits_splat_vec(<2 x i32> %x) {
; CHECK-LABEL: @and_demanded_bits_splat_vec(
; CHECK-NEXT:    [[Z:%.*]] = and <2 x i32> [[X:%.*]], <i32 7, i32 7>
; CHECK-NEXT:    ret <2 x i32> [[Z]]
;
  %y = add <2 x i32> %x, <i32 8, i32 8>
  %z = and <2 x i32> %y, <i32 7, i32 7>
  ret <2 x i32> %z
}

; zext (x >> 8) has all zeros in the high 24-bits:  0x000000xx
; (y | 255) has all ones in the low 8-bits: 0xyyyyyyff
; 'and' of those is all known bits - it's just 'z'.

define i32 @and_zext_demanded(i16 %x, i32 %y) {
; CHECK-LABEL: @and_zext_demanded(
; CHECK-NEXT:    [[S:%.*]] = lshr i16 [[X:%.*]], 8
; CHECK-NEXT:    [[Z:%.*]] = zext i16 [[S]] to i32
; CHECK-NEXT:    ret i32 [[Z]]
;
  %s = lshr i16 %x, 8
  %z = zext i16 %s to i32
  %o = or i32 %y, 255
  %a = and i32 %o, %z
  ret i32 %a
}

define i32 @test32(i32 %In) {
; CHECK-LABEL: @test32(
; CHECK-NEXT:    ret i32 0
;
  %Y = and i32 %In, 16
  %Z = lshr i32 %Y, 2
  %A = and i32 %Z, 1
  ret i32 %A
}

;; Code corresponding to one-bit bitfield ^1.
define i32 @test33(i32 %b) {
; CHECK-LABEL: @test33(
; CHECK-NEXT:    [[T13:%.*]] = xor i32 [[B:%.*]], 1
; CHECK-NEXT:    ret i32 [[T13]]
;
  %t4.mask = and i32 %b, 1
  %t10 = xor i32 %t4.mask, 1
  %t12 = and i32 %b, -2
  %t13 = or i32 %t12, %t10
  ret i32 %t13
}

define i32 @test33b(i32 %b) {
; CHECK-LABEL: @test33b(
; CHECK-NEXT:    [[T13:%.*]] = xor i32 [[B:%.*]], 1
; CHECK-NEXT:    ret i32 [[T13]]
;
  %t4.mask = and i32 %b, 1
  %t10 = xor i32 %t4.mask, 1
  %t12 = and i32 %b, -2
  %t13 = or i32 %t10, %t12
  ret i32 %t13
}

define <2 x i32> @test33vec(<2 x i32> %b) {
; CHECK-LABEL: @test33vec(
; CHECK-NEXT:    [[T13:%.*]] = xor <2 x i32> [[B:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[T13]]
;
  %t4.mask = and <2 x i32> %b, <i32 1, i32 1>
  %t10 = xor <2 x i32> %t4.mask, <i32 1, i32 1>
  %t12 = and <2 x i32> %b, <i32 -2, i32 -2>
  %t13 = or <2 x i32> %t12, %t10
  ret <2 x i32> %t13
}

define <2 x i32> @test33vecb(<2 x i32> %b) {
; CHECK-LABEL: @test33vecb(
; CHECK-NEXT:    [[T13:%.*]] = xor <2 x i32> [[B:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[T13]]
;
  %t4.mask = and <2 x i32> %b, <i32 1, i32 1>
  %t10 = xor <2 x i32> %t4.mask, <i32 1, i32 1>
  %t12 = and <2 x i32> %b, <i32 -2, i32 -2>
  %t13 = or <2 x i32> %t10, %t12
  ret <2 x i32> %t13
}

define i32 @test34(i32 %A, i32 %B) {
; CHECK-LABEL: @test34(
; CHECK-NEXT:    ret i32 [[B:%.*]]
;
  %t2 = or i32 %B, %A
  %t4 = and i32 %t2, %B
  ret i32 %t4
}

; FIXME: This test should only need -instsimplify (ValueTracking / computeKnownBits), not -instcombine.

define <2 x i32> @PR24942(<2 x i32> %x) {
; CHECK-LABEL: @PR24942(
; CHECK-NEXT:    ret <2 x i32> zeroinitializer
;
  %lshr = lshr <2 x i32> %x, <i32 31, i32 31>
  %and = and <2 x i32> %lshr, <i32 2, i32 2>
  ret <2 x i32> %and
}

define i64 @test35(i32 %X) {
; CHECK-LABEL: @test35(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 240
; CHECK-NEXT:    [[RES:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    ret i64 [[RES]]
;
  %zext = zext i32 %X to i64
  %zsub = sub i64 0, %zext
  %res = and i64 %zsub, 240
  ret i64 %res
}

define <2 x i64> @test35_uniform(<2 x i32> %X) {
; CHECK-LABEL: @test35_uniform(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[ZSUB:%.*]] = sub nsw <2 x i64> zeroinitializer, [[ZEXT]]
; CHECK-NEXT:    [[RES:%.*]] = and <2 x i64> [[ZSUB]], <i64 240, i64 240>
; CHECK-NEXT:    ret <2 x i64> [[RES]]
;
  %zext = zext <2 x i32> %X to <2 x i64>
  %zsub = sub <2 x i64> zeroinitializer, %zext
  %res = and <2 x i64> %zsub, <i64 240, i64 240>
  ret <2 x i64> %res
}

define i64 @test36(i32 %X) {
; CHECK-LABEL: @test36(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[X:%.*]], 7
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 240
; CHECK-NEXT:    [[RES:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    ret i64 [[RES]]
;
  %zext = zext i32 %X to i64
  %zsub = add i64 %zext, 7
  %res = and i64 %zsub, 240
  ret i64 %res
}

define <2 x i64> @test36_undef(<2 x i32> %X) {
; CHECK-LABEL: @test36_undef(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[ZSUB:%.*]] = add <2 x i64> [[ZEXT]], <i64 7, i64 undef>
; CHECK-NEXT:    [[RES:%.*]] = and <2 x i64> [[ZSUB]], <i64 240, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[RES]]
;
  %zext = zext <2 x i32> %X to <2 x i64>
  %zsub = add <2 x i64> %zext, <i64 7, i64 undef>
  %res = and <2 x i64> %zsub, <i64 240, i64 undef>
  ret <2 x i64> %res
}

define i64 @test37(i32 %X) {
; CHECK-LABEL: @test37(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[X:%.*]], 7
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 240
; CHECK-NEXT:    [[RES:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    ret i64 [[RES]]
;
  %zext = zext i32 %X to i64
  %zsub = mul i64 %zext, 7
  %res = and i64 %zsub, 240
  ret i64 %res
}

define <2 x i64> @test37_nonuniform(<2 x i32> %X) {
; CHECK-LABEL: @test37_nonuniform(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[ZSUB:%.*]] = mul nuw nsw <2 x i64> [[ZEXT]], <i64 7, i64 9>
; CHECK-NEXT:    [[RES:%.*]] = and <2 x i64> [[ZSUB]], <i64 240, i64 110>
; CHECK-NEXT:    ret <2 x i64> [[RES]]
;
  %zext = zext <2 x i32> %X to <2 x i64>
  %zsub = mul <2 x i64> %zext, <i64 7, i64 9>
  %res = and <2 x i64> %zsub, <i64 240, i64 110>
  ret <2 x i64> %res
}

define i64 @test38(i32 %X) {
; CHECK-LABEL: @test38(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X:%.*]], 240
; CHECK-NEXT:    [[RES:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    ret i64 [[RES]]
;
  %zext = zext i32 %X to i64
  %zsub = xor i64 %zext, 7
  %res = and i64 %zsub, 240
  ret i64 %res
}

define i64 @test39(i32 %X) {
; CHECK-LABEL: @test39(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X:%.*]], 240
; CHECK-NEXT:    [[RES:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    ret i64 [[RES]]
;
  %zext = zext i32 %X to i64
  %zsub = or i64 %zext, 7
  %res = and i64 %zsub, 240
  ret i64 %res
}

define i32 @test40(i1 %C) {
; CHECK-LABEL: @test40(
; CHECK-NEXT:    [[A:%.*]] = select i1 [[C:%.*]], i32 104, i32 10
; CHECK-NEXT:    ret i32 [[A]]
;
  %A = select i1 %C, i32 1000, i32 10
  %V = and i32 %A, 123
  ret i32 %V
}

define <2 x i32> @test40vec(i1 %C) {
; CHECK-LABEL: @test40vec(
; CHECK-NEXT:    [[A:%.*]] = select i1 [[C:%.*]], <2 x i32> <i32 104, i32 104>, <2 x i32> <i32 10, i32 10>
; CHECK-NEXT:    ret <2 x i32> [[A]]
;
  %A = select i1 %C, <2 x i32> <i32 1000, i32 1000>, <2 x i32> <i32 10, i32 10>
  %V = and <2 x i32> %A, <i32 123, i32 123>
  ret <2 x i32> %V
}

define <2 x i32> @test40vec2(i1 %C) {
; CHECK-LABEL: @test40vec2(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[C:%.*]], <2 x i32> <i32 104, i32 324>, <2 x i32> <i32 10, i32 12>
; CHECK-NEXT:    ret <2 x i32> [[V]]
;
  %A = select i1 %C, <2 x i32> <i32 1000, i32 2500>, <2 x i32> <i32 10, i32 30>
  %V = and <2 x i32> %A, <i32 123, i32 333>
  ret <2 x i32> %V
}

define i32 @test41(i1 %which) {
; CHECK-LABEL: @test41(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 104, [[ENTRY:%.*]] ], [ 10, [[DELAY]] ]
; CHECK-NEXT:    ret i32 [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi i32 [ 1000, %entry ], [ 10, %delay ]
  %value = and i32 %A, 123
  ret i32 %value
}

define <2 x i32> @test41vec(i1 %which) {
; CHECK-LABEL: @test41vec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 104, i32 104>, [[ENTRY:%.*]] ], [ <i32 10, i32 10>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 1000>, %entry ], [ <i32 10, i32 10>, %delay ]
  %value = and <2 x i32> %A, <i32 123, i32 123>
  ret <2 x i32> %value
}

define <2 x i32> @test41vec2(i1 %which) {
; CHECK-LABEL: @test41vec2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 104, i32 324>, [[ENTRY:%.*]] ], [ <i32 10, i32 12>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 2500>, %entry ], [ <i32 10, i32 30>, %delay ]
  %value = and <2 x i32> %A, <i32 123, i32 333>
  ret <2 x i32> %value
}

define i32 @test42(i32 %a, i32 %c, i32 %d) {
; CHECK-LABEL: @test42(
; CHECK-NEXT:    [[FORCE:%.*]] = mul i32 [[C:%.*]], [[D:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[FORCE]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %force = mul i32 %c, %d ; forces the complexity sorting
  %or = or i32 %a, %force
  %nota = xor i32 %a, -1
  %xor = xor i32 %nota, %force
  %and = and i32 %xor, %or
  ret i32 %and
}

define i32 @test43(i32 %a, i32 %c, i32 %d) {
; CHECK-LABEL: @test43(
; CHECK-NEXT:    [[FORCE:%.*]] = mul i32 [[C:%.*]], [[D:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[FORCE]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %force = mul i32 %c, %d ; forces the complexity sorting
  %or = or i32 %a, %force
  %nota = xor i32 %a, -1
  %xor = xor i32 %nota, %force
  %and = and i32 %or, %xor
  ret i32 %and
}

; (~y | x) & y -> x & y
define i32 @test44(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: @test44(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[A]]
;
  %n = xor i32 %y, -1
  %o = or i32 %n, %x
  %a = and i32 %o, %y
  ret i32 %a
}

; (x | ~y) & y -> x & y
define i32 @test45(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: @test45(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[A]]
;
  %n = xor i32 %y, -1
  %o = or i32 %x, %n
  %a = and i32 %o, %y
  ret i32 %a
}

; y & (~y | x) -> y | x
define i32 @test46(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: @test46(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[A]]
;
  %n = xor i32 %y, -1
  %o = or i32 %n, %x
  %a = and i32 %y, %o
  ret i32 %a
}

; y & (x | ~y) -> y | x
define i32 @test47(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: @test47(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[A]]
;
  %n = xor i32 %y, -1
  %o = or i32 %x, %n
  %a = and i32 %y, %o
  ret i32 %a
}

; In the next 4 tests, vary the types and predicates for extra coverage.
; (X & (Y | ~X)) -> (X & Y), where 'not' is an inverted cmp

define i1 @and_orn_cmp_1(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @and_orn_cmp_1(
; CHECK-NEXT:    [[X:%.*]] = icmp sgt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt i32 [[C:%.*]], 42
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[AND]]
;
  %x = icmp sgt i32 %a, %b
  %x_inv = icmp sle i32 %a, %b
  %y = icmp ugt i32 %c, 42      ; thwart complexity-based ordering
  %or = or i1 %y, %x_inv
  %and = and i1 %x, %or
  ret i1 %and
}

; Commute the 'and':
; ((Y | ~X) & X) -> (X & Y), where 'not' is an inverted cmp

define <2 x i1> @and_orn_cmp_2(<2 x i32> %a, <2 x i32> %b, <2 x i32> %c) {
; CHECK-LABEL: @and_orn_cmp_2(
; CHECK-NEXT:    [[X:%.*]] = icmp sge <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt <2 x i32> [[C:%.*]], <i32 42, i32 47>
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i1> [[Y]], [[X]]
; CHECK-NEXT:    ret <2 x i1> [[AND]]
;
  %x = icmp sge <2 x i32> %a, %b
  %x_inv = icmp slt <2 x i32> %a, %b
  %y = icmp ugt <2 x i32> %c, <i32 42, i32 47>      ; thwart complexity-based ordering
  %or = or <2 x i1> %y, %x_inv
  %and = and <2 x i1> %or, %x
  ret <2 x i1> %and
}

; Commute the 'or':
; (X & (~X | Y)) -> (X & Y), where 'not' is an inverted cmp

define i1 @and_orn_cmp_3(i72 %a, i72 %b, i72 %c) {
; CHECK-LABEL: @and_orn_cmp_3(
; CHECK-NEXT:    [[X:%.*]] = icmp ugt i72 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt i72 [[C:%.*]], 42
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[AND]]
;
  %x = icmp ugt i72 %a, %b
  %x_inv = icmp ule i72 %a, %b
  %y = icmp ugt i72 %c, 42      ; thwart complexity-based ordering
  %or = or i1 %x_inv, %y
  %and = and i1 %x, %or
  ret i1 %and
}

; Commute the 'and':
; ((~X | Y) & X) -> (X & Y), where 'not' is an inverted cmp

define <3 x i1> @or_andn_cmp_4(<3 x i32> %a, <3 x i32> %b, <3 x i32> %c) {
; CHECK-LABEL: @or_andn_cmp_4(
; CHECK-NEXT:    [[X:%.*]] = icmp eq <3 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt <3 x i32> [[C:%.*]], <i32 42, i32 43, i32 -1>
; CHECK-NEXT:    [[AND:%.*]] = and <3 x i1> [[Y]], [[X]]
; CHECK-NEXT:    ret <3 x i1> [[AND]]
;
  %x = icmp eq <3 x i32> %a, %b
  %x_inv = icmp ne <3 x i32> %a, %b
  %y = icmp ugt <3 x i32> %c, <i32 42, i32 43, i32 -1>      ; thwart complexity-based ordering
  %or = or <3 x i1> %x_inv, %y
  %and = and <3 x i1> %or, %x
  ret <3 x i1> %and
}

; In the next 4 tests, vary the types and predicates for extra coverage.
; (~X & (Y | X)) -> (~X & Y), where 'not' is an inverted cmp

define i1 @andn_or_cmp_1(i37 %a, i37 %b, i37 %c) {
; CHECK-LABEL: @andn_or_cmp_1(
; CHECK-NEXT:    [[X_INV:%.*]] = icmp sle i37 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt i37 [[C:%.*]], 42
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[X_INV]], [[Y]]
; CHECK-NEXT:    ret i1 [[AND]]
;
  %x = icmp sgt i37 %a, %b
  %x_inv = icmp sle i37 %a, %b
  %y = icmp ugt i37 %c, 42      ; thwart complexity-based ordering
  %or = or i1 %y, %x
  %and = and i1 %x_inv, %or
  ret i1 %and
}

; Commute the 'and':
; ((Y | X) & ~X) -> (~X & Y), where 'not' is an inverted cmp

define i1 @andn_or_cmp_2(i16 %a, i16 %b, i16 %c) {
; CHECK-LABEL: @andn_or_cmp_2(
; CHECK-NEXT:    [[X_INV:%.*]] = icmp slt i16 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt i16 [[C:%.*]], 42
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[Y]], [[X_INV]]
; CHECK-NEXT:    ret i1 [[AND]]
;
  %x = icmp sge i16 %a, %b
  %x_inv = icmp slt i16 %a, %b
  %y = icmp ugt i16 %c, 42      ; thwart complexity-based ordering
  %or = or i1 %y, %x
  %and = and i1 %or, %x_inv
  ret i1 %and
}

; Commute the 'or':
; (~X & (X | Y)) -> (~X & Y), where 'not' is an inverted cmp

define <4 x i1> @andn_or_cmp_3(<4 x i32> %a, <4 x i32> %b, <4 x i32> %c) {
; CHECK-LABEL: @andn_or_cmp_3(
; CHECK-NEXT:    [[X_INV:%.*]] = icmp ule <4 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt <4 x i32> [[C:%.*]], <i32 42, i32 0, i32 1, i32 -1>
; CHECK-NEXT:    [[AND:%.*]] = and <4 x i1> [[X_INV]], [[Y]]
; CHECK-NEXT:    ret <4 x i1> [[AND]]
;
  %x = icmp ugt <4 x i32> %a, %b
  %x_inv = icmp ule <4 x i32> %a, %b
  %y = icmp ugt <4 x i32> %c, <i32 42, i32 0, i32 1, i32 -1>      ; thwart complexity-based ordering
  %or = or <4 x i1> %x, %y
  %and = and <4 x i1> %x_inv, %or
  ret <4 x i1> %and
}

; Commute the 'and':
; ((X | Y) & ~X) -> (~X & Y), where 'not' is an inverted cmp

define i1 @andn_or_cmp_4(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @andn_or_cmp_4(
; CHECK-NEXT:    [[X_INV:%.*]] = icmp ne i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = icmp ugt i32 [[C:%.*]], 42
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[Y]], [[X_INV]]
; CHECK-NEXT:    ret i1 [[AND]]
;
  %x = icmp eq i32 %a, %b
  %x_inv = icmp ne i32 %a, %b
  %y = icmp ugt i32 %c, 42      ; thwart complexity-based ordering
  %or = or i1 %x, %y
  %and = and i1 %or, %x_inv
  ret i1 %and
}

define i32 @lowbitmask_casted_shift(i8 %x) {
; CHECK-LABEL: @lowbitmask_casted_shift(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[R:%.*]] = lshr i32 [[TMP1]], 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i8 %x, 1
  %s = sext i8 %a to i32
  %r = and i32 %s, 2147483647
  ret i32 %r
}

; Negative test - mask constant is too big.

define i32 @lowbitmask_casted_shift_wrong_mask1(i8 %x) {
; CHECK-LABEL: @lowbitmask_casted_shift_wrong_mask1(
; CHECK-NEXT:    [[A:%.*]] = ashr i8 [[X:%.*]], 2
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[A]] to i32
; CHECK-NEXT:    [[R:%.*]] = and i32 [[S]], 2147483647
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i8 %x, 2
  %s = sext i8 %a to i32
  %r = and i32 %s, 2147483647 ; 0x7fffffff
  ret i32 %r
}

; Negative test - mask constant is too small.

define i32 @lowbitmask_casted_shift_wrong_mask2(i8 %x) {
; CHECK-LABEL: @lowbitmask_casted_shift_wrong_mask2(
; CHECK-NEXT:    [[A:%.*]] = ashr i8 [[X:%.*]], 2
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[A]] to i32
; CHECK-NEXT:    [[R:%.*]] = and i32 [[S]], 536870911
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i8 %x, 2
  %s = sext i8 %a to i32
  %r = and i32 %s, 536870911  ; 0x1fffffff
  ret i32 %r
}

; Extra use of shift is ok.

define i32 @lowbitmask_casted_shift_use1(i8 %x) {
; CHECK-LABEL: @lowbitmask_casted_shift_use1(
; CHECK-NEXT:    [[A:%.*]] = ashr i8 [[X:%.*]], 3
; CHECK-NEXT:    call void @use8(i8 [[A]])
; CHECK-NEXT:    [[TMP1:%.*]] = sext i8 [[X]] to i32
; CHECK-NEXT:    [[R:%.*]] = lshr i32 [[TMP1]], 3
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i8 %x, 3
  call void @use8(i8 %a)
  %s = sext i8 %a to i32
  %r = and i32 %s, 536870911
  ret i32 %r
}

; Negative test - extra use of sext requires more instructions.

define i32 @lowbitmask_casted_shift_use2(i8 %x) {
; CHECK-LABEL: @lowbitmask_casted_shift_use2(
; CHECK-NEXT:    [[A:%.*]] = ashr i8 [[X:%.*]], 3
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[A]] to i32
; CHECK-NEXT:    call void @use32(i32 [[S]])
; CHECK-NEXT:    [[R:%.*]] = and i32 [[S]], 536870911
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = ashr i8 %x, 3
  %s = sext i8 %a to i32
  call void @use32(i32 %s)
  %r = and i32 %s, 536870911
  ret i32 %r
}

; Vectors/weird types are ok.

define <2 x i59> @lowbitmask_casted_shift_vec_splat(<2 x i47> %x) {
; CHECK-LABEL: @lowbitmask_casted_shift_vec_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = sext <2 x i47> [[X:%.*]] to <2 x i59>
; CHECK-NEXT:    [[R:%.*]] = lshr <2 x i59> [[TMP1]], <i59 5, i59 5>
; CHECK-NEXT:    ret <2 x i59> [[R]]
;
  %a = ashr <2 x i47> %x, <i47 5, i47 5>
  %s = sext <2 x i47> %a to <2 x i59>
  %r = and <2 x i59> %s, <i59 18014398509481983, i59 18014398509481983>  ;  -1 u>> 5 == 0x3f_ffff_ffff_ffff
  ret <2 x i59> %r
}

define i32 @lowmask_sext_in_reg(i32 %x) {
; CHECK-LABEL: @lowmask_sext_in_reg(
; CHECK-NEXT:    [[L:%.*]] = shl i32 [[X:%.*]], 20
; CHECK-NEXT:    [[R:%.*]] = ashr exact i32 [[L]], 20
; CHECK-NEXT:    call void @use32(i32 [[R]])
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[R]], 4095
; CHECK-NEXT:    ret i32 [[AND]]
;
  %l = shl i32 %x, 20
  %r = ashr i32 %l, 20
  call void @use32(i32 %r)
  %and = and i32 %r, 4095
  ret i32 %and
}

define i32 @lowmask_not_sext_in_reg(i32 %x) {
; CHECK-LABEL: @lowmask_not_sext_in_reg(
; CHECK-NEXT:    [[L:%.*]] = shl i32 [[X:%.*]], 19
; CHECK-NEXT:    [[R:%.*]] = ashr i32 [[L]], 20
; CHECK-NEXT:    call void @use32(i32 [[R]])
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[R]], 4095
; CHECK-NEXT:    ret i32 [[AND]]
;
  %l = shl i32 %x, 19
  %r = ashr i32 %l, 20
  call void @use32(i32 %r)
  %and = and i32 %r, 4095
  ret i32 %and
}

define i32 @not_lowmask_sext_in_reg(i32 %x) {
; CHECK-LABEL: @not_lowmask_sext_in_reg(
; CHECK-NEXT:    [[L:%.*]] = shl i32 [[X:%.*]], 20
; CHECK-NEXT:    [[R:%.*]] = ashr exact i32 [[L]], 20
; CHECK-NEXT:    call void @use32(i32 [[R]])
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[R]], 4096
; CHECK-NEXT:    ret i32 [[AND]]
;
  %l = shl i32 %x, 20
  %r = ashr i32 %l, 20
  call void @use32(i32 %r)
  %and = and i32 %r, 4096
  ret i32 %and
}

define i32 @not_lowmask_sext_in_reg2(i32 %x) {
; CHECK-LABEL: @not_lowmask_sext_in_reg2(
; CHECK-NEXT:    [[L:%.*]] = shl i32 [[X:%.*]], 21
; CHECK-NEXT:    [[R:%.*]] = ashr exact i32 [[L]], 21
; CHECK-NEXT:    call void @use32(i32 [[R]])
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[R]], 4095
; CHECK-NEXT:    ret i32 [[AND]]
;
  %l = shl i32 %x, 21
  %r = ashr i32 %l, 21
  call void @use32(i32 %r)
  %and = and i32 %r, 4095
  ret i32 %and
}

define <2 x i32> @lowmask_sext_in_reg_splat(<2 x i32> %x, <2 x i32>* %p) {
; CHECK-LABEL: @lowmask_sext_in_reg_splat(
; CHECK-NEXT:    [[L:%.*]] = shl <2 x i32> [[X:%.*]], <i32 20, i32 20>
; CHECK-NEXT:    [[R:%.*]] = ashr exact <2 x i32> [[L]], <i32 20, i32 20>
; CHECK-NEXT:    store <2 x i32> [[R]], <2 x i32>* [[P:%.*]], align 8
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[R]], <i32 4095, i32 4095>
; CHECK-NEXT:    ret <2 x i32> [[AND]]
;
  %l = shl <2 x i32> %x, <i32 20, i32 20>
  %r = ashr <2 x i32> %l, <i32 20, i32 20>
  store <2 x i32> %r, <2 x i32>* %p
  %and = and <2 x i32> %r, <i32 4095, i32 4095>
  ret <2 x i32> %and
}

define i8 @lowmask_add(i8 %x) {
; CHECK-LABEL: @lowmask_add(
; CHECK-NEXT:    [[A:%.*]] = add i8 [[X:%.*]], -64
; CHECK-NEXT:    call void @use8(i8 [[A]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[X]], 32
; CHECK-NEXT:    ret i8 [[R]]
;
  %a = add i8 %x, -64 ; 0xc0
  call void @use8(i8 %a)
  %r = and i8 %a, 32 ; 0x20
  ret i8 %r
}

define i8 @lowmask_add_2(i8 %x) {
; CHECK-LABEL: @lowmask_add_2(
; CHECK-NEXT:    [[R:%.*]] = and i8 [[X:%.*]], 63
; CHECK-NEXT:    ret i8 [[R]]
;
  %a = add i8 %x, -64 ; 0xc0
  %r = and i8 %a, 63 ; 0x3f
  ret i8 %r
}

define i8 @lowmask_add_2_uses(i8 %x) {
; CHECK-LABEL: @lowmask_add_2_uses(
; CHECK-NEXT:    [[A:%.*]] = add i8 [[X:%.*]], -64
; CHECK-NEXT:    call void @use8(i8 [[A]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[X]], 63
; CHECK-NEXT:    ret i8 [[R]]
;
  %a = add i8 %x, -64 ; 0xc0
  call void @use8(i8 %a)
  %r = and i8 %a, 63 ; 0x3f
  ret i8 %r
}

define <2 x i8> @lowmask_add_2_splat(<2 x i8> %x, <2 x i8>* %p) {
; CHECK-LABEL: @lowmask_add_2_splat(
; CHECK-NEXT:    [[A:%.*]] = add <2 x i8> [[X:%.*]], <i8 -64, i8 -64>
; CHECK-NEXT:    store <2 x i8> [[A]], <2 x i8>* [[P:%.*]], align 2
; CHECK-NEXT:    [[R:%.*]] = and <2 x i8> [[X]], <i8 63, i8 63>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a = add <2 x i8> %x, <i8 -64, i8 -64> ; 0xc0
  store <2 x i8> %a, <2 x i8>* %p
  %r = and <2 x i8> %a, <i8 63, i8 63> ; 0x3f
  ret <2 x i8> %r
}

define i8 @not_lowmask_add(i8 %x) {
; CHECK-LABEL: @not_lowmask_add(
; CHECK-NEXT:    [[A:%.*]] = add i8 [[X:%.*]], -64
; CHECK-NEXT:    call void @use8(i8 [[A]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[A]], 64
; CHECK-NEXT:    ret i8 [[R]]
;
  %a = add i8 %x, -64 ; 0xc0
  call void @use8(i8 %a)
  %r = and i8 %a, 64 ; 0x40
  ret i8 %r
}

define i8 @not_lowmask_add2(i8 %x) {
; CHECK-LABEL: @not_lowmask_add2(
; CHECK-NEXT:    [[A:%.*]] = add i8 [[X:%.*]], -96
; CHECK-NEXT:    call void @use8(i8 [[A]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[A]], 63
; CHECK-NEXT:    ret i8 [[R]]
;
  %a = add i8 %x, -96 ; 0xe0
  call void @use8(i8 %a)
  %r = and i8 %a, 63 ; 0x3f
  ret i8 %r
}

define <2 x i8> @lowmask_add_splat(<2 x i8> %x, <2 x i8>* %p) {
; CHECK-LABEL: @lowmask_add_splat(
; CHECK-NEXT:    [[A:%.*]] = add <2 x i8> [[X:%.*]], <i8 -64, i8 -64>
; CHECK-NEXT:    store <2 x i8> [[A]], <2 x i8>* [[P:%.*]], align 2
; CHECK-NEXT:    [[R:%.*]] = and <2 x i8> [[X]], <i8 32, i8 32>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a = add <2 x i8> %x, <i8 -64, i8 -64> ; 0xc0
  store <2 x i8> %a, <2 x i8>* %p
  %r = and <2 x i8> %a, <i8 32, i8 32> ; 0x20
  ret <2 x i8> %r
}

define <2 x i8> @lowmask_add_splat_undef(<2 x i8> %x, <2 x i8>* %p) {
; CHECK-LABEL: @lowmask_add_splat_undef(
; CHECK-NEXT:    [[A:%.*]] = add <2 x i8> [[X:%.*]], <i8 -64, i8 undef>
; CHECK-NEXT:    store <2 x i8> [[A]], <2 x i8>* [[P:%.*]], align 2
; CHECK-NEXT:    [[R:%.*]] = and <2 x i8> [[A]], <i8 undef, i8 32>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a = add <2 x i8> %x, <i8 -64, i8 undef> ; 0xc0
  store <2 x i8> %a, <2 x i8>* %p
  %r = and <2 x i8> %a, <i8 undef, i8 32> ; 0x20
  ret <2 x i8> %r
}

define <2 x i8> @lowmask_add_vec(<2 x i8> %x, <2 x i8>* %p) {
; CHECK-LABEL: @lowmask_add_vec(
; CHECK-NEXT:    [[A:%.*]] = add <2 x i8> [[X:%.*]], <i8 -96, i8 -64>
; CHECK-NEXT:    store <2 x i8> [[A]], <2 x i8>* [[P:%.*]], align 2
; CHECK-NEXT:    [[R:%.*]] = and <2 x i8> [[A]], <i8 16, i8 32>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a = add <2 x i8> %x, <i8 -96, i8 -64> ; 0xe0, 0xc0
  store <2 x i8> %a, <2 x i8>* %p
  %r = and <2 x i8> %a, <i8 16, i8 32> ; 0x10, 0x20
  ret <2 x i8> %r
}

; Only one bit set
define i8 @flip_masked_bit(i8 %A) {
; CHECK-LABEL: @flip_masked_bit(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[A:%.*]], 16
; CHECK-NEXT:    [[C:%.*]] = xor i8 [[TMP1]], 16
; CHECK-NEXT:    ret i8 [[C]]
;
  %B = add i8 %A, 16
  %C = and i8 %B, 16
  ret i8 %C
}

define <2 x i8> @flip_masked_bit_uniform(<2 x i8> %A) {
; CHECK-LABEL: @flip_masked_bit_uniform(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i8> [[A:%.*]], <i8 16, i8 16>
; CHECK-NEXT:    [[C:%.*]] = xor <2 x i8> [[TMP1]], <i8 16, i8 16>
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %B = add <2 x i8> %A, <i8 16, i8 16>
  %C = and <2 x i8> %B, <i8 16, i8 16>
  ret <2 x i8> %C
}

define <2 x i8> @flip_masked_bit_undef(<2 x i8> %A) {
; CHECK-LABEL: @flip_masked_bit_undef(
; CHECK-NEXT:    [[B:%.*]] = add <2 x i8> [[A:%.*]], <i8 16, i8 undef>
; CHECK-NEXT:    [[C:%.*]] = and <2 x i8> [[B]], <i8 16, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %B = add <2 x i8> %A, <i8 16, i8 undef>
  %C = and <2 x i8> %B, <i8 16, i8 undef>
  ret <2 x i8> %C
}

define <2 x i8> @flip_masked_bit_nonuniform(<2 x i8> %A) {
; CHECK-LABEL: @flip_masked_bit_nonuniform(
; CHECK-NEXT:    [[B:%.*]] = add <2 x i8> [[A:%.*]], <i8 16, i8 4>
; CHECK-NEXT:    [[C:%.*]] = and <2 x i8> [[B]], <i8 16, i8 4>
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %B = add <2 x i8> %A, <i8 16, i8 4>
  %C = and <2 x i8> %B, <i8 16, i8 4>
  ret <2 x i8> %C
}
