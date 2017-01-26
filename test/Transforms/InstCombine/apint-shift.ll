; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; This test makes sure that shift instructions are properly eliminated
; even with arbitrary precision integers.
; RUN: opt < %s -instcombine -S | FileCheck %s

define i47 @test1(i47 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i47 %A
;
  %B = shl i47 %A, 0
  ret i47 %B
}

define i41 @test2(i7 %X) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i41 0
;
  %A = zext i7 %X to i41
  %B = shl i41 0, %A
  ret i41 %B
}

define i41 @test3(i41 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i41 %A
;
  %B = ashr i41 %A, 0
  ret i41 %B
}

define i39 @test4(i7 %X) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret i39 0
;
  %A = zext i7 %X to i39
  %B = ashr i39 0, %A
  ret i39 %B
}

define i55 @test5(i55 %A) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i55 undef
;
  %B = lshr i55 %A, 55
  ret i55 %B
}

define i32 @test5a(i32 %A) {
; CHECK-LABEL: @test5a(
; CHECK-NEXT:    ret i32 undef
;
  %B = shl i32 %A, 32
  ret i32 %B
}

define i55 @test6(i55 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[C:%.*]] = mul i55 %A, 6
; CHECK-NEXT:    ret i55 [[C]]
;
  %B = shl i55 %A, 1
  %C = mul i55 %B, 3
  ret i55 %C
}

define i55 @test6a(i55 %A) {
; CHECK-LABEL: @test6a(
; CHECK-NEXT:    [[C:%.*]] = mul i55 %A, 6
; CHECK-NEXT:    ret i55 [[C]]
;
  %B = mul i55 %A, 3
  %C = shl i55 %B, 1
  ret i55 %C
}

define i29 @test7(i8 %X) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i29 -1
;
  %A = zext i8 %X to i29
  %B = ashr i29 -1, %A
  ret i29 %B
}

define i7 @test8(i7 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i7 0
;
  %B = shl i7 %A, 4
  %C = shl i7 %B, 3
  ret i7 %C
}

define i17 @test9(i17 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[B:%.*]] = and i17 %A, 1
; CHECK-NEXT:    ret i17 [[B]]
;
  %B = shl i17 %A, 16
  %C = lshr i17 %B, 16
  ret i17 %C
}

; shl (lshr X, C), C --> and X, C'

define i19 @test10(i19 %X) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[SH1:%.*]] = and i19 %X, -262144
; CHECK-NEXT:    ret i19 [[SH1]]
;
  %sh1 = lshr i19 %X, 18
  %sh2 = shl i19 %sh1, 18
  ret i19 %sh2
}

; Two right shifts in the same direction:
; lshr (lshr X, C1), C2 --> lshr X, C1 + C2

