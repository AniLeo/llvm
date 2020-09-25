; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32"

define i32 @test1(i32 %i) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TMP12:%.*]] = call i32 @llvm.bswap.i32(i32 [[I:%.*]])
; CHECK-NEXT:    ret i32 [[TMP12]]
;
  %tmp1 = lshr i32 %i, 24
  %tmp3 = lshr i32 %i, 8
  %tmp4 = and i32 %tmp3, 65280
  %tmp5 = or i32 %tmp1, %tmp4
  %tmp7 = shl i32 %i, 8
  %tmp8 = and i32 %tmp7, 16711680
  %tmp9 = or i32 %tmp5, %tmp8
  %tmp11 = shl i32 %i, 24
  %tmp12 = or i32 %tmp9, %tmp11
  ret i32 %tmp12
}

define i32 @test2(i32 %arg) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP14:%.*]] = call i32 @llvm.bswap.i32(i32 [[ARG:%.*]])
; CHECK-NEXT:    ret i32 [[TMP14]]
;
  %tmp2 = shl i32 %arg, 24
  %tmp4 = shl i32 %arg, 8
  %tmp5 = and i32 %tmp4, 16711680
  %tmp6 = or i32 %tmp2, %tmp5
  %tmp8 = lshr i32 %arg, 8
  %tmp9 = and i32 %tmp8, 65280
  %tmp10 = or i32 %tmp6, %tmp9
  %tmp12 = lshr i32 %arg, 24
  %tmp14 = or i32 %tmp10, %tmp12
  ret i32 %tmp14
}

define i16 @test3(i16 %s) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TMP5:%.*]] = call i16 @llvm.bswap.i16(i16 [[S:%.*]])
; CHECK-NEXT:    ret i16 [[TMP5]]
;
  %tmp2 = lshr i16 %s, 8
  %tmp4 = shl i16 %s, 8
  %tmp5 = or i16 %tmp2, %tmp4
  ret i16 %tmp5
}

define i16 @test4(i16 %s) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP5:%.*]] = call i16 @llvm.bswap.i16(i16 [[S:%.*]])
; CHECK-NEXT:    ret i16 [[TMP5]]
;
  %tmp2 = lshr i16 %s, 8
  %tmp4 = shl i16 %s, 8
  %tmp5 = or i16 %tmp4, %tmp2
  ret i16 %tmp5
}

define i16 @test5(i16 %a) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP_UPGRD_3:%.*]] = call i16 @llvm.bswap.i16(i16 [[A:%.*]])
; CHECK-NEXT:    ret i16 [[TMP_UPGRD_3]]
;
  %tmp = zext i16 %a to i32
  %tmp1 = and i32 %tmp, 65280
  %tmp2 = ashr i32 %tmp1, 8
  %tmp2.upgrd.1 = trunc i32 %tmp2 to i16
  %tmp4 = and i32 %tmp, 255
  %tmp5 = shl i32 %tmp4, 8
  %tmp5.upgrd.2 = trunc i32 %tmp5 to i16
  %tmp.upgrd.3 = or i16 %tmp2.upgrd.1, %tmp5.upgrd.2
  %tmp6 = bitcast i16 %tmp.upgrd.3 to i16
  %tmp6.upgrd.4 = zext i16 %tmp6 to i32
  %retval = trunc i32 %tmp6.upgrd.4 to i16
  ret i16 %retval
}

; PR2842
define i32 @test6(i32 %x) nounwind readnone {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[TMP7:%.*]] = call i32 @llvm.bswap.i32(i32 [[X:%.*]])
; CHECK-NEXT:    ret i32 [[TMP7]]
;
  %tmp = shl i32 %x, 16
  %x.mask = and i32 %x, 65280
  %tmp1 = lshr i32 %x, 16
  %tmp2 = and i32 %tmp1, 255
  %tmp3 = or i32 %x.mask, %tmp
  %tmp4 = or i32 %tmp3, %tmp2
  %tmp5 = shl i32 %tmp4, 8
  %tmp6 = lshr i32 %x, 24
  %tmp7 = or i32 %tmp5, %tmp6
  ret i32 %tmp7
}

declare void @extra_use(i32)

