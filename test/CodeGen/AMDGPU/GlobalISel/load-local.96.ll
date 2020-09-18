; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=hawaii -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX7 %s

; FIXME:
; XUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX6 %s

define <3 x i32> @load_lds_v3i32(<3 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v3i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_read_b96 v[0:2], v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v3i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    ds_read_b96 v[0:2], v0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(3)* %ptr
  ret <3 x i32> %load
}

define <3 x i32> @load_lds_v3i32_align1(<3 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v3i32_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v2, v0
; GFX9-NEXT:    ds_read_u8 v0, v0
; GFX9-NEXT:    ds_read_u8 v1, v2 offset:1
; GFX9-NEXT:    ds_read_u8 v4, v2 offset:2
; GFX9-NEXT:    ds_read_u8 v5, v2 offset:3
; GFX9-NEXT:    ds_read_u8 v6, v2 offset:4
; GFX9-NEXT:    ds_read_u8 v7, v2 offset:5
; GFX9-NEXT:    ds_read_u8 v8, v2 offset:6
; GFX9-NEXT:    ds_read_u8 v9, v2 offset:7
; GFX9-NEXT:    s_mov_b32 s5, 8
; GFX9-NEXT:    s_movk_i32 s4, 0xff
; GFX9-NEXT:    s_waitcnt lgkmcnt(6)
; GFX9-NEXT:    v_lshlrev_b32_sdwa v1, s5, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NEXT:    v_and_or_b32 v0, v0, s4, v1
; GFX9-NEXT:    s_waitcnt lgkmcnt(5)
; GFX9-NEXT:    v_and_b32_e32 v1, s4, v4
; GFX9-NEXT:    s_waitcnt lgkmcnt(4)
; GFX9-NEXT:    v_and_b32_e32 v4, s4, v5
; GFX9-NEXT:    v_mov_b32_e32 v3, 0xff
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NEXT:    v_lshlrev_b32_e32 v4, 24, v4
; GFX9-NEXT:    v_or3_b32 v0, v0, v1, v4
; GFX9-NEXT:    s_waitcnt lgkmcnt(2)
; GFX9-NEXT:    v_lshlrev_b32_sdwa v1, s5, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NEXT:    s_waitcnt lgkmcnt(1)
; GFX9-NEXT:    v_and_b32_e32 v4, v8, v3
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v5, v9, v3
; GFX9-NEXT:    v_and_or_b32 v1, v6, s4, v1
; GFX9-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX9-NEXT:    v_lshlrev_b32_e32 v5, 24, v5
; GFX9-NEXT:    v_or3_b32 v1, v1, v4, v5
; GFX9-NEXT:    ds_read_u8 v4, v2 offset:8
; GFX9-NEXT:    ds_read_u8 v5, v2 offset:9
; GFX9-NEXT:    ds_read_u8 v6, v2 offset:10
; GFX9-NEXT:    ds_read_u8 v2, v2 offset:11
; GFX9-NEXT:    v_mov_b32_e32 v7, 8
; GFX9-NEXT:    s_waitcnt lgkmcnt(2)
; GFX9-NEXT:    v_lshlrev_b32_sdwa v5, v7, v5 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NEXT:    v_and_or_b32 v4, v4, v3, v5
; GFX9-NEXT:    s_waitcnt lgkmcnt(1)
; GFX9-NEXT:    v_and_b32_e32 v5, v6, v3
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v2, v2, v3
; GFX9-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GFX9-NEXT:    v_lshlrev_b32_e32 v2, 24, v2
; GFX9-NEXT:    v_or3_b32 v2, v4, v5, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v3i32_align1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    v_mov_b32_e32 v2, v0
; GFX7-NEXT:    s_movk_i32 s4, 0xff
; GFX7-NEXT:    ds_read_u8 v0, v0
; GFX7-NEXT:    ds_read_u8 v1, v2 offset:1
; GFX7-NEXT:    ds_read_u8 v4, v2 offset:2
; GFX7-NEXT:    ds_read_u8 v5, v2 offset:3
; GFX7-NEXT:    ds_read_u8 v6, v2 offset:4
; GFX7-NEXT:    ds_read_u8 v7, v2 offset:5
; GFX7-NEXT:    ds_read_u8 v8, v2 offset:6
; GFX7-NEXT:    ds_read_u8 v9, v2 offset:7
; GFX7-NEXT:    s_waitcnt lgkmcnt(6)
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v1
; GFX7-NEXT:    v_and_b32_e32 v0, s4, v0
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 8, v1
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    s_waitcnt lgkmcnt(5)
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v4
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX7-NEXT:    v_mov_b32_e32 v3, 0xff
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    s_waitcnt lgkmcnt(4)
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v5
; GFX7-NEXT:    s_waitcnt lgkmcnt(2)
; GFX7-NEXT:    v_and_b32_e32 v4, v7, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 24, v1
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v6
; GFX7-NEXT:    v_lshlrev_b32_e32 v4, 8, v4
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v4
; GFX7-NEXT:    s_waitcnt lgkmcnt(1)
; GFX7-NEXT:    v_and_b32_e32 v4, v8, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v4
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_and_b32_e32 v4, v9, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v4, 24, v4
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v4
; GFX7-NEXT:    ds_read_u8 v4, v2 offset:8
; GFX7-NEXT:    ds_read_u8 v5, v2 offset:9
; GFX7-NEXT:    ds_read_u8 v6, v2 offset:10
; GFX7-NEXT:    ds_read_u8 v2, v2 offset:11
; GFX7-NEXT:    s_waitcnt lgkmcnt(3)
; GFX7-NEXT:    v_and_b32_e32 v4, v4, v3
; GFX7-NEXT:    s_waitcnt lgkmcnt(2)
; GFX7-NEXT:    v_and_b32_e32 v5, v5, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v5, 8, v5
; GFX7-NEXT:    v_or_b32_e32 v4, v4, v5
; GFX7-NEXT:    s_waitcnt lgkmcnt(1)
; GFX7-NEXT:    v_and_b32_e32 v5, v6, v3
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_and_b32_e32 v2, v2, v3
; GFX7-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GFX7-NEXT:    v_or_b32_e32 v4, v4, v5
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 24, v2
; GFX7-NEXT:    v_or_b32_e32 v2, v4, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(3)* %ptr, align 1
  ret <3 x i32> %load
}