define <2 x i19> @lshr_lshr_splat_vec(<2 x i19> %X) {
; CHECK-LABEL: @lshr_lshr_splat_vec(
; CHECK-NEXT:    [[SH1:%.*]] = lshr <2 x i19> %X, <i19 5, i19 5>
; CHECK-NEXT:    ret <2 x i19> [[SH1]]
;
  %sh1 = lshr <2 x i19> %X, <i19 3, i19 3>
  %sh2 = lshr <2 x i19> %sh1, <i19 2, i19 2>
  ret <2 x i19> %sh2
}

; Two left shifts in the same direction:
; shl (shl X, C1), C2 -->  shl X, C1 + C2

define <2 x i19> @shl_shl_splat_vec(<2 x i19> %X) {
; CHECK-LABEL: @shl_shl_splat_vec(
; CHECK-NEXT:    [[SH1:%.*]] = shl <2 x i19> %X, <i19 5, i19 5>
; CHECK-NEXT:    ret <2 x i19> [[SH1]]
;
  %sh1 = shl <2 x i19> %X, <i19 3, i19 3>
  %sh2 = shl <2 x i19> %sh1, <i19 2, i19 2>
  ret <2 x i19> %sh2
}

; Equal shift amounts in opposite directions become bitwise 'and':
; lshr (shl X, C), C --> and X, C'

define <2 x i19> @eq_shl_lshr_splat_vec(<2 x i19> %X) {
; CHECK-LABEL: @eq_shl_lshr_splat_vec(
; CHECK-NEXT:    [[SH1:%.*]] = and <2 x i19> %X, <i19 65535, i19 65535>
; CHECK-NEXT:    ret <2 x i19> [[SH1]]
;
  %sh1 = shl <2 x i19> %X, <i19 3, i19 3>
  %sh2 = lshr <2 x i19> %sh1, <i19 3, i19 3>
  ret <2 x i19> %sh2
}

; Equal shift amounts in opposite directions become bitwise 'and':
; shl (lshr X, C), C --> and X, C'

define <2 x i19> @eq_lshr_shl_splat_vec(<2 x i19> %X) {
; CHECK-LABEL: @eq_lshr_shl_splat_vec(
; CHECK-NEXT:    [[SH1:%.*]] = and <2 x i19> %X, <i19 -8, i19 -8>
; CHECK-NEXT:    ret <2 x i19> [[SH1]]
;
  %sh1 = lshr <2 x i19> %X, <i19 3, i19 3>
  %sh2 = shl <2 x i19> %sh1, <i19 3, i19 3>
  ret <2 x i19> %sh2
}

; In general, we would need an 'and' for this transform, but the masked-off bits are known zero.
; shl (lshr X, C1), C2 --> lshr X, C1 - C2

define <2 x i7> @lshr_shl_splat_vec(<2 x i7> %X) {
; CHECK-LABEL: @lshr_shl_splat_vec(
; CHECK-NEXT:    [[MUL:%.*]] = mul <2 x i7> %X, <i7 -8, i7 -8>
; CHECK-NEXT:    [[SH1:%.*]] = lshr exact <2 x i7> [[MUL]], <i7 1, i7 1>
; CHECK-NEXT:    ret <2 x i7> [[SH1]]
;
  %mul = mul <2 x i7> %X, <i7 -8, i7 -8>
  %sh1 = lshr exact <2 x i7> %mul, <i7 3, i7 3>
  %sh2 = shl nuw nsw <2 x i7> %sh1, <i7 2, i7 2>
  ret <2 x i7> %sh2
}

; In general, we would need an 'and' for this transform, but the masked-off bits are known zero.
; lshr (shl X, C1), C2 -->  shl X, C1 - C2

define <2 x i7> @shl_lshr_splat_vec(<2 x i7> %X) {
; CHECK-LABEL: @shl_lshr_splat_vec(
; CHECK-NEXT:    [[DIV:%.*]] = udiv <2 x i7> %X, <i7 9, i7 9>
; CHECK-NEXT:    [[SH1:%.*]] = shl nuw nsw <2 x i7> [[DIV]], <i7 1, i7 1>
; CHECK-NEXT:    ret <2 x i7> [[SH1]]
;
  %div = udiv <2 x i7> %X, <i7 9, i7 9>
  %sh1 = shl nuw <2 x i7> %div, <i7 3, i7 3>
  %sh2 = lshr exact <2 x i7> %sh1, <i7 2, i7 2>
  ret <2 x i7> %sh2
}

; Don't hide the shl from scalar evolution. DAGCombine will get it.
define i23 @test11(i23 %A) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[A:%.*]] = mul i23 %A, 3
; CHECK-NEXT:    [[B:%.*]] = lshr i23 [[A]], 11
; CHECK-NEXT:    [[C:%.*]] = shl i23 [[B]], 12
; CHECK-NEXT:    ret i23 [[C]]
;
  %a = mul i23 %A, 3
  %B = lshr i23 %a, 11
  %C = shl i23 %B, 12
  ret i23 %C
}

; shl (ashr X, C), C --> and X, C'

define i47 @test12(i47 %X) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[SH11:%.*]] = and i47 %X, -256
; CHECK-NEXT:    ret i47 [[SH11]]
;
  %sh1 = ashr i47 %X, 8
  %sh2 = shl i47 %sh1, 8
  ret i47 %sh2
}

; FIXME: Same as above with vectors.

define <2 x i47> @test12_splat_vec(<2 x i47> %X) {
; CHECK-LABEL: @test12_splat_vec(
; CHECK-NEXT:    [[SH1:%.*]] = ashr <2 x i47> %X, <i47 8, i47 8>
; CHECK-NEXT:    [[SH2:%.*]] = shl nsw <2 x i47> [[SH1]], <i47 8, i47 8>
; CHECK-NEXT:    ret <2 x i47> [[SH2]]
;
  %sh1 = ashr <2 x i47> %X, <i47 8, i47 8>
  %sh2 = shl <2 x i47> %sh1, <i47 8, i47 8>
  ret <2 x i47> %sh2
}

; Don't hide the shl from scalar evolution. DAGCombine will get it.
define i18 @test13(i18 %A) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[A:%.*]] = mul i18 %A, 3
; CHECK-NEXT:    [[B1:%.*]] = lshr i18 [[A]], 8
; CHECK-NEXT:    [[C:%.*]] = shl i18 [[B1]], 9
; CHECK-NEXT:    ret i18 [[C]]
;
  %a = mul i18 %A, 3
  %B = ashr i18 %a, 8
  %C = shl i18 %B, 9
  ret i18 %C
}

define i35 @test14(i35 %A) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[B:%.*]] = and i35 %A, -19760
; CHECK-NEXT:    [[C:%.*]] = or i35 [[B]], 19744
; CHECK-NEXT:    ret i35 [[C]]
;
  %B = lshr i35 %A, 4
  %C = or i35 %B, 1234
  %D = shl i35 %C, 4
  ret i35 %D
}