; swaphalf = (x << 16 | x >> 16)
; ((swaphalf & 0x00ff00ff) << 8) | ((swaphalf >> 8) & 0x00ff00ff)

define i32 @bswap32_and_first(i32 %x) {
; CHECK-LABEL: @bswap32_and_first(
; CHECK-NEXT:    [[BSWAP:%.*]] = call i32 @llvm.bswap.i32(i32 [[X:%.*]])
; CHECK-NEXT:    ret i32 [[BSWAP]]
;
  %shl = shl i32 %x, 16
  %shr = lshr i32 %x, 16
  %swaphalf = or i32 %shl, %shr
  %t = and i32 %swaphalf, 16711935
  %tshl = shl nuw i32 %t, 8
  %b = lshr i32 %swaphalf, 8
  %band = and i32 %b, 16711935
  %bswap = or i32 %tshl, %band
  ret i32 %bswap
}

; Extra use should not prevent matching to bswap.
; swaphalf = (x << 16 | x >> 16)
; ((swaphalf & 0x00ff00ff) << 8) | ((swaphalf >> 8) & 0x00ff00ff)

define i32 @bswap32_and_first_extra_use(i32 %x) {
; CHECK-LABEL: @bswap32_and_first_extra_use(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], 16
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[X]], 16
; CHECK-NEXT:    [[SWAPHALF:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    [[T:%.*]] = and i32 [[SWAPHALF]], 16711935
; CHECK-NEXT:    [[BSWAP:%.*]] = call i32 @llvm.bswap.i32(i32 [[X]])
; CHECK-NEXT:    call void @extra_use(i32 [[T]])
; CHECK-NEXT:    ret i32 [[BSWAP]]
;
  %shl = shl i32 %x, 16
  %shr = lshr i32 %x, 16
  %swaphalf = or i32 %shl, %shr
  %t = and i32 %swaphalf, 16711935
  %tshl = shl nuw i32 %t, 8
  %b = lshr i32 %swaphalf, 8
  %band = and i32 %b, 16711935
  %bswap = or i32 %tshl, %band
  call void @extra_use(i32 %t)
  ret i32 %bswap
}

; swaphalf = (x << 16 | x >> 16)
; ((swaphalf << 8) & 0xff00ff00) | ((swaphalf >> 8) & 0x00ff00ff)

; PR23863
define i32 @bswap32_shl_first(i32 %x) {
; CHECK-LABEL: @bswap32_shl_first(
; CHECK-NEXT:    [[BSWAP:%.*]] = call i32 @llvm.bswap.i32(i32 [[X:%.*]])
; CHECK-NEXT:    ret i32 [[BSWAP]]
;
  %shl = shl i32 %x, 16
  %shr = lshr i32 %x, 16
  %swaphalf = or i32 %shl, %shr
  %t = shl i32 %swaphalf, 8
  %tand = and i32 %t, -16711936
  %b = lshr i32 %swaphalf, 8
  %band = and i32 %b, 16711935
  %bswap = or i32 %tand, %band
  ret i32 %bswap
}

; Extra use should not prevent matching to bswap.
; swaphalf = (x << 16 | x >> 16)
; ((swaphalf << 8) & 0xff00ff00) | ((swaphalf >> 8) & 0x00ff00ff)

define i32 @bswap32_shl_first_extra_use(i32 %x) {
; CHECK-LABEL: @bswap32_shl_first_extra_use(
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[X]], 24
; CHECK-NEXT:    [[TMP2:%.*]] = shl nuw nsw i32 [[SHR]], 8
; CHECK-NEXT:    [[T:%.*]] = or i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[BSWAP:%.*]] = call i32 @llvm.bswap.i32(i32 [[X]])
; CHECK-NEXT:    call void @extra_use(i32 [[T]])
; CHECK-NEXT:    ret i32 [[BSWAP]]
;
  %shl = shl i32 %x, 16
  %shr = lshr i32 %x, 16
  %swaphalf = or i32 %shl, %shr
  %t = shl i32 %swaphalf, 8
  %tand = and i32 %t, -16711936
  %b = lshr i32 %swaphalf, 8
  %band = and i32 %b, 16711935
  %bswap = or i32 %tand, %band
  call void @extra_use(i32 %t)
  ret i32 %bswap
}

define i16 @test8(i16 %a) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[REV:%.*]] = call i16 @llvm.bswap.i16(i16 [[A:%.*]])
; CHECK-NEXT:    ret i16 [[REV]]
;
  %conv = zext i16 %a to i32
  %shr = lshr i16 %a, 8
  %shl = shl i32 %conv, 8
  %conv1 = zext i16 %shr to i32
  %or = or i32 %conv1, %shl
  %conv2 = trunc i32 %or to i16
  ret i16 %conv2
}

