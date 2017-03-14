; RUN: opt < %s -instcombine -S | FileCheck %s

define i64 @rem_signed(i64 %x1, i64 %y2) {
; CHECK-LABEL: @rem_signed(
; CHECK-NEXT:    [[R:%.*]] = srem i64 %x1, %y2
; CHECK-NEXT:    ret i64 [[R]]
;
  %r = sdiv i64 %x1, %y2
  %r7 = mul i64 %r, %y2
  %r8 = sub i64 %x1, %r7
  ret i64 %r8
}

define <4 x i32> @rem_signed_vec(<4 x i32> %t, <4 x i32> %u) {
; CHECK-LABEL: @rem_signed_vec(
; CHECK-NEXT:    [[K:%.*]] = srem <4 x i32> %t, %u
; CHECK-NEXT:    ret <4 x i32> [[K]]
;
  %k = sdiv <4 x i32> %t, %u
  %l = mul <4 x i32> %k, %u
  %m = sub <4 x i32> %t, %l
  ret <4 x i32> %m
}

define i64 @rem_unsigned(i64 %x1, i64 %y2) {
; CHECK-LABEL: @rem_unsigned(
; CHECK-NEXT:    [[R:%.*]] = urem i64 %x1, %y2
; CHECK-NEXT:    ret i64 [[R]]
;
  %r = udiv i64 %x1, %y2
  %r7 = mul i64 %r, %y2
  %r8 = sub i64 %x1, %r7
  ret i64 %r8
}

; PR28672 - https://llvm.org/bugs/show_bug.cgi?id=28672

define i8 @big_divisor(i8 %x) {
; CHECK-LABEL: @big_divisor(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i8 %x, -127
; CHECK-NEXT:    [[TMP2:%.*]] = add i8 %x, 127
; CHECK-NEXT:    [[REM:%.*]] = select i1 [[TMP1]], i8 %x, i8 [[TMP2]]
; CHECK-NEXT:    ret i8 [[REM]]
;
  %rem = urem i8 %x, 129
  ret i8 %rem
}

define i5 @biggest_divisor(i5 %x) {
; CHECK-LABEL: @biggest_divisor(
; CHECK-NEXT:    [[NOT_:%.*]] = icmp eq i5 %x, -1
; CHECK-NEXT:    [[TMP1:%.*]] = zext i1 [[NOT_]] to i5
; CHECK-NEXT:    [[REM:%.*]] = add i5 [[TMP1]], %x
; CHECK-NEXT:    ret i5 [[REM]]
;
  %rem = urem i5 %x, -1
  ret i5 %rem
}

; TODO: Should vector subtract of constant be canonicalized to add?
define <2 x i4> @big_divisor_vec(<2 x i4> %x) {
; CHECK-LABEL: @big_divisor_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult <2 x i4> %x, <i4 -3, i4 -3>
; CHECK-NEXT:    [[TMP2:%.*]] = sub <2 x i4> %x, <i4 -3, i4 -3>
; CHECK-NEXT:    [[REM:%.*]] = select <2 x i1> [[TMP1]], <2 x i4> %x, <2 x i4> [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[REM]]
;
  %rem = urem <2 x i4> %x, <i4 13, i4 13>
  ret <2 x i4> %rem
}

define i8 @urem1(i8 %x, i8 %y) {
; CHECK-LABEL: @urem1(
; CHECK-NEXT:    [[A:%.*]] = urem i8 %x, %y
; CHECK-NEXT:    ret i8 [[A]]
;
  %A = udiv i8 %x, %y
  %B = mul i8 %A, %y
  %C = sub i8 %x, %B
  ret i8 %C
}

define i8 @srem1(i8 %x, i8 %y) {
; CHECK-LABEL: @srem1(
; CHECK-NEXT:    [[A:%.*]] = srem i8 %x, %y
; CHECK-NEXT:    ret i8 [[A]]
;
  %A = sdiv i8 %x, %y
  %B = mul i8 %A, %y
  %C = sub i8 %x, %B
  ret i8 %C
}

define i8 @urem2(i8 %x, i8 %y) {
; CHECK-LABEL: @urem2(
; CHECK-NEXT:    [[A:%.*]] = urem i8 %x, %y
; CHECK-NEXT:    [[C:%.*]] = sub i8 0, [[A]]
; CHECK-NEXT:    ret i8 [[C]]
;
  %A = udiv i8 %x, %y
  %B = mul i8 %A, %y
  %C = sub i8 %B, %x
  ret i8 %C
}

define i8 @urem3(i8 %x) {
; CHECK-LABEL: @urem3(
; CHECK-NEXT:    [[A:%.*]] = urem i8 %x, 3
; CHECK-NEXT:    [[B1:%.*]] = sub i8 %x, [[A]]
; CHECK-NEXT:    [[C:%.*]] = add i8 [[B1]], %x
; CHECK-NEXT:    ret i8 [[C]]
;
  %A = udiv i8 %x, 3
  %B = mul i8 %A, -3
  %C = sub i8 %x, %B
  ret i8 %C
}

; (((X / Y) * Y) / Y) -> X / Y

define i32 @sdiv_mul_sdiv(i32 %x, i32 %y) {
; CHECK-LABEL: @sdiv_mul_sdiv(
; CHECK-NEXT:    [[R:%.*]] = sdiv i32 %x, %y
; CHECK-NEXT:    ret i32 [[R]]
;
  %div = sdiv i32 %x, %y
  %mul = mul i32 %div, %y
  %r = sdiv i32 %mul, %y
  ret i32 %r
}

; (((X / Y) * Y) / Y) -> X / Y

define i32 @udiv_mul_udiv(i32 %x, i32 %y) {
; CHECK-LABEL: @udiv_mul_udiv(
; CHECK-NEXT:    [[R:%.*]] = udiv i32 %x, %y
; CHECK-NEXT:    ret i32 [[R]]
;
  %div = udiv i32 %x, %y
  %mul = mul i32 %div, %y
  %r = udiv i32 %mul, %y
  ret i32 %r
}

define i32 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 0
;
  %B = srem i32 %A, 1	; ISA constant 0
  ret i32 %B
}

define i32 @test2(i32 %A) {	; 0 % X = 0, we don't need to preserve traps
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i32 0
;
  %B = srem i32 0, %A
  ret i32 %B
}

define i32 @test3(i32 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[B:%.*]] = and i32 %A, 7
; CHECK-NEXT:    ret i32 [[B]]
;
  %B = urem i32 %A, 8
  ret i32 %B
}

define <2 x i32> @vec_power_of_2_constant_splat_divisor(<2 x i32> %A) {
; CHECK-LABEL: @vec_power_of_2_constant_splat_divisor(
; CHECK-NEXT:    [[B:%.*]] = and <2 x i32> %A, <i32 7, i32 7>
; CHECK-NEXT:    ret <2 x i32> [[B]]
;
  %B = urem <2 x i32> %A, <i32 8, i32 8>
  ret <2 x i32> %B
}

define <2 x i19> @weird_vec_power_of_2_constant_splat_divisor(<2 x i19> %A) {
; CHECK-LABEL: @weird_vec_power_of_2_constant_splat_divisor(
; CHECK-NEXT:    [[B:%.*]] = and <2 x i19> %A, <i19 7, i19 7>
; CHECK-NEXT:    ret <2 x i19> [[B]]
;
  %B = urem <2 x i19> %A, <i19 8, i19 8>
  ret <2 x i19> %B
}

define i1 @test3a(i32 %A) {
; CHECK-LABEL: @test3a(
; CHECK-NEXT:    [[B1:%.*]] = and i32 %A, 7
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[B1]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = srem i32 %A, -8
  %C = icmp ne i32 %B, 0
  ret i1 %C
}

define <2 x i1> @test3a_vec(<2 x i32> %A) {
; CHECK-LABEL: @test3a_vec(
; CHECK-NEXT:    [[B1:%.*]] = and <2 x i32> %A, <i32 7, i32 7>
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i32> [[B1]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = srem <2 x i32> %A, <i32 -8, i32 -8>
  %C = icmp ne <2 x i32> %B, zeroinitializer
  ret <2 x i1> %C
}

define i32 @test4(i32 %X, i1 %C) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 %C, i32 0, i32 7
; CHECK-NEXT:    [[R:%.*]] = and i32 [[TMP1]], %X
; CHECK-NEXT:    ret i32 [[R]]
;
  %V = select i1 %C, i32 1, i32 8
  %R = urem i32 %X, %V
  ret i32 %R
}

define i32 @test5(i32 %X, i8 %B) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[SHIFT_UPGRD_1:%.*]] = zext i8 %B to i32
; CHECK-NEXT:    [[AMT:%.*]] = shl nuw i32 32, [[SHIFT_UPGRD_1]]
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[AMT]], -1
; CHECK-NEXT:    [[V:%.*]] = and i32 [[TMP1]], %X
; CHECK-NEXT:    ret i32 [[V]]
;
  %shift.upgrd.1 = zext i8 %B to i32
  %Amt = shl i32 32, %shift.upgrd.1
  %V = urem i32 %X, %Amt
  ret i32 %V
}

define i32 @test6(i32 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i32 undef
;
  %B = srem i32 %A, 0	;; undef
  ret i32 %B
}

define i32 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 0
;
  %B = mul i32 %A, 8
  %C = srem i32 %B, 4
  ret i32 %C
}

define i32 @test8(i32 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i32 0
;
  %B = shl i32 %A, 4
  %C = srem i32 %B, 8
  ret i32 %C
}

define i32 @test9(i32 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    ret i32 0
;
  %B = mul i32 %A, 64
  %C = urem i32 %B, 32
  ret i32 %C
}

define i32 @test10(i8 %c) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i32 0
;
  %tmp.1 = zext i8 %c to i32
  %tmp.2 = mul i32 %tmp.1, 4
  %tmp.3 = sext i32 %tmp.2 to i64
  %tmp.5 = urem i64 %tmp.3, 4
  %tmp.6 = trunc i64 %tmp.5 to i32
  ret i32 %tmp.6
}

define i32 @test11(i32 %i) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    ret i32 0
;
  %tmp.1 = and i32 %i, -2
  %tmp.3 = mul i32 %tmp.1, 2
  %tmp.5 = urem i32 %tmp.3, 4
  ret i32 %tmp.5
}

define i32 @test12(i32 %i) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    ret i32 0
;
  %tmp.1 = and i32 %i, -4
  %tmp.5 = srem i32 %tmp.1, 2
  ret i32 %tmp.5
}

define i32 @test13(i32 %i) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    ret i32 0
;
  %x = srem i32 %i, %i
  ret i32 %x
}

define i64 @test14(i64 %x, i32 %y) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 1, %y
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i32 [[SHL]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw i64 [[ZEXT]], -1
; CHECK-NEXT:    [[UREM:%.*]] = and i64 [[TMP1]], %x
; CHECK-NEXT:    ret i64 [[UREM]]
;
  %shl = shl i32 1, %y
  %zext = zext i32 %shl to i64
  %urem = urem i64 %x, %zext
  ret i64 %urem
}

define i64 @test15(i32 %x, i32 %y) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i32 1, %y
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[SHL]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], %x
; CHECK-NEXT:    [[UREM:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    ret i64 [[UREM]]
;
  %shl = shl i32 1, %y
  %zext0 = zext i32 %shl to i64
  %zext1 = zext i32 %x to i64
  %urem = urem i64 %zext1, %zext0
  ret i64 %urem
}

define i32 @test16(i32 %x, i32 %y) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 %y, 11
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SHR]], 4
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[AND]], 3
; CHECK-NEXT:    [[REM:%.*]] = and i32 [[TMP1]], %x
; CHECK-NEXT:    ret i32 [[REM]]
;
  %shr = lshr i32 %y, 11
  %and = and i32 %shr, 4
  %add = add i32 %and, 4
  %rem = urem i32 %x, %add
  ret i32 %rem
}

define i32 @test17(i32 %X) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i32 %X, 1
; CHECK-NEXT:    [[TMP2:%.*]] = zext i1 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %A = urem i32 1, %X
  ret i32 %A
}

