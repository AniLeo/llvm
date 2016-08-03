; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 %A
;
  %B = add i32 %A, 0
  ret i32 %B
}

define i32 @test2(i32 %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i32 %A
;
  %B = add i32 %A, 5
  %C = add i32 %B, -5
  ret i32 %C
}

define i32 @test3(i32 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i32 %A
;
  %B = add i32 %A, 5
  ;; This should get converted to an add
  %C = sub i32 %B, 5
  ret i32 %C
}

define i32 @test4(i32 %A, i32 %B) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[D:%.*]] = sub i32 %B, %A
; CHECK-NEXT:    ret i32 [[D]]
;
  %C = sub i32 0, %A
  ; D = B + -A = B - A
  %D = add i32 %B, %C
  ret i32 %D
}

define i32 @test5(i32 %A, i32 %B) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[D:%.*]] = sub i32 %B, %A
; CHECK-NEXT:    ret i32 [[D]]
;
  %C = sub i32 0, %A
  ; D = -A + B = B - A
  %D = add i32 %C, %B
  ret i32 %D
}

define i32 @test6(i32 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[C:%.*]] = shl i32 %A, 3
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = mul i32 7, %A
  ; C = 7*A+A == 8*A == A << 3
  %C = add i32 %B, %A
  ret i32 %C
}

define i32 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[C:%.*]] = shl i32 %A, 3
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = mul i32 7, %A
  ; C = A+7*A == 8*A == A << 3
  %C = add i32 %A, %B
  ret i32 %C
}

; (A & C1)+(B & C2) -> (A & C1)|(B & C2) iff C1&C2 == 0
define i32 @test8(i32 %A, i32 %B) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[A1:%.*]] = and i32 %A, 7
; CHECK-NEXT:    [[B1:%.*]] = and i32 %B, 128
; CHECK-NEXT:    [[C:%.*]] = or i32 [[A1]], [[B1]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A1 = and i32 %A, 7
  %B1 = and i32 %B, 128
  %C = add i32 %A1, %B1
  ret i32 %C
}

define i32 @test9(i32 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[C:%.*]] = shl i32 %A, 5
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = shl i32 %A, 4
  ; === shl int %A, 5
  %C = add i32 %B, %B
  ret i32 %C
}

define i1 @test10(i8 %A, i8 %b) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[B:%.*]] = sub i8 0, %b
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 %A, [[B]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = add i8 %A, %b
  ; === A != -b
  %c = icmp ne i8 %B, 0
  ret i1 %c
}

define <2 x i1> @test10vec(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @test10vec(
; CHECK-NEXT:    [[C:%.*]] = sub <2 x i8> zeroinitializer, %b
; CHECK-NEXT:    [[D:%.*]] = icmp ne <2 x i8> %a, [[C]]
; CHECK-NEXT:    ret <2 x i1> [[D]]
;
  %c = add <2 x i8> %a, %b
  %d = icmp ne <2 x i8> %c, zeroinitializer
  ret <2 x i1> %d
}

define i1 @test11(i8 %A) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 %A, 1
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = add i8 %A, -1
  ; === A != 1
  %c = icmp ne i8 %B, 0
  ret i1 %c
}

define <2 x i1> @test11vec(<2 x i8> %a) {
; CHECK-LABEL: @test11vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i8> %a, <i8 1, i8 1>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add <2 x i8> %a, <i8 -1, i8 -1>
  %c = icmp ne <2 x i8> %b, zeroinitializer
  ret <2 x i1> %c
}

; Should be transformed into shl A, 1?

define i32 @test12(i32 %A, i32 %B) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    br label %X
; CHECK:       X:
; CHECK-NEXT:    [[C_OK:%.*]] = add i32 %B, %A
; CHECK-NEXT:    [[D:%.*]] = add i32 [[C_OK]], %A
; CHECK-NEXT:    ret i32 [[D]]
;
  %C_OK = add i32 %B, %A
  br label %X

