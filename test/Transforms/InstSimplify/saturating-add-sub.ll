; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

; TODO: the instructions having poison operands should be folded to poison

declare i3 @llvm.uadd.sat.i3(i3, i3)
declare i8 @llvm.uadd.sat.i8(i8, i8)
declare <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8>, <2 x i8>)
declare <2 x i9> @llvm.uadd.sat.v2i9(<2 x i9>, <2 x i9>)

declare i8 @llvm.sadd.sat.i8(i8, i8)
declare <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8>, <2 x i8>)

declare i8 @llvm.usub.sat.i8(i8, i8)
declare i8 @llvm.ssub.sat.i8(i8, i8)
declare <2 x i8> @llvm.usub.sat.v2i8(<2 x i8>, <2 x i8>)
declare <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8>, <2 x i8>)

define i8 @uadd_scalar_0(i8 %a) {
; CHECK-LABEL: @uadd_scalar_0(
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %x1 = call i8 @llvm.uadd.sat.i8(i8 %a, i8 0)
  ret i8 %x1
}

define <2 x i8> @uadd_vector_0(<2 x i8> %a) {
; CHECK-LABEL: @uadd_vector_0(
; CHECK-NEXT:    ret <2 x i8> [[A:%.*]]
;
  %x1v = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a, <2 x i8> zeroinitializer)
  ret <2 x i8> %x1v
}

define i3 @uadd_scalar_0_commute(i3 %a) {
; CHECK-LABEL: @uadd_scalar_0_commute(
; CHECK-NEXT:    ret i3 [[A:%.*]]
;
  %x2 = call i3 @llvm.uadd.sat.i3(i3 0, i3 %a)
  ret i3 %x2
}

define <2 x i8> @uadd_vector_0_commute(<2 x i8> %a) {
; CHECK-LABEL: @uadd_vector_0_commute(
; CHECK-NEXT:    ret <2 x i8> [[A:%.*]]
;
  %x2v = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 0, i8 undef>, <2 x i8> %a)
  ret <2 x i8> %x2v
}

define i8 @uadd_scalar_maxval(i8 %a) {
; CHECK-LABEL: @uadd_scalar_maxval(
; CHECK-NEXT:    ret i8 -1
;
  %x3 = call i8 @llvm.uadd.sat.i8(i8 %a, i8 255)
  ret i8 %x3
}

define <2 x i9> @uadd_vector_maxval(<2 x i9> %a) {
; CHECK-LABEL: @uadd_vector_maxval(
; CHECK-NEXT:    ret <2 x i9> <i9 -1, i9 -1>
;
  %x3v = call <2 x i9> @llvm.uadd.sat.v2i9(<2 x i9> %a, <2 x i9> <i9 511, i9 511>)
  ret <2 x i9> %x3v
}

define i3 @uadd_scalar_maxval_commute(i3 %a) {
; CHECK-LABEL: @uadd_scalar_maxval_commute(
; CHECK-NEXT:    ret i3 -1
;
  %x4 = call i3 @llvm.uadd.sat.i3(i3 7, i3 %a)
  ret i3 %x4
}

define <2 x i8> @uadd_vector_maxval_commute(<2 x i8> %a) {
; CHECK-LABEL: @uadd_vector_maxval_commute(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %x4v = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 255, i8 255>, <2 x i8> %a)
  ret <2 x i8> %x4v
}

define i8 @uadd_scalar_undef(i8 %a) {
; CHECK-LABEL: @uadd_scalar_undef(
; CHECK-NEXT:    ret i8 -1
;
  %x5 = call i8 @llvm.uadd.sat.i8(i8 %a, i8 undef)
  ret i8 %x5
}

define i8 @uadd_scalar_poison(i8 %a) {
; CHECK-LABEL: @uadd_scalar_poison(
; CHECK-NEXT:    ret i8 -1
;
  %x5 = call i8 @llvm.uadd.sat.i8(i8 %a, i8 poison)
  ret i8 %x5
}

define <2 x i8> @uadd_vector_undef(<2 x i8> %a) {
; CHECK-LABEL: @uadd_vector_undef(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %x5v = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 undef, i8 undef>)
  ret <2 x i8> %x5v
}

define <2 x i8> @uadd_vector_poison(<2 x i8> %a) {
; CHECK-LABEL: @uadd_vector_poison(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %x5v = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 poison, i8 poison>)
  ret <2 x i8> %x5v
}

define i8 @uadd_scalar_undef_commute(i8 %a) {
; CHECK-LABEL: @uadd_scalar_undef_commute(
; CHECK-NEXT:    ret i8 -1
;
  %x6 = call i8 @llvm.uadd.sat.i8(i8 undef, i8 %a)
  ret i8 %x6
}

define i8 @uadd_scalar_poison_commute(i8 %a) {
; CHECK-LABEL: @uadd_scalar_poison_commute(
; CHECK-NEXT:    ret i8 -1
;
  %x6 = call i8 @llvm.uadd.sat.i8(i8 poison, i8 %a)
  ret i8 %x6
}

define <2 x i8> @uadd_vector_undef_commute(<2 x i8> %a) {
; CHECK-LABEL: @uadd_vector_undef_commute(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %x5v = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> undef, <2 x i8> %a)
  ret <2 x i8> %x5v
}

define <2 x i8> @uadd_vector_poison_commute(<2 x i8> %a) {
; CHECK-LABEL: @uadd_vector_poison_commute(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %x5v = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> poison, <2 x i8> %a)
  ret <2 x i8> %x5v
}

define i8 @sadd_scalar_0(i8 %a) {
; CHECK-LABEL: @sadd_scalar_0(
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %y1 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 0)
  ret i8 %y1
}

define <2 x i8> @sadd_vector_0(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_0(
; CHECK-NEXT:    ret <2 x i8> [[A:%.*]]
;
  %y1v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 undef, i8 0>)
  ret <2 x i8> %y1v
}

define i8 @sadd_scalar_0_commute(i8 %a) {
; CHECK-LABEL: @sadd_scalar_0_commute(
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %y2 = call i8 @llvm.sadd.sat.i8(i8 0, i8 %a)
  ret i8 %y2
}

define <2 x i8> @sadd_vector_0_commute(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_0_commute(
; CHECK-NEXT:    ret <2 x i8> [[A:%.*]]
;
  %y2v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> zeroinitializer, <2 x i8> %a)
  ret <2 x i8> %y2v
}

define i8 @sadd_scalar_maxval(i8 %a) {
; CHECK-LABEL: @sadd_scalar_maxval(
; CHECK-NEXT:    [[Y3:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 127)
; CHECK-NEXT:    ret i8 [[Y3]]
;
  %y3 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 127)
  ret i8 %y3
}

define <2 x i8> @sadd_vector_maxval(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_maxval(
; CHECK-NEXT:    [[Y3V:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 127, i8 127>)
; CHECK-NEXT:    ret <2 x i8> [[Y3V]]
;
  %y3v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 127, i8 127>)
  ret <2 x i8> %y3v
}

define i8 @sadd_scalar_maxval_commute(i8 %a) {
; CHECK-LABEL: @sadd_scalar_maxval_commute(
; CHECK-NEXT:    [[Y4:%.*]] = call i8 @llvm.sadd.sat.i8(i8 127, i8 [[A:%.*]])
; CHECK-NEXT:    ret i8 [[Y4]]
;
  %y4 = call i8 @llvm.sadd.sat.i8(i8 127, i8 %a)
  ret i8 %y4
}

define <2 x i8> @sadd_vector_maxval_commute(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_maxval_commute(
; CHECK-NEXT:    [[Y4V:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 undef, i8 127>, <2 x i8> [[A:%.*]])
; CHECK-NEXT:    ret <2 x i8> [[Y4V]]
;
  %y4v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 undef, i8 127>, <2 x i8> %a)
  ret <2 x i8> %y4v
}

define i8 @sadd_scalar_undef(i8 %a) {
; CHECK-LABEL: @sadd_scalar_undef(
; CHECK-NEXT:    ret i8 -1
;
  %y5 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 undef)
  ret i8 %y5
}

define i8 @sadd_scalar_poison(i8 %a) {
; CHECK-LABEL: @sadd_scalar_poison(
; CHECK-NEXT:    ret i8 -1
;
  %y5 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 poison)
  ret i8 %y5
}

define <2 x i8> @sadd_vector_undef(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_undef(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %y5v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a, <2 x i8> undef)
  ret <2 x i8> %y5v
}

define <2 x i8> @sadd_vector_poison(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_poison(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %y5v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a, <2 x i8> poison)
  ret <2 x i8> %y5v
}

define i8 @sadd_scalar_undef_commute(i8 %a) {
; CHECK-LABEL: @sadd_scalar_undef_commute(
; CHECK-NEXT:    ret i8 -1
;
  %y6 = call i8 @llvm.sadd.sat.i8(i8 undef, i8 %a)
  ret i8 %y6
}

define i8 @sadd_scalar_poison_commute(i8 %a) {
; CHECK-LABEL: @sadd_scalar_poison_commute(
; CHECK-NEXT:    ret i8 -1
;
  %y6 = call i8 @llvm.sadd.sat.i8(i8 poison, i8 %a)
  ret i8 %y6
}

define <2 x i8> @sadd_vector_undef_commute(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_undef_commute(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %y6v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> undef, <2 x i8> %a)
  ret <2 x i8> %y6v
}

define <2 x i8> @sadd_vector_poison_commute(<2 x i8> %a) {
; CHECK-LABEL: @sadd_vector_poison_commute(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %y6v = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> poison, <2 x i8> %a)
  ret <2 x i8> %y6v
}

define i8 @usub_scalar_0(i8 %a) {
; CHECK-LABEL: @usub_scalar_0(
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %x1 = call i8 @llvm.usub.sat.i8(i8 %a, i8 0)
  ret i8 %x1
}

define <2 x i8> @usub_vector_0(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_0(
; CHECK-NEXT:    ret <2 x i8> [[A:%.*]]
;
  %x1v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 0, i8 0>)
  ret <2 x i8> %x1v
}

define i8 @usub_scalar_0_commute(i8 %a) {
; CHECK-LABEL: @usub_scalar_0_commute(
; CHECK-NEXT:    ret i8 0
;
  %x2 = call i8 @llvm.usub.sat.i8(i8 0, i8 %a)
  ret i8 %x2
}

define <2 x i8> @usub_vector_0_commute(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_0_commute(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x2v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 0, i8 0>, <2 x i8> %a)
  ret <2 x i8> %x2v
}

define i8 @usub_scalar_maxval(i8 %a) {
; CHECK-LABEL: @usub_scalar_maxval(
; CHECK-NEXT:    ret i8 0
;
  %x3 = call i8 @llvm.usub.sat.i8(i8 %a, i8 255)
  ret i8 %x3
}

define <2 x i8> @usub_vector_maxval(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_maxval(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x3v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 255, i8 255>)
  ret <2 x i8> %x3v
}

define i8 @usub_scalar_undef(i8 %a) {
; CHECK-LABEL: @usub_scalar_undef(
; CHECK-NEXT:    ret i8 0
;
  %x4 = call i8 @llvm.usub.sat.i8(i8 %a, i8 undef)
  ret i8 %x4
}

define i8 @usub_scalar_poison(i8 %a) {
; CHECK-LABEL: @usub_scalar_poison(
; CHECK-NEXT:    ret i8 0
;
  %x4 = call i8 @llvm.usub.sat.i8(i8 %a, i8 poison)
  ret i8 %x4
}

define <2 x i8> @usub_vector_undef(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_undef(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x4v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 undef, i8 undef>)
  ret <2 x i8> %x4v
}

define <2 x i8> @usub_vector_poison(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_poison(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x4v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 poison, i8 poison>)
  ret <2 x i8> %x4v
}

define i8 @usub_scalar_undef_commute(i8 %a) {
; CHECK-LABEL: @usub_scalar_undef_commute(
; CHECK-NEXT:    ret i8 0
;
  %x5 = call i8 @llvm.usub.sat.i8(i8 undef, i8 %a)
  ret i8 %x5
}

define i8 @usub_scalar_poison_commute(i8 %a) {
; CHECK-LABEL: @usub_scalar_poison_commute(
; CHECK-NEXT:    ret i8 0
;
  %x5 = call i8 @llvm.usub.sat.i8(i8 poison, i8 %a)
  ret i8 %x5
}

define <2 x i8> @usub_vector_undef_commute(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_undef_commute(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x5v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 undef, i8 undef>, <2 x i8> %a)
  ret <2 x i8> %x5v
}

define <2 x i8> @usub_vector_poison_commute(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_poison_commute(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x5v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> <i8 poison, i8 poison>, <2 x i8> %a)
  ret <2 x i8> %x5v
}

define i8 @usub_scalar_same(i8 %a) {
; CHECK-LABEL: @usub_scalar_same(
; CHECK-NEXT:    ret i8 0
;
  %x6 = call i8 @llvm.usub.sat.i8(i8 %a, i8 %a)
  ret i8 %x6
}

define <2 x i8> @usub_vector_same(<2 x i8> %a) {
; CHECK-LABEL: @usub_vector_same(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %x6v = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> %a)
  ret <2 x i8> %x6v
}

define i8 @ssub_scalar_0(i8 %a) {
; CHECK-LABEL: @ssub_scalar_0(
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %y1 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 0)
  ret i8 %y1
}

define <2 x i8> @ssub_vector_0(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_0(
; CHECK-NEXT:    ret <2 x i8> [[A:%.*]]
;
  %y1v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 0, i8 0>)
  ret <2 x i8> %y1v
}

define i8 @ssub_scalar_0_commute(i8 %a) {
; CHECK-LABEL: @ssub_scalar_0_commute(
; CHECK-NEXT:    [[Y2:%.*]] = call i8 @llvm.ssub.sat.i8(i8 0, i8 [[A:%.*]])
; CHECK-NEXT:    ret i8 [[Y2]]
;
  %y2 = call i8 @llvm.ssub.sat.i8(i8 0, i8 %a)
  ret i8 %y2
}

define <2 x i8> @ssub_vector_0_commute(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_0_commute(
; CHECK-NEXT:    [[Y2V:%.*]] = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> zeroinitializer, <2 x i8> [[A:%.*]])
; CHECK-NEXT:    ret <2 x i8> [[Y2V]]
;
  %y2v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 0, i8 0>, <2 x i8> %a)
  ret <2 x i8> %y2v
}

define i8 @ssub_scalar_maxval(i8 %a) {
; CHECK-LABEL: @ssub_scalar_maxval(
; CHECK-NEXT:    [[Y3:%.*]] = call i8 @llvm.ssub.sat.i8(i8 [[A:%.*]], i8 127)
; CHECK-NEXT:    ret i8 [[Y3]]
;
  %y3 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 127)
  ret i8 %y3
}

define <2 x i8> @ssub_vector_maxval(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_maxval(
; CHECK-NEXT:    [[Y3V:%.*]] = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 127, i8 127>)
; CHECK-NEXT:    ret <2 x i8> [[Y3V]]
;
  %y3v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 127, i8 127>)
  ret <2 x i8> %y3v
}

define i8 @ssub_scalar_undef(i8 %a) {
; CHECK-LABEL: @ssub_scalar_undef(
; CHECK-NEXT:    ret i8 0
;
  %y4 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 undef)
  ret i8 %y4
}

define i8 @ssub_scalar_poison(i8 %a) {
; CHECK-LABEL: @ssub_scalar_poison(
; CHECK-NEXT:    ret i8 0
;
  %y4 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 poison)
  ret i8 %y4
}

define <2 x i8> @ssub_vector_undef(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_undef(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %y4v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> undef)
  ret <2 x i8> %y4v
}

define <2 x i8> @ssub_vector_poison(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_poison(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %y4v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> poison)
  ret <2 x i8> %y4v
}

define i8 @ssub_scalar_undef_commute(i8 %a) {
; CHECK-LABEL: @ssub_scalar_undef_commute(
; CHECK-NEXT:    ret i8 0
;
  %y5 = call i8 @llvm.ssub.sat.i8(i8 undef, i8 %a)
  ret i8 %y5
}

define i8 @ssub_scalar_poison_commute(i8 %a) {
; CHECK-LABEL: @ssub_scalar_poison_commute(
; CHECK-NEXT:    ret i8 0
;
  %y5 = call i8 @llvm.ssub.sat.i8(i8 poison, i8 %a)
  ret i8 %y5
}

define <2 x i8> @ssub_vector_undef_commute(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_undef_commute(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %y5v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 undef, i8 undef>, <2 x i8> %a)
  ret <2 x i8> %y5v
}

define <2 x i8> @ssub_vector_poison_commute(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_poison_commute(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %y5v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> <i8 poison, i8 poison>, <2 x i8> %a)
  ret <2 x i8> %y5v
}

define i8 @ssub_scalar_same(i8 %a) {
; CHECK-LABEL: @ssub_scalar_same(
; CHECK-NEXT:    ret i8 0
;
  %y6 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 %a)
  ret i8 %y6
}

define <2 x i8> @ssub_vector_same(<2 x i8> %a) {
; CHECK-LABEL: @ssub_vector_same(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %y6v = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> %a)
  ret <2 x i8> %y6v
}

define i1 @uadd_icmp_op0_known(i8 %a) {
; CHECK-LABEL: @uadd_icmp_op0_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.uadd.sat.i8(i8 10, i8 %a)
  %c = icmp uge i8 %b, 10
  ret i1 %c
}

define i1 @uadd_icmp_op0_unknown(i8 %a) {
; CHECK-LABEL: @uadd_icmp_op0_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.uadd.sat.i8(i8 10, i8 [[A:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i8 [[B]], 10
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.uadd.sat.i8(i8 10, i8 %a)
  %c = icmp ugt i8 %b, 10
  ret i1 %c
}

define i1 @uadd_icmp_op1_known(i8 %a) {
; CHECK-LABEL: @uadd_icmp_op1_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.uadd.sat.i8(i8 %a, i8 10)
  %c = icmp uge i8 %b, 10
  ret i1 %c
}

define i1 @uadd_icmp_op1_unknown(i8 %a) {
; CHECK-LABEL: @uadd_icmp_op1_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.uadd.sat.i8(i8 [[A:%.*]], i8 10)
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i8 [[B]], 10
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.uadd.sat.i8(i8 %a, i8 10)
  %c = icmp ugt i8 %b, 10
  ret i1 %c
}

define i1 @sadd_icmp_op0_pos_known(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op0_pos_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.sadd.sat.i8(i8 10, i8 %a)
  %c = icmp sge i8 %b, -118
  ret i1 %c
}

define i1 @sadd_icmp_op0_pos_unknown(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op0_pos_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.sadd.sat.i8(i8 10, i8 [[A:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[B]], -118
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.sadd.sat.i8(i8 10, i8 %a)
  %c = icmp sgt i8 %b, -118
  ret i1 %c
}

define i1 @sadd_icmp_op0_neg_known(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op0_neg_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.sadd.sat.i8(i8 -10, i8 %a)
  %c = icmp sle i8 %b, 117
  ret i1 %c
}

define i1 @sadd_icmp_op0_neg_unknown(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op0_neg_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.sadd.sat.i8(i8 -10, i8 [[A:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[B]], 117
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.sadd.sat.i8(i8 -10, i8 %a)
  %c = icmp slt i8 %b, 117
  ret i1 %c
}

define i1 @sadd_icmp_op1_pos_known(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op1_pos_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.sadd.sat.i8(i8 %a, i8 10)
  %c = icmp sge i8 %b, -118
  ret i1 %c
}

define i1 @sadd_icmp_op1_pos_unknown(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op1_pos_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 10)
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[B]], -118
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.sadd.sat.i8(i8 %a, i8 10)
  %c = icmp sgt i8 %b, -118
  ret i1 %c
}

define i1 @sadd_icmp_op1_neg_known(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op1_neg_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.sadd.sat.i8(i8 %a, i8 -10)
  %c = icmp sle i8 %b, 117
  ret i1 %c
}

define i1 @sadd_icmp_op1_neg_unknown(i8 %a) {
; CHECK-LABEL: @sadd_icmp_op1_neg_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 -10)
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[B]], 117
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.sadd.sat.i8(i8 %a, i8 -10)
  %c = icmp slt i8 %b, 117
  ret i1 %c
}

define i1 @usub_icmp_op0_known(i8 %a) {
; CHECK-LABEL: @usub_icmp_op0_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.usub.sat.i8(i8 10, i8 %a)
  %c = icmp ule i8 %b, 10
  ret i1 %c
}

define i1 @usub_icmp_op0_unknown(i8 %a) {
; CHECK-LABEL: @usub_icmp_op0_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.usub.sat.i8(i8 10, i8 [[A:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp ult i8 [[B]], 10
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.usub.sat.i8(i8 10, i8 %a)
  %c = icmp ult i8 %b, 10
  ret i1 %c
}

define i1 @usub_icmp_op1_known(i8 %a) {
; CHECK-LABEL: @usub_icmp_op1_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.usub.sat.i8(i8 %a, i8 10)
  %c = icmp ule i8 %b, 245
  ret i1 %c
}

define i1 @usub_icmp_op1_unknown(i8 %a) {
; CHECK-LABEL: @usub_icmp_op1_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.usub.sat.i8(i8 [[A:%.*]], i8 10)
; CHECK-NEXT:    [[C:%.*]] = icmp ult i8 [[B]], -11
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.usub.sat.i8(i8 %a, i8 10)
  %c = icmp ult i8 %b, 245
  ret i1 %c
}

define i1 @ssub_icmp_op0_pos_known(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op0_pos_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.ssub.sat.i8(i8 10, i8 %a)
  %c = icmp sge i8 %b, -117
  ret i1 %c
}

define i1 @ssub_icmp_op0_pos_unknown(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op0_pos_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.ssub.sat.i8(i8 10, i8 [[A:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[B]], -117
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.ssub.sat.i8(i8 10, i8 %a)
  %c = icmp sgt i8 %b, -117
  ret i1 %c
}

define i1 @ssub_icmp_op0_neg_known(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op0_neg_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.ssub.sat.i8(i8 -10, i8 %a)
  %c = icmp sle i8 %b, 118
  ret i1 %c
}

define i1 @ssub_icmp_op0_neg_unknown(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op0_neg_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.ssub.sat.i8(i8 -10, i8 [[A:%.*]])
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[B]], 118
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.ssub.sat.i8(i8 -10, i8 %a)
  %c = icmp slt i8 %b, 118
  ret i1 %c
}

; Peculiar case: ssub.sat(0, x) is never signed min.
define i1 @ssub_icmp_op0_zero(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op0_zero(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.ssub.sat.i8(i8 0, i8 %a)
  %c = icmp ne i8 %b, -128
  ret i1 %c
}

define i1 @ssub_icmp_op1_pos_known(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op1_pos_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.ssub.sat.i8(i8 %a, i8 10)
  %c = icmp sle i8 %b, 117
  ret i1 %c
}

define i1 @ssub_icmp_op1_pos_unknown(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op1_pos_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.ssub.sat.i8(i8 [[A:%.*]], i8 10)
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[B]], 117
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.ssub.sat.i8(i8 %a, i8 10)
  %c = icmp slt i8 %b, 117
  ret i1 %c
}

define i1 @ssub_icmp_op1_neg_known(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op1_neg_known(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.ssub.sat.i8(i8 %a, i8 -10)
  %c = icmp sge i8 %b, -118
  ret i1 %c
}

define i1 @ssub_icmp_op1_neg_unknown(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op1_neg_unknown(
; CHECK-NEXT:    [[B:%.*]] = call i8 @llvm.ssub.sat.i8(i8 [[A:%.*]], i8 -10)
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[B]], -118
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = call i8 @llvm.ssub.sat.i8(i8 %a, i8 -10)
  %c = icmp sgt i8 %b, -118
  ret i1 %c
}

define i1 @ssub_icmp_op1_smin(i8 %a) {
; CHECK-LABEL: @ssub_icmp_op1_smin(
; CHECK-NEXT:    ret i1 true
;
  %b = call i8 @llvm.ssub.sat.i8(i8 %a, i8 -128)
  %c = icmp sge i8 %b, 0
  ret i1 %c
}
