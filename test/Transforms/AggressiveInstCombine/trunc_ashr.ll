; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -aggressive-instcombine -S | FileCheck %s

define i16 @ashr_15(i16 %x) {
; CHECK-LABEL: @ashr_15(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[ZEXT]], 15
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[ASHR]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC]]
;
  %zext = zext i16 %x to i32
  %ashr = ashr i32 %zext, 15
  %trunc = trunc i32 %ashr to i16
  ret i16 %trunc
}

; Negative test

define i16 @ashr_16(i16 %x) {
; CHECK-LABEL: @ashr_16(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[ZEXT]], 16
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[ASHR]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC]]
;
  %zext = zext i16 %x to i32
  %ashr = ashr i32 %zext, 16
  %trunc = trunc i32 %ashr to i16
  ret i16 %trunc
}

; Negative test

define i16 @ashr_var_shift_amount(i8 %x, i8 %amt) {
; CHECK-LABEL: @ashr_var_shift_amount(
; CHECK-NEXT:    [[Z:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[ZA:%.*]] = zext i8 [[AMT:%.*]] to i32
; CHECK-NEXT:    [[S:%.*]] = ashr i32 [[Z]], [[ZA]]
; CHECK-NEXT:    [[A:%.*]] = add i32 [[S]], [[Z]]
; CHECK-NEXT:    [[S2:%.*]] = ashr i32 [[A]], 2
; CHECK-NEXT:    [[T:%.*]] = trunc i32 [[S2]] to i16
; CHECK-NEXT:    ret i16 [[T]]
;
  %z = zext i8 %x to i32
  %za = zext i8 %amt to i32
  %s = ashr i32 %z, %za
  %a = add i32 %s, %z
  %s2 = ashr i32 %a, 2
  %t = trunc i32 %s2 to i16
  ret i16 %t
}

define i16 @ashr_var_bounded_shift_amount(i8 %x, i8 %amt) {
; CHECK-LABEL: @ashr_var_bounded_shift_amount(
; CHECK-NEXT:    [[Z:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[ZA:%.*]] = zext i8 [[AMT:%.*]] to i32
; CHECK-NEXT:    [[ZA2:%.*]] = and i32 [[ZA]], 15
; CHECK-NEXT:    [[S:%.*]] = ashr i32 [[Z]], [[ZA2]]
; CHECK-NEXT:    [[A:%.*]] = add i32 [[S]], [[Z]]
; CHECK-NEXT:    [[S2:%.*]] = ashr i32 [[A]], 2
; CHECK-NEXT:    [[T:%.*]] = trunc i32 [[S2]] to i16
; CHECK-NEXT:    ret i16 [[T]]
;
  %z = zext i8 %x to i32
  %za = zext i8 %amt to i32
  %za2 = and i32 %za, 15
  %s = ashr i32 %z, %za2
  %a = add i32 %s, %z
  %s2 = ashr i32 %a, 2
  %t = trunc i32 %s2 to i16
  ret i16 %t
}

; Negative test

define i32 @ashr_check_no_overflow(i32 %x, i16 %amt) {
; CHECK-LABEL: @ashr_check_no_overflow(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i32 [[X:%.*]] to i64
; CHECK-NEXT:    [[SEXT:%.*]] = sext i16 [[AMT:%.*]] to i64
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[SEXT]], 4294967295
; CHECK-NEXT:    [[SHL:%.*]] = ashr i64 [[ZEXT]], [[AND]]
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i64 [[SHL]] to i32
; CHECK-NEXT:    ret i32 [[TRUNC]]
;
  %zext = zext i32 %x to i64
  %sext = sext i16 %amt to i64
  %and = and i64 %sext, 4294967295
  %shl = ashr i64 %zext, %and
  %trunc = trunc i64 %shl to i32
  ret i32 %trunc
}

define void @ashr_big_dag(i16* %a, i8 %b, i8 %c) {
; CHECK-LABEL: @ashr_big_dag(
; CHECK-NEXT:    [[ZEXT1:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[ZEXT2:%.*]] = zext i8 [[C:%.*]] to i32
; CHECK-NEXT:    [[ADD1:%.*]] = add i32 [[ZEXT1]], [[ZEXT2]]
; CHECK-NEXT:    [[SFT1:%.*]] = and i32 [[ADD1]], 15
; CHECK-NEXT:    [[SHR1:%.*]] = ashr i32 [[ADD1]], [[SFT1]]
; CHECK-NEXT:    [[ADD2:%.*]] = add i32 [[ADD1]], [[SHR1]]
; CHECK-NEXT:    [[SFT2:%.*]] = and i32 [[ADD2]], 7
; CHECK-NEXT:    [[SHR2:%.*]] = ashr i32 [[ADD2]], [[SFT2]]
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[SHR2]] to i16
; CHECK-NEXT:    store i16 [[TRUNC]], i16* [[A:%.*]], align 2
; CHECK-NEXT:    ret void
;
  %zext1 = zext i8 %b to i32
  %zext2 = zext i8 %c to i32
  %add1 = add i32 %zext1, %zext2
  %sft1 = and i32 %add1, 15
  %shr1 = ashr i32 %add1, %sft1
  %add2 = add i32 %add1, %shr1
  %sft2 = and i32 %add2, 7
  %shr2 = ashr i32 %add2, %sft2
  %trunc = trunc i32 %shr2 to i16
  store i16 %trunc, i16* %a, align 2
  ret void
}

; Negative test

define i8 @ashr_check_not_i8_trunc(i16 %x) {
; CHECK-LABEL: @ashr_check_not_i8_trunc(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i16 [[X:%.*]], 1
; CHECK-NEXT:    [[ZEXT2:%.*]] = zext i16 [[ASHR]] to i32
; CHECK-NEXT:    [[ASHR2:%.*]] = ashr i32 [[ZEXT2]], 2
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[ASHR2]] to i8
; CHECK-NEXT:    ret i8 [[TRUNC]]
;
  %ashr = ashr i16 %x, 1
  %zext2 = zext i16 %ashr to i32
  %ashr2 = ashr i32 %zext2, 2
  %trunc = trunc i32 %ashr2 to i8
  ret i8 %trunc
}

define <2 x i16> @ashr_vector(<2 x i8> %x) {
; CHECK-LABEL: @ashr_vector(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[ZA:%.*]] = and <2 x i32> [[Z]], <i32 7, i32 8>
; CHECK-NEXT:    [[S:%.*]] = ashr <2 x i32> [[Z]], [[ZA]]
; CHECK-NEXT:    [[A:%.*]] = add <2 x i32> [[S]], [[Z]]
; CHECK-NEXT:    [[S2:%.*]] = ashr <2 x i32> [[A]], <i32 4, i32 5>
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i32> [[S2]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[T]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %za = and <2 x i32> %z, <i32 7, i32 8>
  %s = ashr <2 x i32> %z, %za
  %a = add <2 x i32> %s, %z
  %s2 = ashr <2 x i32> %a, <i32 4, i32 5>
  %t = trunc <2 x i32> %s2 to <2 x i16>
  ret <2 x i16> %t
}

; Negative test - can only fold to <2 x i16>, requiring new vector type

define <2 x i8> @ashr_vector_no_new_vector_type(<2 x i8> %x) {
; CHECK-LABEL: @ashr_vector_no_new_vector_type(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[ZA:%.*]] = and <2 x i32> [[Z]], <i32 7, i32 8>
; CHECK-NEXT:    [[S:%.*]] = ashr <2 x i32> [[Z]], [[ZA]]
; CHECK-NEXT:    [[A:%.*]] = add <2 x i32> [[S]], [[Z]]
; CHECK-NEXT:    [[S2:%.*]] = ashr <2 x i32> [[A]], <i32 4, i32 5>
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i32> [[S2]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[T]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %za = and <2 x i32> %z, <i32 7, i32 8>
  %s = ashr <2 x i32> %z, %za
  %a = add <2 x i32> %s, %z
  %s2 = ashr <2 x i32> %a, <i32 4, i32 5>
  %t = trunc <2 x i32> %s2 to <2 x i8>
  ret <2 x i8> %t
}

; Negative test

define <2 x i16> @ashr_vector_large_shift_amount(<2 x i8> %x) {
; CHECK-LABEL: @ashr_vector_large_shift_amount(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[ZA:%.*]] = and <2 x i32> [[Z]], <i32 7, i32 8>
; CHECK-NEXT:    [[S:%.*]] = ashr <2 x i32> [[Z]], [[ZA]]
; CHECK-NEXT:    [[A:%.*]] = add <2 x i32> [[S]], [[Z]]
; CHECK-NEXT:    [[S2:%.*]] = ashr <2 x i32> [[A]], <i32 16, i32 5>
; CHECK-NEXT:    [[T:%.*]] = trunc <2 x i32> [[S2]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[T]]
;
  %z = zext <2 x i8> %x to <2 x i32>
  %za = and <2 x i32> %z, <i32 7, i32 8>
  %s = ashr <2 x i32> %z, %za
  %a = add <2 x i32> %s, %z
  %s2 = ashr <2 x i32> %a, <i32 16, i32 5>
  %t = trunc <2 x i32> %s2 to <2 x i16>
  ret <2 x i16> %t
}

define i16 @ashr_exact(i16 %x) {
; CHECK-LABEL: @ashr_exact(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[ZEXT]], 32767
; CHECK-NEXT:    [[ASHR:%.*]] = ashr exact i32 [[AND]], 15
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[ASHR]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC]]
;
  %zext = zext i16 %x to i32
  %and = and i32 %zext, 32767
  %ashr = ashr exact i32 %and, 15
  %trunc = trunc i32 %ashr to i16
  ret i16 %trunc
}

; Negative test

define i16 @ashr_negative_operand(i16 %x) {
; CHECK-LABEL: @ashr_negative_operand(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 -1, [[ZEXT]]
; CHECK-NEXT:    [[LSHR2:%.*]] = ashr i32 [[XOR]], 2
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[LSHR2]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC]]
;
  %zext = zext i16 %x to i32
  %xor = xor i32 -1, %zext
  %lshr2 = ashr i32 %xor, 2
  %trunc = trunc i32 %lshr2 to i16
  ret i16 %trunc
}

define i16 @ashr_negative_operand_but_short(i16 %x) {
; CHECK-LABEL: @ashr_negative_operand_but_short(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[ZEXT]], 32767
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 -1, [[AND]]
; CHECK-NEXT:    [[LSHR2:%.*]] = ashr i32 [[XOR]], 2
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[LSHR2]] to i16
; CHECK-NEXT:    ret i16 [[TRUNC]]
;
  %zext = zext i16 %x to i32
  %and = and i32 %zext, 32767
  %xor = xor i32 -1, %and
  %lshr2 = ashr i32 %xor, 2
  %trunc = trunc i32 %lshr2 to i16
  ret i16 %trunc
}
