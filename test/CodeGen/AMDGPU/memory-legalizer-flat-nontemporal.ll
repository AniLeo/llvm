; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx700 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX7 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX10-WGP %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -mattr=+cumode -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX10-CU %s
; RUN: llc -mtriple=amdgcn-amd-amdpal -mcpu=gfx700 -amdgcn-skip-cache-invalidations -verify-machineinstrs < %s | FileCheck --check-prefixes=SKIP-CACHE-INV %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx90a -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX90A-NOTTGSPLIT %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx90a -mattr=+tgsplit -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX90A-TGSPLIT %s

define amdgpu_kernel void @flat_nontemporal_load_0(
; GFX7-LABEL: flat_nontemporal_load_0:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    flat_load_dword v0, v[0:1] glc slc
; GFX7-NEXT:    v_mov_b32_e32 v2, s2
; GFX7-NEXT:    v_mov_b32_e32 v3, s3
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[2:3], v0
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_load_0:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-WGP-NEXT:    flat_load_dword v2, v[0:1] slc
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_load_0:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-CU-NEXT:    flat_load_dword v2, v[0:1] slc
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_load_0:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s1
; SKIP-CACHE-INV-NEXT:    flat_load_dword v0, v[0:1] glc slc
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v3, s3
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[2:3], v0
; SKIP-CACHE-INV-NEXT:    s_endpgm
;
; GFX90A-NOTTGSPLIT-LABEL: flat_nontemporal_load_0:
; GFX90A-NOTTGSPLIT:       ; %bb.0: ; %entry
; GFX90A-NOTTGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v0, s0
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v1, s1
; GFX90A-NOTTGSPLIT-NEXT:    flat_load_dword v0, v[0:1] glc slc
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v2, s2
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v3, s3
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    flat_store_dword v[2:3], v0
; GFX90A-NOTTGSPLIT-NEXT:    s_endpgm
;
; GFX90A-TGSPLIT-LABEL: flat_nontemporal_load_0:
; GFX90A-TGSPLIT:       ; %bb.0: ; %entry
; GFX90A-TGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-TGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v0, s0
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v1, s1
; GFX90A-TGSPLIT-NEXT:    flat_load_dword v0, v[0:1] glc slc
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v2, s2
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v3, s3
; GFX90A-TGSPLIT-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-TGSPLIT-NEXT:    flat_store_dword v[2:3], v0
; GFX90A-TGSPLIT-NEXT:    s_endpgm
;
;
    i32* %in, i32* %out) {
entry:
  %val = load i32, i32* %in, align 4, !nontemporal !0
  store i32 %val, i32* %out
  ret void
}

define amdgpu_kernel void @flat_nontemporal_load_1(
; GFX7-LABEL: flat_nontemporal_load_1:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v3, s1
; GFX7-NEXT:    v_add_i32_e32 v2, vcc, s0, v2
; GFX7-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; GFX7-NEXT:    flat_load_dword v2, v[2:3] glc slc
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    v_mov_b32_e32 v1, s3
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[0:1], v2
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_load_1:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_add_co_u32_e64 v0, s0, s0, v0
; GFX10-WGP-NEXT:    v_add_co_ci_u32_e64 v1, s0, s1, 0, s0
; GFX10-WGP-NEXT:    flat_load_dword v2, v[0:1] slc
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_load_1:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_add_co_u32_e64 v0, s0, s0, v0
; GFX10-CU-NEXT:    v_add_co_ci_u32_e64 v1, s0, s1, 0, s0
; GFX10-CU-NEXT:    flat_load_dword v2, v[0:1] slc
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_load_1:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v3, s1
; SKIP-CACHE-INV-NEXT:    v_add_i32_e32 v2, vcc, s0, v2
; SKIP-CACHE-INV-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; SKIP-CACHE-INV-NEXT:    flat_load_dword v2, v[2:3] glc slc
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s3
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[0:1], v2
; SKIP-CACHE-INV-NEXT:    s_endpgm
;
; GFX90A-NOTTGSPLIT-LABEL: flat_nontemporal_load_1:
; GFX90A-NOTTGSPLIT:       ; %bb.0: ; %entry
; GFX90A-NOTTGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-NOTTGSPLIT-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v3, s1
; GFX90A-NOTTGSPLIT-NEXT:    v_add_co_u32_e32 v2, vcc, s0, v2
; GFX90A-NOTTGSPLIT-NEXT:    v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
; GFX90A-NOTTGSPLIT-NEXT:    flat_load_dword v2, v[2:3] glc slc
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v0, s2
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v1, s3
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    flat_store_dword v[0:1], v2
; GFX90A-NOTTGSPLIT-NEXT:    s_endpgm
;
; GFX90A-TGSPLIT-LABEL: flat_nontemporal_load_1:
; GFX90A-TGSPLIT:       ; %bb.0: ; %entry
; GFX90A-TGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-TGSPLIT-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; GFX90A-TGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v3, s1
; GFX90A-TGSPLIT-NEXT:    v_add_co_u32_e32 v2, vcc, s0, v2
; GFX90A-TGSPLIT-NEXT:    v_addc_co_u32_e32 v3, vcc, 0, v3, vcc
; GFX90A-TGSPLIT-NEXT:    flat_load_dword v2, v[2:3] glc slc
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v0, s2
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v1, s3
; GFX90A-TGSPLIT-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-TGSPLIT-NEXT:    flat_store_dword v[0:1], v2
; GFX90A-TGSPLIT-NEXT:    s_endpgm
;
;
    i32* %in, i32* %out) {
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %val.gep = getelementptr inbounds i32, i32* %in, i32 %tid
  %val = load i32, i32* %val.gep, align 4, !nontemporal !0
  store i32 %val, i32* %out
  ret void
}

