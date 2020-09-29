; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; If we have some pattern that leaves only some low bits set, and then performs
; left-shift of those bits, we can combine those two shifts into a shift+mask.

; There are many variants to this pattern:
;   b)  (trunc ((x & (~(-1 << maskNbits))))) << shiftNbits
; simplify to:
;   ((trunc(x)) << shiftNbits) & (~(-1 << (maskNbits+shiftNbits)))

; Simple tests.

declare void @use32(i32)
declare void @use64(i64)

define i32 @t0_basic(i64 %x, i32 %nbits) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = zext i32 [[NBITS:%.*]] to i64
; CHECK-NEXT:    [[T1:%.*]] = shl i64 -1, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor i64 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    [[T4:%.*]] = and i64 [[T2]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[NBITS]])
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    call void @use64(i64 [[T1]])
; CHECK-NEXT:    call void @use64(i64 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use64(i64 [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[X]] to i32
; CHECK-NEXT:    [[T6:%.*]] = shl i32 [[TMP1]], [[T3]]
; CHECK-NEXT:    ret i32 [[T6]]
;
  %t0 = zext i32 %nbits to i64
  %t1 = shl i64 -1, %t0
  %t2 = xor i64 %t1, -1
  %t3 = sub i32 32, %nbits
  %t4 = and i64 %t2, %x

  call void @use32(i32 %nbits)
  call void @use64(i64 %t0)
  call void @use64(i64 %t1)
  call void @use64(i64 %t2)
  call void @use32(i32 %t3)
  call void @use64(i64 %t4)

  %t5 = trunc i64 %t4 to i32
  %t6 = shl i32 %t5, %t3
  ret i32 %t6
}

; Vectors

declare void @use8xi32(<8 x i32>)
declare void @use8xi64(<8 x i64>)

define <8 x i32> @t1_vec_splat(<8 x i64> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t1_vec_splat(
; CHECK-NEXT:    [[T0:%.*]] = zext <8 x i32> [[NBITS:%.*]] to <8 x i64>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor <8 x i64> [[T1]], <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>
; CHECK-NEXT:    [[T3:%.*]] = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32>, [[NBITS]]
; CHECK-NEXT:    [[T4:%.*]] = and <8 x i64> [[T2]], [[X:%.*]]
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[NBITS]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T0]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T1]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T2]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T3]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <8 x i64> [[X]] to <8 x i32>
; CHECK-NEXT:    [[T6:%.*]] = shl <8 x i32> [[TMP1]], [[T3]]
; CHECK-NEXT:    ret <8 x i32> [[T6]]
;
  %t0 = zext <8 x i32> %nbits to <8 x i64>
  %t1 = shl <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>, %t0
  %t2 = xor <8 x i64> %t1, <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>
  %t3 = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32>, %nbits
  %t4 = and <8 x i64> %t2, %x

  call void @use8xi32(<8 x i32> %nbits)
  call void @use8xi64(<8 x i64> %t0)
  call void @use8xi64(<8 x i64> %t1)
  call void @use8xi64(<8 x i64> %t2)
  call void @use8xi32(<8 x i32> %t3)
  call void @use8xi64(<8 x i64> %t4)

  %t5 = trunc <8 x i64> %t4 to <8 x i32>
  %t6 = shl <8 x i32> %t5, %t3
  ret <8 x i32> %t6
}

define <8 x i32> @t2_vec_splat_undef(<8 x i64> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t2_vec_splat_undef(
; CHECK-NEXT:    [[T0:%.*]] = zext <8 x i32> [[NBITS:%.*]] to <8 x i64>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 undef, i64 -1>, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor <8 x i64> [[T1]], <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 undef, i64 -1>
; CHECK-NEXT:    [[T3:%.*]] = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 undef, i32 32>, [[NBITS]]
; CHECK-NEXT:    [[T4:%.*]] = and <8 x i64> [[T2]], [[X:%.*]]
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[NBITS]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T0]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T1]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T2]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T3]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <8 x i64> [[X]] to <8 x i32>
; CHECK-NEXT:    [[T6:%.*]] = shl <8 x i32> [[TMP1]], [[T3]]
; CHECK-NEXT:    ret <8 x i32> [[T6]]
;
  %t0 = zext <8 x i32> %nbits to <8 x i64>
  %t1 = shl <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 undef, i64 -1>, %t0
  %t2 = xor <8 x i64> %t1, <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 undef, i64 -1>
  %t3 = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 undef, i32 32>, %nbits
  %t4 = and <8 x i64> %t2, %x

  call void @use8xi32(<8 x i32> %nbits)
  call void @use8xi64(<8 x i64> %t0)
  call void @use8xi64(<8 x i64> %t1)
  call void @use8xi64(<8 x i64> %t2)
  call void @use8xi32(<8 x i32> %t3)
  call void @use8xi64(<8 x i64> %t4)

  %t5 = trunc <8 x i64> %t4 to <8 x i32>
  %t6 = shl <8 x i32> %t5, %t3
  ret <8 x i32> %t6
}

