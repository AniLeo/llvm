; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-mesa3d < %s | FileCheck %s

define i1 @test_srem_odd(i29 %X) nounwind {
; CHECK-LABEL: test_srem_odd:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    s_mov_b32 s4, 0x1f5a814b
; CHECK-NEXT:    s_mov_b32 s5, 0x52bf5b
; CHECK-NEXT:    v_mul_lo_u32 v0, v0, s4
; CHECK-NEXT:    v_add_i32_e32 v0, vcc, 0x295fad, v0
; CHECK-NEXT:    v_and_b32_e32 v0, 0x1fffffff, v0
; CHECK-NEXT:    v_cmp_gt_u32_e32 vcc, s5, v0
; CHECK-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; CHECK-NEXT:    s_setpc_b64 s[30:31]
  %srem = srem i29 %X, 99
  %cmp = icmp eq i29 %srem, 0
  ret i1 %cmp
}

define i1 @test_srem_even(i4 %X) nounwind {
; CHECK-LABEL: test_srem_even:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_bfe_i32 v0, v0, 0, 4
; CHECK-NEXT:    s_mov_b32 s4, 0x2aaaaaab
; CHECK-NEXT:    v_mul_hi_i32 v1, v0, s4
; CHECK-NEXT:    v_lshrrev_b32_e32 v2, 31, v1
; CHECK-NEXT:    v_add_i32_e32 v1, vcc, v1, v2
; CHECK-NEXT:    v_mul_lo_u32 v1, v1, 6
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v1
; CHECK-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; CHECK-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; CHECK-NEXT:    s_setpc_b64 s[30:31]
  %srem = srem i4 %X, 6
  %cmp = icmp eq i4 %srem, 1
  ret i1 %cmp
}

define i1 @test_srem_pow2_setne(i6 %X) nounwind {
; CHECK-LABEL: test_srem_pow2_setne:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_bfe_i32 v1, v0, 0, 6
; CHECK-NEXT:    v_bfe_u32 v1, v1, 9, 2
; CHECK-NEXT:    v_add_i32_e32 v1, vcc, v0, v1
; CHECK-NEXT:    v_and_b32_e32 v1, 60, v1
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v1
; CHECK-NEXT:    v_and_b32_e32 v0, 63, v0
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; CHECK-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; CHECK-NEXT:    s_setpc_b64 s[30:31]
  %srem = srem i6 %X, 4
  %cmp = icmp ne i6 %srem, 0
  ret i1 %cmp
}

define <3 x i1> @test_srem_vec(<3 x i31> %X) nounwind {
; CHECK-LABEL: test_srem_vec:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_bfe_i32 v3, v2, 0, 31
; CHECK-NEXT:    v_bfe_i32 v4, v1, 0, 31
; CHECK-NEXT:    v_bfe_i32 v5, v0, 0, 31
; CHECK-NEXT:    s_mov_b32 s6, 0x38e38e39
; CHECK-NEXT:    s_mov_b32 s7, 0xc71c71c7
; CHECK-NEXT:    s_brev_b32 s4, -2
; CHECK-NEXT:    s_mov_b32 s5, 0x7ffffffd
; CHECK-NEXT:    v_mul_hi_i32 v5, v5, s6
; CHECK-NEXT:    v_mul_hi_i32 v4, v4, s6
; CHECK-NEXT:    v_mul_hi_i32 v3, v3, s7
; CHECK-NEXT:    v_lshrrev_b32_e32 v6, 31, v5
; CHECK-NEXT:    v_lshrrev_b32_e32 v5, 1, v5
; CHECK-NEXT:    v_lshrrev_b32_e32 v7, 31, v4
; CHECK-NEXT:    v_lshrrev_b32_e32 v4, 1, v4
; CHECK-NEXT:    v_lshrrev_b32_e32 v8, 31, v3
; CHECK-NEXT:    v_lshrrev_b32_e32 v3, 1, v3
; CHECK-NEXT:    v_add_i32_e32 v5, vcc, v5, v6
; CHECK-NEXT:    v_add_i32_e32 v4, vcc, v4, v7
; CHECK-NEXT:    v_add_i32_e32 v3, vcc, v3, v8
; CHECK-NEXT:    v_mul_lo_u32 v5, v5, 9
; CHECK-NEXT:    v_mul_lo_u32 v4, v4, 9
; CHECK-NEXT:    v_mul_lo_u32 v3, v3, -9
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v5
; CHECK-NEXT:    v_sub_i32_e32 v1, vcc, v1, v4
; CHECK-NEXT:    v_sub_i32_e32 v2, vcc, v2, v3
; CHECK-NEXT:    v_and_b32_e32 v2, s4, v2
; CHECK-NEXT:    v_and_b32_e32 v1, s4, v1
; CHECK-NEXT:    v_and_b32_e32 v0, s4, v0
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, 3, v0
; CHECK-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, s5, v1
; CHECK-NEXT:    v_cndmask_b32_e64 v1, 0, 1, vcc
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, 3, v2
; CHECK-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; CHECK-NEXT:    s_setpc_b64 s[30:31]
  %srem = srem <3 x i31> %X, <i31 9, i31 9, i31 -9>
  %cmp = icmp ne <3 x i31> %srem, <i31 3, i31 -3, i31 3>
  ret <3 x i1> %cmp
}
