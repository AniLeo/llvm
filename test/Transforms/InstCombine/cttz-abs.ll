; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

define i32 @cttz_abs(i32 %x) {
; CHECK-LABEL: @cttz_abs(
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[X:%.*]], i1 true), [[RNG0:!range !.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp slt i32 %x, 0
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %s, i32 %x
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define <2 x i64> @cttz_abs_vec(<2 x i64> %x) {
; CHECK-LABEL: @cttz_abs_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %c = icmp slt <2 x i64> %x, zeroinitializer
  %s = sub <2 x i64> zeroinitializer, %x
  %d = select <2 x i1> %c, <2 x i64> %s, <2 x i64> %x
  %r = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %d)
  ret <2 x i64> %r
}

define i32 @cttz_abs2(i32 %x) {
; CHECK-LABEL: @cttz_abs2(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use_cond(i1 [[C]])
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[X]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp sgt i32 %x, 0
  call void @use_cond(i1 %c)
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %x, i32 %s
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define i32 @cttz_abs3(i32 %x) {
; CHECK-LABEL: @cttz_abs3(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X:%.*]], -1
; CHECK-NEXT:    call void @use_cond(i1 [[C]])
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[X]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp sgt i32 %x, -1
  call void @use_cond(i1 %c)
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %x, i32 %s
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define i32 @cttz_abs4(i32 %x) {
; CHECK-LABEL: @cttz_abs4(
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[X:%.*]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp slt i32 %x, 1
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %s, i32 %x
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define i32 @cttz_nabs(i32 %x) {
; CHECK-LABEL: @cttz_nabs(
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[X:%.*]], i1 false), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp slt i32 %x, 0
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %x, i32 %s
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 false)
  ret i32 %r
}

define <2 x i64> @cttz_nabs_vec(<2 x i64> %x) {
; CHECK-LABEL: @cttz_nabs_vec(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[X:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %c = icmp slt <2 x i64> %x, zeroinitializer
  %s = sub <2 x i64> zeroinitializer, %x
  %d = select <2 x i1> %c, <2 x i64> %x, <2 x i64> %s
  %r = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %d)
  ret <2 x i64> %r
}

define i64 @cttz_abs_64(i64 %x) {
; CHECK-LABEL: @cttz_abs_64(
; CHECK-NEXT:    [[R:%.*]] = call i64 @llvm.cttz.i64(i64 [[X:%.*]], i1 false), [[RNG1:!range !.*]]
; CHECK-NEXT:    ret i64 [[R]]
;
  %c = icmp slt i64 %x, 0
  %s = sub i64 0, %x
  %d = select i1 %c, i64 %s, i64 %x
  %r = tail call i64 @llvm.cttz.i64(i64 %d)
  ret i64 %r
}

define i32 @cttz_abs_multiuse(i32 %x) {
; CHECK-LABEL: @cttz_abs_multiuse(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[S:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[S]], i32 [[X]]
; CHECK-NEXT:    call void @use_abs(i32 [[D]])
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[X]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp slt i32 %x, 1
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %s, i32 %x
  call void @use_abs(i32 %d)
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define i32 @cttz_nabs_multiuse(i32 %x) {
; CHECK-LABEL: @cttz_nabs_multiuse(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[S:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[X]], i32 [[S]]
; CHECK-NEXT:    call void @use_abs(i32 [[D]])
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[X]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp slt i32 %x, 1
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %x, i32 %s
  call void @use_abs(i32 %d)
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

; Negative tests

define i32 @no_cttz_abs(i32 %x) {
; CHECK-LABEL: @no_cttz_abs(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X:%.*]], 2
; CHECK-NEXT:    [[S:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[S]], i32 [[X]]
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[D]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp slt i32 %x, 2
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %s, i32 %x
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define i32 @no_cttz_abs2(i32 %x) {
; CHECK-LABEL: @no_cttz_abs2(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[S:%.*]] = sub i32 1, [[X]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[S]], i32 [[X]]
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[D]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp slt i32 %x, 0
  %s = sub i32 1, %x
  %d = select i1 %c, i32 %s, i32 %x
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define i32 @no_cttz_abs3(i32 %x) {
; CHECK-LABEL: @no_cttz_abs3(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X:%.*]], -2
; CHECK-NEXT:    call void @use_cond(i1 [[C]])
; CHECK-NEXT:    [[S:%.*]] = sub i32 0, [[X]]
; CHECK-NEXT:    [[D:%.*]] = select i1 [[C]], i32 [[X]], i32 [[S]]
; CHECK-NEXT:    [[R:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[D]], i1 true), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %c = icmp sgt i32 %x, -2
  call void @use_cond(i1 %c)
  %s = sub i32 0, %x
  %d = select i1 %c, i32 %x, i32 %s
  %r = tail call i32 @llvm.cttz.i32(i32 %d, i1 true)
  ret i32 %r
}

define <2 x i64> @no_cttz_abs_vec(<2 x i64> %x) {
; CHECK-LABEL: @no_cttz_abs_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp slt <2 x i64> [[X:%.*]], <i64 2, i64 1>
; CHECK-NEXT:    [[S:%.*]] = sub <2 x i64> <i64 1, i64 0>, [[X]]
; CHECK-NEXT:    [[D:%.*]] = select <2 x i1> [[C]], <2 x i64> [[S]], <2 x i64> [[X]]
; CHECK-NEXT:    [[R:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[D]], i1 false)
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %c = icmp slt <2 x i64> %x, <i64 2, i64 1>
  %s = sub <2 x i64> <i64 1, i64 0>, %x
  %d = select <2 x i1> %c, <2 x i64> %s, <2 x i64> %x
  %r = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %d)
  ret <2 x i64> %r
}

define <2 x i64> @no_cttz_nabs_vec(<2 x i64> %x) {
; CHECK-LABEL: @no_cttz_nabs_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp slt <2 x i64> [[X:%.*]], <i64 2, i64 1>
; CHECK-NEXT:    [[S:%.*]] = sub <2 x i64> <i64 1, i64 0>, [[X]]
; CHECK-NEXT:    [[D:%.*]] = select <2 x i1> [[C]], <2 x i64> [[X]], <2 x i64> [[S]]
; CHECK-NEXT:    [[R:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[D]], i1 false)
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %c = icmp slt <2 x i64> %x, <i64 2, i64 1>
  %s = sub <2 x i64> <i64 1, i64 0>, %x
  %d = select <2 x i1> %c, <2 x i64> %x, <2 x i64> %s
  %r = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %d)
  ret <2 x i64> %r
}

define i32 @cttz_abs_intrin(i32 %x) {
; CHECK-LABEL: @cttz_abs_intrin(
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.cttz.i32(i32 [[A]], i1 false), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = call i32 @llvm.abs.i32(i32 %x, i1 false)
  %r = call i32 @llvm.cttz.i32(i32 %a, i1 false)
  ret i32 %r
}

define i32 @cttz_nabs_intrin(i32 %x) {
; CHECK-LABEL: @cttz_nabs_intrin(
; CHECK-NEXT:    [[A:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.cttz.i32(i32 [[A]], i1 false), [[RNG0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = call i32 @llvm.abs.i32(i32 %x, i1 false)
  %n = sub i32 0, %a
  %r = call i32 @llvm.cttz.i32(i32 %n, i1 false)
  ret i32 %r
}

declare void @use_cond(i1)
declare void @use_abs(i32)
declare i32 @llvm.cttz.i32(i32, i1)
declare i64 @llvm.cttz.i64(i64)
declare <2 x i64> @llvm.cttz.v2i64(<2 x i64>)
declare i32 @llvm.abs.i32(i32, i1)
