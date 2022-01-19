; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GFX7 %s
; RUN: llc -march=amdgcn -mcpu=tonga -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GFX8 %s
; RUN: llc -march=amdgcn -mcpu=gfx1031 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GFX10 %s
; RUN: llc -march=r600 -mcpu=redwood < %s | FileCheck -enable-var-scope -check-prefixes=R600 %s

; BFI_INT Definition pattern from ISA docs
; (y & x) | (z & ~x)
;
define amdgpu_kernel void @bfi_def(i32 addrspace(1)* %out, i32 %x, i32 %y, i32 %z) {
; GFX7-LABEL: bfi_def:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xb
; GFX7-NEXT:    s_load_dword s6, s[0:1], 0xd
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_andn2_b32 s6, s6, s4
; GFX7-NEXT:    s_and_b32 s4, s5, s4
; GFX7-NEXT:    s_or_b32 s4, s6, s4
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: bfi_def:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX8-NEXT:    s_load_dword s4, s[0:1], 0x34
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_andn2_b32 s4, s4, s2
; GFX8-NEXT:    s_and_b32 s2, s3, s2
; GFX8-NEXT:    s_or_b32 s2, s4, s2
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: bfi_def:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x2
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX10-NEXT:    s_load_dword s4, s[0:1], 0x34
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_andn2_b32 s4, s4, s2
; GFX10-NEXT:    s_and_b32 s2, s3, s2
; GFX10-NEXT:    s_or_b32 s2, s4, s2
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX10-NEXT:    s_endpgm
;
; R600-LABEL: bfi_def:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 2, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.X, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
; R600-NEXT:     BFI_INT * T1.X, KC0[2].Z, KC0[2].W, KC0[3].X,
entry:
  %0 = xor i32 %x, -1
  %1 = and i32 %z, %0
  %2 = and i32 %y, %x
  %3 = or i32 %1, %2
  store i32 %3, i32 addrspace(1)* %out
  ret void
}

; SHA-256 Ch function
; z ^ (x & (y ^ z))
define amdgpu_kernel void @bfi_sha256_ch(i32 addrspace(1)* %out, i32 %x, i32 %y, i32 %z) {
; GFX7-LABEL: bfi_sha256_ch:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xb
; GFX7-NEXT:    s_load_dword s6, s[0:1], 0xd
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_xor_b32 s5, s5, s6
; GFX7-NEXT:    s_and_b32 s4, s4, s5
; GFX7-NEXT:    s_xor_b32 s4, s6, s4
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: bfi_sha256_ch:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX8-NEXT:    s_load_dword s4, s[0:1], 0x34
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_xor_b32 s3, s3, s4
; GFX8-NEXT:    s_and_b32 s2, s2, s3
; GFX8-NEXT:    s_xor_b32 s2, s4, s2
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: bfi_sha256_ch:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x2
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX10-NEXT:    s_load_dword s4, s[0:1], 0x34
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_xor_b32 s3, s3, s4
; GFX10-NEXT:    s_and_b32 s2, s2, s3
; GFX10-NEXT:    s_xor_b32 s2, s4, s2
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX10-NEXT:    s_endpgm
;
; R600-LABEL: bfi_sha256_ch:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 2, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.X, T0.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
; R600-NEXT:     BFI_INT * T1.X, KC0[2].Z, KC0[2].W, KC0[3].X,
entry:
  %0 = xor i32 %y, %z
  %1 = and i32 %x, %0
  %2 = xor i32 %z, %1
  store i32 %2, i32 addrspace(1)* %out
  ret void
}

