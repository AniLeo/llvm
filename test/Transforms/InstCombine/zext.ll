; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i64 @test_sext_zext(i16 %A) {
; CHECK-LABEL: @test_sext_zext(
; CHECK-NEXT:    [[C2:%.*]] = zext i16 [[A:%.*]] to i64
; CHECK-NEXT:    ret i64 [[C2]]
;
  %c1 = zext i16 %A to i32
  %c2 = sext i32 %c1 to i64
  ret i64 %c2
}

define <2 x i64> @test2(<2 x i1> %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[XOR:%.*]] = xor <2 x i1> [[A:%.*]], <i1 true, i1 true>
; CHECK-NEXT:    [[ZEXT:%.*]] = zext <2 x i1> [[XOR]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ZEXT]]
;
  %xor = xor <2 x i1> %A, <i1 true, i1 true>
  %zext = zext <2 x i1> %xor to <2 x i64>
  ret <2 x i64> %zext
}

define <2 x i64> @test3(<2 x i64> %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[ZEXT:%.*]] = and <2 x i64> [[A:%.*]], <i64 23, i64 42>
; CHECK-NEXT:    ret <2 x i64> [[ZEXT]]
;
  %trunc = trunc <2 x i64> %A to <2 x i32>
  %and = and <2 x i32> %trunc, <i32 23, i32 42>
  %zext = zext <2 x i32> %and to <2 x i64>
  ret <2 x i64> %zext
}

define <2 x i64> @test4(<2 x i64> %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i64> [[A:%.*]], <i64 23, i64 42>
; CHECK-NEXT:    [[ZEXT:%.*]] = xor <2 x i64> [[TMP1]], <i64 23, i64 42>
; CHECK-NEXT:    ret <2 x i64> [[ZEXT]]
;
  %trunc = trunc <2 x i64> %A to <2 x i32>
  %and = and <2 x i32> %trunc, <i32 23, i32 42>
  %xor = xor <2 x i32> %and, <i32 23, i32 42>
  %zext = zext <2 x i32> %xor to <2 x i64>
  ret <2 x i64> %zext
}

