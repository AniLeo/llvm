; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define i32 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = or i32 %A, 0
  ret i32 %B
}

define i32 @all_ones(i32 %A) {
; CHECK-LABEL: @all_ones(
; CHECK-NEXT:    ret i32 -1
;
  %B = or i32 %A, -1
  ret i32 %B
}

define <3 x i8> @all_ones_vec_with_undef_elt(<3 x i8> %A) {
; CHECK-LABEL: @all_ones_vec_with_undef_elt(
; CHECK-NEXT:    ret <3 x i8> <i8 -1, i8 -1, i8 -1>
;
  %B = or <3 x i8> %A, <i8 -1, i8 undef, i8 -1>
  ret <3 x i8> %B
}

define i1 @test3(i1 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i1 [[A:%.*]]
;
  %B = or i1 %A, false
  ret i1 %B
}

define i1 @test4(i1 %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret i1 true
;
  %B = or i1 %A, true
  ret i1 %B
}

define i1 @test5(i1 %A) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i1 [[A:%.*]]
;
  %B = or i1 %A, %A
  ret i1 %B
}

define i32 @test6(i32 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = or i32 %A, %A
  ret i32 %B
}

; A | ~A == -1
define i32 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 -1
;
  %NotA = xor i32 %A, -1
  %B = or i32 %A, %NotA
  ret i32 %B
}

define i8 @test8(i8 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i8 -1
;
  %B = or i8 %A, -2
  %C = or i8 %B, 1
  ret i8 %C
}

; Test that (A|c1)|(B|c2) == (A|B)|(c1|c2)
define i8 @test9(i8 %A, i8 %B) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    ret i8 -1
;
  %C = or i8 %A, 1
  %D = or i8 %B, -2
  %E = or i8 %C, %D
  ret i8 %E
}

; (X & C1) | C2 --> (X | C2) & (C1|C2)
define i8 @test10(i8 %A) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i8 -2
;
  %B = or i8 %A, 1
  %C = and i8 %B, -2
  %D = or i8 %C, -2
  ret i8 %D
}

; The following two cases only get folded by InstCombine,
; see InstCombine/or-xor.ll.

; (X ^ C1) | C2 --> (X | C2) ^ (C1&~C2)
define i8 @test11(i8 %A) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[B:%.*]] = or i8 [[A:%.*]], -2
; CHECK-NEXT:    [[C:%.*]] = xor i8 [[B]], 13
; CHECK-NEXT:    [[D:%.*]] = or i8 [[C]], 1
; CHECK-NEXT:    [[E:%.*]] = xor i8 [[D]], 12
; CHECK-NEXT:    ret i8 [[E]]
;
  %B = or i8 %A, -2
  %C = xor i8 %B, 13
  %D = or i8 %C, 1
  %E = xor i8 %D, 12
  ret i8 %E
}

