; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 --amdgpu-enable-flat-scratch < %s | FileCheck -check-prefixes=GCN,FLAT_SCR_OPT %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 --mattr=+architected-flat-scratch < %s | FileCheck -check-prefixes=GCN,FLAT_SCR_ARCH %s

declare void @extern_func() #0

define amdgpu_kernel void @stack_object_addrspacecast_in_kernel_no_calls() {
; FLAT_SCR_OPT-LABEL: stack_object_addrspacecast_in_kernel_no_calls:
; FLAT_SCR_OPT:       ; %bb.0:
; FLAT_SCR_OPT-NEXT:    s_add_u32 s0, s0, s3
; FLAT_SCR_OPT-NEXT:    s_addc_u32 s1, s1, 0
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s0
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s1
; FLAT_SCR_OPT-NEXT:    v_mov_b32_e32 v0, 4
; FLAT_SCR_OPT-NEXT:    s_getreg_b32 s0, hwreg(HW_REG_SH_MEM_BASES, 0, 16)
; FLAT_SCR_OPT-NEXT:    v_mov_b32_e32 v2, 0
; FLAT_SCR_OPT-NEXT:    s_lshl_b32 s0, s0, 16
; FLAT_SCR_OPT-NEXT:    v_cmp_ne_u32_e32 vcc_lo, -1, v0
; FLAT_SCR_OPT-NEXT:    v_cndmask_b32_e32 v0, 0, v0, vcc_lo
; FLAT_SCR_OPT-NEXT:    v_cndmask_b32_e64 v1, 0, s0, vcc_lo
; FLAT_SCR_OPT-NEXT:    flat_store_dword v[0:1], v2
; FLAT_SCR_OPT-NEXT:    s_waitcnt_vscnt null, 0x0
; FLAT_SCR_OPT-NEXT:    s_endpgm
;
; FLAT_SCR_ARCH-LABEL: stack_object_addrspacecast_in_kernel_no_calls:
; FLAT_SCR_ARCH:       ; %bb.0:
; FLAT_SCR_ARCH-NEXT:    v_mov_b32_e32 v0, 4
; FLAT_SCR_ARCH-NEXT:    s_getreg_b32 s0, hwreg(HW_REG_SH_MEM_BASES, 0, 16)
; FLAT_SCR_ARCH-NEXT:    v_mov_b32_e32 v2, 0
; FLAT_SCR_ARCH-NEXT:    s_lshl_b32 s0, s0, 16
; FLAT_SCR_ARCH-NEXT:    v_cmp_ne_u32_e32 vcc_lo, -1, v0
; FLAT_SCR_ARCH-NEXT:    v_cndmask_b32_e32 v0, 0, v0, vcc_lo
; FLAT_SCR_ARCH-NEXT:    v_cndmask_b32_e64 v1, 0, s0, vcc_lo
; FLAT_SCR_ARCH-NEXT:    flat_store_dword v[0:1], v2
; FLAT_SCR_ARCH-NEXT:    s_waitcnt_vscnt null, 0x0
; FLAT_SCR_ARCH-NEXT:    s_endpgm
  %alloca = alloca i32, addrspace(5)
  %cast = addrspacecast i32 addrspace(5)* %alloca to i32*
  store volatile i32 0, i32* %cast
  ret void
}

