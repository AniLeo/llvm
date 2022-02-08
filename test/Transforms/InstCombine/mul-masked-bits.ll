; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i32 @foo(i32 %x, i32 %y) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = and i32 [[Y:%.*]], 7
; CHECK-NEXT:    [[C:%.*]] = mul nuw nsw i32 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = shl nuw i32 [[C]], 26
; CHECK-NEXT:    [[E:%.*]] = ashr exact i32 [[D]], 26
; CHECK-NEXT:    ret i32 [[E]]
;
  %a = and i32 %x, 7
  %b = and i32 %y, 7
  %c = mul i32 %a, %b
  %d = shl i32 %c, 26
  %e = ashr i32 %d, 26
  ret i32 %e
}

; PR48683 'Quadratic Reciprocity' - and(mul(x,x),2) -> 0

define i1 @PR48683(i32 %x) {
; CHECK-LABEL: @PR48683(
; CHECK-NEXT:    ret i1 false
;
  %a = mul i32 %x, %x
  %b = and i32 %a, 2
  %c = icmp ne i32 %b, 0
  ret i1 %c
}

define <4 x i1> @PR48683_vec(<4 x i32> %x) {
; CHECK-LABEL: @PR48683_vec(
; CHECK-NEXT:    ret <4 x i1> zeroinitializer
;
  %a = mul <4 x i32> %x, %x
  %b = and <4 x i32> %a, <i32 2, i32 2, i32 2, i32 2>
  %c = icmp ne <4 x i32> %b, zeroinitializer
  ret <4 x i1> %c
}

define <4 x i1> @PR48683_vec_undef(<4 x i32> %x) {
; CHECK-LABEL: @PR48683_vec_undef(
; CHECK-NEXT:    [[A:%.*]] = mul <4 x i32> [[X:%.*]], [[X]]
; CHECK-NEXT:    [[B:%.*]] = and <4 x i32> [[A]], <i32 2, i32 2, i32 2, i32 undef>
; CHECK-NEXT:    [[C:%.*]] = icmp ne <4 x i32> [[B]], zeroinitializer
; CHECK-NEXT:    ret <4 x i1> [[C]]
;
  %a = mul <4 x i32> %x, %x
  %b = and <4 x i32> %a, <i32 2, i32 2, i32 2, i32 undef>
  %c = icmp ne <4 x i32> %b, zeroinitializer
  ret <4 x i1> %c
}

; mul(x,x) - bit[1] is 0, but if demanding the other bits the source must not be undef

define i64 @combine_mul_self_demandedbits(i64 %x) {
; CHECK-LABEL: @combine_mul_self_demandedbits(
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP1]], -3
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %1 = mul i64 %x, %x
  %2 = and i64 %1, -3
  ret i64 %2
}

define <4 x i32> @combine_mul_self_demandedbits_vector(<4 x i32> %x) {
; CHECK-LABEL: @combine_mul_self_demandedbits_vector(
; CHECK-NEXT:    [[TMP1:%.*]] = freeze <4 x i32> [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = mul <4 x i32> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = freeze <4 x i32> %x
  %2 = mul <4 x i32> %1, %1
  %3 = and <4 x i32> %2, <i32 -3, i32 -3, i32 -3, i32 -3>
  ret <4 x i32> %3
}

define i8 @one_demanded_bit(i8 %x) {
; CHECK-LABEL: @one_demanded_bit(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i8 [[X:%.*]], 6
; CHECK-NEXT:    [[R:%.*]] = or i8 [[TMP1]], -65
; CHECK-NEXT:    ret i8 [[R]]
;
  %m = mul i8 %x, 192  ; 0b1100_0000
  %r = or i8 %m, 191   ; 0b1011_1111
  ret i8 %r
}

define <2 x i8> @one_demanded_bit_splat(<2 x i8> %x) {
; CHECK-LABEL: @one_demanded_bit_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i8> [[X:%.*]], <i8 5, i8 5>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i8> [[TMP1]], <i8 32, i8 32>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %m = mul <2 x i8> %x, <i8 160, i8 160> ; 0b1010_0000
  %r = and <2 x i8> %m, <i8 32, i8 32>   ; 0b0010_0000
  ret <2 x i8> %r
}

define i67 @one_demanded_low_bit(i67 %x) {
; CHECK-LABEL: @one_demanded_low_bit(
; CHECK-NEXT:    [[R:%.*]] = and i67 [[X:%.*]], 1
; CHECK-NEXT:    ret i67 [[R]]
;
  %m = mul i67 %x, -63 ; any odd number will do
  %r = and i67 %m, 1
  ret i67 %r
}

define i33 @squared_one_demanded_low_bit(i33 %x) {
; CHECK-LABEL: @squared_one_demanded_low_bit(
; CHECK-NEXT:    [[TMP1:%.*]] = and i33 [[X:%.*]], 1
; CHECK-NEXT:    ret i33 [[TMP1]]
;
  %mul = mul i33 %x, %x
  %and = and i33 %mul, 1
  ret i33 %and
}

define <2 x i8> @squared_one_demanded_low_bit_splat(<2 x i8> %x) {
; CHECK-LABEL: @squared_one_demanded_low_bit_splat(
; CHECK-NEXT:    [[AND:%.*]] = or <2 x i8> [[X:%.*]], <i8 -2, i8 -2>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %mul = mul <2 x i8> %x, %x
  %and = or <2 x i8> %mul, <i8 254, i8 254>
  ret <2 x i8> %and
}

define i33 @squared_demanded_2_low_bits(i33 %x) {
; CHECK-LABEL: @squared_demanded_2_low_bits(
; CHECK-NEXT:    [[TMP1:%.*]] = and i33 [[X:%.*]], 1
; CHECK-NEXT:    ret i33 [[TMP1]]
;
  %mul = mul i33 %x, %x
  %and = and i33 %mul, 3
  ret i33 %and
}

define <2 x i8> @squared_demanded_2_low_bits_splat(<2 x i8> %x) {
; CHECK-LABEL: @squared_demanded_2_low_bits_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i8> [[X:%.*]], <i8 1, i8 1>
; CHECK-NEXT:    [[AND:%.*]] = or <2 x i8> [[TMP1]], <i8 -4, i8 -4>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %mul = mul <2 x i8> %x, %x
  %and = or <2 x i8> %mul, <i8 252, i8 252>
  ret <2 x i8> %and
}

; negative test

define i33 @squared_demanded_3_low_bits(i33 %x) {
; CHECK-LABEL: @squared_demanded_3_low_bits(
; CHECK-NEXT:    [[MUL:%.*]] = mul i33 [[X:%.*]], [[X]]
; CHECK-NEXT:    [[AND:%.*]] = and i33 [[MUL]], 7
; CHECK-NEXT:    ret i33 [[AND]]
;
  %mul = mul i33 %x, %x
  %and = and i33 %mul, 7
  ret i33 %and
}
