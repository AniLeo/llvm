; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=ppc32-- -fp-contract=fast \
; RUN:   -mattr=-vsx -disable-ppc-vsx-fma-mutation=false | FileCheck %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc-ibm-aix-xcoff -fp-contract=fast \
; RUN:   -mattr=-vsx -disable-ppc-vsx-fma-mutation=false | FileCheck %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -fp-contract=fast -mattr=+vsx -disable-ppc-vsx-fma-mutation=false \
; RUN:   -mcpu=pwr7 | FileCheck -check-prefix=CHECK-VSX %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-ibm-aix-xcoff \
; RUN:   -fp-contract=fast -mattr=+vsx -disable-ppc-vsx-fma-mutation=false \
; RUN:   -mcpu=pwr7 -vec-extabi | FileCheck -check-prefix=CHECK-VSX %s

define double @test_FMADD_ASSOC1(double %A, double %B, double %C,
; CHECK-LABEL: test_FMADD_ASSOC1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul 0, 3, 4
; CHECK-NEXT:    fmadd 0, 1, 2, 0
; CHECK-NEXT:    fadd 1, 0, 5
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMADD_ASSOC1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    xsadddp 1, 0, 5
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fadd double %H, %E         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMADD_ASSOC2(double %A, double %B, double %C,
; CHECK-LABEL: test_FMADD_ASSOC2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul 0, 3, 4
; CHECK-NEXT:    fmadd 0, 1, 2, 0
; CHECK-NEXT:    fadd 1, 5, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMADD_ASSOC2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    xsadddp 1, 5, 0
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fadd double %E, %H         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMSUB_ASSOC1(double %A, double %B, double %C,
; CHECK-LABEL: test_FMSUB_ASSOC1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul 0, 3, 4
; CHECK-NEXT:    fmadd 0, 1, 2, 0
; CHECK-NEXT:    fsub 1, 0, 5
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMSUB_ASSOC1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    xssubdp 1, 0, 5
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fsub double %H, %E         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMSUB_ASSOC2(double %A, double %B, double %C,
; CHECK-LABEL: test_FMSUB_ASSOC2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul 0, 3, 4
; CHECK-NEXT:    fmadd 0, 1, 2, 0
; CHECK-NEXT:    fsub 1, 5, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMSUB_ASSOC2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    xssubdp 1, 5, 0
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fsub double %E, %H         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMADD_ASSOC_EXT1(float %A, float %B, double %C,
; CHECK-LABEL: test_FMADD_ASSOC_EXT1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 1, 2, 5
; CHECK-NEXT:    fmadd 1, 3, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMADD_ASSOC_EXT1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B         ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fadd double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMADD_ASSOC_EXT2(float %A, float %B, float %C,
; CHECK-LABEL: test_FMADD_ASSOC_EXT2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMADD_ASSOC_EXT2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B         ; <float> [#uses=1]
  %G = fmul float %C, %D         ; <float> [#uses=1]
  %H = fadd float %F, %G         ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fadd double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMADD_ASSOC_EXT3(float %A, float %B, double %C,
; CHECK-LABEL: test_FMADD_ASSOC_EXT3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 1, 2, 5
; CHECK-NEXT:    fmadd 1, 3, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMADD_ASSOC_EXT3:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fadd double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMADD_ASSOC_EXT4(float %A, float %B, float %C,
; CHECK-LABEL: test_FMADD_ASSOC_EXT4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMADD_ASSOC_EXT4:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fmul float %C, %D          ; <float> [#uses=1]
  %H = fadd float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fadd double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT1(float %A, float %B, double %C,
; CHECK-LABEL: test_FMSUB_ASSOC_EXT1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmsub 0, 1, 2, 5
; CHECK-NEXT:    fmadd 1, 3, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMSUB_ASSOC_EXT1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmsubmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fsub double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT2(float %A, float %B, float %C,
; CHECK-LABEL: test_FMSUB_ASSOC_EXT2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmsub 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMSUB_ASSOC_EXT2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmsubmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fmul float %C, %D          ; <float> [#uses=1]
  %H = fadd float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fsub double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT3(float %A, float %B, double %C,
; CHECK-LABEL: test_FMSUB_ASSOC_EXT3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fneg 0, 1
; CHECK-NEXT:    fmadd 0, 0, 2, 5
; CHECK-NEXT:    fneg 1, 3
; CHECK-NEXT:    fmadd 1, 1, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMSUB_ASSOC_EXT3:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsnegdp 1, 1
; CHECK-VSX-NEXT:    xsnegdp 0, 3
; CHECK-VSX-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 0, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fsub double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT4(float %A, float %B, float %C,
; CHECK-LABEL: test_FMSUB_ASSOC_EXT4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fneg 0, 3
; CHECK-NEXT:    fmadd 0, 0, 4, 5
; CHECK-NEXT:    fneg 1, 1
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_FMSUB_ASSOC_EXT4:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsnegdp 0, 3
; CHECK-VSX-NEXT:    xsnegdp 1, 1
; CHECK-VSX-NEXT:    xsmaddmdp 0, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 0
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fmul float %C, %D          ; <float> [#uses=1]
  %H = fadd float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fsub double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_reassoc_FMADD_ASSOC1(double %A, double %B, double %C,
; CHECK-LABEL: test_reassoc_FMADD_ASSOC1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMADD_ASSOC1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc double %A, %B         ; <double> [#uses=1]
  %G = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %H = fadd reassoc double %F, %G         ; <double> [#uses=1]
  %I = fadd reassoc double %H, %E         ; <double> [#uses=1]
  ret double %I
}

define double @test_reassoc_FMADD_ASSOC2(double %A, double %B, double %C,
; CHECK-LABEL: test_reassoc_FMADD_ASSOC2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMADD_ASSOC2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc double %A, %B         ; <double> [#uses=1]
  %G = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %H = fadd reassoc double %F, %G         ; <double> [#uses=1]
  %I = fadd reassoc double %E, %H         ; <double> [#uses=1]
  ret double %I
}

; FIXME: -ffp-contract=fast does NOT work here?
define double @test_reassoc_FMSUB_ASSOC1(double %A, double %B, double %C,
; CHECK-LABEL: test_reassoc_FMSUB_ASSOC1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul 0, 3, 4
; CHECK-NEXT:    fmadd 0, 1, 2, 0
; CHECK-NEXT:    fsub 1, 0, 5
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMSUB_ASSOC1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    xssubdp 1, 0, 5
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc double %A, %B         ; <double> [#uses=1]
  %G = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %H = fadd reassoc double %F, %G         ; <double> [#uses=1]
  %I = fsub reassoc double %H, %E         ; <double> [#uses=1]
  ret double %I
}

define double @test_reassoc_FMSUB_ASSOC11(double %A, double %B, double %C,
; CHECK-LABEL: test_reassoc_FMSUB_ASSOC11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmsub 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMSUB_ASSOC11:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmsubmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul contract reassoc double %A, %B         ; <double> [#uses=1]
  %G = fmul contract reassoc double %C, %D         ; <double> [#uses=1]
  %H = fadd contract reassoc double %F, %G         ; <double> [#uses=1]
  %I = fsub contract reassoc double %H, %E         ; <double> [#uses=1]
  ret double %I
}


define double @test_reassoc_FMSUB_ASSOC2(double %A, double %B, double %C,
; CHECK-LABEL: test_reassoc_FMSUB_ASSOC2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul 0, 3, 4
; CHECK-NEXT:    fmadd 0, 1, 2, 0
; CHECK-NEXT:    fsub 1, 5, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMSUB_ASSOC2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    xssubdp 1, 5, 0
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc double %A, %B         ; <double> [#uses=1]
  %G = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %H = fadd reassoc double %F, %G         ; <double> [#uses=1]
  %I = fsub reassoc double %E, %H         ; <double> [#uses=1]
  ret double %I
}

define double @test_fast_FMSUB_ASSOC2(double %A, double %B, double %C,
; CHECK-LABEL: test_fast_FMSUB_ASSOC2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul 0, 3, 4
; CHECK-NEXT:    fmadd 0, 1, 2, 0
; CHECK-NEXT:    fsub 1, 5, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_fast_FMSUB_ASSOC2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    xssubdp 1, 5, 0
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc double %A, %B         ; <double> [#uses=1]
  %G = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %H = fadd reassoc double %F, %G         ; <double> [#uses=1]
  %I = fsub reassoc nsz double %E, %H         ; <double> [#uses=1]
  ret double %I
}

define double @test_reassoc_FMADD_ASSOC_EXT1(float %A, float %B, double %C,
; CHECK-LABEL: test_reassoc_FMADD_ASSOC_EXT1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 1, 2, 5
; CHECK-NEXT:    fmadd 1, 3, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMADD_ASSOC_EXT1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc float %A, %B         ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %I = fadd reassoc double %H, %G         ; <double> [#uses=1]
  %J = fadd reassoc double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_reassoc_FMADD_ASSOC_EXT2(float %A, float %B, float %C,
; CHECK-LABEL: test_reassoc_FMADD_ASSOC_EXT2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMADD_ASSOC_EXT2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul reassoc float %A, %B         ; <float> [#uses=1]
  %G = fmul reassoc float %C, %D         ; <float> [#uses=1]
  %H = fadd reassoc float %F, %G         ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fadd reassoc double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_reassoc_FMADD_ASSOC_EXT3(float %A, float %B, double %C,
; CHECK-LABEL: test_reassoc_FMADD_ASSOC_EXT3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 1, 2, 5
; CHECK-NEXT:    fmadd 1, 3, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMADD_ASSOC_EXT3:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %I = fadd reassoc double %H, %G         ; <double> [#uses=1]
  %J = fadd reassoc double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_reassoc_FMADD_ASSOC_EXT4(float %A, float %B, float %C,
; CHECK-LABEL: test_reassoc_FMADD_ASSOC_EXT4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmadd 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMADD_ASSOC_EXT4:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul reassoc float %A, %B          ; <float> [#uses=1]
  %G = fmul reassoc float %C, %D          ; <float> [#uses=1]
  %H = fadd reassoc float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fadd reassoc double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_reassoc_FMSUB_ASSOC_EXT1(float %A, float %B, double %C,
; CHECK-LABEL: test_reassoc_FMSUB_ASSOC_EXT1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmsub 0, 1, 2, 5
; CHECK-NEXT:    fmadd 1, 3, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMSUB_ASSOC_EXT1:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmsubmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %I = fadd reassoc double %H, %G         ; <double> [#uses=1]
  %J = fsub reassoc double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_reassoc_FMSUB_ASSOC_EXT2(float %A, float %B, float %C,
; CHECK-LABEL: test_reassoc_FMSUB_ASSOC_EXT2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmsub 0, 3, 4, 5
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMSUB_ASSOC_EXT2:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsmsubmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul reassoc float %A, %B          ; <float> [#uses=1]
  %G = fmul reassoc float %C, %D          ; <float> [#uses=1]
  %H = fadd reassoc float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fsub reassoc double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_reassoc_FMSUB_ASSOC_EXT3(float %A, float %B, double %C,
; CHECK-LABEL: test_reassoc_FMSUB_ASSOC_EXT3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fneg 0, 1
; CHECK-NEXT:    fmadd 0, 0, 2, 5
; CHECK-NEXT:    fneg 1, 3
; CHECK-NEXT:    fmadd 1, 1, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMSUB_ASSOC_EXT3:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsnegdp 1, 1
; CHECK-VSX-NEXT:    xsnegdp 0, 3
; CHECK-VSX-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsmaddadp 1, 0, 4
; CHECK-VSX-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul reassoc float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul reassoc double %C, %D         ; <double> [#uses=1]
  %I = fadd reassoc double %H, %G         ; <double> [#uses=1]
  %J = fsub reassoc double %E, %I         ; <double> [#uses=1]
  ret double %J
}

; fnmsub/xsnmsubadp may affect the sign of zero, we need nsz flag
; to ensure generating them
define double @test_fast_FMSUB_ASSOC_EXT3(float %A, float %B, double %C,
; CHECK-LABEL: test_fast_FMSUB_ASSOC_EXT3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fnmsub 0, 1, 2, 5
; CHECK-NEXT:    fnmsub 1, 3, 4, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_fast_FMSUB_ASSOC_EXT3:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsnmsubmdp 1, 2, 5
; CHECK-VSX-NEXT:    xsnmsubadp 1, 3, 4
; CHECK-VSX-NEXT:    blr
                                             double %D, double %E) {
  %F = fmul reassoc float %A, %B
  %G = fpext float %F to double
  %H = fmul reassoc double %C, %D
  %I = fadd reassoc nsz double %H, %G
  %J = fsub reassoc nsz double %E, %I
  ret double %J
}

define double @test_reassoc_FMSUB_ASSOC_EXT4(float %A, float %B, float %C,
; CHECK-LABEL: test_reassoc_FMSUB_ASSOC_EXT4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fneg 0, 3
; CHECK-NEXT:    fmadd 0, 0, 4, 5
; CHECK-NEXT:    fneg 1, 1
; CHECK-NEXT:    fmadd 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_reassoc_FMSUB_ASSOC_EXT4:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsnegdp 0, 3
; CHECK-VSX-NEXT:    xsnegdp 1, 1
; CHECK-VSX-NEXT:    xsmaddmdp 0, 4, 5
; CHECK-VSX-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 0
; CHECK-VSX-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul reassoc float %A, %B          ; <float> [#uses=1]
  %G = fmul reassoc float %C, %D          ; <float> [#uses=1]
  %H = fadd reassoc float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fsub reassoc double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_fast_FMSUB_ASSOC_EXT4(float %A, float %B, float %C,
; CHECK-LABEL: test_fast_FMSUB_ASSOC_EXT4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fnmsub 0, 3, 4, 5
; CHECK-NEXT:    fnmsub 1, 1, 2, 0
; CHECK-NEXT:    blr
;
; CHECK-VSX-LABEL: test_fast_FMSUB_ASSOC_EXT4:
; CHECK-VSX:       # %bb.0:
; CHECK-VSX-NEXT:    xsnmsubmdp 3, 4, 5
; CHECK-VSX-NEXT:    xsnmsubadp 3, 1, 2
; CHECK-VSX-NEXT:    fmr 1, 3
; CHECK-VSX-NEXT:    blr
                                          float %D, double %E) {
  %F = fmul reassoc float %A, %B
  %G = fmul reassoc float %C, %D
  %H = fadd reassoc nsz float %F, %G
  %I = fpext float %H to double
  %J = fsub reassoc nsz double %E, %I
  ret double %J
}
