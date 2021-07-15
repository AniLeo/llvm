; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs -o - %s | FileCheck -check-prefix=GCN %s

declare i32 @llvm.cttz.i32(i32, i1) nounwind readnone
declare i32 @llvm.amdgcn.sffbh.i32(i32) nounwind readnone speculatable
define amdgpu_kernel void @select_constant_cttz(i32 addrspace(1)* noalias %out, i32 addrspace(1)* nocapture readonly %arrayidx) nounwind {
; GCN-LABEL: select_constant_cttz:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xb
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_load_dword s2, s[2:3], 0x0
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; GCN-NEXT:    s_mov_b32 s7, 0xf000
; GCN-NEXT:    s_mov_b32 s6, -1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshr_b32 s0, 1, s2
; GCN-NEXT:    s_ff1_i32_b32 s0, s0
; GCN-NEXT:    s_cmp_lg_u32 s2, 0
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    s_cselect_b64 s[2:3], -1, 0
; GCN-NEXT:    v_cndmask_b32_e64 v0, v0, -1, s[2:3]
; GCN-NEXT:    v_ffbh_i32_e32 v1, v0
; GCN-NEXT:    v_cmp_eq_u32_e64 s[0:1], 0, v0
; GCN-NEXT:    v_sub_i32_e32 v0, vcc, 31, v1
; GCN-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; GCN-NEXT:    v_cndmask_b32_e64 v0, v0, -1, s[0:1]
; GCN-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GCN-NEXT:    s_endpgm
  %v    = load i32, i32 addrspace(1)* %arrayidx, align 4
  %sr   = lshr i32 1, %v
  %cmp  = icmp ne i32 %v, 0
  %cttz = call i32 @llvm.cttz.i32(i32 %sr, i1 true), !range !0
  %sel  = select i1 %cmp, i32 -1, i32 %cttz
  %ffbh = call i32 @llvm.amdgcn.sffbh.i32(i32 %sel)
  %sub  = sub i32 31, %ffbh
  %cmp2 = icmp eq i32 %sel, 0
  %or   = or i1 %cmp, %cmp2
  %sel2 = select i1 %or, i32 -1, i32 %sub
  store i32 %sel2, i32 addrspace(1)* %out
  ret void
}

!0 = !{i32 0, i32 33}
