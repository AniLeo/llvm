; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -amdgpu-fixed-function-abi -mtriple=amdgcn-amd-amdhsa --amdhsa-code-object-version=2 -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

@gv.fptr0 = external hidden unnamed_addr addrspace(4) constant void()*, align 4
@gv.fptr1 = external hidden unnamed_addr addrspace(4) constant void(i32)*, align 4

define amdgpu_kernel void @test_indirect_call_sgpr_ptr() {
; GCN-LABEL: test_indirect_call_sgpr_ptr:
; GCN:         .amd_kernel_code_t
; GCN-NEXT:     amd_code_version_major = 1
; GCN-NEXT:     amd_code_version_minor = 2
; GCN-NEXT:     amd_machine_kind = 1
; GCN-NEXT:     amd_machine_version_major = 7
; GCN-NEXT:     amd_machine_version_minor = 0
; GCN-NEXT:     amd_machine_version_stepping = 0
; GCN-NEXT:     kernel_code_entry_byte_offset = 256
; GCN-NEXT:     kernel_code_prefetch_byte_size = 0
; GCN-NEXT:     granulated_workitem_vgpr_count = 15
; GCN-NEXT:     granulated_wavefront_sgpr_count = 12
; GCN-NEXT:     priority = 0
; GCN-NEXT:     float_mode = 240
; GCN-NEXT:     priv = 0
; GCN-NEXT:     enable_dx10_clamp = 1
; GCN-NEXT:     debug_mode = 0
; GCN-NEXT:     enable_ieee_mode = 1
; GCN-NEXT:     enable_wgp_mode = 0
; GCN-NEXT:     enable_mem_ordered = 0
; GCN-NEXT:     enable_fwd_progress = 0
; GCN-NEXT:     enable_sgpr_private_segment_wave_byte_offset = 1
; GCN-NEXT:     user_sgpr_count = 14
; GCN-NEXT:     enable_trap_handler = 0
; GCN-NEXT:     enable_sgpr_workgroup_id_x = 1
; GCN-NEXT:     enable_sgpr_workgroup_id_y = 1
; GCN-NEXT:     enable_sgpr_workgroup_id_z = 1
; GCN-NEXT:     enable_sgpr_workgroup_info = 0
; GCN-NEXT:     enable_vgpr_workitem_id = 2
; GCN-NEXT:     enable_exception_msb = 0
; GCN-NEXT:     granulated_lds_size = 0
; GCN-NEXT:     enable_exception = 0
; GCN-NEXT:     enable_sgpr_private_segment_buffer = 1
; GCN-NEXT:     enable_sgpr_dispatch_ptr = 1
; GCN-NEXT:     enable_sgpr_queue_ptr = 1
; GCN-NEXT:     enable_sgpr_kernarg_segment_ptr = 1
; GCN-NEXT:     enable_sgpr_dispatch_id = 1
; GCN-NEXT:     enable_sgpr_flat_scratch_init = 1
; GCN-NEXT:     enable_sgpr_private_segment_size = 0
; GCN-NEXT:     enable_sgpr_grid_workgroup_count_x = 0
; GCN-NEXT:     enable_sgpr_grid_workgroup_count_y = 0
; GCN-NEXT:     enable_sgpr_grid_workgroup_count_z = 0
; GCN-NEXT:     enable_wavefront_size32 = 0
; GCN-NEXT:     enable_ordered_append_gds = 0
; GCN-NEXT:     private_element_size = 1
; GCN-NEXT:     is_ptr64 = 1
; GCN-NEXT:     is_dynamic_callstack = 1
; GCN-NEXT:     is_debug_enabled = 0
; GCN-NEXT:     is_xnack_enabled = 0
; GCN-NEXT:     workitem_private_segment_byte_size = 16384
; GCN-NEXT:     workgroup_group_segment_byte_size = 0
; GCN-NEXT:     gds_segment_byte_size = 0
; GCN-NEXT:     kernarg_segment_byte_size = 0
; GCN-NEXT:     workgroup_fbarrier_count = 0
; GCN-NEXT:     wavefront_sgpr_count = 102
; GCN-NEXT:     workitem_vgpr_count = 64
; GCN-NEXT:     reserved_vgpr_first = 0
; GCN-NEXT:     reserved_vgpr_count = 0
; GCN-NEXT:     reserved_sgpr_first = 0
; GCN-NEXT:     reserved_sgpr_count = 0
; GCN-NEXT:     debug_wavefront_private_segment_offset_sgpr = 0
; GCN-NEXT:     debug_private_segment_buffer_sgpr = 0
; GCN-NEXT:     kernarg_segment_alignment = 4
; GCN-NEXT:     group_segment_alignment = 4
; GCN-NEXT:     private_segment_alignment = 4
; GCN-NEXT:     wavefront_size = 6
; GCN-NEXT:     call_convention = -1
; GCN-NEXT:     runtime_loader_kernel_symbol = 0
; GCN-NEXT:    .end_amd_kernel_code_t
; GCN-NEXT:  ; %bb.0:
; GCN-NEXT:    s_mov_b32 s32, 0
; GCN-NEXT:    s_mov_b32 flat_scratch_lo, s13
; GCN-NEXT:    s_add_i32 s12, s12, s17
; GCN-NEXT:    s_lshr_b32 flat_scratch_hi, s12, 8
; GCN-NEXT:    s_add_u32 s0, s0, s17
; GCN-NEXT:    s_addc_u32 s1, s1, 0
; GCN-NEXT:    s_mov_b32 s13, s15
; GCN-NEXT:    s_mov_b32 s12, s14
; GCN-NEXT:    s_getpc_b64 s[14:15]
; GCN-NEXT:    s_add_u32 s14, s14, gv.fptr0@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s15, s15, gv.fptr0@rel32@hi+12
; GCN-NEXT:    s_load_dwordx2 s[18:19], s[14:15], 0x0
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 20, v2
; GCN-NEXT:    v_lshlrev_b32_e32 v1, 10, v1
; GCN-NEXT:    v_or_b32_e32 v0, v0, v1
; GCN-NEXT:    v_or_b32_e32 v31, v0, v2
; GCN-NEXT:    s_mov_b32 s14, s16
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_swappc_b64 s[30:31], s[18:19]
; GCN-NEXT:    s_endpgm
  %fptr = load void()*, void()* addrspace(4)* @gv.fptr0
  call void %fptr()
  ret void
}

