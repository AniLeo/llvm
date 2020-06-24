; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-- -verify-machineinstrs < %s | FileCheck -check-prefix=SI %s

define amdgpu_ps void @i1_copy_from_loop(<4 x i32> inreg %rsrc, i32 %tid) {
; SI-LABEL: i1_copy_from_loop:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_mov_b32 s6, 0
; SI-NEXT:    s_mov_b64 s[4:5], 0
; SI-NEXT:    ; implicit-def: $sgpr8_sgpr9
; SI-NEXT:    ; implicit-def: $sgpr10_sgpr11
; SI-NEXT:    s_branch BB0_3
; SI-NEXT:  BB0_1: ; %Flow1
; SI-NEXT:    ; in Loop: Header=BB0_3 Depth=1
; SI-NEXT:    s_or_b64 exec, exec, s[14:15]
; SI-NEXT:  BB0_2: ; %Flow
; SI-NEXT:    ; in Loop: Header=BB0_3 Depth=1
; SI-NEXT:    s_and_b64 s[14:15], exec, s[10:11]
; SI-NEXT:    s_or_b64 s[4:5], s[14:15], s[4:5]
; SI-NEXT:    s_andn2_b64 s[8:9], s[8:9], exec
; SI-NEXT:    s_and_b64 s[12:13], s[12:13], exec
; SI-NEXT:    s_or_b64 s[8:9], s[8:9], s[12:13]
; SI-NEXT:    s_andn2_b64 exec, exec, s[4:5]
; SI-NEXT:    s_cbranch_execz BB0_6
; SI-NEXT:  BB0_3: ; %for.body
; SI-NEXT:    ; =>This Inner Loop Header: Depth=1
; SI-NEXT:    s_or_b64 s[10:11], s[10:11], exec
; SI-NEXT:    s_cmp_gt_u32 s6, 3
; SI-NEXT:    v_cmp_lt_u32_e64 s[12:13], s6, 4
; SI-NEXT:    s_cbranch_scc1 BB0_2
; SI-NEXT:  ; %bb.4: ; %mid.loop
; SI-NEXT:    ; in Loop: Header=BB0_3 Depth=1
; SI-NEXT:    v_mov_b32_e32 v1, s6
; SI-NEXT:    buffer_load_dword v1, v[0:1], s[0:3], 0 idxen offen
; SI-NEXT:    s_mov_b64 s[12:13], -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cmp_le_f32_e32 vcc, 0, v1
; SI-NEXT:    s_mov_b64 s[10:11], -1
; SI-NEXT:    s_and_saveexec_b64 s[14:15], vcc
; SI-NEXT:    s_cbranch_execz BB0_1
; SI-NEXT:  ; %bb.5: ; %end.loop
; SI-NEXT:    ; in Loop: Header=BB0_3 Depth=1
; SI-NEXT:    s_add_i32 s6, s6, 1
; SI-NEXT:    s_xor_b64 s[10:11], exec, -1
; SI-NEXT:    s_branch BB0_1
; SI-NEXT:  BB0_6: ; %for.end
; SI-NEXT:    s_or_b64 exec, exec, s[4:5]
; SI-NEXT:    s_and_saveexec_b64 s[0:1], s[8:9]
; SI-NEXT:    s_cbranch_execz BB0_8
; SI-NEXT:  ; %bb.7: ; %if
; SI-NEXT:    exp mrt0 v0, v0, v0, v0 done vm
; SI-NEXT:  BB0_8: ; %end
; SI-NEXT:    s_endpgm
entry:
  br label %for.body

for.body:
  %i = phi i32 [0, %entry], [%i.inc, %end.loop]
  %cc = icmp ult i32 %i, 4
  br i1 %cc, label %mid.loop, label %for.end

mid.loop:
  %v = call float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32> %rsrc, i32 %tid, i32 %i, i32 0, i32 0)
  %cc2 = fcmp oge float %v, 0.0
  br i1 %cc2, label %end.loop, label %for.end

end.loop:
  %i.inc = add i32 %i, 1
  br label %for.body

for.end:
  br i1 %cc, label %if, label %end

if:
  call void @llvm.amdgcn.exp.f32(i32 0, i32 15, float undef, float undef, float undef, float undef, i1 true, i1 true)
  br label %end

end:
  ret void
}

declare float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare void @llvm.amdgcn.exp.f32(i32, i32, float, float, float, float, i1, i1) #1

attributes #0 = { nounwind readonly }
attributes #1 = { nounwind inaccessiblememonly }
