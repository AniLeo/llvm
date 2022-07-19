; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

define i32 @t1(ptr %X, i32 %i) {
; CHECK-LABEL: t1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movzbl %cl, %ecx
; CHECK-NEXT:    movl (%eax,%ecx,4), %eax
; CHECK-NEXT:    retl

entry:
  %tmp2 = shl i32 %i, 2
  %tmp4 = and i32 %tmp2, 1020
  %tmp7 = getelementptr i8, ptr %X, i32 %tmp4
  %tmp9 = load i32, ptr %tmp7
  ret i32 %tmp9
}

define i32 @t2(ptr %X, i32 %i) {
; CHECK-LABEL: t2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movzwl %cx, %ecx
; CHECK-NEXT:    movl (%eax,%ecx,4), %eax
; CHECK-NEXT:    retl

entry:
  %tmp2 = shl i32 %i, 1
  %tmp4 = and i32 %tmp2, 131070
  %tmp7 = getelementptr i16, ptr %X, i32 %tmp4
  %tmp9 = load i32, ptr %tmp7
  ret i32 %tmp9
}

define i32 @t3(ptr %i.ptr, ptr %arr) {
; This case is tricky. The lshr followed by a gep will produce a lshr followed
; by an and to remove the low bits. This can be simplified by doing the lshr by
; a greater constant and using the addressing mode to scale the result back up.
; To make matters worse, because of the two-phase zext of %i and their reuse in
; the function, the DAG can get confusing trying to re-use both of them and
; prevent easy analysis of the mask in order to match this.
; CHECK-LABEL: t3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzwl (%eax), %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    shrl $11, %edx
; CHECK-NEXT:    addl (%ecx,%edx,4), %eax
; CHECK-NEXT:    retl

entry:
  %i = load i16, ptr %i.ptr
  %i.zext = zext i16 %i to i32
  %index = lshr i32 %i.zext, 11
  %val.ptr = getelementptr inbounds i32, ptr %arr, i32 %index
  %val = load i32, ptr %val.ptr
  %sum = add i32 %val, %i.zext
  ret i32 %sum
}

define i32 @t4(ptr %i.ptr, ptr %arr) {
; A version of @t3 that has more zero extends and more re-use of intermediate
; values. This exercise slightly different bits of canonicalization.
; CHECK-LABEL: t4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzwl (%eax), %eax
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    shrl $11, %edx
; CHECK-NEXT:    addl (%ecx,%edx,4), %eax
; CHECK-NEXT:    addl %edx, %eax
; CHECK-NEXT:    retl

entry:
  %i = load i16, ptr %i.ptr
  %i.zext = zext i16 %i to i32
  %index = lshr i32 %i.zext, 11
  %index.zext = zext i32 %index to i64
  %val.ptr = getelementptr inbounds i32, ptr %arr, i64 %index.zext
  %val = load i32, ptr %val.ptr
  %sum.1 = add i32 %val, %i.zext
  %sum.2 = add i32 %sum.1, %index
  ret i32 %sum.2
}

define i8 @t5(ptr %X, i32 %i) {
; CHECK-LABEL: t5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    andl $-14, %ecx
; CHECK-NEXT:    movzbl (%eax,%ecx,4), %eax
; CHECK-NEXT:    retl

entry:
  %tmp2 = shl i32 %i, 2
  %tmp4 = and i32 %tmp2, -56
  %tmp7 = getelementptr i8, ptr %X, i32 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}

define i8 @t6(ptr %X, i32 %i) {
; CHECK-LABEL: t6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl $-255, %ecx
; CHECK-NEXT:    andl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movzbl (%eax,%ecx,4), %eax
; CHECK-NEXT:    retl

entry:
  %tmp2 = shl i32 %i, 2
  %tmp4 = and i32 %tmp2, -1020
  %tmp7 = getelementptr i8, ptr %X, i32 %tmp4
  %tmp9 = load i8, ptr %tmp7
  ret i8 %tmp9
}