define i79 @test14a(i79 %A) {
; CHECK-LABEL: @test14a(
; CHECK-NEXT:    [[C:%.*]] = and i79 %A, 77
; CHECK-NEXT:    ret i79 [[C]]
;
  %B = shl i79 %A, 4
  %C = and i79 %B, 1234
  %D = lshr i79 %C, 4
  ret i79 %D
}

define i45 @test15(i1 %C) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[A:%.*]] = select i1 %C, i45 12, i45 4
; CHECK-NEXT:    ret i45 [[A]]
;
  %A = select i1 %C, i45 3, i45 1
  %V = shl i45 %A, 2
  ret i45 %V
}

define i53 @test15a(i1 %X) {
; CHECK-LABEL: @test15a(
; CHECK-NEXT:    [[V:%.*]] = select i1 %X, i53 512, i53 128
; CHECK-NEXT:    ret i53 [[V]]
;
  %A = select i1 %X, i8 3, i8 1
  %B = zext i8 %A to i53
  %V = shl i53 64, %B
  ret i53 %V
}

define i1 @test16(i84 %X) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[AND:%.*]] = and i84 %X, 16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i84 [[AND]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %shr = ashr i84 %X, 4
  %and = and i84 %shr, 1
  %cmp = icmp ne i84 %and, 0
  ret i1 %cmp
}

define <2 x i1> @test16vec(<2 x i84> %X) {
; CHECK-LABEL: @test16vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i84> %X, <i84 16, i84 16>
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne <2 x i84> [[AND]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %shr = ashr <2 x i84> %X, <i84 4, i84 4>
  %and = and <2 x i84> %shr, <i84 1, i84 1>
  %cmp = icmp ne <2 x i84> %and, zeroinitializer
  ret <2 x i1> %cmp
}

define i1 @test17(i106 %A) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[B_MASK:%.*]] = and i106 %A, -8
; CHECK-NEXT:    [[C:%.*]] = icmp eq i106 [[B_MASK]], 9872
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = lshr i106 %A, 3
  %C = icmp eq i106 %B, 1234
  ret i1 %C
}

define <2 x i1> @test17vec(<2 x i106> %A) {
; CHECK-LABEL: @test17vec(
; CHECK-NEXT:    [[B_MASK:%.*]] = and <2 x i106> %A, <i106 -8, i106 -8>
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i106> [[B_MASK]], <i106 9872, i106 9872>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = lshr <2 x i106> %A, <i106 3, i106 3>
  %C = icmp eq <2 x i106> %B, <i106 1234, i106 1234>
  ret <2 x i1> %C
}

define i1 @test18(i11 %A) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    ret i1 false
;
  %B = lshr i11 %A, 10
  %C = icmp eq i11 %B, 123
  ret i1 %C
}

define i1 @test19(i37 %A) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i37 %A, 4
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = ashr i37 %A, 2
  %C = icmp eq i37 %B, 0
  ret i1 %C
}

define <2 x i1> @test19vec(<2 x i37> %A) {
; CHECK-LABEL: @test19vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ult <2 x i37> %A, <i37 4, i37 4>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = ashr <2 x i37> %A, <i37 2, i37 2>
  %C = icmp eq <2 x i37> %B, zeroinitializer
  ret <2 x i1> %C
}

define i1 @test19a(i39 %A) {
; CHECK-LABEL: @test19a(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i39 %A, -5
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = ashr i39 %A, 2
  %C = icmp eq i39 %B, -1
  ret i1 %C
}

define <2 x i1> @test19a_vec(<2 x i39> %A) {
; CHECK-LABEL: @test19a_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt <2 x i39> %A, <i39 -5, i39 -5>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = ashr <2 x i39> %A, <i39 2, i39 2>
  %C = icmp eq <2 x i39> %B, <i39 -1, i39 -1>
  ret <2 x i1> %C
}

define i1 @test20(i13 %A) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    ret i1 false
;
  %B = ashr i13 %A, 12
  %C = icmp eq i13 %B, 123
  ret i1 %C
}

define i1 @test21(i12 %A) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    [[B_MASK:%.*]] = and i12 %A, 63
; CHECK-NEXT:    [[C:%.*]] = icmp eq i12 [[B_MASK]], 62
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = shl i12 %A, 6
  %C = icmp eq i12 %B, -128
  ret i1 %C
}

define i1 @test22(i14 %A) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    [[B_MASK:%.*]] = and i14 %A, 127
; CHECK-NEXT:    [[C:%.*]] = icmp eq i14 [[B_MASK]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = shl i14 %A, 7
  %C = icmp eq i14 %B, 0
  ret i1 %C
}