define amdgpu_kernel void @test_indirect_call_sgpr_ptr_arg() {
; GCN-LABEL: test_indirect_call_sgpr_ptr_arg:
; GCN:         .amd_kernel_code_t
; GCN-NEXT:     amd_code_version_major = 1
; GCN-NEXT:     amd_code_version_minor = 2
; GCN-NEXT:     amd_machine_kind = 1
; GCN-NEXT:     amd_machine_version_major = 7
; GCN-NEXT:     amd_machine_version_minor = 0
; GCN-NEXT:     amd_machine_version_stepping = 0
; GCN-NEXT:     kernel_code_entry_byte_offset = 256
; GCN-NEXT:     kernel_code_prefetch_byte_size = 0
; GCN-NEXT:     granulated_workitem_vgpr_count = 15
; GCN-NEXT:     granulated_wavefront_sgpr_count = 12
; GCN-NEXT:     priority = 0
; GCN-NEXT:     float_mode = 240
; GCN-NEXT:     priv = 0
; GCN-NEXT:     enable_dx10_clamp = 1
; GCN-NEXT:     debug_mode = 0
; GCN-NEXT:     enable_ieee_mode = 1
; GCN-NEXT:     enable_wgp_mode = 0
; GCN-NEXT:     enable_mem_ordered = 0
; GCN-NEXT:     enable_fwd_progress = 0
; GCN-NEXT:     enable_sgpr_private_segment_wave_byte_offset = 1
; GCN-NEXT:     user_sgpr_count = 14
; GCN-NEXT:     enable_trap_handler = 0
; GCN-NEXT:     enable_sgpr_workgroup_id_x = 1
; GCN-NEXT:     enable_sgpr_workgroup_id_y = 1
; GCN-NEXT:     enable_sgpr_workgroup_id_z = 1
; GCN-NEXT:     enable_sgpr_workgroup_info = 0
; GCN-NEXT:     enable_vgpr_workitem_id = 2
; GCN-NEXT:     enable_exception_msb = 0
; GCN-NEXT:     granulated_lds_size = 0
; GCN-NEXT:     enable_exception = 0
; GCN-NEXT:     enable_sgpr_private_segment_buffer = 1
; GCN-NEXT:     enable_sgpr_dispatch_ptr = 1
; GCN-NEXT:     enable_sgpr_queue_ptr = 1
; GCN-NEXT:     enable_sgpr_kernarg_segment_ptr = 1
; GCN-NEXT:     enable_sgpr_dispatch_id = 1
; GCN-NEXT:     enable_sgpr_flat_scratch_init = 1
; GCN-NEXT:     enable_sgpr_private_segment_size = 0
; GCN-NEXT:     enable_sgpr_grid_workgroup_count_x = 0
; GCN-NEXT:     enable_sgpr_grid_workgroup_count_y = 0
; GCN-NEXT:     enable_sgpr_grid_workgroup_count_z = 0
; GCN-NEXT:     enable_wavefront_size32 = 0
; GCN-NEXT:     enable_ordered_append_gds = 0
; GCN-NEXT:     private_element_size = 1
; GCN-NEXT:     is_ptr64 = 1
; GCN-NEXT:     is_dynamic_callstack = 1
; GCN-NEXT:     is_debug_enabled = 0
; GCN-NEXT:     is_xnack_enabled = 0
; GCN-NEXT:     workitem_private_segment_byte_size = 16384
; GCN-NEXT:     workgroup_group_segment_byte_size = 0
; GCN-NEXT:     gds_segment_byte_size = 0
; GCN-NEXT:     kernarg_segment_byte_size = 0
; GCN-NEXT:     workgroup_fbarrier_count = 0
; GCN-NEXT:     wavefront_sgpr_count = 102
; GCN-NEXT:     workitem_vgpr_count = 64
; GCN-NEXT:     reserved_vgpr_first = 0
; GCN-NEXT:     reserved_vgpr_count = 0
; GCN-NEXT:     reserved_sgpr_first = 0
; GCN-NEXT:     reserved_sgpr_count = 0
; GCN-NEXT:     debug_wavefront_private_segment_offset_sgpr = 0
; GCN-NEXT:     debug_private_segment_buffer_sgpr = 0
; GCN-NEXT:     kernarg_segment_alignment = 4
; GCN-NEXT:     group_segment_alignment = 4
; GCN-NEXT:     private_segment_alignment = 4
; GCN-NEXT:     wavefront_size = 6
; GCN-NEXT:     call_convention = -1
; GCN-NEXT:     runtime_loader_kernel_symbol = 0
; GCN-NEXT:    .end_amd_kernel_code_t
; GCN-NEXT:  ; %bb.0:
; GCN-NEXT:    s_mov_b32 s32, 0
; GCN-NEXT:    s_mov_b32 flat_scratch_lo, s13
; GCN-NEXT:    s_add_i32 s12, s12, s17
; GCN-NEXT:    s_lshr_b32 flat_scratch_hi, s12, 8
; GCN-NEXT:    s_add_u32 s0, s0, s17
; GCN-NEXT:    s_addc_u32 s1, s1, 0
; GCN-NEXT:    s_mov_b32 s13, s15
; GCN-NEXT:    s_mov_b32 s12, s14
; GCN-NEXT:    s_getpc_b64 s[14:15]
; GCN-NEXT:    s_add_u32 s14, s14, gv.fptr1@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s15, s15, gv.fptr1@rel32@hi+12
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 20, v2
; GCN-NEXT:    s_load_dwordx2 s[18:19], s[14:15], 0x0
; GCN-NEXT:    v_lshlrev_b32_e32 v1, 10, v1
; GCN-NEXT:    v_or_b32_e32 v0, v0, v1
; GCN-NEXT:    v_or_b32_e32 v31, v0, v2
; GCN-NEXT:    v_mov_b32_e32 v0, 0x7b
; GCN-NEXT:    s_mov_b32 s14, s16
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_swappc_b64 s[30:31], s[18:19]
; GCN-NEXT:    s_endpgm
  %fptr = load void(i32)*, void(i32)* addrspace(4)* @gv.fptr1
  call void %fptr(i32 123)
  ret void
}

