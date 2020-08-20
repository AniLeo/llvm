; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64-unknown-linux -mcpu=pwr8 | FileCheck %s
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr9 | FileCheck %s
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr8 -mattr=-vsx | \
; RUN:   FileCheck %s -check-prefix=NOVSX

declare i32 @llvm.experimental.constrained.fptosi.i32.f64(double, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.f64(double, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f64(double, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f64(double, metadata)

declare i32 @llvm.experimental.constrained.fptosi.i32.f32(float, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.f32(float, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f32(float, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f32(float, metadata)

declare double @llvm.experimental.constrained.sitofp.f64.i32(i32, metadata, metadata)
declare double @llvm.experimental.constrained.sitofp.f64.i64(i64, metadata, metadata)
declare double @llvm.experimental.constrained.uitofp.f64.i32(i32, metadata, metadata)
declare double @llvm.experimental.constrained.uitofp.f64.i64(i64, metadata, metadata)

declare float @llvm.experimental.constrained.sitofp.f32.i64(i64, metadata, metadata)
declare float @llvm.experimental.constrained.sitofp.f32.i32(i32, metadata, metadata)
declare float @llvm.experimental.constrained.uitofp.f32.i32(i32, metadata, metadata)
declare float @llvm.experimental.constrained.uitofp.f32.i64(i64, metadata, metadata)

define i32 @d_to_i32(double %m) #0 {
; CHECK-LABEL: d_to_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpsxws f0, f1
; CHECK-NEXT:    mffprwz r3, f0
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: d_to_i32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctiwz f0, f1
; NOVSX-NEXT:    addi r3, r1, -4
; NOVSX-NEXT:    stfiwx f0, 0, r3
; NOVSX-NEXT:    lwz r3, -4(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i32 @llvm.experimental.constrained.fptosi.i32.f64(double %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define i64 @d_to_i64(double %m) #0 {
; CHECK-LABEL: d_to_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpsxds f0, f1
; CHECK-NEXT:    mffprd r3, f0
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: d_to_i64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctidz f0, f1
; NOVSX-NEXT:    stfd f0, -8(r1)
; NOVSX-NEXT:    ld r3, -8(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i64 @llvm.experimental.constrained.fptosi.i64.f64(double %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define i64 @d_to_u64(double %m) #0 {
; CHECK-LABEL: d_to_u64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpuxds f0, f1
; CHECK-NEXT:    mffprd r3, f0
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: d_to_u64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctiduz f0, f1
; NOVSX-NEXT:    stfd f0, -8(r1)
; NOVSX-NEXT:    ld r3, -8(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i64 @llvm.experimental.constrained.fptoui.i64.f64(double %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define zeroext i32 @d_to_u32(double %m) #0 {
; CHECK-LABEL: d_to_u32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpuxws f0, f1
; CHECK-NEXT:    mffprwz r3, f0
; CHECK-NEXT:    clrldi r3, r3, 32
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: d_to_u32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctiwuz f0, f1
; NOVSX-NEXT:    addi r3, r1, -4
; NOVSX-NEXT:    stfiwx f0, 0, r3
; NOVSX-NEXT:    lwz r3, -4(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i32 @llvm.experimental.constrained.fptoui.i32.f64(double %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define signext i32 @f_to_i32(float %m) #0 {
; CHECK-LABEL: f_to_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpsxws f0, f1
; CHECK-NEXT:    mffprwz r3, f0
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: f_to_i32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctiwz f0, f1
; NOVSX-NEXT:    addi r3, r1, -4
; NOVSX-NEXT:    stfiwx f0, 0, r3
; NOVSX-NEXT:    lwa r3, -4(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i32 @llvm.experimental.constrained.fptosi.i32.f32(float %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define i64 @f_to_i64(float %m) #0 {
; CHECK-LABEL: f_to_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpsxds f0, f1
; CHECK-NEXT:    mffprd r3, f0
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: f_to_i64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctidz f0, f1
; NOVSX-NEXT:    stfd f0, -8(r1)
; NOVSX-NEXT:    ld r3, -8(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i64 @llvm.experimental.constrained.fptosi.i64.f32(float %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define i64 @f_to_u64(float %m) #0 {
; CHECK-LABEL: f_to_u64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpuxds f0, f1
; CHECK-NEXT:    mffprd r3, f0
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: f_to_u64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctiduz f0, f1
; NOVSX-NEXT:    stfd f0, -8(r1)
; NOVSX-NEXT:    ld r3, -8(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i64 @llvm.experimental.constrained.fptoui.i64.f32(float %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define zeroext i32 @f_to_u32(float %m) #0 {
; CHECK-LABEL: f_to_u32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpuxws f0, f1
; CHECK-NEXT:    mffprwz r3, f0
; CHECK-NEXT:    clrldi r3, r3, 32
; CHECK-NEXT:    blr
;
; NOVSX-LABEL: f_to_u32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    fctiwuz f0, f1
; NOVSX-NEXT:    addi r3, r1, -4
; NOVSX-NEXT:    stfiwx f0, 0, r3
; NOVSX-NEXT:    lwz r3, -4(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = call i32 @llvm.experimental.constrained.fptoui.i32.f32(float %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

attributes #0 = { strictfp }
