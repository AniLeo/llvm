; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck --check-prefix=SI %s
; RUN: llc -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck --check-prefix=GFX9 %s
; RUN: llc -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck --check-prefix=GFX10 %s

define { i64, i1 } @umulo_i64_v_v(i64 %x, i64 %y) {
; SI-LABEL: umulo_i64_v_v:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_hi_u32 v4, v1, v2
; SI-NEXT:    v_mul_lo_u32 v5, v1, v2
; SI-NEXT:    v_mul_hi_u32 v6, v0, v3
; SI-NEXT:    v_mul_lo_u32 v7, v0, v3
; SI-NEXT:    v_mul_hi_u32 v8, v0, v2
; SI-NEXT:    v_mul_hi_u32 v9, v1, v3
; SI-NEXT:    v_mul_lo_u32 v3, v1, v3
; SI-NEXT:    v_mul_lo_u32 v0, v0, v2
; SI-NEXT:    v_add_i32_e32 v1, vcc, v8, v7
; SI-NEXT:    v_addc_u32_e32 v2, vcc, 0, v6, vcc
; SI-NEXT:    v_add_i32_e32 v6, vcc, v1, v5
; SI-NEXT:    v_add_i32_e64 v1, s[4:5], v1, v5
; SI-NEXT:    v_addc_u32_e32 v2, vcc, v2, v4, vcc
; SI-NEXT:    v_addc_u32_e32 v4, vcc, 0, v9, vcc
; SI-NEXT:    v_add_i32_e32 v2, vcc, v2, v3
; SI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v4, vcc
; SI-NEXT:    v_cmp_ne_u64_e32 vcc, 0, v[2:3]
; SI-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: umulo_i64_v_v:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_lo_u32 v5, v0, v3
; GFX9-NEXT:    v_mul_hi_u32 v6, v0, v2
; GFX9-NEXT:    v_mul_hi_u32 v8, v0, v3
; GFX9-NEXT:    v_mul_lo_u32 v7, v1, v2
; GFX9-NEXT:    v_mul_hi_u32 v4, v1, v2
; GFX9-NEXT:    v_add_co_u32_e32 v9, vcc, v6, v5
; GFX9-NEXT:    v_mul_hi_u32 v10, v1, v3
; GFX9-NEXT:    v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
; GFX9-NEXT:    v_mul_lo_u32 v1, v1, v3
; GFX9-NEXT:    v_add_co_u32_e32 v9, vcc, v9, v7
; GFX9-NEXT:    v_addc_co_u32_e32 v4, vcc, v8, v4, vcc
; GFX9-NEXT:    v_addc_co_u32_e32 v8, vcc, 0, v10, vcc
; GFX9-NEXT:    v_add_co_u32_e32 v3, vcc, v4, v1
; GFX9-NEXT:    v_addc_co_u32_e32 v4, vcc, 0, v8, vcc
; GFX9-NEXT:    v_mul_lo_u32 v0, v0, v2
; GFX9-NEXT:    v_cmp_ne_u64_e32 vcc, 0, v[3:4]
; GFX9-NEXT:    v_add3_u32 v1, v6, v5, v7
; GFX9-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: umulo_i64_v_v:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_lo_u32 v5, v0, v3
; GFX10-NEXT:    v_mul_hi_u32 v6, v0, v2
; GFX10-NEXT:    v_mul_hi_u32 v4, v0, v3
; GFX10-NEXT:    v_mul_lo_u32 v8, v1, v2
; GFX10-NEXT:    v_mul_hi_u32 v7, v1, v2
; GFX10-NEXT:    v_mul_hi_u32 v9, v1, v3
; GFX10-NEXT:    v_mul_lo_u32 v1, v1, v3
; GFX10-NEXT:    v_mul_lo_u32 v0, v0, v2
; GFX10-NEXT:    v_add_co_u32 v10, vcc_lo, v6, v5
; GFX10-NEXT:    v_add_co_ci_u32_e32 v4, vcc_lo, 0, v4, vcc_lo
; GFX10-NEXT:    v_add_co_u32 v3, vcc_lo, v10, v8
; GFX10-NEXT:    v_add_co_ci_u32_e32 v3, vcc_lo, v4, v7, vcc_lo
; GFX10-NEXT:    v_add_co_ci_u32_e32 v4, vcc_lo, 0, v9, vcc_lo
; GFX10-NEXT:    v_add_co_u32 v3, vcc_lo, v3, v1
; GFX10-NEXT:    v_add3_u32 v1, v6, v5, v8
; GFX10-NEXT:    v_add_co_ci_u32_e32 v4, vcc_lo, 0, v4, vcc_lo
; GFX10-NEXT:    v_cmp_ne_u64_e32 vcc_lo, 0, v[3:4]
; GFX10-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc_lo
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %umulo = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %x, i64 %y)
  ret { i64, i1 } %umulo
}