define i64 @fold_xor_zext_sandwich(i1 %a) {
; CHECK-LABEL: @fold_xor_zext_sandwich(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i1 [[A:%.*]], true
; CHECK-NEXT:    [[ZEXT2:%.*]] = zext i1 [[TMP1]] to i64
; CHECK-NEXT:    ret i64 [[ZEXT2]]
;
  %zext1 = zext i1 %a to i32
  %xor = xor i32 %zext1, 1
  %zext2 = zext i32 %xor to i64
  ret i64 %zext2
}

define <2 x i64> @fold_xor_zext_sandwich_vec(<2 x i1> %a) {
; CHECK-LABEL: @fold_xor_zext_sandwich_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i1> [[A:%.*]], <i1 true, i1 true>
; CHECK-NEXT:    [[ZEXT2:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ZEXT2]]
;
  %zext1 = zext <2 x i1> %a to <2 x i32>
  %xor = xor <2 x i32> %zext1, <i32 1, i32 1>
  %zext2 = zext <2 x i32> %xor to <2 x i64>
  ret <2 x i64> %zext2
}

; Assert that zexts in and(zext(icmp), zext(icmp)) can be folded.

define i8 @fold_and_zext_icmp(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: @fold_and_zext_icmp(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i64 [[A]], [[C:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i1 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = zext i1 [[TMP3]] to i8
; CHECK-NEXT:    ret i8 [[TMP4]]
;
  %1 = icmp sgt i64 %a, %b
  %2 = zext i1 %1 to i8
  %3 = icmp slt i64 %a, %c
  %4 = zext i1 %3 to i8
  %5 = and i8 %2, %4
  ret i8 %5
}

; Assert that zexts in or(zext(icmp), zext(icmp)) can be folded.

define i8 @fold_or_zext_icmp(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: @fold_or_zext_icmp(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i64 [[A]], [[C:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = or i1 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = zext i1 [[TMP3]] to i8
; CHECK-NEXT:    ret i8 [[TMP4]]
;
  %1 = icmp sgt i64 %a, %b
  %2 = zext i1 %1 to i8
  %3 = icmp slt i64 %a, %c
  %4 = zext i1 %3 to i8
  %5 = or i8 %2, %4
  ret i8 %5
}

; Assert that zexts in xor(zext(icmp), zext(icmp)) can be folded.

define i8 @fold_xor_zext_icmp(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: @fold_xor_zext_icmp(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i64 [[A]], [[C:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = xor i1 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = zext i1 [[TMP3]] to i8
; CHECK-NEXT:    ret i8 [[TMP4]]
;
  %1 = icmp sgt i64 %a, %b
  %2 = zext i1 %1 to i8
  %3 = icmp slt i64 %a, %c
  %4 = zext i1 %3 to i8
  %5 = xor i8 %2, %4
  ret i8 %5
}

; Assert that zexts in logic(zext(icmp), zext(icmp)) are also folded accross
; nested logical operators.

define i8 @fold_nested_logic_zext_icmp(i64 %a, i64 %b, i64 %c, i64 %d) {
; CHECK-LABEL: @fold_nested_logic_zext_icmp(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i64 [[A]], [[C:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i1 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i64 [[A]], [[D:%.*]]
; CHECK-NEXT:    [[TMP5:%.*]] = or i1 [[TMP3]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = zext i1 [[TMP5]] to i8
; CHECK-NEXT:    ret i8 [[TMP6]]
;
  %1 = icmp sgt i64 %a, %b
  %2 = zext i1 %1 to i8
  %3 = icmp slt i64 %a, %c
  %4 = zext i1 %3 to i8
  %5 = and i8 %2, %4
  %6 = icmp eq i64 %a, %d
  %7 = zext i1 %6 to i8
  %8 = or i8 %5, %7
  ret i8 %8
}

; This test is for Integer BitWidth > 64 && BitWidth <= 1024.

define i1024 @sext_zext_apint1(i77 %A) {
; CHECK-LABEL: @sext_zext_apint1(
; CHECK-NEXT:    [[C2:%.*]] = zext i77 [[A:%.*]] to i1024
; CHECK-NEXT:    ret i1024 [[C2]]
;
  %c1 = zext i77 %A to i533
  %c2 = sext i533 %c1 to i1024
  ret i1024 %c2
}

; This test is for Integer BitWidth <= 64 && BitWidth % 2 != 0.

define i47 @sext_zext_apint2(i11 %A) {
; CHECK-LABEL: @sext_zext_apint2(
; CHECK-NEXT:    [[C2:%.*]] = zext i11 [[A:%.*]] to i47
; CHECK-NEXT:    ret i47 [[C2]]
;
  %c1 = zext i11 %A to i39
  %c2 = sext i39 %c1 to i47
  ret i47 %c2
}

declare void @use1(i1)
declare void @use32(i32)

define i32 @masked_bit_set(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_set(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 1
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %sh1 = shl i32 1, %y
  %and = and i32 %sh1, %x
  %cmp = icmp ne i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

define <2 x i32> @masked_bit_clear(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @masked_bit_clear(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i32> [[X:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[TMP2:%.*]] = lshr <2 x i32> [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i32> [[TMP2]], <i32 1, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %sh1 = shl <2 x i32> <i32 1, i32 1>, %y
  %and = and <2 x i32> %sh1, %x
  %cmp = icmp eq <2 x i32> %and, zeroinitializer
  %r = zext <2 x i1> %cmp to <2 x i32>
  ret <2 x i32> %r
}

define <2 x i32> @masked_bit_set_commute(<2 x i32> %px, <2 x i32> %y) {
; CHECK-LABEL: @masked_bit_set_commute(
; CHECK-NEXT:    [[X:%.*]] = srem <2 x i32> <i32 42, i32 3>, [[PX:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i32> [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], <i32 1, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %x = srem <2 x i32> <i32 42, i32 3>, %px ; thwart complexity-based canonicalization
  %sh1 = shl <2 x i32> <i32 1, i32 1>, %y
  %and = and <2 x i32> %x, %sh1
  %cmp = icmp ne <2 x i32> %and, zeroinitializer
  %r = zext <2 x i1> %cmp to <2 x i32>
  ret <2 x i32> %r
}

define i32 @masked_bit_clear_commute(i32 %px, i32 %y) {
; CHECK-LABEL: @masked_bit_clear_commute(
; CHECK-NEXT:    [[X:%.*]] = srem i32 42, [[PX:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 1
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %x = srem i32 42, %px ; thwart complexity-based canonicalization
  %sh1 = shl i32 1, %y
  %and = and i32 %x, %sh1
  %cmp = icmp eq i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

define i32 @masked_bit_set_use1(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_set_use1(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SH1]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 1
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %sh1 = shl i32 1, %y
  call void @use32(i32 %sh1)
  %and = and i32 %sh1, %x
  %cmp = icmp ne i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @masked_bit_set_use2(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_set_use2(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[AND]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 1, %y
  %and = and i32 %sh1, %x
  call void @use32(i32 %and)
  %cmp = icmp ne i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @masked_bit_set_use3(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_set_use3(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    call void @use1(i1 [[CMP]])
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 1, %y
  %and = and i32 %sh1, %x
  %cmp = icmp ne i32 %and, 0
  call void @use1(i1 %cmp)
  %r = zext i1 %cmp to i32
  ret i32 %r
}

define i32 @masked_bit_clear_use1(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_clear_use1(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[SH1]])
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP1]], [[Y]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 1
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %sh1 = shl i32 1, %y
  call void @use32(i32 %sh1)
  %and = and i32 %sh1, %x
  %cmp = icmp eq i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @masked_bit_clear_use2(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_clear_use2(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[AND]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 1, %y
  %and = and i32 %sh1, %x
  call void @use32(i32 %and)
  %cmp = icmp eq i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @masked_bit_clear_use3(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_clear_use3(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    call void @use1(i1 [[CMP]])
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 1, %y
  %and = and i32 %sh1, %x
  %cmp = icmp eq i32 %and, 0
  call void @use1(i1 %cmp)
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @masked_bits_set(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bits_set(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 3, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 3, %y
  %and = and i32 %sh1, %x
  %cmp = icmp ne i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @div_bit_set(i32 %x, i32 %y) {
; CHECK-LABEL: @div_bit_set(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = sdiv i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 1, %y
  %and = sdiv i32 %sh1, %x
  %cmp = icmp ne i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @masked_bit_set_nonzero_cmp(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_set_nonzero_cmp(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 1
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 1, %y
  %and = and i32 %sh1, %x
  %cmp = icmp ne i32 %and, 1
  %r = zext i1 %cmp to i32
  ret i32 %r
}

; Negative test

define i32 @masked_bit_wrong_pred(i32 %x, i32 %y) {
; CHECK-LABEL: @masked_bit_wrong_pred(
; CHECK-NEXT:    [[SH1:%.*]] = shl i32 1, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SH1]], [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[AND]], 0
; CHECK-NEXT:    [[R:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %sh1 = shl i32 1, %y
  %and = and i32 %sh1, %x
  %cmp = icmp sgt i32 %and, 0
  %r = zext i1 %cmp to i32
  ret i32 %r
}

define i32 @zext_or_masked_bit_test(i32 %a, i32 %b, i32 %x) {
; CHECK-LABEL: @zext_or_masked_bit_test(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 1, [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SHL]], [[A:%.*]]
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X:%.*]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[TOBOOL]], [[CMP]]
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[OR]] to i32
; CHECK-NEXT:    ret i32 [[Z]]
;
  %shl = shl i32 1, %b
  %and = and i32 %shl, %a
  %tobool = icmp ne i32 %and, 0
  %cmp = icmp eq i32 %x, %b
  %or = or i1 %tobool, %cmp
  %z = zext i1 %or to i32
  ret i32 %z
}

define i32 @zext_or_masked_bit_test_uses(i32 %a, i32 %b, i32 %x) {
; CHECK-LABEL: @zext_or_masked_bit_test_uses(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 1, [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SHL]], [[A:%.*]]
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[X:%.*]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[TOBOOL]], [[CMP]]
; CHECK-NEXT:    call void @use1(i1 [[OR]])
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[OR]] to i32
; CHECK-NEXT:    ret i32 [[Z]]
;
  %shl = shl i32 1, %b
  %and = and i32 %shl, %a
  %tobool = icmp ne i32 %and, 0
  %cmp = icmp eq i32 %x, %b
  %or = or i1 %tobool, %cmp
  call void @use1(i1 %or)
  %z = zext i1 %or to i32
  ret i32 %z
}
