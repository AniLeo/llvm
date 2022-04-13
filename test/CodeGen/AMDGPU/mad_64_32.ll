; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=hawaii -verify-machineinstrs < %s | FileCheck -check-prefixes=CI %s
; RUN: llc -march=amdgcn -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -check-prefixes=SI %s
; RUN: llc -march=amdgcn -mcpu=gfx90a -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX9 %s

define i64 @mad_i64_i32_sextops(i32 %arg0, i32 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_i64_i32_sextops:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_sextops:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v4, v0, v1
; SI-NEXT:    v_mul_hi_i32 v1, v0, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v4, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v3, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_sextops:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i32 %arg0 to i64
  %sext1 = sext i32 %arg1 to i64
  %mul = mul i64 %sext0, %sext1
  %mad = add i64 %mul, %arg2
  ret i64 %mad
}

define i64 @mad_i64_i32_sextops_commute(i32 %arg0, i32 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_i64_i32_sextops_commute:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_sextops_commute:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v4, v0, v1
; SI-NEXT:    v_mul_hi_i32 v1, v0, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v2, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v3, v1, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_sextops_commute:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i32 %arg0 to i64
  %sext1 = sext i32 %arg1 to i64
  %mul = mul i64 %sext0, %sext1
  %mad = add i64 %arg2, %mul
  ret i64 %mad
}

define i64 @mad_u64_u32_zextops(i32 %arg0, i32 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_u64_u32_zextops:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_u64_u32_zextops:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v4, v0, v1
; SI-NEXT:    v_mul_hi_u32 v1, v0, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v4, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v3, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_u64_u32_zextops:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = zext i32 %arg0 to i64
  %sext1 = zext i32 %arg1 to i64
  %mul = mul i64 %sext0, %sext1
  %mad = add i64 %mul, %arg2
  ret i64 %mad
}

define i64 @mad_u64_u32_zextops_commute(i32 %arg0, i32 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_u64_u32_zextops_commute:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_u64_u32_zextops_commute:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v4, v0, v1
; SI-NEXT:    v_mul_hi_u32 v1, v0, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v2, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v3, v1, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_u64_u32_zextops_commute:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = zext i32 %arg0 to i64
  %sext1 = zext i32 %arg1 to i64
  %mul = mul i64 %sext0, %sext1
  %mad = add i64 %arg2, %mul
  ret i64 %mad
}

