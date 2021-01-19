; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -early-cse -earlycse-debug-hash | FileCheck %s

; Store-to-load forwarding across a @llvm.experimental.noalias.scope.decl.

define float @s2l(float* %p) {
; CHECK-LABEL: @s2l(
; CHECK-NEXT:    store float 0.000000e+00, float* [[P:%.*]], align 4
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    ret float 0.000000e+00
;
  store float 0.0, float* %p
  call void @llvm.experimental.noalias.scope.decl(metadata !0)
  %t = load float, float* %p
  ret float %t
}

; Redundant load elimination across a @llvm.experimental.noalias.scope.decl.

define float @rle(float* %p) {
; CHECK-LABEL: @rle(
; CHECK-NEXT:    [[R:%.*]] = load float, float* [[P:%.*]], align 4
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    [[T:%.*]] = fadd float [[R]], [[R]]
; CHECK-NEXT:    ret float [[T]]
;
  %r = load float, float* %p
  call void @llvm.experimental.noalias.scope.decl(metadata !0)
  %s = load float, float* %p
  %t = fadd float %r, %s
  ret float %t
}

declare void @llvm.experimental.noalias.scope.decl(metadata)

!0 = !{ !1 }
!1 = distinct !{ !1, !2 }
!2 = distinct !{ !2 }