define amdgpu_kernel void @flat_nontemporal_store_0(
; GFX7-LABEL: flat_nontemporal_store_0:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    flat_load_dword v0, v[0:1]
; GFX7-NEXT:    v_mov_b32_e32 v2, s2
; GFX7-NEXT:    v_mov_b32_e32 v3, s3
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[2:3], v0 glc slc
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_store_0:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-WGP-NEXT:    flat_load_dword v2, v[0:1]
; GFX10-WGP-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2 slc
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_store_0:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-CU-NEXT:    flat_load_dword v2, v[0:1]
; GFX10-CU-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2 slc
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_store_0:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v0, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s1
; SKIP-CACHE-INV-NEXT:    flat_load_dword v0, v[0:1]
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s2
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v3, s3
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[2:3], v0 glc slc
; SKIP-CACHE-INV-NEXT:    s_endpgm
;
; GFX90A-NOTTGSPLIT-LABEL: flat_nontemporal_store_0:
; GFX90A-NOTTGSPLIT:       ; %bb.0: ; %entry
; GFX90A-NOTTGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v0, s0
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v1, s1
; GFX90A-NOTTGSPLIT-NEXT:    flat_load_dword v0, v[0:1]
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v2, s2
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v3, s3
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    flat_store_dword v[2:3], v0 glc slc
; GFX90A-NOTTGSPLIT-NEXT:    s_endpgm
;
; GFX90A-TGSPLIT-LABEL: flat_nontemporal_store_0:
; GFX90A-TGSPLIT:       ; %bb.0: ; %entry
; GFX90A-TGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-TGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v0, s0
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v1, s1
; GFX90A-TGSPLIT-NEXT:    flat_load_dword v0, v[0:1]
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v2, s2
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v3, s3
; GFX90A-TGSPLIT-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-TGSPLIT-NEXT:    flat_store_dword v[2:3], v0 glc slc
; GFX90A-TGSPLIT-NEXT:    s_endpgm
;
;
    i32* %in, i32* %out) {
entry:
  %val = load i32, i32* %in, align 4
  store i32 %val, i32* %out, !nontemporal !0
  ret void
}

