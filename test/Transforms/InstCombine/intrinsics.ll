; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

declare double @llvm.powi.f64.i16(double, i16) nounwind readonly
declare double @llvm.powi.f64.i32(double, i32) nounwind readonly
declare i32 @llvm.cttz.i32(i32, i1) nounwind readnone
declare i32 @llvm.ctlz.i32(i32, i1) nounwind readnone
declare i1 @llvm.cttz.i1(i1, i1) nounwind readnone
declare i1 @llvm.ctlz.i1(i1, i1) nounwind readnone
declare <2 x i1> @llvm.cttz.v2i1(<2 x i1>, i1) nounwind readnone
declare <2 x i1> @llvm.ctlz.v2i1(<2 x i1>, i1) nounwind readnone
declare i32 @llvm.ctpop.i32(i32) nounwind readnone
declare <2 x i32> @llvm.cttz.v2i32(<2 x i32>, i1) nounwind readnone
declare <2 x i32> @llvm.ctlz.v2i32(<2 x i32>, i1) nounwind readnone
declare <2 x i32> @llvm.ctpop.v2i32(<2 x i32>) nounwind readnone
declare i8 @llvm.ctlz.i8(i8, i1) nounwind readnone
declare <2 x i8> @llvm.ctlz.v2i8(<2 x i8>, i1) nounwind readnone
declare double @llvm.cos.f64(double %Val) nounwind readonly
declare double @llvm.sin.f64(double %Val) nounwind readonly
declare double @llvm.floor.f64(double %Val) nounwind readonly
declare double @llvm.ceil.f64(double %Val) nounwind readonly
declare double @llvm.trunc.f64(double %Val) nounwind readonly
declare double @llvm.rint.f64(double %Val) nounwind readonly
declare double @llvm.nearbyint.f64(double %Val) nounwind readonly