define { i64, i1 } @smulo_i64_s_s(i64 %x, i64 %y) {
; SI-LABEL: smulo_i64_s_s:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_hi_u32 v6, v1, v2
; SI-NEXT:    v_mul_lo_u32 v5, v1, v2
; SI-NEXT:    v_mul_hi_u32 v7, v0, v3
; SI-NEXT:    v_mul_lo_u32 v8, v0, v3
; SI-NEXT:    v_mul_hi_u32 v9, v0, v2
; SI-NEXT:    v_mul_hi_i32 v10, v1, v3
; SI-NEXT:    v_mul_lo_u32 v11, v1, v3
; SI-NEXT:    v_mov_b32_e32 v12, 0
; SI-NEXT:    v_mul_lo_u32 v4, v0, v2
; SI-NEXT:    v_add_i32_e32 v8, vcc, v9, v8
; SI-NEXT:    v_addc_u32_e32 v7, vcc, 0, v7, vcc
; SI-NEXT:    v_add_i32_e32 v9, vcc, v8, v5
; SI-NEXT:    v_add_i32_e64 v5, s[4:5], v8, v5
; SI-NEXT:    v_addc_u32_e32 v8, vcc, v7, v6, vcc
; SI-NEXT:    v_ashrrev_i32_e32 v6, 31, v5
; SI-NEXT:    v_addc_u32_e32 v9, vcc, 0, v10, vcc
; SI-NEXT:    v_mov_b32_e32 v7, v6
; SI-NEXT:    v_add_i32_e32 v8, vcc, v8, v11
; SI-NEXT:    v_addc_u32_e32 v9, vcc, v12, v9, vcc
; SI-NEXT:    v_sub_i32_e32 v2, vcc, v8, v2
; SI-NEXT:    v_subb_u32_e32 v10, vcc, v9, v12, vcc
; SI-NEXT:    v_cmp_gt_i32_e32 vcc, 0, v1
; SI-NEXT:    v_cndmask_b32_e32 v1, v9, v10, vcc
; SI-NEXT:    v_cndmask_b32_e32 v2, v8, v2, vcc
; SI-NEXT:    v_sub_i32_e32 v0, vcc, v2, v0
; SI-NEXT:    v_subb_u32_e32 v8, vcc, v1, v12, vcc
; SI-NEXT:    v_cmp_gt_i32_e32 vcc, 0, v3
; SI-NEXT:    v_cndmask_b32_e32 v1, v1, v8, vcc
; SI-NEXT:    v_cndmask_b32_e32 v0, v2, v0, vcc
; SI-NEXT:    v_cmp_ne_u64_e32 vcc, v[0:1], v[6:7]
; SI-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; SI-NEXT:    v_mov_b32_e32 v0, v4
; SI-NEXT:    v_mov_b32_e32 v1, v5
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: smulo_i64_s_s:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_lo_u32 v5, v0, v3
; GFX9-NEXT:    v_mul_hi_u32 v6, v0, v2
; GFX9-NEXT:    v_mul_hi_u32 v8, v0, v3
; GFX9-NEXT:    v_mul_lo_u32 v7, v1, v2
; GFX9-NEXT:    v_mul_hi_u32 v4, v1, v2
; GFX9-NEXT:    v_add_co_u32_e32 v9, vcc, v6, v5
; GFX9-NEXT:    v_addc_co_u32_e32 v8, vcc, 0, v8, vcc
; GFX9-NEXT:    v_add_co_u32_e32 v9, vcc, v9, v7
; GFX9-NEXT:    v_mul_hi_i32 v10, v1, v3
; GFX9-NEXT:    v_addc_co_u32_e32 v4, vcc, v8, v4, vcc
; GFX9-NEXT:    v_mul_lo_u32 v8, v1, v3
; GFX9-NEXT:    v_addc_co_u32_e32 v9, vcc, 0, v10, vcc
; GFX9-NEXT:    v_mov_b32_e32 v10, 0
; GFX9-NEXT:    v_add_co_u32_e32 v4, vcc, v4, v8
; GFX9-NEXT:    v_addc_co_u32_e32 v8, vcc, v10, v9, vcc
; GFX9-NEXT:    v_sub_co_u32_e32 v9, vcc, v4, v2
; GFX9-NEXT:    v_subb_co_u32_e32 v11, vcc, v8, v10, vcc
; GFX9-NEXT:    v_cmp_gt_i32_e32 vcc, 0, v1
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v8, v11, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v8, v4, v9, vcc
; GFX9-NEXT:    v_sub_co_u32_e32 v9, vcc, v8, v0
; GFX9-NEXT:    v_subb_co_u32_e32 v4, vcc, v1, v10, vcc
; GFX9-NEXT:    v_cmp_gt_i32_e32 vcc, 0, v3
; GFX9-NEXT:    v_cndmask_b32_e32 v4, v1, v4, vcc
; GFX9-NEXT:    v_add3_u32 v1, v6, v5, v7
; GFX9-NEXT:    v_ashrrev_i32_e32 v5, 31, v1
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v8, v9, vcc
; GFX9-NEXT:    v_mov_b32_e32 v6, v5
; GFX9-NEXT:    v_mul_lo_u32 v0, v0, v2
; GFX9-NEXT:    v_cmp_ne_u64_e32 vcc, v[3:4], v[5:6]
; GFX9-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: smulo_i64_s_s:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_lo_u32 v15, v0, v3
; GFX10-NEXT:    v_mul_hi_u32 v5, v0, v2
; GFX10-NEXT:    v_mul_hi_u32 v6, v0, v3
; GFX10-NEXT:    v_mul_lo_u32 v8, v1, v2
; GFX10-NEXT:    v_mul_hi_u32 v7, v1, v2
; GFX10-NEXT:    v_mul_hi_i32 v9, v1, v3
; GFX10-NEXT:    v_mul_lo_u32 v11, v1, v3
; GFX10-NEXT:    v_add_co_u32 v10, vcc_lo, v5, v15
; GFX10-NEXT:    v_add_co_ci_u32_e32 v6, vcc_lo, 0, v6, vcc_lo
; GFX10-NEXT:    v_add_co_u32 v10, vcc_lo, v10, v8
; GFX10-NEXT:    v_add_co_ci_u32_e32 v6, vcc_lo, v6, v7, vcc_lo
; GFX10-NEXT:    v_add_co_ci_u32_e32 v7, vcc_lo, 0, v9, vcc_lo
; GFX10-NEXT:    v_add_co_u32 v11, vcc_lo, v6, v11
; GFX10-NEXT:    v_add_co_ci_u32_e32 v7, vcc_lo, 0, v7, vcc_lo
; GFX10-NEXT:    v_sub_co_u32 v9, vcc_lo, v11, v2
; GFX10-NEXT:    v_subrev_co_ci_u32_e32 v10, vcc_lo, 0, v7, vcc_lo
; GFX10-NEXT:    v_cmp_gt_i32_e32 vcc_lo, 0, v1
; GFX10-NEXT:    v_add3_u32 v1, v5, v15, v8
; GFX10-NEXT:    v_cndmask_b32_e32 v6, v11, v9, vcc_lo
; GFX10-NEXT:    v_cndmask_b32_e32 v7, v7, v10, vcc_lo
; GFX10-NEXT:    v_ashrrev_i32_e32 v4, 31, v1
; GFX10-NEXT:    v_sub_co_u32 v8, vcc_lo, v6, v0
; GFX10-NEXT:    v_mul_lo_u32 v0, v0, v2
; GFX10-NEXT:    v_subrev_co_ci_u32_e32 v9, vcc_lo, 0, v7, vcc_lo
; GFX10-NEXT:    v_cmp_gt_i32_e32 vcc_lo, 0, v3
; GFX10-NEXT:    v_mov_b32_e32 v5, v4
; GFX10-NEXT:    v_cndmask_b32_e32 v7, v7, v9, vcc_lo
; GFX10-NEXT:    v_cndmask_b32_e32 v6, v6, v8, vcc_lo
; GFX10-NEXT:    v_cmp_ne_u64_e32 vcc_lo, v[6:7], v[4:5]
; GFX10-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc_lo
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %smulo = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %x, i64 %y)
  ret { i64, i1 } %smulo
}

