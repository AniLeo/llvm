; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

@lds = internal addrspace(3) global [576 x double] undef, align 16

; Stores to the same address appear multiple places in the same
; block. When sorted by offset, the merges would fail. We should form
; two groupings of ds_write2_b64 on either side of the fence.
define amdgpu_kernel void @same_address_fence_merge_write2() #0 {
; GCN-LABEL: same_address_fence_merge_write2:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_mov_b32 s0, 0
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 3, v0
; GCN-NEXT:    s_mov_b32 s1, 0x40100000
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    v_add_u32_e32 v3, 0x840, v2
; GCN-NEXT:    v_add_u32_e32 v4, 0xc60, v2
; GCN-NEXT:    ds_write2_b64 v2, v[0:1], v[0:1] offset1:66
; GCN-NEXT:    ds_write2_b64 v2, v[0:1], v[0:1] offset0:132 offset1:198
; GCN-NEXT:    ds_write2_b64 v3, v[0:1], v[0:1] offset1:66
; GCN-NEXT:    ds_write2_b64 v4, v[0:1], v[0:1] offset1:66
; GCN-NEXT:    s_mov_b32 s1, 0x3ff00000
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_barrier
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ds_write2_b64 v2, v[0:1], v[0:1] offset1:66
; GCN-NEXT:    ds_write2_b64 v2, v[0:1], v[0:1] offset0:132 offset1:198
; GCN-NEXT:    ds_write2_b64 v3, v[0:1], v[0:1] offset1:66
; GCN-NEXT:    ds_write2_b64 v4, v[0:1], v[0:1] offset1:66
; GCN-NEXT:    s_endpgm
bb:
  %tmp = tail call i32 @llvm.amdgcn.workitem.id.x(), !range !0
  %tmp1 = getelementptr inbounds [576 x double], [576 x double] addrspace(3)* @lds, i32 0, i32 %tmp
  store double 4.000000e+00, double addrspace(3)* %tmp1, align 8
  %tmp2 = getelementptr inbounds double, double addrspace(3)* %tmp1, i32 66
  store double 4.000000e+00, double addrspace(3)* %tmp2, align 8
  %tmp3 = getelementptr inbounds double, double addrspace(3)* %tmp1, i32 132
  store double 4.000000e+00, double addrspace(3)* %tmp3, align 8
  %tmp4 = getelementptr inbounds double, double addrspace(3)* %tmp1, i32 198
  store double 4.000000e+00, double addrspace(3)* %tmp4, align 8
  %tmp5 = getelementptr inbounds double, double addrspace(3)* %tmp1, i32 264
  store double 4.000000e+00, double addrspace(3)* %tmp5, align 8
  %tmp6 = getelementptr inbounds double, double addrspace(3)* %tmp1, i32 330
  store double 4.000000e+00, double addrspace(3)* %tmp6, align 8
  %tmp7 = getelementptr inbounds double, double addrspace(3)* %tmp1, i32 396
  store double 4.000000e+00, double addrspace(3)* %tmp7, align 8
  %tmp8 = getelementptr inbounds double, double addrspace(3)* %tmp1, i32 462
  store double 4.000000e+00, double addrspace(3)* %tmp8, align 8
  fence syncscope("workgroup") release
  tail call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  store double 1.000000e+00, double addrspace(3)* %tmp1, align 8
  store double 1.000000e+00, double addrspace(3)* %tmp2, align 8
  store double 1.000000e+00, double addrspace(3)* %tmp3, align 8
  store double 1.000000e+00, double addrspace(3)* %tmp4, align 8
  store double 1.000000e+00, double addrspace(3)* %tmp5, align 8
  store double 1.000000e+00, double addrspace(3)* %tmp6, align 8
  store double 1.000000e+00, double addrspace(3)* %tmp7, align 8
  store double 1.000000e+00, double addrspace(3)* %tmp8, align 8
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #0
declare void @llvm.amdgcn.s.barrier() #1

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { convergent nounwind }

!0 = !{i32 0, i32 1024}