X:              ; preds = %0
  %D = add i32 %C_OK, %A
  ret i32 %D
}

define i32 @test13(i32 %A, i32 %B, i32 %C) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[D_OK:%.*]] = add i32 %A, %B
; CHECK-NEXT:    [[E_OK:%.*]] = add i32 [[D_OK]], %C
; CHECK-NEXT:    [[F:%.*]] = add i32 [[E_OK]], %A
; CHECK-NEXT:    ret i32 [[F]]
;
  %D_OK = add i32 %A, %B
  %E_OK = add i32 %D_OK, %C
  ;; shl A, 1
  %F = add i32 %E_OK, %A
  ret i32 %F
}

define i32 @test14(i32 %offset, i32 %difference) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[TMP_2:%.*]] = and i32 %difference, 3
; CHECK-NEXT:    [[TMP_3_OK:%.*]] = add i32 [[TMP_2]], %offset
; CHECK-NEXT:    [[TMP_5_MASK:%.*]] = and i32 %difference, -4
; CHECK-NEXT:    [[TMP_8:%.*]] = add i32 [[TMP_3_OK]], [[TMP_5_MASK]]
; CHECK-NEXT:    ret i32 [[TMP_8]]
;
  %tmp.2 = and i32 %difference, 3
  %tmp.3_OK = add i32 %tmp.2, %offset
  %tmp.5.mask = and i32 %difference, -4
  ; == add %offset, %difference
  %tmp.8 = add i32 %tmp.3_OK, %tmp.5.mask
  ret i32 %tmp.8
}

define i8 @test15(i8 %A) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[C:%.*]] = and i8 %A, 16
; CHECK-NEXT:    ret i8 [[C]]
;
  %B = add i8 %A, -64
  ; Only one bit set
  %C = and i8 %B, 16
  ret i8 %C
}

define i8 @test16(i8 %A) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[B:%.*]] = and i8 %A, 16
; CHECK-NEXT:    [[C:%.*]] = xor i8 [[B]], 16
; CHECK-NEXT:    ret i8 [[C]]
;
  %B = add i8 %A, 16
  ; Only one bit set
  %C = and i8 %B, 16
  ret i8 %C
}

define i32 @test17(i32 %A) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[C:%.*]] = sub i32 0, %A
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = xor i32 %A, -1
  ; == sub int 0, %A
  %C = add i32 %B, 1
  ret i32 %C
}

define i8 @test18(i8 %A) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[C:%.*]] = sub i8 16, %A
; CHECK-NEXT:    ret i8 [[C]]
;
  %B = xor i8 %A, -1
  ; == sub ubyte 16, %A
  %C = add i8 %B, 17
  ret i8 %C
}

define i32 @test19(i1 %C) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[V:%.*]] = select i1 %C, i32 1123, i32 133
; CHECK-NEXT:    ret i32 [[V]]
;
  %A = select i1 %C, i32 1000, i32 10
  %V = add i32 %A, 123
  ret i32 %V
}

define i32 @test20(i32 %x) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    ret i32 %x
;
  %tmp.2 = xor i32 %x, -2147483648
  ;; Add of sign bit -> xor of sign bit.
  %tmp.4 = add i32 %tmp.2, -2147483648
  ret i32 %tmp.4
}

define i1 @test21(i32 %x) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    [[Y:%.*]] = icmp eq i32 %x, 119
; CHECK-NEXT:    ret i1 [[Y]]
;
  %t = add i32 %x, 4
  %y = icmp eq i32 %t, 123
  ret i1 %y
}

