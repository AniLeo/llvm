; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -o - %s | FileCheck -check-prefix=GCN %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -o - %s | FileCheck -check-prefix=GFX10 %s

define i8 addrspace(1)* @v_ptrmask_global_variable_i64(i8 addrspace(1)* %ptr, i64 %mask) {
; GCN-LABEL: v_ptrmask_global_variable_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v1, v1, v3
; GCN-NEXT:    v_and_b32_e32 v0, v0, v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ptrmask_global_variable_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v0, v0, v2
; GFX10-NEXT:    v_and_b32_e32 v1, v1, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %masked = call i8 addrspace(1)* @llvm.ptrmask.p1i8.i64(i8 addrspace(1)* %ptr, i64 %mask)
  ret i8 addrspace(1)* %masked
}

define i8 addrspace(1)* @v_ptrmask_global_variable_i32(i8 addrspace(1)* %ptr, i32 %mask) {
; GCN-LABEL: v_ptrmask_global_variable_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v0, v0, v2
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ptrmask_global_variable_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v0, v0, v2
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %masked = call i8 addrspace(1)* @llvm.ptrmask.p1i8.i32(i8 addrspace(1)* %ptr, i32 %mask)
  ret i8 addrspace(1)* %masked
}

define i8 addrspace(1)* @v_ptrmask_global_variable_i16(i8 addrspace(1)* %ptr, i16 %mask) {
; GCN-LABEL: v_ptrmask_global_variable_i16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ptrmask_global_variable_i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_sdwa v0, v0, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %masked = call i8 addrspace(1)* @llvm.ptrmask.p1i8.i16(i8 addrspace(1)* %ptr, i16 %mask)
  ret i8 addrspace(1)* %masked
}

define i8 addrspace(3)* @v_ptrmask_local_variable_i64(i8 addrspace(3)* %ptr, i64 %mask) {
; GCN-LABEL: v_ptrmask_local_variable_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ptrmask_local_variable_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v0, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i64(i8 addrspace(3)* %ptr, i64 %mask)
  ret i8 addrspace(3)* %masked
}

define i8 addrspace(3)* @v_ptrmask_local_variable_i32(i8 addrspace(3)* %ptr, i32 %mask) {
; GCN-LABEL: v_ptrmask_local_variable_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ptrmask_local_variable_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v0, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i32(i8 addrspace(3)* %ptr, i32 %mask)
  ret i8 addrspace(3)* %masked
}

define i8 addrspace(3)* @v_ptrmask_local_variable_i16(i8 addrspace(3)* %ptr, i16 %mask) {
; GCN-LABEL: v_ptrmask_local_variable_i16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ptrmask_local_variable_i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_sdwa v0, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i16(i8 addrspace(3)* %ptr, i16 %mask)
  ret i8 addrspace(3)* %masked
}

define amdgpu_ps i8 addrspace(1)* @s_ptrmask_global_variable_i64(i8 addrspace(1)* inreg %ptr, i64 inreg %mask) {
; GCN-LABEL: s_ptrmask_global_variable_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_and_b64 s[0:1], s[2:3], s[4:5]
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ptrmask_global_variable_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_and_b64 s[0:1], s[2:3], s[4:5]
; GFX10-NEXT:    ; return to shader part epilog
  %masked = call i8 addrspace(1)* @llvm.ptrmask.p1i8.i64(i8 addrspace(1)* %ptr, i64 %mask)
  ret i8 addrspace(1)* %masked
}

define amdgpu_ps i8 addrspace(1)* @s_ptrmask_global_variable_i32(i8 addrspace(1)* inreg %ptr, i32 inreg %mask) {
; GCN-LABEL: s_ptrmask_global_variable_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s5, 0
; GCN-NEXT:    s_and_b64 s[0:1], s[2:3], s[4:5]
; GCN-NEXT:    s_mov_b32 s1, 0
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ptrmask_global_variable_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s5, 0
; GFX10-NEXT:    s_and_b64 s[0:1], s[2:3], s[4:5]
; GFX10-NEXT:    s_mov_b32 s1, 0
; GFX10-NEXT:    ; return to shader part epilog
  %masked = call i8 addrspace(1)* @llvm.ptrmask.p1i8.i32(i8 addrspace(1)* %ptr, i32 %mask)
  ret i8 addrspace(1)* %masked
}

