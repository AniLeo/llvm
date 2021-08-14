; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx908 -O0 -global-isel -stop-after=irtranslator -verify-machineinstrs -o - %s | FileCheck %s

define amdgpu_kernel void @asm_convergent() convergent{
  ; CHECK-LABEL: name: asm_convergent
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   INLINEASM &s_barrier, 33 /* sideeffect isconvergent attdialect */, !0
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "s_barrier", ""() convergent, !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_memory_clobber() {
  ; CHECK-LABEL: name: asm_simple_memory_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   INLINEASM &"", 25 /* sideeffect mayload maystore attdialect */, !0
  ; CHECK-NEXT:   INLINEASM &"", 1 /* sideeffect attdialect */, !0
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "", "~{memory}"(), !srcloc !0
  call void asm sideeffect "", ""(), !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_vgpr_clobber() {
  ; CHECK-LABEL: name: asm_simple_vgpr_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 v0, 7", 1 /* sideeffect attdialect */, 12 /* clobber */, implicit-def early-clobber $vgpr0, !0
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "v_mov_b32 v0, 7", "~{v0}"(), !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_sgpr_clobber() {
  ; CHECK-LABEL: name: asm_simple_sgpr_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   INLINEASM &"s_mov_b32 s0, 7", 1 /* sideeffect attdialect */, 12 /* clobber */, implicit-def early-clobber $sgpr0, !0
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "s_mov_b32 s0, 7", "~{s0}"(), !srcloc !0
  ret void
}

define amdgpu_kernel void @asm_simple_agpr_clobber() {
  ; CHECK-LABEL: name: asm_simple_agpr_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   INLINEASM &"; def a0", 1 /* sideeffect attdialect */, 12 /* clobber */, implicit-def early-clobber $agpr0, !0
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "; def a0", "~{a0}"(), !srcloc !0
  ret void
}

define i32 @asm_vgpr_early_clobber() {
  ; CHECK-LABEL: name: asm_vgpr_early_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 $0, 7; v_mov_b32 $1, 7", 1 /* sideeffect attdialect */, 1835019 /* regdef-ec:VGPR_32 */, def early-clobber %8, 1835019 /* regdef-ec:VGPR_32 */, def early-clobber %9, !0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY %8
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY %9
  ; CHECK-NEXT:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY1]], [[COPY2]]
  ; CHECK-NEXT:   $vgpr0 = COPY [[ADD]](s32)
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  call { i32, i32 } asm sideeffect "v_mov_b32 $0, 7; v_mov_b32 $1, 7", "=&v,=&v"(), !srcloc !0
  %asmresult = extractvalue { i32, i32 } %1, 0
  %asmresult1 = extractvalue { i32, i32 } %1, 1
  %add = add i32 %asmresult, %asmresult1
  ret i32 %add
}

define i32 @test_specific_vgpr_output() nounwind {
  ; CHECK-LABEL: name: test_specific_vgpr_output
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 v1, 7", 0 /* attdialect */, 10 /* regdef */, implicit-def $vgpr1
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY1]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
entry:
  %0 = tail call i32 asm "v_mov_b32 v1, 7", "={v1}"() nounwind
  ret i32 %0
}

define i32 @test_single_vgpr_output() nounwind {
  ; CHECK-LABEL: name: test_single_vgpr_output
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 $0, 7", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %8
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY %8
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY1]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
entry:
  %0 = tail call i32 asm "v_mov_b32 $0, 7", "=v"() nounwind
  ret i32 %0
}

define i32 @test_single_sgpr_output_s32() nounwind {
  ; CHECK-LABEL: name: test_single_sgpr_output_s32
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"s_mov_b32 $0, 7", 0 /* attdialect */, 1966090 /* regdef:SReg_32 */, def %8
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY %8
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY1]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
entry:
  %0 = tail call i32 asm "s_mov_b32 $0, 7", "=s"() nounwind
  ret i32 %0
}

; Check support for returning several floats
define float @test_multiple_register_outputs_same() #0 {
  ; CHECK-LABEL: name: test_multiple_register_outputs_same
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 $0, 0; v_mov_b32 $1, 1", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %8, 1835018 /* regdef:VGPR_32 */, def %9
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY %8
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY %9
  ; CHECK-NEXT:   [[FADD:%[0-9]+]]:_(s32) = G_FADD [[COPY1]], [[COPY2]]
  ; CHECK-NEXT:   $vgpr0 = COPY [[FADD]](s32)
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %1 = call { float, float } asm "v_mov_b32 $0, 0; v_mov_b32 $1, 1", "=v,=v"()
  %asmresult = extractvalue { float, float } %1, 0
  %asmresult1 = extractvalue { float, float } %1, 1
  %add = fadd float %asmresult, %asmresult1
  ret float %add
}