define amdgpu_kernel void @umulo_i64_s(i64 %x, i64 %y) {
; SI-LABEL: umulo_i64_s:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s2
; SI-NEXT:    v_mul_hi_u32 v1, s1, v0
; SI-NEXT:    s_mul_i32 s4, s1, s2
; SI-NEXT:    v_mov_b32_e32 v2, s3
; SI-NEXT:    v_mul_hi_u32 v3, s0, v2
; SI-NEXT:    s_mul_i32 s5, s0, s3
; SI-NEXT:    v_mul_hi_u32 v0, s0, v0
; SI-NEXT:    v_mul_hi_u32 v2, s1, v2
; SI-NEXT:    s_mul_i32 s1, s1, s3
; SI-NEXT:    s_mul_i32 s0, s0, s2
; SI-NEXT:    v_add_i32_e32 v4, vcc, s5, v0
; SI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; SI-NEXT:    v_mov_b32_e32 v5, s0
; SI-NEXT:    v_add_i32_e32 v4, vcc, s4, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v3, v1, vcc
; SI-NEXT:    v_addc_u32_e32 v2, vcc, 0, v2, vcc
; SI-NEXT:    v_add_i32_e32 v3, vcc, s5, v0
; SI-NEXT:    v_add_i32_e32 v0, vcc, s1, v1
; SI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v2, vcc
; SI-NEXT:    v_add_i32_e32 v2, vcc, s4, v3
; SI-NEXT:    v_cmp_ne_u64_e32 vcc, 0, v[0:1]
; SI-NEXT:    v_cndmask_b32_e64 v1, v2, 0, vcc
; SI-NEXT:    v_cndmask_b32_e64 v0, v5, 0, vcc
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; GFX9-LABEL: umulo_i64_s:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mul_i32 s7, s0, s3
; GFX9-NEXT:    s_mul_hi_u32 s8, s0, s2
; GFX9-NEXT:    s_mul_hi_u32 s5, s0, s3
; GFX9-NEXT:    s_add_u32 s9, s8, s7
; GFX9-NEXT:    s_mul_i32 s6, s1, s2
; GFX9-NEXT:    s_addc_u32 s5, 0, s5
; GFX9-NEXT:    s_mul_hi_u32 s4, s1, s2
; GFX9-NEXT:    s_add_u32 s9, s9, s6
; GFX9-NEXT:    s_mul_hi_u32 s10, s1, s3
; GFX9-NEXT:    s_addc_u32 s4, s5, s4
; GFX9-NEXT:    s_addc_u32 s5, s10, 0
; GFX9-NEXT:    s_mul_i32 s1, s1, s3
; GFX9-NEXT:    s_add_u32 s4, s4, s1
; GFX9-NEXT:    s_addc_u32 s5, 0, s5
; GFX9-NEXT:    s_add_i32 s1, s8, s7
; GFX9-NEXT:    s_add_i32 s1, s1, s6
; GFX9-NEXT:    s_mul_i32 s2, s0, s2
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_cmp_ne_u64_e64 s[0:1], s[4:5], 0
; GFX9-NEXT:    v_cndmask_b32_e64 v1, v0, 0, s[0:1]
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    v_cndmask_b32_e64 v0, v0, 0, s[0:1]
; GFX9-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: umulo_i64_s:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_mul_i32 s7, s0, s3
; GFX10-NEXT:    s_mul_hi_u32 s8, s0, s2
; GFX10-NEXT:    s_mul_hi_u32 s5, s0, s3
; GFX10-NEXT:    s_mul_hi_u32 s4, s1, s2
; GFX10-NEXT:    s_mul_i32 s6, s1, s2
; GFX10-NEXT:    s_mul_hi_u32 s9, s1, s3
; GFX10-NEXT:    s_mul_i32 s1, s1, s3
; GFX10-NEXT:    s_add_u32 s3, s8, s7
; GFX10-NEXT:    s_addc_u32 s5, 0, s5
; GFX10-NEXT:    s_add_u32 s3, s3, s6
; GFX10-NEXT:    s_addc_u32 s3, s5, s4
; GFX10-NEXT:    s_addc_u32 s5, s9, 0
; GFX10-NEXT:    s_add_u32 s4, s3, s1
; GFX10-NEXT:    s_addc_u32 s5, 0, s5
; GFX10-NEXT:    s_add_i32 s1, s8, s7
; GFX10-NEXT:    v_cmp_ne_u64_e64 s3, s[4:5], 0
; GFX10-NEXT:    s_add_i32 s1, s1, s6
; GFX10-NEXT:    s_mul_i32 s0, s0, s2
; GFX10-NEXT:    v_cndmask_b32_e64 v1, s1, 0, s3
; GFX10-NEXT:    v_cndmask_b32_e64 v0, s0, 0, s3
; GFX10-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX10-NEXT:    s_endpgm
bb:
  %umulo = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %x, i64 %y)
  %mul = extractvalue { i64, i1 } %umulo, 0
  %overflow = extractvalue { i64, i1 } %umulo, 1
  %res = select i1 %overflow, i64 0, i64 %mul
  store i64 %res, i64 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @smulo_i64_s(i64 %x, i64 %y) {
; SI-LABEL: smulo_i64_s:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    v_mov_b32_e32 v0, 0
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v1, s2
; SI-NEXT:    v_mul_hi_u32 v2, s1, v1
; SI-NEXT:    s_mul_i32 s4, s1, s2
; SI-NEXT:    v_mov_b32_e32 v3, s3
; SI-NEXT:    v_mul_hi_u32 v4, s0, v3
; SI-NEXT:    s_mul_i32 s5, s0, s3
; SI-NEXT:    v_mul_hi_u32 v1, s0, v1
; SI-NEXT:    v_mul_hi_i32 v3, s1, v3
; SI-NEXT:    s_mul_i32 s6, s1, s3
; SI-NEXT:    s_mul_i32 s8, s0, s2
; SI-NEXT:    v_add_i32_e32 v5, vcc, s5, v1
; SI-NEXT:    v_addc_u32_e32 v4, vcc, 0, v4, vcc
; SI-NEXT:    v_mov_b32_e32 v6, s8
; SI-NEXT:    v_add_i32_e32 v5, vcc, s4, v5
; SI-NEXT:    v_addc_u32_e32 v2, vcc, v4, v2, vcc
; SI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; SI-NEXT:    v_add_i32_e32 v1, vcc, s5, v1
; SI-NEXT:    v_add_i32_e32 v2, vcc, s6, v2
; SI-NEXT:    v_addc_u32_e32 v3, vcc, v0, v3, vcc
; SI-NEXT:    v_add_i32_e32 v4, vcc, s4, v1
; SI-NEXT:    v_subrev_i32_e32 v1, vcc, s2, v2
; SI-NEXT:    v_subbrev_u32_e32 v5, vcc, 0, v3, vcc
; SI-NEXT:    v_ashrrev_i32_e32 v0, 31, v4
; SI-NEXT:    v_cmp_lt_i32_e64 vcc, s1, 0
; SI-NEXT:    v_cndmask_b32_e32 v3, v3, v5, vcc
; SI-NEXT:    v_cndmask_b32_e32 v2, v2, v1, vcc
; SI-NEXT:    v_mov_b32_e32 v1, v0
; SI-NEXT:    v_subrev_i32_e32 v5, vcc, s0, v2
; SI-NEXT:    v_subbrev_u32_e32 v7, vcc, 0, v3, vcc
; SI-NEXT:    v_cmp_lt_i32_e64 vcc, s3, 0
; SI-NEXT:    v_cndmask_b32_e32 v3, v3, v7, vcc
; SI-NEXT:    v_cndmask_b32_e32 v2, v2, v5, vcc
; SI-NEXT:    v_cmp_ne_u64_e32 vcc, v[2:3], v[0:1]
; SI-NEXT:    v_cndmask_b32_e64 v1, v4, 0, vcc
; SI-NEXT:    v_cndmask_b32_e64 v0, v6, 0, vcc
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; GFX9-LABEL: smulo_i64_s:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mul_i32 s7, s0, s3
; GFX9-NEXT:    s_mul_hi_u32 s8, s0, s2
; GFX9-NEXT:    s_mul_hi_u32 s6, s0, s3
; GFX9-NEXT:    s_add_u32 s9, s8, s7
; GFX9-NEXT:    s_mul_i32 s5, s1, s2
; GFX9-NEXT:    s_addc_u32 s6, 0, s6
; GFX9-NEXT:    s_add_u32 s9, s9, s5
; GFX9-NEXT:    s_mul_hi_u32 s4, s1, s2
; GFX9-NEXT:    s_mul_hi_i32 s10, s1, s3
; GFX9-NEXT:    s_addc_u32 s4, s6, s4
; GFX9-NEXT:    s_addc_u32 s6, s10, 0
; GFX9-NEXT:    s_mul_i32 s9, s1, s3
; GFX9-NEXT:    s_add_u32 s4, s4, s9
; GFX9-NEXT:    s_addc_u32 s6, 0, s6
; GFX9-NEXT:    s_sub_u32 s9, s4, s2
; GFX9-NEXT:    s_subb_u32 s10, s6, 0
; GFX9-NEXT:    v_cmp_lt_i32_e64 vcc, s1, 0
; GFX9-NEXT:    v_mov_b32_e32 v0, s6
; GFX9-NEXT:    v_mov_b32_e32 v1, s10
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v1, s4
; GFX9-NEXT:    v_mov_b32_e32 v2, s9
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v1, v2, vcc
; GFX9-NEXT:    v_subrev_co_u32_e32 v3, vcc, s0, v2
; GFX9-NEXT:    s_add_i32 s1, s8, s7
; GFX9-NEXT:    v_subbrev_co_u32_e32 v1, vcc, 0, v0, vcc
; GFX9-NEXT:    s_add_i32 s1, s1, s5
; GFX9-NEXT:    v_cmp_lt_i32_e64 vcc, s3, 0
; GFX9-NEXT:    s_ashr_i32 s4, s1, 31
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v0, v1, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v2, v3, vcc
; GFX9-NEXT:    s_mov_b32 s5, s4
; GFX9-NEXT:    s_mul_i32 s0, s0, s2
; GFX9-NEXT:    v_cmp_ne_u64_e32 vcc, s[4:5], v[0:1]
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    v_mov_b32_e32 v2, s1
; GFX9-NEXT:    v_cndmask_b32_e64 v1, v2, 0, vcc
; GFX9-NEXT:    v_cndmask_b32_e64 v0, v0, 0, vcc
; GFX9-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: smulo_i64_s:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_mul_i32 s7, s0, s3
; GFX10-NEXT:    s_mul_hi_u32 s8, s0, s2
; GFX10-NEXT:    s_mul_hi_u32 s6, s0, s3
; GFX10-NEXT:    s_add_u32 s11, s8, s7
; GFX10-NEXT:    s_mul_i32 s5, s1, s2
; GFX10-NEXT:    s_addc_u32 s6, 0, s6
; GFX10-NEXT:    s_mul_hi_u32 s4, s1, s2
; GFX10-NEXT:    s_add_u32 s11, s11, s5
; GFX10-NEXT:    s_mul_hi_i32 s9, s1, s3
; GFX10-NEXT:    s_addc_u32 s4, s6, s4
; GFX10-NEXT:    s_mul_i32 s10, s1, s3
; GFX10-NEXT:    s_addc_u32 s6, s9, 0
; GFX10-NEXT:    s_add_u32 s4, s4, s10
; GFX10-NEXT:    s_addc_u32 s6, 0, s6
; GFX10-NEXT:    s_sub_u32 s9, s4, s2
; GFX10-NEXT:    s_subb_u32 s10, s6, 0
; GFX10-NEXT:    v_cmp_lt_i32_e64 vcc_lo, s1, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, s9
; GFX10-NEXT:    v_mov_b32_e32 v1, s10
; GFX10-NEXT:    s_add_i32 s1, s8, s7
; GFX10-NEXT:    s_add_i32 s1, s1, s5
; GFX10-NEXT:    v_cndmask_b32_e32 v0, s4, v0, vcc_lo
; GFX10-NEXT:    v_cndmask_b32_e32 v1, s6, v1, vcc_lo
; GFX10-NEXT:    s_ashr_i32 s4, s1, 31
; GFX10-NEXT:    s_mov_b32 s5, s4
; GFX10-NEXT:    v_sub_co_u32 v2, vcc_lo, v0, s0
; GFX10-NEXT:    s_mul_i32 s0, s0, s2
; GFX10-NEXT:    v_subrev_co_ci_u32_e32 v3, vcc_lo, 0, v1, vcc_lo
; GFX10-NEXT:    v_cmp_lt_i32_e64 vcc_lo, s3, 0
; GFX10-NEXT:    v_cndmask_b32_e32 v1, v1, v3, vcc_lo
; GFX10-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc_lo
; GFX10-NEXT:    v_cmp_ne_u64_e32 vcc_lo, s[4:5], v[0:1]
; GFX10-NEXT:    v_cndmask_b32_e64 v1, s1, 0, vcc_lo
; GFX10-NEXT:    v_cndmask_b32_e64 v0, s0, 0, vcc_lo
; GFX10-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX10-NEXT:    s_endpgm
bb:
  %umulo = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %x, i64 %y)
  %mul = extractvalue { i64, i1 } %umulo, 0
  %overflow = extractvalue { i64, i1 } %umulo, 1
  %res = select i1 %overflow, i64 0, i64 %mul
  store i64 %res, i64 addrspace(1)* undef
  ret void
}

