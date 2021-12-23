; RUN: llc < %s -march=amdgcn -mcpu=tahiti -verify-machineinstrs | FileCheck -check-prefixes=SI,GCN %s
; RUN: llc < %s -march=amdgcn -mcpu=tonga -verify-machineinstrs | FileCheck -check-prefixes=VI,GCN %s

; GCN-LABEL: {{^}}select0:
; i64 select should be split into two i32 selects, and we shouldn't need
; to use a shfit to extract the hi dword of the input.
; GCN-NOT: s_lshr_b64
; GCN: v_cndmask
; GCN: v_cndmask
define amdgpu_kernel void @select0(i64 addrspace(1)* %out, i32 %cond, i64 %in) {
<<<<<<< HEAD
; SI-LABEL: select0:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dword s6, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_cmp_lt_u32 s6, 6
; SI-NEXT:    v_mov_b32_e32 v0, s5
; SI-NEXT:    s_cselect_b64 vcc, -1, 0
; SI-NEXT:    v_cndmask_b32_e32 v1, 0, v0, vcc
; SI-NEXT:    v_mov_b32_e32 v0, s4
; SI-NEXT:    v_cndmask_b32_e32 v0, 0, v0, vcc
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: select0:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dword s4, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_cmp_lt_u32 s4, 6
; VI-NEXT:    s_cselect_b64 s[2:3], s[2:3], 0
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_mov_b32_e32 v3, s3
; VI-NEXT:    flat_store_dwordx2 v[0:1], v[2:3]
; VI-NEXT:    s_endpgm
;
; GFX90A-LABEL: select0:
; GFX90A:       ; %bb.0: ; %entry
; GFX90A-NEXT:    s_load_dword s6, s[0:1], 0x2c
; GFX90A-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX90A-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v2, 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_cmp_lt_u32 s6, 6
; GFX90A-NEXT:    s_cselect_b64 s[0:1], s[2:3], 0
; GFX90A-NEXT:    v_pk_mov_b32 v[0:1], s[0:1], s[0:1] op_sel:[0,1]
; GFX90A-NEXT:    global_store_dwordx2 v2, v[0:1], s[4:5]
; GFX90A-NEXT:    s_endpgm
=======
>>>>>>> parent of 640beb38e771... [amdgpu] Enable selection of `s_cselect_b64`.
entry:
  %0 = icmp ugt i32 %cond, 5
  %1 = select i1 %0, i64 0, i64 %in
  store i64 %1, i64 addrspace(1)* %out
  ret void
}

; GCN-LABEL: {{^}}select_trunc_i64:
; VI: s_cselect_b32
; VI-NOT: s_cselect_b32
; SI: v_cndmask_b32
; SI-NOT: v_cndmask_b32
define amdgpu_kernel void @select_trunc_i64(i32 addrspace(1)* %out, i32 %cond, i64 %in) nounwind {
<<<<<<< HEAD
; SI-LABEL: select_trunc_i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s4, s[0:1], 0xb
; SI-NEXT:    s_load_dword s5, s[0:1], 0xd
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_cmp_lt_u32 s4, 6
; SI-NEXT:    v_mov_b32_e32 v0, s5
; SI-NEXT:    s_cselect_b64 vcc, -1, 0
; SI-NEXT:    v_cndmask_b32_e32 v0, 0, v0, vcc
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: select_trunc_i64:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dword s2, s[0:1], 0x2c
; VI-NEXT:    s_load_dword s3, s[0:1], 0x34
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_cmp_lt_u32 s2, 6
; VI-NEXT:    s_cselect_b32 s2, s3, 0
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
;
; GFX90A-LABEL: select_trunc_i64:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX90A-NEXT:    s_load_dword s5, s[0:1], 0x34
; GFX90A-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v0, 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_cmp_lt_u32 s4, 6
; GFX90A-NEXT:    s_cselect_b32 s0, s5, 0
; GFX90A-NEXT:    v_mov_b32_e32 v1, s0
; GFX90A-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX90A-NEXT:    s_endpgm
=======
>>>>>>> parent of 640beb38e771... [amdgpu] Enable selection of `s_cselect_b64`.
  %cmp = icmp ugt i32 %cond, 5
  %sel = select i1 %cmp, i64 0, i64 %in
  %trunc = trunc i64 %sel to i32
  store i32 %trunc, i32 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}select_trunc_i64_2:
