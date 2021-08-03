; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=amdgcn -mcpu=verde -verify-machineinstrs | FileCheck --check-prefix=SI %s
; RUN: llc < %s -march=amdgcn -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs | FileCheck --check-prefix=FLAT %s

define amdgpu_kernel void @break_inserted_outside_of_loop(i32 addrspace(1)* %out, i32 %a) {
; SI-LABEL: break_inserted_outside_of_loop:
; SI:       ; %bb.0: ; %main_body
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    v_mbcnt_lo_u32_b32_e64 v0, -1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_and_b32_e32 v0, s0, v0
; SI-NEXT:    v_and_b32_e32 v0, 1, v0
; SI-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; SI-NEXT:    s_mov_b64 s[0:1], 0
; SI-NEXT:  BB0_1: ; %ENDIF
; SI-NEXT:    ; =>This Inner Loop Header: Depth=1
; SI-NEXT:    s_and_b64 s[2:3], exec, vcc
; SI-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; SI-NEXT:    s_andn2_b64 exec, exec, s[0:1]
; SI-NEXT:    s_cbranch_execnz BB0_1
; SI-NEXT:  ; %bb.2: ; %ENDLOOP
; SI-NEXT:    s_or_b64 exec, exec, s[0:1]
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    v_mov_b32_e32 v0, 0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: break_inserted_outside_of_loop:
; FLAT:       ; %bb.0: ; %main_body
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dword s0, s[0:1], 0x2c
; FLAT-NEXT:    v_mbcnt_lo_u32_b32 v0, -1, 0
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_and_b32_e32 v0, s0, v0
; FLAT-NEXT:    v_and_b32_e32 v0, 1, v0
; FLAT-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; FLAT-NEXT:    s_mov_b64 s[0:1], 0
; FLAT-NEXT:  BB0_1: ; %ENDIF
; FLAT-NEXT:    ; =>This Inner Loop Header: Depth=1
; FLAT-NEXT:    s_and_b64 s[2:3], exec, vcc
; FLAT-NEXT:    s_or_b64 s[0:1], s[2:3], s[0:1]
; FLAT-NEXT:    s_andn2_b64 exec, exec, s[0:1]
; FLAT-NEXT:    s_cbranch_execnz BB0_1
; FLAT-NEXT:  ; %bb.2: ; %ENDLOOP
; FLAT-NEXT:    s_or_b64 exec, exec, s[0:1]
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    v_mov_b32_e32 v0, 0
; FLAT-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
main_body:
  %tid = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0) #0
  %0 = and i32 %a, %tid
  %1 = trunc i32 %0 to i1
  br label %ENDIF

ENDLOOP:
  store i32 0, i32 addrspace(1)* %out
  ret void

ENDIF:
  br i1 %1, label %ENDLOOP, label %ENDIF
}

