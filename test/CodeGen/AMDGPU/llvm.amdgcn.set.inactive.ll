; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -march=amdgcn -mcpu=tonga -mattr=-flat-for-global -early-live-intervals -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

define amdgpu_kernel void @set_inactive(i32 addrspace(1)* %out, i32 %in) {
; GCN-LABEL: set_inactive:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    s_not_b64 exec, exec
; GCN-NEXT:    v_mov_b32_e32 v0, 42
; GCN-NEXT:    s_not_b64 exec, exec
; GCN-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
  %tmp = call i32 @llvm.amdgcn.set.inactive.i32(i32 %in, i32 42) #0
  store i32 %tmp, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @set_inactive_64(i64 addrspace(1)* %out, i64 %in) {
; GCN-LABEL: set_inactive_64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GCN-NEXT:    s_mov_b32 s7, 0xf000
; GCN-NEXT:    s_mov_b32 s6, -1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s4, s0
; GCN-NEXT:    s_mov_b32 s5, s1
; GCN-NEXT:    v_mov_b32_e32 v0, s2
; GCN-NEXT:    v_mov_b32_e32 v1, s3
; GCN-NEXT:    s_not_b64 exec, exec
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    s_not_b64 exec, exec
; GCN-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; GCN-NEXT:    s_endpgm
  %tmp = call i64 @llvm.amdgcn.set.inactive.i64(i64 %in, i64 0) #0
  store i64 %tmp, i64 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @set_inactive_scc(i32 addrspace(1)* %out, i32 %in, <4 x i32> inreg %desc) {
; GCN-LABEL: set_inactive_scc:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; GCN-NEXT:    s_load_dword s2, s[0:1], 0x2c
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_buffer_load_dword s3, s[4:7], 0x0
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GCN-NEXT:    v_mov_b32_e32 v0, s2
; GCN-NEXT:    s_not_b64 exec, exec
; GCN-NEXT:    v_mov_b32_e32 v0, 42
; GCN-NEXT:    s_not_b64 exec, exec
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s3, 56
; GCN-NEXT:    s_mov_b64 s[2:3], -1
; GCN-NEXT:    s_cbranch_scc1 .LBB2_3
; GCN-NEXT:  ; %bb.1: ; %Flow
; GCN-NEXT:    s_andn2_b64 vcc, exec, s[2:3]
; GCN-NEXT:    s_cbranch_vccz .LBB2_4
; GCN-NEXT:  .LBB2_2: ; %.exit
; GCN-NEXT:    s_endpgm
; GCN-NEXT:  .LBB2_3: ; %.one
; GCN-NEXT:    v_add_u32_e32 v1, vcc, 1, v0
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    buffer_store_dword v1, off, s[0:3], 0
; GCN-NEXT:    s_mov_b64 s[2:3], 0
; GCN-NEXT:    s_cbranch_execnz .LBB2_2
; GCN-NEXT:  .LBB2_4: ; %.zero
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
  %val = call i32 @llvm.amdgcn.s.buffer.load.i32(<4 x i32> %desc, i32 0, i32 0)
  %cmp = icmp eq i32 %val, 56
  %tmp = call i32 @llvm.amdgcn.set.inactive.i32(i32 %in, i32 42) #0
  br i1 %cmp, label %.zero, label %.one

.zero:
  store i32 %tmp, i32 addrspace(1)* %out
  br label %.exit

.one:
  %tmp.1 = add i32 %tmp, 1
  store i32 %tmp.1, i32 addrspace(1)* %out
  br label %.exit

.exit:
  ret void
}

declare i32 @llvm.amdgcn.set.inactive.i32(i32, i32) #0
declare i64 @llvm.amdgcn.set.inactive.i64(i64, i64) #0
declare i32 @llvm.amdgcn.s.buffer.load.i32(<4 x i32>, i32, i32)

attributes #0 = { convergent readnone }
