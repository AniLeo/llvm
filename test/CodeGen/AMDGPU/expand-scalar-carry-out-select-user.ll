; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx704 < %s | FileCheck -check-prefix=GFX7 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1100 < %s | FileCheck -check-prefix=GFX11 %s

define i32 @s_add_co_select_user() {
; GFX7-LABEL: s_add_co_select_user:
; GFX7:       ; %bb.0: ; %bb
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    s_load_dword s6, s[4:5], 0x0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_add_i32_e64 v0, s[4:5], s6, s6
; GFX7-NEXT:    s_or_b32 s4, s4, s5
; GFX7-NEXT:    s_cmp_lg_u32 s4, 0
; GFX7-NEXT:    s_addc_u32 s4, s6, 0
; GFX7-NEXT:    v_mov_b32_e32 v1, s4
; GFX7-NEXT:    s_cselect_b64 vcc, -1, 0
; GFX7-NEXT:    s_cmp_gt_u32 s6, 31
; GFX7-NEXT:    v_cndmask_b32_e32 v1, 0, v1, vcc
; GFX7-NEXT:    s_cselect_b64 vcc, -1, 0
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v1, v0, vcc
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: s_add_co_select_user:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b64 s[4:5], 0
; GFX9-NEXT:    s_load_dword s6, s[4:5], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_add_co_u32_e64 v0, s[4:5], s6, s6
; GFX9-NEXT:    s_cmp_lg_u64 s[4:5], 0
; GFX9-NEXT:    s_addc_u32 s4, s6, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, s4
; GFX9-NEXT:    s_cselect_b64 vcc, -1, 0
; GFX9-NEXT:    s_cmp_gt_u32 s6, 31
; GFX9-NEXT:    v_cndmask_b32_e32 v1, 0, v1, vcc
; GFX9-NEXT:    s_cselect_b64 vcc, -1, 0
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v1, v0, vcc
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: s_add_co_select_user:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_mov_b64 s[4:5], 0
; GFX10-NEXT:    s_load_dword s4, s[4:5], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_add_co_u32 v0, s5, s4, s4
; GFX10-NEXT:    s_cmpk_lg_u32 s5, 0x0
; GFX10-NEXT:    s_addc_u32 s5, s4, 0
; GFX10-NEXT:    s_cselect_b32 s6, -1, 0
; GFX10-NEXT:    s_cmp_gt_u32 s4, 31
; GFX10-NEXT:    v_cndmask_b32_e64 v1, 0, s5, s6
; GFX10-NEXT:    s_cselect_b32 vcc_lo, -1, 0
; GFX10-NEXT:    v_cndmask_b32_e32 v0, v1, v0, vcc_lo
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX11-LABEL: s_add_co_select_user:
; GFX11:       ; %bb.0: ; %bb
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    s_mov_b64 s[0:1], 0
; GFX11-NEXT:    s_load_b32 s0, s[0:1], 0x0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    v_add_co_u32 v0, s1, s0, s0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-NEXT:    s_cmpk_lg_u32 s1, 0x0
; GFX11-NEXT:    s_addc_u32 s1, s0, 0
; GFX11-NEXT:    s_cselect_b32 s2, -1, 0
; GFX11-NEXT:    s_cmp_gt_u32 s0, 31
; GFX11-NEXT:    v_cndmask_b32_e64 v1, 0, s1, s2
; GFX11-NEXT:    s_cselect_b32 vcc_lo, -1, 0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-NEXT:    v_cndmask_b32_e32 v0, v1, v0, vcc_lo
; GFX11-NEXT:    s_setpc_b64 s[30:31]
bb:
  %i = load volatile i32, i32 addrspace(4)* null, align 8
  %i1 = add i32 %i, %i
  %i2 = icmp ult i32 %i1, %i
  %i3 = zext i1 %i2 to i32
  %i4 = add nuw nsw i32 %i3, 0
  %i5 = add i32 %i4, %i
  %i6 = icmp ult i32 %i5, %i4
  %i7 = select i1 %i6, i32 %i5, i32 0
  %i8 = icmp ugt i32 %i, 31
  %i9 = select i1 %i8, i32 %i1, i32 %i7
  ret i32 %i9
}