define i8 @test11v(<2 x i8> %A) {
; CHECK-LABEL: @test11v(
; CHECK-NEXT:    [[B:%.*]] = or <2 x i8> [[A:%.*]], <i8 -2, i8 0>
; CHECK-NEXT:    [[CV:%.*]] = xor <2 x i8> [[B]], <i8 13, i8 13>
; CHECK-NEXT:    [[C:%.*]] = extractelement <2 x i8> [[CV]], i32 0
; CHECK-NEXT:    [[D:%.*]] = or i8 [[C]], 1
; CHECK-NEXT:    [[E:%.*]] = xor i8 [[D]], 12
; CHECK-NEXT:    ret i8 [[E]]
;
  %B = or <2 x i8> %A, <i8 -2, i8 0>
  %CV = xor <2 x i8> %B, <i8 13, i8 13>
  %C = extractelement <2 x i8> %CV, i32 0
  %D = or i8 %C, 1
  %E = xor i8 %D, 12
  ret i8 %E
}

; Test the case where integer BitWidth <= 64 && BitWidth % 2 != 0.
; If we have: ((V + N) & C1) | (V & C2)
; .. and C2 = ~C1 and C2 is 0+1+ and (N & C2) == 0
; replace with V+N.
define i39 @test1_apint(i39 %V, i39 %M) {
; CHECK-LABEL: @test1_apint(
; CHECK-NEXT:    [[N:%.*]] = and i39 [[M:%.*]], -274877906944
; CHECK-NEXT:    [[A:%.*]] = add i39 [[V:%.*]], [[N]]
; CHECK-NEXT:    ret i39 [[A]]
;
  %C1 = xor i39 274877906943, -1 ;; C2 = 274877906943
  %N = and i39 %M, 274877906944
  %A = add i39 %V, %N
  %B = and i39 %A, %C1
  %D = and i39 %V, 274877906943
  %R = or i39 %B, %D
  ret i39 %R
}

define i7 @test2_apint(i7 %X) {
; CHECK-LABEL: @test2_apint(
; CHECK-NEXT:    ret i7 [[X:%.*]]
;
  %Y = or i7 %X, 0
  ret i7 %Y
}

define i17 @test3_apint(i17 %X) {
; CHECK-LABEL: @test3_apint(
; CHECK-NEXT:    ret i17 -1
;
  %Y = or i17 %X, -1
  ret i17 %Y
}

; Test the case where Integer BitWidth > 64 && BitWidth <= 1024.
; If we have: ((V + N) & C1) | (V & C2)
; .. and C2 = ~C1 and C2 is 0+1+ and (N & C2) == 0
; replace with V+N.
define i399 @test4_apint(i399 %V, i399 %M) {
; CHECK-LABEL: @test4_apint(
; CHECK-NEXT:    [[N:%.*]] = and i399 [[M:%.*]], 18446742974197923840
; CHECK-NEXT:    [[A:%.*]] = add i399 [[V:%.*]], [[N]]
; CHECK-NEXT:    ret i399 [[A]]
;
  %C1 = xor i399 274877906943, -1 ;; C2 = 274877906943
  %N = and i399 %M, 18446742974197923840
  %A = add i399 %V, %N
  %B = and i399 %A, %C1
  %D = and i399 %V, 274877906943
  %R = or i399 %D, %B
  ret i399 %R
}

define i777 @test5_apint(i777 %X) {
; CHECK-LABEL: @test5_apint(
; CHECK-NEXT:    ret i777 [[X:%.*]]
;
  %Y = or i777 %X, 0
  ret i777 %Y
}

define i117 @test6_apint(i117 %X) {
; CHECK-LABEL: @test6_apint(
; CHECK-NEXT:    ret i117 -1
;
  %Y = or i117 %X, -1
  ret i117 %Y
}

; Test the case where integer BitWidth <= 64 && BitWidth % 2 != 0.
; Vector version of test1_apint with the add commuted
; If we have: ((V + N) & C1) | (V & C2)
; .. and C2 = ~C1 and C2 is 0+1+ and (N & C2) == 0
; replace with V+N.
define <2 x i39> @test7_apint(<2 x i39> %V, <2 x i39> %M) {
; CHECK-LABEL: @test7_apint(
; CHECK-NEXT:    [[N:%.*]] = and <2 x i39> [[M:%.*]], <i39 -274877906944, i39 -274877906944>
; CHECK-NEXT:    [[A:%.*]] = add <2 x i39> [[N]], [[V:%.*]]
; CHECK-NEXT:    ret <2 x i39> [[A]]
;
  %C1 = xor <2 x i39> <i39 274877906943, i39 274877906943>, <i39 -1, i39 -1> ;; C2 = 274877906943
  %N = and <2 x i39> %M, <i39 274877906944, i39 274877906944>
  %A = add <2 x i39> %N, %V
  %B = and <2 x i39> %A, %C1
  %D = and <2 x i39> %V, <i39 274877906943, i39 274877906943>
  %R = or <2 x i39> %B, %D
  ret <2 x i39> %R
}

; Test the case where Integer BitWidth > 64 && BitWidth <= 1024.
; Vector version of test4_apint with the add and the or commuted
; If we have: ((V + N) & C1) | (V & C2)
; .. and C2 = ~C1 and C2 is 0+1+ and (N & C2) == 0
; replace with V+N.
define <2 x i399> @test8_apint(<2 x i399> %V, <2 x i399> %M) {
; CHECK-LABEL: @test8_apint(
; CHECK-NEXT:    [[N:%.*]] = and <2 x i399> [[M:%.*]], <i399 18446742974197923840, i399 18446742974197923840>
; CHECK-NEXT:    [[A:%.*]] = add <2 x i399> [[N]], [[V:%.*]]
; CHECK-NEXT:    ret <2 x i399> [[A]]
;
  %C1 = xor <2 x i399> <i399 274877906943, i399 274877906943>, <i399 -1, i399 -1> ;; C2 = 274877906943
  %N = and <2 x i399> %M, <i399 18446742974197923840, i399 18446742974197923840>
  %A = add <2 x i399> %N, %V
  %B = and <2 x i399> %A, %C1
  %D = and <2 x i399> %V, <i399 274877906943, i399 274877906943>
  %R = or <2 x i399> %D, %B
  ret <2 x i399> %R
}

; A | ~(A & B) = -1

define i1 @or_with_not_op_commute1(i1 %a, i1 %b) {
; CHECK-LABEL: @or_with_not_op_commute1(
; CHECK-NEXT:    ret i1 true
;
  %ab = and i1 %a, %b
  %not = xor i1 %ab, -1
  %r = or i1 %a, %not
  ret i1 %r
}

; A | ~(B & A) = -1

define i8 @or_with_not_op_commute2(i8 %a, i8 %b) {
; CHECK-LABEL: @or_with_not_op_commute2(
; CHECK-NEXT:    ret i8 -1
;
  %ab = and i8 %b, %a
  %not = xor i8 %ab, -1
  %r = or i8 %a, %not
  ret i8 %r
}

; ~(A & B) | A = -1

define <3 x i17> @or_with_not_op_commute3(<3 x i17> %a, <3 x i17> %b) {
; CHECK-LABEL: @or_with_not_op_commute3(
; CHECK-NEXT:    ret <3 x i17> <i17 -1, i17 -1, i17 -1>
;
  %ab = and <3 x i17> %a, %b
  %not = xor <3 x i17> %ab, <i17 -1, i17 -1, i17 -1>
  %r = or <3 x i17> %not, %a
  ret <3 x i17> %r
}

; ~(B & A) | A = -1

define <2 x i1> @or_with_not_op_commute4(<2 x i1> %a, <2 x i1> %b) {
; CHECK-LABEL: @or_with_not_op_commute4(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %ab = and <2 x i1> %b, %a
  %not = xor <2 x i1> %ab, <i1 -1, i1 undef>
  %r = or <2 x i1> %not, %a
  ret <2 x i1> %r
}

; TODO: this should be poison

define i32 @poison(i32 %x) {
; CHECK-LABEL: @poison(
; CHECK-NEXT:    ret i32 -1
;
  %v = or i32 %x, poison
  ret i32 %v
}

declare void @use(i32)

define i32 @and_or_not_or(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or(
; CHECK-NEXT:    [[I:%.*]] = xor i32 [[B:%.*]], -1
; CHECK-NEXT:    ret i32 [[I]]
;
  %i = xor i32 %B, -1
  %i2 = and i32 %i, %A
  %i3 = or i32 %B, %A
  %i4 = xor i32 %i3, -1
  %i5 = or i32 %i2, %i4
  ret i32 %i5
}

define i32 @and_or_not_or2(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or2(
; CHECK-NEXT:    [[I:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    ret i32 [[I]]
;
  %i = xor i32 %A, -1
  %i2 = and i32 %i, %B
  %i3 = or i32 %B, %A
  %i4 = xor i32 %i3, -1
  %i5 = or i32 %i2, %i4
  ret i32 %i5
}

define <4 x i32> @and_or_not_or3_vec(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: @and_or_not_or3_vec(
; CHECK-NEXT:    [[I:%.*]] = xor <4 x i32> [[A:%.*]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    ret <4 x i32> [[I]]
;
  %i = xor <4 x i32> %A, <i32 -1, i32 -1, i32 -1, i32 -1>
  %i2 = and <4 x i32> %i, %B
  %i3 = or <4 x i32> %B, %A
  %i4 = xor <4 x i32> %i3, <i32 -1, i32 -1, i32 -1, i32 -1>
  %i5 = or <4 x i32> %i2, %i4
  ret <4 x i32> %i5
}

define i32 @and_or_not_or4_use(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or4_use(
; CHECK-NEXT:    [[I:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[I2:%.*]] = and i32 [[I]], [[B:%.*]]
; CHECK-NEXT:    tail call void @use(i32 [[I2]])
; CHECK-NEXT:    ret i32 [[I]]
;
  %i = xor i32 %A, -1
  %i2 = and i32 %i, %B
  tail call void @use(i32 %i2)
  %i3 = or i32 %B, %A
  %i4 = xor i32 %i3, -1
  %i5 = or i32 %i2, %i4
  ret i32 %i5
}

define i32 @and_or_not_or4_use2(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or4_use2(
; CHECK-NEXT:    [[I:%.*]] = or i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = xor i32 [[I]], -1
; CHECK-NEXT:    tail call void @use(i32 [[I2]])
; CHECK-NEXT:    [[I3:%.*]] = xor i32 [[A]], -1
; CHECK-NEXT:    ret i32 [[I3]]
;
  %i = or i32 %B, %A
  %i2 = xor i32 %i, -1
  tail call void @use(i32 %i2)
  %i3 = xor i32 %A, -1
  %i4 = and i32 %i3, %B
  %i5 = or i32 %i4, %i2
  ret i32 %i5
}

define i32 @and_or_not_or4_use3(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or4_use3(
; CHECK-NEXT:    [[I:%.*]] = or i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = xor i32 [[I]], -1
; CHECK-NEXT:    tail call void @use(i32 [[I2]])
; CHECK-NEXT:    [[I3:%.*]] = xor i32 [[A]], -1
; CHECK-NEXT:    [[I4:%.*]] = and i32 [[I3]], [[B]]
; CHECK-NEXT:    tail call void @use(i32 [[I4]])
; CHECK-NEXT:    ret i32 [[I3]]
;
  %i = or i32 %B, %A
  %i2 = xor i32 %i, -1
  tail call void @use(i32 %i2)
  %i3 = xor i32 %A, -1
  %i4 = and i32 %i3, %B
  tail call void @use(i32 %i4)
  %i5 = or i32 %i4, %i2
  ret i32 %i5
}

define i32 @and_or_not_or5(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or5(
; CHECK-NEXT:    [[I:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[I2:%.*]] = and i32 [[B:%.*]], [[I]]
; CHECK-NEXT:    [[I3:%.*]] = or i32 [[B]], [[A]]
; CHECK-NEXT:    [[I4:%.*]] = xor i32 [[I3]], -1
; CHECK-NEXT:    [[I5:%.*]] = or i32 [[I2]], [[I4]]
; CHECK-NEXT:    ret i32 [[I5]]
;
  %i = xor i32 %A, -1
  %i2 = and i32 %B, %i
  %i3 = or i32 %B, %A
  %i4 = xor i32 %i3, -1
  %i5 = or i32 %i2, %i4
  ret i32 %i5
}

define i32 @and_or_not_or6(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or6(
; CHECK-NEXT:    [[I:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[I2:%.*]] = and i32 [[I]], [[B:%.*]]
; CHECK-NEXT:    [[I3:%.*]] = or i32 [[B]], [[A]]
; CHECK-NEXT:    [[I4:%.*]] = xor i32 [[I3]], -1
; CHECK-NEXT:    [[I5:%.*]] = or i32 [[I4]], [[I2]]
; CHECK-NEXT:    ret i32 [[I5]]
;
  %i = xor i32 %A, -1
  %i2 = and i32 %i, %B
  %i3 = or i32 %B, %A
  %i4 = xor i32 %i3, -1
  %i5 = or i32 %i4, %i2
  ret i32 %i5
}

define i32 @and_or_not_or7(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or7(
; CHECK-NEXT:    [[I:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[I2:%.*]] = and i32 [[B:%.*]], [[I]]
; CHECK-NEXT:    [[I3:%.*]] = or i32 [[B]], [[A]]
; CHECK-NEXT:    [[I4:%.*]] = xor i32 [[I3]], -1
; CHECK-NEXT:    [[I5:%.*]] = or i32 [[I4]], [[I2]]
; CHECK-NEXT:    ret i32 [[I5]]
;
  %i = xor i32 %A, -1
  %i2 = and i32 %B, %i
  %i3 = or i32 %B, %A
  %i4 = xor i32 %i3, -1
  %i5 = or i32 %i4, %i2
  ret i32 %i5
}

define i32 @and_or_not_or8(i32 %A, i32 %B) {
; CHECK-LABEL: @and_or_not_or8(
; CHECK-NEXT:    [[I:%.*]] = xor i32 [[B:%.*]], -1
; CHECK-NEXT:    [[I2:%.*]] = and i32 [[A:%.*]], [[I]]
; CHECK-NEXT:    [[I3:%.*]] = or i32 [[B]], [[A]]
; CHECK-NEXT:    [[I4:%.*]] = xor i32 [[I3]], -1
; CHECK-NEXT:    [[I5:%.*]] = or i32 [[I4]], [[I2]]
; CHECK-NEXT:    ret i32 [[I5]]
;
  %i = xor i32 %B, -1
  %i2 = and i32 %A, %i
  %i3 = or i32 %B, %A
  %i4 = xor i32 %i3, -1
  %i5 = or i32 %i4, %i2
  ret i32 %i5
}
