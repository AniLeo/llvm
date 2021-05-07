; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX900 %s
; RUN: llc -march=amdgcn -mcpu=gfx908 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX908 %s
; RUN: llc -march=amdgcn -mcpu=gfx90a -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX90A %s
; RUN: llc -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX10 %s

define amdgpu_kernel void @global_atomic_fadd_ret_f32(float addrspace(1)* %ptr) #0 {
; GFX900-LABEL: global_atomic_fadd_ret_f32:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX900-NEXT:    s_mov_b64 s[2:3], 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v0, s4
; GFX900-NEXT:  BB0_1: ; %atomicrmw.start
; GFX900-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX900-NEXT:    v_mov_b32_e32 v1, v0
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX900-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX900-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_wbinvl1_vol
; GFX900-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX900-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX900-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX900-NEXT:    s_cbranch_execnz BB0_1
; GFX900-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX900-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX900-NEXT:    global_store_dword v[0:1], v0, off
; GFX900-NEXT:    s_endpgm
;
; GFX908-LABEL: global_atomic_fadd_ret_f32:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX908-NEXT:    s_mov_b64 s[2:3], 0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    v_mov_b32_e32 v0, s4
; GFX908-NEXT:  BB0_1: ; %atomicrmw.start
; GFX908-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX908-NEXT:    v_mov_b32_e32 v1, v0
; GFX908-NEXT:    v_mov_b32_e32 v2, 0
; GFX908-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX908-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    buffer_wbinvl1_vol
; GFX908-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX908-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX908-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX908-NEXT:    s_cbranch_execnz BB0_1
; GFX908-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX908-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX908-NEXT:    global_store_dword v[0:1], v0, off
; GFX908-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_atomic_fadd_ret_f32:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX90A-NEXT:    s_mov_b64 s[2:3], 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    v_mov_b32_e32 v0, s4
; GFX90A-NEXT:  BB0_1: ; %atomicrmw.start
; GFX90A-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX90A-NEXT:    v_mov_b32_e32 v1, v0
; GFX90A-NEXT:    v_mov_b32_e32 v2, 0
; GFX90A-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX90A-NEXT:    buffer_wbl2
; GFX90A-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    buffer_invl2
; GFX90A-NEXT:    buffer_wbinvl1_vol
; GFX90A-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX90A-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX90A-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX90A-NEXT:    s_cbranch_execnz BB0_1
; GFX90A-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX90A-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX90A-NEXT:    global_store_dword v[0:1], v0, off
; GFX90A-NEXT:    s_endpgm
;
; GFX10-LABEL: global_atomic_fadd_ret_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    s_mov_b32 s2, 0
; GFX10-NEXT:  BB0_1: ; %atomicrmw.start
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX10-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_gl0_inv
; GFX10-NEXT:    buffer_gl1_inv
; GFX10-NEXT:    v_cmp_eq_u32_e32 vcc_lo, v0, v1
; GFX10-NEXT:    s_or_b32 s2, vcc_lo, s2
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    s_cbranch_execnz BB0_1
; GFX10-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX10-NEXT:    s_or_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    global_store_dword v[0:1], v0, off
; GFX10-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 seq_cst
  store float %result, float addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_ret_f32_ieee(float addrspace(1)* %ptr) #2 {