define amdgpu_kernel void @stack_object_in_kernel_no_calls() {
; FLAT_SCR_OPT-LABEL: stack_object_in_kernel_no_calls:
; FLAT_SCR_OPT:       ; %bb.0:
; FLAT_SCR_OPT-NEXT:    s_add_u32 s0, s0, s3
; FLAT_SCR_OPT-NEXT:    s_addc_u32 s1, s1, 0
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s0
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s1
; FLAT_SCR_OPT-NEXT:    v_mov_b32_e32 v0, 0
; FLAT_SCR_OPT-NEXT:    s_mov_b32 vcc_lo, 0
; FLAT_SCR_OPT-NEXT:    scratch_store_dword off, v0, vcc_lo offset:4
; FLAT_SCR_OPT-NEXT:    s_waitcnt_vscnt null, 0x0
; FLAT_SCR_OPT-NEXT:    s_endpgm
;
; FLAT_SCR_ARCH-LABEL: stack_object_in_kernel_no_calls:
; FLAT_SCR_ARCH:       ; %bb.0:
; FLAT_SCR_ARCH-NEXT:    v_mov_b32_e32 v0, 0
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 vcc_lo, 0
; FLAT_SCR_ARCH-NEXT:    scratch_store_dword off, v0, vcc_lo offset:4
; FLAT_SCR_ARCH-NEXT:    s_waitcnt_vscnt null, 0x0
; FLAT_SCR_ARCH-NEXT:    s_endpgm
  %alloca = alloca i32, addrspace(5)
  store volatile i32 0, i32 addrspace(5)* %alloca
  ret void
}

define amdgpu_kernel void @kernel_calls_no_stack() {
; FLAT_SCR_OPT-LABEL: kernel_calls_no_stack:
; FLAT_SCR_OPT:       ; %bb.0:
; FLAT_SCR_OPT-NEXT:    s_add_u32 s6, s6, s11
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s32, 0
; FLAT_SCR_OPT-NEXT:    s_addc_u32 s7, s7, 0
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s6
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s7
; FLAT_SCR_OPT-NEXT:    s_getpc_b64 s[0:1]
; FLAT_SCR_OPT-NEXT:    s_add_u32 s0, s0, extern_func@gotpcrel32@lo+4
; FLAT_SCR_OPT-NEXT:    s_addc_u32 s1, s1, extern_func@gotpcrel32@hi+12
; FLAT_SCR_OPT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; FLAT_SCR_OPT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT_SCR_OPT-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLAT_SCR_OPT-NEXT:    s_endpgm
;
; FLAT_SCR_ARCH-LABEL: kernel_calls_no_stack:
; FLAT_SCR_ARCH:       ; %bb.0:
; FLAT_SCR_ARCH-NEXT:    s_getpc_b64 s[0:1]
; FLAT_SCR_ARCH-NEXT:    s_add_u32 s0, s0, extern_func@gotpcrel32@lo+4
; FLAT_SCR_ARCH-NEXT:    s_addc_u32 s1, s1, extern_func@gotpcrel32@hi+12
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s32, 0
; FLAT_SCR_ARCH-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; FLAT_SCR_ARCH-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT_SCR_ARCH-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLAT_SCR_ARCH-NEXT:    s_endpgm
  call void @extern_func()
  ret void
}

