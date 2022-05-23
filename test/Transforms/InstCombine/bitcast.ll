; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-darwin10.0.0"

; Bitcasts between vectors and scalars are valid.
; PR4487
define i32 @test1(i64 %a) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 0
;
  %t1 = bitcast i64 %a to <2 x i32>
  %t2 = bitcast i64 %a to <2 x i32>
  %t3 = xor <2 x i32> %t1, %t2
  %t4 = extractelement <2 x i32> %t3, i32 0
  ret i32 %t4
}

; Perform the bitwise logic in the source type of the operands to eliminate bitcasts.

define <2 x i32> @xor_two_vector_bitcasts(<1 x i64> %a, <1 x i64> %b) {
; CHECK-LABEL: @xor_two_vector_bitcasts(
; CHECK-NEXT:    [[T31:%.*]] = xor <1 x i64> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = bitcast <1 x i64> [[T31]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[T3]]
;
  %t1 = bitcast <1 x i64> %a to <2 x i32>
  %t2 = bitcast <1 x i64> %b to <2 x i32>
  %t3 = xor <2 x i32> %t1, %t2
  ret <2 x i32> %t3
}

; No change. Bitcasts are canonicalized above bitwise logic.

define <2 x i32> @xor_bitcast_vec_to_vec(<1 x i64> %a) {
; CHECK-LABEL: @xor_bitcast_vec_to_vec(
; CHECK-NEXT:    [[T1:%.*]] = bitcast <1 x i64> [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[T2:%.*]] = xor <2 x i32> [[T1]], <i32 1, i32 2>
; CHECK-NEXT:    ret <2 x i32> [[T2]]
;
  %t1 = bitcast <1 x i64> %a to <2 x i32>
  %t2 = xor <2 x i32> <i32 1, i32 2>, %t1
  ret <2 x i32> %t2
}

; No change. Bitcasts are canonicalized above bitwise logic.

define i64 @and_bitcast_vec_to_int(<2 x i32> %a) {
; CHECK-LABEL: @and_bitcast_vec_to_int(
; CHECK-NEXT:    [[T1:%.*]] = bitcast <2 x i32> [[A:%.*]] to i64
; CHECK-NEXT:    [[T2:%.*]] = and i64 [[T1]], 3
; CHECK-NEXT:    ret i64 [[T2]]
;
  %t1 = bitcast <2 x i32> %a to i64
  %t2 = and i64 %t1, 3
  ret i64 %t2
}

; No change. Bitcasts are canonicalized above bitwise logic.

define <2 x i32> @or_bitcast_int_to_vec(i64 %a) {
; CHECK-LABEL: @or_bitcast_int_to_vec(
; CHECK-NEXT:    [[T1:%.*]] = bitcast i64 [[A:%.*]] to <2 x i32>
; CHECK-NEXT:    [[T2:%.*]] = or <2 x i32> [[T1]], <i32 1, i32 2>
; CHECK-NEXT:    ret <2 x i32> [[T2]]
;
  %t1 = bitcast i64 %a to <2 x i32>
  %t2 = or <2 x i32> %t1, <i32 1, i32 2>
  ret <2 x i32> %t2
}

; PR26702 - https://bugs.llvm.org//show_bug.cgi?id=26702
; Bitcast is canonicalized above logic, so we can see the not-not pattern.

define <2 x i64> @is_negative(<4 x i32> %x) {
; CHECK-LABEL: @is_negative(
; CHECK-NEXT:    [[LOBIT:%.*]] = ashr <4 x i32> [[X:%.*]], <i32 31, i32 31, i32 31, i32 31>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[LOBIT]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP1]]
;
  %lobit = ashr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %not = xor <4 x i32> %lobit, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc = bitcast <4 x i32> %not to <2 x i64>
  %notnot = xor <2 x i64> %bc, <i64 -1, i64 -1>
  ret <2 x i64> %notnot
}

; This variation has an extra bitcast at the end. This means that the 2nd xor
; can be done in <4 x i32> to eliminate a bitcast regardless of canonicalizaion.

define <4 x i32> @is_negative_bonus_bitcast(<4 x i32> %x) {
; CHECK-LABEL: @is_negative_bonus_bitcast(
; CHECK-NEXT:    [[LOBIT:%.*]] = ashr <4 x i32> [[X:%.*]], <i32 31, i32 31, i32 31, i32 31>
; CHECK-NEXT:    ret <4 x i32> [[LOBIT]]
;
  %lobit = ashr <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %not = xor <4 x i32> %lobit, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc = bitcast <4 x i32> %not to <2 x i64>
  %notnot = xor <2 x i64> %bc, <i64 -1, i64 -1>
  %bc2 = bitcast <2 x i64> %notnot to <4 x i32>
  ret <4 x i32> %bc2
}

; Bitcasts are canonicalized above bitwise logic.

define <2 x i8> @canonicalize_bitcast_logic_with_constant(<4 x i4> %x) {
; CHECK-LABEL: @canonicalize_bitcast_logic_with_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i4> [[X:%.*]] to <2 x i8>
; CHECK-NEXT:    [[B:%.*]] = and <2 x i8> [[TMP1]], <i8 -128, i8 -128>
; CHECK-NEXT:    ret <2 x i8> [[B]]
;
  %a = and <4 x i4> %x, <i4 0, i4 8, i4 0, i4 8>
  %b = bitcast <4 x i4> %a to <2 x i8>
  ret <2 x i8> %b
}

; PR27925 - https://llvm.org/bugs/show_bug.cgi?id=27925

define <4 x i32> @bitcasts_and_bitcast(<4 x i32> %a, <8 x i16> %b) {
; CHECK-LABEL: @bitcasts_and_bitcast(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i16> [[B:%.*]] to <4 x i32>
; CHECK-NEXT:    [[BC3:%.*]] = and <4 x i32> [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[BC3]]
;
  %bc1 = bitcast <4 x i32> %a to <2 x i64>
  %bc2 = bitcast <8 x i16> %b to <2 x i64>
  %and = and <2 x i64> %bc2, %bc1
  %bc3 = bitcast <2 x i64> %and to <4 x i32>
  ret <4 x i32> %bc3
}

; The destination must have an integer element type.
; FIXME: We can still eliminate one bitcast in this test by doing the logic op
; in the type of the input that has an integer element type.

define <4 x float> @bitcasts_and_bitcast_to_fp(<4 x float> %a, <8 x i16> %b) {
; CHECK-LABEL: @bitcasts_and_bitcast_to_fp(
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <4 x float> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[BC2:%.*]] = bitcast <8 x i16> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i64> [[BC2]], [[BC1]]
; CHECK-NEXT:    [[BC3:%.*]] = bitcast <2 x i64> [[AND]] to <4 x float>
; CHECK-NEXT:    ret <4 x float> [[BC3]]
;
  %bc1 = bitcast <4 x float> %a to <2 x i64>
  %bc2 = bitcast <8 x i16> %b to <2 x i64>
  %and = and <2 x i64> %bc2, %bc1
  %bc3 = bitcast <2 x i64> %and to <4 x float>
  ret <4 x float> %bc3
}

define <4 x float> @bitcasts_or_bitcast_to_fp(<4 x float> %a, <8 x i16> %b) {
; CHECK-LABEL: @bitcasts_or_bitcast_to_fp(
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <4 x float> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[BC2:%.*]] = bitcast <8 x i16> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[AND:%.*]] = or <2 x i64> [[BC1]], [[BC2]]
; CHECK-NEXT:    [[BC3:%.*]] = bitcast <2 x i64> [[AND]] to <4 x float>
; CHECK-NEXT:    ret <4 x float> [[BC3]]
;
  %bc1 = bitcast <4 x float> %a to <2 x i64>
  %bc2 = bitcast <8 x i16> %b to <2 x i64>
  %and = or <2 x i64> %bc1, %bc2
  %bc3 = bitcast <2 x i64> %and to <4 x float>
  ret <4 x float> %bc3
}

; FIXME: Transform limited from changing vector op to integer op to avoid codegen problems.

define i128 @bitcast_or_bitcast(i128 %a, <2 x i64> %b) {
; CHECK-LABEL: @bitcast_or_bitcast(
; CHECK-NEXT:    [[BC1:%.*]] = bitcast i128 [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i64> [[BC1]], [[B:%.*]]
; CHECK-NEXT:    [[BC2:%.*]] = bitcast <2 x i64> [[OR]] to i128
; CHECK-NEXT:    ret i128 [[BC2]]
;
  %bc1 = bitcast i128 %a to <2 x i64>
  %or = or <2 x i64> %b, %bc1
  %bc2 = bitcast <2 x i64> %or to i128
  ret i128 %bc2
}

; FIXME: Transform limited from changing integer op to vector op to avoid codegen problems.

define <4 x i32> @bitcast_xor_bitcast(<4 x i32> %a, i128 %b) {
; CHECK-LABEL: @bitcast_xor_bitcast(
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <4 x i32> [[A:%.*]] to i128
; CHECK-NEXT:    [[XOR:%.*]] = xor i128 [[BC1]], [[B:%.*]]
; CHECK-NEXT:    [[BC2:%.*]] = bitcast i128 [[XOR]] to <4 x i32>
; CHECK-NEXT:    ret <4 x i32> [[BC2]]
;
  %bc1 = bitcast <4 x i32> %a to i128
  %xor = xor i128 %bc1, %b
  %bc2 = bitcast i128 %xor to <4 x i32>
  ret <4 x i32> %bc2
}

; https://llvm.org/bugs/show_bug.cgi?id=6137#c6

define <4 x float> @bitcast_vector_select(<4 x float> %x, <2 x i64> %y, <4 x i1> %cmp) {
; CHECK-LABEL: @bitcast_vector_select(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[Y:%.*]] to <4 x float>
; CHECK-NEXT:    [[T7:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x float> [[X:%.*]], <4 x float> [[TMP1]]
; CHECK-NEXT:    ret <4 x float> [[T7]]
;
  %t4 = bitcast <4 x float> %x to <4 x i32>
  %t5 = bitcast <2 x i64> %y to <4 x i32>
  %t6 = select <4 x i1> %cmp, <4 x i32> %t4, <4 x i32> %t5
  %t7 = bitcast <4 x i32> %t6 to <4 x float>
  ret <4 x float> %t7
}

define float @bitcast_scalar_select_of_scalars(float %x, i32 %y, i1 %cmp) {
; CHECK-LABEL: @bitcast_scalar_select_of_scalars(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32 [[Y:%.*]] to float
; CHECK-NEXT:    [[T7:%.*]] = select i1 [[CMP:%.*]], float [[X:%.*]], float [[TMP1]]
; CHECK-NEXT:    ret float [[T7]]
;
  %t4 = bitcast float %x to i32
  %t6 = select i1 %cmp, i32 %t4, i32 %y
  %t7 = bitcast i32 %t6 to float
  ret float %t7
}

; FIXME: We should change the select operand types to scalars, but we need to make
; sure the backend can reverse that transform if needed.

define float @bitcast_scalar_select_type_mismatch1(float %x, <4 x i8> %y, i1 %cmp) {
; CHECK-LABEL: @bitcast_scalar_select_type_mismatch1(
; CHECK-NEXT:    [[T4:%.*]] = bitcast float [[X:%.*]] to <4 x i8>
; CHECK-NEXT:    [[T6:%.*]] = select i1 [[CMP:%.*]], <4 x i8> [[T4]], <4 x i8> [[Y:%.*]]
; CHECK-NEXT:    [[T7:%.*]] = bitcast <4 x i8> [[T6]] to float
; CHECK-NEXT:    ret float [[T7]]
;
  %t4 = bitcast float %x to <4 x i8>
  %t6 = select i1 %cmp, <4 x i8> %t4, <4 x i8> %y
  %t7 = bitcast <4 x i8> %t6 to float
  ret float %t7
}

; FIXME: We should change the select operand types to vectors, but we need to make
; sure the backend can reverse that transform if needed.

define <4 x i8> @bitcast_scalar_select_type_mismatch2(<4 x i8> %x, float %y, i1 %cmp) {
; CHECK-LABEL: @bitcast_scalar_select_type_mismatch2(
; CHECK-NEXT:    [[T4:%.*]] = bitcast <4 x i8> [[X:%.*]] to float
; CHECK-NEXT:    [[T6:%.*]] = select i1 [[CMP:%.*]], float [[T4]], float [[Y:%.*]]
; CHECK-NEXT:    [[T7:%.*]] = bitcast float [[T6]] to <4 x i8>
; CHECK-NEXT:    ret <4 x i8> [[T7]]
;
  %t4 = bitcast <4 x i8> %x to float
  %t6 = select i1 %cmp, float %t4, float %y
  %t7 = bitcast float %t6 to <4 x i8>
  ret <4 x i8> %t7
}

define <4 x float> @bitcast_scalar_select_of_vectors(<4 x float> %x, <2 x i64> %y, i1 %cmp) {
; CHECK-LABEL: @bitcast_scalar_select_of_vectors(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[Y:%.*]] to <4 x float>
; CHECK-NEXT:    [[T7:%.*]] = select i1 [[CMP:%.*]], <4 x float> [[X:%.*]], <4 x float> [[TMP1]]
; CHECK-NEXT:    ret <4 x float> [[T7]]
;
  %t4 = bitcast <4 x float> %x to <4 x i32>
  %t5 = bitcast <2 x i64> %y to <4 x i32>
  %t6 = select i1 %cmp, <4 x i32> %t4, <4 x i32> %t5
  %t7 = bitcast <4 x i32> %t6 to <4 x float>
  ret <4 x float> %t7
}

; Can't change the type of the vector select if the dest type is scalar.

define float @bitcast_vector_select_no_fold1(float %x, <2 x i16> %y, <4 x i1> %cmp) {
; CHECK-LABEL: @bitcast_vector_select_no_fold1(
; CHECK-NEXT:    [[T4:%.*]] = bitcast float [[X:%.*]] to <4 x i8>
; CHECK-NEXT:    [[T5:%.*]] = bitcast <2 x i16> [[Y:%.*]] to <4 x i8>
; CHECK-NEXT:    [[T6:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i8> [[T4]], <4 x i8> [[T5]]
; CHECK-NEXT:    [[T7:%.*]] = bitcast <4 x i8> [[T6]] to float
; CHECK-NEXT:    ret float [[T7]]
;
  %t4 = bitcast float %x to <4 x i8>
  %t5 = bitcast <2 x i16> %y to <4 x i8>
  %t6 = select <4 x i1> %cmp, <4 x i8> %t4, <4 x i8> %t5
  %t7 = bitcast <4 x i8> %t6 to float
  ret float %t7
}

; Can't change the type of the vector select if the number of elements in the dest type is not the same.

define <2 x float> @bitcast_vector_select_no_fold2(<2 x float> %x, <4 x i16> %y, <8 x i1> %cmp) {
; CHECK-LABEL: @bitcast_vector_select_no_fold2(
; CHECK-NEXT:    [[T4:%.*]] = bitcast <2 x float> [[X:%.*]] to <8 x i8>
; CHECK-NEXT:    [[T5:%.*]] = bitcast <4 x i16> [[Y:%.*]] to <8 x i8>
; CHECK-NEXT:    [[T6:%.*]] = select <8 x i1> [[CMP:%.*]], <8 x i8> [[T4]], <8 x i8> [[T5]]
; CHECK-NEXT:    [[T7:%.*]] = bitcast <8 x i8> [[T6]] to <2 x float>
; CHECK-NEXT:    ret <2 x float> [[T7]]
;
  %t4 = bitcast <2 x float> %x to <8 x i8>
  %t5 = bitcast <4 x i16> %y to <8 x i8>
  %t6 = select <8 x i1> %cmp, <8 x i8> %t4, <8 x i8> %t5
  %t7 = bitcast <8 x i8> %t6 to <2 x float>
  ret <2 x float> %t7
}

; Optimize bitcasts that are extracting low element of vector.  This happens because of SRoA.
; rdar://7892780
define float @test2(<2 x float> %A, <2 x i32> %B) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <2 x float> [[A:%.*]], i64 0
; CHECK-NEXT:    [[BC:%.*]] = bitcast <2 x i32> [[B:%.*]] to <2 x float>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x float> [[BC]], i64 0
; CHECK-NEXT:    [[ADD:%.*]] = fadd float [[TMP24]], [[TMP4]]
; CHECK-NEXT:    ret float [[ADD]]
;
  %tmp28 = bitcast <2 x float> %A to i64  ; <i64> [#uses=2]
  %tmp23 = trunc i64 %tmp28 to i32                ; <i32> [#uses=1]
  %tmp24 = bitcast i32 %tmp23 to float            ; <float> [#uses=1]

  %tmp = bitcast <2 x i32> %B to i64
  %tmp2 = trunc i64 %tmp to i32                ; <i32> [#uses=1]
  %tmp4 = bitcast i32 %tmp2 to float            ; <float> [#uses=1]

  %add = fadd float %tmp24, %tmp4
  ret float %add
}

; Optimize bitcasts that are extracting other elements of a vector.  This happens because of SRoA.
; rdar://7892780
define float @test3(<2 x float> %A, <2 x i64> %B) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <2 x float> [[A:%.*]], i64 1
; CHECK-NEXT:    [[BC2:%.*]] = bitcast <2 x i64> [[B:%.*]] to <4 x float>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[BC2]], i64 2
; CHECK-NEXT:    [[ADD:%.*]] = fadd float [[TMP24]], [[TMP4]]
; CHECK-NEXT:    ret float [[ADD]]
;
  %tmp28 = bitcast <2 x float> %A to i64
  %tmp29 = lshr i64 %tmp28, 32
  %tmp23 = trunc i64 %tmp29 to i32
  %tmp24 = bitcast i32 %tmp23 to float

  %tmp = bitcast <2 x i64> %B to i128
  %tmp1 = lshr i128 %tmp, 64
  %tmp2 = trunc i128 %tmp1 to i32
  %tmp4 = bitcast i32 %tmp2 to float

  %add = fadd float %tmp24, %tmp4
  ret float %add
}

; Both bitcasts are unnecessary; change the extractelement.

define float @bitcast_extelt1(<2 x float> %A) {
; CHECK-LABEL: @bitcast_extelt1(
; CHECK-NEXT:    [[BC2:%.*]] = extractelement <2 x float> [[A:%.*]], i64 0
; CHECK-NEXT:    ret float [[BC2]]
;
  %bc1 = bitcast <2 x float> %A to <2 x i32>
  %ext = extractelement <2 x i32> %bc1, i32 0
  %bc2 = bitcast i32 %ext to float
  ret float %bc2
}

; Second bitcast can be folded into the first.

define i64 @bitcast_extelt2(<4 x float> %A) {
; CHECK-LABEL: @bitcast_extelt2(
; CHECK-NEXT:    [[BC:%.*]] = bitcast <4 x float> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[BC2:%.*]] = extractelement <2 x i64> [[BC]], i64 1
; CHECK-NEXT:    ret i64 [[BC2]]
;
  %bc1 = bitcast <4 x float> %A to <2 x double>
  %ext = extractelement <2 x double> %bc1, i32 1
  %bc2 = bitcast double %ext to i64
  ret i64 %bc2
}

; TODO: This should return %A.

define <2 x i32> @bitcast_extelt3(<2 x i32> %A) {
; CHECK-LABEL: @bitcast_extelt3(
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <2 x i32> [[A:%.*]] to <1 x i64>
; CHECK-NEXT:    [[EXT:%.*]] = extractelement <1 x i64> [[BC1]], i64 0
; CHECK-NEXT:    [[BC2:%.*]] = bitcast i64 [[EXT]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[BC2]]
;
  %bc1 = bitcast <2 x i32> %A to <1 x i64>
  %ext = extractelement <1 x i64> %bc1, i32 0
  %bc2 = bitcast i64 %ext to <2 x i32>
  ret <2 x i32> %bc2
}

; Handle the case where the input is not a vector.

define double @bitcast_extelt4(i128 %A) {
; CHECK-LABEL: @bitcast_extelt4(
; CHECK-NEXT:    [[BC:%.*]] = bitcast i128 [[A:%.*]] to <2 x double>
; CHECK-NEXT:    [[BC2:%.*]] = extractelement <2 x double> [[BC]], i64 0
; CHECK-NEXT:    ret double [[BC2]]
;
  %bc1 = bitcast i128 %A to <2 x i64>
  %ext = extractelement <2 x i64> %bc1, i32 0
  %bc2 = bitcast i64 %ext to double
  ret double %bc2
}

define <2 x i32> @test4(i32 %A, i32 %B){
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> poison, i32 [[A:%.*]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i32> [[TMP1]], i32 [[B:%.*]], i64 1
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %tmp38 = zext i32 %A to i64
  %tmp32 = zext i32 %B to i64
  %tmp33 = shl i64 %tmp32, 32
  %ins35 = or i64 %tmp33, %tmp38
  %tmp43 = bitcast i64 %ins35 to <2 x i32>
  ret <2 x i32> %tmp43
}

; rdar://8360454
define <2 x float> @test5(float %A, float %B) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x float> poison, float [[A:%.*]], i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x float> [[TMP1]], float [[B:%.*]], i64 1
; CHECK-NEXT:    ret <2 x float> [[TMP2]]
;
  %tmp37 = bitcast float %A to i32
  %tmp38 = zext i32 %tmp37 to i64
  %tmp31 = bitcast float %B to i32
  %tmp32 = zext i32 %tmp31 to i64
  %tmp33 = shl i64 %tmp32, 32
  %ins35 = or i64 %tmp33, %tmp38
  %tmp43 = bitcast i64 %ins35 to <2 x float>
  ret <2 x float> %tmp43
}

define <2 x float> @test6(float %A){
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x float> <float 4.200000e+01, float poison>, float [[A:%.*]], i64 1
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %tmp23 = bitcast float %A to i32
  %tmp24 = zext i32 %tmp23 to i64
  %tmp25 = shl i64 %tmp24, 32
  %mask20 = or i64 %tmp25, 1109917696
  %tmp35 = bitcast i64 %mask20 to <2 x float>
  ret <2 x float> %tmp35
}

; This test should not be optimized by OptimizeIntegerToVectorInsertions.
; The bitcast from vector previously confused it.
define <2 x i64> @int2vec_insertion_bitcast_from_vec(i64 %x) {
; CHECK-LABEL: @int2vec_insertion_bitcast_from_vec(
; CHECK-NEXT:    [[A:%.*]] = bitcast i64 [[X:%.*]] to <8 x i8>
; CHECK-NEXT:    [[B:%.*]] = zext <8 x i8> [[A]] to <8 x i16>
; CHECK-NEXT:    [[D:%.*]] = bitcast <8 x i16> [[B]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[D]]
;
  %a = bitcast i64 %x to <8 x i8>
  %b = zext <8 x i8> %a to <8 x i16>
  %c = bitcast <8 x i16> %b to i128
  %d = bitcast i128 %c to <2 x i64>
  ret <2 x i64> %d
}

define i64 @ISPC0(i64 %in) {
; CHECK-LABEL: @ISPC0(
; CHECK-NEXT:    ret i64 0
;
  %out = and i64 %in, xor (i64 bitcast (<4 x i16> <i16 -1, i16 -1, i16 -1, i16 -1> to i64), i64 -1)
  ret i64 %out
}


define i64 @Vec2(i64 %in) {
; CHECK-LABEL: @Vec2(
; CHECK-NEXT:    ret i64 0
;
  %out = and i64 %in, xor (i64 bitcast (<4 x i16> <i16 0, i16 0, i16 0, i16 0> to i64), i64 0)
  ret i64 %out
}

define i64 @All11(i64 %in) {
; CHECK-LABEL: @All11(
; CHECK-NEXT:    ret i64 0
;
  %out = and i64 %in, xor (i64 bitcast (<2 x float> bitcast (i64 -1 to <2 x float>) to i64), i64 -1)
  ret i64 %out
}


define i32 @All111(i32 %in) {
; CHECK-LABEL: @All111(
; CHECK-NEXT:    ret i32 0
;
  %out = and i32 %in, xor (i32 bitcast (<1 x float> bitcast (i32 -1 to <1 x float>) to i32), i32 -1)
  ret i32 %out
}

define <vscale x 1 x i32> @ScalableAll111(<vscale x 1 x i32> %in) {
; CHECK-LABEL: @ScalableAll111(
; CHECK-NEXT:    ret <vscale x 1 x i32> [[IN:%.*]]
;
  %out = and <vscale x 1 x i32> %in, bitcast (<vscale x 2 x i16> shufflevector (<vscale x 2 x i16> insertelement (<vscale x 2 x i16> undef, i16 -1, i32 0), <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer) to <vscale x 1 x i32>)
  ret <vscale x 1 x i32> %out
}

define <2 x i16> @BitcastInsert(i32 %a) {
; CHECK-LABEL: @BitcastInsert(
; CHECK-NEXT:    [[R:%.*]] = bitcast i32 [[A:%.*]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[R]]
;
  %v = insertelement <1 x i32> undef, i32 %a, i32 0
  %r = bitcast <1 x i32> %v to <2 x i16>
  ret <2 x i16> %r
}

; PR17293
define <2 x i64> @test7(<2 x i8*>* %arg) nounwind {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[CAST:%.*]] = bitcast <2 x i8*>* [[ARG:%.*]] to <2 x i64>*
; CHECK-NEXT:    [[LOAD:%.*]] = load <2 x i64>, <2 x i64>* [[CAST]], align 16
; CHECK-NEXT:    ret <2 x i64> [[LOAD]]
;
  %cast = bitcast <2 x i8*>* %arg to <2 x i64>*
  %load = load <2 x i64>, <2 x i64>* %cast, align 16
  ret <2 x i64> %load
}

define i8 @test8() {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i8 -85
;
  %res = bitcast <8 x i1> <i1 true, i1 true, i1 false, i1 true, i1 false, i1 true, i1 false, i1 true> to i8
  ret i8 %res
}

@g = internal unnamed_addr global i32 undef

define void @constant_fold_vector_to_double() {
; CHECK-LABEL: @constant_fold_vector_to_double(
; CHECK-NEXT:    store volatile double 1.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 1.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 0xFFFFFFFFFFFFFFFF, double* undef, align 8
; CHECK-NEXT:    store volatile double 0x162E000004D2, double* undef, align 8
; CHECK-NEXT:    store volatile double bitcast (<2 x i32> <i32 1234, i32 ptrtoint (i32* @g to i32)> to double), double* undef, align 8
; CHECK-NEXT:    store volatile double 0x400000003F800000, double* undef, align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* undef, align 8
; CHECK-NEXT:    store volatile double 0.000000e+00, double* undef, align 8
; CHECK-NEXT:    ret void
;
  store volatile double bitcast (<1 x i64> <i64 4607182418800017408> to double), double* undef
  store volatile double bitcast (<2 x i32> <i32 0, i32 1072693248> to double), double* undef
  store volatile double bitcast (<4 x i16> <i16 0, i16 0, i16 0, i16 16368> to double), double* undef
  store volatile double bitcast (<8 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 240, i8 63> to double), double* undef

  store volatile double bitcast (<2 x i32> <i32 -1, i32 -1> to double), double* undef
  store volatile double bitcast (<2 x i32> <i32 1234, i32 5678> to double), double* undef

  store volatile double bitcast (<2 x i32> <i32 1234, i32 ptrtoint (i32* @g to i32)> to double), double* undef
  store volatile double bitcast (<2 x float> <float 1.0, float 2.0> to double), double* undef

  store volatile double bitcast (<2 x i32> zeroinitializer to double), double* undef
  store volatile double bitcast (<4 x i16> zeroinitializer to double), double* undef
  store volatile double bitcast (<8 x i8> zeroinitializer to double), double* undef
  store volatile double bitcast (<16 x i4> zeroinitializer to double), double* undef
  store volatile double bitcast (<32 x i2> zeroinitializer to double), double* undef
  store volatile double bitcast (<64 x i1> zeroinitializer to double), double* undef
  ret void
}

define void @constant_fold_vector_to_float() {
; CHECK-LABEL: @constant_fold_vector_to_float(
; CHECK-NEXT:    store volatile float 1.000000e+00, float* undef, align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* undef, align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* undef, align 4
; CHECK-NEXT:    store volatile float 1.000000e+00, float* undef, align 4
; CHECK-NEXT:    ret void
;
  store volatile float bitcast (<1 x i32> <i32 1065353216> to float), float* undef
  store volatile float bitcast (<2 x i16> <i16 0, i16 16256> to float), float* undef
  store volatile float bitcast (<4 x i8> <i8 0, i8 0, i8 128, i8 63> to float), float* undef
  store volatile float bitcast (<32 x i1> <i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 0, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 0, i1 0> to float), float* undef

  ret void
}

define void @constant_fold_vector_to_half() {
; CHECK-LABEL: @constant_fold_vector_to_half(
; CHECK-NEXT:    store volatile half 0xH4000, half* undef, align 2
; CHECK-NEXT:    store volatile half 0xH4000, half* undef, align 2
; CHECK-NEXT:    ret void
;
  store volatile half bitcast (<2 x i8> <i8 0, i8 64> to half), half* undef
  store volatile half bitcast (<4 x i4> <i4 0, i4 0, i4 0, i4 4> to half), half* undef
  ret void
}

; Ensure that we do not crash when looking at such a weird bitcast.
define i8* @bitcast_from_single_element_pointer_vector_to_pointer(<1 x i8*> %ptrvec) {
; CHECK-LABEL: @bitcast_from_single_element_pointer_vector_to_pointer(
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <1 x i8*> [[PTRVEC:%.*]], i64 0
; CHECK-NEXT:    ret i8* [[TMP1]]
;
  %ptr = bitcast <1 x i8*> %ptrvec to i8*
  ret i8* %ptr
}

declare void @f1()
declare void @f2()
define i8* @select_bitcast_unsized_pointer(i1 %c) {
; CHECK-LABEL: @select_bitcast_unsized_pointer(
; CHECK-NEXT:    [[B:%.*]] = select i1 [[C:%.*]], i8* bitcast (void ()* @f1 to i8*), i8* bitcast (void ()* @f2 to i8*)
; CHECK-NEXT:    ret i8* [[B]]
;
  %s = select i1 %c, void ()* @f1, void ()* @f2
  %b = bitcast void ()* %s to i8*
  ret i8* %b
}
