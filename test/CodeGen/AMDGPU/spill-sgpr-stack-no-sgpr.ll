; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx1010 -mattr=-wavefrontsize32,+wavefrontsize64 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

; Spill an SGPR to scratch without having spare SGPRs available to save exec

define amdgpu_kernel void @test() #1 {
; GFX10-LABEL: test:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s8, SCRATCH_RSRC_DWORD0
; GFX10-NEXT:    s_mov_b32 s9, SCRATCH_RSRC_DWORD1
; GFX10-NEXT:    s_mov_b32 s10, -1
; GFX10-NEXT:    s_mov_b32 s11, 0x31e16000
; GFX10-NEXT:    s_add_u32 s8, s8, s1
; GFX10-NEXT:    s_addc_u32 s9, s9, 0
; GFX10-NEXT:    ;;#ASMSTART
; GFX10-NEXT:    ; def s[0:7]
; GFX10-NEXT:    ;;#ASMEND
; GFX10-NEXT:    ;;#ASMSTART
; GFX10-NEXT:    ; def s[8:12]
; GFX10-NEXT:    ;;#ASMEND
; GFX10-NEXT:    s_not_b64 exec, exec
; GFX10-NEXT:    buffer_store_dword v0, off, s[8:11], 0
; GFX10-NEXT:    v_writelane_b32 v0, s8, 0
; GFX10-NEXT:    v_writelane_b32 v0, s9, 1
; GFX10-NEXT:    v_writelane_b32 v0, s10, 2
; GFX10-NEXT:    v_writelane_b32 v0, s11, 3
; GFX10-NEXT:    v_writelane_b32 v0, s12, 4
; GFX10-NEXT:    buffer_store_dword v0, off, s[8:11], 0 offset:4 ; 4-byte Folded Spill
; GFX10-NEXT:    s_waitcnt_depctr 0xffe3
; GFX10-NEXT:    s_not_b64 exec, exec
; GFX10-NEXT:    buffer_store_dword v0, off, s[8:11], 0 offset:4 ; 4-byte Folded Spill
; GFX10-NEXT:    s_waitcnt_depctr 0xffe3
; GFX10-NEXT:    s_not_b64 exec, exec
; GFX10-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_waitcnt_depctr 0xffe3
; GFX10-NEXT:    s_not_b64 exec, exec
; GFX10-NEXT:    ;;#ASMSTART
; GFX10-NEXT:    ;;#ASMEND
; GFX10-NEXT:    ;;#ASMSTART
; GFX10-NEXT:    ; use s[0:7]
; GFX10-NEXT:    ;;#ASMEND
; GFX10-NEXT:    s_mov_b64 s[6:7], exec
; GFX10-NEXT:    s_mov_b64 exec, 31
; GFX10-NEXT:    buffer_store_dword v0, off, s[8:11], 0
; GFX10-NEXT:    buffer_load_dword v0, off, s[8:11], 0 offset:4 ; 4-byte Folded Reload
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_readlane_b32 s0, v0, 0
; GFX10-NEXT:    v_readlane_b32 s1, v0, 1
; GFX10-NEXT:    v_readlane_b32 s2, v0, 2
; GFX10-NEXT:    v_readlane_b32 s3, v0, 3
; GFX10-NEXT:    v_readlane_b32 s4, v0, 4
; GFX10-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_waitcnt_depctr 0xffe3
; GFX10-NEXT:    s_mov_b64 exec, s[6:7]
; GFX10-NEXT:    ;;#ASMSTART
; GFX10-NEXT:    ; use s[0:4]
; GFX10-NEXT:    ;;#ASMEND
; GFX10-NEXT:    s_endpgm
  %wide.sgpr0 = call <8 x i32> asm sideeffect "; def $0", "={s[0:7]}" () #0
  %wide.sgpr2 = call <5 x i32> asm sideeffect "; def $0", "={s[8:12]}" () #0
  call void asm sideeffect "", "~{v[0:7]}" () #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr0) #0
  call void asm sideeffect "; use $0", "s"(<5 x i32> %wide.sgpr2) #0
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind "amdgpu-num-sgpr"="16" "amdgpu-num-vgpr"="8" }
