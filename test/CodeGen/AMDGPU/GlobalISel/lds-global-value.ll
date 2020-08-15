; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=bonaire -verify-machineinstrs < %s | FileCheck %s
; TODO: Replace with existing DAG tests

@lds_512_4 = internal unnamed_addr addrspace(3) global [128 x i32] undef, align 4
@lds_4_8 = addrspace(3) global i32 undef, align 8

define amdgpu_kernel void @use_lds_globals(i32 addrspace(1)* %out, i32 addrspace(3)* %in) #0 {
; CHECK-LABEL: use_lds_globals:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; CHECK-NEXT:    v_mov_b32_e32 v0, 4
; CHECK-NEXT:    s_mov_b32 m0, -1
; CHECK-NEXT:    ds_read_b32 v3, v0 offset:4
; CHECK-NEXT:    v_mov_b32_e32 v2, 9
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    s_add_u32 s0, s0, 4
; CHECK-NEXT:    s_addc_u32 s1, s1, 0
; CHECK-NEXT:    v_mov_b32_e32 v0, s0
; CHECK-NEXT:    v_mov_b32_e32 v1, s1
; CHECK-NEXT:    flat_store_dword v[0:1], v3
; CHECK-NEXT:    v_mov_b32_e32 v0, 0
; CHECK-NEXT:    ds_write_b32 v0, v2
; CHECK-NEXT:    s_endpgm
entry:
  %tmp0 = getelementptr [128 x i32], [128 x i32] addrspace(3)* @lds_512_4, i32 0, i32 1
  %tmp1 = load i32, i32 addrspace(3)* %tmp0
  %tmp2 = getelementptr i32, i32 addrspace(1)* %out, i32 1
  store i32 %tmp1, i32 addrspace(1)* %tmp2
  store i32 9, i32 addrspace(3)* @lds_4_8
  ret void
}

attributes #0 = { nounwind }
