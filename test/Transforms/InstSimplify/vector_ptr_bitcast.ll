; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instsimplify < %s | FileCheck %s
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"

%mst = type { ptr, ptr }
%mst2 = type { ptr, ptr, ptr, ptr }

@a = private unnamed_addr constant %mst { ptr inttoptr (i64 -1 to ptr),
  ptr inttoptr (i64 -1 to ptr)},
  align 8
@b = private unnamed_addr constant %mst2 { ptr inttoptr (i64 42 to ptr),
  ptr inttoptr (i64 67 to ptr),
  ptr inttoptr (i64 33 to ptr),
  ptr inttoptr (i64 58 to ptr)},
  align 8

define i64 @fn() {
; CHECK-LABEL: @fn(
; CHECK-NEXT:    ret i64 -1
;
  %x = load <2 x ptr>, ptr @a, align 8
  %b = extractelement <2 x ptr> %x, i32 0
  %c = ptrtoint ptr %b to i64
  ret i64 %c
}

define i64 @fn2() {
; CHECK-LABEL: @fn2(
; CHECK-NEXT:    ret i64 100
;
  %x = load <4 x ptr>, ptr @b, align 8
  %b = extractelement <4 x ptr> %x, i32 0
  %c = extractelement <4 x ptr> %x, i32 3
  %d = ptrtoint ptr %b to i64
  %e = ptrtoint ptr %c to i64
  %r = add i64 %d, %e
  ret i64 %r
}
