; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

declare i3 @llvm.cttz.i3(i3, i1)
declare i32 @llvm.cttz.i32(i32, i1 immarg)
declare i32 @llvm.ctlz.i32(i32, i1 immarg)
declare i64 @llvm.cttz.i64(i64, i1 immarg)
declare i64 @llvm.ctlz.i64(i64, i1 immarg)

declare <2 x i32> @llvm.ctlz.v2i32(<2 x i32>, i1)
declare <2 x i32> @llvm.cttz.v2i32(<2 x i32>, i1)


declare void @use(i32)
declare void @use2(i1)

define i32 @select_clz_to_ctz(i32 %a) {
; CHECK-LABEL: @select_clz_to_ctz(
; CHECK-NEXT:    [[COND:%.*]] = call i32 @llvm.cttz.i32(i32 [[A:%.*]], i1 true), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %sub = sub i32 0, %a
  %and = and i32 %sub, %a
  %lz = tail call i32 @llvm.ctlz.i32(i32 %and, i1 true)
  %tobool = icmp eq i32 %a, 0
  %sub1 = xor i32 %lz, 31
  %cond = select i1 %tobool, i32 %lz, i32 %sub1
  ret i32 %cond
}

define i32 @select_clz_to_ctz_preserve_flag(i32 %a) {
; CHECK-LABEL: @select_clz_to_ctz_preserve_flag(
; CHECK-NEXT:    [[COND:%.*]] = call i32 @llvm.cttz.i32(i32 [[A:%.*]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %sub = sub i32 0, %a
  %and = and i32 %sub, %a
  %lz = tail call i32 @llvm.ctlz.i32(i32 %and, i1 false)
  %tobool = icmp eq i32 %a, 0
  %sub1 = xor i32 %lz, 31
  %cond = select i1 %tobool, i32 %lz, i32 %sub1
  ret i32 %cond
}

define <2 x i32> @select_clz_to_ctz_vec(<2 x i32> %a) {
; CHECK-LABEL: @select_clz_to_ctz_vec(
; CHECK-NEXT:    [[COND:%.*]] = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[A:%.*]], i1 true)
; CHECK-NEXT:    ret <2 x i32> [[COND]]
;
  %sub = sub <2 x i32> zeroinitializer, %a
  %and = and <2 x i32> %sub, %a
  %lz = tail call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %and, i1 true)
  %tobool = icmp eq <2 x i32> %a, zeroinitializer
  %sub1 = xor <2 x i32> %lz, <i32 31, i32 31>
  %cond = select <2 x i1> %tobool, <2 x i32> %lz, <2 x i32> %sub1
  ret <2 x i32> %cond
}

define i32 @select_clz_to_ctz_extra_use(i32 %a) {
; CHECK-LABEL: @select_clz_to_ctz_extra_use(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[A:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SUB]], [[A]]
; CHECK-NEXT:    [[LZ:%.*]] = tail call i32 @llvm.ctlz.i32(i32 [[AND]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    [[SUB1:%.*]] = xor i32 [[LZ]], 31
; CHECK-NEXT:    call void @use(i32 [[SUB1]])
; CHECK-NEXT:    [[COND:%.*]] = call i32 @llvm.cttz.i32(i32 [[A]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %sub = sub i32 0, %a
  %and = and i32 %sub, %a
  %lz = tail call i32 @llvm.ctlz.i32(i32 %and, i1 true)
  %tobool = icmp eq i32 %a, 0
  %sub1 = xor i32 %lz, 31
  call void @use(i32 %sub1)
  %cond = select i1 %tobool, i32 %lz, i32 %sub1
  ret i32 %cond
}

define i32 @select_clz_to_ctz_and_commuted(i32 %a) {
; CHECK-LABEL: @select_clz_to_ctz_and_commuted(
; CHECK-NEXT:    [[COND:%.*]] = call i32 @llvm.cttz.i32(i32 [[A:%.*]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %sub = sub i32 0, %a
  %and = and i32 %a, %sub
  %lz = tail call i32 @llvm.ctlz.i32(i32 %and, i1 true)
  %tobool = icmp eq i32 %a, 0
  %sub1 = xor i32 %lz, 31
  %cond = select i1 %tobool, i32 %lz, i32 %sub1
  ret i32 %cond
}

define i32 @select_clz_to_ctz_icmp_ne(i32 %a) {
; CHECK-LABEL: @select_clz_to_ctz_icmp_ne(
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[A:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[TOBOOL]])
; CHECK-NEXT:    [[COND:%.*]] = call i32 @llvm.cttz.i32(i32 [[A]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %sub = sub i32 0, %a
  %and = and i32 %sub, %a
  %lz = tail call i32 @llvm.ctlz.i32(i32 %and, i1 true)
  %tobool = icmp ne i32 %a, 0
  call void @use2(i1 %tobool)
  %sub1 = xor i32 %lz, 31
  %cond = select i1 %tobool, i32 %sub1, i32 %lz
  ret i32 %cond
}

define i64 @select_clz_to_ctz_i64(i64 %a) {
; CHECK-LABEL: @select_clz_to_ctz_i64(
; CHECK-NEXT:    [[COND:%.*]] = call i64 @llvm.cttz.i64(i64 [[A:%.*]], i1 true), !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    ret i64 [[COND]]
;
  %sub = sub i64 0, %a
  %and = and i64 %sub, %a
  %lz = tail call i64 @llvm.ctlz.i64(i64 %and, i1 true)
  %tobool = icmp eq i64 %a, 0
  %sub1 = xor i64 %lz, 63
  %cond = select i1 %tobool, i64 %lz, i64 %sub1
  ret i64 %cond
}

; Negative tests

define i32 @select_clz_to_ctz_wrong_sub(i32 %a) {
; CHECK-LABEL: @select_clz_to_ctz_wrong_sub(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 1, [[A:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SUB]], [[A]]
; CHECK-NEXT:    [[LZ:%.*]] = tail call i32 @llvm.ctlz.i32(i32 [[AND]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[A]], 0
; CHECK-NEXT:    [[SUB1:%.*]] = xor i32 [[LZ]], 31
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[TOBOOL]], i32 [[LZ]], i32 [[SUB1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
  %sub = sub i32 1, %a
  %and = and i32 %sub, %a
  %lz = tail call i32 @llvm.ctlz.i32(i32 %and, i1 true)
  %tobool = icmp eq i32 %a, 0
  %sub1 = xor i32 %lz, 31
  %cond = select i1 %tobool, i32 %lz, i32 %sub1
  ret i32 %cond
}

define i64 @select_clz_to_ctz_i64_wrong_xor(i64 %a) {
; CHECK-LABEL: @select_clz_to_ctz_i64_wrong_xor(
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[A:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[SUB]], [[A]]
; CHECK-NEXT:    [[LZ:%.*]] = tail call i64 @llvm.ctlz.i64(i64 [[AND]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[A]], 0
; CHECK-NEXT:    [[SUB11:%.*]] = or i64 [[LZ]], 64
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[TOBOOL]], i64 [[LZ]], i64 [[SUB11]]
; CHECK-NEXT:    ret i64 [[COND]]
;
  %sub = sub i64 0, %a
  %and = and i64 %sub, %a
  %lz = tail call i64 @llvm.ctlz.i64(i64 %and, i1 true)
  %tobool = icmp eq i64 %a, 0
  %sub1 = xor i64 %lz, 64
  %cond = select i1 %tobool, i64 %lz, i64 %sub1
  ret i64 %cond
}

define i64 @select_clz_to_ctz_i64_wrong_icmp_cst(i64 %a) {
; CHECK-LABEL: @select_clz_to_ctz_i64_wrong_icmp_cst(
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[A:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[SUB]], [[A]]
; CHECK-NEXT:    [[LZ:%.*]] = tail call i64 @llvm.ctlz.i64(i64 [[AND]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[A]], 1
; CHECK-NEXT:    [[SUB1:%.*]] = xor i64 [[LZ]], 63
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[TOBOOL]], i64 [[LZ]], i64 [[SUB1]]
; CHECK-NEXT:    ret i64 [[COND]]
;
  %sub = sub i64 0, %a
  %and = and i64 %sub, %a
  %lz = tail call i64 @llvm.ctlz.i64(i64 %and, i1 true)
  %tobool = icmp eq i64 %a, 1
  %sub1 = xor i64 %lz, 63
  %cond = select i1 %tobool, i64 %lz, i64 %sub1
  ret i64 %cond
}

define i64 @select_clz_to_ctz_i64_wrong_icmp_pred(i64 %a) {
; CHECK-LABEL: @select_clz_to_ctz_i64_wrong_icmp_pred(
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[A:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[SUB]], [[A]]
; CHECK-NEXT:    [[LZ:%.*]] = tail call i64 @llvm.ctlz.i64(i64 [[AND]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp slt i64 [[A]], 0
; CHECK-NEXT:    [[SUB1:%.*]] = xor i64 [[LZ]], 63
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[TOBOOL]], i64 [[LZ]], i64 [[SUB1]]
; CHECK-NEXT:    ret i64 [[COND]]
;
  %sub = sub i64 0, %a
  %and = and i64 %sub, %a
  %lz = tail call i64 @llvm.ctlz.i64(i64 %and, i1 true)
  %tobool = icmp slt i64 %a, 0
  %sub1 = xor i64 %lz, 63
  %cond = select i1 %tobool, i64 %lz, i64 %sub1
  ret i64 %cond
}

define <2 x i32> @select_clz_to_ctz_vec_with_undef(<2 x i32> %a) {
; CHECK-LABEL: @select_clz_to_ctz_vec_with_undef(
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i32> zeroinitializer, [[A:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[SUB]], [[A]]
; CHECK-NEXT:    [[LZ:%.*]] = tail call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> [[AND]], i1 true)
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq <2 x i32> [[A]], zeroinitializer
; CHECK-NEXT:    [[SUB1:%.*]] = xor <2 x i32> [[LZ]], <i32 31, i32 undef>
; CHECK-NEXT:    [[COND:%.*]] = select <2 x i1> [[TOBOOL]], <2 x i32> [[LZ]], <2 x i32> [[SUB1]]
; CHECK-NEXT:    ret <2 x i32> [[COND]]
;
  %sub = sub <2 x i32> zeroinitializer, %a
  %and = and <2 x i32> %sub, %a
  %lz = tail call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %and, i1 true)
  %tobool = icmp eq <2 x i32> %a, zeroinitializer
  %sub1 = xor <2 x i32> %lz, <i32 31, i32 undef>
  %cond = select <2 x i1> %tobool, <2 x i32> %lz, <2 x i32> %sub1
  ret <2 x i32> %cond
}

define i4 @PR45762(i3 %x4) {
; CHECK-LABEL: @PR45762(
; CHECK-NEXT:    [[T4:%.*]] = call i3 @llvm.cttz.i3(i3 [[X4:%.*]], i1 false), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    [[T7:%.*]] = zext i3 [[T4]] to i4
; CHECK-NEXT:    [[ONE_HOT_16:%.*]] = shl i4 1, [[T7]]
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq i3 [[X4]], 0
; CHECK-NEXT:    [[UMUL_23:%.*]] = select i1 [[DOTNOT]], i4 0, i4 [[T7]]
; CHECK-NEXT:    [[SEL_71:%.*]] = shl i4 [[ONE_HOT_16]], [[UMUL_23]]
; CHECK-NEXT:    ret i4 [[SEL_71]]
;
  %t4 = call i3 @llvm.cttz.i3(i3 %x4, i1 false)
  %t5 = icmp eq i3 %x4, 0
  %t6 = select i1 %t5, i3 3, i3 %t4
  %t7 = zext i3 %t6 to i4
  %one_hot_16 = shl i4 1, %t7
  %t8 = lshr i4 %one_hot_16, 0
  %bit_slice_61 = trunc i4 %t8 to i1
  %t9 = lshr i4 %one_hot_16, 1
  %bit_slice_62 = trunc i4 %t9 to i1
  %t10 = lshr i4 %one_hot_16, 2
  %bit_slice_64 = trunc i4 %t10 to i1
  %t11 = or i1 %bit_slice_61, %bit_slice_62
  %or_69 = or i1 %t11, %bit_slice_64
  %umul_23 = mul i4 %one_hot_16, %one_hot_16
  %t12 = icmp eq i1 %or_69, false
  %sel_71 = select i1 %t12, i4 %one_hot_16, i4 %umul_23
  ret i4 %sel_71
}

define i4 @PR45762_logical(i3 %x4) {
; CHECK-LABEL: @PR45762_logical(
; CHECK-NEXT:    [[T4:%.*]] = call i3 @llvm.cttz.i3(i3 [[X4:%.*]], i1 false), !range [[RNG2]]
; CHECK-NEXT:    [[T7:%.*]] = zext i3 [[T4]] to i4
; CHECK-NEXT:    [[ONE_HOT_16:%.*]] = shl i4 1, [[T7]]
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq i3 [[X4]], 0
; CHECK-NEXT:    [[UMUL_23:%.*]] = select i1 [[DOTNOT]], i4 0, i4 [[T7]]
; CHECK-NEXT:    [[SEL_71:%.*]] = shl i4 [[ONE_HOT_16]], [[UMUL_23]]
; CHECK-NEXT:    ret i4 [[SEL_71]]
;
  %t4 = call i3 @llvm.cttz.i3(i3 %x4, i1 false)
  %t5 = icmp eq i3 %x4, 0
  %t6 = select i1 %t5, i3 3, i3 %t4
  %t7 = zext i3 %t6 to i4
  %one_hot_16 = shl i4 1, %t7
  %t8 = lshr i4 %one_hot_16, 0
  %bit_slice_61 = trunc i4 %t8 to i1
  %t9 = lshr i4 %one_hot_16, 1
  %bit_slice_62 = trunc i4 %t9 to i1
  %t10 = lshr i4 %one_hot_16, 2
  %bit_slice_64 = trunc i4 %t10 to i1
  %t11 = select i1 %bit_slice_61, i1 true, i1 %bit_slice_62
  %or_69 = select i1 %t11, i1 true, i1 %bit_slice_64
  %umul_23 = mul i4 %one_hot_16, %one_hot_16
  %t12 = icmp eq i1 %or_69, false
  %sel_71 = select i1 %t12, i4 %one_hot_16, i4 %umul_23
  ret i4 %sel_71
}
