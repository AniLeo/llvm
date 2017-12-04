; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=bdver2 -mattr=-fma -mtriple=i686-apple-darwin < %s | FileCheck %s
; RUN: llc -mcpu=bdver2 -mattr=-fma,-fma4 -mtriple=i686-apple-darwin < %s | FileCheck %s --check-prefix=CHECK-NOFMA

; CHECK-LABEL: fmafunc
; CHECK-NOFMA-LABEL: fmafunc
define <16 x float> @fmafunc(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: fmafunc:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushl %ebp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    .cfi_offset %ebp, -8
; CHECK-NEXT:    movl %esp, %ebp
; CHECK-NEXT:    .cfi_def_cfa_register %ebp
; CHECK-NEXT:    andl $-32, %esp
; CHECK-NEXT:    subl $32, %esp
; CHECK-NEXT:    vfmaddps 8(%ebp), %ymm2, %ymm0, %ymm0
; CHECK-NEXT:    vfmaddps 40(%ebp), %ymm3, %ymm1, %ymm1
; CHECK-NEXT:    movl %ebp, %esp
; CHECK-NEXT:    popl %ebp
; CHECK-NEXT:    retl
;
; CHECK-NOFMA-LABEL: fmafunc:
; CHECK-NOFMA:       ## %bb.0:
; CHECK-NOFMA-NEXT:    pushl %ebp
; CHECK-NOFMA-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NOFMA-NEXT:    .cfi_offset %ebp, -8
; CHECK-NOFMA-NEXT:    movl %esp, %ebp
; CHECK-NOFMA-NEXT:    .cfi_def_cfa_register %ebp
; CHECK-NOFMA-NEXT:    andl $-32, %esp
; CHECK-NOFMA-NEXT:    subl $32, %esp
; CHECK-NOFMA-NEXT:    vmulps %ymm2, %ymm0, %ymm0
; CHECK-NOFMA-NEXT:    vaddps 8(%ebp), %ymm0, %ymm0
; CHECK-NOFMA-NEXT:    vmulps %ymm3, %ymm1, %ymm1
; CHECK-NOFMA-NEXT:    vaddps 40(%ebp), %ymm1, %ymm1
; CHECK-NOFMA-NEXT:    movl %ebp, %esp
; CHECK-NOFMA-NEXT:    popl %ebp
; CHECK-NOFMA-NEXT:    retl


  %ret = tail call <16 x float> @llvm.fmuladd.v16f32(<16 x float> %a, <16 x float> %b, <16 x float> %c)
  ret <16 x float> %ret
}

declare <16 x float> @llvm.fmuladd.v16f32(<16 x float>, <16 x float>, <16 x float>) nounwind readnone