define i128 @mad_i64_i32_sextops_i32_i128(i32 %arg0, i32 %arg1, i128 %arg2) #0 {
; CI-LABEL: mad_i64_i32_sextops_i32_i128:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_u64_u32 v[6:7], s[4:5], v0, v1, 0
; CI-NEXT:    v_ashrrev_i32_e32 v13, 31, v0
; CI-NEXT:    v_mov_b32_e32 v8, 0
; CI-NEXT:    v_mad_u64_u32 v[9:10], s[4:5], v13, v1, v[7:8]
; CI-NEXT:    v_ashrrev_i32_e32 v14, 31, v1
; CI-NEXT:    v_mad_i64_i32 v[11:12], s[4:5], v1, v13, 0
; CI-NEXT:    v_mov_b32_e32 v7, v10
; CI-NEXT:    v_mov_b32_e32 v10, v8
; CI-NEXT:    v_mad_u64_u32 v[8:9], s[4:5], v0, v14, v[9:10]
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v14, v0, v[11:12]
; CI-NEXT:    v_add_i32_e32 v9, vcc, v7, v9
; CI-NEXT:    v_addc_u32_e64 v10, s[4:5], 0, 0, vcc
; CI-NEXT:    v_mad_u64_u32 v[9:10], s[4:5], v13, v14, v[9:10]
; CI-NEXT:    v_add_i32_e32 v7, vcc, v9, v0
; CI-NEXT:    v_addc_u32_e32 v9, vcc, v10, v1, vcc
; CI-NEXT:    v_mov_b32_e32 v1, v8
; CI-NEXT:    v_add_i32_e32 v0, vcc, v6, v2
; CI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v3, vcc
; CI-NEXT:    v_addc_u32_e32 v2, vcc, v7, v4, vcc
; CI-NEXT:    v_addc_u32_e32 v3, vcc, v9, v5, vcc
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_sextops_i32_i128:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_ashrrev_i32_e32 v6, 31, v0
; SI-NEXT:    v_mul_lo_u32 v11, v6, v1
; SI-NEXT:    v_mul_hi_u32 v12, v0, v1
; SI-NEXT:    v_ashrrev_i32_e32 v7, 31, v1
; SI-NEXT:    v_mul_hi_u32 v14, v6, v1
; SI-NEXT:    v_mul_lo_u32 v13, v0, v7
; SI-NEXT:    v_mul_hi_u32 v10, v0, v7
; SI-NEXT:    v_add_i32_e32 v12, vcc, v11, v12
; SI-NEXT:    v_addc_u32_e32 v14, vcc, 0, v14, vcc
; SI-NEXT:    v_mul_hi_u32 v8, v6, v7
; SI-NEXT:    v_add_i32_e32 v12, vcc, v13, v12
; SI-NEXT:    v_addc_u32_e32 v10, vcc, 0, v10, vcc
; SI-NEXT:    v_mul_i32_i24_e32 v9, v6, v7
; SI-NEXT:    v_add_i32_e32 v10, vcc, v14, v10
; SI-NEXT:    v_mul_hi_i32 v6, v1, v6
; SI-NEXT:    v_mul_hi_i32 v7, v7, v0
; SI-NEXT:    v_addc_u32_e64 v14, s[4:5], 0, 0, vcc
; SI-NEXT:    v_add_i32_e32 v9, vcc, v9, v10
; SI-NEXT:    v_addc_u32_e32 v8, vcc, v8, v14, vcc
; SI-NEXT:    v_add_i32_e32 v10, vcc, v13, v11
; SI-NEXT:    v_mul_lo_u32 v0, v0, v1
; SI-NEXT:    v_addc_u32_e32 v6, vcc, v7, v6, vcc
; SI-NEXT:    v_add_i32_e32 v7, vcc, v9, v10
; SI-NEXT:    v_addc_u32_e32 v6, vcc, v8, v6, vcc
; SI-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v12, v3, vcc
; SI-NEXT:    v_addc_u32_e32 v2, vcc, v7, v4, vcc
; SI-NEXT:    v_addc_u32_e32 v3, vcc, v6, v5, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_sextops_i32_i128:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_u64_u32 v[6:7], s[4:5], v0, v1, 0
; GFX9-NEXT:    v_ashrrev_i32_e32 v13, 31, v0
; GFX9-NEXT:    v_mov_b32_e32 v9, 0
; GFX9-NEXT:    v_mov_b32_e32 v8, v7
; GFX9-NEXT:    v_mad_u64_u32 v[10:11], s[4:5], v13, v1, v[8:9]
; GFX9-NEXT:    v_ashrrev_i32_e32 v14, 31, v1
; GFX9-NEXT:    v_mov_b32_e32 v8, v11
; GFX9-NEXT:    v_mov_b32_e32 v11, v9
; GFX9-NEXT:    v_mad_u64_u32 v[10:11], s[4:5], v0, v14, v[10:11]
; GFX9-NEXT:    v_mov_b32_e32 v12, v11
; GFX9-NEXT:    v_add_co_u32_e32 v8, vcc, v8, v12
; GFX9-NEXT:    v_addc_co_u32_e64 v9, s[4:5], 0, 0, vcc
; GFX9-NEXT:    v_mad_u64_u32 v[8:9], s[4:5], v13, v14, v[8:9]
; GFX9-NEXT:    v_mad_i64_i32 v[12:13], s[4:5], v1, v13, 0
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v14, v0, v[12:13]
; GFX9-NEXT:    v_add_co_u32_e32 v7, vcc, v8, v0
; GFX9-NEXT:    v_addc_co_u32_e32 v8, vcc, v9, v1, vcc
; GFX9-NEXT:    v_mov_b32_e32 v1, v10
; GFX9-NEXT:    v_add_co_u32_e32 v0, vcc, v6, v2
; GFX9-NEXT:    v_addc_co_u32_e32 v1, vcc, v1, v3, vcc
; GFX9-NEXT:    v_addc_co_u32_e32 v2, vcc, v7, v4, vcc
; GFX9-NEXT:    v_addc_co_u32_e32 v3, vcc, v8, v5, vcc
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i32 %arg0 to i128
  %sext1 = sext i32 %arg1 to i128
  %mul = mul i128 %sext0, %sext1
  %mad = add i128 %mul, %arg2
  ret i128 %mad
}