define <3 x i32> @load_lds_v3i32_align2(<3 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v3i32_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_read_u16 v1, v0
; GFX9-NEXT:    ds_read_u16 v2, v0 offset:2
; GFX9-NEXT:    ds_read_u16 v3, v0 offset:4
; GFX9-NEXT:    ds_read_u16 v4, v0 offset:6
; GFX9-NEXT:    ds_read_u16 v5, v0 offset:8
; GFX9-NEXT:    ds_read_u16 v6, v0 offset:10
; GFX9-NEXT:    s_mov_b32 s4, 0xffff
; GFX9-NEXT:    s_waitcnt lgkmcnt(4)
; GFX9-NEXT:    v_and_b32_e32 v0, s4, v2
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GFX9-NEXT:    v_and_or_b32 v0, v1, s4, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(2)
; GFX9-NEXT:    v_and_b32_e32 v1, s4, v4
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v2, s4, v6
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX9-NEXT:    v_and_or_b32 v1, v3, s4, v1
; GFX9-NEXT:    v_and_or_b32 v2, v5, s4, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v3i32_align2:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    ds_read_u16 v1, v0
; GFX7-NEXT:    ds_read_u16 v2, v0 offset:2
; GFX7-NEXT:    ds_read_u16 v3, v0 offset:4
; GFX7-NEXT:    ds_read_u16 v4, v0 offset:6
; GFX7-NEXT:    ds_read_u16 v5, v0 offset:8
; GFX7-NEXT:    ds_read_u16 v6, v0 offset:10
; GFX7-NEXT:    s_mov_b32 s4, 0xffff
; GFX7-NEXT:    s_waitcnt lgkmcnt(5)
; GFX7-NEXT:    v_and_b32_e32 v0, s4, v1
; GFX7-NEXT:    s_waitcnt lgkmcnt(4)
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v2
; GFX7-NEXT:    s_waitcnt lgkmcnt(2)
; GFX7-NEXT:    v_and_b32_e32 v2, s4, v4
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    v_and_b32_e32 v1, s4, v3
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_and_b32_e32 v3, s4, v6
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    v_and_b32_e32 v2, s4, v5
; GFX7-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX7-NEXT:    v_or_b32_e32 v2, v2, v3
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(3)* %ptr, align 2
  ret <3 x i32> %load
}

define <3 x i32> @load_lds_v3i32_align4(<3 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v3i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v2, v0
; GFX9-NEXT:    ds_read2_b32 v[0:1], v0 offset1:1
; GFX9-NEXT:    ds_read_b32 v2, v2 offset:8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v3i32_align4:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v2, v0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    ds_read2_b32 v[0:1], v0 offset1:1
; GFX7-NEXT:    ds_read_b32 v2, v2 offset:8
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(3)* %ptr, align 4
  ret <3 x i32> %load
}

define <3 x i32> @load_lds_v3i32_align8(<3 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v3i32_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v2, v0
; GFX9-NEXT:    ds_read_b64 v[0:1], v0
; GFX9-NEXT:    ds_read_b32 v2, v2 offset:8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v3i32_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v2, v0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    ds_read_b64 v[0:1], v0
; GFX7-NEXT:    ds_read_b32 v2, v2 offset:8
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(3)* %ptr, align 8
  ret <3 x i32> %load
}

define <3 x i32> @load_lds_v3i32_align16(<3 x i32> addrspace(3)* %ptr) {
; GFX9-LABEL: load_lds_v3i32_align16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_read_b96 v[0:2], v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: load_lds_v3i32_align16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    ds_read_b96 v[0:2], v0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(3)* %ptr, align 16
  ret <3 x i32> %load
}
