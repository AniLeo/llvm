; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -constprop -S | FileCheck %s

declare {i8, i1} @llvm.uadd.with.overflow.i8(i8, i8)
declare {i8, i1} @llvm.usub.with.overflow.i8(i8, i8)
declare {i8, i1} @llvm.umul.with.overflow.i8(i8, i8)

declare {i8, i1} @llvm.sadd.with.overflow.i8(i8, i8)
declare {i8, i1} @llvm.ssub.with.overflow.i8(i8, i8)
declare {i8, i1} @llvm.smul.with.overflow.i8(i8, i8)

;;-----------------------------
;; uadd
;;-----------------------------

define {i8, i1} @uadd_1() nounwind {
; CHECK-LABEL: @uadd_1(
; CHECK-NEXT:    ret { i8, i1 } { i8 -114, i1 false }
;
  %t = call {i8, i1} @llvm.uadd.with.overflow.i8(i8 42, i8 100)
  ret {i8, i1} %t
}

define {i8, i1} @uadd_2() nounwind {
; CHECK-LABEL: @uadd_2(
; CHECK-NEXT:    ret { i8, i1 } { i8 6, i1 true }
;
  %t = call {i8, i1} @llvm.uadd.with.overflow.i8(i8 142, i8 120)
  ret {i8, i1} %t
}

;;-----------------------------
;; usub
;;-----------------------------

define {i8, i1} @usub_1() nounwind {
; CHECK-LABEL: @usub_1(
; CHECK-NEXT:    ret { i8, i1 } { i8 2, i1 false }
;
  %t = call {i8, i1} @llvm.usub.with.overflow.i8(i8 4, i8 2)
  ret {i8, i1} %t
}

define {i8, i1} @usub_2() nounwind {
; CHECK-LABEL: @usub_2(
; CHECK-NEXT:    ret { i8, i1 } { i8 -2, i1 true }
;
  %t = call {i8, i1} @llvm.usub.with.overflow.i8(i8 4, i8 6)
  ret {i8, i1} %t
}

;;-----------------------------
;; umul
;;-----------------------------

define {i8, i1} @umul_1() nounwind {
; CHECK-LABEL: @umul_1(
; CHECK-NEXT:    ret { i8, i1 } { i8 44, i1 true }
;
  %t = call {i8, i1} @llvm.umul.with.overflow.i8(i8 100, i8 3)
  ret {i8, i1} %t
}

define {i8, i1} @umul_2() nounwind {
; CHECK-LABEL: @umul_2(
; CHECK-NEXT:    ret { i8, i1 } { i8 -56, i1 false }
;
  %t = call {i8, i1} @llvm.umul.with.overflow.i8(i8 100, i8 2)
  ret {i8, i1} %t
}

;;-----------------------------
;; sadd
;;-----------------------------

define {i8, i1} @sadd_1() nounwind {
; CHECK-LABEL: @sadd_1(
; CHECK-NEXT:    ret { i8, i1 } { i8 44, i1 false }
;
  %t = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 42, i8 2)
  ret {i8, i1} %t
}

define {i8, i1} @sadd_2() nounwind {
; CHECK-LABEL: @sadd_2(
; CHECK-NEXT:    ret { i8, i1 } { i8 -126, i1 true }
;
  %t = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 120, i8 10)
  ret {i8, i1} %t
}

define {i8, i1} @sadd_3() nounwind {
; CHECK-LABEL: @sadd_3(
; CHECK-NEXT:    ret { i8, i1 } { i8 -110, i1 false }
;
  %t = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 -120, i8 10)
  ret {i8, i1} %t
}

define {i8, i1} @sadd_4() nounwind {
; CHECK-LABEL: @sadd_4(
; CHECK-NEXT:    ret { i8, i1 } { i8 126, i1 true }
;
  %t = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 -120, i8 -10)
  ret {i8, i1} %t
}

define {i8, i1} @sadd_5() nounwind {
; CHECK-LABEL: @sadd_5(
; CHECK-NEXT:    ret { i8, i1 } { i8 -8, i1 false }
;
  %t = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 2, i8 -10)
  ret {i8, i1} %t
}


;;-----------------------------
;; ssub
;;-----------------------------

define {i8, i1} @ssub_1() nounwind {
; CHECK-LABEL: @ssub_1(
; CHECK-NEXT:    ret { i8, i1 } { i8 2, i1 false }
;
  %t = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 4, i8 2)
  ret {i8, i1} %t
}

define {i8, i1} @ssub_2() nounwind {
; CHECK-LABEL: @ssub_2(
; CHECK-NEXT:    ret { i8, i1 } { i8 -2, i1 false }
;
  %t = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 4, i8 6)
  ret {i8, i1} %t
}

define {i8, i1} @ssub_3() nounwind {
; CHECK-LABEL: @ssub_3(
; CHECK-NEXT:    ret { i8, i1 } { i8 126, i1 true }
;
  %t = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 -10, i8 120)
  ret {i8, i1} %t
}

define {i8, i1} @ssub_3b() nounwind {
; CHECK-LABEL: @ssub_3b(
; CHECK-NEXT:    ret { i8, i1 } { i8 -20, i1 false }
;
  %t = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 -10, i8 10)
  ret {i8, i1} %t
}

define {i8, i1} @ssub_4() nounwind {
; CHECK-LABEL: @ssub_4(
; CHECK-NEXT:    ret { i8, i1 } { i8 -126, i1 true }
;
  %t = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 120, i8 -10)
  ret {i8, i1} %t
}

define {i8, i1} @ssub_4b() nounwind {
; CHECK-LABEL: @ssub_4b(
; CHECK-NEXT:    ret { i8, i1 } { i8 30, i1 false }
;
  %t = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 20, i8 -10)
  ret {i8, i1} %t
}

define {i8, i1} @ssub_5() nounwind {
; CHECK-LABEL: @ssub_5(
; CHECK-NEXT:    ret { i8, i1 } { i8 -10, i1 false }
;
  %t = call {i8, i1} @llvm.ssub.with.overflow.i8(i8 -20, i8 -10)
  ret {i8, i1} %t
}

;;-----------------------------
;; smul
;;-----------------------------

define {i8, i1} @smul_1() nounwind {
; CHECK-LABEL: @smul_1(
; CHECK-NEXT:    ret { i8, i1 } { i8 -56, i1 true }
;
  %t = call {i8, i1} @llvm.smul.with.overflow.i8(i8 -20, i8 -10)
  ret {i8, i1} %t
}
