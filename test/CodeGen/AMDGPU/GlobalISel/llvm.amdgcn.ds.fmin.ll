; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tonga -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GFX10 %s

define amdgpu_ps float @ds_fmin_f32_ss(float addrspace(3)* inreg %ptr, float inreg %val) {
; GFX8-LABEL: ds_fmin_f32_ss:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: ds_fmin_f32_ss:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    v_mov_b32_e32 v1, s3
; GFX9-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: ds_fmin_f32_ss:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
  %ret = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %ptr, float %val, i32 0, i32 0, i1 false)
  ret float %ret
}

define amdgpu_ps float @ds_fmin_f32_ss_offset(float addrspace(3)* inreg %ptr, float inreg %val) {
; GFX8-LABEL: ds_fmin_f32_ss_offset:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s3
; GFX8-NEXT:    v_mov_b32_e32 v1, s2
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v1, v0 offset:512
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: ds_fmin_f32_ss_offset:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s3
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    ds_min_rtn_f32 v0, v1, v0 offset:512
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: ds_fmin_f32_ss_offset:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v0, s3
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    ds_min_rtn_f32 v0, v1, v0 offset:512
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
  %gep = getelementptr float, float addrspace(3)* %ptr, i32 128
  %ret = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %gep, float %val, i32 0, i32 0, i1 false)
  ret float %ret
}

define amdgpu_ps void @ds_fmin_f32_ss_nortn(float addrspace(3)* inreg %ptr, float inreg %val) {
; GFX8-LABEL: ds_fmin_f32_ss_nortn:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: ds_fmin_f32_ss_nortn:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    v_mov_b32_e32 v1, s3
; GFX9-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: ds_fmin_f32_ss_nortn:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX10-NEXT:    s_endpgm
  %unused = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %ptr, float %val, i32 0, i32 0, i1 false)
  ret void
}

define amdgpu_ps void @ds_fmin_f32_ss_offset_nortn(float addrspace(3)* inreg %ptr, float inreg %val) {
; GFX8-LABEL: ds_fmin_f32_ss_offset_nortn:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s3
; GFX8-NEXT:    v_mov_b32_e32 v1, s2
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v1, v0 offset:512
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: ds_fmin_f32_ss_offset_nortn:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s3
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    ds_min_rtn_f32 v0, v1, v0 offset:512
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: ds_fmin_f32_ss_offset_nortn:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v0, s3
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    ds_min_rtn_f32 v0, v1, v0 offset:512
; GFX10-NEXT:    s_endpgm
  %gep = getelementptr float, float addrspace(3)* %ptr, i32 128
  %unused = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %gep, float %val, i32 0, i32 0, i1 false)
  ret void
}

define float @ds_fmin_f32_vv(float addrspace(3)* %ptr, float %val) {
; GFX8-LABEL: ds_fmin_f32_vv:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: ds_fmin_f32_vv:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: ds_fmin_f32_vv:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %ret = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %ptr, float %val, i32 0, i32 0, i1 false)
  ret float %ret
}

define float @ds_fmin_f32_vv_offset(float addrspace(3)* %ptr, float %val) {
; GFX8-LABEL: ds_fmin_f32_vv_offset:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v0, v1 offset:512
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: ds_fmin_f32_vv_offset:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_min_rtn_f32 v0, v0, v1 offset:512
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: ds_fmin_f32_vv_offset:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ds_min_rtn_f32 v0, v0, v1 offset:512
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr float, float addrspace(3)* %ptr, i32 128
  %ret = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %gep, float %val, i32 0, i32 0, i1 false)
  ret float %ret
}

define void @ds_fmin_f32_vv_nortn(float addrspace(3)* %ptr, float %val) {
; GFX8-LABEL: ds_fmin_f32_vv_nortn:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: ds_fmin_f32_vv_nortn:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: ds_fmin_f32_vv_nortn:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %ret = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %ptr, float %val, i32 0, i32 0, i1 false)
  ret void
}

define void @ds_fmin_f32_vv_offset_nortn(float addrspace(3)* %ptr, float %val) {
; GFX8-LABEL: ds_fmin_f32_vv_offset_nortn:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v0, v1 offset:512
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: ds_fmin_f32_vv_offset_nortn:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_min_rtn_f32 v0, v0, v1 offset:512
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: ds_fmin_f32_vv_offset_nortn:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ds_min_rtn_f32 v0, v0, v1 offset:512
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr float, float addrspace(3)* %ptr, i32 128
  %ret = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %gep, float %val, i32 0, i32 0, i1 false)
  ret void
}

define float @ds_fmin_f32_vv_volatile(float addrspace(3)* %ptr, float %val) {
; GFX8-LABEL: ds_fmin_f32_vv_volatile:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: ds_fmin_f32_vv_volatile:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: ds_fmin_f32_vv_volatile:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ds_min_rtn_f32 v0, v0, v1
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %ret = call float @llvm.amdgcn.ds.fmin(float addrspace(3)* %ptr, float %val, i32 0, i32 0, i1 true)
  ret float %ret
}

declare float @llvm.amdgcn.ds.fmin(float addrspace(3)* nocapture, float, i32 immarg, i32 immarg, i1 immarg) #0

attributes #0 = { argmemonly nounwind willreturn }