define i63 @mad_i64_i32_sextops_i32_i63(i32 %arg0, i32 %arg1, i63 %arg2) #0 {
; CI-LABEL: mad_i64_i32_sextops_i32_i63:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_sextops_i32_i63:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v4, v0, v1
; SI-NEXT:    v_mul_hi_i32 v1, v0, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v4, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v3, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_sextops_i32_i63:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i32 %arg0 to i63
  %sext1 = sext i32 %arg1 to i63
  %mul = mul i63 %sext0, %sext1
  %mad = add i63 %mul, %arg2
  ret i63 %mad
}

define i63 @mad_i64_i32_sextops_i31_i63(i31 %arg0, i31 %arg1, i63 %arg2) #0 {
; CI-LABEL: mad_i64_i32_sextops_i31_i63:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_bfe_i32 v1, v1, 0, 31
; CI-NEXT:    v_bfe_i32 v0, v0, 0, 31
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_sextops_i31_i63:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_lshlrev_b32_e32 v4, 1, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 1, v1
; SI-NEXT:    v_ashr_i64 v[4:5], v[3:4], 33
; SI-NEXT:    v_ashr_i64 v[0:1], v[0:1], 33
; SI-NEXT:    v_mul_lo_u32 v1, v4, v0
; SI-NEXT:    v_mul_hi_i32 v4, v4, v0
; SI-NEXT:    v_add_i32_e32 v0, vcc, v1, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v4, v3, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_sextops_i31_i63:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_bfe_i32 v1, v1, 0, 31
; GFX9-NEXT:    v_bfe_i32 v0, v0, 0, 31
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i31 %arg0 to i63
  %sext1 = sext i31 %arg1 to i63
  %mul = mul i63 %sext0, %sext1
  %mad = add i63 %mul, %arg2
  ret i63 %mad
}

define i64 @mad_i64_i32_extops_i32_i64(i32 %arg0, i32 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_i64_i32_extops_i32_i64:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; CI-NEXT:    v_mul_lo_u32 v4, v4, v1
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    v_add_i32_e32 v1, vcc, v4, v1
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_extops_i32_i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; SI-NEXT:    v_mul_hi_u32 v5, v0, v1
; SI-NEXT:    v_mul_lo_u32 v4, v4, v1
; SI-NEXT:    v_mul_lo_u32 v0, v0, v1
; SI-NEXT:    v_add_i32_e32 v1, vcc, v5, v4
; SI-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v3, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_extops_i32_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; GFX9-NEXT:    v_mul_lo_u32 v4, v4, v1
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    v_add_u32_e32 v1, v4, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %ext0 = sext i32 %arg0 to i64
  %ext1 = zext i32 %arg1 to i64
  %mul = mul i64 %ext0, %ext1
  %mad = add i64 %mul, %arg2
  ret i64 %mad
}