define { i64, i1 } @smulo_i64_v_4(i64 %i) {
; SI-LABEL: smulo_i64_v_4:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_lshl_b64 v[5:6], v[0:1], 2
; SI-NEXT:    v_alignbit_b32 v4, v1, v0, 30
; SI-NEXT:    v_ashr_i64 v[2:3], v[5:6], 2
; SI-NEXT:    v_cmp_ne_u64_e32 vcc, v[2:3], v[0:1]
; SI-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; SI-NEXT:    v_mov_b32_e32 v0, v5
; SI-NEXT:    v_mov_b32_e32 v1, v4
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: smulo_i64_v_4:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_lshlrev_b64 v[4:5], 2, v[0:1]
; GFX9-NEXT:    v_alignbit_b32 v3, v1, v0, 30
; GFX9-NEXT:    v_ashrrev_i64 v[5:6], 2, v[4:5]
; GFX9-NEXT:    v_cmp_ne_u64_e32 vcc, v[5:6], v[0:1]
; GFX9-NEXT:    v_mov_b32_e32 v0, v4
; GFX9-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v1, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: smulo_i64_v_4:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_lshlrev_b64 v[4:5], 2, v[0:1]
; GFX10-NEXT:    v_alignbit_b32 v3, v1, v0, 30
; GFX10-NEXT:    v_ashrrev_i64 v[6:7], 2, v[4:5]
; GFX10-NEXT:    v_cmp_ne_u64_e32 vcc_lo, v[6:7], v[0:1]
; GFX10-NEXT:    v_mov_b32_e32 v0, v4
; GFX10-NEXT:    v_mov_b32_e32 v1, v3
; GFX10-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc_lo
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %umulo = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %i, i64 4)
  ret { i64, i1 } %umulo
}