; FIXME: Vectors should fold the same way.
define <2 x i1> @test21vec(<2 x i32> %x) {
; CHECK-LABEL: @test21vec(
; CHECK-NEXT:    [[T:%.*]] = add <2 x i32> %x, <i32 4, i32 4>
; CHECK-NEXT:    [[Y:%.*]] = icmp eq <2 x i32> [[T]], <i32 123, i32 123>
; CHECK-NEXT:    ret <2 x i1> [[Y]]
;
  %t = add <2 x i32> %x, <i32 4, i32 4>
  %y = icmp eq <2 x i32> %t, <i32 123, i32 123>
  ret <2 x i1> %y
}

define i32 @test22(i32 %V) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    switch i32 %V, label %Default [
; CHECK-NEXT:    i32 10, label %Lab1
; CHECK-NEXT:    i32 20, label %Lab2
; CHECK-NEXT:    ]
; CHECK:       Default:
; CHECK-NEXT:    ret i32 123
; CHECK:       Lab1:
; CHECK-NEXT:    ret i32 12312
; CHECK:       Lab2:
; CHECK-NEXT:    ret i32 1231231
;
  %V2 = add i32 %V, 10
  switch i32 %V2, label %Default [
  i32 20, label %Lab1
  i32 30, label %Lab2
  ]

Default:                ; preds = %0
  ret i32 123

Lab1:           ; preds = %0
  ret i32 12312

Lab2:           ; preds = %0
  ret i32 1231231
}

define i32 @test23(i1 %C, i32 %a) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %C, label %endif, label %else
; CHECK:       else:
; CHECK-NEXT:    br label %endif
; CHECK:       endif:
; CHECK-NEXT:    [[B_0:%.*]] = phi i32 [ 1, %entry ], [ 2, %else ]
; CHECK-NEXT:    ret i32 [[B_0]]
;
entry:
  br i1 %C, label %endif, label %else

else:           ; preds = %entry
  br label %endif

endif:          ; preds = %else, %entry
  %b.0 = phi i32 [ 0, %entry ], [ 1, %else ]
  %tmp.4 = add i32 %b.0, 1
  ret i32 %tmp.4
}

define i32 @test24(i32 %A) {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[B:%.*]] = shl i32 %A, 1
; CHECK-NEXT:    ret i32 [[B]]
;
  %B = add i32 %A, 1
  %C = shl i32 %B, 1
  %D = sub i32 %C, 2
  ret i32 %D
}

define i64 @test25(i64 %Y) {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    [[TMP_8:%.*]] = shl i64 %Y, 3
; CHECK-NEXT:    ret i64 [[TMP_8]]
;
  %tmp.4 = shl i64 %Y, 2
  %tmp.12 = shl i64 %Y, 2
  %tmp.8 = add i64 %tmp.4, %tmp.12
  ret i64 %tmp.8
}

