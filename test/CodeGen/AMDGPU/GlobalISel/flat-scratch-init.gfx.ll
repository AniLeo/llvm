; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mattr=+enable-flat-scratch -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 < %s | FileCheck -check-prefix=MESA %s
; RUN: llc -global-isel -mattr=+enable-flat-scratch -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 < %s | FileCheck -check-prefix=PAL %s

; Test that the initialization for flat_scratch doesn't crash.  PAL
; doesn't add a user SGPR for initializing flat_scratch, mesa does
; (although this probably isn't actually defined).

define amdgpu_ps void @amdgpu_ps() {
; MESA-LABEL: amdgpu_ps:
; MESA:       ; %bb.0:
; MESA-NEXT:    s_add_u32 flat_scratch_lo, s2, s4
; MESA-NEXT:    s_getreg_b32 s0, hwreg(HW_REG_SH_MEM_BASES, 0, 16)
; MESA-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; MESA-NEXT:    s_lshl_b32 s0, s0, 16
; MESA-NEXT:    v_mov_b32_e32 v0, 4
; MESA-NEXT:    v_mov_b32_e32 v1, s0
; MESA-NEXT:    v_mov_b32_e32 v2, 0
; MESA-NEXT:    flat_store_dword v[0:1], v2
; MESA-NEXT:    s_waitcnt vmcnt(0)
; MESA-NEXT:    s_endpgm
;
; PAL-LABEL: amdgpu_ps:
; PAL:       ; %bb.0:
; PAL-NEXT:    s_getpc_b64 s[2:3]
; PAL-NEXT:    s_mov_b32 s2, s0
; PAL-NEXT:    s_load_dwordx2 s[2:3], s[2:3], 0x0
; PAL-NEXT:    v_mov_b32_e32 v0, 4
; PAL-NEXT:    v_mov_b32_e32 v2, 0
; PAL-NEXT:    s_waitcnt lgkmcnt(0)
; PAL-NEXT:    s_and_b32 s3, s3, 0xffff
; PAL-NEXT:    s_add_u32 flat_scratch_lo, s2, s0
; PAL-NEXT:    s_getreg_b32 s0, hwreg(HW_REG_SH_MEM_BASES, 0, 16)
; PAL-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; PAL-NEXT:    s_lshl_b32 s0, s0, 16
; PAL-NEXT:    v_mov_b32_e32 v1, s0
; PAL-NEXT:    flat_store_dword v[0:1], v2
; PAL-NEXT:    s_waitcnt vmcnt(0)
; PAL-NEXT:    s_endpgm
  %alloca = alloca i32, addrspace(5)
  %cast = addrspacecast i32 addrspace(5)* %alloca to i32*
  store volatile i32 0, i32* %cast
  ret void
}

