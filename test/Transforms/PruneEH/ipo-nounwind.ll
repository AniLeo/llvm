; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -prune-eh -enable-new-pm=0 < %s | FileCheck %s
; RUN: opt -S -passes='function-attrs,function(simplify-cfg)' < %s | FileCheck %s

declare void @may_throw()

; @callee below may be an optimized form of this function, which can
; throw at runtime (see r265762 for more details):
;
; define linkonce_odr void @callee(i32* %ptr) noinline {
; entry:
;   %val0 = load atomic i32, i32* %ptr unordered, align 4
;   %val1 = load atomic i32, i32* %ptr unordered, align 4
;   %cmp = icmp eq i32 %val0, %val1
;   br i1 %cmp, label %left, label %right

; left:
;   ret void

; right:
;   call void @may_throw()
;   ret void
; }

define linkonce_odr void @callee(i32* %ptr) noinline {
; CHECK-LABEL: @callee(
; CHECK-NEXT:    ret void
;
  ret void
}

define i32 @caller(i32* %ptr) personality i32 3 {
; CHECK-LABEL: @caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    invoke void @callee(i32* [[PTR:%.*]])
; CHECK-NEXT:    to label [[NORMAL:%.*]] unwind label [[UNWIND:%.*]]
; CHECK:       normal:
; CHECK-NEXT:    ret i32 1
; CHECK:       unwind:
; CHECK-NEXT:    [[RES:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    ret i32 2
;

entry:
  invoke void @callee(i32* %ptr)
  to label %normal unwind label %unwind

normal:
  ret i32 1

unwind:
  %res = landingpad { i8*, i32 }
  cleanup
  ret i32 2
}