define i32 @test18(i16 %x, i32 %y) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i16 %x, 3
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[TMP1]], 32
; CHECK-NEXT:    [[TMP3:%.*]] = xor i16 [[TMP2]], 63
; CHECK-NEXT:    [[TMP4:%.*]] = zext i16 [[TMP3]] to i32
; CHECK-NEXT:    [[TMP5:%.*]] = and i32 [[TMP4]], %y
; CHECK-NEXT:    ret i32 [[TMP5]]
;
  %1 = and i16 %x, 4
  %2 = icmp ne i16 %1, 0
  %3 = select i1 %2, i32 32, i32 64
  %4 = urem i32 %y, %3
  ret i32 %4
}

define i32 @test19(i32 %x, i32 %y) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[A:%.*]] = shl i32 1, %x
; CHECK-NEXT:    [[B:%.*]] = shl i32 1, %y
; CHECK-NEXT:    [[C:%.*]] = and i32 [[A]], [[B]]
; CHECK-NEXT:    [[D:%.*]] = add i32 [[C]], [[A]]
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[D]], -1
; CHECK-NEXT:    [[E:%.*]] = and i32 [[TMP1]], %y
; CHECK-NEXT:    ret i32 [[E]]
;
  %A = shl i32 1, %x
  %B = shl i32 1, %y
  %C = and i32 %A, %B
  %D = add i32 %C, %A
  %E = urem i32 %y, %D
  ret i32 %E
}

