; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare void @use(i32)
declare void @use_vec(<2 x i8>)

define i1 @test_nuw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_and_unsigned_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp ugt i64 [[X:%.*]], 7
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp ult i64 %y, 3
  ret i1 %z
}

define i1 @test_nsw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_nsw_and_signed_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp slt i64 [[X:%.*]], -7
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i64 3, %x
  %z = icmp sgt i64 %y, 10
  ret i1 %z
}

define i1 @test_nuw_nsw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_nsw_and_unsigned_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp ugt i64 [[X:%.*]], 6
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw nsw i64 10, %x
  %z = icmp ule i64 %y, 3
  ret i1 %z
}

define i1 @test_nuw_nsw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_nuw_nsw_and_signed_pred(
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i64 [[X:%.*]], 7
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw nsw i64 10, %x
  %z = icmp slt i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_nuw_and_signed_pred(i64 %x) {
; CHECK-LABEL: @test_negative_nuw_and_signed_pred(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add nuw i64 [[X:%.*]], -11
; CHECK-NEXT:    [[Z:%.*]] = icmp sgt i64 [[NOTSUB]], -4
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nuw i64 10, %x
  %z = icmp slt i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_nsw_and_unsigned_pred(i64 %x) {
; CHECK-LABEL: @test_negative_nsw_and_unsigned_pred(
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[X:%.*]], -8
; CHECK-NEXT:    [[Z:%.*]] = icmp ult i64 [[TMP1]], 3
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = sub nsw i64 10, %x
  %z = icmp ult i64 %y, 3
  ret i1 %z
}

define i1 @test_negative_combined_sub_unsigned_overflow(i64 %x) {
; CHECK-LABEL: @test_negative_combined_sub_unsigned_overflow(
; CHECK-NEXT:    ret i1 true
;
  %y = sub nuw i64 10, %x
  %z = icmp ult i64 %y, 11
  ret i1 %z
}

define i1 @test_negative_combined_sub_signed_overflow(i8 %x) {
; CHECK-LABEL: @test_negative_combined_sub_signed_overflow(
; CHECK-NEXT:    ret i1 false
;
  %y = sub nsw i8 127, %x
  %z = icmp slt i8 %y, -1
  ret i1 %z
}

define i1 @test_sub_0_Y_eq_0(i8 %y) {
; CHECK-LABEL: @test_sub_0_Y_eq_0(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 0, %y
  %z = icmp eq i8 %s, 0
  ret i1 %z
}

define i1 @test_sub_0_Y_ne_0(i8 %y) {
; CHECK-LABEL: @test_sub_0_Y_ne_0(
; CHECK-NEXT:    [[Z:%.*]] = icmp ne i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 0, %y
  %z = icmp ne i8 %s, 0
  ret i1 %z
}

define i1 @test_sub_4_Y_ne_4(i8 %y) {
; CHECK-LABEL: @test_sub_4_Y_ne_4(
; CHECK-NEXT:    [[Z:%.*]] = icmp ne i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 4, %y
  %z = icmp ne i8 %s, 4
  ret i1 %z
}

define i1 @test_sub_127_Y_eq_127(i8 %y) {
; CHECK-LABEL: @test_sub_127_Y_eq_127(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 127, %y
  %z = icmp eq i8 %s, 127
  ret i1 %z
}

define i1 @test_sub_255_Y_eq_255(i8 %y) {
; CHECK-LABEL: @test_sub_255_Y_eq_255(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[Z]]
;
  %s = sub i8 255, %y
  %z = icmp eq i8 %s, 255
  ret i1 %z
}
define <2 x i1> @test_sub_255_Y_eq_255_vec(<2 x i8> %y) {
; CHECK-LABEL: @test_sub_255_Y_eq_255_vec(
; CHECK-NEXT:    [[Z:%.*]] = icmp eq <2 x i8> [[Y:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[Z]]
;
  %s = sub <2 x i8> <i8 255, i8 255>, %y
  %z = icmp eq <2 x i8> %s, <i8 255, i8 255>
  ret <2 x i1> %z
}

define <2 x i1> @icmp_eq_sub_undef(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_undef(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[A:%.*]], <i32 5, i32 undef>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 undef>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 10>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_sub_non_splat(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_non_splat(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[A:%.*]], <i32 5, i32 6>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 16>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 10>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_sub_undef2(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_undef2(
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i32> <i32 15, i32 15>, [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[SUB]], <i32 10, i32 undef>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 15>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 undef>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_sub_non_splat2(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_sub_non_splat2(
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i32> <i32 15, i32 15>, [[A:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[SUB]], <i32 10, i32 11>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %sub = sub <2 x i32> <i32 15, i32 15>, %a
  %cmp = icmp eq <2 x i32> %sub, <i32 10, i32 11>
  ret <2 x i1> %cmp
}

define i1 @neg_sgt_42(i32 %x) {
; CHECK-LABEL: @neg_sgt_42(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add i32 [[X:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = icmp slt i32 [[NOTSUB]], -43
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i32 0, %x
  %r = icmp sgt i32 %negx, 42
  ret i1 %r
}

define i1 @neg_eq_43(i32 %x) {
; CHECK-LABEL: @neg_eq_43(
; CHECK-NEXT:    [[NEGX:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[NEGX]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[X]], -43
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i32 0, %x
  call void @use(i32 %negx)
  %r = icmp eq i32 %negx, 43
  ret i1 %r
}

define i1 @neg_ne_44(i32 %x) {
; CHECK-LABEL: @neg_ne_44(
; CHECK-NEXT:    [[NEGX:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[NEGX]])
; CHECK-NEXT:    [[R:%.*]] = icmp ne i32 [[X]], -44
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i32 0, %x
  call void @use(i32 %negx)
  %r = icmp ne i32 %negx, 44
  ret i1 %r
}

define i1 @neg_nsw_eq_45(i32 %x) {
; CHECK-LABEL: @neg_nsw_eq_45(
; CHECK-NEXT:    [[NEGX:%.*]] = sub nsw i32 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[NEGX]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[X]], -45
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub nsw i32 0, %x
  call void @use(i32 %negx)
  %r = icmp eq i32 %negx, 45
  ret i1 %r
}

define i1 @neg_nsw_ne_46(i32 %x) {
; CHECK-LABEL: @neg_nsw_ne_46(
; CHECK-NEXT:    [[NEGX:%.*]] = sub nsw i32 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[NEGX]])
; CHECK-NEXT:    [[R:%.*]] = icmp ne i32 [[X]], -46
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub nsw i32 0, %x
  call void @use(i32 %negx)
  %r = icmp ne i32 %negx, 46
  ret i1 %r
}

define i1 @subC_eq(i32 %x) {
; CHECK-LABEL: @subC_eq(
; CHECK-NEXT:    [[SUBX:%.*]] = sub i32 -2147483648, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[SUBX]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[X]], 2147483605
; CHECK-NEXT:    ret i1 [[R]]
;
  %subx = sub i32 -2147483648, %x
  call void @use(i32 %subx)
  %r = icmp eq i32 %subx, 43
  ret i1 %r
}

define <2 x i1> @subC_ne(<2 x i8> %x) {
; CHECK-LABEL: @subC_ne(
; CHECK-NEXT:    [[SUBX:%.*]] = sub <2 x i8> <i8 -6, i8 -128>, [[X:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[SUBX]])
; CHECK-NEXT:    [[R:%.*]] = icmp ne <2 x i8> [[X]], <i8 38, i8 -84>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %subx = sub <2 x i8> <i8 -6, i8 -128>, %x
  call void @use_vec(<2 x i8> %subx)
  %r = icmp ne <2 x i8> %subx, <i8 -44, i8 -44>
  ret <2 x i1> %r
}

define i1 @subC_nsw_eq(i32 %x) {
; CHECK-LABEL: @subC_nsw_eq(
; CHECK-NEXT:    [[SUBX:%.*]] = sub nsw i32 -100, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[SUBX]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[X]], 2147483548
; CHECK-NEXT:    ret i1 [[R]]
;
  %subx = sub nsw i32 -100, %x
  call void @use(i32 %subx)
  %r = icmp eq i32 %subx, -2147483648
  ret i1 %r
}

define i1 @subC_nsw_ne(i32 %x) {
; CHECK-LABEL: @subC_nsw_ne(
; CHECK-NEXT:    [[SUBX:%.*]] = sub nsw i32 -2147483647, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[SUBX]])
; CHECK-NEXT:    [[R:%.*]] = icmp ne i32 [[X]], 2147483603
; CHECK-NEXT:    ret i1 [[R]]
;
  %subx = sub nsw i32 -2147483647, %x
  call void @use(i32 %subx)
  %r = icmp ne i32 %subx, 46
  ret i1 %r
}

define i1 @neg_slt_42(i128 %x) {
; CHECK-LABEL: @neg_slt_42(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add i128 [[X:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i128 [[NOTSUB]], -43
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i128 0, %x
  %r = icmp slt i128 %negx, 42
  ret i1 %r
}

define <2 x i1> @neg_ugt_42_splat(<2 x i7> %x) {
; CHECK-LABEL: @neg_ugt_42_splat(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add <2 x i7> [[X:%.*]], <i7 -1, i7 -1>
; CHECK-NEXT:    [[R:%.*]] = icmp ult <2 x i7> [[NOTSUB]], <i7 -43, i7 -43>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %negx = sub <2 x i7> zeroinitializer, %x
  %r = icmp ugt <2 x i7> %negx, <i7 42, i7 42>
  ret <2 x i1> %r
}

define i1 @neg_sgt_42_use(i32 %x) {
; CHECK-LABEL: @neg_sgt_42_use(
; CHECK-NEXT:    [[NEGX:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    call void @use(i32 [[NEGX]])
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i32 [[NEGX]], 42
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i32 0, %x
  call void @use(i32 %negx)
  %r = icmp sgt i32 %negx, 42
  ret i1 %r
}

; Test common/edge cases with signed pred.

define i1 @neg_slt_n1(i8 %x) {
; CHECK-LABEL: @neg_slt_n1(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[NOTSUB]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i8 0, %x
  %r = icmp slt i8 %negx, -1
  ret i1 %r
}

define i1 @neg_slt_0(i8 %x) {
; CHECK-LABEL: @neg_slt_0(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[ISNEGNEG:%.*]] = icmp sgt i8 [[NOTSUB]], -1
; CHECK-NEXT:    ret i1 [[ISNEGNEG]]
;
  %negx = sub i8 0, %x
  %isnegneg = icmp slt i8 %negx, 0
  ret i1 %isnegneg
}

define i1 @neg_slt_1(i8 %x) {
; CHECK-LABEL: @neg_slt_1(
; CHECK-NEXT:    [[R:%.*]] = icmp ult i8 [[X:%.*]], -127
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i8 0, %x
  %r = icmp slt i8 %negx, 1
  ret i1 %r
}

define i1 @neg_sgt_n1(i8 %x) {
; CHECK-LABEL: @neg_sgt_n1(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[NOTSUB]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i8 0, %x
  %r = icmp sgt i8 %negx, -1
  ret i1 %r
}

define i1 @neg_sgt_0(i8 %x) {
; CHECK-LABEL: @neg_sgt_0(
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8 [[X:%.*]], -128
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i8 0, %x
  %r = icmp sgt i8 %negx, 0
  ret i1 %r
}

define i1 @neg_sgt_1(i8 %x) {
; CHECK-LABEL: @neg_sgt_1(
; CHECK-NEXT:    [[NOTSUB:%.*]] = add i8 [[X:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[NOTSUB]], -2
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub i8 0, %x
  %r = icmp sgt i8 %negx, 1
  ret i1 %r
}

; Test common/edge cases with signed pred and nsw.

define i1 @neg_nsw_slt_n1(i8 %x) {
; CHECK-LABEL: @neg_nsw_slt_n1(
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub nsw i8 0, %x
  %r = icmp slt i8 %negx, -1
  ret i1 %r
}

define i1 @neg_nsw_slt_0(i8 %x) {
; CHECK-LABEL: @neg_nsw_slt_0(
; CHECK-NEXT:    [[ISNEGNEG:%.*]] = icmp sgt i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[ISNEGNEG]]
;
  %negx = sub nsw i8 0, %x
  %isnegneg = icmp slt i8 %negx, 0
  ret i1 %isnegneg
}

define i1 @neg_nsw_slt_1(i8 %x) {
; CHECK-LABEL: @neg_nsw_slt_1(
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8 [[X:%.*]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub nsw i8 0, %x
  %r = icmp slt i8 %negx, 1
  ret i1 %r
}

define i1 @neg_nsw_sgt_n1(i8 %x) {
; CHECK-LABEL: @neg_nsw_sgt_n1(
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub nsw i8 0, %x
  %r = icmp sgt i8 %negx, -1
  ret i1 %r
}

define i1 @neg_nsw_sgt_0(i8 %x) {
; CHECK-LABEL: @neg_nsw_sgt_0(
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub nsw i8 0, %x
  %r = icmp sgt i8 %negx, 0
  ret i1 %r
}

define i1 @neg_nsw_sgt_1(i8 %x) {
; CHECK-LABEL: @neg_nsw_sgt_1(
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8 [[X:%.*]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %negx = sub nsw i8 0, %x
  %r = icmp sgt i8 %negx, 1
  ret i1 %r
}

define i1 @sub_eq_zero_use(i32 %x, i32 %y) {
; CHECK-LABEL: @sub_eq_zero_use(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(i32 [[SUB]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %sub = sub i32 %x, %y
  call void @use(i32 %sub)
  %r = icmp eq i32 %sub, 0
  ret i1 %r
}

define <2 x i1> @sub_ne_zero_use(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @sub_ne_zero_use(
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[SUB]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq <2 x i8> [[X]], [[Y]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %sub = sub <2 x i8> %x, %y
  call void @use_vec(<2 x i8> %sub)
  %r = icmp eq <2 x i8> %sub, zeroinitializer
  ret <2 x i1> %r
}

define i32 @sub_eq_zero_select(i32 %a, i32 %b, i32* %p) {
; CHECK-LABEL: @sub_eq_zero_select(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i32 [[SUB]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 [[B]]
;
  %sub = sub i32 %a, %b
  store i32 %sub, i32* %p
  %cmp = icmp eq i32 %sub, 0
  %sel = select i1 %cmp, i32 %a, i32 %b
  ret i32 %sel
}
