; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; This testcase tests for various features the basicaa test should be able to
; determine, as noted in the comments.

; RUN: opt < %s -basic-aa -gvn -instcombine -dce -S | FileCheck %s --check-prefixes=CHECK,NO_ASSUME
; RUN: opt < %s -basic-aa -gvn -instcombine -dce --enable-knowledge-retention -S | FileCheck %s --check-prefixes=CHECK,USE_ASSUME
target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

@Global = external global { i32 }

declare void @external(i32*)
declare void @llvm.assume(i1)

; Array test:  Test that operations on one local array do not invalidate
; operations on another array.  Important for scientific codes.
;
define i32 @different_array_test(i64 %A, i64 %B) {
; CHECK-LABEL: @different_array_test(
; CHECK-NEXT:    [[ARRAY11:%.*]] = alloca [100 x i32], align 4
; CHECK-NEXT:    [[ARRAY22:%.*]] = alloca [200 x i32], align 4
; CHECK-NEXT:    [[ARRAY22_SUB:%.*]] = getelementptr inbounds [200 x i32], [200 x i32]* [[ARRAY22]], i64 0, i64 0
; CHECK-NEXT:    [[ARRAY11_SUB:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[ARRAY11]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i32* [[ARRAY11_SUB]], i32 4) ]
; CHECK-NEXT:    call void @external(i32* nonnull [[ARRAY11_SUB]])
; CHECK-NEXT:    call void @external(i32* nonnull [[ARRAY22_SUB]])
; CHECK-NEXT:    [[POINTER2:%.*]] = getelementptr [200 x i32], [200 x i32]* [[ARRAY22]], i64 0, i64 [[B:%.*]]
; CHECK-NEXT:    store i32 7, i32* [[POINTER2]], align 4
; CHECK-NEXT:    ret i32 0
;
  %Array1 = alloca i32, i32 100
  %Array2 = alloca i32, i32 200
  call void @llvm.assume(i1 true) ["align"(i32* %Array1, i32 4)]

  call void @external(i32* %Array1)
  call void @external(i32* %Array2)

  %pointer = getelementptr i32, i32* %Array1, i64 %A
  %val = load i32, i32* %pointer

  %pointer2 = getelementptr i32, i32* %Array2, i64 %B
  store i32 7, i32* %pointer2

  %REMOVE = load i32, i32* %pointer ; redundant with above load
  %retval = sub i32 %REMOVE, %val
  ret i32 %retval
}

; Constant index test: Constant indexes into the same array should not
; interfere with each other.  Again, important for scientific codes.
;
define i32 @constant_array_index_test() {
; CHECK-LABEL: @constant_array_index_test(
; CHECK-NEXT:    [[ARRAY1:%.*]] = alloca [100 x i32], align 4
; CHECK-NEXT:    [[ARRAY1_SUB:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[ARRAY1]], i64 0, i64 0
; CHECK-NEXT:    call void @external(i32* nonnull [[ARRAY1_SUB]])
; CHECK-NEXT:    [[P2:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[ARRAY1]], i64 0, i64 6
; CHECK-NEXT:    store i32 1, i32* [[P2]], align 4
; CHECK-NEXT:    ret i32 0
;
  %Array = alloca i32, i32 100
  call void @external(i32* %Array)

  %P1 = getelementptr i32, i32* %Array, i64 7
  %P2 = getelementptr i32, i32* %Array, i64 6

  %A = load i32, i32* %P1
  store i32 1, i32* %P2   ; Should not invalidate load
  %BREMOVE = load i32, i32* %P1
  %Val = sub i32 %A, %BREMOVE
  ret i32 %Val
}

; Test that if two pointers are spaced out by a constant getelementptr, that
; they cannot alias.
define i32 @gep_distance_test(i32* %A) {
; NO_ASSUME-LABEL: @gep_distance_test(
; NO_ASSUME-NEXT:    [[B:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 2
; NO_ASSUME-NEXT:    store i32 7, i32* [[B]], align 4
; NO_ASSUME-NEXT:    ret i32 0
;
; USE_ASSUME-LABEL: @gep_distance_test(
; USE_ASSUME-NEXT:    [[B:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 2
; USE_ASSUME-NEXT:    store i32 7, i32* [[B]], align 4
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[A]], i64 4), "nonnull"(i32* [[A]]), "align"(i32* [[A]], i64 4) ]
; USE_ASSUME-NEXT:    ret i32 0
;
  %REMOVEu = load i32, i32* %A
  %B = getelementptr i32, i32* %A, i64 2  ; Cannot alias A
  store i32 7, i32* %B
  %REMOVEv = load i32, i32* %A
  %r = sub i32 %REMOVEu, %REMOVEv
  ret i32 %r
}

; Test that if two pointers are spaced out by a constant offset, that they
; cannot alias, even if there is a variable offset between them...
define i32 @gep_distance_test2({i32,i32}* %A, i64 %distance) {
; NO_ASSUME-LABEL: @gep_distance_test2(
; NO_ASSUME-NEXT:    [[B:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[A:%.*]], i64 [[DISTANCE:%.*]], i32 1
; NO_ASSUME-NEXT:    store i32 7, i32* [[B]], align 4
; NO_ASSUME-NEXT:    ret i32 0
;
; USE_ASSUME-LABEL: @gep_distance_test2(
; USE_ASSUME-NEXT:    [[A1:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[A:%.*]], i64 0, i32 0
; USE_ASSUME-NEXT:    [[B:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[A]], i64 [[DISTANCE:%.*]], i32 1
; USE_ASSUME-NEXT:    store i32 7, i32* [[B]], align 4
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[A1]], i64 4), "nonnull"({ i32, i32 }* [[A]]), "align"(i32* [[A1]], i64 4) ]
; USE_ASSUME-NEXT:    ret i32 0
;
  %A1 = getelementptr {i32,i32}, {i32,i32}* %A, i64 0, i32 0
  %REMOVEu = load i32, i32* %A1
  %B = getelementptr {i32,i32}, {i32,i32}* %A, i64 %distance, i32 1
  store i32 7, i32* %B    ; B cannot alias A, it's at least 4 bytes away
  %REMOVEv = load i32, i32* %A1
  %r = sub i32 %REMOVEu, %REMOVEv
  ret i32 %r
}

; Test that we can do funny pointer things and that distance calc will still
; work.
define i32 @gep_distance_test3(i32 * %A) {
; NO_ASSUME-LABEL: @gep_distance_test3(
; NO_ASSUME-NEXT:    [[C1:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 1
; NO_ASSUME-NEXT:    [[C:%.*]] = bitcast i32* [[C1]] to i8*
; NO_ASSUME-NEXT:    store i8 42, i8* [[C]], align 1
; NO_ASSUME-NEXT:    ret i32 0
;
; USE_ASSUME-LABEL: @gep_distance_test3(
; USE_ASSUME-NEXT:    [[C1:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 1
; USE_ASSUME-NEXT:    [[C:%.*]] = bitcast i32* [[C1]] to i8*
; USE_ASSUME-NEXT:    store i8 42, i8* [[C]], align 4
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[A]], i64 4), "nonnull"(i32* [[A]]), "align"(i32* [[A]], i64 4) ]
; USE_ASSUME-NEXT:    ret i32 0
;
  %X = load i32, i32* %A
  %B = bitcast i32* %A to i8*
  %C = getelementptr i8, i8* %B, i64 4
  store i8 42, i8* %C
  %Y = load i32, i32* %A
  %R = sub i32 %X, %Y
  ret i32 %R
}

; Test that we can disambiguate globals reached through constantexpr geps
define i32 @constexpr_test() {
; CHECK-LABEL: @constexpr_test(
; CHECK-NEXT:    [[X:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @external(i32* nonnull [[X]])
; CHECK-NEXT:    store i32 5, i32* getelementptr inbounds ({ i32 }, { i32 }* @Global, i64 0, i32 0), align 4
; CHECK-NEXT:    ret i32 0
;
  %X = alloca i32
  call void @external(i32* %X)

  %Y = load i32, i32* %X
  store i32 5, i32* getelementptr ({ i32 }, { i32 }* @Global, i64 0, i32 0)
  %REMOVE = load i32, i32* %X
  %retval = sub i32 %Y, %REMOVE
  ret i32 %retval
}



; PR7589
; These two index expressions are different, this cannot be CSE'd.
define i16 @zext_sext_confusion(i16* %row2col, i5 %j) nounwind{
; CHECK-LABEL: @zext_sext_confusion(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUM5_CAST:%.*]] = zext i5 [[J:%.*]] to i64
; CHECK-NEXT:    [[P1:%.*]] = getelementptr i16, i16* [[ROW2COL:%.*]], i64 [[SUM5_CAST]]
; CHECK-NEXT:    [[ROW2COL_LOAD_1_2:%.*]] = load i16, i16* [[P1]], align 1
; CHECK-NEXT:    [[SUM13_CAST31:%.*]] = sext i5 [[J]] to i6
; CHECK-NEXT:    [[SUM13_CAST:%.*]] = zext i6 [[SUM13_CAST31]] to i64
; CHECK-NEXT:    [[P2:%.*]] = getelementptr i16, i16* [[ROW2COL]], i64 [[SUM13_CAST]]
; CHECK-NEXT:    [[ROW2COL_LOAD_1_6:%.*]] = load i16, i16* [[P2]], align 1
; CHECK-NEXT:    [[DOTRET:%.*]] = sub i16 [[ROW2COL_LOAD_1_6]], [[ROW2COL_LOAD_1_2]]
; CHECK-NEXT:    ret i16 [[DOTRET]]
;
entry:
  %sum5.cast = zext i5 %j to i64             ; <i64> [#uses=1]
  %P1 = getelementptr i16, i16* %row2col, i64 %sum5.cast
  %row2col.load.1.2 = load i16, i16* %P1, align 1 ; <i16> [#uses=1]

  %sum13.cast31 = sext i5 %j to i6          ; <i6> [#uses=1]
  %sum13.cast = zext i6 %sum13.cast31 to i64      ; <i64> [#uses=1]
  %P2 = getelementptr i16, i16* %row2col, i64 %sum13.cast
  %row2col.load.1.6 = load i16, i16* %P2, align 1 ; <i16> [#uses=1]

  %.ret = sub i16 %row2col.load.1.6, %row2col.load.1.2 ; <i16> [#uses=1]
  ret i16 %.ret
}
