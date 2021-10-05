; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use1(i1)
declare void @use8(i8)

define i32 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = xor i32 %A, -1
  %C = xor i32 %B, -1
  ret i32 %C
}

define i1 @invert_icmp(i32 %A, i32 %B) {
; CHECK-LABEL: @invert_icmp(
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp sgt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i1 [[CMP_NOT]]
;
  %cmp = icmp sle i32 %A, %B
  %not = xor i1 %cmp, true
  ret i1 %not
}

; PR1570

define i1 @invert_fcmp(float %X, float %Y) {
; CHECK-LABEL: @invert_fcmp(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uge float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp olt float %X, %Y
  %not = xor i1 %cmp, true
  ret i1 %not
}

; PR2298

define i1 @not_not_cmp(i32 %a, i32 %b) {
; CHECK-LABEL: @not_not_cmp(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %nota = xor i32 %a, -1
  %notb = xor i32 %b, -1
  %cmp = icmp slt i32 %nota, %notb
  ret i1 %cmp
}

define <2 x i1> @not_not_cmp_vector(<2 x i32> %a, <2 x i32> %b) {
; CHECK-LABEL: @not_not_cmp_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt <2 x i32> [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %nota = xor <2 x i32> %a, <i32 -1, i32 -1>
  %notb = xor <2 x i32> %b, <i32 -1, i32 -1>
  %cmp = icmp ugt <2 x i32> %nota, %notb
  ret <2 x i1> %cmp
}

define i1 @not_cmp_constant(i32 %a) {
; CHECK-LABEL: @not_cmp_constant(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A:%.*]], -43
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %nota = xor i32 %a, -1
  %cmp = icmp ugt i32 %nota, 42
  ret i1 %cmp
}

define <2 x i1> @not_cmp_constant_vector(<2 x i32> %a) {
; CHECK-LABEL: @not_cmp_constant_vector(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt <2 x i32> [[A:%.*]], <i32 -43, i32 -43>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %nota = xor <2 x i32> %a, <i32 -1, i32 -1>
  %cmp = icmp slt <2 x i32> %nota, <i32 42, i32 42>
  ret <2 x i1> %cmp
}

define <2 x i1> @test7(<2 x i32> %A, <2 x i32> %B) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[COND_NOT:%.*]] = icmp sgt <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[COND_NOT]]
;
  %cond = icmp sle <2 x i32> %A, %B
  %Ret = xor <2 x i1> %cond, <i1 true, i1 true>
  ret <2 x i1> %Ret
}

define i32 @not_ashr_not(i32 %A, i32 %B) {
; CHECK-LABEL: @not_ashr_not(
; CHECK-NEXT:    [[NOT1_NOT:%.*]] = ashr i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[NOT1_NOT]]
;
  %not1 = xor i32 %A, -1
  %ashr = ashr i32 %not1, %B
  %not2 = xor i32 %ashr, -1
  ret i32 %not2
}

define i8 @not_ashr_const(i8 %x) {
; CHECK-LABEL: @not_ashr_const(
; CHECK-NEXT:    [[NOT:%.*]] = lshr i8 41, [[X:%.*]]
; CHECK-NEXT:    ret i8 [[NOT]]
;
  %shr = ashr i8 -42, %x
  %not = xor i8 %shr, -1
  ret i8 %not
}

define <2 x i8> @not_ashr_const_splat(<2 x i8> %x) {
; CHECK-LABEL: @not_ashr_const_splat(
; CHECK-NEXT:    [[NOT:%.*]] = lshr <2 x i8> <i8 41, i8 41>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[NOT]]
;
  %shr = ashr <2 x i8> <i8 -42, i8 -42>, %x
  %not = xor <2 x i8> %shr, <i8 -1, i8 -1>
  ret <2 x i8> %not
}

; We can't get rid of the 'not' on a logical shift of a negative constant.

define i8 @not_lshr_const_negative(i8 %x) {
; CHECK-LABEL: @not_lshr_const_negative(
; CHECK-NEXT:    [[SHR:%.*]] = lshr i8 -42, [[X:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i8 [[SHR]], -1
; CHECK-NEXT:    ret i8 [[NOT]]
;
  %shr = lshr i8 -42, %x
  %not = xor i8 %shr, -1
  ret i8 %not
}

define i8 @not_lshr_const(i8 %x) {
; CHECK-LABEL: @not_lshr_const(
; CHECK-NEXT:    [[NOT:%.*]] = ashr i8 -43, [[X:%.*]]
; CHECK-NEXT:    ret i8 [[NOT]]
;
  %shr = lshr i8 42, %x
  %not = xor i8 %shr, -1
  ret i8 %not
}

define <2 x i8> @not_lshr_const_splat(<2 x i8> %x) {
; CHECK-LABEL: @not_lshr_const_splat(
; CHECK-NEXT:    [[NOT:%.*]] = ashr <2 x i8> <i8 -43, i8 -43>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[NOT]]
;
  %shr = lshr <2 x i8> <i8 42, i8 42>, %x
  %not = xor <2 x i8> %shr, <i8 -1, i8 -1>
  ret <2 x i8> %not
}

define i32 @not_sub(i32 %y) {
; CHECK-LABEL: @not_sub(
; CHECK-NEXT:    [[R:%.*]] = add i32 [[Y:%.*]], -124
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = sub i32 123, %y
  %r = xor i32 %s, -1
  ret i32 %r
}

define i32 @not_sub_extra_use(i32 %y, i32* %p) {
; CHECK-LABEL: @not_sub_extra_use(
; CHECK-NEXT:    [[S:%.*]] = sub i32 123, [[Y:%.*]]
; CHECK-NEXT:    store i32 [[S]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = add i32 [[Y]], -124
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = sub i32 123, %y
  store i32 %s, i32* %p
  %r = xor i32 %s, -1
  ret i32 %r
}

define <2 x i32> @not_sub_splat(<2 x i32> %y) {
; CHECK-LABEL: @not_sub_splat(
; CHECK-NEXT:    [[R:%.*]] = add <2 x i32> [[Y:%.*]], <i32 -124, i32 -124>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %s = sub <2 x i32> <i32 123, i32 123>, %y
  %r = xor <2 x i32> %s, <i32 -1, i32 -1>
  ret <2 x i32> %r
}

define <2 x i32> @not_sub_extra_use_splat(<2 x i32> %y, <2 x i32>* %p) {
; CHECK-LABEL: @not_sub_extra_use_splat(
; CHECK-NEXT:    [[S:%.*]] = sub <2 x i32> <i32 123, i32 123>, [[Y:%.*]]
; CHECK-NEXT:    store <2 x i32> [[S]], <2 x i32>* [[P:%.*]], align 8
; CHECK-NEXT:    [[R:%.*]] = add <2 x i32> [[Y]], <i32 -124, i32 -124>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %s = sub <2 x i32> <i32 123, i32 123>, %y
  store <2 x i32> %s, <2 x i32>* %p
  %r = xor <2 x i32> %s, <i32 -1, i32 -1>
  ret <2 x i32> %r
}

define <2 x i32> @not_sub_vec(<2 x i32> %y) {
; CHECK-LABEL: @not_sub_vec(
; CHECK-NEXT:    [[R:%.*]] = add <2 x i32> [[Y:%.*]], <i32 -43, i32 -124>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %s = sub <2 x i32> <i32 42, i32 123>, %y
  %r = xor <2 x i32> %s, <i32 -1, i32 -1>
  ret <2 x i32> %r
}

define <2 x i32> @not_sub_extra_use_vec(<2 x i32> %y, <2 x i32>* %p) {
; CHECK-LABEL: @not_sub_extra_use_vec(
; CHECK-NEXT:    [[S:%.*]] = sub <2 x i32> <i32 123, i32 42>, [[Y:%.*]]
; CHECK-NEXT:    store <2 x i32> [[S]], <2 x i32>* [[P:%.*]], align 8
; CHECK-NEXT:    [[R:%.*]] = add <2 x i32> [[Y]], <i32 -124, i32 -43>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %s = sub <2 x i32> <i32 123, i32 42>, %y
  store <2 x i32> %s, <2 x i32>* %p
  %r = xor <2 x i32> %s, <i32 -1, i32 -1>
  ret <2 x i32> %r
}

; ~(X + C) --> -X - C - 1 --> -(C + 1) - X

define i32 @not_add(i32 %x) {
; CHECK-LABEL: @not_add(
; CHECK-NEXT:    [[R:%.*]] = sub i32 -124, [[X:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = add i32 %x, 123
  %r = xor i32 %a, -1
  ret i32 %r
}

define <2 x i32> @not_add_splat(<2 x i32> %x) {
; CHECK-LABEL: @not_add_splat(
; CHECK-NEXT:    [[R:%.*]] = sub <2 x i32> <i32 -124, i32 -124>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %a = add <2 x i32> %x, <i32 123, i32 123>
  %r = xor <2 x i32> %a, <i32 -1, i32 -1>
  ret <2 x i32> %r
}

define <2 x i32> @not_add_vec(<2 x i32> %x) {
; CHECK-LABEL: @not_add_vec(
; CHECK-NEXT:    [[R:%.*]] = sub <2 x i32> <i32 -43, i32 -124>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %a = add <2 x i32> %x, <i32 42, i32 123>
  %r = xor <2 x i32> %a, <i32 -1, i32 -1>
  ret <2 x i32> %r
}

define i1 @not_select_cmp_cmp(i32 %x, i32 %y, float %z, float %w, i1 %cond) {
; CHECK-LABEL: @not_select_cmp_cmp(
; CHECK-NEXT:    [[CMPT:%.*]] = icmp sgt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPF:%.*]] = fcmp ole float [[Z:%.*]], [[W:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[CMPT]], i1 [[CMPF]]
; CHECK-NEXT:    ret i1 [[SEL]]
;
  %cmpt = icmp sle i32 %x, %y
  %cmpf = fcmp ugt float %z, %w
  %sel = select i1 %cond, i1 %cmpt, i1 %cmpf
  %not = xor i1 %sel, true
  ret i1 %not
}

; TODO: Missed canonicalization - hoist 'not'?

define i1 @not_select_cmp_cmp_extra_use1(i32 %x, i32 %y, float %z, float %w, i1 %cond) {
; CHECK-LABEL: @not_select_cmp_cmp_extra_use1(
; CHECK-NEXT:    [[CMPT:%.*]] = icmp sle i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMPT]])
; CHECK-NEXT:    [[CMPF:%.*]] = fcmp ugt float [[Z:%.*]], [[W:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[CMPT]], i1 [[CMPF]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpt = icmp sle i32 %x, %y
  call void @use1(i1 %cmpt)
  %cmpf = fcmp ugt float %z, %w
  %sel = select i1 %cond, i1 %cmpt, i1 %cmpf
  %not = xor i1 %sel, true
  ret i1 %not
}

; TODO: Missed canonicalization - hoist 'not'?

define i1 @not_select_cmp_cmp_extra_use2(i32 %x, i32 %y, float %z, float %w, i1 %cond) {
; CHECK-LABEL: @not_select_cmp_cmp_extra_use2(
; CHECK-NEXT:    [[CMPT:%.*]] = icmp sle i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPF:%.*]] = fcmp ugt float [[Z:%.*]], [[W:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMPF]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[CMPT]], i1 [[CMPF]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpt = icmp sle i32 %x, %y
  %cmpf = fcmp ugt float %z, %w
  call void @use1(i1 %cmpf)
  %sel = select i1 %cond, i1 %cmpt, i1 %cmpf
  %not = xor i1 %sel, true
  ret i1 %not
}

; Negative test - extra uses would require more instructions.

define i1 @not_select_cmp_cmp_extra_use3(i32 %x, i32 %y, float %z, float %w, i1 %cond) {
; CHECK-LABEL: @not_select_cmp_cmp_extra_use3(
; CHECK-NEXT:    [[CMPT:%.*]] = icmp sle i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMPT]])
; CHECK-NEXT:    [[CMPF:%.*]] = fcmp ugt float [[Z:%.*]], [[W:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMPF]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[CMPT]], i1 [[CMPF]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpt = icmp sle i32 %x, %y
  call void @use1(i1 %cmpt)
  %cmpf = fcmp ugt float %z, %w
  call void @use1(i1 %cmpf)
  %sel = select i1 %cond, i1 %cmpt, i1 %cmpf
  %not = xor i1 %sel, true
  ret i1 %not
}

; Negative test - extra uses would require more instructions.

define i1 @not_select_cmp_cmp_extra_use4(i32 %x, i32 %y, float %z, float %w, i1 %cond) {
; CHECK-LABEL: @not_select_cmp_cmp_extra_use4(
; CHECK-NEXT:    [[CMPT:%.*]] = icmp sle i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[CMPF:%.*]] = fcmp ugt float [[Z:%.*]], [[W:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[CMPT]], i1 [[CMPF]]
; CHECK-NEXT:    call void @use1(i1 [[SEL]])
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpt = icmp sle i32 %x, %y
  %cmpf = fcmp ugt float %z, %w
  %sel = select i1 %cond, i1 %cmpt, i1 %cmpf
  call void @use1(i1 %sel)
  %not = xor i1 %sel, true
  ret i1 %not
}

; TODO: Missed canonicalization - hoist 'not'?

define i1 @not_select_cmpt(double %x, double %y, i1 %z, i1 %cond) {
; CHECK-LABEL: @not_select_cmpt(
; CHECK-NEXT:    [[CMPT:%.*]] = fcmp oeq double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[CMPT]], i1 [[Z:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpt = fcmp oeq double %x, %y
  %sel = select i1 %cond, i1 %cmpt, i1 %z
  %not = xor i1 %sel, true
  ret i1 %not
}

; TODO: Missed canonicalization - hoist 'not'?

define i1 @not_select_cmpf(i1 %x, i32 %z, i32 %w, i1 %cond) {
; CHECK-LABEL: @not_select_cmpf(
; CHECK-NEXT:    [[CMPF:%.*]] = icmp ugt i32 [[Z:%.*]], [[W:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[X:%.*]], i1 [[CMPF]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpf = icmp ugt i32 %z, %w
  %sel = select i1 %cond, i1 %x, i1 %cmpf
  %not = xor i1 %sel, true
  ret i1 %not
}

define i1 @not_select_cmpt_extra_use(double %x, double %y, i1 %z, i1 %cond) {
; CHECK-LABEL: @not_select_cmpt_extra_use(
; CHECK-NEXT:    [[CMPT:%.*]] = fcmp oeq double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMPT]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[CMPT]], i1 [[Z:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpt = fcmp oeq double %x, %y
  call void @use1(i1 %cmpt)
  %sel = select i1 %cond, i1 %cmpt, i1 %z
  %not = xor i1 %sel, true
  ret i1 %not
}

define i1 @not_select_cmpf_extra_use(i1 %x, i32 %z, i32 %w, i1 %cond) {
; CHECK-LABEL: @not_select_cmpf_extra_use(
; CHECK-NEXT:    [[CMPF:%.*]] = icmp ugt i32 [[Z:%.*]], [[W:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMPF]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[COND:%.*]], i1 [[X:%.*]], i1 [[CMPF]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[NOT]]
;
  %cmpf = icmp ugt i32 %z, %w
  call void @use1(i1 %cmpf)
  %sel = select i1 %cond, i1 %x, i1 %cmpf
  %not = xor i1 %sel, true
  ret i1 %not
}

define i8 @not_or_neg(i8 %x, i8 %y)  {
; CHECK-LABEL: @not_or_neg(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    [[NOT:%.*]] = and i8 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i8 [[NOT]]
;
  %s = sub i8 0, %y
  %o = or i8 %s, %x
  %not = xor i8 %o, -1
  ret i8 %not
}

define <3 x i5> @not_or_neg_commute_vec(<3 x i5> %x, <3 x i5> %p)  {
; CHECK-LABEL: @not_or_neg_commute_vec(
; CHECK-NEXT:    [[Y:%.*]] = mul <3 x i5> [[P:%.*]], <i5 1, i5 2, i5 3>
; CHECK-NEXT:    [[TMP1:%.*]] = add <3 x i5> [[X:%.*]], <i5 -1, i5 -1, i5 -1>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <3 x i5> [[Y]], <i5 -1, i5 -1, i5 -1>
; CHECK-NEXT:    [[NOT:%.*]] = and <3 x i5> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <3 x i5> [[NOT]]
;
  %y = mul <3 x i5> %p, <i5 1, i5 2, i5 3> ; thwart complexity-based-canonicalization
  %s = sub <3 x i5> <i5 0, i5 0, i5 undef>, %x
  %o = or <3 x i5> %y, %s
  %not = xor <3 x i5> %o, <i5 -1, i5 undef, i5 -1>
  ret <3 x i5> %not
}

; negative test

define i8 @not_or_neg_use1(i8 %x, i8 %y)  {
; CHECK-LABEL: @not_or_neg_use1(
; CHECK-NEXT:    [[S:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[S]])
; CHECK-NEXT:    [[O:%.*]] = or i8 [[S]], [[X:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i8 [[O]], -1
; CHECK-NEXT:    ret i8 [[NOT]]
;
  %s = sub i8 0, %y
  call void @use8(i8 %s)
  %o = or i8 %s, %x
  %not = xor i8 %o, -1
  ret i8 %not
}

; negative test

define i8 @not_or_neg_use2(i8 %x, i8 %y)  {
; CHECK-LABEL: @not_or_neg_use2(
; CHECK-NEXT:    [[S:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    [[O:%.*]] = or i8 [[S]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[O]])
; CHECK-NEXT:    [[NOT:%.*]] = xor i8 [[O]], -1
; CHECK-NEXT:    ret i8 [[NOT]]
;
  %s = sub i8 0, %y
  %o = or i8 %s, %x
  call void @use8(i8 %o)
  %not = xor i8 %o, -1
  ret i8 %not
}

define i1 @not_select_bool(i1 %x, i1 %y, i1 %z) {
; CHECK-LABEL: @not_select_bool(
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[X:%.*]], i1 [[Y:%.*]], i1 [[Z:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[R]]
;
  %sel = select i1 %x, i1 %y, i1 %z
  %r = xor i1 %sel, true
  ret i1 %r
}

define i1 @not_select_bool_const1(i1 %x, i1 %y) {
; CHECK-LABEL: @not_select_bool_const1(
; CHECK-NEXT:    [[NOT_X:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[NOT_X]], i1 true, i1 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[R]]
;
  %sel = select i1 %x, i1 %y, i1 true
  %r = xor i1 %sel, true
  ret i1 %r
}

define i1 @not_select_bool_const2(i1 %x, i1 %y) {
; CHECK-LABEL: @not_select_bool_const2(
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[X:%.*]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[R]]
;
  %sel = select i1 %x, i1 %y, i1 false
  %r = xor i1 %sel, true
  ret i1 %r
}

define i1 @not_select_bool_const3(i1 %x, i1 %y) {
; CHECK-LABEL: @not_select_bool_const3(
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[X:%.*]], i1 true, i1 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[R]]
;
  %sel = select i1 %x, i1 true, i1 %y
  %r = xor i1 %sel, true
  ret i1 %r
}

define i1 @not_select_bool_const4(i1 %x, i1 %y) {
; CHECK-LABEL: @not_select_bool_const4(
; CHECK-NEXT:    [[NOT_X:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[NOT_X]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[SEL]], true
; CHECK-NEXT:    ret i1 [[R]]
;
  %sel = select i1 %x, i1 false, i1 %y
  %r = xor i1 %sel, true
  ret i1 %r
}

define <2 x i1> @not_logicalAnd_not_op0(<2 x i1> %x, <2 x i1> %y) {
; CHECK-LABEL: @not_logicalAnd_not_op0(
; CHECK-NEXT:    [[NOTX:%.*]] = xor <2 x i1> [[X:%.*]], <i1 true, i1 true>
; CHECK-NEXT:    [[AND:%.*]] = select <2 x i1> [[NOTX]], <2 x i1> [[Y:%.*]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[NOTAND:%.*]] = xor <2 x i1> [[AND]], <i1 true, i1 true>
; CHECK-NEXT:    ret <2 x i1> [[NOTAND]]
;
  %notx = xor <2 x i1> %x, <i1 true, i1 true>
  %and = select <2 x i1> %notx, <2 x i1> %y, <2 x i1> zeroinitializer
  %notand = xor <2 x i1> %and, <i1 true, i1 true>
  ret <2 x i1> %notand
}

define i1 @not_logicalAnd_not_op1(i1 %x, i1 %y) {
; CHECK-LABEL: @not_logicalAnd_not_op1(
; CHECK-NEXT:    [[NOT_X:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    [[NOTAND:%.*]] = select i1 [[NOT_X]], i1 true, i1 [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[NOTAND]]
;
  %noty = xor i1 %y, true
  %and = select i1 %x, i1 %noty, i1 false
  %notand = xor i1 %and, true
  ret i1 %notand
}

define i1 @not_logicalAnd_not_op0_use1(i1 %x, i1 %y) {
; CHECK-LABEL: @not_logicalAnd_not_op0_use1(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    call void @use1(i1 [[NOTX]])
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[NOTX]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    [[NOTAND:%.*]] = xor i1 [[AND]], true
; CHECK-NEXT:    ret i1 [[NOTAND]]
;
  %notx = xor i1 %x, true
  call void @use1(i1 %notx)
  %and = select i1 %notx, i1 %y, i1 false
  %notand = xor i1 %and, true
  ret i1 %notand
}

define i1 @not_logicalAnd_not_op0_use2(i1 %x, i1 %y) {
; CHECK-LABEL: @not_logicalAnd_not_op0_use2(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[NOTX]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    call void @use1(i1 [[AND]])
; CHECK-NEXT:    [[NOTAND:%.*]] = xor i1 [[AND]], true
; CHECK-NEXT:    ret i1 [[NOTAND]]
;
  %notx = xor i1 %x, true
  %and = select i1 %notx, i1 %y, i1 false
  call void @use1(i1 %and)
  %notand = xor i1 %and, true
  ret i1 %notand
}

define <2 x i1> @not_logicalOr_not_op0(<2 x i1> %x, <2 x i1> %y) {
; CHECK-LABEL: @not_logicalOr_not_op0(
; CHECK-NEXT:    [[NOTX:%.*]] = xor <2 x i1> [[X:%.*]], <i1 true, i1 true>
; CHECK-NEXT:    [[OR:%.*]] = select <2 x i1> [[NOTX]], <2 x i1> <i1 true, i1 true>, <2 x i1> [[Y:%.*]]
; CHECK-NEXT:    [[NOTOR:%.*]] = xor <2 x i1> [[OR]], <i1 true, i1 true>
; CHECK-NEXT:    ret <2 x i1> [[NOTOR]]
;
  %notx = xor <2 x i1> %x, <i1 true, i1 true>
  %or = select <2 x i1> %notx, <2 x i1> <i1 true, i1 true>, <2 x i1> %y
  %notor = xor <2 x i1> %or, <i1 true, i1 true>
  ret <2 x i1> %notor
}

define i1 @not_logicalOr_not_op1(i1 %x, i1 %y) {
; CHECK-LABEL: @not_logicalOr_not_op1(
; CHECK-NEXT:    [[NOT_X:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    [[NOTOR:%.*]] = select i1 [[NOT_X]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    ret i1 [[NOTOR]]
;
  %noty = xor i1 %y, true
  %or = select i1 %x, i1 true, i1 %noty
  %notor = xor i1 %or, true
  ret i1 %notor
}

define i1 @not_logicalOr_not_op0_use1(i1 %x, i1 %y) {
; CHECK-LABEL: @not_logicalOr_not_op0_use1(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    call void @use1(i1 [[NOTX]])
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[NOTX]], i1 true, i1 [[Y:%.*]]
; CHECK-NEXT:    [[NOTOR:%.*]] = xor i1 [[OR]], true
; CHECK-NEXT:    ret i1 [[NOTOR]]
;
  %notx = xor i1 %x, true
  call void @use1(i1 %notx)
  %or = select i1 %notx, i1 true, i1 %y
  %notor = xor i1 %or, true
  ret i1 %notor
}

define i1 @not_logicalOr_not_op0_use2(i1 %x, i1 %y) {
; CHECK-LABEL: @not_logicalOr_not_op0_use2(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i1 [[X:%.*]], true
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[NOTX]], i1 true, i1 [[Y:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[OR]])
; CHECK-NEXT:    [[NOTOR:%.*]] = xor i1 [[OR]], true
; CHECK-NEXT:    ret i1 [[NOTOR]]
;
  %notx = xor i1 %x, true
  %or = select i1 %notx, i1 true, i1 %y
  call void @use1(i1 %or)
  %notor = xor i1 %or, true
  ret i1 %notor
}
