; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; RUN: llc -verify-machineinstrs -csky-no-aliases < %s -mtriple=csky -float-abi=hard -mattr=+hard-float -mattr=+2e3 -mattr=+fpuv2_sf | FileCheck %s --check-prefix=CHECK-SF
; RUN: llc -verify-machineinstrs -csky-no-aliases < %s -mtriple=csky -float-abi=hard -mattr=+hard-float -mattr=+2e3 -mattr=+fpuv3_sf | FileCheck %s --check-prefix=CHECK-SF2

;ueq
define i1 @fcmpRR_ueq(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_ueq:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    fcmpnes vr1, vr0
; CHECK-SF-NEXT:    mvcv16 a1
; CHECK-SF-NEXT:    or16 a0, a1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_ueq:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    fcmpne.32 vr1, vr0
; CHECK-SF2-NEXT:    mvcv16 a1
; CHECK-SF2-NEXT:    or16 a0, a1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ueq float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_ueq(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_ueq:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmpnes vr0, vr1
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvc32 a1
; CHECK-SF-NEXT:    or16 a0, a1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_ueq:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmpne.32 vr0, vr1
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvc32 a1
; CHECK-SF2-NEXT:    or16 a0, a1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ueq float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_ueq(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_ueq:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    fcmpznes vr0
; CHECK-SF-NEXT:    mvcv16 a1
; CHECK-SF-NEXT:    or16 a0, a1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_ueq:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    fcmpnez.32 vr0
; CHECK-SF2-NEXT:    mvcv16 a1
; CHECK-SF2-NEXT:    or16 a0, a1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ueq float %x, 0.0
  ret i1 %fcmp
}


;une
define i1 @fcmpRR_une(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_une:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpnes vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_une:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpne.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp une float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_une(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_une:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmpnes vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_une:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmpne.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp une float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_une(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_une:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpznes vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_une:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpnez.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp une float %x, 0.0
  ret i1 %fcmp
}


;ugt
define i1 @fcmpRR_ugt(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_ugt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmphss vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_ugt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphs.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ugt float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_ugt(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_ugt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmphss vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_ugt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmphs.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ugt float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_ugt(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_ugt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzlss vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_ugt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmplsz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ugt float %x, 0.0
  ret i1 %fcmp
}


;uge
define i1 @fcmpRR_uge(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_uge:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmplts vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_uge:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmplt.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp uge float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_uge(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_uge:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmplts vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_uge:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmplt.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp uge float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_uge(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_uge:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzhss vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_uge:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpltz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp uge float %x, 0.0
  ret i1 %fcmp
}

;ult
define i1 @fcmpRR_ult(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_ult:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmphss vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_ult:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphs.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ult float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_ult(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_ult:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmphss vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_ult:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmphs.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ult float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_ult(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_ult:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzhss vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_ult:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphsz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ult float %x, 0.0
  ret i1 %fcmp
}


;ule
define i1 @fcmpRR_ule(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_ule:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmplts vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_ule:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmplt.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ule float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_ule(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_ule:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmplts vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_ule:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmplt.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ule float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_ule(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_ule:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzlss vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    xori32 a0, a0, 1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_ule:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    xori32 a0, a0, 1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ule float %x, 0.0
  ret i1 %fcmp
}


;ogt
define i1 @fcmpRR_ogt(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_ogt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmplts vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_ogt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmplt.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ogt float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_ogt(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_ogt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmplts vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_ogt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmplt.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ogt float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_ogt(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_ogt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzlss vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_ogt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ogt float %x, 0.0
  ret i1 %fcmp
}


;oge
define i1 @fcmpRR_oge(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_oge:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmphss vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_oge:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphs.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp oge float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_oge(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_oge:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmphss vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_oge:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmphs.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp oge float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_oge(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_oge:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzhss vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_oge:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphsz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp oge float %x, 0.0
  ret i1 %fcmp
}


;olt
define i1 @fcmpRR_olt(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_olt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmplts vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_olt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmplt.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp olt float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_olt(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_olt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmplts vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_olt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmplt.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp olt float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_olt(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_olt:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzhss vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_olt:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpltz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp olt float %x, 0.0
  ret i1 %fcmp
}


;ole
define i1 @fcmpRR_ole(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_ole:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmphss vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_ole:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmphs.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ole float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_ole(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_ole:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmphss vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_ole:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmphs.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ole float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_ole(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_ole:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpzlss vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_ole:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmplsz.32 vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ole float %x, 0.0
  ret i1 %fcmp
}


;one
define i1 @fcmpRR_one(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_one:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr1, vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    fcmpnes vr1, vr0
; CHECK-SF-NEXT:    mvc32 a1
; CHECK-SF-NEXT:    and16 a0, a1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_one:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr1, vr0
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    fcmpne.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a1
; CHECK-SF2-NEXT:    and16 a0, a1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp one float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_one(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_one:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmpnes vr0, vr1
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvcv16 a1
; CHECK-SF-NEXT:    and16 a0, a1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_one:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmpne.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvcv16 a1
; CHECK-SF2-NEXT:    and16 a0, a1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp one float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_one(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_one:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    fcmpznes vr0
; CHECK-SF-NEXT:    mvc32 a1
; CHECK-SF-NEXT:    and16 a0, a1
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_one:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movi16 a0, 0
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmpne.32 vr0, vr1
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvcv16 a1
; CHECK-SF2-NEXT:    and16 a0, a1
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp one float %x, 0.0
  ret i1 %fcmp
}


;oeq
define i1 @fcmpRR_oeq(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_oeq:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpnes vr1, vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_oeq:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpne.32 vr1, vr0
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp oeq float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_oeq(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_oeq:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    movih32 a0, 49440
; CHECK-SF-NEXT:    fmtvrl vr1, a0
; CHECK-SF-NEXT:    fcmpnes vr0, vr1
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_oeq:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    movih32 a0, 49440
; CHECK-SF2-NEXT:    fmtvr.32.1 vr1, a0
; CHECK-SF2-NEXT:    fcmpne.32 vr0, vr1
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp oeq float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_oeq(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_oeq:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpznes vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_oeq:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpnez.32 vr0
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp oeq float %x, 0.0
  ret i1 %fcmp
}


;ord
define i1 @fcmpRR_ord(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_ord:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr1, vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_ord:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr1, vr0
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ord float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_ord(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_ord:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_ord:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ord float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_ord(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_ord:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvcv16 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_ord:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvcv16 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp ord float %x, 0.0
  ret i1 %fcmp
}


;uno
define i1 @fcmpRR_uno(float %x, float %y) {
;
; CHECK-SF-LABEL: fcmpRR_uno:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr1, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRR_uno:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr1, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp uno float %y, %x
  ret i1 %fcmp
}

define i1 @fcmpRI_uno(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_uno:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_uno:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp uno float %x, -10.0
  ret i1 %fcmp
}

define i1 @fcmpRI_X_uno(float %x) {
;
; CHECK-SF-LABEL: fcmpRI_X_uno:
; CHECK-SF:       # %bb.0: # %entry
; CHECK-SF-NEXT:    fcmpuos vr0, vr0
; CHECK-SF-NEXT:    mvc32 a0
; CHECK-SF-NEXT:    rts16
;
; CHECK-SF2-LABEL: fcmpRI_X_uno:
; CHECK-SF2:       # %bb.0: # %entry
; CHECK-SF2-NEXT:    fcmpuo.32 vr0, vr0
; CHECK-SF2-NEXT:    mvc32 a0
; CHECK-SF2-NEXT:    rts16
entry:
  %fcmp = fcmp uno float %x, 0.0
  ret i1 %fcmp
}