define void @test_indirect_call_vgpr_ptr(void()* %fptr) {
; GCN-LABEL: test_indirect_call_vgpr_ptr:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_or_saveexec_b64 s[16:17], -1
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[16:17]
; GCN-NEXT:    v_writelane_b32 v40, s33, 17
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_addk_i32 s32, 0x400
; GCN-NEXT:    v_writelane_b32 v40, s34, 0
; GCN-NEXT:    v_writelane_b32 v40, s35, 1
; GCN-NEXT:    v_writelane_b32 v40, s36, 2
; GCN-NEXT:    v_writelane_b32 v40, s38, 3
; GCN-NEXT:    v_writelane_b32 v40, s39, 4
; GCN-NEXT:    v_writelane_b32 v40, s40, 5
; GCN-NEXT:    v_writelane_b32 v40, s41, 6
; GCN-NEXT:    v_writelane_b32 v40, s42, 7
; GCN-NEXT:    v_writelane_b32 v40, s43, 8
; GCN-NEXT:    v_writelane_b32 v40, s44, 9
; GCN-NEXT:    v_writelane_b32 v40, s45, 10
; GCN-NEXT:    v_writelane_b32 v40, s46, 11
; GCN-NEXT:    v_writelane_b32 v40, s47, 12
; GCN-NEXT:    v_writelane_b32 v40, s48, 13
; GCN-NEXT:    v_writelane_b32 v40, s49, 14
; GCN-NEXT:    v_writelane_b32 v40, s30, 15
; GCN-NEXT:    v_writelane_b32 v40, s31, 16
; GCN-NEXT:    s_mov_b32 s34, s14
; GCN-NEXT:    s_mov_b32 s35, s13
; GCN-NEXT:    s_mov_b32 s36, s12
; GCN-NEXT:    s_mov_b64 s[38:39], s[10:11]
; GCN-NEXT:    s_mov_b64 s[40:41], s[8:9]
; GCN-NEXT:    s_mov_b64 s[42:43], s[6:7]
; GCN-NEXT:    s_mov_b64 s[44:45], s[4:5]
; GCN-NEXT:    s_mov_b64 s[46:47], exec
; GCN-NEXT:  BB2_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s16, v0
; GCN-NEXT:    v_readfirstlane_b32 s17, v1
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc, s[16:17], v[0:1]
; GCN-NEXT:    s_and_saveexec_b64 s[48:49], vcc
; GCN-NEXT:    s_mov_b64 s[4:5], s[44:45]
; GCN-NEXT:    s_mov_b64 s[6:7], s[42:43]
; GCN-NEXT:    s_mov_b64 s[8:9], s[40:41]
; GCN-NEXT:    s_mov_b64 s[10:11], s[38:39]
; GCN-NEXT:    s_mov_b32 s12, s36
; GCN-NEXT:    s_mov_b32 s13, s35
; GCN-NEXT:    s_mov_b32 s14, s34
; GCN-NEXT:    s_swappc_b64 s[30:31], s[16:17]
; GCN-NEXT:    ; implicit-def: $vgpr0_vgpr1
; GCN-NEXT:    ; implicit-def: $vgpr31
; GCN-NEXT:    s_xor_b64 exec, exec, s[48:49]
; GCN-NEXT:    s_cbranch_execnz BB2_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b64 exec, s[46:47]
; GCN-NEXT:    v_readlane_b32 s4, v40, 15
; GCN-NEXT:    v_readlane_b32 s5, v40, 16
; GCN-NEXT:    v_readlane_b32 s49, v40, 14
; GCN-NEXT:    v_readlane_b32 s48, v40, 13
; GCN-NEXT:    v_readlane_b32 s47, v40, 12
; GCN-NEXT:    v_readlane_b32 s46, v40, 11
; GCN-NEXT:    v_readlane_b32 s45, v40, 10
; GCN-NEXT:    v_readlane_b32 s44, v40, 9
; GCN-NEXT:    v_readlane_b32 s43, v40, 8
; GCN-NEXT:    v_readlane_b32 s42, v40, 7
; GCN-NEXT:    v_readlane_b32 s41, v40, 6
; GCN-NEXT:    v_readlane_b32 s40, v40, 5
; GCN-NEXT:    v_readlane_b32 s39, v40, 4
; GCN-NEXT:    v_readlane_b32 s38, v40, 3
; GCN-NEXT:    v_readlane_b32 s36, v40, 2
; GCN-NEXT:    v_readlane_b32 s35, v40, 1
; GCN-NEXT:    v_readlane_b32 s34, v40, 0
; GCN-NEXT:    s_addk_i32 s32, 0xfc00
; GCN-NEXT:    v_readlane_b32 s33, v40, 17
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[4:5]
  call void %fptr()
  ret void
}