define <2 x i64> @test20(<2 x i64> %X, <2 x i1> %C) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> %C, <2 x i64> <i64 1, i64 2>, <2 x i64> zeroinitializer
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %V = select <2 x i1> %C, <2 x i64> <i64 1, i64 2>, <2 x i64> <i64 8, i64 9>
  %R = urem <2 x i64> %V, <i64 2, i64 3>
  ret <2 x i64> %R
}

define i32 @test21(i1 %c0, i32* %p) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %c0, label %if.then, label %if.end
; CHECK:       if.then:
; CHECK-NEXT:    [[V:%.*]] = load volatile i32, i32* %p, align 4
; CHECK-NEXT:    [[PHITMP:%.*]] = srem i32 [[V]], 5
; CHECK-NEXT:    br label %if.end
; CHECK:       if.end:
; CHECK-NEXT:    [[LHS:%.*]] = phi i32 [ [[PHITMP]], %if.then ], [ 0, %entry ]
; CHECK-NEXT:    ret i32 [[LHS]]
;
entry:
  br i1 %c0, label %if.then, label %if.end

if.then:
  %v = load volatile i32, i32* %p
  br label %if.end

if.end:
  %lhs = phi i32 [ %v, %if.then ], [ 5, %entry ]
  %rem = srem i32 %lhs, 5
  ret i32 %rem
}