; Check support for returning several floats
define double @test_multiple_register_outputs_mixed() #0 {
  ; CHECK-LABEL: name: test_multiple_register_outputs_mixed
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 $0, 0; v_add_f64 $1, 0, 0", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %8, 2949130 /* regdef:VReg_64 */, def %9
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY %8
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(s64) = COPY %9
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[COPY2]](s64)
  ; CHECK-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0, implicit $vgpr1
  %1 = call { float, double } asm "v_mov_b32 $0, 0; v_add_f64 $1, 0, 0", "=v,=v"()
  %asmresult = extractvalue { float, double } %1, 1
  ret double %asmresult
}


define float @test_vector_output() nounwind {
  ; CHECK-LABEL: name: test_vector_output
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 0
  ; CHECK-NEXT:   INLINEASM &"v_add_f64 $0, 0, 0", 1 /* sideeffect attdialect */, 10 /* regdef */, implicit-def $vgpr14_vgpr15
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(<2 x s32>) = COPY $vgpr14_vgpr15
  ; CHECK-NEXT:   [[EVEC:%[0-9]+]]:_(s32) = G_EXTRACT_VECTOR_ELT [[COPY1]](<2 x s32>), [[C]](s32)
  ; CHECK-NEXT:   $vgpr0 = COPY [[EVEC]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
  %1 = tail call <2 x float> asm sideeffect "v_add_f64 $0, 0, 0", "={v[14:15]}"() nounwind
  %2 = extractelement <2 x float> %1, i32 0
  ret float %2
}

define amdgpu_kernel void @test_input_vgpr_imm() {
  ; CHECK-LABEL: name: test_input_vgpr_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY [[C]](s32)
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 v0, $0", 1 /* sideeffect attdialect */, 1835017 /* reguse:VGPR_32 */, [[COPY]]
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "v_mov_b32 v0, $0", "v"(i32 42)
  ret void
}

define amdgpu_kernel void @test_input_sgpr_imm() {
  ; CHECK-LABEL: name: test_input_sgpr_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY [[C]](s32)
  ; CHECK-NEXT:   INLINEASM &"s_mov_b32 s0, $0", 1 /* sideeffect attdialect */, 1966089 /* reguse:SReg_32 */, [[COPY]]
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "s_mov_b32 s0, $0", "s"(i32 42)
  ret void
}

define amdgpu_kernel void @test_input_imm() {
  ; CHECK-LABEL: name: test_input_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   INLINEASM &"s_mov_b32 s0, $0", 9 /* sideeffect mayload attdialect */, 13 /* imm */, 42
  ; CHECK-NEXT:   INLINEASM &"s_mov_b64 s[0:1], $0", 9 /* sideeffect mayload attdialect */, 13 /* imm */, 42
  ; CHECK-NEXT:   S_ENDPGM 0
  call void asm sideeffect "s_mov_b32 s0, $0", "i"(i32 42)
  call void asm sideeffect "s_mov_b64 s[0:1], $0", "i"(i64 42)
  ret void
}

define float @test_input_vgpr(i32 %src) nounwind {
  ; CHECK-LABEL: name: test_input_vgpr
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[COPY]](s32)
  ; CHECK-NEXT:   INLINEASM &"v_add_f32 $0, 1.0, $1", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %9, 1835017 /* reguse:VGPR_32 */, [[COPY2]]
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY %9
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY3]](s32)
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
entry:
  %0 = tail call float asm "v_add_f32 $0, 1.0, $1", "=v,v"(i32 %src) nounwind
  ret float %0
}

define i32 @test_memory_constraint(i32 addrspace(3)* %a) nounwind {
  ; CHECK-LABEL: name: test_memory_constraint
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"ds_read_b32 $0, $1", 8 /* mayload attdialect */, 1835018 /* regdef:VGPR_32 */, def %9, 196622 /* mem:m */, [[COPY]](p3)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY %9
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY2]](s32)
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %1 = tail call i32 asm "ds_read_b32 $0, $1", "=v,*m"(i32 addrspace(3)* %a)
  ret i32 %1
}

define i32 @test_vgpr_matching_constraint(i32 %a) nounwind {
  ; CHECK-LABEL: name: test_vgpr_matching_constraint
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 1
  ; CHECK-NEXT:   [[AND:%[0-9]+]]:_(s32) = G_AND [[COPY]], [[C]]
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[AND]](s32)
  ; CHECK-NEXT:   INLINEASM &";", 1 /* sideeffect attdialect */, 1835018 /* regdef:VGPR_32 */, def %11, 2147483657 /* reguse tiedto:$0 */, [[COPY2]](tied-def 3)
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY %11
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY3]](s32)
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
  %and = and i32 %a, 1
  %asm = call i32 asm sideeffect ";", "=v,0"(i32 %and)
  ret i32 %asm
}

