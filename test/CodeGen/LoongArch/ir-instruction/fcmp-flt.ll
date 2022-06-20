; RUN: llc --mtriple=loongarch32 --mattr=+f,-d < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 --mattr=+f,-d < %s | FileCheck %s --check-prefix=LA64

;; Test the 'fcmp' LLVM IR: https://llvm.org/docs/LangRef.html#fcmp-instruction
;; over float values.

define i1 @fcmp_false(float %a, float %b) {
; LA32-LABEL: fcmp_false:
; LA32:       # %bb.0:
; LA32-NEXT:    move $a0, $zero
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_false:
; LA64:       # %bb.0:
; LA64-NEXT:    move $a0, $zero
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp false float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_oeq(float %a, float %b) {
; LA32-LABEL: fcmp_oeq:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.ceq.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_oeq:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.ceq.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp oeq float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ogt(float %a, float %b) {
; LA32-LABEL: fcmp_ogt:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.clt.s $fcc0, $fa1, $fa0
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_ogt:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.clt.s $fcc0, $fa1, $fa0
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp ogt float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_oge(float %a, float %b) {
; LA32-LABEL: fcmp_oge:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cle.s $fcc0, $fa1, $fa0
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_oge:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cle.s $fcc0, $fa1, $fa0
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp oge float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_olt(float %a, float %b) {
; LA32-LABEL: fcmp_olt:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.clt.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_olt:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.clt.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp olt float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ole(float %a, float %b) {
; LA32-LABEL: fcmp_ole:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cle.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_ole:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cle.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp ole float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_one(float %a, float %b) {
; LA32-LABEL: fcmp_one:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cne.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_one:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cne.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp one float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ord(float %a, float %b) {
; LA32-LABEL: fcmp_ord:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cor.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_ord:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cor.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp ord float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ueq(float %a, float %b) {
; LA32-LABEL: fcmp_ueq:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cueq.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_ueq:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cueq.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp ueq float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ugt(float %a, float %b) {
; LA32-LABEL: fcmp_ugt:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cult.s $fcc0, $fa1, $fa0
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_ugt:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cult.s $fcc0, $fa1, $fa0
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp ugt float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_uge(float %a, float %b) {
; LA32-LABEL: fcmp_uge:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cule.s $fcc0, $fa1, $fa0
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_uge:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cule.s $fcc0, $fa1, $fa0
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp uge float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ult(float %a, float %b) {
; LA32-LABEL: fcmp_ult:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cult.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_ult:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cult.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp ult float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_ule(float %a, float %b) {
; LA32-LABEL: fcmp_ule:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cule.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_ule:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cule.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp ule float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_une(float %a, float %b) {
; LA32-LABEL: fcmp_une:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cune.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_une:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cune.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp une float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_uno(float %a, float %b) {
; LA32-LABEL: fcmp_uno:
; LA32:       # %bb.0:
; LA32-NEXT:    fcmp.cun.s $fcc0, $fa0, $fa1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_uno:
; LA64:       # %bb.0:
; LA64-NEXT:    fcmp.cun.s $fcc0, $fa0, $fa1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp uno float %a, %b
  ret i1 %cmp
}

define i1 @fcmp_true(float %a, float %b) {
; LA32-LABEL: fcmp_true:
; LA32:       # %bb.0:
; LA32-NEXT:    ori $a0, $zero, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: fcmp_true:
; LA64:       # %bb.0:
; LA64-NEXT:    ori $a0, $zero, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %cmp = fcmp true float %a, %b
  ret i1 %cmp
}
