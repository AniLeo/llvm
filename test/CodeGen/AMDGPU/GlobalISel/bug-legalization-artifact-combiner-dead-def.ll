; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s

define void @value_finder_bug(<2 x float> addrspace(5)* %store_ptr, <4 x float> addrspace(4)* %ptr) {
; GFX10-LABEL: value_finder_bug:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    global_load_dwordx4 v[1:4], v[1:2], off
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    buffer_store_dword v3, v0, s[0:3], 0 offen
; GFX10-NEXT:    buffer_store_dword v4, v0, s[0:3], 0 offen offset:4
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %vec = load <4 x float>, <4 x float> addrspace(4)* %ptr, align 4
  %vec.3 = extractelement <4 x float> %vec, i32 3
  %shuffle = shufflevector <4 x float> %vec, <4 x float> undef, <2 x i32> <i32 2, i32 undef>
  %new_vec = insertelement <2 x float> %shuffle, float %vec.3, i32 1
  store <2 x float> %new_vec, <2 x float> addrspace(5)* %store_ptr, align 8
  ret void
}
