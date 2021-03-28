; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

define void @foo(i32 %n, double* nocapture %p) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %bb
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    fldl (%eax,%ecx,8)
; CHECK-NEXT:    fmull {{\.LCPI[0-9]+_[0-9]+}}
; CHECK-NEXT:    fstpl (%eax,%ecx,8)
; CHECK-NEXT:    decl %ecx
; CHECK-NEXT:    js .LBB0_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retl
	br label %bb

bb:
	%indvar = phi i32 [ 0, %0 ], [ %indvar.next, %bb ]
	%i.03 = sub i32 %n, %indvar
	%1 = getelementptr double, double* %p, i32 %i.03
	%2 = load double, double* %1, align 4
	%3 = fmul double %2, 2.930000e+00
	store double %3, double* %1, align 4
	%4 = add i32 %i.03, -1
	%phitmp = icmp slt i32 %4, 0
	%indvar.next = add i32 %indvar, 1
	br i1 %phitmp, label %bb, label %return

return:
	ret void
}
