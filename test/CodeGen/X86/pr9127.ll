; RUN: llc < %s | FileCheck %s

define i8 @foobar(double %d, double* %x) {
entry:
  %tmp2 = load double* %x, align 8
  %cmp = fcmp oeq double %tmp2, %d
  %conv3 = zext i1 %cmp to i8
  ret i8 %conv3
}

; test that the load is folded.
; CHECK: ucomisd	(%rdi), %xmm0
