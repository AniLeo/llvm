; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -stop-after=irtranslator -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -verify-machineinstrs -o - %s | FileCheck -enable-var-scope %s

; amdgpu_gfx calling convention
declare hidden amdgpu_gfx void @external_gfx_void_func_void() #0
declare hidden amdgpu_gfx void @external_gfx_void_func_i32(i32) #0
declare hidden amdgpu_gfx void @external_gfx_void_func_i32_inreg(i32 inreg) #0
declare hidden amdgpu_gfx void @external_gfx_void_func_struct_i8_i32({ i8, i32 }) #0
declare hidden amdgpu_gfx void @external_gfx_void_func_struct_i8_i32_inreg({ i8, i32 } inreg) #0

define amdgpu_gfx void @test_gfx_call_external_void_func_void() #0 {
  ; CHECK-LABEL: name: test_gfx_call_external_void_func_void
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @external_gfx_void_func_void
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(<4 x s32>) = COPY $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   $sgpr0_sgpr1_sgpr2_sgpr3 = COPY [[COPY]](<4 x s32>)
  ; CHECK-NEXT:   $sgpr30_sgpr31 = G_SI_CALL [[GV]](p0), @external_gfx_void_func_void, csr_amdgpu_si_gfx, implicit $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $scc
  ; CHECK-NEXT:   SI_RETURN
  call amdgpu_gfx void @external_gfx_void_func_void()
  ret void
}

define amdgpu_gfx void @test_gfx_call_external_void_func_i32_imm(i32) #0 {
  ; CHECK-LABEL: name: test_gfx_call_external_void_func_i32_imm
  ; CHECK: bb.1 (%ir-block.1):
  ; CHECK-NEXT:   liveins: $vgpr0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @external_gfx_void_func_i32
  ; CHECK-NEXT:   $vgpr0 = COPY [[C]](s32)
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(<4 x s32>) = COPY $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   $sgpr0_sgpr1_sgpr2_sgpr3 = COPY [[COPY1]](<4 x s32>)
  ; CHECK-NEXT:   $sgpr30_sgpr31 = G_SI_CALL [[GV]](p0), @external_gfx_void_func_i32, csr_amdgpu_si_gfx, implicit $vgpr0, implicit $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $scc
  ; CHECK-NEXT:   SI_RETURN
  call amdgpu_gfx void @external_gfx_void_func_i32(i32 42)
  ret void
}

define amdgpu_gfx void @test_gfx_call_external_void_func_i32_imm_inreg(i32 inreg) #0 {
  ; CHECK-LABEL: name: test_gfx_call_external_void_func_i32_imm_inreg
  ; CHECK: bb.1 (%ir-block.1):
  ; CHECK-NEXT:   liveins: $sgpr4
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @external_gfx_void_func_i32_inreg
  ; CHECK-NEXT:   $sgpr4 = COPY [[C]](s32)
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(<4 x s32>) = COPY $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   $sgpr0_sgpr1_sgpr2_sgpr3 = COPY [[COPY1]](<4 x s32>)
  ; CHECK-NEXT:   $sgpr30_sgpr31 = G_SI_CALL [[GV]](p0), @external_gfx_void_func_i32_inreg, csr_amdgpu_si_gfx, implicit $sgpr4, implicit $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $scc
  ; CHECK-NEXT:   SI_RETURN
  call amdgpu_gfx void @external_gfx_void_func_i32_inreg(i32 inreg 42)
  ret void
}