define i64 @mad_u64_u32_bitops(i64 %arg0, i64 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_u64_u32_bitops:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v2, v[4:5]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_u64_u32_bitops:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v1, v0, v2
; SI-NEXT:    v_mul_hi_u32 v2, v0, v2
; SI-NEXT:    v_add_i32_e32 v0, vcc, v1, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v2, v5, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_u64_u32_bitops:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v2, v[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %trunc.lhs = and i64 %arg0, 4294967295
  %trunc.rhs = and i64 %arg1, 4294967295
  %mul = mul i64 %trunc.lhs, %trunc.rhs
  %add = add i64 %mul, %arg2
  ret i64 %add
}

define i64 @mad_u64_u32_bitops_lhs_mask_small(i64 %arg0, i64 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_u64_u32_bitops_lhs_mask_small:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_and_b32_e32 v3, 1, v1
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v2, v[4:5]
; CI-NEXT:    v_mul_lo_u32 v2, v3, v2
; CI-NEXT:    v_add_i32_e32 v1, vcc, v2, v1
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_u64_u32_bitops_lhs_mask_small:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_and_b32_e32 v1, 1, v1
; SI-NEXT:    v_mul_hi_u32 v3, v0, v2
; SI-NEXT:    v_mul_lo_u32 v1, v1, v2
; SI-NEXT:    v_mul_lo_u32 v0, v0, v2
; SI-NEXT:    v_add_i32_e32 v1, vcc, v3, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v5, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_u64_u32_bitops_lhs_mask_small:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v3, 1, v1
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v0, v2, v[4:5]
; GFX9-NEXT:    v_mul_lo_u32 v2, v3, v2
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %trunc.lhs = and i64 %arg0, 8589934591
  %trunc.rhs = and i64 %arg1, 4294967295
  %mul = mul i64 %trunc.lhs, %trunc.rhs
  %add = add i64 %mul, %arg2
  ret i64 %add
}

define i64 @mad_u64_u32_bitops_rhs_mask_small(i64 %arg0, i64 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_u64_u32_bitops_rhs_mask_small:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mov_b32_e32 v6, v0
; CI-NEXT:    v_and_b32_e32 v3, 1, v3
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v6, v2, v[4:5]
; CI-NEXT:    v_mul_lo_u32 v2, v6, v3
; CI-NEXT:    v_add_i32_e32 v1, vcc, v2, v1
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_u64_u32_bitops_rhs_mask_small:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_and_b32_e32 v1, 1, v3
; SI-NEXT:    v_mul_hi_u32 v3, v0, v2
; SI-NEXT:    v_mul_lo_u32 v1, v0, v1
; SI-NEXT:    v_mul_lo_u32 v0, v0, v2
; SI-NEXT:    v_add_i32_e32 v1, vcc, v3, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v5, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_u64_u32_bitops_rhs_mask_small:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v6, v0
; GFX9-NEXT:    v_and_b32_e32 v3, 1, v3
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v6, v2, v[4:5]
; GFX9-NEXT:    v_mul_lo_u32 v2, v6, v3
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %trunc.lhs = and i64 %arg0, 4294967295
  %trunc.rhs = and i64 %arg1, 8589934591
  %mul = mul i64 %trunc.lhs, %trunc.rhs
  %add = add i64 %mul, %arg2
  ret i64 %add
}

define i64 @mad_i64_i32_bitops(i64 %arg0, i64 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_i64_i32_bitops:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v2, v[4:5]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_bitops:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v1, v0, v2
; SI-NEXT:    v_mul_hi_i32 v2, v0, v2
; SI-NEXT:    v_add_i32_e32 v0, vcc, v1, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v2, v5, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_bitops:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v2, v[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %shl.lhs = shl i64 %arg0, 32
  %trunc.lhs = ashr i64 %shl.lhs, 32
  %shl.rhs = shl i64 %arg1, 32
  %trunc.rhs = ashr i64 %shl.rhs, 32
  %mul = mul i64 %trunc.lhs, %trunc.rhs
  %add = add i64 %mul, %arg2
  ret i64 %add
}

; Example from bug report
define i64 @mad_i64_i32_unpack_i64ops(i64 %arg0) #0 {
; CI-LABEL: mad_i64_i32_unpack_i64ops:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v1, v0, v[0:1]
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_unpack_i64ops:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v2, v1, v0
; SI-NEXT:    v_mul_hi_u32 v3, v1, v0
; SI-NEXT:    v_add_i32_e32 v0, vcc, v2, v0
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v3, v1, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_unpack_i64ops:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v1, v0, v[0:1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %tmp4 = lshr i64 %arg0, 32
  %tmp5 = and i64 %arg0, 4294967295
  %mul = mul nuw i64 %tmp4, %tmp5
  %mad = add i64 %mul, %arg0
  ret i64 %mad
}

define amdgpu_kernel void @mad_i64_i32_uniform(i64 addrspace(1)* %out, i32 %arg0, i32 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_i64_i32_uniform:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xb
; CI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; CI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_mov_b32_e32 v2, s3
; CI-NEXT:    v_mov_b32_e32 v0, s4
; CI-NEXT:    v_mov_b32_e32 v1, s5
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[2:3], s2, v2, v[0:1]
; CI-NEXT:    s_mov_b32 s3, 0xf000
; CI-NEXT:    s_mov_b32 s2, -1
; CI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; CI-NEXT:    s_endpgm
;
; SI-LABEL: mad_i64_i32_uniform:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s3
; SI-NEXT:    v_mul_hi_u32 v1, s2, v0
; SI-NEXT:    s_mul_i32 s2, s2, s3
; SI-NEXT:    v_mov_b32_e32 v0, s2
; SI-NEXT:    v_mov_b32_e32 v2, s1
; SI-NEXT:    v_add_i32_e32 v0, vcc, s0, v0
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v2, vcc
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; GFX9-LABEL: mad_i64_i32_uniform:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; GFX9-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mul_i32 s0, s2, s3
; GFX9-NEXT:    s_mul_hi_u32 s1, s2, s3
; GFX9-NEXT:    s_add_u32 s0, s0, s4
; GFX9-NEXT:    s_addc_u32 s1, s1, s5
; GFX9-NEXT:    v_pk_mov_b32 v[0:1], s[0:1], s[0:1] op_sel:[0,1]
; GFX9-NEXT:    global_store_dwordx2 v2, v[0:1], s[6:7]
; GFX9-NEXT:    s_endpgm
  %ext0 = zext i32 %arg0 to i64
  %ext1 = zext i32 %arg1 to i64
  %mul = mul i64 %ext0, %ext1
  %mad = add i64 %mul, %arg2
  store i64 %mad, i64 addrspace(1)* %out
  ret void
}

define i64 @mad_i64_i32_twice(i32 %arg0, i32 %arg1, i64 %arg2, i64 %arg3) #0 {
; CI-LABEL: mad_i64_i32_twice:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_i64_i32 v[2:3], s[4:5], v0, v1, v[2:3]
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[4:5]
; CI-NEXT:    v_xor_b32_e32 v1, v3, v1
; CI-NEXT:    v_xor_b32_e32 v0, v2, v0
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_twice:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v6, v0, v1
; SI-NEXT:    v_mul_hi_i32 v0, v0, v1
; SI-NEXT:    v_add_i32_e32 v2, vcc, v6, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v0, v3, vcc
; SI-NEXT:    v_add_i32_e32 v3, vcc, v6, v4
; SI-NEXT:    v_addc_u32_e32 v0, vcc, v0, v5, vcc
; SI-NEXT:    v_xor_b32_e32 v1, v1, v0
; SI-NEXT:    v_xor_b32_e32 v0, v2, v3
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_twice:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_i64_i32 v[2:3], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[4:5]
; GFX9-NEXT:    v_xor_b32_e32 v1, v3, v1
; GFX9-NEXT:    v_xor_b32_e32 v0, v2, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i32 %arg0 to i64
  %sext1 = sext i32 %arg1 to i64
  %mul = mul i64 %sext0, %sext1
  %mad1 = add i64 %mul, %arg2
  %mad2 = add i64 %mul, %arg3
  %out = xor i64 %mad1, %mad2
  ret i64 %out
}

define i64 @mad_i64_i32_thrice(i32 %arg0, i32 %arg1, i64 %arg2, i64 %arg3, i64 %arg4) #0 {
; CI-LABEL: mad_i64_i32_thrice:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, 0
; CI-NEXT:    v_add_i32_e32 v2, vcc, v0, v2
; CI-NEXT:    v_addc_u32_e32 v3, vcc, v1, v3, vcc
; CI-NEXT:    v_add_i32_e32 v4, vcc, v0, v4
; CI-NEXT:    v_addc_u32_e32 v5, vcc, v1, v5, vcc
; CI-NEXT:    v_add_i32_e32 v0, vcc, v0, v6
; CI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v7, vcc
; CI-NEXT:    v_xor_b32_e32 v3, v3, v5
; CI-NEXT:    v_xor_b32_e32 v2, v2, v4
; CI-NEXT:    v_xor_b32_e32 v1, v3, v1
; CI-NEXT:    v_xor_b32_e32 v0, v2, v0
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_thrice:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v8, v0, v1
; SI-NEXT:    v_mul_hi_i32 v0, v0, v1
; SI-NEXT:    v_add_i32_e32 v1, vcc, v8, v2
; SI-NEXT:    v_addc_u32_e32 v2, vcc, v0, v3, vcc
; SI-NEXT:    v_add_i32_e32 v3, vcc, v8, v4
; SI-NEXT:    v_addc_u32_e32 v4, vcc, v0, v5, vcc
; SI-NEXT:    v_add_i32_e32 v5, vcc, v8, v6
; SI-NEXT:    v_addc_u32_e32 v0, vcc, v0, v7, vcc
; SI-NEXT:    v_xor_b32_e32 v2, v2, v4
; SI-NEXT:    v_xor_b32_e32 v3, v1, v3
; SI-NEXT:    v_xor_b32_e32 v1, v2, v0
; SI-NEXT:    v_xor_b32_e32 v0, v3, v5
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_thrice:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_i64_i32 v[2:3], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    v_mad_i64_i32 v[4:5], s[4:5], v0, v1, v[4:5]
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[6:7]
; GFX9-NEXT:    v_xor_b32_e32 v3, v3, v5
; GFX9-NEXT:    v_xor_b32_e32 v2, v2, v4
; GFX9-NEXT:    v_xor_b32_e32 v1, v3, v1
; GFX9-NEXT:    v_xor_b32_e32 v0, v2, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i32 %arg0 to i64
  %sext1 = sext i32 %arg1 to i64
  %mul = mul i64 %sext0, %sext1
  %mad1 = add i64 %mul, %arg2
  %mad2 = add i64 %mul, %arg3
  %mad3 = add i64 %mul, %arg4
  %out.p = xor i64 %mad1, %mad2
  %out = xor i64 %out.p, %mad3
  ret i64 %out
}

