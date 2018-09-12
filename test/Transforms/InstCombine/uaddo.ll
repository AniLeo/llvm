; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @uaddo_commute1(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_commute1(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[Z:%.*]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %x, %y
  %c = icmp ugt i32 %x, %noty
  %r = select i1 %c, i32 %z, i32 %a
  ret i32 %r
}

define <2 x i32> @uaddo_commute2(<2 x i32> %x, <2 x i32> %y, <2 x i32> %z) {
; CHECK-LABEL: @uaddo_commute2(
; CHECK-NEXT:    [[NOTY:%.*]] = xor <2 x i32> [[Y:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[A:%.*]] = add <2 x i32> [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult <2 x i32> [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[C]], <2 x i32> [[Z:%.*]], <2 x i32> [[A]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %noty = xor <2 x i32> %y, <i32 -1, i32 -1>
  %a = add <2 x i32> %y, %x
  %c = icmp ugt <2 x i32> %x, %noty
  %r = select <2 x i1> %c, <2 x i32> %z, <2 x i32> %a
  ret <2 x i32> %r
}

define i32 @uaddo_commute3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_commute3(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[Z:%.*]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %x, %y
  %c = icmp ult i32 %noty, %x
  %r = select i1 %c, i32 %z, i32 %a
  ret i32 %r
}

define i32 @uaddo_commute4(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_commute4(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[Z:%.*]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %y, %x
  %c = icmp ult i32 %noty, %x
  %r = select i1 %c, i32 %z, i32 %a
  ret i32 %r
}

define i32 @uaddo_commute5(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_commute5(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %x, %y
  %c = icmp ugt i32 %x, %noty
  %r = select i1 %c, i32 %a, i32 %z
  ret i32 %r
}

define i32 @uaddo_commute6(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_commute6(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %y, %x
  %c = icmp ugt i32 %x, %noty
  %r = select i1 %c, i32 %a, i32 %z
  ret i32 %r
}

define i32 @uaddo_commute7(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_commute7(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %x, %y
  %c = icmp ult i32 %noty, %x
  %r = select i1 %c, i32 %a, i32 %z
  ret i32 %r
}

define i32 @uaddo_commute8(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_commute8(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %y, %x
  %c = icmp ult i32 %noty, %x
  %r = select i1 %c, i32 %a, i32 %z
  ret i32 %r
}

define i32 @uaddo_wrong_pred1(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_wrong_pred1(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[Z:%.*]], i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %x, %y
  %c = icmp ult i32 %x, %noty
  %r = select i1 %c, i32 %z, i32 %a
  ret i32 %r
}

define i32 @uaddo_wrong_pred2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @uaddo_wrong_pred2(
; CHECK-NEXT:    [[NOTY:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[NOTY]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %noty = xor i32 %y, -1
  %a = add i32 %x, %y
  %c = icmp uge i32 %x, %noty
  %r = select i1 %c, i32 %z, i32 %a
  ret i32 %r
}

