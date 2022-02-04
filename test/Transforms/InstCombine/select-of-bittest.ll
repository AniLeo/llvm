; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=36950

; These all should be just and+icmp, there should be no select.

define i32 @and_lshr_and(i32 %arg) {
; CHECK-LABEL: @and_lshr_and(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[ARG:%.*]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP1]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, 1
  %tmp1 = icmp eq i32 %tmp, 0
  %tmp2 = lshr i32 %arg, 1
  %tmp3 = and i32 %tmp2, 1
  %tmp4 = select i1 %tmp1, i32 %tmp3, i32 1
  ret i32 %tmp4
}

define <2 x i32> @and_lshr_and_splatvec(<2 x i32> %arg) {
; CHECK-LABEL: @and_lshr_and_splatvec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[ARG:%.*]], <i32 3, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <2 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = zext <2 x i1> [[TMP2]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %tmp = and <2 x i32> %arg, <i32 1, i32 1>
  %tmp1 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp2 = lshr <2 x i32> %arg, <i32 1, i32 1>
  %tmp3 = and <2 x i32> %tmp2, <i32 1, i32 1>
  %tmp4 = select <2 x i1> %tmp1, <2 x i32> %tmp3, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp4
}

define <2 x i32> @and_lshr_and_vec_v0(<2 x i32> %arg) {
; CHECK-LABEL: @and_lshr_and_vec_v0(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[ARG:%.*]], <i32 3, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <2 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = zext <2 x i1> [[TMP2]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %tmp = and <2 x i32> %arg, <i32 1, i32 4> ; mask is not splat
  %tmp1 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp2 = lshr <2 x i32> %arg, <i32 1, i32 1>
  %tmp3 = and <2 x i32> %tmp2, <i32 1, i32 1>
  %tmp4 = select <2 x i1> %tmp1, <2 x i32> %tmp3, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp4
}

define <2 x i32> @and_lshr_and_vec_v1(<2 x i32> %arg) {
; CHECK-LABEL: @and_lshr_and_vec_v1(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[ARG:%.*]], <i32 3, i32 5>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <2 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = zext <2 x i1> [[TMP2]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %tmp = and <2 x i32> %arg, <i32 1, i32 1>
  %tmp1 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp2 = lshr <2 x i32> %arg, <i32 1, i32 2> ; shift is not splat
  %tmp3 = and <2 x i32> %tmp2, <i32 1, i32 1>
  %tmp4 = select <2 x i1> %tmp1, <2 x i32> %tmp3, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp4
}

define <2 x i32> @and_lshr_and_vec_v2(<2 x i32> %arg) {
; CHECK-LABEL: @and_lshr_and_vec_v2(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[ARG:%.*]], <i32 12, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <2 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = zext <2 x i1> [[TMP2]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %tmp = and <2 x i32> %arg, <i32 8, i32 1> ; mask is not splat
  %tmp1 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp2 = lshr <2 x i32> %arg, <i32 2, i32 1> ; shift is not splat
  %tmp3 = and <2 x i32> %tmp2, <i32 1, i32 1>
  %tmp4 = select <2 x i1> %tmp1, <2 x i32> %tmp3, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp4
}

define <3 x i32> @and_lshr_and_vec_undef(<3 x i32> %arg) {
; CHECK-LABEL: @and_lshr_and_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = and <3 x i32> [[ARG:%.*]], <i32 3, i32 poison, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <3 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = zext <3 x i1> [[TMP2]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[TMP4]]
;
  %tmp = and <3 x i32> %arg, <i32 1, i32 undef, i32 1>
  %tmp1 = icmp eq <3 x i32> %tmp, <i32 0, i32 undef, i32 0>
  %tmp2 = lshr <3 x i32> %arg, <i32 1, i32 undef, i32 1>
  %tmp3 = and <3 x i32> %tmp2, <i32 1, i32 undef, i32 1>
  ; The second element of %tmp4 is poison because it is (undef ? poison : undef).
  %tmp4 = select <3 x i1> %tmp1, <3 x i32> %tmp3, <3 x i32> <i32 1, i32 undef, i32 1>
  ret <3 x i32> %tmp4
}

define i32 @and_and(i32 %arg) {
; CHECK-LABEL: @and_and(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[ARG:%.*]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = and i32 %arg, 2
  %tmp1 = icmp eq i32 %tmp, 0
  %tmp2 = and i32 %arg, 1
  %tmp3 = select i1 %tmp1, i32 %tmp2, i32 1
  ret i32 %tmp3
}

define <2 x i32> @and_and_splatvec(<2 x i32> %arg) {
; CHECK-LABEL: @and_and_splatvec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[ARG:%.*]], <i32 3, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <2 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = zext <2 x i1> [[TMP2]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %tmp = and <2 x i32> %arg, <i32 2, i32 2>
  %tmp1 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp2 = and <2 x i32> %arg, <i32 1, i32 1>
  %tmp3 = select <2 x i1> %tmp1, <2 x i32> %tmp2, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp3
}

define <2 x i32> @and_and_vec(<2 x i32> %arg) {
; CHECK-LABEL: @and_and_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[ARG:%.*]], <i32 7, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <2 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = zext <2 x i1> [[TMP2]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %tmp = and <2 x i32> %arg, <i32 6, i32 2> ; mask is not splat
  %tmp1 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp2 = and <2 x i32> %arg, <i32 1, i32 1>
  %tmp3 = select <2 x i1> %tmp1, <2 x i32> %tmp2, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp3
}

define <3 x i32> @and_and_vec_undef(<3 x i32> %arg) {
; CHECK-LABEL: @and_and_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = and <3 x i32> [[ARG:%.*]], <i32 3, i32 -1, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne <3 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = zext <3 x i1> [[TMP2]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[TMP3]]
;
  %tmp = and <3 x i32> %arg, <i32 2, i32 undef, i32 2>
  %tmp1 = icmp eq <3 x i32> %tmp, <i32 0, i32 undef, i32 0>
  %tmp2 = and <3 x i32> %arg, <i32 1, i32 undef, i32 1>
  %tmp3 = select <3 x i1> %tmp1, <3 x i32> %tmp2, <3 x i32> <i32 1, i32 undef, i32 1>
  ret <3 x i32> %tmp3
}

; ============================================================================ ;
; Mask can be a variable, too.
; ============================================================================ ;

define i32 @f_var0(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @f_var0(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[ARG1:%.*]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = zext i1 [[TMP3]] to i32
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %tmp = and i32 %arg, %arg1
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = lshr i32 %arg, 1
  %tmp4 = and i32 %tmp3, 1
  %tmp5 = select i1 %tmp2, i32 %tmp4, i32 1
  ret i32 %tmp5
}

; Should be exactly as the previous one
define i32 @f_var0_commutative_and(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @f_var0_commutative_and(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[ARG1:%.*]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = zext i1 [[TMP3]] to i32
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %tmp = and i32 %arg1, %arg ; in different order
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = lshr i32 %arg, 1
  %tmp4 = and i32 %tmp3, 1
  %tmp5 = select i1 %tmp2, i32 %tmp4, i32 1
  ret i32 %tmp5
}

define <2 x i32> @f_var0_splatvec(<2 x i32> %arg, <2 x i32> %arg1) {
; CHECK-LABEL: @f_var0_splatvec(
; CHECK-NEXT:    [[TMP1:%.*]] = or <2 x i32> [[ARG1:%.*]], <i32 2, i32 2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne <2 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = zext <2 x i1> [[TMP3]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %tmp = and <2 x i32> %arg, %arg1
  %tmp2 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp3 = lshr <2 x i32> %arg, <i32 1, i32 1>
  %tmp4 = and <2 x i32> %tmp3, <i32 1, i32 1>
  %tmp5 = select <2 x i1> %tmp2, <2 x i32> %tmp4, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp5
}

define <2 x i32> @f_var0_vec(<2 x i32> %arg, <2 x i32> %arg1) {
; CHECK-LABEL: @f_var0_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = or <2 x i32> [[ARG1:%.*]], <i32 2, i32 4>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne <2 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = zext <2 x i1> [[TMP3]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %tmp = and <2 x i32> %arg, %arg1
  %tmp2 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp3 = lshr <2 x i32> %arg, <i32 1, i32 2> ; shift is not splat
  %tmp4 = and <2 x i32> %tmp3, <i32 1, i32 1>
  %tmp5 = select <2 x i1> %tmp2, <2 x i32> %tmp4, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp5
}

define <3 x i32> @f_var0_vec_undef(<3 x i32> %arg, <3 x i32> %arg1) {
; CHECK-LABEL: @f_var0_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = or <3 x i32> [[ARG1:%.*]], <i32 2, i32 poison, i32 2>
; CHECK-NEXT:    [[TMP2:%.*]] = and <3 x i32> [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne <3 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = zext <3 x i1> [[TMP3]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[TMP5]]
;
  %tmp = and <3 x i32> %arg, %arg1
  %tmp2 = icmp eq <3 x i32> %tmp, <i32 0, i32 undef, i32 0>
  %tmp3 = lshr <3 x i32> %arg, <i32 1, i32 undef, i32 1>
  %tmp4 = and <3 x i32> %tmp3, <i32 1, i32 undef, i32 1>
  ; The second element of %tmp5 is poison because it is (undef ? poison : undef).
  %tmp5 = select <3 x i1> %tmp2, <3 x i32> %tmp4, <3 x i32> <i32 1, i32 undef, i32 1>
  ret <3 x i32> %tmp5
}

define i32 @f_var1(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @f_var1(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[ARG1:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = zext i1 [[TMP3]] to i32
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, %arg1
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = and i32 %arg, 1
  %tmp4 = select i1 %tmp2, i32 %tmp3, i32 1
  ret i32 %tmp4
}

; Should be exactly as the previous one
define i32 @f_var1_commutative_and(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @f_var1_commutative_and(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[ARG1:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = zext i1 [[TMP3]] to i32
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg1, %arg ; in different order
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = and i32 %arg, 1
  %tmp4 = select i1 %tmp2, i32 %tmp3, i32 1
  ret i32 %tmp4
}

define <2 x i32> @f_var1_vec(<2 x i32> %arg, <2 x i32> %arg1) {
; CHECK-LABEL: @f_var1_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = or <2 x i32> [[ARG1:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne <2 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = zext <2 x i1> [[TMP3]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %tmp = and <2 x i32> %arg, %arg1
  %tmp2 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp3 = and <2 x i32> %arg, <i32 1, i32 1>
  %tmp4 = select <2 x i1> %tmp2, <2 x i32> %tmp3, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp4
}

define <3 x i32> @f_var1_vec_undef(<3 x i32> %arg, <3 x i32> %arg1) {
; CHECK-LABEL: @f_var1_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = or <3 x i32> [[ARG1:%.*]], <i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = and <3 x i32> [[TMP1]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne <3 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = zext <3 x i1> [[TMP3]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[TMP4]]
;
  %tmp = and <3 x i32> %arg, %arg1
  %tmp2 = icmp eq <3 x i32> %tmp, <i32 0, i32 undef, i32 0>
  %tmp3 = and <3 x i32> %arg, <i32 1, i32 undef, i32 1>
  %tmp4 = select <3 x i1> %tmp2, <3 x i32> %tmp3, <3 x i32> <i32 1, i32 undef, i32 1>
  ret <3 x i32> %tmp4
}

; ============================================================================ ;
; Shift can be a variable, too.
; ============================================================================ ;

define i32 @f_var2(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @f_var2(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 1, [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i32 [[TMP3]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = zext i1 [[TMP4]] to i32
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %tmp = and i32 %arg, 1
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = lshr i32 %arg, %arg1
  %tmp4 = and i32 %tmp3, 1
  %tmp5 = select i1 %tmp2, i32 %tmp4, i32 1
  ret i32 %tmp5
}

define <2 x i32> @f_var2_splatvec(<2 x i32> %arg, <2 x i32> %arg1) {
; CHECK-LABEL: @f_var2_splatvec(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i32> <i32 1, i32 1>, [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or <2 x i32> [[TMP1]], <i32 1, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i32> [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <2 x i32> [[TMP3]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = zext <2 x i1> [[TMP4]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %tmp = and <2 x i32> %arg, <i32 1, i32 1>
  %tmp2 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp3 = lshr <2 x i32> %arg, %arg1
  %tmp4 = and <2 x i32> %tmp3, <i32 1, i32 1>
  %tmp5 = select <2 x i1> %tmp2, <2 x i32> %tmp4, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp5
}

define <2 x i32> @f_var2_vec(<2 x i32> %arg, <2 x i32> %arg1) {
; CHECK-LABEL: @f_var2_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i32> <i32 1, i32 1>, [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or <2 x i32> [[TMP1]], <i32 2, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i32> [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <2 x i32> [[TMP3]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = zext <2 x i1> [[TMP4]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %tmp = and <2 x i32> %arg, <i32 2, i32 1>; mask is not splat
  %tmp2 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp3 = lshr <2 x i32> %arg, %arg1
  %tmp4 = and <2 x i32> %tmp3, <i32 1, i32 1>
  %tmp5 = select <2 x i1> %tmp2, <2 x i32> %tmp4, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp5
}

define <3 x i32> @f_var2_vec_undef(<3 x i32> %arg, <3 x i32> %arg1) {
; CHECK-LABEL: @f_var2_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <3 x i32> <i32 1, i32 1, i32 1>, [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or <3 x i32> [[TMP1]], <i32 1, i32 undef, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = and <3 x i32> [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <3 x i32> [[TMP3]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = zext <3 x i1> [[TMP4]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[TMP5]]
;
  %tmp = and <3 x i32> %arg, <i32 1, i32 undef, i32 1>
  %tmp2 = icmp eq <3 x i32> %tmp, <i32 0, i32 undef, i32 0>
  %tmp3 = lshr <3 x i32> %arg, %arg1
  %tmp4 = and <3 x i32> %tmp3, <i32 1, i32 undef, i32 1>
  %tmp5 = select <3 x i1> %tmp2, <3 x i32> %tmp4, <3 x i32> <i32 1, i32 undef, i32 1>
  ret <3 x i32> %tmp5
}

; ============================================================================ ;
; The worst case: both Mask and Shift are variables
; ============================================================================ ;

define i32 @f_var3(i32 %arg, i32 %arg1, i32 %arg2) {
; CHECK-LABEL: @f_var3(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 1, [[ARG2:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i32 [[TMP3]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = zext i1 [[TMP4]] to i32
; CHECK-NEXT:    ret i32 [[TMP6]]
;
  %tmp = and i32 %arg, %arg1
  %tmp3 = icmp eq i32 %tmp, 0
  %tmp4 = lshr i32 %arg, %arg2
  %tmp5 = and i32 %tmp4, 1
  %tmp6 = select i1 %tmp3, i32 %tmp5, i32 1
  ret i32 %tmp6
}

; Should be exactly as the previous one
define i32 @f_var3_commutative_and(i32 %arg, i32 %arg1, i32 %arg2) {
; CHECK-LABEL: @f_var3_commutative_and(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 1, [[ARG2:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i32 [[TMP3]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = zext i1 [[TMP4]] to i32
; CHECK-NEXT:    ret i32 [[TMP6]]
;
  %tmp = and i32 %arg1, %arg ; in different order
  %tmp3 = icmp eq i32 %tmp, 0
  %tmp4 = lshr i32 %arg, %arg2
  %tmp5 = and i32 %tmp4, 1
  %tmp6 = select i1 %tmp3, i32 %tmp5, i32 1
  ret i32 %tmp6
}

define <2 x i32> @f_var3_splatvec(<2 x i32> %arg, <2 x i32> %arg1, <2 x i32> %arg2) {
; CHECK-LABEL: @f_var3_splatvec(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i32> <i32 1, i32 1>, [[ARG2:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or <2 x i32> [[TMP1]], [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i32> [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <2 x i32> [[TMP3]], zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = zext <2 x i1> [[TMP4]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP6]]
;
  %tmp = and <2 x i32> %arg, %arg1
  %tmp3 = icmp eq <2 x i32> %tmp, zeroinitializer
  %tmp4 = lshr <2 x i32> %arg, %arg2
  %tmp5 = and <2 x i32> %tmp4, <i32 1, i32 1>
  %tmp6 = select <2 x i1> %tmp3, <2 x i32> %tmp5, <2 x i32> <i32 1, i32 1>
  ret <2 x i32> %tmp6
}

define <3 x i32> @f_var3_vec_undef(<3 x i32> %arg, <3 x i32> %arg1, <3 x i32> %arg2) {
; CHECK-LABEL: @f_var3_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <3 x i32> <i32 1, i32 1, i32 1>, [[ARG2:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = or <3 x i32> [[TMP1]], [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and <3 x i32> [[TMP2]], [[ARG:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <3 x i32> [[TMP3]], zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = zext <3 x i1> [[TMP4]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[TMP6]]
;
  %tmp = and <3 x i32> %arg, %arg1
  %tmp3 = icmp eq <3 x i32> %tmp, <i32 0, i32 undef, i32 0>
  %tmp4 = lshr <3 x i32> %arg, %arg2
  %tmp5 = and <3 x i32> %tmp4, <i32 1, i32 undef, i32 1>
  %tmp6 = select <3 x i1> %tmp3, <3 x i32> %tmp5, <3 x i32> <i32 1, i32 undef, i32 1>
  ret <3 x i32> %tmp6
}

; ============================================================================ ;
; Negative tests. Should not be folded.
; ============================================================================ ;

; One use only.

declare void @use32(i32)

declare void @use1(i1)

define i32 @n_var0_oneuse(i32 %arg, i32 %arg1, i32 %arg2) {
; CHECK-LABEL: @n_var0_oneuse(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = lshr i32 [[ARG]], [[ARG2:%.*]]
; CHECK-NEXT:    [[TMP5:%.*]] = and i32 [[TMP4]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = select i1 [[TMP3]], i32 [[TMP5]], i32 1
; CHECK-NEXT:    call void @use32(i32 [[TMP]])
; CHECK-NEXT:    call void @use1(i1 [[TMP3]])
; CHECK-NEXT:    call void @use32(i32 [[TMP4]])
; CHECK-NEXT:    call void @use32(i32 [[TMP5]])
; CHECK-NEXT:    ret i32 [[TMP6]]
;
  %tmp = and i32 %arg, %arg1
  %tmp3 = icmp eq i32 %tmp, 0
  %tmp4 = lshr i32 %arg, %arg2
  %tmp5 = and i32 %tmp4, 1
  %tmp6 = select i1 %tmp3, i32 %tmp5, i32 1
  call void @use32(i32 %tmp)
  call void @use1(i1 %tmp3)
  call void @use32(i32 %tmp4)
  call void @use32(i32 %tmp5)
  ret i32 %tmp6
}

define i32 @n_var1_oneuse(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @n_var1_oneuse(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], [[ARG1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[ARG]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP2]], i32 [[TMP3]], i32 1
; CHECK-NEXT:    call void @use32(i32 [[TMP]])
; CHECK-NEXT:    call void @use1(i1 [[TMP2]])
; CHECK-NEXT:    call void @use32(i32 [[TMP3]])
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, %arg1
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = and i32 %arg, 1
  %tmp4 = select i1 %tmp2, i32 %tmp3, i32 1
  call void @use32(i32 %tmp)
  call void @use1(i1 %tmp2)
  call void @use32(i32 %tmp3)
  ret i32 %tmp4
}

; Different variables are used

define i32 @n0(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @n0(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = lshr i32 [[ARG1:%.*]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = and i32 [[TMP3]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = select i1 [[TMP2]], i32 [[TMP4]], i32 1
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %tmp = and i32 %arg, 1
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = lshr i32 %arg1, 1 ; works on %arg1 instead of %arg
  %tmp4 = and i32 %tmp3, 1
  %tmp5 = select i1 %tmp2, i32 %tmp4, i32 1
  ret i32 %tmp5
}

define i32 @n1(i32 %arg, i32 %arg1) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[ARG1:%.*]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP2]], i32 [[TMP3]], i32 1
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, 2
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = and i32 %arg1, 1 ; works on %arg1 instead of %arg
  %tmp4 = select i1 %tmp2, i32 %tmp3, i32 1
  ret i32 %tmp4
}

; False-value is not 1

define i32 @n2(i32 %arg) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[ARG]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], i32 [[TMP3]], i32 0
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, 1
  %tmp1 = icmp eq i32 %tmp, 0
  %tmp2 = lshr i32 %arg, 2
  %tmp3 = and i32 %tmp2, 1
  %tmp4 = select i1 %tmp1, i32 %tmp3, i32 0 ; 0 instead of 1
  ret i32 %tmp4
}

define i32 @n3(i32 %arg) {
; CHECK-LABEL: @n3(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[ARG]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i32 [[TMP2]], i32 0
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = and i32 %arg, 2
  %tmp1 = icmp eq i32 %tmp, 0
  %tmp2 = and i32 %arg, 1
  %tmp3 = select i1 %tmp1, i32 %tmp2, i32 0 ; 0 instead of 1
  ret i32 %tmp3
}

; Mask of second and is not one

define i32 @n4(i32 %arg) {
; CHECK-LABEL: @n4(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[ARG]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], i32 [[TMP3]], i32 1
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, 1
  %tmp1 = icmp eq i32 %tmp, 0
  %tmp2 = lshr i32 %arg, 2
  %tmp3 = and i32 %tmp2, 2 ; 2 instead of 1
  %tmp4 = select i1 %tmp1, i32 %tmp3, i32 1
  ret i32 %tmp4
}

define i32 @n5(i32 %arg) {
; CHECK-LABEL: @n5(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[ARG]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i32 [[TMP2]], i32 1
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = and i32 %arg, 2
  %tmp1 = icmp eq i32 %tmp, 0
  %tmp2 = and i32 %arg, 2 ; 2 instead of 1
  %tmp3 = select i1 %tmp1, i32 %tmp2, i32 1
  ret i32 %tmp3
}

; Wrong icmp pred

define i32 @n6(i32 %arg) {
; CHECK-LABEL: @n6(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[ARG]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], i32 1, i32 [[TMP3]]
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, 1
  %tmp1 = icmp ne i32 %tmp, 0 ; ne, not eq
  %tmp2 = lshr i32 %arg, 2
  %tmp3 = and i32 %tmp2, 1
  %tmp4 = select i1 %tmp1, i32 %tmp3, i32 1
  ret i32 %tmp4
}

define i32 @n7(i32 %arg) {
; CHECK-LABEL: @n7(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[ARG]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i32 1, i32 [[TMP2]]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %tmp = and i32 %arg, 2
  %tmp1 = icmp ne i32 %tmp, 0 ; ne, not eq
  %tmp2 = and i32 %arg, 1
  %tmp3 = select i1 %tmp1, i32 %tmp2, i32 1
  ret i32 %tmp3
}

; icmp second operand is not zero

define i32 @n8(i32 %arg) {
; CHECK-LABEL: @n8(
; CHECK-NEXT:    [[TMP:%.*]] = and i32 [[ARG:%.*]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[ARG]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], i32 1, i32 [[TMP3]]
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %tmp = and i32 %arg, 1
  %tmp1 = icmp eq i32 %tmp, 1
  %tmp2 = lshr i32 %arg, 2
  %tmp3 = and i32 %tmp2, 1
  %tmp4 = select i1 %tmp1, i32 %tmp3, i32 1
  ret i32 %tmp4
}