@a = common global [5 x i16] zeroinitializer, align 2
@b = common global i16 0, align 2

define i32 @pr27968_0(i1 %c0, i32* %p) {
; CHECK-LABEL: @pr27968_0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %c0, label %if.then, label %if.end
; CHECK:       if.then:
; CHECK-NEXT:    [[V:%.*]] = load volatile i32, i32* %p, align 4
; CHECK-NEXT:    br label %if.end
; CHECK:       if.end:
; CHECK-NEXT:    [[LHS:%.*]] = phi i32 [ [[V]], %if.then ], [ 5, %entry ]
; CHECK-NEXT:    br i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b), label [[REM]].is.safe, label [[REM]].is.unsafe
; CHECK:       rem.is.safe:
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[LHS]], zext (i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b) to i32)
; CHECK-NEXT:    ret i32 [[REM]]
; CHECK:       rem.is.unsafe:
; CHECK-NEXT:    ret i32 0
;
entry:
  br i1 %c0, label %if.then, label %if.end

if.then:
  %v = load volatile i32, i32* %p
  br label %if.end

if.end:
  %lhs = phi i32 [ %v, %if.then ], [ 5, %entry ]
  br i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b), label %rem.is.safe, label %rem.is.unsafe

rem.is.safe:
  %rem = srem i32 %lhs, zext (i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b) to i32)
  ret i32 %rem

rem.is.unsafe:
  ret i32 0
}