define amdgpu_ps i8 addrspace(1)* @s_ptrmask_global_variable_i16(i8 addrspace(1)* inreg %ptr, i16 inreg %mask) {
; GCN-LABEL: s_ptrmask_global_variable_i16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_and_b32 s0, s4, 0xffff
; GCN-NEXT:    s_mov_b32 s1, 0
; GCN-NEXT:    s_and_b64 s[0:1], s[2:3], s[0:1]
; GCN-NEXT:    s_mov_b32 s1, 0
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ptrmask_global_variable_i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s1, 0
; GFX10-NEXT:    s_and_b32 s0, s4, 0xffff
; GFX10-NEXT:    s_and_b64 s[0:1], s[2:3], s[0:1]
; GFX10-NEXT:    s_mov_b32 s1, 0
; GFX10-NEXT:    ; return to shader part epilog
  %masked = call i8 addrspace(1)* @llvm.ptrmask.p1i8.i16(i8 addrspace(1)* %ptr, i16 %mask)
  ret i8 addrspace(1)* %masked
}

define amdgpu_ps i8 addrspace(3)* @s_ptrmask_local_variable_i64(i8 addrspace(3)* inreg %ptr, i64 inreg %mask) {
; GCN-LABEL: s_ptrmask_local_variable_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_and_b32 s0, s2, s3
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ptrmask_local_variable_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_and_b32 s0, s2, s3
; GFX10-NEXT:    ; return to shader part epilog
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i64(i8 addrspace(3)* %ptr, i64 %mask)
  ret i8 addrspace(3)* %masked
}

define amdgpu_ps i8 addrspace(3)* @s_ptrmask_local_variable_i32(i8 addrspace(3)* inreg %ptr, i32 inreg %mask) {
; GCN-LABEL: s_ptrmask_local_variable_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_and_b32 s0, s2, s3
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ptrmask_local_variable_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_and_b32 s0, s2, s3
; GFX10-NEXT:    ; return to shader part epilog
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i32(i8 addrspace(3)* %ptr, i32 %mask)
  ret i8 addrspace(3)* %masked
}

define amdgpu_ps i8 addrspace(3)* @s_ptrmask_local_variable_i16(i8 addrspace(3)* inreg %ptr, i16 inreg %mask) {
; GCN-LABEL: s_ptrmask_local_variable_i16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_and_b32 s0, 0xffff, s3
; GCN-NEXT:    s_and_b32 s0, s2, s0
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ptrmask_local_variable_i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_and_b32 s0, 0xffff, s3
; GFX10-NEXT:    s_and_b32 s0, s2, s0
; GFX10-NEXT:    ; return to shader part epilog
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i16(i8 addrspace(3)* %ptr, i16 %mask)
  ret i8 addrspace(3)* %masked
}

declare i8 addrspace(3)* @llvm.ptrmask.p3i8.i64(i8 addrspace(3)*, i64) #0
declare i8 addrspace(3)* @llvm.ptrmask.p3i8.i32(i8 addrspace(3)*, i32) #0
declare i8 addrspace(3)* @llvm.ptrmask.p3i8.i16(i8 addrspace(3)*, i16) #0
declare i8 addrspace(1)* @llvm.ptrmask.p1i8.i64(i8 addrspace(1)*, i64) #0
declare i8 addrspace(1)* @llvm.ptrmask.p1i8.i32(i8 addrspace(1)*, i32) #0
declare i8 addrspace(1)* @llvm.ptrmask.p1i8.i16(i8 addrspace(1)*, i16) #0

attributes #0 = { nounwind readnone speculatable willreturn }