define void @test_indirect_call_vgpr_ptr_arg(void(i32)* %fptr) {
; GCN-LABEL: test_indirect_call_vgpr_ptr_arg:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_or_saveexec_b64 s[16:17], -1
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[16:17]
; GCN-NEXT:    v_writelane_b32 v40, s33, 17
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_addk_i32 s32, 0x400
; GCN-NEXT:    v_writelane_b32 v40, s34, 0
; GCN-NEXT:    v_writelane_b32 v40, s35, 1
; GCN-NEXT:    v_writelane_b32 v40, s36, 2
; GCN-NEXT:    v_writelane_b32 v40, s38, 3
; GCN-NEXT:    v_writelane_b32 v40, s39, 4
; GCN-NEXT:    v_writelane_b32 v40, s40, 5
; GCN-NEXT:    v_writelane_b32 v40, s41, 6
; GCN-NEXT:    v_writelane_b32 v40, s42, 7
; GCN-NEXT:    v_writelane_b32 v40, s43, 8
; GCN-NEXT:    v_writelane_b32 v40, s44, 9
; GCN-NEXT:    v_writelane_b32 v40, s45, 10
; GCN-NEXT:    v_writelane_b32 v40, s46, 11
; GCN-NEXT:    v_writelane_b32 v40, s47, 12
; GCN-NEXT:    v_writelane_b32 v40, s48, 13
; GCN-NEXT:    v_writelane_b32 v40, s49, 14
; GCN-NEXT:    v_writelane_b32 v40, s30, 15
; GCN-NEXT:    v_writelane_b32 v40, s31, 16
; GCN-NEXT:    s_mov_b32 s34, s14
; GCN-NEXT:    s_mov_b32 s35, s13
; GCN-NEXT:    s_mov_b32 s36, s12
; GCN-NEXT:    s_mov_b64 s[38:39], s[10:11]
; GCN-NEXT:    s_mov_b64 s[40:41], s[8:9]
; GCN-NEXT:    s_mov_b64 s[42:43], s[6:7]
; GCN-NEXT:    s_mov_b64 s[44:45], s[4:5]
; GCN-NEXT:    s_mov_b64 s[46:47], exec
; GCN-NEXT:  BB3_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s16, v0
; GCN-NEXT:    v_readfirstlane_b32 s17, v1
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc, s[16:17], v[0:1]
; GCN-NEXT:    s_and_saveexec_b64 s[48:49], vcc
; GCN-NEXT:    v_mov_b32_e32 v0, 0x7b
; GCN-NEXT:    s_mov_b64 s[4:5], s[44:45]
; GCN-NEXT:    s_mov_b64 s[6:7], s[42:43]
; GCN-NEXT:    s_mov_b64 s[8:9], s[40:41]
; GCN-NEXT:    s_mov_b64 s[10:11], s[38:39]
; GCN-NEXT:    s_mov_b32 s12, s36
; GCN-NEXT:    s_mov_b32 s13, s35
; GCN-NEXT:    s_mov_b32 s14, s34
; GCN-NEXT:    s_swappc_b64 s[30:31], s[16:17]
; GCN-NEXT:    ; implicit-def: $vgpr0_vgpr1
; GCN-NEXT:    ; implicit-def: $vgpr31
; GCN-NEXT:    s_xor_b64 exec, exec, s[48:49]
; GCN-NEXT:    s_cbranch_execnz BB3_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b64 exec, s[46:47]
; GCN-NEXT:    v_readlane_b32 s4, v40, 15
; GCN-NEXT:    v_readlane_b32 s5, v40, 16
; GCN-NEXT:    v_readlane_b32 s49, v40, 14
; GCN-NEXT:    v_readlane_b32 s48, v40, 13
; GCN-NEXT:    v_readlane_b32 s47, v40, 12
; GCN-NEXT:    v_readlane_b32 s46, v40, 11
; GCN-NEXT:    v_readlane_b32 s45, v40, 10
; GCN-NEXT:    v_readlane_b32 s44, v40, 9
; GCN-NEXT:    v_readlane_b32 s43, v40, 8
; GCN-NEXT:    v_readlane_b32 s42, v40, 7
; GCN-NEXT:    v_readlane_b32 s41, v40, 6
; GCN-NEXT:    v_readlane_b32 s40, v40, 5
; GCN-NEXT:    v_readlane_b32 s39, v40, 4
; GCN-NEXT:    v_readlane_b32 s38, v40, 3
; GCN-NEXT:    v_readlane_b32 s36, v40, 2
; GCN-NEXT:    v_readlane_b32 s35, v40, 1
; GCN-NEXT:    v_readlane_b32 s34, v40, 0
; GCN-NEXT:    s_addk_i32 s32, 0xfc00
; GCN-NEXT:    v_readlane_b32 s33, v40, 17
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[4:5]
  call void %fptr(i32 123)
  ret void
}

