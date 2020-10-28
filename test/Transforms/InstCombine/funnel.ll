; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

; Canonicalize or(shl,lshr) by constant to funnel shift intrinsics.
; This should help cost modeling for vectorization, inlining, etc.
; If a target does not have a fshl instruction, the expansion will
; be exactly these same 3 basic ops (shl/lshr/or).

define i32 @fshl_i32_constant(i32 %x, i32 %y) {
; CHECK-LABEL: @fshl_i32_constant(
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 11)
; CHECK-NEXT:    ret i32 [[R]]
;
  %shl = shl i32 %x, 11
  %shr = lshr i32 %y, 21
  %r = or i32 %shr, %shl
  ret i32 %r
}

define i42 @fshr_i42_constant(i42 %x, i42 %y) {
; CHECK-LABEL: @fshr_i42_constant(
; CHECK-NEXT:    [[R:%.*]] = call i42 @llvm.fshl.i42(i42 [[Y:%.*]], i42 [[X:%.*]], i42 11)
; CHECK-NEXT:    ret i42 [[R]]
;
  %shr = lshr i42 %x, 31
  %shl = shl i42 %y, 11
  %r = or i42 %shr, %shl
  ret i42 %r
}

; Vector types are allowed.

define <2 x i16> @fshl_v2i16_constant_splat(<2 x i16> %x, <2 x i16> %y) {
; CHECK-LABEL: @fshl_v2i16_constant_splat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> <i16 1, i16 1>)
; CHECK-NEXT:    ret <2 x i16> [[R]]
;
  %shl = shl <2 x i16> %x, <i16 1, i16 1>
  %shr = lshr <2 x i16> %y, <i16 15, i16 15>
  %r = or <2 x i16> %shl, %shr
  ret <2 x i16> %r
}

define <2 x i16> @fshl_v2i16_constant_splat_undef0(<2 x i16> %x, <2 x i16> %y) {
; CHECK-LABEL: @fshl_v2i16_constant_splat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> <i16 1, i16 1>)
; CHECK-NEXT:    ret <2 x i16> [[R]]
;
  %shl = shl <2 x i16> %x, <i16 undef, i16 1>
  %shr = lshr <2 x i16> %y, <i16 15, i16 15>
  %r = or <2 x i16> %shl, %shr
  ret <2 x i16> %r
}

define <2 x i16> @fshl_v2i16_constant_splat_undef1(<2 x i16> %x, <2 x i16> %y) {
; CHECK-LABEL: @fshl_v2i16_constant_splat_undef1(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> <i16 1, i16 1>)
; CHECK-NEXT:    ret <2 x i16> [[R]]
;
  %shl = shl <2 x i16> %x, <i16 1, i16 1>
  %shr = lshr <2 x i16> %y, <i16 15, i16 undef>
  %r = or <2 x i16> %shl, %shr
  ret <2 x i16> %r
}

; Non-power-of-2 vector types are allowed.

define <2 x i17> @fshr_v2i17_constant_splat(<2 x i17> %x, <2 x i17> %y) {
; CHECK-LABEL: @fshr_v2i17_constant_splat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i17> @llvm.fshl.v2i17(<2 x i17> [[Y:%.*]], <2 x i17> [[X:%.*]], <2 x i17> <i17 5, i17 5>)
; CHECK-NEXT:    ret <2 x i17> [[R]]
;
  %shr = lshr <2 x i17> %x, <i17 12, i17 12>
  %shl = shl <2 x i17> %y, <i17 5, i17 5>
  %r = or <2 x i17> %shr, %shl
  ret <2 x i17> %r
}

define <2 x i17> @fshr_v2i17_constant_splat_undef0(<2 x i17> %x, <2 x i17> %y) {
; CHECK-LABEL: @fshr_v2i17_constant_splat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i17> @llvm.fshl.v2i17(<2 x i17> [[Y:%.*]], <2 x i17> [[X:%.*]], <2 x i17> <i17 5, i17 5>)
; CHECK-NEXT:    ret <2 x i17> [[R]]
;
  %shr = lshr <2 x i17> %x, <i17 12, i17 undef>
  %shl = shl <2 x i17> %y, <i17 undef, i17 5>
  %r = or <2 x i17> %shr, %shl
  ret <2 x i17> %r
}