define amdgpu_kernel void @test(i32 addrspace(1)* %out, i32 %in) {
; FLAT_SCR_OPT-LABEL: test:
; FLAT_SCR_OPT:       ; %bb.0:
; FLAT_SCR_OPT-NEXT:    s_add_u32 s2, s2, s5
; FLAT_SCR_OPT-NEXT:    s_addc_u32 s3, s3, 0
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; FLAT_SCR_OPT-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; FLAT_SCR_OPT-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x0
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s104, exec_lo
; FLAT_SCR_OPT-NEXT:    s_mov_b32 exec_lo, 3
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s105, 0
; FLAT_SCR_OPT-NEXT:    scratch_store_dword off, v72, s105
; FLAT_SCR_OPT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT_SCR_OPT-NEXT:    v_writelane_b32 v72, s2, 0
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s105, 4
; FLAT_SCR_OPT-NEXT:    v_writelane_b32 v72, s3, 1
; FLAT_SCR_OPT-NEXT:    scratch_store_dword off, v72, s105 ; 4-byte Folded Spill
; FLAT_SCR_OPT-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s105, 0
; FLAT_SCR_OPT-NEXT:    scratch_load_dword v72, off, s105
; FLAT_SCR_OPT-NEXT:    s_waitcnt vmcnt(0)
; FLAT_SCR_OPT-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_OPT-NEXT:    s_mov_b32 exec_lo, s104
; FLAT_SCR_OPT-NEXT:    s_load_dword vcc_lo, s[0:1], 0x8
; FLAT_SCR_OPT-NEXT:    ; kill: killed $sgpr0_sgpr1
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT_SCR_OPT-NEXT:    v_mov_b32_e32 v0, vcc_lo
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    ;;#ASMSTART
; FLAT_SCR_OPT-NEXT:    ;;#ASMEND
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s2, exec_lo
; FLAT_SCR_OPT-NEXT:    s_mov_b32 exec_lo, 3
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s3, 0
; FLAT_SCR_OPT-NEXT:    scratch_store_dword off, v2, s3
; FLAT_SCR_OPT-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s3, 4
; FLAT_SCR_OPT-NEXT:    scratch_load_dword v2, off, s3 ; 4-byte Folded Reload
; FLAT_SCR_OPT-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_OPT-NEXT:    s_mov_b32 s3, 0
; FLAT_SCR_OPT-NEXT:    s_waitcnt vmcnt(0)
; FLAT_SCR_OPT-NEXT:    v_readlane_b32 s0, v2, 0
; FLAT_SCR_OPT-NEXT:    v_readlane_b32 s1, v2, 1
; FLAT_SCR_OPT-NEXT:    scratch_load_dword v2, off, s3
; FLAT_SCR_OPT-NEXT:    s_waitcnt vmcnt(0)
; FLAT_SCR_OPT-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_OPT-NEXT:    s_mov_b32 exec_lo, s2
; FLAT_SCR_OPT-NEXT:    v_mov_b32_e32 v1, 0
; FLAT_SCR_OPT-NEXT:    global_store_dword v1, v0, s[0:1]
; FLAT_SCR_OPT-NEXT:    s_endpgm
;
; FLAT_SCR_ARCH-LABEL: test:
; FLAT_SCR_ARCH:       ; %bb.0:
; FLAT_SCR_ARCH-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x0
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s104, exec_lo
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 exec_lo, 3
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s105, 0
; FLAT_SCR_ARCH-NEXT:    scratch_store_dword off, v72, s105
; FLAT_SCR_ARCH-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT_SCR_ARCH-NEXT:    v_writelane_b32 v72, s2, 0
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s105, 4
; FLAT_SCR_ARCH-NEXT:    v_writelane_b32 v72, s3, 1
; FLAT_SCR_ARCH-NEXT:    scratch_store_dword off, v72, s105 ; 4-byte Folded Spill
; FLAT_SCR_ARCH-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s105, 0
; FLAT_SCR_ARCH-NEXT:    scratch_load_dword v72, off, s105
; FLAT_SCR_ARCH-NEXT:    s_waitcnt vmcnt(0)
; FLAT_SCR_ARCH-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 exec_lo, s104
; FLAT_SCR_ARCH-NEXT:    s_load_dword vcc_lo, s[0:1], 0x8
; FLAT_SCR_ARCH-NEXT:    ; kill: killed $sgpr0_sgpr1
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT_SCR_ARCH-NEXT:    v_mov_b32_e32 v0, vcc_lo
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    ;;#ASMSTART
; FLAT_SCR_ARCH-NEXT:    ;;#ASMEND
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s2, exec_lo
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 exec_lo, 3
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s3, 0
; FLAT_SCR_ARCH-NEXT:    scratch_store_dword off, v2, s3
; FLAT_SCR_ARCH-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s3, 4
; FLAT_SCR_ARCH-NEXT:    scratch_load_dword v2, off, s3 ; 4-byte Folded Reload
; FLAT_SCR_ARCH-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 s3, 0
; FLAT_SCR_ARCH-NEXT:    s_waitcnt vmcnt(0)
; FLAT_SCR_ARCH-NEXT:    v_readlane_b32 s0, v2, 0
; FLAT_SCR_ARCH-NEXT:    v_readlane_b32 s1, v2, 1
; FLAT_SCR_ARCH-NEXT:    scratch_load_dword v2, off, s3
; FLAT_SCR_ARCH-NEXT:    s_waitcnt vmcnt(0)
; FLAT_SCR_ARCH-NEXT:    s_waitcnt_depctr 0xffe3
; FLAT_SCR_ARCH-NEXT:    s_mov_b32 exec_lo, s2
; FLAT_SCR_ARCH-NEXT:    v_mov_b32_e32 v1, 0
; FLAT_SCR_ARCH-NEXT:    global_store_dword v1, v0, s[0:1]
; FLAT_SCR_ARCH-NEXT:    s_endpgm
  call void asm sideeffect "", "~{s[0:7]}" ()
  call void asm sideeffect "", "~{s[8:15]}" ()
  call void asm sideeffect "", "~{s[16:23]}" ()
  call void asm sideeffect "", "~{s[24:31]}" ()
  call void asm sideeffect "", "~{s[32:39]}" ()
  call void asm sideeffect "", "~{s[40:47]}" ()
  call void asm sideeffect "", "~{s[48:55]}" ()
  call void asm sideeffect "", "~{s[56:63]}" ()
  call void asm sideeffect "", "~{s[64:71]}" ()
  call void asm sideeffect "", "~{s[72:79]}" ()
  call void asm sideeffect "", "~{s[80:87]}" ()
  call void asm sideeffect "", "~{s[88:95]}" ()
  call void asm sideeffect "", "~{s[96:103]}" ()
  call void asm sideeffect "", "~{s[104:105]}" ()
  call void asm sideeffect "", "~{v[0:7]}" ()
  call void asm sideeffect "", "~{v[8:15]}" ()
  call void asm sideeffect "", "~{v[16:23]}" ()
  call void asm sideeffect "", "~{v[24:31]}" ()
  call void asm sideeffect "", "~{v[32:39]}" ()
  call void asm sideeffect "", "~{v[40:47]}" ()
  call void asm sideeffect "", "~{v[48:55]}" ()
  call void asm sideeffect "", "~{v[56:63]}" ()
  call void asm sideeffect "", "~{v[64:71]}" ()
  call void asm sideeffect "", "~{v[72:79]}" ()
  call void asm sideeffect "", "~{v[80:87]}" ()
  call void asm sideeffect "", "~{v[88:95]}" ()
  call void asm sideeffect "", "~{v[96:103]}" ()
  call void asm sideeffect "", "~{v[104:111]}" ()
  call void asm sideeffect "", "~{v[112:119]}" ()
  call void asm sideeffect "", "~{v[120:127]}" ()
  call void asm sideeffect "", "~{v[128:135]}" ()
  call void asm sideeffect "", "~{v[136:143]}" ()
  call void asm sideeffect "", "~{v[144:151]}" ()
  call void asm sideeffect "", "~{v[152:159]}" ()
  call void asm sideeffect "", "~{v[160:167]}" ()
  call void asm sideeffect "", "~{v[168:175]}" ()
  call void asm sideeffect "", "~{v[176:183]}" ()
  call void asm sideeffect "", "~{v[184:191]}" ()
  call void asm sideeffect "", "~{v[192:199]}" ()
  call void asm sideeffect "", "~{v[200:207]}" ()
  call void asm sideeffect "", "~{v[208:215]}" ()
  call void asm sideeffect "", "~{v[216:223]}" ()
  call void asm sideeffect "", "~{v[224:231]}" ()
  call void asm sideeffect "", "~{v[232:239]}" ()
  call void asm sideeffect "", "~{v[240:247]}" ()
  call void asm sideeffect "", "~{v[248:255]}" ()

  store i32 %in, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @kernel_no_calls_no_stack() {
; GCN-LABEL: kernel_no_calls_no_stack:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_endpgm
  ret void
}

attributes #0 = { nounwind }