; SHA-256 Ma function
; ((x & z) | (y & (x | z)))
define amdgpu_kernel void @bfi_sha256_ma(i32 addrspace(1)* %out, i32 %x, i32 %y, i32 %z) {
; GFX7-LABEL: bfi_sha256_ma:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xb
; GFX7-NEXT:    s_load_dword s6, s[0:1], 0xd
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_and_b32 s7, s4, s6
; GFX7-NEXT:    s_or_b32 s4, s4, s6
; GFX7-NEXT:    s_and_b32 s4, s5, s4
; GFX7-NEXT:    s_or_b32 s4, s7, s4
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: bfi_sha256_ma:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX8-NEXT:    s_load_dword s4, s[0:1], 0x34
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_and_b32 s5, s2, s4
; GFX8-NEXT:    s_or_b32 s2, s2, s4
; GFX8-NEXT:    s_and_b32 s2, s3, s2
; GFX8-NEXT:    s_or_b32 s2, s5, s2
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: bfi_sha256_ma:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x2
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX10-NEXT:    s_load_dword s4, s[0:1], 0x34
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_or_b32 s5, s2, s4
; GFX10-NEXT:    s_and_b32 s2, s2, s4
; GFX10-NEXT:    s_and_b32 s3, s3, s5
; GFX10-NEXT:    s_or_b32 s2, s2, s3
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX10-NEXT:    s_endpgm
;
; R600-LABEL: bfi_sha256_ma:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.X, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     XOR_INT * T0.W, KC0[2].Z, KC0[2].W,
; R600-NEXT:     BFI_INT * T0.X, PV.W, KC0[3].X, KC0[2].W,
; R600-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; R600-NEXT:    2(2.802597e-45), 0(0.000000e+00)
entry:
  %0 = and i32 %x, %z
  %1 = or i32 %x, %z
  %2 = and i32 %y, %1
  %3 = or i32 %0, %2
  store i32 %3, i32 addrspace(1)* %out
  ret void
}

define <2 x i32> @v_bitselect_v2i32_pat1(<2 x i32> %a, <2 x i32> %b, <2 x i32> %mask) {
; GFX7-LABEL: v_bitselect_v2i32_pat1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX7-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bitselect_v2i32_pat1:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX8-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bitselect_v2i32_pat1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX10-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; R600-LABEL: v_bitselect_v2i32_pat1:
; R600:       ; %bb.0:
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
  %xor.0 = xor <2 x i32> %a, %mask
  %and = and <2 x i32> %xor.0, %b
  %bitselect = xor <2 x i32> %and, %mask
  ret <2 x i32> %bitselect
}

define i64 @v_bitselect_i64_pat_0(i64 %a, i64 %b, i64 %mask) {
; GFX7-LABEL: v_bitselect_i64_pat_0:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_bfi_b32 v1, v1, v3, v5
; GFX7-NEXT:    v_bfi_b32 v0, v0, v2, v4
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bitselect_i64_pat_0:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_bfi_b32 v1, v1, v3, v5
; GFX8-NEXT:    v_bfi_b32 v0, v0, v2, v4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bitselect_i64_pat_0:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfi_b32 v0, v0, v2, v4
; GFX10-NEXT:    v_bfi_b32 v1, v1, v3, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; R600-LABEL: v_bitselect_i64_pat_0:
; R600:       ; %bb.0:
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
  %and0 = and i64 %a, %b
  %not.a = xor i64 %a, -1
  %and1 = and i64 %not.a, %mask
  %bitselect = or i64 %and0, %and1
  ret i64 %bitselect
}

define i64 @v_bitselect_i64_pat_1(i64 %a, i64 %b, i64 %mask) {
; GFX7-LABEL: v_bitselect_i64_pat_1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX7-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bitselect_i64_pat_1:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX8-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bitselect_i64_pat_1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX10-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; R600-LABEL: v_bitselect_i64_pat_1:
; R600:       ; %bb.0:
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
  %xor.0 = xor i64 %a, %mask
  %and = and i64 %xor.0, %b
  %bitselect = xor i64 %and, %mask
  ret i64 %bitselect
}

define i64 @v_bitselect_i64_pat_2(i64 %a, i64 %b, i64 %mask) {
; GFX7-LABEL: v_bitselect_i64_pat_2:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX7-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bitselect_i64_pat_2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX8-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bitselect_i64_pat_2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfi_b32 v0, v2, v0, v4
; GFX10-NEXT:    v_bfi_b32 v1, v3, v1, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; R600-LABEL: v_bitselect_i64_pat_2:
; R600:       ; %bb.0:
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
  %xor.0 = xor i64 %a, %mask
  %and = and i64 %xor.0, %b
  %bitselect = xor i64 %and, %mask
  ret i64 %bitselect
}

