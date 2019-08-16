; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; Given pattern:
;   icmp eq/ne (and ((x shift Q), (y oppositeshift K))), 0
; we should move shifts to the same hand of 'and', i.e. e.g. rewrite as
;   icmp eq/ne (and (((x shift Q) shift K), y)), 0
; We are only interested in opposite logical shifts here.
; We still can handle the case where there is a truncation between a shift
; and an 'and', but for now only if it's 'shl' - simpler legality check.

;-------------------------------------------------------------------------------
; Basic scalar tests
;-------------------------------------------------------------------------------

define i1 @t0_const_after_fold_lshr_shl_ne(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t0_const_after_fold_lshr_shl_ne(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[TMP2]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[TMP3]], 0
; CHECK-NEXT:    ret i1 [[TMP4]]
;
  %t0 = sub i32 32, %len
  %t1 = lshr i32 %x, %t0
  %t2 = add i32 %len, -1
  %t2_wide = zext i32 %t2 to i64
  %t3 = shl i64 %y, %t2_wide
  %t3_trunc = trunc i64 %t3 to i32
  %t4 = and i32 %t1, %t3_trunc
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

;-------------------------------------------------------------------------------
; Very basic vector tests
;-------------------------------------------------------------------------------

define <2 x i1> @t1_vec_splat(<2 x i32> %x, <2 x i64> %y, <2 x i32> %len) {
; CHECK-LABEL: @t1_vec_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 31, i32 31>
; CHECK-NEXT:    [[TMP2:%.*]] = zext <2 x i32> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i64> [[TMP2]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <2 x i64> [[TMP3]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[TMP4]]
;
  %t0 = sub <2 x i32> <i32 32, i32 32>, %len
  %t1 = lshr <2 x i32> %x, %t0
  %t2 = add <2 x i32> %len, <i32 -1, i32 -1>
  %t2_wide = zext <2 x i32> %t2 to <2 x i64>
  %t3 = shl <2 x i64> %y, %t2_wide
  %t3_trunc = trunc <2 x i64> %t3 to <2 x i32>
  %t4 = and <2 x i32> %t1, %t3_trunc
  %t5 = icmp ne <2 x i32> %t4, <i32 0, i32 0>
  ret <2 x i1> %t5
}

define <2 x i1> @t2_vec_nonsplat(<2 x i32> %x, <2 x i64> %y, <2 x i32> %len) {
; CHECK-LABEL: @t2_vec_nonsplat(
; CHECK-NEXT:    [[TMP1:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP2:%.*]] = lshr <2 x i64> [[TMP1]], <i64 31, i64 30>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i64> [[TMP2]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <2 x i64> [[TMP3]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[TMP4]]
;
  %t0 = sub <2 x i32> <i32 30, i32 32>, %len
  %t1 = lshr <2 x i32> %x, %t0
  %t2 = add <2 x i32> %len, <i32 1, i32 -2>
  %t2_wide = zext <2 x i32> %t2 to <2 x i64>
  %t3 = shl <2 x i64> %y, %t2_wide
  %t3_trunc = trunc <2 x i64> %t3 to <2 x i32>
  %t4 = and <2 x i32> %t1, %t3_trunc
  %t5 = icmp ne <2 x i32> %t4, <i32 0, i32 0>
  ret <2 x i1> %t5
}

;-------------------------------------------------------------------------------
; Commutativity tests
;-------------------------------------------------------------------------------

declare i32 @gen32()
declare i64 @gen64()

; While 'and' is commutative, the 'trunc' *always* seems to be getting
; canonicalized to the RHS, it does not seem possible to prevent that.

;-------------------------------------------------------------------------------
; One-use tests
;-------------------------------------------------------------------------------

declare void @use32(i32)
declare void @use64(i64)

; Nope, everything has extra uses.
define i1 @t3_oneuse0(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t3_oneuse0(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], -1
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    call void @use64(i64 [[T2_WIDE]])
; CHECK-NEXT:    [[T3:%.*]] = shl i64 [[Y:%.*]], [[T2_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[T3_TRUNC:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T3_TRUNC]])
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T1]], [[T3_TRUNC]]
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = icmp ne i32 [[T4]], 0
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t0 = sub i32 32, %len
  call void @use32(i32 %t0)
  %t1 = lshr i32 %x, %t0
  call void @use32(i32 %t1)
  %t2 = add i32 %len, -1
  call void @use32(i32 %t2)
  %t2_wide = zext i32 %t2 to i64
  call void @use64(i64 %t2_wide)
  %t3 = shl i64 %y, %t2_wide
  call void @use64(i64 %t3)
  %t3_trunc = trunc i64 %t3 to i32
  call void @use32(i32 %t3_trunc)
  %t4 = and i32 %t1, %t3_trunc
  call void @use32(i32 %t4)
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

; Nope, still too much extra uses.
define i1 @t4_oneuse1(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t4_oneuse1(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], -1
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    call void @use64(i64 [[T2_WIDE]])
; CHECK-NEXT:    [[T3:%.*]] = shl i64 [[Y:%.*]], [[T2_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[T3_TRUNC:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T3_TRUNC]])
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T1]], [[T3_TRUNC]]
; CHECK-NEXT:    [[T5:%.*]] = icmp ne i32 [[T4]], 0
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t0 = sub i32 32, %len
  call void @use32(i32 %t0)
  %t1 = lshr i32 %x, %t0
  call void @use32(i32 %t1)
  %t2 = add i32 %len, -1
  call void @use32(i32 %t2)
  %t2_wide = zext i32 %t2 to i64
  call void @use64(i64 %t2_wide)
  %t3 = shl i64 %y, %t2_wide
  call void @use64(i64 %t3)
  %t3_trunc = trunc i64 %t3 to i32
  call void @use32(i32 %t3_trunc)
  %t4 = and i32 %t1, %t3_trunc ; no extra uses
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

; Still too much extra uses.
define i1 @t5_oneuse2(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t5_oneuse2(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], -1
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    call void @use64(i64 [[T2_WIDE]])
; CHECK-NEXT:    [[T3:%.*]] = shl i64 [[Y:%.*]], [[T2_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[T3_TRUNC:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T3_TRUNC]])
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T1]], [[T3_TRUNC]]
; CHECK-NEXT:    [[T5:%.*]] = icmp ne i32 [[T4]], 0
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t0 = sub i32 32, %len
  call void @use32(i32 %t0)
  %t1 = lshr i32 %x, %t0 ; no extra uses
  %t2 = add i32 %len, -1
  call void @use32(i32 %t2)
  %t2_wide = zext i32 %t2 to i64
  call void @use64(i64 %t2_wide)
  %t3 = shl i64 %y, %t2_wide
  call void @use64(i64 %t3)
  %t3_trunc = trunc i64 %t3 to i32
  call void @use32(i32 %t3_trunc)
  %t4 = and i32 %t1, %t3_trunc ; no extra uses
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

; Ok, trunc has no extra uses.
define i1 @t6_oneuse3(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t6_oneuse3(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], -1
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    call void @use64(i64 [[T2_WIDE]])
; CHECK-NEXT:    [[T3:%.*]] = shl i64 [[Y:%.*]], [[T2_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[TMP2]], [[Y]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[TMP3]], 0
; CHECK-NEXT:    ret i1 [[TMP4]]
;
  %t0 = sub i32 32, %len
  call void @use32(i32 %t0)
  %t1 = lshr i32 %x, %t0 ; no extra uses
  %t2 = add i32 %len, -1
  call void @use32(i32 %t2)
  %t2_wide = zext i32 %t2 to i64
  call void @use64(i64 %t2_wide)
  %t3 = shl i64 %y, %t2_wide
  call void @use64(i64 %t3)
  %t3_trunc = trunc i64 %t3 to i32 ; no extra uses
  %t4 = and i32 %t1, %t3_trunc ; no extra uses
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

; Ok, shift amount of non-truncated shift has no extra uses;
define i1 @t7_oneuse4(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t7_oneuse4(
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN:%.*]], -1
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    call void @use64(i64 [[T2_WIDE]])
; CHECK-NEXT:    [[T3:%.*]] = shl i64 [[Y:%.*]], [[T2_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[T3_TRUNC:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T3_TRUNC]])
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 31
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[TMP2]], [[Y]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[TMP3]], 0
; CHECK-NEXT:    ret i1 [[TMP4]]
;
  %t0 = sub i32 32, %len ; no extra uses
  %t1 = lshr i32 %x, %t0 ; no extra uses
  %t2 = add i32 %len, -1
  call void @use32(i32 %t2)
  %t2_wide = zext i32 %t2 to i64
  call void @use64(i64 %t2_wide)
  %t3 = shl i64 %y, %t2_wide
  call void @use64(i64 %t3)
  %t3_trunc = trunc i64 %t3 to i32
  call void @use32(i32 %t3_trunc)
  %t4 = and i32 %t1, %t3_trunc ; no extra uses
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

; Ok, non-truncated shift is of constant;
define i1 @t8_oneuse5(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t8_oneuse5(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 -52543054, [[T0]]
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], -1
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    call void @use64(i64 [[T2_WIDE]])
; CHECK-NEXT:    [[T3:%.*]] = shl i64 [[Y:%.*]], [[T2_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[T3_TRUNC:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T3_TRUNC]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[Y]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i64 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %t0 = sub i32 32, %len
  call void @use32(i32 %t0)
  %t1 = lshr i32 4242424242, %t0 ; shift-of-constant
  call void @use32(i32 %t1)
  %t2 = add i32 %len, -1
  call void @use32(i32 %t2)
  %t2_wide = zext i32 %t2 to i64
  call void @use64(i64 %t2_wide)
  %t3 = shl i64 %y, %t2_wide
  call void @use64(i64 %t3)
  %t3_trunc = trunc i64 %t3 to i32
  call void @use32(i32 %t3_trunc)
  %t4 = and i32 %t1, %t3_trunc ; no extra uses
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

; Ok, truncated shift is of constant;
define i1 @t9_oneuse5(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @t9_oneuse5(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], -1
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    call void @use64(i64 [[T2_WIDE]])
; CHECK-NEXT:    [[T3:%.*]] = shl i64 4242424242, [[T2_WIDE]]
; CHECK-NEXT:    call void @use64(i64 [[T3]])
; CHECK-NEXT:    [[T3_TRUNC:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T3_TRUNC]])
; CHECK-NEXT:    ret i1 false
;
  %t0 = sub i32 32, %len
  call void @use32(i32 %t0)
  %t1 = lshr i32 %x, %t0 ; shift-of-constant
  call void @use32(i32 %t1)
  %t2 = add i32 %len, -1
  call void @use32(i32 %t2)
  %t2_wide = zext i32 %t2 to i64
  call void @use64(i64 %t2_wide)
  %t3 = shl i64 4242424242, %t2_wide
  call void @use64(i64 %t3)
  %t3_trunc = trunc i64 %t3 to i32
  call void @use32(i32 %t3_trunc)
  %t4 = and i32 %t1, %t3_trunc ; no extra uses
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

;-------------------------------------------------------------------------------
; Commutativity with extra uses
;-------------------------------------------------------------------------------

; While 'and' is commutative, the 'trunc' *always* seems to be getting
; canonicalized to the RHS, it does not seem possible to prevent that.

;

; Constant shift amounts

define i1 @t10_constants(i32 %x, i64 %y) {
; CHECK-LABEL: @t10_constants(
; CHECK-NEXT:    [[Y_TR:%.*]] = trunc i64 [[Y:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 26
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], [[Y_TR]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[TMP3]]
;
  %t0 = lshr i32 %x, 12
  %t1 = shl i64 %y, 14
  %t1_trunc = trunc i64 %t1 to i32
  %t2 = and i32 %t0, %t1_trunc
  %t3 = icmp ne i32 %t2, 0
  ret i1 %t3
}

define <2 x i1> @t11_constants_vec_splat(<2 x i32> %x, <2 x i64> %y) {
; CHECK-LABEL: @t11_constants_vec_splat(
; CHECK-NEXT:    [[T0:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 12, i32 12>
; CHECK-NEXT:    [[T1:%.*]] = shl <2 x i64> [[Y:%.*]], <i64 14, i64 14>
; CHECK-NEXT:    [[T1_TRUNC:%.*]] = trunc <2 x i64> [[T1]] to <2 x i32>
; CHECK-NEXT:    [[T2:%.*]] = and <2 x i32> [[T0]], [[T1_TRUNC]]
; CHECK-NEXT:    [[T3:%.*]] = icmp ne <2 x i32> [[T2]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[T3]]
;
  %t0 = lshr <2 x i32> %x, <i32 12, i32 12>
  %t1 = shl <2 x i64> %y, <i64 14, i64 14>
  %t1_trunc = trunc <2 x i64> %t1 to <2 x i32>
  %t2 = and <2 x i32> %t0, %t1_trunc
  %t3 = icmp ne <2 x i32> %t2, <i32 0, i32 0>
  ret <2 x i1> %t3
}
define <2 x i1> @t12_constants_vec_nonsplat(<2 x i32> %x, <2 x i64> %y) {
; CHECK-LABEL: @t12_constants_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 12, i32 14>
; CHECK-NEXT:    [[T1:%.*]] = shl <2 x i64> [[Y:%.*]], <i64 16, i64 14>
; CHECK-NEXT:    [[T1_TRUNC:%.*]] = trunc <2 x i64> [[T1]] to <2 x i32>
; CHECK-NEXT:    [[T2:%.*]] = and <2 x i32> [[T0]], [[T1_TRUNC]]
; CHECK-NEXT:    [[T3:%.*]] = icmp ne <2 x i32> [[T2]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[T3]]
;
  %t0 = lshr <2 x i32> %x, <i32 12, i32 14>
  %t1 = shl <2 x i64> %y, <i64 16, i64 14>
  %t1_trunc = trunc <2 x i64> %t1 to <2 x i32>
  %t2 = and <2 x i32> %t0, %t1_trunc
  %t3 = icmp ne <2 x i32> %t2, <i32 0, i32 0>
  ret <2 x i1> %t3
}

;-------------------------------------------------------------------------------
; Negative tests
;-------------------------------------------------------------------------------

define i1 @n13_overshift(i32 %x, i64 %y, i32 %len) {
; CHECK-LABEL: @n13_overshift(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], 32
; CHECK-NEXT:    [[T2_WIDE:%.*]] = zext i32 [[T2]] to i64
; CHECK-NEXT:    [[T3:%.*]] = shl i64 [[Y:%.*]], [[T2_WIDE]]
; CHECK-NEXT:    [[T3_TRUNC:%.*]] = trunc i64 [[T3]] to i32
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T1]], [[T3_TRUNC]]
; CHECK-NEXT:    [[T5:%.*]] = icmp ne i32 [[T4]], 0
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t0 = sub i32 32, %len
  %t1 = lshr i32 %x, %t0
  %t2 = add i32 %len, 32 ; too much
  %t2_wide = zext i32 %t2 to i64
  %t3 = shl i64 %y, %t2_wide
  %t3_trunc = trunc i64 %t3 to i32
  %t4 = and i32 %t1, %t3_trunc
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

define i1 @n14_trunc_of_lshr(i64 %x, i32 %y, i32 %len) {
; CHECK-LABEL: @n14_trunc_of_lshr(
; CHECK-NEXT:    [[T0:%.*]] = sub i32 32, [[LEN:%.*]]
; CHECK-NEXT:    [[T0_WIDE:%.*]] = zext i32 [[T0]] to i64
; CHECK-NEXT:    [[T1:%.*]] = lshr i64 [[X:%.*]], [[T0_WIDE]]
; CHECK-NEXT:    [[T1_TRUNC:%.*]] = trunc i64 [[T1]] to i32
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[LEN]], -1
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[Y:%.*]], [[T2]]
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T3]], [[T1_TRUNC]]
; CHECK-NEXT:    [[T5:%.*]] = icmp ne i32 [[T4]], 0
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t0 = sub i32 32, %len
  %t0_wide = zext i32 %t0 to i64
  %t1 = lshr i64 %x, %t0_wide
  %t1_trunc = trunc i64 %t1 to i32
  %t2 = add i32 %len, -1
  %t3 = shl i32 %y, %t2
  %t4 = and i32 %t1_trunc, %t3
  %t5 = icmp ne i32 %t4, 0
  ret i1 %t5
}

; Completely variable shift amounts

define i1 @n15_variable_shamts(i32 %x, i64 %y, i32 %shamt0, i64 %shamt1) {
; CHECK-LABEL: @n15_variable_shamts(
; CHECK-NEXT:    [[T0:%.*]] = lshr i32 [[X:%.*]], [[SHAMT0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = shl i64 [[Y:%.*]], [[SHAMT1:%.*]]
; CHECK-NEXT:    [[T1_TRUNC:%.*]] = trunc i64 [[T1]] to i32
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T0]], [[T1_TRUNC]]
; CHECK-NEXT:    [[T3:%.*]] = icmp ne i32 [[T2]], 0
; CHECK-NEXT:    ret i1 [[T3]]
;
  %t0 = lshr i32 %x, %shamt0
  %t1 = shl i64 %y, %shamt1
  %t1_trunc = trunc i64 %t1 to i32
  %t2 = and i32 %t1_trunc, %t0
  %t3 = icmp ne i32 %t2, 0
  ret i1 %t3
}
