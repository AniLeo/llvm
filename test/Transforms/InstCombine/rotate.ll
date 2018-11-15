; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

; These may be UB-free rotate left/right patterns that are narrowed to a smaller bitwidth.
; See PR34046, PR16726, and PR39624 for motivating examples:
; https://bugs.llvm.org/show_bug.cgi?id=34046
; https://bugs.llvm.org/show_bug.cgi?id=16726
; https://bugs.llvm.org/show_bug.cgi?id=39624

define i16 @rotate_left_16bit(i16 %v, i32 %shift) {
; CHECK-LABEL: @rotate_left_16bit(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHIFT:%.*]] to i16
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[TMP1]], 15
; CHECK-NEXT:    [[TMP3:%.*]] = sub i16 0, [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = and i16 [[TMP3]], 15
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i16 [[V:%.*]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = shl i16 [[V]], [[TMP2]]
; CHECK-NEXT:    [[CONV2:%.*]] = or i16 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret i16 [[CONV2]]
;
  %and = and i32 %shift, 15
  %conv = zext i16 %v to i32
  %shl = shl i32 %conv, %and
  %sub = sub i32 16, %and
  %shr = lshr i32 %conv, %sub
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i16
  ret i16 %conv2
}

; Commute the 'or' operands and try a vector type.

define <2 x i16> @rotate_left_commute_16bit_vec(<2 x i16> %v, <2 x i32> %shift) {
; CHECK-LABEL: @rotate_left_commute_16bit_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <2 x i32> [[SHIFT:%.*]] to <2 x i16>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i16> [[TMP1]], <i16 15, i16 15>
; CHECK-NEXT:    [[TMP3:%.*]] = sub <2 x i16> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = and <2 x i16> [[TMP3]], <i16 15, i16 15>
; CHECK-NEXT:    [[TMP5:%.*]] = shl <2 x i16> [[V:%.*]], [[TMP2]]
; CHECK-NEXT:    [[TMP6:%.*]] = lshr <2 x i16> [[V]], [[TMP4]]
; CHECK-NEXT:    [[CONV2:%.*]] = or <2 x i16> [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret <2 x i16> [[CONV2]]
;
  %and = and <2 x i32> %shift, <i32 15, i32 15>
  %conv = zext <2 x i16> %v to <2 x i32>
  %shl = shl <2 x i32> %conv, %and
  %sub = sub <2 x i32> <i32 16, i32 16>, %and
  %shr = lshr <2 x i32> %conv, %sub
  %or = or <2 x i32> %shl, %shr
  %conv2 = trunc <2 x i32> %or to <2 x i16>
  ret <2 x i16> %conv2
}

; Change the size, rotation direction (the subtract is on the left-shift), and mask op.

define i8 @rotate_right_8bit(i8 %v, i3 %shift) {
; CHECK-LABEL: @rotate_right_8bit(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i3 [[SHIFT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = sub i3 0, [[SHIFT]]
; CHECK-NEXT:    [[TMP3:%.*]] = zext i3 [[TMP2]] to i8
; CHECK-NEXT:    [[TMP4:%.*]] = shl i8 [[V:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i8 [[V]], [[TMP1]]
; CHECK-NEXT:    [[CONV2:%.*]] = or i8 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i8 [[CONV2]]
;
  %and = zext i3 %shift to i32
  %conv = zext i8 %v to i32
  %shr = lshr i32 %conv, %and
  %sub = sub i32 8, %and
  %shl = shl i32 %conv, %sub
  %or = or i32 %shl, %shr
  %conv2 = trunc i32 %or to i8
  ret i8 %conv2
}

; The shifted value does not need to be a zexted value; here it is masked.
; The shift mask could be less than the bitwidth, but this is still ok.

define i8 @rotate_right_commute_8bit(i32 %v, i32 %shift) {
; CHECK-LABEL: @rotate_right_commute_8bit(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHIFT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], 3
; CHECK-NEXT:    [[TMP3:%.*]] = sub nsw i8 0, [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = and i8 [[TMP3]], 7
; CHECK-NEXT:    [[TMP5:%.*]] = trunc i32 [[V:%.*]] to i8
; CHECK-NEXT:    [[TMP6:%.*]] = lshr i8 [[TMP5]], [[TMP2]]
; CHECK-NEXT:    [[TMP7:%.*]] = shl i8 [[TMP5]], [[TMP4]]
; CHECK-NEXT:    [[CONV2:%.*]] = or i8 [[TMP6]], [[TMP7]]
; CHECK-NEXT:    ret i8 [[CONV2]]
;
  %and = and i32 %shift, 3
  %conv = and i32 %v, 255
  %shr = lshr i32 %conv, %and
  %sub = sub i32 8, %and
  %shl = shl i32 %conv, %sub
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i8
  ret i8 %conv2
}

; If the original source does not mask the shift amount,
; we still do the transform by adding masks to make it safe.

define i8 @rotate8_not_safe(i8 %v, i32 %shamt) {
; CHECK-LABEL: @rotate8_not_safe(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHAMT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i8 [[TMP1]], 7
; CHECK-NEXT:    [[TMP4:%.*]] = and i8 [[TMP2]], 7
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i8 [[V:%.*]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = shl i8 [[V]], [[TMP3]]
; CHECK-NEXT:    [[RET:%.*]] = or i8 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %conv = zext i8 %v to i32
  %sub = sub i32 8, %shamt
  %shr = lshr i32 %conv, %sub
  %shl = shl i32 %conv, %shamt
  %or = or i32 %shr, %shl
  %ret = trunc i32 %or to i8
  ret i8 %ret
}

; A non-power-of-2 destination type can't be masked as above.

define i9 @rotate9_not_safe(i9 %v, i32 %shamt) {
; CHECK-LABEL: @rotate9_not_safe(
; CHECK-NEXT:    [[CONV:%.*]] = zext i9 [[V:%.*]] to i32
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 9, [[SHAMT:%.*]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[CONV]], [[SUB]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[CONV]], [[SHAMT]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHR]], [[SHL]]
; CHECK-NEXT:    [[RET:%.*]] = trunc i32 [[OR]] to i9
; CHECK-NEXT:    ret i9 [[RET]]
;
  %conv = zext i9 %v to i32
  %sub = sub i32 9, %shamt
  %shr = lshr i32 %conv, %sub
  %shl = shl i32 %conv, %shamt
  %or = or i32 %shr, %shl
  %ret = trunc i32 %or to i9
  ret i9 %ret
}

; We should narrow (v << (s & 15)) | (v >> (-s & 15))
; when both v and s have been promoted.

define i16 @rotateleft_16_neg_mask(i16 %v, i16 %shamt) {
; CHECK-LABEL: @rotateleft_16_neg_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i16 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[SHAMT]], 15
; CHECK-NEXT:    [[TMP3:%.*]] = and i16 [[TMP1]], 15
; CHECK-NEXT:    [[TMP4:%.*]] = lshr i16 [[V:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = shl i16 [[V]], [[TMP2]]
; CHECK-NEXT:    [[RET:%.*]] = or i16 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i16 [[RET]]
;
  %neg = sub i16 0, %shamt
  %lshamt = and i16 %shamt, 15
  %lshamtconv = zext i16 %lshamt to i32
  %rshamt = and i16 %neg, 15
  %rshamtconv = zext i16 %rshamt to i32
  %conv = zext i16 %v to i32
  %shl = shl i32 %conv, %lshamtconv
  %shr = lshr i32 %conv, %rshamtconv
  %or = or i32 %shr, %shl
  %ret = trunc i32 %or to i16
  ret i16 %ret
}

define i16 @rotateleft_16_neg_mask_commute(i16 %v, i16 %shamt) {
; CHECK-LABEL: @rotateleft_16_neg_mask_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i16 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[SHAMT]], 15
; CHECK-NEXT:    [[TMP3:%.*]] = and i16 [[TMP1]], 15
; CHECK-NEXT:    [[TMP4:%.*]] = shl i16 [[V:%.*]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i16 [[V]], [[TMP3]]
; CHECK-NEXT:    [[RET:%.*]] = or i16 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i16 [[RET]]
;
  %neg = sub i16 0, %shamt
  %lshamt = and i16 %shamt, 15
  %lshamtconv = zext i16 %lshamt to i32
  %rshamt = and i16 %neg, 15
  %rshamtconv = zext i16 %rshamt to i32
  %conv = zext i16 %v to i32
  %shl = shl i32 %conv, %lshamtconv
  %shr = lshr i32 %conv, %rshamtconv
  %or = or i32 %shl, %shr
  %ret = trunc i32 %or to i16
  ret i16 %ret
}

define i8 @rotateright_8_neg_mask(i8 %v, i8 %shamt) {
; CHECK-LABEL: @rotateright_8_neg_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[SHAMT]], 7
; CHECK-NEXT:    [[TMP3:%.*]] = and i8 [[TMP1]], 7
; CHECK-NEXT:    [[TMP4:%.*]] = lshr i8 [[V:%.*]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = shl i8 [[V]], [[TMP3]]
; CHECK-NEXT:    [[RET:%.*]] = or i8 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %neg = sub i8 0, %shamt
  %rshamt = and i8 %shamt, 7
  %rshamtconv = zext i8 %rshamt to i32
  %lshamt = and i8 %neg, 7
  %lshamtconv = zext i8 %lshamt to i32
  %conv = zext i8 %v to i32
  %shl = shl i32 %conv, %lshamtconv
  %shr = lshr i32 %conv, %rshamtconv
  %or = or i32 %shr, %shl
  %ret = trunc i32 %or to i8
  ret i8 %ret
}

define i8 @rotateright_8_neg_mask_commute(i8 %v, i8 %shamt) {
; CHECK-LABEL: @rotateright_8_neg_mask_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[SHAMT]], 7
; CHECK-NEXT:    [[TMP3:%.*]] = and i8 [[TMP1]], 7
; CHECK-NEXT:    [[TMP4:%.*]] = shl i8 [[V:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i8 [[V]], [[TMP2]]
; CHECK-NEXT:    [[RET:%.*]] = or i8 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %neg = sub i8 0, %shamt
  %rshamt = and i8 %shamt, 7
  %rshamtconv = zext i8 %rshamt to i32
  %lshamt = and i8 %neg, 7
  %lshamtconv = zext i8 %lshamt to i32
  %conv = zext i8 %v to i32
  %shl = shl i32 %conv, %lshamtconv
  %shr = lshr i32 %conv, %rshamtconv
  %or = or i32 %shl, %shr
  %ret = trunc i32 %or to i8
  ret i8 %ret
}

; The shift amount may already be in the wide type,
; so we need to truncate it going into the rotate pattern.

define i16 @rotateright_16_neg_mask_wide_amount(i16 %v, i32 %shamt) {
; CHECK-LABEL: @rotateright_16_neg_mask_wide_amount(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHAMT:%.*]] to i16
; CHECK-NEXT:    [[TMP2:%.*]] = sub i16 0, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i16 [[TMP1]], 15
; CHECK-NEXT:    [[TMP4:%.*]] = and i16 [[TMP2]], 15
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i16 [[V:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = shl i16 [[V]], [[TMP4]]
; CHECK-NEXT:    [[RET:%.*]] = or i16 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret i16 [[RET]]
;
  %neg = sub i32 0, %shamt
  %rshamt = and i32 %shamt, 15
  %lshamt = and i32 %neg, 15
  %conv = zext i16 %v to i32
  %shl = shl i32 %conv, %lshamt
  %shr = lshr i32 %conv, %rshamt
  %or = or i32 %shr, %shl
  %ret = trunc i32 %or to i16
  ret i16 %ret
}

define i16 @rotateright_16_neg_mask_wide_amount_commute(i16 %v, i32 %shamt) {
; CHECK-LABEL: @rotateright_16_neg_mask_wide_amount_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHAMT:%.*]] to i16
; CHECK-NEXT:    [[TMP2:%.*]] = sub i16 0, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i16 [[TMP1]], 15
; CHECK-NEXT:    [[TMP4:%.*]] = and i16 [[TMP2]], 15
; CHECK-NEXT:    [[TMP5:%.*]] = shl i16 [[V:%.*]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = lshr i16 [[V]], [[TMP3]]
; CHECK-NEXT:    [[RET:%.*]] = or i16 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret i16 [[RET]]
;
  %neg = sub i32 0, %shamt
  %rshamt = and i32 %shamt, 15
  %lshamt = and i32 %neg, 15
  %conv = zext i16 %v to i32
  %shl = shl i32 %conv, %lshamt
  %shr = lshr i32 %conv, %rshamt
  %or = or i32 %shl, %shr
  %ret = trunc i32 %or to i16
  ret i16 %ret
}

define i8 @rotateleft_8_neg_mask_wide_amount(i8 %v, i32 %shamt) {
; CHECK-LABEL: @rotateleft_8_neg_mask_wide_amount(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHAMT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i8 [[TMP1]], 7
; CHECK-NEXT:    [[TMP4:%.*]] = and i8 [[TMP2]], 7
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i8 [[V:%.*]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = shl i8 [[V]], [[TMP3]]
; CHECK-NEXT:    [[RET:%.*]] = or i8 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %neg = sub i32 0, %shamt
  %lshamt = and i32 %shamt, 7
  %rshamt = and i32 %neg, 7
  %conv = zext i8 %v to i32
  %shl = shl i32 %conv, %lshamt
  %shr = lshr i32 %conv, %rshamt
  %or = or i32 %shr, %shl
  %ret = trunc i32 %or to i8
  ret i8 %ret
}

define i8 @rotateleft_8_neg_mask_wide_amount_commute(i8 %v, i32 %shamt) {
; CHECK-LABEL: @rotateleft_8_neg_mask_wide_amount_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHAMT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i8 [[TMP1]], 7
; CHECK-NEXT:    [[TMP4:%.*]] = and i8 [[TMP2]], 7
; CHECK-NEXT:    [[TMP5:%.*]] = shl i8 [[V:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = lshr i8 [[V]], [[TMP4]]
; CHECK-NEXT:    [[RET:%.*]] = or i8 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %neg = sub i32 0, %shamt
  %lshamt = and i32 %shamt, 7
  %rshamt = and i32 %neg, 7
  %conv = zext i8 %v to i32
  %shl = shl i32 %conv, %lshamt
  %shr = lshr i32 %conv, %rshamt
  %or = or i32 %shl, %shr
  %ret = trunc i32 %or to i8
  ret i8 %ret
}

; Non-power-of-2 types. This could be transformed, but it's not a typical rotate pattern.

define i9 @rotateleft_9_neg_mask_wide_amount_commute(i9 %v, i33 %shamt) {
; CHECK-LABEL: @rotateleft_9_neg_mask_wide_amount_commute(
; CHECK-NEXT:    [[NEG:%.*]] = sub i33 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[LSHAMT:%.*]] = and i33 [[SHAMT]], 8
; CHECK-NEXT:    [[RSHAMT:%.*]] = and i33 [[NEG]], 8
; CHECK-NEXT:    [[CONV:%.*]] = zext i9 [[V:%.*]] to i33
; CHECK-NEXT:    [[SHL:%.*]] = shl i33 [[CONV]], [[LSHAMT]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i33 [[CONV]], [[RSHAMT]]
; CHECK-NEXT:    [[OR:%.*]] = or i33 [[SHL]], [[SHR]]
; CHECK-NEXT:    [[RET:%.*]] = trunc i33 [[OR]] to i9
; CHECK-NEXT:    ret i9 [[RET]]
;
  %neg = sub i33 0, %shamt
  %lshamt = and i33 %shamt, 8
  %rshamt = and i33 %neg, 8
  %conv = zext i9 %v to i33
  %shl = shl i33 %conv, %lshamt
  %shr = lshr i33 %conv, %rshamt
  %or = or i33 %shl, %shr
  %ret = trunc i33 %or to i9
  ret i9 %ret
}

; Convert select pattern to masked shift that ends in 'or'.

define i32 @rotr_select(i32 %x, i32 %shamt) {
; CHECK-LABEL: @rotr_select(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[SHAMT]], 31
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP1]], 31
; CHECK-NEXT:    [[TMP4:%.*]] = lshr i32 [[X:%.*]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = shl i32 [[X]], [[TMP3]]
; CHECK-NEXT:    [[R:%.*]] = or i32 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cmp = icmp eq i32 %shamt, 0
  %sub = sub i32 32, %shamt
  %shr = lshr i32 %x, %shamt
  %shl = shl i32 %x, %sub
  %or = or i32 %shr, %shl
  %r = select i1 %cmp, i32 %x, i32 %or
  ret i32 %r
}

; Convert select pattern to masked shift that ends in 'or'.

define i8 @rotr_select_commute(i8 %x, i8 %shamt) {
; CHECK-LABEL: @rotr_select_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i8 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[SHAMT]], 7
; CHECK-NEXT:    [[TMP3:%.*]] = and i8 [[TMP1]], 7
; CHECK-NEXT:    [[TMP4:%.*]] = shl i8 [[X:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = lshr i8 [[X]], [[TMP2]]
; CHECK-NEXT:    [[R:%.*]] = or i8 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %cmp = icmp eq i8 %shamt, 0
  %sub = sub i8 8, %shamt
  %shr = lshr i8 %x, %shamt
  %shl = shl i8 %x, %sub
  %or = or i8 %shl, %shr
  %r = select i1 %cmp, i8 %x, i8 %or
  ret i8 %r
}

; Convert select pattern to masked shift that ends in 'or'.

define i16 @rotl_select(i16 %x, i16 %shamt) {
; CHECK-LABEL: @rotl_select(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i16 0, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[SHAMT]], 15
; CHECK-NEXT:    [[TMP3:%.*]] = and i16 [[TMP1]], 15
; CHECK-NEXT:    [[TMP4:%.*]] = lshr i16 [[X:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = shl i16 [[X]], [[TMP2]]
; CHECK-NEXT:    [[R:%.*]] = or i16 [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret i16 [[R]]
;
  %cmp = icmp eq i16 %shamt, 0
  %sub = sub i16 16, %shamt
  %shr = lshr i16 %x, %sub
  %shl = shl i16 %x, %shamt
  %or = or i16 %shr, %shl
  %r = select i1 %cmp, i16 %x, i16 %or
  ret i16 %r
}

; Convert select pattern to masked shift that ends in 'or'.

define <2 x i64> @rotl_select_commute(<2 x i64> %x, <2 x i64> %shamt) {
; CHECK-LABEL: @rotl_select_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i64> zeroinitializer, [[SHAMT:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i64> [[SHAMT]], <i64 63, i64 63>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i64> [[TMP1]], <i64 63, i64 63>
; CHECK-NEXT:    [[TMP4:%.*]] = shl <2 x i64> [[X:%.*]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = lshr <2 x i64> [[X]], [[TMP3]]
; CHECK-NEXT:    [[R:%.*]] = or <2 x i64> [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %cmp = icmp eq <2 x i64> %shamt, zeroinitializer
  %sub = sub <2 x i64> <i64 64, i64 64>, %shamt
  %shr = lshr <2 x i64> %x, %sub
  %shl = shl <2 x i64> %x, %shamt
  %or = or <2 x i64> %shl, %shr
  %r = select <2 x i1> %cmp, <2 x i64> %x, <2 x i64> %or
  ret <2 x i64> %r
}

; Negative test - the transform is only valid with power-of-2 types.

define i24 @rotl_select_weird_type(i24 %x, i24 %shamt) {
; CHECK-LABEL: @rotl_select_weird_type(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i24 [[SHAMT:%.*]], 0
; CHECK-NEXT:    [[SUB:%.*]] = sub i24 24, [[SHAMT]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i24 [[X:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i24 [[X]], [[SHAMT]]
; CHECK-NEXT:    [[OR:%.*]] = or i24 [[SHL]], [[SHR]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CMP]], i24 [[X]], i24 [[OR]]
; CHECK-NEXT:    ret i24 [[R]]
;
  %cmp = icmp eq i24 %shamt, 0
  %sub = sub i24 24, %shamt
  %shr = lshr i24 %x, %sub
  %shl = shl i24 %x, %shamt
  %or = or i24 %shl, %shr
  %r = select i1 %cmp, i24 %x, i24 %or
  ret i24 %r
}

