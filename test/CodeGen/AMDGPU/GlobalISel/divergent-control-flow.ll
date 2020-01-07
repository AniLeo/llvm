; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -amdgpu-global-isel-risky-select -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck %s

; Make sure the branch targets are correct after lowering llvm.amdgcn.if

define i32 @divergent_if_swap_brtarget_order0(i32 %value) {
; CHECK-LABEL: divergent_if_swap_brtarget_order0:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; CHECK-NEXT:    ; implicit-def: $vgpr0
; CHECK-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; CHECK-NEXT:    s_cbranch_execz BB0_2
; CHECK-NEXT:  ; %bb.1: ; %if.true
; CHECK-NEXT:    global_load_dword v0, v[0:1], off
; CHECK-NEXT:  BB0_2: ; %endif
; CHECK-NEXT:    s_or_b64 exec, exec, s[4:5]
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
entry:
  %c = icmp ne i32 %value, 0
  br i1 %c, label %if.true, label %endif

if.true:
  %val = load volatile i32, i32 addrspace(1)* undef
  br label %endif

endif:
  %v = phi i32 [ %val, %if.true ], [ undef, %entry ]
  ret i32 %v
}

define i32 @divergent_if_swap_brtarget_order1(i32 %value) {
; CHECK-LABEL: divergent_if_swap_brtarget_order1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; CHECK-NEXT:    ; implicit-def: $vgpr0
; CHECK-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; CHECK-NEXT:    s_cbranch_execz BB1_2
; CHECK-NEXT:  ; %bb.1: ; %if.true
; CHECK-NEXT:    global_load_dword v0, v[0:1], off
; CHECK-NEXT:  BB1_2: ; %endif
; CHECK-NEXT:    s_or_b64 exec, exec, s[4:5]
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
entry:
  %c = icmp ne i32 %value, 0
  br i1 %c, label %if.true, label %endif

endif:
  %v = phi i32 [ %val, %if.true ], [ undef, %entry ]
  ret i32 %v

if.true:
  %val = load volatile i32, i32 addrspace(1)* undef
  br label %endif
}

; Make sure and 1 is inserted on llvm.amdgcn.if
define i32 @divergent_if_nonboolean_condition0(i32 %value) {
; CHECK-LABEL: divergent_if_nonboolean_condition0:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_and_b32_e32 v0, 1, v0
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; CHECK-NEXT:    ; implicit-def: $vgpr0
; CHECK-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; CHECK-NEXT:    s_cbranch_execz BB2_2
; CHECK-NEXT:  ; %bb.1: ; %if.true
; CHECK-NEXT:    global_load_dword v0, v[0:1], off
; CHECK-NEXT:  BB2_2: ; %endif
; CHECK-NEXT:    s_or_b64 exec, exec, s[4:5]
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
entry:
  %c = trunc i32 %value to i1
  br i1 %c, label %if.true, label %endif

if.true:
  %val = load volatile i32, i32 addrspace(1)* undef
  br label %endif

endif:
  %v = phi i32 [ %val, %if.true ], [ undef, %entry ]
  ret i32 %v
}

; Make sure and 1 is inserted on llvm.amdgcn.if
define i32 @divergent_if_nonboolean_condition1(i32 addrspace(1)* %ptr) {
; CHECK-LABEL: divergent_if_nonboolean_condition1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    global_load_dword v0, v[0:1], off
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    v_and_b32_e32 v0, 1, v0
; CHECK-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; CHECK-NEXT:    ; implicit-def: $vgpr0
; CHECK-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; CHECK-NEXT:    s_cbranch_execz BB3_2
; CHECK-NEXT:  ; %bb.1: ; %if.true
; CHECK-NEXT:    global_load_dword v0, v[0:1], off
; CHECK-NEXT:  BB3_2: ; %endif
; CHECK-NEXT:    s_or_b64 exec, exec, s[4:5]
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
entry:
  %value = load i32, i32 addrspace(1)* %ptr
  %c = trunc i32 %value to i1
  br i1 %c, label %if.true, label %endif

if.true:
  %val = load volatile i32, i32 addrspace(1)* undef
  br label %endif

endif:
  %v = phi i32 [ %val, %if.true ], [ undef, %entry ]
  ret i32 %v
}

@external_constant = external addrspace(4) constant i32, align 4
@const.ptr = external addrspace(4) constant float*, align 4