define void @powi(double %V, double *%P) {
; CHECK-LABEL: @powi(
; CHECK-NEXT:    [[A:%.*]] = fdiv fast double 1.000000e+00, [[V:%.*]]
; CHECK-NEXT:    store volatile double [[A]], double* [[P:%.*]], align 8
; CHECK-NEXT:    [[D:%.*]] = fmul nnan double [[V]], [[V]]
; CHECK-NEXT:    store volatile double [[D]], double* [[P]], align 8
; CHECK-NEXT:    [[A2:%.*]] = fdiv fast double 1.000000e+00, [[V]]
; CHECK-NEXT:    store volatile double [[A2]], double* [[P]], align 8
; CHECK-NEXT:    [[D2:%.*]] = fmul nnan double [[V]], [[V]]
; CHECK-NEXT:    store volatile double [[D2]], double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %A = tail call fast double @llvm.powi.f64.i32(double %V, i32 -1) nounwind
  store volatile double %A, double* %P

  %D = tail call nnan double @llvm.powi.f64.i32(double %V, i32 2) nounwind
  store volatile double %D, double* %P

  %A2 = tail call fast double @llvm.powi.f64.i16(double %V, i16 -1) nounwind
  store volatile double %A2, double* %P

  %D2 = tail call nnan double @llvm.powi.f64.i16(double %V, i16 2) nounwind
  store volatile double %D2, double* %P
  ret void
}

define i32 @cttz(i32 %a) {
; CHECK-LABEL: @cttz(
; CHECK-NEXT:    ret i32 3
;
  %or = or i32 %a, 8
  %and = and i32 %or, -8
  %count = tail call i32 @llvm.cttz.i32(i32 %and, i1 true) nounwind readnone
  ret i32 %count
}

define <2 x i32> @cttz_vec(<2 x i32> %a) {
; CHECK-LABEL: @cttz_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 3, i32 3>
;
  %or = or <2 x i32> %a, <i32 8, i32 8>
  %and = and <2 x i32> %or, <i32 -8, i32 -8>
  %count = tail call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %and, i1 true) nounwind readnone
  ret <2 x i32> %count
}

; Make sure we don't add range metadata to i1 cttz.
define i1 @cttz_i1(i1 %arg) {
; CHECK-LABEL: @cttz_i1(
; CHECK-NEXT:    [[CNT:%.*]] = xor i1 [[ARG:%.*]], true
; CHECK-NEXT:    ret i1 [[CNT]]
;
  %cnt = call i1 @llvm.cttz.i1(i1 %arg, i1 false) nounwind readnone
  ret i1 %cnt
}

define i1 @cttz_i1_zero_is_poison(i1 %arg) {
; CHECK-LABEL: @cttz_i1_zero_is_poison(
; CHECK-NEXT:    ret i1 false
;
  %cnt = call i1 @llvm.cttz.i1(i1 %arg, i1 true) nounwind readnone
  ret i1 %cnt
}

define <2 x i1> @cttz_v2i1(<2 x i1> %arg) {
; CHECK-LABEL: @cttz_v2i1(
; CHECK-NEXT:    [[CNT:%.*]] = xor <2 x i1> [[ARG:%.*]], <i1 true, i1 true>
; CHECK-NEXT:    ret <2 x i1> [[CNT]]
;
  %cnt = call <2 x i1> @llvm.cttz.v2i1(<2 x i1> %arg, i1 false) nounwind readnone
  ret <2 x i1> %cnt
}

define <2 x i1> @cttz_v2i1_zero_is_poison(<2 x i1> %arg) {
; CHECK-LABEL: @cttz_v2i1_zero_is_poison(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %cnt = call <2 x i1> @llvm.cttz.v2i1(<2 x i1> %arg, i1 true) nounwind readnone
  ret <2 x i1> %cnt
}

define i1 @cttz_knownbits(i32 %arg) {
; CHECK-LABEL: @cttz_knownbits(
; CHECK-NEXT:    ret i1 false
;
  %or = or i32 %arg, 4
  %cnt = call i32 @llvm.cttz.i32(i32 %or, i1 true) nounwind readnone
  %res = icmp eq i32 %cnt, 4
  ret i1 %res
}

define <2 x i1> @cttz_knownbits_vec(<2 x i32> %arg) {
; CHECK-LABEL: @cttz_knownbits_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %or = or <2 x i32> %arg, <i32 4, i32 4>
  %cnt = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %or, i1 true) nounwind readnone
  %res = icmp eq <2 x i32> %cnt, <i32 4, i32 4>
  ret <2 x i1> %res
}

define i32 @cttz_knownbits2(i32 %arg) {
; CHECK-LABEL: @cttz_knownbits2(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[ARG:%.*]], 4
; CHECK-NEXT:    [[CNT:%.*]] = call i32 @llvm.cttz.i32(i32 [[OR]], i1 true) #[[ATTR2:[0-9]+]], !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    ret i32 [[CNT]]
;
  %or = or i32 %arg, 4
  %cnt = call i32 @llvm.cttz.i32(i32 %or, i1 true) nounwind readnone
  ret i32 %cnt
}

define <2 x i32> @cttz_knownbits2_vec(<2 x i32> %arg) {
; CHECK-LABEL: @cttz_knownbits2_vec(
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> [[ARG:%.*]], <i32 4, i32 4>
; CHECK-NEXT:    [[CNT:%.*]] = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[OR]], i1 true) #[[ATTR2]]
; CHECK-NEXT:    ret <2 x i32> [[CNT]]
;
  %or = or <2 x i32> %arg, <i32 4, i32 4>
  %cnt = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %or, i1 true) nounwind readnone
  ret <2 x i32> %cnt
}

define i1 @cttz_knownbits3(i32 %arg) {
; CHECK-LABEL: @cttz_knownbits3(
; CHECK-NEXT:    ret i1 false
;
  %or = or i32 %arg, 4
  %cnt = call i32 @llvm.cttz.i32(i32 %or, i1 true) nounwind readnone
  %res = icmp eq i32 %cnt, 3
  ret i1 %res
}

define <2 x i1> @cttz_knownbits3_vec(<2 x i32> %arg) {
; CHECK-LABEL: @cttz_knownbits3_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %or = or <2 x i32> %arg, <i32 4, i32 4>
  %cnt = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %or, i1 true) nounwind readnone
  %res = icmp eq <2 x i32> %cnt, <i32 3, i32 3>
  ret <2 x i1> %res
}

define i8 @ctlz(i8 %a) {
; CHECK-LABEL: @ctlz(
; CHECK-NEXT:    ret i8 2
;
  %or = or i8 %a, 32
  %and = and i8 %or, 63
  %count = tail call i8 @llvm.ctlz.i8(i8 %and, i1 true) nounwind readnone
  ret i8 %count
}

define <2 x i8> @ctlz_vec(<2 x i8> %a) {
; CHECK-LABEL: @ctlz_vec(
; CHECK-NEXT:    ret <2 x i8> <i8 2, i8 2>
;
  %or = or <2 x i8> %a, <i8 32, i8 32>
  %and = and <2 x i8> %or, <i8 63, i8 63>
  %count = tail call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> %and, i1 true) nounwind readnone
  ret <2 x i8> %count
}

; Make sure we don't add range metadata to i1 ctlz.
define i1 @ctlz_i1(i1 %arg) {
; CHECK-LABEL: @ctlz_i1(
; CHECK-NEXT:    [[CNT:%.*]] = xor i1 [[ARG:%.*]], true
; CHECK-NEXT:    ret i1 [[CNT]]
;
  %cnt = call i1 @llvm.ctlz.i1(i1 %arg, i1 false) nounwind readnone
  ret i1 %cnt
}

define i1 @ctlz_i1_zero_is_poison(i1 %arg) {
; CHECK-LABEL: @ctlz_i1_zero_is_poison(
; CHECK-NEXT:    ret i1 false
;
  %cnt = call i1 @llvm.ctlz.i1(i1 %arg, i1 true) nounwind readnone
  ret i1 %cnt
}

define <2 x i1> @ctlz_v2i1(<2 x i1> %arg) {
; CHECK-LABEL: @ctlz_v2i1(
; CHECK-NEXT:    [[CNT:%.*]] = xor <2 x i1> [[ARG:%.*]], <i1 true, i1 true>
; CHECK-NEXT:    ret <2 x i1> [[CNT]]
;
  %cnt = call <2 x i1> @llvm.ctlz.v2i1(<2 x i1> %arg, i1 false) nounwind readnone
  ret <2 x i1> %cnt
}

define <2 x i1> @ctlz_v2i1_zero_is_poison(<2 x i1> %arg) {
; CHECK-LABEL: @ctlz_v2i1_zero_is_poison(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %cnt = call <2 x i1> @llvm.ctlz.v2i1(<2 x i1> %arg, i1 true) nounwind readnone
  ret <2 x i1> %cnt
}

define i1 @ctlz_knownbits(i8 %arg) {
; CHECK-LABEL: @ctlz_knownbits(
; CHECK-NEXT:    ret i1 false
;
  %or = or i8 %arg, 32
  %cnt = call i8 @llvm.ctlz.i8(i8 %or, i1 true) nounwind readnone
  %res = icmp eq i8 %cnt, 4
  ret i1 %res
}

define <2 x i1> @ctlz_knownbits_vec(<2 x i8> %arg) {
; CHECK-LABEL: @ctlz_knownbits_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %or = or <2 x i8> %arg, <i8 32, i8 32>
  %cnt = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> %or, i1 true) nounwind readnone
  %res = icmp eq <2 x i8> %cnt, <i8 4, i8 4>
  ret <2 x i1> %res
}

define i8 @ctlz_knownbits2(i8 %arg) {
; CHECK-LABEL: @ctlz_knownbits2(
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[ARG:%.*]], 32
; CHECK-NEXT:    [[CNT:%.*]] = call i8 @llvm.ctlz.i8(i8 [[OR]], i1 true) #[[ATTR2]], !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    ret i8 [[CNT]]
;
  %or = or i8 %arg, 32
  %cnt = call i8 @llvm.ctlz.i8(i8 %or, i1 true) nounwind readnone
  ret i8 %cnt
}

define <2 x i8> @ctlz_knownbits2_vec(<2 x i8> %arg) {
; CHECK-LABEL: @ctlz_knownbits2_vec(
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i8> [[ARG:%.*]], <i8 32, i8 32>
; CHECK-NEXT:    [[CNT:%.*]] = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> [[OR]], i1 true) #[[ATTR2]]
; CHECK-NEXT:    ret <2 x i8> [[CNT]]
;
  %or = or <2 x i8> %arg, <i8 32, i8 32>
  %cnt = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> %or, i1 true) nounwind readnone
  ret <2 x i8> %cnt
}

define i1 @ctlz_knownbits3(i8 %arg) {
; CHECK-LABEL: @ctlz_knownbits3(
; CHECK-NEXT:    ret i1 false
;
  %or = or i8 %arg, 32
  %cnt = call i8 @llvm.ctlz.i8(i8 %or, i1 true) nounwind readnone
  %res = icmp eq i8 %cnt, 3
  ret i1 %res
}

define <2 x i1> @ctlz_knownbits3_vec(<2 x i8> %arg) {
; CHECK-LABEL: @ctlz_knownbits3_vec(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %or = or <2 x i8> %arg, <i8 32, i8 32>
  %cnt = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> %or, i1 true) nounwind readnone
  %res = icmp eq <2 x i8> %cnt, <i8 3, i8 3>
  ret <2 x i1> %res
}

define i32 @ctlz_poison(i32 %Value) {
; CHECK-LABEL: @ctlz_poison(
; CHECK-NEXT:    ret i32 poison
;
  %ctlz = call i32 @llvm.ctlz.i32(i32 0, i1 true)
  ret i32 %ctlz
}

define <2 x i32> @ctlz_poison_vec(<2 x i32> %Value) {
; CHECK-LABEL: @ctlz_poison_vec(
; CHECK-NEXT:    ret <2 x i32> poison
;
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> zeroinitializer, i1 true)
  ret <2 x i32> %ctlz
}

define i32 @ctlz_no_zero(i32 %a) {
; CHECK-LABEL: @ctlz_no_zero(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[A:%.*]], 8
; CHECK-NEXT:    [[CTLZ:%.*]] = tail call i32 @llvm.ctlz.i32(i32 [[OR]], i1 true), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    ret i32 [[CTLZ]]
;
  %or = or i32 %a, 8
  %ctlz = tail call i32 @llvm.ctlz.i32(i32 %or, i1 false)
  ret i32 %ctlz
}

define <2 x i32> @ctlz_no_zero_vec(<2 x i32> %a) {
; CHECK-LABEL: @ctlz_no_zero_vec(
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> [[A:%.*]], <i32 8, i32 8>
; CHECK-NEXT:    [[CTLZ:%.*]] = tail call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> [[OR]], i1 true)
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %or = or <2 x i32> %a, <i32 8, i32 8>
  %ctlz = tail call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %or, i1 false)
  ret <2 x i32> %ctlz
}

define i32 @cttz_poison(i32 %Value) {
; CHECK-LABEL: @cttz_poison(
; CHECK-NEXT:    ret i32 poison
;
  %cttz = call i32 @llvm.cttz.i32(i32 0, i1 true)
  ret i32 %cttz
}

define <2 x i32> @cttz_poison_vec(<2 x i32> %Value) {
; CHECK-LABEL: @cttz_poison_vec(
; CHECK-NEXT:    ret <2 x i32> poison
;
  %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> zeroinitializer, i1 true)
  ret <2 x i32> %cttz
}

define i32 @cttz_no_zero(i32 %a) {
; CHECK-LABEL: @cttz_no_zero(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[A:%.*]], 8
; CHECK-NEXT:    [[CTTZ:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[OR]], i1 true), !range [[RNG3:![0-9]+]]
; CHECK-NEXT:    ret i32 [[CTTZ]]
;
  %or = or i32 %a, 8
  %cttz = tail call i32 @llvm.cttz.i32(i32 %or, i1 false)
  ret i32 %cttz
}

define <2 x i32> @cttz_no_zero_vec(<2 x i32> %a) {
; CHECK-LABEL: @cttz_no_zero_vec(
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> [[A:%.*]], <i32 8, i32 8>
; CHECK-NEXT:    [[CTTZ:%.*]] = tail call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[OR]], i1 true)
; CHECK-NEXT:    ret <2 x i32> [[CTTZ]]
;
  %or = or <2 x i32> %a, <i32 8, i32 8>
  %cttz = tail call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %or, i1 false)
  ret <2 x i32> %cttz
}

define i32 @ctlz_select(i32 %Value) nounwind {
; CHECK-LABEL: @ctlz_select(
; CHECK-NEXT:    [[CTLZ:%.*]] = call i32 @llvm.ctlz.i32(i32 [[VALUE:%.*]], i1 false), !range [[RNG4:![0-9]+]]
; CHECK-NEXT:    ret i32 [[CTLZ]]
;
  %tobool = icmp ne i32 %Value, 0
  %ctlz = call i32 @llvm.ctlz.i32(i32 %Value, i1 true)
  %s = select i1 %tobool, i32 %ctlz, i32 32
  ret i32 %s
}

define <2 x i32> @ctlz_select_vec(<2 x i32> %Value) nounwind {
; CHECK-LABEL: @ctlz_select_vec(
; CHECK-NEXT:    [[CTLZ:%.*]] = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> [[VALUE:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %tobool = icmp ne <2 x i32> %Value, zeroinitializer
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %Value, i1 true)
  %s = select <2 x i1> %tobool, <2 x i32> %ctlz, <2 x i32> <i32 32, i32 32>
  ret <2 x i32> %s
}

define i32 @cttz_select(i32 %Value) nounwind {
; CHECK-LABEL: @cttz_select(
; CHECK-NEXT:    [[CTTZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[VALUE:%.*]], i1 false), !range [[RNG4]]
; CHECK-NEXT:    ret i32 [[CTTZ]]
;
  %tobool = icmp ne i32 %Value, 0
  %cttz = call i32 @llvm.cttz.i32(i32 %Value, i1 true)
  %s = select i1 %tobool, i32 %cttz, i32 32
  ret i32 %s
}

define <2 x i32> @cttz_select_vec(<2 x i32> %Value) nounwind {
; CHECK-LABEL: @cttz_select_vec(
; CHECK-NEXT:    [[CTTZ:%.*]] = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[VALUE:%.*]], i1 false)
; CHECK-NEXT:    ret <2 x i32> [[CTTZ]]
;
  %tobool = icmp ne <2 x i32> %Value, zeroinitializer
  %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %Value, i1 true)
  %s = select <2 x i1> %tobool, <2 x i32> %cttz, <2 x i32> <i32 32, i32 32>
  ret <2 x i32> %s
}

define void @cos(double *%P) {
; CHECK-LABEL: @cos(
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %B = tail call double @llvm.cos.f64(double 0.0) nounwind
  store volatile double %B, double* %P

  ret void
}

define void @sin(double *%P) {
; CHECK-LABEL: @sin(
; CHECK-NEXT:    store volatile double 0.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %B = tail call double @llvm.sin.f64(double 0.0) nounwind
  store volatile double %B, double* %P

  ret void
}

define void @floor(double *%P) {
; CHECK-LABEL: @floor(
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    store volatile double -2.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %B = tail call double @llvm.floor.f64(double 1.5) nounwind
  store volatile double %B, double* %P
  %C = tail call double @llvm.floor.f64(double -1.5) nounwind
  store volatile double %C, double* %P
  ret void
}

define void @ceil(double *%P) {
; CHECK-LABEL: @ceil(
; CHECK-NEXT:    store volatile double 2.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    store volatile double -1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %B = tail call double @llvm.ceil.f64(double 1.5) nounwind
  store volatile double %B, double* %P
  %C = tail call double @llvm.ceil.f64(double -1.5) nounwind
  store volatile double %C, double* %P
  ret void
}

define void @trunc(double *%P) {
; CHECK-LABEL: @trunc(
; CHECK-NEXT:    store volatile double 1.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    store volatile double -1.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %B = tail call double @llvm.trunc.f64(double 1.5) nounwind
  store volatile double %B, double* %P
  %C = tail call double @llvm.trunc.f64(double -1.5) nounwind
  store volatile double %C, double* %P
  ret void
}

define void @rint(double *%P) {
; CHECK-LABEL: @rint(
; CHECK-NEXT:    store volatile double 2.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    store volatile double -2.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %B = tail call double @llvm.rint.f64(double 1.5) nounwind
  store volatile double %B, double* %P
  %C = tail call double @llvm.rint.f64(double -1.5) nounwind
  store volatile double %C, double* %P
  ret void
}

define void @nearbyint(double *%P) {
; CHECK-LABEL: @nearbyint(
; CHECK-NEXT:    store volatile double 2.000000e+00, double* [[P:%.*]], align 8
; CHECK-NEXT:    store volatile double -2.000000e+00, double* [[P]], align 8
; CHECK-NEXT:    ret void
;
  %B = tail call double @llvm.nearbyint.f64(double 1.5) nounwind
  store volatile double %B, double* %P
  %C = tail call double @llvm.nearbyint.f64(double -1.5) nounwind
  store volatile double %C, double* %P
  ret void
}

; CHECK: [[RNG0]] = !{i32 0, i32 3}
; CHECK: [[RNG1]] = !{i8 0, i8 3}
