; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s

; Test the localizer did something and we don't materialize all
; constants in SGPRs in the entry block.

define amdgpu_kernel void @localize_constants(i1 %cond) {
; GFX9-LABEL: localize_constants:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dword s1, s[4:5], 0x0
; GFX9-NEXT:    s_mov_b32 s0, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_xor_b32 s1, s1, -1
; GFX9-NEXT:    s_and_b32 s1, s1, 1
; GFX9-NEXT:    s_cmp_lg_u32 s1, 0
; GFX9-NEXT:    s_cbranch_scc0 .LBB0_2
; GFX9-NEXT:  ; %bb.1: ; %bb1
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x5be6
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x1c7
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x3e8
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x1c8
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x3e7
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x7b
; GFX9-NEXT:    s_mov_b32 s0, 0
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:  .LBB0_2: ; %Flow
; GFX9-NEXT:    s_xor_b32 s0, s0, -1
; GFX9-NEXT:    s_and_b32 s0, s0, 1
; GFX9-NEXT:    s_cmp_lg_u32 s0, 0
; GFX9-NEXT:    s_cbranch_scc1 .LBB0_4
; GFX9-NEXT:  ; %bb.3: ; %bb0
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x7b
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x1c8
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x3e7
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x3e8
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x1c7
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x5be6
; GFX9-NEXT:    global_store_dword v[0:1], v0, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:  .LBB0_4: ; %bb2
; GFX9-NEXT:    s_endpgm
entry:
  br i1 %cond, label %bb0, label %bb1

bb0:
  store volatile i32 123, i32 addrspace(1)* undef
  store volatile i32 456, i32 addrspace(1)* undef
  store volatile i32 999, i32 addrspace(1)* undef
  store volatile i32 1000, i32 addrspace(1)* undef
  store volatile i32 455, i32 addrspace(1)* undef
  store volatile i32 23526, i32 addrspace(1)* undef
  br label %bb2

bb1:
  store volatile i32 23526, i32 addrspace(1)* undef
  store volatile i32 455, i32 addrspace(1)* undef
  store volatile i32 1000, i32 addrspace(1)* undef
  store volatile i32 456, i32 addrspace(1)* undef
  store volatile i32 999, i32 addrspace(1)* undef
  store volatile i32 123, i32 addrspace(1)* undef
  br label %bb2

bb2:
  ret void
}

; FIXME: These aren't localized because thesee were legalized before
; the localizer, and are no longer G_GLOBAL_VALUE.
@gv0 = addrspace(1) global i32 undef, align 4
@gv1 = addrspace(1) global i32 undef, align 4
@gv2 = addrspace(1) global i32 undef, align 4
@gv3 = addrspace(1) global i32 undef, align 4