define i64 @v_bfi_sha256_ma_i64(i64 %x, i64 %y, i64 %z) {
; GFX7-LABEL: v_bfi_sha256_ma_i64:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_xor_b32_e32 v1, v1, v3
; GFX7-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX7-NEXT:    v_bfi_b32 v1, v1, v5, v3
; GFX7-NEXT:    v_bfi_b32 v0, v0, v4, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bfi_sha256_ma_i64:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v1, v1, v3
; GFX8-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX8-NEXT:    v_bfi_b32 v1, v1, v5, v3
; GFX8-NEXT:    v_bfi_b32 v0, v0, v4, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bfi_sha256_ma_i64:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX10-NEXT:    v_xor_b32_e32 v1, v1, v3
; GFX10-NEXT:    v_bfi_b32 v0, v0, v4, v2
; GFX10-NEXT:    v_bfi_b32 v1, v1, v5, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; R600-LABEL: v_bfi_sha256_ma_i64:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
entry:
  %and0 = and i64 %x, %z
  %or0 = or i64 %x, %z
  %and1 = and i64 %y, %or0
  %or1 = or i64 %and0, %and1
  ret i64 %or1
}

define amdgpu_kernel void @s_bitselect_i64_pat_0(i64 %a, i64 %b, i64 %mask) {
; GFX7-LABEL: s_bitselect_i64_pat_0:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_and_b64 s[6:7], s[4:5], s[6:7]
; GFX7-NEXT:    s_andn2_b64 s[0:1], s[0:1], s[4:5]
; GFX7-NEXT:    s_or_b64 s[0:1], s[6:7], s[0:1]
; GFX7-NEXT:    s_add_u32 s0, s0, 10
; GFX7-NEXT:    s_addc_u32 s1, s1, 0
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: s_bitselect_i64_pat_0:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_and_b64 s[2:3], s[4:5], s[6:7]
; GFX8-NEXT:    s_andn2_b64 s[0:1], s[0:1], s[4:5]
; GFX8-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; GFX8-NEXT:    s_add_u32 s0, s0, 10
; GFX8-NEXT:    s_addc_u32 s1, s1, 0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: s_bitselect_i64_pat_0:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_and_b64 s[2:3], s[4:5], s[6:7]
; GFX10-NEXT:    s_andn2_b64 s[0:1], s[0:1], s[4:5]
; GFX10-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; GFX10-NEXT:    s_add_u32 s0, s0, 10
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX10-NEXT:    s_endpgm
;
; R600-LABEL: s_bitselect_i64_pat_0:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 9, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV * T0.W, KC0[3].Y,
; R600-NEXT:     BFI_INT * T0.W, KC0[2].Y, KC0[2].W, PV.W,
; R600-NEXT:     MOV * T1.W, KC0[3].Z,
; R600-NEXT:     BFI_INT T1.W, KC0[2].Z, KC0[3].X, PV.W,
; R600-NEXT:     ADDC_UINT * T2.W, T0.W, literal.x,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
; R600-NEXT:     ADD_INT * T0.Y, PV.W, PS,
; R600-NEXT:     ADD_INT T0.X, T0.W, literal.x,
; R600-NEXT:     MOV * T1.X, literal.y,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
  %and0 = and i64 %a, %b
  %not.a = xor i64 %a, -1
  %and1 = and i64 %not.a, %mask
  %bitselect = or i64 %and0, %and1
  %scalar.use = add i64 %bitselect, 10
  store i64 %scalar.use, i64 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @s_bitselect_i64_pat_1(i64 %a, i64 %b, i64 %mask) {
; GFX7-LABEL: s_bitselect_i64_pat_1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_xor_b64 s[4:5], s[4:5], s[0:1]
; GFX7-NEXT:    s_and_b64 s[4:5], s[4:5], s[6:7]
; GFX7-NEXT:    s_xor_b64 s[0:1], s[4:5], s[0:1]
; GFX7-NEXT:    s_add_u32 s0, s0, 10
; GFX7-NEXT:    s_addc_u32 s1, s1, 0
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: s_bitselect_i64_pat_1:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_xor_b64 s[2:3], s[4:5], s[0:1]
; GFX8-NEXT:    s_and_b64 s[2:3], s[2:3], s[6:7]
; GFX8-NEXT:    s_xor_b64 s[0:1], s[2:3], s[0:1]
; GFX8-NEXT:    s_add_u32 s0, s0, 10
; GFX8-NEXT:    s_addc_u32 s1, s1, 0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: s_bitselect_i64_pat_1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_xor_b64 s[2:3], s[4:5], s[0:1]
; GFX10-NEXT:    s_and_b64 s[2:3], s[2:3], s[6:7]
; GFX10-NEXT:    s_xor_b64 s[0:1], s[2:3], s[0:1]
; GFX10-NEXT:    s_add_u32 s0, s0, 10
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX10-NEXT:    s_endpgm
;
; R600-LABEL: s_bitselect_i64_pat_1:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 9, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV * T0.W, KC0[3].Y,
; R600-NEXT:     BFI_INT * T0.W, KC0[2].W, KC0[2].Y, PV.W,
; R600-NEXT:     MOV * T1.W, KC0[3].Z,
; R600-NEXT:     BFI_INT T1.W, KC0[3].X, KC0[2].Z, PV.W,
; R600-NEXT:     ADDC_UINT * T2.W, T0.W, literal.x,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
; R600-NEXT:     ADD_INT * T0.Y, PV.W, PS,
; R600-NEXT:     ADD_INT T0.X, T0.W, literal.x,
; R600-NEXT:     MOV * T1.X, literal.y,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
  %xor.0 = xor i64 %a, %mask
  %and = and i64 %xor.0, %b
  %bitselect = xor i64 %and, %mask

  %scalar.use = add i64 %bitselect, 10
  store i64 %scalar.use, i64 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @s_bitselect_i64_pat_2(i64 %a, i64 %b, i64 %mask) {
; GFX7-LABEL: s_bitselect_i64_pat_2:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_xor_b64 s[4:5], s[4:5], s[0:1]
; GFX7-NEXT:    s_and_b64 s[4:5], s[4:5], s[6:7]
; GFX7-NEXT:    s_xor_b64 s[0:1], s[4:5], s[0:1]
; GFX7-NEXT:    s_add_u32 s0, s0, 10
; GFX7-NEXT:    s_addc_u32 s1, s1, 0
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: s_bitselect_i64_pat_2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_xor_b64 s[2:3], s[4:5], s[0:1]
; GFX8-NEXT:    s_and_b64 s[2:3], s[2:3], s[6:7]
; GFX8-NEXT:    s_xor_b64 s[0:1], s[2:3], s[0:1]
; GFX8-NEXT:    s_add_u32 s0, s0, 10
; GFX8-NEXT:    s_addc_u32 s1, s1, 0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: s_bitselect_i64_pat_2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_xor_b64 s[2:3], s[4:5], s[0:1]
; GFX10-NEXT:    s_and_b64 s[2:3], s[2:3], s[6:7]
; GFX10-NEXT:    s_xor_b64 s[0:1], s[2:3], s[0:1]
; GFX10-NEXT:    s_add_u32 s0, s0, 10
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX10-NEXT:    s_endpgm
;
; R600-LABEL: s_bitselect_i64_pat_2:
; R600:       ; %bb.0:
; R600-NEXT:    ALU 9, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     MOV * T0.W, KC0[3].Y,
; R600-NEXT:     BFI_INT * T0.W, KC0[2].W, KC0[2].Y, PV.W,
; R600-NEXT:     MOV * T1.W, KC0[3].Z,
; R600-NEXT:     BFI_INT T1.W, KC0[3].X, KC0[2].Z, PV.W,
; R600-NEXT:     ADDC_UINT * T2.W, T0.W, literal.x,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
; R600-NEXT:     ADD_INT * T0.Y, PV.W, PS,
; R600-NEXT:     ADD_INT T0.X, T0.W, literal.x,
; R600-NEXT:     MOV * T1.X, literal.y,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
  %xor.0 = xor i64 %a, %mask
  %and = and i64 %xor.0, %b
  %bitselect = xor i64 %and, %mask

  %scalar.use = add i64 %bitselect, 10
  store i64 %scalar.use, i64 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @s_bfi_sha256_ma_i64(i64 %x, i64 %y, i64 %z) {
; GFX7-LABEL: s_bfi_sha256_ma_i64:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; GFX7-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NEXT:    s_mov_b32 s2, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_and_b64 s[8:9], s[4:5], s[0:1]
; GFX7-NEXT:    s_or_b64 s[0:1], s[4:5], s[0:1]
; GFX7-NEXT:    s_and_b64 s[0:1], s[6:7], s[0:1]
; GFX7-NEXT:    s_or_b64 s[0:1], s[8:9], s[0:1]
; GFX7-NEXT:    s_add_u32 s0, s0, 10
; GFX7-NEXT:    s_addc_u32 s1, s1, 0
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX7-NEXT:    s_endpgm
;
; GFX8-LABEL: s_bfi_sha256_ma_i64:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_and_b64 s[2:3], s[4:5], s[0:1]
; GFX8-NEXT:    s_or_b64 s[0:1], s[4:5], s[0:1]
; GFX8-NEXT:    s_and_b64 s[0:1], s[6:7], s[0:1]
; GFX8-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; GFX8-NEXT:    s_add_u32 s0, s0, 10
; GFX8-NEXT:    s_addc_u32 s1, s1, 0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: s_bfi_sha256_ma_i64:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_or_b64 s[2:3], s[4:5], s[0:1]
; GFX10-NEXT:    s_and_b64 s[0:1], s[4:5], s[0:1]
; GFX10-NEXT:    s_and_b64 s[2:3], s[6:7], s[2:3]
; GFX10-NEXT:    s_or_b64 s[0:1], s[0:1], s[2:3]
; GFX10-NEXT:    s_add_u32 s0, s0, 10
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-NEXT:    global_store_dwordx2 v[0:1], v[0:1], off
; GFX10-NEXT:    s_endpgm
;
; R600-LABEL: s_bfi_sha256_ma_i64:
; R600:       ; %bb.0: ; %entry
; R600-NEXT:    ALU 9, @4, KC0[CB0:0-32], KC1[]
; R600-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; R600-NEXT:    CF_END
; R600-NEXT:    PAD
; R600-NEXT:    ALU clause starting at 4:
; R600-NEXT:     XOR_INT * T0.W, KC0[2].Y, KC0[2].W,
; R600-NEXT:     BFI_INT T0.W, PV.W, KC0[3].Y, KC0[2].W,
; R600-NEXT:     XOR_INT * T1.W, KC0[2].Z, KC0[3].X,
; R600-NEXT:     BFI_INT T1.W, PS, KC0[3].Z, KC0[3].X,
; R600-NEXT:     ADDC_UINT * T2.W, PV.W, literal.x,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
; R600-NEXT:     ADD_INT * T0.Y, PV.W, PS,
; R600-NEXT:     ADD_INT T0.X, T0.W, literal.x,
; R600-NEXT:     MOV * T1.X, literal.y,
; R600-NEXT:    10(1.401298e-44), 0(0.000000e+00)
entry:
  %and0 = and i64 %x, %z
  %or0 = or i64 %x, %z
  %and1 = and i64 %y, %or0
  %or1 = or i64 %and0, %and1

  %scalar.use = add i64 %or1, 10
  store i64 %scalar.use, i64 addrspace(1)* undef
  ret void
}