; Make sure this case compiles. G_ICMP was mis-mapped due to having
; the result register class constrained by llvm.amdgcn.if lowering.
define void @constrained_if_register_class() {
; CHECK-LABEL: constrained_if_register_class:
; CHECK:       ; %bb.0: ; %bb
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    s_getpc_b64 s[4:5]
; CHECK-NEXT:    s_add_u32 s4, s4, external_constant@gotpcrel32@lo+4
; CHECK-NEXT:    s_addc_u32 s5, s5, external_constant@gotpcrel32@hi+4
; CHECK-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    s_load_dword s4, s[4:5], 0x0
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    s_cmp_lg_u32 s4, 0
; CHECK-NEXT:    s_cselect_b32 s4, 1, 0
; CHECK-NEXT:    s_xor_b32 s4, s4, 1
; CHECK-NEXT:    s_and_b32 s4, s4, 1
; CHECK-NEXT:    s_cmp_lg_u32 s4, 0
; CHECK-NEXT:    s_cbranch_scc0 BB4_6
; CHECK-NEXT:  ; %bb.1: ; %bb2
; CHECK-NEXT:    s_getpc_b64 s[4:5]
; CHECK-NEXT:    s_add_u32 s4, s4, const.ptr@gotpcrel32@lo+4
; CHECK-NEXT:    s_addc_u32 s5, s5, const.ptr@gotpcrel32@hi+4
; CHECK-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; CHECK-NEXT:    v_cmp_ne_u32_e64 s[6:7], 0, 1
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    v_mov_b32_e32 v0, s4
; CHECK-NEXT:    v_mov_b32_e32 v1, s5
; CHECK-NEXT:    flat_load_dword v0, v[0:1]
; CHECK-NEXT:    s_mov_b32 s4, -1
; CHECK-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_cmp_gt_f32_e32 vcc, 1.0, v0
; CHECK-NEXT:    s_xor_b64 s[8:9], vcc, s[6:7]
; CHECK-NEXT:    s_and_saveexec_b64 s[6:7], s[8:9]
; CHECK-NEXT:  ; %bb.2: ; %bb7
; CHECK-NEXT:    s_mov_b32 s4, 0
; CHECK-NEXT:  ; %bb.3: ; %bb8
; CHECK-NEXT:    s_or_b64 exec, exec, s[6:7]
; CHECK-NEXT:    v_cmp_eq_u32_e64 s[6:7], s4, 0
; CHECK-NEXT:    s_and_saveexec_b64 s[4:5], s[6:7]
; CHECK-NEXT:    s_cbranch_execz BB4_5
; CHECK-NEXT:  ; %bb.4: ; %bb11
; CHECK-NEXT:    v_mov_b32_e32 v0, 4.0
; CHECK-NEXT:    buffer_store_dword v0, v0, s[0:3], 0 offen
; CHECK-NEXT:  BB4_5: ; %Flow
; CHECK-NEXT:    s_or_b64 exec, exec, s[4:5]
; CHECK-NEXT:  BB4_6: ; %bb12
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
bb:
  %tmp = load i32, i32 addrspace(4)* @external_constant
  %ptr = load float*, float* addrspace(4)* @const.ptr
  %tmp1 = icmp ne i32 %tmp, 0
  br i1 %tmp1, label %bb12, label %bb2

bb2:
  %tmp4 = load float, float* %ptr, align 4
  %tmp5 = fcmp olt float %tmp4, 1.0
  %tmp6 = or i1 %tmp5, false
  br i1 %tmp6, label %bb8, label %bb7

bb7:
  br label %bb8

bb8:
  %tmp9 = phi i32 [ 0, %bb7 ], [ -1, %bb2 ]
  %tmp10 = icmp eq i32 %tmp9, 0
  br i1 %tmp10, label %bb11, label %bb12

bb11:
  store float 4.0, float addrspace(5)* undef, align 4
  br label %bb12

bb12:
  ret void
}

define amdgpu_kernel void @break_loop(i32 %arg) {
; CHECK-LABEL: break_loop:
; CHECK:       ; %bb.0: ; %bb
; CHECK-NEXT:    s_load_dword s2, s[4:5], 0x0
; CHECK-NEXT:    s_mov_b64 s[0:1], 0
; CHECK-NEXT:    ; implicit-def: $vgpr1
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    v_subrev_u32_e32 v0, s2, v0
; CHECK-NEXT:  BB5_1: ; %bb1
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    v_add_u32_e32 v1, 1, v1
; CHECK-NEXT:    v_cmp_le_i32_e32 vcc, 0, v1
; CHECK-NEXT:    v_cmp_ne_u32_e64 s[2:3], 0, 1
; CHECK-NEXT:    s_cbranch_vccnz BB5_3
; CHECK-NEXT:  ; %bb.2: ; %bb4
; CHECK-NEXT:    ; in Loop: Header=BB5_1 Depth=1
; CHECK-NEXT:    global_load_dword v2, v[0:1], off
; CHECK-NEXT:    v_cmp_ne_u32_e64 s[2:3], 0, 1
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    v_cmp_lt_i32_e32 vcc, v0, v2
; CHECK-NEXT:    s_xor_b64 s[2:3], vcc, s[2:3]
; CHECK-NEXT:  BB5_3: ; %Flow
; CHECK-NEXT:    ; in Loop: Header=BB5_1 Depth=1
; CHECK-NEXT:    s_and_b64 s[2:3], exec, s[2:3]
; CHECK-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; CHECK-NEXT:    s_andn2_b64 exec, exec, s[0:1]
; CHECK-NEXT:    s_cbranch_execnz BB5_1
; CHECK-NEXT:  ; %bb.4: ; %bb9
; CHECK-NEXT:    s_endpgm
bb:
  %id = call i32 @llvm.amdgcn.workitem.id.x()
  %tmp = sub i32 %id, %arg
  br label %bb1

bb1:
  %lsr.iv = phi i32 [ undef, %bb ], [ %lsr.iv.next, %bb4 ]
  %lsr.iv.next = add i32 %lsr.iv, 1
  %cmp0 = icmp slt i32 %lsr.iv.next, 0
  br i1 %cmp0, label %bb4, label %bb9

bb4:
  %load = load volatile i32, i32 addrspace(1)* undef, align 4
  %cmp1 = icmp slt i32 %tmp, %load
  br i1 %cmp1, label %bb1, label %bb9

bb9:
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x()
