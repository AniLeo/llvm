; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -amdgpu-fixed-function-abi -stop-after=irtranslator -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -verify-machineinstrs -o - %s | FileCheck -enable-var-scope %s

define amdgpu_kernel void @test_indirect_call_sgpr_ptr(void()* %fptr) {
  ; CHECK-LABEL: name: test_indirect_call_sgpr_ptr
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr14, $sgpr15, $sgpr16, $vgpr0, $vgpr1, $vgpr2, $sgpr4_sgpr5, $sgpr6_sgpr7, $sgpr8_sgpr9, $sgpr10_sgpr11
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vgpr_32(s32) = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32(s32) = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32(s32) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sgpr_32 = COPY $sgpr16
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sgpr_32 = COPY $sgpr15
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:sgpr_32 = COPY $sgpr14
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sgpr_64 = COPY $sgpr10_sgpr11
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:sgpr_64 = COPY $sgpr6_sgpr7
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:sgpr_64 = COPY $sgpr4_sgpr5
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:_(p4) = COPY $sgpr8_sgpr9
  ; CHECK-NEXT:   [[INT:%[0-9]+]]:_(p4) = G_INTRINSIC intrinsic(@llvm.amdgcn.kernarg.segment.ptr)
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:sreg_64(p0) = G_LOAD [[INT]](p4) :: (dereferenceable invariant load (p0) from %ir.fptr.kernarg.offset.cast, align 16, addrspace 4)
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:_(p4) = COPY [[COPY8]]
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:_(p4) = COPY [[COPY7]]
  ; CHECK-NEXT:   [[COPY12:%[0-9]+]]:_(p4) = COPY [[COPY9]](p4)
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 8
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p4) = G_PTR_ADD [[COPY12]], [[C]](s64)
  ; CHECK-NEXT:   [[COPY13:%[0-9]+]]:_(s64) = COPY [[COPY6]]
  ; CHECK-NEXT:   [[COPY14:%[0-9]+]]:_(s32) = COPY [[COPY5]]
  ; CHECK-NEXT:   [[COPY15:%[0-9]+]]:_(s32) = COPY [[COPY4]]
  ; CHECK-NEXT:   [[COPY16:%[0-9]+]]:_(s32) = COPY [[COPY3]]
  ; CHECK-NEXT:   [[COPY17:%[0-9]+]]:_(s32) = COPY [[COPY2]](s32)
  ; CHECK-NEXT:   [[COPY18:%[0-9]+]]:_(s32) = COPY [[COPY1]](s32)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 10
  ; CHECK-NEXT:   [[SHL:%[0-9]+]]:_(s32) = G_SHL [[COPY18]], [[C1]](s32)
  ; CHECK-NEXT:   [[OR:%[0-9]+]]:_(s32) = G_OR [[COPY17]], [[SHL]]
  ; CHECK-NEXT:   [[COPY19:%[0-9]+]]:_(s32) = COPY [[COPY]](s32)
  ; CHECK-NEXT:   [[C2:%[0-9]+]]:_(s32) = G_CONSTANT i32 20
  ; CHECK-NEXT:   [[SHL1:%[0-9]+]]:_(s32) = G_SHL [[COPY19]], [[C2]](s32)
  ; CHECK-NEXT:   [[OR1:%[0-9]+]]:_(s32) = G_OR [[OR]], [[SHL1]]
  ; CHECK-NEXT:   [[COPY20:%[0-9]+]]:_(<4 x s32>) = COPY $private_rsrc_reg
  ; CHECK-NEXT:   $sgpr0_sgpr1_sgpr2_sgpr3 = COPY [[COPY20]](<4 x s32>)
  ; CHECK-NEXT:   $sgpr4_sgpr5 = COPY [[COPY10]](p4)
  ; CHECK-NEXT:   $sgpr6_sgpr7 = COPY [[COPY11]](p4)
  ; CHECK-NEXT:   $sgpr8_sgpr9 = COPY [[PTR_ADD]](p4)
  ; CHECK-NEXT:   $sgpr10_sgpr11 = COPY [[COPY13]](s64)
  ; CHECK-NEXT:   $sgpr12 = COPY [[COPY14]](s32)
  ; CHECK-NEXT:   $sgpr13 = COPY [[COPY15]](s32)
  ; CHECK-NEXT:   $sgpr14 = COPY [[COPY16]](s32)
  ; CHECK-NEXT:   $vgpr31 = COPY [[OR1]](s32)
  ; CHECK-NEXT:   $sgpr30_sgpr31 = SI_CALL [[LOAD]](p0), 0, csr_amdgpu_highregs, implicit $sgpr0_sgpr1_sgpr2_sgpr3, implicit $sgpr4_sgpr5, implicit $sgpr6_sgpr7, implicit $sgpr8_sgpr9, implicit $sgpr10_sgpr11, implicit $sgpr12, implicit $sgpr13, implicit $sgpr14, implicit $vgpr31
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $scc
  ; CHECK-NEXT:   S_ENDPGM 0
  call void %fptr()
  ret void
}

define amdgpu_gfx void @test_gfx_indirect_call_sgpr_ptr(void()* %fptr) {
  ; CHECK-LABEL: name: test_gfx_indirect_call_sgpr_ptr
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK-NEXT:   [[MV:%[0-9]+]]:sreg_64(p0) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:_(<4 x s32>) = COPY $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   $sgpr0_sgpr1_sgpr2_sgpr3 = COPY [[COPY3]](<4 x s32>)
  ; CHECK-NEXT:   $sgpr30_sgpr31 = SI_CALL [[MV]](p0), 0, csr_amdgpu_highregs, implicit $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY4]]
  call amdgpu_gfx void %fptr()
  ret void
}