define i32 @test_indirect_call_vgpr_ptr_ret(i32()* %fptr) {
; GCN-LABEL: test_indirect_call_vgpr_ptr_ret:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_or_saveexec_b64 s[16:17], -1
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[16:17]
; GCN-NEXT:    v_writelane_b32 v40, s33, 17
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_addk_i32 s32, 0x400
; GCN-NEXT:    v_writelane_b32 v40, s34, 0
; GCN-NEXT:    v_writelane_b32 v40, s35, 1
; GCN-NEXT:    v_writelane_b32 v40, s36, 2
; GCN-NEXT:    v_writelane_b32 v40, s38, 3
; GCN-NEXT:    v_writelane_b32 v40, s39, 4
; GCN-NEXT:    v_writelane_b32 v40, s40, 5
; GCN-NEXT:    v_writelane_b32 v40, s41, 6
; GCN-NEXT:    v_writelane_b32 v40, s42, 7
; GCN-NEXT:    v_writelane_b32 v40, s43, 8
; GCN-NEXT:    v_writelane_b32 v40, s44, 9
; GCN-NEXT:    v_writelane_b32 v40, s45, 10
; GCN-NEXT:    v_writelane_b32 v40, s46, 11
; GCN-NEXT:    v_writelane_b32 v40, s47, 12
; GCN-NEXT:    v_writelane_b32 v40, s48, 13
; GCN-NEXT:    v_writelane_b32 v40, s49, 14
; GCN-NEXT:    v_writelane_b32 v40, s30, 15
; GCN-NEXT:    v_writelane_b32 v40, s31, 16
; GCN-NEXT:    s_mov_b32 s34, s14
; GCN-NEXT:    s_mov_b32 s35, s13
; GCN-NEXT:    s_mov_b32 s36, s12
; GCN-NEXT:    s_mov_b64 s[38:39], s[10:11]
; GCN-NEXT:    s_mov_b64 s[40:41], s[8:9]
; GCN-NEXT:    s_mov_b64 s[42:43], s[6:7]
; GCN-NEXT:    s_mov_b64 s[44:45], s[4:5]
; GCN-NEXT:    s_mov_b64 s[46:47], exec
; GCN-NEXT:  BB4_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s16, v0
; GCN-NEXT:    v_readfirstlane_b32 s17, v1
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc, s[16:17], v[0:1]
; GCN-NEXT:    s_and_saveexec_b64 s[48:49], vcc
; GCN-NEXT:    s_mov_b64 s[4:5], s[44:45]
; GCN-NEXT:    s_mov_b64 s[6:7], s[42:43]
; GCN-NEXT:    s_mov_b64 s[8:9], s[40:41]
; GCN-NEXT:    s_mov_b64 s[10:11], s[38:39]
; GCN-NEXT:    s_mov_b32 s12, s36
; GCN-NEXT:    s_mov_b32 s13, s35
; GCN-NEXT:    s_mov_b32 s14, s34
; GCN-NEXT:    s_swappc_b64 s[30:31], s[16:17]
; GCN-NEXT:    v_mov_b32_e32 v2, v0
; GCN-NEXT:    ; implicit-def: $vgpr0_vgpr1
; GCN-NEXT:    ; implicit-def: $vgpr31
; GCN-NEXT:    s_xor_b64 exec, exec, s[48:49]
; GCN-NEXT:    s_cbranch_execnz BB4_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b64 exec, s[46:47]
; GCN-NEXT:    v_add_i32_e32 v0, vcc, 1, v2
; GCN-NEXT:    v_readlane_b32 s4, v40, 15
; GCN-NEXT:    v_readlane_b32 s5, v40, 16
; GCN-NEXT:    v_readlane_b32 s49, v40, 14
; GCN-NEXT:    v_readlane_b32 s48, v40, 13
; GCN-NEXT:    v_readlane_b32 s47, v40, 12
; GCN-NEXT:    v_readlane_b32 s46, v40, 11
; GCN-NEXT:    v_readlane_b32 s45, v40, 10
; GCN-NEXT:    v_readlane_b32 s44, v40, 9
; GCN-NEXT:    v_readlane_b32 s43, v40, 8
; GCN-NEXT:    v_readlane_b32 s42, v40, 7
; GCN-NEXT:    v_readlane_b32 s41, v40, 6
; GCN-NEXT:    v_readlane_b32 s40, v40, 5
; GCN-NEXT:    v_readlane_b32 s39, v40, 4
; GCN-NEXT:    v_readlane_b32 s38, v40, 3
; GCN-NEXT:    v_readlane_b32 s36, v40, 2
; GCN-NEXT:    v_readlane_b32 s35, v40, 1
; GCN-NEXT:    v_readlane_b32 s34, v40, 0
; GCN-NEXT:    s_addk_i32 s32, 0xfc00
; GCN-NEXT:    v_readlane_b32 s33, v40, 17
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[4:5]
  %a = call i32 %fptr()
  %b = add i32 %a, 1
  ret i32 %b
}

