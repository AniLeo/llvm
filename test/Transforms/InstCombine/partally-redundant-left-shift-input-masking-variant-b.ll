; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; If we have some pattern that leaves only some low bits set, and then performs
; left-shift of those bits, we can combine those two shifts into a shift+mask.

; There are many variants to this pattern:
;   b)  (x & (~(-1 << maskNbits))) << shiftNbits
; simplify to:
;   (x << shiftNbits) & (~(-1 << (maskNbits+shiftNbits)))

; Simple tests.

declare void @use32(i32)

define i32 @t0_basic(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = add i32 [[NBITS:%.*]], -1
; CHECK-NEXT:    [[T1:%.*]] = shl i32 -1, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor i32 [[T1]], -1
; CHECK-NEXT:    [[T4:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[X:%.*]], [[T4]]
; CHECK-NEXT:    [[T5:%.*]] = and i32 [[TMP1]], 2147483647
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t0 = add i32 %nbits, -1
  %t1 = shl i32 -1, %t0 ; shifting by nbits-1
  %t2 = xor i32 %t1, -1
  %t3 = and i32 %t2, %x
  %t4 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t4)
  %t5 = shl i32 %t3, %t4
  ret i32 %t5
}

; Vectors

declare void @use8xi32(<8 x i32>)

define <8 x i32> @t1_vec_splat(<8 x i32> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t1_vec_splat(
; CHECK-NEXT:    [[T0:%.*]] = add <8 x i32> [[NBITS:%.*]], <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor <8 x i32> [[T1]], <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T4:%.*]] = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32>, [[NBITS]]
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T0]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T1]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T2]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = shl <8 x i32> [[X:%.*]], [[T4]]
; CHECK-NEXT:    [[T5:%.*]] = and <8 x i32> [[TMP1]], <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
; CHECK-NEXT:    ret <8 x i32> [[T5]]
;
  %t0 = add <8 x i32> %nbits, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %t1 = shl <8 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, %t0
  %t2 = xor <8 x i32> %t1, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %t3 = and <8 x i32> %t2, %x
  %t4 = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32>, %nbits
  call void @use8xi32(<8 x i32> %t0)
  call void @use8xi32(<8 x i32> %t1)
  call void @use8xi32(<8 x i32> %t2)
  call void @use8xi32(<8 x i32> %t4)
  %t5 = shl <8 x i32> %t3, %t4
  ret <8 x i32> %t5
}

define <8 x i32> @t1_vec_splat_undef(<8 x i32> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t1_vec_splat_undef(
; CHECK-NEXT:    [[T0:%.*]] = add <8 x i32> [[NBITS:%.*]], <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 undef, i32 -1>, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor <8 x i32> [[T1]], <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[T4:%.*]] = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 undef, i32 32>, [[NBITS]]
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T0]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T1]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T2]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = shl <8 x i32> [[X:%.*]], [[T4]]
; CHECK-NEXT:    [[T5:%.*]] = and <8 x i32> [[TMP1]], <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647, i32 poison, i32 2147483647>
; CHECK-NEXT:    ret <8 x i32> [[T5]]
;
  %t0 = add <8 x i32> %nbits, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 undef, i32 -1>
  %t1 = shl <8 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 undef, i32 -1>, %t0
  %t2 = xor <8 x i32> %t1, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 undef, i32 -1>
  %t3 = and <8 x i32> %t2, %x
  %t4 = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 undef, i32 32>, %nbits
  call void @use8xi32(<8 x i32> %t0)
  call void @use8xi32(<8 x i32> %t1)
  call void @use8xi32(<8 x i32> %t2)
  call void @use8xi32(<8 x i32> %t4)
  %t5 = shl <8 x i32> %t3, %t4
  ret <8 x i32> %t5
}

define <8 x i32> @t2_vec_nonsplat(<8 x i32> %x, <8 x i32> %nbits) {
; CHECK-LABEL: @t2_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = add <8 x i32> [[NBITS:%.*]], <i32 -33, i32 -32, i32 -31, i32 -1, i32 0, i32 1, i32 31, i32 32>
; CHECK-NEXT:    [[T1:%.*]] = shl <8 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor <8 x i32> [[T1]], <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T4:%.*]] = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32>, [[NBITS]]
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T0]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T1]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T2]])
; CHECK-NEXT:    call void @use8xi32(<8 x i32> [[T4]])
; CHECK-NEXT:    [[TMP1:%.*]] = shl <8 x i32> [[X:%.*]], [[T4]]
; CHECK-NEXT:    [[T5:%.*]] = and <8 x i32> [[TMP1]], <i32 poison, i32 0, i32 1, i32 2147483647, i32 -1, i32 -1, i32 -1, i32 poison>
; CHECK-NEXT:    ret <8 x i32> [[T5]]
;
  %t0 = add <8 x i32> %nbits, <i32 -33, i32 -32, i32 -31, i32 -1, i32 0, i32 1, i32 31, i32 32>
  %t1 = shl <8 x i32> <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, %t0
  %t2 = xor <8 x i32> %t1, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %t3 = and <8 x i32> %t2, %x
  %t4 = sub <8 x i32> <i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32>, %nbits
  call void @use8xi32(<8 x i32> %t0)
  call void @use8xi32(<8 x i32> %t1)
  call void @use8xi32(<8 x i32> %t2)
  call void @use8xi32(<8 x i32> %t4)
  %t5 = shl <8 x i32> %t3, %t4
  ret <8 x i32> %t5
}

; Extra uses.

define i32 @n3_extrause(i32 %x, i32 %nbits) {
; CHECK-LABEL: @n3_extrause(
; CHECK-NEXT:    [[T0:%.*]] = add i32 [[NBITS:%.*]], -1
; CHECK-NEXT:    [[T1:%.*]] = shl i32 -1, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = xor i32 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = and i32 [[T2]], [[X:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl i32 [[T3]], [[T4]]
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t0 = add i32 %nbits, -1
  %t1 = shl i32 -1, %t0 ; shifting by nbits-1
  %t2 = xor i32 %t1, -1
  %t3 = and i32 %t2, %x ; this mask must be one-use.
  %t4 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3) ; BAD
  call void @use32(i32 %t4)
  %t5 = shl i32 %t3, %t4
  ret i32 %t5
}