define i64 @mad_i64_i32_secondary_use(i32 %arg0, i32 %arg1, i64 %arg2) #0 {
; CI-LABEL: mad_i64_i32_secondary_use:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, 0
; CI-NEXT:    v_add_i32_e32 v2, vcc, v0, v2
; CI-NEXT:    v_addc_u32_e32 v3, vcc, v1, v3, vcc
; CI-NEXT:    v_xor_b32_e32 v1, v3, v1
; CI-NEXT:    v_xor_b32_e32 v0, v2, v0
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i64_i32_secondary_use:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v4, v0, v1
; SI-NEXT:    v_mul_hi_i32 v0, v0, v1
; SI-NEXT:    v_add_i32_e32 v2, vcc, v4, v2
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v0, v3, vcc
; SI-NEXT:    v_xor_b32_e32 v1, v1, v0
; SI-NEXT:    v_xor_b32_e32 v0, v2, v4
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i64_i32_secondary_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_i64_i32 v[4:5], s[4:5], v0, v1, 0
; GFX9-NEXT:    v_mad_i64_i32 v[0:1], s[4:5], v0, v1, v[2:3]
; GFX9-NEXT:    v_xor_b32_e32 v1, v1, v5
; GFX9-NEXT:    v_xor_b32_e32 v0, v0, v4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %sext0 = sext i32 %arg0 to i64
  %sext1 = sext i32 %arg1 to i64
  %mul = mul i64 %sext0, %sext1
  %mad = add i64 %mul, %arg2
  %out = xor i64 %mad, %mul
  ret i64 %out
}

