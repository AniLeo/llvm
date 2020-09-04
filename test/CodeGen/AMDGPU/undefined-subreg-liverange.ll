; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck %s

; We may have subregister live ranges that are undefined on some paths. The
; verifier should not complain about this.

define amdgpu_kernel void @func() #0 {
; CHECK-LABEL: func:
; CHECK:       ; %bb.0: ; %B0
; CHECK-NEXT:    s_mov_b32 s0, 0
; CHECK-NEXT:    s_cbranch_scc1 BB0_2
; CHECK-NEXT:  ; %bb.1: ; %B30.1
; CHECK-NEXT:    s_mov_b32 s0, 0x7fc00000
; CHECK-NEXT:  BB0_2: ; %B30.2
; CHECK-NEXT:    v_mov_b32_e32 v0, s0
; CHECK-NEXT:    s_mov_b32 m0, -1
; CHECK-NEXT:    ds_write_b32 v0, v0
; CHECK-NEXT:    s_endpgm
B0:
  br i1 undef, label %B1, label %B2

B1:
  br label %B2

B2:
  %v0 = phi <4 x float> [ zeroinitializer, %B1 ], [ <float 0.0, float 0.0, float 0.0, float undef>, %B0 ]
  br i1 undef, label %B30.1, label %B30.2

B30.1:
  %sub = fsub <4 x float> %v0, undef
  br label %B30.2

B30.2:
  %v3 = phi <4 x float> [ %sub, %B30.1 ], [ %v0, %B2 ]
  %ve0 = extractelement <4 x float> %v3, i32 0
  store float %ve0, float addrspace(3)* undef, align 4
  ret void
}

; FIXME: Extra undef subregister copy should be removed before
; overwritten with defined copy
define amdgpu_ps float @valley_partially_undef_copy() #0 {
; CHECK-LABEL: valley_partially_undef_copy:
; CHECK:       ; %bb.0: ; %bb
; CHECK-NEXT:    s_mov_b32 s3, 0xf000
; CHECK-NEXT:    s_mov_b32 s2, -1
; CHECK-NEXT:    buffer_load_dword v1, off, s[0:3], 0
; CHECK-NEXT:    buffer_load_dword v0, off, s[0:3], 0
; CHECK-NEXT:    v_mov_b32_e32 v2, 0x7fc00000
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; CHECK-NEXT:    buffer_store_dword v2, off, s[0:3], 0
; CHECK-NEXT:    v_cmp_ne_u32_e64 s[0:1], 0, v1
; CHECK-NEXT:  BB1_1: ; %bb9
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    s_andn2_b64 vcc, exec, s[0:1]
; CHECK-NEXT:    s_cbranch_vccnz BB1_1
; CHECK-NEXT:  ; %bb.2: ; %bb11
; CHECK-NEXT:    s_mov_b32 s3, 0xf000
; CHECK-NEXT:    s_mov_b32 s2, -1
; CHECK-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; CHECK-NEXT:    ; return to shader part epilog
bb:
  %tmp = load volatile i32, i32 addrspace(1)* undef, align 4
  %tmp1 = load volatile i32, i32 addrspace(1)* undef, align 4
  %tmp2 = insertelement <4 x i32> undef, i32 %tmp1, i32 0
  %tmp3 = bitcast i32 %tmp1 to float
  %tmp4 = call <4 x float> @llvm.amdgcn.image.sample.2d.v4f32.f32(i32 15, float %tmp3, float %tmp3, <8 x i32> undef, <4 x i32> undef, i1 0, i32 0, i32 0)
  %tmp5 = extractelement <4 x float> %tmp4, i32 0
  %tmp6 = fmul float %tmp5, undef
  %tmp7 = fadd float %tmp6, %tmp6
  %tmp8 = insertelement <4 x i32> %tmp2, i32 %tmp, i32 1
  store <4 x i32> %tmp8, <4 x i32> addrspace(1)* undef, align 16
  store float %tmp7, float addrspace(1)* undef, align 4
  br label %bb9

bb9:                                              ; preds = %bb9, %bb
  %tmp10 = icmp eq i32 %tmp, 0
  br i1 %tmp10, label %bb9, label %bb11

bb11:                                             ; preds = %bb9
  store <4 x i32> %tmp2, <4 x i32> addrspace(1)* undef, align 16
  ret float undef
}

; FIXME: Should be able to remove the undef copies
define amdgpu_kernel void @partially_undef_copy() #0 {
; CHECK-LABEL: partially_undef_copy:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ;;#ASMSTART
; CHECK-NEXT:    v_mov_b32_e32 v5, 5
; CHECK-NEXT:    ;;#ASMEND
; CHECK-NEXT:    ;;#ASMSTART
; CHECK-NEXT:    v_mov_b32_e32 v6, 6
; CHECK-NEXT:    ;;#ASMEND
; CHECK-NEXT:    v_mov_b32_e32 v0, v5
; CHECK-NEXT:    v_mov_b32_e32 v1, v6
; CHECK-NEXT:    v_mov_b32_e32 v2, v7
; CHECK-NEXT:    v_mov_b32_e32 v3, v8
; CHECK-NEXT:    s_mov_b32 s3, 0xf000
; CHECK-NEXT:    s_mov_b32 s2, -1
; CHECK-NEXT:    v_mov_b32_e32 v0, v6
; CHECK-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; CHECK-NEXT:    ;;#ASMSTART
; CHECK-NEXT:    v_nop
; CHECK-NEXT:    ;;#ASMEND
; CHECK-NEXT:    s_endpgm
  %tmp0 = call i32 asm sideeffect "v_mov_b32_e32 v5, 5", "={v5}"()
  %tmp1 = call i32 asm sideeffect "v_mov_b32_e32 v6, 6", "={v6}"()

  %partially.undef.0 = insertelement <4 x i32> undef, i32 %tmp0, i32 0
  %partially.undef.1 = insertelement <4 x i32> %partially.undef.0, i32 %tmp1, i32 0

  store volatile <4 x i32> %partially.undef.1, <4 x i32> addrspace(1)* undef, align 16
  tail call void asm sideeffect "v_nop", "v={v[5:8]}"(<4 x i32> %partially.undef.0)
  ret void
}

declare <4 x float> @llvm.amdgcn.image.sample.2d.v4f32.f32(i32, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }
