; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

declare i32 @llvm.vector.reduce.add.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.add.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.mul.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.and.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.and.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.or.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.or.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.xor.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.smin.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.smax.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.umin.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> %a)
declare i32 @llvm.vector.reduce.umax.v1i32(<1 x i32> %a)
declare i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> %a)


define i32 @add_0() {
; CHECK-LABEL: @add_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @add_1() {
; CHECK-LABEL: @add_1(
; CHECK-NEXT:    ret i32 8
;
  %x = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @add_inc() {
; CHECK-LABEL: @add_inc(
; CHECK-NEXT:    ret i32 18
;
  %x = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @add_1v() {
; CHECK-LABEL: @add_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.add.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @add_undef() {
; CHECK-LABEL: @add_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @add_undef1() {
; CHECK-LABEL: @add_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}



define i32 @mul_0() {
; CHECK-LABEL: @mul_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @mul_1() {
; CHECK-LABEL: @mul_1(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @mul_inc() {
; CHECK-LABEL: @mul_inc(
; CHECK-NEXT:    ret i32 40320
;
  %x = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @mul_1v() {
; CHECK-LABEL: @mul_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.mul.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @mul_undef() {
; CHECK-LABEL: @mul_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @mul_undef1() {
; CHECK-LABEL: @mul_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}


define i32 @and_0() {
; CHECK-LABEL: @and_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @and_1() {
; CHECK-LABEL: @and_1(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @and_inc() {
; CHECK-LABEL: @and_inc(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @and_1v() {
; CHECK-LABEL: @and_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.and.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @and_undef() {
; CHECK-LABEL: @and_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @and_undef1() {
; CHECK-LABEL: @and_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}


define i32 @or_0() {
; CHECK-LABEL: @or_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @or_1() {
; CHECK-LABEL: @or_1(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @or_inc() {
; CHECK-LABEL: @or_inc(
; CHECK-NEXT:    ret i32 -1
;
  %x = call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @or_1v() {
; CHECK-LABEL: @or_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.or.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @or_undef() {
; CHECK-LABEL: @or_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @or_undef1() {
; CHECK-LABEL: @or_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.or.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}


define i32 @xor_0() {
; CHECK-LABEL: @xor_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @xor_1() {
; CHECK-LABEL: @xor_1(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @xor_inc() {
; CHECK-LABEL: @xor_inc(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @xor_1v() {
; CHECK-LABEL: @xor_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.xor.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @xor_undef() {
; CHECK-LABEL: @xor_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @xor_undef1() {
; CHECK-LABEL: @xor_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}


define i32 @smin_0() {
; CHECK-LABEL: @smin_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @smin_1() {
; CHECK-LABEL: @smin_1(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @smin_inc() {
; CHECK-LABEL: @smin_inc(
; CHECK-NEXT:    ret i32 -6
;
  %x = call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @smin_1v() {
; CHECK-LABEL: @smin_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.smin.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @smin_undef() {
; CHECK-LABEL: @smin_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @smin_undef1() {
; CHECK-LABEL: @smin_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.smin.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}


define i32 @smax_0() {
; CHECK-LABEL: @smax_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @smax_1() {
; CHECK-LABEL: @smax_1(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @smax_inc() {
; CHECK-LABEL: @smax_inc(
; CHECK-NEXT:    ret i32 8
;
  %x = call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @smax_1v() {
; CHECK-LABEL: @smax_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.smax.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @smax_undef() {
; CHECK-LABEL: @smax_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @smax_undef1() {
; CHECK-LABEL: @smax_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.smax.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}


define i32 @umin_0() {
; CHECK-LABEL: @umin_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @umin_1() {
; CHECK-LABEL: @umin_1(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @umin_inc() {
; CHECK-LABEL: @umin_inc(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @umin_1v() {
; CHECK-LABEL: @umin_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.umin.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @umin_undef() {
; CHECK-LABEL: @umin_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @umin_undef1() {
; CHECK-LABEL: @umin_undef1(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.umin.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}


define i32 @umax_0() {
; CHECK-LABEL: @umax_0(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> zeroinitializer)
  ret i32 %x
}

define i32 @umax_1() {
; CHECK-LABEL: @umax_1(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}

define i32 @umax_inc() {
; CHECK-LABEL: @umax_inc(
; CHECK-NEXT:    ret i32 -3
;
  %x = call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> <i32 1, i32 -3, i32 5, i32 7, i32 2, i32 4, i32 -6, i32 8>)
  ret i32 %x
}

define i32 @umax_1v() {
; CHECK-LABEL: @umax_1v(
; CHECK-NEXT:    ret i32 10
;
  %x = call i32 @llvm.vector.reduce.umax.v1i32(<1 x i32> <i32 10>)
  ret i32 %x
}

define i32 @umax_undef() {
; CHECK-LABEL: @umax_undef(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> undef)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> undef)
  ret i32 %x
}

define i32 @umax_undef1d() {
; CHECK-LABEL: @umax_undef1d(
; CHECK-NEXT:    [[X:%.*]] = call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = call i32 @llvm.vector.reduce.umax.v8i32(<8 x i32> <i32 1, i32 1, i32 undef, i32 1, i32 1, i32 1, i32 1, i32 1>)
  ret i32 %x
}