define void @test_indirect_call_vgpr_ptr_in_branch(void()* %fptr, i1 %cond) {
; GCN-LABEL: test_indirect_call_vgpr_ptr_in_branch:
; GCN:       ; %bb.0: ; %bb0
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_or_saveexec_b64 s[16:17], -1
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[16:17]
; GCN-NEXT:    v_writelane_b32 v40, s33, 19
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_addk_i32 s32, 0x400
; GCN-NEXT:    v_writelane_b32 v40, s34, 0
; GCN-NEXT:    v_writelane_b32 v40, s35, 1
; GCN-NEXT:    v_writelane_b32 v40, s36, 2
; GCN-NEXT:    v_writelane_b32 v40, s38, 3
; GCN-NEXT:    v_writelane_b32 v40, s39, 4
; GCN-NEXT:    v_writelane_b32 v40, s40, 5
; GCN-NEXT:    v_writelane_b32 v40, s41, 6
; GCN-NEXT:    v_writelane_b32 v40, s42, 7
; GCN-NEXT:    v_writelane_b32 v40, s43, 8
; GCN-NEXT:    v_writelane_b32 v40, s44, 9
; GCN-NEXT:    v_writelane_b32 v40, s45, 10
; GCN-NEXT:    v_writelane_b32 v40, s46, 11
; GCN-NEXT:    v_writelane_b32 v40, s47, 12
; GCN-NEXT:    v_writelane_b32 v40, s48, 13
; GCN-NEXT:    v_writelane_b32 v40, s49, 14
; GCN-NEXT:    v_writelane_b32 v40, s50, 15
; GCN-NEXT:    v_writelane_b32 v40, s51, 16
; GCN-NEXT:    s_mov_b32 s34, s14
; GCN-NEXT:    s_mov_b32 s35, s13
; GCN-NEXT:    s_mov_b32 s36, s12
; GCN-NEXT:    s_mov_b64 s[38:39], s[10:11]
; GCN-NEXT:    s_mov_b64 s[40:41], s[8:9]
; GCN-NEXT:    s_mov_b64 s[42:43], s[6:7]
; GCN-NEXT:    s_mov_b64 s[44:45], s[4:5]
; GCN-NEXT:    v_and_b32_e32 v2, 1, v2
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v2
; GCN-NEXT:    s_and_saveexec_b64 s[46:47], vcc
; GCN-NEXT:    s_cbranch_execz BB5_4
; GCN-NEXT:  ; %bb.1: ; %bb1
; GCN-NEXT:    v_writelane_b32 v40, s30, 17
; GCN-NEXT:    v_writelane_b32 v40, s31, 18
; GCN-NEXT:    s_mov_b64 s[48:49], exec
; GCN-NEXT:  BB5_2: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s16, v0
; GCN-NEXT:    v_readfirstlane_b32 s17, v1
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc, s[16:17], v[0:1]
; GCN-NEXT:    s_and_saveexec_b64 s[50:51], vcc
; GCN-NEXT:    s_mov_b64 s[4:5], s[44:45]
; GCN-NEXT:    s_mov_b64 s[6:7], s[42:43]
; GCN-NEXT:    s_mov_b64 s[8:9], s[40:41]
; GCN-NEXT:    s_mov_b64 s[10:11], s[38:39]
; GCN-NEXT:    s_mov_b32 s12, s36
; GCN-NEXT:    s_mov_b32 s13, s35
; GCN-NEXT:    s_mov_b32 s14, s34
; GCN-NEXT:    s_swappc_b64 s[30:31], s[16:17]
; GCN-NEXT:    ; implicit-def: $vgpr0_vgpr1
; GCN-NEXT:    ; implicit-def: $vgpr31
; GCN-NEXT:    s_xor_b64 exec, exec, s[50:51]
; GCN-NEXT:    s_cbranch_execnz BB5_2
; GCN-NEXT:  ; %bb.3:
; GCN-NEXT:    s_mov_b64 exec, s[48:49]
; GCN-NEXT:    v_readlane_b32 s30, v40, 17
; GCN-NEXT:    v_readlane_b32 s31, v40, 18
; GCN-NEXT:  BB5_4: ; %bb2
; GCN-NEXT:    s_or_b64 exec, exec, s[46:47]
; GCN-NEXT:    v_readlane_b32 s51, v40, 16
; GCN-NEXT:    v_readlane_b32 s50, v40, 15
; GCN-NEXT:    v_readlane_b32 s49, v40, 14
; GCN-NEXT:    v_readlane_b32 s48, v40, 13
; GCN-NEXT:    v_readlane_b32 s47, v40, 12
; GCN-NEXT:    v_readlane_b32 s46, v40, 11
; GCN-NEXT:    v_readlane_b32 s45, v40, 10
; GCN-NEXT:    v_readlane_b32 s44, v40, 9
; GCN-NEXT:    v_readlane_b32 s43, v40, 8
; GCN-NEXT:    v_readlane_b32 s42, v40, 7
; GCN-NEXT:    v_readlane_b32 s41, v40, 6
; GCN-NEXT:    v_readlane_b32 s40, v40, 5
; GCN-NEXT:    v_readlane_b32 s39, v40, 4
; GCN-NEXT:    v_readlane_b32 s38, v40, 3
; GCN-NEXT:    v_readlane_b32 s36, v40, 2
; GCN-NEXT:    v_readlane_b32 s35, v40, 1
; GCN-NEXT:    v_readlane_b32 s34, v40, 0
; GCN-NEXT:    s_addk_i32 s32, 0xfc00
; GCN-NEXT:    v_readlane_b32 s33, v40, 19
; GCN-NEXT:    s_or_saveexec_b64 s[4:5], -1
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[4:5]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
bb0:
  br i1 %cond, label %bb1, label %bb2

bb1:
  call void %fptr()
  br label %bb2

bb2:
  ret void
}

