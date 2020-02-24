; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Check that no attributes are added to graphics functions
; RUN: opt -S -mtriple=amdgcn-amd-amdpal -amdgpu-annotate-kernel-features  %s | FileCheck -check-prefix=GCN %s

; Check that it doesn't crash
; RUN: llc -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 < %s | FileCheck -check-prefixes=GFX9 %s
; RUN: llc -mtriple=amdgcn-amd-amdpal -mcpu=gfx1010 < %s | FileCheck -check-prefixes=GFX10 %s

target datalayout = "A5"

define amdgpu_cs void @test_simple_indirect_call() {
; GCN-LABEL: define amdgpu_cs void @test_simple_indirect_call() {
; GFX9-LABEL: test_simple_indirect_call:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_getpc_b64 s[36:37]
; GFX9-NEXT:    s_mov_b32 s36, s0
; GFX9-NEXT:    s_load_dwordx4 s[36:39], s[36:37], 0x10
; GFX9-NEXT:    s_getpc_b64 s[4:5]
; GFX9-NEXT:    s_mov_b32 s32, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_add_u32 s36, s36, s0
; GFX9-NEXT:    s_addc_u32 s37, s37, 0
; GFX9-NEXT:    s_mov_b64 s[0:1], s[36:37]
; GFX9-NEXT:    s_mov_b64 s[2:3], s[38:39]
; GFX9-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: test_simple_indirect_call:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_getpc_b64 s[36:37]
; GFX10-NEXT:    s_mov_b32 s36, s0
; GFX10-NEXT:    s_getpc_b64 s[4:5]
; GFX10-NEXT:    s_load_dwordx4 s[36:39], s[36:37], 0x10
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_bitset0_b32 s39, 21
; GFX10-NEXT:    s_mov_b32 s32, 0
; GFX10-NEXT:    s_add_u32 s36, s36, s0
; GFX10-NEXT:    s_addc_u32 s37, s37, 0
; GFX10-NEXT:    s_mov_b64 s[0:1], s[36:37]
; GFX10-NEXT:    s_mov_b64 s[2:3], s[38:39]
; GFX10-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GFX10-NEXT:    s_endpgm


  %pc = call i64 @llvm.amdgcn.s.getpc()
  %fun = inttoptr i64 %pc to void()*
  call amdgpu_gfx void %fun()
  ret void
}

; Function Attrs: nounwind readnone speculatable willreturn
declare i64 @llvm.amdgcn.s.getpc() #0

attributes #0 = { nounwind readnone speculatable willreturn }