; GFX900-LABEL: global_atomic_fadd_ret_f32_ieee:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX900-NEXT:    s_mov_b64 s[2:3], 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v0, s4
; GFX900-NEXT:  BB1_1: ; %atomicrmw.start
; GFX900-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX900-NEXT:    v_mov_b32_e32 v1, v0
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX900-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX900-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_wbinvl1_vol
; GFX900-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX900-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX900-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX900-NEXT:    s_cbranch_execnz BB1_1
; GFX900-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX900-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX900-NEXT:    global_store_dword v[0:1], v0, off
; GFX900-NEXT:    s_endpgm
;
; GFX908-LABEL: global_atomic_fadd_ret_f32_ieee:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX908-NEXT:    s_mov_b64 s[2:3], 0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    v_mov_b32_e32 v0, s4
; GFX908-NEXT:  BB1_1: ; %atomicrmw.start
; GFX908-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX908-NEXT:    v_mov_b32_e32 v1, v0
; GFX908-NEXT:    v_mov_b32_e32 v2, 0
; GFX908-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX908-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    buffer_wbinvl1_vol
; GFX908-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX908-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX908-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX908-NEXT:    s_cbranch_execnz BB1_1
; GFX908-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX908-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX908-NEXT:    global_store_dword v[0:1], v0, off
; GFX908-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_atomic_fadd_ret_f32_ieee:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v0, 0
; GFX90A-NEXT:    v_mov_b32_e32 v1, 4.0
; GFX90A-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NEXT:    global_atomic_add_f32 v0, v0, v1, s[0:1] glc
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    buffer_wbinvl1_vol
; GFX90A-NEXT:    global_store_dword v[0:1], v0, off
; GFX90A-NEXT:    s_endpgm
;
; GFX10-LABEL: global_atomic_fadd_ret_f32_ieee:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    s_mov_b32 s2, 0
; GFX10-NEXT:  BB1_1: ; %atomicrmw.start
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX10-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_gl0_inv
; GFX10-NEXT:    buffer_gl1_inv
; GFX10-NEXT:    v_cmp_eq_u32_e32 vcc_lo, v0, v1
; GFX10-NEXT:    s_or_b32 s2, vcc_lo, s2
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    s_cbranch_execnz BB1_1
; GFX10-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX10-NEXT:    s_or_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    global_store_dword v[0:1], v0, off
; GFX10-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("agent") seq_cst
  store float %result, float addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_noret_f32(float addrspace(1)* %ptr) #0 {
; GFX900-LABEL: global_atomic_fadd_noret_f32:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX900-NEXT:    s_mov_b64 s[2:3], 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v1, s4
; GFX900-NEXT:  BB2_1: ; %atomicrmw.start
; GFX900-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX900-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX900-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_wbinvl1_vol
; GFX900-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX900-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX900-NEXT:    v_mov_b32_e32 v1, v0
; GFX900-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX900-NEXT:    s_cbranch_execnz BB2_1
; GFX900-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX900-NEXT:    s_endpgm
;
; GFX908-LABEL: global_atomic_fadd_noret_f32:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX908-NEXT:    v_mov_b32_e32 v0, 0
; GFX908-NEXT:    v_mov_b32_e32 v1, 4.0
; GFX908-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_add_f32 v0, v1, s[0:1]
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    buffer_wbinvl1_vol
; GFX908-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_atomic_fadd_noret_f32:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v0, 0
; GFX90A-NEXT:    v_mov_b32_e32 v1, 4.0
; GFX90A-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NEXT:    global_atomic_add_f32 v0, v1, s[0:1]
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    buffer_wbinvl1_vol
; GFX90A-NEXT:    s_endpgm
;
; GFX10-LABEL: global_atomic_fadd_noret_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    s_mov_b32 s2, 0
; GFX10-NEXT:  BB2_1: ; %atomicrmw.start
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX10-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_gl0_inv
; GFX10-NEXT:    buffer_gl1_inv
; GFX10-NEXT:    v_cmp_eq_u32_e32 vcc_lo, v0, v1
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    s_or_b32 s2, vcc_lo, s2
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    s_cbranch_execnz BB2_1
; GFX10-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX10-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("agent") seq_cst
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_noret_f32_ieee(float addrspace(1)* %ptr) #2 {
; GFX900-LABEL: global_atomic_fadd_noret_f32_ieee:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX900-NEXT:    s_mov_b64 s[2:3], 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v1, s4
; GFX900-NEXT:  BB3_1: ; %atomicrmw.start
; GFX900-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX900-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX900-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_wbinvl1_vol
; GFX900-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX900-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX900-NEXT:    v_mov_b32_e32 v1, v0
; GFX900-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX900-NEXT:    s_cbranch_execnz BB3_1
; GFX900-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX900-NEXT:    s_endpgm
;
; GFX908-LABEL: global_atomic_fadd_noret_f32_ieee:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX908-NEXT:    v_mov_b32_e32 v0, 0
; GFX908-NEXT:    v_mov_b32_e32 v1, 4.0
; GFX908-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_add_f32 v0, v1, s[0:1]
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    buffer_wbinvl1_vol
; GFX908-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_atomic_fadd_noret_f32_ieee:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v0, 0
; GFX90A-NEXT:    v_mov_b32_e32 v1, 4.0
; GFX90A-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NEXT:    global_atomic_add_f32 v0, v1, s[0:1]
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    buffer_wbinvl1_vol
; GFX90A-NEXT:    s_endpgm
;
; GFX10-LABEL: global_atomic_fadd_noret_f32_ieee:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    s_mov_b32 s2, 0
; GFX10-NEXT:  BB3_1: ; %atomicrmw.start
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX10-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_gl0_inv
; GFX10-NEXT:    buffer_gl1_inv
; GFX10-NEXT:    v_cmp_eq_u32_e32 vcc_lo, v0, v1
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    s_or_b32 s2, vcc_lo, s2
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    s_cbranch_execnz BB3_1
; GFX10-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX10-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("agent") seq_cst
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_ret_f32_agent(float addrspace(1)* %ptr) #0 {
; GFX900-LABEL: global_atomic_fadd_ret_f32_agent:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX900-NEXT:    s_mov_b64 s[2:3], 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v0, s4
; GFX900-NEXT:  BB4_1: ; %atomicrmw.start
; GFX900-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX900-NEXT:    v_mov_b32_e32 v1, v0
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX900-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX900-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_wbinvl1_vol
; GFX900-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX900-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX900-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX900-NEXT:    s_cbranch_execnz BB4_1
; GFX900-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX900-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX900-NEXT:    global_store_dword v[0:1], v0, off
; GFX900-NEXT:    s_endpgm
;
; GFX908-LABEL: global_atomic_fadd_ret_f32_agent:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX908-NEXT:    s_mov_b64 s[2:3], 0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    v_mov_b32_e32 v0, s4
; GFX908-NEXT:  BB4_1: ; %atomicrmw.start
; GFX908-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX908-NEXT:    v_mov_b32_e32 v1, v0
; GFX908-NEXT:    v_mov_b32_e32 v2, 0
; GFX908-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX908-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    buffer_wbinvl1_vol
; GFX908-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX908-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX908-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX908-NEXT:    s_cbranch_execnz BB4_1
; GFX908-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX908-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX908-NEXT:    global_store_dword v[0:1], v0, off
; GFX908-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_atomic_fadd_ret_f32_agent:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v0, 0
; GFX90A-NEXT:    v_mov_b32_e32 v1, 4.0
; GFX90A-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NEXT:    global_atomic_add_f32 v0, v0, v1, s[0:1] glc
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    buffer_wbinvl1_vol
; GFX90A-NEXT:    global_store_dword v[0:1], v0, off
; GFX90A-NEXT:    s_endpgm
;
; GFX10-LABEL: global_atomic_fadd_ret_f32_agent:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    s_mov_b32 s2, 0
; GFX10-NEXT:  BB4_1: ; %atomicrmw.start
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX10-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_gl0_inv
; GFX10-NEXT:    buffer_gl1_inv
; GFX10-NEXT:    v_cmp_eq_u32_e32 vcc_lo, v0, v1
; GFX10-NEXT:    s_or_b32 s2, vcc_lo, s2
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    s_cbranch_execnz BB4_1
; GFX10-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX10-NEXT:    s_or_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    global_store_dword v[0:1], v0, off
; GFX10-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("agent") seq_cst
  store float %result, float addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_ret_f32_system(float addrspace(1)* %ptr) #0 {
; GFX900-LABEL: global_atomic_fadd_ret_f32_system:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX900-NEXT:    s_mov_b64 s[2:3], 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v0, s4
; GFX900-NEXT:  BB5_1: ; %atomicrmw.start
; GFX900-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX900-NEXT:    v_mov_b32_e32 v1, v0
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_wbinvl1_vol
; GFX900-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX900-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX900-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX900-NEXT:    s_cbranch_execnz BB5_1
; GFX900-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX900-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX900-NEXT:    global_store_dword v[0:1], v0, off
; GFX900-NEXT:    s_endpgm
;
; GFX908-LABEL: global_atomic_fadd_ret_f32_system:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX908-NEXT:    s_mov_b64 s[2:3], 0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    v_mov_b32_e32 v0, s4
; GFX908-NEXT:  BB5_1: ; %atomicrmw.start
; GFX908-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX908-NEXT:    v_mov_b32_e32 v1, v0
; GFX908-NEXT:    v_mov_b32_e32 v2, 0
; GFX908-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    buffer_wbinvl1_vol
; GFX908-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX908-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX908-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX908-NEXT:    s_cbranch_execnz BB5_1
; GFX908-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX908-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX908-NEXT:    global_store_dword v[0:1], v0, off
; GFX908-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_atomic_fadd_ret_f32_system:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX90A-NEXT:    s_mov_b64 s[2:3], 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    v_mov_b32_e32 v0, s4
; GFX90A-NEXT:  BB5_1: ; %atomicrmw.start
; GFX90A-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX90A-NEXT:    v_mov_b32_e32 v1, v0
; GFX90A-NEXT:    v_mov_b32_e32 v2, 0
; GFX90A-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX90A-NEXT:    buffer_wbl2
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    buffer_invl2
; GFX90A-NEXT:    buffer_wbinvl1_vol
; GFX90A-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX90A-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX90A-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX90A-NEXT:    s_cbranch_execnz BB5_1
; GFX90A-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX90A-NEXT:    s_or_b64 exec, exec, s[2:3]
; GFX90A-NEXT:    global_store_dword v[0:1], v0, off
; GFX90A-NEXT:    s_endpgm
;
; GFX10-LABEL: global_atomic_fadd_ret_f32_system:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    s_mov_b32 s2, 0
; GFX10-NEXT:  BB5_1: ; %atomicrmw.start
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_gl0_inv
; GFX10-NEXT:    buffer_gl1_inv
; GFX10-NEXT:    v_cmp_eq_u32_e32 vcc_lo, v0, v1
; GFX10-NEXT:    s_or_b32 s2, vcc_lo, s2
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    s_cbranch_execnz BB5_1
; GFX10-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX10-NEXT:    s_or_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    global_store_dword v[0:1], v0, off
; GFX10-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("one-as") seq_cst
  store float %result, float addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_ret_f32_wrong_subtarget(float addrspace(1)* %ptr) #1 {
; GCN-LABEL: global_atomic_fadd_ret_f32_wrong_subtarget:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_mov_b64 s[2:3], 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_load_dword s4, s[0:1], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:  BB6_1: ; %atomicrmw.start
; GCN-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_mov_b32_e32 v1, v0
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_wbinvl1_vol
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GCN-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GCN-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GCN-NEXT:    s_cbranch_execnz BB6_1
; GCN-NEXT:  ; %bb.2: ; %atomicrmw.end
; GCN-NEXT:    s_or_b64 exec, exec, s[2:3]
; GCN-NEXT:    global_store_dword v[0:1], v0, off
; GCN-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("agent") seq_cst
  store float %result, float addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_noret_f32_wrong_subtarget(float addrspace(1)* %ptr) #1 {
; GCN-LABEL: global_atomic_fadd_noret_f32_wrong_subtarget:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    v_mov_b32_e32 v1, 4.0
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    global_atomic_add_f32 v0, v1, s[0:1]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_wbinvl1_vol
; GCN-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("agent") seq_cst
  ret void
}

define amdgpu_kernel void @global_atomic_fadd_noret_f32_safe(float addrspace(1)* %ptr) {
; GFX900-LABEL: global_atomic_fadd_noret_f32_safe:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX900-NEXT:    s_mov_b64 s[2:3], 0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX900-NEXT:    s_waitcnt lgkmcnt(0)
; GFX900-NEXT:    v_mov_b32_e32 v1, s4
; GFX900-NEXT:  BB8_1: ; %atomicrmw.start
; GFX900-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX900-NEXT:    v_mov_b32_e32 v2, 0
; GFX900-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX900-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX900-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX900-NEXT:    s_waitcnt vmcnt(0)
; GFX900-NEXT:    buffer_wbinvl1_vol
; GFX900-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX900-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX900-NEXT:    v_mov_b32_e32 v1, v0
; GFX900-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX900-NEXT:    s_cbranch_execnz BB8_1
; GFX900-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX900-NEXT:    s_endpgm
;
; GFX908-LABEL: global_atomic_fadd_noret_f32_safe:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX908-NEXT:    s_mov_b64 s[2:3], 0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX908-NEXT:    s_waitcnt lgkmcnt(0)
; GFX908-NEXT:    v_mov_b32_e32 v1, s4
; GFX908-NEXT:  BB8_1: ; %atomicrmw.start
; GFX908-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX908-NEXT:    v_mov_b32_e32 v2, 0
; GFX908-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX908-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX908-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX908-NEXT:    s_waitcnt vmcnt(0)
; GFX908-NEXT:    buffer_wbinvl1_vol
; GFX908-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX908-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX908-NEXT:    v_mov_b32_e32 v1, v0
; GFX908-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX908-NEXT:    s_cbranch_execnz BB8_1
; GFX908-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX908-NEXT:    s_endpgm
;
; GFX90A-LABEL: global_atomic_fadd_noret_f32_safe:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX90A-NEXT:    s_mov_b64 s[2:3], 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_load_dword s4, s[0:1], 0x0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    v_mov_b32_e32 v1, s4
; GFX90A-NEXT:  BB8_1: ; %atomicrmw.start
; GFX90A-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX90A-NEXT:    v_mov_b32_e32 v2, 0
; GFX90A-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX90A-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX90A-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-NEXT:    buffer_wbinvl1_vol
; GFX90A-NEXT:    v_cmp_eq_u32_e32 vcc, v0, v1
; GFX90A-NEXT:    s_or_b64 s[2:3], vcc, s[2:3]
; GFX90A-NEXT:    v_mov_b32_e32 v1, v0
; GFX90A-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; GFX90A-NEXT:    s_cbranch_execnz BB8_1
; GFX90A-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX90A-NEXT:    s_endpgm
;
; GFX10-LABEL: global_atomic_fadd_noret_f32_safe:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    s_mov_b32 s2, 0
; GFX10-NEXT:  BB8_1: ; %atomicrmw.start
; GFX10-NEXT:    ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    v_add_f32_e32 v0, 4.0, v1
; GFX10-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_atomic_cmpswap v0, v2, v[0:1], s[0:1] glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_gl0_inv
; GFX10-NEXT:    buffer_gl1_inv
; GFX10-NEXT:    v_cmp_eq_u32_e32 vcc_lo, v0, v1
; GFX10-NEXT:    v_mov_b32_e32 v1, v0
; GFX10-NEXT:    s_or_b32 s2, vcc_lo, s2
; GFX10-NEXT:    s_andn2_b32 exec_lo, exec_lo, s2
; GFX10-NEXT:    s_cbranch_execnz BB8_1
; GFX10-NEXT:  ; %bb.2: ; %atomicrmw.end
; GFX10-NEXT:    s_endpgm
  %result = atomicrmw fadd float addrspace(1)* %ptr, float 4.0 syncscope("agent") seq_cst
  ret void
}

attributes #0 = { "denormal-fp-math-f32"="preserve-sign,preserve-sign" "amdgpu-unsafe-fp-atomics"="true" }
attributes #1 = { "denormal-fp-math-f32"="preserve-sign,preserve-sign" "target-cpu"="gfx803" "target-features"="+atomic-fadd-insts" "amdgpu-unsafe-fp-atomics"="true" }
attributes #2 = { "amdgpu-unsafe-fp-atomics"="true" }
