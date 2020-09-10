; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: opt -S -codegenprepare -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1030 < %s | FileCheck -check-prefix=OPT %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1030 < %s | FileCheck -check-prefix=GCN %s

; Make sure we match the addressing mode offset of csub intrinsics across blocks.

define amdgpu_kernel void @test_sink_small_offset_global_atomic_csub_i32(i32 addrspace(1)* %out, i32 addrspace(1)* %in) {
; OPT-LABEL: @test_sink_small_offset_global_atomic_csub_i32(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[OUT_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[OUT:%.*]], i32 999999
; OPT-NEXT:    [[TID:%.*]] = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0) #3
; OPT-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TID]], 0
; OPT-NEXT:    br i1 [[CMP]], label [[ENDIF:%.*]], label [[IF:%.*]]
; OPT:       if:
; OPT-NEXT:    [[TMP0:%.*]] = bitcast i32 addrspace(1)* [[IN:%.*]] to i8 addrspace(1)*
; OPT-NEXT:    [[SUNKADDR:%.*]] = getelementptr i8, i8 addrspace(1)* [[TMP0]], i64 28
; OPT-NEXT:    [[TMP1:%.*]] = bitcast i8 addrspace(1)* [[SUNKADDR]] to i32 addrspace(1)*
; OPT-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* [[TMP1]], i32 2)
; OPT-NEXT:    br label [[ENDIF]]
; OPT:       endif:
; OPT-NEXT:    [[X:%.*]] = phi i32 [ [[VAL]], [[IF]] ], [ 0, [[ENTRY:%.*]] ]
; OPT-NEXT:    store i32 [[X]], i32 addrspace(1)* [[OUT_GEP]], align 4
; OPT-NEXT:    ret void
;
; GCN-LABEL: test_sink_small_offset_global_atomic_csub_i32:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GCN-NEXT:    v_mbcnt_lo_u32_b32_e64 v0, -1, 0
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:    v_cmp_ne_u32_e32 vcc_lo, 0, v0
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_and_saveexec_b32 s4, vcc_lo
; GCN-NEXT:    s_cbranch_execz BB0_2
; GCN-NEXT:  ; %bb.1: ; %if
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s2
; GCN-NEXT:    v_mov_b32_e32 v1, s3
; GCN-NEXT:    v_mov_b32_e32 v2, 2
; GCN-NEXT:    global_atomic_csub v0, v[0:1], v2, off offset:28 glc
; GCN-NEXT:  BB0_2: ; %endif
; GCN-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_add_co_u32_e64 v1, s0, 0x3d0800, s0
; GCN-NEXT:    v_add_co_ci_u32_e64 v2, s0, 0, s1, s0
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    global_store_dword v[1:2], v0, off offset:252
; GCN-NEXT:    s_endpgm
entry:
  %out.gep = getelementptr i32, i32 addrspace(1)* %out, i32 999999
  %in.gep = getelementptr i32, i32 addrspace(1)* %in, i32 7
  %tid = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0) #0
  %cmp = icmp eq i32 %tid, 0
  br i1 %cmp, label %endif, label %if

if:
  %val = call i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* %in.gep, i32 2)
  br label %endif

endif:
  %x = phi i32 [ %val, %if ], [ 0, %entry ]
  store i32 %x, i32 addrspace(1)* %out.gep
  br label %done

done:
  ret void
}

declare i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* nocapture, i32) #0
declare i32 @llvm.amdgcn.mbcnt.lo(i32, i32) #1

attributes #0 = { argmemonly nounwind }
attributes #1 = { nounwind readnone willreturn }
attributes #2 = { argmemonly nounwind willreturn }