; VI: s_cselect_b32
; VI-NOT: s_cselect_b32
; SI: v_cndmask_b32
; SI-NOT: v_cndmask_b32
define amdgpu_kernel void @select_trunc_i64_2(i32 addrspace(1)* %out, i32 %cond, i64 %a, i64 %b) nounwind {
<<<<<<< HEAD
; SI-LABEL: select_trunc_i64_2:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s8, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0xd
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_cmp_gt_u32 s8, 5
; SI-NEXT:    v_mov_b32_e32 v0, s6
; SI-NEXT:    v_mov_b32_e32 v1, s4
; SI-NEXT:    s_cselect_b64 vcc, -1, 0
; SI-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: select_trunc_i64_2:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dword s2, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_cmp_gt_u32 s2, 5
; VI-NEXT:    s_cselect_b32 s2, s4, s6
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
;
; GFX90A-LABEL: select_trunc_i64_2:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dword s8, s[0:1], 0x2c
; GFX90A-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; GFX90A-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v0, 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_cmp_gt_u32 s8, 5
; GFX90A-NEXT:    s_cselect_b32 s0, s4, s6
; GFX90A-NEXT:    v_mov_b32_e32 v1, s0
; GFX90A-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX90A-NEXT:    s_endpgm
=======
>>>>>>> parent of 640beb38e771... [amdgpu] Enable selection of `s_cselect_b64`.
  %cmp = icmp ugt i32 %cond, 5
  %sel = select i1 %cmp, i64 %a, i64 %b
  %trunc = trunc i64 %sel to i32
  store i32 %trunc, i32 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}v_select_trunc_i64_2:
; VI: s_cselect_b32
; VI-NOT: s_cselect_b32
; SI: v_cndmask_b32
; SI-NOT: v_cndmask_b32
define amdgpu_kernel void @v_select_trunc_i64_2(i32 addrspace(1)* %out, i32 %cond, i64 addrspace(1)* %aptr, i64 addrspace(1)* %bptr) nounwind {
<<<<<<< HEAD
; SI-LABEL: v_select_trunc_i64_2:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0xd
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s11, 0xf000
; SI-NEXT:    s_mov_b32 s10, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_load_dword s1, s[6:7], 0x0
; SI-NEXT:    s_load_dword s2, s[4:5], 0x0
; SI-NEXT:    s_cmp_gt_u32 s0, 5
; SI-NEXT:    s_cselect_b64 vcc, -1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s1
; SI-NEXT:    v_mov_b32_e32 v1, s2
; SI-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; SI-NEXT:    buffer_store_dword v0, off, s[8:11], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: v_select_trunc_i64_2:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; VI-NEXT:    s_load_dword s2, s[0:1], 0x2c
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_load_dword s3, s[4:5], 0x0
; VI-NEXT:    s_load_dword s4, s[6:7], 0x0
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_cmp_gt_u32 s2, 5
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_cselect_b32 s2, s3, s4
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    flat_store_dword v[0:1], v2
; VI-NEXT:    s_endpgm
;
; GFX90A-LABEL: v_select_trunc_i64_2:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; GFX90A-NEXT:    s_load_dword s8, s[0:1], 0x2c
; GFX90A-NEXT:    v_mov_b32_e32 v0, 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_load_dword s9, s[4:5], 0x0
; GFX90A-NEXT:    s_load_dword s10, s[6:7], 0x0
; GFX90A-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX90A-NEXT:    s_cmp_gt_u32 s8, 5
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_cselect_b32 s0, s9, s10
; GFX90A-NEXT:    v_mov_b32_e32 v1, s0
; GFX90A-NEXT:    global_store_dword v0, v1, s[2:3]
; GFX90A-NEXT:    s_endpgm
=======
>>>>>>> parent of 640beb38e771... [amdgpu] Enable selection of `s_cselect_b64`.
  %cmp = icmp ugt i32 %cond, 5
  %a = load i64, i64 addrspace(1)* %aptr, align 8
  %b = load i64, i64 addrspace(1)* %bptr, align 8
  %sel = select i1 %cmp, i64 %a, i64 %b
  %trunc = trunc i64 %sel to i32
  store i32 %trunc, i32 addrspace(1)* %out, align 4
  ret void
}