define amdgpu_kernel void @s_add_co_br_user(i32 %i) {
; GFX7-LABEL: s_add_co_br_user:
; GFX7:       ; %bb.0: ; %bb
; GFX7-NEXT:    s_load_dword s2, s[4:5], 0x0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_add_i32 s0, s2, s2
; GFX7-NEXT:    s_cmp_lt_u32 s0, s2
; GFX7-NEXT:    s_cselect_b64 s[0:1], -1, 0
; GFX7-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[0:1]
; GFX7-NEXT:    s_or_b32 s0, s0, s1
; GFX7-NEXT:    s_cmp_lg_u32 s0, 0
; GFX7-NEXT:    s_addc_u32 s0, s2, 0
; GFX7-NEXT:    v_cmp_ge_u32_e32 vcc, s0, v0
; GFX7-NEXT:    s_cbranch_vccnz .LBB1_2
; GFX7-NEXT:  ; %bb.1: ; %bb0
; GFX7-NEXT:    v_mov_b32_e32 v0, 0
; GFX7-NEXT:    v_mov_b32_e32 v1, 0
; GFX7-NEXT:    v_mov_b32_e32 v2, 9
; GFX7-NEXT:    flat_store_dword v[0:1], v2
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:  .LBB1_2: ; %bb1
; GFX7-NEXT:    v_mov_b32_e32 v0, 0
; GFX7-NEXT:    v_mov_b32_e32 v1, 0
; GFX7-NEXT:    v_mov_b32_e32 v2, 10
; GFX7-NEXT:    flat_store_dword v[0:1], v2
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_endpgm
;
; GFX9-LABEL: s_add_co_br_user:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_load_dword s2, s[4:5], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_add_i32 s0, s2, s2
; GFX9-NEXT:    s_cmp_lt_u32 s0, s2
; GFX9-NEXT:    s_cselect_b64 s[0:1], -1, 0
; GFX9-NEXT:    s_cmp_lg_u64 s[0:1], 0
; GFX9-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[0:1]
; GFX9-NEXT:    s_addc_u32 s0, s2, 0
; GFX9-NEXT:    v_cmp_ge_u32_e32 vcc, s0, v0
; GFX9-NEXT:    s_cbranch_vccnz .LBB1_2
; GFX9-NEXT:  ; %bb.1: ; %bb0
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    v_mov_b32_e32 v2, 9
; GFX9-NEXT:    global_store_dword v[0:1], v2, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:  .LBB1_2: ; %bb1
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    v_mov_b32_e32 v2, 10
; GFX9-NEXT:    global_store_dword v[0:1], v2, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: s_add_co_br_user:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_load_dword s0, s[4:5], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_add_i32 s1, s0, s0
; GFX10-NEXT:    s_cmp_lt_u32 s1, s0
; GFX10-NEXT:    s_cselect_b32 s1, -1, 0
; GFX10-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s1
; GFX10-NEXT:    s_cmpk_lg_u32 s1, 0x0
; GFX10-NEXT:    s_addc_u32 s0, s0, 0
; GFX10-NEXT:    v_cmp_ge_u32_e32 vcc_lo, s0, v0
; GFX10-NEXT:    s_cbranch_vccnz .LBB1_2
; GFX10-NEXT:  ; %bb.1: ; %bb0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    v_mov_b32_e32 v2, 9
; GFX10-NEXT:    global_store_dword v[0:1], v2, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:  .LBB1_2: ; %bb1
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    v_mov_b32_e32 v2, 10
; GFX10-NEXT:    global_store_dword v[0:1], v2, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: s_add_co_br_user:
; GFX11:       ; %bb.0: ; %bb
; GFX11-NEXT:    s_load_b32 s0, s[0:1], 0x0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_add_i32 s1, s0, s0
; GFX11-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
; GFX11-NEXT:    s_cmp_lt_u32 s1, s0
; GFX11-NEXT:    s_cselect_b32 s1, -1, 0
; GFX11-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s1
; GFX11-NEXT:    s_cmpk_lg_u32 s1, 0x0
; GFX11-NEXT:    s_addc_u32 s0, s0, 0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instid1(SALU_CYCLE_1)
; GFX11-NEXT:    v_cmp_ge_u32_e32 vcc_lo, s0, v0
; GFX11-NEXT:    s_cbranch_vccnz .LBB1_2
; GFX11-NEXT:  ; %bb.1: ; %bb0
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, 9
; GFX11-NEXT:    global_store_b32 v[0:1], v2, off dlc
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:  .LBB1_2: ; %bb1
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, 10
; GFX11-NEXT:    global_store_b32 v[0:1], v2, off dlc
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
bb:
  %i1 = add i32 %i, %i
  %i2 = icmp ult i32 %i1, %i
  %i3 = zext i1 %i2 to i32
  %i4 = add nuw nsw i32 %i3, 0
  %i5 = add i32 %i4, %i
  %i6 = icmp ult i32 %i5, %i4
  %i7 = select i1 %i6, i32 %i5, i32 0
  br i1 %i6, label %bb0, label %bb1

bb0:
  store volatile i32 9, i32 addrspace(1)* null
  br label %bb1

bb1:
  store volatile i32 10, i32 addrspace(1)* null
  ret void
}
