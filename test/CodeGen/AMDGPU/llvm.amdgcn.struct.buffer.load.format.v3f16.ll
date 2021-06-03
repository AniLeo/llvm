; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=gfx1010 -mtriple=amdgcn-- -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s
; RUN: llc -mcpu=gfx900 -mtriple=amdgcn-- -verify-machineinstrs < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -mcpu=gfx810 -mtriple=amdgcn-- -verify-machineinstrs < %s | FileCheck -check-prefix=GFX8 %s
@esgs_ring = external addrspace(3) global [0 x i32], align 65536

define amdgpu_gs void @main(<4 x i32> %arg, i32 %arg1) {
; GFX10-LABEL: main:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:  BB0_1: ; =>This Inner Loop Header: Depth=1
; GFX10-NEXT:    v_readfirstlane_b32 s4, v0
; GFX10-NEXT:    v_readfirstlane_b32 s5, v1
; GFX10-NEXT:    v_readfirstlane_b32 s6, v2
; GFX10-NEXT:    v_readfirstlane_b32 s7, v3
; GFX10-NEXT:    v_cmp_eq_u64_e32 vcc_lo, s[4:5], v[0:1]
; GFX10-NEXT:    v_cmp_eq_u64_e64 s0, s[6:7], v[2:3]
; GFX10-NEXT:    s_and_b32 s0, vcc_lo, s0
; GFX10-NEXT:    s_and_saveexec_b32 s0, s0
; GFX10-NEXT:    buffer_load_format_d16_xyz v[5:6], v4, s[4:7], 0 idxen
; GFX10-NEXT:    s_waitcnt_depctr 0xffe3
; GFX10-NEXT:    s_xor_b32 exec_lo, exec_lo, s0
; GFX10-NEXT:    s_cbranch_execnz BB0_1
; GFX10-NEXT:  ; %bb.2:
; GFX10-NEXT:    s_mov_b32 exec_lo, s1
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_lshrrev_b32_e32 v0, 16, v5
; GFX10-NEXT:    v_and_b32_e32 v1, 0xffff, v6
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ds_write2_b32 v2, v0, v1 offset0:7 offset1:8
;
; GFX9-LABEL: main:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_mov_b64 s[2:3], exec
; GFX9-NEXT:  BB0_1: ; =>This Inner Loop Header: Depth=1
; GFX9-NEXT:    v_readfirstlane_b32 s4, v0
; GFX9-NEXT:    v_readfirstlane_b32 s5, v1
; GFX9-NEXT:    v_readfirstlane_b32 s6, v2
; GFX9-NEXT:    v_readfirstlane_b32 s7, v3
; GFX9-NEXT:    v_cmp_eq_u64_e32 vcc, s[4:5], v[0:1]
; GFX9-NEXT:    v_cmp_eq_u64_e64 s[0:1], s[6:7], v[2:3]
; GFX9-NEXT:    s_and_b64 s[0:1], vcc, s[0:1]
; GFX9-NEXT:    s_and_saveexec_b64 s[0:1], s[0:1]
; GFX9-NEXT:    s_nop 0
; GFX9-NEXT:    buffer_load_format_d16_xyz v[5:6], v4, s[4:7], 0 idxen
; GFX9-NEXT:    s_xor_b64 exec, exec, s[0:1]
; GFX9-NEXT:    s_cbranch_execnz BB0_1
; GFX9-NEXT:  ; %bb.2:
; GFX9-NEXT:    s_mov_b64 exec, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v0, 16, v5
; GFX9-NEXT:    v_and_b32_e32 v1, 0xffff, v6
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    ds_write2_b32 v2, v0, v1 offset0:7 offset1:8
;
; GFX8-LABEL: main:
; GFX8:       ; %bb.0: ; %bb
; GFX8-NEXT:    s_mov_b64 s[2:3], exec
; GFX8-NEXT:  BB0_1: ; =>This Inner Loop Header: Depth=1
; GFX8-NEXT:    v_readfirstlane_b32 s4, v0
; GFX8-NEXT:    v_readfirstlane_b32 s5, v1
; GFX8-NEXT:    v_readfirstlane_b32 s6, v2
; GFX8-NEXT:    v_readfirstlane_b32 s7, v3
; GFX8-NEXT:    v_cmp_eq_u64_e32 vcc, s[4:5], v[0:1]
; GFX8-NEXT:    v_cmp_eq_u64_e64 s[0:1], s[6:7], v[2:3]
; GFX8-NEXT:    s_and_b64 s[0:1], vcc, s[0:1]
; GFX8-NEXT:    s_and_saveexec_b64 s[0:1], s[0:1]
; GFX8-NEXT:    s_nop 0
; GFX8-NEXT:    buffer_load_format_d16_xyz v[5:6], v4, s[4:7], 0 idxen
; GFX8-NEXT:    s_xor_b64 exec, exec, s[0:1]
; GFX8-NEXT:    s_cbranch_execnz BB0_1
; GFX8-NEXT:  ; %bb.2:
; GFX8-NEXT:    s_mov_b64 exec, s[2:3]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_alignbit_b32 v0, v6, v5, 16
; GFX8-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; GFX8-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX8-NEXT:    v_mov_b32_e32 v2, 0
; GFX8-NEXT:    s_mov_b32 m0, -1
; GFX8-NEXT:    ds_write2_b32 v2, v0, v1 offset0:7 offset1:8
bb:
  %i = call i32 @llvm.amdgcn.mbcnt.hi(i32 -1, i32 undef)
  %i2 = call nsz arcp <3 x half> @llvm.amdgcn.struct.buffer.load.format.v3f16(<4 x i32> %arg, i32 %arg1, i32 0, i32 0, i32 0)
  %i3 = bitcast <3 x half> %i2 to <3 x i16>
  %i4 = extractelement <3 x i16> %i3, i32 1
  %i5 = bitcast <3 x half> %i2 to <3 x i16>
  %i6 = extractelement <3 x i16> %i5, i32 2
  %i7 = zext i16 %i4 to i32
  %i8 = zext i16 %i6 to i32
  %i9 = add nuw nsw i32 0, 7
  %i10 = getelementptr [0 x i32], [0 x i32] addrspace(3)* @esgs_ring, i32 0, i32 %i9
  store i32 %i7, i32 addrspace(3)* %i10, align 4
  %i11 = add nuw nsw i32 0, 8
  %i12 = getelementptr [0 x i32], [0 x i32] addrspace(3)* @esgs_ring, i32 0, i32 %i11
  store i32 %i8, i32 addrspace(3)* %i12, align 4
  unreachable
}

; Function Attrs: nounwind readnone willreturn
declare i32 @llvm.amdgcn.mbcnt.hi(i32, i32) #0

; Function Attrs: nounwind readonly willreturn
declare <3 x half> @llvm.amdgcn.struct.buffer.load.format.v3f16(<4 x i32>, i32, i32, i32, i32 immarg) #1

attributes #0 = { nounwind readnone willreturn }
attributes #1 = { nounwind readonly willreturn }