; GCN-LABEL: {{^}}v_select_i64_split_imm:
; GCN-DAG: v_cndmask_b32_e32 {{v[0-9]+}}, 0, {{v[0-9]+}}
; GCN-DAG: v_cndmask_b32_e32 {{v[0-9]+}}, 63, {{v[0-9]+}}
; GCN: s_endpgm
define amdgpu_kernel void @v_select_i64_split_imm(i64 addrspace(1)* %out, i32 %cond, i64 addrspace(1)* %aptr, i64 addrspace(1)* %bptr) nounwind {
<<<<<<< HEAD
; SI-LABEL: v_select_i64_split_imm:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xd
; SI-NEXT:    s_load_dword s6, s[0:1], 0xb
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_load_dwordx2 s[4:5], s[2:3], 0x0
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_cmp_gt_u32 s6, 5
; SI-NEXT:    s_cselect_b64 vcc, -1, 0
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s5
; SI-NEXT:    v_mov_b32_e32 v2, s4
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    v_cndmask_b32_e32 v1, 63, v0, vcc
; SI-NEXT:    v_cndmask_b32_e32 v0, 0, v2, vcc
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: v_select_i64_split_imm:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; VI-NEXT:    s_load_dword s6, s[0:1], 0x2c
; VI-NEXT:    s_mov_b32 s4, 0
; VI-NEXT:    s_mov_b32 s5, 63
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_load_dwordx2 s[2:3], s[2:3], 0x0
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_cmp_gt_u32 s6, 5
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_cselect_b64 s[2:3], s[2:3], s[4:5]
; VI-NEXT:    v_mov_b32_e32 v0, s0
; VI-NEXT:    v_mov_b32_e32 v2, s2
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_mov_b32_e32 v3, s3
; VI-NEXT:    flat_store_dwordx2 v[0:1], v[2:3]
; VI-NEXT:    s_endpgm
;
; GFX90A-LABEL: v_select_i64_split_imm:
; GFX90A:       ; %bb.0:
; GFX90A-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX90A-NEXT:    s_load_dword s6, s[0:1], 0x2c
; GFX90A-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; GFX90A-NEXT:    v_mov_b32_e32 v2, 0
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX90A-NEXT:    s_mov_b32 s2, 0
; GFX90A-NEXT:    s_cmp_gt_u32 s6, 5
; GFX90A-NEXT:    s_mov_b32 s3, 63
; GFX90A-NEXT:    s_waitcnt lgkmcnt(0)
; GFX90A-NEXT:    s_cselect_b64 s[0:1], s[0:1], s[2:3]
; GFX90A-NEXT:    v_pk_mov_b32 v[0:1], s[0:1], s[0:1] op_sel:[0,1]
; GFX90A-NEXT:    global_store_dwordx2 v2, v[0:1], s[4:5]
; GFX90A-NEXT:    s_endpgm
=======
>>>>>>> parent of 640beb38e771... [amdgpu] Enable selection of `s_cselect_b64`.
  %cmp = icmp ugt i32 %cond, 5
  %a = load i64, i64 addrspace(1)* %aptr, align 8
  %b = load i64, i64 addrspace(1)* %bptr, align 8
  %sel = select i1 %cmp, i64 %a, i64 270582939648 ; 63 << 32
  store i64 %sel, i64 addrspace(1)* %out, align 8
  ret void
}
