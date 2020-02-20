; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck --check-prefix=GCN %s

define weak_odr amdgpu_kernel void @test_mul24_knownbits_kernel(float addrspace(1)* %p) #4 {
; GCN-LABEL: test_mul24_knownbits_kernel:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    v_and_b32_e32 v0, 3, v0
; GCN-NEXT:    v_mul_i32_i24_e32 v0, -5, v0
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GCN-NEXT:    v_and_b32_e32 v0, 0xffffffe0, v0
; GCN-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; GCN-NEXT:    v_lshlrev_b64 v[0:1], 2, v[0:1]
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v2, s1
; GCN-NEXT:    v_add_co_u32_e32 v0, vcc, s0, v0
; GCN-NEXT:    v_addc_co_u32_e32 v1, vcc, v2, v1, vcc
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    global_store_dword v[0:1], v2, off
; GCN-NEXT:    s_endpgm
entry:
  %0 = tail call i32 @llvm.amdgcn.workitem.id.x() #28, !range !4
  %tid = and i32 %0, 3
  %1 = mul nsw i32 %tid, -5
  %v1 = and i32 %1, -32
  %v2 = sext i32 %v1 to i64
  %v3 = getelementptr inbounds float, float addrspace(1)* %p, i64 %v2
  store float 0.000, float addrspace(1)* %v3, align 4
  ret void
}

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.amdgcn.workitem.id.x() #20

!4 = !{i32 0, i32 1024}
