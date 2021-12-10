; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -data-layout="e-p:64:64:64-p1:16:16:16-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64" -instsimplify -S | FileCheck %s --check-prefixes=CHECK,LE
; RUN: opt < %s -data-layout="E-p:64:64:64-p1:16:16:16-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64" -instsimplify -S | FileCheck %s --check-prefixes=CHECK,BE

; {{ 0xDEADBEEF, 0xBA }, 0xCAFEBABE}
@g1 = constant {{i32,i8},i32} {{i32,i8} { i32 -559038737, i8 186 }, i32 -889275714 }
@g2 = constant double 1.0
; { 0x7B, 0x06B1BFF8 }
@g3 = constant {i64, i64} { i64 123, i64 112312312 }

; Simple load
define i32 @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 -559038737
;
  %r = load i32, i32* getelementptr ({{i32,i8},i32}, {{i32,i8},i32}* @g1, i32 0, i32 0, i32 0)
  ret i32 %r
}

; PR3152
; Load of first 16 bits of 32-bit value.
define i16 @test2() {
; LE-LABEL: @test2(
; LE-NEXT:    ret i16 -16657
;
; BE-LABEL: @test2(
; BE-NEXT:    ret i16 -8531
;
  %r = load i16, i16* bitcast(i32* getelementptr ({{i32,i8},i32}, {{i32,i8},i32}* @g1, i32 0, i32 0, i32 0) to i16*)
  ret i16 %r
}

define i16 @test2_addrspacecast() {
; LE-LABEL: @test2_addrspacecast(
; LE-NEXT:    ret i16 -16657
;
; BE-LABEL: @test2_addrspacecast(
; BE-NEXT:    ret i16 -8531
;
  %r = load i16, i16 addrspace(1)* addrspacecast(i32* getelementptr ({{i32,i8},i32}, {{i32,i8},i32}* @g1, i32 0, i32 0, i32 0) to i16 addrspace(1)*)
  ret i16 %r
}

; Load of second 16 bits of 32-bit value.
define i16 @test3() {
; LE-LABEL: @test3(
; LE-NEXT:    ret i16 -8531
;
; BE-LABEL: @test3(
; BE-NEXT:    ret i16 -16657
;
  %r = load i16, i16* getelementptr(i16, i16* bitcast(i32* getelementptr ({{i32,i8},i32}, {{i32,i8},i32}* @g1, i32 0, i32 0, i32 0) to i16*), i32 1)
  ret i16 %r
}

; Load of 8 bit field + tail padding.
define i16 @test4() {
; LE-LABEL: @test4(
; LE-NEXT:    ret i16 186
;
; BE-LABEL: @test4(
; BE-NEXT:    ret i16 -17920
;
  %r = load i16, i16* getelementptr(i16, i16* bitcast(i32* getelementptr ({{i32,i8},i32}, {{i32,i8},i32}* @g1, i32 0, i32 0, i32 0) to i16*), i32 2)
  ret i16 %r
}

; Load of double bits.
define i64 @test6() {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i64 4607182418800017408
;
  %r = load i64, i64* bitcast(double* @g2 to i64*)
  ret i64 %r
}

; Load of double bits.
define i16 @test7() {
; LE-LABEL: @test7(
; LE-NEXT:    ret i16 0
;
; BE-LABEL: @test7(
; BE-NEXT:    ret i16 16368
;
  %r = load i16, i16* bitcast(double* @g2 to i16*)
  ret i16 %r
}

; Double load.
define double @test8() {
; LE-LABEL: @test8(
; LE-NEXT:    ret double 0xBADEADBEEF
;
; BE-LABEL: @test8(
; BE-NEXT:    ret double 0xDEADBEEFBA000000
;
  %r = load double, double* bitcast({{i32,i8},i32}* @g1 to double*)
  ret double %r
}


; i128 load.
define i128 @test9() {
; LE-LABEL: @test9(
; LE-NEXT:    ret i128 2071796475790618158476296315
;
; BE-LABEL: @test9(
; BE-NEXT:    ret i128 2268949521066387161080
;
  %r = load i128, i128* bitcast({i64, i64}* @g3 to i128*)
  ret i128 %r
}

; vector load.
define <2 x i64> @test10() {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret <2 x i64> <i64 123, i64 112312312>
;
  %r = load <2 x i64>, <2 x i64>* bitcast({i64, i64}* @g3 to <2 x i64>*)
  ret <2 x i64> %r
}


; PR5287
; { 0xA1, 0x08 }
@g4 = internal constant { i8, i8 } { i8 -95, i8 8 }

define i16 @test11() nounwind {
; LE-LABEL: @test11(
; LE-NEXT:  entry:
; LE-NEXT:    ret i16 2209
;
; BE-LABEL: @test11(
; BE-NEXT:  entry:
; BE-NEXT:    ret i16 -24312
;
entry:
  %a = load i16, i16* bitcast ({ i8, i8 }* @g4 to i16*)
  ret i16 %a
}


; PR5551
@test12g = private constant [6 x i8] c"a\00b\00\00\00"

define i16 @test12() {
; LE-LABEL: @test12(
; LE-NEXT:    ret i16 98
;
; BE-LABEL: @test12(
; BE-NEXT:    ret i16 25088
;
  %a = load i16, i16* getelementptr inbounds ([3 x i16], [3 x i16]* bitcast ([6 x i8]* @test12g to [3 x i16]*), i32 0, i64 1)
  ret i16 %a
}


; PR5978
@g5 = constant i8 4
define i1 @test13() {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    ret i1 false
;
  %A = load i1, i1* bitcast (i8* @g5 to i1*)
  ret i1 %A
}

@g6 = constant [2 x i8*] [i8* inttoptr (i64 1 to i8*), i8* inttoptr (i64 2 to i8*)]
define i64 @test14() nounwind {
; CHECK-LABEL: @test14(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 1
;
entry:
  %tmp = load i64, i64* bitcast ([2 x i8*]* @g6 to i64*)
  ret i64 %tmp
}

; Check with address space pointers
@g6_as1 = constant [2 x i8 addrspace(1)*] [i8 addrspace(1)* inttoptr (i16 1 to i8 addrspace(1)*), i8 addrspace(1)* inttoptr (i16 2 to i8 addrspace(1)*)]
define i16 @test14_as1() nounwind {
; CHECK-LABEL: @test14_as1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i16 1
;
entry:
  %tmp = load i16, i16* bitcast ([2 x i8 addrspace(1)*]* @g6_as1 to i16*)
  ret i16 %tmp
}

define i64 @test15() nounwind {
; CHECK-LABEL: @test15(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 2
;
entry:
  %tmp = load i64, i64* bitcast (i8** getelementptr inbounds ([2 x i8*], [2 x i8*]* @g6, i32 0, i64 1) to i64*)
  ret i64 %tmp
}

@gv7 = constant [4 x i8*] [i8* null, i8* inttoptr (i64 -14 to i8*), i8* null, i8* null]
define i64 @test16.1() {
; CHECK-LABEL: @test16.1(
; CHECK-NEXT:    ret i64 0
;
  %v = load i64, i64* bitcast ([4 x i8*]* @gv7 to i64*), align 8
  ret i64 %v
}

define i64 @test16.2() {
; CHECK-LABEL: @test16.2(
; CHECK-NEXT:    ret i64 -14
;
  %v = load i64, i64* bitcast (i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @gv7, i64 0, i64 1) to i64*), align 8
  ret i64 %v
}

define i64 @test16.3() {
; CHECK-LABEL: @test16.3(
; CHECK-NEXT:    ret i64 0
;
  %v = load i64, i64* bitcast (i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @gv7, i64 0, i64 2) to i64*), align 8
  ret i64 %v
}

@g7 = constant {[0 x i32], [0 x i8], {}*} { [0 x i32] undef, [0 x i8] undef, {}* null }

define i64* @test_leading_zero_size_elems() {
; CHECK-LABEL: @test_leading_zero_size_elems(
; CHECK-NEXT:    ret i64* null
;
  %v = load i64*, i64** bitcast ({[0 x i32], [0 x i8], {}*}* @g7 to i64**)
  ret i64* %v
}

@g8 = constant {[4294967295 x [0 x i32]], i64} { [4294967295 x [0 x i32]] undef, i64 123 }

define i64 @test_leading_zero_size_elems_big() {
; CHECK-LABEL: @test_leading_zero_size_elems_big(
; CHECK-NEXT:    ret i64 123
;
  %v = load i64, i64* bitcast ({[4294967295 x [0 x i32]], i64}* @g8 to i64*)
  ret i64 %v
}

@g9 = constant [4294967295 x [0 x i32]] zeroinitializer

define i64 @test_array_of_zero_size_array() {
; CHECK-LABEL: @test_array_of_zero_size_array(
; CHECK-NEXT:    ret i64 undef
;
  %v = load i64, i64* bitcast ([4294967295 x [0 x i32]]* @g9 to i64*)
  ret i64 %v
}

@g10 = constant {i128} {i128 undef}

define i32* @test_undef_aggregate() {
; CHECK-LABEL: @test_undef_aggregate(
; CHECK-NEXT:    ret i32* undef
;
  %v = load i32*, i32** bitcast ({i128}* @g10 to i32**)
  ret i32* %v
}

@g11 = constant <{ [8 x i8], [8 x i8] }> <{ [8 x i8] undef, [8 x i8] zeroinitializer }>, align 4

define {}* @test_trailing_zero_gep_index() {
; CHECK-LABEL: @test_trailing_zero_gep_index(
; CHECK-NEXT:    ret {}* null
;
  %v = load {}*, {}** bitcast (i8* getelementptr inbounds (<{ [8 x i8], [8 x i8] }>, <{ [8 x i8], [8 x i8] }>* @g11, i32 0, i32 1, i32 0) to {}**), align 4
  ret {}* %v
}

define { i64, i64 } @test_load_struct() {
; CHECK-LABEL: @test_load_struct(
; CHECK-NEXT:    [[V:%.*]] = load { i64, i64 }, { i64, i64 }* @g3, align 8
; CHECK-NEXT:    ret { i64, i64 } [[V]]
;
  %v = load { i64, i64 }, { i64, i64 }* @g3
  ret { i64, i64 } %v
}