define i11 @test23(i44 %A) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    [[D:%.*]] = trunc i44 %A to i11
; CHECK-NEXT:    ret i11 [[D]]
;
  %B = shl i44 %A, 33
  %C = ashr i44 %B, 33
  %D = trunc i44 %C to i11
  ret i11 %D
}

; Fold lshr (shl X, C), C -> and X, C' regardless of the number of uses of the shl.

define i44 @shl_lshr_eq_amt_multi_use(i44 %A) {
; CHECK-LABEL: @shl_lshr_eq_amt_multi_use(
; CHECK-NEXT:    [[B:%.*]] = shl i44 %A, 33
; CHECK-NEXT:    [[C:%.*]] = and i44 %A, 2047
; CHECK-NEXT:    [[D:%.*]] = or i44 [[B]], [[C]]
; CHECK-NEXT:    ret i44 [[D]]
;
  %B = shl i44 %A, 33
  %C = lshr i44 %B, 33
  %D = add i44 %B, %C
  ret i44 %D
}

; Fold vector lshr (shl X, C), C -> and X, C' regardless of the number of uses of the shl.

define <2 x i44> @shl_lshr_eq_amt_multi_use_splat_vec(<2 x i44> %A) {
; CHECK-LABEL: @shl_lshr_eq_amt_multi_use_splat_vec(
; CHECK-NEXT:    [[B:%.*]] = shl <2 x i44> %A, <i44 33, i44 33>
; CHECK-NEXT:    [[C:%.*]] = and <2 x i44> %A, <i44 2047, i44 2047>
; CHECK-NEXT:    [[D:%.*]] = or <2 x i44> [[B]], [[C]]
; CHECK-NEXT:    ret <2 x i44> [[D]]
;
  %B = shl <2 x i44> %A, <i44 33, i44 33>
  %C = lshr <2 x i44> %B, <i44 33, i44 33>
  %D = add <2 x i44> %B, %C
  ret <2 x i44> %D
}

; FIXME: Fold shl (lshr X, C), C -> and X, C' regardless of the number of uses of the lshr.

define i43 @lshr_shl_eq_amt_multi_use(i43 %A) {
; CHECK-LABEL: @lshr_shl_eq_amt_multi_use(
; CHECK-NEXT:    [[B:%.*]] = lshr i43 %A, 23
; CHECK-NEXT:    [[C:%.*]] = shl nuw i43 [[B]], 23
; CHECK-NEXT:    [[D:%.*]] = mul i43 [[B]], [[C]]
; CHECK-NEXT:    ret i43 [[D]]
;
  %B = lshr i43 %A, 23
  %C = shl i43 %B, 23
  %D = mul i43 %B, %C
  ret i43 %D
}

; FIXME: Fold vector shl (lshr X, C), C -> and X, C' regardless of the number of uses of the lshr.

define <2 x i43> @lshr_shl_eq_amt_multi_use_splat_vec(<2 x i43> %A) {
; CHECK-LABEL: @lshr_shl_eq_amt_multi_use_splat_vec(
; CHECK-NEXT:    [[B:%.*]] = lshr <2 x i43> %A, <i43 23, i43 23>
; CHECK-NEXT:    [[C:%.*]] = shl nuw <2 x i43> [[B]], <i43 23, i43 23>
; CHECK-NEXT:    [[D:%.*]] = mul <2 x i43> [[B]], [[C]]
; CHECK-NEXT:    ret <2 x i43> [[D]]
;
  %B = lshr <2 x i43> %A, <i43 23, i43 23>
  %C = shl <2 x i43> %B, <i43 23, i43 23>
  %D = mul <2 x i43> %B, %C
  ret <2 x i43> %D
}

define i37 @test25(i37 %tmp.2, i37 %AA) {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    [[TMP_3:%.*]] = and i37 %tmp.2, -131072
; CHECK-NEXT:    [[X2:%.*]] = add i37 [[TMP_3]], %AA
; CHECK-NEXT:    [[TMP_6:%.*]] = and i37 [[X2]], -131072
; CHECK-NEXT:    ret i37 [[TMP_6]]
;
  %x = lshr i37 %AA, 17
  %tmp.3 = lshr i37 %tmp.2, 17
  %tmp.5 = add i37 %tmp.3, %x
  %tmp.6 = shl i37 %tmp.5, 17
  ret i37 %tmp.6
}

define i40 @test26(i40 %A) {
; CHECK-LABEL: @test26(
; CHECK-NEXT:    [[B:%.*]] = and i40 %A, -2
; CHECK-NEXT:    ret i40 [[B]]
;
  %B = lshr i40 %A, 1
  %C = bitcast i40 %B to i40
  %D = shl i40 %C, 1
  ret i40 %D
}