define void @test_indirect_call_vgpr_ptr_inreg_arg(void(i32)* %fptr) {
; GCN-LABEL: test_indirect_call_vgpr_ptr_inreg_arg:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_or_saveexec_b64 s[4:5], -1
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[4:5]
; GCN-NEXT:    v_writelane_b32 v40, s33, 6
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_addk_i32 s32, 0x400
; GCN-NEXT:    v_writelane_b32 v40, s34, 0
; GCN-NEXT:    v_writelane_b32 v40, s35, 1
; GCN-NEXT:    v_writelane_b32 v40, s36, 2
; GCN-NEXT:    v_writelane_b32 v40, s37, 3
; GCN-NEXT:    v_writelane_b32 v40, s30, 4
; GCN-NEXT:    v_writelane_b32 v40, s31, 5
; GCN-NEXT:    s_mov_b64 s[34:35], exec
; GCN-NEXT:  BB6_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s6, v0
; GCN-NEXT:    v_readfirstlane_b32 s7, v1
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc, s[6:7], v[0:1]
; GCN-NEXT:    s_and_saveexec_b64 s[36:37], vcc
; GCN-NEXT:    s_movk_i32 s4, 0x7b
; GCN-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GCN-NEXT:    ; implicit-def: $vgpr0_vgpr1
; GCN-NEXT:    s_xor_b64 exec, exec, s[36:37]
; GCN-NEXT:    s_cbranch_execnz BB6_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b64 exec, s[34:35]
; GCN-NEXT:    v_readlane_b32 s4, v40, 4
; GCN-NEXT:    v_readlane_b32 s5, v40, 5
; GCN-NEXT:    v_readlane_b32 s37, v40, 3
; GCN-NEXT:    v_readlane_b32 s36, v40, 2
; GCN-NEXT:    v_readlane_b32 s35, v40, 1
; GCN-NEXT:    v_readlane_b32 s34, v40, 0
; GCN-NEXT:    s_addk_i32 s32, 0xfc00
; GCN-NEXT:    v_readlane_b32 s33, v40, 6
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[4:5]
  call amdgpu_gfx void %fptr(i32 inreg 123)
  ret void
}