define i32 @pr27968_1(i1 %c0, i1 %always_false, i32* %p) {
; CHECK-LABEL: @pr27968_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %c0, label %if.then, label %if.end
; CHECK:       if.then:
; CHECK-NEXT:    [[V:%.*]] = load volatile i32, i32* %p, align 4
; CHECK-NEXT:    br label %if.end
; CHECK:       if.end:
; CHECK-NEXT:    [[LHS:%.*]] = phi i32 [ [[V]], %if.then ], [ 5, %entry ]
; CHECK-NEXT:    br i1 %always_false, label [[REM]].is.safe, label [[REM]].is.unsafe
; CHECK:       rem.is.safe:
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[LHS]], -2147483648
; CHECK-NEXT:    ret i32 [[REM]]
; CHECK:       rem.is.unsafe:
; CHECK-NEXT:    ret i32 0
;
entry:
  br i1 %c0, label %if.then, label %if.end

if.then:
  %v = load volatile i32, i32* %p
  br label %if.end

if.end:
  %lhs = phi i32 [ %v, %if.then ], [ 5, %entry ]
  br i1 %always_false, label %rem.is.safe, label %rem.is.unsafe

rem.is.safe:
  %rem = srem i32 %lhs, -2147483648
  ret i32 %rem

rem.is.unsafe:
  ret i32 0
}

define i32 @pr27968_2(i1 %c0, i32* %p) {
; CHECK-LABEL: @pr27968_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %c0, label %if.then, label %if.end
; CHECK:       if.then:
; CHECK-NEXT:    [[V:%.*]] = load volatile i32, i32* %p, align 4
; CHECK-NEXT:    br label %if.end
; CHECK:       if.end:
; CHECK-NEXT:    [[LHS:%.*]] = phi i32 [ [[V]], %if.then ], [ 5, %entry ]
; CHECK-NEXT:    br i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b), label [[REM]].is.safe, label [[REM]].is.unsafe
; CHECK:       rem.is.safe:
; CHECK-NEXT:    [[REM:%.*]] = urem i32 [[LHS]], zext (i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b) to i32)
; CHECK-NEXT:    ret i32 [[REM]]
; CHECK:       rem.is.unsafe:
; CHECK-NEXT:    ret i32 0
;
entry:
  br i1 %c0, label %if.then, label %if.end

if.then:
  %v = load volatile i32, i32* %p
  br label %if.end

if.end:
  %lhs = phi i32 [ %v, %if.then ], [ 5, %entry ]
  br i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b), label %rem.is.safe, label %rem.is.unsafe

rem.is.safe:
  %rem = urem i32 %lhs, zext (i1 icmp eq (i16* getelementptr inbounds ([5 x i16], [5 x i16]* @a, i64 0, i64 4), i16* @b) to i32)
  ret i32 %rem

rem.is.unsafe:
  ret i32 0
}

define i32 @pr27968_3(i1 %c0, i1 %always_false, i32* %p) {
; CHECK-LABEL: @pr27968_3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 %c0, label %if.then, label %if.end
; CHECK:       if.then:
; CHECK-NEXT:    [[V:%.*]] = load volatile i32, i32* %p, align 4
; CHECK-NEXT:    [[PHITMP:%.*]] = and i32 [[V]], 2147483647
; CHECK-NEXT:    br label %if.end
; CHECK:       if.end:
; CHECK-NEXT:    [[LHS:%.*]] = phi i32 [ [[PHITMP]], %if.then ], [ 5, %entry ]
; CHECK-NEXT:    br i1 %always_false, label %rem.is.safe, label %rem.is.unsafe
; CHECK:       rem.is.safe:
; CHECK-NEXT:    ret i32 [[LHS]]
; CHECK:       rem.is.unsafe:
; CHECK-NEXT:    ret i32 0
;
entry:
  br i1 %c0, label %if.then, label %if.end

if.then:
  %v = load volatile i32, i32* %p
  br label %if.end

if.end:
  %lhs = phi i32 [ %v, %if.then ], [ 5, %entry ]
  br i1 %always_false, label %rem.is.safe, label %rem.is.unsafe

rem.is.safe:
  %rem = urem i32 %lhs, -2147483648
  ret i32 %rem

rem.is.unsafe:
  ret i32 0
}

