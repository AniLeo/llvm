; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

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
; CHECK-NEXT:    [[A:%.*]] = mul i32 [[X:%.*]], [[X]]
; CHECK-NEXT:    [[B:%.*]] = and i32 [[A]], 2
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[B]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %a = mul i32 %x, %x
  %b = and i32 %a, 2
  %c = icmp ne i32 %b, 0
  ret i1 %c
}

define <4 x i1> @PR48683_vec(<4 x i32> %x) {
; CHECK-LABEL: @PR48683_vec(
; CHECK-NEXT:    [[A:%.*]] = mul <4 x i32> [[X:%.*]], [[X]]
; CHECK-NEXT:    [[B:%.*]] = and <4 x i32> [[A]], <i32 2, i32 2, i32 2, i32 2>
; CHECK-NEXT:    [[C:%.*]] = icmp ne <4 x i32> [[B]], zeroinitializer
; CHECK-NEXT:    ret <4 x i1> [[C]]
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
; CHECK-NEXT:    [[MUL:%.*]] = mul i33 [[X:%.*]], [[X]]
; CHECK-NEXT:    [[AND:%.*]] = and i33 [[MUL]], 1
; CHECK-NEXT:    ret i33 [[AND]]
;
  %mul = mul i33 %x, %x
  %and = and i33 %mul, 1
  ret i33 %and
}

define <2 x i8> @squared_one_demanded_low_bit_splat(<2 x i8> %x) {
; CHECK-LABEL: @squared_one_demanded_low_bit_splat(
; CHECK-NEXT:    [[MUL:%.*]] = mul <2 x i8> [[X:%.*]], [[X]]
; CHECK-NEXT:    [[AND:%.*]] = or <2 x i8> [[MUL]], <i8 -2, i8 -2>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %mul = mul <2 x i8> %x, %x
  %and = or <2 x i8> %mul, <i8 254, i8 254>
  ret <2 x i8> %and
}