define i16 @test9(i16 %a) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[REV:%.*]] = call i16 @llvm.bswap.i16(i16 [[A:%.*]])
; CHECK-NEXT:    ret i16 [[REV]]
;
  %conv = zext i16 %a to i32
  %shr = lshr i32 %conv, 8
  %shl = shl i32 %conv, 8
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i16
  ret i16 %conv2
}

define i16 @test10(i32 %a) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[TRUNC:%.*]] = trunc i32 [[A:%.*]] to i16
; CHECK-NEXT:    [[REV:%.*]] = call i16 @llvm.bswap.i16(i16 [[TRUNC]])
; CHECK-NEXT:    ret i16 [[REV]]
;
  %shr1 = lshr i32 %a, 8
  %and1 = and i32 %shr1, 255
  %and2 = shl i32 %a, 8
  %shl1 = and i32 %and2, 65280
  %or = or i32 %and1, %shl1
  %conv = trunc i32 %or to i16
  ret i16 %conv
}

define i32 @shuf_4bytes(<4 x i8> %x) {
; CHECK-LABEL: @shuf_4bytes(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i8> [[X:%.*]] to i32
; CHECK-NEXT:    [[CAST:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[CAST]]
;
  %bswap = shufflevector <4 x i8> %x, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %cast = bitcast <4 x i8> %bswap to i32
  ret i32 %cast
}

define i32 @shuf_load_4bytes(<4 x i8>* %p) {
; CHECK-LABEL: @shuf_load_4bytes(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i8>* [[P:%.*]] to i32*
; CHECK-NEXT:    [[X1:%.*]] = load i32, i32* [[TMP1]], align 4
; CHECK-NEXT:    [[CAST:%.*]] = call i32 @llvm.bswap.i32(i32 [[X1]])
; CHECK-NEXT:    ret i32 [[CAST]]
;
  %x = load <4 x i8>, <4 x i8>* %p
  %bswap = shufflevector <4 x i8> %x, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 undef, i32 0>
  %cast = bitcast <4 x i8> %bswap to i32
  ret i32 %cast
}

define i32 @shuf_bitcast_twice_4bytes(i32 %x) {
; CHECK-LABEL: @shuf_bitcast_twice_4bytes(
; CHECK-NEXT:    [[CAST2:%.*]] = call i32 @llvm.bswap.i32(i32 [[X:%.*]])
; CHECK-NEXT:    ret i32 [[CAST2]]
;
  %cast1 = bitcast i32 %x to <4 x i8>
  %bswap = shufflevector <4 x i8> %cast1, <4 x i8> undef, <4 x i32> <i32 undef, i32 2, i32 1, i32 0>
  %cast2 = bitcast <4 x i8> %bswap to i32
  ret i32 %cast2
}

; Negative test - extra use
declare void @use(<4 x i8>)

define i32 @shuf_4bytes_extra_use(<4 x i8> %x) {
; CHECK-LABEL: @shuf_4bytes_extra_use(
; CHECK-NEXT:    [[BSWAP:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    call void @use(<4 x i8> [[BSWAP]])
; CHECK-NEXT:    [[CAST:%.*]] = bitcast <4 x i8> [[BSWAP]] to i32
; CHECK-NEXT:    ret i32 [[CAST]]
;
  %bswap = shufflevector <4 x i8> %x, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  call void @use(<4 x i8> %bswap)
  %cast = bitcast <4 x i8> %bswap to i32
  ret i32 %cast
}

; Negative test - scalar type is not in the data layout

define i128 @shuf_16bytes(<16 x i8> %x) {
; CHECK-LABEL: @shuf_16bytes(
; CHECK-NEXT:    [[BSWAP:%.*]] = shufflevector <16 x i8> [[X:%.*]], <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[CAST:%.*]] = bitcast <16 x i8> [[BSWAP]] to i128
; CHECK-NEXT:    ret i128 [[CAST]]
;
  %bswap = shufflevector <16 x i8> %x, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %cast = bitcast <16 x i8> %bswap to i128
  ret i128 %cast
}

; Negative test - don't touch widening shuffles (for now)

define i32 @shuf_2bytes_widening(<2 x i8> %x) {
; CHECK-LABEL: @shuf_2bytes_widening(
; CHECK-NEXT:    [[BSWAP:%.*]] = shufflevector <2 x i8> [[X:%.*]], <2 x i8> undef, <4 x i32> <i32 1, i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[CAST:%.*]] = bitcast <4 x i8> [[BSWAP]] to i32
; CHECK-NEXT:    ret i32 [[CAST]]
;
  %bswap = shufflevector <2 x i8> %x, <2 x i8> undef, <4 x i32> <i32 1, i32 0, i32 undef, i32 undef>
  %cast = bitcast <4 x i8> %bswap to i32
  ret i32 %cast
}

declare i32 @llvm.fshl.i32(i32, i32, i32)
declare i32 @llvm.fshr.i32(i32, i32, i32)

define i32 @funnel_unary(i32 %abcd) {
; CHECK-LABEL: @funnel_unary(
; CHECK-NEXT:    [[DABC:%.*]] = call i32 @llvm.fshl.i32(i32 [[ABCD:%.*]], i32 [[ABCD]], i32 24)
; CHECK-NEXT:    [[BCDA:%.*]] = call i32 @llvm.fshl.i32(i32 [[ABCD]], i32 [[ABCD]], i32 8)
; CHECK-NEXT:    [[DZBZ:%.*]] = and i32 [[DABC]], -16711936
; CHECK-NEXT:    [[ZCZA:%.*]] = and i32 [[BCDA]], 16711935
; CHECK-NEXT:    [[DCBA:%.*]] = or i32 [[DZBZ]], [[ZCZA]]
; CHECK-NEXT:    ret i32 [[DCBA]]
;
  %dabc = call i32 @llvm.fshl.i32(i32 %abcd, i32 %abcd, i32 24)
  %bcda = call i32 @llvm.fshr.i32(i32 %abcd, i32 %abcd, i32 24)
  %dzbz = and i32 %dabc, -16711936
  %zcza = and i32 %bcda,  16711935
  %dcba = or i32 %dzbz, %zcza
  ret i32 %dcba
}

define i32 @funnel_binary(i32 %abcd) {
; CHECK-LABEL: @funnel_binary(
; CHECK-NEXT:    [[CDZZ:%.*]] = shl i32 [[ABCD:%.*]], 16
; CHECK-NEXT:    [[DCDZ:%.*]] = call i32 @llvm.fshl.i32(i32 [[ABCD]], i32 [[CDZZ]], i32 24)
; CHECK-NEXT:    [[ZZAB:%.*]] = lshr i32 [[ABCD]], 16
; CHECK-NEXT:    [[ZABA:%.*]] = call i32 @llvm.fshl.i32(i32 [[ZZAB]], i32 [[ABCD]], i32 8)
; CHECK-NEXT:    [[DCZZ:%.*]] = and i32 [[DCDZ]], -65536
; CHECK-NEXT:    [[ZZBA:%.*]] = and i32 [[ZABA]], 65535
; CHECK-NEXT:    [[DCBA:%.*]] = or i32 [[DCZZ]], [[ZZBA]]
; CHECK-NEXT:    ret i32 [[DCBA]]
;
  %cdzz = shl i32 %abcd, 16
  %dcdz = call i32 @llvm.fshl.i32(i32 %abcd, i32 %cdzz, i32 24)
  %zzab = lshr i32 %abcd, 16
  %zaba = call i32 @llvm.fshr.i32(i32 %zzab, i32 %abcd, i32 24)
  %dczz = and i32 %dcdz, -65536
  %zzba = and i32 %zaba,  65535
  %dcba = or i32 %dczz, %zzba
  ret i32 %dcba
}