define <2 x i17> @fshr_v2i17_constant_splat_undef1(<2 x i17> %x, <2 x i17> %y) {
; CHECK-LABEL: @fshr_v2i17_constant_splat_undef1(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i17> @llvm.fshl.v2i17(<2 x i17> [[Y:%.*]], <2 x i17> [[X:%.*]], <2 x i17> <i17 5, i17 5>)
; CHECK-NEXT:    ret <2 x i17> [[R]]
;
  %shr = lshr <2 x i17> %x, <i17 12, i17 undef>
  %shl = shl <2 x i17> %y, <i17 5, i17 undef>
  %r = or <2 x i17> %shr, %shl
  ret <2 x i17> %r
}

; Allow arbitrary shift constants.
; Support undef elements.

define <2 x i32> @fshr_v2i32_constant_nonsplat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @fshr_v2i32_constant_nonsplat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[Y:%.*]], <2 x i32> [[X:%.*]], <2 x i32> <i32 15, i32 13>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shr = lshr <2 x i32> %x, <i32 17, i32 19>
  %shl = shl <2 x i32> %y, <i32 15, i32 13>
  %r = or <2 x i32> %shl, %shr
  ret <2 x i32> %r
}

define <2 x i32> @fshr_v2i32_constant_nonsplat_undef0(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @fshr_v2i32_constant_nonsplat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[Y:%.*]], <2 x i32> [[X:%.*]], <2 x i32> <i32 0, i32 13>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shr = lshr <2 x i32> %x, <i32 undef, i32 19>
  %shl = shl <2 x i32> %y, <i32 15, i32 13>
  %r = or <2 x i32> %shl, %shr
  ret <2 x i32> %r
}

define <2 x i32> @fshr_v2i32_constant_nonsplat_undef1(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @fshr_v2i32_constant_nonsplat_undef1(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[Y:%.*]], <2 x i32> [[X:%.*]], <2 x i32> <i32 15, i32 0>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shr = lshr <2 x i32> %x, <i32 17, i32 19>
  %shl = shl <2 x i32> %y, <i32 15, i32 undef>
  %r = or <2 x i32> %shl, %shr
  ret <2 x i32> %r
}

define <2 x i36> @fshl_v2i36_constant_nonsplat(<2 x i36> %x, <2 x i36> %y) {
; CHECK-LABEL: @fshl_v2i36_constant_nonsplat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i36> @llvm.fshl.v2i36(<2 x i36> [[X:%.*]], <2 x i36> [[Y:%.*]], <2 x i36> <i36 21, i36 11>)
; CHECK-NEXT:    ret <2 x i36> [[R]]
;
  %shl = shl <2 x i36> %x, <i36 21, i36 11>
  %shr = lshr <2 x i36> %y, <i36 15, i36 25>
  %r = or <2 x i36> %shl, %shr
  ret <2 x i36> %r
}

define <3 x i36> @fshl_v3i36_constant_nonsplat_undef0(<3 x i36> %x, <3 x i36> %y) {
; CHECK-LABEL: @fshl_v3i36_constant_nonsplat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <3 x i36> @llvm.fshl.v3i36(<3 x i36> [[X:%.*]], <3 x i36> [[Y:%.*]], <3 x i36> <i36 21, i36 11, i36 0>)
; CHECK-NEXT:    ret <3 x i36> [[R]]
;
  %shl = shl <3 x i36> %x, <i36 21, i36 11, i36 undef>
  %shr = lshr <3 x i36> %y, <i36 15, i36 25, i36 undef>
  %r = or <3 x i36> %shl, %shr
  ret <3 x i36> %r
}

; Fold or(shl(x,a),lshr(y,bw-a)) -> fshl(x,y,a) iff a < bw