define i32 @test26(i32 %A, i32 %B) {
; CHECK-LABEL: @test26(
; CHECK-NEXT:    ret i32 %A
;
  %C = add i32 %A, %B
  %D = sub i32 %C, %B
  ret i32 %D
}

define i32 @test27(i1 %C, i32 %X, i32 %Y) {
; CHECK-LABEL: @test27(
; CHECK-NEXT:    [[C_UPGRD_1_V:%.*]] = select i1 %C, i32 %X, i32 123
; CHECK-NEXT:    ret i32 [[C_UPGRD_1_V]]
;
  %A = add i32 %X, %Y
  %B = add i32 %Y, 123
  ;; Fold add through select.
  %C.upgrd.1 = select i1 %C, i32 %A, i32 %B
  %D = sub i32 %C.upgrd.1, %Y
  ret i32 %D
}

define i32 @test28(i32 %X) {
; CHECK-LABEL: @test28(
; CHECK-NEXT:    [[Z:%.*]] = sub i32 -1192, %X
; CHECK-NEXT:    ret i32 [[Z]]
;
  %Y = add i32 %X, 1234
  %Z = sub i32 42, %Y
  ret i32 %Z
}

define i32 @test29(i32 %X, i32 %x) {
; CHECK-LABEL: @test29(
; CHECK-NEXT:    [[TMP_2:%.*]] = sub i32 %X, %x
; CHECK-NEXT:    [[TMP_7:%.*]] = and i32 %X, 63
; CHECK-NEXT:    [[TMP_9:%.*]] = and i32 [[TMP_2]], -64
; CHECK-NEXT:    [[TMP_10:%.*]] = or i32 [[TMP_7]], [[TMP_9]]
; CHECK-NEXT:    ret i32 [[TMP_10]]
;
  %tmp.2 = sub i32 %X, %x
  %tmp.2.mask = and i32 %tmp.2, 63
  %tmp.6 = add i32 %tmp.2.mask, %x
  %tmp.7 = and i32 %tmp.6, 63
  %tmp.9 = and i32 %tmp.2, -64
  %tmp.10 = or i32 %tmp.7, %tmp.9
  ret i32 %tmp.10
}

define i64 @test30(i64 %x) {
; CHECK-LABEL: @test30(
; CHECK-NEXT:    ret i64 %x
;
  %tmp.2 = xor i64 %x, -9223372036854775808
  ;; Add of sign bit -> xor of sign bit.
  %tmp.4 = add i64 %tmp.2, -9223372036854775808
  ret i64 %tmp.4
}

define i32 @test31(i32 %A) {
; CHECK-LABEL: @test31(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 %A, 5
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %B = add i32 %A, 4
  %C = mul i32 %B, 5
  %D = sub i32 %C, 20
  ret i32 %D
}

define i32 @test32(i32 %A) {
; CHECK-LABEL: @test32(
; CHECK-NEXT:    [[B:%.*]] = shl i32 %A, 2
; CHECK-NEXT:    ret i32 [[B]]
;
  %B = add i32 %A, 4
  %C = shl i32 %B, 2
  %D = sub i32 %C, 16
  ret i32 %D
}

define i8 @test33(i8 %A) {
; CHECK-LABEL: @test33(
; CHECK-NEXT:    [[C:%.*]] = or i8 %A, 1
; CHECK-NEXT:    ret i8 [[C]]
;
  %B = and i8 %A, -2
  %C = add i8 %B, 1
  ret i8 %C
}

define i8 @test34(i8 %A) {
; CHECK-LABEL: @test34(
; CHECK-NEXT:    [[C:%.*]] = and i8 %A, 12
; CHECK-NEXT:    ret i8 [[C]]
;
  %B = add i8 %A, 64
  %C = and i8 %B, 12
  ret i8 %C
}

define i32 @test35(i32 %a) {
; CHECK-LABEL: @test35(
; CHECK-NEXT:    ret i32 -1
;
  %tmpnot = xor i32 %a, -1
  %tmp2 = add i32 %tmpnot, %a
  ret i32 %tmp2
}

define i32 @test36(i32 %a) {
; CHECK-LABEL: @test36(
; CHECK-NEXT:    ret i32 0
;
  %x = and i32 %a, -2
  %y = and i32 %a, -126
  %z = add i32 %x, %y
  %q = and i32 %z, 1  ; always zero
  ret i32 %q
}

define i1 @test37(i32 %a, i32 %b) {
; CHECK-LABEL: @test37(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 %b, 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add i32 %a, %b
  %cmp = icmp eq i32 %add, %a
  ret i1 %cmp
}

define i1 @test38(i32 %a, i32 %b) {
; CHECK-LABEL: @test38(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 %a, 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add i32 %a, %b
  %cmp = icmp eq i32 %add, %b
  ret i1 %cmp
}

define i1 @test39(i32 %a, i32 %b) {
; CHECK-LABEL: @test39(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 %b, 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add i32 %b, %a
  %cmp = icmp eq i32 %add, %a
  ret i1 %cmp
}

define i1 @test40(i32 %a, i32 %b) {
; CHECK-LABEL: @test40(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 %a, 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add i32 %b, %a
  %cmp = icmp eq i32 %add, %b
  ret i1 %cmp
}