define { i64, i1 } @umulo_i64_v_4(i64 %i) {
; SI-LABEL: umulo_i64_v_4:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_and_b32_e32 v7, 0x3fffffff, v1
; SI-NEXT:    v_mov_b32_e32 v6, v0
; SI-NEXT:    v_lshl_b64 v[4:5], v[0:1], 2
; SI-NEXT:    v_alignbit_b32 v3, v1, v0, 30
; SI-NEXT:    v_cmp_ne_u64_e32 vcc, v[6:7], v[0:1]
; SI-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; SI-NEXT:    v_mov_b32_e32 v0, v4
; SI-NEXT:    v_mov_b32_e32 v1, v3
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: umulo_i64_v_4:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v7, 0x3fffffff, v1
; GFX9-NEXT:    v_mov_b32_e32 v6, v0
; GFX9-NEXT:    v_cmp_ne_u64_e32 vcc, v[6:7], v[0:1]
; GFX9-NEXT:    v_lshlrev_b64 v[4:5], 2, v[0:1]
; GFX9-NEXT:    v_alignbit_b32 v3, v1, v0, 30
; GFX9-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v0, v4
; GFX9-NEXT:    v_mov_b32_e32 v1, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: umulo_i64_v_4:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v7, 0x3fffffff, v1
; GFX10-NEXT:    v_mov_b32_e32 v6, v0
; GFX10-NEXT:    v_lshlrev_b64 v[4:5], 2, v[0:1]
; GFX10-NEXT:    v_alignbit_b32 v3, v1, v0, 30
; GFX10-NEXT:    v_cmp_ne_u64_e32 vcc_lo, v[6:7], v[0:1]
; GFX10-NEXT:    v_mov_b32_e32 v0, v4
; GFX10-NEXT:    v_mov_b32_e32 v1, v3
; GFX10-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc_lo
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %umulo = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %i, i64 4)
  ret { i64, i1 } %umulo
}

declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64)