define amdgpu_kernel void @localize_globals(i1 %cond) {
; GFX9-LABEL: localize_globals:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dword s1, s[4:5], 0x0
; GFX9-NEXT:    s_mov_b32 s0, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_xor_b32 s1, s1, -1
; GFX9-NEXT:    s_and_b32 s1, s1, 1
; GFX9-NEXT:    s_cmp_lg_u32 s1, 0
; GFX9-NEXT:    s_cbranch_scc0 .LBB1_2
; GFX9-NEXT:  ; %bb.1: ; %bb1
; GFX9-NEXT:    s_getpc_b64 s[0:1]
; GFX9-NEXT:    s_add_u32 s0, s0, gv2@gotpcrel32@lo+4
; GFX9-NEXT:    s_addc_u32 s1, s1, gv2@gotpcrel32@hi+12
; GFX9-NEXT:    s_getpc_b64 s[2:3]
; GFX9-NEXT:    s_add_u32 s2, s2, gv3@gotpcrel32@lo+4
; GFX9-NEXT:    s_addc_u32 s3, s3, gv3@gotpcrel32@hi+12
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x0
; GFX9-NEXT:    s_load_dwordx2 s[6:7], s[2:3], 0x0
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, 1
; GFX9-NEXT:    s_mov_b32 s0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_store_dword v0, v0, s[4:5]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    global_store_dword v0, v1, s[6:7]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:  .LBB1_2: ; %Flow
; GFX9-NEXT:    s_xor_b32 s0, s0, -1
; GFX9-NEXT:    s_and_b32 s0, s0, 1
; GFX9-NEXT:    s_cmp_lg_u32 s0, 0
; GFX9-NEXT:    s_cbranch_scc1 .LBB1_4
; GFX9-NEXT:  ; %bb.3: ; %bb0
; GFX9-NEXT:    s_getpc_b64 s[0:1]
; GFX9-NEXT:    s_add_u32 s0, s0, gv0@gotpcrel32@lo+4
; GFX9-NEXT:    s_addc_u32 s1, s1, gv0@gotpcrel32@hi+12
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX9-NEXT:    s_getpc_b64 s[2:3]
; GFX9-NEXT:    s_add_u32 s2, s2, gv1@gotpcrel32@lo+4
; GFX9-NEXT:    s_addc_u32 s3, s3, gv1@gotpcrel32@hi+12
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[2:3], 0x0
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, 1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_store_dword v0, v0, s[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:  .LBB1_4: ; %bb2
; GFX9-NEXT:    s_endpgm
entry:
  br i1 %cond, label %bb0, label %bb1

bb0:
  store volatile i32 0, i32 addrspace(1)* @gv0
  store volatile i32 1, i32 addrspace(1)* @gv1
  br label %bb2

bb1:
  store volatile i32 0, i32 addrspace(1)* @gv2
  store volatile i32 1, i32 addrspace(1)* @gv3
  br label %bb2

bb2:
  ret void
}

@static.gv0 = internal addrspace(1) global i32 undef, align 4
@static.gv1 = internal addrspace(1) global i32 undef, align 4
@static.gv2 = internal addrspace(1) global i32 undef, align 4
@static.gv3 = internal addrspace(1) global i32 undef, align 4

define void @localize_internal_globals(i1 %cond) {
; GFX9-LABEL: localize_internal_globals:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX9-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX9-NEXT:    s_xor_b64 s[4:5], vcc, -1
; GFX9-NEXT:    s_and_saveexec_b64 s[6:7], s[4:5]
; GFX9-NEXT:    s_xor_b64 s[4:5], exec, s[6:7]
; GFX9-NEXT:    s_cbranch_execz .LBB2_2
; GFX9-NEXT:  ; %bb.1: ; %bb1
; GFX9-NEXT:    s_getpc_b64 s[6:7]
; GFX9-NEXT:    s_add_u32 s6, s6, static.gv2@rel32@lo+4
; GFX9-NEXT:    s_addc_u32 s7, s7, static.gv2@rel32@hi+12
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    global_store_dword v0, v0, s[6:7]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_getpc_b64 s[6:7]
; GFX9-NEXT:    s_add_u32 s6, s6, static.gv3@rel32@lo+4
; GFX9-NEXT:    s_addc_u32 s7, s7, static.gv3@rel32@hi+12
; GFX9-NEXT:    v_mov_b32_e32 v1, 1
; GFX9-NEXT:    global_store_dword v0, v1, s[6:7]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:  .LBB2_2: ; %Flow
; GFX9-NEXT:    s_or_saveexec_b64 s[4:5], s[4:5]
; GFX9-NEXT:    s_xor_b64 exec, exec, s[4:5]
; GFX9-NEXT:    s_cbranch_execz .LBB2_4
; GFX9-NEXT:  ; %bb.3: ; %bb0
; GFX9-NEXT:    s_getpc_b64 s[6:7]
; GFX9-NEXT:    s_add_u32 s6, s6, static.gv0@rel32@lo+4
; GFX9-NEXT:    s_addc_u32 s7, s7, static.gv0@rel32@hi+12
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    global_store_dword v0, v0, s[6:7]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_getpc_b64 s[6:7]
; GFX9-NEXT:    s_add_u32 s6, s6, static.gv1@rel32@lo+4
; GFX9-NEXT:    s_addc_u32 s7, s7, static.gv1@rel32@hi+12
; GFX9-NEXT:    v_mov_b32_e32 v1, 1
; GFX9-NEXT:    global_store_dword v0, v1, s[6:7]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:  .LBB2_4: ; %bb2
; GFX9-NEXT:    s_or_b64 exec, exec, s[4:5]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
entry:
  br i1 %cond, label %bb0, label %bb1

bb0:
  store volatile i32 0, i32 addrspace(1)* @static.gv0
  store volatile i32 1, i32 addrspace(1)* @static.gv1
  br label %bb2

bb1:
  store volatile i32 0, i32 addrspace(1)* @static.gv2
  store volatile i32 1, i32 addrspace(1)* @static.gv3
  br label %bb2

bb2:
  ret void
}