define amdgpu_gfx void @test_gfx_call_external_void_func_struct_i8_i32() #0 {
  ; CHECK-LABEL: name: test_gfx_call_external_void_func_struct_i8_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   [[DEF:%[0-9]+]]:_(p4) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(p1) = G_LOAD [[DEF]](p4) :: (load (p1) from `{ i8, i32 } addrspace(1)* addrspace(4)* undef`, addrspace 4)
  ; CHECK-NEXT:   [[LOAD1:%[0-9]+]]:_(s8) = G_LOAD [[LOAD]](p1) :: (load (s8) from %ir.ptr0, align 4, addrspace 1)
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p1) = G_PTR_ADD [[LOAD]], [[C]](s64)
  ; CHECK-NEXT:   [[LOAD2:%[0-9]+]]:_(s32) = G_LOAD [[PTR_ADD]](p1) :: (load (s32) from %ir.ptr0 + 4, addrspace 1)
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @external_gfx_void_func_struct_i8_i32
  ; CHECK-NEXT:   [[ANYEXT:%[0-9]+]]:_(s16) = G_ANYEXT [[LOAD1]](s8)
  ; CHECK-NEXT:   [[ANYEXT1:%[0-9]+]]:_(s32) = G_ANYEXT [[ANYEXT]](s16)
  ; CHECK-NEXT:   $vgpr0 = COPY [[ANYEXT1]](s32)
  ; CHECK-NEXT:   $vgpr1 = COPY [[LOAD2]](s32)
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(<4 x s32>) = COPY $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   $sgpr0_sgpr1_sgpr2_sgpr3 = COPY [[COPY]](<4 x s32>)
  ; CHECK-NEXT:   $sgpr30_sgpr31 = G_SI_CALL [[GV]](p0), @external_gfx_void_func_struct_i8_i32, csr_amdgpu_si_gfx, implicit $vgpr0, implicit $vgpr1, implicit $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $scc
  ; CHECK-NEXT:   SI_RETURN
  %ptr0 = load { i8, i32 } addrspace(1)*, { i8, i32 } addrspace(1)* addrspace(4)* undef
  %val = load { i8, i32 }, { i8, i32 } addrspace(1)* %ptr0
  call amdgpu_gfx void @external_gfx_void_func_struct_i8_i32({ i8, i32 } %val)
  ret void
}

define amdgpu_gfx void @test_gfx_call_external_void_func_struct_i8_i32_inreg() #0 {
  ; CHECK-LABEL: name: test_gfx_call_external_void_func_struct_i8_i32_inreg
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   [[DEF:%[0-9]+]]:_(p4) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(p1) = G_LOAD [[DEF]](p4) :: (load (p1) from `{ i8, i32 } addrspace(1)* addrspace(4)* undef`, addrspace 4)
  ; CHECK-NEXT:   [[LOAD1:%[0-9]+]]:_(s8) = G_LOAD [[LOAD]](p1) :: (load (s8) from %ir.ptr0, align 4, addrspace 1)
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p1) = G_PTR_ADD [[LOAD]], [[C]](s64)
  ; CHECK-NEXT:   [[LOAD2:%[0-9]+]]:_(s32) = G_LOAD [[PTR_ADD]](p1) :: (load (s32) from %ir.ptr0 + 4, addrspace 1)
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $scc
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @external_gfx_void_func_struct_i8_i32_inreg
  ; CHECK-NEXT:   [[ANYEXT:%[0-9]+]]:_(s16) = G_ANYEXT [[LOAD1]](s8)
  ; CHECK-NEXT:   [[ANYEXT1:%[0-9]+]]:_(s32) = G_ANYEXT [[ANYEXT]](s16)
  ; CHECK-NEXT:   $sgpr4 = COPY [[ANYEXT1]](s32)
  ; CHECK-NEXT:   $sgpr5 = COPY [[LOAD2]](s32)
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(<4 x s32>) = COPY $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   $sgpr0_sgpr1_sgpr2_sgpr3 = COPY [[COPY]](<4 x s32>)
  ; CHECK-NEXT:   $sgpr30_sgpr31 = G_SI_CALL [[GV]](p0), @external_gfx_void_func_struct_i8_i32_inreg, csr_amdgpu_si_gfx, implicit $sgpr4, implicit $sgpr5, implicit $sgpr0_sgpr1_sgpr2_sgpr3
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $scc
  ; CHECK-NEXT:   SI_RETURN
  %ptr0 = load { i8, i32 } addrspace(1)*, { i8, i32 } addrspace(1)* addrspace(4)* undef
  %val = load { i8, i32 }, { i8, i32 } addrspace(1)* %ptr0
  call amdgpu_gfx void @external_gfx_void_func_struct_i8_i32_inreg({ i8, i32 } inreg %val)
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind noinline }