define i48 @mad_i48_i48(i48 %arg0, i48 %arg1, i48 %arg2) #0 {
; CI-LABEL: mad_i48_i48:
; CI:       ; %bb.0:
; CI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CI-NEXT:    v_mov_b32_e32 v6, v1
; CI-NEXT:    v_mov_b32_e32 v7, v0
; CI-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v7, v2, v[4:5]
; CI-NEXT:    v_mul_lo_u32 v2, v6, v2
; CI-NEXT:    v_mul_lo_u32 v3, v7, v3
; CI-NEXT:    v_add_i32_e32 v1, vcc, v2, v1
; CI-NEXT:    v_add_i32_e32 v1, vcc, v3, v1
; CI-NEXT:    s_setpc_b64 s[30:31]
;
; SI-LABEL: mad_i48_i48:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_mul_lo_u32 v3, v0, v3
; SI-NEXT:    v_mul_hi_u32 v6, v0, v2
; SI-NEXT:    v_mul_lo_u32 v1, v1, v2
; SI-NEXT:    v_mul_lo_u32 v0, v0, v2
; SI-NEXT:    v_add_i32_e32 v3, vcc, v6, v3
; SI-NEXT:    v_add_i32_e32 v1, vcc, v3, v1
; SI-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; SI-NEXT:    v_addc_u32_e32 v1, vcc, v1, v5, vcc
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: mad_i48_i48:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v6, v1
; GFX9-NEXT:    v_mov_b32_e32 v7, v0
; GFX9-NEXT:    v_mad_u64_u32 v[0:1], s[4:5], v7, v2, v[4:5]
; GFX9-NEXT:    v_mul_lo_u32 v3, v7, v3
; GFX9-NEXT:    v_mul_lo_u32 v2, v6, v2
; GFX9-NEXT:    v_add3_u32 v1, v2, v1, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %m = mul i48 %arg0, %arg1
  %a = add i48 %m, %arg2
  ret i48 %a
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone speculatable }
