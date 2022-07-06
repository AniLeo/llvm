; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx1010 -mattr=+wavefrontsize32,-wavefrontsize64 -global-isel -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -march=amdgcn -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 -mattr=+wavefrontsize32,-wavefrontsize64 -global-isel -verify-machineinstrs < %s | FileCheck %s

declare i32 @llvm.amdgcn.ballot.i32(i1)
declare i32 @llvm.ctpop.i32(i32)

; Test ballot(0)

define amdgpu_cs i32 @constant_false() {
; CHECK-LABEL: constant_false:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_mov_b32 s0, 0
; CHECK-NEXT:    ; return to shader part epilog
  %ballot = call i32 @llvm.amdgcn.ballot.i32(i1 0)
  ret i32 %ballot
}

; Test ballot(1)

define amdgpu_cs i32 @constant_true() {
; CHECK-LABEL: constant_true:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_mov_b32 s0, exec_lo
; CHECK-NEXT:    ; return to shader part epilog
  %ballot = call i32 @llvm.amdgcn.ballot.i32(i1 1)
  ret i32 %ballot
}

; Test ballot of a non-comparison operation

define amdgpu_cs i32 @non_compare(i32 %x) {
; CHECK-LABEL: non_compare:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    v_and_b32_e32 v0, 1, v0
; CHECK-NEXT:    v_cmp_ne_u32_e64 s0, 0, v0
; CHECK-NEXT:    ; return to shader part epilog
  %trunc = trunc i32 %x to i1
  %ballot = call i32 @llvm.amdgcn.ballot.i32(i1 %trunc)
  ret i32 %ballot
}

; Test ballot of comparisons

define amdgpu_cs i32 @compare_ints(i32 %x, i32 %y) {
; CHECK-LABEL: compare_ints:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    v_cmp_eq_u32_e64 s0, v0, v1
; CHECK-NEXT:    ; return to shader part epilog
  %cmp = icmp eq i32 %x, %y
  %ballot = call i32 @llvm.amdgcn.ballot.i32(i1 %cmp)
  ret i32 %ballot
}

define amdgpu_cs i32 @compare_int_with_constant(i32 %x) {
; CHECK-LABEL: compare_int_with_constant:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    v_cmp_le_i32_e64 s0, 0x63, v0
; CHECK-NEXT:    ; return to shader part epilog
  %cmp = icmp sge i32 %x, 99
  %ballot = call i32 @llvm.amdgcn.ballot.i32(i1 %cmp)
  ret i32 %ballot
}

define amdgpu_cs i32 @compare_floats(float %x, float %y) {
; CHECK-LABEL: compare_floats:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    v_cmp_gt_f32_e64 s0, v0, v1
; CHECK-NEXT:    ; return to shader part epilog
  %cmp = fcmp ogt float %x, %y
  %ballot = call i32 @llvm.amdgcn.ballot.i32(i1 %cmp)
  ret i32 %ballot
}

define amdgpu_cs i32 @ctpop_of_ballot(float %x, float %y) {
; CHECK-LABEL: ctpop_of_ballot:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    v_cmp_gt_f32_e32 vcc_lo, v0, v1
; CHECK-NEXT:    s_bcnt1_i32_b32 s0, vcc_lo
; CHECK-NEXT:    ; return to shader part epilog
  %cmp = fcmp ogt float %x, %y
  %ballot = call i32 @llvm.amdgcn.ballot.i32(i1 %cmp)
  %bcnt = call i32 @llvm.ctpop.i32(i32 %ballot)
  ret i32 %bcnt
}