define i32 @test_sgpr_matching_constraint() nounwind {
  ; CHECK-LABEL: name: test_sgpr_matching_constraint
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"s_mov_b32 $0, 7", 0 /* attdialect */, 1966090 /* regdef:SReg_32 */, def %8
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY %8
  ; CHECK-NEXT:   INLINEASM &"s_mov_b32 $0, 8", 0 /* attdialect */, 1966090 /* regdef:SReg_32 */, def %10
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY %10
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY [[COPY1]](s32)
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY [[COPY2]](s32)
  ; CHECK-NEXT:   INLINEASM &"s_add_u32 $0, $1, $2", 0 /* attdialect */, 1966090 /* regdef:SReg_32 */, def %12, 1966089 /* reguse:SReg_32 */, [[COPY3]], 2147483657 /* reguse tiedto:$0 */, [[COPY4]](tied-def 3)
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY %12
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY5]](s32)
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY6]], implicit $vgpr0
entry:
  %asm0 = tail call i32 asm "s_mov_b32 $0, 7", "=s"() nounwind
  %asm1 = tail call i32 asm "s_mov_b32 $0, 8", "=s"() nounwind
  %asm2 = tail call i32 asm "s_add_u32 $0, $1, $2", "=s,s,0"(i32 %asm0, i32 %asm1) nounwind
  ret i32 %asm2
}

define void @test_many_matching_constraints(i32 %a, i32 %b, i32 %c) nounwind {
  ; CHECK-LABEL: name: test_many_matching_constraints
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $vgpr0, $vgpr1, $vgpr2, $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[DEF:%[0-9]+]]:_(p1) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY [[COPY2]](s32)
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[COPY]](s32)
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[COPY1]](s32)
  ; CHECK-NEXT:   INLINEASM &"; ", 1 /* sideeffect attdialect */, 1835018 /* regdef:VGPR_32 */, def %11, 1835018 /* regdef:VGPR_32 */, def %12, 1835018 /* regdef:VGPR_32 */, def %13, 2147483657 /* reguse tiedto:$0 */, [[COPY4]](tied-def 3), 2147614729 /* reguse tiedto:$2 */, [[COPY5]](tied-def 7), 2147549193 /* reguse tiedto:$1 */, [[COPY6]](tied-def 5)
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY %11
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY %12
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY %13
  ; CHECK-NEXT:   G_STORE [[COPY7]](s32), [[DEF]](p1) :: (store (s32) into `i32 addrspace(1)* undef`, addrspace 1)
  ; CHECK-NEXT:   G_STORE [[COPY8]](s32), [[DEF]](p1) :: (store (s32) into `i32 addrspace(1)* undef`, addrspace 1)
  ; CHECK-NEXT:   G_STORE [[COPY9]](s32), [[DEF]](p1) :: (store (s32) into `i32 addrspace(1)* undef`, addrspace 1)
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY10]]
  %asm = call {i32, i32, i32} asm sideeffect "; ", "=v,=v,=v,0,2,1"(i32 %c, i32 %a, i32 %b)
  %asmresult0 = extractvalue  {i32, i32, i32} %asm, 0
  store i32 %asmresult0, i32 addrspace(1)* undef
  %asmresult1 = extractvalue  {i32, i32, i32} %asm, 1
  store i32 %asmresult1, i32 addrspace(1)* undef
  %asmresult2 = extractvalue  {i32, i32, i32} %asm, 2
  store i32 %asmresult2, i32 addrspace(1)* undef
  ret void
}

define i32 @test_sgpr_to_vgpr_move_matching_constraint() nounwind {
  ; CHECK-LABEL: name: test_sgpr_to_vgpr_move_matching_constraint
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   INLINEASM &"s_mov_b32 $0, 7", 0 /* attdialect */, 1966090 /* regdef:SReg_32 */, def %8
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY %8
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[COPY1]](s32)
  ; CHECK-NEXT:   INLINEASM &"v_mov_b32 $0, $1", 0 /* attdialect */, 1835018 /* regdef:VGPR_32 */, def %10, 2147483657 /* reguse tiedto:$0 */, [[COPY2]](tied-def 3)
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY %10
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY3]](s32)
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
entry:
  %asm0 = tail call i32 asm "s_mov_b32 $0, 7", "=s"() nounwind
  %asm1 = tail call i32 asm "v_mov_b32 $0, $1", "=v,0"(i32 %asm0) nounwind
  ret i32 %asm1
}

define amdgpu_kernel void @asm_constraint_n_n()  {
  ; CHECK-LABEL: name: asm_constraint_n_n
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   INLINEASM &"s_trap ${0:n}", 1 /* sideeffect attdialect */, 13 /* imm */, 10
  ; CHECK-NEXT:   S_ENDPGM 0
  tail call void asm sideeffect "s_trap ${0:n}", "n"(i32 10) #1
  ret void
}

!0 = !{i32 70}
