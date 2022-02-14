; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

define <2 x i32> @umin_of_nots(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @umin_of_nots(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.umax.v2i32(<2 x i32> [[X:%.*]], <2 x i32> [[Y:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = xor <2 x i32> [[TMP1]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %notx = xor <2 x i32> %x, <i32 -1, i32 -1>
  %noty = xor <2 x i32> %y, <i32 -1, i32 -1>
  %cmp = icmp ult <2 x i32> %notx, %noty
  %min = select <2 x i1> %cmp, <2 x i32> %notx, <2 x i32> %noty
  ret <2 x i32> %min
}

define <2 x i32> @smin_of_nots(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @smin_of_nots(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.smax.v2i32(<2 x i32> [[X:%.*]], <2 x i32> [[Y:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = xor <2 x i32> [[TMP1]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %notx = xor <2 x i32> %x, <i32 -1, i32 -1>
  %noty = xor <2 x i32> %y, <i32 -1, i32 -1>
  %cmp = icmp sle <2 x i32> %notx, %noty
  %min = select <2 x i1> %cmp, <2 x i32> %notx, <2 x i32> %noty
  ret <2 x i32> %min
}

define i32 @compute_min_2(i32 %x, i32 %y) {
; CHECK-LABEL: @compute_min_2(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smin.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %not_x = sub i32 -1, %x
  %not_y = sub i32 -1, %y
  %cmp = icmp sgt i32 %not_x, %not_y
  %not_min = select i1 %cmp, i32 %not_x, i32 %not_y
  %min = sub i32 -1, %not_min
  ret i32 %min
}

declare void @extra_use(i8)
define i8 @umin_not_1_extra_use(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_not_1_extra_use(
; CHECK-NEXT:    [[NX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umax.i8(i8 [[Y:%.*]], i8 [[X]])
; CHECK-NEXT:    [[TMP2:%.*]] = xor i8 [[TMP1]], -1
; CHECK-NEXT:    call void @extra_use(i8 [[NX]])
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %nx = xor i8 %x, -1
  %ny = xor i8 %y, -1
  %cmpxy = icmp ult i8 %nx, %ny
  %minxy = select i1 %cmpxy, i8 %nx, i8 %ny
  call void @extra_use(i8 %nx)
  ret i8 %minxy
}

define i8 @umin_not_2_extra_use(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_not_2_extra_use(
; CHECK-NEXT:    [[NX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    [[NY:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umin.i8(i8 [[NX]], i8 [[NY]])
; CHECK-NEXT:    call void @extra_use(i8 [[NX]])
; CHECK-NEXT:    call void @extra_use(i8 [[NY]])
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %nx = xor i8 %x, -1
  %ny = xor i8 %y, -1
  %cmpxy = icmp ult i8 %nx, %ny
  %minxy = select i1 %cmpxy, i8 %nx, i8 %ny
  call void @extra_use(i8 %nx)
  call void @extra_use(i8 %ny)
  ret i8 %minxy
}

; PR35834 - https://bugs.llvm.org/show_bug.cgi?id=35834

define i8 @umin3_not(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @umin3_not(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umax.i8(i8 [[Y:%.*]], i8 [[X:%.*]])
; CHECK-NEXT:    [[R_V:%.*]] = call i8 @llvm.umax.i8(i8 [[TMP1]], i8 [[Z:%.*]])
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[R_V]], -1
; CHECK-NEXT:    ret i8 [[R]]
;
  %nx = xor i8 %x, -1
  %ny = xor i8 %y, -1
  %nz = xor i8 %z, -1
  %cmpyx = icmp ult i8 %y, %x
  %cmpxz = icmp ult i8 %nx, %nz
  %minxz = select i1 %cmpxz, i8 %nx, i8 %nz
  %cmpyz = icmp ult i8 %ny, %nz
  %minyz = select i1 %cmpyz, i8 %ny, i8 %nz
  %r = select i1 %cmpyx, i8 %minxz, i8 %minyz
  ret i8 %r
}

; PR35875 - https://bugs.llvm.org/show_bug.cgi?id=35875

define i8 @umin3_not_more_uses(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @umin3_not_more_uses(
; CHECK-NEXT:    [[NX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    [[NY:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umax.i8(i8 [[X]], i8 [[Y]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.umax.i8(i8 [[Z:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    call void @extra_use(i8 [[NX]])
; CHECK-NEXT:    call void @extra_use(i8 [[NY]])
; CHECK-NEXT:    ret i8 [[R]]
;
  %nx = xor i8 %x, -1
  %ny = xor i8 %y, -1
  %nz = xor i8 %z, -1
  %cmpxz = icmp ult i8 %nx, %nz
  %minxz = select i1 %cmpxz, i8 %nx, i8 %nz
  %cmpyz = icmp ult i8 %ny, %nz
  %minyz = select i1 %cmpyz, i8 %ny, i8 %nz
  %cmpyx = icmp ult i8 %y, %x
  %r = select i1 %cmpyx, i8 %minxz, i8 %minyz
  call void @extra_use(i8 %nx)
  call void @extra_use(i8 %ny)
  ret i8 %r
}

declare void @use8(i8)

define i8 @umin3_not_all_ops_extra_uses(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @umin3_not_all_ops_extra_uses(
; CHECK-NEXT:    [[XN:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    [[YN:%.*]] = xor i8 [[Y:%.*]], -1
; CHECK-NEXT:    [[ZN:%.*]] = xor i8 [[Z:%.*]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umin.i8(i8 [[XN]], i8 [[ZN]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.umin.i8(i8 [[TMP1]], i8 [[YN]])
; CHECK-NEXT:    call void @use8(i8 [[XN]])
; CHECK-NEXT:    call void @use8(i8 [[YN]])
; CHECK-NEXT:    call void @use8(i8 [[ZN]])
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %xn = xor i8 %x, -1
  %yn = xor i8 %y, -1
  %zn = xor i8 %z, -1
  %cmpxz = icmp ult i8 %xn, %zn
  %minxz = select i1 %cmpxz, i8 %xn, i8 %zn
  %cmpxyz = icmp ult i8 %minxz, %yn
  %minxyz = select i1 %cmpxyz, i8 %minxz, i8 %yn
  call void @use8(i8 %xn)
  call void @use8(i8 %yn)
  call void @use8(i8 %zn)
  ret i8 %minxyz
}

define i32 @compute_min_3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @compute_min_3(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smin.i32(i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.smin.i32(i32 [[TMP1]], i32 [[Z:%.*]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %not_x = sub i32 -1, %x
  %not_y = sub i32 -1, %y
  %not_z = sub i32 -1, %z
  %cmp_1 = icmp sgt i32 %not_x, %not_y
  %not_min_1 = select i1 %cmp_1, i32 %not_x, i32 %not_y
  %cmp_2 = icmp sgt i32 %not_min_1, %not_z
  %not_min_2 = select i1 %cmp_2, i32 %not_min_1, i32 %not_z
  %min = sub i32 -1, %not_min_2
  ret i32 %min
}

; Don't increase the critical path by moving the 'not' op after the 'select'.

define i32 @compute_min_arithmetic(i32 %x, i32 %y) {
; CHECK-LABEL: @compute_min_arithmetic(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[X:%.*]], -4
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.smin.i32(i32 [[Y:%.*]], i32 [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %not_value = sub i32 3, %x
  %not_y = sub i32 -1, %y
  %cmp = icmp sgt i32 %not_value, %not_y
  %not_min = select i1 %cmp, i32 %not_value, i32 %not_y
  ret i32 %not_min
}

declare void @fake_use(i32)

define i32 @compute_min_pessimization(i32 %x, i32 %y) {
; CHECK-LABEL: @compute_min_pessimization(
; CHECK-NEXT:    [[NOT_VALUE:%.*]] = sub i32 3, [[X:%.*]]
; CHECK-NEXT:    call void @fake_use(i32 [[NOT_VALUE]])
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[X]], -4
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.smin.i32(i32 [[Y:%.*]], i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %not_value = sub i32 3, %x
  call void @fake_use(i32 %not_value)
  %not_y = sub i32 -1, %y
  %cmp = icmp sgt i32 %not_value, %not_y
  %not_min = select i1 %cmp, i32 %not_value, i32 %not_y
  %min = sub i32 -1, %not_min
  ret i32 %min
}

define i32 @max_of_nots(i32 %x, i32 %y) {
; CHECK-LABEL: @max_of_nots(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smax.i32(i32 [[Y:%.*]], i32 0)
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.smin.i32(i32 [[TMP1]], i32 [[X:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %c0 = icmp sgt i32 %y, 0
  %xor_y = xor i32 %y, -1
  %s0 = select i1 %c0, i32 %xor_y, i32 -1
  %xor_x = xor i32 %x, -1
  %c1 = icmp slt i32 %s0, %xor_x
  %smax96 = select i1 %c1, i32 %xor_x, i32 %s0
  ret i32 %smax96
}

  ; negative test case (i.e. can not simplify) : ABS(MIN(NOT x,y))
define i32 @abs_of_min_of_not(i32 %x, i32 %y) {
; CHECK-LABEL: @abs_of_min_of_not(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 -3, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.smax.i32(i32 [[X:%.*]], i32 [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP2]], -1
; CHECK-NEXT:    [[TMP4:%.*]] = call i32 @llvm.abs.i32(i32 [[TMP3]], i1 false)
; CHECK-NEXT:    ret i32 [[TMP4]]
;

  %xord = xor i32 %x, -1
  %yadd = add i32 %y, 2
  %cond.i = icmp sge i32 %yadd, %xord
  %min = select i1 %cond.i, i32 %xord, i32 %yadd
  %cmp2 = icmp sgt i32 %min, -1
  %sub = sub i32 0, %min
  %abs = select i1 %cmp2, i32 %min, i32 %sub
  ret i32  %abs
}

define <2 x i32> @max_of_nots_vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @max_of_nots_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.smax.v2i32(<2 x i32> [[Y:%.*]], <2 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.smin.v2i32(<2 x i32> [[TMP1]], <2 x i32> [[X:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = xor <2 x i32> [[TMP2]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %c0 = icmp sgt <2 x i32> %y, zeroinitializer
  %xor_y = xor <2 x i32> %y, <i32 -1, i32 -1>
  %s0 = select <2 x i1> %c0, <2 x i32> %xor_y, <2 x i32> <i32 -1, i32 -1>
  %xor_x = xor <2 x i32> %x, <i32 -1, i32 -1>
  %c1 = icmp slt <2 x i32> %s0, %xor_x
  %smax96 = select <2 x i1> %c1, <2 x i32> %xor_x, <2 x i32> %s0
  ret <2 x i32> %smax96
}

define <2 x i37> @max_of_nots_weird_type_vec(<2 x i37> %x, <2 x i37> %y) {
; CHECK-LABEL: @max_of_nots_weird_type_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i37> @llvm.smax.v2i37(<2 x i37> [[Y:%.*]], <2 x i37> zeroinitializer)
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i37> @llvm.smin.v2i37(<2 x i37> [[TMP1]], <2 x i37> [[X:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = xor <2 x i37> [[TMP2]], <i37 -1, i37 -1>
; CHECK-NEXT:    ret <2 x i37> [[TMP3]]
;
  %c0 = icmp sgt <2 x i37> %y, zeroinitializer
  %xor_y = xor <2 x i37> %y, <i37 -1, i37 -1>
  %s0 = select <2 x i1> %c0, <2 x i37> %xor_y, <2 x i37> <i37 -1, i37 -1>
  %xor_x = xor <2 x i37> %x, <i37 -1, i37 -1>
  %c1 = icmp slt <2 x i37> %s0, %xor_x
  %smax96 = select <2 x i1> %c1, <2 x i37> %xor_x, <2 x i37> %s0
  ret <2 x i37> %smax96
}

; max(min(%a, -1), -1) == -1
define i32 @max_of_min(i32 %a) {
; CHECK-LABEL: @max_of_min(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp sgt i32 %a, 0
  %s0 = select i1 %c0, i32 %not_a, i32 -1
  %c1 = icmp sgt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

; max(min(%a, -1), -1) == -1 (swap predicate and select ops)
define i32 @max_of_min_swap(i32 %a) {
; CHECK-LABEL: @max_of_min_swap(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp slt i32 %a, 0
  %s0 = select i1 %c0, i32 -1, i32 %not_a
  %c1 = icmp sgt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

; min(max(%a, -1), -1) == -1
define i32 @min_of_max(i32 %a) {
; CHECK-LABEL: @min_of_max(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp slt i32 %a, 0
  %s0 = select i1 %c0, i32 %not_a, i32 -1
  %c1 = icmp slt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

; min(max(%a, -1), -1) == -1 (swap predicate and select ops)
define i32 @min_of_max_swap(i32 %a) {
; CHECK-LABEL: @min_of_max_swap(
; CHECK-NEXT:    ret i32 -1
;
  %not_a = xor i32 %a, -1
  %c0 = icmp sgt i32 %a, 0
  %s0 = select i1 %c0, i32 -1, i32 %not_a
  %c1 = icmp slt i32 %s0, -1
  %s1 = select i1 %c1, i32 %s0, i32 -1
  ret i32 %s1
}

define <2 x i32> @max_of_min_vec(<2 x i32> %a) {
; CHECK-LABEL: @max_of_min_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 -1, i32 -1>
;
  %not_a = xor <2 x i32> %a, <i32 -1, i32 -1>
  %c0 = icmp sgt <2 x i32> %a, zeroinitializer
  %s0 = select <2 x i1> %c0, <2 x i32> %not_a, <2 x i32> <i32 -1, i32 -1>
  %c1 = icmp sgt <2 x i32> %s0, <i32 -1, i32 -1>
  %s1 = select <2 x i1> %c1, <2 x i32> %s0, <2 x i32> <i32 -1, i32 -1>
  ret <2 x i32> %s1
}

declare void @use(i8, i8, i8, i8)

define void @cmyk(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smax.i8(i8 [[R:%.*]], i8 [[G:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.smax.i8(i8 [[B:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    [[K:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[CK:%.*]] = sub i8 [[TMP2]], [[R]]
; CHECK-NEXT:    [[MK:%.*]] = sub i8 [[TMP2]], [[G]]
; CHECK-NEXT:    [[YK:%.*]] = sub i8 [[TMP2]], [[B]]
; CHECK-NEXT:    call void @use(i8 [[CK]], i8 [[MK]], i8 [[YK]], i8 [[K]])
; CHECK-NEXT:    ret void
;
  %notr = xor i8 %r, -1
  %notg = xor i8 %g, -1
  %notb = xor i8 %b, -1
  %cmp_gr = icmp slt i8 %g, %r
  %cmp_br = icmp slt i8 %notr, %notb
  %min_br = select i1 %cmp_br, i8 %notr, i8 %notb
  %cmp_gb = icmp slt i8 %notg, %notb
  %min_gb = select i1 %cmp_gb, i8 %notg, i8 %notb
  %k = select i1 %cmp_gr, i8 %min_br, i8 %min_gb
  %ck = sub i8 %notr, %k
  %mk = sub i8 %notg, %k
  %yk = sub i8 %notb, %k
  call void @use(i8 %ck, i8 %mk, i8 %yk, i8 %k)
  ret void
}

define void @cmyk2(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk2(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smax.i8(i8 [[R:%.*]], i8 [[G:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.smax.i8(i8 [[B:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    [[K:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[CK:%.*]] = sub i8 [[TMP2]], [[R]]
; CHECK-NEXT:    [[MK:%.*]] = sub i8 [[TMP2]], [[G]]
; CHECK-NEXT:    [[YK:%.*]] = sub i8 [[TMP2]], [[B]]
; CHECK-NEXT:    call void @use(i8 [[CK]], i8 [[MK]], i8 [[YK]], i8 [[K]])
; CHECK-NEXT:    ret void
;
  %notr = xor i8 %r, -1
  %notg = xor i8 %g, -1
  %notb = xor i8 %b, -1
  %cmp_gr = icmp slt i8 %g, %r
  %cmp_br = icmp slt i8 %b, %r
  %min_br = select i1 %cmp_br, i8 %notr, i8 %notb
  %cmp_bg = icmp slt i8 %b, %g
  %min_bg = select i1 %cmp_bg, i8 %notg, i8 %notb
  %k = select i1 %cmp_gr, i8 %min_br, i8 %min_bg
  %ck = sub i8 %notr, %k
  %mk = sub i8 %notg, %k
  %yk = sub i8 %notb, %k
  call void @use(i8 %ck, i8 %mk, i8 %yk, i8 %k)
  ret void
}

define void @cmyk3(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk3(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smax.i8(i8 [[R:%.*]], i8 [[G:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.smax.i8(i8 [[B:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    [[K:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[CK:%.*]] = sub i8 [[TMP2]], [[R]]
; CHECK-NEXT:    [[MK:%.*]] = sub i8 [[TMP2]], [[G]]
; CHECK-NEXT:    [[YK:%.*]] = sub i8 [[TMP2]], [[B]]
; CHECK-NEXT:    call void @use(i8 [[CK]], i8 [[MK]], i8 [[YK]], i8 [[K]])
; CHECK-NEXT:    ret void
;
  %notr = xor i8 %r, -1
  %notg = xor i8 %g, -1
  %notb = xor i8 %b, -1
  %cmp_gr = icmp slt i8 %g, %r
  %cmp_br = icmp sgt i8 %r, %b
  %min_br = select i1 %cmp_br, i8 %notr, i8 %notb
  %cmp_bg = icmp slt i8 %b, %g
  %min_bg = select i1 %cmp_bg, i8 %notg, i8 %notb
  %k = select i1 %cmp_gr, i8 %min_br, i8 %min_bg
  %ck = sub i8 %notr, %k
  %mk = sub i8 %notg, %k
  %yk = sub i8 %notb, %k
  call void @use(i8 %ck, i8 %mk, i8 %yk, i8 %k)
  ret void
}

define void @cmyk4(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk4(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smax.i8(i8 [[R:%.*]], i8 [[G:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.smax.i8(i8 [[B:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    [[K:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[CK:%.*]] = sub i8 [[TMP2]], [[R]]
; CHECK-NEXT:    [[MK:%.*]] = sub i8 [[TMP2]], [[G]]
; CHECK-NEXT:    [[YK:%.*]] = sub i8 [[TMP2]], [[B]]
; CHECK-NEXT:    call void @use(i8 [[CK]], i8 [[MK]], i8 [[YK]], i8 [[K]])
; CHECK-NEXT:    ret void
;
  %notr = xor i8 %r, -1
  %notg = xor i8 %g, -1
  %notb = xor i8 %b, -1
  %cmp_gr = icmp slt i8 %g, %r
  %cmp_br = icmp sgt i8 %r, %b
  %min_br = select i1 %cmp_br, i8 %notr, i8 %notb
  %cmp_bg = icmp sgt i8 %g, %b
  %min_bg = select i1 %cmp_bg, i8 %notg, i8 %notb
  %k = select i1 %cmp_gr, i8 %min_br, i8 %min_bg
  %ck = sub i8 %notr, %k
  %mk = sub i8 %notg, %k
  %yk = sub i8 %notb, %k
  call void @use(i8 %ck, i8 %mk, i8 %yk, i8 %k)
  ret void
}

define void @cmyk5(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk5(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.smax.i8(i8 [[R:%.*]], i8 [[G:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.smax.i8(i8 [[B:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    [[K:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[CK:%.*]] = sub i8 [[TMP2]], [[R]]
; CHECK-NEXT:    [[MK:%.*]] = sub i8 [[TMP2]], [[G]]
; CHECK-NEXT:    [[YK:%.*]] = sub i8 [[TMP2]], [[B]]
; CHECK-NEXT:    call void @use(i8 [[CK]], i8 [[MK]], i8 [[YK]], i8 [[K]])
; CHECK-NEXT:    ret void
;
  %notr = xor i8 %r, -1
  %notg = xor i8 %g, -1
  %notb = xor i8 %b, -1
  %cmp_gr = icmp sgt i8 %r, %g
  %cmp_br = icmp sgt i8 %r, %b
  %min_br = select i1 %cmp_br, i8 %notr, i8 %notb
  %cmp_bg = icmp sgt i8 %g, %b
  %min_bg = select i1 %cmp_bg, i8 %notg, i8 %notb
  %k = select i1 %cmp_gr, i8 %min_br, i8 %min_bg
  %ck = sub i8 %notr, %k
  %mk = sub i8 %notg, %k
  %yk = sub i8 %notb, %k
  call void @use(i8 %ck, i8 %mk, i8 %yk, i8 %k)
  ret void
}

define void @cmyk6(i8 %r, i8 %g, i8 %b) {
; CHECK-LABEL: @cmyk6(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.umax.i8(i8 [[R:%.*]], i8 [[G:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.umax.i8(i8 [[B:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    [[K:%.*]] = xor i8 [[TMP2]], -1
; CHECK-NEXT:    [[CK:%.*]] = sub i8 [[TMP2]], [[R]]
; CHECK-NEXT:    [[MK:%.*]] = sub i8 [[TMP2]], [[G]]
; CHECK-NEXT:    [[YK:%.*]] = sub i8 [[TMP2]], [[B]]
; CHECK-NEXT:    tail call void @use(i8 [[CK]], i8 [[MK]], i8 [[YK]], i8 [[K]])
; CHECK-NEXT:    ret void
;
  %notr = xor i8 %r, -1
  %notg = xor i8 %g, -1
  %notb = xor i8 %b, -1
  %cmp_gr = icmp ult i8 %g, %r
  %cmp_br = icmp ult i8 %b, %r
  %sel_rb = select i1 %cmp_br, i8 %notr, i8 %notb
  %cmp_bg = icmp ult i8 %b, %g
  %sel_gb = select i1 %cmp_bg, i8 %notg, i8 %notb
  %k = select i1 %cmp_gr, i8 %sel_rb, i8 %sel_gb
  %ck = sub i8 %notr, %k
  %mk = sub i8 %notg, %k
  %yk = sub i8 %notb, %k
  tail call void @use(i8 %ck, i8 %mk, i8 %yk, i8 %k)
  ret void
}