define amdgpu_kernel void @phi_cond_outside_loop(i32 %b) {
; SI-LABEL: phi_cond_outside_loop:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    v_mbcnt_lo_u32_b32_e64 v0, -1, 0
; SI-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; SI-NEXT:    s_mov_b64 s[2:3], 0
; SI-NEXT:    s_mov_b64 s[4:5], 0
; SI-NEXT:    s_and_saveexec_b64 s[6:7], vcc
; SI-NEXT:    s_cbranch_execz BB1_2
; SI-NEXT:  ; %bb.1: ; %else
; SI-NEXT:    s_load_dword s0, s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cmp_eq_u32_e64 s[0:1], s0, 0
; SI-NEXT:    s_and_b64 s[4:5], s[0:1], exec
; SI-NEXT:  BB1_2: ; %endif
; SI-NEXT:    s_or_b64 exec, exec, s[6:7]
; SI-NEXT:  BB1_3: ; %loop
; SI-NEXT:    ; =>This Inner Loop Header: Depth=1
; SI-NEXT:    s_and_b64 s[0:1], exec, s[4:5]
; SI-NEXT:    s_or_b64 s[2:3], s[0:1], s[2:3]
; SI-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; SI-NEXT:    s_cbranch_execnz BB1_3
; SI-NEXT:  ; %bb.4: ; %exit
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: phi_cond_outside_loop:
; FLAT:       ; %bb.0: ; %entry
; FLAT-NEXT:    v_mbcnt_lo_u32_b32 v0, -1, 0
; FLAT-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; FLAT-NEXT:    s_mov_b64 s[2:3], 0
; FLAT-NEXT:    s_mov_b64 s[4:5], 0
; FLAT-NEXT:    s_and_saveexec_b64 s[6:7], vcc
; FLAT-NEXT:    s_cbranch_execz BB1_2
; FLAT-NEXT:  ; %bb.1: ; %else
; FLAT-NEXT:    s_load_dword s0, s[0:1], 0x24
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_cmp_eq_u32_e64 s[0:1], s0, 0
; FLAT-NEXT:    s_and_b64 s[4:5], s[0:1], exec
; FLAT-NEXT:  BB1_2: ; %endif
; FLAT-NEXT:    s_or_b64 exec, exec, s[6:7]
; FLAT-NEXT:  BB1_3: ; %loop
; FLAT-NEXT:    ; =>This Inner Loop Header: Depth=1
; FLAT-NEXT:    s_and_b64 s[0:1], exec, s[4:5]
; FLAT-NEXT:    s_or_b64 s[2:3], s[0:1], s[2:3]
; FLAT-NEXT:    s_andn2_b64 exec, exec, s[2:3]
; FLAT-NEXT:    s_cbranch_execnz BB1_3
; FLAT-NEXT:  ; %bb.4: ; %exit
; FLAT-NEXT:    s_endpgm
entry:
  %tid = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0) #0
  %0 = icmp eq i32 %tid , 0
  br i1 %0, label %if, label %else

if:
  br label %endif

else:
  %1 = icmp eq i32 %b, 0
  br label %endif

endif:
  %2 = phi i1 [0, %if], [%1, %else]
  br label %loop

loop:
  br i1 %2, label %exit, label %loop

exit:
  ret void
}

define amdgpu_kernel void @switch_unreachable(i32 addrspace(1)* %g, i8 addrspace(3)* %l, i32 %x) nounwind {
; SI-LABEL: switch_unreachable:
; SI:       ; %bb.0: ; %centry
;
; FLAT-LABEL: switch_unreachable:
; FLAT:       ; %bb.0: ; %centry
centry:
  switch i32 %x, label %sw.default [
    i32 0, label %sw.bb
    i32 60, label %sw.bb
  ]

sw.bb:
  unreachable

sw.default:
  unreachable

sw.epilog:
  ret void
}

declare float @llvm.fabs.f32(float) nounwind readnone

