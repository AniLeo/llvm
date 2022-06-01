; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=riscv64-unknown-elf -passes='separate-const-offset-from-gep,early-cse' \
; RUN:       -S | FileCheck %s

; Several tests for -separate-const-offset-from-gep. The transformation
; heavily relies on TargetTransformInfo, so we put these tests under
; target-specific folders.

; Simple case when GEPs should be optimized.
define i64 @test1(i64* %array, i64 %i, i64 %j)  {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr i64, i64* [[ARRAY:%.*]], i64 [[I]]
; CHECK-NEXT:    [[GEP4:%.*]] = getelementptr inbounds i64, i64* [[TMP0]], i64 5
; CHECK-NEXT:    store i64 [[J:%.*]], i64* [[GEP4]], align 4
; CHECK-NEXT:    [[GEP26:%.*]] = getelementptr inbounds i64, i64* [[TMP0]], i64 6
; CHECK-NEXT:    store i64 [[J]], i64* [[GEP26]], align 4
; CHECK-NEXT:    [[GEP38:%.*]] = getelementptr inbounds i64, i64* [[TMP0]], i64 35
; CHECK-NEXT:    store i64 [[ADD]], i64* [[GEP38]], align 4
; CHECK-NEXT:    ret i64 undef
;
entry:
  %add = add nsw i64 %i, 5
  %gep = getelementptr inbounds i64, i64* %array, i64 %add
  store i64 %j, i64* %gep
  %add2 = add nsw i64 %i, 6
  %gep2 = getelementptr inbounds i64, i64* %array, i64 %add2
  store i64 %j, i64* %gep2
  %add3 = add nsw i64 %i, 35
  %gep3 = getelementptr inbounds i64, i64* %array, i64 %add3
  store i64 %add, i64* %gep3
  ret i64 undef
}

; Optimize GEPs when there sext instructions are needed to cast index value to expected type.
define i32 @test2(i32* %array, i32 %i, i32 %j) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i32, i32* [[ARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 5
; CHECK-NEXT:    store i32 [[J:%.*]], i32* [[GEP2]], align 4
; CHECK-NEXT:    [[GEP54:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 6
; CHECK-NEXT:    store i32 [[J]], i32* [[GEP54]], align 4
; CHECK-NEXT:    [[GEP86:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 35
; CHECK-NEXT:    store i32 [[ADD]], i32* [[GEP86]], align 4
; CHECK-NEXT:    ret i32 undef
;
entry:
  %add = add nsw i32 %i, 5
  %sext = sext i32 %add to i64
  %gep = getelementptr inbounds i32, i32* %array, i64 %sext
  store i32 %j, i32* %gep
  %add3 = add nsw i32 %i, 6
  %sext4 = sext i32 %add3 to i64
  %gep5 = getelementptr inbounds i32, i32* %array, i64 %sext4
  store i32 %j, i32* %gep5
  %add6 = add nsw i32 %i, 35
  %sext7 = sext i32 %add6 to i64
  %gep8 = getelementptr inbounds i32, i32* %array, i64 %sext7
  store i32 %add, i32* %gep8
  ret i32 undef
}

; No need to modify because all values are also used in other expressions.
; Modification doesn't decrease register pressure.
define i32 @test3(i32* %array, i32 %i) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i32, i32* [[ARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 5
; CHECK-NEXT:    store i32 [[ADD]], i32* [[GEP2]], align 4
; CHECK-NEXT:    [[ADD3:%.*]] = add nsw i32 [[I]], 6
; CHECK-NEXT:    [[GEP54:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 6
; CHECK-NEXT:    store i32 [[ADD3]], i32* [[GEP54]], align 4
; CHECK-NEXT:    [[ADD6:%.*]] = add nsw i32 [[I]], 35
; CHECK-NEXT:    [[GEP86:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 35
; CHECK-NEXT:    store i32 [[ADD6]], i32* [[GEP86]], align 4
; CHECK-NEXT:    ret i32 undef
;
entry:
  %add = add nsw i32 %i, 5
  %sext = sext i32 %add to i64
  %gep = getelementptr inbounds i32, i32* %array, i64 %sext
  store i32 %add, i32* %gep
  %add3 = add nsw i32 %i, 6
  %sext4 = sext i32 %add3 to i64
  %gep5 = getelementptr inbounds i32, i32* %array, i64 %sext4
  store i32 %add3, i32* %gep5
  %add6 = add nsw i32 %i, 35
  %sext7 = sext i32 %add6 to i64
  %gep8 = getelementptr inbounds i32, i32* %array, i64 %sext7
  store i32 %add6, i32* %gep8
  ret i32 undef
}

; Optimized GEPs for multidimensional array with same base
define i32 @test4([50 x i32]* %array2, i32 %i) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [50 x i32], [50 x i32]* [[ARRAY2:%.*]], i64 [[TMP0]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP3:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 255
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP3]], align 4
; CHECK-NEXT:    [[GEP56:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 256
; CHECK-NEXT:    store i32 [[ADD]], i32* [[GEP56]], align 4
; CHECK-NEXT:    [[GEP89:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 285
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP89]], align 4
; CHECK-NEXT:    ret i32 undef
;
entry:
  %add = add nsw i32 %i, 5
  %sext = sext i32 %add to i64
  %gep = getelementptr inbounds [50 x i32], [50 x i32]* %array2, i64 %sext, i64 %sext
  store i32 %i, i32* %gep
  %add3 = add nsw i32 %i, 6
  %sext4 = sext i32 %add3 to i64
  %gep5 = getelementptr inbounds [50 x i32], [50 x i32]* %array2, i64 %sext, i64 %sext4
  store i32 %add, i32* %gep5
  %add6 = add nsw i32 %i, 35
  %sext7 = sext i32 %add6 to i64
  %gep8 = getelementptr inbounds [50 x i32], [50 x i32]* %array2, i64 %sext, i64 %sext7
  store i32 %i, i32* %gep8
  ret i32 undef
}

; Don't optimize GEPs for multidimensional array with same base because RISC-V doesn't support the addressing mode
define i32 @test5([50 x i32]* %array2, i32 %i, i64 %j) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [50 x i32], [50 x i32]* [[ARRAY2:%.*]], i64 [[TMP0]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP3:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 255
; CHECK-NEXT:    store i32 [[ADD]], i32* [[GEP3]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr [50 x i32], [50 x i32]* [[ARRAY2]], i64 [[TMP0]], i64 [[J:%.*]]
; CHECK-NEXT:    [[GEP55:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 300
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP55]], align 4
; CHECK-NEXT:    [[ADD6:%.*]] = add nsw i32 [[I]], 35
; CHECK-NEXT:    [[SEXT7:%.*]] = sext i32 [[ADD6]] to i64
; CHECK-NEXT:    [[GEP8:%.*]] = getelementptr inbounds [50 x i32], [50 x i32]* [[ARRAY2]], i64 [[SEXT7]], i64 [[J]]
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP8]], align 4
; CHECK-NEXT:    ret i32 undef
;
entry:
  %add = add nsw i32 %i, 5
  %sext = sext i32 %add to i64
  %gep = getelementptr inbounds [50 x i32], [50 x i32]* %array2, i64 %sext, i64 %sext
  store i32 %add, i32* %gep
  %add3 = add nsw i32 %i, 6
  %sext4 = sext i32 %add3 to i64
  %gep5 = getelementptr inbounds [50 x i32], [50 x i32]* %array2, i64 %sext4, i64 %j
  store i32 %i, i32* %gep5
  %add6 = add nsw i32 %i, 35
  %sext7 = sext i32 %add6 to i64
  %gep8 = getelementptr inbounds [50 x i32], [50 x i32]* %array2, i64 %sext7, i64 %j
  store i32 %i, i32* %gep8
  ret i32 undef
}

; No need to optimize GEPs, because there is critical amount with non-constant offsets.
define i64 @test6(i64* %array, i64 %i, i64 %j) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[I:%.*]], 5
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i64, i64* [[ARRAY:%.*]], i64 [[J:%.*]]
; CHECK-NEXT:    store i64 [[ADD]], i64* [[GEP]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr i64, i64* [[ARRAY]], i64 [[I]]
; CHECK-NEXT:    [[GEP52:%.*]] = getelementptr inbounds i64, i64* [[TMP0]], i64 6
; CHECK-NEXT:    store i64 [[I]], i64* [[GEP52]], align 4
; CHECK-NEXT:    store i64 [[I]], i64* [[TMP0]], align 4
; CHECK-NEXT:    ret i64 undef
;
entry:
  %add = add nsw i64 %i, 5
  %gep = getelementptr inbounds i64, i64* %array, i64 %j
  store i64 %add, i64* %gep
  %add3 = add nsw i64 %i, 6
  %gep5 = getelementptr inbounds i64, i64* %array, i64 %add3
  store i64 %i, i64* %gep5
  %add6 = add nsw i64 %i, 35
  %gep8 = getelementptr inbounds i64, i64* %array, i64 %i
  store i64 %i, i64* %gep8
  ret i64 undef
}

; No need to optimize GEPs, because the base variable is different.
define i32 @test7(i32* %array, i32 %i, i32 %j, i32 %k) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i32, i32* [[ARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 5
; CHECK-NEXT:    store i32 [[ADD]], i32* [[GEP2]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = sext i32 [[K:%.*]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i32, i32* [[ARRAY]], i64 [[TMP2]]
; CHECK-NEXT:    [[GEP54:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i64 6
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP54]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = sext i32 [[J:%.*]] to i64
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i32, i32* [[ARRAY]], i64 [[TMP4]]
; CHECK-NEXT:    [[GEP86:%.*]] = getelementptr inbounds i32, i32* [[TMP5]], i64 35
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP86]], align 4
; CHECK-NEXT:    ret i32 undef
;
entry:
  %add = add nsw i32 %i, 5
  %sext = sext i32 %add to i64
  %gep = getelementptr inbounds i32, i32* %array, i64 %sext
  store i32 %add, i32* %gep
  %add3 = add nsw i32 %k, 6
  %sext4 = sext i32 %add3 to i64
  %gep5 = getelementptr inbounds i32, i32* %array, i64 %sext4
  store i32 %i, i32* %gep5
  %add6 = add nsw i32 %j, 35
  %sext7 = sext i32 %add6 to i64
  %gep8 = getelementptr inbounds i32, i32* %array, i64 %sext7
  store i32 %i, i32* %gep8
  ret i32 undef
}

; No need to optimize GEPs, because the base of GEP instructions is different.
define i32 @test8(i32* %array, i32* %array2, i32* %array3, i32 %i) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i32, i32* [[ARRAY:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 5
; CHECK-NEXT:    store i32 [[ADD]], i32* [[GEP2]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i32, i32* [[ARRAY2:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP54:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 6
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP54]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i32, i32* [[ARRAY3:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP86:%.*]] = getelementptr inbounds i32, i32* [[TMP3]], i64 35
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP86]], align 4
; CHECK-NEXT:    ret i32 undef
;
entry:
  %add = add nsw i32 %i, 5
  %sext = sext i32 %add to i64
  %gep = getelementptr inbounds i32, i32* %array, i64 %sext
  store i32 %add, i32* %gep
  %add3 = add nsw i32 %i, 6
  %sext4 = sext i32 %add3 to i64
  %gep5 = getelementptr inbounds i32, i32* %array2, i64 %sext4
  store i32 %i, i32* %gep5
  %add6 = add nsw i32 %i, 35
  %sext7 = sext i32 %add6 to i64
  %gep8 = getelementptr inbounds i32, i32* %array3, i64 %sext7
  store i32 %i, i32* %gep8
  ret i32 undef
}

; No need to optimize GEPs of multidimensional array, because the base of GEP instructions is different.
define i32 @test9([50 x i32]* %array, i32 %i) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[I:%.*]], 5
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [50 x i32], [50 x i32]* [[ARRAY:%.*]], i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds i32, i32* [[TMP1]], i64 5
; CHECK-NEXT:    store i32 [[ADD]], i32* [[GEP2]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr [50 x i32], [50 x i32]* [[ARRAY]], i64 [[TMP0]], i64 [[TMP0]]
; CHECK-NEXT:    [[GEP54:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 6
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP54]], align 4
; CHECK-NEXT:    [[GEP87:%.*]] = getelementptr inbounds i32, i32* [[TMP2]], i64 335
; CHECK-NEXT:    store i32 [[I]], i32* [[GEP87]], align 4
; CHECK-NEXT:    ret i32 undef
;
entry:
  %add = add nsw i32 %i, 5
  %sext = sext i32 %add to i64
  %gep = getelementptr inbounds [50 x i32], [50 x i32]* %array, i64 0, i64 %sext
  store i32 %add, i32* %gep
  %add3 = add nsw i32 %i, 6
  %sext4 = sext i32 %add3 to i64
  %int = sext i32 %i to i64
  %gep5 = getelementptr inbounds [50 x i32], [50 x i32]* %array, i64 %int, i64 %sext4
  store i32 %i, i32* %gep5
  %add6 = add nsw i32 %i, 35
  %sext7 = sext i32 %add6 to i64
  %gep8 = getelementptr inbounds [50 x i32], [50 x i32]* %array, i64 %sext4, i64 %sext7
  store i32 %i, i32* %gep8
  ret i32 undef
}
