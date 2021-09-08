; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx908 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GFX908 %s

; Make sure there are no v_accvgpr_read_b32 copying back and forth
; between AGPR and VGPR.
define amdgpu_kernel void @remat_constant_voids_spill(i32 addrspace(1)* %p) #1 {
; GFX908-LABEL: remat_constant_voids_spill:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    v_accvgpr_write_b32 a1, 1
; GFX908-NEXT:    v_accvgpr_write_b32 a5, 6
; GFX908-NEXT:    v_accvgpr_write_b32 a6, 7
; GFX908-NEXT:    v_accvgpr_write_b32 a7, 8
; GFX908-NEXT:    v_accvgpr_write_b32 a0, 9
; GFX908-NEXT:    v_accvgpr_write_b32 a2, 2
; GFX908-NEXT:    v_accvgpr_write_b32 a3, 3
; GFX908-NEXT:    v_accvgpr_write_b32 a4, 4
; GFX908-NEXT:    ;;#ASMSTART
; GFX908-NEXT:    ;;#ASMEND
; GFX908-NEXT:    v_accvgpr_write_b32 a1, 5
; GFX908-NEXT:    ;;#ASMSTART
; GFX908-NEXT:    ;;#ASMEND
; GFX908-NEXT:    s_endpgm
  call void asm sideeffect "", "a,a,a,a"(i32 1, i32 2, i32 3, i32 4)
  call void asm sideeffect "", "a,a,a,a,a"(i32 5, i32 6, i32 7, i32 8, i32 9)
  ret void
}

define void @remat_regcopy_avoids_spill(i32 %v0, i32 %v1, i32 %v2, i32 %v3, i32 %v4, i32 %v5, i32 %v6, i32 %v7, i32 %v8, i32 %v9, i32 %v10) #1 {
; GFX908-LABEL: remat_regcopy_avoids_spill:
; GFX908:       ; %bb.0:
; GFX908-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX908-NEXT:    v_accvgpr_write_b32 a1, v0
; GFX908-NEXT:    v_accvgpr_write_b32 a2, v1
; GFX908-NEXT:    v_accvgpr_write_b32 a3, v2
; GFX908-NEXT:    v_accvgpr_write_b32 a4, v3
; GFX908-NEXT:    v_accvgpr_write_b32 a0, v8
; GFX908-NEXT:    ;;#ASMSTART
; GFX908-NEXT:    ;;#ASMEND
; GFX908-NEXT:    v_accvgpr_write_b32 a1, v4
; GFX908-NEXT:    v_accvgpr_write_b32 a2, v5
; GFX908-NEXT:    v_accvgpr_write_b32 a3, v6
; GFX908-NEXT:    v_accvgpr_write_b32 a4, v7
; GFX908-NEXT:    ;;#ASMSTART
; GFX908-NEXT:    ;;#ASMEND
; GFX908-NEXT:    s_setpc_b64 s[30:31]
  call void asm sideeffect "", "a,a,a,a"(i32 %v0, i32 %v1, i32 %v2, i32 %v3)
  call void asm sideeffect "", "a,a,a,a,a"(i32 %v4, i32 %v5, i32 %v6, i32 %v7, i32 %v8)
  ret void
}

attributes #1 = { nounwind "amdgpu-num-vgpr"="8" }