define i32 @test_indirect_call_vgpr_ptr_arg_and_reuse(i32 %i, void(i32)* %fptr) {
; GCN-LABEL: test_indirect_call_vgpr_ptr_arg_and_reuse:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_or_saveexec_b64 s[4:5], -1
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s32 offset:4 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[4:5]
; GCN-NEXT:    v_writelane_b32 v40, s33, 6
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_addk_i32 s32, 0x400
; GCN-NEXT:    buffer_store_dword v41, off, s[0:3], s33 ; 4-byte Folded Spill
; GCN-NEXT:    v_writelane_b32 v40, s34, 0
; GCN-NEXT:    v_writelane_b32 v40, s35, 1
; GCN-NEXT:    v_writelane_b32 v40, s36, 2
; GCN-NEXT:    v_writelane_b32 v40, s37, 3
; GCN-NEXT:    v_writelane_b32 v40, s30, 4
; GCN-NEXT:    v_writelane_b32 v40, s31, 5
; GCN-NEXT:    v_mov_b32_e32 v41, v0
; GCN-NEXT:    s_mov_b64 s[34:35], exec
; GCN-NEXT:  BB7_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s4, v1
; GCN-NEXT:    v_readfirstlane_b32 s5, v2
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc, s[4:5], v[1:2]
; GCN-NEXT:    s_and_saveexec_b64 s[36:37], vcc
; GCN-NEXT:    v_mov_b32_e32 v0, v41
; GCN-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GCN-NEXT:    ; implicit-def: $vgpr1_vgpr2
; GCN-NEXT:    s_xor_b64 exec, exec, s[36:37]
; GCN-NEXT:    s_cbranch_execnz BB7_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b64 exec, s[34:35]
; GCN-NEXT:    v_mov_b32_e32 v0, v41
; GCN-NEXT:    v_readlane_b32 s4, v40, 4
; GCN-NEXT:    v_readlane_b32 s5, v40, 5
; GCN-NEXT:    v_readlane_b32 s37, v40, 3
; GCN-NEXT:    v_readlane_b32 s36, v40, 2
; GCN-NEXT:    v_readlane_b32 s35, v40, 1
; GCN-NEXT:    v_readlane_b32 s34, v40, 0
; GCN-NEXT:    buffer_load_dword v41, off, s[0:3], s33 ; 4-byte Folded Reload
; GCN-NEXT:    s_addk_i32 s32, 0xfc00
; GCN-NEXT:    v_readlane_b32 s33, v40, 6
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s32 offset:4 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[4:5]
  call amdgpu_gfx void %fptr(i32 %i)
  ret i32 %i
}

; Use a variable inside a waterfall loop and use the return variable after the loop.
; TODO The argument and return variable could be in the same physical register, but the register
; allocator is not able to do that because the return value clashes with the liverange of an
; IMPLICIT_DEF of the argument.
define i32 @test_indirect_call_vgpr_ptr_arg_and_return(i32 %i, i32(i32)* %fptr) {
; GCN-LABEL: test_indirect_call_vgpr_ptr_arg_and_return:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_or_saveexec_b64 s[4:5], -1
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[4:5]
; GCN-NEXT:    v_writelane_b32 v40, s33, 6
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_addk_i32 s32, 0x400
; GCN-NEXT:    v_writelane_b32 v40, s34, 0
; GCN-NEXT:    v_writelane_b32 v40, s35, 1
; GCN-NEXT:    v_writelane_b32 v40, s36, 2
; GCN-NEXT:    v_writelane_b32 v40, s37, 3
; GCN-NEXT:    v_writelane_b32 v40, s30, 4
; GCN-NEXT:    v_writelane_b32 v40, s31, 5
; GCN-NEXT:    s_mov_b64 s[34:35], exec
; GCN-NEXT:  BB8_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s4, v1
; GCN-NEXT:    v_readfirstlane_b32 s5, v2
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc, s[4:5], v[1:2]
; GCN-NEXT:    s_and_saveexec_b64 s[36:37], vcc
; GCN-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GCN-NEXT:    v_mov_b32_e32 v3, v0
; GCN-NEXT:    ; implicit-def: $vgpr1_vgpr2
; GCN-NEXT:    ; implicit-def: $vgpr0
; GCN-NEXT:    s_xor_b64 exec, exec, s[36:37]
; GCN-NEXT:    s_cbranch_execnz BB8_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b64 exec, s[34:35]
; GCN-NEXT:    v_mov_b32_e32 v0, v3
; GCN-NEXT:    v_readlane_b32 s4, v40, 4
; GCN-NEXT:    v_readlane_b32 s5, v40, 5
; GCN-NEXT:    v_readlane_b32 s37, v40, 3
; GCN-NEXT:    v_readlane_b32 s36, v40, 2
; GCN-NEXT:    v_readlane_b32 s35, v40, 1
; GCN-NEXT:    v_readlane_b32 s34, v40, 0
; GCN-NEXT:    s_addk_i32 s32, 0xfc00
; GCN-NEXT:    v_readlane_b32 s33, v40, 6
; GCN-NEXT:    s_or_saveexec_b64 s[6:7], -1
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[6:7]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[4:5]
  %ret = call amdgpu_gfx i32 %fptr(i32 %i)
  ret i32 %ret
}
