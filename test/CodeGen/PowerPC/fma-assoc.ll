; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=ppc32-- -fp-contract=fast -mattr=-vsx -disable-ppc-vsx-fma-mutation=false | FileCheck -check-prefix=CHECK-SAFE %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-unknown-linux-gnu -fp-contract=fast -mattr=+vsx -mcpu=pwr7 -disable-ppc-vsx-fma-mutation=false | FileCheck -check-prefix=CHECK-VSX-SAFE %s
; RUN: llc -verify-machineinstrs < %s -mtriple=ppc32-- -fp-contract=fast -enable-unsafe-fp-math -mattr=-vsx -disable-ppc-vsx-fma-mutation=false | FileCheck -check-prefix=CHECK-UNSAFE %s
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-unknown-linux-gnu -fp-contract=fast -enable-unsafe-fp-math -mattr=+vsx -mcpu=pwr7 -disable-ppc-vsx-fma-mutation=false | FileCheck -check-prefix=CHECK-VSX-UNSAFE %s

define double @test_FMADD_ASSOC1(double %A, double %B, double %C,
; CHECK-SAFE-LABEL: test_FMADD_ASSOC1:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmul 0, 3, 4
; CHECK-SAFE-NEXT:    fmadd 0, 1, 2, 0
; CHECK-SAFE-NEXT:    fadd 1, 0, 5
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMADD_ASSOC1:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-SAFE-NEXT:    xsadddp 1, 0, 5
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMADD_ASSOC1:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmadd 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMADD_ASSOC1:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fadd double %H, %E         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMADD_ASSOC2(double %A, double %B, double %C,
; CHECK-SAFE-LABEL: test_FMADD_ASSOC2:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmul 0, 3, 4
; CHECK-SAFE-NEXT:    fmadd 0, 1, 2, 0
; CHECK-SAFE-NEXT:    fadd 1, 5, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMADD_ASSOC2:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-SAFE-NEXT:    xsadddp 1, 5, 0
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMADD_ASSOC2:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmadd 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMADD_ASSOC2:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fadd double %E, %H         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMSUB_ASSOC1(double %A, double %B, double %C,
; CHECK-SAFE-LABEL: test_FMSUB_ASSOC1:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmul 0, 3, 4
; CHECK-SAFE-NEXT:    fmadd 0, 1, 2, 0
; CHECK-SAFE-NEXT:    fsub 1, 0, 5
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMSUB_ASSOC1:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-SAFE-NEXT:    xssubdp 1, 0, 5
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMSUB_ASSOC1:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmsub 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMSUB_ASSOC1:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmsubmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fsub double %H, %E         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMSUB_ASSOC2(double %A, double %B, double %C,
; CHECK-SAFE-LABEL: test_FMSUB_ASSOC2:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmul 0, 3, 4
; CHECK-SAFE-NEXT:    fmadd 0, 1, 2, 0
; CHECK-SAFE-NEXT:    fsub 1, 5, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMSUB_ASSOC2:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmuldp 0, 3, 4
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 0, 1, 2
; CHECK-VSX-SAFE-NEXT:    xssubdp 1, 5, 0
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMSUB_ASSOC2:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fnmsub 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fnmsub 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMSUB_ASSOC2:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsnmsubmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsnmsubadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul double %A, %B         ; <double> [#uses=1]
  %G = fmul double %C, %D         ; <double> [#uses=1]
  %H = fadd double %F, %G         ; <double> [#uses=1]
  %I = fsub double %E, %H         ; <double> [#uses=1]
  ret double %I
}

define double @test_FMADD_ASSOC_EXT1(float %A, float %B, double %C,
; CHECK-SAFE-LABEL: test_FMADD_ASSOC_EXT1:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmadd 0, 1, 2, 5
; CHECK-SAFE-NEXT:    fmadd 1, 3, 4, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMADD_ASSOC_EXT1:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMADD_ASSOC_EXT1:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmadd 0, 1, 2, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 3, 4, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMADD_ASSOC_EXT1:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B         ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fadd double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMADD_ASSOC_EXT2(float %A, float %B, float %C,
; CHECK-SAFE-LABEL: test_FMADD_ASSOC_EXT2:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmadd 0, 3, 4, 5
; CHECK-SAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMADD_ASSOC_EXT2:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-SAFE-NEXT:    fmr 1, 3
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMADD_ASSOC_EXT2:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmadd 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMADD_ASSOC_EXT2:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B         ; <float> [#uses=1]
  %G = fmul float %C, %D         ; <float> [#uses=1]
  %H = fadd float %F, %G         ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fadd double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMADD_ASSOC_EXT3(float %A, float %B, double %C,
; CHECK-SAFE-LABEL: test_FMADD_ASSOC_EXT3:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmadd 0, 1, 2, 5
; CHECK-SAFE-NEXT:    fmadd 1, 3, 4, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMADD_ASSOC_EXT3:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMADD_ASSOC_EXT3:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmadd 0, 1, 2, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 3, 4, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMADD_ASSOC_EXT3:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmaddmdp 1, 2, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fadd double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMADD_ASSOC_EXT4(float %A, float %B, float %C,
; CHECK-SAFE-LABEL: test_FMADD_ASSOC_EXT4:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmadd 0, 3, 4, 5
; CHECK-SAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMADD_ASSOC_EXT4:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-SAFE-NEXT:    fmr 1, 3
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMADD_ASSOC_EXT4:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmadd 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMADD_ASSOC_EXT4:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmaddmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fmul float %C, %D          ; <float> [#uses=1]
  %H = fadd float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fadd double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT1(float %A, float %B, double %C,
; CHECK-SAFE-LABEL: test_FMSUB_ASSOC_EXT1:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmsub 0, 1, 2, 5
; CHECK-SAFE-NEXT:    fmadd 1, 3, 4, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMSUB_ASSOC_EXT1:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmsubmdp 1, 2, 5
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT1:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmsub 0, 1, 2, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 3, 4, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT1:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmsubmdp 1, 2, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 1, 3, 4
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fsub double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT2(float %A, float %B, float %C,
; CHECK-SAFE-LABEL: test_FMSUB_ASSOC_EXT2:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fmsub 0, 3, 4, 5
; CHECK-SAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMSUB_ASSOC_EXT2:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsmsubmdp 3, 4, 5
; CHECK-VSX-SAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-SAFE-NEXT:    fmr 1, 3
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT2:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fmsub 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fmadd 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT2:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsmsubmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsmaddadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fmul float %C, %D          ; <float> [#uses=1]
  %H = fadd float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fsub double %I, %E         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT3(float %A, float %B, double %C,
; CHECK-SAFE-LABEL: test_FMSUB_ASSOC_EXT3:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fnmsub 0, 1, 2, 5
; CHECK-SAFE-NEXT:    fnmsub 1, 3, 4, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMSUB_ASSOC_EXT3:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsnmsubmdp 1, 2, 5
; CHECK-VSX-SAFE-NEXT:    xsnmsubadp 1, 3, 4
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT3:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fnmsub 0, 1, 2, 5
; CHECK-UNSAFE-NEXT:    fnmsub 1, 3, 4, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT3:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsnmsubmdp 1, 2, 5
; CHECK-VSX-UNSAFE-NEXT:    xsnmsubadp 1, 3, 4
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 double %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fpext float %F to double   ; <double> [#uses=1]
  %H = fmul double %C, %D         ; <double> [#uses=1]
  %I = fadd double %H, %G         ; <double> [#uses=1]
  %J = fsub double %E, %I         ; <double> [#uses=1]
  ret double %J
}

define double @test_FMSUB_ASSOC_EXT4(float %A, float %B, float %C,
; CHECK-SAFE-LABEL: test_FMSUB_ASSOC_EXT4:
; CHECK-SAFE:       # %bb.0:
; CHECK-SAFE-NEXT:    fnmsub 0, 3, 4, 5
; CHECK-SAFE-NEXT:    fnmsub 1, 1, 2, 0
; CHECK-SAFE-NEXT:    blr
;
; CHECK-VSX-SAFE-LABEL: test_FMSUB_ASSOC_EXT4:
; CHECK-VSX-SAFE:       # %bb.0:
; CHECK-VSX-SAFE-NEXT:    xsnmsubmdp 3, 4, 5
; CHECK-VSX-SAFE-NEXT:    xsnmsubadp 3, 1, 2
; CHECK-VSX-SAFE-NEXT:    fmr 1, 3
; CHECK-VSX-SAFE-NEXT:    blr
;
; CHECK-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT4:
; CHECK-UNSAFE:       # %bb.0:
; CHECK-UNSAFE-NEXT:    fnmsub 0, 3, 4, 5
; CHECK-UNSAFE-NEXT:    fnmsub 1, 1, 2, 0
; CHECK-UNSAFE-NEXT:    blr
;
; CHECK-VSX-UNSAFE-LABEL: test_FMSUB_ASSOC_EXT4:
; CHECK-VSX-UNSAFE:       # %bb.0:
; CHECK-VSX-UNSAFE-NEXT:    xsnmsubmdp 3, 4, 5
; CHECK-VSX-UNSAFE-NEXT:    xsnmsubadp 3, 1, 2
; CHECK-VSX-UNSAFE-NEXT:    fmr 1, 3
; CHECK-VSX-UNSAFE-NEXT:    blr
                                 float %D, double %E) {
  %F = fmul float %A, %B          ; <float> [#uses=1]
  %G = fmul float %C, %D          ; <float> [#uses=1]
  %H = fadd float %F, %G          ; <float> [#uses=1]
  %I = fpext float %H to double   ; <double> [#uses=1]
  %J = fsub double %E, %I         ; <double> [#uses=1]
  ret double %J
}
