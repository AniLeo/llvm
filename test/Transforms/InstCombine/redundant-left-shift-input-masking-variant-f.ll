; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; If we have some pattern that leaves only some low bits set, and then performs
; left-shift of those bits, if none of the bits that are left after the final
; shift are modified by the mask, we can omit the mask.

; There are many variants to this pattern:
;   f)  ((x << maskNbits) a>> maskNbits) << shiftNbits
; simplify to:
;   x << shiftNbits
; iff (shiftNbits-maskNbits) s>= 0 (i.e. shiftNbits u>= maskNbits)

; Simple tests. We don't care about extra uses.

declare void @use32(i32)

define i32 @t0_basic(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = shl i32 [[T1]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t0 = shl i32 %x, %nbits
  %t1 = ashr i32 %t0, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  %t2 = shl i32 %t1, %nbits
  ret i32 %t2
}

define i32 @t1_bigger_shift(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t1_bigger_shift(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[NBITS]], 1
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[T1]], [[T2]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = shl i32 %x, %nbits
  %t1 = ashr i32 %t0, %nbits
  %t2 = add i32 %nbits, 1
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl i32 %t1, %t2
  ret i32 %t3
}

; Vectors

declare void @use3xi32(<3 x i32>)

define <3 x i32> @t2_vec_splat(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t2_vec_splat(
; CHECK-NEXT:    [[T0:%.*]] = shl <3 x i32> [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr <3 x i32> [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[NBITS]], <i32 1, i32 1, i32 1>
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T0]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl <3 x i32> [[T1]], [[T2]]
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t0 = shl <3 x i32> %x, %nbits
  %t1 = ashr <3 x i32> %t0, %nbits
  %t2 = add <3 x i32> %nbits, <i32 1, i32 1, i32 1>
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  %t3 = shl <3 x i32> %t1, %t2
  ret <3 x i32> %t3
}

define <3 x i32> @t3_vec_nonsplat(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t3_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = shl <3 x i32> [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr <3 x i32> [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[NBITS]], <i32 1, i32 0, i32 2>
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T0]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl <3 x i32> [[T1]], [[T2]]
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t0 = shl <3 x i32> %x, %nbits
  %t1 = ashr <3 x i32> %t0, %nbits
  %t2 = add <3 x i32> %nbits, <i32 1, i32 0, i32 2>
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  %t3 = shl <3 x i32> %t1, %t2
  ret <3 x i32> %t3
}

define <3 x i32> @t4_vec_undef(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t4_vec_undef(
; CHECK-NEXT:    [[T0:%.*]] = shl <3 x i32> [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr <3 x i32> [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[NBITS]], <i32 1, i32 undef, i32 1>
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T0]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl <3 x i32> [[T1]], [[T2]]
; CHECK-NEXT:    ret <3 x i32> [[T3]]
;
  %t0 = shl <3 x i32> %x, %nbits
  %t1 = ashr <3 x i32> %t0, %nbits
  %t2 = add <3 x i32> %nbits, <i32 1, i32 undef, i32 1>
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  %t3 = shl <3 x i32> %t1, %t2
  ret <3 x i32> %t3
}

; Fast-math flags. We must not preserve them!

define i32 @t5_nuw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t5_nuw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = shl nuw i32 [[T1]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t0 = shl i32 %x, %nbits
  %t1 = ashr i32 %t0, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  %t2 = shl nuw i32 %t1, %nbits
  ret i32 %t2
}

define i32 @t6_nsw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t6_nsw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = shl nsw i32 [[T1]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t0 = shl i32 %x, %nbits
  %t1 = ashr i32 %t0, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  %t2 = shl nsw i32 %t1, %nbits
  ret i32 %t2
}

define i32 @t7_nuw_nsw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t7_nuw_nsw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = shl nuw nsw i32 [[T1]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t0 = shl i32 %x, %nbits
  %t1 = ashr i32 %t0, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  %t2 = shl nuw nsw i32 %t1, %nbits
  ret i32 %t2
}

; Negative tests

define i32 @n8_different_shamts0(i32 %x, i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @n8_different_shamts0(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS1:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = shl i32 [[T1]], [[NBITS0]]
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t0 = shl i32 %x, %nbits0 ; different shift amts
  %t1 = ashr i32 %t0, %nbits1 ; different shift amts
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  %t2 = shl i32 %t1, %nbits0
  ret i32 %t2
}

define i32 @n9_different_shamts1(i32 %x, i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @n9_different_shamts1(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS1:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = shl i32 [[T1]], [[NBITS1]]
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t0 = shl i32 %x, %nbits0 ; different shift amts
  %t1 = ashr i32 %t0, %nbits1 ; different shift amts
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  %t2 = shl i32 %t1, %nbits1
  ret i32 %t2
}

define i32 @n10_shamt_is_smaller(i32 %x, i32 %nbits) {
; CHECK-LABEL: @n10_shamt_is_smaller(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = ashr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[NBITS]], -1
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t0 = shl i32 %x, %nbits
  %t1 = ashr i32 %t0, %nbits
  %t2 = add i32 %nbits, -1
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl i32 %t1, %t2 ; shift is smaller than mask
  ret i32 %t2
}
