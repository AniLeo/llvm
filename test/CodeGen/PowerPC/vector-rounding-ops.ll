; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   -mtriple=powerpc64le-unknown-unknown -verify-machineinstrs < %s | \
; RUN:   FileCheck %s --check-prefix=P9
; RUN: llc -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   -mtriple=powerpc64le-unknown-unknown -verify-machineinstrs < %s | \
; RUN:   FileCheck %s
; RUN: llc -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   -mtriple=powerpc64le-unknown-unknown -verify-machineinstrs < %s \
; RUN:   --enable-unsafe-fp-math | FileCheck %s --check-prefix=FAST

define dso_local <2 x double> @test_rint_v2f64(<2 x double> %d) local_unnamed_addr {
; P9-LABEL: test_rint_v2f64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xvrdpic v2, v2
; P9-NEXT:    blr
;
; CHECK-LABEL: test_rint_v2f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvrdpic v2, v2
; CHECK-NEXT:    blr
;
; FAST-LABEL: test_rint_v2f64:
; FAST:       # %bb.0: # %entry
; FAST-NEXT:    xvrdpic v2, v2
; FAST-NEXT:    blr
entry:
  %0 = tail call <2 x double> @llvm.rint.v2f64(<2 x double> %d)
  ret <2 x double> %0
}

declare <2 x double> @llvm.rint.v2f64(<2 x double>)


define dso_local <4 x float> @test_rint_v4f32(<4 x float> %d) local_unnamed_addr {
; P9-LABEL: test_rint_v4f32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xvrspic v2, v2
; P9-NEXT:    blr
;
; CHECK-LABEL: test_rint_v4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvrspic v2, v2
; CHECK-NEXT:    blr
;
; FAST-LABEL: test_rint_v4f32:
; FAST:       # %bb.0: # %entry
; FAST-NEXT:    xvrspic v2, v2
; FAST-NEXT:    blr
entry:
  %0 = tail call <4 x float> @llvm.rint.v4f32(<4 x float> %d)
  ret <4 x float> %0
}

declare <4 x float> @llvm.rint.v4f32(<4 x float>)