define amdgpu_kernel void @flat_nontemporal_store_1(
; GFX7-LABEL: flat_nontemporal_store_1:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX7-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    v_mov_b32_e32 v2, s1
; GFX7-NEXT:    flat_load_dword v2, v[1:2]
; GFX7-NEXT:    v_mov_b32_e32 v1, s3
; GFX7-NEXT:    v_add_i32_e32 v0, vcc, s2, v0
; GFX7-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_store_dword v[0:1], v2 glc slc
; GFX7-NEXT:    s_endpgm
;
; GFX10-WGP-LABEL: flat_nontemporal_store_1:
; GFX10-WGP:       ; %bb.0: ; %entry
; GFX10-WGP-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-WGP-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-WGP-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-WGP-NEXT:    v_mov_b32_e32 v1, s0
; GFX10-WGP-NEXT:    v_mov_b32_e32 v2, s1
; GFX10-WGP-NEXT:    v_add_co_u32_e64 v0, s0, s2, v0
; GFX10-WGP-NEXT:    flat_load_dword v2, v[1:2]
; GFX10-WGP-NEXT:    v_add_co_ci_u32_e64 v1, s0, s3, 0, s0
; GFX10-WGP-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-WGP-NEXT:    flat_store_dword v[0:1], v2 slc
; GFX10-WGP-NEXT:    s_endpgm
;
; GFX10-CU-LABEL: flat_nontemporal_store_1:
; GFX10-CU:       ; %bb.0: ; %entry
; GFX10-CU-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX10-CU-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-CU-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-CU-NEXT:    v_mov_b32_e32 v1, s0
; GFX10-CU-NEXT:    v_mov_b32_e32 v2, s1
; GFX10-CU-NEXT:    v_add_co_u32_e64 v0, s0, s2, v0
; GFX10-CU-NEXT:    flat_load_dword v2, v[1:2]
; GFX10-CU-NEXT:    v_add_co_ci_u32_e64 v1, s0, s3, 0, s0
; GFX10-CU-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX10-CU-NEXT:    flat_store_dword v[0:1], v2 slc
; GFX10-CU-NEXT:    s_endpgm
;
; SKIP-CACHE-INV-LABEL: flat_nontemporal_store_1:
; SKIP-CACHE-INV:       ; %bb.0: ; %entry
; SKIP-CACHE-INV-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SKIP-CACHE-INV-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SKIP-CACHE-INV-NEXT:    s_waitcnt lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s0
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v2, s1
; SKIP-CACHE-INV-NEXT:    flat_load_dword v2, v[1:2]
; SKIP-CACHE-INV-NEXT:    v_mov_b32_e32 v1, s3
; SKIP-CACHE-INV-NEXT:    v_add_i32_e32 v0, vcc, s2, v0
; SKIP-CACHE-INV-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; SKIP-CACHE-INV-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; SKIP-CACHE-INV-NEXT:    flat_store_dword v[0:1], v2 glc slc
; SKIP-CACHE-INV-NEXT:    s_endpgm
;
; GFX90A-NOTTGSPLIT-LABEL: flat_nontemporal_store_1:
; GFX90A-NOTTGSPLIT:       ; %bb.0: ; %entry
; GFX90A-NOTTGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-NOTTGSPLIT-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v2, s0
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v3, s1
; GFX90A-NOTTGSPLIT-NEXT:    flat_load_dword v2, v[2:3]
; GFX90A-NOTTGSPLIT-NEXT:    v_mov_b32_e32 v1, s3
; GFX90A-NOTTGSPLIT-NEXT:    v_add_co_u32_e32 v0, vcc, s2, v0
; GFX90A-NOTTGSPLIT-NEXT:    v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
; GFX90A-NOTTGSPLIT-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX90A-NOTTGSPLIT-NEXT:    flat_store_dword v[0:1], v2 glc slc
; GFX90A-NOTTGSPLIT-NEXT:    s_endpgm
;
; GFX90A-TGSPLIT-LABEL: flat_nontemporal_store_1:
; GFX90A-TGSPLIT:       ; %bb.0: ; %entry
; GFX90A-TGSPLIT-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GFX90A-TGSPLIT-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX90A-TGSPLIT-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v2, s0
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v3, s1
; GFX90A-TGSPLIT-NEXT:    flat_load_dword v2, v[2:3]
; GFX90A-TGSPLIT-NEXT:    v_mov_b32_e32 v1, s3
; GFX90A-TGSPLIT-NEXT:    v_add_co_u32_e32 v0, vcc, s2, v0
; GFX90A-TGSPLIT-NEXT:    v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
; GFX90A-TGSPLIT-NEXT:    s_waitcnt vmcnt(0)
; GFX90A-TGSPLIT-NEXT:    flat_store_dword v[0:1], v2 glc slc
; GFX90A-TGSPLIT-NEXT:    s_endpgm
;
;
    i32* %in, i32* %out) {
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %val = load i32, i32* %in, align 4
  %out.gep = getelementptr inbounds i32, i32* %out, i32 %tid
  store i32 %val, i32* %out.gep, !nontemporal !0
  ret void
}

!0 = !{i32 1}
declare i32 @llvm.amdgcn.workitem.id.x()
