; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-eabi   -mattr=+8msecext,+mve.fp                  %s -o - | FileCheck %s --check-prefix=CHECK-SOFTFP
; RUN: llc -mtriple=thumbebv8.1m.main-eabi -mattr=+8msecext,+mve.fp                  %s -o - | FileCheck %s --check-prefix=CHECK-SOFTFP
; RUN: llc -mtriple=thumbv8.1m.main-eabi   -mattr=+8msecext,+mve.fp --float-abi=hard %s -o - | FileCheck %s --check-prefix=CHECK-HARD
; RUN: llc -mtriple=thumbebv8.1m.main-eabi -mattr=+8msecext,+mve.fp --float-abi=hard %s -o - | FileCheck %s --check-prefix=CHECK-HARD

declare <8 x i16> @g0(...) #0
declare <4 x float> @g1(...) #0

;;
;; Test clearing before return to nonsecure state
;;

define <8 x i16> @f0() #1 {
; CHECK-SOFTFP-LABEL: f0:
; CHECK-SOFTFP:       @ %bb.0: @ %entry
; CHECK-SOFTFP-NEXT:    vstr fpcxtns, [sp, #-4]!
; CHECK-SOFTFP-NEXT:    .save {r7, lr}
; CHECK-SOFTFP-NEXT:    push {r7, lr}
; CHECK-SOFTFP-NEXT:    .pad #4
; CHECK-SOFTFP-NEXT:    sub sp, #4
; CHECK-SOFTFP-NEXT:    bl g0
; CHECK-SOFTFP-NEXT:    add sp, #4
; CHECK-SOFTFP-NEXT:    pop.w {r7, lr}
; CHECK-SOFTFP-NEXT:    vscclrm {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, vpr}
; CHECK-SOFTFP-NEXT:    vldr fpcxtns, [sp], #4
; CHECK-SOFTFP-NEXT:    clrm {r12, apsr}
; CHECK-SOFTFP-NEXT:    bxns lr
;
; CHECK-HARD-LABEL: f0:
; CHECK-HARD:       @ %bb.0: @ %entry
; CHECK-HARD-NEXT:    vstr fpcxtns, [sp, #-4]!
; CHECK-HARD-NEXT:    .save {r7, lr}
; CHECK-HARD-NEXT:    push {r7, lr}
; CHECK-HARD-NEXT:    .pad #4
; CHECK-HARD-NEXT:    sub sp, #4
; CHECK-HARD-NEXT:    bl g0
; CHECK-HARD-NEXT:    add sp, #4
; CHECK-HARD-NEXT:    pop.w {r7, lr}
; CHECK-HARD-NEXT:    vscclrm {s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, vpr}
; CHECK-HARD-NEXT:    vldr fpcxtns, [sp], #4
; CHECK-HARD-NEXT:    clrm {r0, r1, r2, r3, r12, apsr}
; CHECK-HARD-NEXT:    bxns lr
entry:
  %call = call <8 x i16> bitcast (<8 x i16> (...)* @g0 to <8 x i16> ()*)() #0
  ret <8 x i16> %call
}

define <4 x float> @f1() #1 {
; CHECK-SOFTFP-LABEL: f1:
; CHECK-SOFTFP:       @ %bb.0: @ %entry
; CHECK-SOFTFP-NEXT:    vstr fpcxtns, [sp, #-4]!
; CHECK-SOFTFP-NEXT:    .save {r7, lr}
; CHECK-SOFTFP-NEXT:    push {r7, lr}
; CHECK-SOFTFP-NEXT:    .pad #4
; CHECK-SOFTFP-NEXT:    sub sp, #4
; CHECK-SOFTFP-NEXT:    bl g1
; CHECK-SOFTFP-NEXT:    add sp, #4
; CHECK-SOFTFP-NEXT:    pop.w {r7, lr}
; CHECK-SOFTFP-NEXT:    vscclrm {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, vpr}
; CHECK-SOFTFP-NEXT:    vldr fpcxtns, [sp], #4
; CHECK-SOFTFP-NEXT:    clrm {r12, apsr}
; CHECK-SOFTFP-NEXT:    bxns lr
;
; CHECK-HARD-LABEL: f1:
; CHECK-HARD:       @ %bb.0: @ %entry
; CHECK-HARD-NEXT:    vstr fpcxtns, [sp, #-4]!
; CHECK-HARD-NEXT:    .save {r7, lr}
; CHECK-HARD-NEXT:    push {r7, lr}
; CHECK-HARD-NEXT:    .pad #4
; CHECK-HARD-NEXT:    sub sp, #4
; CHECK-HARD-NEXT:    bl g1
; CHECK-HARD-NEXT:    add sp, #4
; CHECK-HARD-NEXT:    pop.w {r7, lr}
; CHECK-HARD-NEXT:    vscclrm {s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, vpr}
; CHECK-HARD-NEXT:    vldr fpcxtns, [sp], #4
; CHECK-HARD-NEXT:    clrm {r0, r1, r2, r3, r12, apsr}
; CHECK-HARD-NEXT:    bxns lr
entry:
  %call = call nnan ninf nsz <4 x float> bitcast (<4 x float> (...)* @g1 to <4 x float> ()*)() #0
  ret <4 x float> %call
}

;;
;; Test clearing around nonsecure calls
;;

define void @f2(void (<8 x i16>)* nocapture %cb) #0 {
; CHECK-SOFTFP-LABEL: f2:
; CHECK-SOFTFP:       @ %bb.0: @ %entry
; CHECK-SOFTFP-NEXT:    .save {r4, lr}
; CHECK-SOFTFP-NEXT:    push {r4, lr}
; CHECK-SOFTFP-NEXT:    mov r4, r0
; CHECK-SOFTFP-NEXT:    bl g0
; CHECK-SOFTFP-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-SOFTFP-NEXT:    bic r4, r4, #1
; CHECK-SOFTFP-NEXT:    sub sp, #136
; CHECK-SOFTFP-NEXT:    vlstm sp
; CHECK-SOFTFP-NEXT:    clrm {r5, r6, r7, r8, r9, r10, r11, r12, apsr}
; CHECK-SOFTFP-NEXT:    blxns r4
; CHECK-SOFTFP-NEXT:    vlldm sp
; CHECK-SOFTFP-NEXT:    add sp, #136
; CHECK-SOFTFP-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-SOFTFP-NEXT:    pop {r4, pc}
;
; CHECK-HARD-LABEL: f2:
; CHECK-HARD:       @ %bb.0: @ %entry
; CHECK-HARD-NEXT:    .save {r4, lr}
; CHECK-HARD-NEXT:    push {r4, lr}
; CHECK-HARD-NEXT:    mov r4, r0
; CHECK-HARD-NEXT:    bl g0
; CHECK-HARD-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-HARD-NEXT:    bic r4, r4, #1
; CHECK-HARD-NEXT:    vpush {s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
; CHECK-HARD-NEXT:    vscclrm {s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, vpr}
; CHECK-HARD-NEXT:    vstr fpcxts, [sp, #-8]!
; CHECK-HARD-NEXT:    clrm {r0, r1, r2, r3, r5, r6, r7, r8, r9, r10, r11, r12, apsr}
; CHECK-HARD-NEXT:    blxns r4
; CHECK-HARD-NEXT:    vldr fpcxts, [sp], #8
; CHECK-HARD-NEXT:    vpop {s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
; CHECK-HARD-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-HARD-NEXT:    pop {r4, pc}
entry:
  %call = tail call <8 x i16> bitcast (<8 x i16> (...)* @g0 to <8 x i16> ()*)() #0
  tail call void %cb(<8 x i16> %call) #2
  ret void
}

define void @f3(void (<4 x float>)* nocapture %cb) #0 {
; CHECK-SOFTFP-LABEL: f3:
; CHECK-SOFTFP:       @ %bb.0: @ %entry
; CHECK-SOFTFP-NEXT:    .save {r4, lr}
; CHECK-SOFTFP-NEXT:    push {r4, lr}
; CHECK-SOFTFP-NEXT:    mov r4, r0
; CHECK-SOFTFP-NEXT:    bl g1
; CHECK-SOFTFP-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-SOFTFP-NEXT:    bic r4, r4, #1
; CHECK-SOFTFP-NEXT:    sub sp, #136
; CHECK-SOFTFP-NEXT:    vlstm sp
; CHECK-SOFTFP-NEXT:    clrm {r5, r6, r7, r8, r9, r10, r11, r12, apsr}
; CHECK-SOFTFP-NEXT:    blxns r4
; CHECK-SOFTFP-NEXT:    vlldm sp
; CHECK-SOFTFP-NEXT:    add sp, #136
; CHECK-SOFTFP-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-SOFTFP-NEXT:    pop {r4, pc}
;
; CHECK-HARD-LABEL: f3:
; CHECK-HARD:       @ %bb.0: @ %entry
; CHECK-HARD-NEXT:    .save {r4, lr}
; CHECK-HARD-NEXT:    push {r4, lr}
; CHECK-HARD-NEXT:    mov r4, r0
; CHECK-HARD-NEXT:    bl g1
; CHECK-HARD-NEXT:    push.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-HARD-NEXT:    bic r4, r4, #1
; CHECK-HARD-NEXT:    vpush {s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
; CHECK-HARD-NEXT:    vscclrm {s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, vpr}
; CHECK-HARD-NEXT:    vstr fpcxts, [sp, #-8]!
; CHECK-HARD-NEXT:    clrm {r0, r1, r2, r3, r5, r6, r7, r8, r9, r10, r11, r12, apsr}
; CHECK-HARD-NEXT:    blxns r4
; CHECK-HARD-NEXT:    vldr fpcxts, [sp], #8
; CHECK-HARD-NEXT:    vpop {s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31}
; CHECK-HARD-NEXT:    pop.w {r4, r5, r6, r7, r8, r9, r10, r11}
; CHECK-HARD-NEXT:    pop {r4, pc}
entry:
  %call = tail call nnan ninf nsz <4 x float> bitcast (<4 x float> (...)* @g1 to <4 x float> ()*)() #0
  tail call void %cb(<4 x float> %call) #2
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind "cmse_nonsecure_entry" }
attributes #2 = { nounwind "cmse_nonsecure_call" }
