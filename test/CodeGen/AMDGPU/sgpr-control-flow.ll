; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=SI %s
;
; Most SALU instructions ignore control flow, so we need to make sure
; they don't overwrite values from other blocks.

; If the branch decision is made based on a value in an SGPR then all
; threads will execute the same code paths, so we don't need to worry
; about instructions in different blocks overwriting each other.

define amdgpu_kernel void @sgpr_if_else_salu_br(i32 addrspace(1)* %out, i32 %a, i32 %b, i32 %c, i32 %d, i32 %e) {
; SI-LABEL: sgpr_if_else_salu_br:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[8:11], s[0:1], 0xb
; SI-NEXT:    s_load_dword s0, s[0:1], 0xf
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_cmp_lg_u32 s8, 0
; SI-NEXT:    s_cbranch_scc0 BB0_2
; SI-NEXT:  ; %bb.1: ; %else
; SI-NEXT:    s_add_i32 s0, s11, s0
; SI-NEXT:    s_mov_b64 s[2:3], 0
; SI-NEXT:    s_andn2_b64 vcc, exec, s[2:3]
; SI-NEXT:    s_cbranch_vccz BB0_3
; SI-NEXT:    s_branch BB0_4
; SI-NEXT:  BB0_2:
; SI-NEXT:    s_mov_b64 s[2:3], -1
; SI-NEXT:    ; implicit-def: $sgpr0
; SI-NEXT:    s_andn2_b64 vcc, exec, s[2:3]
; SI-NEXT:    s_cbranch_vccnz BB0_4
; SI-NEXT:  BB0_3: ; %if
; SI-NEXT:    s_sub_i32 s0, s9, s10
; SI-NEXT:  BB0_4: ; %endif
; SI-NEXT:    s_add_i32 s0, s0, s8
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
entry:
  %0 = icmp eq i32 %a, 0
  br i1 %0, label %if, label %else

if:
  %1 = sub i32 %b, %c
  br label %endif

else:
  %2 = add i32 %d, %e
  br label %endif

endif:
  %3 = phi i32 [%1, %if], [%2, %else]
  %4 = add i32 %3, %a
  store i32 %4, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @sgpr_if_else_salu_br_opt(i32 addrspace(1)* %out, [8 x i32], i32 %a, [8 x i32], i32 %b, [8 x i32], i32 %c, [8 x i32], i32 %d, [8 x i32], i32 %e) {
; SI-LABEL: sgpr_if_else_salu_br_opt:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dword s2, s[0:1], 0x13
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_cmp_lg_u32 s2, 0
; SI-NEXT:    s_cbranch_scc0 BB1_2
; SI-NEXT:  ; %bb.1: ; %else
; SI-NEXT:    s_load_dword s3, s[0:1], 0x2e
; SI-NEXT:    s_load_dword s6, s[0:1], 0x37
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_add_i32 s3, s3, s6
; SI-NEXT:    s_mov_b64 s[6:7], 0
; SI-NEXT:    s_andn2_b64 vcc, exec, s[6:7]
; SI-NEXT:    s_cbranch_vccz BB1_3
; SI-NEXT:    s_branch BB1_4
; SI-NEXT:  BB1_2:
; SI-NEXT:    s_mov_b64 s[6:7], -1
; SI-NEXT:    ; implicit-def: $sgpr3
; SI-NEXT:    s_andn2_b64 vcc, exec, s[6:7]
; SI-NEXT:    s_cbranch_vccnz BB1_4
; SI-NEXT:  BB1_3: ; %if
; SI-NEXT:    s_load_dword s3, s[0:1], 0x1c
; SI-NEXT:    s_load_dword s0, s[0:1], 0x25
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_add_i32 s3, s3, s0
; SI-NEXT:  BB1_4: ; %endif
; SI-NEXT:    s_add_i32 s0, s3, s2
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
entry:
  %cmp0 = icmp eq i32 %a, 0
  br i1 %cmp0, label %if, label %else

if:
  %add0 = add i32 %b, %c
  br label %endif

else:
  %add1 = add i32 %d, %e
  br label %endif

endif:
  %phi = phi i32 [%add0, %if], [%add1, %else]
  %add2 = add i32 %phi, %a
  store i32 %add2, i32 addrspace(1)* %out
  ret void
}

; The two S_ADD instructions should write to different registers, since
; different threads will take different control flow paths.
define amdgpu_kernel void @sgpr_if_else_valu_br(i32 addrspace(1)* %out, float %a, i32 %b, i32 %c, i32 %d, i32 %e) {
; SI-LABEL: sgpr_if_else_valu_br:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    v_cvt_f32_u32_e32 v0, v0
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0xc
; SI-NEXT:    ; implicit-def: $sgpr6
; SI-NEXT:    v_cmp_lg_f32_e32 vcc, 0, v0
; SI-NEXT:    s_and_saveexec_b64 s[8:9], vcc
; SI-NEXT:    s_xor_b64 s[8:9], exec, s[8:9]
; SI-NEXT:    s_cbranch_execz BB2_2
; SI-NEXT:  ; %bb.1: ; %else
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_add_i32 s6, s2, s3
; SI-NEXT:  BB2_2: ; %Flow
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_or_saveexec_b64 s[2:3], s[8:9]
; SI-NEXT:    v_mov_b32_e32 v0, s6
; SI-NEXT:    s_xor_b64 exec, exec, s[2:3]
; SI-NEXT:  ; %bb.3: ; %if
; SI-NEXT:    s_add_i32 s0, s0, s1
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:  ; %bb.4: ; %endif
; SI-NEXT:    s_or_b64 exec, exec, s[2:3]
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid_f = uitofp i32 %tid to float
  %tmp1 = fcmp ueq float %tid_f, 0.0
  br i1 %tmp1, label %if, label %else

if:
  %tmp2 = add i32 %b, %c
  br label %endif

else:
  %tmp3 = add i32 %d, %e
  br label %endif

endif:
  %tmp4 = phi i32 [%tmp2, %if], [%tmp3, %else]
  store i32 %tmp4, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @sgpr_if_else_valu_cmp_phi_br(i32 addrspace(1)* %out, i32 addrspace(1)* %a, i32 addrspace(1)* %b) {
; SI-LABEL: sgpr_if_else_valu_cmp_phi_br:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s14, 0
; SI-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; SI-NEXT:    ; implicit-def: $sgpr2_sgpr3
; SI-NEXT:    s_and_saveexec_b64 s[8:9], vcc
; SI-NEXT:    s_xor_b64 s[8:9], exec, s[8:9]
; SI-NEXT:    s_cbranch_execz BB3_2
; SI-NEXT:  ; %bb.1: ; %else
; SI-NEXT:    s_load_dwordx2 s[12:13], s[0:1], 0xd
; SI-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; SI-NEXT:    v_mov_b32_e32 v2, 0
; SI-NEXT:    s_mov_b32 s15, 0xf000
; SI-NEXT:    s_andn2_b64 s[0:1], s[0:1], exec
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dword v1, v[1:2], s[12:15], 0 addr64
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cmp_gt_i32_e32 vcc, 0, v1
; SI-NEXT:    s_and_b64 s[2:3], vcc, exec
; SI-NEXT:    s_or_b64 s[2:3], s[0:1], s[2:3]
; SI-NEXT:  BB3_2: ; %Flow
; SI-NEXT:    s_or_saveexec_b64 s[0:1], s[8:9]
; SI-NEXT:    s_xor_b64 exec, exec, s[0:1]
; SI-NEXT:    s_cbranch_execz BB3_4
; SI-NEXT:  ; %bb.3: ; %if
; SI-NEXT:    s_mov_b32 s11, 0xf000
; SI-NEXT:    s_mov_b32 s10, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b64 s[8:9], s[6:7]
; SI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    buffer_load_dword v0, v[0:1], s[8:11], 0 addr64
; SI-NEXT:    s_andn2_b64 s[2:3], s[2:3], exec
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v0
; SI-NEXT:    s_and_b64 s[6:7], vcc, exec
; SI-NEXT:    s_or_b64 s[2:3], s[2:3], s[6:7]
; SI-NEXT:  BB3_4: ; %endif
; SI-NEXT:    s_or_b64 exec, exec, s[0:1]
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    v_cndmask_b32_e64 v0, 0, -1, s[2:3]
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x() #0
  %tmp1 = icmp eq i32 %tid, 0
  br i1 %tmp1, label %if, label %else

if:
  %gep.if = getelementptr i32, i32 addrspace(1)* %a, i32 %tid
  %a.val = load i32, i32 addrspace(1)* %gep.if
  %cmp.if = icmp eq i32 %a.val, 0
  br label %endif

else:
  %gep.else = getelementptr i32, i32 addrspace(1)* %b, i32 %tid
  %b.val = load i32, i32 addrspace(1)* %gep.else
  %cmp.else = icmp slt i32 %b.val, 0
  br label %endif

endif:
  %tmp4 = phi i1 [%cmp.if, %if], [%cmp.else, %else]
  %ext = sext i1 %tmp4 to i32
  store i32 %ext, i32 addrspace(1)* %out
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #0

attributes #0 = { readnone }