define <8 x i32> @t3_vec_nonsplat(<8 x i64> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t3_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = add <8 x i32> [[NBITS:%.*]], <i32 -1, i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0>
; CHECK-NEXT:    [[T1:%.*]] = zext <8 x i32> [[T0]] to <8 x i64>
; CHECK-NEXT:    [[T2:%.*]] = shl <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>, [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = xor <8 x i64> [[T2]], <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>
; CHECK-NEXT:    [[T4:%.*]] = sub <8 x i32> <i32 33, i32 32, i32 33, i32 32, i32 32, i32 32, i32 32, i32 32>, [[NBITS]]
; CHECK-NEXT:    [[T5:%.*]] = and <8 x i64> [[T3]], [[X:%.*]]
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T0]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T1]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T2]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T3]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T4]])
; CHECK-NEXT:    call void @use8xi64(<8 x i64> [[T5]])
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <8 x i64> [[X]] to <8 x i32>
; CHECK-NEXT:    [[T7:%.*]] = shl <8 x i32> [[TMP1]], [[T4]]
; CHECK-NEXT:    ret <8 x i32> [[T7]]
;
  %t0 = add <8 x i32> %nbits, <i32 -1, i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0>
  %t1 = zext <8 x i32> %t0 to <8 x i64>
  %t2 = shl <8 x i64> <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>, %t1 ; shifting by nbits-1
  %t3 = xor <8 x i64> %t2, <i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1, i64 -1>
  %t4 = sub <8 x i32> <i32 33, i32 32, i32 33, i32 32, i32 32, i32 32, i32 32, i32 32>, %nbits
  %t5 = and <8 x i64> %t3, %x

  call void @use8xi32(<8 x i32> %t0)
  call void @use8xi64(<8 x i64> %t1)
  call void @use8xi64(<8 x i64> %t2)
  call void @use8xi64(<8 x i64> %t3)
  call void @use8xi32(<8 x i32> %t4)
  call void @use8xi64(<8 x i64> %t5)

  %t6 = trunc <8 x i64> %t5 to <8 x i32>
  %t7 = shl <8 x i32> %t6, %t4
  ret <8 x i32> %t7
}

; -1 can be truncated.

define i32 @t4_allones_trunc(i64 %x, i32 %nbits) {
; CHECK-LABEL: @t4_allones_trunc(
; CHECK-NEXT:    [[T0:%.*]] = zext i32 [[NBITS:%.*]] to i64
; CHECK-NEXT:    [[T1:%.*]] = shl i64 -1, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor i64 [[T1]], 4294967295
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    [[T4:%.*]] = and i64 [[T2]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[NBITS]])
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    call void @use64(i64 [[T1]])
; CHECK-NEXT:    call void @use64(i64 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use64(i64 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = trunc i64 [[T4]] to i32
; CHECK-NEXT:    [[T6:%.*]] = shl i32 [[T5]], [[T3]]
; CHECK-NEXT:    ret i32 [[T6]]
;
  %t0 = zext i32 %nbits to i64
  %t1 = shl i64 -1, %t0
  %t2 = xor i64 %t1, 4294967295
  %t3 = sub i32 32, %nbits
  %t4 = and i64 %t2, %x

  call void @use32(i32 %nbits)
  call void @use64(i64 %t0)
  call void @use64(i64 %t1)
  call void @use64(i64 %t2)
  call void @use32(i32 %t3)
  call void @use64(i64 %t4)

  %t5 = trunc i64 %t4 to i32
  %t6 = shl i32 %t5, %t3
  ret i32 %t6
}

; Extra uses

define i32 @n5_extrause(i64 %x, i32 %nbits) {
; CHECK-LABEL: @n5_extrause(
; CHECK-NEXT:    [[T0:%.*]] = zext i32 [[NBITS:%.*]] to i64
; CHECK-NEXT:    [[T1:%.*]] = shl i64 -1, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor i64 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    [[T4:%.*]] = and i64 [[T2]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[NBITS]])
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    call void @use64(i64 [[T1]])
; CHECK-NEXT:    call void @use64(i64 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use64(i64 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = trunc i64 [[T4]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T5]])
; CHECK-NEXT:    [[T6:%.*]] = shl i32 [[T5]], [[T3]]
; CHECK-NEXT:    ret i32 [[T6]]
;
  %t0 = zext i32 %nbits to i64
  %t1 = shl i64 -1, %t0
  %t2 = xor i64 %t1, -1
  %t3 = sub i32 32, %nbits
  %t4 = and i64 %t2, %x

  call void @use32(i32 %nbits)
  call void @use64(i64 %t0)
  call void @use64(i64 %t1)
  call void @use64(i64 %t2)
  call void @use32(i32 %t3)
  call void @use64(i64 %t4)

  %t5 = trunc i64 %t4 to i32
  call void @use32(i32 %t5)
  %t6 = shl i32 %t5, %t3
  ret i32 %t6
}