define i64 @fshl_sub_mask(i64 %x, i64 %y, i64 %a) {
; CHECK-LABEL: @fshl_sub_mask(
; CHECK-NEXT:    [[R:%.*]] = call i64 @llvm.fshl.i64(i64 [[X:%.*]], i64 [[Y:%.*]], i64 [[A:%.*]])
; CHECK-NEXT:    ret i64 [[R]]
;
  %mask = and i64 %a, 63
  %shl = shl i64 %x, %mask
  %sub = sub nuw nsw i64 64, %mask
  %shr = lshr i64 %y, %sub
  %r = or i64 %shl, %shr
  ret i64 %r
}

; Fold or(lshr(v,a),shl(v,bw-a)) -> fshr(y,x,a) iff a < bw

define i64 @fshr_sub_mask(i64 %x, i64 %y, i64 %a) {
; CHECK-LABEL: @fshr_sub_mask(
; CHECK-NEXT:    [[R:%.*]] = call i64 @llvm.fshr.i64(i64 [[Y:%.*]], i64 [[X:%.*]], i64 [[A:%.*]])
; CHECK-NEXT:    ret i64 [[R]]
;
  %mask = and i64 %a, 63
  %shr = lshr i64 %x, %mask
  %sub = sub nuw nsw i64 64, %mask
  %shl = shl i64 %y, %sub
  %r = or i64 %shl, %shr
  ret i64 %r
}

define <2 x i64> @fshr_sub_mask_vector(<2 x i64> %x, <2 x i64> %y, <2 x i64> %a) {
; CHECK-LABEL: @fshr_sub_mask_vector(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> [[Y:%.*]], <2 x i64> [[X:%.*]], <2 x i64> [[A:%.*]])
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %mask = and <2 x i64> %a, <i64 63, i64 63>
  %shr = lshr <2 x i64> %x, %mask
  %sub = sub nuw nsw <2 x i64> <i64 64, i64 64>, %mask
  %shl = shl <2 x i64> %y, %sub
  %r = or <2 x i64> %shl, %shr
  ret <2 x i64> %r
}

; PR35155 - these are optionally UB-free funnel shift left/right patterns that are narrowed to a smaller bitwidth.

define i16 @fshl_16bit(i16 %x, i16 %y, i32 %shift) {
; CHECK-LABEL: @fshl_16bit(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHIFT:%.*]] to i16
; CHECK-NEXT:    [[CONV2:%.*]] = call i16 @llvm.fshl.i16(i16 [[X:%.*]], i16 [[Y:%.*]], i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[CONV2]]
;
  %and = and i32 %shift, 15
  %convx = zext i16 %x to i32
  %shl = shl i32 %convx, %and
  %sub = sub i32 16, %and
  %convy = zext i16 %y to i32
  %shr = lshr i32 %convy, %sub
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i16
  ret i16 %conv2
}

; Commute the 'or' operands and try a vector type.

define <2 x i16> @fshl_commute_16bit_vec(<2 x i16> %x, <2 x i16> %y, <2 x i32> %shift) {
; CHECK-LABEL: @fshl_commute_16bit_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <2 x i32> [[SHIFT:%.*]] to <2 x i16>
; CHECK-NEXT:    [[CONV2:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> [[TMP1]])
; CHECK-NEXT:    ret <2 x i16> [[CONV2]]
;
  %and = and <2 x i32> %shift, <i32 15, i32 15>
  %convx = zext <2 x i16> %x to <2 x i32>
  %shl = shl <2 x i32> %convx, %and
  %sub = sub <2 x i32> <i32 16, i32 16>, %and
  %convy = zext <2 x i16> %y to <2 x i32>
  %shr = lshr <2 x i32> %convy, %sub
  %or = or <2 x i32> %shl, %shr
  %conv2 = trunc <2 x i32> %or to <2 x i16>
  ret <2 x i16> %conv2
}

; Change the size, shift direction (the subtract is on the left-shift), and mask op.

define i8 @fshr_8bit(i8 %x, i8 %y, i3 %shift) {
; CHECK-LABEL: @fshr_8bit(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i3 [[SHIFT:%.*]] to i8
; CHECK-NEXT:    [[CONV2:%.*]] = call i8 @llvm.fshr.i8(i8 [[Y:%.*]], i8 [[X:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    ret i8 [[CONV2]]
;
  %and = zext i3 %shift to i32
  %convx = zext i8 %x to i32
  %shr = lshr i32 %convx, %and
  %sub = sub i32 8, %and
  %convy = zext i8 %y to i32
  %shl = shl i32 %convy, %sub
  %or = or i32 %shl, %shr
  %conv2 = trunc i32 %or to i8
  ret i8 %conv2
}

; The shifted value does not need to be a zexted value; here it is masked.
; The shift mask could be less than the bitwidth, but this is still ok.

define i8 @fshr_commute_8bit(i32 %x, i32 %y, i32 %shift) {
; CHECK-LABEL: @fshr_commute_8bit(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHIFT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], 3
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[Y:%.*]] to i8
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i32 [[X:%.*]] to i8
; CHECK-NEXT:    [[CONV2:%.*]] = call i8 @llvm.fshr.i8(i8 [[TMP3]], i8 [[TMP4]], i8 [[TMP2]])
; CHECK-NEXT:    ret i8 [[CONV2]]
;
  %and = and i32 %shift, 3
  %convx = and i32 %x, 255
  %shr = lshr i32 %convx, %and
  %sub = sub i32 8, %and
  %convy = and i32 %y, 255
  %shl = shl i32 %convy, %sub
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i8
  ret i8 %conv2
}

; Convert select pattern to funnel shift that ends in 'or'.

define i8 @fshr_select(i8 %x, i8 %y, i8 %shamt) {
; CHECK-LABEL: @fshr_select(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[SHAMT:%.*]], 0
; CHECK-NEXT:    [[SUB:%.*]] = sub i8 8, [[SHAMT]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i8 [[Y:%.*]], [[SHAMT]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i8 [[X:%.*]], [[SUB]]
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[SHL]], [[SHR]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP]], i8 [[Y]], i8 [[OR]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %cmp = icmp eq i8 %shamt, 0
  %sub = sub i8 8, %shamt
  %shr = lshr i8 %y, %shamt
  %shl = shl i8 %x, %sub
  %or = or i8 %shl, %shr
  %r = select i1 %cmp, i8 %y, i8 %or
  ret i8 %r
}

; Convert select pattern to funnel shift that ends in 'or'.

define i16 @fshl_select(i16 %x, i16 %y, i16 %shamt) {
; CHECK-LABEL: @fshl_select(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[SHAMT:%.*]], 0
; CHECK-NEXT:    [[SUB:%.*]] = sub i16 16, [[SHAMT]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i16 [[Y:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i16 [[X:%.*]], [[SHAMT]]
; CHECK-NEXT:    [[OR:%.*]] = or i16 [[SHR]], [[SHL]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP]], i16 [[X]], i16 [[OR]]
; CHECK-NEXT:    ret i16 [[R]]
;
  %cmp = icmp eq i16 %shamt, 0
  %sub = sub i16 16, %shamt
  %shr = lshr i16 %y, %sub
  %shl = shl i16 %x, %shamt
  %or = or i16 %shr, %shl
  %r = select i1 %cmp, i16 %x, i16 %or
  ret i16 %r
}

; Convert select pattern to funnel shift that ends in 'or'.

define <2 x i64> @fshl_select_vector(<2 x i64> %x, <2 x i64> %y, <2 x i64> %shamt) {
; CHECK-LABEL: @fshl_select_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i64> [[SHAMT:%.*]], zeroinitializer
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i64> <i64 64, i64 64>, [[SHAMT]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr <2 x i64> [[X:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHL:%.*]] = shl <2 x i64> [[Y:%.*]], [[SHAMT]]
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i64> [[SHL]], [[SHR]]
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP]], <2 x i64> [[Y]], <2 x i64> [[OR]]
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %cmp = icmp eq <2 x i64> %shamt, zeroinitializer
  %sub = sub <2 x i64> <i64 64, i64 64>, %shamt
  %shr = lshr <2 x i64> %x, %sub
  %shl = shl <2 x i64> %y, %shamt
  %or = or <2 x i64> %shl, %shr
  %r = select <2 x i1> %cmp, <2 x i64> %y, <2 x i64> %or
  ret <2 x i64> %r
}