define amdgpu_kernel void @loop_land_info_assert(i32 %c0, i32 %c1, i32 %c2, i32 %c3, i32 %x, i32 %y, i1 %arg) nounwind {
; SI-LABEL: loop_land_info_assert:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    buffer_load_dword v0, off, s[4:7], 0
; SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x9
; SI-NEXT:    s_load_dword s14, s[0:1], 0xc
; SI-NEXT:    s_brev_b32 s8, 44
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cmp_lt_i32_e64 s[0:1], s2, 1
; SI-NEXT:    v_cmp_lt_i32_e64 s[4:5], s3, 4
; SI-NEXT:    v_cmp_gt_i32_e64 s[2:3], s3, 3
; SI-NEXT:    s_and_b64 s[2:3], s[0:1], s[2:3]
; SI-NEXT:    s_and_b64 s[0:1], exec, s[4:5]
; SI-NEXT:    s_and_b64 s[2:3], exec, s[2:3]
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cmp_lt_f32_e64 s[4:5], |v0|, s8
; SI-NEXT:    s_and_b64 s[4:5], exec, s[4:5]
; SI-NEXT:    v_mov_b32_e32 v0, 3
; SI-NEXT:    s_branch BB3_4
; SI-NEXT:  BB3_1: ; %Flow6
; SI-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; SI-NEXT:    s_mov_b64 s[8:9], 0
; SI-NEXT:  BB3_2: ; %Flow5
; SI-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; SI-NEXT:    s_mov_b64 s[12:13], 0
; SI-NEXT:  BB3_3: ; %Flow
; SI-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; SI-NEXT:    s_and_b64 vcc, exec, s[10:11]
; SI-NEXT:    s_cbranch_vccnz BB3_8
; SI-NEXT:  BB3_4: ; %while.cond
; SI-NEXT:    ; =>This Inner Loop Header: Depth=1
; SI-NEXT:    s_mov_b64 s[12:13], -1
; SI-NEXT:    s_mov_b64 s[8:9], -1
; SI-NEXT:    s_mov_b64 s[10:11], -1
; SI-NEXT:    s_mov_b64 vcc, s[0:1]
; SI-NEXT:    s_cbranch_vccz BB3_3
; SI-NEXT:  ; %bb.5: ; %convex.exit
; SI-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; SI-NEXT:    s_mov_b64 s[8:9], -1
; SI-NEXT:    s_mov_b64 s[10:11], -1
; SI-NEXT:    s_mov_b64 vcc, s[2:3]
; SI-NEXT:    s_cbranch_vccz BB3_2
; SI-NEXT:  ; %bb.6: ; %if.end
; SI-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; SI-NEXT:    s_mov_b64 s[10:11], -1
; SI-NEXT:    s_mov_b64 vcc, s[4:5]
; SI-NEXT:    s_cbranch_vccz BB3_1
; SI-NEXT:  ; %bb.7: ; %if.else
; SI-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; SI-NEXT:    s_mov_b64 s[10:11], 0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    s_branch BB3_1
; SI-NEXT:  BB3_8: ; %loop.exit.guard4
; SI-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; SI-NEXT:    s_and_b64 vcc, exec, s[8:9]
; SI-NEXT:    s_cbranch_vccz BB3_4
; SI-NEXT:  ; %bb.9: ; %loop.exit.guard
; SI-NEXT:    s_and_b64 vcc, exec, s[12:13]
; SI-NEXT:    s_cbranch_vccz BB3_13
; SI-NEXT:  ; %bb.10: ; %for.cond.preheader
; SI-NEXT:    s_cmpk_lt_i32 s14, 0x3e8
; SI-NEXT:    s_cbranch_scc0 BB3_13
; SI-NEXT:  ; %bb.11: ; %for.body
; SI-NEXT:    s_and_b64 vcc, exec, 0
; SI-NEXT:  BB3_12: ; %self.loop
; SI-NEXT:    ; =>This Inner Loop Header: Depth=1
; SI-NEXT:    s_mov_b64 vcc, vcc
; SI-NEXT:    s_cbranch_vccz BB3_12
; SI-NEXT:  BB3_13: ; %DummyReturnBlock
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: loop_land_info_assert:
; FLAT:       ; %bb.0: ; %entry
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    buffer_load_dword v0, off, s[4:7], 0
; FLAT-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; FLAT-NEXT:    s_load_dword s14, s[0:1], 0x30
; FLAT-NEXT:    s_brev_b32 s8, 44
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_cmp_lt_i32_e64 s[0:1], s2, 1
; FLAT-NEXT:    v_cmp_lt_i32_e64 s[4:5], s3, 4
; FLAT-NEXT:    v_cmp_gt_i32_e64 s[2:3], s3, 3
; FLAT-NEXT:    s_and_b64 s[2:3], s[0:1], s[2:3]
; FLAT-NEXT:    s_and_b64 s[0:1], exec, s[4:5]
; FLAT-NEXT:    s_and_b64 s[2:3], exec, s[2:3]
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    v_cmp_lt_f32_e64 s[4:5], |v0|, s8
; FLAT-NEXT:    s_and_b64 s[4:5], exec, s[4:5]
; FLAT-NEXT:    v_mov_b32_e32 v0, 3
; FLAT-NEXT:    s_branch BB3_4
; FLAT-NEXT:  BB3_1: ; %Flow6
; FLAT-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; FLAT-NEXT:    s_mov_b64 s[8:9], 0
; FLAT-NEXT:  BB3_2: ; %Flow5
; FLAT-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; FLAT-NEXT:    s_mov_b64 s[12:13], 0
; FLAT-NEXT:  BB3_3: ; %Flow
; FLAT-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; FLAT-NEXT:    s_and_b64 vcc, exec, s[10:11]
; FLAT-NEXT:    s_cbranch_vccnz BB3_8
; FLAT-NEXT:  BB3_4: ; %while.cond
; FLAT-NEXT:    ; =>This Inner Loop Header: Depth=1
; FLAT-NEXT:    s_mov_b64 s[12:13], -1
; FLAT-NEXT:    s_mov_b64 s[8:9], -1
; FLAT-NEXT:    s_mov_b64 s[10:11], -1
; FLAT-NEXT:    s_mov_b64 vcc, s[0:1]
; FLAT-NEXT:    s_cbranch_vccz BB3_3
; FLAT-NEXT:  ; %bb.5: ; %convex.exit
; FLAT-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; FLAT-NEXT:    s_mov_b64 s[8:9], -1
; FLAT-NEXT:    s_mov_b64 s[10:11], -1
; FLAT-NEXT:    s_mov_b64 vcc, s[2:3]
; FLAT-NEXT:    s_cbranch_vccz BB3_2
; FLAT-NEXT:  ; %bb.6: ; %if.end
; FLAT-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; FLAT-NEXT:    s_mov_b64 s[10:11], -1
; FLAT-NEXT:    s_mov_b64 vcc, s[4:5]
; FLAT-NEXT:    s_cbranch_vccz BB3_1
; FLAT-NEXT:  ; %bb.7: ; %if.else
; FLAT-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; FLAT-NEXT:    s_mov_b64 s[10:11], 0
; FLAT-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    s_branch BB3_1
; FLAT-NEXT:  BB3_8: ; %loop.exit.guard4
; FLAT-NEXT:    ; in Loop: Header=BB3_4 Depth=1
; FLAT-NEXT:    s_and_b64 vcc, exec, s[8:9]
; FLAT-NEXT:    s_cbranch_vccz BB3_4
; FLAT-NEXT:  ; %bb.9: ; %loop.exit.guard
; FLAT-NEXT:    s_and_b64 vcc, exec, s[12:13]
; FLAT-NEXT:    s_cbranch_vccz BB3_13
; FLAT-NEXT:  ; %bb.10: ; %for.cond.preheader
; FLAT-NEXT:    s_cmpk_lt_i32 s14, 0x3e8
; FLAT-NEXT:    s_cbranch_scc0 BB3_13
; FLAT-NEXT:  ; %bb.11: ; %for.body
; FLAT-NEXT:    s_and_b64 vcc, exec, 0
; FLAT-NEXT:  BB3_12: ; %self.loop
; FLAT-NEXT:    ; =>This Inner Loop Header: Depth=1
; FLAT-NEXT:    s_mov_b64 vcc, vcc
; FLAT-NEXT:    s_cbranch_vccz BB3_12
; FLAT-NEXT:  BB3_13: ; %DummyReturnBlock
; FLAT-NEXT:    s_endpgm
entry:
  %cmp = icmp sgt i32 %c0, 0
  br label %while.cond.outer

while.cond.outer:
  %tmp = load float, float addrspace(1)* undef
  br label %while.cond

while.cond:
  %cmp1 = icmp slt i32 %c1, 4
  br i1 %cmp1, label %convex.exit, label %for.cond

convex.exit:
  %or = or i1 %cmp, %cmp1
  br i1 %or, label %return, label %if.end

if.end:
  %tmp3 = call float @llvm.fabs.f32(float %tmp) nounwind readnone
  %cmp2 = fcmp olt float %tmp3, 0x3E80000000000000
  br i1 %cmp2, label %if.else, label %while.cond.outer

if.else:
  store volatile i32 3, i32 addrspace(1)* undef, align 4
  br label %while.cond

for.cond:
  %cmp3 = icmp slt i32 %c3, 1000
  br i1 %cmp3, label %for.body, label %return

for.body:
  br i1 %cmp3, label %self.loop, label %if.end.2

if.end.2:
  %or.cond2 = or i1 %cmp3, %arg
  br i1 %or.cond2, label %return, label %for.cond

self.loop:
 br label %self.loop

return:
  ret void
}

declare i32 @llvm.amdgcn.mbcnt.lo(i32, i32) #0

attributes #0 = { nounwind readnone }
